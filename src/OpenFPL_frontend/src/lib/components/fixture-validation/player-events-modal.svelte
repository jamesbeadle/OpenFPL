<script lang="ts">
  import type { Writable } from "svelte/store";
  import type { PlayerDTO, PlayerEventData } from "../../../../../declarations/player_canister/player_canister.did";

  export let show = false;
  export let player: PlayerDTO;
  export let fixtureId: number;
  export let playerEventData: Writable<[] | PlayerEventData[]>;
  export let closeModal: () => void;

  let eventType = -1;
  let eventStartTime = 0;
  let eventEndTime = 0;

  let isSubmitDisabled: boolean = true;
  $: isSubmitDisabled = eventType < 0;

  const eventOptions = [
    { id: 0, label: "Appearance" },
    { id: 1, label: "Goal Scored" },
    { id: 2, label: "Goal Assisted" },
    { id: 7, label: "Penalty Missed" },
    { id: 8, label: "Yellow Card" },
    { id: 9, label: "Red Card" },
    { id: 10, label: "Own Goal" },
  ];

  function handleAddEvent() {
    
    if (eventType >= 0 && eventStartTime !== null && eventEndTime !== null) {
      const newEvent = {
        playerId: player.id,
        eventType: Number(eventType),
        eventStartMinute: Number(eventStartTime),
        eventEndMinute: Number(eventEndTime),
        fixtureId: fixtureId,
        teamId: player.teamId,
      };
      let updatedEvents: PlayerEventData[] = [...$playerEventData, newEvent];
      playerEventData.set(updatedEvents);
      eventStartTime = 0;
      eventEndTime = 0;
      eventType = -1;
    }
  }

  function handleRemoveEvent(indexToRemove: number) {
    playerEventData.update((currentEvents) => {
      return currentEvents.filter((_, index) => index !== indexToRemove);
    });
  }

  function handleKeydown(event: KeyboardEvent): void {
    if (!(event.target instanceof HTMLInputElement) && event.key === "Escape") {
      closeModal();
    }
  }
</script>

{#if show}
  <div class="fixed inset-0 bg-gray-900 bg-opacity-80 overflow-y-auto h-full w-full modal-backdrop"
    on:click={closeModal} on:keydown={handleKeydown}>
    <div class="relative top-20 mx-auto p-5 border border-gray-700 w-96 shadow-lg rounded-md bg-panel"
      on:click|stopPropagation on:keydown={handleKeydown}>
      <div class="mt-3">
        <div class="flex justify-between items-center">
          <h4 class="text-lg font-bold">
            {player.firstName !== "" ? player.firstName.charAt(0) + "." : ""}
            {player.lastName} - Match Events
          </h4>
        </div>

        <div class="mt-4 p-4 border-t border-gray-200">
          <h4 class="font-bold">Add Event</h4>
          <div class="flex flex-col gap-1">
            <div class="mt-1">
              <select id="eventType" 
                bind:value={eventType}
                class="w-full p-2 rounded-md fpl-dropdown">
                <option value={-1} disabled>Select event type</option>
                {#each eventOptions as option}
                  <option value={option.id}>{option.label}</option>
                {/each}
              </select>
            </div>
            <div class="mt-1">
              <label for="startMinute" class="block text-sm font-medium">Start Minute</label>
              <input type="number" id="startMinute" bind:value={eventStartTime}
                class="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-black"
                placeholder="Enter start minute"/>
            </div>
            <div class="mt-2">
              <label for="endMinute" class="block text-sm font-medium">End Minute</label>
              <input type="number" id="endMinute" bind:value={eventEndTime}
                class="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-black"
                placeholder="Enter end minute"/>
            </div>
            
            <div class="items-center mt-3 flex space-x-4">
              <button class="px-4 py-2 fpl-cancel-btn text-white text-base font-medium rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300"
                on:click={closeModal}>
                Cancel
              </button>
              
              <button class={`${ isSubmitDisabled ? "bg-gray-500" : "fpl-purple-btn"} px-4 py-2 text-white text-base font-medium rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300`} on:click={handleAddEvent} disabled={isSubmitDisabled}>Add Event</button>
            </div>
            
          </div>
        </div>
        
        <div class="px-4">
          <h4 class="text-sm">Events:</h4>
        </div>
        <div class="mt-1 text-xs">
          <ul class="list-disc pl-5">
            {#each $playerEventData as event, index}
              <li class="flex justify-between items-center mb-2">
                <span>{event.eventType} - From {event.eventStartMinute} to {event.eventEndMinute} minutes</span>
                <button class="px-3 py-1 bg-red-500 rounded" on:click={() => handleRemoveEvent(index)}>
                  Remove
                </button>
              </li>
            {/each}
          </ul>
        </div>
        <div class="flex justify-end gap-3 mt-4">
          <button class="px-4 py-2 bg-blue-500 rounded" on:click={closeModal}>Done</button>
        </div>
      </div>
    </div>
  </div>
{/if}
