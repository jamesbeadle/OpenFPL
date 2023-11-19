<script lang="ts">
  import type { PlayerDTO } from "../../../../declarations/player_canister/player_canister.did";
  import { convertDateToReadable, getFlagComponent, getPositionText } from "../../utils/Helpers";  
  export let players: PlayerDTO[] = [];
</script>
  
<div class="container-fluid mt-4">
  <div class="flex flex-col space-y-4">
    <div>
      {#each players as player }
        <div class="flex items-center justify-between py-2 border-b border-gray-700 text-white cursor-pointer">
          <a class="flex-grow flex items-center justify-start space-x-2 px-4" href={`/player?id=${player.id}`}>
              <div class="flex items-center w-1/2 ml-4">
                  {player.shirtNumber == 0 ? '-' : player.shirtNumber}
              </div>
              <div class="flex items-center w-1/2 ml-4">
                  {player.firstName == "" ? '-' : player.firstName}
              </div>
              <div class="flex items-center w-1/2 ml-4">
                  {player.lastName}
              </div>
              <div class="flex items-center w-1/2 ml-4">
                  { convertDateToReadable(Number(player.dateOfBirth))}
              </div>
              <div class="flex items-center w-1/2 ml-4">
                <svelte:component class="w-10 h-10" this={getFlagComponent(player.nationality)} size="100" /> 
              </div>
              <div class="flex items-center w-1/2 ml-4">
                  { player.totalPoints }
              </div>
              <div class="flex items-center w-1/2 ml-4">
                  £{ (Number(player.value)/4).toFixed(2) }m
              </div>
              <div class="flex items-center w-1/2 ml-4">
                  {getPositionText(player.position)}
              </div>
          </a>
        </div>
      {/each}
    </div>
  </div>
</div>
