<script lang="ts">
    import type { Team } from '../../../../declarations/OpenFPL_backend/OpenFPL_backend.did';
    import type { PlayerDTO } from '../../../../declarations/player_canister/player_canister.did';
    export let teamPlayers: PlayerDTO[];
    export let selectedTeam: Team;
    export let selectedPlayers: PlayerDTO[];
    export let show = false;
    export let closeModal: () => void;
    export let confirmSelectPlayers: (players: PlayerDTO[]) => void;

    
    function handlePlayerSelection(event: Event, player: PlayerDTO) {
        const input = event.target as HTMLInputElement;
        if(input.checked){
            const playerToAdd = teamPlayers.find(x => x.id === player.id);
            if (playerToAdd && !selectedPlayers.some(x => x.id === player.id)) {
            selectedPlayers = [...selectedPlayers, playerToAdd];
            }
        }
        else{
            selectedPlayers = selectedPlayers.filter(x => x.id !== player.id);
        }
    }
  
    function handleSelectPlayers() {
      show = false;
      confirmSelectPlayers(selectedPlayers);
    }
  
    function handleCancel() {
        show = false;
        closeModal();
    }

  </script>
  
  
{#if show}
    <div class="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full">
        <div class="relative top-20 mx-auto p-5 border w-3/4 shadow-lg rounded-md bg-white">
            <div class="flex justify-between items-center">
                <h4 class="text-lg font-bold">Select {selectedTeam.friendlyName} Players</h4>
                <button class="text-black" on:click={handleCancel}>✕</button>
            </div>
            <div class="my-5 flex flex-wrap">
                {#each teamPlayers as player}
                    <div class="flex-1 sm:flex-basis-1/2">
                        <label class="block">
                            <input type="checkbox" checked={selectedPlayers.some(p => p.id === player.id)}
                                on:change={(e) => {handlePlayerSelection(e, player);}}/>
                            {`${player.firstName.length > 0 ? player.firstName.charAt(0) + '.' : '' } ${player.lastName}`}
                        </label>
                    </div>
                {/each}
            </div>
            <div class="flex justify-end gap-3">
                <button class="px-4 py-2 border rounded text-black" on:click={handleCancel}>Cancel</button>
                <button class="px-4 py-2 bg-blue-500 text-white rounded" on:click={handleSelectPlayers}>Select Players</button>
            </div>
        </div>
    </div>
{/if}
