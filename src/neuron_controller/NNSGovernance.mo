module {
  public let CANISTER_ID : Text = "rrkah-fqaaa-aaaaa-aaaaq-cai"; //TODO: Update with SNS canister Id

  type AccountIdentifier = Blob;
  type Action = {
  #RegisterKnownNeuron : KnownNeuron;
  #ManageNeuron : ManageNeuron;
  #CreateServiceNervousSystem : CreateServiceNervousSystem;
  #ExecuteNnsFunction : ExecuteNnsFunction;
  #RewardNodeProvider : RewardNodeProvider;
  #OpenSnsTokenSwap : OpenSnsTokenSwap;
  #SetSnsTokenSwapOpenTimeWindow : SetSnsTokenSwapOpenTimeWindow;
  #SetDefaultFollowees : SetDefaultFollowees;
  #RewardNodeProviders : RewardNodeProviders;
  #ManageNetworkEconomics : NetworkEconomics;
  #ApproveGenesisKyc : ApproveGenesisKyc;
  #AddOrRemoveNodeProvider : AddOrRemoveNodeProvider;
  #Motion : Motion;
};
type AddHotKey = { new_hot_key : ?Principal };
type AddOrRemoveNodeProvider =  { change : ?Change };
type Amount = { e8s : Nat64 };
type ApproveGenesisKyc = { Principals : [Principal] };
type Ballot = { vote : Int32; voting_power : Nat64 };
type BallotInfo = { vote : Int32; proposal_id : ?NeuronId };
public type By = {
  #NeuronIdOrSubaccount : {};
  #MemoAndController : ClaimOrRefreshNeuronFromAccount;
  #Memo : Nat64;
};
type Canister = { id : ?Principal };
type CanisterStatusResultV2 = {
  status : ?Int32;
  freezing_threshold : ?Nat64;
  controllers : [Principal];
  memory_size : ?Nat64;
  cycles : ?Nat64;
  idle_cycles_burned_per_day : ?Nat64;
  module_hash : ?Nat8;
};
type CanisterSummary = {
  status : ?CanisterStatusResultV2;
  canister_id : ?Principal;
};
type CfNeuron = {
  has_created_neuron_recipes : ?Bool;
  nns_neuron_id : Nat64;
  amount_icp_e8s : Nat64;
};
type CfParticipant = {
  hotkey_Principal : Text;
  cf_neurons : [CfNeuron];
};
type Change = { #ToRemove : NodeProvider; #ToAdd : NodeProvider };
type ChangeAutoStakeMaturity = {
  requested_setting_for_auto_stake_maturity : Bool;
};
public type ClaimOrRefresh = { by : ?By };
public type ClaimOrRefreshNeuronFromAccount = {
  controller : ?Principal;
  memo : Nat64;
};
type ClaimOrRefreshNeuronFromAccountResponse = { result : ?Result_1 };
type ClaimOrRefreshResponse = { refreshed_neuron_id : ?NeuronId };
public type Command = {
  #Spawn : Spawn;
  #Split : Split;
  #Follow : Follow;
  #ClaimOrRefresh : ClaimOrRefresh;
  #Configure : Configure;
  #RegisterVote : RegisterVote;
  #Merge : Merge;
  #DisburseToNeuron : DisburseToNeuron;
  #MakeProposal : Proposal;
  #StakeMaturity : StakeMaturity;
  #MergeMaturity : MergeMaturity;
  #Disburse : Disburse;
};
type Command_1 = {
  #Error : GovernanceError;
  #Spawn : SpawnResponse;
  #Split : SpawnResponse;
  #Follow : {};
  #ClaimOrRefresh : ClaimOrRefreshResponse;
  #Configure : {};
  #RegisterVote : {};
  #Merge : MergeResponse;
  #DisburseToNeuron : SpawnResponse;
  #MakeProposal : MakeProposalResponse;
  #StakeMaturity : StakeMaturityResponse;
  #MergeMaturity : MergeMaturityResponse;
  #Disburse : DisburseResponse;
};
type Command_2 = {
  #Spawn : NeuronId;
  #Split : Split;
  #Configure : Configure;
  #Merge : Merge;
  #DisburseToNeuron : DisburseToNeuron;
  #SyncCommand : {};
  #ClaimOrRefreshNeuron : ClaimOrRefresh;
  #MergeMaturity : MergeMaturity;
  #Disburse : Disburse;
};
type Committed = {
  total_direct_contribution_icp_e8s : ?Nat64;
  total_neurons_fund_contribution_icp_e8s : ?Nat64;
  sns_governance_canister_id : ?Principal;
};
type Committed_1 = {
  total_direct_participation_icp_e8s : ?Nat64;
  total_neurons_fund_participation_icp_e8s : ?Nat64;
  sns_governance_canister_id : ?Principal;
};
type Configure = { operation : ?Operation };
type Countries = { iso_codes : [Text] };
type CreateServiceNervousSystem = {
  url : ?Text;
  governance_parameters : ?GovernanceParameters;
  fallback_controller_Principal_ids : [Principal];
  logo : ?Image;
  name : ?Text;
  ledger_parameters : ?LedgerParameters;
  description : ?Text;
  dapp_canisters : [Canister];
  swap_parameters : ?SwapParameters;
  initial_token_distribution : ?InitialTokenDistribution;
};
type Decimal = { human_readable : ?Text };
type DerivedProposalInformation = {
  swap_background_information : ?SwapBackgroundInformation;
};
type DeveloperDistribution = {
  developer_neurons : [NeuronDistribution];
};
type Disburse = {
  to_account : ?AccountIdentifier;
  amount : ?Amount;
};
type DisburseResponse = { transfer_block_height : Nat64 };
type DisburseToNeuron = {
  dissolve_delay_seconds : Nat64;
  kyc_verified : Bool;
  amount_e8s : Nat64;
  new_controller : ?Principal;
  nonce : Nat64;
};
type DissolveState = {
  #DissolveDelaySeconds : Nat64;
  #WhenDissolvedTimestampSeconds : Nat64;
};
type Duration = { seconds : ?Nat64 };
type ExecuteNnsFunction = { nns_function : Int32; payload : [Nat8] };
type Follow = { topic : Int32; followees : [NeuronId] };
type Followees = { followees : [NeuronId] };
type Followers = { followers : [NeuronId] };
type FollowersMap = { followers_map : [{ a: Nat64; b: Followers }] };
type GetNeuronsFundAuditInfoRequest = { nns_proposal_id : ?NeuronId };
type GetNeuronsFundAuditInfoResponse = { result : ?Result_6 };
type GlobalTimeOfDay = { seconds_after_utc_midnight : ?Nat64 };
type Governance = {
  default_followees : [{ a: Int32; b: Followees }];
  making_sns_proposal : ?MakingSnsProposal;
  most_recent_monthly_node_provider_rewards : ?MostRecentMonthlyNodeProviderRewards;
  maturity_modulation_last_updated_at_timestamp_seconds : ?Nat64;
  wait_for_quiet_threshold_seconds : Nat64;
  metrics : ?GovernanceCachedMetrics;
  neuron_management_voting_period_seconds : ?Nat64;
  node_providers : [NodeProvider];
  cached_daily_maturity_modulation_basis_points : ?Int32;
  economics : ?NetworkEconomics;
  spawning_neurons : ?Bool;
  latest_reward_event : ?RewardEvent;
  to_claim_transfers : [NeuronStakeTransfer];
  short_voting_period_seconds : Nat64;
  topic_followee_index : [{ a: Int32; b: FollowersMap }];
  migrations : ?Migrations;
  proposals : [{ a: Nat64; b: ProposalData }];
  xdr_conversion_rate : ?XdrConversionRate;
  in_flight_commands : [{ a: Nat64; b: NeuronInFlightCommand }];
  neurons : [{ a: Nat64; b: Neuron }];
  genesis_timestamp_seconds : Nat64;
};
type GovernanceCachedMetrics = {
  total_maturity_e8s_equivalent : Nat64;
  not_dissolving_neurons_e8s_buckets : [{ a: Nat64; b: Float }];
  dissolving_neurons_staked_maturity_e8s_equivalent_sum : Nat64;
  garbage_collectable_neurons_count : Nat64;
  dissolving_neurons_staked_maturity_e8s_equivalent_buckets : [{
    a: Nat64;
    b: Float;
  }];
  neurons_with_invalid_stake_count : Nat64;
  not_dissolving_neurons_count_buckets : [{ a: Nat64; b: Nat64 }];
  ect_neuron_count : Nat64;
  total_supply_icp : Nat64;
  neurons_with_less_than_6_months_dissolve_delay_count : Nat64;
  dissolved_neurons_count : Nat64;
  community_fund_total_maturity_e8s_equivalent : Nat64;
  total_staked_e8s_seed : Nat64;
  total_staked_maturity_e8s_equivalent_ect : Nat64;
  total_staked_e8s : Nat64;
  not_dissolving_neurons_count : Nat64;
  total_locked_e8s : Nat64;
  neurons_fund_total_active_neurons : Nat64;
  total_staked_maturity_e8s_equivalent : Nat64;
  not_dissolving_neurons_e8s_buckets_ect : [{ a: Nat64; b: Float }];
  total_staked_e8s_ect : Nat64;
  not_dissolving_neurons_staked_maturity_e8s_equivalent_sum : Nat64;
  dissolved_neurons_e8s : Nat64;
  dissolving_neurons_e8s_buckets_seed : [{ a: Nat64; b: Float }];
  neurons_with_less_than_6_months_dissolve_delay_e8s : Nat64;
  not_dissolving_neurons_staked_maturity_e8s_equivalent_buckets : [{
    a: Nat64;
    b: Float;
  }];
  dissolving_neurons_count_buckets : [{ a: Nat64; b: Nat64 }];
  dissolving_neurons_e8s_buckets_ect : [{ a: Nat64; b: Float }];
  dissolving_neurons_count : Nat64;
  dissolving_neurons_e8s_buckets : [{ a: Nat64; b: Float }];
  total_staked_maturity_e8s_equivalent_seed : Nat64;
  community_fund_total_staked_e8s : Nat64;
  not_dissolving_neurons_e8s_buckets_seed : [{ a: Nat64; b: Float }];
  timestamp_seconds : Nat64;
  seed_neuron_count : Nat64;
};
type GovernanceError = { error_message : Text; error_type : Int32 };
type GovernanceParameters = {
  neuron_maximum_dissolve_delay_bonus : ?Percentage;
  neuron_maximum_age_for_age_bonus : ?Duration;
  neuron_maximum_dissolve_delay : ?Duration;
  neuron_minimum_dissolve_delay_to_vote : ?Duration;
  neuron_maximum_age_bonus : ?Percentage;
  neuron_minimum_stake : ?Tokens;
  proposal_wait_for_quiet_deadline_increase : ?Duration;
  proposal_initial_voting_period : ?Duration;
  proposal_rejection_fee : ?Tokens;
  voting_reward_parameters : ?VotingRewardParameters;
};
type IdealMatchedParticipationFunction = {
  serialized_representation : ?Text;
};
type Image = { base64_encoding : ?Text };
type IncreaseDissolveDelay = {
  additional_dissolve_delay_seconds : Nat32;
};
type InitialTokenDistribution = {
  treasury_distribution : ?SwapDistribution;
  developer_distribution : ?DeveloperDistribution;
  swap_distribution : ?SwapDistribution;
};
type KnownNeuron = {
  id : ?NeuronId;
  known_neuron_data : ?KnownNeuronData;
};
type KnownNeuronData = { name : Text; description : ?Text };
type LedgerParameters = {
  transaction_fee : ?Tokens;
  token_symbol : ?Text;
  token_logo : ?Image;
  token_name : ?Text;
};
type ListKnownNeuronsResponse = { known_neurons : [KnownNeuron] };
type ListNeurons = {
  neuron_ids : [Nat64];
  include_neurons_readable_by_caller : Bool;
};
type ListNeuronsResponse = {
  neuron_infos : [{ a: Nat64; b: NeuronInfo }];
  full_neurons : [Neuron];
};
type ListNodeProvidersResponse = { node_providers : [NodeProvider] };
type ListProposalInfo = {
  include_reward_status : [Int32];
  omit_large_fields : ?Bool;
  before_proposal : ?NeuronId;
  limit : Nat32;
  exclude_topic : [Int32];
  include_all_manage_neuron_proposals : ?Bool;
  include_status : [Int32];
};
type ListProposalInfoResponse = { proposal_info : [ProposalInfo] };
type MakeProposalResponse = {
  message : ?Text;
  proposal_id : ?NeuronId;
};
type MakingSnsProposal = {
  proposal : ?Proposal;
  caller : ?Principal;
  proposer_id : ?NeuronId;
};
type ManageNeuron = {
  id : ?NeuronId;
  command : ?Command;
  neuron_id_or_subaccount : ?NeuronIdOrSubaccount;
};
type ManageNeuronResponse = { command : ?Command_1 };
type Merge = { source_neuron_id : ?NeuronId };
type MergeMaturity = { percentage_to_merge : Nat32 };
type MergeMaturityResponse = {
  merged_maturity_e8s : Nat64;
  new_stake_e8s : Nat64;
};
type MergeResponse = {
  target_neuron : ?Neuron;
  source_neuron : ?Neuron;
  target_neuron_info : ?NeuronInfo;
  source_neuron_info : ?NeuronInfo;
};
type Migration = {
  status : ?Int32;
  failure_reason : ?Text;
  progress : ?Progress;
};
type Migrations = {
  neuron_indexes_migration : ?Migration;
  copy_inactive_neurons_to_stable_memory_migration : ?Migration;
};
type MostRecentMonthlyNodeProviderRewards = {
  timestamp : Nat64;
  rewards : [RewardNodeProvider];
};
type Motion = { motion_Text : Text };
type NetworkEconomics = {
  neuron_minimum_stake_e8s : Nat64;
  max_proposals_to_keep_per_topic : Nat32;
  neuron_management_fee_per_proposal_e8s : Nat64;
  reject_cost_e8s : Nat64;
  transaction_fee_e8s : Nat64;
  neuron_spawn_dissolve_delay_seconds : Nat64;
  minimum_icp_xdr_rate : Nat64;
  maximum_node_provider_rewards_e8s : Nat64;
  neurons_fund_economics : ?NeuronsFundEconomics;
};
type Neuron = {
  id : ?NeuronId;
  staked_maturity_e8s_equivalent : ?Nat64;
  controller : ?Principal;
  recent_ballots : [BallotInfo];
  kyc_verified : Bool;
  neuron_type : ?Int32;
  not_for_profit : Bool;
  maturity_e8s_equivalent : Nat64;
  cached_neuron_stake_e8s : Nat64;
  created_timestamp_seconds : Nat64;
  auto_stake_maturity : ?Bool;
  aging_since_timestamp_seconds : Nat64;
  hot_keys : [Principal];
  account : [Nat8];
  joined_community_fund_timestamp_seconds : ?Nat64;
  dissolve_state : ?DissolveState;
  followees : [{ a: Int32; b: Followees }];
  neuron_fees_e8s : Nat64;
  transfer : ?NeuronStakeTransfer;
  known_neuron_data : ?KnownNeuronData;
  spawn_at_timestamp_seconds : ?Nat64;
};
type NeuronBasketConstructionParameters = {
  dissolve_delay_interval : ?Duration;
  count : ?Nat64;
};
type NeuronBasketConstructionParameters_1 = {
  dissolve_delay_interval_seconds : Nat64;
  count : Nat64;
};
type NeuronDistribution = {
  controller : ?Principal;
  dissolve_delay : ?Duration;
  memo : ?Nat64;
  vesting_period : ?Duration;
  stake : ?Tokens;
};
type NeuronId = { id : Nat64 };
type NeuronIdOrSubaccount = {
  #Subaccount : [Nat8];
  #NeuronId : NeuronId;
};
type NeuronInFlightCommand = {
  command : ?Command_2;
  timestamp : Nat64;
};
type NeuronInfo = {
  dissolve_delay_seconds : Nat64;
  recent_ballots : [BallotInfo];
  neuron_type : ?Int32;
  created_timestamp_seconds : Nat64;
  state : Int32;
  stake_e8s : Nat64;
  joined_community_fund_timestamp_seconds : ?Nat64;
  retrieved_at_timestamp_seconds : Nat64;
  known_neuron_data : ?KnownNeuronData;
  voting_power : Nat64;
  age_seconds : Nat64;
};
type NeuronStakeTransfer = {
  to_subaccount : [Nat8];
  neuron_stake_e8s : Nat64;
  from : ?Principal;
  memo : Nat64;
  from_subaccount : [Nat8];
  transfer_timestamp : Nat64;
  block_height : Nat64;
};
type NeuronsFundAuditInfo = {
  final_neurons_fund_participation : ?NeuronsFundParticipation;
  initial_neurons_fund_participation : ?NeuronsFundParticipation;
  neurons_fund_refunds : ?NeuronsFundSnapshot;
};
type NeuronsFundData = {
  final_neurons_fund_participation : ?NeuronsFundParticipation;
  initial_neurons_fund_participation : ?NeuronsFundParticipation;
  neurons_fund_refunds : ?NeuronsFundSnapshot;
};
type NeuronsFundEconomics = {
  maximum_icp_xdr_rate : ?Percentage;
  neurons_fund_matched_funding_curve_coefficients : ?NeuronsFundMatchedFundingCurveCoefficients;
  max_theoretical_neurons_fund_participation_amount_xdr : ?Decimal;
  minimum_icp_xdr_rate : ?Percentage;
};
type NeuronsFundMatchedFundingCurveCoefficients = {
  contribution_threshold_xdr : ?Decimal;
  one_third_participation_milestone_xdr : ?Decimal;
  full_participation_milestone_xdr : ?Decimal;
};
type NeuronsFundNeuron = {
  hotkey_Principal : ?Text;
  is_capped : ?Bool;
  nns_neuron_id : ?Nat64;
  amount_icp_e8s : ?Nat64;
};
type NeuronsFundNeuronPortion = {
  hotkey_Principal : ?Principal;
  is_capped : ?Bool;
  maturity_equivalent_icp_e8s : ?Nat64;
  nns_neuron_id : ?NeuronId;
  amount_icp_e8s : ?Nat64;
};
type NeuronsFundParticipation = {
  total_maturity_equivalent_icp_e8s : ?Nat64;
  intended_neurons_fund_participation_icp_e8s : ?Nat64;
  direct_participation_icp_e8s : ?Nat64;
  swap_participation_limits : ?SwapParticipationLimits;
  max_neurons_fund_swap_participation_icp_e8s : ?Nat64;
  neurons_fund_reserves : ?NeuronsFundSnapshot;
  ideal_matched_participation_function : ?IdealMatchedParticipationFunction;
  allocated_neurons_fund_participation_icp_e8s : ?Nat64;
};
type NeuronsFundSnapshot = {
  neurons_fund_neuron_portions : [NeuronsFundNeuronPortion];
};
type NodeProvider = {
  id : ?Principal;
  reward_account : ?AccountIdentifier;
};
type Ok = { neurons_fund_audit_info : ?NeuronsFundAuditInfo };
type Ok_1 = { neurons_fund_neuron_portions : [NeuronsFundNeuron] };
type OpenSnsTokenSwap = {
  community_fund_investment_e8s : ?Nat64;
  target_swap_canister_id : ?Principal;
  params : ?Params;
};
type Operation = {
  #RemoveHotKey : RemoveHotKey;
  #AddHotKey : AddHotKey;
  #ChangeAutoStakeMaturity : ChangeAutoStakeMaturity;
  #StopDissolving : {};
  #StartDissolving : {};
  #IncreaseDissolveDelay : IncreaseDissolveDelay;
  #JoinCommunityFund : {};
  #LeaveCommunityFund : {};
  #SetDissolveTimestamp : SetDissolveTimestamp;
};
type Params = {
  min_participant_icp_e8s : Nat64;
  neuron_basket_construction_parameters : ?NeuronBasketConstructionParameters_1;
  max_icp_e8s : Nat64;
  swap_due_timestamp_seconds : Nat64;
  min_participants : Nat32;
  sns_token_e8s : Nat64;
  sale_delay_seconds : ?Nat64;
  max_participant_icp_e8s : Nat64;
  min_direct_participation_icp_e8s : ?Nat64;
  min_icp_e8s : Nat64;
  max_direct_participation_icp_e8s : ?Nat64;
};
type Percentage = { basis_points : ?Nat64 };
type Progress = { #LastNeuronId : NeuronId };
type Proposal = {
  url : Text;
  title : ?Text;
  action : ?Action;
  summary : Text;
};
type ProposalData = {
  id : ?NeuronId;
  failure_reason : ?GovernanceError;
  cf_participants : [CfParticipant];
  ballots : [{ a: Nat64; b: Ballot }];
  proposal_timestamp_seconds : Nat64;
  reward_event_round : Nat64;
  failed_timestamp_seconds : Nat64;
  neurons_fund_data : ?NeuronsFundData;
  reject_cost_e8s : Nat64;
  derived_proposal_information : ?DerivedProposalInformation;
  latest_tally : ?Tally;
  sns_token_swap_lifecycle : ?Int32;
  decided_timestamp_seconds : Nat64;
  proposal : ?Proposal;
  proposer : ?NeuronId;
  wait_for_quiet_state : ?WaitForQuietState;
  executed_timestamp_seconds : Nat64;
  original_total_community_fund_maturity_e8s_equivalent : ?Nat64;
};
type ProposalInfo = {
  id : ?NeuronId;
  status : Int32;
  topic : Int32;
  failure_reason : ?GovernanceError;
  ballots : [{ a: Nat64; b: Ballot }];
  proposal_timestamp_seconds : Nat64;
  reward_event_round : Nat64;
  deadline_timestamp_seconds : ?Nat64;
  failed_timestamp_seconds : Nat64;
  reject_cost_e8s : Nat64;
  derived_proposal_information : ?DerivedProposalInformation;
  latest_tally : ?Tally;
  reward_status : Int32;
  decided_timestamp_seconds : Nat64;
  proposal : ?Proposal;
  proposer : ?NeuronId;
  executed_timestamp_seconds : Nat64;
};
type RegisterVote = { vote : Int32; proposal : ?NeuronId };
type RemoveHotKey = { hot_key_to_remove : ?Principal };
type Result = { #Ok; #Err : GovernanceError };
type Result_1 = { #Error : GovernanceError; #NeuronId : NeuronId };
type Result_10 = { #Ok : Ok_1; #Err : GovernanceError };
type Result_2 = { #Ok : Neuron; #Err : GovernanceError };
type Result_3 = { #Ok : GovernanceCachedMetrics; #Err : GovernanceError };
type Result_4 = { #Ok : RewardNodeProviders; #Err : GovernanceError };
type Result_5 = { #Ok : NeuronInfo; #Err : GovernanceError };
type Result_6 = { #Ok : Ok; #Err : GovernanceError };
type Result_7 = { #Ok : NodeProvider; #Err : GovernanceError };
type Result_8 = { #Committed : Committed; #Aborted : {} };
type Result_9 = { #Committed : Committed_1; #Aborted : {} };
type RewardEvent = {
  rounds_since_last_distribution : ?Nat64;
  day_after_genesis : Nat64;
  actual_timestamp_seconds : Nat64;
  total_available_e8s_equivalent : Nat64;
  latest_round_available_e8s_equivalent : ?Nat64;
  distributed_e8s_equivalent : Nat64;
  settled_proposals : [NeuronId];
};
type RewardMode = {
  #RewardToNeuron : RewardToNeuron;
  #RewardToAccount : RewardToAccount;
};
type RewardNodeProvider = {
  node_provider : ?NodeProvider;
  reward_mode : ?RewardMode;
  amount_e8s : Nat64;
};
type RewardNodeProviders = {
  use_registry_derived_rewards : ?Bool;
  rewards : [RewardNodeProvider];
};
type RewardToAccount = { to_account : ?AccountIdentifier };
type RewardToNeuron = { dissolve_delay_seconds : Nat64 };
type SetDefaultFollowees = {
  default_followees : [{ a: Int32; b: Followees }];
};
type SetDissolveTimestamp = { dissolve_timestamp_seconds : Nat64 };
type SetOpenTimeWindowRequest = { open_time_window : ?TimeWindow };
type SetSnsTokenSwapOpenTimeWindow = {
  request : ?SetOpenTimeWindowRequest;
  swap_canister_id : ?Principal;
};
type SettleCommunityFundParticipation = {
  result : ?Result_8;
  open_sns_token_swap_proposal_id : ?Nat64;
};
type SettleNeuronsFundParticipationRequest = {
  result : ?Result_9;
  nns_proposal_id : ?Nat64;
};
type SettleNeuronsFundParticipationResponse = { result : ?Result_10 };
type Spawn = {
  percentage_to_spawn : ?Nat32;
  new_controller : ?Principal;
  nonce : ?Nat64;
};
type SpawnResponse = { created_neuron_id : ?NeuronId };
type Split = { amount_e8s : Nat64 };
type StakeMaturity = { percentage_to_stake : ?Nat32 };
type StakeMaturityResponse = {
  maturity_e8s : Nat64;
  staked_maturity_e8s : Nat64;
};
type SwapBackgroundInformation = {
  ledger_index_canister_summary : ?CanisterSummary;
  fallback_controller_Principal_ids : [Principal];
  ledger_archive_canister_summaries : [CanisterSummary];
  ledger_canister_summary : ?CanisterSummary;
  swap_canister_summary : ?CanisterSummary;
  governance_canister_summary : ?CanisterSummary;
  root_canister_summary : ?CanisterSummary;
  dapp_canister_summaries : [CanisterSummary];
};
type SwapDistribution = { total : ?Tokens };
type SwapParameters = {
  minimum_participants : ?Nat64;
  neurons_fund_participation : ?Bool;
  duration : ?Duration;
  neuron_basket_construction_parameters : ?NeuronBasketConstructionParameters;
  confirmation_Text : ?Text;
  maximum_participant_icp : ?Tokens;
  minimum_icp : ?Tokens;
  minimum_direct_participation_icp : ?Tokens;
  minimum_participant_icp : ?Tokens;
  start_time : ?GlobalTimeOfDay;
  maximum_direct_participation_icp : ?Tokens;
  maximum_icp : ?Tokens;
  neurons_fund_investment_icp : ?Tokens;
  restricted_countries : ?Countries;
};
type SwapParticipationLimits = {
  min_participant_icp_e8s : ?Nat64;
  max_participant_icp_e8s : ?Nat64;
  min_direct_participation_icp_e8s : ?Nat64;
  max_direct_participation_icp_e8s : ?Nat64;
};
type Tally = {
  no : Nat64;
  yes : Nat64;
  total : Nat64;
  timestamp_seconds : Nat64;
};
type TimeWindow = {
  start_timestamp_seconds : Nat64;
  end_timestamp_seconds : Nat64;
};
type Tokens = { e8s : ?Nat64 };
type UpdateNodeProvider = { reward_account : ?AccountIdentifier };
type VotingRewardParameters = {
  reward_rate_transition_duration : ?Duration;
  initial_reward_rate : ?Percentage;
  final_reward_rate : ?Percentage;
};
type WaitForQuietState = { current_deadline_timestamp_seconds : Nat64 };
type XdrConversionRate = {
  xdr_permyriad_per_icp : ?Nat64;
  timestamp_seconds : ?Nat64;
};

  public type Interface = actor {
  claim_gtc_neurons : (Principal, [NeuronId]) -> async (Result);
  claim_or_refresh_neuron_from_account : (ClaimOrRefreshNeuronFromAccount) -> async (
      ClaimOrRefreshNeuronFromAccountResponse,
    );
  get_build_metadata : () -> async (Text);
  get_full_neuron : (Nat64) -> async (Result_2);
  get_full_neuron_by_id_or_subaccount : (NeuronIdOrSubaccount) -> async (
      Result_2,
    );
  get_latest_reward_event : () -> async (RewardEvent);
  get_metrics : () -> async (Result_3);
  get_monthly_node_provider_rewards : () -> async (Result_4);
  get_most_recent_monthly_node_provider_rewards : () -> async (
      ?MostRecentMonthlyNodeProviderRewards,
    );
  get_network_economics_parameters : () -> async (NetworkEconomics);
  get_neuron_ids : () -> async ([Nat64]);
  get_neuron_info : (Nat64) -> async (Result_5);
  get_neuron_info_by_id_or_subaccount : (NeuronIdOrSubaccount) -> async (
      Result_5,
    );
  get_neurons_fund_audit_info : (GetNeuronsFundAuditInfoRequest) -> async (
      GetNeuronsFundAuditInfoResponse,
    );
  get_node_provider_by_caller : () -> async (Result_7);
  get_pending_proposals : () -> async ([ProposalInfo]);
  get_proposal_info : (Nat64) -> async (?ProposalInfo);
  list_known_neurons : () -> async (ListKnownNeuronsResponse);
  list_neurons : (ListNeurons) -> async (ListNeuronsResponse);
  list_node_providers : () -> async (ListNodeProvidersResponse);
  list_proposals : (ListProposalInfo) -> async (ListProposalInfoResponse);
  manage_neuron : (ManageNeuron) -> async (ManageNeuronResponse);
  settle_community_fund_participation : (SettleCommunityFundParticipation) -> async (
      Result,
    );
  settle_neurons_fund_participation : (
      SettleNeuronsFundParticipationRequest,
    ) -> async (SettleNeuronsFundParticipationResponse);
  simulate_manage_neuron : (ManageNeuron) -> async (ManageNeuronResponse);
  transfer_gtc_neuron : (NeuronId, NeuronId) -> async (Result);
  update_node_provider : (UpdateNodeProvider) -> async (Result);
  };
};
