<script lang="ts">
    import { getPlayerName } from "$lib/utils/helpers";
    import type { PlayerDTO } from "../../../../../../external_declarations/data_canister/data_canister.did";
    import { playerEventsStore } from "$lib/stores/player-events-store";
    
    import AddIcon from "$lib/icons/AddIcon.svelte";
    import BadgeIcon from "$lib/icons/BadgeIcon.svelte";

    export let player: any;
    export let index: number;
    export let selectPlayer : (player: PlayerDTO) => void;
    export let disableReasons: (string | null)[];

    $: totalPoints = playerEventsStore.getPlayerScore(player.id);
</script>

<div
class="flex items-center justify-between py-2 border-b border-gray-700 cursor-pointer"
>
<div class="w-1/12 text-center">
  {#if Object.keys(player.position).includes("Goalkeeper")}GK{/if}
  {#if Object.keys(player.position).includes("Defender")}DF{/if}
  {#if Object.keys(player.position).includes("Midfielder")}MF{/if}
  {#if Object.keys(player.position).includes("Forward")}FW{/if}
</div>

<div class="w-2/12">
  {getPlayerName(player)}
</div>
<div class="w-2/12">
  <p class="flex items-center">
    <BadgeIcon
      className="w-6 h-6 mr-2"
      club={player.team!}
    />
    {player.team?.abbreviatedName}
  </p>
</div>
<div class="w-2/12">
  £{(player.valueQuarterMillions / 4).toFixed(2)}m
</div>
<div class="w-2/12">{totalPoints}</div>
<div class="flex items-center justify-center w-2/12">
  {#if disableReasons[index]}
    <span class="text-center text-xxs">{disableReasons[index]}</span>
  {:else}
    <button
      on:click={() => selectPlayer(player)}
      class="flex items-center rounded fpl-button"
    >
      <AddIcon className="w-6 h-6 p-2" />
    </button>
  {/if}
</div>
</div>