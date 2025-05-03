import type { Principal } from "@dfinity/principal";
import type { ActorMethod } from "@dfinity/agent";
import type { IDL } from "@dfinity/candid";

export interface AddInitialFixtures {
  seasonId: SeasonId;
  seasonFixtures: Array<InitialFixture>;
  leagueId: LeagueId;
}
export interface BettableFixtures {
  seasonId: SeasonId;
  fixtures: Array<Fixture>;
  leagueId: LeagueId;
}
export interface BettableLeagues {
  leagues: Array<League>;
}
export type CalendarMonth = number;
export interface Canister {
  app: WaterwayLabsApp;
  canisterName: string;
  canisterType: CanisterType;
  canisterId: CanisterId;
}
export type CanisterId = string;
export type CanisterType = { SNS: null } | { Dynamic: null } | { Static: null };
export interface Club {
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
export interface ClubSummary {
  mvp: MostValuablePlayer;
  clubId: ClubId;
  clubName: string;
  totalMFValue: bigint;
  totalGKValue: bigint;
  totalPlayers: number;
  totalValue: bigint;
  totalDefenders: number;
  totalForwards: number;
  positionText: string;
  primaryColour: string;
  totalGoalkeepers: number;
  gender: Gender;
  shirtType: ShirtType;
  totalDFValue: bigint;
  thirdColour: string;
  secondaryColour: string;
  totalFWValue: bigint;
  position: bigint;
  priorValue: bigint;
  leagueId: LeagueId;
  totalMidfielders: number;
}
export interface ClubValueLeaderboard {
  clubs: Array<ClubSummary>;
}
export interface Clubs {
  clubs: Array<Club>;
  leagueId: LeagueId;
}
export type CountryId = number;
export interface CreateClub {
  secondaryColourHex: string;
  name: string;
  friendlyName: string;
  thirdColourHex: string;
  abbreviatedName: string;
  shirtType: ShirtType;
  primaryColourHex: string;
  leagueId: LeagueId;
}
export interface CreateLeague {
  logo: [] | [Uint8Array | number[]];
  name: string;
  teamCount: number;
  relatedGender: Gender;
  countryId: CountryId;
  abbreviation: string;
  governingBody: string;
  formed: bigint;
}
export interface CreatePlayer {
  clubId: ClubId;
  valueQuarterMillions: number;
  dateOfBirth: bigint;
  nationality: CountryId;
  shirtNumber: number;
  position: PlayerPosition;
  lastName: string;
  leagueId: LeagueId;
  firstName: string;
}
export interface DataHash {
  hash: string;
  category: string;
}
export interface DataHashes {
  dataHashes: Array<DataHash>;
}
export interface DataTotals {
  totalGovernanceRewards: bigint;
  totalPlayers: bigint;
  totalClubs: bigint;
  totalNeurons: bigint;
  totalProposals: bigint;
  totalLeagues: bigint;
}
export interface DetailedPlayer {
  id: PlayerId;
  status: PlayerStatus;
  clubId: ClubId;
  parentClubId: ClubId;
  valueQuarterMillions: number;
  dateOfBirth: bigint;
  injuryHistory: Array<InjuryHistory>;
  seasonId: SeasonId;
  gameweeks: Array<PlayerGameweek>;
  nationality: CountryId;
  retirementDate: bigint;
  valueHistory: Array<ValueHistory>;
  latestInjuryEndDate: bigint;
  shirtNumber: number;
  position: PlayerPosition;
  lastName: string;
  firstName: string;
}
export type Error =
  | { InvalidProfilePicture: null }
  | { DecodeError: null }
  | { TooLong: null }
  | { NotAllowed: null }
  | { DuplicateData: null }
  | { InvalidProperty: null }
  | { NotFound: null }
  | { IncorrectSetup: null }
  | { AlreadyClaimed: null }
  | { NotAuthorized: null }
  | { MaxDataExceeded: null }
  | { InvalidData: null }
  | { SystemOnHold: null }
  | { AlreadyExists: null }
  | { NoPacketsRemaining: null }
  | { UpdateFailed: null }
  | { CanisterCreateError: null }
  | { NeuronAlreadyUsed: null }
  | { FailedInterCanisterCall: null }
  | { InsufficientPacketsRemaining: null }
  | { InsufficientFunds: null }
  | { InEligible: null };
export interface Fixture {
  id: FixtureId;
  status: FixtureStatusType;
  highestScoringPlayerId: PlayerId;
  seasonId: SeasonId;
  awayClubId: ClubId;
  events: Array<PlayerEventData__1>;
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
export interface Fixtures {
  seasonId: SeasonId;
  fixtures: Array<Fixture>;
  leagueId: LeagueId;
}
export type GameweekNumber = number;
export type Gender = { Male: null } | { Female: null };
export interface GetBettableFixtures {
  leagueId: LeagueId;
}
export type GetBettableLeagues = {};
export type GetClubValueLeaderboard = {};
export interface GetClubs {
  leagueId: LeagueId;
}
export interface GetDataHashes {
  leagueId: LeagueId;
}
export type GetDataTotals = {};
export interface GetFixtures {
  seasonId: SeasonId;
  leagueId: LeagueId;
}
export interface GetLeagueStatus {
  leagueId: LeagueId;
}
export interface GetLeagueTable {
  seasonId: SeasonId;
  leagueId: LeagueId;
}
export type GetLeagues = {};
export interface GetLoanedPlayers {
  leagueId: LeagueId;
}
export interface GetPlayerDetails {
  playerId: PlayerId;
  seasonId: SeasonId;
  leagueId: LeagueId;
}
export interface GetPlayerDetailsForGameweek {
  seasonId: SeasonId;
  gameweek: GameweekNumber;
  leagueId: LeagueId;
}
export type GetPlayerValueLeaderboard = {};
export interface GetPlayers {
  leagueId: LeagueId;
}
export interface GetPlayersMap {
  seasonId: SeasonId;
  gameweek: GameweekNumber;
  leagueId: LeagueId;
}
export interface GetPostponedFixtures {
  leagueId: LeagueId;
}
export interface GetRetiredPlayers {
  clubId: ClubId;
  leagueId: LeagueId;
}
export interface GetSeasons {
  leagueId: LeagueId;
}
export interface InitialFixture {
  awayClubId: ClubId;
  homeClubId: ClubId;
  kickOff: bigint;
  gameweek: GameweekNumber;
}
export interface InjuryHistory {
  description: string;
  injuryStartDate: bigint;
  expectedEndDate: bigint;
}
export interface League {
  id: LeagueId;
  logo: Uint8Array | number[];
  name: string;
  teamCount: number;
  relatedGender: Gender;
  countryId: CountryId;
  abbreviation: string;
  governingBody: string;
  formed: bigint;
}
export type LeagueId = number;
export interface LeagueStatus {
  transferWindowEndMonth: number;
  transferWindowEndDay: number;
  transferWindowStartMonth: number;
  transferWindowActive: boolean;
  totalGameweeks: number;
  completedGameweek: GameweekNumber;
  transferWindowStartDay: number;
  unplayedGameweek: GameweekNumber;
  activeMonth: CalendarMonth;
  activeSeasonId: SeasonId;
  activeGameweek: GameweekNumber;
  leagueId: LeagueId;
  seasonActive: boolean;
}
export interface LeagueTable {
  seasonId: SeasonId;
  entries: Array<LeagueTableEntry>;
  leagueId: LeagueId;
}
export interface LeagueTableEntry {
  won: bigint;
  homeDrawn: bigint;
  clubId: ClubId;
  awayDrawn: bigint;
  homeLost: bigint;
  played: bigint;
  scored: bigint;
  lost: bigint;
  homeWon: bigint;
  conceded: bigint;
  awayPoints: bigint;
  awayWon: bigint;
  homePoints: bigint;
  awayConceded: bigint;
  awayLost: bigint;
  awayPlayed: bigint;
  awayScored: bigint;
  homePlayed: bigint;
  position: bigint;
  homeScored: bigint;
  drawn: bigint;
  homeConceded: bigint;
  points: bigint;
}
export interface Leagues {
  leagues: Array<League>;
}
export interface LoanPlayer {
  loanEndDate: bigint;
  playerId: ClubId;
  loanClubId: ClubId;
  newValueQuarterMillions: number;
  loanLeagueId: LeagueId;
  leagueId: LeagueId;
}
export interface LoanedPlayers {
  players: Array<Player>;
}
export interface MostValuablePlayer {
  id: PlayerId;
  value: number;
  lastName: string;
  firstName: string;
}
export interface MoveFixture {
  fixtureId: FixtureId;
  updatedFixtureGameweek: GameweekNumber;
  updatedFixtureDate: bigint;
  seasonId: SeasonId;
  leagueId: LeagueId;
}
export interface Player {
  id: number;
  status: PlayerStatus;
  clubId: ClubId;
  parentClubId: ClubId;
  valueQuarterMillions: number;
  dateOfBirth: bigint;
  nationality: CountryId;
  currentLoanEndDate: bigint;
  shirtNumber: number;
  parentLeagueId: LeagueId;
  position: PlayerPosition;
  lastName: string;
  leagueId: LeagueId;
  firstName: string;
}
export interface PlayerDetails {
  player: DetailedPlayer;
}
export interface PlayerDetailsForGameweek {
  playerPoints: Array<PlayerPoints>;
}
export interface PlayerEventData {
  fixtureId: FixtureId;
  clubId: ClubId;
  playerId: number;
  eventStartMinute: number;
  eventEndMinute: number;
  eventType: PlayerEventType;
}
export interface PlayerEventData__1 {
  fixtureId: FixtureId;
  clubId: ClubId;
  playerId: number;
  eventStartMinute: number;
  eventEndMinute: number;
  eventType: PlayerEventType;
}
export interface PlayerEventData__2 {
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
export interface PlayerGameweek {
  fixtureId: FixtureId;
  events: Array<PlayerEventData__2>;
  number: number;
  points: number;
}
export type PlayerId = number;
export interface PlayerPoints {
  id: number;
  clubId: ClubId;
  events: Array<PlayerEventData__2>;
  position: PlayerPosition;
  gameweek: GameweekNumber;
  points: number;
}
export type PlayerPosition =
  | { Goalkeeper: null }
  | { Midfielder: null }
  | { Forward: null }
  | { Defender: null };
export interface PlayerScore {
  id: number;
  clubId: ClubId;
  assists: number;
  dateOfBirth: bigint;
  nationality: CountryId;
  goalsScored: number;
  saves: number;
  goalsConceded: number;
  events: Array<PlayerEventData__2>;
  position: PlayerPosition;
  points: number;
}
export type PlayerStatus =
  | { OnLoan: null }
  | { Active: null }
  | { FreeAgent: null }
  | { Retired: null };
export interface PlayerSummary {
  clubId: ClubId;
  totalValue: number;
  playerId: PlayerId;
  positionText: string;
  position: bigint;
  priorValue: number;
  leagueId: LeagueId;
}
export interface PlayerValueLeaderboard {
  players: Array<PlayerSummary>;
}
export interface Players {
  players: Array<Player>;
}
export interface PlayersMap {
  playersMap: Array<[PlayerId, PlayerScore]>;
}
export interface PostponeFixture {
  fixtureId: FixtureId;
  seasonId: SeasonId;
  leagueId: LeagueId;
}
export interface PostponedFixtures {
  seasonId: SeasonId;
  fixtures: Array<Fixture>;
  leagueId: LeagueId;
}
export interface PromoteClub {
  clubId: ClubId;
  toLeagueId: LeagueId;
  leagueId: LeagueId;
}
export interface RecallPlayer {
  playerId: ClubId;
  newValueQuarterMillions: number;
  leagueId: LeagueId;
}
export interface RelegateClub {
  clubId: ClubId;
  relegatedToLeagueId: LeagueId;
  leagueId: LeagueId;
}
export interface RescheduleFixture {
  fixtureId: FixtureId;
  updatedFixtureGameweek: GameweekNumber;
  updatedFixtureDate: bigint;
  seasonId: SeasonId;
  leagueId: LeagueId;
}
export type Result = { ok: null } | { err: Error };
export type Result_1 = { ok: Seasons } | { err: Error };
export type Result_10 = { ok: Leagues } | { err: Error };
export type Result_11 = { ok: LeagueTable } | { err: Error };
export type Result_12 = { ok: LeagueStatus } | { err: Error };
export type Result_13 = { ok: Fixtures } | { err: Error };
export type Result_14 = { ok: DataTotals } | { err: Error };
export type Result_15 = { ok: DataHashes } | { err: Error };
export type Result_16 = { ok: Clubs } | { err: Error };
export type Result_17 = { ok: ClubValueLeaderboard } | { err: Error };
export type Result_18 = { ok: Canister } | { err: Error };
export type Result_19 = { ok: BettableLeagues } | { err: Error };
export type Result_2 = { ok: RetiredPlayers } | { err: Error };
export type Result_20 = { ok: BettableFixtures } | { err: Error };
export type Result_3 = { ok: PostponedFixtures } | { err: Error };
export type Result_4 = { ok: PlayersMap } | { err: Error };
export type Result_5 = { ok: Players } | { err: Error };
export type Result_6 = { ok: PlayerValueLeaderboard } | { err: Error };
export type Result_7 = { ok: PlayerDetailsForGameweek } | { err: Error };
export type Result_8 = { ok: PlayerDetails } | { err: Error };
export type Result_9 = { ok: LoanedPlayers } | { err: Error };
export interface RetirePlayer {
  playerId: ClubId;
  retirementDate: bigint;
  leagueId: LeagueId;
}
export interface RetiredPlayers {
  players: Array<Player>;
}
export interface RevaluePlayerDown {
  playerId: PlayerId;
  leagueId: LeagueId;
}
export interface RevaluePlayerUp {
  playerId: PlayerId;
  leagueId: LeagueId;
}
export type RustResult = { Ok: string } | { Err: string };
export interface Season {
  id: number;
  name: string;
  year: number;
}
export type SeasonId = number;
export interface Seasons {
  seasons: Array<Season>;
}
export interface SetFreeAgent {
  playerId: ClubId;
  newValueQuarterMillions: number;
  leagueId: LeagueId;
}
export interface SetPlayerInjury {
  playerId: ClubId;
  description: string;
  leagueId: LeagueId;
  expectedEndDate: bigint;
}
export type ShirtType = { Filled: null } | { Striped: null };
export interface Snapshot {
  id: SnapshotId;
  total_size: bigint;
  taken_at_timestamp: bigint;
}
export type SnapshotId = Uint8Array | number[];
export interface SubmitFixtureData {
  fixtureId: FixtureId;
  seasonId: SeasonId;
  gameweek: GameweekNumber;
  playerEventData: Array<PlayerEventData>;
  leagueId: LeagueId;
}
export interface TopupCanister {
  app: WaterwayLabsApp;
  cycles: bigint;
  canisterId: CanisterId;
}
export interface TransferPlayer {
  clubId: ClubId;
  newLeagueId: LeagueId;
  playerId: ClubId;
  newShirtNumber: number;
  newValueQuarterMillions: number;
  newClubId: ClubId;
  leagueId: LeagueId;
}
export interface UnretirePlayer {
  playerId: ClubId;
  newValueQuarterMillions: number;
  leagueId: LeagueId;
}
export interface UpdateClub {
  clubId: ClubId;
  secondaryColourHex: string;
  name: string;
  friendlyName: string;
  thirdColourHex: string;
  abbreviatedName: string;
  shirtType: ShirtType;
  primaryColourHex: string;
  leagueId: LeagueId;
}
export interface UpdateLeague {
  logo: Uint8Array | number[];
  name: string;
  teamCount: number;
  relatedGender: Gender;
  countryId: CountryId;
  abbreviation: string;
  governingBody: string;
  leagueId: LeagueId;
  formed: bigint;
}
export interface UpdatePlayer {
  dateOfBirth: bigint;
  playerId: ClubId;
  nationality: CountryId;
  shirtNumber: number;
  position: PlayerPosition;
  lastName: string;
  leagueId: LeagueId;
  firstName: string;
}
export interface ValueHistory {
  oldValue: number;
  changedOn: bigint;
  newValue: number;
}
export type WaterwayLabsApp =
  | { OpenFPL: null }
  | { OpenWSL: null }
  | { ICPCasino: null }
  | { FootballGod: null }
  | { ICF1: null }
  | { ICFC: null }
  | { ICGC: null }
  | { ICPFA: null }
  | { GolfPad: null }
  | { TransferKings: null }
  | { JeffBets: null }
  | { OpenBook: null }
  | { OpenCare: null }
  | { OpenChef: null }
  | { OpenBeats: null }
  | { WaterwayLabs: null };
export interface _SERVICE {
  addInitialFixtures: ActorMethod<[AddInitialFixtures], undefined>;
  calculateDataTotals: ActorMethod<[], undefined>;
  createClub: ActorMethod<[CreateClub], undefined>;
  createLeague: ActorMethod<[CreateLeague], undefined>;
  createPlayer: ActorMethod<[CreatePlayer], undefined>;
  getBettableFixtures: ActorMethod<[GetBettableFixtures], Result_20>;
  getBettableLeagues: ActorMethod<[GetBettableLeagues], Result_19>;
  getCanisterInfo: ActorMethod<[], Result_18>;
  getClubValueLeaderboard: ActorMethod<[GetClubValueLeaderboard], Result_17>;
  getClubs: ActorMethod<[GetClubs], Result_16>;
  getDataHashes: ActorMethod<[GetDataHashes], Result_15>;
  getDataTotals: ActorMethod<[GetDataTotals], Result_14>;
  getFixtures: ActorMethod<[GetFixtures], Result_13>;
  getLeagueStatus: ActorMethod<[GetLeagueStatus], Result_12>;
  getLeagueTable: ActorMethod<[GetLeagueTable], Result_11>;
  getLeagues: ActorMethod<[GetLeagues], Result_10>;
  getLoanedPlayers: ActorMethod<[GetLoanedPlayers], Result_9>;
  getPlayerDetails: ActorMethod<[GetPlayerDetails], Result_8>;
  getPlayerDetailsForGameweek: ActorMethod<
    [GetPlayerDetailsForGameweek],
    Result_7
  >;
  getPlayerValueLeaderboard: ActorMethod<[GetPlayerValueLeaderboard], Result_6>;
  getPlayers: ActorMethod<[GetPlayers], Result_5>;
  getPlayersMap: ActorMethod<[GetPlayersMap], Result_4>;
  getPostponedFixtures: ActorMethod<[GetPostponedFixtures], Result_3>;
  getRetiredPlayers: ActorMethod<[GetRetiredPlayers], Result_2>;
  getSeasons: ActorMethod<[GetSeasons], Result_1>;
  getSnapshotIds: ActorMethod<[], Array<Snapshot>>;
  loanPlayer: ActorMethod<[LoanPlayer], undefined>;
  moveFixture: ActorMethod<[MoveFixture], undefined>;
  postponeFixture: ActorMethod<[PostponeFixture], undefined>;
  recallPlayer: ActorMethod<[RecallPlayer], undefined>;
  rescheduleFixture: ActorMethod<[RescheduleFixture], undefined>;
  retirePlayer: ActorMethod<[RetirePlayer], undefined>;
  revaluePlayerDown: ActorMethod<[RevaluePlayerDown], undefined>;
  revaluePlayerUp: ActorMethod<[RevaluePlayerUp], undefined>;
  setFreeAgent: ActorMethod<[SetFreeAgent], undefined>;
  setPlayerInjury: ActorMethod<[SetPlayerInjury], undefined>;
  submitFixtureData: ActorMethod<[SubmitFixtureData], undefined>;
  transferCycles: ActorMethod<[TopupCanister], Result>;
  transferPlayer: ActorMethod<[TransferPlayer], undefined>;
  unretirePlayer: ActorMethod<[UnretirePlayer], undefined>;
  updateClub: ActorMethod<[UpdateClub], undefined>;
  updateLeague: ActorMethod<[UpdateLeague], undefined>;
  updatePlayer: ActorMethod<[UpdatePlayer], undefined>;
  validateAddInitialFixtures: ActorMethod<[AddInitialFixtures], RustResult>;
  validateCreateClub: ActorMethod<[CreateClub], RustResult>;
  validateCreateLeague: ActorMethod<[CreateLeague], RustResult>;
  validateCreatePlayer: ActorMethod<[CreatePlayer], RustResult>;
  validateLoanPlayer: ActorMethod<[LoanPlayer], RustResult>;
  validateMoveFixture: ActorMethod<[MoveFixture], RustResult>;
  validatePostponeFixture: ActorMethod<[PostponeFixture], RustResult>;
  validatePromoteClub: ActorMethod<[PromoteClub], RustResult>;
  validateRecallPlayer: ActorMethod<[RecallPlayer], RustResult>;
  validateRelegateClub: ActorMethod<[RelegateClub], RustResult>;
  validateRescheduleFixture: ActorMethod<[RescheduleFixture], RustResult>;
  validateRetirePlayer: ActorMethod<[RetirePlayer], RustResult>;
  validateRevaluePlayerDown: ActorMethod<[RevaluePlayerDown], RustResult>;
  validateRevaluePlayerUp: ActorMethod<[RevaluePlayerUp], RustResult>;
  validateSetFreeAgent: ActorMethod<[SetFreeAgent], RustResult>;
  validateSetPlayerInjury: ActorMethod<[SetPlayerInjury], RustResult>;
  validateSubmitFixtureData: ActorMethod<[SubmitFixtureData], RustResult>;
  validateTransferPlayer: ActorMethod<[TransferPlayer], RustResult>;
  validateUnretirePlayer: ActorMethod<[UnretirePlayer], RustResult>;
  validateUpdateClub: ActorMethod<[UpdateClub], RustResult>;
  validateUpdateLeague: ActorMethod<[UpdateLeague], RustResult>;
  validateUpdatePlayer: ActorMethod<[UpdatePlayer], RustResult>;
}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
