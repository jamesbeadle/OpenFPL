import type { Principal } from "@dfinity/principal";
import type { ActorMethod } from "@dfinity/agent";
import type { IDL } from "@dfinity/candid";

export interface AddInitialFixturesDTO {
  seasonFixtures: Array<FixtureDTO>;
}
export type CalendarMonth = number;
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
  logo: Uint8Array | number[];
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
  firstName: string;
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
  loanLeagueId: LeagueId;
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
  secondaryColourHex: string;
  name: string;
  friendlyName: string;
  thirdColourHex: string;
  abbreviatedName: string;
  shirtType: ShirtType;
  primaryColourHex: string;
}
export interface RecallPlayerDTO {
  playerId: ClubId;
}
export interface RelegateClubDTO {
  clubId: ClubId;
  leagueId: LeagueId;
}
export interface RemoveClubDTO {
  clubId: ClubId;
  leagueId: LeagueId;
}
export interface RequestFixturesDTO {
  seasonId: SeasonId;
  leagueId: LeagueId;
}
export interface RescheduleFixtureDTO {
  postponedFixtureId: FixtureId;
  updatedFixtureGameweek: GameweekNumber;
  updatedFixtureDate: bigint;
}
export type Result = { ok: null } | { err: Error };
export type Result_1 = { ok: Array<PlayerDTO> } | { err: Error };
export type Result_2 = { ok: Array<FixtureDTO> } | { err: Error };
export type Result_3 = { ok: Array<ClubDTO> } | { err: Error };
export type Result_4 = { ok: Array<SeasonDTO> } | { err: Error };
export type Result_5 = { ok: Array<[number, PlayerScoreDTO]> } | { err: Error };
export type Result_6 = { ok: Array<PlayerPointsDTO> } | { err: Error };
export type Result_7 = { ok: PlayerDetailDTO } | { err: Error };
export type Result_8 = { ok: Array<FootballLeagueDTO> } | { err: Error };
export interface RetirePlayerDTO {
  playerId: ClubId;
  retirementDate: bigint;
}
export interface RevaluePlayerDownDTO {
  playerId: ClubId;
  seasonId: SeasonId;
  gameweek: GameweekNumber;
}
export interface RevaluePlayerUpDTO {
  playerId: ClubId;
  seasonId: SeasonId;
  gameweek: GameweekNumber;
}
export interface SeasonDTO {
  id: SeasonId;
  name: string;
  year: number;
}
export type SeasonId = number;
export interface SetFreeAgentDTO {
  clubId: ClubId;
  playerId: ClubId;
  leagueId: LeagueId;
}
export interface SetPlayerInjuryDTO {
  playerId: ClubId;
  description: string;
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
export interface SystemState {
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
  newClubId: ClubId;
  leagueId: LeagueId;
}
export interface UnretirePlayerDTO {
  playerId: ClubId;
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
export interface UpdateClubDTO__1 {
  clubId: ClubId;
  secondaryColourHex: string;
  name: string;
  friendlyName: string;
  thirdColourHex: string;
  abbreviatedName: string;
  shirtType: ShirtType;
  primaryColourHex: string;
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
  firstName: string;
}
export interface ValueHistory {
  oldValue: number;
  changedOn: bigint;
  newValue: number;
}
export interface _SERVICE {
  checkGameweekComplete: ActorMethod<
    [LeagueId, SeasonId, GameweekNumber],
    boolean
  >;
  checkMonthComplete: ActorMethod<
    [LeagueId, SeasonId, CalendarMonth, GameweekNumber],
    boolean
  >;
  checkSeasonComplete: ActorMethod<[LeagueId, SeasonId], boolean>;
  createClub: ActorMethod<[CreateClubDTO], Result>;
  createLeague: ActorMethod<[CreateLeagueDTO], Result>;
  createNewSeason: ActorMethod<[SystemState], undefined>;
  createPlayer: ActorMethod<[LeagueId, CreatePlayerDTO], Result>;
  getClubs: ActorMethod<[LeagueId], Result_3>;
  getFixtures: ActorMethod<[RequestFixturesDTO], Result_2>;
  getLeagueClubs: ActorMethod<[], Array<[LeagueId, Array<Club>]>>;
  getLeaguePlayers: ActorMethod<[], Array<[LeagueId, Array<Player>]>>;
  getLeagues: ActorMethod<[], Result_8>;
  getLoanedPlayers: ActorMethod<[LeagueId, ClubFilterDTO], Result_1>;
  getPlayerDetails: ActorMethod<[LeagueId, GetPlayerDetailsDTO], Result_7>;
  getPlayerDetailsForGameweek: ActorMethod<
    [LeagueId, GameweekFiltersDTO],
    Result_6
  >;
  getPlayers: ActorMethod<[LeagueId], Result_1>;
  getPlayersMap: ActorMethod<[LeagueId, GameweekFiltersDTO], Result_5>;
  getPostponedFixtures: ActorMethod<[LeagueId, RequestFixturesDTO], Result_2>;
  getRetiredPlayers: ActorMethod<[LeagueId, ClubFilterDTO], Result_1>;
  getSeasons: ActorMethod<[LeagueId], Result_4>;
  getVerifiedClubs: ActorMethod<[LeagueId], Result_3>;
  getVerifiedFixtures: ActorMethod<[RequestFixturesDTO], Result_2>;
  getVerifiedPlayers: ActorMethod<[LeagueId], Result_1>;
  loanPlayer: ActorMethod<[LeagueId, LoanPlayerDTO], Result>;
  moveFixture: ActorMethod<[MoveFixtureDTO], Result>;
  populatePlayerEventData: ActorMethod<
    [SubmitFixtureDataDTO, Array<Player>],
    [] | [Array<PlayerEventData>]
  >;
  postponeFixture: ActorMethod<[PostponeFixtureDTO], Result>;
  promoteClub: ActorMethod<[LeagueId, PromoteClubDTO], Result>;
  recallPlayer: ActorMethod<[LeagueId, RecallPlayerDTO], Result>;
  relegateClub: ActorMethod<[LeagueId, RelegateClubDTO], Result>;
  removeClub: ActorMethod<[RemoveClubDTO], Result>;
  retirePlayer: ActorMethod<[LeagueId, RetirePlayerDTO], Result>;
  revaluePlayerDown: ActorMethod<[LeagueId, RevaluePlayerDownDTO], Result>;
  revaluePlayerUp: ActorMethod<[LeagueId, RevaluePlayerUpDTO], Result>;
  setFixtureToComplete: ActorMethod<[LeagueId, SeasonId, FixtureId], undefined>;
  setFreeAgent: ActorMethod<[LeagueId, SetFreeAgentDTO], Result>;
  setPlayerInjury: ActorMethod<[LeagueId, SetPlayerInjuryDTO], Result>;
  submitFixtureData: ActorMethod<[SubmitFixtureDataDTO], Result>;
  transferPlayer: ActorMethod<[LeagueId, TransferPlayerDTO], Result>;
  unretirePlayer: ActorMethod<[UnretirePlayerDTO], Result>;
  updateClub: ActorMethod<[UpdateClubDTO__1], Result>;
  updateLeague: ActorMethod<[UpdateLeagueDTO], Result>;
  updatePlayer: ActorMethod<[LeagueId, UpdatePlayerDTO], Result>;
  validateAddInitialFixtures: ActorMethod<
    [LeagueId, AddInitialFixturesDTO],
    Result
  >;
  validateCreateClub: ActorMethod<[LeagueId, CreateClubDTO], Result>;
  validateCreateLeague: ActorMethod<[CreateLeagueDTO], Result>;
  validateCreatePlayer: ActorMethod<[LeagueId, CreatePlayerDTO], Result>;
  validateLoanPlayer: ActorMethod<[LeagueId, LoanPlayerDTO], Result>;
  validateMoveFixture: ActorMethod<[LeagueId, MoveFixtureDTO], Result>;
  validatePostponeFixture: ActorMethod<[LeagueId, PostponeFixtureDTO], Result>;
  validatePromoteClub: ActorMethod<[LeagueId, PromoteClubDTO], Result>;
  validateRecallPlayer: ActorMethod<[LeagueId, RecallPlayerDTO], Result>;
  validateRelegateClub: ActorMethod<[LeagueId, RelegateClubDTO], Result>;
  validateRescehduleFixture: ActorMethod<
    [LeagueId, RescheduleFixtureDTO],
    Result
  >;
  validateRetirePlayer: ActorMethod<[LeagueId, RetirePlayerDTO], Result>;
  validateRevaluePlayerDown: ActorMethod<
    [LeagueId, RevaluePlayerDownDTO],
    Result
  >;
  validateRevaluePlayerUp: ActorMethod<[LeagueId, RevaluePlayerUpDTO], Result>;
  validateSetFreeAgent: ActorMethod<[LeagueId, SetFreeAgentDTO], Result>;
  validateSetPlayerInjury: ActorMethod<[LeagueId, SetPlayerInjuryDTO], Result>;
  validateSubmitFixtureData: ActorMethod<
    [LeagueId, SubmitFixtureDataDTO],
    Result
  >;
  validateTransferPlayer: ActorMethod<[LeagueId, TransferPlayerDTO], Result>;
  validateUnretirePlayer: ActorMethod<[LeagueId, UnretirePlayerDTO], Result>;
  validateUpdateClub: ActorMethod<[LeagueId, UpdateClubDTO], Result>;
  validateUpdateLeague: ActorMethod<[UpdateLeagueDTO], Result>;
  validateUpdatePlayer: ActorMethod<[LeagueId, UpdatePlayerDTO], Result>;
  validationRemoveClub: ActorMethod<[LeagueId, RemoveClubDTO], Result>;
}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
