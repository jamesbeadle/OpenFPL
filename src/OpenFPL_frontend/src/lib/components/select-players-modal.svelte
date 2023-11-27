<script lang="ts">
    import { createEventDispatcher } from 'svelte';
    let show = false;
    let teamPlayers = [];
    let selectedTeam = '';
    let currentSelectedPlayers = [];
    let selectedPlayers = {};
    let initialSelectedPlayers = {};
  
    const dispatch = createEventDispatcher();
  
    $: if (show) {
      if (!initialSelectedPlayers[selectedTeam]) {
        initialSelectedPlayers = { ...initialSelectedPlayers, [selectedTeam]: selectedPlayers[selectedTeam] };
      }
    } else {
      initialSelectedPlayers = {};
    }
  
    function handlePlayerCheck(playerId, isChecked) {
      selectedPlayers = {
        ...selectedPlayers,
        [selectedTeam]: isChecked
          ? [...(selectedPlayers[selectedTeam] || []), playerId]
          : (selectedPlayers[selectedTeam] || []).filter(id => id !== playerId)
      };
    }
  
    function handleSelectPlayers() {
      const selectedPlayerIds = selectedPlayers[selectedTeam] || [];
      dispatch('selectPlayers', { team: selectedTeam, playerIds: selectedPlayerIds });
      show = false;
    }
  
    function handleCancel() {
      selectedPlayers = {
        ...selectedPlayers,
        [selectedTeam]: initialSelectedPlayers[selectedTeam]
      };
      show = false;
    }
  
    function renderPlayerList() {
      if (!teamPlayers) {
        return [];
      }
  
      const sortedPlayers = teamPlayers.sort((a, b) => a.lastName.localeCompare(b.lastName));
      const halfLength = Math.ceil(sortedPlayers.length / 2);
      const firstHalf = sortedPlayers.slice(0, halfLength);
      const secondHalf = sortedPlayers.slice(halfLength);
  
      return { firstHalf, secondHalf };
    }
  </script>
  
  {#if show}
    <div class="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full">
      <div class="relative top-20 mx-auto p-5 border w-3/4 shadow-lg rounded-md bg-white">
        <div class="flex justify-between items-center">
          <h4 class="text-lg font-bold">Select Players</h4>
          <button class="text-black" on:click={handleCancel}>✕</button>
        </div>
        <div class="my-5">
          {#each renderPlayerList().firstHalf as player}
            <label class="block">
              <input
                type="checkbox"
                checked={(selectedPlayers[selectedTeam] || []).includes(player.id)}
                on:change={(e) => handlePlayerCheck(player.id, e.target.checked)}
              />
              {`${player.firstName.length > 0 ? player.firstName.charAt(0) + '.' : '' } ${player.lastName}`}
            </label>
          {/each}
          <!-- Repeat for secondHalf -->
        </div>
        <div class="flex justify-end gap-3">
          <button class="px-4 py-2 border rounded text-black" on:click={handleCancel}>Cancel</button>
          <button class="px-4 py-2 bg-blue-500 text-white rounded" on:click={handleSelectPlayers}>Select Players</button>
        </div>
      </div>
    </div>
  {/if}
