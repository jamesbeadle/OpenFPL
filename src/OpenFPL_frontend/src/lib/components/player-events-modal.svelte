<script lang="ts">
    import { writable, get } from "svelte/store";
    import type { PlayerDTO, PlayerEventData } from '../../../../declarations/player_canister/player_canister.did';
    export let show = false;
    export let player: PlayerDTO;
    export let fixtureId: number;
    const playerEvents = writable<PlayerEventData[] | []>([]);

    let eventType = -1;
    let eventStartTime = 0;
    let eventEndTime = 0;
    
    function handleAddEvent() {
      if (eventType && eventStartTime !== null && eventEndTime !== null) {
        const newEvent = {
            playerId: player.id,
            eventType: Number(eventType),
            eventStartMinute: Number(eventStartTime),
            eventEndMinute: Number(eventEndTime),
            fixtureId: fixtureId,
            teamId: player.teamId
            
        };
        let updatedEvents: PlayerEventData[] = [...get(playerEvents), newEvent];
        playerEvents.set(updatedEvents);
        eventStartTime = 0;
        eventEndTime = 0;
        eventType = -1;
        }
    }
  
    function handleRemoveEvent(indexToRemove: number) {
        playerEvents.update(currentEvents => {
            return currentEvents.filter((_, index) => index !== indexToRemove);
        });
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
          <div class="mt-4">
            <ul class="list-disc pl-5">
              {#each $playerEvents as event, index}
                <li class="flex justify-between items-center mb-2">
                  <span>{event.eventType} - From {event.eventStartMinute} to {event.eventEndMinute} minutes</span>
                  <button class="px-3 py-1 bg-red-500 text-white rounded" on:click={() => handleRemoveEvent(index)}>
                    Remove
                  </button>
                </li>
              {/each}
            </ul>
          </div>
        {/if}
        <div class="flex justify-end gap-3 mt-4">
          <button class="px-4 py-2 bg-blue-500 text-white rounded" on:click={() => show = false}>Done</button>
        </div>
      </div>
    </div>
  {/if}
  