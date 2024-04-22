<script lang="ts">
  import { writable } from "svelte/store";
  import type { CreatePrivateLeagueDTO, EntryRequirement } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

  let selectedEntryType = 0;
  let entryFee = 0;
  let adminFee = 0;
  let creatorPrizePool = 0;
  let accountBalance = 1000; // This would typically come from a backend or store.

  export let privateLeague = writable<CreatePrivateLeagueDTO | null>(null);
</script>

<div class="container mx-auto p-4">
  <p class="text-xl mb-2">Entry Requirements</p>

  <div class="mb-4">
      <label class="block text-sm font-bold mb-2" for="entry-type">
          Entry Type:
      </label>
      <select
          id="entry-type"
          class="p-2 fpl-dropdown my-4 min-w-[100px]"
          bind:value={selectedEntryType}
      >
          <option value={0}>Free Entry</option>
          <option value={1}>Paid Entry</option>
          <option value={2}>Invite Entry</option>
          <option value={3}>Paid Invite Entry</option>
      </select>
  </div>


  {#if selectedEntryType === 1 || selectedEntryType === 3}
      <div class="mb-4">
          <label class="block text-sm font-bold mb-2" for="entry-fee">
              Entry Fee:
          </label>
          <input type="number" step="0.0000001" min="2" max="1000" bind:value={entryFee} class="shadow appearance-none border rounded w-full py-2 px-3 leading-tight focus:outline-none focus:shadow-outline" id="entry-fee" />
      </div>

      <div class="mb-4">
          <label for="admin-fee-range" class="block text-sm font-bold mb-2">Admin Fee (%)</label>
          <p class="text-xs my-1">A fee paid to you for administering the private league (up to 5%).</p>
          <input id="admin-fee-range" min="0" max="5" step="1" type="range" bind:value={adminFee} class="w-full h-2 bg-gray-200 rounded-lg appearance-none cursor-pointer dark:bg-gray-700">
          <p class="my-1">{adminFee}%</p>
      </div>
  {/if}

  <div class="mb-4">
      <label class="block text-sm font-bold mb-2" for="creator-prize-pool">
          Creator Prize Pool:
      </label>
      <input type="number" step="1" min="0" class="shadow appearance-none border rounded w-full py-2 px-3 leading-tight focus:outline-none focus:shadow-outline" id="creator-prize-pool" bind:value={creatorPrizePool} />
  </div>

  <div class="mb-4">
      <label class="block text-sm font-bold mb-2">
          Your Account Balance:
      </label>
      <p>{accountBalance} ICP</p>
  </div>
</div>
