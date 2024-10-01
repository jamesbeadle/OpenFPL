import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';
import type { IDL } from '@dfinity/candid';

export interface AddInitialFixturesDTO {
  'seasonId' : SeasonId,
  'seasonFixtures' : Array<FixtureDTO>,
}
export type CalendarMonth = number;
export interface Club {
  'id' : ClubId,
  'secondaryColourHex' : string,
  'name' : string,
  'friendlyName' : string,
  'thirdColourHex' : string,
  'abbreviatedName' : string,
  'shirtType' : ShirtType,
  'primaryColourHex' : string,
}
export type ClubId = number;
export type CountryId = number;
export interface CreatePlayerDTO {
  'clubId' : ClubId,
  'valueQuarterMillions' : number,
  'dateOfBirth' : bigint,
  'nationality' : CountryId,
  'gender' : Gender,
  'shirtNumber' : number,
  'position' : PlayerPosition,
  'lastName' : string,
  'leagueId' : FootballLeagueId,
  'firstName' : string,
}
export type Error = { 'MoreThan2PlayersFromClub' : null } |
  { 'DecodeError' : null } |
  { 'NotAllowed' : null } |
  { 'DuplicatePlayerInTeam' : null } |
  { 'InvalidBonuses' : null } |
  { 'TooManyTransfers' : null } |
  { 'NotFound' : null } |
  { 'NumberPerPositionError' : null } |
  { 'TeamOverspend' : null } |
  { 'NotAuthorized' : null } |
  { 'SelectedCaptainNotInTeam' : null } |
  { 'InvalidData' : null } |
  { 'SystemOnHold' : null } |
  { 'AlreadyExists' : null } |
  { 'CanisterCreateError' : null } |
  { 'Not11Players' : null };
export interface FixtureDTO {
  'id' : number,
  'status' : FixtureStatusType,
  'highestScoringPlayerId' : number,
  'seasonId' : SeasonId,
  'awayClubId' : ClubId,
  'events' : Array<PlayerEventData>,
  'homeClubId' : ClubId,
  'kickOff' : bigint,
  'homeGoals' : number,
  'gameweek' : GameweekNumber,
  'awayGoals' : number,
}
export type FixtureId = number;
export type FixtureStatusType = { 'Unplayed' : null } |
  { 'Finalised' : null } |
  { 'Active' : null } |
  { 'Complete' : null };
export type FootballLeagueId = number;
export interface GameweekFiltersDTO {
  'seasonId' : SeasonId,
  'gameweek' : GameweekNumber,
  'leagueId' : FootballLeagueId,
}
export type GameweekNumber = number;
export type Gender = { 'Male' : null } |
  { 'Female' : null };
export interface GetPlayerDetailsDTO {
  'playerId' : PlayerId,
  'seasonId' : SeasonId,
  'leagueId' : FootballLeagueId,
}
export interface InjuryHistory {
  'description' : string,
  'injuryStartDate' : bigint,
  'expectedEndDate' : bigint,
}
export interface LoanPlayerDTO {
  'loanEndDate' : bigint,
  'playerId' : PlayerId,
  'seasonId' : SeasonId,
  'loanClubId' : ClubId,
  'gameweek' : GameweekNumber,
  'loanLeagueId' : FootballLeagueId,
  'leagueId' : FootballLeagueId,
}
export interface MoveFixtureDTO {
  'fixtureId' : FixtureId,
  'updatedFixtureGameweek' : GameweekNumber,
  'updatedFixtureDate' : bigint,
}
export interface PlayerDTO {
  'id' : number,
  'status' : PlayerStatus,
  'clubId' : ClubId,
  'valueQuarterMillions' : number,
  'dateOfBirth' : bigint,
  'nationality' : CountryId,
  'shirtNumber' : number,
  'totalPoints' : number,
  'position' : PlayerPosition,
  'lastName' : string,
  'firstName' : string,
}
export interface PlayerDetailDTO {
  'id' : PlayerId,
  'status' : PlayerStatus,
  'clubId' : ClubId,
  'parentClubId' : ClubId,
  'valueQuarterMillions' : number,
  'dateOfBirth' : bigint,
  'injuryHistory' : Array<InjuryHistory>,
  'seasonId' : SeasonId,
  'gameweeks' : Array<PlayerGameweekDTO>,
  'nationality' : CountryId,
  'retirementDate' : bigint,
  'valueHistory' : Array<ValueHistory>,
  'latestInjuryEndDate' : bigint,
  'shirtNumber' : number,
  'position' : PlayerPosition,
  'lastName' : string,
  'firstName' : string,
}
export interface PlayerEventData {
  'fixtureId' : FixtureId,
  'clubId' : ClubId,
  'playerId' : number,
  'eventStartMinute' : number,
  'eventEndMinute' : number,
  'eventType' : PlayerEventType,
}
export type PlayerEventType = { 'PenaltyMissed' : null } |
  { 'Goal' : null } |
  { 'GoalConceded' : null } |
  { 'Appearance' : null } |
  { 'PenaltySaved' : null } |
  { 'RedCard' : null } |
  { 'KeeperSave' : null } |
  { 'CleanSheet' : null } |
  { 'YellowCard' : null } |
  { 'GoalAssisted' : null } |
  { 'OwnGoal' : null } |
  { 'HighestScoringPlayer' : null };
export interface PlayerGameweekDTO {
  'fixtureId' : FixtureId,
  'events' : Array<PlayerEventData>,
  'number' : number,
  'points' : number,
}
export type PlayerId = number;
export interface PlayerPointsDTO {
  'id' : number,
  'clubId' : ClubId,
  'events' : Array<PlayerEventData>,
  'position' : PlayerPosition,
  'gameweek' : GameweekNumber,
  'points' : number,
}
export type PlayerPosition = { 'Goalkeeper' : null } |
  { 'Midfielder' : null } |
  { 'Forward' : null } |
  { 'Defender' : null };
export interface PlayerScoreDTO {
  'id' : number,
  'clubId' : ClubId,
  'assists' : number,
  'dateOfBirth' : bigint,
  'nationality' : CountryId,
  'goalsScored' : number,
  'saves' : number,
  'goalsConceded' : number,
  'events' : Array<PlayerEventData>,
  'position' : PlayerPosition,
  'points' : number,
}
export type PlayerStatus = { 'OnLoan' : null } |
  { 'Active' : null } |
  { 'FreeAgent' : null } |
  { 'Retired' : null };
export interface PostponeFixtureDTO { 'fixtureId' : FixtureId }
export interface PromoteNewClubDTO {
  'secondaryColourHex' : string,
  'name' : string,
  'friendlyName' : string,
  'thirdColourHex' : string,
  'abbreviatedName' : string,
  'shirtType' : ShirtType,
  'primaryColourHex' : string,
}
export interface RecallPlayerDTO {
  'playerId' : PlayerId,
  'leagueId' : FootballLeagueId,
}
export interface RequestFixturesDTO {
  'seasonId' : SeasonId,
  'leagueId' : FootballLeagueId,
}
export interface RequestPlayersDTO {
  'seasonId' : SeasonId,
  'leagueId' : FootballLeagueId,
}
export interface RescheduleFixtureDTO {
  'postponedFixtureId' : FixtureId,
  'updatedFixtureGameweek' : GameweekNumber,
  'updatedFixtureDate' : bigint,
}
export type Result = { 'ok' : null } |
  { 'err' : Error };
export type Result_1 = { 'ok' : Array<SeasonDTO> } |
  { 'err' : Error };
export type Result_2 = { 'ok' : Array<FixtureDTO> } |
  { 'err' : Error };
export type Result_3 = { 'ok' : Array<[number, PlayerScoreDTO]> } |
  { 'err' : Error };
export type Result_4 = { 'ok' : Array<PlayerDTO> } |
  { 'err' : Error };
export type Result_5 = { 'ok' : Array<PlayerPointsDTO> } |
  { 'err' : Error };
export type Result_6 = { 'ok' : PlayerDetailDTO } |
  { 'err' : Error };
export type Result_7 = { 'ok' : Array<Club> } |
  { 'err' : Error };
export interface RetirePlayerDTO {
  'playerId' : PlayerId,
  'retirementDate' : bigint,
  'leagueId' : FootballLeagueId,
}
export interface RevaluePlayerDownDTO {
  'playerId' : PlayerId,
  'seasonId' : SeasonId,
  'gameweek' : GameweekNumber,
  'leagueId' : FootballLeagueId,
}
export interface RevaluePlayerUpDTO {
  'playerId' : PlayerId,
  'seasonId' : SeasonId,
  'gameweek' : GameweekNumber,
  'leagueId' : FootballLeagueId,
}
export interface SeasonDTO { 'id' : SeasonId, 'name' : string, 'year' : number }
export type SeasonId = number;
export interface SetPlayerInjuryDTO {
  'playerId' : PlayerId,
  'description' : string,
  'leagueId' : FootballLeagueId,
  'expectedEndDate' : bigint,
}
export type ShirtType = { 'Filled' : null } |
  { 'Striped' : null };
export interface SubmitFixtureDataDTO {
  'fixtureId' : FixtureId,
  'month' : CalendarMonth,
  'seasonId' : SeasonId,
  'gameweek' : GameweekNumber,
  'playerEventData' : Array<PlayerEventData>,
  'leagueId' : FootballLeagueId,
}
export interface SystemState {
  'pickTeamSeasonId' : SeasonId,
  'calculationGameweek' : GameweekNumber,
  'transferWindowActive' : boolean,
  'pickTeamMonth' : CalendarMonth,
  'pickTeamGameweek' : GameweekNumber,
  'version' : string,
  'calculationMonth' : CalendarMonth,
  'calculationSeasonId' : SeasonId,
  'onHold' : boolean,
  'seasonActive' : boolean,
}
export interface TransferPlayerDTO {
  'clubId' : ClubId,
  'newLeagueId' : FootballLeagueId,
  'playerId' : PlayerId,
  'newShirtNumber' : number,
  'seasonId' : SeasonId,
  'newClubId' : ClubId,
  'gameweek' : GameweekNumber,
  'leagueId' : FootballLeagueId,
}
export interface UnretirePlayerDTO {
  'playerId' : PlayerId,
  'leagueId' : FootballLeagueId,
}
export interface UpdateClubDTO {
  'clubId' : ClubId,
  'secondaryColourHex' : string,
  'name' : string,
  'friendlyName' : string,
  'thirdColourHex' : string,
  'abbreviatedName' : string,
  'shirtType' : ShirtType,
  'primaryColourHex' : string,
}
export interface UpdatePlayerDTO {
  'dateOfBirth' : bigint,
  'playerId' : PlayerId,
  'nationality' : CountryId,
  'shirtNumber' : number,
  'position' : PlayerPosition,
  'lastName' : string,
  'leagueId' : FootballLeagueId,
  'firstName' : string,
}
export interface ValueHistory {
  'oldValue' : number,
  'newValue' : number,
  'seasonId' : number,
  'gameweek' : number,
}
export interface _SERVICE {
  'addEventsToFixture' : ActorMethod<
    [Array<PlayerEventData>, SeasonId, FixtureId],
    undefined
  >,
  'addEventsToPlayers' : ActorMethod<
    [Array<PlayerEventData>, SeasonId, GameweekNumber],
    undefined
  >,
  'checkGameweekComplete' : ActorMethod<[SeasonId, GameweekNumber], boolean>,
  'checkMonthComplete' : ActorMethod<
    [SeasonId, CalendarMonth, GameweekNumber],
    boolean
  >,
  'checkSeasonComplete' : ActorMethod<[SeasonId], boolean>,
  'createNewSeason' : ActorMethod<[SystemState], undefined>,
  'createPlayer' : ActorMethod<[CreatePlayerDTO], Result>,
  'getClubs' : ActorMethod<[FootballLeagueId], Result_7>,
  'getFixtures' : ActorMethod<[RequestFixturesDTO], Result_2>,
  'getPlayerDetails' : ActorMethod<[GetPlayerDetailsDTO], Result_6>,
  'getPlayerDetailsForGameweek' : ActorMethod<[GameweekFiltersDTO], Result_5>,
  'getPlayers' : ActorMethod<[RequestPlayersDTO], Result_4>,
  'getPlayersMap' : ActorMethod<[GameweekFiltersDTO], Result_3>,
  'getPostponedFixtures' : ActorMethod<[RequestFixturesDTO], Result_2>,
  'getSeasons' : ActorMethod<[FootballLeagueId], Result_1>,
  'loanPlayer' : ActorMethod<[LoanPlayerDTO], Result>,
  'promoteNewClub' : ActorMethod<[PromoteNewClubDTO], Result>,
  'retirePlayer' : ActorMethod<[RetirePlayerDTO], Result>,
  'revaluePlayerDown' : ActorMethod<[RevaluePlayerDownDTO], Result>,
  'revaluePlayerUp' : ActorMethod<[RevaluePlayerUpDTO], Result>,
  'setFixtureToComplete' : ActorMethod<[SeasonId, FixtureId], undefined>,
  'setFixtureToFinalised' : ActorMethod<[SeasonId, FixtureId], undefined>,
  'setGameScore' : ActorMethod<[SeasonId, FixtureId], undefined>,
  'setPlayerInjury' : ActorMethod<[SetPlayerInjuryDTO], Result>,
  'transferPlayer' : ActorMethod<[TransferPlayerDTO], Result>,
  'unretirePlayer' : ActorMethod<[UnretirePlayerDTO], Result>,
  'updateClub' : ActorMethod<[UpdateClubDTO], Result>,
  'updatePlayer' : ActorMethod<[UpdatePlayerDTO], Result>,
  'validateAddInitialFixtures' : ActorMethod<[AddInitialFixturesDTO], Result>,
  'validateCreatePlayer' : ActorMethod<[CreatePlayerDTO], Result>,
  'validateLoanPlayer' : ActorMethod<[LoanPlayerDTO], Result>,
  'validateMoveFixture' : ActorMethod<[MoveFixtureDTO], Result>,
  'validatePostponeFixture' : ActorMethod<[PostponeFixtureDTO], Result>,
  'validateRecallPlayer' : ActorMethod<[RecallPlayerDTO], Result>,
  'validateRescehduleFixture' : ActorMethod<[RescheduleFixtureDTO], Result>,
  'validateRetirePlayer' : ActorMethod<[RetirePlayerDTO], Result>,
  'validateRevaluePlayerDown' : ActorMethod<[RevaluePlayerDownDTO], Result>,
  'validateRevaluePlayerUp' : ActorMethod<[RevaluePlayerUpDTO], Result>,
  'validateSetPlayerInjury' : ActorMethod<[SetPlayerInjuryDTO], Result>,
  'validateSubmitFixtureData' : ActorMethod<[SubmitFixtureDataDTO], Result>,
  'validateTransferPlayer' : ActorMethod<[TransferPlayerDTO], Result>,
  'validateUnretirePlayer' : ActorMethod<[UnretirePlayerDTO], Result>,
  'validateUpdateClub' : ActorMethod<[UpdateClubDTO], Result>,
  'validateUpdatePlayer' : ActorMethod<[UpdatePlayerDTO], Result>,
}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
