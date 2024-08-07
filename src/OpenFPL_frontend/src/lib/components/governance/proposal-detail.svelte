<script lang="ts">
  import { Modal } from "@dfinity/gix-components";
  import LocalSpinner from "$lib/components/local-spinner.svelte";
  import { authStore } from "$lib/stores/auth.store";
  import { ActorFactory } from "../../../utils/ActorFactory";
  import { SnsGovernanceCanister, SnsVote } from "@dfinity/sns";
  import type { ProposalData } from "@dfinity/sns/dist/candid/sns_governance";
  import VotingBar from './voting-bar.svelte';

  export let visible: boolean;
  export let closeModal: () => void;

  export let proposal: ProposalData;

  let isLoading = false;
  let showConfirm = false;
  let vote = "";

  function voteYes() {
    vote = "Yes";
    showConfirm = true;
  }

  function voteNo() {
    vote = "No";
    showConfirm = true;
  }

  async function confirmVote() {
    isLoading = true;
    const identityActor: any = await ActorFactory.createIdentityActor(
      authStore,
      process.env.CANISTER_ID_SNS_GOVERNANCE ?? ""
    );

    const { listNeurons, registerVote } =
      SnsGovernanceCanister.create(identityActor);
    let neurons = await listNeurons({ certified: false });

    neurons.forEach((neuron) => {
      const neuronId = neuron.id[0];

      if (!neuronId) {
        return;
      }

      switch (vote) {
        case "Yes":
          registerVote({
            proposalId: proposal.id[0]!,
            vote: SnsVote.Yes,
            neuronId: neuronId,
          });
          break;
        case "No":
          registerVote({
            proposalId: proposal.id[0]!,
            vote: SnsVote.No,
            neuronId: neuronId,
          });
          break;
      }
    });

    isLoading = false;
    resetForm();
    closeModal();
  }

  function resetForm() {
    showConfirm = false;
    vote = "";
  }

  function cancelModal() {
    resetForm();
    closeModal();
  }

  // Convert bigint values to number
  const yesVotes = Number(proposal.latest_tally[0]?.yes ?? 0n);
  const noVotes = Number(proposal.latest_tally[0]?.no ?? 0n);
  const totalVotes = Number(proposal.latest_tally[0]?.total ?? 0n);
</script>

<Modal {visible} on:nnsClose={cancelModal}>
  <div class="mx-4 p-4">
    <div class="flex justify-between items-center my-2">
      <h3 class="default-header">Proposal {proposal.id[0]?.id}</h3>
      <button class="times-button" on:click={cancelModal}>&times;</button>
    </div>

    <div class="flex justify-start items-center w-full">
      <div class="w-full flex-col space-y-4 mb-2">
        <div class="flex-col space-y-2">
          <p class="text-xl">{proposal.proposal[0]?.title}</p>
          <p>{proposal.proposal[0]?.summary}</p>
          <div class="flex flex-row">
            <div class="col-1/2">
              <p>yes</p>
              <p>{yesVotes.toLocaleString()}</p>
            </div>
            <div class="col-1/2">
              <p>no</p>
              <p>{noVotes.toLocaleString()}</p>
            </div>
          </div>
          
          <VotingBar {yesVotes} {noVotes} {totalVotes} />

          <div class="border-b border-gray-200" />

          <div class="items-center flex space-x-4">
            <button
              class="px-4 py-2 default-button fpl-cancel-btn min-w-[150px]"
              type="button"
              on:click={cancelModal}
            >
              Cancel
            </button>
            <button
              class="fpl-purple-btn px-4 py-2 default-button min-w-[150px]"
              on:click={voteYes}
            >
              Vote Yes
            </button>
            <button
              class="fpl-purple-btn px-4 py-2 default-button min-w-[150px]"
              on:click={voteNo}
            >
              Vote No
            </button>
          </div>

          {#if showConfirm}
            <div class="items-center flex">
              <p class="text-orange-400">
                Are you sure you want to vote {vote} on proposal {proposal.id[0]?.id}.
              </p>
            </div>
            <div class="items-center flex">
              <button
                class="fpl-purple-btn px-4 py-2 default-button w-full"
                on:click={confirmVote}
              >
                Confirm Submit Proposal
              </button>
            </div>
          {/if}
        </div>
      </div>

      {#if isLoading}
        <LocalSpinner />
      {/if}
    </div>
  </div>
</Modal>
