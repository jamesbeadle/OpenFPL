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
export type ClubId = number;
export type CountryId = number;
export interface DataHash {
  hash: string;
  category: string;
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
export interface Gameweek {
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
  principalId: string;
  passMasterPlayerId: PlayerId;
  captainId: PlayerId;
  points: number;
  monthlyBonusesAvailable: number;
}
export type GameweekNumber = number;
export interface GetFantasyTeamSnapshot {
  seasonId: SeasonId;
  gameweek: GameweekNumber;
  principalId: PrincipalId;
}
export interface GetICFCProfile {
  principalId: PrincipalId;
}
export interface GetManager {
  principalId: string;
}
export interface GetManagerByUsername {
  username: string;
}
export interface GetPlayersMap {
  seasonId: number;
  gameweek: number;
  leagueId: number;
}
export interface GetProfile {
  principalId: PrincipalId;
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
export interface ICFCProfile {
  username: string;
  displayName: string;
  createdOn: bigint;
  favouriteClubId: [] | [ClubId];
  membershipClaims: Array<MembershipClaim>;
  profilePicture: [] | [Uint8Array | number[]];
  membershipType: MembershipType;
  termsAgreed: boolean;
  membershipExpiryTime: bigint;
  favouriteLeagueId: [] | [LeagueId];
  nationalityId: [] | [CountryId];
  principalId: PrincipalId;
}
export interface LeaderboardEntry {
  username: string;
  positionText: string;
  position: bigint;
  principalId: string;
  points: number;
}
export type LeagueId = number;
export interface Manager {
  username: string;
  weeklyPosition: bigint;
  createDate: bigint;
  monthlyPoints: number;
  weeklyPoints: number;
  weeklyPositionText: string;
  gameweeks: Array<Gameweek>;
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
export interface PlayBonus {
  clubId: ClubId;
  playerId: PlayerId;
  countryId: CountryId;
  bonusType: BonusType;
  principalId: PrincipalId;
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
export type PlayerId = number;
export type PlayerPosition =
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
  position: PlayerPosition;
  points: number;
}
export interface PlayersMap {
  playersMap: Array<[number, PlayerScore]>;
}
export type PrincipalId = string;
export interface Profile {
  username: string;
  termsAccepted: boolean;
  createDate: bigint;
  favouriteClubId: [] | [ClubId];
  profilePicture: [] | [Uint8Array | number[]];
  profilePictureType: string;
  principalId: PrincipalId;
}
export type Result = { ok: null } | { err: Error };
export type Result_1 = { ok: WeeklyLeaderboard } | { err: Error };
export type Result_10 = { ok: Array<DataHash> } | { err: Error };
export type Result_11 = { ok: AppStatus } | { err: Error };
export type Result_12 = { ok: RewardRates } | { err: Error };
export type Result_13 = { ok: string } | { err: Error };
export type Result_2 = { ok: bigint } | { err: Error };
export type Result_3 = { ok: TeamSetup } | { err: Error };
export type Result_4 = { ok: Profile } | { err: Error };
export type Result_5 = { ok: PlayersMap } | { err: Error };
export type Result_6 = { ok: Array<CanisterId> } | { err: Error };
export type Result_7 = { ok: Manager } | { err: Error };
export type Result_8 = { ok: ICFCProfile } | { err: Error };
export type Result_9 = { ok: FantasyTeamSnapshot } | { err: Error };
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
export type SeasonId = number;
export interface SetFavouriteClub {
  favouriteClubId: ClubId;
  principalId: PrincipalId;
}
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
export interface WeeklyLeaderboard {
  totalEntries: bigint;
  seasonId: SeasonId;
  entries: Array<LeaderboardEntry>;
  gameweek: GameweekNumber;
}
export interface _SERVICE {
  getActiveLeaderboardCanisterId: ActorMethod<[], Result_13>;
  getActiveRewardRates: ActorMethod<[], Result_12>;
  getAppStatus: ActorMethod<[], Result_11>;
  getDataHashes: ActorMethod<[], Result_10>;
  getFantasyTeamSnapshot: ActorMethod<[GetFantasyTeamSnapshot], Result_9>;
  getICFCProfile: ActorMethod<[GetICFCProfile], Result_8>;
  getLeaderboardCanisterIds: ActorMethod<[], Result_6>;
  getManager: ActorMethod<[GetManager], Result_7>;
  getManagerByUsername: ActorMethod<[GetManagerByUsername], Result_7>;
  getManagerCanisterIds: ActorMethod<[], Result_6>;
  getPlayersMap: ActorMethod<[GetPlayersMap], Result_5>;
  getProfile: ActorMethod<[GetProfile], Result_4>;
  getTeamSelection: ActorMethod<[GetTeamSetup], Result_3>;
  getTotalManagers: ActorMethod<[], Result_2>;
  getWeeklyLeaderboard: ActorMethod<[GetWeeklyLeaderboard], Result_1>;
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
