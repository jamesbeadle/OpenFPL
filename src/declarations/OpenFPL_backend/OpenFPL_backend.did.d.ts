import type { Principal } from "@dfinity/principal";
import type { ActorMethod } from "@dfinity/agent";
import type { IDL } from "@dfinity/candid";

export interface AppStatusDTO {
  version: string;
  onHold: boolean;
}
export type CalendarMonth = number;
export interface CanisterDTO {
  cycles: bigint;
  topups: Array<CanisterTopup>;
  computeAllocation: bigint;
  canisterId: CanisterId;
}
export type CanisterId = string;
export interface CanisterTopup {
  topupTime: bigint;
  canisterId: CanisterId;
  cyclesAmount: bigint;
}
export type CanisterType =
  | { SNS: null }
  | { Leaderboard: null }
  | { Dapp: null }
  | { Archive: null }
  | { Manager: null };
export type ClubId = number;
export type CountryId = number;
export interface CreateManagerDTO {
  username: string;
  favouriteClubId: [] | [ClubId];
}
export interface DataHashDTO {
  hash: string;
  category: string;
}
export type Error =
  | { MoreThan2PlayersFromClub: null }
  | { DecodeError: null }
  | { NotAllowed: null }
  | { DuplicatePlayerInTeam: null }
  | { InvalidBonuses: null }
  | { TooManyTransfers: null }
  | { NotFound: null }
  | { NumberPerPositionError: null }
  | { TeamOverspend: null }
  | { NotAuthorized: null }
  | { InvalidGameweek: null }
  | { SelectedCaptainNotInTeam: null }
  | { InvalidData: null }
  | { SystemOnHold: null }
  | { AlreadyExists: null }
  | { CanisterCreateError: null }
  | { Not11Players: null }
  | { InsufficientFunds: null };
export type FixtureId = number;
export type GameweekNumber = number;
export interface GetCanistersDTO {
  canisterType: CanisterType;
}
export interface GetManagerByUsername {
  username: string;
}
export interface GetManagerDTO {
  month: CalendarMonth;
  seasonId: SeasonId;
  gameweek: GameweekNumber;
  principalId: PrincipalId;
}
export interface GetManagerGameweekDTO {
  seasonId: SeasonId;
  gameweek: GameweekNumber;
  principalId: PrincipalId;
}
export interface GetPlayersMapDTO {
  seasonId: SeasonId;
  gameweek: GameweekNumber;
}
export interface GetSnapshotPlayersDTO {
  seasonId: SeasonId;
  gameweek: GameweekNumber;
}
export interface GetWeeklyLeaderboardDTO {
  offset: bigint;
  seasonId: SeasonId;
  limit: bigint;
  searchTerm: string;
  gameweek: GameweekNumber;
}
export interface GetWeeklyRewardsDTO {
  seasonId: SeasonId;
  gameweek: GameweekNumber;
}
export type ICFCLinkStatus = { PendingVerification: null } | { Verified: null };
export interface ICFCMembershipDTO {
  membershipClaims: Array<MembershipClaim>;
  membershipType: MembershipType;
  membershipExpiryTime: bigint;
}
export interface IsUsernameValid {
  username: string;
}
export interface LeaderboardEntryDTO {
  username: string;
  positionText: string;
  position: bigint;
  principalId: string;
  points: number;
}
export type LeagueId = number;
export interface ManagerDTO {
  username: string;
  weeklyPosition: bigint;
  createDate: bigint;
  monthlyPoints: number;
  weeklyPoints: number;
  weeklyPositionText: string;
  gameweeks: Array<ManagerGameweekDTO>;
  favouriteClubId: [] | [ClubId];
  monthlyPosition: bigint;
  seasonPosition: bigint;
  monthlyPositionText: string;
  profilePicture: [] | [Uint8Array | number[]];
  seasonPoints: number;
  profilePictureType: string;
  principalId: string;
  seasonPositionText: string;
}
export interface ManagerGameweekDTO {
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
export interface MembershipClaim {
  expiresOn: [] | [bigint];
  claimedOn: bigint;
  membershipType: MembershipType;
}
export type MembershipType =
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
}
export interface PlayerDTO {
  id: number;
  status: PlayerStatus;
  clubId: ClubId;
  parentClubId: ClubId;
  valueQuarterMillions: number;
  dateOfBirth: bigint;
  nationality: CountryId;
  currentLoanEndDate: bigint;
  shirtNumber: number;
  parentLeagueId: LeagueId;
  position: PlayerPosition;
  lastName: string;
  leagueId: LeagueId;
  firstName: string;
}
export interface PlayerEventData {
  fixtureId: FixtureId;
  clubId: ClubId;
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
export interface PlayerScoreDTO {
  id: number;
  clubId: ClubId;
  assists: number;
  dateOfBirth: bigint;
  nationality: CountryId;
  goalsScored: number;
  saves: number;
  goalsConceded: number;
  events: Array<PlayerEventData>;
  position: PlayerPosition;
  points: number;
}
export type PlayerStatus =
  | { OnLoan: null }
  | { Active: null }
  | { FreeAgent: null }
  | { Retired: null };
export type PrincipalId = string;
export interface ProfileDTO {
  username: string;
  termsAccepted: boolean;
  createDate: bigint;
  favouriteClubId: [] | [ClubId];
  profilePicture: [] | [Uint8Array | number[]];
  profilePictureType: string;
  principalId: string;
}
export type Result = { ok: null } | { err: Error };
export type Result_1 = { ok: ManagerDTO } | { err: Error };
export type Result_10 =
  | { ok: Array<[number, PlayerScoreDTO]> }
  | { err: Error };
export type Result_11 = { ok: Array<CanisterId> } | { err: Error };
export type Result_12 = { ok: ICFCLinkStatus } | { err: Error };
export type Result_13 = { ok: ManagerGameweekDTO } | { err: Error };
export type Result_14 = { ok: Array<DataHashDTO> } | { err: Error };
export type Result_15 = { ok: TeamSelectionDTO } | { err: Error };
export type Result_16 = { ok: Array<CanisterDTO> } | { err: Error };
export type Result_17 = { ok: RewardRatesDTO } | { err: Error };
export type Result_18 = { ok: string } | { err: Error };
export type Result_2 = { ok: WeeklyRewardsDTO } | { err: Error };
export type Result_3 = { ok: WeeklyLeaderboardDTO } | { err: Error };
export type Result_4 =
  | {
      ok: Array<[SeasonId, Array<[GameweekNumber, CanisterId]>]>;
    }
  | { err: Error };
export type Result_5 = { ok: Array<PlayerDTO> } | { err: Error };
export type Result_6 = { ok: ICFCMembershipDTO } | { err: Error };
export type Result_7 = { ok: bigint } | { err: Error };
export type Result_8 = { ok: AppStatusDTO } | { err: Error };
export type Result_9 = { ok: ProfileDTO } | { err: Error };
export interface RewardEntry {
  rewardType: RewardType;
  position: bigint;
  amount: bigint;
  principalId: string;
}
export interface RewardRatesDTO {
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
export interface SaveBonusDTO {
  goalGetterPlayerId: [] | [ClubId];
  oneNationCountryId: [] | [CountryId];
  hatTrickHeroGameweek: [] | [GameweekNumber];
  oneNationGameweek: [] | [GameweekNumber];
  teamBoostGameweek: [] | [GameweekNumber];
  captainFantasticGameweek: [] | [GameweekNumber];
  noEntryPlayerId: [] | [ClubId];
  safeHandsPlayerId: [] | [ClubId];
  braceBonusGameweek: [] | [GameweekNumber];
  passMasterGameweek: [] | [GameweekNumber];
  teamBoostClubId: [] | [ClubId];
  goalGetterGameweek: [] | [GameweekNumber];
  captainFantasticPlayerId: [] | [ClubId];
  noEntryGameweek: [] | [GameweekNumber];
  prospectsGameweek: [] | [GameweekNumber];
  safeHandsGameweek: [] | [GameweekNumber];
  passMasterPlayerId: [] | [ClubId];
}
export interface SaveTeamDTO {
  playerIds: Uint16Array | number[];
  teamName: [] | [string];
  transferWindowGameweek: [] | [GameweekNumber];
  captainId: ClubId;
}
export type SeasonId = number;
export type SubApp =
  | { OpenFPL: null }
  | { OpenWSL: null }
  | { FootballGod: null }
  | { TransferKings: null }
  | { JeffBets: null };
export interface TeamSelectionDTO {
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
export interface UpdateAppStatusDTO {
  version: string;
  onHold: boolean;
}
export interface UpdateFavouriteClubDTO {
  favouriteClubId: ClubId;
}
export interface UpdateICFCProfile {
  subApp: SubApp;
  subAppUserPrincipalId: PrincipalId;
}
export interface UpdateProfilePictureDTO {
  profilePicture: Uint8Array | number[];
  extension: string;
}
export interface UpdateUsernameDTO {
  username: string;
}
export interface WeeklyLeaderboardDTO {
  totalEntries: bigint;
  seasonId: SeasonId;
  entries: Array<LeaderboardEntryDTO>;
  gameweek: GameweekNumber;
}
export interface WeeklyRewardsDTO {
  seasonId: SeasonId;
  rewards: Array<RewardEntry>;
  gameweek: GameweekNumber;
}
export interface _SERVICE {
  calculateWeeklyRewards: ActorMethod<[GameweekNumber], Result>;
  createManager: ActorMethod<[CreateManagerDTO], Result>;
  getActiveLeaderboardCanisterId: ActorMethod<[], Result_18>;
  getActiveRewardRates: ActorMethod<[], Result_17>;
  getAppStatus: ActorMethod<[], Result_8>;
  getCanisters: ActorMethod<[GetCanistersDTO], Result_16>;
  getCurrentTeam: ActorMethod<[], Result_15>;
  getDataHashes: ActorMethod<[], Result_14>;
  getFantasyTeamSnapshot: ActorMethod<[GetManagerGameweekDTO], Result_13>;
  getICFCProfileStatus: ActorMethod<[], Result_12>;
  getLeaderboardCanisterIds: ActorMethod<[], Result_11>;
  getManager: ActorMethod<[GetManagerDTO], Result_1>;
  getManagerCanisterIds: ActorMethod<[], Result_11>;
  getPlayersMap: ActorMethod<[GetPlayersMapDTO], Result_10>;
  getPlayersSnapshot: ActorMethod<[GetSnapshotPlayersDTO], Array<PlayerDTO>>;
  getProfile: ActorMethod<[], Result_9>;
  getSystemState: ActorMethod<[], Result_8>;
  getTopups: ActorMethod<[], Array<CanisterTopup>>;
  getTotalManagers: ActorMethod<[], Result_7>;
  getUserIFCFMembership: ActorMethod<[], Result_6>;
  getVerifiedPlayers: ActorMethod<[], Result_5>;
  getWeeklyCanisters: ActorMethod<[], Result_4>;
  getWeeklyLeaderboard: ActorMethod<[GetWeeklyLeaderboardDTO], Result_3>;
  getWeeklyRewards: ActorMethod<[GetWeeklyRewardsDTO], Result_2>;
  isUsernameValid: ActorMethod<[IsUsernameValid], boolean>;
  noitifyAppofICFCProfileUpdate: ActorMethod<[UpdateICFCProfile], Result>;
  notifyAppLink: ActorMethod<[NotifyAppofLink], Result>;
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
  payWeeklyRewards: ActorMethod<[GameweekNumber], Result>;
  saveBonusSelection: ActorMethod<[SaveBonusDTO], Result>;
  saveTeamSelection: ActorMethod<[SaveTeamDTO], Result>;
  searchUsername: ActorMethod<[GetManagerByUsername], Result_1>;
  updateDataHashes: ActorMethod<[string], Result>;
  updateFavouriteClub: ActorMethod<[UpdateFavouriteClubDTO], Result>;
  updateProfilePicture: ActorMethod<[UpdateProfilePictureDTO], Result>;
  updateSystemState: ActorMethod<[UpdateAppStatusDTO], Result>;
  updateUsername: ActorMethod<[UpdateUsernameDTO], Result>;
  verifyICFCProfile: ActorMethod<[], Result>;
}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
