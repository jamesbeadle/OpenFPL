export const idlFactory = ({ IDL }) => {
  const List = IDL.Rec();
  const List_1 = IDL.Rec();
  const Error = IDL.Variant({
    'MoreThan2PlayersFromClub' : IDL.Null,
    'DecodeError' : IDL.Null,
    'NotAllowed' : IDL.Null,
    'DuplicatePlayerInTeam' : IDL.Null,
    'InvalidBonuses' : IDL.Null,
    'TooManyTransfers' : IDL.Null,
    'NotFound' : IDL.Null,
    'NumberPerPositionError' : IDL.Null,
    'TeamOverspend' : IDL.Null,
    'NotAuthorized' : IDL.Null,
    'SelectedCaptainNotInTeam' : IDL.Null,
    'InvalidData' : IDL.Null,
    'SystemOnHold' : IDL.Null,
    'AlreadyExists' : IDL.Null,
    'CanisterCreateError' : IDL.Null,
    'Not11Players' : IDL.Null,
  });
  const Result = IDL.Variant({ 'ok' : IDL.Null, 'err' : Error });
  const GameweekNumber = IDL.Nat8;
  const Result_24 = IDL.Variant({ 'ok' : IDL.Text, 'err' : Error });
  const CanisterType = IDL.Variant({
    'SNS' : IDL.Null,
    'Leaderboard' : IDL.Null,
    'Dapp' : IDL.Null,
    'Archive' : IDL.Null,
    'Manager' : IDL.Null,
  });
  const GetCanistersDTO = IDL.Record({ 'canisterType' : CanisterType });
  const CanisterId = IDL.Text;
  const CanisterTopup = IDL.Record({
    'topupTime' : IDL.Int,
    'canisterId' : CanisterId,
    'cyclesAmount' : IDL.Nat,
  });
  const CanisterDTO = IDL.Record({
    'cycles' : IDL.Nat,
    'topups' : IDL.Vec(CanisterTopup),
    'computeAllocation' : IDL.Nat,
    'canisterId' : CanisterId,
  });
  const Result_23 = IDL.Variant({ 'ok' : IDL.Vec(CanisterDTO), 'err' : Error });
  const ClubId = IDL.Nat16;
  const ShirtType = IDL.Variant({ 'Filled' : IDL.Null, 'Striped' : IDL.Null });
  const ClubDTO = IDL.Record({
    'id' : ClubId,
    'secondaryColourHex' : IDL.Text,
    'name' : IDL.Text,
    'friendlyName' : IDL.Text,
    'thirdColourHex' : IDL.Text,
    'abbreviatedName' : IDL.Text,
    'shirtType' : ShirtType,
    'primaryColourHex' : IDL.Text,
  });
  const Result_22 = IDL.Variant({ 'ok' : IDL.Vec(ClubDTO), 'err' : Error });
  const CountryId = IDL.Nat16;
  const CountryDTO = IDL.Record({
    'id' : CountryId,
    'code' : IDL.Text,
    'name' : IDL.Text,
  });
  const Result_21 = IDL.Variant({ 'ok' : IDL.Vec(CountryDTO), 'err' : Error });
  const PickTeamDTO = IDL.Record({
    'playerIds' : IDL.Vec(ClubId),
    'username' : IDL.Text,
    'goalGetterPlayerId' : ClubId,
    'oneNationCountryId' : CountryId,
    'hatTrickHeroGameweek' : GameweekNumber,
    'transfersAvailable' : IDL.Nat8,
    'oneNationGameweek' : GameweekNumber,
    'teamBoostGameweek' : GameweekNumber,
    'captainFantasticGameweek' : GameweekNumber,
    'bankQuarterMillions' : IDL.Nat16,
    'noEntryPlayerId' : ClubId,
    'safeHandsPlayerId' : ClubId,
    'braceBonusGameweek' : GameweekNumber,
    'passMasterGameweek' : GameweekNumber,
    'teamBoostClubId' : ClubId,
    'goalGetterGameweek' : GameweekNumber,
    'firstGameweek' : IDL.Bool,
    'captainFantasticPlayerId' : ClubId,
    'transferWindowGameweek' : GameweekNumber,
    'noEntryGameweek' : GameweekNumber,
    'prospectsGameweek' : GameweekNumber,
    'safeHandsGameweek' : GameweekNumber,
    'principalId' : IDL.Text,
    'passMasterPlayerId' : ClubId,
    'captainId' : ClubId,
    'canisterId' : CanisterId,
    'monthlyBonusesAvailable' : IDL.Nat8,
  });
  const Result_20 = IDL.Variant({ 'ok' : PickTeamDTO, 'err' : Error });
  const DataHashDTO = IDL.Record({ 'hash' : IDL.Text, 'category' : IDL.Text });
  const Result_19 = IDL.Variant({ 'ok' : IDL.Vec(DataHashDTO), 'err' : Error });
  const SeasonId = IDL.Nat16;
  const PrincipalId = IDL.Text;
  const GetFantasyTeamSnapshotDTO = IDL.Record({
    'seasonId' : SeasonId,
    'managerPrincipalId' : PrincipalId,
    'gameweek' : GameweekNumber,
  });
  const CalendarMonth = IDL.Nat8;
  const FantasyTeamSnapshotDTO = IDL.Record({
    'playerIds' : IDL.Vec(ClubId),
    'month' : CalendarMonth,
    'teamValueQuarterMillions' : IDL.Nat16,
    'username' : IDL.Text,
    'goalGetterPlayerId' : ClubId,
    'oneNationCountryId' : CountryId,
    'hatTrickHeroGameweek' : GameweekNumber,
    'transfersAvailable' : IDL.Nat8,
    'oneNationGameweek' : GameweekNumber,
    'teamBoostGameweek' : GameweekNumber,
    'captainFantasticGameweek' : GameweekNumber,
    'bankQuarterMillions' : IDL.Nat16,
    'noEntryPlayerId' : ClubId,
    'monthlyPoints' : IDL.Int16,
    'safeHandsPlayerId' : ClubId,
    'seasonId' : SeasonId,
    'braceBonusGameweek' : GameweekNumber,
    'favouriteClubId' : ClubId,
    'passMasterGameweek' : GameweekNumber,
    'teamBoostClubId' : ClubId,
    'goalGetterGameweek' : GameweekNumber,
    'captainFantasticPlayerId' : ClubId,
    'gameweek' : GameweekNumber,
    'seasonPoints' : IDL.Int16,
    'transferWindowGameweek' : GameweekNumber,
    'noEntryGameweek' : GameweekNumber,
    'prospectsGameweek' : GameweekNumber,
    'safeHandsGameweek' : GameweekNumber,
    'principalId' : IDL.Text,
    'passMasterPlayerId' : ClubId,
    'captainId' : ClubId,
    'points' : IDL.Int16,
    'monthlyBonusesAvailable' : IDL.Nat8,
  });
  const Result_18 = IDL.Variant({
    'ok' : FantasyTeamSnapshotDTO,
    'err' : Error,
  });
  const LeagueId = IDL.Nat16;
  const FixtureStatusType = IDL.Variant({
    'Unplayed' : IDL.Null,
    'Finalised' : IDL.Null,
    'Active' : IDL.Null,
    'Complete' : IDL.Null,
  });
  const FixtureId = IDL.Nat32;
  const PlayerEventType = IDL.Variant({
    'PenaltyMissed' : IDL.Null,
    'Goal' : IDL.Null,
    'GoalConceded' : IDL.Null,
    'Appearance' : IDL.Null,
    'PenaltySaved' : IDL.Null,
    'RedCard' : IDL.Null,
    'KeeperSave' : IDL.Null,
    'CleanSheet' : IDL.Null,
    'YellowCard' : IDL.Null,
    'GoalAssisted' : IDL.Null,
    'OwnGoal' : IDL.Null,
    'HighestScoringPlayer' : IDL.Null,
  });
  const PlayerEventData = IDL.Record({
    'fixtureId' : FixtureId,
    'clubId' : ClubId,
    'playerId' : IDL.Nat16,
    'eventStartMinute' : IDL.Nat8,
    'eventEndMinute' : IDL.Nat8,
    'eventType' : PlayerEventType,
  });
  const FixtureDTO = IDL.Record({
    'id' : IDL.Nat32,
    'status' : FixtureStatusType,
    'highestScoringPlayerId' : IDL.Nat16,
    'seasonId' : SeasonId,
    'awayClubId' : ClubId,
    'events' : IDL.Vec(PlayerEventData),
    'homeClubId' : ClubId,
    'kickOff' : IDL.Int,
    'homeGoals' : IDL.Nat8,
    'gameweek' : GameweekNumber,
    'awayGoals' : IDL.Nat8,
  });
  const Result_12 = IDL.Variant({ 'ok' : IDL.Vec(FixtureDTO), 'err' : Error });
  const Result_17 = IDL.Variant({ 'ok' : IDL.Vec(CanisterId), 'err' : Error });
  const ClubFilterDTO = IDL.Record({
    'clubId' : ClubId,
    'leagueId' : LeagueId,
  });
  const PlayerStatus = IDL.Variant({
    'OnLoan' : IDL.Null,
    'Active' : IDL.Null,
    'FreeAgent' : IDL.Null,
    'Retired' : IDL.Null,
  });
  const PlayerPosition = IDL.Variant({
    'Goalkeeper' : IDL.Null,
    'Midfielder' : IDL.Null,
    'Forward' : IDL.Null,
    'Defender' : IDL.Null,
  });
  const PlayerDTO = IDL.Record({
    'id' : IDL.Nat16,
    'status' : PlayerStatus,
    'clubId' : ClubId,
    'valueQuarterMillions' : IDL.Nat16,
    'dateOfBirth' : IDL.Int,
    'nationality' : CountryId,
    'shirtNumber' : IDL.Nat8,
    'position' : PlayerPosition,
    'lastName' : IDL.Text,
    'firstName' : IDL.Text,
  });
  const Result_5 = IDL.Variant({ 'ok' : IDL.Vec(PlayerDTO), 'err' : Error });
  const RequestManagerDTO = IDL.Record({
    'month' : CalendarMonth,
    'clubId' : ClubId,
    'seasonId' : SeasonId,
    'managerId' : IDL.Text,
    'gameweek' : GameweekNumber,
  });
  const PlayerId = IDL.Nat16;
  const FantasyTeamSnapshot = IDL.Record({
    'playerIds' : IDL.Vec(PlayerId),
    'month' : CalendarMonth,
    'teamValueQuarterMillions' : IDL.Nat16,
    'username' : IDL.Text,
    'goalGetterPlayerId' : PlayerId,
    'oneNationCountryId' : CountryId,
    'hatTrickHeroGameweek' : GameweekNumber,
    'transfersAvailable' : IDL.Nat8,
    'oneNationGameweek' : GameweekNumber,
    'teamBoostGameweek' : GameweekNumber,
    'captainFantasticGameweek' : GameweekNumber,
    'bankQuarterMillions' : IDL.Nat16,
    'noEntryPlayerId' : PlayerId,
    'monthlyPoints' : IDL.Int16,
    'safeHandsPlayerId' : PlayerId,
    'seasonId' : SeasonId,
    'braceBonusGameweek' : GameweekNumber,
    'favouriteClubId' : IDL.Opt(ClubId),
    'passMasterGameweek' : GameweekNumber,
    'teamBoostClubId' : ClubId,
    'goalGetterGameweek' : GameweekNumber,
    'captainFantasticPlayerId' : PlayerId,
    'gameweek' : GameweekNumber,
    'seasonPoints' : IDL.Int16,
    'transferWindowGameweek' : GameweekNumber,
    'noEntryGameweek' : GameweekNumber,
    'prospectsGameweek' : GameweekNumber,
    'safeHandsGameweek' : GameweekNumber,
    'principalId' : IDL.Text,
    'passMasterPlayerId' : PlayerId,
    'captainId' : PlayerId,
    'points' : IDL.Int16,
    'monthlyBonusesAvailable' : IDL.Nat8,
  });
  const ManagerDTO = IDL.Record({
    'username' : IDL.Text,
    'weeklyPosition' : IDL.Int,
    'createDate' : IDL.Int,
    'monthlyPoints' : IDL.Int16,
    'weeklyPoints' : IDL.Int16,
    'weeklyPositionText' : IDL.Text,
    'gameweeks' : IDL.Vec(FantasyTeamSnapshot),
    'favouriteClubId' : IDL.Opt(ClubId),
    'monthlyPosition' : IDL.Int,
    'seasonPosition' : IDL.Int,
    'monthlyPositionText' : IDL.Text,
    'profilePicture' : IDL.Opt(IDL.Vec(IDL.Nat8)),
    'seasonPoints' : IDL.Int16,
    'profilePictureType' : IDL.Text,
    'principalId' : IDL.Text,
    'seasonPositionText' : IDL.Text,
  });
  const Result_1 = IDL.Variant({ 'ok' : ManagerDTO, 'err' : Error });
  const GetMonthlyLeaderboardDTO = IDL.Record({
    'month' : CalendarMonth,
    'clubId' : ClubId,
    'offset' : IDL.Nat,
    'seasonId' : SeasonId,
    'limit' : IDL.Nat,
    'searchTerm' : IDL.Text,
  });
  const LeaderboardEntry = IDL.Record({
    'username' : IDL.Text,
    'positionText' : IDL.Text,
    'position' : IDL.Nat,
    'principalId' : IDL.Text,
    'points' : IDL.Int16,
  });
  const MonthlyLeaderboardDTO = IDL.Record({
    'month' : IDL.Nat8,
    'clubId' : ClubId,
    'totalEntries' : IDL.Nat,
    'seasonId' : SeasonId,
    'entries' : IDL.Vec(LeaderboardEntry),
  });
  const Result_16 = IDL.Variant({
    'ok' : MonthlyLeaderboardDTO,
    'err' : Error,
  });
  const GetPlayerDetailsDTO = IDL.Record({
    'playerId' : ClubId,
    'seasonId' : SeasonId,
  });
  const InjuryHistory = IDL.Record({
    'description' : IDL.Text,
    'injuryStartDate' : IDL.Int,
    'expectedEndDate' : IDL.Int,
  });
  const PlayerGameweekDTO = IDL.Record({
    'fixtureId' : FixtureId,
    'events' : IDL.Vec(PlayerEventData),
    'number' : IDL.Nat8,
    'points' : IDL.Int16,
  });
  const ValueHistory = IDL.Record({
    'oldValue' : IDL.Nat16,
    'changedOn' : IDL.Int,
    'newValue' : IDL.Nat16,
  });
  const PlayerDetailDTO = IDL.Record({
    'id' : ClubId,
    'status' : PlayerStatus,
    'clubId' : ClubId,
    'parentClubId' : ClubId,
    'valueQuarterMillions' : IDL.Nat16,
    'dateOfBirth' : IDL.Int,
    'injuryHistory' : IDL.Vec(InjuryHistory),
    'seasonId' : SeasonId,
    'gameweeks' : IDL.Vec(PlayerGameweekDTO),
    'nationality' : CountryId,
    'retirementDate' : IDL.Int,
    'valueHistory' : IDL.Vec(ValueHistory),
    'latestInjuryEndDate' : IDL.Int,
    'shirtNumber' : IDL.Nat8,
    'position' : PlayerPosition,
    'lastName' : IDL.Text,
    'firstName' : IDL.Text,
  });
  const Result_15 = IDL.Variant({ 'ok' : PlayerDetailDTO, 'err' : Error });
  const GameweekFiltersDTO = IDL.Record({
    'seasonId' : SeasonId,
    'gameweek' : GameweekNumber,
  });
  const PlayerPointsDTO = IDL.Record({
    'id' : IDL.Nat16,
    'clubId' : ClubId,
    'events' : IDL.Vec(PlayerEventData),
    'position' : PlayerPosition,
    'gameweek' : GameweekNumber,
    'points' : IDL.Int16,
  });
  const Result_14 = IDL.Variant({
    'ok' : IDL.Vec(PlayerPointsDTO),
    'err' : Error,
  });
  const PlayerScoreDTO = IDL.Record({
    'id' : IDL.Nat16,
    'clubId' : ClubId,
    'assists' : IDL.Int16,
    'dateOfBirth' : IDL.Int,
    'nationality' : CountryId,
    'goalsScored' : IDL.Int16,
    'saves' : IDL.Int16,
    'goalsConceded' : IDL.Int16,
    'events' : IDL.Vec(PlayerEventData),
    'position' : PlayerPosition,
    'points' : IDL.Int16,
  });
  const Result_13 = IDL.Variant({
    'ok' : IDL.Vec(IDL.Tuple(IDL.Nat16, PlayerScoreDTO)),
    'err' : Error,
  });
  const GetSnapshotPlayers = IDL.Record({
    'seasonId' : SeasonId,
    'gameweek' : GameweekNumber,
    'leagueId' : LeagueId,
  });
  const ProfileDTO = IDL.Record({
    'username' : IDL.Text,
    'termsAccepted' : IDL.Bool,
    'createDate' : IDL.Int,
    'favouriteClubId' : IDL.Opt(ClubId),
    'profilePicture' : IDL.Opt(IDL.Vec(IDL.Nat8)),
    'profilePictureType' : IDL.Text,
    'principalId' : IDL.Text,
  });
  const Result_11 = IDL.Variant({ 'ok' : ProfileDTO, 'err' : Error });
  const RewardPool = IDL.Record({
    'monthlyLeaderboardPool' : IDL.Nat64,
    'allTimeSeasonHighScorePool' : IDL.Nat64,
    'mostValuableTeamPool' : IDL.Nat64,
    'highestScoringMatchPlayerPool' : IDL.Nat64,
    'seasonId' : SeasonId,
    'seasonLeaderboardPool' : IDL.Nat64,
    'allTimeWeeklyHighScorePool' : IDL.Nat64,
    'allTimeMonthlyHighScorePool' : IDL.Nat64,
    'weeklyLeaderboardPool' : IDL.Nat64,
  });
  const GetRewardPoolDTO = IDL.Record({
    'seasonId' : SeasonId,
    'rewardPool' : RewardPool,
  });
  const Result_10 = IDL.Variant({ 'ok' : GetRewardPoolDTO, 'err' : Error });
  const GetSeasonLeaderboardDTO = IDL.Record({
    'offset' : IDL.Nat,
    'seasonId' : SeasonId,
    'limit' : IDL.Nat,
    'searchTerm' : IDL.Text,
  });
  const SeasonLeaderboardDTO = IDL.Record({
    'totalEntries' : IDL.Nat,
    'seasonId' : SeasonId,
    'entries' : IDL.Vec(LeaderboardEntry),
  });
  const Result_9 = IDL.Variant({ 'ok' : SeasonLeaderboardDTO, 'err' : Error });
  const SeasonDTO = IDL.Record({
    'id' : SeasonId,
    'name' : IDL.Text,
    'year' : IDL.Nat16,
  });
  const Result_8 = IDL.Variant({ 'ok' : IDL.Vec(SeasonDTO), 'err' : Error });
  const SystemStateDTO = IDL.Record({
    'pickTeamSeasonId' : SeasonId,
    'calculationGameweek' : GameweekNumber,
    'transferWindowActive' : IDL.Bool,
    'pickTeamMonth' : CalendarMonth,
    'pickTeamGameweek' : GameweekNumber,
    'version' : IDL.Text,
    'calculationMonth' : CalendarMonth,
    'calculationSeasonId' : SeasonId,
    'onHold' : IDL.Bool,
    'seasonActive' : IDL.Bool,
  });
  const Result_7 = IDL.Variant({ 'ok' : SystemStateDTO, 'err' : Error });
  const Result_6 = IDL.Variant({ 'ok' : IDL.Nat, 'err' : Error });
  const Result_4 = IDL.Variant({
    'ok' : IDL.Vec(
      IDL.Tuple(SeasonId, IDL.Vec(IDL.Tuple(GameweekNumber, CanisterId)))
    ),
    'err' : Error,
  });
  const GetWeeklyLeaderboardDTO = IDL.Record({
    'offset' : IDL.Nat,
    'seasonId' : SeasonId,
    'limit' : IDL.Nat,
    'searchTerm' : IDL.Text,
    'gameweek' : GameweekNumber,
  });
  const WeeklyLeaderboardDTO = IDL.Record({
    'totalEntries' : IDL.Nat,
    'seasonId' : SeasonId,
    'entries' : IDL.Vec(LeaderboardEntry),
    'gameweek' : GameweekNumber,
  });
  const Result_3 = IDL.Variant({ 'ok' : WeeklyLeaderboardDTO, 'err' : Error });
  List_1.fill(IDL.Opt(IDL.Tuple(LeaderboardEntry, List_1)));
  const WeeklyLeaderboard = IDL.Record({
    'totalEntries' : IDL.Nat,
    'seasonId' : SeasonId,
    'entries' : List_1,
    'gameweek' : GameweekNumber,
  });
  const RewardType = IDL.Variant({
    'MonthlyLeaderboard' : IDL.Null,
    'MostValuableTeam' : IDL.Null,
    'MonthlyATHScore' : IDL.Null,
    'WeeklyATHScore' : IDL.Null,
    'SeasonATHScore' : IDL.Null,
    'SeasonLeaderboard' : IDL.Null,
    'WeeklyLeaderboard' : IDL.Null,
    'HighestScoringPlayer' : IDL.Null,
  });
  const RewardEntry = IDL.Record({
    'rewardType' : RewardType,
    'position' : IDL.Nat,
    'amount' : IDL.Nat64,
    'principalId' : IDL.Text,
  });
  List.fill(IDL.Opt(IDL.Tuple(RewardEntry, List)));
  const WeeklyRewards = IDL.Record({
    'seasonId' : SeasonId,
    'rewards' : List,
    'gameweek' : GameweekNumber,
  });
  const Result_2 = IDL.Variant({ 'ok' : WeeklyRewards, 'err' : Error });
  const UsernameFilterDTO = IDL.Record({ 'username' : IDL.Text });
  const UpdateTeamSelectionDTO = IDL.Record({
    'playerIds' : IDL.Vec(ClubId),
    'username' : IDL.Text,
    'goalGetterPlayerId' : ClubId,
    'oneNationCountryId' : CountryId,
    'hatTrickHeroGameweek' : GameweekNumber,
    'oneNationGameweek' : GameweekNumber,
    'teamBoostGameweek' : GameweekNumber,
    'captainFantasticGameweek' : GameweekNumber,
    'noEntryPlayerId' : ClubId,
    'safeHandsPlayerId' : ClubId,
    'braceBonusGameweek' : GameweekNumber,
    'passMasterGameweek' : GameweekNumber,
    'teamBoostClubId' : ClubId,
    'goalGetterGameweek' : GameweekNumber,
    'captainFantasticPlayerId' : ClubId,
    'transferWindowGameweek' : GameweekNumber,
    'noEntryGameweek' : GameweekNumber,
    'prospectsGameweek' : GameweekNumber,
    'safeHandsGameweek' : GameweekNumber,
    'passMasterPlayerId' : ClubId,
    'captainId' : ClubId,
  });
  const BlockIndex = IDL.Nat;
  const Tokens = IDL.Nat;
  const Timestamp = IDL.Nat64;
  const TransferError = IDL.Variant({
    'GenericError' : IDL.Record({
      'message' : IDL.Text,
      'error_code' : IDL.Nat,
    }),
    'TemporarilyUnavailable' : IDL.Null,
    'BadBurn' : IDL.Record({ 'min_burn_amount' : Tokens }),
    'Duplicate' : IDL.Record({ 'duplicate_of' : BlockIndex }),
    'BadFee' : IDL.Record({ 'expected_fee' : Tokens }),
    'CreatedInFuture' : IDL.Record({ 'ledger_time' : Timestamp }),
    'TooOld' : IDL.Null,
    'InsufficientFunds' : IDL.Record({ 'balance' : Tokens }),
  });
  const TransferResult = IDL.Variant({
    'Ok' : BlockIndex,
    'Err' : TransferError,
  });
  const UpdateFavouriteClubDTO = IDL.Record({ 'favouriteClubId' : ClubId });
  const UpdateProfilePictureDTO = IDL.Record({
    'profilePicture' : IDL.Vec(IDL.Nat8),
    'extension' : IDL.Text,
  });
  const UpdateSystemStateDTO = IDL.Record({
    'pickTeamSeasonId' : SeasonId,
    'calculationGameweek' : GameweekNumber,
    'transferWindowActive' : IDL.Bool,
    'pickTeamMonth' : CalendarMonth,
    'pickTeamGameweek' : GameweekNumber,
    'version' : IDL.Text,
    'calculationMonth' : CalendarMonth,
    'calculationSeasonId' : SeasonId,
    'onHold' : IDL.Bool,
    'seasonActive' : IDL.Bool,
  });
  const UpdateUsernameDTO = IDL.Record({ 'username' : IDL.Text });
  return IDL.Service({
    'calculateGameweekScores' : IDL.Func([], [Result], []),
    'calculateLeaderboards' : IDL.Func([], [Result], []),
    'calculateWeeklyRewards' : IDL.Func([GameweekNumber], [Result], []),
    'getActiveLeaderboardCanisterId' : IDL.Func([], [Result_24], []),
    'getCanisters' : IDL.Func([GetCanistersDTO], [Result_23], []),
    'getClubs' : IDL.Func([], [Result_22], ['composite_query']),
    'getCountries' : IDL.Func([], [Result_21], ['query']),
    'getCurrentTeam' : IDL.Func([], [Result_20], []),
    'getDataHashes' : IDL.Func([], [Result_19], ['composite_query']),
    'getFantasyTeamSnapshot' : IDL.Func(
        [GetFantasyTeamSnapshotDTO],
        [Result_18],
        [],
      ),
    'getFixtures' : IDL.Func([LeagueId], [Result_12], ['composite_query']),
    'getLeaderboardCanisterIds' : IDL.Func([], [Result_17], []),
    'getLoanedPlayers' : IDL.Func(
        [ClubFilterDTO],
        [Result_5],
        ['composite_query'],
      ),
    'getManager' : IDL.Func([RequestManagerDTO], [Result_1], []),
    'getManagerCanisterIds' : IDL.Func([], [Result_17], []),
    'getMonthlyLeaderboard' : IDL.Func(
        [GetMonthlyLeaderboardDTO],
        [Result_16],
        [],
      ),
    'getPlayerDetails' : IDL.Func([GetPlayerDetailsDTO], [Result_15], []),
    'getPlayerDetailsForGameweek' : IDL.Func(
        [GameweekFiltersDTO],
        [Result_14],
        ['composite_query'],
      ),
    'getPlayers' : IDL.Func([], [Result_5], ['composite_query']),
    'getPlayersMap' : IDL.Func([GameweekFiltersDTO], [Result_13], []),
    'getPlayersSnapshot' : IDL.Func(
        [GetSnapshotPlayers],
        [IDL.Vec(PlayerDTO)],
        ['query'],
      ),
    'getPostponedFixtures' : IDL.Func([], [Result_12], ['composite_query']),
    'getProfile' : IDL.Func([], [Result_11], []),
    'getRetiredPlayers' : IDL.Func(
        [ClubFilterDTO],
        [Result_5],
        ['composite_query'],
      ),
    'getRewardPool' : IDL.Func([GetRewardPoolDTO], [Result_10], []),
    'getSeasonLeaderboard' : IDL.Func(
        [GetSeasonLeaderboardDTO],
        [Result_9],
        [],
      ),
    'getSeasons' : IDL.Func([], [Result_8], ['composite_query']),
    'getSystemState' : IDL.Func([], [Result_7], ['query']),
    'getTotalManagers' : IDL.Func([], [Result_6], ['query']),
    'getVerifiedPlayers' : IDL.Func([], [Result_5], []),
    'getWeeklyCanisters' : IDL.Func([], [Result_4], ['query']),
    'getWeeklyLeaderboard' : IDL.Func(
        [GetWeeklyLeaderboardDTO],
        [Result_3],
        [],
      ),
    'getWeeklyLeaderboards' : IDL.Func([], [IDL.Vec(WeeklyLeaderboard)], []),
    'getWeeklyRewards' : IDL.Func(
        [SeasonId, GameweekNumber],
        [Result_2],
        ['query'],
      ),
    'isUsernameValid' : IDL.Func([UsernameFilterDTO], [IDL.Bool], ['query']),
    'notifyAppsOfLoan' : IDL.Func([LeagueId, PlayerId], [Result], []),
    'notifyAppsOfPositionChange' : IDL.Func([LeagueId, PlayerId], [Result], []),
    'payWeeklyRewards' : IDL.Func([GameweekNumber], [Result], []),
    'saveFantasyTeam' : IDL.Func([UpdateTeamSelectionDTO], [Result], []),
    'searchUsername' : IDL.Func([UsernameFilterDTO], [Result_1], []),
    'snapshotManagers' : IDL.Func([], [Result], []),
    'transferFPLToNewBackendCanister' : IDL.Func([], [TransferResult], []),
    'updateDataHashes' : IDL.Func([IDL.Text], [Result], []),
    'updateFavouriteClub' : IDL.Func([UpdateFavouriteClubDTO], [Result], []),
    'updateProfilePicture' : IDL.Func([UpdateProfilePictureDTO], [Result], []),
    'updateSystemState' : IDL.Func([UpdateSystemStateDTO], [Result], []),
    'updateUsername' : IDL.Func([UpdateUsernameDTO], [Result], []),
  });
};
export const init = ({ IDL }) => { return []; };
