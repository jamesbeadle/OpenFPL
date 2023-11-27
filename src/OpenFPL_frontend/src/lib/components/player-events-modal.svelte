<script lang="ts">
    import { createEventDispatcher } from 'svelte';
    let show = false;
    let player;
    let playerEventMap = {};
    let playerEvents = [];
    let eventType = "-1";
    let eventStartTime = "0";
    let eventEndTime = "0";
    const dispatch = createEventDispatcher();
  
    $: if (show && player) {
      const existingEvents = playerEventMap[player.id] || [];
      playerEvents = existingEvents;
      eventType = "-1";
      eventStartTime = "0";
      eventEndTime = "0";
    }
  
    function handleAddEvent() {
      if (eventType && eventStartTime !== null && eventEndTime !== null) {
        const newEvent = {
          playerId: player.id,
          eventType: Number(eventType),
          eventStartTime: Number(eventStartTime),
          eventEndTime: Number(eventEndTime)
        };
        let updatedEvents = [...playerEvents, newEvent];
        playerEvents = updatedEvents;
        dispatch('playerEventAdded', { playerId: player.id, newEvents: updatedEvents });
        eventStartTime = "";
        eventEndTime = "";
      }
    }
  
    function handleRemoveEvent(indexToRemove) {
      const updatedEvents = playerEvents.filter((_, index) => index !== indexToRemove);
      playerEvents = updatedEvents;
      dispatch('playerEventAdded', { playerId: player.id, newEvents: updatedEvents });
    }
  
    function getEventOptions(position) {
      const generalOptions = [
        // ... define general options
      ];
      if (position === 0) {
        return [
          ...generalOptions,
          // ... define keeper options
        ];
      }
      return generalOptions;
    }
  
    function getEventTypeLabel(id) {
      const allOptions = [
        // ... define all options
      ];
      const option = allOptions.find(option => option.id === id);
      return option ? option.label : '';
    }
  </script>
  
  {#if show}
    <div class="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full">
      <div class="relative top-20 mx-auto p-5 border w-3/4 shadow-lg rounded-md bg-white">
        {#if player}
          <div class="flex justify-between items-center">
            <h4 class="text-lg font-bold">{player.firstName !== "" ? player.firstName.charAt(0) + "." : ""} {player.lastName} - Match Events</h4>
            <button class="text-black" on:click={() => show = false}>✕</button>
          </div>
          <!-- Form and event list here -->
        {/if}
        <div class="flex justify-end gap-3 mt-4">
          <button class="px-4 py-2 bg-blue-500 text-white rounded" on:click={() => show = false}>Done</button>
        </div>
      </div>
    </div>
  {/if}
  