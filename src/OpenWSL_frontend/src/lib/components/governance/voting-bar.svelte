<script lang="ts">
  export let yesVotes: number = 0;
  export let noVotes: number = 0;
  export let totalVotes: number = 100;

  $: yesPercentage = (yesVotes / totalVotes) * 100;
  $: noPercentage = (noVotes / totalVotes) * 100;
  $: remainingPercentage = 100 - yesPercentage - noPercentage;
</script>

<div class="w-full bg-gray-200 rounded-lg overflow-hidden relative h-8">
  <div class="flex h-full relative">
    <div class="bg-green-500 h-full" style="width: {yesPercentage}%">
      {#if yesPercentage > 5}
        <span class="absolute left-0 text-white px-2">{yesPercentage.toFixed(2)}%</span>
      {/if}
    </div>
    <div class="bg-red-500 h-full" style="width: {noPercentage}%">
      {#if noPercentage > 5}
        <span class="absolute right-0 text-white px-2">{noPercentage.toFixed(2)}%</span>
      {/if}
    </div>
    <div class="bg-gray-400 h-full" style="width: {remainingPercentage}%"></div>
  </div>
  <div class="absolute top-0 left-0 w-full flex justify-between px-2 text-sm">
    <span class="text-green-700">{yesVotes.toLocaleString()} Voting Power</span>
    <span class="text-red-700">{noVotes.toLocaleString()} Voting Power</span>
  </div>
</div>
