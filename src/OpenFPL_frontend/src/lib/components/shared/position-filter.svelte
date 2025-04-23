<script lang="ts">
    import { Position } from "$lib/enums/Position";
    import { getPositionIndexToText } from "$lib/utils/helpers";
    import type { Writable } from "svelte/store";


    interface Props {
      selectedPosition: Writable<number>;
    }
    let { selectedPosition }: Props = $props();
    

    let positionValues: number[] = Object.values(Position).filter(
        (value) => typeof value === "number"
    ) as number[];
</script>
<div class="flex p-4">
    <div class="flex items-center">
      <p>Position:</p>
      <select
        class="px-2 fpl-dropdown text-center mx-0 md:mx-2 min-w-[100px]"
        bind:value={$selectedPosition}
      >
        <option value={-1}>All</option>
        {#each positionValues as position}
          <option value={position}>{getPositionIndexToText(position)}</option>
        {/each}
      </select>
    </div>
  </div>