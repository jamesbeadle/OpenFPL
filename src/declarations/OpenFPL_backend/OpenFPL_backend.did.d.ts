import type { Principal } from "@dfinity/principal";
import type { ActorMethod } from "@dfinity/agent";
import type { IDL } from "@dfinity/candid";

export interface AccountIdentifier {
  hash: Uint8Array | number[];
}
export interface AddInitialFixturesDTO {
  seasonId: SeasonId;
  seasonFixtures: Array<FixtureDTO>;
}
export interface Amount {
  e8s: bigint;
}
export type By =
  | { NeuronIdOrSubaccount: null }
  | { MemoAndController: ClaimOrRefreshNeuronFromAccount }
  | { Memo: bigint };
export type CalendarMonth = number;
export interface ChangeAutoStakeMaturity {
  requested_setting_for_auto_stake_maturity: boolean;
}
export interface ClaimOrRefresh {
  by: [] | [By];
}
export interface ClaimOrRefreshNeuronFromAccount {
  controller: [] | [Principal];
  memo: bigint;
}
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
export type Command =
  | { Spawn: Spawn }
  | { Follow: Follow }
  | { ClaimOrRefresh: ClaimOrRefresh }
  | { Configure: Configure }
  | { StakeMaturity: StakeMaturityResponse }
  | { Disburse: Disburse };
export interface Configure {
  operation: [] | [Operation];
}
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
export interface Disburse {
  to_account: [] | [AccountIdentifier];
  amount: [] | [Amount];
}
export type Error =
  | { DecodeError: null }
  | { NotAllowed: null }
  | { NotFound: null }
  | { NotAuthorized: null }
  | { InvalidData: null }
  | { SystemOnHold: null }
  | { AlreadyExists: null }
  | { CanisterCreateError: null }
  | { InvalidTeamError: null };
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
export interface Follow {
  topic: number;
  followees: Array<NeuronId>;
}
export type GameweekNumber = number;
export interface IncreaseDissolveDelay {
  additional_dissolve_delay_seconds: number;
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
export interface NeuronId {
  id: bigint;
}
export type Operation =
  | {
      ChangeAutoStakeMaturity: ChangeAutoStakeMaturity;
    }
  | { StopDissolving: null }
  | { StartDissolving: null }
  | { IncreaseDissolveDelay: IncreaseDissolveDelay }
  | { SetDissolveTimestamp: SetDissolveTimestamp };
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
  | { Former: null }
  | { Active: null }
  | { Retired: null };
export interface PostponeFixtureDTO {
  fixtureId: FixtureId;
}
export interface ProfileDTO {
  username: string;
  termsAccepted: boolean;
  createDate: bigint;
  favouriteClubId: ClubId;
  profilePicture: [] | [Uint8Array | number[]];
  profilePictureType: string;
  principalId: string;
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
export interface RecallPlayerDTO {
  playerId: PlayerId;
}
export interface RescheduleFixtureDTO {
  postponedFixtureId: FixtureId;
  updatedFixtureGameweek: GameweekNumber;
  updatedFixtureDate: bigint;
}
export type Result = { ok: string } | { err: string };
export type Result_1 = { ok: null } | { err: Error };
export type Result_10 =
  | { ok: Array<[number, PlayerScoreDTO]> }
  | { err: Error };
export type Result_11 = { ok: Array<PlayerPointsDTO> } | { err: Error };
export type Result_12 = { ok: PlayerDetailDTO } | { err: Error };
export type Result_13 = { ok: Array<MonthlyLeaderboardDTO> } | { err: Error };
export type Result_14 = { ok: MonthlyLeaderboardDTO } | { err: Error };
export type Result_15 = { ok: ManagerDTO } | { err: Error };
export type Result_16 = { ok: Array<ClubDTO> } | { err: Error };
export type Result_17 = { ok: Array<DataCacheDTO> } | { err: Error };
export type Result_18 = { ok: PickTeamDTO } | { err: Error };
export type Result_19 = { ok: Array<CountryDTO> } | { err: Error };
export type Result_2 = { ok: WeeklyLeaderboardDTO } | { err: Error };
export type Result_20 = { ok: string } | { err: Error };
export type Result_3 = { ok: bigint } | { err: Error };
export type Result_4 = { ok: SystemStateDTO } | { err: Error };
export type Result_5 = { ok: Array<SeasonDTO> } | { err: Error };
export type Result_6 = { ok: SeasonLeaderboardDTO } | { err: Error };
export type Result_7 = { ok: Array<PlayerDTO> } | { err: Error };
export type Result_8 = { ok: ProfileDTO } | { err: Error };
export type Result_9 = { ok: Array<FixtureDTO> } | { err: Error };
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
export type RustResult = { Ok: null } | { Err: string };
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
export interface SetDissolveTimestamp {
  dissolve_timestamp_seconds: bigint;
}
export interface SetPlayerInjuryDTO {
  playerId: PlayerId;
  description: string;
  expectedEndDate: bigint;
}
export type ShirtType = { Filled: null } | { Striped: null };
export interface Spawn {
  percentage_to_spawn: [] | [number];
  new_controller: [] | [Principal];
  nonce: [] | [bigint];
}
export interface StakeMaturityResponse {
  maturity_e8s: bigint;
  stake_maturity_e8s: bigint;
}
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
  transferWindowActive: boolean;
  pickTeamGameweek: GameweekNumber;
  calculationMonth: CalendarMonth;
  calculationSeasonId: SeasonId;
  onHold: boolean;
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
export interface UpdatePlayerDTO {
  dateOfBirth: bigint;
  playerId: PlayerId;
  nationality: CountryId;
  shirtNumber: number;
  position: PlayerPosition;
  lastName: string;
  firstName: string;
}
export interface UpdateTeamSelectionDTO {
  playerIds: Uint16Array | number[];
  countrymenCountryId: CountryId;
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
  principalId: string;
  passMasterPlayerId: PlayerId;
  captainId: PlayerId;
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
  acceptLeagueInvite: ActorMethod<[], undefined>;
  agreePrivateLeagueTerms: ActorMethod<[], undefined>;
  burnICPToCycles: ActorMethod<[bigint], undefined>;
  executeAddInitialFixtures: ActorMethod<[AddInitialFixturesDTO], undefined>;
  executeCreateDAONeuron: ActorMethod<[], undefined>;
  executeCreatePlayer: ActorMethod<[CreatePlayerDTO], undefined>;
  executeLoanPlayer: ActorMethod<[LoanPlayerDTO], undefined>;
  executeManageDAONeuron: ActorMethod<[Command], undefined>;
  executeMoveFixture: ActorMethod<[MoveFixtureDTO], undefined>;
  executePostponeFixture: ActorMethod<[PostponeFixtureDTO], undefined>;
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
  getBackendCanisterId: ActorMethod<[], Result_20>;
  getClubs: ActorMethod<[], Result_16>;
  getCountries: ActorMethod<[], Result_19>;
  getCurrentTeam: ActorMethod<[], Result_18>;
  getDataHashes: ActorMethod<[], Result_17>;
  getFixtures: ActorMethod<[SeasonId], Result_9>;
  getFormerClubs: ActorMethod<[], Result_16>;
  getICRC1TokenList: ActorMethod<[], undefined>;
  getLoanedPlayers: ActorMethod<[ClubId], Result_7>;
  getManager: ActorMethod<[string], Result_15>;
  getMonthlyLeaderboard: ActorMethod<
    [SeasonId, ClubId, CalendarMonth, bigint, bigint, string],
    Result_14
  >;
  getMonthlyLeaderboards: ActorMethod<[SeasonId, CalendarMonth], Result_13>;
  getNeuronId: ActorMethod<[], bigint>;
  getPlayerDetails: ActorMethod<[PlayerId, SeasonId], Result_12>;
  getPlayerDetailsForGameweek: ActorMethod<
    [SeasonId, GameweekNumber],
    Result_11
  >;
  getPlayers: ActorMethod<[], Result_7>;
  getPlayersMap: ActorMethod<[SeasonId, GameweekNumber], Result_10>;
  getPostponedFixtures: ActorMethod<[], Result_9>;
  getPrivateLeagueMembers: ActorMethod<[], undefined>;
  getPrivateLeagueTable: ActorMethod<[], undefined>;
  getProfile: ActorMethod<[], Result_8>;
  getRetiredPlayers: ActorMethod<[ClubId], Result_7>;
  getSeasonLeaderboard: ActorMethod<
    [SeasonId, bigint, bigint, string],
    Result_6
  >;
  getSeasons: ActorMethod<[], Result_5>;
  getSystemState: ActorMethod<[], Result_4>;
  getTotalManagers: ActorMethod<[], Result_3>;
  getWeeklyLeaderboard: ActorMethod<
    [SeasonId, GameweekNumber, bigint, bigint, string],
    Result_2
  >;
  inviteUserToLeague: ActorMethod<[], undefined>;
  isUsernameValid: ActorMethod<[string], boolean>;
  payLeagueEntryFee: ActorMethod<[], undefined>;
  requestCanisterTopup: ActorMethod<[], undefined>;
  saveFantasyTeam: ActorMethod<[UpdateTeamSelectionDTO], Result_1>;
  searchUsername: ActorMethod<[], undefined>;
  setTimer: ActorMethod<[bigint, string], undefined>;
  setupPrivateLeague: ActorMethod<[], undefined>;
  updateFavouriteClub: ActorMethod<[ClubId], Result_1>;
  updateLeagueBannerPicture: ActorMethod<[], undefined>;
  updateLeagueColours: ActorMethod<[], undefined>;
  updateLeagueName: ActorMethod<[], undefined>;
  updateLeagueProfilePicture: ActorMethod<[], undefined>;
  updateProfilePicture: ActorMethod<[Uint8Array | number[], string], Result_1>;
  updateUsername: ActorMethod<[string], Result_1>;
  validateAddInitialFixtures: ActorMethod<[AddInitialFixturesDTO], Result>;
  validateCreateDAONeuron: ActorMethod<[], RustResult>;
  validateCreatePlayer: ActorMethod<[CreatePlayerDTO], Result>;
  validateLoanPlayer: ActorMethod<[LoanPlayerDTO], Result>;
  validateManageDAONeuron: ActorMethod<[], Result>;
  validateMoveFixture: ActorMethod<[MoveFixtureDTO], Result>;
  validatePostponeFixture: ActorMethod<[PostponeFixtureDTO], Result>;
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
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
