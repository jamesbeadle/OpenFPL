<script lang="ts">
  import type { Writable } from "svelte/store";
  import type {
    PlayerDTO,
    PlayerEventData,
  } from "../../../../../declarations/player_canister/player_canister.did";
  import { Modal } from "@dfinity/gix-components";

  export let visible = false;
  export let player: PlayerDTO;
  export let fixtureId: number;
  export let playerEventData: Writable<[] | PlayerEventData[]>;
  export let closeModal: () => void;

  let eventType = -1;
  let eventStartTime = 0;
  let eventEndTime = 0;

  let isSubmitDisabled: boolean = true;
  $: isSubmitDisabled =
    eventType < 0 ||
    eventStartTime < 0 ||
    eventStartTime > 90 ||
    eventEndTime < 0 ||
    eventEndTime > 90;

  const eventOptions = [
    { id: 0, label: "Appearance" },
    { id: 1, label: "Goal Scored" },
    { id: 2, label: "Goal Assisted" },
    { id: 6, label: "Penalty Saved" },
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

  function handleRemoveEvent(removedEvent: PlayerEventData) {
    playerEventData.update((currentEvents) => {
      return currentEvents.filter(
        (event) =>
          event.playerId != removedEvent.playerId &&
          event.eventStartMinute != removedEvent.eventStartMinute &&
          event.eventEndMinute != removedEvent.eventEndMinute &&
          event.eventType != eventType &&
          event.fixtureId != event.fixtureId &&
          event.teamId != event.teamId
      );
    });
  }

  const getEventTypeLabel = (id: number) => {
    const option = eventOptions.find((option) => option.id === id);
    return option ? option.label : "";
  };
</script>

<Modal {visible} on:nnsClose={closeModal}>
  <div class="bg-gray-900 p-4">
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
          <select
            id="eventType"
            bind:value={eventType}
            class="w-full p-2 fpl-dropdown"
          >
            <option value={-1} disabled>Select event type</option>
            <option value={0}>Appearance</option>
            <option value={1}>Goal Scored</option>
            <option value={2}>Goal Assisted</option>
            <option value={7}>Penalty Missed</option>
            <option value={8}>Yellow Card</option>
            <option value={9}> Card</option>
            <option value={10}>Own Goal</option>
            {#if player.position === 0}
              <option value={4}>Keeper Save</option>
              <option value={6}>Penalty Save</option>
            {/if}
          </select>
        </div>
        <div class="mt-1">
          <label for="startMinute" class="block text-sm font-medium"
            >Start Minute</label
          >
          <input
            type="number"
            id="startMinute"
            bind:value={eventStartTime}
            class="bg-gray-900 w-full px-4 py-2 mt-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            placeholder="Enter start minute"
            min="0"
            max="90"
          />
        </div>
        <div class="mt-2">
          <label for="endMinute" class="block text-sm font-medium"
            >End Minute</label
          >
          <input
            type="number"
            id="endMinute"
            bind:value={eventEndTime}
            class="bg-gray-900 w-full px-4 py-2 mt-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            placeholder="Enter end minute"
            min="0"
            max="90"
          />
        </div>

        <div class="items-center mt-3 flex space-x-4">
          <button
            class={`${isSubmitDisabled ? "bg-gray-500" : "fpl-purple-btn"} 
            px-4 py-2 text-white text-base font-medium rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300`}
            on:click={handleAddEvent}
            disabled={isSubmitDisabled}>Add Event</button
          >
        </div>
      </div>
    </div>

    <div class="px-4">
      <h4 class="text-sm">Events:</h4>
    </div>
    <div class="mt-1 text-xs mx-4">
      <ul class="list-disc">
        {#each $playerEventData.filter((x) => x.playerId == player.id) as event, index}
          <li class="flex justify-between items-center mb-2">
            <span
              >{getEventTypeLabel(event.eventType)} ({event.eventStartMinute} - {event.eventEndMinute})
              mins</span
            >
            <button
              class="px-3 py-1 bg-red-500 rounded"
              on:click={() => handleRemoveEvent(event)}
            >
              Remove
            </button>
          </li>
        {/each}
      </ul>
    </div>

    <div class="items-center mt-3 flex space-x-4">
      <button
        class="fpl-button mx-4 px-4 py-2 text-white text-base font-medium rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300"
        on:click={closeModal}>Done</button
      >
    </div>
  </div>
</Modal>
