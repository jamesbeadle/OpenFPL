<script lang="ts">
    import { onMount } from "svelte";
    import Layout from "../Layout.svelte";
    import { storeManager } from "$lib/managers/store-manager";
    import WidgetSpinner from "$lib/components/shared/widget-spinner.svelte";
    import type { CanisterDTO, CanisterType, GetCanistersDTO } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    import { canisterStore } from "$lib/stores/canister-store";
    import { formatCycles } from "$lib/utils/helpers";
    import PageHeader from "$lib/components/shared/panels/page-header.svelte";
    import ContentPanel from "$lib/components/shared/panels/content-panel.svelte";
  
    let selectedCanisterType = 0;
    let loadingCanisters = true;
    let canisters: CanisterDTO[] = [];

    let dropdownOptions: {id: number; name: string}[] = [
      { id:0, name:"App" },
      { id:1, name:"Manager" },
      { id:2, name:"Leaderboard" },
      { id:3, name:"SNS" }
    ];

    onMount(async () => {
        await storeManager.syncStores();
        await loadCanisters();
    });

    $: if(selectedCanisterType >= 0){ loadCanisters(); }

    async function loadCanisters(){
      loadingCanisters = true;
      let filterCanisterType: CanisterType = { Dapp : null};
      switch(selectedCanisterType){
        case (0):
          filterCanisterType = { Dapp : null }
        break;
        case (1):
          filterCanisterType = { Manager : null }
        break;
        case (2):
          filterCanisterType = { Leaderboard : null }
        break;
        case (3):
          filterCanisterType = { SNS : null }
        break;
      }

      let dto: GetCanistersDTO = {
        canisterType: filterCanisterType
      };
      
      let canistersResult = await canisterStore.getCanisters(dto);
      canisters = canistersResult ? canistersResult : [];
      loadingCanisters = false;
    }
  </script>
  
  <Layout>
    <PageHeader>
      <ContentPanel>
        <div class="w-full mt-4 px-2">
          <p class="text-center w-full mb-6 text-xl font-semibold">
            OpenFPL Managed Canisters
          </p>
  
          <div class="flex flex-col sm:flex-row items-start sm:items-center gap-2 mb-4">
            <label class="font-medium" for="canisterType">Select Canister Type:</label>
            <select id="canisterType" class="fpl-dropdown" bind:value={selectedCanisterType}>
              {#each dropdownOptions as option}
                <option value={option.id}>option.name</option>
              {/each}
            </select>
          </div>
  
          {#if loadingCanisters}
            <div class="flex justify-center">
              <WidgetSpinner />
            </div>
          {:else}
            <div class="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
              {#each canisters as canister}
                <div class="border border-gray-200 rounded shadow-sm p-4 flex flex-col space-y-2">
                  <p class="font-medium">Canister Id: {canister.canisterId}</p>
                  <p class="font-medium mt-2">Cycles Balance: {formatCycles(canister.cycles)}</p>
                  <p class="font-medium mt-2">Compute Allocation: {canister.computeAllocation}</p>
                  <p class="font-medium mt-2">Total Topups: {canister.topups.length}</p>
                </div>
              {/each}
            </div>
          {/if}
        </div>
      </ContentPanel>
    </PageHeader>
  </Layout>