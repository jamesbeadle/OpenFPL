import type { Principal } from "@dfinity/principal";
import type { ActorMethod } from "@dfinity/agent";
import type { IDL } from "@dfinity/candid";

export interface AppStatus {
  version: string;
  onHold: boolean;
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
export type CanisterId = string;
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
  membershipType: MembershipType__1;
  termsAgreed: boolean;
  membershipExpiryTime: bigint;
  favouriteLeagueId: [] | [LeagueId];
  nationalityId: [] | [CountryId];
  profilePictureType: string;
  principalId: PrincipalId;
}
export interface Countries {
  countries: Array<Country>;
}
export interface Country {
  id: number;
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
  | { DecodeError: null }
  | { NotAllowed: null }
  | { DuplicateData: null }
  | { InvalidProperty: null }
  | { NotFound: null }
  | { IncorrectSetup: null }
  | { NotAuthorized: null }
  | { MaxDataExceeded: null }
  | { InvalidData: null }
  | { SystemOnHold: null }
  | { AlreadyExists: null }
  | { CanisterCreateError: null }
  | { FailedInterCanisterCall: null }
  | { InsufficientFunds: null };
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
export interface GetManager {
  principalId: string;
}
export interface GetManagerByUsername {
  username: string;
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
export interface GetPostponedFixtures {
  leagueId: number;
}
export interface GetSeasons {
  leagueId: number;
}
export interface GetTeamSetup {
  principalId: string;
}
export interface GetWeeklyLeaderboard {
  offset: bigint;
  seasonId: SeasonId;
  limit: bigint;
  searchTerm: string;
  gameweek: GameweekNumber;
}
export interface GetWeeklyRewardsLeaderboard {
  seasonId: SeasonId;
  gameweek: GameweekNumber;
}
export interface ICFCLink {
  dataHash: string;
  membershipType: MembershipType__1;
  linkStatus: ICFCLinkStatus;
  principalId: PrincipalId;
}
export type ICFCLinkStatus = { PendingVerification: null } | { Verified: null };
export interface InjuryHistory {
  description: string;
  injuryStartDate: bigint;
  expectedEndDate: bigint;
}
export interface LeaderboardEntry {
  username: string;
  positionText: string;
  position: bigint;
  principalId: string;
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
  claimedOn: bigint;
  membershipType: MembershipType__1;
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
export interface PostponedFixtures {
  seasonId: number;
  fixtures: Array<Fixture>;
  leagueId: number;
}
export type PrincipalId = string;
export type Result = { ok: null } | { err: Error };
export type Result_1 = { ok: WeeklyRewardsLeaderboard } | { err: Error };
export type Result_10 = { ok: Players } | { err: Error };
export type Result_11 = { ok: PlayerDetailsForGameweek } | { err: Error };
export type Result_12 = { ok: PlayerDetails } | { err: Error };
export type Result_13 = { ok: Array<CanisterId> } | { err: Error };
export type Result_14 = { ok: Manager } | { err: Error };
export type Result_15 = { ok: LeagueStatus } | { err: Error };
export type Result_16 = { ok: ICFCLinkStatus } | { err: Error };
export type Result_17 = { ok: Fixtures } | { err: Error };
export type Result_18 = { ok: FantasyTeamSnapshot } | { err: Error };
export type Result_19 = { ok: Array<DataHash> } | { err: Error };
export type Result_2 = { ok: WeeklyLeaderboard } | { err: Error };
export type Result_20 = { ok: Countries } | { err: Error };
export type Result_21 = { ok: Clubs } | { err: Error };
export type Result_22 = { ok: AppStatus } | { err: Error };
export type Result_23 = { ok: RewardRates } | { err: Error };
export type Result_24 = { ok: string } | { err: Error };
export type Result_3 = { ok: bigint } | { err: Error };
export type Result_4 = { ok: TeamSetup } | { err: Error };
export type Result_5 = { ok: Seasons } | { err: Error };
export type Result_6 = { ok: CombinedProfile } | { err: Error };
export type Result_7 = { ok: PostponedFixtures } | { err: Error };
export type Result_8 = { ok: PlayersSnapshot } | { err: Error };
export type Result_9 = { ok: PlayersMap } | { err: Error };
export interface RewardEntry {
  rewardType: RewardType;
  position: bigint;
  amount: bigint;
  principalId: string;
}
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
export type RewardType =
  | { MonthlyLeaderboard: null }
  | { MostValuableTeam: null }
  | { MonthlyATHScore: null }
  | { WeeklyATHScore: null }
  | { SeasonATHScore: null }
  | { SeasonLeaderboard: null }
  | { WeeklyLeaderboard: null }
  | { HighestScoringPlayer: null };
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
export interface WeeklyLeaderboard {
  totalEntries: bigint;
  seasonId: SeasonId;
  entries: Array<LeaderboardEntry>;
  gameweek: GameweekNumber;
}
export interface WeeklyRewardsLeaderboard {
  seasonId: SeasonId;
  entries: Array<RewardEntry>;
  gameweek: GameweekNumber;
}
export interface _SERVICE {
  getActiveLeaderboardCanisterId: ActorMethod<[], Result_24>;
  getActiveRewardRates: ActorMethod<[], Result_23>;
  getAllUserICFCLinks: ActorMethod<[], Array<[PrincipalId, ICFCLink]>>;
  getAppStatus: ActorMethod<[], Result_22>;
  getClubs: ActorMethod<[GetClubs], Result_21>;
  getCountries: ActorMethod<[], Result_20>;
  getDataHashes: ActorMethod<[], Result_19>;
  getFantasyTeamSnapshot: ActorMethod<[GetFantasyTeamSnapshot], Result_18>;
  getFixtures: ActorMethod<[GetFixtures], Result_17>;
  getICFCLinkStatus: ActorMethod<[], Result_16>;
  getLeaderboardCanisterIds: ActorMethod<[], Result_13>;
  getLeagueStatus: ActorMethod<[], Result_15>;
  getManager: ActorMethod<[GetManager], Result_14>;
  getManagerByUsername: ActorMethod<[GetManagerByUsername], Result_14>;
  getManagerCanisterIds: ActorMethod<[], Result_13>;
  getPlayerDetails: ActorMethod<[GetPlayerDetails], Result_12>;
  getPlayerEvents: ActorMethod<[GetPlayerDetailsForGameweek], Result_11>;
  getPlayers: ActorMethod<[GetPlayers], Result_10>;
  getPlayersMap: ActorMethod<[GetPlayersMap], Result_9>;
  getPlayersSnapshot: ActorMethod<[GetPlayersSnapshot], Result_8>;
  getPostponedFixtures: ActorMethod<[GetPostponedFixtures], Result_7>;
  getProfile: ActorMethod<[], Result_6>;
  getSeasons: ActorMethod<[GetSeasons], Result_5>;
  getTeamSelection: ActorMethod<[GetTeamSetup], Result_4>;
  getTotalManagers: ActorMethod<[], Result_3>;
  getWeeklyLeaderboard: ActorMethod<[GetWeeklyLeaderboard], Result_2>;
  getWeeklyRewards: ActorMethod<[GetWeeklyRewardsLeaderboard], Result_1>;
  linkICFCProfile: ActorMethod<[], Result>;
  noitifyAppofICFCHashUpdate: ActorMethod<[UpdateICFCProfile], Result>;
  notifyAppLink: ActorMethod<[NotifyAppofLink], Result>;
  notifyAppRemoveLink: ActorMethod<[NotifyAppofRemoveLink], Result>;
  notifyAppsOfFixtureFinalised: ActorMethod<
    [LeagueId, SeasonId, GameweekNumber],
    Result
  >;
  notifyAppsOfGameweekStarting: ActorMethod<
    [LeagueId, SeasonId, GameweekNumber],
    Result
  >;
  notifyAppsOfLoan: ActorMethod<[LeagueId, PlayerId], Result>;
  notifyAppsOfLoanExpired: ActorMethod<[LeagueId, PlayerId], Result>;
  notifyAppsOfPositionChange: ActorMethod<[LeagueId, PlayerId], Result>;
  notifyAppsOfRetirement: ActorMethod<[LeagueId, PlayerId], Result>;
  notifyAppsOfSeasonComplete: ActorMethod<[LeagueId, SeasonId], Result>;
  notifyAppsOfTransfer: ActorMethod<[LeagueId, PlayerId], Result>;
  saveBonusSelection: ActorMethod<[PlayBonus], Result>;
  saveTeamSelection: ActorMethod<[SaveFantasyTeam], Result>;
  updateDataHashes: ActorMethod<[string], Result>;
  updateFavouriteClub: ActorMethod<[SetFavouriteClub], Result>;
}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
