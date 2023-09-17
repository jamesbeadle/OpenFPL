import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';

export interface AccountBalanceDTO {
  'icpBalance' : bigint,
  'fplBalance' : bigint,
}
export interface DataCache { 'hash' : string, 'category' : string }
export type Error = { 'DecodeError' : null } |
  { 'NotAllowed' : null } |
  { 'NotFound' : null } |
  { 'NotAuthorized' : null } |
  { 'AlreadyExists' : null } |
  { 'InvalidTeamError' : null };
export interface FantasyTeam {
  'playerIds' : Uint16Array | number[],
  'teamName' : string,
  'goalGetterPlayerId' : PlayerId,
  'favouriteTeamId' : TeamId,
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
  'bankBalance' : bigint,
  'captainFantasticPlayerId' : PlayerId,
  'noEntryGameweek' : GameweekNumber,
  'safeHandsGameweek' : GameweekNumber,
  'principalId' : string,
  'passMasterPlayerId' : PlayerId,
  'captainId' : PlayerId,
}
export interface FantasyTeamSeason {
  'seasonId' : SeasonId,
  'gameweeks' : List_1,
  'totalPoints' : number,
}
export interface FantasyTeamSnapshot {
  'playerIds' : Uint16Array | number[],
  'teamName' : string,
  'goalGetterPlayerId' : PlayerId,
  'favouriteTeamId' : TeamId,
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
  'bankBalance' : bigint,
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
  'events' : List_2,
  'kickOff' : bigint,
  'homeGoals' : number,
  'gameweek' : GameweekNumber,
  'awayGoals' : number,
}
export interface FixtureDTO {
  'id' : number,
  'status' : number,
  'awayTeamId' : TeamId,
  'highestScoringPlayerId' : number,
  'homeTeamId' : TeamId,
  'seasonId' : SeasonId,
  'events' : Array<PlayerEventData>,
  'kickOff' : bigint,
  'homeGoals' : number,
  'gameweek' : GameweekNumber,
  'awayGoals' : number,
}
export type FixtureId = number;
export interface Gameweek {
  'number' : GameweekNumber,
  'fixtures' : List_4,
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
export type List = [] | [[FantasyTeamSeason, List]];
export type List_1 = [] | [[FantasyTeamSnapshot, List_1]];
export type List_2 = [] | [[PlayerEventData, List_2]];
export type List_3 = [] | [[Gameweek, List_3]];
export type List_4 = [] | [[Fixture, List_4]];
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
  'postponedFixtures' : List_4,
  'name' : string,
  'year' : number,
  'gameweeks' : List_3,
}
export interface SeasonDTO { 'id' : SeasonId, 'name' : string, 'year' : number }
export type SeasonId = number;
export interface SystemState {
  'activeMonth' : number,
  'focusGameweek' : GameweekNumber,
  'activeSeason' : Season,
  'activeGameweek' : GameweekNumber,
}
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
  'history' : List,
}
export interface _SERVICE {
  'fixMissingProfiles' : ActorMethod<[], undefined>,
  'getAccountBalanceDTO' : ActorMethod<[], AccountBalanceDTO>,
  'getAllProfilesDEV' : ActorMethod<[], Array<ProfileDTO>>,
  'getClubLeaderboard' : ActorMethod<
    [number, number, TeamId, bigint, bigint],
    PaginatedClubLeaderboard
  >,
  'getClubLeaderboardsCache' : ActorMethod<
    [number, number],
    Array<PaginatedClubLeaderboard>
  >,
  'getDataHashes' : ActorMethod<[], Array<DataCache>>,
  'getFantasyTeam' : ActorMethod<[], FantasyTeam>,
  'getFantasyTeamForGameweek' : ActorMethod<
    [string, number, number],
    FantasyTeamSnapshot
  >,
  'getFantasyTeamsDEV' : ActorMethod<[], Array<[string, UserFantasyTeam]>>,
  'getFixture' : ActorMethod<[SeasonId, GameweekNumber, FixtureId], Fixture>,
  'getFixtureDTOs' : ActorMethod<[], Array<FixtureDTO>>,
  'getFixtures' : ActorMethod<[], Array<Fixture>>,
  'getFixturesForSeason' : ActorMethod<[SeasonId], Array<Fixture>>,
  'getProfileDTO' : ActorMethod<[], ProfileDTO>,
  'getProfilesWithoutTeamsCount' : ActorMethod<[], bigint>,
  'getPublicProfileDTO' : ActorMethod<[string], ProfileDTO>,
  'getSeasonLeaderboard' : ActorMethod<
    [number, bigint, bigint],
    PaginatedLeaderboard
  >,
  'getSeasonLeaderboardCache' : ActorMethod<[number], PaginatedLeaderboard>,
  'getSeasons' : ActorMethod<[], Array<SeasonDTO>>,
  'getSystemState' : ActorMethod<[], SystemState>,
  'getTeams' : ActorMethod<[], Array<Team>>,
  'getTeamsWithoutProfiles' : ActorMethod<[], Array<UserFantasyTeam>>,
  'getTotalManagers' : ActorMethod<[], bigint>,
  'getValidatableFixtures' : ActorMethod<[], Array<Fixture>>,
  'getWeeklyLeaderboard' : ActorMethod<
    [number, number, bigint, bigint],
    PaginatedLeaderboard
  >,
  'getWeeklyLeaderboardCache' : ActorMethod<
    [number, number],
    PaginatedLeaderboard
  >,
  'isDisplayNameValid' : ActorMethod<[string], boolean>,
  'saveFantasyTeam' : ActorMethod<
    [Uint16Array | number[], number, number, number, number],
    Result
  >,
  'savePlayerEvents' : ActorMethod<
    [FixtureId, Array<PlayerEventData>],
    undefined
  >,
  'testUpdatingFantasyTeams' : ActorMethod<
    [],
    Array<[string, UserFantasyTeam]>
  >,
  'updateDisplayName' : ActorMethod<[string], Result>,
  'updateFavouriteTeam' : ActorMethod<[number], Result>,
  'updateHashForCategory' : ActorMethod<[string], undefined>,
  'updateProfilePicture' : ActorMethod<[Uint8Array | number[]], Result>,
  'withdrawICP' : ActorMethod<[number, string], Result>,
}
