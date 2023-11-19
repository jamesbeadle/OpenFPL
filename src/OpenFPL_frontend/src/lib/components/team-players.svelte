<script lang="ts">
  import type { PlayerDTO } from "../../../../declarations/player_canister/player_canister.did";
  import { calculateAgeFromNanoseconds, getFlagComponent, getPositionText } from "../../utils/Helpers";  
  export let players: PlayerDTO[] = [];
</script>
  
<div class="container-fluid">
  <div class="flex flex-col space-y-4">
    <div>
      <div class='flex justify-between p-2 border border-gray-700 py-4 bg-light-gray'>
        <div class="flex-grow px-4 w-1/2">Number</div>
        <div class="flex-grow px-4 w-1/2">First Name</div>
        <div class="flex-grow px-4 w-1/2">Last Name</div>
        <div class="flex-grow px-4 w-1/2">Position</div>
        <div class="flex-grow px-4 w-1/2">Age</div>
        <div class="flex-grow px-4 w-1/2">Nationality</div>
        <div class="flex-grow px-4 w-1/2">Season Points</div>
        <div class="flex-grow px-4 w-1/2">Value</div>
      </div>
      {#each players as player }
        <div class="flex items-center justify-between py-2 border-b border-gray-700 text-white cursor-pointer">
          <a class="flex-grow flex items-center justify-start space-x-2 px-4" href={`/player?id=${player.id}`}>
              <div class="flex items-center w-1/2 px-3">
                  {player.shirtNumber == 0 ? '-' : player.shirtNumber}
              </div>
              <div class="flex items-center w-1/2 px-3">
                  {player.firstName == "" ? '-' : player.firstName}
              </div>
              <div class="flex items-center w-1/2 px-3">
                  {player.lastName}
              </div>
              <div class="flex items-center w-1/2 px-3">
                  {getPositionText(player.position)}
              </div>
              <div class="flex items-center w-1/2 px-3">
                  { calculateAgeFromNanoseconds(Number(player.dateOfBirth))}
              </div>
              <div class="flex items-center w-1/2 px-3">
                <svelte:component class="w-10 h-10" this={getFlagComponent(player.nationality)} size="100" /> 
              </div>
              <div class="flex items-center w-1/2 px-3">
                  { player.totalPoints }
              </div>
              <div class="flex items-center w-1/2 px-3">
                  £{ (Number(player.value)/4).toFixed(2) }m
              </div>
          </a>
        </div>
      {/each}
    </div>
  </div>
</div>
