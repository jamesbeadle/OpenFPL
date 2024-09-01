<script lang="ts">
  import { onMount } from "svelte";
  
  import { Principal } from "@dfinity/principal";
  import { SnsGovernanceCanister, SnsVote, type SnsListProposalsParams } from "@dfinity/sns";
  import type { ExecuteGenericNervousSystemFunction } from "@dfinity/sns/dist/candid/sns_governance_test";
  import type { ListProposalsResponse, Neuron, ProposalData, ProposalId } from "@dfinity/sns/dist/candid/sns_governance";
  
  import { authStore } from "$lib/stores/auth.store";
  import { toastsError } from "$lib/stores/toasts-store";
  import { formatUnixDateToSmallReadable } from "$lib/utils/helpers";
  import { ActorFactory } from "../../utils/ActorFactory";
  
  import Layout from "../Layout.svelte";
  import ProposalDetail from "$lib/components/governance/proposal-detail.svelte";
  import TickIcon from "$lib/icons/TickIcon.svelte";
  import LocalSpinner from "$lib/components/local-spinner.svelte";
    import CrossIcon from "$lib/icons/CrossIcon.svelte";
   
  let isLoading = true;
  let initialLoadCompleted = false;
  let votesSet = false;
  let activeTab: string = "proposals";
  let showProposal = false;

  let selectedProposalStatus = [0,1,2,3,4,5];
  let proposals: ListProposalsResponse = { proposals: [], include_ballots_by_caller: [] };
  let filteredProposals: ProposalData[] = [];

  let currentPage: number = 1;
  let itemsPerPage: bigint = 10n;
  let totalPages: number = 1;
  let latestProposalId: bigint = 0n;
  
  let selectedProposal: ProposalData;
  
  let filterType = -1;
  let filterStatus = -1;
  let userNeurons: Neuron[] = [];

  const PLAYER_FUNCTION_IDS: bigint[] = [1000n, 2000n, 8000n, 9000n, 10000n, 12000n, 13000n, 14000n, 15000n, 22000n];
  const CLUB_FUNCTION_IDS: bigint[] = [16000n, 17000n, 18000n, 23000n];
  const FIXTURE_FUNCTION_IDS: bigint[] = [3000n, 4000n, 5000n, 6000n, 7000n];


  onMount(async () => {
    try {
      await authStore.sync();
      await getUserNeurons();
      await listProposals();
      await setProposalTotals();
    } catch (error) {
      toastsError({
        msg: { text: "Error fetching proposals." },
        err: error,
      });
      console.error("Error fetching proposals:", error);
    } finally {
      isLoading = false;
      await setProposalVotes();
      votesSet = true;
    }
  });

  async function getUserNeurons(){

    const agent: any = await ActorFactory.getGovernanceAgent();
    if (process.env.DFX_NETWORK !== "ic") {
      await agent.fetchRootKey();
    }

    const snsGovernanceCanisterPrincipal: Principal = Principal.fromText(process.env.CANISTER_ID_SNS_GOVERNANCE ?? "");
    const { listNeurons } = SnsGovernanceCanister.create({
      agent,
      canisterId: snsGovernanceCanisterPrincipal
    });
    
    let principal = $authStore?.identity?.getPrincipal().toText() ?? "";
    if (principal == "") {
      return;
    }
    userNeurons = await listNeurons({ certified: false, principal: Principal.fromText(principal) });
  };

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

    const params: SnsListProposalsParams = {
        includeStatus: selectedProposalStatus,
        limit: Number(itemsPerPage),
        beforeProposal: beforeProposal,
        excludeType: undefined,
        certified: false
    };

    proposals = await governanceListProposals(params);

    filterProposals();
  }




  async function setProposalTotals(){
    const agent: any = await ActorFactory.getGovernanceAgent();
    if (process.env.DFX_NETWORK !== "ic") {
      await agent.fetchRootKey();
    }

    const principal: Principal = Principal.fromText(process.env.CANISTER_ID_SNS_GOVERNANCE ?? "");
    const { listProposals: governanceListProposals } = SnsGovernanceCanister.create({
      agent,
      canisterId: principal
    });

    const params: SnsListProposalsParams = {
      includeStatus: [0,1,2,3,4,5],
      limit: 1,
      beforeProposal: undefined,
      excludeType: undefined,
      certified: false
    };

    const latestProposals = await governanceListProposals(params);

    if (latestProposals.proposals.length > 0) {
      const latestProposal = latestProposals.proposals[0];
      latestProposalId = latestProposal.id[0]?.id ?? 0n;

      totalPages = Math.ceil(Number(latestProposalId) / Number(itemsPerPage));
    }
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
  }


  function isExecuteGenericNervousSystemFunction(action: any): action is { ExecuteGenericNervousSystemFunction: { function_id: bigint } } {
    return action && action.ExecuteGenericNervousSystemFunction !== undefined;
  }

  function viewProposal(data: ProposalData){
    selectedProposal = data;
    showProposal = true;
  };

  function closeModal() {
    showProposal = false;
  }

  async function setActiveTab(tab: string) : Promise<void> {
    if (tab === "proposals") {
      let proposalId: ProposalId = {id: latestProposalId};
      await listProposals(proposalId);
    }
    activeTab = tab;
  }

  function getProposalType(proposalData: ProposalData) : string {
    let action = proposalData.proposal[0]?.action[0];
    
    if(action == null){
      return "Unknown"
    }
    if('ExecuteGenericNervousSystemFunction' in action){
      const executeAction = action as { ExecuteGenericNervousSystemFunction: ExecuteGenericNervousSystemFunction };

      switch (executeAction.ExecuteGenericNervousSystemFunction.function_id) {
        case 1000n:
        case 2000n:
          return 'Revalue Player';
        case 3000n:
          return 'Fixture Data';
        case 4000n:
          return 'Fixture Setup';
        case 5000n:
          return 'Move Fixture';
        case 6000n:
          return 'Postpone Fixture';
        case 7000n:
          return 'Reschedule Fixture';
        case 8000n:
          return 'Transfer Player';
        case 19000n:
          return 'Create Neuron';
        case 20000n:
          return 'Manager Neuron';
        case 21000n:
          return 'Add Token';
        case 22000n:
          return 'Create Player';
        case 23000n:
          return 'Promote Club';
      }
    }
    return "General"
  }

  $: {
    if (
      (filterType >= -1 || filterStatus >= -1) && !isLoading 
    ) {
      if(initialLoadCompleted){
        listProposals({id: latestProposalId});
        currentPage = 1;
        initialLoadCompleted = true;
      }
    }
  }
  

  function calculatePercentages(proposal: ProposalData) {
    const totalVotes = Number(proposal.latest_tally[0]?.total) ?? 0;
    const yesVotes = Number(proposal.latest_tally[0]?.yes) ?? 0;
    const noVotes = Number(proposal.latest_tally[0]?.no) ?? 0;
    const unvotedVotes = totalVotes - (yesVotes + noVotes);

    const yesPercentage = (yesVotes / totalVotes) * 100;
    const noPercentage = (noVotes / totalVotes) * 100;
    const unvotedPercentage = 100 - yesPercentage - noPercentage;

    return {
      yesPercentage: yesPercentage.toFixed(2),
      noPercentage: noPercentage.toFixed(2),
      unvotedPercentage: unvotedPercentage.toFixed(2)
    };
  }

  async function adoptProposal(proposalId: ProposalId | undefined){
    
    if(!proposalId){
      return;
    }

    const agent: any = await ActorFactory.getGovernanceAgent($authStore?.identity);
    if (process.env.DFX_NETWORK !== "ic") {
      await agent.fetchRootKey();
    }

    const snsCanisterPrincipal: Principal = Principal.fromText(process.env.CANISTER_ID_SNS_GOVERNANCE ?? "");
    const { registerVote } = SnsGovernanceCanister.create({
      agent,
      canisterId: snsCanisterPrincipal
    });
    
    let principal = $authStore?.identity?.getPrincipal().toText() ?? "";
    if (principal == "") {
      return;
    }

    userNeurons.forEach((neuron) => {
      const neuronId = neuron.id[0];
      if (!neuronId) {
        return;
      }
      registerVote({
        proposalId: proposalId,
        vote: SnsVote.Yes,
        neuronId: neuronId,
      });
    });


  };

  function rejectProposal(proposalId: ProposalId | undefined){
    if(!proposalId){
      return;
    }
  }

  async function setProposalVotes() {
    
    const agent: any = await ActorFactory.getGovernanceAgent();
    if (process.env.DFX_NETWORK !== "ic") {
      await agent.fetchRootKey();
    }

    const snsGovernanceCanisterPrincipal: Principal = Principal.fromText(process.env.CANISTER_ID_SNS_GOVERNANCE ?? "");
    const { getProposal } = SnsGovernanceCanister.create({
      agent,
      canisterId: snsGovernanceCanisterPrincipal
    });
    
    let principal = $authStore?.identity?.getPrincipal().toText() ?? "";
    if (principal == "") {
      return;
    }
    
    for (const proposal of proposals.proposals) {
      let proposalId = proposal.id[0];
      
      if (proposalId && (proposal.executed_timestamp_seconds == 0n && proposal.failed_timestamp_seconds == 0n && proposal.decided_timestamp_seconds == 0n  )) {

        let proposalData = await getProposal({ proposalId: proposalId });
        
        for (let neuron of userNeurons) {
          let neuronId = neuron.id[0]?.id;
          if(neuronId instanceof Uint8Array){
            let neuronPrincipal = Principal.fromUint8Array(neuronId);

            const ballotEntry = proposalData.ballots.find(([id, _]) => id === neuronPrincipal.toHex().toLowerCase());

            if (ballotEntry) {
              const [_, ballot] = ballotEntry;
              const vote = ballot.vote;
              
              if (vote === 1) {
                const adoptButton = document.querySelector(`#adopt-button-${proposalId.id} img`);
                if (adoptButton) {
                  (adoptButton as HTMLImageElement).src = "adopt_filled.png";
                }
                const rejectButton = document.querySelector(`#reject-button-${proposalId.id}`);
                if(rejectButton){
                  (rejectButton as HTMLImageElement).hidden = true;
                }
                disableThumbButtons(proposalId);
                
              } else if (vote === 2) {
                const rejectButton = document.querySelector(`#reject-button-${proposalId.id} img`);
                if (rejectButton) {
                  (rejectButton as HTMLImageElement).src = "reject_filled.png";
                }
                const adoptButton = document.querySelector(`#adopt-button-${proposalId.id}`);
                if(adoptButton){
                  (adoptButton as HTMLImageElement).hidden = true;
                }
                disableThumbButtons(proposalId);
              }
            }
          }
        }
      }
    }
  }

  function disableThumbButtons(proposalId: ProposalId){
    const adoptButtonParent = document.querySelector(`#adopt-button-${proposalId.id}`);
    if (adoptButtonParent) {
      (adoptButtonParent as HTMLButtonElement).disabled = true;
    }

    const rejectButtonParent = document.querySelector(`#reject-button-${proposalId.id}`);
    if (rejectButtonParent) {
      (rejectButtonParent as HTMLButtonElement).disabled = true;
    }
  }

  async function changePage(delta: number) {
    isLoading = true;
    const newPage = Math.max(1, Math.min(totalPages, currentPage - delta)); 
    if (newPage === currentPage) return; 

    currentPage = newPage;

    let beforeProposal: ProposalId | undefined;

    if (delta < 0) { 
        if (proposals.proposals.length > 0) {
            const lastProposalOnCurrentPage = proposals.proposals[proposals.proposals.length - 1];
            beforeProposal = { id: lastProposalOnCurrentPage.id[0]?.id ?? 0n };
        }
    } else if (delta > 0) { 
        if (proposals.proposals.length > 0) {

          const propopaslPlusPageSizeId = (proposals.proposals[0].id[0]?.id ?? 0n) + BigInt(itemsPerPage) + 1n;
          beforeProposal = { id: propopaslPlusPageSizeId };
        }
    }
    
    await listProposals(beforeProposal);
    isLoading = false;
}






</script>

{#if showProposal}
  <ProposalDetail visible={showProposal} {closeModal} proposal={selectedProposal} />
{/if}

<Layout>
  <div class="bg-panel rounded-md">

    {#if isLoading}
      <LocalSpinner />
    {:else}

      <div class="flex flex-col lg:flex-row lg:items-center lg:justify-between px-4 my-4 text-sm">
        <div class="flex"><button
          on:click={() => setActiveTab("proposals")}
          class="flex items-center h-full nav-underline active hover:text-gray-400 py-2 font-black"
        >
          <span class="flex items-center h-full my-1">Proposals</span>
          </button>
        </div>
      </div>
      <div class="flex flex-col space-y-4 lg:space-y-0 lg:flex-row lg:items-center lg:justify-between px-4 my-4 text-sm">
        <div class="flex flex-col space-y-4 lg:space-y-0 lg:flex-row lg:space-x-8 lg:w-auto">
          <div class="flex items-center space-x-2">
            <label for="filterStatus" class="whitespace-nowrap min-w-[150px] lg:min-w-unset">Filter Status:</label>
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
          
          <div class="hidden lg:flex vertical-divider-thin" />
          
          <div class="flex items-center space-x-2">
            <label for="filterType" class="whitespace-nowrap min-w-[150px] lg:min-w-unset">Filter Type:</label>
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
          <a class="w-full lg:w-auto" href="/add-proposal">
            <button class="fpl-purple-btn text-white py-2 px-4 rounded-lg text-sm w-full lg:w-auto">New Proposal</button>
          </a>
        </div>
      </div>

      <div class="w-full text-sm">
        {#if activeTab === "proposals"}
          <div class="hidden lg:flex flex-row py-4 gray-border bg-brand-light-gray text-xs">
            <div class="w-full lg:w-3/5 flex flex-col lg:flex-row pl-4">
              <div class="w-1/12">
                <p>ID</p>
              </div>
              <div class="w-3/12">
                <p>Proposal Type</p>
              </div>
              <div class="w-8/12">
                <p>Details</p>  
              </div>
            </div>
            <div class="w-full lg:w-2/5 flex flex-col lg:flex-row items-end pr-4"> 
              <p class="ml-auto offset-alignment"></p>
            </div>
          
          </div>
          <div class="flex lg:hidden flex-row py-4 gray-border bg-brand-light-gray text-xs pl-4">
            <p>Proposals:</p>
          </div>
          {#if filteredProposals.length > 0}
            {#each filteredProposals as proposal} 
              {@const { yesPercentage, noPercentage, unvotedPercentage } = calculatePercentages(proposal)}
              <div class="flex flex-col lg:flex-row py-4 gray-border text-xs">
                <div class="w-full lg:w-3/5 flex flex-col lg:flex-row px-4 lg:items-center ">
                  <div class="w-full lg:w-1/12 flex flex-col">
                    <p class="hidden lg:flex">{proposal.id[0]?.id}</p>
                    <p class="lg:hidden text-base">Proposal {proposal.id[0]?.id}: {proposal.proposal[0]?.title}</p>
                  </div>
                  <div class="w-full lg:w-3/12 my-2 lg:my-0">
                    <p class="hidden lg:flex">{getProposalType(proposal)}</p>
                    <p class="lg:hidden">Proposal Type: {getProposalType(proposal)}</p>
                  </div>
                  <div class="w-full lg:w-8/12">
                    <p class="hidden lg:flex text-sm mb-1">{proposal.proposal[0]?.title}</p>  
                    <p class="lg:hidden text-sm mb-1">{proposal.proposal[0]?.summary}</p>  
                  </div>
                </div>
                <div class="w-full lg:w-2/5 flex flex-row items-center lg:justify-end px-4 lg:pr-4 mt-2 lg:mt-0"> 
                  {#if proposal.decided_timestamp_seconds == 0n && votesSet}
                      <p class="hidden xl:flex">Adopt</p>
                      <button id={`adopt-button-${proposal.id[0]?.id}`} on:click={() => adoptProposal(proposal.id[0])}>
                        <img src="adopt.png" alt="adopt" class="w-6 mx-2" />
                      </button>
                      <p class="text-brand-green">{((Number(proposal.latest_tally[0]?.yes) ?? 0) / (Number(proposal.latest_tally[0]?.total) ?? 0) * 100).toFixed(2)}%</p>
                      
                      <span 
                      class="mx-2 rounded-3xl" 
                      style="
                        width: 150px; 
                        height: 16px; 
                        background: linear-gradient(
                          to right, 
                          #2CE3A6 0%, 
                          #2CE3A6 {yesPercentage}%, 
                          #A0AEC0 {yesPercentage}%, 
                          #A0AEC0 calc({yesPercentage}% + {unvotedPercentage}%), 
                          #F56565 calc({yesPercentage}% + {unvotedPercentage}%), 
                          #F56565 100%
                        );
                      "
                    ></span>
                    <p class="hidden xl:flex pr-2">Reject</p>
                      <button id={`reject-button-${proposal.id[0]?.id}`} on:click={() => rejectProposal(proposal.id[0])}>
                        <img src="reject.png" alt="reject" class="w-6 mr-2" />
                      </button>
                      <p class="text-brand-red">{((Number(proposal.latest_tally[0]?.no) ?? 0) / (Number(proposal.latest_tally[0]?.total) ?? 0) * 100).toFixed(2)}%</p>
                  {/if}
                  {#if proposal.decided_timestamp_seconds > 0 && proposal.executed_timestamp_seconds > 0 && votesSet}
                    <p class="lg:min-w-[100px] lg:text-right">Adopted</p>
                    <TickIcon fill="#2CE3A6" className="w-4 mx-2" />
                    <p class="lg:min-w-[100px]">{ formatUnixDateToSmallReadable(proposal.executed_timestamp_seconds * 1_000_000_000n) }</p>
                  {/if}
                  {#if proposal.decided_timestamp_seconds > 0 && proposal.failed_timestamp_seconds == 0n && proposal.executed_timestamp_seconds == 0n }
                    <p class="lg:min-w-[100px] lg:text-right">Rejected</p>
                    <CrossIcon fill="#CF5D43" className="w-3 mx-2" />
                    <p class="lg:min-w-[100px]">{ formatUnixDateToSmallReadable(proposal.decided_timestamp_seconds * 1_000_000_000n) }</p>
                  {/if}
                  {#if proposal.failed_timestamp_seconds > 0}
                    <p class="lg:min-w-[100px] lg:text-right">Failed</p>
                    <CrossIcon fill="#CF5D43" className="w-3 mx-2" />
                    <p class="lg:min-w-[100px]">{ formatUnixDateToSmallReadable(proposal.failed_timestamp_seconds * 1_000_000_000n) }</p>
                  {/if}       
                </div>  
              </div>
            {/each}
          {/if}

          <div class="flex justify-center items-center mt-4 mb-4">
            <button
              on:click={() => changePage(1)}
              disabled={currentPage === 1}
              class={`fpl-button disabled:bg-gray-400 disabled:text-gray-700 disabled:cursor-not-allowed min-w-[100px] default-button`}
          >
              Previous
          </button>

          <span class="px-4">Page {currentPage}</span>

          <button
              on:click={() => changePage(-1)}
              disabled={currentPage >= totalPages}
              class={`fpl-button disabled:bg-gray-400 disabled:text-gray-700 disabled:cursor-not-allowed min-w-[100px] default-button`}
          >
              Next
          </button>

          </div>
        
        {/if}
      </div>
    {/if}
    
  </div>
</Layout>