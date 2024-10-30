import type { Principal } from "@dfinity/principal";
import type { ActorMethod } from "@dfinity/agent";
import type { IDL } from "@dfinity/candid";

export type CalendarMonth = number;
export type CanisterId = string;
export interface ClubDTO {
  id: ClubId;
  secondaryColourHex: string;
  name: string;
  friendlyName: string;
  thirdColourHex: string;
  abbreviatedName: string;
  shirtType: ShirtType;
  primaryColourHex: string;
}
export interface ClubFilterDTO {
  clubId: ClubId;
  leagueId: LeagueId;
}
export type ClubId = number;
export interface CountryDTO {
  id: CountryId;
  code: string;
  name: string;
}
export type CountryId = number;
export interface DataHashDTO {
  hash: string;
  category: string;
}
export type Error =
  | { MoreThan2PlayersFromClub: null }
  | { DecodeError: null }
  | { NotAllowed: null }
  | { DuplicatePlayerInTeam: null }
  | { InvalidBonuses: null }
  | { TooManyTransfers: null }
  | { NotFound: null }
  | { NumberPerPositionError: null }
  | { TeamOverspend: null }
  | { NotAuthorized: null }
  | { SelectedCaptainNotInTeam: null }
  | { InvalidData: null }
  | { SystemOnHold: null }
  | { AlreadyExists: null }
  | { CanisterCreateError: null }
  | { Not11Players: null };
export interface FantasyTeamSnapshot {
  playerIds: Uint16Array | number[];
  month: CalendarMonth;
  teamValueQuarterMillions: number;
  username: string;
  goalGetterPlayerId: PlayerId;
  oneNationCountryId: CountryId;
  hatTrickHeroGameweek: GameweekNumber;
  transfersAvailable: number;
  oneNationGameweek: GameweekNumber;
  teamBoostGameweek: GameweekNumber;
  captainFantasticGameweek: GameweekNumber;
  bankQuarterMillions: number;
  noEntryPlayerId: PlayerId;
  monthlyPoints: number;
  safeHandsPlayerId: PlayerId;
  seasonId: SeasonId;
  braceBonusGameweek: GameweekNumber;
  favouriteClubId: [] | [ClubId];
  passMasterGameweek: GameweekNumber;
  teamBoostClubId: ClubId;
  goalGetterGameweek: GameweekNumber;
  captainFantasticPlayerId: PlayerId;
  gameweek: GameweekNumber;
  seasonPoints: number;
  transferWindowGameweek: GameweekNumber;
  noEntryGameweek: GameweekNumber;
  prospectsGameweek: GameweekNumber;
  safeHandsGameweek: GameweekNumber;
  principalId: string;
  passMasterPlayerId: PlayerId;
  captainId: PlayerId;
  points: number;
  monthlyBonusesAvailable: number;
}
export interface FantasyTeamSnapshotDTO {
  playerIds: Uint16Array | number[];
  month: CalendarMonth;
  teamValueQuarterMillions: number;
  username: string;
  goalGetterPlayerId: ClubId;
  oneNationCountryId: CountryId;
  hatTrickHeroGameweek: GameweekNumber;
  transfersAvailable: number;
  oneNationGameweek: GameweekNumber;
  teamBoostGameweek: GameweekNumber;
  captainFantasticGameweek: GameweekNumber;
  bankQuarterMillions: number;
  noEntryPlayerId: ClubId;
  monthlyPoints: number;
  safeHandsPlayerId: ClubId;
  seasonId: SeasonId;
  braceBonusGameweek: GameweekNumber;
  favouriteClubId: ClubId;
  passMasterGameweek: GameweekNumber;
  teamBoostClubId: ClubId;
  goalGetterGameweek: GameweekNumber;
  captainFantasticPlayerId: ClubId;
  gameweek: GameweekNumber;
  seasonPoints: number;
  transferWindowGameweek: GameweekNumber;
  noEntryGameweek: GameweekNumber;
  prospectsGameweek: GameweekNumber;
  safeHandsGameweek: GameweekNumber;
  principalId: string;
  passMasterPlayerId: ClubId;
  captainId: ClubId;
  points: number;
  monthlyBonusesAvailable: number;
}
export interface FixtureDTO {
  id: number;
  status: FixtureStatusType;
  highestScoringPlayerId: number;
  seasonId: SeasonId;
  awayClubId: ClubId;
  events: Array<PlayerEventData>;
  homeClubId: ClubId;
  kickOff: bigint;
  homeGoals: number;
  gameweek: GameweekNumber;
  awayGoals: number;
}
export type FixtureId = number;
export type FixtureStatusType =
  | { Unplayed: null }
  | { Finalised: null }
  | { Active: null }
  | { Complete: null };
export interface GameweekFiltersDTO {
  seasonId: SeasonId;
  gameweek: GameweekNumber;
}
export type GameweekNumber = number;
export interface GetFantasyTeamSnapshotDTO {
  seasonId: SeasonId;
  managerPrincipalId: PrincipalId;
  gameweek: GameweekNumber;
}
export interface GetMonthlyLeaderboardDTO {
  month: CalendarMonth;
  clubId: ClubId;
  offset: bigint;
  seasonId: SeasonId;
  limit: bigint;
  searchTerm: string;
}
export interface GetPlayerDetailsDTO {
  playerId: ClubId;
  seasonId: SeasonId;
}
export interface GetRewardPoolDTO {
  seasonId: SeasonId;
  rewardPool: RewardPool;
}
export interface GetSeasonLeaderboardDTO {
  offset: bigint;
  seasonId: SeasonId;
  limit: bigint;
  searchTerm: string;
}
export interface GetSnapshotPlayers {
  seasonId: SeasonId;
  gameweek: GameweekNumber;
  leagueId: LeagueId;
}
export interface GetWeeklyLeaderboardDTO {
  offset: bigint;
  seasonId: SeasonId;
  limit: bigint;
  searchTerm: string;
  gameweek: GameweekNumber;
}
export interface InjuryHistory {
  description: string;
  injuryStartDate: bigint;
  expectedEndDate: bigint;
}
export interface LeaderboardEntry {
  username: string;
  positionText: string;
  position: bigint;
  principalId: string;
  points: number;
}
export type LeagueId = number;
export interface ManagerDTO {
  username: string;
  weeklyPosition: bigint;
  createDate: bigint;
  monthlyPoints: number;
  weeklyPoints: number;
  weeklyPositionText: string;
  gameweeks: Array<FantasyTeamSnapshot>;
  favouriteClubId: [] | [ClubId];
  monthlyPosition: bigint;
  seasonPosition: bigint;
  monthlyPositionText: string;
  profilePicture: [] | [Uint8Array | number[]];
  seasonPoints: number;
  principalId: string;
  seasonPositionText: string;
}
export interface MonthlyLeaderboardDTO {
  month: number;
  clubId: ClubId;
  totalEntries: bigint;
  seasonId: SeasonId;
  entries: Array<LeaderboardEntry>;
}
export interface PickTeamDTO {
  playerIds: Uint16Array | number[];
  username: string;
  goalGetterPlayerId: ClubId;
  oneNationCountryId: CountryId;
  hatTrickHeroGameweek: GameweekNumber;
  transfersAvailable: number;
  oneNationGameweek: GameweekNumber;
  teamBoostGameweek: GameweekNumber;
  captainFantasticGameweek: GameweekNumber;
  bankQuarterMillions: number;
  noEntryPlayerId: ClubId;
  safeHandsPlayerId: ClubId;
  braceBonusGameweek: GameweekNumber;
  passMasterGameweek: GameweekNumber;
  teamBoostClubId: ClubId;
  goalGetterGameweek: GameweekNumber;
  firstGameweek: boolean;
  captainFantasticPlayerId: ClubId;
  transferWindowGameweek: GameweekNumber;
  noEntryGameweek: GameweekNumber;
  prospectsGameweek: GameweekNumber;
  safeHandsGameweek: GameweekNumber;
  principalId: string;
  passMasterPlayerId: ClubId;
  captainId: ClubId;
  canisterId: CanisterId;
  monthlyBonusesAvailable: number;
}
export interface PlayerDTO {
  id: number;
  status: PlayerStatus;
  clubId: ClubId;
  valueQuarterMillions: number;
  dateOfBirth: bigint;
  nationality: CountryId;
  shirtNumber: number;
  position: PlayerPosition;
  lastName: string;
  firstName: string;
}
export interface PlayerDetailDTO {
  id: ClubId;
  status: PlayerStatus;
  clubId: ClubId;
  parentClubId: ClubId;
  valueQuarterMillions: number;
  dateOfBirth: bigint;
  injuryHistory: Array<InjuryHistory>;
  seasonId: SeasonId;
  gameweeks: Array<PlayerGameweekDTO>;
  nationality: CountryId;
  retirementDate: bigint;
  valueHistory: Array<ValueHistory>;
  latestInjuryEndDate: bigint;
  shirtNumber: number;
  position: PlayerPosition;
  lastName: string;
  firstName: string;
}
export interface PlayerEventData {
  fixtureId: FixtureId;
  clubId: ClubId;
  playerId: number;
  eventStartMinute: number;
  eventEndMinute: number;
  eventType: PlayerEventType;
}
export type PlayerEventType =
  | { PenaltyMissed: null }
  | { Goal: null }
  | { GoalConceded: null }
  | { Appearance: null }
  | { PenaltySaved: null }
  | { RedCard: null }
  | { KeeperSave: null }
  | { CleanSheet: null }
  | { YellowCard: null }
  | { GoalAssisted: null }
  | { OwnGoal: null }
  | { HighestScoringPlayer: null };
export interface PlayerGameweekDTO {
  fixtureId: FixtureId;
  events: Array<PlayerEventData>;
  number: number;
  points: number;
}
export type PlayerId = number;
export interface PlayerPointsDTO {
  id: number;
  clubId: ClubId;
  events: Array<PlayerEventData>;
  position: PlayerPosition;
  gameweek: GameweekNumber;
  points: number;
}
export type PlayerPosition =
  | { Goalkeeper: null }
  | { Midfielder: null }
  | { Forward: null }
  | { Defender: null };
export interface PlayerScoreDTO {
  id: number;
  clubId: ClubId;
  assists: number;
  dateOfBirth: bigint;
  nationality: CountryId;
  goalsScored: number;
  saves: number;
  goalsConceded: number;
  events: Array<PlayerEventData>;
  position: PlayerPosition;
  points: number;
}
export type PlayerStatus =
  | { OnLoan: null }
  | { Active: null }
  | { FreeAgent: null }
  | { Retired: null };
export type PrincipalId = string;
export interface ProfileDTO {
  username: string;
  termsAccepted: boolean;
  createDate: bigint;
  favouriteClubId: [] | [ClubId];
  profilePicture: [] | [Uint8Array | number[]];
  profilePictureType: string;
  principalId: string;
}
export interface RequestFixturesDTO {
  seasonId: SeasonId;
  leagueId: LeagueId;
}
export interface RequestManagerDTO {
  month: CalendarMonth;
  clubId: ClubId;
  seasonId: SeasonId;
  managerId: string;
  gameweek: GameweekNumber;
}
export type Result = { ok: null } | { err: Error };
export type Result_1 = { ok: ManagerDTO } | { err: Error };
export type Result_10 = { ok: Array<FixtureDTO> } | { err: Error };
export type Result_11 =
  | { ok: Array<[number, PlayerScoreDTO]> }
  | { err: Error };
export type Result_12 = { ok: Array<PlayerPointsDTO> } | { err: Error };
export type Result_13 = { ok: PlayerDetailDTO } | { err: Error };
export type Result_14 = { ok: MonthlyLeaderboardDTO } | { err: Error };
export type Result_15 = { ok: Array<CanisterId> } | { err: Error };
export type Result_16 = { ok: FantasyTeamSnapshotDTO } | { err: Error };
export type Result_17 = { ok: Array<DataHashDTO> } | { err: Error };
export type Result_18 = { ok: PickTeamDTO } | { err: Error };
export type Result_19 = { ok: Array<CountryDTO> } | { err: Error };
export type Result_2 = { ok: WeeklyLeaderboardDTO } | { err: Error };
export type Result_20 = { ok: Array<ClubDTO> } | { err: Error };
export type Result_21 = { ok: string } | { err: Error };
export type Result_3 = { ok: Array<PlayerDTO> } | { err: Error };
export type Result_4 = { ok: bigint } | { err: Error };
export type Result_5 = { ok: SystemStateDTO } | { err: Error };
export type Result_6 = { ok: Array<SeasonDTO> } | { err: Error };
export type Result_7 = { ok: SeasonLeaderboardDTO } | { err: Error };
export type Result_8 = { ok: GetRewardPoolDTO } | { err: Error };
export type Result_9 = { ok: ProfileDTO } | { err: Error };
export interface RewardPool {
  monthlyLeaderboardPool: bigint;
  allTimeSeasonHighScorePool: bigint;
  mostValuableTeamPool: bigint;
  highestScoringMatchPlayerPool: bigint;
  seasonId: SeasonId;
  seasonLeaderboardPool: bigint;
  allTimeWeeklyHighScorePool: bigint;
  allTimeMonthlyHighScorePool: bigint;
  weeklyLeaderboardPool: bigint;
}
export interface SeasonDTO {
  id: SeasonId;
  name: string;
  year: number;
}
export type SeasonId = number;
export interface SeasonLeaderboardDTO {
  totalEntries: bigint;
  seasonId: SeasonId;
  entries: Array<LeaderboardEntry>;
}
export type ShirtType = { Filled: null } | { Striped: null };
export interface SystemStateDTO {
  pickTeamSeasonId: SeasonId;
  calculationGameweek: GameweekNumber;
  transferWindowActive: boolean;
  pickTeamMonth: CalendarMonth;
  pickTeamGameweek: GameweekNumber;
  version: string;
  calculationMonth: CalendarMonth;
  calculationSeasonId: SeasonId;
  onHold: boolean;
  seasonActive: boolean;
}
export interface UpdateFavouriteClubDTO {
  favouriteClubId: ClubId;
}
export interface UpdateProfilePictureDTO {
  profilePicture: Uint8Array | number[];
  extension: string;
}
export interface UpdateSystemStateDTO {
  pickTeamSeasonId: SeasonId;
  calculationGameweek: GameweekNumber;
  transferWindowActive: boolean;
  pickTeamMonth: CalendarMonth;
  pickTeamGameweek: GameweekNumber;
  version: string;
  calculationMonth: CalendarMonth;
  calculationSeasonId: SeasonId;
  onHold: boolean;
  seasonActive: boolean;
}
export interface UpdateTeamSelectionDTO {
  playerIds: Uint16Array | number[];
  username: string;
  goalGetterPlayerId: ClubId;
  oneNationCountryId: CountryId;
  hatTrickHeroGameweek: GameweekNumber;
  oneNationGameweek: GameweekNumber;
  teamBoostGameweek: GameweekNumber;
  captainFantasticGameweek: GameweekNumber;
  noEntryPlayerId: ClubId;
  safeHandsPlayerId: ClubId;
  braceBonusGameweek: GameweekNumber;
  passMasterGameweek: GameweekNumber;
  teamBoostClubId: ClubId;
  goalGetterGameweek: GameweekNumber;
  captainFantasticPlayerId: ClubId;
  transferWindowGameweek: GameweekNumber;
  noEntryGameweek: GameweekNumber;
  prospectsGameweek: GameweekNumber;
  safeHandsGameweek: GameweekNumber;
  passMasterPlayerId: ClubId;
  captainId: ClubId;
}
export interface UpdateUsernameDTO {
  username: string;
}
export interface UsernameFilterDTO {
  username: string;
}
export interface ValueHistory {
  oldValue: number;
  changedOn: bigint;
  newValue: number;
}
export interface WeeklyLeaderboardDTO {
  totalEntries: bigint;
  seasonId: SeasonId;
  entries: Array<LeaderboardEntry>;
  gameweek: GameweekNumber;
}
export interface _SERVICE {
  calculateGameweekScores: ActorMethod<[], Result>;
  calculateLeaderboards: ActorMethod<[], Result>;
  getActiveLeaderboardCanisterId: ActorMethod<[], Result_21>;
  getClubs: ActorMethod<[], Result_20>;
  getCountries: ActorMethod<[], Result_19>;
  getCurrentTeam: ActorMethod<[], Result_18>;
  getDataHashes: ActorMethod<[], Result_17>;
  getFantasyTeamSnapshot: ActorMethod<[GetFantasyTeamSnapshotDTO], Result_16>;
  getFixtures: ActorMethod<[RequestFixturesDTO], Result_10>;
  getLeaderboardCanisterIds: ActorMethod<[], Result_15>;
  getLoanedPlayers: ActorMethod<[ClubFilterDTO], Result_3>;
  getManager: ActorMethod<[RequestManagerDTO], Result_1>;
  getManagerCanisterIds: ActorMethod<[], Result_15>;
  getMonthlyLeaderboard: ActorMethod<[GetMonthlyLeaderboardDTO], Result_14>;
  getPlayerDetails: ActorMethod<[GetPlayerDetailsDTO], Result_13>;
  getPlayerDetailsForGameweek: ActorMethod<[GameweekFiltersDTO], Result_12>;
  getPlayers: ActorMethod<[], Result_3>;
  getPlayersMap: ActorMethod<[GameweekFiltersDTO], Result_11>;
  getPlayersSnapshot: ActorMethod<[GetSnapshotPlayers], Array<PlayerDTO>>;
  getPostponedFixtures: ActorMethod<[], Result_10>;
  getProfile: ActorMethod<[], Result_9>;
  getRetiredPlayers: ActorMethod<[ClubFilterDTO], Result_3>;
  getRewardPool: ActorMethod<[GetRewardPoolDTO], Result_8>;
  getSeasonLeaderboard: ActorMethod<[GetSeasonLeaderboardDTO], Result_7>;
  getSeasons: ActorMethod<[], Result_6>;
  getSystemState: ActorMethod<[], Result_5>;
  getTotalManagers: ActorMethod<[], Result_4>;
  getVerifiedPlayers: ActorMethod<[], Result_3>;
  getWeeklyLeaderboard: ActorMethod<[GetWeeklyLeaderboardDTO], Result_2>;
  isUsernameValid: ActorMethod<[UsernameFilterDTO], boolean>;
  notifyAppsOfLoan: ActorMethod<[LeagueId, PlayerId], Result>;
  notifyAppsOfPositionChange: ActorMethod<[LeagueId, PlayerId], Result>;
  saveFantasyTeam: ActorMethod<[UpdateTeamSelectionDTO], Result>;
  searchUsername: ActorMethod<[UsernameFilterDTO], Result_1>;
  snapshotManagers: ActorMethod<[], Result>;
  updateDataHashes: ActorMethod<[string], Result>;
  updateFavouriteClub: ActorMethod<[UpdateFavouriteClubDTO], Result>;
  updateProfilePicture: ActorMethod<[UpdateProfilePictureDTO], Result>;
  updateSystemState: ActorMethod<[UpdateSystemStateDTO], Result>;
  updateUsername: ActorMethod<[UpdateUsernameDTO], Result>;
}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
