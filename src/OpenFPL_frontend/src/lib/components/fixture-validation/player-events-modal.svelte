<script lang="ts">
  import { get, type Writable } from "svelte/store";
  import type {
    PlayerDTO,
    PlayerEventData,
  } from "../../../../../declarations/player_canister/player_canister.did";

  export let show = false;
  export let player: PlayerDTO;
  export let fixtureId: number;
  export let playerEventData: Writable<[] | PlayerEventData[]>;

  let eventType = -1;
  let eventStartTime = 0;
  let eventEndTime = 0;

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
    if (eventType && eventStartTime !== null && eventEndTime !== null) {
      const newEvent = {
        playerId: player.id,
        eventType: Number(eventType),
        eventStartMinute: Number(eventStartTime),
        eventEndMinute: Number(eventEndTime),
        fixtureId: fixtureId,
        teamId: player.teamId,
      };
      let updatedEvents: PlayerEventData[] = [
        ...get(playerEventData),
        newEvent,
      ];
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
</script>

{#if show}
  <div
    class="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full"
  >
    <div class="relative top-20 mx-auto p-5 border w-3/4 shadow-lg rounded-md">
      {#if player}
        <div class="flex justify-between items-center">
          <h4 class="text-lg font-bold">
            {player.firstName !== "" ? player.firstName.charAt(0) + "." : ""}
            {player.lastName} - Match Events
          </h4>
          <button class="text-black" on:click={() => (show = false)}>✕</button>
        </div>

        <div class="mt-4 p-4 border-t border-gray-200">
          <h4 class="text-lg font-bold mb-3">Add Event</h4>
          <div class="flex flex-col gap-3">
            <div>
              <label
                for="eventType"
                class="block text-sm font-medium text-gray-700"
                >Event Type</label
              >
              <select
                id="eventType"
                bind:value={eventType}
                class="mt-1 block w-full pl-3 pr-10 py-2 text-base border-gray-300 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm rounded-md"
              >
                <option value="-1" disabled>Select event type</option>
                {#each eventOptions as option}
                  <option value={option.id}>{option.label}</option>
                {/each}
              </select>
            </div>
            <div>
              <label
                for="startMinute"
                class="block text-sm font-medium text-gray-700"
                >Start Minute</label
              >
              <input
                type="number"
                id="startMinute"
                bind:value={eventStartTime}
                class="mt-1 block w-full pl-3 pr-10 py-2 text-base border-gray-300 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm rounded-md"
                placeholder="Enter start minute"
              />
            </div>
            <div>
              <label
                for="endMinute"
                class="block text-sm font-medium text-gray-700"
                >End Minute</label
              >
              <input
                type="number"
                id="endMinute"
                bind:value={eventEndTime}
                class="mt-1 block w-full pl-3 pr-10 py-2 text-base border-gray-300 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm rounded-md"
                placeholder="Enter end minute"
              />
            </div>
            <button
              class="mt-2 px-4 py-2 bg-blue-500 text-white rounded"
              on:click={handleAddEvent}>Add Event</button
            >
          </div>
        </div>

        <div class="mt-4">
          <ul class="list-disc pl-5">
            {#each $playerEventData as event, index}
              <li class="flex justify-between items-center mb-2">
                <span
                  >{event.eventType} - From {event.eventStartMinute} to {event.eventEndMinute}
                  minutes</span
                >
                <button
                  class="px-3 py-1 bg-red-500 text-white rounded"
                  on:click={() => handleRemoveEvent(index)}
                >
                  Remove
                </button>
              </li>
            {/each}
          </ul>
        </div>
      {/if}
      <div class="flex justify-end gap-3 mt-4">
        <button
          class="px-4 py-2 bg-blue-500 text-white rounded"
          on:click={() => (show = false)}>Done</button
        >
      </div>
    </div>
  </div>
{/if}
