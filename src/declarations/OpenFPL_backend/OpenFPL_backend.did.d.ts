import type { ActorMethod } from "@dfinity/agent";

export type AccountIdentifier = Uint8Array | number[];
export interface AddInitialFixturesDTO {
  seasonId: SeasonId;
  seasonFixtures: Array<FixtureDTO>;
}
export type CalendarMonth = number;
export type ClubId = number;
export interface CountryDTO {
  id: CountryId;
  code: string;
  name: string;
}
export type CountryId = number;
export interface CreatePlayerDTO {
  clubId: ClubId;
  valueQuarterMillions: bigint;
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
  | { AlreadyExists: null }
  | { InvalidTeamError: null };
export interface FixtureDTO {
  id: number;
  status: FixtureStatus;
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
export type FixtureStatus =
  | { Unplayed: null }
  | { Finalised: null }
  | { Active: null }
  | { Complete: null };
export type GameweekNumber = number;
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
export interface ManagerGameweekDTO {
  playerIds: Uint16Array | number[];
  teamValueQuarterMillions: bigint;
  countrymenCountryId: CountryId;
  username: string;
  goalGetterPlayerId: PlayerId;
  hatTrickHeroGameweek: GameweekNumber;
  transfersAvailable: number;
  teamBoostGameweek: GameweekNumber;
  captainFantasticGameweek: GameweekNumber;
  countrymenGameweek: GameweekNumber;
  bankQuarterMillions: bigint;
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
export interface MonthlyLeaderboardDTO {
  month: number;
  clubId: ClubId;
  totalEntries: bigint;
  seasonId: SeasonId;
  entries: Array<LeaderboardEntry>;
}
export interface PlayerDTO {
  id: number;
  clubId: ClubId;
  valueQuarterMillions: bigint;
  dateOfBirth: bigint;
  nationality: CountryId;
  shirtNumber: number;
  totalPoints: number;
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
export interface ProfileDTO {
  username: string;
  createDate: bigint;
  favouriteClubId: number;
  profilePicture: Uint8Array | number[];
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
  fixtureId: FixtureId;
  updatedFixtureGameweek: GameweekNumber;
  updatedFixtureDate: bigint;
  seasonId: SeasonId;
}
export type Result = { ok: string } | { err: string };
export type Result_1 = { ok: null } | { err: Error };
export type Result_10 = { ok: ManagerGameweekDTO } | { err: Error };
export type Result_11 = { ok: Array<FixtureDTO> } | { err: Error };
export type Result_12 = { ok: Array<DataCacheDTO> } | { err: Error };
export type Result_13 = { ok: Array<CountryDTO> } | { err: Error };
export type Result_2 = { ok: WeeklyLeaderboardDTO } | { err: Error };
export type Result_3 = { ok: bigint } | { err: Error };
export type Result_4 = { ok: SystemStateDTO } | { err: Error };
export type Result_5 = { ok: SeasonLeaderboardDTO } | { err: Error };
export type Result_6 = { ok: ProfileDTO } | { err: Error };
export type Result_7 = { ok: Array<PlayerDTO> } | { err: Error };
export type Result_8 = { ok: Array<PlayerPointsDTO> } | { err: Error };
export type Result_9 = { ok: MonthlyLeaderboardDTO } | { err: Error };
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
export type SeasonId = number;
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
  calculationGameweek: GameweekNumber;
  pickTeamGameweek: GameweekNumber;
  calculationMonth: CalendarMonth;
  calculationSeason: SeasonId;
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
export interface UpdatePlayerDTO {
  dateOfBirth: bigint;
  playerId: PlayerId;
  nationality: CountryId;
  shirtNumber: number;
  position: PlayerPosition;
  lastName: string;
  firstName: string;
}
export interface WeeklyLeaderboardDTO {
  totalEntries: bigint;
  seasonId: SeasonId;
  entries: Array<LeaderboardEntry>;
  gameweek: GameweekNumber;
}
export interface _SERVICE {
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
  getCountries: ActorMethod<[], Result_13>;
  getDataHashes: ActorMethod<[], Result_12>;
  getFixtures: ActorMethod<[SeasonId], Result_11>;
  getManager: ActorMethod<[string], Result_6>;
  getManagerGameweek: ActorMethod<
    [string, SeasonId, GameweekNumber],
    Result_10
  >;
  getMonthlyLeaderboard: ActorMethod<
    [SeasonId, ClubId, CalendarMonth, bigint, bigint],
    Result_9
  >;
  getPlayerDetailsForGameweek: ActorMethod<
    [SeasonId, GameweekNumber],
    Result_8
  >;
  getPlayers: ActorMethod<[], Result_7>;
  getProfile: ActorMethod<[], Result_6>;
  getSeasonLeaderboard: ActorMethod<[SeasonId, bigint, bigint], Result_5>;
  getSystemState: ActorMethod<[], Result_4>;
  getTotalManagers: ActorMethod<[], Result_3>;
  getTreasuryAccount: ActorMethod<[], AccountIdentifier>;
  getWeeklyLeaderboard: ActorMethod<
    [SeasonId, GameweekNumber, bigint, bigint],
    Result_2
  >;
  init: ActorMethod<[], undefined>;
  isUsernameValid: ActorMethod<[string], boolean>;
  requestCanisterTopup: ActorMethod<[], undefined>;
  saveFantasyTeam: ActorMethod<[UpdateFantasyTeamDTO], Result_1>;
  updateFavouriteClub: ActorMethod<[ClubId], Result_1>;
  updateProfilePicture: ActorMethod<[Uint8Array | number[]], Result_1>;
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
