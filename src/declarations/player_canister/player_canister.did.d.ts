import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';

export interface DataCache { 'hash' : string, 'category' : string }
export interface Fixture {
  'id' : number,
  'status' : number,
  'awayTeamId' : TeamId,
  'highestScoringPlayerId' : number,
  'homeTeamId' : TeamId,
  'seasonId' : SeasonId,
  'events' : List_3,
  'kickOff' : bigint,
  'homeGoals' : number,
  'gameweek' : GameweekNumber,
  'awayGoals' : number,
}
export type FixtureId = number;
export type GameweekNumber = number;
export interface InjuryHistory {
  'description' : string,
  'injuryStartDate' : bigint,
  'expectedEndDate' : bigint,
}
export type List = [] | [[InjuryHistory, List]];
export type List_1 = [] | [[PlayerSeason, List_1]];
export type List_2 = [] | [[PlayerGameweek, List_2]];
export type List_3 = [] | [[PlayerEventData, List_3]];
export type List_4 = [] | [[TransferHistory, List_4]];
export type List_5 = [] | [[ValueHistory, List_5]];
export interface Player {
  'id' : PlayerId,
  'value' : bigint,
  'seasons' : List_1,
  'dateOfBirth' : bigint,
  'injuryHistory' : List,
  'transferHistory' : List_4,
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
export interface PlayerDetailDTO {
  'id' : PlayerId,
  'value' : bigint,
  'dateOfBirth' : bigint,
  'injuryHistory' : Array<InjuryHistory>,
  'seasonId' : SeasonId,
  'isInjured' : boolean,
  'gameweeks' : Array<PlayerGameweekDTO>,
  'nationality' : string,
  'retirementDate' : bigint,
  'valueHistory' : Array<ValueHistory>,
  'shirtNumber' : number,
  'teamId' : TeamId,
  'position' : number,
  'parentTeamId' : number,
  'lastName' : string,
  'onLoan' : boolean,
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
  'events' : List_3,
  'number' : number,
  'points' : number,
}
export interface PlayerGameweekDTO {
  'fixtureId' : FixtureId,
  'events' : Array<PlayerEventData>,
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
  'events' : List_3,
  'teamId' : number,
  'position' : number,
  'points' : number,
}
export interface PlayerSeason { 'id' : number, 'gameweeks' : List_2 }
export type SeasonId = number;
export type TeamId = number;
export interface TransferHistory {
  'transferDate' : bigint,
  'loanEndDate' : bigint,
  'toTeam' : TeamId,
  'transferSeason' : SeasonId,
  'fromTeam' : TeamId,
  'transferGameweek' : GameweekNumber,
}
export interface ValueHistory {
  'oldValue' : bigint,
  'newValue' : bigint,
  'seasonId' : number,
  'gameweek' : number,
}
export interface _SERVICE {
  'addAllPlayers' : ActorMethod<[], undefined>,
  'calculatePlayerScores' : ActorMethod<[number, number, Fixture], Fixture>,
  'createPlayer' : ActorMethod<
    [TeamId, number, string, string, number, bigint, bigint, string],
    undefined
  >,
  'getActivePlayers' : ActorMethod<[], Array<PlayerDTO>>,
  'getAllPlayers' : ActorMethod<[], Array<PlayerDTO>>,
  'getAllPlayersMap' : ActorMethod<
    [number, number],
    Array<[number, PlayerScoreDTO]>
  >,
  'getDataHashes' : ActorMethod<[], Array<DataCache>>,
  'getPlayer' : ActorMethod<[number], Player>,
  'getPlayerDetails' : ActorMethod<[number, SeasonId], PlayerDetailDTO>,
  'getPlayerDetailsForGameweek' : ActorMethod<
    [number, number],
    Array<PlayerPointsDTO>
  >,
  'getPlayersDetailsForGameweek' : ActorMethod<
    [Uint16Array | number[], number, number],
    Array<PlayerPointsDTO>
  >,
  'getRetiredPlayer' : ActorMethod<[string], Array<Player>>,
  'loanPlayer' : ActorMethod<
    [PlayerId, TeamId, bigint, SeasonId, GameweekNumber],
    undefined
  >,
  'recallPlayer' : ActorMethod<[PlayerId], undefined>,
  'retirePlayer' : ActorMethod<[PlayerId, bigint], undefined>,
  'revaluePlayerDown' : ActorMethod<
    [PlayerId, SeasonId, GameweekNumber],
    undefined
  >,
  'revaluePlayerUp' : ActorMethod<
    [PlayerId, SeasonId, GameweekNumber],
    undefined
  >,
  'setPlayerInjury' : ActorMethod<[PlayerId, string, bigint], undefined>,
  'transferPlayer' : ActorMethod<
    [PlayerId, TeamId, SeasonId, GameweekNumber],
    undefined
  >,
  'unretirePlayer' : ActorMethod<[PlayerId], undefined>,
  'updateHashForCategory' : ActorMethod<[string], undefined>,
  'updatePlayer' : ActorMethod<
    [PlayerId, number, string, string, number, bigint, string],
    undefined
  >,
  'updatePlayerEventDataCache' : ActorMethod<[], undefined>,
}
