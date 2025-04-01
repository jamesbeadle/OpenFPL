import type { Principal } from "@dfinity/principal";
import type { ActorMethod } from "@dfinity/agent";
import type { IDL } from "@dfinity/candid";

export interface AddInitialFixturesDTO {
  seasonId: SeasonId;
  seasonFixtures: Array<FixtureDTO>;
  leagueId: LeagueId;
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
export interface CreateClubDTO {
  secondaryColourHex: string;
  name: string;
  friendlyName: string;
  thirdColourHex: string;
  abbreviatedName: string;
  shirtType: ShirtType;
  primaryColourHex: string;
  leagueId: LeagueId;
}
export interface CreateLeagueDTO {
  logo: [] | [Uint8Array | number[]];
  name: string;
  teamCount: number;
  relatedGender: Gender;
  countryId: CountryId;
  abbreviation: string;
  governingBody: string;
  formed: bigint;
}
export interface CreatePlayerDTO {
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
export interface DataHashDTO {
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
  | { CanisterCreateError: null }
  | { FailedInterCanisterCall: null }
  | { CanisterFull: null };
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
export interface FootballLeagueDTO {
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
export interface GameweekFiltersDTO {
  seasonId: SeasonId;
  gameweek: GameweekNumber;
}
export type GameweekNumber = number;
export type Gender = { Male: null } | { Female: null };
export interface GetPlayerDetailsDTO {
  playerId: ClubId;
  seasonId: SeasonId;
}
export interface InjuryHistory {
  description: string;
  injuryStartDate: bigint;
  expectedEndDate: bigint;
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
export type List = [] | [[InjuryHistory, List]];
export type List_1 = [] | [[PlayerSeason, List_1]];
export type List_2 = [] | [[PlayerGameweek, List_2]];
export type List_3 = [] | [[PlayerEventData, List_3]];
export type List_4 = [] | [[TransferHistory, List_4]];
export type List_5 = [] | [[ValueHistory, List_5]];
export interface LoanPlayerDTO {
  loanEndDate: bigint;
  playerId: ClubId;
  loanClubId: ClubId;
  newValueQuarterMillions: number;
  loanLeagueId: LeagueId;
  leagueId: LeagueId;
}
export interface LoanedPlayerDTO {
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
export interface MoveFixtureDTO {
  fixtureId: FixtureId;
  updatedFixtureGameweek: GameweekNumber;
  updatedFixtureDate: bigint;
  seasonId: SeasonId;
  leagueId: LeagueId;
}
export interface Player {
  id: PlayerId;
  status: PlayerStatus;
  clubId: ClubId;
  parentClubId: ClubId;
  seasons: List_1;
  valueQuarterMillions: number;
  dateOfBirth: bigint;
  injuryHistory: List;
  transferHistory: List_4;
  nationality: CountryId;
  retirementDate: bigint;
  valueHistory: List_5;
  latestInjuryEndDate: bigint;
  gender: Gender;
  currentLoanEndDate: bigint;
  shirtNumber: number;
  parentLeagueId: LeagueId;
  position: PlayerPosition;
  lastName: string;
  leagueId: LeagueId;
  firstName: string;
}
export interface PlayerDTO {
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
export interface PlayerGameweek {
  events: List_3;
  number: GameweekNumber;
  points: number;
}
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
export interface PlayerSeason {
  id: SeasonId;
  gameweeks: List_2;
  totalPoints: number;
}
export type PlayerStatus =
  | { OnLoan: null }
  | { Active: null }
  | { FreeAgent: null }
  | { Retired: null };
export interface PostponeFixtureDTO {
  fixtureId: FixtureId;
  seasonId: SeasonId;
  leagueId: LeagueId;
}
export interface PromoteClubDTO {
  clubId: ClubId;
  toLeagueId: LeagueId;
  leagueId: LeagueId;
}
export interface RecallPlayerDTO {
  playerId: ClubId;
  newValueQuarterMillions: number;
  leagueId: LeagueId;
}
export interface RelegateClubDTO {
  clubId: ClubId;
  relegatedToLeagueId: LeagueId;
  leagueId: LeagueId;
}
export interface RescheduleFixtureDTO {
  fixtureId: FixtureId;
  updatedFixtureGameweek: GameweekNumber;
  updatedFixtureDate: bigint;
  seasonId: SeasonId;
  leagueId: LeagueId;
}
export type Result = { ok: Array<PlayerDTO> } | { err: Error };
export type Result_1 = { ok: Array<FixtureDTO> } | { err: Error };
export type Result_10 = { ok: LeagueStatus } | { err: Error };
export type Result_11 = { ok: Array<[LeagueId, LeagueId]> } | { err: Error };
export type Result_12 =
  | { ok: [LeagueId, Uint16Array | number[]] }
  | { err: Error };
export type Result_13 = { ok: Array<DataHashDTO> } | { err: Error };
export type Result_14 = { ok: Array<CountryDTO> } | { err: Error };
export type Result_2 = { ok: Array<ClubDTO> } | { err: Error };
export type Result_3 = { ok: Array<FootballLeagueDTO> } | { err: Error };
export type Result_4 = { ok: Array<SeasonDTO> } | { err: Error };
export type Result_5 = { ok: Array<[number, PlayerScoreDTO]> } | { err: Error };
export type Result_6 = { ok: Array<PlayerPointsDTO> } | { err: Error };
export type Result_7 = { ok: PlayerDetailDTO } | { err: Error };
export type Result_8 = { ok: Array<LoanedPlayerDTO> } | { err: Error };
export type Result_9 = { ok: LeagueTable } | { err: Error };
export interface RetirePlayerDTO {
  playerId: ClubId;
  retirementDate: bigint;
  leagueId: LeagueId;
}
export interface RevaluePlayerDownDTO {
  playerId: PlayerId;
  leagueId: LeagueId;
}
export interface RevaluePlayerUpDTO {
  playerId: PlayerId;
  leagueId: LeagueId;
}
export type RustResult = { Ok: string } | { Err: string };
export interface SeasonDTO {
  id: SeasonId;
  name: string;
  year: number;
}
export type SeasonId = number;
export interface SetFreeAgentDTO {
  playerId: ClubId;
  newValueQuarterMillions: number;
  leagueId: LeagueId;
}
export interface SetPlayerInjuryDTO {
  playerId: ClubId;
  description: string;
  leagueId: LeagueId;
  expectedEndDate: bigint;
}
export type ShirtType = { Filled: null } | { Striped: null };
export interface SubmitFixtureDataDTO {
  fixtureId: FixtureId;
  seasonId: SeasonId;
  gameweek: GameweekNumber;
  playerEventData: Array<PlayerEventData>;
  leagueId: LeagueId;
}
export interface TransferHistory {
  transferDate: bigint;
  loanEndDate: bigint;
  toLeagueId: LeagueId;
  toClub: ClubId;
  fromLeagueId: LeagueId;
  fromClub: ClubId;
}
export interface TransferPlayerDTO {
  clubId: ClubId;
  newLeagueId: LeagueId;
  playerId: ClubId;
  newShirtNumber: number;
  newValueQuarterMillions: number;
  newClubId: ClubId;
  leagueId: LeagueId;
}
export interface UnretirePlayerDTO {
  playerId: ClubId;
  newValueQuarterMillions: number;
  leagueId: LeagueId;
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
  leagueId: LeagueId;
}
export interface UpdateLeagueDTO {
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
export interface UpdatePlayerDTO {
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
export interface _SERVICE {
  addInitialFixtures: ActorMethod<[AddInitialFixturesDTO], undefined>;
  createClub: ActorMethod<[CreateClubDTO], undefined>;
  createLeague: ActorMethod<[CreateLeagueDTO], undefined>;
  createPlayer: ActorMethod<[CreatePlayerDTO], undefined>;
  getBettableFixtures: ActorMethod<[LeagueId, SeasonId], Result_1>;
  getClubs: ActorMethod<[LeagueId], Result_2>;
  getCountries: ActorMethod<[], Result_14>;
  getDataHashes: ActorMethod<[LeagueId], Result_13>;
  getFixtures: ActorMethod<[LeagueId, SeasonId], Result_1>;
  getLeagueClubsRequiringData: ActorMethod<[LeagueId], Result_12>;
  getLeagueRelegationPairs: ActorMethod<[], Result_11>;
  getLeagueStatus: ActorMethod<[LeagueId], Result_10>;
  getLeagueTable: ActorMethod<[LeagueId, SeasonId], Result_9>;
  getLeagues: ActorMethod<[], Result_3>;
  getLoanedPlayers: ActorMethod<[LeagueId], Result_8>;
  getPlayerDetails: ActorMethod<[LeagueId, GetPlayerDetailsDTO], Result_7>;
  getPlayerDetailsForGameweek: ActorMethod<
    [LeagueId, GameweekFiltersDTO],
    Result_6
  >;
  getPlayers: ActorMethod<[LeagueId], Result>;
  getPlayersMap: ActorMethod<[LeagueId, GameweekFiltersDTO], Result_5>;
  getPostponedFixtures: ActorMethod<[LeagueId], Result_1>;
  getRetiredPlayers: ActorMethod<[LeagueId, ClubFilterDTO], Result>;
  getSeasons: ActorMethod<[LeagueId], Result_4>;
  getUpToDateLeagues: ActorMethod<[], Result_3>;
  getVerifiedClubs: ActorMethod<[LeagueId], Result_2>;
  getVerifiedFixtures: ActorMethod<[LeagueId, SeasonId], Result_1>;
  getVerifiedPlayers: ActorMethod<[LeagueId], Result>;
  loanPlayer: ActorMethod<[LoanPlayerDTO], undefined>;
  moveFixture: ActorMethod<[MoveFixtureDTO], undefined>;
  populatePlayerEventData: ActorMethod<
    [SubmitFixtureDataDTO, Array<Player>],
    [] | [Array<PlayerEventData>]
  >;
  postponeFixture: ActorMethod<[PostponeFixtureDTO], undefined>;
  recallPlayer: ActorMethod<[RecallPlayerDTO], undefined>;
  rescheduleFixture: ActorMethod<[RescheduleFixtureDTO], undefined>;
  retirePlayer: ActorMethod<[RetirePlayerDTO], undefined>;
  revaluePlayerDown: ActorMethod<[RevaluePlayerDownDTO], undefined>;
  revaluePlayerUp: ActorMethod<[RevaluePlayerUpDTO], undefined>;
  setFreeAgent: ActorMethod<[SetFreeAgentDTO], undefined>;
  setPlayerInjury: ActorMethod<[SetPlayerInjuryDTO], undefined>;
  submitFixtureData: ActorMethod<[SubmitFixtureDataDTO], undefined>;
  transferPlayer: ActorMethod<[TransferPlayerDTO], undefined>;
  unretirePlayer: ActorMethod<[UnretirePlayerDTO], undefined>;
  updateClub: ActorMethod<[UpdateClubDTO], undefined>;
  updateLeague: ActorMethod<[UpdateLeagueDTO], undefined>;
  updatePlayer: ActorMethod<[UpdatePlayerDTO], undefined>;
  validateAddInitialFixtures: ActorMethod<[AddInitialFixturesDTO], RustResult>;
  validateCreateClub: ActorMethod<[CreateClubDTO], RustResult>;
  validateCreateLeague: ActorMethod<[CreateLeagueDTO], RustResult>;
  validateCreatePlayer: ActorMethod<[CreatePlayerDTO], RustResult>;
  validateLoanPlayer: ActorMethod<[LoanPlayerDTO], RustResult>;
  validateMoveFixture: ActorMethod<[MoveFixtureDTO], RustResult>;
  validatePostponeFixture: ActorMethod<[PostponeFixtureDTO], RustResult>;
  validatePromoteClub: ActorMethod<[PromoteClubDTO], RustResult>;
  validateRecallPlayer: ActorMethod<[RecallPlayerDTO], RustResult>;
  validateRelegateClub: ActorMethod<[RelegateClubDTO], RustResult>;
  validateRescheduleFixture: ActorMethod<[RescheduleFixtureDTO], RustResult>;
  validateRetirePlayer: ActorMethod<[RetirePlayerDTO], RustResult>;
  validateRevaluePlayerDown: ActorMethod<[RevaluePlayerDownDTO], RustResult>;
  validateRevaluePlayerUp: ActorMethod<[RevaluePlayerUpDTO], RustResult>;
  validateSetFreeAgent: ActorMethod<[SetFreeAgentDTO], RustResult>;
  validateSetPlayerInjury: ActorMethod<[SetPlayerInjuryDTO], RustResult>;
  validateSubmitFixtureData: ActorMethod<[SubmitFixtureDataDTO], RustResult>;
  validateTransferPlayer: ActorMethod<[TransferPlayerDTO], RustResult>;
  validateUnretirePlayer: ActorMethod<[UnretirePlayerDTO], RustResult>;
  validateUpdateClub: ActorMethod<[UpdateClubDTO], RustResult>;
  validateUpdateLeague: ActorMethod<[UpdateLeagueDTO], RustResult>;
  validateUpdatePlayer: ActorMethod<[UpdatePlayerDTO], RustResult>;
}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
