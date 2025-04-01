<script lang="ts">
    import ShirtIcon from "$lib/icons/ShirtIcon.svelte";
    import { convertPositionToIndex, getPositionIndexToText } from "$lib/utils/helpers";
    import type { Club, Player } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

    export let player: Player;
    export let club: Club;
</script>

<div class="flex-grow flex flex-col items-center">
  <p class="content-panel-header">
    {getPositionIndexToText(
      convertPositionToIndex(
        player.position ?? { Goalkeeper: null }
      ) ?? -1
    )}
  </p>
  <div class="py-2 flex">
    <ShirtIcon className="h-10" club={club} />
  </div>
  <p class="content-panel-header">
    Shirt: {player.shirtNumber}
  </p>
</div>