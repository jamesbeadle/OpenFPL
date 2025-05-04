<script lang="ts">
    import { getGridSetup } from "$lib/utils/pick-team.helpers";
    import AddIcon from "$lib/icons/AddIcon.svelte";
    import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
    import ActiveCaptainIcon from "$lib/icons/ActiveCaptainIcon.svelte";
    import PlayerCaptainIcon from "$lib/icons/PlayerCaptainIcon.svelte";
    import RemovePlayerIcon from "$lib/icons/RemovePlayerIcon.svelte";
    import { getActualIndex } from "$lib/utils/Helpers";
    import { playerStore } from "$lib/stores/player-store";
    import { clubStore } from "$lib/stores/club-store";
    import type { TeamSetup } from "../../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    
    interface Props {
      selectedFormation: string;
      fantasyTeam: TeamSetup | undefined;
      loadAddPlayer: (row: number, col: number) => void;
      removePlayer: (playerId: number) => void;
      setCaptain: (playerId: number) => void;
      canSellPlayer: boolean;
      sessionAddedPlayers: number[];
    }
    let { selectedFormation, fantasyTeam, loadAddPlayer, removePlayer, setCaptain, canSellPlayer, sessionAddedPlayers }: Props = $props();
    let gridSetup: number[][] = $state([]);
    $effect(() => {
      gridSetup = getGridSetup(selectedFormation);
    });

</script>

<div class="bg-panel">
    {#each gridSetup as row, rowIndex}
      <div class="flex items-center justify-between py-2 bg-light-gray border-b border-gray-700 px-4">
        <div class="w-1/3">
          {#if rowIndex === 0}Goalkeeper{/if}
          {#if rowIndex === 1}Defenders{/if}
          {#if rowIndex === 2}Midfielders{/if}
          {#if rowIndex === 3}Forwards{/if}
        </div>
        <div class="w-1/6">(c)</div>
        <div class="w-1/3">Team</div>
        <div class="w-1/6">Value</div>
        <div class="w-1/6">&nbsp;</div>
      </div>
      {#each row as _, colIndex (colIndex)}
        {@const actualIndex = getActualIndex(rowIndex, colIndex, gridSetup)}
        {@const playerIds = fantasyTeam?.playerIds ?? []}
        {@const playerId = playerIds[actualIndex]}
        {@const player = $playerStore.find((p) => p.id === playerId)}
        {@const team = $clubStore.find((x) => x.id === player?.clubId)}

        <div class="flex items-center justify-between py-2 px-4">
          {#if playerId > 0 && player}
            <div class="w-1/3">
              {player.firstName}
              {player.lastName}
            </div>
            <div class="w-1/6 flex items-center">
              {#if fantasyTeam?.captainId === playerId}
                <span>
                  <ActiveCaptainIcon className="w-6 h-6" />
                </span>
              {:else}
                <button onclick={() => setCaptain(player.id)}>
                  <PlayerCaptainIcon className="w-6 h-6" />
                </button>
              {/if}
            </div>
            <div class="flex w-1/3 items-center">
              <BadgeIcon className="h-5 w-5 mr-2" club={team!}/>
              <p>{team?.name}</p>
            </div>
            <div class="w-1/6">
              £{(player.valueQuarterMillions / 4).toFixed(2)}m
            </div>
            <div class="w-1/6 flex items-center">
              {#if canSellPlayer || sessionAddedPlayers.includes(player.id)}
                <button onclick={() => removePlayer(player.id)} class="bg-red-600 mb-1 rounded-sm">
                  <RemovePlayerIcon className="w-6 h-6 p-2" />
                </button>
              {:else}
                <div class="w-4 h-4 sm:w-6 sm:h-6 p-1">&nbsp;</div>
              {/if}
            </div>
          {:else}
            <div class="w-1/3">-</div>
            <div class="w-1/6">-</div>
            <div class="w-1/3">-</div>
            <div class="w-1/6">-</div>
            <div class="w-1/6 flex items-center">
              <button onclick={() => loadAddPlayer(rowIndex, colIndex)} class="rounded fpl-button flex items-center">
                <AddIcon className="w-6 h-6 p-2" />
              </button>
            </div>
          {/if}
        </div>
      {/each}
    {/each}
  </div>