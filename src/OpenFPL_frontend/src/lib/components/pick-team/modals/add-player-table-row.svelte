<script lang="ts">
    import AddIcon from "$lib/icons/AddIcon.svelte";
    import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
    import { getPlayerName } from "$lib/utils/helpers";
    import type { PlayerDTO } from "../../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

    export let player: any;
    export let index: number;
    export let selectPlayer : (player: PlayerDTO) => void;
    export let disableReasons: (string | null)[];
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
<div class="w-1/12">{player.totalPoints}</div>
<div class="w-3/12 flex justify-center items-center">
  {#if disableReasons[index]}
    <span class="text-xxs text-center">{disableReasons[index]}</span>
  {:else}
    <button
      on:click={() => selectPlayer(player)}
      class="rounded fpl-button flex items-center"
    >
      <AddIcon className="w-6 h-6 p-2" />
    </button>
  {/if}
</div>
</div>