<script lang="ts">
    import ShirtIcon from "$lib/icons/ShirtIcon.svelte";
    import { convertPositionToIndex, getPositionIndexToText } from "$lib/utils/helpers";
    import type { ClubDTO, PlayerDTO } from "../../../../../declarations/data_canister/data_canister.did";

    export let player: PlayerDTO;
    export let club: ClubDTO;
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