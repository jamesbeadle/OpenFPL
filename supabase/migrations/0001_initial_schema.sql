-- ============================================================================
-- OpenFPL — initial schema
-- ============================================================================
-- This migration creates every entity in the V1 scope:
--   identity     : profiles, admin_allowlist, reserved_team_names
--   FG mirror    : clubs, players, seasons, gameweeks, fixtures, fixture_events
--   fantasy      : fantasy_teams (+ players), team_snapshots (+ players),
--                  bonus_plays, gameweek_scores
--   leagues      : private_leagues, league_memberships
--   operations   : audit_log, webhook_deliveries
--
-- Money is tracked in *quarter-millions* (one unit = £0.25M) for precision.
-- All FootballGod-sourced entities use FootballGod's id directly as the PK
-- so reconciliation never needs a lookup table.
-- ============================================================================

-- ---------- extensions ----------
create extension if not exists "pgcrypto" with schema public;

-- ---------- enums ----------
create type player_position as enum ('GK', 'DEF', 'MID', 'FWD');

create type gameweek_status as enum ('Upcoming', 'Active', 'Settled');

create type fixture_status as enum ('Scheduled', 'Live', 'Finalised');

create type bonus_type as enum (
	'GoalGetter',
	'PassMaster',
	'NoEntry',
	'TeamBoost',
	'SafeHands',
	'CaptainFantastic',
	'Prospects',
	'OneNation',
	'BraceBonus',
	'HatTrickHero'
);

create type fixture_event_type as enum (
	'Appearance',
	'Goal',
	'Assist',
	'CleanSheet',
	'Saves',                  -- count stored in `value`
	'PenaltySaved',
	'GoalsConceded',          -- count stored in `value`
	'YellowCard',
	'RedCard',
	'PenaltyMissed',
	'OwnGoal',
	'HighestScorerInFixture'
);

-- ============================================================================
-- IDENTITY
-- ============================================================================

create table profiles (
	id uuid primary key references auth.users(id) on delete cascade,
	team_name text not null,
	display_name text,
	created_at timestamptz not null default now(),
	updated_at timestamptz not null default now(),
	-- Team-name uniqueness is case-insensitive.
	constraint profiles_team_name_length check (char_length(team_name) between 3 and 32)
);

create unique index profiles_team_name_lower_idx on profiles (lower(team_name));

create table admin_allowlist (
	email text primary key,
	added_at timestamptz not null default now(),
	added_by uuid references auth.users(id)
);

create table reserved_team_names (
	name_lower text primary key,
	reason text,
	added_at timestamptz not null default now()
);

-- ============================================================================
-- FOOTBALLGOD MIRROR
-- ============================================================================

create table seasons (
	id text primary key,                 -- e.g. '2025-26'
	name text not null,
	start_date date not null,
	end_date date not null,
	is_current boolean not null default false,
	footballgod_id text unique,
	created_at timestamptz not null default now()
);

create unique index seasons_one_current_idx on seasons (is_current) where is_current;

create table gameweeks (
	id uuid primary key default gen_random_uuid(),
	season_id text not null references seasons(id) on delete cascade,
	number int not null,
	deadline timestamptz not null,
	kickoff_window_start timestamptz,
	kickoff_window_end timestamptz,
	status gameweek_status not null default 'Upcoming',
	settled_at timestamptz,
	footballgod_id text unique,
	created_at timestamptz not null default now(),
	constraint gameweeks_unique_per_season unique (season_id, number)
);

create index gameweeks_status_idx on gameweeks (status);
create index gameweeks_deadline_idx on gameweeks (deadline);

create table clubs (
	id text primary key,                 -- FootballGod id
	name text not null,
	short_name text,
	primary_color text,
	updated_at timestamptz not null default now()
);

create table players (
	id text primary key,                 -- FootballGod id
	first_name text,
	last_name text,
	display_name text not null,
	position player_position not null,
	club_id text references clubs(id) on delete set null,
	nationality text,
	date_of_birth date,
	price_quarter_millions int not null,   -- units of £0.25M (e.g. 200 = £50.00M)
	form numeric(4, 1) not null default 0,
	total_points int not null default 0,
	updated_at timestamptz not null default now(),
	constraint players_price_positive check (price_quarter_millions > 0)
);

create index players_position_idx on players (position);
create index players_club_idx on players (club_id);

create table fixtures (
	id text primary key,                 -- FootballGod id
	gameweek_id uuid not null references gameweeks(id) on delete cascade,
	home_club_id text not null references clubs(id),
	away_club_id text not null references clubs(id),
	kickoff timestamptz not null,
	status fixture_status not null default 'Scheduled',
	home_score int,
	away_score int,
	finalised_at timestamptz,
	updated_at timestamptz not null default now(),
	constraint fixtures_distinct_clubs check (home_club_id <> away_club_id)
);

create index fixtures_gameweek_idx on fixtures (gameweek_id);
create index fixtures_status_idx on fixtures (status);

create table fixture_events (
	id text primary key,                 -- FootballGod event id (idempotency key)
	fixture_id text not null references fixtures(id) on delete cascade,
	player_id text references players(id) on delete set null,
	event_type fixture_event_type not null,
	value int,                           -- e.g. saves count, conceded count
	minute int,
	disallowed boolean not null default false,
	updated_at timestamptz not null default now()
);

create index fixture_events_fixture_idx on fixture_events (fixture_id);
create index fixture_events_player_idx on fixture_events (player_id);

-- ============================================================================
-- FANTASY STATE (editable: pre-deadline)
-- ============================================================================

create table fantasy_teams (
	id uuid primary key default gen_random_uuid(),
	manager_id uuid not null references profiles(id) on delete cascade,
	gameweek_id uuid not null references gameweeks(id) on delete cascade,
	captain_player_id text references players(id),
	bank_quarter_millions int not null,
	transfers_made int not null default 0,
	updated_at timestamptz not null default now(),
	constraint fantasy_teams_unique_per_gw unique (manager_id, gameweek_id),
	constraint fantasy_teams_bank_nonneg check (bank_quarter_millions >= 0),
	constraint fantasy_teams_transfers_cap check (transfers_made between 0 and 3)
);

create index fantasy_teams_manager_idx on fantasy_teams (manager_id);

create table fantasy_team_players (
	fantasy_team_id uuid not null references fantasy_teams(id) on delete cascade,
	player_id text not null references players(id),
	primary key (fantasy_team_id, player_id)
);

-- ============================================================================
-- FANTASY STATE (immutable: locked at deadline)
-- ============================================================================

create table team_snapshots (
	id uuid primary key default gen_random_uuid(),
	manager_id uuid not null references profiles(id) on delete cascade,
	gameweek_id uuid not null references gameweeks(id) on delete cascade,
	captain_player_id text not null references players(id),
	locked_at timestamptz not null default now(),
	constraint team_snapshots_unique_per_gw unique (manager_id, gameweek_id)
);

create index team_snapshots_gameweek_idx on team_snapshots (gameweek_id);

create table team_snapshot_players (
	team_snapshot_id uuid not null references team_snapshots(id) on delete cascade,
	player_id text not null references players(id),
	price_quarter_millions int not null,  -- price at the moment of lock
	primary key (team_snapshot_id, player_id)
);

-- One bonus per gameweek per manager, one of each bonus type per season per manager.
create table bonus_plays (
	id uuid primary key default gen_random_uuid(),
	manager_id uuid not null references profiles(id) on delete cascade,
	gameweek_id uuid not null references gameweeks(id) on delete cascade,
	season_id text not null references seasons(id) on delete cascade,
	bonus bonus_type not null,
	target_player_id text references players(id),
	target_club_id text references clubs(id),
	target_nationality text,
	played_at timestamptz not null default now(),
	constraint bonus_plays_unique_per_gw unique (manager_id, gameweek_id),
	constraint bonus_plays_unique_per_season unique (manager_id, season_id, bonus)
);

create index bonus_plays_manager_played_idx on bonus_plays (manager_id, played_at);

create table gameweek_scores (
	id uuid primary key default gen_random_uuid(),
	team_snapshot_id uuid not null references team_snapshots(id) on delete cascade,
	manager_id uuid not null references profiles(id) on delete cascade,
	gameweek_id uuid not null references gameweeks(id) on delete cascade,
	total_points int not null default 0,
	is_provisional boolean not null default true,
	calculated_at timestamptz not null default now(),
	constraint gameweek_scores_unique unique (manager_id, gameweek_id)
);

create index gameweek_scores_gw_total_idx on gameweek_scores (gameweek_id, total_points desc);
create index gameweek_scores_manager_idx on gameweek_scores (manager_id);

-- ============================================================================
-- LEAGUES
-- ============================================================================

create table private_leagues (
	id uuid primary key default gen_random_uuid(),
	admin_id uuid not null references profiles(id) on delete restrict,
	name text not null,
	invite_code text not null unique,
	created_at timestamptz not null default now(),
	constraint private_leagues_name_length check (char_length(name) between 3 and 64)
);

create index private_leagues_admin_idx on private_leagues (admin_id);

create table league_memberships (
	league_id uuid not null references private_leagues(id) on delete cascade,
	manager_id uuid not null references profiles(id) on delete cascade,
	joined_at timestamptz not null default now(),
	primary key (league_id, manager_id)
);

create index league_memberships_manager_idx on league_memberships (manager_id);

-- ============================================================================
-- OPERATIONS
-- ============================================================================

create table audit_log (
	id uuid primary key default gen_random_uuid(),
	actor_id uuid references auth.users(id) on delete set null,
	action text not null,
	details jsonb not null default '{}'::jsonb,
	created_at timestamptz not null default now()
);

create index audit_log_action_idx on audit_log (action);
create index audit_log_created_idx on audit_log (created_at desc);

create table webhook_deliveries (
	id uuid primary key default gen_random_uuid(),
	source text not null,                -- e.g. 'footballgod'
	event_type text not null,            -- e.g. 'fixture.event', 'fixture.finalised'
	payload jsonb not null,
	signature text,
	status text not null,                -- 'received', 'processed', 'failed', 'duplicate'
	error text,
	received_at timestamptz not null default now(),
	processed_at timestamptz
);

create index webhook_deliveries_received_idx on webhook_deliveries (received_at desc);
create index webhook_deliveries_status_idx on webhook_deliveries (status);

-- ============================================================================
-- HELPERS
-- ============================================================================

-- Is the current request from an admin?
create or replace function public.is_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
	select exists (
		select 1
		from public.admin_allowlist a
		join auth.users u on u.email = a.email
		where u.id = auth.uid()
	);
$$;

-- Updated_at trigger
create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
	new.updated_at = now();
	return new;
end;
$$;

create trigger profiles_set_updated_at
	before update on profiles
	for each row execute function public.set_updated_at();

create trigger fantasy_teams_set_updated_at
	before update on fantasy_teams
	for each row execute function public.set_updated_at();

create trigger players_set_updated_at
	before update on players
	for each row execute function public.set_updated_at();

create trigger clubs_set_updated_at
	before update on clubs
	for each row execute function public.set_updated_at();

create trigger fixtures_set_updated_at
	before update on fixtures
	for each row execute function public.set_updated_at();

create trigger fixture_events_set_updated_at
	before update on fixture_events
	for each row execute function public.set_updated_at();

-- ============================================================================
-- ROW LEVEL SECURITY
-- ============================================================================
-- Public-read tables (anyone can SELECT, mutations restricted to admins/service-role).
-- User-owned tables: row owner can SELECT/INSERT/UPDATE/DELETE own rows.

alter table profiles enable row level security;
alter table admin_allowlist enable row level security;
alter table reserved_team_names enable row level security;
alter table seasons enable row level security;
alter table gameweeks enable row level security;
alter table clubs enable row level security;
alter table players enable row level security;
alter table fixtures enable row level security;
alter table fixture_events enable row level security;
alter table fantasy_teams enable row level security;
alter table fantasy_team_players enable row level security;
alter table team_snapshots enable row level security;
alter table team_snapshot_players enable row level security;
alter table bonus_plays enable row level security;
alter table gameweek_scores enable row level security;
alter table private_leagues enable row level security;
alter table league_memberships enable row level security;
alter table audit_log enable row level security;
alter table webhook_deliveries enable row level security;

-- ---------- profiles ----------
create policy profiles_select_all on profiles
	for select using (true);

create policy profiles_insert_self on profiles
	for insert with check (auth.uid() = id);

create policy profiles_update_self on profiles
	for update using (auth.uid() = id);

create policy profiles_admin_update on profiles
	for update using (public.is_admin());

-- ---------- admin_allowlist, reserved_team_names ----------
create policy admin_allowlist_admin_only on admin_allowlist
	for all using (public.is_admin()) with check (public.is_admin());

create policy reserved_names_admin_write on reserved_team_names
	for all using (public.is_admin()) with check (public.is_admin());

create policy reserved_names_public_read on reserved_team_names
	for select using (true);

-- ---------- public-read mirror tables ----------
create policy seasons_read on seasons for select using (true);
create policy seasons_admin_write on seasons for all using (public.is_admin()) with check (public.is_admin());

create policy gameweeks_read on gameweeks for select using (true);
create policy gameweeks_admin_write on gameweeks for all using (public.is_admin()) with check (public.is_admin());

create policy clubs_read on clubs for select using (true);
create policy clubs_admin_write on clubs for all using (public.is_admin()) with check (public.is_admin());

create policy players_read on players for select using (true);
create policy players_admin_write on players for all using (public.is_admin()) with check (public.is_admin());

create policy fixtures_read on fixtures for select using (true);
create policy fixtures_admin_write on fixtures for all using (public.is_admin()) with check (public.is_admin());

create policy fixture_events_read on fixture_events for select using (true);
create policy fixture_events_admin_write on fixture_events for all using (public.is_admin()) with check (public.is_admin());

-- ---------- fantasy_teams + players (owner-only) ----------
create policy fantasy_teams_owner on fantasy_teams
	for all using (auth.uid() = manager_id) with check (auth.uid() = manager_id);

create policy fantasy_team_players_owner on fantasy_team_players
	for all using (
		exists (
			select 1 from fantasy_teams ft
			where ft.id = fantasy_team_id and ft.manager_id = auth.uid()
		)
	) with check (
		exists (
			select 1 from fantasy_teams ft
			where ft.id = fantasy_team_id and ft.manager_id = auth.uid()
		)
	);

-- ---------- team_snapshots (read: owner OR settled gameweek; write: service role) ----------
create policy team_snapshots_read on team_snapshots
	for select using (
		auth.uid() = manager_id
		or exists (
			select 1 from gameweeks gw
			where gw.id = gameweek_id and gw.status = 'Settled'
		)
	);

create policy team_snapshot_players_read on team_snapshot_players
	for select using (
		exists (
			select 1 from team_snapshots ts
			where ts.id = team_snapshot_id
			and (
				auth.uid() = ts.manager_id
				or exists (
					select 1 from gameweeks gw
					where gw.id = ts.gameweek_id and gw.status = 'Settled'
				)
			)
		)
	);

-- ---------- bonus_plays (owner-only) ----------
create policy bonus_plays_owner on bonus_plays
	for all using (auth.uid() = manager_id) with check (auth.uid() = manager_id);

-- ---------- gameweek_scores (public read for leaderboards) ----------
create policy gameweek_scores_read on gameweek_scores
	for select using (true);

-- ---------- private_leagues ----------
create policy private_leagues_member_read on private_leagues
	for select using (
		auth.uid() = admin_id
		or exists (
			select 1 from league_memberships lm
			where lm.league_id = id and lm.manager_id = auth.uid()
		)
	);

create policy private_leagues_admin_create on private_leagues
	for insert with check (auth.uid() = admin_id);

create policy private_leagues_admin_update on private_leagues
	for update using (auth.uid() = admin_id) with check (auth.uid() = admin_id);

create policy private_leagues_admin_delete on private_leagues
	for delete using (auth.uid() = admin_id);

create policy league_memberships_read on league_memberships
	for select using (
		auth.uid() = manager_id
		or exists (
			select 1 from private_leagues pl
			where pl.id = league_id and pl.admin_id = auth.uid()
		)
	);

create policy league_memberships_self_insert on league_memberships
	for insert with check (auth.uid() = manager_id);

create policy league_memberships_self_delete on league_memberships
	for delete using (
		auth.uid() = manager_id
		or exists (
			select 1 from private_leagues pl
			where pl.id = league_id and pl.admin_id = auth.uid()
		)
	);

-- ---------- audit_log / webhook_deliveries (admin read only; service role writes) ----------
create policy audit_log_admin_read on audit_log
	for select using (public.is_admin());

create policy webhook_deliveries_admin_read on webhook_deliveries
	for select using (public.is_admin());
