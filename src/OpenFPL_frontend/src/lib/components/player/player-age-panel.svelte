<script lang="ts">
    import { calculateAgeFromNanoseconds, convertDateToReadable } from "$lib/utils/helpers";
    import type { Player__1 } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    
    export let player: Player__1;
</script>

<div class="flex flex-col flex-grow">
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