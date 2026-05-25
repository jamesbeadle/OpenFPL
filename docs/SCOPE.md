# OpenFPL — Project Scope

## Purpose

OpenFPL is a free fantasy Premier League game. Users pick an 11-player squad within a £100M budget, score points based on real-world player performance, and compete on weekly, monthly, and season leaderboards — plus optional private leagues with friends.

OpenFPL is a pure consumer of FootballGod data. It does not scrape, store, or judge football facts itself — it reacts to canonical data via the FootballGod API and webhooks.

## Roles

- **Visitor** — anyone browsing the public site without logging in
- **Manager** — a logged-in user who has created a fantasy team
- **League Admin** — a Manager who has created a private league
- **Admin** — me, managing the system via the admin panel
- **System** — the automated scoring and leaderboard engine reacting to FootballGod events

## Stack

SvelteKit + Tailwind frontend, Supabase (Postgres + Auth + Edge Functions + Cron) backend, Vercel hosting, Google login for managers, FootballGod API for all football data.

## Core Domain Model (revealed by the UI)

- **Manager** — a user with a team name and profile, linked to their Google identity
- **Season** — the active Premier League season as defined by FootballGod
- **Gameweek** — a numbered round within the season, with deadline, kickoff window, and status
- **FantasyTeam** — a Manager's 11-player squad for a Gameweek, with captain, bank balance, and bonuses-used markers
- **TeamSnapshot** — the locked state of a FantasyTeam at the Gameweek deadline (immutable record of what was played)
- **GameweekScore** — points earned by a TeamSnapshot once the gameweek is settled
- **Leaderboard** — a ranking of GameweekScores, scoped to Weekly, Monthly, or Season, and globally or per-League
- **PrivateLeague** — a group of Managers competing on a separate leaderboard
- **LeagueInvite** — a code or link granting entry to a PrivateLeague
- **BonusPlay** — record that a specific bonus was used in a specific gameweek by a Manager

## Rules of the Game (lifted and confirmed from the original codebase)

### Team

- 11 players per team
- £100M budget, tracked in quarter-millions internally for precision
- Formation: exactly 1 Goalkeeper, 3–5 Defenders, 3–5 Midfielders, 1–3 Forwards
- Maximum 2 players from any single Premier League club
- A captain must be designated (scores 2x points)
- Team is locked at the Gameweek deadline; the snapshot at that moment is what scores

### Transfers

- **3 transfers per gameweek** (no excess-transfer point penalty — over-cap transfers are simply blocked)
- Unused transfers do not carry over

### Base Player Points

Awarded for real-world events, irrespective of bonuses:

| Event | Goalkeeper | Defender | Midfielder | Forward |
|---|---|---|---|---|
| Appearance | +5 | +5 | +5 | +5 |
| Goal | +20 | +20 | +15 | +10 |
| Assist | +15 | +15 | +10 | +10 |
| Clean sheet | +10 | +10 | — | — |
| Every 3 saves | +5 | — | — | — |
| Penalty saved | +20 | — | — | — |
| Every 2 goals conceded | -15 | -15 | — | — |
| Yellow card | -5 | -5 | -5 | -5 |
| Red card | -20 | -20 | -20 | -20 |
| Penalty missed | -10 | -10 | -10 | -10 |
| Own goal | -10 | -10 | -10 | -10 |
| Highest scorer in fixture | +25 | +25 | +25 | +25 |

The "highest scorer in fixture" award is granted to the player with the highest total base points within their fixture, after all other base events are tallied. It is awarded per fixture, not per gameweek — a player can earn it multiple times if they are the top scorer in multiple matches in the same gameweek (e.g. during double-gameweeks, should those exist in future).

### Captain

- Captain's total score (base + any bonus effects) is multiplied by ×2

### Bonuses

10 bonuses exist. Each can be used **at most once per season**, with an additional cap of **2 bonuses per month**. One bonus per gameweek maximum.

| Bonus | Effect |
|---|---|
| **GoalGetter** | Chosen player earns extra goal points: +40 (GK/DEF), +30 (MID), +20 (FWD) per goal, on top of base goal points |
| **PassMaster** | Chosen player earns extra assist points: +30 (GK/DEF), +20 (MID/FWD) per assist, on top of base assist points |
| **NoEntry** | Each eligible GK/DEF in the team who keeps a clean sheet has their total ×3 |
| **TeamBoost** | All players from a chosen club have their total ×2 |
| **SafeHands** | If the team's goalkeeper makes more than 4 saves, their total ×3 |
| **CaptainFantastic** | If the captain scores a goal, their total ×2 (stacks with the standard captain ×2, so effectively ×4) |
| **Prospects** | All players under 21 have their total ×2 |
| **OneNation** | All players of a chosen nationality have their total ×2 |
| **BraceBonus** | Any player who scores 2+ goals has their total ×2 |
| **HatTrickHero** | Any player who scores 3+ goals has their total ×3 |

---

# Epics & User Stories

## Epic FPL-A: Account & Identity

### FPL-001 — Sign in with Google

**As** a Visitor,
**I want** to sign in with my Google account,
**so that** I can become a Manager and play.

**Acceptance Criteria:**
- Given the sign-in screen, when I authenticate with Google, then I am logged in and redirected to my dashboard.
- Given a first-time sign-in, when authentication succeeds, then I am prompted to choose a team name before continuing.

### FPL-002 — Set or change team name

**As** a Manager,
**I want** to set a unique team name,
**so that** I am identifiable on leaderboards.

**Acceptance Criteria:**
- Given a name input, when I submit a name that is unused and meets length/character rules, then the name is saved.
- Given a name that is already taken, when I submit, then I see a clear error and remain on the form.
- Given an existing team name, when I edit and save, then leaderboards reflect the new name on next render.

### FPL-003 — Sign out

**As** a Manager,
**I want** to sign out,
**so that** my account is not accessible from a shared device.

**Acceptance Criteria:**
- Given I am signed in, when I click sign out, then my session ends and I am returned to the public site.

---

## Epic FPL-B: Team Selection

### FPL-004 — Browse the player pool

**As** a Manager,
**I want** to browse all Premier League players with their position, club, price, and form,
**so that** I can decide who to pick.

**Acceptance Criteria:**
- Given the player browser, when it loads, then I see every player from FootballGod with current price and position.
- Given the browser, when I filter by position, club, or price range, then the list updates immediately.
- Given the browser, when I sort by form or total points, then the list reorders.

### FPL-005 — Pick a starting 11

**As** a Manager,
**I want** to select 11 players within budget and formation rules,
**so that** I can compete.

**Acceptance Criteria:**
- Given an empty squad, when I add players, then the bank balance, formation counts, and per-club counts update live.
- Given I attempt to add an invalid player (e.g. a 3rd from one club, or one that exceeds budget), then the action is rejected with a clear reason.
- Given my squad is incomplete or invalid, when I try to save, then save is blocked with a list of what's wrong.
- Given a valid 11, when I save, then the team is persisted for the upcoming gameweek.

### FPL-006 — Designate a captain

**As** a Manager,
**I want** to choose one player as captain,
**so that** they score double points.

**Acceptance Criteria:**
- Given a saved squad, when I select a captain, then that selection is shown clearly on the team view.
- Given I try to save without a captain, then save is blocked with a clear error.

### FPL-007 — Make transfers between gameweeks

**As** a Manager,
**I want** to swap players in and out of my squad before the deadline,
**so that** I can adapt to form, fixtures, and injuries.

**Acceptance Criteria:**
- Given I have a fresh gameweek, when it begins, then I have 3 transfers available.
- Given I have transfers available, when I swap one player for another that fits budget and rules, then the change is staged and the available count decrements.
- Given I have used all 3 transfers, when I attempt another, then the action is blocked with a clear message (no excess-transfer point penalty in V1 — the cap is hard).
- Given I save my staged changes before the deadline, then they become the active squad for the next gameweek.
- Given the new gameweek starts, when transfers reset, then I have 3 available again (no carryover).

### FPL-008 — See the team deadline

**As** a Manager,
**I want** to clearly see the next gameweek's deadline,
**so that** I know when my team locks.

**Acceptance Criteria:**
- Given my dashboard, when I view it, then the next deadline is displayed with a live countdown.
- Given the deadline passes, when the countdown reaches zero, then the team is locked automatically and the dashboard reflects this.

---

## Epic FPL-C: Bonuses

### FPL-009 — View available bonuses

**As** a Manager,
**I want** to see which of my 10 bonuses I have used, which are still available, and how many I can still play this month,
**so that** I can plan when to use them.

**Acceptance Criteria:**
- Given the bonuses view, when I open it, then I see all 10 bonuses with `used` or `available` status, and for used ones, which gameweek and month they were played in.
- Given the bonuses view, when I open it, then I see a count of how many of my 2 monthly bonus uses are remaining for the current month.

### FPL-010 — Play a bonus for a gameweek

**As** a Manager,
**I want** to activate one bonus before the deadline,
**so that** it applies when my team scores this gameweek.

**Acceptance Criteria:**
- Given the bonuses view and a not-yet-locked gameweek, when I activate a bonus I have not used and have monthly capacity for, then it is staged for this gameweek.
- Given I have already used that bonus this season, when I attempt to activate it again, then the action is blocked.
- Given I have already used 2 bonuses this calendar month, when I attempt a third, then the action is blocked with a message explaining the monthly cap.
- Given I have already activated a different bonus for this gameweek, when I try to activate another, then I am prompted to confirm the swap (only one bonus per gameweek).
- Given a bonus requires a target (GoalGetter and PassMaster need a player; TeamBoost a club; OneNation a nationality), when I activate it, then I must select the target before staging is allowed.
- Given the deadline passes with a bonus active, when the gameweek scores, then the bonus rules apply to my score.

### FPL-011 — Cancel a bonus before the deadline

**As** a Manager,
**I want** to deactivate a bonus I have staged but not yet locked in,
**so that** I can change my mind.

**Acceptance Criteria:**
- Given a bonus is staged for the upcoming gameweek and the deadline has not passed, when I deactivate it, then it is returned to available.
- Given the deadline has passed, when I try to deactivate, then the action is blocked.

---

## Epic FPL-D: Scoring (Autonomous Reaction to FootballGod)

OpenFPL reads FootballGod's canonical data, stores its own copy of what it needs, and recomputes Manager scores from that copy. Reactions are triggered by FootballGod webhooks where possible, but the System also reconciles on a schedule so a dropped webhook never leaves a Manager with a wrong score. Every operation is idempotent: applying the same event or the same finalisation twice produces the same result.

### FPL-012 — React to fixture-event webhooks during live play

**As** the System,
**I want** to ingest events as FootballGod publishes them and update OpenFPL's local copy of the fixture state,
**so that** provisional scores can be calculated from up-to-date data without polling.

**Acceptance Criteria:**
- Given a `fixture.event` webhook from FootballGod, when received, then the event is upserted into OpenFPL's local store keyed by FootballGod's event id (so duplicate deliveries do not double-count).
- Given a webhook for an already-stored event with the same content, when received, then no change occurs and the System logs the duplicate.
- Given a webhook for an event that contradicts a stored version (e.g. a corrected assist), when received, then the stored version is replaced and any affected Manager scores are recomputed.

### FPL-013 — React to fixture-finalised webhook

**As** the System,
**I want** to mark a fixture as finalised when FootballGod confirms it,
**so that** scoring for that fixture transitions from provisional to settled.

**Acceptance Criteria:**
- Given a `fixture.finalised` webhook for a fixture, when received, then the fixture's local status moves to `Finalised` and the finalisation timestamp is recorded.
- Given the same webhook is delivered twice, when processed the second time, then no state changes and the duplicate is logged.
- Given every fixture in a gameweek has been finalised, when the last one settles, then the gameweek's leaderboard transitions from `Active` to `Settled` and all GameweekScores are marked final.

### FPL-014 — React to disallowed-event webhook

**As** the System,
**I want** to retract a previously-applied event when FootballGod marks it disallowed,
**so that** scores reflect the corrected canonical state.

**Acceptance Criteria:**
- Given an `event.disallowed` webhook, when received, then the event is flagged disallowed in OpenFPL's local store and excluded from score calculation.
- Given the affected Managers' scores have already been calculated (provisional or settled), when the event is retracted, then their scores are recomputed and the leaderboard re-renders.

### FPL-015 — Scheduled reconciliation against FootballGod

**As** the System,
**I want** to compare OpenFPL's local fixture state against FootballGod on a schedule,
**so that** any missed webhook is detected and corrected without a Manager ever seeing a stale score.

**Acceptance Criteria:**
- Given a configured reconciliation interval (frequent during live fixtures, infrequent otherwise), when the schedule runs, then OpenFPL fetches the current fixture and event state from FootballGod for every fixture whose local status is not `Finalised`.
- Given any difference between local and FootballGod state, when detected, then the local copy is updated to match and affected Manager scores are recomputed.
- Given there is no difference, when reconciliation completes, then nothing is written and a heartbeat is logged.
- Given a webhook was missed entirely, when the next reconciliation runs, then the resulting state is identical to what would have happened had the webhook arrived.

### FPL-016 — Idempotent score calculation

**As** the System,
**I want** Manager score calculation to be a pure function of (locked TeamSnapshot, active bonus, current local event state),
**so that** running it any number of times produces the same result and triggering it is always safe.

**Acceptance Criteria:**
- Given the same inputs, when the calculation runs twice, then both runs produce the same GameweekScore.
- Given any change to the local event state for a fixture relevant to a Manager's snapshot, when calculation is triggered, then the Manager's GameweekScore is overwritten with the new value (not added to or merged with the previous one).
- Given a Manager has no players in any finalised fixture yet, when calculation runs, then their GameweekScore is 0 with a status indicating no fixtures have completed.

### FPL-017 — Apply bonuses during score calculation

**As** the System,
**I want** to apply a Manager's active bonus during scoring,
**so that** the score reflects the bonus rules defined in the Rules section.

**Acceptance Criteria:**
- Given a Manager played a specific bonus for a gameweek, when scoring runs, then the bonus's rule is applied to their score per the bonus table.
- Given a bonus requires a target (player, club, or nationality) and the target was set at lock-in, when scoring runs, then the stored target is used (never the Manager's current selection).

### FPL-018 — Show live provisional scores publicly

**As** a Visitor or Manager,
**I want** to see provisional scores update during live gameweeks without logging in,
**so that** anyone can follow the action.

**Acceptance Criteria:**
- Given fixtures are live, when I view a team, gameweek, or leaderboard, then I see provisional scores clearly labelled as such.
- Given scores update due to a webhook or reconciliation, when I am on a live view, then I see the change within a short delay (target: under 30 seconds).
- Given a gameweek transitions from `Active` to `Settled`, when I view it, then provisional labels are removed and scores are shown as final.

### FPL-019 — Score from a locked snapshot, not the live team

**As** the System,
**I want** to score the team as it was at the deadline, not as it is now,
**so that** post-deadline edits cannot retroactively change historical results.

**Acceptance Criteria:**
- Given a Manager's team was locked at the deadline (TeamSnapshot persisted), when the gameweek is scored at any time after, then the TeamSnapshot is the basis for scoring — never the current team.
- Given a Manager edits their team after a deadline (for a future gameweek), when historical scores are recomputed for reconciliation, then the historical TeamSnapshot is used and the historical score is unaffected.

---

## Epic FPL-E: Leaderboards

### FPL-020 — View the global weekly leaderboard

**As** a Manager,
**I want** to see the global ranking of all Managers for a specific gameweek,
**so that** I know where I stand.

**Acceptance Criteria:**
- Given a settled gameweek, when I open the weekly leaderboard, then I see ranked Managers by GameweekScore with my row highlighted.
- Given the leaderboard is paginated, when I scroll or page, then I can browse all entries.
- Given the gameweek is still active, when I open the leaderboard, then it shows provisional rankings labelled as such.

### FPL-021 — View the global monthly leaderboard

**As** a Manager,
**I want** to see monthly rankings,
**so that** I can compete over a longer horizon.

**Acceptance Criteria:**
- Given a month with at least one settled gameweek, when I open the monthly leaderboard, then it shows Managers ranked by the sum of their settled GameweekScores within that month.
- Given a month is in progress, when I view it, then it includes provisional scores from any live gameweek.

### FPL-022 — View the global season leaderboard

**As** a Manager,
**I want** to see the season-wide ranking,
**so that** I can see the overall best Manager.

**Acceptance Criteria:**
- Given the season has begun, when I open the season leaderboard, then it shows every Manager ranked by total points across all settled gameweeks.

### FPL-023 — See historical leaderboards

**As** a Manager,
**I want** to look back at previous gameweeks' and months' leaderboards,
**so that** I can review past performance.

**Acceptance Criteria:**
- Given any settled gameweek or month in the season, when I navigate to it, then the leaderboard is shown exactly as it was when settled.

---

## Epic FPL-F: Private Leagues

### FPL-024 — Create a private league

**As** a Manager,
**I want** to create a private league with a name at any point during the season,
**so that** I can compete with a specific group from that moment.

**Acceptance Criteria:**
- Given the leagues view, when I create a league with a valid name, then I become the League Admin and receive a shareable invite code.
- Given I create a league mid-season, when its leaderboards are rendered, then my full existing season scores are included from gameweek 1 onward.

### FPL-025 — Join a private league

**As** a Manager,
**I want** to join a private league using an invite code at any point in the season,
**so that** I can compete with the people who invited me from that moment on.

**Acceptance Criteria:**
- Given a valid invite code, when I submit it, then I join the league immediately.
- Given I have just joined a league, when its weekly, monthly, or season leaderboards are rendered, then my full existing scores for the current season are included from the first gameweek onward, even if I joined on the final gameweek.
- Given an invalid or revoked code, when I submit it, then I see a clear error.

### FPL-026 — View a private league leaderboard

**As** a member of a private league,
**I want** to see weekly, monthly, and season leaderboards scoped to my league,
**so that** I can track how I'm doing among friends.

**Acceptance Criteria:**
- Given I am in a private league, when I open it, then I see weekly, monthly, and season leaderboards containing only members of that league.

### FPL-027 — Leave a private league

**As** a Manager,
**I want** to leave a private league,
**so that** I am no longer ranked in it.

**Acceptance Criteria:**
- Given I am in a league, when I leave, then I no longer appear on its leaderboards going forward (historical settled standings are preserved).

### FPL-028 — Manage a private league

**As** a League Admin,
**I want** to rename my league, regenerate the invite code, and remove members,
**so that** I can keep the league running cleanly.

**Acceptance Criteria:**
- Given I created the league, when I edit its name, regenerate the code, or remove a member, then the change takes effect immediately.
- Given I am not the League Admin, when I view a league, then admin controls are not visible.

---

## Epic FPL-G: Manager Profile & History

### FPL-029 — View my team history

**As** a Manager,
**I want** to see every gameweek's locked team and score,
**so that** I can review my decisions and performance.

**Acceptance Criteria:**
- Given the history view, when I open it, then I see each settled gameweek with my TeamSnapshot, captain, active bonus (if any), and final score.

### FPL-030 — View another Manager's settled team

**As** a Manager,
**I want** to view other Managers' settled team snapshots,
**so that** I can learn from the top of the leaderboard.

**Acceptance Criteria:**
- Given a settled gameweek and a Manager listed on the leaderboard, when I open their entry, then I see their snapshot for that gameweek.
- Given a gameweek is still active, when I try to view another Manager's team, then the team is hidden until settled (no peeking before lock).

---

## Epic FPL-H: Admin Panel

### FPL-031 — Admin authentication

**As** an Admin,
**I want** to sign in to the admin panel with Google,
**so that** only authorised admins can manage the system.

**Acceptance Criteria:**
- Given the admin login, when I sign in, then I gain access only if my email is on the admin allowlist (same mechanism as FootballGod).

### FPL-032 — View system health

**As** an Admin,
**I want** a dashboard showing the next deadline, last settled gameweek, count of active managers, and recent webhook deliveries from FootballGod,
**so that** I can monitor that the autonomous system is working.

**Acceptance Criteria:**
- Given the admin dashboard, when I open it, then the listed metrics are shown with their current values.

### FPL-033 — Manually re-settle a gameweek

**As** an Admin,
**I want** to trigger re-settlement of a gameweek,
**so that** corrected canonical data from FootballGod is applied retroactively.

**Acceptance Criteria:**
- Given a settled gameweek, when I trigger re-settlement, then every GameweekScore for that gameweek is recalculated from the latest canonical FootballGod data and leaderboards update.
- Given re-settlement runs, when it completes, then an audit log entry records who triggered it, when, and the diff (managers whose scores changed).

### FPL-034 — Moderate team names

**As** an Admin,
**I want** to flag and reset offensive team names,
**so that** the leaderboard remains usable.

**Acceptance Criteria:**
- Given a Manager's team name, when I mark it as inappropriate, then the name is reset to a default placeholder and the Manager is prompted to choose a new name on next login.

---

## Out of Scope for V1

- Cash prizes, real-money entry, gambling, NFTs, tokens
- Cup-style knockout competitions
- Wildcards / Free Hits (could be added later — for V1, the 10 bonuses above are the full set)
- Mobile native apps (responsive web only)
- Push notifications (email-only if anything)
- Cross-season carryover of teams or stats
- Social features beyond private leagues (no chat, no comments, no friends list)

## Decisions Made (informed by the original codebase and product direction)

- **Mid-season league join.** Anyone can create or join a private league at any point during the season. Joining or creating a league mid-season retroactively includes the Manager's full season scores from gameweek 1.
- **Public live scoring.** Live provisional scores are visible to anyone, logged in or not. OpenFPL stores its own copy of relevant FootballGod data and does not expose FootballGod's underlying API publicly.
- **No email notifications.** Google login is the only contact channel. The app does not send emails or push notifications in V1.
- **Highest-scorer-in-fixture (+25) is retained.** It is a base scoring rule that affects fantasy team totals and leaderboards, so it remains in scope.
- **No excess-transfer penalty.** The 3-transfer-per-gameweek cap is a hard limit; exceeding it is blocked rather than allowed at a points cost.
- **Idempotent, self-healing scoring.** OpenFPL reacts to FootballGod webhooks but also reconciles on a schedule, so a missed webhook never leaves a Manager with a wrong score.

## Open Questions

None remain that block scope finalisation. Implementation-level questions (e.g. reconciliation cadence, exact webhook signing scheme) will surface naturally during build.

## Dependencies on FootballGod

OpenFPL cannot function without FootballGod. Specifically, it requires these FootballGod capabilities to be live first:

- FG-011 (fixtures by gameweek)
- FG-012 (events by fixture)
- FG-013 (player roster)
- FG-014 (clubs)
- FG-015 + FG-016 (fixture-finalised webhook)
- FG-008 (disallowed-event handling, surfaced via webhook so live scores adjust)
