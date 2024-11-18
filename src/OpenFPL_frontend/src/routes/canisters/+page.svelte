<script lang="ts">
    import { onMount } from "svelte";
    import { toastsError } from "$lib/stores/toasts-store";
    import Layout from "../Layout.svelte";
    import { storeManager } from "$lib/managers/store-manager";
    import WidgetSpinner from "$lib/components/widget-spinner.svelte";
    import type { CanisterDTO, CanisterType, GetCanistersDTO } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    import { canisterStore } from "$lib/stores/canister-store";
    import { formatCycles } from "$lib/utils/helpers";
  
    let selectedCanisterType = 0;
    let loadingCanisters = true;
    let canisters: CanisterDTO[] = [];

    onMount(async () => {
      try {
        await storeManager.syncStores();
        let dto: GetCanistersDTO = {
          canisterType: { Dapp : null}
        };
        canisters = await canisterStore.getCanisters(dto)
      } catch (error) {
        toastsError({
          msg: { text: "Error loading canisters." },
          err: error,
        });
        console.error("Error fetching league table:", error);
      } finally {
        loadingCanisters = false;
      }
    });

    $: if(selectedCanisterType >= 0){
      loadCanisters();
    }

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
      canisters = await canisterStore.getCanisters(dto);
      loadingCanisters = false;
    }
  </script>
  
  <Layout>
    <div class="page-header-wrapper flex w-full">
      <div class="content-panel w-full">
        <div class="w-full grid grid-cols-1 md:grid-cols-4 gap-4 mt-4">
          <p class="col-span-1 md:col-span-4 text-center w-full mb-4">
            OpenFPL Managed Canisters
          </p>
          <div class="flex flex-col">
            <p class="w-full text-left p-2">Select Canister Type</p>
            <select
              class="p-2 fpl-dropdown text-left mx-0 md:mx-2 min-w-[125px]"
              bind:value={selectedCanisterType}
              >
                <option value={0}>App</option>
                <option value={1}>Manager</option>
                <option value={2}>Leaderboard</option>
                <option value={3}>SNS</option>
              </select>
          </div>

          {#if loadingCanisters}
            <WidgetSpinner />
          {:else}
            {#each canisters as canister}
              <div class="row">
                <div class="col-1/4">
                  <p>Canister Id: {canister.canisterId}</p>
                </div>
                <div class="col-1/4">
                  <p>Cycles Balance: {formatCycles(canister.cycles)}</p>
                </div>
                <div class="col-1/4">
                  <p>Compute Allocation: {canister.computeAllocation}</p>
                </div>
                <div class="col-1/4">
                  <p>Total topups: {canister.topups.length}</p>
                </div>
              </div>
            {/each}
          {/if}

        </div>
      </div>
    </div>
  </Layout>