<script lang="ts">
  import { onMount } from "svelte";
  import Layout from "../Layout.svelte";
  import { authStore } from "$lib/stores/auth.store";
  import { ActorFactory } from "../../utils/ActorFactory";
  import { SnsGovernanceCanister } from "@dfinity/sns";
  import { Principal } from "@dfinity/principal";
  import type { ListProposalsResponse, ProposalData, Action } from "@dfinity/sns/dist/candid/sns_governance";

  let activeTab: string = "player_proposals";
  let selectedProposalStatus = 1;
  let proposals: ListProposalsResponse;
  let playerProposals: ProposalData[] = [];
  let clubProposals: ProposalData[] = [];
  let systemProposals: ProposalData[] = [];

  const PLAYER_FUNCTION_IDS: bigint[] = [1000n, 2000n, 8000n, 9000n, 10000n, 12000n, 13000n, 14000n, 15000n, 22000n];
  const CLUB_FUNCTION_IDS: bigint[] = [16000n, 17000n, 18000n, 23000n];

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
    if (process.env.DFX_NETWORK !== "ic") {
      await agent.fetchRootKey();
    }

    const principal: Principal = Principal.fromText(process.env.CANISTER_ID_SNS_GOVERNANCE ?? "");
    const { listProposals: governanceListProposals } = SnsGovernanceCanister.create({
      agent,
      canisterId: principal,
    });
    proposals = await governanceListProposals({ certified: false });
    categoriseProposals(proposals.proposals);
  }

  function categoriseProposals(proposalsArray: ProposalData[]) {
    playerProposals = [];
    clubProposals = [];
    systemProposals = [];

    for (const proposal of proposalsArray) {
      const action = proposal.proposal[0]?.action[0];
      let functionId: bigint | undefined;

      if (action) {
        if ("ExecuteGenericNervousSystemFunction" in action) {
          functionId = action.ExecuteGenericNervousSystemFunction.function_id;
        } else {
          functionId = 0n; // Placeholder, adjust according to your data
        }
      }

      if (functionId !== undefined) {
        if (PLAYER_FUNCTION_IDS.includes(functionId)) {
          playerProposals.push(proposal);
        } else if (CLUB_FUNCTION_IDS.includes(functionId)) {
          clubProposals.push(proposal);
        } else {
          systemProposals.push(proposal);
        }
      } else {
        systemProposals.push(proposal);
      }
    }
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
          {#if playerProposals.length > 0}
            {#each playerProposals as proposal}
              <div class="border border-gray-700 rounded-lg p-4 bg-light-gray flex flex-col">
                <div class="font-bold truncate">Id: {proposal.id[0]?.id}</div>
                <div class="truncate my-2">{proposal.proposal[0]?.title}</div>
                <div class="truncate">Summary: {proposal.proposal[0]?.summary}</div>
                <button class="p-2 fpl-button text-white rounded-md mt-4">View / Vote</button>
              </div>
            {/each}
          {/if}
        </div>
      {/if}

      {#if activeTab === "club_proposals"}
        <div class="grid grid-cols-1 gap-4 mt-4 sm:grid-cols-2 lg:grid-cols-3 mx-4 mb-4">
          {#if clubProposals.length > 0}
            {#each clubProposals as proposal}
              <div class="border border-gray-700 rounded-lg p-4 bg-light-gray flex flex-col">
                <div class="font-bold truncate">Id: {proposal.id[0]?.id}</div>
                <div class="truncate my-2">{proposal.proposal[0]?.title}</div>
                <div class="truncate">Summary: {proposal.proposal[0]?.summary}</div>
                <button class="p-2 fpl-button text-white rounded-md mt-4">View / Vote</button>
              </div>
            {/each}
          {/if}
        </div>
      {/if}

      {#if activeTab === "system_proposals"}
        <div class="grid grid-cols-1 gap-4 mt-4 sm:grid-cols-2 lg:grid-cols-3 mx-4 mb-4">
          {#if systemProposals.length > 0}
            {#each systemProposals as proposal}
              <div class="border border-gray-700 rounded-lg p-4 bg-light-gray flex flex-col">
                <div class="font-bold truncate">Id: {proposal.id[0]?.id}</div>
                <div class="truncate my-2">{proposal.proposal[0]?.title}</div>
                <div class="truncate">Summary: {proposal.proposal[0]?.summary}</div>
                <button class="p-2 fpl-button text-white rounded-md mt-4">View / Vote</button>
              </div>
            {/each}
          {/if}
        </div>
      {/if}
    </div>
  </div>
</Layout>
