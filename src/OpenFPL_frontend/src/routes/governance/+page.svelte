<script lang="ts">
  import { onMount } from "svelte";
  import Layout from "../Layout.svelte";
  import { ActorFactory } from "../../utils/ActorFactory";
  import { SnsGovernanceCanister, type SnsListProposalsParams } from "@dfinity/sns";
  import { Principal } from "@dfinity/principal";
  import type { ListProposalsResponse, ProposalData, ProposalId } from "@dfinity/sns/dist/candid/sns_governance";
    import ProposalDetail from "$lib/components/governance/proposal-detail.svelte";
    import { writable, type Writable } from "svelte/store";
  
  let selectedProposalStatus = [0,1,2,3,4,5];
  let proposals: ListProposalsResponse = { proposals: [], include_ballots_by_caller: [] };
  let filteredProposals: ProposalData[] = [];

  let currentPage: number = 1;
  let itemsPerPage: number = 100;
  let totalPages: number = 1;
  let activeTab: string = "proposals";

  let showProposal = false;
  let selectedProposal: ProposalData;
  let loadingProposals: Writable<boolean> = writable(false);

  let filterType = -1;
  let filterStatus = -1;

  const PLAYER_FUNCTION_IDS: bigint[] = [1000n, 2000n, 8000n, 9000n, 10000n, 12000n, 13000n, 14000n, 15000n, 22000n];
  const CLUB_FUNCTION_IDS: bigint[] = [16000n, 17000n, 18000n, 23000n];
  const FIXTURE_FUNCTION_IDS: bigint[] = [3000n, 4000n, 5000n, 6000n, 7000n];

  onMount(() => {
    listProposals();
  });

  async function listProposals(beforeProposal?: ProposalId) {
    const agent: any = await ActorFactory.getGovernanceAgent();
    if (process.env.DFX_NETWORK !== "ic") {
      await agent.fetchRootKey();
    }

    const principal: Principal = Principal.fromText(process.env.CANISTER_ID_SNS_GOVERNANCE ?? "");
    const { listProposals: governanceListProposals } = SnsGovernanceCanister.create({
      agent,
      canisterId: principal
    });

    switch(filterStatus){
      case -1:
        selectedProposalStatus = [0,1,2,3,4,5];
        break;
      case 0:
        selectedProposalStatus = [0,1];
        break;
      case 1:
        selectedProposalStatus = [3,4];
        break;
      case 2:
        selectedProposalStatus = [2];
        break;
      case 3:
        selectedProposalStatus = [5];
        break;
    }

    const params: SnsListProposalsParams = {
      includeStatus: selectedProposalStatus,
      limit: itemsPerPage,
      beforeProposal: beforeProposal,
      excludeType: undefined,
      certified: false
    };

    proposals = await governanceListProposals(params);
    filterProposals();
  }

  function filterProposals() {
    if (!proposals || !proposals.proposals) return;

    if (filterType === -1) {
      filteredProposals = proposals.proposals;
    } else {
      filteredProposals = proposals.proposals.filter(proposal => {
        const action = proposal.proposal[0]?.action?.[0];
        let functionId: bigint | undefined;

        if (isExecuteGenericNervousSystemFunction(action)) {
          functionId = action.ExecuteGenericNervousSystemFunction.function_id;
        }

        if (filterType === 0) {
          return functionId !== undefined && PLAYER_FUNCTION_IDS.includes(functionId);
        } else if (filterType === 1) {
          return functionId !== undefined && CLUB_FUNCTION_IDS.includes(functionId);
        } else if (filterType === 2) {
          return functionId !== undefined && FIXTURE_FUNCTION_IDS.includes(functionId);
        } else if (filterType === 3) {
          return functionId === undefined || (!PLAYER_FUNCTION_IDS.includes(functionId) && !CLUB_FUNCTION_IDS.includes(functionId) && !FIXTURE_FUNCTION_IDS.includes(functionId));
        }
        return true;
      });
    }

    totalPages = Math.ceil(filteredProposals.length / itemsPerPage);
    currentPage = 1;
  }

  function isExecuteGenericNervousSystemFunction(action: any): action is { ExecuteGenericNervousSystemFunction: { function_id: bigint } } {
    return action && action.ExecuteGenericNervousSystemFunction !== undefined;
  }

  function paginate(proposals: ProposalData[], page: number): ProposalData[] {
    const start = (page - 1) * itemsPerPage;
    const end = start + itemsPerPage;
    return proposals.slice(start, end);
  }

  function viewProposal(data: ProposalData){
    selectedProposal = data;
    showProposal = true;
  };

  function closeModal() {
    showProposal = false;
  }

  function setActiveTab(tab: string): void {
    if (tab === "proposals") {
      $loadingProposals = true;
    }
    activeTab = tab;
  }


  $: {
    if (
      filterType >= -1 || filterStatus >= -1
    ) {
      listProposals();
      currentPage = 1;
    }
  }
</script>

{#if showProposal}
  <ProposalDetail visible={showProposal} {closeModal} proposal={selectedProposal} />
{/if}

<Layout>
  <div class="bg-panel rounded-md">
    <div class="flex flex-row md:justify-between md:items-center px-4 bg-brand-light-gray">
      <div class="flex"><button
        on:click={() => setActiveTab("proposals")}
        class="flex items-center h-full nav-underline active hover:text-gray-400 py-2 font-black"
      >
        <span class="flex items-center h-full my-1">Proposals</span>
        </button>
      </div>
    </div>
    <div class="flex flex-col space-y-4 lg:space-y-0 lg:flex-row lg:items-center lg:justify-between px-4 mt-4">
      <!-- Filters Section -->
      <div class="flex flex-col space-y-4 lg:space-y-0 lg:flex-row lg:space-x-8 lg:w-auto">
        <!-- Filter by Status -->
        <div class="flex items-center space-x-2">
          <label for="filterStatus" class="whitespace-nowrap min-w-[150px] lg:min-w-unset">Filter Proposals:</label>
          <select
              id="filterStatus"
              class="block w-full lg:w-40 py-2 text-white fpl-dropdown"
              bind:value={filterStatus}
          >
              <option value={-1}>All</option>
              <option value={0}>Open</option>
              <option value={1}>Accepted</option>
              <option value={2}>Rejected</option>
              <option value={3}>Failed</option>
          </select>
        </div>
        
        <div class="flex items-center space-x-2">
          <label for="filterType" class="whitespace-nowrap min-w-[150px] lg:min-w-unset">Proposals Status:</label>
          <select
              id="filterType"
              class="block w-full lg:w-40 py-2 text-white fpl-dropdown"
              bind:value={filterType}
          >
              <option value={-1}>All</option>
              <option value={0}>Player</option>
              <option value={1}>Club</option>
              <option value={2}>Fixture</option>
              <option value={3}>General</option>
          </select>
        </div>
      </div>

      <div class="w-full lg:w-auto">
        <button class="fpl-purple-btn text-white py-2 px-4 rounded w-full lg:w-auto">New Proposal</button>
      </div>
    </div>
    
    



    <div class="w-full">
      {#if activeTab === "proposals"}
        <div class="grid grid-cols-1 gap-6 mt-2 lg:grid-cols-2 lg:grid-cols-3 mx-4 mb-4 p-4">
          {#if filteredProposals.length > 0}
            {#each paginate(filteredProposals, currentPage) as proposal}
              <div class="border border-gray-700 rounded-lg p-4 bg-light-gray flex flex-col">
                <div class="font-bold truncate">Proposal {proposal.id[0]?.id}</div>
                <div class="truncate my-2 text-lg">{proposal.proposal[0]?.title}</div>
                <div class="truncate text-sm">Summary: {proposal.proposal[0]?.summary}</div>
                <button on:click={() => viewProposal(proposal)} class="p-2 fpl-button rounded-md mt-4">View</button>
              </div>
            {/each}
          {/if}
        </div>
      {/if}
    </div>
  </div>
</Layout>
