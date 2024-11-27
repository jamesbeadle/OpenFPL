<script lang="ts">
    import { type Writable } from "svelte/store";
    import ShirtIcon from "$lib/icons/ShirtIcon.svelte";
    import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
    import { clubStore } from "$lib/stores/club-store";
    import type { GameweekData } from "$lib/interfaces/GameweekData";
    import { getFlagComponent, convertPositionToAbbreviation } from "$lib/utils/helpers";
    import type { ClubDTO, FantasyTeamSnapshot } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    import { onMount } from "svelte";
    
    $: rowHeight = (pitchHeight * 0.9) / 4;
    $: gridSetupComplete = rowHeight > 0;
  
    let pitchHeight = 0;
    let pitchElement: HTMLElement;
    export let fantasyTeam: Writable<FantasyTeamSnapshot | null>;
    export let gridSetup: number[][];
    export let gameweekPlayers: Writable<GameweekData[]>;

    onMount(async () => {
      try {
        if (typeof window !== "undefined") {
          window.addEventListener("resize", updatePitchHeight);
          updatePitchHeight();
        }
      } catch (error) {
        console.error("Error fetching manager details:", error);
      } finally {
        gridSetupComplete = true;
      }
    });

    function updatePitchHeight() {
      if (!pitchElement) {
        return;
      }
      pitchHeight = pitchElement.clientHeight;
    }
  
    function getActualIndex(rowIndex: number, colIndex: number): number {
      let startIndex = gridSetup
        .slice(0, rowIndex)
        .reduce((sum, currentRow) => sum + currentRow.length, 0);
      return startIndex + colIndex;
    }
  
    function getPlayerData(playerId: number): GameweekData | null {
      return $gameweekPlayers.find((data) => data.player.id === playerId) ?? null;
    }
  
    function getClubData(clubId: number | undefined): ClubDTO | null {
      if (!clubId) return null;
      return $clubStore.find((club) => club.id === clubId) ?? null;
    }
  </script>
  
  <div class="relative w-full mt-2">
    {#if gridSetupComplete}
      <img
          src="/pitch.png"
          alt="pitch"
          class="w-full h-auto"
          on:load={updatePitchHeight}
          bind:this={pitchElement}
        />
      {#if gridSetup && rowHeight}
        <div class="absolute top-0 left-0 right-0 bottom-0">
          {#each gridSetup as row, rowIndex}
            <div
              class="flex justify-around items-center w-full"
              style="height: {rowHeight}px;"
            >
              {#each row as _, colIndex (colIndex)}
                {@const actualIndex = getActualIndex(rowIndex, colIndex)}
                {@const playerIds = $fantasyTeam?.playerIds ?? []}
                {@const playerId = playerIds[actualIndex]}
                {@const playerData = getPlayerData(playerId)}
                {@const clubData = getClubData(playerData?.player.clubId)}
    
                <div class="flex flex-col justify-center items-center flex-1 player-card">
                  {#if playerData && clubData}
                    <div class="flex flex-col items-center text-center">
                      <div class="flex justify-center items-center">
                        <ShirtIcon
                          className="h-6 xs:h-8 sm:h-10 lg:h-8 lg:h-12 xl:h-14 2xl:h-16"
                          primaryColour={clubData.primaryColourHex}
                          secondaryColour={clubData.secondaryColourHex}
                          thirdColour={clubData.thirdColourHex}
                        />
                      </div>
    
                      <div class="flex flex-col justify-center items-center text-xxs sm:text-xs">
                        <div
                          class="flex justify-center items-center bg-gray-700 rounded-t-md md:px-2 sm:py-1
                          min-w-[60px] xs:min-w-[90px] sm:min-w-[120px]
                          max-w-[60px] xs:max-w-[90px] sm:max-w-[120px]"
                        >
                          <p class="hidden sm:flex sm:min-w-[15px]">
                            {convertPositionToAbbreviation(playerData.player.position)}
                          </p>
                          <svelte:component
                            this={getFlagComponent(playerData.player.nationality)}
                            class="hidden sm:flex h-2 w-2 mr-1 sm:h-4 sm:w-4 sm:mx-2 min-w-[15px]"
                          />
                          <p
                            class="block truncate min-w-[50px] max-w-[50px] xs:min-w-[60px] xs:max-w-[60px]"
                          >
                            {playerData.player.firstName.length > 0
                              ? playerData.player.firstName.substring(0, 1) + "."
                              : ""}
                            {playerData.player.lastName}
                          </p>
                        </div>
    
                        <div
                          class="flex justify-center items-center bg-white text-black md:px-2 sm:py-1 rounded-b-md
                          min-w-[70px] xs:min-w-[90px] sm:min-w-[120px]
                          max-w-[70px] xs:max-w-[90px] sm:max-w-[120px]"
                        >
                          <BadgeIcon
                            className="hidden sm:flex w-2 h-2 xs:h-4 xs:w-4 sm:mx-1 min-w-[15px] pl-2 xs:pl-0"
                            primaryColour={clubData.primaryColourHex}
                            secondaryColour={clubData.secondaryColourHex}
                            thirdColour={clubData.thirdColourHex}
                          />
                          <p class="truncate min-w-[50px] max-w-[50px]">
                            {playerData.totalPoints} pts
                          </p>
                        </div>
                      </div>
                    </div>
                  {/if}
                </div>
              {/each}
            </div>
          {/each}
        </div>
      {/if}
    {/if}
  </div>
  