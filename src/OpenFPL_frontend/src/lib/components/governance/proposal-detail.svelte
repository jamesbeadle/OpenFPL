<script lang="ts">
  import { Modal } from "@dfinity/gix-components";
  import LocalSpinner from "$lib/components/local-spinner.svelte";
  import type { ProposalInfo } from "@dfinity/nns";
  import { authStore } from "$lib/stores/auth.store";
  import { ActorFactory } from "../../../utils/ActorFactory";
  import { GovernanceCanister, Vote } from "@dfinity/nns";

  export let visible: boolean;
  export let closeModal: () => void;

  export let proposal: ProposalInfo;

  let isLoading = true;
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
      process.env.OPENFPL_GOVERNANCE_CANISTER_ID ?? ""
    ); //TODO: Create the governance canister

    const { listNeurons, registerVote } =
      GovernanceCanister.create(identityActor);
    let neurons = await listNeurons({ certified: false });

    neurons.forEach((element) => {
      switch (vote) {
        case "Yes":
          registerVote({
            neuronId: element.neuronId,
            proposalId: proposal.id!,
            vote: Vote.Yes,
          });
          break;
        case "No":
          registerVote({
            neuronId: element.neuronId,
            proposalId: proposal.id!,
            vote: Vote.No,
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
</script>

<Modal {visible} on:nnsClose={cancelModal}>
  <div class="mx-4 p-4">
    <div class="flex justify-between items-center my-2">
      <h3 class="default-header">Vote on proposal</h3>
      <button class="times-button" on:click={cancelModal}>&times;</button>
    </div>

    <div class="flex justify-start items-center w-full">
      <div class="w-full flex-col space-y-4 mb-2">
        <div class="flex-col space-y-2">
          <p>{proposal.proposal?.title}</p>
          <p>{proposal.proposal?.summary}</p>
          <p>{proposal.latestTally?.yes}</p>
          <p>{proposal.latestTally?.no}</p>

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
                Are you sure you want to vote {vote} on proposal {proposal.id}.
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
  </div></Modal
>