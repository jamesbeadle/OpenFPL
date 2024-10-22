import type { Principal } from "@dfinity/principal";
import type { ActorMethod } from "@dfinity/agent";
import type { IDL } from "@dfinity/candid";

export interface AddInitialFixturesDTO {
  seasonFixtures: Array<FixtureDTO>;
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
  playerId: ClubId;
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
export interface SetPlayerInjuryDTO {
  playerId: ClubId;
  description: string;
  expectedEndDate: bigint;
}
export type ShirtType = { Filled: null } | { Striped: null };
export interface SubmitFixtureDataDTO {
  fixtureId: FixtureId;
  month: CalendarMonth;
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
  executeSubmitFixtureData: ActorMethod<[SubmitFixtureDataDTO], undefined>;
  getClubs: ActorMethod<[LeagueId], Result_3>;
  getFixtures: ActorMethod<[LeagueId, RequestFixturesDTO], Result_2>;
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
  getVerifiedFixtures: ActorMethod<[LeagueId, RequestFixturesDTO], Result_2>;
  getVerifiedPlayers: ActorMethod<[LeagueId, RequestPlayersDTO], Result_1>;
  loanPlayer: ActorMethod<[LeagueId, LoanPlayerDTO], Result>;
  promoteNewClub: ActorMethod<[LeagueId, PromoteNewClubDTO], Result>;
  retirePlayer: ActorMethod<[LeagueId, RetirePlayerDTO], Result>;
  revaluePlayerDown: ActorMethod<[LeagueId, RevaluePlayerDownDTO], Result>;
  revaluePlayerUp: ActorMethod<[LeagueId, RevaluePlayerUpDTO], Result>;
  setFixtureToComplete: ActorMethod<[LeagueId, SeasonId, FixtureId], undefined>;
  setFixtureToFinalised: ActorMethod<
    [LeagueId, SeasonId, FixtureId],
    undefined
  >;
  setGameScore: ActorMethod<[LeagueId, SeasonId, FixtureId], undefined>;
  setPlayerInjury: ActorMethod<[LeagueId, SetPlayerInjuryDTO], Result>;
  setupData: ActorMethod<[], Result>;
  transferPlayer: ActorMethod<[LeagueId, TransferPlayerDTO], Result>;
  unretirePlayer: ActorMethod<[UnretirePlayerDTO], Result>;
  updateClub: ActorMethod<[UpdateClubDTO__1], Result>;
  updateLeague: ActorMethod<[UpdateLeagueDTO], Result>;
  updatePlayer: ActorMethod<[LeagueId, UpdatePlayerDTO], Result>;
  validateAddInitialFixtures: ActorMethod<
    [LeagueId, AddInitialFixturesDTO],
    Result
  >;
  validateCreatePlayer: ActorMethod<[LeagueId, CreatePlayerDTO], Result>;
  validateLoanPlayer: ActorMethod<[LeagueId, LoanPlayerDTO], Result>;
  validateMoveFixture: ActorMethod<[LeagueId, MoveFixtureDTO], Result>;
  validatePostponeFixture: ActorMethod<[LeagueId, PostponeFixtureDTO], Result>;
  validateRecallPlayer: ActorMethod<[LeagueId, RecallPlayerDTO], Result>;
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
  validateSetPlayerInjury: ActorMethod<[LeagueId, SetPlayerInjuryDTO], Result>;
  validateSubmitFixtureData: ActorMethod<
    [LeagueId, SubmitFixtureDataDTO],
    Result
  >;
  validateTransferPlayer: ActorMethod<[LeagueId, TransferPlayerDTO], Result>;
  validateUnretirePlayer: ActorMethod<[LeagueId, UnretirePlayerDTO], Result>;
  validateUpdateClub: ActorMethod<[LeagueId, UpdateClubDTO], Result>;
  validateUpdatePlayer: ActorMethod<[LeagueId, UpdatePlayerDTO], Result>;
}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
