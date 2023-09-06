import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';

export interface AccountBalanceDTO {
  'icpBalance' : bigint,
  'fplBalance' : bigint,
}
export type Error = { 'DecodeError' : null } |
  { 'NotAllowed' : null } |
  { 'NotFound' : null } |
  { 'NotAuthorized' : null } |
  { 'AlreadyExists' : null } |
  { 'InvalidTeamError' : null };
export interface FantasyTeam {
  'playerIds' : Uint16Array | number[],
  'goalGetterPlayerId' : PlayerId,
  'hatTrickHeroGameweek' : GameweekNumber,
  'transfersAvailable' : number,
  'teamBoostGameweek' : GameweekNumber,
  'captainFantasticGameweek' : GameweekNumber,
  'teamBoostTeamId' : TeamId,
  'noEntryPlayerId' : PlayerId,
  'safeHandsPlayerId' : PlayerId,
  'braceBonusGameweek' : GameweekNumber,
  'passMasterGameweek' : GameweekNumber,
  'goalGetterGameweek' : GameweekNumber,
  'bankBalance' : number,
  'captainFantasticPlayerId' : PlayerId,
  'noEntryGameweek' : GameweekNumber,
  'safeHandsGameweek' : GameweekNumber,
  'principalId' : string,
  'passMasterPlayerId' : PlayerId,
  'captainId' : PlayerId,
}
export interface FantasyTeamSnapshot {
  'playerIds' : Uint16Array | number[],
  'goalGetterPlayerId' : PlayerId,
  'hatTrickHeroGameweek' : GameweekNumber,
  'transfersAvailable' : number,
  'teamBoostGameweek' : GameweekNumber,
  'captainFantasticGameweek' : GameweekNumber,
  'teamBoostTeamId' : TeamId,
  'noEntryPlayerId' : PlayerId,
  'safeHandsPlayerId' : PlayerId,
  'braceBonusGameweek' : GameweekNumber,
  'passMasterGameweek' : GameweekNumber,
  'goalGetterGameweek' : GameweekNumber,
  'bankBalance' : number,
  'captainFantasticPlayerId' : PlayerId,
  'gameweek' : GameweekNumber,
  'noEntryGameweek' : GameweekNumber,
  'safeHandsGameweek' : GameweekNumber,
  'principalId' : string,
  'passMasterPlayerId' : PlayerId,
  'captainId' : number,
  'points' : number,
}
export interface Fixture {
  'id' : number,
  'status' : number,
  'awayTeamId' : TeamId,
  'highestScoringPlayerId' : number,
  'homeTeamId' : TeamId,
  'seasonId' : SeasonId,
  'events' : List,
  'kickOff' : bigint,
  'homeGoals' : number,
  'gameweek' : GameweekNumber,
  'awayGoals' : number,
}
export type FixtureId = number;
export interface Gameweek {
  'number' : GameweekNumber,
  'fixtures' : List_2,
  'canisterId' : string,
}
export type GameweekNumber = number;
export interface LeaderboardEntry {
  'username' : string,
  'positionText' : string,
  'position' : bigint,
  'principalId' : string,
  'points' : number,
}
export type List = [] | [[PlayerEventData, List]];
export type List_1 = [] | [[Gameweek, List_1]];
export type List_2 = [] | [[Fixture, List_2]];
export interface PaginatedClubLeaderboard {
  'month' : number,
  'clubId' : TeamId,
  'totalEntries' : bigint,
  'seasonId' : SeasonId,
  'entries' : Array<LeaderboardEntry>,
}
export interface PaginatedLeaderboard {
  'totalEntries' : bigint,
  'seasonId' : SeasonId,
  'entries' : Array<LeaderboardEntry>,
  'gameweek' : GameweekNumber,
}
export interface PlayerEventData {
  'fixtureId' : FixtureId,
  'playerId' : number,
  'eventStartMinute' : number,
  'eventEndMinute' : number,
  'teamId' : TeamId,
  'eventType' : number,
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
export interface ProfileDTO {
  'icpDepositAddress' : Uint8Array | number[],
  'favouriteTeamId' : number,
  'displayName' : string,
  'fplDepositAddress' : Uint8Array | number[],
  'createDate' : bigint,
  'canUpdateFavouriteTeam' : boolean,
  'reputation' : number,
  'principalName' : string,
  'profilePicture' : Uint8Array | number[],
  'membershipType' : number,
}
export type Result = { 'ok' : null } |
  { 'err' : Error };
export interface Season {
  'id' : number,
  'postponedFixtures' : List_2,
  'name' : string,
  'year' : number,
  'gameweeks' : List_1,
}
export type SeasonId = number;
export interface Team {
  'id' : number,
  'secondaryColourHex' : string,
  'name' : string,
  'friendlyName' : string,
  'abbreviatedName' : string,
  'primaryColourHex' : string,
}
export type TeamId = number;
export interface _SERVICE {
  'getAccountBalanceDTO' : ActorMethod<[], AccountBalanceDTO>,
  'getActiveGameweekFixtures' : ActorMethod<[], Array<Fixture>>,
  'getClubLeaderboard' : ActorMethod<
    [number, number, TeamId, bigint, bigint],
    PaginatedClubLeaderboard
  >,
  'getCurrentGameweek' : ActorMethod<[], number>,
  'getCurrentMonth' : ActorMethod<[], number>,
  'getCurrentSeason' : ActorMethod<[], Season>,
  'getFantasyTeam' : ActorMethod<[], FantasyTeam>,
  'getFantasyTeamForGameweek' : ActorMethod<
    [string, number, number],
    FantasyTeamSnapshot
  >,
  'getFixture' : ActorMethod<[SeasonId, GameweekNumber, FixtureId], Fixture>,
  'getFixtures' : ActorMethod<[], Array<Fixture>>,
  'getFixturesByWeek' : ActorMethod<[SeasonId, GameweekNumber], Array<Fixture>>,
  'getFixturesForSeason' : ActorMethod<[SeasonId], Array<Fixture>>,
  'getPlayersDetailsForGameweek' : ActorMethod<
    [Uint16Array | number[], number, number],
    Array<PlayerPointsDTO>
  >,
  'getProfileDTO' : ActorMethod<[], ProfileDTO>,
  'getPublicProfileDTO' : ActorMethod<[string], ProfileDTO>,
  'getSeasonLeaderboard' : ActorMethod<
    [number, bigint, bigint],
    PaginatedLeaderboard
  >,
  'getSeasonTop10' : ActorMethod<[], PaginatedLeaderboard>,
  'getSeasons' : ActorMethod<[], Array<Season>>,
  'getTeams' : ActorMethod<[], Array<Team>>,
  'getTotalManagers' : ActorMethod<[], bigint>,
  'getValidatableFixtures' : ActorMethod<[], Array<Fixture>>,
  'getWeeklyLeaderboard' : ActorMethod<
    [number, number, bigint, bigint],
    PaginatedLeaderboard
  >,
  'getWeeklyTop10' : ActorMethod<[], PaginatedLeaderboard>,
  'isDisplayNameValid' : ActorMethod<[string], boolean>,
  'saveFantasyTeam' : ActorMethod<
    [Uint16Array | number[], number, number, number, number],
    Result
  >,
  'savePlayerEvents' : ActorMethod<
    [FixtureId, Array<PlayerEventData>],
    undefined
  >,
  'updateDisplayName' : ActorMethod<[string], Result>,
  'updateFavouriteTeam' : ActorMethod<[number], Result>,
  'updateProfilePicture' : ActorMethod<[Uint8Array | number[]], Result>,
  'withdrawICP' : ActorMethod<[number, string], Result>,
}
