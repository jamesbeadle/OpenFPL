import Nat64 "mo:base/Nat64";
import Principal "mo:base/Principal";
import Blob "mo:base/Blob";
import Time "mo:base/Time";
import Int64 "mo:base/Int64";
import Array "mo:base/Array";
import Result "mo:base/Result";
import Bool "mo:base/Bool";
import Account "../lib/Account";
import CanisterIds "../CanisterIds";
import T "../types";
import Environment "../Environment";

module {

  public class Governance() {

    let network = Environment.DFX_NETWORK;
    var governance_canister_id = CanisterIds.GOVERNANCE_CANISTER_IC_ID; //TODO: UPDATE POST SNS
    type SnsProposalRewardStatus = Nat8;
    type ProposalId = Nat;
    type SnsProposalDecisionStatus = Nat8;

    type SnsListProposalsParams = {
      // A list of proposal reward statuses, specifying that only proposals that
      // that have one of the define reward statuses should be included
      // in the list.
      // If this list is empty, no restriction is applied.
      includeRewardStatus: ?[SnsProposalRewardStatus];
      // The proposal ID specifying which proposals to return.
      // This should be set to the last proposal of the previously returned page and
      // will not be included in the current page.
      beforeProposal: ?ProposalId;
      // Limit the number of Proposals returned in each page, from 1 to 100.
      // If a value outside of this range is provided, 100 will be used.
      limit: ?Nat;
      // A list of proposal types, specifying that proposals of the given
      // types should be excluded in this list.
      excludeType: [Nat];
      // A list of proposal decision statuses, specifying that only proposals that
      // that have one of the define decision statuses should be included
      // in the list.
      // If this list is empty, no restriction is applied.
      includeStatus: ?[SnsProposalDecisionStatus];
    };

    type NeuronId = {
      id: Nat;
    };
    
    type GovernanceError = {
      error_message: Text;
      error_type: Int;
    };

    type CfNeuron = {
      has_created_neuron_recipes: ?[Bool];
      nns_neuron_id: Nat;
      amount_icp_e8s: Nat;
    };
    
    type CfParticipant = {
      hotkey_principal: Text;
      cf_neurons: [CfNeuron];
    };

    type Ballot = {
      vote: Int;
      voting_power: Nat;
    };

    type NeuronsFundData = {
      final_neurons_fund_participation: ?[NeuronsFundParticipation];
      initial_neurons_fund_participation: ?[NeuronsFundParticipation];
      neurons_fund_refunds: ?[NeuronsFundSnapshot];
    };

    type NeuronsFundParticipation = {
      total_maturity_equivalent_icp_e8s: ?Nat;
      intended_neurons_fund_participation_icp_e8s: ?Nat;
      direct_participation_icp_e8s: ?Nat;
      swap_participation_limits: ?[SwapParticipationLimits];
      max_neurons_fund_swap_participation_icp_e8s: ?Nat;
      neurons_fund_reserves: ?[NeuronsFundSnapshot];
      ideal_matched_participation_function: [IdealMatchedParticipationFunction];
      allocated_neurons_fund_participation_icp_e8s: ?Nat;
    };

    type IdealMatchedParticipationFunction = {
      serialized_representation: ?[Text];
    };

    type NeuronsFundNeuronPortion = {
      hotkey_principal: ?[Principal];
      is_capped: ?[Bool];
      maturity_equivalent_icp_e8s: ?[Nat];
      nns_neuron_id: ?[NeuronId];
      amount_icp_e8s: ?[Nat];
    };
        
    type NeuronsFundSnapshot = {
      neurons_fund_neuron_portions: [NeuronsFundNeuronPortion];
    };

    type SwapParticipationLimits = {
      min_participant_icp_e8s: ?[Nat];
      max_participant_icp_e8s: ?[Nat];
      min_direct_participation_icp_e8s: ?[Nat];
      max_direct_participation_icp_e8s: ?[Nat];
    };

    type ProposalData = {
      id: ?[NeuronId];
      failure_reason:?[GovernanceError];
      cf_participants: [CfParticipant];
      ballots: [(Nat, Ballot)];
      proposal_timestamp_seconds: Nat;
      reward_event_round: Nat;
      failed_timestamp_seconds: Nat;
      neurons_fund_data: ?[NeuronsFundData];
      reject_cost_e8s: Nat;
      derived_proposal_information: ?[DerivedProposalInformation];
      latest_tally: ?[Tally];
      sns_token_swap_lifecycle: ?[Int];
      decided_timestamp_seconds: Nat;
      proposal: ?[Proposal];
      proposer: ?[NeuronId];
      wait_for_quiet_state: ?[WaitForQuietState];
      executed_timestamp_seconds: Nat;
      original_total_community_fund_maturity_e8s_equivalent: ?[Nat];
    };

    type WaitForQuietState = {
      current_deadline_timestamp_seconds: Nat;
    };

    type Proposal = {
      url: Text;
      title: ?[Text];
      action: ?[Action];
      summary: Text;
    };

    type Action = { ManageNeuron: ManageNeuron };

    type ManageNeuron = {
      id: ?[NeuronId];
      command: ?[Command];
      neuron_id_or_subaccount: ?[NeuronIdOrSubaccount];
    };
        
    type Command ={ MakeProposal: Proposal };

    type NeuronIdOrSubaccount = { NeuronId: NeuronId };

    type Tally = {
      no: Nat;
      yes: Nat;
      total: Nat;
      timestamp_seconds: Nat;
    };

    type CanisterSummary = {
      status: ?[CanisterStatusResultV2];
      canister_id: ?[Principal];
    };

    type CanisterStatusResultV2 = {
      status: ?[Int];
      freezing_threshold: ?[Nat];
      controllers: [Principal];
      memory_size: ?[Nat];
      cycles: ?[Nat];
      idle_cycles_burned_per_day: ?[Nat];
      module_hash: [Int8];
    };

    type SwapBackgroundInformation = {
      ledger_index_canister_summary: ?[CanisterSummary];
      fallback_controller_principal_ids: [Principal];
      ledger_archive_canister_summaries: [CanisterSummary];
      ledger_canister_summary: ?[CanisterSummary];
      swap_canister_summary: ?[CanisterSummary];
      governance_canister_summary: ?[CanisterSummary];
      root_canister_summary: ?[CanisterSummary];
      dapp_canister_summaries: [CanisterSummary];
    };

    type DerivedProposalInformation = {
      swap_background_information: ?[SwapBackgroundInformation];
    };

    let governance_canister_actor = actor (governance_canister_id) : actor {
      listProposals : (params: SnsListProposalsParams) -> async [ProposalData];
    };

  };
};
