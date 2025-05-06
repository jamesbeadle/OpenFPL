<script lang="ts">
    import RemovePlayerIcon from "$lib/icons/RemovePlayerIcon.svelte";
    import ShirtIcon from "$lib/icons/ShirtIcon.svelte";
    import ActiveCaptainIcon from "$lib/icons/ActiveCaptainIcon.svelte";
    import PlayerCaptainIcon from "$lib/icons/PlayerCaptainIcon.svelte";
    import { convertPositionToIndex, getFlagComponent, getPlayerName, getPositionAbbreviation } from "$lib/utils/Helpers";
    import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
    import type { TeamSetup, Club, Player } from "../../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    
    interface Props {
      fantasyTeam: TeamSetup | undefined;
      player: Player;
      club: Club;
      canSellPlayer: boolean;
      sessionAddedPlayers: number[];
      removePlayer: (playerId: number) => void;
      setCaptain: (playerId: number) => void;
    }
    let { fantasyTeam, player, club, canSellPlayer, sessionAddedPlayers, removePlayer, setCaptain }: Props = $props();
    
</script>

<div class="flex flex-col items-center text-center">
    <div class="flex items-center justify-center">
      <div class="flex items-end justify-between w-full">
        {#if canSellPlayer || sessionAddedPlayers.includes(player.id)}
          <button onclick={() => removePlayer(player.id)} class="mb-1 bg-red-600 rounded-sm">
            <RemovePlayerIcon className="w-3 xs:w-4 h-3 xs:h-4 sm:w-6 sm:h-6 p-1" />
          </button>
        {:else}
          <div class="w-4 h-4 p-1 sm:w-6 sm:h-6">&nbsp;</div>
        {/if}
        <div class="flex items-center justify-center flex-grow">
          <ShirtIcon className="h-6 xs:h-12 sm:h-12 md:h-16 lg:h-20 xl:h-12 2xl:h-16" {club} />
        </div>
        {#if fantasyTeam?.captainId === player.id}
          <span class="mb-1">
            <ActiveCaptainIcon className="captain-icon"/>
          </span>
        {:else}
          <button onclick={() => setCaptain(player.id)} class="mb-1">
            <PlayerCaptainIcon className="captain-icon" />
          </button>
        {/if}
      </div>
    </div>
    <div class="flex flex-col items-center justify-center text-xxs sm:text-xs">
      <div class="flex items-center justify-between bg-gray-700 rounded-t-md md:px-2 sm:py-1 top-player-detail w-full gap-1">
        <p class="min-w-[15px] sm:min-w-[20px] text-center">
          {getPositionAbbreviation(convertPositionToIndex(player.position))}
        </p>
    
        {#if player.nationality > 0}
          {@const FlagComponent = getFlagComponent(player.nationality)}
          <FlagComponent className="w-4 xs:w-6 mx-1" size="16" ariaLabel={`flag of ${player.nationality}`} role='img' />
        {/if}
    
        <p class="truncate flex-1 text-center">
          {getPlayerName(player)}
        </p>
      </div>
      <div class="flex items-center justify-center text-black bg-white md:px-2 sm:py-1 rounded-b-md top-player-detail">
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