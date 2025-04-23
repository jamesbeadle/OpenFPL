<script lang="ts">
    import ShirtIcon from "$lib/icons/ShirtIcon.svelte";
    import { convertPositionToIndex, getPositionIndexToText } from "$lib/utils/helpers";
    import type { Club, Player } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

    interface Props {
      player: Player;
      club: Club;
    }
    let { player, club }: Props = $props();
</script>

<div class="flex flex-col items-center flex-grow">
  <p class="content-panel-header">
    {getPositionIndexToText(
      convertPositionToIndex(
        player.position ?? { Goalkeeper: null }
      ) ?? -1
    )}
  </p>
  <div class="flex py-2">
    <ShirtIcon className="h-10" club={club} />
  </div>
  <p class="content-panel-header">
    Shirt: {player.shirtNumber}
  </p>
</div>