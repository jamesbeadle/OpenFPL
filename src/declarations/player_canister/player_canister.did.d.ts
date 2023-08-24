import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';

export interface CreatePlayerPayload {
  'value' : bigint,
  'dateOfBirth' : bigint,
  'nationality' : string,
  'shirtNumber' : number,
  'teamId' : TeamId,
  'position' : number,
  'lastName' : string,
  'firstName' : string,
}
export interface Fixture {
  'id' : number,
  'status' : number,
  'awayTeamId' : TeamId,
  'highestScoringPlayerId' : number,
  'homeTeamId' : TeamId,
  'seasonId' : SeasonId,
  'events' : List_4,
  'kickOff' : bigint,
  'homeGoals' : number,
  'gameweek' : GameweekNumber,
  'awayGoals' : number,
}
export type FixtureId = number;
export type GameweekNumber = number;
export interface InjuryHistory {
  'description' : string,
  'expectedEndDate' : bigint,
}
export type List = [] | [[RevaluedPlayer, List]];
export type List_1 = [] | [[InjuryHistory, List_1]];
export type List_2 = [] | [[PlayerSeason, List_2]];
export type List_3 = [] | [[PlayerGameweek, List_3]];
export type List_4 = [] | [[PlayerEventData, List_4]];
export type List_5 = [] | [[ValueHistory, List_5]];
export interface LoanPlayerPayload {
  'loanTeamId' : TeamId,
  'loanEndDate' : bigint,
  'playerId' : PlayerId,
}
export interface Player {
  'id' : PlayerId,
  'value' : bigint,
  'seasons' : List_2,
  'dateOfBirth' : bigint,
  'injuryHistory' : List_1,
  'isInjured' : boolean,
  'nationality' : string,
  'retirementDate' : bigint,
  'valueHistory' : List_5,
  'shirtNumber' : number,
  'teamId' : TeamId,
  'position' : number,
  'parentTeamId' : number,
  'lastName' : string,
  'onLoan' : boolean,
  'firstName' : string,
}
export interface PlayerDTO {
  'id' : number,
  'value' : bigint,
  'dateOfBirth' : bigint,
  'nationality' : string,
  'shirtNumber' : number,
  'totalPoints' : number,
  'teamId' : number,
  'position' : number,
  'lastName' : string,
  'firstName' : string,
}
export interface PlayerEventData {
  'fixtureId' : FixtureId,
  'playerId' : number,
  'eventStartMinute' : number,
  'eventEndMinute' : number,
  'teamId' : TeamId,
  'eventType' : number,
}
export interface PlayerGameweek {
  'events' : List_4,
  'number' : number,
  'points' : number,
}
export type PlayerId = number;
export interface PlayerPointsDTO {
  'id' : number,
  'events' : Array<PlayerEventData>,
  'teamId' : number,
  'position' : number,
  'gameweek' : GameweekNumber,
  'points' : number,
}
export interface PlayerScoreDTO {
  'id' : number,
  'assists' : number,
  'goalsScored' : number,
  'saves' : number,
  'goalsConceded' : number,
  'events' : List_4,
  'teamId' : number,
  'position' : number,
  'points' : number,
}
export interface PlayerSeason { 'id' : number, 'gameweeks' : List_3 }
export interface RecallPlayerPayload { 'playerId' : PlayerId }
export interface RetirePlayerPayload {
  'playerId' : PlayerId,
  'retirementDate' : bigint,
}
export type RevaluationDirection = { 'Decrease' : null } |
  { 'Increase' : null };
export interface RevaluedPlayer {
  'direction' : RevaluationDirection,
  'playerId' : PlayerId,
}
export type SeasonId = number;
export interface SetPlayerInjuryPayload {
  'recovered' : boolean,
  'playerId' : PlayerId,
  'injuryDescription' : string,
  'expectedEndDate' : bigint,
}
export type TeamId = number;
export interface TransferPlayerPayload {
  'playerId' : PlayerId,
  'newTeamId' : TeamId,
}
export interface UnretirePlayerPayload { 'playerId' : PlayerId }
export interface UpdatePlayerPayload {
  'dateOfBirth' : bigint,
  'playerId' : PlayerId,
  'nationality' : string,
  'shirtNumber' : number,
  'teamId' : TeamId,
  'position' : number,
  'lastName' : string,
  'firstName' : string,
}
export interface ValueHistory {
  'oldValue' : number,
  'newValue' : number,
  'seasonId' : number,
  'gameweek' : number,
}
export interface _SERVICE {
  'calculatePlayerScores' : ActorMethod<[number, number, Fixture], Fixture>,
  'createPlayer' : ActorMethod<[CreatePlayerPayload], undefined>,
  'getAllPlayers' : ActorMethod<[], Array<PlayerDTO>>,
  'getAllPlayersMap' : ActorMethod<
    [number, number],
    Array<[number, PlayerScoreDTO]>
  >,
  'getPlayer' : ActorMethod<[number], Player>,
  'getPlayersDetailsForGameweek' : ActorMethod<
    [Uint16Array | number[], number, number],
    Array<PlayerPointsDTO>
  >,
  'loanPlayer' : ActorMethod<[LoanPlayerPayload], undefined>,
  'recallPlayer' : ActorMethod<[RecallPlayerPayload], undefined>,
  'retirePlayer' : ActorMethod<[RetirePlayerPayload], undefined>,
  'revaluePlayers' : ActorMethod<[number, number, List], undefined>,
  'setPlayerInjury' : ActorMethod<[SetPlayerInjuryPayload], undefined>,
  'transferPlayer' : ActorMethod<[TransferPlayerPayload], undefined>,
  'unretirePlayer' : ActorMethod<[UnretirePlayerPayload], undefined>,
  'updatePlayer' : ActorMethod<[UpdatePlayerPayload], undefined>,
}
