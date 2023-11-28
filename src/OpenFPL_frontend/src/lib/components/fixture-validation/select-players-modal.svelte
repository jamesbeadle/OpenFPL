<script lang="ts">
  import { get, writable } from "svelte/store";
  import type { Team } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import type { PlayerDTO } from "../../../../../declarations/player_canister/player_canister.did";

  export let teamPlayers = writable<PlayerDTO[]>([]);
  export let selectedTeam: Team;
  export let selectedPlayers = writable<PlayerDTO[]>([]);
  export let show = false;

  function handlePlayerSelection(event: Event, player: PlayerDTO) {
    const input = event.target as HTMLInputElement;
    let allSelectedPlayers = get(selectedPlayers);
    let allTeamPlayers = get(teamPlayers);
    if (input.checked) {
      const playerToAdd = allTeamPlayers.find((x) => x.id === player.id);
      if (playerToAdd && !allSelectedPlayers.some((x) => x.id === player.id)) {
        allSelectedPlayers = [...allSelectedPlayers, playerToAdd];
      }
    } else {
      allSelectedPlayers = allSelectedPlayers.filter((x) => x.id !== player.id);
    }
  }
  function closeModal() {
    show = false;
  }
</script>

{#if show}
  <div
    class="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full"
  >
    <div
      class="relative top-20 mx-auto p-5 border w-3/4 shadow-lg rounded-md bg-white"
    >
      <div class="flex justify-between items-center">
        <h4 class="text-lg font-bold">
          Select {selectedTeam.friendlyName} Players
        </h4>
        <button class="text-black" on:click={closeModal}>✕</button>
      </div>
      <div class="my-5 flex flex-wrap">
        {#each $teamPlayers as player}
          {@const selected = get(selectedPlayers).some(
            (p) => p.id === player.id
          )}
          <div class="flex-1 sm:flex-basis-1/2">
            <label class="block">
              <input
                type="checkbox"
                checked={selected}
                on:change={(e) => {
                  handlePlayerSelection(e, player);
                }}
              />
              {`${
                player.firstName.length > 0
                  ? player.firstName.charAt(0) + "."
                  : ""
              } ${player.lastName}`}
            </label>
          </div>
        {/each}
      </div>
      <div class="flex justify-end gap-3">
        <button
          class="px-4 py-2 border rounded text-black"
          on:click={closeModal}>Cancel</button
        >
        <button
          class="px-4 py-2 bg-blue-500 text-white rounded"
          on:click={closeModal}>Select Players</button
        >
      </div>
    </div>
  </div>
{/if}
