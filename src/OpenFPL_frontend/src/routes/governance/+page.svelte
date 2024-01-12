<script lang="ts">
  import { onMount } from "svelte";
  import Layout from "../Layout.svelte";
  import { GovernanceCanister } from "@dfinity/nns";
  import { authStore } from '$lib/stores/auth.store';
  import { ActorFactory } from "../../utils/ActorFactory";
  import type { ListProposalsRequest, ProposalInfo } from "@dfinity/nns";
  
  let activeTab: string = "proposals";

  let activeProposals: ProposalInfo[] = [];

  function setActiveTab(tab: string): void {
    activeTab = tab;
  }

  onMount(() => {
    listProposals();
  });

  async function listProposals(){
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
      includeStatus: [1],
      beforeProposal: 0n
    };
    let proposalResponse = await listProposals({request, certified: false});
    activeProposals = proposalResponse.proposals;
    

  }
</script>

<!-- //TODO: List the proposals and add filters etc -->
<!-- 

//list all the active proposals
//allow users to vote on the proposals


-->
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
        <div class="p-4">
          <p>Proposals will appear here after the SNS decentralisation sale.</p>
          <p>
            For now the OpenFPL team will continue to add fixture data through <a
              class="text-blue-500"
              href="/fixture-validation">this</a
            > view.
          </p>
        </div>
      {/if}
    </div>
  </div>
</Layout>
