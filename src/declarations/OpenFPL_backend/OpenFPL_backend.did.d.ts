import type { Principal } from "@dfinity/principal";
import type { ActorMethod } from "@dfinity/agent";
import type { IDL } from "@dfinity/candid";

export interface AddController {
  app: WaterwayLabsApp;
  controller: PrincipalId;
  canisterId: CanisterId;
}
export interface AddInitialFixtureNotification {
  leagueId: LeagueId;
}
export interface AllTimeHighScores {
  seasonHighScore: [] | [HighScoreRecord];
  weeklyHighScore: [] | [HighScoreRecord];
  monthlyHighScore: [] | [HighScoreRecord];
}
export interface AppStatus {
  version: string;
  onHold: boolean;
}
export interface BeginGameweekNotification {
  seasonId: SeasonId;
  gameweek: GameweekNumber;
  leagueId: LeagueId;
}
export type BonusType =
  | { NoEntry: null }
  | { Prospects: null }
  | { PassMaster: null }
  | { TeamBoost: null }
  | { OneNation: null }
  | { CaptainFantastic: null }
  | { HatTrickHero: null }
  | { SafeHands: null }
  | { GoalGetter: null }
  | { BraceBonus: null };
export type CalendarMonth = number;
export interface Canister {
  app: WaterwayLabsApp;
  canisterName: string;
  canisterType: CanisterType;
  canisterId: CanisterId;
}
export type CanisterId = string;
export type CanisterType = { SNS: null } | { Dynamic: null } | { Static: null };
export interface Club {
  id: number;
  secondaryColourHex: string;
  name: string;
  friendlyName: string;
  thirdColourHex: string;
  abbreviatedName: string;
  shirtType: ShirtType;
  primaryColourHex: string;
}
export type ClubId = number;
export interface Clubs {
  clubs: Array<Club>;
  leagueId: number;
}
export interface CombinedProfile {
  username: string;
  displayName: string;
  termsAccepted: boolean;
  createdOn: bigint;
  createDate: bigint;
  favouriteClubId: [] | [ClubId];
  membershipClaims: Array<MembershipClaim>;
  profilePicture: [] | [Uint8Array | number[]];
  membershipType: MembershipType;
  termsAgreed: boolean;
  membershipExpiryTime: bigint;
  favouriteLeagueId: [] | [LeagueId];
  nationalityId: [] | [CountryId];
  profilePictureType: string;
  principalId: PrincipalId;
}
export interface CompleteFixtureNotification {
  fixtureId: FixtureId;
  seasonId: SeasonId;
  leagueId: LeagueId;
}
export interface CompleteGameweekNotification {
  seasonId: SeasonId;
  gameweek: GameweekNumber;
  leagueId: LeagueId;
}
export interface CompleteLeaderboardPayout {
  totalEntries: bigint;
  leaderboard: Array<LeaderboardEntry>;
  seasonId: SeasonId;
  totalPaid: bigint;
  gameweek: GameweekNumber;
}
export interface CompleteSeasonNotification {
  seasonId: SeasonId;
  leagueId: LeagueId;
}
export interface Countries {
  countries: Array<Country>;
}
export interface Country {
  id: CountryId;
  code: string;
  name: string;
}
export type CountryId = number;
export interface DataHash {
  hash: string;
  category: string;
}
export interface DetailedPlayer {
  id: PlayerId;
  status: PlayerStatus__2;
  clubId: ClubId;
  parentClubId: ClubId;
  valueQuarterMillions: number;
  dateOfBirth: bigint;
  injuryHistory: Array<InjuryHistory>;
  seasonId: SeasonId;
  gameweeks: Array<PlayerGameweek>;
  nationality: CountryId;
  retirementDate: bigint;
  valueHistory: Array<ValueHistory>;
  latestInjuryEndDate: bigint;
  shirtNumber: number;
  position: PlayerPosition__2;
  lastName: string;
  firstName: string;
}
export type Error =
  | { InvalidProfilePicture: null }
  | { DecodeError: null }
  | { TooLong: null }
  | { NotAllowed: null }
  | { DuplicateData: null }
  | { InvalidProperty: null }
  | { NotFound: null }
  | { IncorrectSetup: null }
  | { AlreadyClaimed: null }
  | { NotAuthorized: null }
  | { MaxDataExceeded: null }
  | { InvalidData: null }
  | { SystemOnHold: null }
  | { AlreadyExists: null }
  | { NoPacketsRemaining: null }
  | { UpdateFailed: null }
  | { CanisterCreateError: null }
  | { NeuronAlreadyUsed: null }
  | { FailedInterCanisterCall: null }
  | { InsufficientPacketsRemaining: null }
  | { InsufficientFunds: null }
  | { InEligible: null };
export interface FantasyTeamSnapshot {
  playerIds: Uint16Array | number[];
  month: CalendarMonth;
  teamValueQuarterMillions: number;
  username: string;
  goalGetterPlayerId: PlayerId;
  oneNationCountryId: CountryId;
  hatTrickHeroGameweek: GameweekNumber;
  transfersAvailable: number;
  oneNationGameweek: GameweekNumber;
  teamBoostGameweek: GameweekNumber;
  captainFantasticGameweek: GameweekNumber;
  bankQuarterMillions: number;
  noEntryPlayerId: PlayerId;
  monthlyPoints: number;
  safeHandsPlayerId: PlayerId;
  seasonId: SeasonId;
  braceBonusGameweek: GameweekNumber;
  favouriteClubId: [] | [ClubId];
  passMasterGameweek: GameweekNumber;
  teamBoostClubId: ClubId;
  goalGetterGameweek: GameweekNumber;
  captainFantasticPlayerId: PlayerId;
  gameweek: GameweekNumber;
  seasonPoints: number;
  transferWindowGameweek: GameweekNumber;
  noEntryGameweek: GameweekNumber;
  prospectsGameweek: GameweekNumber;
  safeHandsGameweek: GameweekNumber;
  principalId: PrincipalId;
  passMasterPlayerId: PlayerId;
  captainId: PlayerId;
  points: number;
  monthlyBonusesAvailable: number;
}
export interface Fixture {
  id: number;
  status: FixtureStatusType;
  highestScoringPlayerId: number;
  seasonId: number;
  awayClubId: number;
  events: Array<PlayerEventData__1>;
  homeClubId: number;
  kickOff: bigint;
  homeGoals: number;
  gameweek: number;
  awayGoals: number;
}
export type FixtureId = number;
export type FixtureStatusType =
  | { Unplayed: null }
  | { Finalised: null }
  | { Active: null }
  | { Complete: null };
export interface Fixtures {
  seasonId: number;
  fixtures: Array<Fixture>;
  leagueId: number;
}
export type GameweekNumber = number;
export type GetAllTimeHighScores = {};
export interface GetClubs {
  leagueId: number;
}
export interface GetFantasyTeamSnapshot {
  seasonId: SeasonId;
  gameweek: GameweekNumber;
  principalId: PrincipalId;
}
export interface GetFixtures {
  seasonId: number;
  leagueId: number;
}
export type GetICFCLinks = {};
export interface GetManager {
  principalId: string;
}
export interface GetManagerByUsername {
  username: string;
}
export interface GetMonthlyLeaderboard {
  month: GameweekNumber;
  clubId: ClubId;
  page: bigint;
  seasonId: SeasonId;
}
export interface GetMostValuableGameweekPlayers {
  seasonId: SeasonId;
  gameweek: GameweekNumber;
}
export interface GetMostValuableTeamLeaderboard {
  page: bigint;
  seasonId: SeasonId;
}
export interface GetPlayerDetails {
  playerId: number;
  seasonId: number;
  leagueId: number;
}
export interface GetPlayerDetailsForGameweek {
  seasonId: number;
  gameweek: number;
  leagueId: number;
}
export interface GetPlayers {
  leagueId: number;
}
export interface GetPlayersMap {
  seasonId: number;
  gameweek: number;
  leagueId: number;
}
export interface GetPlayersSnapshot {
  seasonId: SeasonId;
  gameweek: GameweekNumber;
}
export interface GetSeasonLeaderboard {
  page: bigint;
  seasonId: SeasonId;
}
export interface GetSeasons {
  leagueId: number;
}
export interface GetWeeklyLeaderboard {
  page: bigint;
  seasonId: SeasonId;
  searchTerm: string;
  gameweek: GameweekNumber;
}
export interface HighScoreRecord {
  recordHolderUsername: string;
  recordHolderProfilePicture: [] | [Uint8Array | number[]];
  recordPrizePool: bigint;
  recordHolderPrincipalId: PrincipalId;
  recordPoints: number;
}
export interface ICFCLink {
  dataHash: string;
  membershipType: MembershipType__1;
  linkStatus: ICFCLinkStatus;
  principalId: PrincipalId;
}
export type ICFCLinkStatus = { PendingVerification: null } | { Verified: null };
export interface ICFCLinks {
  icfcPrincipalId: PrincipalId;
  subApp: SubApp;
  subAppUserPrincipalId: PrincipalId;
  membershipType: MembershipType;
}
export interface InjuryHistory {
  description: string;
  injuryStartDate: bigint;
  expectedEndDate: bigint;
}
export interface LeaderboardEntry {
  payoutStatus: PayoutStatus;
  rewardAmount: [] | [bigint];
  appPrincipalId: PrincipalId;
  payoutDate: [] | [bigint];
}
export interface LeaderboardEntry__1 {
  username: string;
  rewardAmount: [] | [bigint];
  membershipLevel: MembershipType;
  positionText: string;
  bonusPlayed: [] | [BonusType];
  position: bigint;
  profilePicture: [] | [Uint8Array | number[]];
  nationalityId: [] | [CountryId];
  principalId: PrincipalId;
  points: number;
}
export type LeagueId = number;
export interface LeagueStatus {
  transferWindowEndMonth: number;
  transferWindowEndDay: number;
  transferWindowStartMonth: number;
  transferWindowActive: boolean;
  totalGameweeks: number;
  completedGameweek: number;
  transferWindowStartDay: number;
  unplayedGameweek: number;
  activeMonth: number;
  activeSeasonId: number;
  activeGameweek: number;
  leagueId: number;
  seasonActive: boolean;
}
export interface Manager {
  username: string;
  weeklyPosition: bigint;
  createDate: bigint;
  monthlyPoints: number;
  weeklyPoints: number;
  weeklyPositionText: string;
  gameweeks: Array<FantasyTeamSnapshot>;
  favouriteClubId: [] | [ClubId];
  monthlyPosition: bigint;
  seasonPosition: bigint;
  monthlyPositionText: string;
  profilePicture: [] | [Uint8Array | number[]];
  seasonPoints: number;
  profilePictureType: string;
  principalId: PrincipalId;
  seasonPositionText: string;
}
export interface MembershipClaim {
  expiresOn: [] | [bigint];
  purchasedOn: bigint;
  membershipType: MembershipType;
}
export type MembershipType =
  | { Founding: null }
  | { NotClaimed: null }
  | { Seasonal: null }
  | { Lifetime: null }
  | { Monthly: null }
  | { NotEligible: null }
  | { Expired: null };
export type MembershipType__1 =
  | { Founding: null }
  | { NotClaimed: null }
  | { Seasonal: null }
  | { Lifetime: null }
  | { Monthly: null }
  | { NotEligible: null }
  | { Expired: null };
export interface MonthlyLeaderboard {
  month: GameweekNumber;
  clubId: ClubId;
  totalEntries: bigint;
  seasonId: SeasonId;
  entries: Array<LeaderboardEntry__1>;
}
export interface MostValuableGameweekPlayers {
  totalEntries: bigint;
  seasonId: SeasonId;
  entries: Array<MostValuablePlayer>;
  gameweek: GameweekNumber;
}
export interface MostValuablePlayer {
  fixtureId: FixtureId;
  playerId: PlayerId;
  totalRewardAmount: bigint;
  selectedByCount: bigint;
  rewardPerManager: bigint;
  points: number;
}
export interface MostValuableTeamLeaderboard {
  totalEntries: bigint;
  seasonId: SeasonId;
  entries: Array<TeamValueLeaderboardEntry>;
}
export interface NotifyAppofLink {
  icfcPrincipalId: PrincipalId;
  subApp: SubApp;
  subAppUserPrincipalId: PrincipalId;
  membershipType: MembershipType;
}
export interface NotifyAppofRemoveLink {
  icfcPrincipalId: PrincipalId;
  subApp: SubApp;
}
export type PayoutStatus = { Paid: null } | { Pending: null };
export interface PlayBonus {
  clubId: ClubId;
  playerId: PlayerId;
  countryId: CountryId;
  bonusType: BonusType;
  principalId: PrincipalId;
}
export interface Player {
  id: number;
  status: PlayerStatus;
  clubId: number;
  parentClubId: number;
  valueQuarterMillions: number;
  dateOfBirth: bigint;
  nationality: number;
  currentLoanEndDate: bigint;
  shirtNumber: number;
  parentLeagueId: number;
  position: PlayerPosition;
  lastName: string;
  leagueId: number;
  firstName: string;
}
export interface PlayerChangeNotification {
  playerId: PlayerId;
  leagueId: LeagueId;
}
export interface PlayerDetails {
  player: DetailedPlayer;
}
export interface PlayerDetailsForGameweek {
  playerPoints: Array<PlayerPoints>;
}
export interface PlayerEventData {
  fixtureId: FixtureId;
  clubId: ClubId;
  playerId: number;
  eventStartMinute: number;
  eventEndMinute: number;
  eventType: PlayerEventType__1;
}
export interface PlayerEventData__1 {
  fixtureId: number;
  clubId: number;
  playerId: number;
  eventStartMinute: number;
  eventEndMinute: number;
  eventType: PlayerEventType;
}
export interface PlayerEventData__2 {
  fixtureId: number;
  clubId: number;
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
export type PlayerEventType__1 =
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
  fixtureId: FixtureId;
  events: Array<PlayerEventData>;
  number: number;
  points: number;
}
export type PlayerId = number;
export interface PlayerPoints {
  id: number;
  clubId: number;
  events: Array<PlayerEventData__2>;
  position: PlayerPosition__1;
  gameweek: number;
  points: number;
}
export type PlayerPosition =
  | { Goalkeeper: null }
  | { Midfielder: null }
  | { Forward: null }
  | { Defender: null };
export type PlayerPosition__1 =
  | { Goalkeeper: null }
  | { Midfielder: null }
  | { Forward: null }
  | { Defender: null };
export type PlayerPosition__2 =
  | { Goalkeeper: null }
  | { Midfielder: null }
  | { Forward: null }
  | { Defender: null };
export interface PlayerScore {
  id: number;
  clubId: number;
  assists: number;
  dateOfBirth: bigint;
  nationality: number;
  goalsScored: number;
  saves: number;
  goalsConceded: number;
  events: Array<PlayerEventData__2>;
  position: PlayerPosition__1;
  points: number;
}
export type PlayerStatus =
  | { OnLoan: null }
  | { Active: null }
  | { FreeAgent: null }
  | { Retired: null };
export type PlayerStatus__1 =
  | { OnLoan: null }
  | { Active: null }
  | { FreeAgent: null }
  | { Retired: null };
export type PlayerStatus__2 =
  | { OnLoan: null }
  | { Active: null }
  | { FreeAgent: null }
  | { Retired: null };
export interface Player__1 {
  id: number;
  status: PlayerStatus__1;
  clubId: number;
  parentClubId: number;
  valueQuarterMillions: number;
  dateOfBirth: bigint;
  nationality: number;
  currentLoanEndDate: bigint;
  shirtNumber: number;
  parentLeagueId: number;
  position: PlayerPosition__1;
  lastName: string;
  leagueId: number;
  firstName: string;
}
export interface Players {
  players: Array<Player__1>;
}
export interface PlayersMap {
  playersMap: Array<[number, PlayerScore]>;
}
export interface PlayersSnapshot {
  players: Array<Player>;
}
export type PrincipalId = string;
export interface ProjectCanisters {
  entries: Array<Canister>;
}
export interface RemoveController {
  app: WaterwayLabsApp;
  controller: PrincipalId;
  canisterId: CanisterId;
}
export type Result = { ok: null } | { err: Error };
export type Result_1 = { ok: WeeklyLeaderboard } | { err: Error };
export type Result_10 = { ok: Players } | { err: Error };
export type Result_11 = { ok: PlayerDetailsForGameweek } | { err: Error };
export type Result_12 = { ok: PlayerDetails } | { err: Error };
export type Result_13 = { ok: MostValuableTeamLeaderboard } | { err: Error };
export type Result_14 = { ok: MostValuableGameweekPlayers } | { err: Error };
export type Result_15 = { ok: MonthlyLeaderboard } | { err: Error };
export type Result_16 = { ok: Array<CanisterId> } | { err: Error };
export type Result_17 = { ok: Manager } | { err: Error };
export type Result_18 = { ok: LeagueStatus } | { err: Error };
export type Result_19 = { ok: Array<ICFCLinks> } | { err: Error };
export type Result_2 = { ok: bigint } | { err: Error };
export type Result_20 = { ok: ICFCLinkStatus } | { err: Error };
export type Result_21 = { ok: string } | { err: Error };
export type Result_22 = { ok: Fixtures } | { err: Error };
export type Result_23 = { ok: FantasyTeamSnapshot } | { err: Error };
export type Result_24 = { ok: Array<DataHash> } | { err: Error };
export type Result_25 = { ok: Countries } | { err: Error };
export type Result_26 = { ok: Clubs } | { err: Error };
export type Result_27 = { ok: AppStatus } | { err: Error };
export type Result_28 = { ok: AllTimeHighScores } | { err: Error };
export type Result_29 = { ok: RewardRates } | { err: Error };
export type Result_3 = { ok: TeamSetup } | { err: Error };
export type Result_4 = { ok: Seasons } | { err: Error };
export type Result_5 = { ok: SeasonLeaderboard } | { err: Error };
export type Result_6 = { ok: ProjectCanisters } | { err: Error };
export type Result_7 = { ok: CombinedProfile } | { err: Error };
export type Result_8 = { ok: PlayersSnapshot } | { err: Error };
export type Result_9 = { ok: PlayersMap } | { err: Error };
export interface RewardRates {
  monthlyLeaderboardRewardRate: bigint;
  allTimeSeasonHighScoreRewardRate: bigint;
  highestScoringMatchRewardRate: bigint;
  seasonLeaderboardRewardRate: bigint;
  mostValuableTeamRewardRate: bigint;
  allTimeMonthlyHighScoreRewardRate: bigint;
  weeklyLeaderboardRewardRate: bigint;
  allTimeWeeklyHighScoreRewardRate: bigint;
}
export interface SaveFantasyTeam {
  playerIds: Uint16Array | number[];
  playTransferWindowBonus: boolean;
  principalId: PrincipalId;
  captainId: ClubId;
}
export interface Season {
  id: number;
  name: string;
  year: number;
}
export type SeasonId = number;
export interface SeasonLeaderboard {
  totalEntries: bigint;
  seasonId: SeasonId;
  entries: Array<LeaderboardEntry__1>;
}
export interface Seasons {
  seasons: Array<Season>;
}
export interface SetFavouriteClub {
  favouriteClubId: ClubId;
  principalId: PrincipalId;
}
export type ShirtType = { Filled: null } | { Striped: null };
export type SubApp =
  | { OpenFPL: null }
  | { OpenWSL: null }
  | { FootballGod: null }
  | { TransferKings: null }
  | { JeffBets: null };
export interface TeamSetup {
  playerIds: Uint16Array | number[];
  username: string;
  goalGetterPlayerId: ClubId;
  oneNationCountryId: CountryId;
  hatTrickHeroGameweek: GameweekNumber;
  transfersAvailable: number;
  oneNationGameweek: GameweekNumber;
  teamBoostGameweek: GameweekNumber;
  captainFantasticGameweek: GameweekNumber;
  bankQuarterMillions: number;
  noEntryPlayerId: ClubId;
  safeHandsPlayerId: ClubId;
  braceBonusGameweek: GameweekNumber;
  passMasterGameweek: GameweekNumber;
  teamBoostClubId: ClubId;
  goalGetterGameweek: GameweekNumber;
  firstGameweek: boolean;
  captainFantasticPlayerId: ClubId;
  transferWindowGameweek: GameweekNumber;
  noEntryGameweek: GameweekNumber;
  prospectsGameweek: GameweekNumber;
  safeHandsGameweek: GameweekNumber;
  principalId: string;
  passMasterPlayerId: ClubId;
  captainId: ClubId;
  canisterId: CanisterId;
  monthlyBonusesAvailable: number;
}
export interface TeamValueLeaderboardEntry {
  username: string;
  rewardAmount: [] | [bigint];
  teamValue: number;
  membershipLevel: MembershipType;
  positionText: string;
  bonusPlayed: [] | [BonusType];
  position: bigint;
  profilePicture: [] | [Uint8Array | number[]];
  nationalityId: [] | [CountryId];
  principalId: PrincipalId;
}
export interface UpdateICFCProfile {
  subApp: SubApp;
  subAppUserPrincipalId: PrincipalId;
  membershipType: MembershipType;
}
export interface ValueHistory {
  oldValue: number;
  changedOn: bigint;
  newValue: number;
}
export type WaterwayLabsApp =
  | { OpenFPL: null }
  | { OpenWSL: null }
  | { ICPCasino: null }
  | { FootballGod: null }
  | { ICF1: null }
  | { ICFC: null }
  | { ICGC: null }
  | { ICPFA: null }
  | { TransferKings: null }
  | { JeffBets: null }
  | { OpenBook: null }
  | { OpenCare: null }
  | { OpenChef: null }
  | { OpenBeats: null }
  | { WaterwayLabs: null };
export interface WeeklyLeaderboard {
  totalEntries: bigint;
  seasonId: SeasonId;
  entries: Array<LeaderboardEntry__1>;
  gameweek: GameweekNumber;
}
export interface _SERVICE {
  addController: ActorMethod<[AddController], Result>;
  addInitialFixtureNotification: ActorMethod<
    [AddInitialFixtureNotification],
    Result
  >;
  beginGameweekNotification: ActorMethod<[BeginGameweekNotification], Result>;
  changePlayerPositionNotification: ActorMethod<
    [PlayerChangeNotification],
    Result
  >;
  completeGameweekNotification: ActorMethod<
    [CompleteGameweekNotification],
    Result
  >;
  completeSeasonNotification: ActorMethod<[CompleteSeasonNotification], Result>;
  expireLoanNotification: ActorMethod<[PlayerChangeNotification], Result>;
  finaliseFixtureNotification: ActorMethod<
    [CompleteFixtureNotification],
    Result
  >;
  getActiveLeaderboardCanisterId: ActorMethod<[], Result_21>;
  getActiveRewardRates: ActorMethod<[], Result_29>;
  getAllTimeHighScores: ActorMethod<[GetAllTimeHighScores], Result_28>;
  getAllUserICFCLinks: ActorMethod<[], Array<[PrincipalId, ICFCLink]>>;
  getAppStatus: ActorMethod<[], Result_27>;
  getClubs: ActorMethod<[GetClubs], Result_26>;
  getCountries: ActorMethod<[], Result_25>;
  getDataHashes: ActorMethod<[], Result_24>;
  getFantasyTeamSnapshot: ActorMethod<[GetFantasyTeamSnapshot], Result_23>;
  getFixtures: ActorMethod<[GetFixtures], Result_22>;
  getICFCDataHash: ActorMethod<[], Result_21>;
  getICFCLinkStatus: ActorMethod<[], Result_20>;
  getICFCProfileLinks: ActorMethod<[GetICFCLinks], Result_19>;
  getLeaderboardCanisterIds: ActorMethod<[], Result_16>;
  getLeagueStatus: ActorMethod<[], Result_18>;
  getManager: ActorMethod<[GetManager], Result_17>;
  getManagerByUsername: ActorMethod<[GetManagerByUsername], Result_17>;
  getManagerCanisterIds: ActorMethod<[], Result_16>;
  getMonthlyLeaderboard: ActorMethod<[GetMonthlyLeaderboard], Result_15>;
  getMostValuableGameweekPlayers: ActorMethod<
    [GetMostValuableGameweekPlayers],
    Result_14
  >;
  getMostValuableTeamLeaderboard: ActorMethod<
    [GetMostValuableTeamLeaderboard],
    Result_13
  >;
  getPlayerDetails: ActorMethod<[GetPlayerDetails], Result_12>;
  getPlayerEvents: ActorMethod<[GetPlayerDetailsForGameweek], Result_11>;
  getPlayers: ActorMethod<[GetPlayers], Result_10>;
  getPlayersMap: ActorMethod<[GetPlayersMap], Result_9>;
  getPlayersSnapshot: ActorMethod<[GetPlayersSnapshot], Result_8>;
  getProfile: ActorMethod<[], Result_7>;
  getProjectCanisters: ActorMethod<[], Result_6>;
  getSeasonLeaderboard: ActorMethod<[GetSeasonLeaderboard], Result_5>;
  getSeasons: ActorMethod<[GetSeasons], Result_4>;
  getTeamSelection: ActorMethod<[], Result_3>;
  getTotalManagers: ActorMethod<[], Result_2>;
  getWeeklyLeaderboard: ActorMethod<[GetWeeklyLeaderboard], Result_1>;
  leaderboardPaid: ActorMethod<[CompleteLeaderboardPayout], Result>;
  linkICFCProfile: ActorMethod<[], Result>;
  loanPlayerNotification: ActorMethod<[PlayerChangeNotification], Result>;
  noitifyAppofICFCHashUpdate: ActorMethod<[UpdateICFCProfile], Result>;
  notifyAppLink: ActorMethod<[NotifyAppofLink], Result>;
  notifyAppRemoveLink: ActorMethod<[NotifyAppofRemoveLink], Result>;
  recallPlayerNotification: ActorMethod<[PlayerChangeNotification], Result>;
  removeController: ActorMethod<[RemoveController], Result>;
  retirePlayerNotification: ActorMethod<[PlayerChangeNotification], Result>;
  revaluePlayerDownNotification: ActorMethod<
    [PlayerChangeNotification],
    Result
  >;
  revaluePlayerUpNotification: ActorMethod<[PlayerChangeNotification], Result>;
  saveBonusSelection: ActorMethod<[PlayBonus], Result>;
  saveTeamSelection: ActorMethod<[SaveFantasyTeam], Result>;
  setFreeAgentNotification: ActorMethod<[PlayerChangeNotification], Result>;
  transferPlayerNotification: ActorMethod<[PlayerChangeNotification], Result>;
  updateFavouriteClub: ActorMethod<[SetFavouriteClub], Result>;
}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
