export const idlFactory = ({ IDL }) => {
  const AccountId = IDL.Vec(IDL.Nat8);
  const Address = IDL.Text;
  const GovernanceError = IDL.Record({
    'error_message' : IDL.Text,
    'error_type' : IDL.Int32,
  });
  const NeuronId = IDL.Record({ 'id' : IDL.Nat64 });
  const SpawnResponse = IDL.Record({ 'created_neuron_id' : IDL.Opt(NeuronId) });
  const ClaimOrRefreshResponse = IDL.Record({
    'refreshed_neuron_id' : IDL.Opt(NeuronId),
  });
  const StakeMaturityResponse = IDL.Record({
    'maturity_e8s' : IDL.Nat64,
    'stake_maturity_e8s' : IDL.Nat64,
  });
  const DisburseResponse = IDL.Record({ 'transfer_block_height' : IDL.Nat64 });
  const CommandResponse = IDL.Variant({
    'Error' : GovernanceError,
    'Spawn' : SpawnResponse,
    'Follow' : IDL.Null,
    'ClaimOrRefresh' : ClaimOrRefreshResponse,
    'Configure' : IDL.Null,
    'StakeMaturity' : StakeMaturityResponse,
    'Disburse' : DisburseResponse,
  });
  const ManageNeuronResponse = IDL.Record({
    'command' : IDL.Opt(CommandResponse),
  });
  const Error = IDL.Variant({
    'expired' : IDL.Null,
    'missing' : IDL.Text,
    'other' : IDL.Text,
    'invalid' : IDL.Text,
    'fee_not_defined' : IDL.Text,
    'trapped' : IDL.Text,
    'rejected' : IDL.Text,
    'fatal' : IDL.Text,
  });
  const NeuronResponse = IDL.Variant({
    'ok' : ManageNeuronResponse,
    'err' : Error,
  });
  const AsyncError = IDL.Variant({
    'other' : IDL.Text,
    'fee_not_defined' : IDL.Text,
    'trapped' : IDL.Text,
  });
  const AsyncReturn = IDL.Variant({ 'ok' : IDL.Null, 'err' : AsyncError });
  const Spawn = IDL.Record({
    'percentage_to_spawn' : IDL.Opt(IDL.Nat32),
    'new_controller' : IDL.Opt(IDL.Principal),
    'nonce' : IDL.Opt(IDL.Nat64),
  });
  const Follow = IDL.Record({
    'topic' : IDL.Int32,
    'followees' : IDL.Vec(NeuronId),
  });
  const ClaimOrRefreshNeuronFromAccount = IDL.Record({
    'controller' : IDL.Opt(IDL.Principal),
    'memo' : IDL.Nat64,
  });
  const By = IDL.Variant({
    'NeuronIdOrSubaccount' : IDL.Null,
    'MemoAndController' : ClaimOrRefreshNeuronFromAccount,
    'Memo' : IDL.Nat64,
  });
  const ClaimOrRefresh = IDL.Record({ 'by' : IDL.Opt(By) });
  const ChangeAutoStakeMaturity = IDL.Record({
    'requested_setting_for_auto_stake_maturity' : IDL.Bool,
  });
  const IncreaseDissolveDelay = IDL.Record({
    'additional_dissolve_delay_seconds' : IDL.Nat32,
  });
  const SetDissolveTimestamp = IDL.Record({
    'dissolve_timestamp_seconds' : IDL.Nat64,
  });
  const Operation = IDL.Variant({
    'ChangeAutoStakeMaturity' : ChangeAutoStakeMaturity,
    'StopDissolving' : IDL.Null,
    'StartDissolving' : IDL.Null,
    'IncreaseDissolveDelay' : IncreaseDissolveDelay,
    'SetDissolveTimestamp' : SetDissolveTimestamp,
  });
  const Configure = IDL.Record({ 'operation' : IDL.Opt(Operation) });
  const AccountIdentifier = IDL.Record({ 'hash' : IDL.Vec(IDL.Nat8) });
  const Amount = IDL.Record({ 'e8s' : IDL.Nat64 });
  const Disburse = IDL.Record({
    'to_account' : IDL.Opt(AccountIdentifier),
    'amount' : IDL.Opt(Amount),
  });
  const Command = IDL.Variant({
    'Spawn' : Spawn,
    'Follow' : Follow,
    'ClaimOrRefresh' : ClaimOrRefresh,
    'Configure' : Configure,
    'StakeMaturity' : StakeMaturityResponse,
    'Disburse' : Disburse,
  });
  const HttpHeader = IDL.Record({ 'value' : IDL.Text, 'name' : IDL.Text });
  const HttpResponsePayload = IDL.Record({
    'status' : IDL.Nat,
    'body' : IDL.Vec(IDL.Nat8),
    'headers' : IDL.Vec(HttpHeader),
  });
  const TransformArgs = IDL.Record({
    'context' : IDL.Vec(IDL.Nat8),
    'response' : HttpResponsePayload,
  });
  const NeuronController = IDL.Service({
    'getAccountIdentifier' : IDL.Func([], [AccountId], ['query']),
    'getBackendCanisterId' : IDL.Func([], [IDL.Text], []),
    'getLedgerAddress' : IDL.Func([], [Address], ['query']),
    'getNeuronAddress' : IDL.Func([], [Address], ['query']),
    'getNeuronId' : IDL.Func([], [IDL.Nat64], ['query']),
    'getNeuronResponse' : IDL.Func([], [IDL.Opt(NeuronResponse)], ['query']),
    'init' : IDL.Func([], [AsyncReturn], []),
    'manage_neuron' : IDL.Func([Command], [NeuronResponse], []),
    'stake_nns_neuron' : IDL.Func([], [NeuronResponse], []),
    'transform' : IDL.Func([TransformArgs], [HttpResponsePayload], ['query']),
  });
  return NeuronController;
};
export const init = ({ IDL }) => { return []; };
