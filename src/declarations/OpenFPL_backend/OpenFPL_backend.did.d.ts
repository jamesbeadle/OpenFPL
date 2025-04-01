import type { Principal } from "@dfinity/principal";
import type { ActorMethod } from "@dfinity/agent";
import type { IDL } from "@dfinity/candid";

export type CanisterId = string;
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
  | { InsufficientFunds: null };
export type LeagueId = number;
export type PlayerId = number;
export type Result = { ok: null } | { err: Error };
export type Result_1 = { ok: Array<CanisterId> } | { err: Error };
export type Result_2 = { ok: string } | { err: Error };
export type SeasonId = number;
export interface _SERVICE {
  getActiveLeaderboardCanisterId: ActorMethod<[], Result_2>;
  getLeaderboardCanisterIds: ActorMethod<[], Result_1>;
  getManagerCanisterIds: ActorMethod<[], Result_1>;
  notifyAppsOfLoanExpired: ActorMethod<[LeagueId, PlayerId], Result>;
  notifyAppsOfPositionChange: ActorMethod<[LeagueId, PlayerId], Result>;
  notifyAppsOfRetirement: ActorMethod<[LeagueId, PlayerId], Result>;
  notifyAppsOfSeasonComplete: ActorMethod<[LeagueId, SeasonId], Result>;
}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
