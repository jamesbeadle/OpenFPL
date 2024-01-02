import type { ActorMethod } from "@dfinity/agent";

export interface AddInitialFixturesDTO {
  seasonId: SeasonId;
  seasonFixtures: Array<FixtureDTO>;
}
export interface AdminClubList {
  totalEntries: bigint;
  clubs: Array<ClubDTO>;
  offset: bigint;
  limit: bigint;
}
export interface AdminFixtureList {
  seasonId: SeasonId;
  fixtures: Array<FixtureDTO>;
}
export interface AdminMainCanisterInfo {
  cycles: bigint;
  canisterId: string;
}
export interface AdminMonthlyCanisterList {
  totalEntries: bigint;
  offset: bigint;
  limit: bigint;
  canisters: Array<MonthlyCanisterDTO>;
}
export interface AdminPlayerList {
  playerStatus: PlayerStatus;
  players: Array<PlayerDTO>;
}
export interface AdminProfileList {
  totalEntries: bigint;
  offset: bigint;
  limit: bigint;
  profiles: Array<ProfileDTO>;
}
export interface AdminProfilePictureCanisterList {
  totalEntries: bigint;
  canisters: Array<ProfileCanisterDTO>;
}
export interface AdminSeasonCanisterList {
  totalEntries: bigint;
  offset: bigint;
  limit: bigint;
  canisters: Array<SeasonCanisterDTO>;
}
export interface AdminTimerList {
  timers: Array<TimerDTO>;
  totalEntries: bigint;
  offset: bigint;
  limit: bigint;
}
export interface AdminWeeklyCanisterList {
  totalEntries: bigint;
  offset: bigint;
  limit: bigint;
  canisters: Array<WeeklyCanisterDTO>;
}
export type CalendarMonth = number;
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
  shirtNumber: number;
  position: PlayerPosition;
  lastName: string;
  firstName: string;
}
export interface DataCacheDTO {
  hash: string;
  category: string;
}
export type Error =
  | { DecodeError: null }
  | { NotAllowed: null }
  | { NotFound: null }
  | { NotAuthorized: null }
  | { InvalidData: null }
  | { SystemOnHold: null }
  | { AlreadyExists: null }
  | { InvalidTeamError: null };
export interface FantasyTeamSeason {
  seasonId: SeasonId;
  gameweeks: List_1;
  totalPoints: number;
}
export interface FantasyTeamSnapshot {
  playerIds: Uint16Array | number[];
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
  safeHandsPlayerId: PlayerId;
  braceBonusGameweek: GameweekNumber;
  favouriteClubId: ClubId;
  passMasterGameweek: GameweekNumber;
  teamBoostClubId: ClubId;
  goalGetterGameweek: GameweekNumber;
  captainFantasticPlayerId: PlayerId;
  gameweek: GameweekNumber;
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
export type GameweekNumber = number;
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
export type List = [] | [[FantasyTeamSeason, List]];
export type List_1 = [] | [[FantasyTeamSnapshot, List_1]];
export type List_2 = [] | [[PlayerEventData, List_2]];
export interface LoanPlayerDTO {
  loanEndDate: bigint;
  playerId: PlayerId;
  loanClubId: ClubId;
}
export interface ManagerDTO {
  username: string;
  weeklyPosition: bigint;
  createDate: bigint;
  monthlyPoints: number;
  weeklyPoints: number;
  weeklyPositionText: string;
  gameweeks: Array<FantasyTeamSnapshot>;
  favouriteClubId: ClubId;
  monthlyPosition: bigint;
  seasonPosition: bigint;
  monthlyPositionText: string;
  profilePicture: Uint8Array | number[];
  seasonPoints: number;
  principalId: string;
  seasonPositionText: string;
}
export interface ManagerGameweekDTO {
  playerIds: Uint16Array | number[];
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
  safeHandsPlayerId: PlayerId;
  braceBonusGameweek: GameweekNumber;
  favouriteClubId: ClubId;
  passMasterGameweek: GameweekNumber;
  teamBoostClubId: ClubId;
  goalGetterGameweek: GameweekNumber;
  captainFantasticPlayerId: PlayerId;
  gameweek: GameweekNumber;
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
export interface MonthlyCanisterDTO {
  cycles: bigint;
  canister: MonthlyLeaderboardCanister;
}
export interface MonthlyLeaderboardCanister {
  month: CalendarMonth;
  clubId: ClubId;
  seasonId: SeasonId;
  canisterId: string;
}
export interface MonthlyLeaderboardDTO {
  month: number;
  clubId: ClubId;
  totalEntries: bigint;
  seasonId: SeasonId;
  entries: Array<LeaderboardEntry>;
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
  isInjured: boolean;
  gameweeks: Array<PlayerGameweekDTO>;
  nationality: CountryId;
  retirementDate: bigint;
  valueHistory: Array<ValueHistory>;
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
  events: List_2;
  position: PlayerPosition;
  points: number;
}
export type PlayerStatus =
  | { OnLoan: null }
  | { Former: null }
  | { Active: null }
  | { Retired: null };
export interface ProfileCanisterDTO {
  cycles: bigint;
  canisterId: string;
}
export interface ProfileDTO {
  playerIds: Uint16Array | number[];
  countrymenCountryId: CountryId;
  username: string;
  goalGetterPlayerId: PlayerId;
  hatTrickHeroGameweek: GameweekNumber;
  transfersAvailable: number;
  termsAccepted: boolean;
  teamBoostGameweek: GameweekNumber;
  captainFantasticGameweek: GameweekNumber;
  createDate: bigint;
  countrymenGameweek: GameweekNumber;
  bankQuarterMillions: number;
  noEntryPlayerId: PlayerId;
  safeHandsPlayerId: PlayerId;
  history: List;
  braceBonusGameweek: GameweekNumber;
  favouriteClubId: ClubId;
  passMasterGameweek: GameweekNumber;
  teamBoostClubId: ClubId;
  goalGetterGameweek: GameweekNumber;
  captainFantasticPlayerId: PlayerId;
  profilePicture: Uint8Array | number[];
  transferWindowGameweek: GameweekNumber;
  noEntryGameweek: GameweekNumber;
  prospectsGameweek: GameweekNumber;
  safeHandsGameweek: GameweekNumber;
  principalId: string;
  passMasterPlayerId: PlayerId;
  captainId: PlayerId;
  monthlyBonusesAvailable: number;
}
export interface PromoteFormerClubDTO {
  clubId: ClubId;
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
export interface PublicProfileDTO {
  username: string;
  createDate: bigint;
  gameweeks: Array<FantasyTeamSnapshot>;
  favouriteClubId: number;
  profilePicture: Uint8Array | number[];
  principalId: string;
}
export interface RecallPlayerDTO {
  playerId: PlayerId;
}
export interface RescheduleFixtureDTO {
  fixtureId: FixtureId;
  updatedFixtureGameweek: GameweekNumber;
  updatedFixtureDate: bigint;
  seasonId: SeasonId;
}
export type Result = { ok: string } | { err: string };
export type Result_1 = { ok: null } | { err: Error };
export type Result_10 = { ok: Array<PlayerPointsDTO> } | { err: Error };
export type Result_11 = { ok: PlayerDetailDTO } | { err: Error };
export type Result_12 = { ok: Array<MonthlyLeaderboardDTO> } | { err: Error };
export type Result_13 = { ok: MonthlyLeaderboardDTO } | { err: Error };
export type Result_14 = { ok: ManagerGameweekDTO } | { err: Error };
export type Result_15 = { ok: ManagerDTO } | { err: Error };
export type Result_16 = { ok: Array<FixtureDTO> } | { err: Error };
export type Result_17 = { ok: Array<DataCacheDTO> } | { err: Error };
export type Result_18 = { ok: Array<CountryDTO> } | { err: Error };
export type Result_19 = { ok: Array<ClubDTO> } | { err: Error };
export type Result_2 = { ok: WeeklyLeaderboardDTO } | { err: Error };
export type Result_20 = { ok: AdminWeeklyCanisterList } | { err: Error };
export type Result_21 = { ok: AdminTimerList } | { err: Error };
export type Result_22 = { ok: AdminSeasonCanisterList } | { err: Error };
export type Result_23 =
  | { ok: AdminProfilePictureCanisterList }
  | { err: Error };
export type Result_24 = { ok: AdminPlayerList } | { err: Error };
export type Result_25 = { ok: AdminMonthlyCanisterList } | { err: Error };
export type Result_26 = { ok: AdminProfileList } | { err: Error };
export type Result_27 = { ok: AdminMainCanisterInfo } | { err: Error };
export type Result_28 = { ok: AdminFixtureList } | { err: Error };
export type Result_29 = { ok: AdminClubList } | { err: Error };
export type Result_3 = { ok: bigint } | { err: Error };
export type Result_4 = { ok: SystemStateDTO } | { err: Error };
export type Result_5 = { ok: SeasonLeaderboardDTO } | { err: Error };
export type Result_6 = { ok: PublicProfileDTO } | { err: Error };
export type Result_7 = { ok: ProfileDTO } | { err: Error };
export type Result_8 = { ok: Array<[number, PlayerScoreDTO]> } | { err: Error };
export type Result_9 = { ok: Array<PlayerDTO> } | { err: Error };
export interface RetirePlayerDTO {
  playerId: PlayerId;
  retirementDate: bigint;
}
export interface RevaluePlayerDownDTO {
  playerId: PlayerId;
}
export interface RevaluePlayerUpDTO {
  playerId: PlayerId;
}
export interface SeasonCanisterDTO {
  cycles: bigint;
  canister: SeasonLeaderboardCanister;
}
export type SeasonId = number;
export interface SeasonLeaderboardCanister {
  seasonId: SeasonId;
  canisterId: string;
}
export interface SeasonLeaderboardDTO {
  totalEntries: bigint;
  seasonId: SeasonId;
  entries: Array<LeaderboardEntry>;
}
export interface SetPlayerInjuryDTO {
  playerId: PlayerId;
  description: string;
  expectedEndDate: bigint;
}
export type ShirtType = { Filled: null } | { Striped: null };
export interface SubmitFixtureDataDTO {
  fixtureId: FixtureId;
  seasonId: SeasonId;
  gameweek: GameweekNumber;
  playerEventData: Array<PlayerEventData>;
}
export interface SystemStateDTO {
  pickTeamSeasonId: SeasonId;
  pickTeamSeasonName: string;
  calculationSeasonName: string;
  calculationGameweek: GameweekNumber;
  pickTeamGameweek: GameweekNumber;
  calculationMonth: CalendarMonth;
  calculationSeasonId: SeasonId;
}
export interface TimerDTO {
  id: bigint;
  callbackName: string;
  triggerTime: bigint;
}
export interface TransferPlayerDTO {
  playerId: PlayerId;
  newClubId: ClubId;
}
export interface UnretirePlayerDTO {
  playerId: PlayerId;
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
export interface UpdateFantasyTeamDTO {
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
export interface UpdateFixtureDTO {
  status: FixtureStatusType;
  fixtureId: FixtureId;
  seasonId: SeasonId;
  kickOff: bigint;
  gameweek: GameweekNumber;
}
export interface UpdatePlayerDTO {
  dateOfBirth: bigint;
  playerId: PlayerId;
  nationality: CountryId;
  shirtNumber: number;
  position: PlayerPosition;
  lastName: string;
  firstName: string;
}
export interface UpdateSystemStateDTO {
  pickTeamSeasonId: SeasonId;
  calculationGameweek: GameweekNumber;
  transferWindowActive: boolean;
  pickTeamGameweek: GameweekNumber;
  calculationMonth: CalendarMonth;
  calculationSeasonId: SeasonId;
  onHold: boolean;
}
export interface ValueHistory {
  oldValue: number;
  newValue: number;
  seasonId: number;
  gameweek: number;
}
export interface WeeklyCanisterDTO {
  cycles: bigint;
  canister: WeeklyLeaderboardCanister;
}
export interface WeeklyLeaderboardCanister {
  seasonId: SeasonId;
  gameweek: GameweekNumber;
  canisterId: string;
}
export interface WeeklyLeaderboardDTO {
  totalEntries: bigint;
  seasonId: SeasonId;
  entries: Array<LeaderboardEntry>;
  gameweek: GameweekNumber;
}
export interface _SERVICE {
  adminAddInitialFixtures: ActorMethod<[AddInitialFixturesDTO], Result>;
  adminCreatePlayer: ActorMethod<[CreatePlayerDTO], Result>;
  adminGetClubs: ActorMethod<[bigint, bigint], Result_29>;
  adminGetFixtures: ActorMethod<[SeasonId], Result_28>;
  adminGetMainCanisterInfo: ActorMethod<[], Result_27>;
  adminGetManagers: ActorMethod<[bigint, bigint], Result_26>;
  adminGetMonthlyCanisters: ActorMethod<[bigint, bigint], Result_25>;
  adminGetPlayers: ActorMethod<[PlayerStatus], Result_24>;
  adminGetProfileCanisters: ActorMethod<[bigint, bigint], Result_23>;
  adminGetSeasonCanisters: ActorMethod<[bigint, bigint], Result_22>;
  adminGetTimers: ActorMethod<[bigint, bigint], Result_21>;
  adminGetWeeklyCanisters: ActorMethod<[bigint, bigint], Result_20>;
  adminLoanPlayer: ActorMethod<[LoanPlayerDTO], Result>;
  adminPromoteFormerClub: ActorMethod<[PromoteFormerClubDTO], Result>;
  adminPromoteNewClub: ActorMethod<[PromoteNewClubDTO], Result>;
  adminRecallPlayer: ActorMethod<[RecallPlayerDTO], Result>;
  adminRescheduleFixture: ActorMethod<[RescheduleFixtureDTO], Result>;
  adminRetirePlayer: ActorMethod<[RetirePlayerDTO], Result>;
  adminRevaluePlayerDown: ActorMethod<[RevaluePlayerDownDTO], Result>;
  adminRevaluePlayerUp: ActorMethod<[RevaluePlayerUpDTO], Result>;
  adminSetPlayerInjury: ActorMethod<[SetPlayerInjuryDTO], Result>;
  adminSubmitFixtureData: ActorMethod<[SubmitFixtureDataDTO], Result>;
  adminTransferPlayer: ActorMethod<[TransferPlayerDTO], Result>;
  adminUnretirePlayer: ActorMethod<[UnretirePlayerDTO], Result>;
  adminUpdateClub: ActorMethod<[UpdateClubDTO], Result>;
  adminUpdatePlayer: ActorMethod<[UpdatePlayerDTO], Result>;
  burnICPToCycles: ActorMethod<[bigint], undefined>;
  executeAddInitialFixtures: ActorMethod<[AddInitialFixturesDTO], undefined>;
  executeCreatePlayer: ActorMethod<[CreatePlayerDTO], undefined>;
  executeLoanPlayer: ActorMethod<[LoanPlayerDTO], undefined>;
  executePromoteFormerClub: ActorMethod<[PromoteFormerClubDTO], undefined>;
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
  getClubs: ActorMethod<[], Result_19>;
  getCountries: ActorMethod<[], Result_18>;
  getDataHashes: ActorMethod<[], Result_17>;
  getFixtures: ActorMethod<[SeasonId], Result_16>;
  getManager: ActorMethod<[], Result_15>;
  getManagerGameweek: ActorMethod<
    [string, SeasonId, GameweekNumber],
    Result_14
  >;
  getMonthlyLeaderboard: ActorMethod<
    [SeasonId, ClubId, CalendarMonth, bigint, bigint],
    Result_13
  >;
  getMonthlyLeaderboards: ActorMethod<[SeasonId, CalendarMonth], Result_12>;
  getPlayerDetails: ActorMethod<[PlayerId, SeasonId], Result_11>;
  getPlayerDetailsForGameweek: ActorMethod<
    [SeasonId, GameweekNumber],
    Result_10
  >;
  getPlayers: ActorMethod<[], Result_9>;
  getPlayersMap: ActorMethod<[SeasonId, GameweekNumber], Result_8>;
  getProfile: ActorMethod<[], Result_7>;
  getPublicProfile: ActorMethod<[string, SeasonId, GameweekNumber], Result_6>;
  getSeasonLeaderboard: ActorMethod<[SeasonId, bigint, bigint], Result_5>;
  getSystemState: ActorMethod<[], Result_4>;
  getTotalManagers: ActorMethod<[], Result_3>;
  getWeeklyLeaderboard: ActorMethod<
    [SeasonId, GameweekNumber, bigint, bigint],
    Result_2
  >;
  initControllers: ActorMethod<[], undefined>;
  isUsernameValid: ActorMethod<[string], boolean>;
  requestCanisterTopup: ActorMethod<[], undefined>;
  saveFantasyTeam: ActorMethod<[UpdateFantasyTeamDTO], Result_1>;
  updateFavouriteClub: ActorMethod<[ClubId], Result_1>;
  updateFixture: ActorMethod<[UpdateFixtureDTO], Result_1>;
  updateProfilePicture: ActorMethod<[Uint8Array | number[]], Result_1>;
  updateSystemState: ActorMethod<[UpdateSystemStateDTO], Result_1>;
  updateUsername: ActorMethod<[string], Result_1>;
  validateAddInitialFixtures: ActorMethod<[AddInitialFixturesDTO], Result>;
  validateCreatePlayer: ActorMethod<[CreatePlayerDTO], Result>;
  validateLoanPlayer: ActorMethod<[LoanPlayerDTO], Result>;
  validatePromoteFormerClub: ActorMethod<[PromoteFormerClubDTO], Result>;
  validatePromoteNewClub: ActorMethod<[PromoteNewClubDTO], Result>;
  validateRecallPlayer: ActorMethod<[RecallPlayerDTO], Result>;
  validateRescheduleFixture: ActorMethod<[RescheduleFixtureDTO], Result>;
  validateRetirePlayer: ActorMethod<[RetirePlayerDTO], Result>;
  validateRevaluePlayerDown: ActorMethod<[RevaluePlayerDownDTO], Result>;
  validateRevaluePlayerUp: ActorMethod<[RevaluePlayerUpDTO], Result>;
  validateSetPlayerInjury: ActorMethod<[SetPlayerInjuryDTO], Result>;
  validateSubmitFixtureData: ActorMethod<[SubmitFixtureDataDTO], Result>;
  validateTransferPlayer: ActorMethod<[TransferPlayerDTO], Result>;
  validateUnretirePlayer: ActorMethod<[UnretirePlayerDTO], Result>;
  validateUpdateClub: ActorMethod<[UpdateClubDTO], Result>;
  validateUpdatePlayer: ActorMethod<[UpdatePlayerDTO], Result>;
}
