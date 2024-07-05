<script lang="ts">
  import { onMount } from "svelte";
  import Layout from "../Layout.svelte";
  import { authStore } from "$lib/stores/auth.store";
  import { ActorFactory } from "../../utils/ActorFactory";
  import { SnsGovernanceCanister } from "@dfinity/sns";
  import { Principal } from "@dfinity/principal";
    import type { ListProposalsResponse } from "@dfinity/sns/dist/candid/sns_governance";
  
  let activeTab: string = "player_proposals";

  let selectedProposalStatus = 1;
  let proposals: ListProposalsResponse;

  const proposalStatuses = [
    { id: 1, description: "Open" },
    { id: 2, description: "Rejected" },
    { id: 3, description: "Accepted" },
    { id: 4, description: "Executed" },
    { id: 5, description: "Failed" },
  ];

  function setActiveTab(tab: string): void {
    activeTab = tab;
  }

  onMount(() => {
    listProposals();
  });

  async function listProposals() {
      const agent: any = await ActorFactory.getGovernanceAgent();
      if(process.env.DFX_NETWORK !== "ic"){
        await agent.fetchRootKey()
      }
      
      const principcal: Principal = Principal.fromText(process.env.CANISTER_ID_SNS_GOVERNANCE ?? "");
      const { listProposals: governanceListProposals } = SnsGovernanceCanister.create({
        agent,
        canisterId: principcal,
      });
      proposals = await governanceListProposals({ certified: false });
  }
</script>

<Layout>
  <div class="m-4">
    <div class="bg-panel rounded-md">
      <ul class="flex rounded-t-lg bg-light-gray border-b border-gray-700 px-4 pt-2">
        <li class={`mr-4 ${activeTab === "player_proposals" ? "active-tab" : ""}`}>
          <button
            class={`p-2 ${activeTab === "player_proposals" ? "text-white" : "text-gray-400"}`}
            on:click={() => setActiveTab("player_proposals")}>Player Proposals</button>
        </li>
        <li class={`mr-4 ${activeTab === "club_proposals" ? "active-tab" : ""}`}>
          <button
            class={`p-2 ${activeTab === "club_proposals" ? "text-white" : "text-gray-400"}`}
            on:click={() => setActiveTab("club_proposals")}>Club Proposals</button>
        </li>
        <li class={`mr-4 ${activeTab === "system_proposals" ? "active-tab" : ""}`}>
          <button
            class={`p-2 ${activeTab === "system_proposals" ? "text-white" : "text-gray-400"}`}
            on:click={() => setActiveTab("system_proposals")}>System Proposals</button>
        </li>
      </ul>

      {#if activeTab === "player_proposals"}
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

        <div class="grid grid-cols-1 gap-4 mt-4 sm:grid-cols-2 lg:grid-cols-3 mx-4 mb-4">
          {#if proposals}
            {#each proposals.proposals as proposal}
              <div class="border border-gray-700 rounded-lg p-4 bg-light-gray flex flex-col">
                <div class="font-bold truncate">Id: {proposal.id[0]?.id}</div>
                <div class="truncate my-2">{proposal.proposal[0]?.title}</div>
                <div class="truncate">Title: {proposal.proposal[0]?.summary}</div>
                <button class="p-2 fpl-button text-white rounded-md mt-4">View / Vote //TODO</button>
              </div>
            {/each}
          {/if}
        </div>
      {/if}
    </div>
  </div>
</Layout>
