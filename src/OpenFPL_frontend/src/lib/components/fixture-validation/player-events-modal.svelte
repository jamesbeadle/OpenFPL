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

  let appearanceStart = 0;
  let appearanceEnd = 0;
  let keeperSaves = 0;
  let selectedCard = 0;
  let goalMinutes: number[] = [];
  let assistMinutes: number[] = [];
  let ownGoalMinutes: number[] = [];
  let penaltySaveMinutes: number[] = [];
  let penaltyMissedMinutes: number[] = [];

  let goalSliderValue = 0;
  let assistSliderValue = 0;
  let ownGoalSliderValue = 0;
  let penaltySaveSliderValue = 0;
  let penaltyMissSliderValue = 0;
  
  let isSubmitDisabled: boolean = true;
  $: isSubmitDisabled =
    appearanceStart < 0 ||
    appearanceStart > 90 ||
    appearanceEnd < 0 ||
    appearanceEnd > 90;

  function addPlayerEvents(){
    
    //create the player events and write to the writable in the parent container
    
    closeModal();
  }
  
  function addGoalEvent() {
    goalMinutes = [...goalMinutes, goalSliderValue];
  }
  
  function addAssistEvent() {
    assistMinutes = [...assistMinutes, assistSliderValue];
  }
  
  function addPenaltySaveEvent() {
    penaltySaveMinutes = [...penaltySaveMinutes, penaltySaveSliderValue];
  }
  
  function addPenaltyMissEvent() {
    penaltyMissedMinutes = [...penaltyMissedMinutes, penaltyMissSliderValue];
  }
  
  function addOwnGoalEvent() {
    ownGoalMinutes = [...ownGoalMinutes, ownGoalSliderValue];
  }

  function removeGoal(minute: number) {
    goalMinutes = goalMinutes.filter(m => m !== minute);
  }

  function removeAssist(minute: number) {
    assistMinutes = assistMinutes.filter(m => m !== minute);
  }

  function removePenaltySave(minute: number) {
    penaltySaveMinutes = penaltySaveMinutes.filter(m => m !== minute);
  }

  function removePenaltyMiss(minute: number) {
    penaltyMissedMinutes = penaltyMissedMinutes.filter(m => m !== minute);
  }

  function removeOwnGoal(minute: number) {
    ownGoalMinutes = ownGoalMinutes.filter(m => m !== minute);
  }

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
            bind:value={appearanceStart}
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
            bind:value={appearanceEnd}
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
            <input type="range" class="w-11/12" min="0" max="90" bind:value={goalSliderValue}>
            <button class="fpl-button w-1/12 ml-4 py-1" on:click={addGoalEvent}>+</button>
          </div>
          <div class="flex flex-wrap">
            {#each goalMinutes as minute}
              <div class="event-tag mt-2">{minute} Min
                <button class="p-1" on:click={() => removeGoal(minute)}>x</button>
              </div>
            {/each}
          </div>
        </div>

        <div class="flex-col space-y-2">
          <p>Add Assists:</p>
          <p class="text-sm">Minute</p>
          <div class="flex flex-row">
            <input type="range" class="w-11/12" min="0" max="90" bind:value={assistSliderValue}>
            <button class="fpl-button w-1/12 ml-4 py-1" on:click={addAssistEvent}>+</button>
          </div>
          <div class="flex flex-wrap">
            {#each assistMinutes as minute}
              <div class="event-tag mt-2">{minute} Min
                <button class="p-1" on:click={() => removeAssist(minute)}>x</button>
              </div>
            {/each}
          </div>
        </div>

        
        <div class="flex-col space-y-2">
          <p>Add Own Goals:</p>
          <p class="text-sm">Minute</p>
          <div class="flex flex-row">
            <input type="range" class="w-11/12" min="0" max="90" bind:value={ownGoalSliderValue}>
            <button class="fpl-button w-1/12 ml-4 py-1" on:click={addOwnGoalEvent}>+</button>
          </div>
          <div class="flex flex-wrap">
            {#each ownGoalMinutes as minute}
              <div class="event-tag mt-2">{minute} Min
                <button class="p-1" on:click={() => removeOwnGoal(minute)}>x</button>
              </div>
            {/each}
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
              <input type="range" class="w-11/12" min="0" max="90" bind:value={penaltySaveSliderValue}>
              <button class="fpl-button w-1/12 ml-4 py-1" on:click={addPenaltySaveEvent}>+</button>
            </div>
            <div class="flex flex-wrap">
              {#each penaltySaveMinutes as minute}
                <div class="event-tag mt-2">{minute} Min
                  <button class="p-1" on:click={() => removePenaltySave(minute)}>x</button>
                </div>
              {/each}
            </div>
          </div>
        {/if}

        <div class="flex-col space-y-2">
          <p>Penalty Missed:</p>
          <p class="text-sm">Minute</p>
          <div class="flex flex-row">
            <input type="range" class="w-11/12" min="0" max="90" bind:value={penaltyMissSliderValue}>
            <button class="fpl-button w-1/12 ml-4 py-1" on:click={addPenaltyMissEvent}>+</button>
          </div>
          <div class="flex flex-wrap">
            {#each penaltyMissedMinutes as minute}
              <div class="event-tag mt-2">{minute} Min
                <button class="p-1" on:click={() => removePenaltyMiss(minute)}>x</button>
              </div>
            {/each}
          </div>
        </div>

        <div class="items-center flex space-x-4 justify-end">
          <button
            on:click={addPlayerEvents}
            class="fpl-purple-btn px-4 py-2 default-button min-w-[150px]"
          >
            Done
          </button>
        </div>

      </div>

    </div>

    
  </div>
</Modal>
