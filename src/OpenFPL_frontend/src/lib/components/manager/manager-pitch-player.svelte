<script lang="ts">
    import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
    import ShirtIcon from "$lib/icons/ShirtIcon.svelte";
    import type { GameweekData } from "$lib/interfaces/GameweekData";
    import { convertPositionToAbbreviation, getFlagComponent, getPlayerName } from "$lib/utils/helpers";
    import type { ClubDTO } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

    export let clubData: ClubDTO;
    export let playerData: GameweekData;

</script>
<div class="flex flex-col items-center text-center">
    <div class="flex justify-center items-center">
      <ShirtIcon className="h-6 xs:h-8 sm:h-10 lg:h-8 lg:h-12 xl:h-14 2xl:h-16" club={clubData} />
    </div>
    <div class="flex flex-col justify-center items-center text-xxs sm:text-xs">
      <div class="flex justify-center items-center bg-gray-700 rounded-t-md md:px-2 sm:py-1 top-player-detail">
        <p class="hidden sm:flex sm:min-w-[15px]">
          {convertPositionToAbbreviation(playerData.player.position)}
        </p>
        <svelte:component
          this={getFlagComponent(playerData.player.nationality)}
          class="hidden sm:flex h-2 w-2 mr-1 sm:h-4 sm:w-4 sm:mx-2 min-w-[15px]"
        />
        <p class="block truncate-50">
          { getPlayerName(playerData.player) }
          {playerData.player.lastName}
        </p>
      </div>
      <div
        class="flex justify-center items-center bg-white text-black md:px-2 sm:py-1 rounded-b-md
        min-w-[70px] xs:min-w-[90px] sm:min-w-[120px]
        max-w-[70px] xs:max-w-[90px] sm:max-w-[120px]"
      >
        <BadgeIcon className="hidden sm:flex w-2 h-2 xs:h-4 xs:w-4 sm:mx-1 min-w-[15px] pl-2 xs:pl-0" club={clubData}/>
        <p class="truncate-50">
          {playerData.totalPoints} pts
        </p>
      </div>
    </div>
  </div>