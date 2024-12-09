import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';
import type { IDL } from '@dfinity/candid';

export interface AppStatusDTO { 'version' : string, 'onHold' : boolean }
export interface AppStatusDTO__1 { 'version' : string, 'onHold' : boolean }
export type CalendarMonth = number;
export interface CanisterDTO {
  'cycles' : bigint,
  'topups' : Array<CanisterTopup>,
  'computeAllocation' : bigint,
  'canisterId' : CanisterId,
}
export type CanisterId = string;
export interface CanisterTopup {
  'topupTime' : bigint,
  'canisterId' : CanisterId,
  'cyclesAmount' : bigint,
}
export type CanisterType = { 'SNS' : null } |
  { 'Leaderboard' : null } |
  { 'Dapp' : null } |
  { 'Archive' : null } |
  { 'Manager' : null };
export interface ClubDTO {
  'id' : ClubId,
  'secondaryColourHex' : string,
  'name' : string,
  'friendlyName' : string,
  'thirdColourHex' : string,
  'abbreviatedName' : string,
  'shirtType' : ShirtType,
  'primaryColourHex' : string,
}
export interface ClubFilterDTO { 'clubId' : ClubId, 'leagueId' : LeagueId }
export type ClubId = number;
export interface CountryDTO {
  'id' : CountryId,
  'code' : string,
  'name' : string,
}
export type CountryId = number;
export interface DataHashDTO { 'hash' : string, 'category' : string }
export type Error = { 'MoreThan2PlayersFromClub' : null } |
  { 'DecodeError' : null } |
  { 'NotAllowed' : null } |
  { 'DuplicatePlayerInTeam' : null } |
  { 'InvalidBonuses' : null } |
  { 'TooManyTransfers' : null } |
  { 'NotFound' : null } |
  { 'NumberPerPositionError' : null } |
  { 'TeamOverspend' : null } |
  { 'NotAuthorized' : null } |
  { 'SelectedCaptainNotInTeam' : null } |
  { 'InvalidData' : null } |
  { 'SystemOnHold' : null } |
  { 'AlreadyExists' : null } |
  { 'CanisterCreateError' : null } |
  { 'Not11Players' : null };
export interface FantasyTeamSnapshot {
  'playerIds' : Uint16Array | number[],
  'month' : CalendarMonth,
  'teamValueQuarterMillions' : number,
  'username' : string,
  'goalGetterPlayerId' : PlayerId,
  'oneNationCountryId' : CountryId,
  'hatTrickHeroGameweek' : GameweekNumber,
  'transfersAvailable' : number,
  'oneNationGameweek' : GameweekNumber,
  'teamBoostGameweek' : GameweekNumber,
  'captainFantasticGameweek' : GameweekNumber,
  'bankQuarterMillions' : number,
  'noEntryPlayerId' : PlayerId,
  'monthlyPoints' : number,
  'safeHandsPlayerId' : PlayerId,
  'seasonId' : SeasonId,
  'braceBonusGameweek' : GameweekNumber,
  'favouriteClubId' : [] | [ClubId],
  'passMasterGameweek' : GameweekNumber,
  'teamBoostClubId' : ClubId,
  'goalGetterGameweek' : GameweekNumber,
  'captainFantasticPlayerId' : PlayerId,
  'gameweek' : GameweekNumber,
  'seasonPoints' : number,
  'transferWindowGameweek' : GameweekNumber,
  'noEntryGameweek' : GameweekNumber,
  'prospectsGameweek' : GameweekNumber,
  'safeHandsGameweek' : GameweekNumber,
  'principalId' : string,
  'passMasterPlayerId' : PlayerId,
  'captainId' : PlayerId,
  'points' : number,
  'monthlyBonusesAvailable' : number,
}
export interface FantasyTeamSnapshotDTO {
  'playerIds' : Uint16Array | number[],
  'month' : CalendarMonth,
  'teamValueQuarterMillions' : number,
  'username' : string,
  'goalGetterPlayerId' : ClubId,
  'oneNationCountryId' : CountryId,
  'hatTrickHeroGameweek' : GameweekNumber,
  'transfersAvailable' : number,
  'oneNationGameweek' : GameweekNumber,
  'teamBoostGameweek' : GameweekNumber,
  'captainFantasticGameweek' : GameweekNumber,
  'bankQuarterMillions' : number,
  'noEntryPlayerId' : ClubId,
  'monthlyPoints' : number,
  'safeHandsPlayerId' : ClubId,
  'seasonId' : SeasonId,
  'braceBonusGameweek' : GameweekNumber,
  'favouriteClubId' : ClubId,
  'passMasterGameweek' : GameweekNumber,
  'teamBoostClubId' : ClubId,
  'goalGetterGameweek' : GameweekNumber,
  'captainFantasticPlayerId' : ClubId,
  'gameweek' : GameweekNumber,
  'seasonPoints' : number,
  'transferWindowGameweek' : GameweekNumber,
  'noEntryGameweek' : GameweekNumber,
  'prospectsGameweek' : GameweekNumber,
  'safeHandsGameweek' : GameweekNumber,
  'principalId' : string,
  'passMasterPlayerId' : ClubId,
  'captainId' : ClubId,
  'points' : number,
  'monthlyBonusesAvailable' : number,
}
export interface FixtureDTO {
  'id' : number,
  'status' : FixtureStatusType,
  'highestScoringPlayerId' : number,
  'seasonId' : SeasonId,
  'awayClubId' : ClubId,
  'events' : Array<PlayerEventData>,
  'homeClubId' : ClubId,
  'kickOff' : bigint,
  'homeGoals' : number,
  'gameweek' : GameweekNumber,
  'awayGoals' : number,
}
export type FixtureId = number;
export type FixtureStatusType = { 'Unplayed' : null } |
  { 'Finalised' : null } |
  { 'Active' : null } |
  { 'Complete' : null };
export interface GameweekFiltersDTO {
  'seasonId' : SeasonId,
  'gameweek' : GameweekNumber,
}
export type GameweekNumber = number;
export interface GetCanistersDTO { 'canisterType' : CanisterType }
export interface GetFantasyTeamSnapshotDTO {
  'seasonId' : SeasonId,
  'managerPrincipalId' : PrincipalId,
  'gameweek' : GameweekNumber,
}
export interface GetMonthlyLeaderboardDTO {
  'month' : CalendarMonth,
  'clubId' : ClubId,
  'offset' : bigint,
  'seasonId' : SeasonId,
  'limit' : bigint,
  'searchTerm' : string,
}
export interface GetPlayerDetailsDTO {
  'playerId' : ClubId,
  'seasonId' : SeasonId,
}
export interface GetRewardPoolDTO {
  'seasonId' : SeasonId,
  'rewardPool' : RewardPool,
}
export interface GetSeasonLeaderboardDTO {
  'offset' : bigint,
  'seasonId' : SeasonId,
  'limit' : bigint,
  'searchTerm' : string,
}
export interface GetSnapshotPlayers {
  'seasonId' : SeasonId,
  'gameweek' : GameweekNumber,
  'leagueId' : LeagueId,
}
export interface GetWeeklyLeaderboardDTO {
  'offset' : bigint,
  'seasonId' : SeasonId,
  'limit' : bigint,
  'searchTerm' : string,
  'gameweek' : GameweekNumber,
}
export interface InjuryHistory {
  'description' : string,
  'injuryStartDate' : bigint,
  'expectedEndDate' : bigint,
}
export interface LeaderboardEntry {
  'username' : string,
  'positionText' : string,
  'position' : bigint,
  'principalId' : string,
  'points' : number,
}
export type LeagueId = number;
export interface LeagueStatus {
  'transferWindowEndMonth' : number,
  'transferWindowEndDay' : number,
  'transferWindowStartMonth' : number,
  'transferWindowActive' : boolean,
  'totalGameweeks' : number,
  'completedGameweek' : GameweekNumber,
  'transferWindowStartDay' : number,
  'unplayedGameweek' : GameweekNumber,
  'activeMonth' : CalendarMonth,
  'activeSeasonId' : SeasonId,
  'activeGameweek' : GameweekNumber,
  'leagueId' : LeagueId,
  'seasonActive' : boolean,
}
export type List = [] | [[LeaderboardEntry, List]];
export interface ManagerDTO {
  'username' : string,
  'weeklyPosition' : bigint,
  'createDate' : bigint,
  'monthlyPoints' : number,
  'weeklyPoints' : number,
  'weeklyPositionText' : string,
  'gameweeks' : Array<FantasyTeamSnapshot>,
  'favouriteClubId' : [] | [ClubId],
  'monthlyPosition' : bigint,
  'seasonPosition' : bigint,
  'monthlyPositionText' : string,
  'profilePicture' : [] | [Uint8Array | number[]],
  'seasonPoints' : number,
  'profilePictureType' : string,
  'principalId' : string,
  'seasonPositionText' : string,
}
export interface MonthlyLeaderboardDTO {
  'month' : number,
  'clubId' : ClubId,
  'totalEntries' : bigint,
  'seasonId' : SeasonId,
  'entries' : Array<LeaderboardEntry>,
}
export interface PickTeamDTO {
  'playerIds' : Uint16Array | number[],
  'username' : string,
  'goalGetterPlayerId' : ClubId,
  'oneNationCountryId' : CountryId,
  'hatTrickHeroGameweek' : GameweekNumber,
  'transfersAvailable' : number,
  'oneNationGameweek' : GameweekNumber,
  'teamBoostGameweek' : GameweekNumber,
  'captainFantasticGameweek' : GameweekNumber,
  'bankQuarterMillions' : number,
  'noEntryPlayerId' : ClubId,
  'safeHandsPlayerId' : ClubId,
  'braceBonusGameweek' : GameweekNumber,
  'passMasterGameweek' : GameweekNumber,
  'teamBoostClubId' : ClubId,
  'goalGetterGameweek' : GameweekNumber,
  'firstGameweek' : boolean,
  'captainFantasticPlayerId' : ClubId,
  'transferWindowGameweek' : GameweekNumber,
  'noEntryGameweek' : GameweekNumber,
  'prospectsGameweek' : GameweekNumber,
  'safeHandsGameweek' : GameweekNumber,
  'principalId' : string,
  'passMasterPlayerId' : ClubId,
  'captainId' : ClubId,
  'canisterId' : CanisterId,
  'monthlyBonusesAvailable' : number,
}
export interface PlayerDTO {
  'id' : number,
  'status' : PlayerStatus,
  'clubId' : ClubId,
  'valueQuarterMillions' : number,
  'dateOfBirth' : bigint,
  'nationality' : CountryId,
  'shirtNumber' : number,
  'position' : PlayerPosition,
  'lastName' : string,
  'firstName' : string,
}
export interface PlayerDetailDTO {
  'id' : ClubId,
  'status' : PlayerStatus,
  'clubId' : ClubId,
  'parentClubId' : ClubId,
  'valueQuarterMillions' : number,
  'dateOfBirth' : bigint,
  'injuryHistory' : Array<InjuryHistory>,
  'seasonId' : SeasonId,
  'gameweeks' : Array<PlayerGameweekDTO>,
  'nationality' : CountryId,
  'retirementDate' : bigint,
  'valueHistory' : Array<ValueHistory>,
  'latestInjuryEndDate' : bigint,
  'shirtNumber' : number,
  'position' : PlayerPosition,
  'lastName' : string,
  'firstName' : string,
}
export interface PlayerEventData {
  'fixtureId' : FixtureId,
  'clubId' : ClubId,
  'playerId' : number,
  'eventStartMinute' : number,
  'eventEndMinute' : number,
  'eventType' : PlayerEventType,
}
export type PlayerEventType = { 'PenaltyMissed' : null } |
  { 'Goal' : null } |
  { 'GoalConceded' : null } |
  { 'Appearance' : null } |
  { 'PenaltySaved' : null } |
  { 'RedCard' : null } |
  { 'KeeperSave' : null } |
  { 'CleanSheet' : null } |
  { 'YellowCard' : null } |
  { 'GoalAssisted' : null } |
  { 'OwnGoal' : null } |
  { 'HighestScoringPlayer' : null };
export interface PlayerGameweekDTO {
  'fixtureId' : FixtureId,
  'events' : Array<PlayerEventData>,
  'number' : number,
  'points' : number,
}
export type PlayerId = number;
export interface PlayerPointsDTO {
  'id' : number,
  'clubId' : ClubId,
  'events' : Array<PlayerEventData>,
  'position' : PlayerPosition,
  'gameweek' : GameweekNumber,
  'points' : number,
}
export type PlayerPosition = { 'Goalkeeper' : null } |
  { 'Midfielder' : null } |
  { 'Forward' : null } |
  { 'Defender' : null };
export interface PlayerScoreDTO {
  'id' : number,
  'clubId' : ClubId,
  'assists' : number,
  'dateOfBirth' : bigint,
  'nationality' : CountryId,
  'goalsScored' : number,
  'saves' : number,
  'goalsConceded' : number,
  'events' : Array<PlayerEventData>,
  'position' : PlayerPosition,
  'points' : number,
}
export type PlayerStatus = { 'OnLoan' : null } |
  { 'Active' : null } |
  { 'FreeAgent' : null } |
  { 'Retired' : null };
export type PrincipalId = string;
export interface ProfileDTO {
  'username' : string,
  'termsAccepted' : boolean,
  'createDate' : bigint,
  'favouriteClubId' : [] | [ClubId],
  'profilePicture' : [] | [Uint8Array | number[]],
  'profilePictureType' : string,
  'principalId' : string,
}
export interface RequestManagerDTO {
  'month' : CalendarMonth,
  'clubId' : ClubId,
  'seasonId' : SeasonId,
  'managerId' : string,
  'gameweek' : GameweekNumber,
}
export type Result = { 'ok' : null } |
  { 'err' : Error };
export type Result_1 = { 'ok' : ManagerDTO } |
  { 'err' : Error };
export type Result_10 = { 'ok' : GetRewardPoolDTO } |
  { 'err' : Error };
export type Result_11 = { 'ok' : ProfileDTO } |
  { 'err' : Error };
export type Result_12 = { 'ok' : Array<FixtureDTO> } |
  { 'err' : Error };
export type Result_13 = { 'ok' : Array<[number, PlayerScoreDTO]> } |
  { 'err' : Error };
export type Result_14 = { 'ok' : Array<PlayerPointsDTO> } |
  { 'err' : Error };
export type Result_15 = { 'ok' : PlayerDetailDTO } |
  { 'err' : Error };
export type Result_16 = { 'ok' : MonthlyLeaderboardDTO } |
  { 'err' : Error };
export type Result_17 = { 'ok' : Array<CanisterId> } |
  { 'err' : Error };
export type Result_18 = { 'ok' : LeagueStatus } |
  { 'err' : Error };
export type Result_19 = { 'ok' : FantasyTeamSnapshotDTO } |
  { 'err' : Error };
export type Result_2 = { 'ok' : WeeklyRewardsDTO } |
  { 'err' : Error };
export type Result_20 = { 'ok' : Array<DataHashDTO> } |
  { 'err' : Error };
export type Result_21 = { 'ok' : PickTeamDTO } |
  { 'err' : Error };
export type Result_22 = { 'ok' : Array<CountryDTO> } |
  { 'err' : Error };
export type Result_23 = { 'ok' : Array<ClubDTO> } |
  { 'err' : Error };
export type Result_24 = { 'ok' : Array<CanisterDTO> } |
  { 'err' : Error };
export type Result_25 = { 'ok' : AppStatusDTO__1 } |
  { 'err' : Error };
export type Result_26 = { 'ok' : string } |
  { 'err' : Error };
export type Result_3 = { 'ok' : WeeklyLeaderboardDTO } |
  { 'err' : Error };
export type Result_4 = {
    'ok' : Array<[SeasonId, Array<[GameweekNumber, CanisterId]>]>
  } |
  { 'err' : Error };
export type Result_5 = { 'ok' : Array<PlayerDTO> } |
  { 'err' : Error };
export type Result_6 = { 'ok' : bigint } |
  { 'err' : Error };
export type Result_7 = { 'ok' : AppStatusDTO } |
  { 'err' : Error };
export type Result_8 = { 'ok' : Array<SeasonDTO> } |
  { 'err' : Error };
export type Result_9 = { 'ok' : SeasonLeaderboardDTO } |
  { 'err' : Error };
export interface RewardEntry {
  'rewardType' : RewardType,
  'position' : bigint,
  'amount' : bigint,
  'principalId' : string,
}
export interface RewardPool {
  'monthlyLeaderboardPool' : bigint,
  'allTimeSeasonHighScorePool' : bigint,
  'mostValuableTeamPool' : bigint,
  'highestScoringMatchPlayerPool' : bigint,
  'seasonId' : SeasonId,
  'seasonLeaderboardPool' : bigint,
  'allTimeWeeklyHighScorePool' : bigint,
  'allTimeMonthlyHighScorePool' : bigint,
  'weeklyLeaderboardPool' : bigint,
}
export type RewardType = { 'MonthlyLeaderboard' : null } |
  { 'MostValuableTeam' : null } |
  { 'MonthlyATHScore' : null } |
  { 'WeeklyATHScore' : null } |
  { 'SeasonATHScore' : null } |
  { 'SeasonLeaderboard' : null } |
  { 'WeeklyLeaderboard' : null } |
  { 'HighestScoringPlayer' : null };
export interface SeasonDTO { 'id' : SeasonId, 'name' : string, 'year' : number }
export type SeasonId = number;
export interface SeasonLeaderboardDTO {
  'totalEntries' : bigint,
  'seasonId' : SeasonId,
  'entries' : Array<LeaderboardEntry>,
}
export type ShirtType = { 'Filled' : null } |
  { 'Striped' : null };
export interface UpdateAppStatusDTO { 'version' : string, 'onHold' : boolean }
export interface UpdateFavouriteClubDTO { 'favouriteClubId' : ClubId }
export interface UpdateProfilePictureDTO {
  'profilePicture' : Uint8Array | number[],
  'extension' : string,
}
export interface UpdateTeamSelectionDTO {
  'playerIds' : Uint16Array | number[],
  'username' : string,
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
}
export interface UpdateUsernameDTO { 'username' : string }
export interface UsernameFilterDTO { 'username' : string }
export interface ValueHistory {
  'oldValue' : number,
  'changedOn' : bigint,
  'newValue' : number,
}
export interface WeeklyLeaderboard {
  'totalEntries' : bigint,
  'seasonId' : SeasonId,
  'entries' : List,
  'gameweek' : GameweekNumber,
}
export interface WeeklyLeaderboardDTO {
  'totalEntries' : bigint,
  'seasonId' : SeasonId,
  'entries' : Array<LeaderboardEntry>,
  'gameweek' : GameweekNumber,
}
export interface WeeklyRewardsDTO {
  'seasonId' : SeasonId,
  'rewards' : Array<RewardEntry>,
  'gameweek' : GameweekNumber,
}
export interface _SERVICE {
  'calculateGameweekScores' : ActorMethod<[], Result>,
  'calculateLeaderboards' : ActorMethod<[], Result>,
  'calculateWeeklyRewards' : ActorMethod<[GameweekNumber], Result>,
  'getActiveLeaderboardCanisterId' : ActorMethod<[], Result_26>,
  'getAppStatus' : ActorMethod<[], Result_25>,
  'getCanisters' : ActorMethod<[GetCanistersDTO], Result_24>,
  'getClubs' : ActorMethod<[], Result_23>,
  'getCountries' : ActorMethod<[], Result_22>,
  'getCurrentTeam' : ActorMethod<[], Result_21>,
  'getDataHashes' : ActorMethod<[], Result_20>,
  'getFantasyTeamSnapshot' : ActorMethod<
    [GetFantasyTeamSnapshotDTO],
    Result_19
  >,
  'getFixtures' : ActorMethod<[LeagueId], Result_12>,
  'getLeaderboardCanisterIds' : ActorMethod<[], Result_17>,
  'getLeagueStatus' : ActorMethod<[], Result_18>,
  'getLoanedPlayers' : ActorMethod<[ClubFilterDTO], Result_5>,
  'getManager' : ActorMethod<[RequestManagerDTO], Result_1>,
  'getManagerCanisterIds' : ActorMethod<[], Result_17>,
  'getMonthlyLeaderboard' : ActorMethod<[GetMonthlyLeaderboardDTO], Result_16>,
  'getPlayerDetails' : ActorMethod<[GetPlayerDetailsDTO], Result_15>,
  'getPlayerDetailsForGameweek' : ActorMethod<[GameweekFiltersDTO], Result_14>,
  'getPlayers' : ActorMethod<[], Result_5>,
  'getPlayersMap' : ActorMethod<[GameweekFiltersDTO], Result_13>,
  'getPlayersSnapshot' : ActorMethod<[GetSnapshotPlayers], Array<PlayerDTO>>,
  'getPostponedFixtures' : ActorMethod<[LeagueId], Result_12>,
  'getProfile' : ActorMethod<[], Result_11>,
  'getRetiredPlayers' : ActorMethod<[ClubFilterDTO], Result_5>,
  'getRewardPool' : ActorMethod<[GetRewardPoolDTO], Result_10>,
  'getSeasonLeaderboard' : ActorMethod<[GetSeasonLeaderboardDTO], Result_9>,
  'getSeasons' : ActorMethod<[], Result_8>,
  'getSystemState' : ActorMethod<[], Result_7>,
  'getTotalManagers' : ActorMethod<[], Result_6>,
  'getVerifiedPlayers' : ActorMethod<[], Result_5>,
  'getWeeklyCanisters' : ActorMethod<[], Result_4>,
  'getWeeklyLeaderboard' : ActorMethod<[GetWeeklyLeaderboardDTO], Result_3>,
  'getWeeklyLeaderboards' : ActorMethod<[], Array<WeeklyLeaderboard>>,
  'getWeeklyRewards' : ActorMethod<[SeasonId, GameweekNumber], Result_2>,
  'isUsernameValid' : ActorMethod<[UsernameFilterDTO], boolean>,
  'notifyAppsOfLoan' : ActorMethod<[LeagueId, PlayerId], Result>,
  'notifyAppsOfPositionChange' : ActorMethod<[LeagueId, PlayerId], Result>,
  'notifyAppsOfTransfer' : ActorMethod<[LeagueId, PlayerId], Result>,
  'payWeeklyRewards' : ActorMethod<[GameweekNumber], Result>,
  'saveFantasyTeam' : ActorMethod<[UpdateTeamSelectionDTO], Result>,
  'searchUsername' : ActorMethod<[UsernameFilterDTO], Result_1>,
  'snapshotManagers' : ActorMethod<[], Result>,
  'updateDataHashes' : ActorMethod<[string], Result>,
  'updateFavouriteClub' : ActorMethod<[UpdateFavouriteClubDTO], Result>,
  'updateProfilePicture' : ActorMethod<[UpdateProfilePictureDTO], Result>,
  'updateSystemState' : ActorMethod<[UpdateAppStatusDTO], Result>,
  'updateUsername' : ActorMethod<[UpdateUsernameDTO], Result>,
}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
