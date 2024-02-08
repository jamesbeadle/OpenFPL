<script lang="ts">
  import { onMount } from "svelte";
  import Layout from "../Layout.svelte";
  import { GovernanceCanister } from "@dfinity/nns";
  import { authStore } from "$lib/stores/auth.store";
  import { ActorFactory } from "../../utils/ActorFactory";
  import type { ListProposalsRequest, ProposalInfo } from "@dfinity/nns";

  let activeTab: string = "proposals";

  let activeProposals: ProposalInfo[] = [];
  let selectedProposalStatus = 1;

  const proposalStatuses = [
  { id: 1, description: "Open" },
  { id: 2, description: "Rejected" },
  { id: 3, description: "Accepted" },
  { id: 4, description: "Executed" },
  { id: 5, description: "Failed" }
];

  function setActiveTab(tab: string): void {
    activeTab = tab;
  }

  onMount(() => {
    listProposals();
  });

  async function listProposals() {
    if(!process.env.OPENFPL_GOVERNANCE_CANISTER_ID){
      console.log("HERE")
      return;
    }
    const identityActor: any = await ActorFactory.createIdentityActor(
      authStore,
      process.env.OPENFPL_GOVERNANCE_CANISTER_ID ?? ""
    ); //TODO: Create the governance canister

    const { listProposals } = GovernanceCanister.create(identityActor);
    let request: ListProposalsRequest = {
      limit: 100,
      includeRewardStatus: [1],
      excludeTopic: [0],
      includeAllManageNeuronProposals: true,
      includeStatus: [selectedProposalStatus],
      beforeProposal: 0n,
    };
    let proposalResponse = await listProposals({ request, certified: false });
    activeProposals = proposalResponse.proposals;
  }
</script>

<Layout>
  <div class="m-4">
    <div class="bg-panel rounded-md">
      <ul
        class="flex rounded-t-lg bg-light-gray border-b border-gray-700 px-4 pt-2"
      >
        <li class={`mr-4 ${activeTab === "proposals" ? "active-tab" : ""}`}>
          <button
            class={`p-2 ${
              activeTab === "proposals" ? "text-white" : "text-gray-400"
            }`}
            on:click={() => setActiveTab("details")}>Proposals</button
          >
        </li>
      </ul>

      {#if activeTab === "proposals"}
      <div class="flex justify-between items-center mx-4 mt-4">
        <select class="fpl-dropdown min-w-[100px]" bind:value={selectedProposalStatus}>
          {#each proposalStatuses as proposalType}
            <option value={proposalType.id}>{proposalType.description}</option>
          {/each}
        </select>
        <a href="/add-proposal">
        <button class="p-2 fpl-button text-white rounded-md">Raise Proposal</button>
      </a>
      </div>

        <div class="flex flex-col space-y-4 mt-4">
          <div class="overflow-x-auto flex-1">
            <div
              class="flex justify-between p-2 border border-gray-700 py-4 bg-light-gray"
            >
              <div class="w-2/12">Id</div>
              <div class="w-2/12">Proposal Type</div>
              <div class="w-4/12">Details</div>
              <div class="w-4/12">Voting</div>
            </div>
            
            {#each activeProposals as proposal}
              <div
                class="flex items-center p-2 justify-between py-4 border-b border-gray-700 cursor-pointer"
              >
                <div class="w-2/12">{proposal.id}</div>
                <div class="w-2/12">{proposal.topic}</div>
                <div class="w-4/12">{proposal.proposal?.title}</div>
                <div class="w-4/12">{proposal.latestTally?.yes}</div>
                <div class="w-4/12">{proposal.latestTally?.no}</div>
                <div class="w-4/12">
                  <button>Vote</button>
                </div>
              </div>
            {/each}
          </div>
        </div>
      {/if}
    </div>
  </div>
</Layout>
