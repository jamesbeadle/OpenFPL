module {

    type Account = { owner : ?Principal; subaccount : ?Subaccount };
    type Action = {
      #ManageNervousSystemParameters : NervousSystemParameters;
      #AddGenericNervousSystemFunction : NervousSystemFunction;
      #ManageDappCanisterSettings : ManageDappCanisterSettings;
      #RemoveGenericNervousSystemFunction : Nat64;
      #UpgradeSnsToNextVersion : {};
      #RegisterDappCanisters : RegisterDappCanisters;
      #TransferSnsTreasuryFunds : TransferSnsTreasuryFunds;
      #UpgradeSnsControlledCanister : UpgradeSnsControlledCanister;
      #DeregisterDappCanisters : DeregisterDappCanisters;
      #MintSnsTokens : MintSnsTokens;
      #Unspecified : {};
      #ManageSnsMetadata : ManageSnsMetadata;
      #ExecuteGenericNervousSystemFunction : ExecuteGenericNervousSystemFunction;
      #ManageLedgerParameters : ManageLedgerParameters;
      #Motion : Motion;
    };
    type ActionAuxiliary = {
      #TransferSnsTreasuryFunds : TransferSnsTreasuryFundsActionAuxiliary;
    };
    type AddNeuronPermissions = {
      permissions_to_add : ?NeuronPermissionList;
      principal_id : ?Principal;
    };
    type Amount = { e8s : Nat64 };
    type Ballot = {
      vote : Int32;
      cast_timestamp_seconds : Nat64;
      voting_power : Nat64;
    };
    type By = {
      #MemoAndController : MemoAndController;
      #NeuronId : {};
    };
    type CanisterStatusResultV2 = {
      status : CanisterStatusType;
      memory_size : Nat;
      cycles : Nat;
      settings : DefiniteCanisterSettingsArgs;
      idle_cycles_burned_per_day : Nat;
      module_hash : ?[Nat8];
    };
    type CanisterStatusType = { #stopped; #stopping; #running };
    type ChangeAutoStakeMaturity = {
      requested_setting_for_auto_stake_maturity : Bool;
    };
    type ClaimOrRefresh = { by : ?By };
    type ClaimOrRefreshResponse = { refreshed_neuron_id : ?NeuronId };
    type ClaimSwapNeuronsRequest = {
      neuron_parameters : [NeuronParameters];
    };
    type ClaimSwapNeuronsResponse = {
      claim_swap_neurons_result : ?ClaimSwapNeuronsResult;
    };
    type ClaimSwapNeuronsResult = { #Ok : ClaimedSwapNeurons; #Err : Int32 };
    type ClaimedSwapNeurons = { swap_neurons : [SwapNeuron] };
    type Command = {
      #Split : Split;
      #Follow : Follow;
      #DisburseMaturity : DisburseMaturity;
      #ClaimOrRefresh : ClaimOrRefresh;
      #Configure : Configure;
      #RegisterVote : RegisterVote;
      #MakeProposal : Proposal;
      #StakeMaturity : StakeMaturity;
      #RemoveNeuronPermissions : RemoveNeuronPermissions;
      #AddNeuronPermissions : AddNeuronPermissions;
      #MergeMaturity : MergeMaturity;
      #Disburse : Disburse;
    };
    type Command_1 = {
      #Error : GovernanceError;
      #Split : SplitResponse;
      #Follow : {};
      #DisburseMaturity : DisburseMaturityResponse;
      #ClaimOrRefresh : ClaimOrRefreshResponse;
      #Configure : {};
      #RegisterVote : {};
      #MakeProposal : GetProposal;
      #RemoveNeuronPermission : {};
      #StakeMaturity : StakeMaturityResponse;
      #MergeMaturity : MergeMaturityResponse;
      #Disburse : DisburseResponse;
      #AddNeuronPermission : {};
    };
    type Command_2 = {
      #Split : Split;
      #Follow : Follow;
      #DisburseMaturity : DisburseMaturity;
      #Configure : Configure;
      #RegisterVote : RegisterVote;
      #SyncCommand : {};
      #MakeProposal : Proposal;
      #FinalizeDisburseMaturity : FinalizeDisburseMaturity;
      #ClaimOrRefreshNeuron : ClaimOrRefresh;
      #RemoveNeuronPermissions : RemoveNeuronPermissions;
      #AddNeuronPermissions : AddNeuronPermissions;
      #MergeMaturity : MergeMaturity;
      #Disburse : Disburse;
    };
    type Configure = { operation : ?Operation };
    type Decimal = { human_readable : ?Text };
    type DefaultFollowees = { followees : [(Nat64, Followees )] };
    type DefiniteCanisterSettingsArgs = {
      freezing_threshold : Nat;
      controllers : [Principal];
      memory_allocation : Nat;
      compute_allocation : Nat;
    };
    type DeregisterDappCanisters = {
      canister_ids : [Principal];
      new_controllers : [Principal];
    };
    type Disburse = { to_account : ?Account; amount : ?Amount };
    type DisburseMaturity = {
      to_account : ?Account;
      percentage_to_disburse : Nat32;
    };
    type DisburseMaturityInProgress = {
      timestamp_of_disbursement_seconds : Nat64;
      amount_e8s : Nat64;
      account_to_disburse_to : ?Account;
      finalize_disbursement_timestamp_seconds : ?Nat64;
    };
    type DisburseMaturityResponse = {
      amount_disbursed_e8s : Nat64;
      amount_deducted_e8s : ?Nat64;
    };
    type DisburseResponse = { transfer_block_height : Nat64 };
    type DissolveState = {
      #DissolveDelaySeconds : Nat64;
      #WhenDissolvedTimestampSeconds : Nat64;
    };
    type ExecuteGenericNervousSystemFunction = {
      function_id : Nat64;
      payload : [Nat8];
    };
    type FinalizeDisburseMaturity = {
      amount_to_be_disbursed_e8s : Nat64;
      to_account : ?Account;
    };
    type Follow = { function_id : Nat64; followees : [NeuronId] };
    type Followees = { followees : [NeuronId] };
    type FunctionType = {
      #NativeNervousSystemFunction : {};
      #GenericNervousSystemFunction : GenericNervousSystemFunction;
    };
    type GenericNervousSystemFunction = {
      validator_canister_id : ?Principal;
      target_canister_id : ?Principal;
      validator_method_name : ?Text;
      target_method_name : ?Text;
    };
    type GetMaturityModulationResponse = {
      maturity_modulation : ?MaturityModulation;
    };
    type GetMetadataResponse = {
      url : ?Text;
      logo : ?Text;
      name : ?Text;
      description : ?Text;
    };
    type GetModeResponse = { mode : ?Int32 };
    type GetNeuron = { neuron_id : ?NeuronId };
    type GetNeuronResponse = { result : ?Result };
    type GetProposal = { proposal_id : ?ProposalId };
    type GetProposalResponse = { result : ?Result_1 };
    type GetRunningSnsVersionResponse = {
      deployed_version : ?Version;
      pending_version : ?UpgradeInProgress;
    };
    type GetSnsInitializationParametersResponse = {
      sns_initialization_parameters : Text;
    };
    type Governance = {
      root_canister_id : ?Principal;
      id_to_nervous_system_functions : [(Nat64, NervousSystemFunction)];
      metrics : ?GovernanceCachedMetrics;
      maturity_modulation : ?MaturityModulation;
      mode : Int32;
      parameters : ?NervousSystemParameters;
      is_finalizing_disburse_maturity : ?Bool;
      deployed_version : ?Version;
      sns_initialization_parameters : Text;
      latest_reward_event : ?RewardEvent;
      pending_version : ?UpgradeInProgress;
      swap_canister_id : ?Principal;
      ledger_canister_id : ?Principal;
      proposals : [(Nat64, ProposalData)];
      in_flight_commands : [(Text, NeuronInFlightCommand)];
      sns_metadata : ?ManageSnsMetadata;
      neurons : [(Text, Neuron)];
      genesis_timestamp_seconds : Nat64;
    };
    type GovernanceCachedMetrics = {
      not_dissolving_neurons_e8s_buckets : [(Nat64, Float)];
      garbage_collectable_neurons_count : Nat64;
      neurons_with_invalid_stake_count : Nat64;
      not_dissolving_neurons_count_buckets : [(Nat64, Nat64)];
      neurons_with_less_than_6_months_dissolve_delay_count : Nat64;
      dissolved_neurons_count : Nat64;
      total_staked_e8s : Nat64;
      total_supply_governance_tokens : Nat64;
      not_dissolving_neurons_count : Nat64;
      dissolved_neurons_e8s : Nat64;
      neurons_with_less_than_6_months_dissolve_delay_e8s : Nat64;
      dissolving_neurons_count_buckets : [(Nat64, Nat64)];
      dissolving_neurons_count : Nat64;
      dissolving_neurons_e8s_buckets :[(Nat64, Float)];
      timestamp_seconds : Nat64;
    };
    type GovernanceError = { error_message : Text; error_type : Int32 };
    type IncreaseDissolveDelay = {
      additional_dissolve_delay_seconds : Nat32;
    };
    type ListNervousSystemFunctionsResponse = {
      reserved_ids : [Nat64];
      functions :[NervousSystemFunction];
    };
    type ListNeurons = {
      of_principal : ?Principal;
      limit : Nat32;
      start_page_at : ?NeuronId;
    };
    type ListNeuronsResponse = { neurons : [Neuron] };
    type ListProposals = {
      include_reward_status : [Int32];
      before_proposal : ?ProposalId;
      limit : Nat32;
      exclude_type : [Nat64];
      include_status : [Int32];
    };
    type ListProposalsResponse = {
      include_ballots_by_caller : ?Bool;
      proposals : [ProposalData];
    };
    type ManageDappCanisterSettings = {
      freezing_threshold : ?Nat64;
      canister_ids : [Principal];
      reserved_cycles_limit : ?Nat64;
      log_visibility : ?Int32;
      memory_allocation : ?Nat64;
      compute_allocation : ?Nat64;
    };
    type ManageLedgerParameters = { transfer_fee : ?Nat64 };
    type ManageNeuron = { subaccount : [Nat8]; command : ?Command };
    type ManageNeuronResponse = { command : ?Command_1 };
    type ManageSnsMetadata = {
      url : ?Text;
      logo : ?Text;
      name : ?Text;
      description : ?Text;
    };
    type MaturityModulation = {
      current_basis_points : ?Int32;
      updated_at_timestamp_seconds : ?Nat64;
    };
    type MemoAndController = { controller : ?Principal; memo : Nat64 };
    type MergeMaturity = { percentage_to_merge : Nat32 };
    type MergeMaturityResponse = {
      merged_maturity_e8s : Nat64;
      new_stake_e8s : Nat64;
    };
    type MintSnsTokens = {
      to_principal : ?Principal;
      to_subaccount : ?Subaccount;
      memo : ?Nat64;
      amount_e8s : ?Nat64;
    };
    type Motion = { motion_text : Text };
    type NervousSystemFunction = {
      id : Nat64;
      name : Text;
      description : ?Text;
      function_type : ?FunctionType;
    };
    type NervousSystemParameters = {
      default_followees : ?DefaultFollowees;
      max_dissolve_delay_seconds : ?Nat64;
      max_dissolve_delay_bonus_percentage : ?Nat64;
      max_followees_per_function : ?Nat64;
      neuron_claimer_permissions : ?NeuronPermissionList;
      neuron_minimum_stake_e8s : ?Nat64;
      max_neuron_age_for_age_bonus : ?Nat64;
      initial_voting_period_seconds : ?Nat64;
      neuron_minimum_dissolve_delay_to_vote_seconds : ?Nat64;
      reject_cost_e8s : ?Nat64;
      max_proposals_to_keep_per_action : ?Nat32;
      wait_for_quiet_deadline_increase_seconds : ?Nat64;
      max_number_of_neurons : ?Nat64;
      transaction_fee_e8s : ?Nat64;
      max_number_of_proposals_with_ballots : ?Nat64;
      max_age_bonus_percentage : ?Nat64;
      neuron_grantable_permissions : ?NeuronPermissionList;
      voting_rewards_parameters : ?VotingRewardsParameters;
      maturity_modulation_disabled : ?Bool;
      max_number_of_principals_per_neuron : ?Nat64;
    };
    type Neuron = {
      id : ?NeuronId;
      staked_maturity_e8s_equivalent : ?Nat64;
      permissions : [NeuronPermission];
      maturity_e8s_equivalent : Nat64;
      cached_neuron_stake_e8s : Nat64;
      created_timestamp_seconds : Nat64;
      source_nns_neuron_id : ?Nat64;
      auto_stake_maturity : ?Bool;
      aging_since_timestamp_seconds : Nat64;
      dissolve_state : ?DissolveState;
      voting_power_percentage_multiplier : Nat64;
      vesting_period_seconds : ?Nat64;
      disburse_maturity_in_progress : [DisburseMaturityInProgress];
      followees : [(Nat64, Followees)];
      neuron_fees_e8s : Nat64;
    };
    type NeuronId = { id : [Nat8] };
    type NeuronInFlightCommand = {
      command : ?Command_2;
      timestamp : Nat64;
    };
    type NeuronParameters = {
      controller : ?Principal;
      dissolve_delay_seconds : ?Nat64;
      source_nns_neuron_id : ?Nat64;
      stake_e8s : ?Nat64;
      followees : [NeuronId];
      hotkey : ?Principal;
      neuron_id : ?NeuronId;
    };
    type NeuronPermission = {
      principal : ?Principal;
      permission_type : [Int32];
    };
    type NeuronPermissionList = { permissions : [Int32] };
    type Operation = {
      #ChangeAutoStakeMaturity : ChangeAutoStakeMaturity;
      #StopDissolving : {};
      #StartDissolving : {};
      #IncreaseDissolveDelay : IncreaseDissolveDelay;
      #SetDissolveTimestamp : SetDissolveTimestamp;
    };
    type Percentage = { basis_points : ?Nat64 };
    type Proposal = {
      url : Text;
      title : Text;
      action : ?Action;
      summary : Text;
    };
    type ProposalData = {
      id : ?ProposalId;
      payload_text_rendering : ?Text;
      action : Nat64;
      failure_reason : ?GovernanceError;
      action_auxiliary : ?ActionAuxiliary;
      ballots : [(Text, Ballot)];
      minimum_yes_proportion_of_total : ?Percentage;
      reward_event_round : Nat64;
      failed_timestamp_seconds : Nat64;
      reward_event_end_timestamp_seconds : ?Nat64;
      proposal_creation_timestamp_seconds : Nat64;
      initial_voting_period_seconds : Nat64;
      reject_cost_e8s : Nat64;
      latest_tally : ?Tally;
      wait_for_quiet_deadline_increase_seconds : Nat64;
      decided_timestamp_seconds : Nat64;
      proposal : ?Proposal;
      proposer : ?NeuronId;
      wait_for_quiet_state : ?WaitForQuietState;
      minimum_yes_proportion_of_exercised : ?Percentage;
      is_eligible_for_rewards : Bool;
      executed_timestamp_seconds : Nat64;
    };
    type ProposalId = { id : Nat64 };
    type RegisterDappCanisters = { canister_ids : [Principal] };
    type RegisterVote = { vote : Int32; proposal : ?ProposalId };
    type RemoveNeuronPermissions = {
      permissions_to_remove : ?NeuronPermissionList;
      principal_id : ?Principal;
    };
    type Result = { #Error : GovernanceError; #Neuron : Neuron };
    type Result_1 = { #Error : GovernanceError; #Proposal : ProposalData };
    type RewardEvent = {
      rounds_since_last_distribution : ?Nat64;
      actual_timestamp_seconds : Nat64;
      end_timestamp_seconds : ?Nat64;
      distributed_e8s_equivalent : Nat64;
      round : Nat64;
      settled_proposals : [ProposalId];
    };
    type SetDissolveTimestamp = { dissolve_timestamp_seconds : Nat64 };
    type SetMode = { mode : Int32 };
    type Split = { memo : Nat64; amount_e8s : Nat64 };
    type SplitResponse = { created_neuron_id : ?NeuronId };
    type StakeMaturity = { percentage_to_stake : ?Nat32 };
    type StakeMaturityResponse = {
      maturity_e8s : Nat64;
      staked_maturity_e8s : Nat64;
    };
    type Subaccount = { subaccount : [Nat8] };
    type SwapNeuron = { id : ?NeuronId; status : Int32 };
    type Tally = {
      no : Nat64;
      yes : Nat64;
      total : Nat64;
      timestamp_seconds : Nat64;
    };
    type Tokens = { e8s : ?Nat64 };
    type TransferSnsTreasuryFunds = {
      from_treasury : Int32;
      to_principal : ?Principal;
      to_subaccount : ?Subaccount;
      memo : ?Nat64;
      amount_e8s : Nat64;
    };
    type TransferSnsTreasuryFundsActionAuxiliary = {
      valuation : ?Valuation;
    };
    type UpgradeInProgress = {
      mark_failed_at_seconds : Nat64;
      checking_upgrade_lock : Nat64;
      proposal_id : Nat64;
      target_version : ?Version;
    };
    type UpgradeSnsControlledCanister = {
      new_canister_wasm : [Nat8];
      mode : ?Int32;
      canister_id : ?Principal;
      canister_upgrade_arg : ?[Nat8];
    };
    type Valuation = {
      token : ?Int32;
      account : ?Account;
      valuation_factors : ?ValuationFactors;
      timestamp_seconds : ?Nat64;
    };
    type ValuationFactors = {
      xdrs_per_icp : ?Decimal;
      icps_per_token : ?Decimal;
      tokens : ?Tokens;
    };
    type Version = {
      archive_wasm_hash : [Nat8];
      root_wasm_hash : [Nat8];
      swap_wasm_hash : [Nat8];
      ledger_wasm_hash : [Nat8];
      governance_wasm_hash : [Nat8];
      index_wasm_hash : [Nat8];
    };
    type VotingRewardsParameters = {
      final_reward_rate_basis_points : ?Nat64;
      initial_reward_rate_basis_points : ?Nat64;
      reward_rate_transition_duration_seconds : ?Nat64;
      round_duration_seconds : ?Nat64;
    };
    type WaitForQuietState = { current_deadline_timestamp_seconds : Nat64 };
    
      
    public type Interface = actor {
      claim_swap_neurons : (ClaimSwapNeuronsRequest) -> async (ClaimSwapNeuronsResponse);
      fail_stuck_upgrade_in_progress : ({}) -> async ({});
      get_build_metadata : () -> async (Text);
      get_latest_reward_event : () -> async (RewardEvent);
      get_maturity_modulation : ({}) -> async (GetMaturityModulationResponse);
      get_metadata : ({}) -> async (GetMetadataResponse);
      get_mode : ({}) -> async (GetModeResponse);
      get_nervous_system_parameters : () -> async (NervousSystemParameters);
      get_neuron : (GetNeuron) -> async (GetNeuronResponse);
      get_proposal : (GetProposal) -> async (GetProposalResponse);
      get_root_canister_status : () -> async (CanisterStatusResultV2);
      get_running_sns_version : ({}) -> async (GetRunningSnsVersionResponse);
      get_sns_initialization_parameters : ({}) -> async (
          GetSnsInitializationParametersResponse,
        );
      list_nervous_system_functions : () -> async (
          ListNervousSystemFunctionsResponse,
        );
      list_neurons : (ListNeurons) -> async (ListNeuronsResponse);
      list_proposals : (ListProposals) -> async (ListProposalsResponse);
      manage_neuron : (ManageNeuron) -> async (ManageNeuronResponse);
      set_mode : (SetMode) -> async ({});
    };

  
};
