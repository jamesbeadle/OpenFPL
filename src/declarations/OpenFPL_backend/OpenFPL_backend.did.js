export const idlFactory = ({ IDL }) => {
  const List = IDL.Rec();
  const List_1 = IDL.Rec();
  const List_2 = IDL.Rec();
  const AccountBalanceDTO = IDL.Record({
    'icpBalance' : IDL.Nat64,
    'fplBalance' : IDL.Nat64,
  });
  const TeamId = IDL.Nat16;
  const SeasonId = IDL.Nat16;
  const FixtureId = IDL.Nat32;
  const PlayerEventData = IDL.Record({
    'fixtureId' : FixtureId,
    'playerId' : IDL.Nat16,
    'eventStartMinute' : IDL.Nat8,
    'eventEndMinute' : IDL.Nat8,
    'teamId' : TeamId,
    'eventType' : IDL.Nat8,
  });
  List.fill(IDL.Opt(IDL.Tuple(PlayerEventData, List)));
  const GameweekNumber = IDL.Nat8;
  const Fixture = IDL.Record({
    'id' : IDL.Nat32,
    'status' : IDL.Nat8,
    'awayTeamId' : TeamId,
    'highestScoringPlayerId' : IDL.Nat16,
    'homeTeamId' : TeamId,
    'seasonId' : SeasonId,
    'events' : List,
    'kickOff' : IDL.Int,
    'homeGoals' : IDL.Nat8,
    'gameweek' : GameweekNumber,
    'awayGoals' : IDL.Nat8,
  });
  List_2.fill(IDL.Opt(IDL.Tuple(Fixture, List_2)));
  const Gameweek = IDL.Record({
    'number' : GameweekNumber,
    'fixtures' : List_2,
    'canisterId' : IDL.Text,
  });
  List_1.fill(IDL.Opt(IDL.Tuple(Gameweek, List_1)));
  const Season = IDL.Record({
    'id' : IDL.Nat16,
    'postponedFixtures' : List_2,
    'name' : IDL.Text,
    'year' : IDL.Nat16,
    'gameweeks' : List_1,
  });
  const PlayerId = IDL.Nat16;
  const FantasyTeam = IDL.Record({
    'playerIds' : IDL.Vec(PlayerId),
    'goalGetterPlayerId' : PlayerId,
    'hatTrickHeroGameweek' : GameweekNumber,
    'transfersAvailable' : IDL.Nat8,
    'teamBoostGameweek' : GameweekNumber,
    'captainFantasticGameweek' : GameweekNumber,
    'teamBoostTeamId' : TeamId,
    'noEntryPlayerId' : PlayerId,
    'safeHandsPlayerId' : PlayerId,
    'braceBonusGameweek' : GameweekNumber,
    'passMasterGameweek' : GameweekNumber,
    'goalGetterGameweek' : GameweekNumber,
    'bankBalance' : IDL.Float64,
    'captainFantasticPlayerId' : PlayerId,
    'noEntryGameweek' : GameweekNumber,
    'safeHandsGameweek' : GameweekNumber,
    'principalId' : IDL.Text,
    'passMasterPlayerId' : PlayerId,
    'captainId' : PlayerId,
  });
  const FantasyTeamSnapshot = IDL.Record({
    'playerIds' : IDL.Vec(PlayerId),
    'goalGetterPlayerId' : PlayerId,
    'hatTrickHeroGameweek' : GameweekNumber,
    'transfersAvailable' : IDL.Nat8,
    'teamBoostGameweek' : GameweekNumber,
    'captainFantasticGameweek' : GameweekNumber,
    'teamBoostTeamId' : TeamId,
    'noEntryPlayerId' : PlayerId,
    'safeHandsPlayerId' : PlayerId,
    'braceBonusGameweek' : GameweekNumber,
    'passMasterGameweek' : GameweekNumber,
    'goalGetterGameweek' : GameweekNumber,
    'bankBalance' : IDL.Float64,
    'captainFantasticPlayerId' : PlayerId,
    'gameweek' : GameweekNumber,
    'noEntryGameweek' : GameweekNumber,
    'safeHandsGameweek' : GameweekNumber,
    'principalId' : IDL.Text,
    'passMasterPlayerId' : PlayerId,
    'captainId' : IDL.Nat16,
    'points' : IDL.Int16,
  });
  const PlayerPointsDTO = IDL.Record({
    'id' : IDL.Nat16,
    'events' : IDL.Vec(PlayerEventData),
    'teamId' : IDL.Nat16,
    'position' : IDL.Nat8,
    'gameweek' : GameweekNumber,
    'points' : IDL.Int16,
  });
  const ProfileDTO = IDL.Record({
    'icpDepositAddress' : IDL.Vec(IDL.Nat8),
    'favouriteTeamId' : IDL.Nat16,
    'displayName' : IDL.Text,
    'fplDepositAddress' : IDL.Vec(IDL.Nat8),
    'createDate' : IDL.Int,
    'reputation' : IDL.Nat32,
    'principalName' : IDL.Text,
    'profilePicture' : IDL.Vec(IDL.Nat8),
    'membershipType' : IDL.Nat8,
  });
  const LeaderboardEntry = IDL.Record({
    'username' : IDL.Text,
    'positionText' : IDL.Text,
    'position' : IDL.Int,
    'principalId' : IDL.Text,
    'points' : IDL.Int16,
  });
  const PaginatedLeaderboard = IDL.Record({
    'totalEntries' : IDL.Nat,
    'seasonId' : SeasonId,
    'entries' : IDL.Vec(LeaderboardEntry),
    'gameweek' : GameweekNumber,
  });
  const Team = IDL.Record({
    'id' : IDL.Nat16,
    'secondaryColourHex' : IDL.Text,
    'name' : IDL.Text,
    'friendlyName' : IDL.Text,
    'abbreviatedName' : IDL.Text,
    'primaryColourHex' : IDL.Text,
  });
  const Error = IDL.Variant({
    'DecodeError' : IDL.Null,
    'NotAllowed' : IDL.Null,
    'NotFound' : IDL.Null,
    'NotAuthorized' : IDL.Null,
    'AlreadyExists' : IDL.Null,
    'InvalidTeamError' : IDL.Null,
  });
  const Result = IDL.Variant({ 'ok' : IDL.Null, 'err' : Error });
  return IDL.Service({
    'getAccountBalanceDTO' : IDL.Func([], [AccountBalanceDTO], []),
    'getActiveGameweekFixtures' : IDL.Func([], [IDL.Vec(Fixture)], ['query']),
    'getCurrentGameweek' : IDL.Func([], [IDL.Nat8], []),
    'getCurrentSeason' : IDL.Func([], [Season], []),
    'getFantasyTeam' : IDL.Func([], [FantasyTeam], ['query']),
    'getFantasyTeamForGameweek' : IDL.Func(
        [IDL.Text, IDL.Nat16, IDL.Nat8],
        [FantasyTeamSnapshot],
        [],
      ),
    'getFixture' : IDL.Func(
        [SeasonId, GameweekNumber, FixtureId],
        [Fixture],
        [],
      ),
    'getFixtures' : IDL.Func([], [IDL.Vec(Fixture)], ['query']),
    'getFixturesByWeek' : IDL.Func(
        [SeasonId, GameweekNumber],
        [IDL.Vec(Fixture)],
        [],
      ),
    'getFixturesForSeason' : IDL.Func(
        [SeasonId],
        [IDL.Vec(Fixture)],
        ['query'],
      ),
    'getPlayersDetailsForGameweek' : IDL.Func(
        [IDL.Vec(PlayerId), IDL.Nat16, IDL.Nat8],
        [IDL.Vec(PlayerPointsDTO)],
        [],
      ),
    'getProfileDTO' : IDL.Func([], [ProfileDTO], []),
    'getPublicProfileDTO' : IDL.Func([IDL.Text], [ProfileDTO], []),
    'getSeasonLeaderboard' : IDL.Func(
        [IDL.Nat16, IDL.Nat, IDL.Nat],
        [PaginatedLeaderboard],
        ['query'],
      ),
    'getSeasonTop10' : IDL.Func([], [PaginatedLeaderboard], ['query']),
    'getSeasons' : IDL.Func([], [IDL.Vec(Season)], ['query']),
    'getTeams' : IDL.Func([], [IDL.Vec(Team)], ['query']),
    'getTotalManagers' : IDL.Func([], [IDL.Nat], ['query']),
    'getValidatableFixtures' : IDL.Func([], [IDL.Vec(Fixture)], ['query']),
    'getWeeklyLeaderboard' : IDL.Func(
        [IDL.Nat16, IDL.Nat8, IDL.Nat, IDL.Nat],
        [PaginatedLeaderboard],
        ['query'],
      ),
    'getWeeklyTop10' : IDL.Func([], [PaginatedLeaderboard], ['query']),
    'isDisplayNameValid' : IDL.Func([IDL.Text], [IDL.Bool], ['query']),
    'saveFantasyTeam' : IDL.Func(
        [IDL.Vec(IDL.Nat16), IDL.Nat16, IDL.Nat8, IDL.Nat16, IDL.Nat16],
        [Result],
        [],
      ),
    'savePlayerEvents' : IDL.Func(
        [FixtureId, IDL.Vec(PlayerEventData)],
        [],
        [],
      ),
    'updateDisplayName' : IDL.Func([IDL.Text], [Result], []),
    'updateFavouriteTeam' : IDL.Func([IDL.Nat16], [Result], []),
    'updateProfilePicture' : IDL.Func([IDL.Vec(IDL.Nat8)], [Result], []),
    'withdrawICP' : IDL.Func([IDL.Float64, IDL.Text], [Result], []),
  });
};
export const init = ({ IDL }) => { return []; };
