<script lang="ts">
    import { calculateAgeFromNanoseconds, convertDateToReadable } from "$lib/utils/helpers";
    import type { Player } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    
    export let player: Player;
</script>

<div class="flex-grow flex flex-col">
    <p class="content-panel-header">Age</p>
    <p class="content-panel-stat">
      {calculateAgeFromNanoseconds(
        Number(player.dateOfBirth ?? 0)
      )}
    </p>
    <p class="content-panel-header">
      {convertDateToReadable(Number(player.dateOfBirth ?? 0))}
    </p>
  </div>