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
export interface FantasyTeamSeason {
  'seasonId' : SeasonId,
  'gameweeks' : List_4,
  'totalPoints' : number,
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
export type List_3 = [] | [[FantasyTeamSeason, List_3]];
export type List_4 = [] | [[FantasyTeamSnapshot, List_4]];
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
export interface UserFantasyTeam {
  'fantasyTeam' : FantasyTeam,
  'history' : List_3,
}
export interface _SERVICE {
  'getAccountBalanceDTO' : ActorMethod<[], AccountBalanceDTO>,
  'getActiveGameweekFixtures' : ActorMethod<[], Array<Fixture>>,
  'getCurrentGameweek' : ActorMethod<[], number>,
  'getCurrentSeason' : ActorMethod<[], Season>,
  'getFantasyTeam' : ActorMethod<[], FantasyTeam>,
  'getFantasyTeamForGameweek' : ActorMethod<
    [string, number, number],
    FantasyTeamSnapshot
  >,
  'getFantasyTeams' : ActorMethod<[], Array<[string, UserFantasyTeam]>>,
  'getFixture' : ActorMethod<[SeasonId, GameweekNumber, FixtureId], Fixture>,
  'getFixtures' : ActorMethod<[], Array<Fixture>>,
  'getFixturesByWeek' : ActorMethod<[SeasonId, GameweekNumber], Array<Fixture>>,
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
  'getTransfersAllowed' : ActorMethod<[], boolean>,
  'getValidatableFixtures' : ActorMethod<[], Array<Fixture>>,
  'getWeeklyLeaderboard' : ActorMethod<
    [number, number, bigint, bigint],
    PaginatedLeaderboard
  >,
  'getWeeklyTop10' : ActorMethod<[], PaginatedLeaderboard>,
  'isDisplayNameValid' : ActorMethod<[string], boolean>,
  'recalculateSnapshotTotals' : ActorMethod<[], undefined>,
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
