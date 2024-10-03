import type { Principal } from "@dfinity/principal";
import type { ActorMethod } from "@dfinity/agent";
import type { IDL } from "@dfinity/candid";

export type AccountIdentifier = Uint8Array | number[];
export interface AddInitialFixturesDTO {
  seasonId: SeasonId;
  seasonFixtures: Array<FixtureDTO>;
}
export type CalendarMonth = number;
export interface CanisterDTO {
  lastTopup: bigint;
  cycles: bigint;
  canister_type: CanisterType;
  canisterId: CanisterId;
}
export type CanisterId = string;
export type CanisterType =
  | { SNS: null }
  | { MonthlyLeaderboard: null }
  | { Dapp: null }
  | { Archive: null }
  | { SeasonLeaderboard: null }
  | { WeeklyLeaderboard: null }
  | { Manager: null };
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
  leagueId: FootballLeagueId;
}
export type ClubId = number;
export interface CountryDTO {
  id: CountryId;
  code: string;
  name: string;
}
export type CountryId = number;
export interface CreatePlayerDTO {
  clubId: ClubId;
  valueQuarterMillions: number;
  dateOfBirth: bigint;
  nationality: CountryId;
  gender: Gender;
  shirtNumber: number;
  position: PlayerPosition;
  lastName: string;
  leagueId: FootballLeagueId;
  firstName: string;
}
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
  countrymenCountryId: CountryId;
  username: string;
  goalGetterPlayerId: PlayerId;
  hatTrickHeroGameweek: GameweekNumber;
  transfersAvailable: number;
  teamBoostGameweek: GameweekNumber;
  captainFantasticGameweek: GameweekNumber;
  countrymenGameweek: GameweekNumber;
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
  countrymenCountryId: CountryId;
  username: string;
  goalGetterPlayerId: PlayerId;
  hatTrickHeroGameweek: GameweekNumber;
  transfersAvailable: number;
  teamBoostGameweek: GameweekNumber;
  captainFantasticGameweek: GameweekNumber;
  countrymenGameweek: GameweekNumber;
  bankQuarterMillions: number;
  noEntryPlayerId: PlayerId;
  monthlyPoints: number;
  safeHandsPlayerId: PlayerId;
  seasonId: SeasonId;
  braceBonusGameweek: GameweekNumber;
  favouriteClubId: ClubId;
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
export type FootballLeagueId = number;
export interface GameweekFiltersDTO {
  seasonId: SeasonId;
  gameweek: GameweekNumber;
  leagueId: FootballLeagueId;
}
export type GameweekNumber = number;
export type Gender = { Male: null } | { Female: null };
export interface GetCanistersDTO {
  totalEntries: bigint;
  offset: bigint;
  limit: bigint;
  entries: Array<CanisterDTO>;
  canisterTypeFilter: CanisterType;
}
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
  playerId: PlayerId;
  seasonId: SeasonId;
  leagueId: FootballLeagueId;
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
  leagueId: FootballLeagueId;
}
export interface GetTopupsDTO {
  totalEntries: bigint;
  offset: bigint;
  limit: bigint;
  entries: Array<TopupDTO>;
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
export interface LoanPlayerDTO {
  loanEndDate: bigint;
  playerId: PlayerId;
  seasonId: SeasonId;
  loanClubId: ClubId;
  gameweek: GameweekNumber;
  loanLeagueId: FootballLeagueId;
  leagueId: FootballLeagueId;
}
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
export interface MoveFixtureDTO {
  fixtureId: FixtureId;
  updatedFixtureGameweek: GameweekNumber;
  updatedFixtureDate: bigint;
}
export interface PickTeamDTO {
  playerIds: Uint16Array | number[];
  countrymenCountryId: CountryId;
  username: string;
  goalGetterPlayerId: PlayerId;
  hatTrickHeroGameweek: GameweekNumber;
  transfersAvailable: number;
  teamBoostGameweek: GameweekNumber;
  captainFantasticGameweek: GameweekNumber;
  countrymenGameweek: GameweekNumber;
  bankQuarterMillions: number;
  noEntryPlayerId: PlayerId;
  safeHandsPlayerId: PlayerId;
  braceBonusGameweek: GameweekNumber;
  passMasterGameweek: GameweekNumber;
  teamBoostClubId: ClubId;
  goalGetterGameweek: GameweekNumber;
  captainFantasticPlayerId: PlayerId;
  transferWindowGameweek: GameweekNumber;
  noEntryGameweek: GameweekNumber;
  prospectsGameweek: GameweekNumber;
  safeHandsGameweek: GameweekNumber;
  principalId: string;
  passMasterPlayerId: PlayerId;
  captainId: PlayerId;
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
  totalPoints: number;
  position: PlayerPosition;
  lastName: string;
  firstName: string;
}
export interface PlayerDetailDTO {
  id: PlayerId;
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
export interface PostponeFixtureDTO {
  fixtureId: FixtureId;
}
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
export interface PromoteNewClubDTO {
  secondaryColourHex: string;
  name: string;
  friendlyName: string;
  thirdColourHex: string;
  abbreviatedName: string;
  shirtType: ShirtType;
  primaryColourHex: string;
}
export interface RecallPlayerDTO {
  playerId: PlayerId;
  leagueId: FootballLeagueId;
}
export interface RequestFixturesDTO {
  seasonId: SeasonId;
  leagueId: FootballLeagueId;
}
export interface RequestManagerDTO {
  month: CalendarMonth;
  clubId: ClubId;
  seasonId: SeasonId;
  managerId: string;
  gameweek: GameweekNumber;
}
export interface RescheduleFixtureDTO {
  postponedFixtureId: FixtureId;
  updatedFixtureGameweek: GameweekNumber;
  updatedFixtureDate: bigint;
}
export type Result = { ok: null } | { err: Error };
export type Result_1 = { ok: ManagerDTO } | { err: Error };
export type Result_10 = { ok: ProfileDTO } | { err: Error };
export type Result_11 = { ok: Array<FixtureDTO> } | { err: Error };
export type Result_12 =
  | { ok: Array<[number, PlayerScoreDTO]> }
  | { err: Error };
export type Result_13 = { ok: Array<PlayerPointsDTO> } | { err: Error };
export type Result_14 = { ok: PlayerDetailDTO } | { err: Error };
export type Result_15 = { ok: MonthlyLeaderboardDTO } | { err: Error };
export type Result_16 = { ok: FantasyTeamSnapshotDTO } | { err: Error };
export type Result_17 = { ok: Array<DataHashDTO> } | { err: Error };
export type Result_18 = { ok: PickTeamDTO } | { err: Error };
export type Result_19 = { ok: Array<CountryDTO> } | { err: Error };
export type Result_2 = { ok: WeeklyLeaderboardDTO } | { err: Error };
export type Result_20 = { ok: Array<ClubDTO> } | { err: Error };
export type Result_21 = { ok: GetCanistersDTO } | { err: Error };
export type Result_3 = { ok: bigint } | { err: Error };
export type Result_4 = { ok: GetTopupsDTO } | { err: Error };
export type Result_5 = { ok: SystemStateDTO } | { err: Error };
export type Result_6 = { ok: Array<PlayerDTO> } | { err: Error };
export type Result_7 = { ok: Array<SeasonDTO> } | { err: Error };
export type Result_8 = { ok: SeasonLeaderboardDTO } | { err: Error };
export type Result_9 = { ok: GetRewardPoolDTO } | { err: Error };
export interface RetirePlayerDTO {
  playerId: PlayerId;
  retirementDate: bigint;
  leagueId: FootballLeagueId;
}
export interface RevaluePlayerDownDTO {
  playerId: PlayerId;
  seasonId: SeasonId;
  gameweek: GameweekNumber;
  leagueId: FootballLeagueId;
}
export interface RevaluePlayerUpDTO {
  playerId: PlayerId;
  seasonId: SeasonId;
  gameweek: GameweekNumber;
  leagueId: FootballLeagueId;
}
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
export type RustResult = { Ok: string } | { Err: string };
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
export interface SetPlayerInjuryDTO {
  playerId: PlayerId;
  description: string;
  leagueId: FootballLeagueId;
  expectedEndDate: bigint;
}
export type ShirtType = { Filled: null } | { Striped: null };
export interface SubmitFixtureDataDTO {
  fixtureId: FixtureId;
  month: CalendarMonth;
  seasonId: SeasonId;
  gameweek: GameweekNumber;
  playerEventData: Array<PlayerEventData>;
  leagueId: FootballLeagueId;
}
export interface SystemStateDTO {
  pickTeamSeasonId: SeasonId;
  calculationGameweek: GameweekNumber;
  transferWindowActive: boolean;
  pickTeamGameweek: GameweekNumber;
  version: string;
  calculationMonth: CalendarMonth;
  calculationSeasonId: SeasonId;
  onHold: boolean;
  seasonActive: boolean;
}
export interface TopupDTO {
  topupAmount: bigint;
  canisterId: string;
  toppedUpOn: bigint;
}
export interface TransferPlayerDTO {
  clubId: ClubId;
  newLeagueId: FootballLeagueId;
  playerId: PlayerId;
  newShirtNumber: number;
  seasonId: SeasonId;
  newClubId: ClubId;
  gameweek: GameweekNumber;
  leagueId: FootballLeagueId;
}
export interface UnretirePlayerDTO {
  playerId: PlayerId;
  leagueId: FootballLeagueId;
}
export interface UpdateClubDTO {
  clubId: ClubId;
  secondaryColourHex: string;
  name: string;
  friendlyName: string;
  thirdColourHex: string;
  abbreviatedName: string;
  shirtType: ShirtType;
  primaryColourHex: string;
}
export interface UpdateFavouriteClubDTO {
  favouriteClubId: ClubId;
}
export interface UpdatePlayerDTO {
  dateOfBirth: bigint;
  playerId: PlayerId;
  nationality: CountryId;
  shirtNumber: number;
  position: PlayerPosition;
  lastName: string;
  leagueId: FootballLeagueId;
  firstName: string;
}
export interface UpdateProfilePictureDTO {
  profilePicture: Uint8Array | number[];
  extension: string;
}
export interface UpdateTeamSelectionDTO {
  playerIds: Uint16Array | number[];
  countrymenCountryId: CountryId;
  username: string;
  goalGetterPlayerId: PlayerId;
  hatTrickHeroGameweek: GameweekNumber;
  teamBoostGameweek: GameweekNumber;
  captainFantasticGameweek: GameweekNumber;
  countrymenGameweek: GameweekNumber;
  noEntryPlayerId: PlayerId;
  safeHandsPlayerId: PlayerId;
  braceBonusGameweek: GameweekNumber;
  passMasterGameweek: GameweekNumber;
  teamBoostClubId: ClubId;
  goalGetterGameweek: GameweekNumber;
  captainFantasticPlayerId: PlayerId;
  transferWindowGameweek: GameweekNumber;
  noEntryGameweek: GameweekNumber;
  prospectsGameweek: GameweekNumber;
  safeHandsGameweek: GameweekNumber;
  passMasterPlayerId: PlayerId;
  captainId: PlayerId;
}
export interface UpdateUsernameDTO {
  username: string;
}
export interface UsernameFilterDTO {
  username: string;
}
export interface ValueHistory {
  oldValue: number;
  newValue: number;
  seasonId: number;
  gameweek: number;
}
export interface WeeklyLeaderboardDTO {
  totalEntries: bigint;
  seasonId: SeasonId;
  entries: Array<LeaderboardEntry>;
  gameweek: GameweekNumber;
}
export interface _SERVICE {
  executeAddInitialFixtures: ActorMethod<[AddInitialFixturesDTO], undefined>;
  executeCreatePlayer: ActorMethod<[CreatePlayerDTO], undefined>;
  executeLoanPlayer: ActorMethod<[LoanPlayerDTO], undefined>;
  executeMoveFixture: ActorMethod<[MoveFixtureDTO], undefined>;
  executePostponeFixture: ActorMethod<[PostponeFixtureDTO], undefined>;
  executePromoteNewClub: ActorMethod<[PromoteNewClubDTO], undefined>;
  executeRecallPlayer: ActorMethod<[RecallPlayerDTO], undefined>;
  executeRescheduleFixture: ActorMethod<[RescheduleFixtureDTO], undefined>;
  executeRetirePlayer: ActorMethod<[RetirePlayerDTO], undefined>;
  executeRevaluePlayerDown: ActorMethod<[RevaluePlayerDownDTO], undefined>;
  executeRevaluePlayerUp: ActorMethod<[RevaluePlayerUpDTO], undefined>;
  executeSetPlayerInjury: ActorMethod<[SetPlayerInjuryDTO], undefined>;
  executeSubmitFixtureData: ActorMethod<[SubmitFixtureDataDTO], undefined>;
  executeTransferPlayer: ActorMethod<[TransferPlayerDTO], undefined>;
  executeUnretirePlayer: ActorMethod<[UnretirePlayerDTO], undefined>;
  executeUpdateClub: ActorMethod<[UpdateClubDTO], undefined>;
  executeUpdatePlayer: ActorMethod<[UpdatePlayerDTO], undefined>;
  getBackendCanisterBalance: ActorMethod<[], Result_3>;
  getCanisterCyclesAvailable: ActorMethod<[], bigint>;
  getCanisterCyclesBalance: ActorMethod<[], Result_3>;
  getCanisters: ActorMethod<[GetCanistersDTO], Result_21>;
  getClubs: ActorMethod<[], Result_20>;
  getCountries: ActorMethod<[], Result_19>;
  getCurrentTeam: ActorMethod<[], Result_18>;
  getDataHashes: ActorMethod<[], Result_17>;
  getFantasyTeamSnapshot: ActorMethod<[GetFantasyTeamSnapshotDTO], Result_16>;
  getFixtures: ActorMethod<[RequestFixturesDTO], Result_11>;
  getLoanedPlayers: ActorMethod<[ClubFilterDTO], Result_6>;
  getManager: ActorMethod<[RequestManagerDTO], Result_1>;
  getMonthlyLeaderboard: ActorMethod<[GetMonthlyLeaderboardDTO], Result_15>;
  getPlayerDetails: ActorMethod<[GetPlayerDetailsDTO], Result_14>;
  getPlayerDetailsForGameweek: ActorMethod<[GameweekFiltersDTO], Result_13>;
  getPlayers: ActorMethod<[SeasonId], Result_6>;
  getPlayersMap: ActorMethod<[GameweekFiltersDTO], Result_12>;
  getPostponedFixtures: ActorMethod<[], Result_11>;
  getProfile: ActorMethod<[], Result_10>;
  getRetiredPlayers: ActorMethod<[ClubFilterDTO], Result_6>;
  getRewardPool: ActorMethod<[GetRewardPoolDTO], Result_9>;
  getSeasonLeaderboard: ActorMethod<[GetSeasonLeaderboardDTO], Result_8>;
  getSeasons: ActorMethod<[], Result_7>;
  getSnapshotPlayers: ActorMethod<[GetSnapshotPlayers], Result_6>;
  getSystemState: ActorMethod<[], Result_5>;
  getTopups: ActorMethod<[GetTopupsDTO], Result_4>;
  getTotalManagers: ActorMethod<[], Result_3>;
  getTreasuryAccountPublic: ActorMethod<[], AccountIdentifier>;
  getWeeklyLeaderboard: ActorMethod<[GetWeeklyLeaderboardDTO], Result_2>;
  isUsernameValid: ActorMethod<[UsernameFilterDTO], boolean>;
  saveFantasyTeam: ActorMethod<[UpdateTeamSelectionDTO], Result>;
  searchUsername: ActorMethod<[UsernameFilterDTO], Result_1>;
  setGameweekTimers: ActorMethod<[SeasonId, GameweekNumber], undefined>;
  updateFavouriteClub: ActorMethod<[UpdateFavouriteClubDTO], Result>;
  updateProfilePicture: ActorMethod<[UpdateProfilePictureDTO], Result>;
  updateUsername: ActorMethod<[UpdateUsernameDTO], Result>;
  validateAddInitialFixtures: ActorMethod<[AddInitialFixturesDTO], RustResult>;
  validateCreatePlayer: ActorMethod<[CreatePlayerDTO], RustResult>;
  validateLoanPlayer: ActorMethod<[LoanPlayerDTO], RustResult>;
  validateMoveFixture: ActorMethod<[MoveFixtureDTO], RustResult>;
  validatePostponeFixture: ActorMethod<[PostponeFixtureDTO], RustResult>;
  validatePromoteNewClub: ActorMethod<[PromoteNewClubDTO], RustResult>;
  validateRecallPlayer: ActorMethod<[RecallPlayerDTO], RustResult>;
  validateRescheduleFixture: ActorMethod<[RescheduleFixtureDTO], RustResult>;
  validateRetirePlayer: ActorMethod<[RetirePlayerDTO], RustResult>;
  validateRevaluePlayerDown: ActorMethod<[RevaluePlayerDownDTO], RustResult>;
  validateRevaluePlayerUp: ActorMethod<[RevaluePlayerUpDTO], RustResult>;
  validateSetPlayerInjury: ActorMethod<[SetPlayerInjuryDTO], RustResult>;
  validateSubmitFixtureData: ActorMethod<[SubmitFixtureDataDTO], RustResult>;
  validateTransferPlayer: ActorMethod<[TransferPlayerDTO], RustResult>;
  validateUnretirePlayer: ActorMethod<[UnretirePlayerDTO], RustResult>;
  validateUpdateClub: ActorMethod<[UpdateClubDTO], RustResult>;
  validateUpdatePlayer: ActorMethod<[UpdatePlayerDTO], RustResult>;
}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
