<script lang="ts">
    import { getPlayerName } from "$lib/utils/Helpers";
    import BadgeIcon from "$lib/icons/BadgeIcon.svelte";

    interface Props {
      player: any;
    }
    let { player }: Props = $props();
 
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
<div class="w-3/12">
  £{(player.valueQuarterMillions / 4).toFixed(2)}m
</div>
<div class="w-3/12">0</div>
</div>