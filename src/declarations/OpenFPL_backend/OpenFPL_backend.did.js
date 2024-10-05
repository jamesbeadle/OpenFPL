export const idlFactory = ({ IDL }) => {
  const FixtureStatusType = IDL.Variant({
    'Unplayed' : IDL.Null,
    'Finalised' : IDL.Null,
    'Active' : IDL.Null,
    'Complete' : IDL.Null,
  });
  const SeasonId = IDL.Nat16;
  const ClubId = IDL.Nat16;
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
  const GameweekNumber = IDL.Nat8;
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
  const AddInitialFixturesDTO = IDL.Record({
    'seasonFixtures' : IDL.Vec(FixtureDTO),
  });
  const CountryId = IDL.Nat16;
  const Gender = IDL.Variant({ 'Male' : IDL.Null, 'Female' : IDL.Null });
  const PlayerPosition = IDL.Variant({
    'Goalkeeper' : IDL.Null,
    'Midfielder' : IDL.Null,
    'Forward' : IDL.Null,
    'Defender' : IDL.Null,
  });
  const CreatePlayerDTO = IDL.Record({
    'clubId' : ClubId,
    'valueQuarterMillions' : IDL.Nat16,
    'dateOfBirth' : IDL.Int,
    'nationality' : CountryId,
    'gender' : Gender,
    'shirtNumber' : IDL.Nat8,
    'position' : PlayerPosition,
    'lastName' : IDL.Text,
    'firstName' : IDL.Text,
  });
  const PlayerId = IDL.Nat16;
  const FootballLeagueId = IDL.Nat16;
  const LoanPlayerDTO = IDL.Record({
    'loanEndDate' : IDL.Int,
    'playerId' : PlayerId,
    'seasonId' : SeasonId,
    'loanClubId' : ClubId,
    'gameweek' : GameweekNumber,
    'loanLeagueId' : FootballLeagueId,
  });
  const MoveFixtureDTO = IDL.Record({
    'fixtureId' : FixtureId,
    'updatedFixtureGameweek' : GameweekNumber,
    'updatedFixtureDate' : IDL.Int,
  });
  const PostponeFixtureDTO = IDL.Record({ 'fixtureId' : FixtureId });
  const ShirtType = IDL.Variant({ 'Filled' : IDL.Null, 'Striped' : IDL.Null });
  const PromoteNewClubDTO = IDL.Record({
    'secondaryColourHex' : IDL.Text,
    'name' : IDL.Text,
    'friendlyName' : IDL.Text,
    'thirdColourHex' : IDL.Text,
    'abbreviatedName' : IDL.Text,
    'shirtType' : ShirtType,
    'primaryColourHex' : IDL.Text,
  });
  const RecallPlayerDTO = IDL.Record({ 'playerId' : PlayerId });
  const RescheduleFixtureDTO = IDL.Record({
    'postponedFixtureId' : FixtureId,
    'updatedFixtureGameweek' : GameweekNumber,
    'updatedFixtureDate' : IDL.Int,
  });
  const RetirePlayerDTO = IDL.Record({
    'playerId' : PlayerId,
    'retirementDate' : IDL.Int,
  });
  const RevaluePlayerDownDTO = IDL.Record({
    'playerId' : PlayerId,
    'seasonId' : SeasonId,
    'gameweek' : GameweekNumber,
  });
  const RevaluePlayerUpDTO = IDL.Record({
    'playerId' : PlayerId,
    'seasonId' : SeasonId,
    'gameweek' : GameweekNumber,
  });
  const SetPlayerInjuryDTO = IDL.Record({
    'playerId' : PlayerId,
    'description' : IDL.Text,
    'expectedEndDate' : IDL.Int,
  });
  const CalendarMonth = IDL.Nat8;
  const SubmitFixtureDataDTO = IDL.Record({
    'fixtureId' : FixtureId,
    'month' : CalendarMonth,
    'gameweek' : GameweekNumber,
    'playerEventData' : IDL.Vec(PlayerEventData),
  });
  const TransferPlayerDTO = IDL.Record({
    'clubId' : ClubId,
    'newLeagueId' : FootballLeagueId,
    'playerId' : PlayerId,
    'newShirtNumber' : IDL.Nat8,
    'seasonId' : SeasonId,
    'newClubId' : ClubId,
    'gameweek' : GameweekNumber,
  });
  const UnretirePlayerDTO = IDL.Record({ 'playerId' : PlayerId });
  const UpdateClubDTO = IDL.Record({
    'clubId' : ClubId,
    'secondaryColourHex' : IDL.Text,
    'name' : IDL.Text,
    'friendlyName' : IDL.Text,
    'thirdColourHex' : IDL.Text,
    'abbreviatedName' : IDL.Text,
    'shirtType' : ShirtType,
    'primaryColourHex' : IDL.Text,
  });
  const UpdatePlayerDTO = IDL.Record({
    'dateOfBirth' : IDL.Int,
    'playerId' : PlayerId,
    'nationality' : CountryId,
    'shirtNumber' : IDL.Nat8,
    'position' : PlayerPosition,
    'lastName' : IDL.Text,
    'firstName' : IDL.Text,
  });
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
  const Result_3 = IDL.Variant({ 'ok' : IDL.Nat, 'err' : Error });
  const CanisterType = IDL.Variant({
    'SNS' : IDL.Null,
    'MonthlyLeaderboard' : IDL.Null,
    'Dapp' : IDL.Null,
    'Archive' : IDL.Null,
    'SeasonLeaderboard' : IDL.Null,
    'WeeklyLeaderboard' : IDL.Null,
    'Manager' : IDL.Null,
  });
  const CanisterId = IDL.Text;
  const CanisterDTO = IDL.Record({
    'lastTopup' : IDL.Int,
    'cycles' : IDL.Nat,
    'canister_type' : CanisterType,
    'canisterId' : CanisterId,
  });
  const GetCanistersDTO = IDL.Record({
    'totalEntries' : IDL.Nat,
    'offset' : IDL.Nat,
    'limit' : IDL.Nat,
    'entries' : IDL.Vec(CanisterDTO),
    'canisterTypeFilter' : CanisterType,
  });
  const Result_21 = IDL.Variant({ 'ok' : GetCanistersDTO, 'err' : Error });
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
  const Result_20 = IDL.Variant({ 'ok' : IDL.Vec(ClubDTO), 'err' : Error });
  const CountryDTO = IDL.Record({
    'id' : CountryId,
    'code' : IDL.Text,
    'name' : IDL.Text,
  });
  const Result_19 = IDL.Variant({ 'ok' : IDL.Vec(CountryDTO), 'err' : Error });
  const PickTeamDTO = IDL.Record({
    'playerIds' : IDL.Vec(PlayerId),
    'countrymenCountryId' : CountryId,
    'username' : IDL.Text,
    'goalGetterPlayerId' : PlayerId,
    'hatTrickHeroGameweek' : GameweekNumber,
    'transfersAvailable' : IDL.Nat8,
    'teamBoostGameweek' : GameweekNumber,
    'captainFantasticGameweek' : GameweekNumber,
    'countrymenGameweek' : GameweekNumber,
    'bankQuarterMillions' : IDL.Nat16,
    'noEntryPlayerId' : PlayerId,
    'safeHandsPlayerId' : PlayerId,
    'braceBonusGameweek' : GameweekNumber,
    'passMasterGameweek' : GameweekNumber,
    'teamBoostClubId' : ClubId,
    'goalGetterGameweek' : GameweekNumber,
    'captainFantasticPlayerId' : PlayerId,
    'transferWindowGameweek' : GameweekNumber,
    'noEntryGameweek' : GameweekNumber,
    'prospectsGameweek' : GameweekNumber,
    'safeHandsGameweek' : GameweekNumber,
    'principalId' : IDL.Text,
    'passMasterPlayerId' : PlayerId,
    'captainId' : PlayerId,
    'canisterId' : CanisterId,
    'monthlyBonusesAvailable' : IDL.Nat8,
  });
  const Result_18 = IDL.Variant({ 'ok' : PickTeamDTO, 'err' : Error });
  const DataHashDTO = IDL.Record({ 'hash' : IDL.Text, 'category' : IDL.Text });
  const Result_17 = IDL.Variant({ 'ok' : IDL.Vec(DataHashDTO), 'err' : Error });
  const PrincipalId = IDL.Text;
  const GetFantasyTeamSnapshotDTO = IDL.Record({
    'seasonId' : SeasonId,
    'managerPrincipalId' : PrincipalId,
    'gameweek' : GameweekNumber,
  });
  const FantasyTeamSnapshotDTO = IDL.Record({
    'playerIds' : IDL.Vec(PlayerId),
    'month' : CalendarMonth,
    'teamValueQuarterMillions' : IDL.Nat16,
    'countrymenCountryId' : CountryId,
    'username' : IDL.Text,
    'goalGetterPlayerId' : PlayerId,
    'hatTrickHeroGameweek' : GameweekNumber,
    'transfersAvailable' : IDL.Nat8,
    'teamBoostGameweek' : GameweekNumber,
    'captainFantasticGameweek' : GameweekNumber,
    'countrymenGameweek' : GameweekNumber,
    'bankQuarterMillions' : IDL.Nat16,
    'noEntryPlayerId' : PlayerId,
    'monthlyPoints' : IDL.Int16,
    'safeHandsPlayerId' : PlayerId,
    'seasonId' : SeasonId,
    'braceBonusGameweek' : GameweekNumber,
    'favouriteClubId' : ClubId,
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
  const Result_16 = IDL.Variant({
    'ok' : FantasyTeamSnapshotDTO,
    'err' : Error,
  });
  const RequestFixturesDTO = IDL.Record({ 'seasonId' : SeasonId });
  const Result_11 = IDL.Variant({ 'ok' : IDL.Vec(FixtureDTO), 'err' : Error });
  const ClubFilterDTO = IDL.Record({
    'clubId' : ClubId,
    'leagueId' : FootballLeagueId,
  });
  const PlayerStatus = IDL.Variant({
    'OnLoan' : IDL.Null,
    'Active' : IDL.Null,
    'FreeAgent' : IDL.Null,
    'Retired' : IDL.Null,
  });
  const PlayerDTO = IDL.Record({
    'id' : IDL.Nat16,
    'status' : PlayerStatus,
    'clubId' : ClubId,
    'valueQuarterMillions' : IDL.Nat16,
    'dateOfBirth' : IDL.Int,
    'nationality' : CountryId,
    'shirtNumber' : IDL.Nat8,
    'totalPoints' : IDL.Int16,
    'position' : PlayerPosition,
    'lastName' : IDL.Text,
    'firstName' : IDL.Text,
  });
  const Result_6 = IDL.Variant({ 'ok' : IDL.Vec(PlayerDTO), 'err' : Error });
  const RequestManagerDTO = IDL.Record({
    'month' : CalendarMonth,
    'clubId' : ClubId,
    'seasonId' : SeasonId,
    'managerId' : IDL.Text,
    'gameweek' : GameweekNumber,
  });
  const FantasyTeamSnapshot = IDL.Record({
    'playerIds' : IDL.Vec(PlayerId),
    'month' : CalendarMonth,
    'teamValueQuarterMillions' : IDL.Nat16,
    'countrymenCountryId' : CountryId,
    'username' : IDL.Text,
    'goalGetterPlayerId' : PlayerId,
    'hatTrickHeroGameweek' : GameweekNumber,
    'transfersAvailable' : IDL.Nat8,
    'teamBoostGameweek' : GameweekNumber,
    'captainFantasticGameweek' : GameweekNumber,
    'countrymenGameweek' : GameweekNumber,
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
  const Result_15 = IDL.Variant({
    'ok' : MonthlyLeaderboardDTO,
    'err' : Error,
  });
  const GetPlayerDetailsDTO = IDL.Record({
    'playerId' : PlayerId,
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
    'newValue' : IDL.Nat16,
    'seasonId' : IDL.Nat16,
    'gameweek' : IDL.Nat8,
  });
  const PlayerDetailDTO = IDL.Record({
    'id' : PlayerId,
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
  const Result_14 = IDL.Variant({ 'ok' : PlayerDetailDTO, 'err' : Error });
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
  const Result_13 = IDL.Variant({
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
  const Result_12 = IDL.Variant({
    'ok' : IDL.Vec(IDL.Tuple(IDL.Nat16, PlayerScoreDTO)),
    'err' : Error,
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
  const Result_10 = IDL.Variant({ 'ok' : ProfileDTO, 'err' : Error });
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
  const Result_9 = IDL.Variant({ 'ok' : GetRewardPoolDTO, 'err' : Error });
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
  const Result_8 = IDL.Variant({ 'ok' : SeasonLeaderboardDTO, 'err' : Error });
  const SeasonDTO = IDL.Record({
    'id' : SeasonId,
    'name' : IDL.Text,
    'year' : IDL.Nat16,
  });
  const Result_7 = IDL.Variant({ 'ok' : IDL.Vec(SeasonDTO), 'err' : Error });
  const GetSnapshotPlayers = IDL.Record({
    'seasonId' : SeasonId,
    'gameweek' : GameweekNumber,
    'leagueId' : FootballLeagueId,
  });
  const SystemStateDTO = IDL.Record({
    'pickTeamSeasonId' : SeasonId,
    'calculationGameweek' : GameweekNumber,
    'transferWindowActive' : IDL.Bool,
    'pickTeamGameweek' : GameweekNumber,
    'version' : IDL.Text,
    'calculationMonth' : CalendarMonth,
    'calculationSeasonId' : SeasonId,
    'onHold' : IDL.Bool,
    'seasonActive' : IDL.Bool,
  });
  const Result_5 = IDL.Variant({ 'ok' : SystemStateDTO, 'err' : Error });
  const TopupDTO = IDL.Record({
    'topupAmount' : IDL.Nat,
    'canisterId' : IDL.Text,
    'toppedUpOn' : IDL.Int,
  });
  const GetTopupsDTO = IDL.Record({
    'totalEntries' : IDL.Nat,
    'offset' : IDL.Nat,
    'limit' : IDL.Nat,
    'entries' : IDL.Vec(TopupDTO),
  });
  const Result_4 = IDL.Variant({ 'ok' : GetTopupsDTO, 'err' : Error });
  const AccountIdentifier = IDL.Vec(IDL.Nat8);
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
  const Result_2 = IDL.Variant({ 'ok' : WeeklyLeaderboardDTO, 'err' : Error });
  const UsernameFilterDTO = IDL.Record({ 'username' : IDL.Text });
  const UpdateTeamSelectionDTO = IDL.Record({
    'playerIds' : IDL.Vec(PlayerId),
    'countrymenCountryId' : CountryId,
    'username' : IDL.Text,
    'goalGetterPlayerId' : PlayerId,
    'hatTrickHeroGameweek' : GameweekNumber,
    'teamBoostGameweek' : GameweekNumber,
    'captainFantasticGameweek' : GameweekNumber,
    'countrymenGameweek' : GameweekNumber,
    'noEntryPlayerId' : PlayerId,
    'safeHandsPlayerId' : PlayerId,
    'braceBonusGameweek' : GameweekNumber,
    'passMasterGameweek' : GameweekNumber,
    'teamBoostClubId' : ClubId,
    'goalGetterGameweek' : GameweekNumber,
    'captainFantasticPlayerId' : PlayerId,
    'transferWindowGameweek' : GameweekNumber,
    'noEntryGameweek' : GameweekNumber,
    'prospectsGameweek' : GameweekNumber,
    'safeHandsGameweek' : GameweekNumber,
    'passMasterPlayerId' : PlayerId,
    'captainId' : PlayerId,
  });
  const Result = IDL.Variant({ 'ok' : IDL.Null, 'err' : Error });
  const UpdateFavouriteClubDTO = IDL.Record({ 'favouriteClubId' : ClubId });
  const UpdateProfilePictureDTO = IDL.Record({
    'profilePicture' : IDL.Vec(IDL.Nat8),
    'extension' : IDL.Text,
  });
  const UpdateUsernameDTO = IDL.Record({ 'username' : IDL.Text });
  const RustResult = IDL.Variant({ 'Ok' : IDL.Text, 'Err' : IDL.Text });
  return IDL.Service({
    'executeAddInitialFixtures' : IDL.Func([AddInitialFixturesDTO], [], []),
    'executeCreatePlayer' : IDL.Func([CreatePlayerDTO], [], []),
    'executeLoanPlayer' : IDL.Func([LoanPlayerDTO], [], []),
    'executeMoveFixture' : IDL.Func([MoveFixtureDTO], [], []),
    'executePostponeFixture' : IDL.Func([PostponeFixtureDTO], [], []),
    'executePromoteNewClub' : IDL.Func([PromoteNewClubDTO], [], []),
    'executeRecallPlayer' : IDL.Func([RecallPlayerDTO], [], []),
    'executeRescheduleFixture' : IDL.Func([RescheduleFixtureDTO], [], []),
    'executeRetirePlayer' : IDL.Func([RetirePlayerDTO], [], []),
    'executeRevaluePlayerDown' : IDL.Func([RevaluePlayerDownDTO], [], []),
    'executeRevaluePlayerUp' : IDL.Func([RevaluePlayerUpDTO], [], []),
    'executeSetPlayerInjury' : IDL.Func([SetPlayerInjuryDTO], [], []),
    'executeSubmitFixtureData' : IDL.Func([SubmitFixtureDataDTO], [], []),
    'executeTransferPlayer' : IDL.Func([TransferPlayerDTO], [], []),
    'executeUnretirePlayer' : IDL.Func([UnretirePlayerDTO], [], []),
    'executeUpdateClub' : IDL.Func([UpdateClubDTO], [], []),
    'executeUpdatePlayer' : IDL.Func([UpdatePlayerDTO], [], []),
    'getBackendCanisterBalance' : IDL.Func([], [Result_3], []),
    'getCanisterCyclesAvailable' : IDL.Func([], [IDL.Nat], []),
    'getCanisterCyclesBalance' : IDL.Func([], [Result_3], []),
    'getCanisters' : IDL.Func([GetCanistersDTO], [Result_21], []),
    'getClubs' : IDL.Func([], [Result_20], []),
    'getCountries' : IDL.Func([], [Result_19], ['query']),
    'getCurrentTeam' : IDL.Func([], [Result_18], []),
    'getDataHashes' : IDL.Func([], [Result_17], ['query']),
    'getFantasyTeamSnapshot' : IDL.Func(
        [GetFantasyTeamSnapshotDTO],
        [Result_16],
        [],
      ),
    'getFixtures' : IDL.Func([RequestFixturesDTO], [Result_11], []),
    'getLoanedPlayers' : IDL.Func([ClubFilterDTO], [Result_6], []),
    'getManager' : IDL.Func([RequestManagerDTO], [Result_1], []),
    'getMonthlyLeaderboard' : IDL.Func(
        [GetMonthlyLeaderboardDTO],
        [Result_15],
        [],
      ),
    'getPlayerDetails' : IDL.Func([GetPlayerDetailsDTO], [Result_14], []),
    'getPlayerDetailsForGameweek' : IDL.Func(
        [GameweekFiltersDTO],
        [Result_13],
        [],
      ),
    'getPlayers' : IDL.Func([], [Result_6], []),
    'getPlayersMap' : IDL.Func([GameweekFiltersDTO], [Result_12], []),
    'getPostponedFixtures' : IDL.Func([], [Result_11], []),
    'getProfile' : IDL.Func([], [Result_10], []),
    'getRetiredPlayers' : IDL.Func([ClubFilterDTO], [Result_6], []),
    'getRewardPool' : IDL.Func([GetRewardPoolDTO], [Result_9], []),
    'getSeasonLeaderboard' : IDL.Func(
        [GetSeasonLeaderboardDTO],
        [Result_8],
        [],
      ),
    'getSeasons' : IDL.Func([], [Result_7], []),
    'getSnapshotPlayers' : IDL.Func([GetSnapshotPlayers], [Result_6], []),
    'getSystemState' : IDL.Func([], [Result_5], []),
    'getTopups' : IDL.Func([GetTopupsDTO], [Result_4], []),
    'getTotalManagers' : IDL.Func([], [Result_3], []),
    'getTreasuryAccountPublic' : IDL.Func([], [AccountIdentifier], []),
    'getWeeklyLeaderboard' : IDL.Func(
        [GetWeeklyLeaderboardDTO],
        [Result_2],
        [],
      ),
    'isUsernameValid' : IDL.Func([UsernameFilterDTO], [IDL.Bool], ['query']),
    'saveFantasyTeam' : IDL.Func([UpdateTeamSelectionDTO], [Result], []),
    'searchUsername' : IDL.Func([UsernameFilterDTO], [Result_1], []),
    'setGameweekTimers' : IDL.Func([SeasonId, GameweekNumber], [], []),
    'updateFavouriteClub' : IDL.Func([UpdateFavouriteClubDTO], [Result], []),
    'updateProfilePicture' : IDL.Func([UpdateProfilePictureDTO], [Result], []),
    'updateUsername' : IDL.Func([UpdateUsernameDTO], [Result], []),
    'validateAddInitialFixtures' : IDL.Func(
        [AddInitialFixturesDTO],
        [RustResult],
        ['query'],
      ),
    'validateCreatePlayer' : IDL.Func(
        [CreatePlayerDTO],
        [RustResult],
        ['query'],
      ),
    'validateLoanPlayer' : IDL.Func([LoanPlayerDTO], [RustResult], ['query']),
    'validateMoveFixture' : IDL.Func([MoveFixtureDTO], [RustResult], ['query']),
    'validatePostponeFixture' : IDL.Func(
        [PostponeFixtureDTO],
        [RustResult],
        ['query'],
      ),
    'validatePromoteNewClub' : IDL.Func(
        [PromoteNewClubDTO],
        [RustResult],
        ['query'],
      ),
    'validateRecallPlayer' : IDL.Func(
        [RecallPlayerDTO],
        [RustResult],
        ['query'],
      ),
    'validateRescheduleFixture' : IDL.Func(
        [RescheduleFixtureDTO],
        [RustResult],
        ['query'],
      ),
    'validateRetirePlayer' : IDL.Func(
        [RetirePlayerDTO],
        [RustResult],
        ['query'],
      ),
    'validateRevaluePlayerDown' : IDL.Func(
        [RevaluePlayerDownDTO],
        [RustResult],
        ['query'],
      ),
    'validateRevaluePlayerUp' : IDL.Func(
        [RevaluePlayerUpDTO],
        [RustResult],
        ['query'],
      ),
    'validateSetPlayerInjury' : IDL.Func(
        [SetPlayerInjuryDTO],
        [RustResult],
        ['query'],
      ),
    'validateSubmitFixtureData' : IDL.Func(
        [SubmitFixtureDataDTO],
        [RustResult],
        ['query'],
      ),
    'validateTransferPlayer' : IDL.Func(
        [TransferPlayerDTO],
        [RustResult],
        ['query'],
      ),
    'validateUnretirePlayer' : IDL.Func(
        [UnretirePlayerDTO],
        [RustResult],
        ['query'],
      ),
    'validateUpdateClub' : IDL.Func([UpdateClubDTO], [RustResult], ['query']),
    'validateUpdatePlayer' : IDL.Func(
        [UpdatePlayerDTO],
        [RustResult],
        ['query'],
      ),
  });
};
export const init = ({ IDL }) => { return []; };
