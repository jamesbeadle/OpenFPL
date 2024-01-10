<script lang="ts">
  import type { Writable } from "svelte/store";
  import { Modal } from "@dfinity/gix-components";
  import type {
    PlayerDTO,
    PlayerEventData,
  } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import {
    convertEvent,
    convertPlayerPosition,
    convertIntToEvent,
    getFlagComponent,
  } from "$lib/utils/Helpers";

  export let visible = false;
  export let player: PlayerDTO;
  export let fixtureId: number;
  export let playerEventData: Writable<[] | PlayerEventData[]>;
  export let closeModal: () => void;

  let eventType = -1;
  let eventStartTime = 0;
  let eventEndTime = 0;
  let keeperSaves = 0;
  let selectedCard = 0;
  

  let isSubmitDisabled: boolean = true;
  $: isSubmitDisabled =
    eventType < 0 ||
    eventStartTime < 0 ||
    eventStartTime > 90 ||
    eventEndTime < 0 ||
    eventEndTime > 90;

</script>

<Modal {visible} on:nnsClose={closeModal}>
  <div class="mx-4 p-4">
    <div class="flex justify-between items-center my-2">
      <h3 class="default-header">
        Add Events
      </h3>
      <button class="times-button" on:click={closeModal}>&times;</button>
    </div>

    <div class="flex justify-start items-center w-full">
      <div class="w-full flex-col space-y-4 mb-2">
        
        <div class="flex flex-row items-center">
          <svelte:component
              this={getFlagComponent(player.nationality)}
              class="w-4 h-4 mr-2 hidden xs:flex"
            />
          <p>
            {player.firstName !== "" ? player.firstName.charAt(0) + "." : ""}
            {player.lastName}
          </p>
        </div>

        <div class="border-b border-gray-200"></div>
        
        <div class="flex-col space-y-2">
          <p>Start Minute</p>
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
        
        <div class="flex-col space-y-2">
          <p>End Minute</p>
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

        <div class="flex-col space-y-2">
          <p>Select Cards:</p>
          <div class="flex flex-row">
            <input
              type="radio"
              class="form-radio h-5 w-5 text-blue-600"
              name="options"
              value={0}
              bind:group={selectedCard}
            />
            <p class="ml-2">No Card</p>
            <input
              type="radio"
              class="form-radio h-5 w-5 text-blue-600 ml-2"
              name="options"
              value={1}
              bind:group={selectedCard}
            />
            <p class="ml-2">Yellow Card</p>
            <input
              type="radio"
              class="form-radio h-5 w-5 text-blue-600 ml-2"
              name="options"
              value={2}
              bind:group={selectedCard}
            />
            <p class="ml-2">Red Card</p>
            
          </div>
          
        </div>

        <div class="flex-col space-y-2">
          <p>Add Goals:</p>
          <p class="text-sm">Minute</p>
          <div class="flex flex-row">
            <input type="range" class="w-11/12" min="0" max="90" value="0">
            <button class="fpl-button w-1/12 ml-4 py-1">+</button>
          </div>
          <div class="flex flex-wrap">
            <div class="event-tag mt-2">22 Min
              <button class="p-1">x</button>
            </div>
          </div>
        </div>

        <div class="flex-col space-y-2">
          <p>Add Assists:</p>
          <p class="text-sm">Minute</p>
          <div class="flex flex-row">
            <input type="range" class="w-11/12" min="0" max="90" value="0">
            <button class="fpl-button w-1/12 ml-4 py-1">+</button>
          </div>
          <div class="flex flex-wrap">
            <div class="event-tag mt-2">22 Min
              <button class="p-1">x</button>
            </div>
          </div>
        </div>

        
        <div class="flex-col space-y-2">
          <p>Add Own Goals:</p>
          <p class="text-sm">Minute</p>
          <div class="flex flex-row">
            <input type="range" class="w-11/12" min="0" max="90" value="0">
            <button class="fpl-button w-1/12 ml-4 py-1">+</button>
          </div>
          <div class="flex flex-wrap">
            <div class="event-tag mt-2">22 Min
              <button class="p-1">x</button>
            </div>
          </div>
        </div>

        {#if Object.keys(player.position)[0] == "Goalkeeper"}
          <div class="flex-col space-y-2">
            <p>Keeper Saves:</p>
            <input
              type="number"
              id="keepersaves"
              bind:value={keeperSaves}
              class="bg-gray-900 w-full px-4 py-2 mt-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
              placeholder="Enter start minute"
              min="0"
              max="90"
            />
          </div>
          <div class="flex-col space-y-2">
            <p>Penalty Saved:</p>
            <p class="text-sm">Minute</p>
            <div class="flex flex-row">
              <input type="range" class="w-11/12" min="0" max="90" value="0">
              <button class="fpl-button w-1/12 ml-4 py-1">+</button>
            </div>
            <div class="flex flex-wrap">
              <div class="event-tag mt-2">22 Min
                <button class="p-1">x</button>
              </div>
            </div>
          </div>
        {/if}

        <div class="flex-col space-y-2">
          <p>Penalty Missed:</p>
          <p class="text-sm">Minute</p>
          <div class="flex flex-row">
            <input type="range" class="w-11/12" min="0" max="90" value="0">
            <button class="fpl-button w-1/12 ml-4 py-1">+</button>
          </div>
          <div class="flex flex-wrap">
            <div class="event-tag mt-2">22 Min
              <button class="p-1">x</button>
            </div>
          </div>
        </div>

        <div class="items-center flex space-x-4 justify-end">
          <button
            on:click={closeModal}
            class="fpl-purple-btn px-4 py-2 default-button min-w-[150px]"
          >
            Done
          </button>
        </div>

      </div>

    </div>

    
  </div>
</Modal>
