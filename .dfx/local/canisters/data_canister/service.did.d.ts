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
export interface ClubFilterDTO {
  clubId: ClubId;
  leagueId: FootballLeagueId;
}
export type ClubId = number;
export type CountryId = number;
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
  gender: Gender;
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
export interface FootballLeague {
  id: FootballLeagueId;
  logo: Uint8Array | number[];
  name: string;
  teamCount: number;
  relatedGender: Gender;
  countryId: CountryId;
  abbreviation: string;
  governingBody: string;
  formed: bigint;
}
export type FootballLeagueId = number;
export interface GameweekFiltersDTO {
  seasonId: SeasonId;
  gameweek: GameweekNumber;
}
export type GameweekNumber = number;
export type Gender = { Male: null } | { Female: null };
export interface GetPlayerDetailsDTO {
  playerId: PlayerId;
  seasonId: SeasonId;
}
export interface InjuryHistory {
  description: string;
  injuryStartDate: bigint;
  expectedEndDate: bigint;
}
export interface LoanPlayerDTO {
  loanEndDate: bigint;
  playerId: PlayerId;
  seasonId: SeasonId;
  loanClubId: ClubId;
  gameweek: GameweekNumber;
  loanLeagueId: FootballLeagueId;
}
export interface MoveFixtureDTO {
  fixtureId: FixtureId;
  updatedFixtureGameweek: GameweekNumber;
  updatedFixtureDate: bigint;
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
export interface RequestFixturesDTO {
  seasonId: SeasonId;
}
export interface RequestPlayersDTO {
  seasonId: SeasonId;
}
export interface RescheduleFixtureDTO {
  postponedFixtureId: FixtureId;
  updatedFixtureGameweek: GameweekNumber;
  updatedFixtureDate: bigint;
}
export type Result = { ok: null } | { err: Error };
export type Result_1 = { ok: Array<SeasonDTO> } | { err: Error };
export type Result_2 = { ok: Array<PlayerDTO> } | { err: Error };
export type Result_3 = { ok: Array<FixtureDTO> } | { err: Error };
export type Result_4 = { ok: Array<[number, PlayerScoreDTO]> } | { err: Error };
export type Result_5 = { ok: Array<PlayerPointsDTO> } | { err: Error };
export type Result_6 = { ok: PlayerDetailDTO } | { err: Error };
export type Result_7 = { ok: Array<FootballLeague> } | { err: Error };
export type Result_8 = { ok: Array<Club> } | { err: Error };
export interface RetirePlayerDTO {
  playerId: PlayerId;
  retirementDate: bigint;
}
export interface RevaluePlayerDownDTO {
  playerId: PlayerId;
  seasonId: SeasonId;
  gameweek: GameweekNumber;
}
export interface RevaluePlayerUpDTO {
  playerId: PlayerId;
  seasonId: SeasonId;
  gameweek: GameweekNumber;
}
export interface SeasonDTO {
  id: SeasonId;
  name: string;
  year: number;
}
export type SeasonId = number;
export interface SetPlayerInjuryDTO {
  playerId: PlayerId;
  description: string;
  expectedEndDate: bigint;
}
export type ShirtType = { Filled: null } | { Striped: null };
export interface SubmitFixtureDataDTO {
  fixtureId: FixtureId;
  month: CalendarMonth;
  gameweek: GameweekNumber;
  playerEventData: Array<PlayerEventData>;
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
export interface TransferPlayerDTO {
  clubId: ClubId;
  newLeagueId: FootballLeagueId;
  playerId: PlayerId;
  newShirtNumber: number;
  seasonId: SeasonId;
  newClubId: ClubId;
  gameweek: GameweekNumber;
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
export interface ValueHistory {
  oldValue: number;
  newValue: number;
  seasonId: number;
  gameweek: number;
}
export interface _SERVICE {
  addEventsToFixture: ActorMethod<
    [FootballLeagueId, Array<PlayerEventData>, SeasonId, FixtureId],
    undefined
  >;
  addEventsToPlayers: ActorMethod<
    [FootballLeagueId, Array<PlayerEventData>, SeasonId, GameweekNumber],
    undefined
  >;
  checkGameweekComplete: ActorMethod<
    [FootballLeagueId, SeasonId, GameweekNumber],
    boolean
  >;
  checkMonthComplete: ActorMethod<
    [FootballLeagueId, SeasonId, CalendarMonth, GameweekNumber],
    boolean
  >;
  checkSeasonComplete: ActorMethod<[FootballLeagueId, SeasonId], boolean>;
  createLeague: ActorMethod<[CreateLeagueDTO], Result>;
  createNewSeason: ActorMethod<[SystemState], undefined>;
  createPlayer: ActorMethod<[FootballLeagueId, CreatePlayerDTO], Result>;
  getClubs: ActorMethod<[FootballLeagueId], Result_8>;
  getFixtures: ActorMethod<[FootballLeagueId, RequestFixturesDTO], Result_3>;
  getLeagues: ActorMethod<[], Result_7>;
  getLoanedPlayers: ActorMethod<[FootballLeagueId, ClubFilterDTO], Result_2>;
  getPlayerDetails: ActorMethod<
    [FootballLeagueId, GetPlayerDetailsDTO],
    Result_6
  >;
  getPlayerDetailsForGameweek: ActorMethod<
    [FootballLeagueId, GameweekFiltersDTO],
    Result_5
  >;
  getPlayers: ActorMethod<[FootballLeagueId, RequestPlayersDTO], Result_2>;
  getPlayersMap: ActorMethod<[FootballLeagueId, GameweekFiltersDTO], Result_4>;
  getPostponedFixtures: ActorMethod<
    [FootballLeagueId, RequestFixturesDTO],
    Result_3
  >;
  getRetiredPlayers: ActorMethod<[FootballLeagueId, ClubFilterDTO], Result_2>;
  getSeasons: ActorMethod<[FootballLeagueId], Result_1>;
  loanPlayer: ActorMethod<[FootballLeagueId, LoanPlayerDTO], Result>;
  promoteNewClub: ActorMethod<[FootballLeagueId, PromoteNewClubDTO], Result>;
  retirePlayer: ActorMethod<[FootballLeagueId, RetirePlayerDTO], Result>;
  revaluePlayerDown: ActorMethod<
    [FootballLeagueId, RevaluePlayerDownDTO],
    Result
  >;
  revaluePlayerUp: ActorMethod<[FootballLeagueId, RevaluePlayerUpDTO], Result>;
  setAbbreviatedLeagueName: ActorMethod<[FootballLeagueId, string], Result>;
  setFixtureToComplete: ActorMethod<
    [FootballLeagueId, SeasonId, FixtureId],
    undefined
  >;
  setFixtureToFinalised: ActorMethod<
    [FootballLeagueId, SeasonId, FixtureId],
    undefined
  >;
  setGameScore: ActorMethod<[FootballLeagueId, SeasonId, FixtureId], undefined>;
  setLeagueCountryId: ActorMethod<[FootballLeagueId, CountryId], Result>;
  setLeagueDateFormed: ActorMethod<[FootballLeagueId, bigint], Result>;
  setLeagueGender: ActorMethod<[FootballLeagueId, Gender], Result>;
  setLeagueGoverningBody: ActorMethod<[FootballLeagueId, string], Result>;
  setLeagueLogo: ActorMethod<[FootballLeagueId, Uint8Array | number[]], Result>;
  setLeagueName: ActorMethod<[FootballLeagueId, string], Result>;
  setPlayerInjury: ActorMethod<[FootballLeagueId, SetPlayerInjuryDTO], Result>;
  setTeamCount: ActorMethod<[FootballLeagueId, number], Result>;
  setupData: ActorMethod<[], Result>;
  transferPlayer: ActorMethod<[FootballLeagueId, TransferPlayerDTO], Result>;
  unretirePlayer: ActorMethod<[UnretirePlayerDTO], Result>;
  updateClub: ActorMethod<[UpdateClubDTO], Result>;
  updatePlayer: ActorMethod<[FootballLeagueId, UpdatePlayerDTO], Result>;
  validateAddInitialFixtures: ActorMethod<
    [FootballLeagueId, AddInitialFixturesDTO],
    Result
  >;
  validateCreatePlayer: ActorMethod<
    [FootballLeagueId, CreatePlayerDTO],
    Result
  >;
  validateLoanPlayer: ActorMethod<[FootballLeagueId, LoanPlayerDTO], Result>;
  validateMoveFixture: ActorMethod<[FootballLeagueId, MoveFixtureDTO], Result>;
  validatePostponeFixture: ActorMethod<
    [FootballLeagueId, PostponeFixtureDTO],
    Result
  >;
  validateRecallPlayer: ActorMethod<
    [FootballLeagueId, RecallPlayerDTO],
    Result
  >;
  validateRescehduleFixture: ActorMethod<
    [FootballLeagueId, RescheduleFixtureDTO],
    Result
  >;
  validateRetirePlayer: ActorMethod<
    [FootballLeagueId, RetirePlayerDTO],
    Result
  >;
  validateRevaluePlayerDown: ActorMethod<
    [FootballLeagueId, RevaluePlayerDownDTO],
    Result
  >;
  validateRevaluePlayerUp: ActorMethod<
    [FootballLeagueId, RevaluePlayerUpDTO],
    Result
  >;
  validateSetPlayerInjury: ActorMethod<
    [FootballLeagueId, SetPlayerInjuryDTO],
    Result
  >;
  validateSubmitFixtureData: ActorMethod<
    [FootballLeagueId, SubmitFixtureDataDTO],
    Result
  >;
  validateTransferPlayer: ActorMethod<
    [FootballLeagueId, TransferPlayerDTO],
    Result
  >;
  validateUnretirePlayer: ActorMethod<
    [FootballLeagueId, UnretirePlayerDTO],
    Result
  >;
  validateUpdateClub: ActorMethod<[FootballLeagueId, UpdateClubDTO], Result>;
  validateUpdatePlayer: ActorMethod<
    [FootballLeagueId, UpdatePlayerDTO],
    Result
  >;
}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
