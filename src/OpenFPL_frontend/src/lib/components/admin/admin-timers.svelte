<script lang="ts">
    import { onMount } from "svelte";
    import { adminStore } from "$lib/stores/admin-store";
    import { toastsError } from "$lib/stores/toasts-store";
    import { authStore } from "$lib/stores/auth.store";
    import { Spinner } from "@dfinity/gix-components";
    import type { AdminTimerList } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  
    let selectedTimerType = "gameweekBeginExpired";
    let timerList: AdminTimerList | null = null;
    let currentPage = 1;
    let itemsPerPage = 25;
    let totalPages: number = 0;
    let isLoading = true;
  
    onMount(async () => {
      try {
        authStore.sync();
        await loadTimerInfo();
      } catch (error) {
        toastsError({
          msg: { text: "Error fetching timer info." },
          err: error,
        });
        console.error("Error fetching timer info:", error);
      } finally {
        isLoading = false;
      }
    });
  
    async function changePage(delta: number) {
      currentPage = Math.max(1, Math.min(totalPages, currentPage + delta));
      await loadTimerInfo();
    }
  
    async function loadTimerInfo() {
      isLoading = true;
      timerList = await adminStore.getTimers(selectedTimerType, itemsPerPage, currentPage);
      isLoading = false;
    }
  
    $: if (selectedTimerType) {
      currentPage = 1;
      loadTimerInfo();
    }
  </script>
  
  {#if isLoading}
    <Spinner />
  {:else}
    <div class="m-4">
      <p class="text-xl">OpenFPL Timers</p>
  
      <p>Next Cycles Check:</p>

      {timerList.cyclesCheck}

      <p>Next Cycles Wallet Check:</p>

      {timerList.cyclesWalletCheck}

      <div class="flex mt-4">
        <div class="flex items-center">
          <p>Type:</p>
          <select
            class="px-2 fpl-dropdown text-center mx-0 md:mx-2 min-w-[100px]"
            bind:value={selectedTimerType}
          >
            <option value={"gameweekBeginExpired"}>Gameweek Begin</option>
            <option value={"gameKickOffExpired"}>Game Kick Off</option>
            <option value={"gameCompletedExpired"}>Game End</option>
            <option value={"loanExpired"}>Loan Expired</option>
            <option value={"injuryExpired"}>Injury Expired</option>
            <option value={"transferWindowStart"}>Tansfer Window Start</option>
            <option value={"transferWindowEnd"}>Transfer Window End</option>
          </select>
        </div>
      </div>
  
      <div class="flex">
        <div class="w-1/4">
          <p>Timer Id</p>
        </div>
        <div class="w-1/4">
          <p>Trigger Timer</p>
        </div>
        <div class="w-1/4">
          <p>Callback Function</p>
        </div>
        <div class="w-1/4">
          <p>Options</p>
        </div>
      </div>
  
      {#if timerList}
        {#each timerList.timers as timer}
          <div class="flex">
            <div class="w-1/4">
              <p>{timer.id}</p>
            </div>
            <div class="w-1/4">
              <p>{timer.triggerTime}</p>
            </div>
            <div class="w-1/4">
              <p>{timer.callbackName}</p>
            </div>
            <div class="w-1/4">
              <p>...</p>
            </div>
          </div>
        {/each}
        {#if timerList.timers.length == 0}
          <p>No Timers Found</p>
        {/if}
      {/if}
  
      <div class="flex justify-center items-center mt-4 mb-4">
        <button
          on:click={() => changePage(-1)}
          disabled={currentPage === 1}
          class={`${currentPage === 1 ? "bg-gray-500" : "fpl-button"}
          disabled:bg-gray-400 disabled:text-gray-700 disabled:cursor-not-allowed min-w-[100px] default-button`}
        >
          Previous
        </button>
  
        <span class="px-4">Page {currentPage}</span>
  
        <button
          on:click={() => changePage(1)}
          disabled={currentPage >= totalPages}
          class={`${currentPage >= totalPages ? "bg-gray-500" : "fpl-button"} 
            disabled:bg-gray-400 disabled:text-gray-700 disabled:cursor-not-allowed min-w-[100px] default-button`}
        >
          Next
        </button>
      </div>
    </div>
  {/if}
  