<script lang="ts">
    import type { Writable } from "svelte/store";
    import type { ClubDTO, PlayerDTO } from "../../../../../external_declarations/data_canister/data_canister.did";
    import RemovePlayerIcon from "$lib/icons/RemovePlayerIcon.svelte";
    import ShirtIcon from "$lib/icons/ShirtIcon.svelte";
    import ActiveCaptainIcon from "$lib/icons/ActiveCaptainIcon.svelte";
    import PlayerCaptainIcon from "$lib/icons/PlayerCaptainIcon.svelte";
    import { convertPositionToIndex, getFlagComponent, getPlayerName, getPositionAbbreviation } from "$lib/utils/helpers";
    import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
    import type { TeamSelectionDTO } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

    export let fantasyTeam: Writable<TeamSelectionDTO | undefined>;
    export let player: PlayerDTO;
    export let club: ClubDTO;
    export let canSellPlayer: Writable<boolean>;
    export let sessionAddedPlayers: Writable<number[]>;
    export let removePlayer: (playerId: number) => void;
    export let setCaptain: (playerId: number) => void;

</script>

<div class="flex flex-col items-center text-center">
    <div class="flex justify-center items-center">
      <div class="flex justify-between items-end w-full">
        {#if $canSellPlayer || $sessionAddedPlayers.includes(player.id)}
          <button on:click={() => removePlayer(player.id)} class="bg-red-600 mb-1 rounded-sm">
            <RemovePlayerIcon className="w-3 xs:w-4 h-3 xs:h-4 sm:w-6 sm:h-6 p-1" />
          </button>
        {:else}
          <div class="w-4 h-4 sm:w-6 sm:h-6 p-1">&nbsp;</div>
        {/if}
        <div class="flex justify-center items-center flex-grow">
          <ShirtIcon className="h-6 xs:h-12 sm:h-12 md:h-16 lg:h-20 xl:h-12 2xl:h-16" {club} />
        </div>
        {#if $fantasyTeam?.captainId === player.id}
          <span class="mb-1">
            <ActiveCaptainIcon className="captain-icon"/>
          </span>
        {:else}
          <button on:click={() => setCaptain(player.id)} class="mb-1">
            <PlayerCaptainIcon className="captain-icon" />
          </button>
        {/if}
      </div>
    </div>
    <div class="flex flex-col justify-center items-center text-xxs sm:text-xs">
      <div class="flex justify-center items-center bg-gray-700 rounded-t-md md:px-2 sm:py-1 top-player-detail">
        <p class="hidden sm:flex sm:min-w-[15px]">
          {getPositionAbbreviation(convertPositionToIndex(player.position))}
        </p>
        <svelte:component
          this={getFlagComponent(player.nationality)}
          class="hidden xs:flex h-2 w-2 mr-1 sm:h-4 sm:w-4 sm:mx-2 min-w-[15px]"
        />
        <p class="hidden xs:block truncate-50">
          {getPlayerName(player)}
        </p>
        <p class="xs:hidden truncate-50">
          {player.lastName}
        </p>
      </div>
      <div
        class="flex justify-center items-center bg-white text-black md:px-2 sm:py-1 rounded-b-md top-player-detail">
        <p class="hidden sm:visible sm:min-w-[20px]">
          {club.abbreviatedName}
        </p>
        <BadgeIcon className="w-2 h-2 xs:h-4 xs:w-4 sm:mx-1 min-w-[15px] pl-2 xs:pl-0" {club}/>
        <p class="truncate-50">
          £{(player.valueQuarterMillions / 4).toFixed(2)}m
        </p>
      </div>
    </div>
  </div>