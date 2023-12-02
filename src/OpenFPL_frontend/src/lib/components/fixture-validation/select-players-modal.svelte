<script lang="ts">
  import { writable } from "svelte/store";
  import type { Team } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import type { PlayerDTO } from "../../../../../declarations/player_canister/player_canister.did";

  export let teamPlayers = writable<PlayerDTO[]>([]);
  export let selectedTeam: Team;
  export let selectedPlayers = writable<PlayerDTO[]>([]);
  export let show = false;

  function handlePlayerSelection(event: Event, player: PlayerDTO) {
    const input = event.target as HTMLInputElement;
    let allSelectedPlayers = $selectedPlayers;
    let allTeamPlayers = $teamPlayers;
    if (input.checked) {
      const playerToAdd = allTeamPlayers.find((x) => x.id === player.id);
      if (playerToAdd && !allSelectedPlayers.some((x) => x.id === player.id)) {
        allSelectedPlayers = [...allSelectedPlayers, playerToAdd];
      }
    } else {
      allSelectedPlayers = allSelectedPlayers.filter((x) => x.id !== player.id);
    }
    $selectedPlayers = allSelectedPlayers;
  }

  export let closeModal: () => void;

  function handleKeydown(event: KeyboardEvent): void {
    if (!(event.target instanceof HTMLInputElement) && event.key === "Escape") {
      closeModal();
    }
  }
</script>

{#if show}
  <div
    class="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full"
    on:click={closeModal}
    on:keydown={closeModal}
  >
    <div
      class="relative top-20 mx-auto p-5 border border-gray-700 mx-8 md:mx-64 shadow-lg rounded-md bg-panel text-white"
      on:click|stopPropagation
      on:keydown={handleKeydown}
    >
      <div class="mt-3 px-4 py-2">
        <h3 class="text-lg leading-6 font-medium mb-2">
          Select {selectedTeam.friendlyName} Players
        </h3>
        <div class="my-5 grid grid-cols-1 sm:grid-cols-2 gap-2">
          {#each $teamPlayers.sort((a, b) => a.position - b.position) as player}
            {@const selected = $selectedPlayers.some((p) => p.id === player.id)}
            <div
              class="flex flex-row justify-between items-center mx-4 border-b"
            >
              <div class="flex w-1/2">
                <span class="text-lg font-medium">
                  {`${
                    player.firstName.length > 0
                      ? player.firstName.charAt(0) + "."
                      : ""
                  } ${player.lastName}`}
                </span>
              </div>
              <div class="flex w-1/4">
                <span class="text-lg font-medium">
                  {#if player.position == 0}GK{/if}
                  {#if player.position == 1}DF{/if}
                  {#if player.position == 2}MF{/if}
                  {#if player.position == 3}FW{/if}
                </span>
              </div>
              <div class="form-checkbox w-1/4">
                <label class="inline-flex items-center">
                  <input
                    type="checkbox"
                    class="form-checkbox h-5 w-5 text-blue-600"
                    checked={selected}
                    on:change={(e) => {
                      handlePlayerSelection(e, player);
                    }}
                  />
                </label>
              </div>
            </div>
          {/each}
        </div>

        <div class="items-center py-3 flex space-x-4">
          <button
            class="px-4 py-2 fpl-cancel-btn text-white text-base font-medium rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300"
            on:click={closeModal}
          >
            Cancel
          </button>
          <button
            class={`px-4 py-2 fpl-purple-btn text-white text-base font-medium rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300`}
            on:click={closeModal}
            >Select
          </button>
        </div>
      </div>
    </div>
  </div>
{/if}
