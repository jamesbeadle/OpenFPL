import type { ActorMethod } from "@dfinity/agent";

export interface AccountBalanceDTO {
  icpBalance: bigint;
  fplBalance: bigint;
}
export interface DataCache {
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
  | { InvalidTeamError: null };
export interface FantasyTeam {
  playerIds: Uint16Array | number[];
  teamName: string;
  goalGetterPlayerId: PlayerId;
  favouriteTeamId: TeamId;
  hatTrickHeroGameweek: GameweekNumber;
  transfersAvailable: number;
  teamBoostGameweek: GameweekNumber;
  captainFantasticGameweek: GameweekNumber;
  teamBoostTeamId: TeamId;
  noEntryPlayerId: PlayerId;
  safeHandsPlayerId: PlayerId;
  braceBonusGameweek: GameweekNumber;
  passMasterGameweek: GameweekNumber;
  goalGetterGameweek: GameweekNumber;
  bankBalance: bigint;
  captainFantasticPlayerId: PlayerId;
  noEntryGameweek: GameweekNumber;
  safeHandsGameweek: GameweekNumber;
  principalId: string;
  passMasterPlayerId: PlayerId;
  captainId: PlayerId;
}
export interface FantasyTeamSnapshot {
  playerIds: Uint16Array | number[];
  teamName: string;
  goalGetterPlayerId: PlayerId;
  favouriteTeamId: TeamId;
  hatTrickHeroGameweek: GameweekNumber;
  transfersAvailable: number;
  teamBoostGameweek: GameweekNumber;
  captainFantasticGameweek: GameweekNumber;
  teamBoostTeamId: TeamId;
  noEntryPlayerId: PlayerId;
  safeHandsPlayerId: PlayerId;
  braceBonusGameweek: GameweekNumber;
  passMasterGameweek: GameweekNumber;
  goalGetterGameweek: GameweekNumber;
  bankBalance: bigint;
  captainFantasticPlayerId: PlayerId;
  gameweek: GameweekNumber;
  noEntryGameweek: GameweekNumber;
  safeHandsGameweek: GameweekNumber;
  principalId: string;
  passMasterPlayerId: PlayerId;
  captainId: number;
  points: number;
}
export interface Fixture {
  id: number;
  status: number;
  awayTeamId: TeamId;
  highestScoringPlayerId: number;
  homeTeamId: TeamId;
  seasonId: SeasonId;
  events: List;
  kickOff: bigint;
  homeGoals: number;
  gameweek: GameweekNumber;
  awayGoals: number;
}
export interface FixtureDTO {
  id: number;
  status: number;
  awayTeamId: TeamId;
  highestScoringPlayerId: number;
  homeTeamId: TeamId;
  seasonId: SeasonId;
  events: Array<PlayerEventData>;
  kickOff: bigint;
  homeGoals: number;
  gameweek: GameweekNumber;
  awayGoals: number;
}
export type FixtureId = number;
export interface Gameweek {
  number: GameweekNumber;
  fixtures: List_2;
  canisterId: string;
}
export type GameweekNumber = number;
export interface LeaderboardEntry {
  username: string;
  positionText: string;
  position: bigint;
  principalId: string;
  points: number;
}
export type List = [] | [[PlayerEventData, List]];
export type List_1 = [] | [[Gameweek, List_1]];
export type List_2 = [] | [[Fixture, List_2]];
export interface ManagerDTO {
  favouriteTeamId: TeamId;
  displayName: string;
  weeklyPosition: bigint;
  createDate: bigint;
  monthlyPoints: number;
  weeklyPoints: number;
  weeklyPositionText: string;
  gameweeks: Array<FantasyTeamSnapshot>;
  monthlyPosition: bigint;
  seasonPosition: bigint;
  monthlyPositionText: string;
  profilePicture: Uint8Array | number[];
  seasonPoints: number;
  principalId: string;
  seasonPositionText: string;
}
export interface PaginatedClubLeaderboard {
  month: number;
  clubId: TeamId;
  totalEntries: bigint;
  seasonId: SeasonId;
  entries: Array<LeaderboardEntry>;
}
export interface PaginatedLeaderboard {
  totalEntries: bigint;
  seasonId: SeasonId;
  entries: Array<LeaderboardEntry>;
  gameweek: GameweekNumber;
}
export interface PlayerEventData {
  fixtureId: FixtureId;
  playerId: number;
  eventStartMinute: number;
  eventEndMinute: number;
  teamId: TeamId;
  eventType: number;
}
export type PlayerId = number;
export interface ProfileDTO {
  icpDepositAddress: Uint8Array | number[];
  favouriteTeamId: number;
  displayName: string;
  fplDepositAddress: Uint8Array | number[];
  createDate: bigint;
  canUpdateFavouriteTeam: boolean;
  reputation: number;
  profilePicture: Uint8Array | number[];
  membershipType: number;
  principalId: string;
}
export type Result = { ok: null } | { err: Error };
export interface Season {
  id: number;
  postponedFixtures: List_2;
  name: string;
  year: number;
  gameweeks: List_1;
}
export interface SeasonDTO {
  id: SeasonId;
  name: string;
  year: number;
}
export type SeasonId = number;
export interface SystemState {
  activeMonth: number;
  focusGameweek: GameweekNumber;
  activeSeason: Season;
  activeGameweek: GameweekNumber;
}
export interface Team {
  id: number;
  secondaryColourHex: string;
  name: string;
  friendlyName: string;
  thirdColourHex: string;
  abbreviatedName: string;
  shirtType: number;
  primaryColourHex: string;
}
export type TeamId = number;
export interface TimerInfo {
  id: bigint;
  fixtureId: FixtureId;
  playerId: PlayerId;
  callbackName: string;
  triggerTime: bigint;
}
export interface UpdateFixtureDTO {
  status: number;
  fixtureId: FixtureId;
  seasonId: SeasonId;
  kickOff: bigint;
  gameweek: GameweekNumber;
}
export interface UpdateSystemStateDTO {
  focusGameweek: GameweekNumber;
  activeGameweek: GameweekNumber;
}
export interface _SERVICE {
  createProfile: ActorMethod<[], undefined>;
  executeAddInitialFixtures: ActorMethod<[SeasonId, Array<Fixture>], Result>;
  executeCreatePlayer: ActorMethod<
    [TeamId, number, string, string, number, bigint, bigint, string],
    Result
  >;
  executeLoanPlayer: ActorMethod<[PlayerId, TeamId, bigint], Result>;
  executePromoteFormerTeam: ActorMethod<[TeamId], Result>;
  executePromoteNewTeam: ActorMethod<
    [string, string, string, string, string, string, number],
    Result
  >;
  executeRecallPlayer: ActorMethod<[PlayerId], Result>;
  executeRescheduleFixture: ActorMethod<
    [FixtureId, GameweekNumber, GameweekNumber, bigint],
    Result
  >;
  executeRetirePlayer: ActorMethod<[PlayerId, bigint], Result>;
  executeRevaluePlayerDown: ActorMethod<
    [SeasonId, GameweekNumber, PlayerId],
    Result
  >;
  executeRevaluePlayerUp: ActorMethod<[PlayerId], Result>;
  executeSetPlayerInjury: ActorMethod<[PlayerId, string, bigint], Result>;
  executeSubmitFixtureData: ActorMethod<
    [FixtureId, Array<PlayerEventData>],
    Result
  >;
  executeTransferPlayer: ActorMethod<[PlayerId, TeamId], Result>;
  executeUnretirePlayer: ActorMethod<[PlayerId], Result>;
  executeUpdatePlayer: ActorMethod<
    [PlayerId, number, string, string, number, bigint, string],
    Result
  >;
  executeUpdateTeam: ActorMethod<
    [TeamId, string, string, string, string, string, string, number],
    Result
  >;
  getAccountBalanceDTO: ActorMethod<[], AccountBalanceDTO>;
  getActiveFixtures: ActorMethod<[], Array<Fixture>>;
  getClubLeaderboard: ActorMethod<
    [number, number, TeamId, bigint, bigint],
    PaginatedClubLeaderboard
  >;
  getClubLeaderboardsCache: ActorMethod<
    [number, number],
    Array<PaginatedClubLeaderboard>
  >;
  getDataHashes: ActorMethod<[], Array<DataCache>>;
  getFantasyTeam: ActorMethod<[], FantasyTeam>;
  getFantasyTeamForGameweek: ActorMethod<
    [string, number, number],
    FantasyTeamSnapshot
  >;
  getFixtureDTOs: ActorMethod<[], Array<FixtureDTO>>;
  getFixtures: ActorMethod<[], Array<Fixture>>;
  getFixturesForSeason: ActorMethod<[SeasonId], Array<Fixture>>;
  getManager: ActorMethod<[string, SeasonId, GameweekNumber], ManagerDTO>;
  getProfileDTO: ActorMethod<[], [] | [ProfileDTO]>;
  getPublicProfileDTO: ActorMethod<[string], ProfileDTO>;
  getSeasonLeaderboard: ActorMethod<
    [number, bigint, bigint],
    PaginatedLeaderboard
  >;
  getSeasonLeaderboardCache: ActorMethod<[number], PaginatedLeaderboard>;
  getSeasons: ActorMethod<[], Array<SeasonDTO>>;
  getSystemState: ActorMethod<[], SystemState>;
  getTeamValueInfo: ActorMethod<[], Array<string>>;
  getTeams: ActorMethod<[], Array<Team>>;
  getTimers: ActorMethod<[], Array<TimerInfo>>;
  getTotalManagers: ActorMethod<[], bigint>;
  getWeeklyLeaderboard: ActorMethod<
    [number, number, bigint, bigint],
    PaginatedLeaderboard
  >;
  getWeeklyLeaderboardCache: ActorMethod<
    [number, number],
    PaginatedLeaderboard
  >;
  isDisplayNameValid: ActorMethod<[string], boolean>;
  movePostponedFixture: ActorMethod<[], undefined>;
  saveFantasyTeam: ActorMethod<
    [Uint16Array | number[], number, number, number, number],
    Result
  >;
  savePlayerEvents: ActorMethod<[FixtureId, Array<PlayerEventData>], Result>;
  snapshotFantasyTeams: ActorMethod<[], undefined>;
  updateDisplayName: ActorMethod<[string], Result>;
  updateFavouriteTeam: ActorMethod<[number], Result>;
  updateFixture: ActorMethod<[UpdateFixtureDTO], undefined>;
  updateHashForCategory: ActorMethod<[string], undefined>;
  updateProfilePicture: ActorMethod<[Uint8Array | number[]], Result>;
  updateSystemState: ActorMethod<[UpdateSystemStateDTO], Result>;
  updateTeamValueInfo: ActorMethod<[], undefined>;
  validateAddInitialFixtures: ActorMethod<[SeasonId, Array<Fixture>], Result>;
  validateCreatePlayer: ActorMethod<
    [TeamId, number, string, string, number, bigint, bigint, string],
    Result
  >;
  validateLoanPlayer: ActorMethod<[PlayerId, TeamId, bigint], Result>;
  validatePromoteFormerTeam: ActorMethod<[TeamId], Result>;
  validatePromoteNewTeam: ActorMethod<
    [string, string, string, string, string, string],
    Result
  >;
  validateRecallPlayer: ActorMethod<[PlayerId], Result>;
  validateRescheduleFixtures: ActorMethod<
    [FixtureId, GameweekNumber, GameweekNumber, bigint],
    Result
  >;
  validateRetirePlayer: ActorMethod<[PlayerId, bigint], Result>;
  validateRevaluePlayerDown: ActorMethod<[PlayerId], Result>;
  validateRevaluePlayerUp: ActorMethod<[PlayerId], Result>;
  validateSetPlayerInjury: ActorMethod<[PlayerId, string, bigint], Result>;
  validateSubmitFixtureData: ActorMethod<
    [FixtureId, Array<PlayerEventData>],
    Result
  >;
  validateTransferPlayer: ActorMethod<[PlayerId, TeamId], Result>;
  validateUnretirePlayer: ActorMethod<[PlayerId], Result>;
  validateUpdatePlayer: ActorMethod<
    [PlayerId, number, string, string, number, bigint, string],
    Result
  >;
  validateUpdateTeam: ActorMethod<
    [TeamId, string, string, string, string, string, string],
    Result
  >;
  withdrawICP: ActorMethod<[number, string], Result>;
}
