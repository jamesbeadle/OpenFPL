<script lang="ts">
    import { calculateAgeFromNanoseconds, convertDateToReadable } from "$lib/utils/helpers";
    import type { PlayerDTO } from "../../../../../external_declarations/data_canister/data_canister.did";

    export let player: PlayerDTO;
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