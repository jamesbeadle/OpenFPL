export const idlFactory = ({ IDL }) => {
  const List = IDL.Rec();
  const List_1 = IDL.Rec();
  const List_2 = IDL.Rec();
  const List_3 = IDL.Rec();
  const List_4 = IDL.Rec();
  const AccountBalanceDTO = IDL.Record({
    'icpBalance' : IDL.Nat64,
    'fplBalance' : IDL.Nat64,
  });
  const ProfileDTO = IDL.Record({
    'icpDepositAddress' : IDL.Vec(IDL.Nat8),
    'favouriteTeamId' : IDL.Nat16,
    'displayName' : IDL.Text,
    'fplDepositAddress' : IDL.Vec(IDL.Nat8),
    'createDate' : IDL.Int,
    'canUpdateFavouriteTeam' : IDL.Bool,
    'reputation' : IDL.Nat32,
    'principalName' : IDL.Text,
    'profilePicture' : IDL.Vec(IDL.Nat8),
    'membershipType' : IDL.Nat8,
  });
  const TeamId = IDL.Nat16;
  const SeasonId = IDL.Nat16;
  const LeaderboardEntry = IDL.Record({
    'username' : IDL.Text,
    'positionText' : IDL.Text,
    'position' : IDL.Int,
    'principalId' : IDL.Text,
    'points' : IDL.Int16,
  });
  const PaginatedClubLeaderboard = IDL.Record({
    'month' : IDL.Nat8,
    'clubId' : TeamId,
    'totalEntries' : IDL.Nat,
    'seasonId' : SeasonId,
    'entries' : IDL.Vec(LeaderboardEntry),
  });
  const DataCache = IDL.Record({ 'hash' : IDL.Text, 'category' : IDL.Text });
  const PlayerId = IDL.Nat16;
  const GameweekNumber = IDL.Nat8;
  const FantasyTeam = IDL.Record({
    'playerIds' : IDL.Vec(PlayerId),
    'teamName' : IDL.Text,
    'goalGetterPlayerId' : PlayerId,
    'favouriteTeamId' : TeamId,
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
    'bankBalance' : IDL.Nat,
    'captainFantasticPlayerId' : PlayerId,
    'noEntryGameweek' : GameweekNumber,
    'safeHandsGameweek' : GameweekNumber,
    'principalId' : IDL.Text,
    'passMasterPlayerId' : PlayerId,
    'captainId' : PlayerId,
  });
  const FantasyTeamSnapshot = IDL.Record({
    'playerIds' : IDL.Vec(PlayerId),
    'teamName' : IDL.Text,
    'goalGetterPlayerId' : PlayerId,
    'favouriteTeamId' : TeamId,
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
    'bankBalance' : IDL.Nat,
    'captainFantasticPlayerId' : PlayerId,
    'gameweek' : GameweekNumber,
    'noEntryGameweek' : GameweekNumber,
    'safeHandsGameweek' : GameweekNumber,
    'principalId' : IDL.Text,
    'passMasterPlayerId' : PlayerId,
    'captainId' : IDL.Nat16,
    'points' : IDL.Int16,
  });
  List_1.fill(IDL.Opt(IDL.Tuple(FantasyTeamSnapshot, List_1)));
  const FantasyTeamSeason = IDL.Record({
    'seasonId' : SeasonId,
    'gameweeks' : List_1,
    'totalPoints' : IDL.Int16,
  });
  List.fill(IDL.Opt(IDL.Tuple(FantasyTeamSeason, List)));
  const UserFantasyTeam = IDL.Record({
    'fantasyTeam' : FantasyTeam,
    'history' : List,
  });
  const FixtureId = IDL.Nat32;
  const PlayerEventData = IDL.Record({
    'fixtureId' : FixtureId,
    'playerId' : IDL.Nat16,
    'eventStartMinute' : IDL.Nat8,
    'eventEndMinute' : IDL.Nat8,
    'teamId' : TeamId,
    'eventType' : IDL.Nat8,
  });
  List_2.fill(IDL.Opt(IDL.Tuple(PlayerEventData, List_2)));
  const Fixture = IDL.Record({
    'id' : IDL.Nat32,
    'status' : IDL.Nat8,
    'awayTeamId' : TeamId,
    'highestScoringPlayerId' : IDL.Nat16,
    'homeTeamId' : TeamId,
    'seasonId' : SeasonId,
    'events' : List_2,
    'kickOff' : IDL.Int,
    'homeGoals' : IDL.Nat8,
    'gameweek' : GameweekNumber,
    'awayGoals' : IDL.Nat8,
  });
  const FixtureDTO = IDL.Record({
    'id' : IDL.Nat32,
    'status' : IDL.Nat8,
    'awayTeamId' : TeamId,
    'highestScoringPlayerId' : IDL.Nat16,
    'homeTeamId' : TeamId,
    'seasonId' : SeasonId,
    'events' : IDL.Vec(PlayerEventData),
    'kickOff' : IDL.Int,
    'homeGoals' : IDL.Nat8,
    'gameweek' : GameweekNumber,
    'awayGoals' : IDL.Nat8,
  });
  const PaginatedLeaderboard = IDL.Record({
    'totalEntries' : IDL.Nat,
    'seasonId' : SeasonId,
    'entries' : IDL.Vec(LeaderboardEntry),
    'gameweek' : GameweekNumber,
  });
  const SeasonDTO = IDL.Record({
    'id' : SeasonId,
    'name' : IDL.Text,
    'year' : IDL.Nat16,
  });
  List_4.fill(IDL.Opt(IDL.Tuple(Fixture, List_4)));
  const Gameweek = IDL.Record({
    'number' : GameweekNumber,
    'fixtures' : List_4,
    'canisterId' : IDL.Text,
  });
  List_3.fill(IDL.Opt(IDL.Tuple(Gameweek, List_3)));
  const Season = IDL.Record({
    'id' : IDL.Nat16,
    'postponedFixtures' : List_4,
    'name' : IDL.Text,
    'year' : IDL.Nat16,
    'gameweeks' : List_3,
  });
  const SystemState = IDL.Record({
    'activeMonth' : IDL.Nat8,
    'focusGameweek' : GameweekNumber,
    'activeSeason' : Season,
    'activeGameweek' : GameweekNumber,
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
    'fixMissingProfiles' : IDL.Func([], [], []),
    'getAccountBalanceDTO' : IDL.Func([], [AccountBalanceDTO], []),
    'getAllProfilesDEV' : IDL.Func([], [IDL.Vec(ProfileDTO)], []),
    'getClubLeaderboard' : IDL.Func(
        [IDL.Nat16, IDL.Nat8, TeamId, IDL.Nat, IDL.Nat],
        [PaginatedClubLeaderboard],
        ['query'],
      ),
    'getClubLeaderboardsCache' : IDL.Func(
        [IDL.Nat16, IDL.Nat8],
        [IDL.Vec(PaginatedClubLeaderboard)],
        ['query'],
      ),
    'getDataHashes' : IDL.Func([], [IDL.Vec(DataCache)], ['query']),
    'getFantasyTeam' : IDL.Func([], [FantasyTeam], ['query']),
    'getFantasyTeamForGameweek' : IDL.Func(
        [IDL.Text, IDL.Nat16, IDL.Nat8],
        [FantasyTeamSnapshot],
        ['query'],
      ),
    'getFantasyTeamsDEV' : IDL.Func(
        [],
        [IDL.Vec(IDL.Tuple(IDL.Text, UserFantasyTeam))],
        [],
      ),
    'getFixture' : IDL.Func(
        [SeasonId, GameweekNumber, FixtureId],
        [Fixture],
        [],
      ),
    'getFixtureDTOs' : IDL.Func([], [IDL.Vec(FixtureDTO)], ['query']),
    'getFixtures' : IDL.Func([], [IDL.Vec(Fixture)], ['query']),
    'getFixturesForSeason' : IDL.Func(
        [SeasonId],
        [IDL.Vec(Fixture)],
        ['query'],
      ),
    'getProfileDTO' : IDL.Func([], [ProfileDTO], []),
    'getProfilesWithoutTeamsCount' : IDL.Func([], [IDL.Nat], []),
    'getPublicProfileDTO' : IDL.Func([IDL.Text], [ProfileDTO], ['query']),
    'getSeasonLeaderboard' : IDL.Func(
        [IDL.Nat16, IDL.Nat, IDL.Nat],
        [PaginatedLeaderboard],
        ['query'],
      ),
    'getSeasonLeaderboardCache' : IDL.Func(
        [IDL.Nat16],
        [PaginatedLeaderboard],
        ['query'],
      ),
    'getSeasons' : IDL.Func([], [IDL.Vec(SeasonDTO)], ['query']),
    'getSystemState' : IDL.Func([], [SystemState], ['query']),
    'getTeams' : IDL.Func([], [IDL.Vec(Team)], ['query']),
    'getTeamsWithoutProfiles' : IDL.Func([], [IDL.Vec(UserFantasyTeam)], []),
    'getTotalManagers' : IDL.Func([], [IDL.Nat], ['query']),
    'getValidatableFixtures' : IDL.Func([], [IDL.Vec(Fixture)], ['query']),
    'getWeeklyLeaderboard' : IDL.Func(
        [IDL.Nat16, IDL.Nat8, IDL.Nat, IDL.Nat],
        [PaginatedLeaderboard],
        ['query'],
      ),
    'getWeeklyLeaderboardCache' : IDL.Func(
        [IDL.Nat16, IDL.Nat8],
        [PaginatedLeaderboard],
        ['query'],
      ),
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
    'testUpdatingFantasyTeams' : IDL.Func(
        [],
        [IDL.Vec(IDL.Tuple(IDL.Text, UserFantasyTeam))],
        [],
      ),
    'updateDisplayName' : IDL.Func([IDL.Text], [Result], []),
    'updateFavouriteTeam' : IDL.Func([IDL.Nat16], [Result], []),
    'updateHashForCategory' : IDL.Func([IDL.Text], [], []),
    'updateProfilePicture' : IDL.Func([IDL.Vec(IDL.Nat8)], [Result], []),
    'withdrawICP' : IDL.Func([IDL.Float64, IDL.Text], [Result], []),
  });
};
export const init = ({ IDL }) => { return []; };
