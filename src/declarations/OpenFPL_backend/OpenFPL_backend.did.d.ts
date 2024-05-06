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
export type CanisterId = string;
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
export interface ClubFilterDTO {
  clubId: ClubId;
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
export interface CreatePrivateLeagueDTO {
  tokenId: TokenId;
  adminFee: number;
  name: string;
  banner: [] | [Uint8Array | number[]];
  entryRequirement: EntryRequirement;
  entrants: number;
  photo: [] | [Uint8Array | number[]];
  entryFee: bigint;
  paymentChoice: PaymentChoice;
  termsAgreed: boolean;
}
export interface DataCacheDTO {
  hash: string;
  category: string;
}
export interface Disburse {
  to_account: [] | [AccountIdentifier];
  amount: [] | [Amount];
}
export type EntryRequirement =
  | { InviteOnly: null }
  | { PaidEntry: null }
  | { PaidInviteEntry: null }
  | { FreeEntry: null };
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
export interface Follow {
  topic: number;
  followees: Array<NeuronId>;
}
export interface GameweekFiltersDTO {
  seasonId: SeasonId;
  gameweek: GameweekNumber;
}
export type GameweekNumber = number;
export interface GetFixturesDTO {
  seasonId: SeasonId;
}
export interface GetLeagueMembersDTO {
  offset: bigint;
  limit: bigint;
  canisterId: CanisterId;
}
export interface GetManagerDTO {
  managerId: string;
}
export interface GetMonthlyLeaderboardDTO {
  month: CalendarMonth;
  clubId: ClubId;
  offset: bigint;
  seasonId: SeasonId;
  limit: bigint;
  searchTerm: string;
}
export interface GetMonthlyLeaderboardsDTO {
  month: CalendarMonth;
  seasonId: SeasonId;
}
export interface GetPlayerDetailsDTO {
  playerId: PlayerId;
  seasonId: SeasonId;
}
export interface GetPrivateLeagueMonthlyLeaderboard {
  month: CalendarMonth;
  offset: bigint;
  seasonId: SeasonId;
  limit: bigint;
  canisterId: CanisterId;
}
export interface GetPrivateLeagueSeasonLeaderboard {
  offset: bigint;
  seasonId: SeasonId;
  limit: bigint;
  canisterId: CanisterId;
}
export interface GetPrivateLeagueWeeklyLeaderboard {
  offset: bigint;
  seasonId: SeasonId;
  limit: bigint;
  gameweek: GameweekNumber;
  canisterId: CanisterId;
}
export interface GetSeasonLeaderboardDTO {
  offset: bigint;
  seasonId: SeasonId;
  limit: bigint;
  searchTerm: string;
}
export interface GetWeeklyLeaderboardDTO {
  offset: bigint;
  seasonId: SeasonId;
  limit: bigint;
  searchTerm: string;
  gameweek: GameweekNumber;
}
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
export interface LeagueInviteDTO {
  managerId: PrincipalId;
  canisterId: CanisterId;
}
export interface LeagueMemberDTO {
  added: bigint;
  username: string;
  principalId: PrincipalId;
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
  privateLeagueMemberships: Array<CanisterId>;
  profilePicture: [] | [Uint8Array | number[]];
  seasonPoints: number;
  principalId: string;
  seasonPositionText: string;
}
export interface ManagerPrivateLeagueDTO {
  created: bigint;
  name: string;
  memberCount: bigint;
  seasonPosition: bigint;
  seasonPositionText: string;
  canisterId: CanisterId;
}
export interface ManagerPrivateLeaguesDTO {
  totalEntries: bigint;
  entries: Array<ManagerPrivateLeagueDTO>;
}
export interface MonthlyLeaderboardDTO {
  month: number;
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
export interface NewTokenDTO {
  fee: bigint;
  ticker: string;
  tokenImageURL: string;
  canisterId: CanisterId;
}
export type Operation =
  | {
      ChangeAutoStakeMaturity: ChangeAutoStakeMaturity;
    }
  | { StopDissolving: null }
  | { StartDissolving: null }
  | { IncreaseDissolveDelay: IncreaseDissolveDelay }
  | { SetDissolveTimestamp: SetDissolveTimestamp };
export type PaymentChoice = { FPL: null } | { ICP: null };
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
export type PrincipalId = string;
export interface PrivateLeagueRewardDTO {
  managerId: PrincipalId;
  amount: bigint;
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
export type Result = { ok: null } | { err: Error };
export type Result_1 = { ok: ManagerDTO } | { err: Error };
export type Result_10 = { ok: MonthlyLeaderboardDTO } | { err: Error };
export type Result_11 = { ok: Array<LeagueMemberDTO> } | { err: Error };
export type Result_12 = { ok: ManagerPrivateLeagueDTO } | { err: Error };
export type Result_13 = { ok: Array<FixtureDTO> } | { err: Error };
export type Result_14 =
  | { ok: Array<[number, PlayerScoreDTO]> }
  | { err: Error };
export type Result_15 = { ok: Array<PlayerPointsDTO> } | { err: Error };
export type Result_16 = { ok: PlayerDetailDTO } | { err: Error };
export type Result_17 = { ok: Array<MonthlyLeaderboardDTO> } | { err: Error };
export type Result_18 = { ok: ManagerPrivateLeaguesDTO } | { err: Error };
export type Result_19 = { ok: Array<ClubDTO> } | { err: Error };
export type Result_2 = { ok: WeeklyLeaderboardDTO } | { err: Error };
export type Result_20 = { ok: Array<DataCacheDTO> } | { err: Error };
export type Result_21 = { ok: PickTeamDTO } | { err: Error };
export type Result_22 = { ok: Array<CountryDTO> } | { err: Error };
export type Result_3 = { ok: bigint } | { err: Error };
export type Result_4 = { ok: Array<TokenInfo> } | { err: Error };
export type Result_5 = { ok: SystemStateDTO } | { err: Error };
export type Result_6 = { ok: Array<SeasonDTO> } | { err: Error };
export type Result_7 = { ok: SeasonLeaderboardDTO } | { err: Error };
export type Result_8 = { ok: Array<PlayerDTO> } | { err: Error };
export type Result_9 = { ok: ProfileDTO } | { err: Error };
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
export type TokenId = number;
export interface TokenInfo {
  id: TokenId;
  fee: bigint;
  ticker: string;
  tokenImageURL: string;
  canisterId: CanisterId;
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
export interface UpdateLeagueBannerDTO {
  banner: [] | [Uint8Array | number[]];
  canisterId: CanisterId;
}
export interface UpdateLeagueNameDTO {
  name: string;
  canisterId: CanisterId;
}
export interface UpdateLeaguePictureDTO {
  picture: [] | [Uint8Array | number[]];
  canisterId: CanisterId;
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
export interface UpdateProfilePictureDTO {
  managerId: string;
  profilePicture: Uint8Array | number[];
  extension: string;
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
  acceptInviteAndPayFee: ActorMethod<[CanisterId], Result>;
  acceptLeagueInvite: ActorMethod<[CanisterId], Result>;
  burnICPToCycles: ActorMethod<[bigint], undefined>;
  createPrivateLeague: ActorMethod<[CreatePrivateLeagueDTO], Result>;
  enterLeague: ActorMethod<[CanisterId], Result>;
  enterLeagueWithFee: ActorMethod<[CanisterId], Result>;
  executeAddInitialFixtures: ActorMethod<[AddInitialFixturesDTO], undefined>;
  executeAddNewToken: ActorMethod<[NewTokenDTO], undefined>;
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
  getClubs: ActorMethod<[], Result_19>;
  getCountries: ActorMethod<[], Result_22>;
  getCurrentTeam: ActorMethod<[], Result_21>;
  getDataHashes: ActorMethod<[], Result_20>;
  getFixtures: ActorMethod<[GetFixturesDTO], Result_13>;
  getFormerClubs: ActorMethod<[], Result_19>;
  getLoanedPlayers: ActorMethod<[ClubFilterDTO], Result_8>;
  getManager: ActorMethod<[GetManagerDTO], Result_1>;
  getManagerPrivateLeagues: ActorMethod<[], Result_18>;
  getMonthlyLeaderboard: ActorMethod<[GetMonthlyLeaderboardDTO], Result_10>;
  getMonthlyLeaderboards: ActorMethod<[GetMonthlyLeaderboardsDTO], Result_17>;
  getNeuronId: ActorMethod<[], bigint>;
  getPlayerDetails: ActorMethod<[GetPlayerDetailsDTO], Result_16>;
  getPlayerDetailsForGameweek: ActorMethod<[GameweekFiltersDTO], Result_15>;
  getPlayers: ActorMethod<[], Result_8>;
  getPlayersMap: ActorMethod<[GameweekFiltersDTO], Result_14>;
  getPostponedFixtures: ActorMethod<[], Result_13>;
  getPrivateLeague: ActorMethod<[CanisterId], Result_12>;
  getPrivateLeagueMembers: ActorMethod<[GetLeagueMembersDTO], Result_11>;
  getPrivateLeagueMonthlyLeaderboard: ActorMethod<
    [GetPrivateLeagueMonthlyLeaderboard],
    Result_10
  >;
  getPrivateLeagueSeasonLeaderboard: ActorMethod<
    [GetPrivateLeagueSeasonLeaderboard],
    Result_7
  >;
  getPrivateLeagueWeeklyLeaderboard: ActorMethod<
    [GetPrivateLeagueWeeklyLeaderboard],
    Result_2
  >;
  getProfile: ActorMethod<[], Result_9>;
  getRetiredPlayers: ActorMethod<[ClubFilterDTO], Result_8>;
  getSeasonLeaderboard: ActorMethod<[GetSeasonLeaderboardDTO], Result_7>;
  getSeasons: ActorMethod<[], Result_6>;
  getSystemState: ActorMethod<[], Result_5>;
  getTokenList: ActorMethod<[], Result_4>;
  getTotalManagers: ActorMethod<[], Result_3>;
  getWeeklyLeaderboard: ActorMethod<[GetWeeklyLeaderboardDTO], Result_2>;
  inviteUserToLeague: ActorMethod<[LeagueInviteDTO], Result>;
  isUsernameValid: ActorMethod<[UsernameFilterDTO], boolean>;
  payPrivateLeagueRewards: ActorMethod<[PrivateLeagueRewardDTO], undefined>;
  requestCanisterTopup: ActorMethod<[], undefined>;
  saveFantasyTeam: ActorMethod<[UpdateTeamSelectionDTO], Result>;
  searchUsername: ActorMethod<[UsernameFilterDTO], Result_1>;
  setTimer: ActorMethod<[bigint, string], undefined>;
  updateFavouriteClub: ActorMethod<[ClubFilterDTO], Result>;
  updateLeagueBanner: ActorMethod<[UpdateLeagueBannerDTO], Result>;
  updateLeagueName: ActorMethod<[UpdateLeagueNameDTO], Result>;
  updateLeaguePicture: ActorMethod<[UpdateLeaguePictureDTO], Result>;
  updateProfilePicture: ActorMethod<[UpdateProfilePictureDTO], Result>;
  updateUsername: ActorMethod<[UsernameFilterDTO], Result>;
  validateAddInitialFixtures: ActorMethod<[AddInitialFixturesDTO], RustResult>;
  validateAddNewToken: ActorMethod<[NewTokenDTO], RustResult>;
  validateCreateDAONeuron: ActorMethod<[], RustResult>;
  validateCreatePlayer: ActorMethod<[CreatePlayerDTO], RustResult>;
  validateLoanPlayer: ActorMethod<[LoanPlayerDTO], RustResult>;
  validateManageDAONeuron: ActorMethod<[], RustResult>;
  validateMoveFixture: ActorMethod<[MoveFixtureDTO], RustResult>;
  validatePostponeFixture: ActorMethod<[PostponeFixtureDTO], RustResult>;
  validatePromoteFormerClub: ActorMethod<[PromoteFormerClubDTO], RustResult>;
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
