module {
    public let CANISTER_ID : Text = "rrkah-fqaaa-aaaaa-aaaaq-cai";

    public type Result<T, E> = {
        #Ok  : T;
        #Err : E;
    };

    public type ListNeurons = {
        neuron_ids : Nat64;
        include_neurons_readable_by_caller: Bool;
    };

    public type ListNeuronsResponse = {
        neuron_infos: [(Nat64, NeuronInfo)];
        full_neurons : Neuron;
    };

    public type BallotInfo = {
        vote : Int32;
        proposal_id : ?NeuronId;
    };

    public type NeuronId = {
        id : Nat64;
    };

    public type DissolveState = {
        #DissolveDelaySeconds : Nat64;
        #WhenDissolvedTimestampSeconds : Nat64;
    };

    public type NeuronStakeTransfer = {
        to_subaccount : [Nat8];
        neuron_stake_e8s : Nat64;
        from : ?Principal;
        memo : Nat64;
        from_subaccount : [Nat8];
        transfer_timestamp : Nat64;
        block_height : Nat64;
    };

    public type KnownNeuronData = {
        name : Text;
        description : ?Text;
    };

    public type NeuronInfo = {
        dissolve_delay_seconds : Nat64;
        recent_ballots : [BallotInfo];
        created_timestamp_seconds : Nat64;
        state : Int32;
        stake_e8s : Nat64;
        joined_community_fund_timestamp_seconds : ?Nat64;
        retrieved_at_timestamp_seconds : Nat64;
        known_neuron_data : ?KnownNeuronData;
        voting_power : Nat64;
        age_seconds : Nat64;
    };

    public type Neuron = {
        id : ?NeuronId;
        staked_maturity_e8s_equivalent : ?Nat64;
        controller : ?Principal;
        recent_ballots : [BallotInfo];
        kyc_verified : Bool;
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
        followees : [(Int32, Followees)];
        neuron_fees_e8s : Nat64;
        transfer : ?NeuronStakeTransfer;
        known_neuron_data : ?KnownNeuronData;
        spawn_at_timestamp_seconds : ?Nat64;
    };

    public type Followees = {
        followees : [NeuronId];
    };

    public type ListProposalInfo = {
        include_reward_status : Int32;
        before_proposal: NeuronId;
        limit: Nat32;
        exclude_topic: Int32;
        include_all_manage_neuron_proposals: Bool;
        include_status: Int32;
    };

    public type ListProposalInfoResponse = { proposal_info: ProposalInfo };

    public type Tally = {
        no : Nat64;
        yes : Nat64;
        total : Nat64;
        timestamp_seconds : Nat64;
    };

    public type GovernanceError = {
        error_message : Text;
        error_type : Int32;
    };

    public type Ballot = {
        vote : Int32;
        voting_power : Nat64;
    };

     public type DerivedProposalInformation = {
        swap_background_information : ?SwapBackgroundInformation;
    };

    public type SwapBackgroundInformation = {
        ledger_index_canister_summary : ?CanisterSummary;
        fallback_controller_principal_ids : [Principal];
        ledger_archive_canister_summaries : [CanisterSummary];
        ledger_canister_summary : ?CanisterSummary;
        swap_canister_summary : ?CanisterSummary;
        governance_canister_summary : ?CanisterSummary;
        root_canister_summary : ?CanisterSummary;
        dapp_canister_summaries : [CanisterSummary];
    };

    public type CanisterSummary = {
        status : ?CanisterStatusResultV2;
        canister_id : ?Principal;
    };

    public type CanisterStatusResultV2 = {
        status : ?Int32;
        freezing_threshold : ?Nat64;
        controllers : [Principal];
        memory_size : ?Nat64;
        cycles : ?Nat64;
        idle_cycles_burned_per_day : ?Nat64;
        module_hash : [Nat8];
    };

    public type ProposalInfo = {
        id : ?NeuronId;
        status : Int32;
        topic : Int32;
        failure_reason : ?GovernanceError;
        ballots : [(Nat64, Ballot)];
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

    public type KnownNeuron = {
        id : ?NeuronId;
        known_neuron_data : ?KnownNeuronData;
    };

    public type ManageNeuron = {
        id : ?NeuronId;
        command : ?Command;
        neuron_id_or_subaccount : ?NeuronIdOrSubaccount; // This type is not provided
    };

    public type NeuronIdOrSubaccount = {
        #Subaccount : [Nat8];
        #NeuronId : NeuronId;
    };


    public type Command = {
        #Spawn : Spawn;                      // This type is not provided
        #Split : Split;                      // This type is not provided
        #Follow : Follow;                    // This type is not provided
        #ClaimOrRefresh : ClaimOrRefresh;    // This type is not provided
        #Configure : Configure;              // This type is not provided
        #RegisterVote : RegisterVote;        // This type is not provided
        #Merge : Merge;                      // This type is not provided
        #DisburseToNeuron : DisburseToNeuron;  // This type is not provided
        #MakeProposal : Proposal;            // This type was previously provided
        #StakeMaturity : StakeMaturity;      // This type is not provided
        #MergeMaturity : MergeMaturity;      // This type is not provided
        #Disburse : Disburse;                // This type is not provided
    };

    type Spawn = {
        percentage_to_spawn : ?Nat32;
        new_controller : ?Principal;
        nonce : ?Nat64;
    };

    type Split = { amount_e8s : Nat64 };

    type Follow = {
        topic : Int32;
        followees : [NeuronId];
    };

    type ClaimOrRefresh = { by : ?By };

    type RegisterVote = {
        vote : Int32;
        proposal : ?NeuronId;
    };

    type Merge = {
        source_neuron_id : ?NeuronId;
    };

    type DisburseToNeuron = {
        dissolve_delay_seconds : Nat64;
        kyc_verified : Bool;
        amount_e8s : Nat64;
        new_controller : ?Principal;
        nonce : Nat64;
    };

    type StakeMaturity = {
        percentage_to_stake : ?Nat32;
    };

    type MergeMaturity = {
        percentage_to_merge : Nat32;
    };

    type Disburse = {
        to_account : ?AccountIdentifier;
        amount : ?Amount;
    };

    public type AccountIdentifier = {
        hash : [Nat8];
    };

    public type Amount = { 
        e8s: Nat64 
    };

    public type By = {
        #NeuronIdOrSubaccount : {};
        #MemoAndController : ClaimOrRefreshNeuronFromAccount;
        #Memo : Nat64;
    };

    public type ClaimOrRefreshNeuronFromAccount = {
        controller : ?Principal;
        memo : Nat64;
    };

    public type Configure = { operation : ?Operation };

    public type Operation = {
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

    public type RemoveHotKey = {
        hot_key_to_remove : ?Principal;
    };

    public type AddHotKey = {
        new_hot_key : ?Principal;
    };

    public type ChangeAutoStakeMaturity = {
        requested_setting_for_auto_stake_maturity : Bool;
    };

    public type IncreaseDissolveDelay = {
        additional_dissolve_delay_seconds : Nat32;
    };

    public type SetDissolveTimestamp = {
        dissolve_timestamp_seconds : Nat64;
    };

    public type Proposal = {
        url : Text;
        title : ?Text;
        action : ?Action;
        summary : Text;
    };

    public type Action = {
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

    public type CreateServiceNervousSystem = {
        url : ?Text;
        governance_parameters : ?GovernanceParameters;
        fallback_controller_principal_ids : [Principal];
        logo : ?Image;
        name : ?Text;
        ledger_parameters : ?LedgerParameters;
        description : ?Text;
        dapp_canisters : [Canister];
        swap_parameters : ?SwapParameters;
        initial_token_distribution : ?InitialTokenDistribution;
    };

    public type GovernanceParameters = {
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

    public type ExecuteNnsFunction = {
        nns_function : Int32;
        payload : [Nat8];
    };

    public type RewardNodeProvider = {
        node_provider : ?NodeProvider;
        reward_mode : ?RewardMode;
        amount_e8s : Nat64;
    };

    public type RewardMode = {
        #RewardToNeuron : RewardToNeuron;
        #RewardToAccount : RewardToAccount;
    };

    public type RewardToAccount = {
        to_account : ?AccountIdentifier;
    };

    public type RewardToNeuron = {
        dissolve_delay_seconds : Nat64;
    };

    public type NodeProvider = {
        id : ?Principal;
        reward_account : ?AccountIdentifier;
    };

    public type OpenSnsTokenSwap = {
        community_fund_investment_e8s : ?Nat64;
        target_swap_canister_id : ?Principal;
        params : ?Params;
    };

    public type SetSnsTokenSwapOpenTimeWindow = {
        request : ?SetOpenTimeWindowRequest;
        swap_canister_id : ?Principal;
    };

    public type RewardNodeProviders = {
        use_registry_derived_rewards : ?Bool;
        rewards : [RewardNodeProvider];
    };

    public type NetworkEconomics = {
        neuron_minimum_stake_e8s : Nat64;
        max_proposals_to_keep_per_topic : Nat32;
        neuron_management_fee_per_proposal_e8s : Nat64;
        reject_cost_e8s : Nat64;
        transaction_fee_e8s : Nat64;
        neuron_spawn_dissolve_delay_seconds : Nat64;
        minimum_icp_xdr_rate : Nat64;
        maximum_node_provider_rewards_e8s : Nat64;
    };

    public type ApproveGenesisKyc = {
        principals : [Principal];
    };

    public type AddOrRemoveNodeProvider = {
        change : ?Change;
    };

    public type Change = {
        #ToRemove : NodeProvider;
        #ToAdd : NodeProvider;
    };

    public type SetDefaultFollowees = {
        default_followees : [(Int32, Followees)];
    };

    public type Motion = { motion_text : Text };

    public type Image = { base64_encoding : ?Text };

    public type LedgerParameters = {
        transaction_fee : ?Tokens;
        token_symbol : ?Text;
        token_logo : ?Image;
        token_name : ?Text;
    };

    public type SwapParameters = {
        minimum_participants : ?Nat64;
        duration : ?Duration;
        neuron_basket_construction_parameters : ?NeuronBasketConstructionParameters;
        confirmation_text : ?Text;
        maximum_participant_icp : ?Tokens;
        minimum_icp : ?Tokens;
        minimum_participant_icp : ?Tokens;
        start_time : ?GlobalTimeOfDay;
        maximum_icp : ?Tokens;
        restricted_countries : ?Countries;
    };

    public type InitialTokenDistribution = {
        treasury_distribution : ?SwapDistribution;
        developer_distribution : ?DeveloperDistribution;
        swap_distribution : ?SwapDistribution;
    };

    public type Percentage = { basis_points : ?Nat64 };

    public type Duration = { seconds : ?Nat64 };

    public type VotingRewardParameters = {
        reward_rate_transition_duration : ?Duration;
        initial_reward_rate : ?Percentage;
        final_reward_rate : ?Percentage;
    };

    public type Canister = { id : ?Principal };

    public type Tokens = { e8s : ?Nat64 };

    public type Params = {
        min_participant_icp_e8s : Nat64;
        neuron_basket_construction_parameters : ?NeuronBasketConstructionParameters_1;
        max_icp_e8s : Nat64;
        swap_due_timestamp_seconds : Nat64;
        min_participants : Nat32;
        sns_token_e8s : Nat64;
        sale_delay_seconds : ?Nat64;
        max_participant_icp_e8s : Nat64;
        min_icp_e8s : Nat64;
    };
    
    public type TimeWindow = {
        start_timestamp_seconds : Nat64;
        end_timestamp_seconds : Nat64;
    };

    public type SetOpenTimeWindowRequest = {
        open_time_window : ?TimeWindow;
    };

    public type NeuronBasketConstructionParameters = {
        dissolve_delay_interval : ?Duration;
        count : ?Nat64;
    };

    public type GlobalTimeOfDay = {
        seconds_after_utc_midnight : ?Nat64;
    };

    public type Countries = {
        iso_codes : [Text];
    };

    public type SwapDistribution = {
        total : ?Tokens;
    };

    public type DeveloperDistribution = {
        developer_neurons : [NeuronDistribution];
    };

    public type NeuronDistribution = {
        controller : ?Principal;
        dissolve_delay : ?Duration;
        memo : ?Nat64;
        vesting_period : ?Duration;
        stake : ?Tokens;
    };

    public type NeuronBasketConstructionParameters_1 = {
        dissolve_delay_interval_seconds : Nat64;
        count : Nat64;
    };


    type ManageNeuronResponse = {
    command : ?Command_1;
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

    public type SpawnResponse = {
        created_neuron_id : ?NeuronId;
    };

    public type ClaimOrRefreshResponse = {
        refreshed_neuron_id : ?NeuronId;
    };

    public type MergeResponse = {
        target_neuron : ?Neuron;
        source_neuron : ?Neuron;
        target_neuron_info : ?NeuronInfo;
        source_neuron_info : ?NeuronInfo;
    };

    public type MakeProposalResponse = {
        proposal_id : ?NeuronId;
    };

    public type StakeMaturityResponse = {
        maturity_e8s : Nat64;
        staked_maturity_e8s : Nat64;
    };

    public type MergeMaturityResponse = {
        merged_maturity_e8s : Nat64;
        new_stake_e8s : Nat64;
    };

    public type DisburseResponse = {
        transfer_block_height : Nat64;
    };

    public type Interface = actor {
        list_neurons: ListNeurons -> async ListNeuronsResponse;
        list_proposals: ListProposalInfo -> async ListProposalInfoResponse;
        manage_neuron: ManageNeuron -> async ManageNeuronResponse;
    };

};
