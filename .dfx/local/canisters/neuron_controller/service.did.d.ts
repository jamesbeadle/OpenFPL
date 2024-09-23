import type { Principal } from "@dfinity/principal";
import type { ActorMethod } from "@dfinity/agent";
import type { IDL } from "@dfinity/candid";

export type AccountId = Uint8Array | number[];
export interface AccountIdentifier {
  hash: Uint8Array | number[];
}
export type Address = string;
export interface Amount {
  e8s: bigint;
}
export type AsyncError =
  | { other: string }
  | { fee_not_defined: string }
  | { trapped: string };
export type AsyncReturn = { ok: null } | { err: AsyncError };
export type By =
  | { NeuronIdOrSubaccount: null }
  | { MemoAndController: ClaimOrRefreshNeuronFromAccount }
  | { Memo: bigint };
export interface ChangeAutoStakeMaturity {
  requested_setting_for_auto_stake_maturity: boolean;
}
export interface ClaimOrRefresh {
  by: [] | [By];
}
export interface ClaimOrRefreshNeuronFromAccount {
  controller: [] | [Principal];
  memo: bigint;
}
export interface ClaimOrRefreshResponse {
  refreshed_neuron_id: [] | [NeuronId];
}
export type Command =
  | { Spawn: Spawn }
  | { Follow: Follow }
  | { ClaimOrRefresh: ClaimOrRefresh }
  | { Configure: Configure }
  | { StakeMaturity: StakeMaturityResponse }
  | { Disburse: Disburse };
export type CommandResponse =
  | { Error: GovernanceError }
  | { Spawn: SpawnResponse }
  | { Follow: null }
  | { ClaimOrRefresh: ClaimOrRefreshResponse }
  | { Configure: null }
  | { StakeMaturity: StakeMaturityResponse }
  | { Disburse: DisburseResponse };
export interface Configure {
  operation: [] | [Operation];
}
export interface Disburse {
  to_account: [] | [AccountIdentifier];
  amount: [] | [Amount];
}
export interface DisburseResponse {
  transfer_block_height: bigint;
}
export type Error =
  | { expired: null }
  | { missing: string }
  | { other: string }
  | { invalid: string }
  | { fee_not_defined: string }
  | { trapped: string }
  | { rejected: string }
  | { fatal: string };
export interface Follow {
  topic: number;
  followees: Array<NeuronId>;
}
export interface GovernanceError {
  error_message: string;
  error_type: number;
}
export interface HttpHeader {
  value: string;
  name: string;
}
export interface HttpResponsePayload {
  status: bigint;
  body: Uint8Array | number[];
  headers: Array<HttpHeader>;
}
export interface IncreaseDissolveDelay {
  additional_dissolve_delay_seconds: number;
}
export interface ManageNeuronResponse {
  command: [] | [CommandResponse];
}
export interface NeuronController {
  getAccountIdentifier: ActorMethod<[], AccountId>;
  getBackendCanisterId: ActorMethod<[], string>;
  getLedgerAddress: ActorMethod<[], Address>;
  getNeuronAddress: ActorMethod<[], Address>;
  getNeuronId: ActorMethod<[], bigint>;
  getNeuronResponse: ActorMethod<[], [] | [NeuronResponse]>;
  init: ActorMethod<[], AsyncReturn>;
  manage_neuron: ActorMethod<[Command], NeuronResponse>;
  stake_nns_neuron: ActorMethod<[], NeuronResponse>;
  transform: ActorMethod<[TransformArgs], HttpResponsePayload>;
}
export interface NeuronId {
  id: bigint;
}
export type NeuronResponse = { ok: ManageNeuronResponse } | { err: Error };
export type Operation =
  | {
      ChangeAutoStakeMaturity: ChangeAutoStakeMaturity;
    }
  | { StopDissolving: null }
  | { StartDissolving: null }
  | { IncreaseDissolveDelay: IncreaseDissolveDelay }
  | { SetDissolveTimestamp: SetDissolveTimestamp };
export interface SetDissolveTimestamp {
  dissolve_timestamp_seconds: bigint;
}
export interface Spawn {
  percentage_to_spawn: [] | [number];
  new_controller: [] | [Principal];
  nonce: [] | [bigint];
}
export interface SpawnResponse {
  created_neuron_id: [] | [NeuronId];
}
export interface StakeMaturityResponse {
  maturity_e8s: bigint;
  stake_maturity_e8s: bigint;
}
export interface TransformArgs {
  context: Uint8Array | number[];
  response: HttpResponsePayload;
}
export interface _SERVICE extends NeuronController {}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
