<script lang="ts">
    import { countryStore } from "$lib/stores/country-store";
    import { getFlagComponent } from "$lib/utils/helpers";
    import type { PlayerDTO } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

    export let player: PlayerDTO;
</script>

<div class="flex-grow">
    <p class="content-panel-header">{player.firstName}</p>
    <p class="content-panel-stat">
      {player.lastName}
    </p>
    <p class="content-panel-header">
      <span class="flex flex-row items-center">
        <svelte:component
          this={getFlagComponent(player.nationality ?? 0)}
          class="w-4 h-4 mr-1"
          size="100"
        />{$countryStore.find(
          (x) => x.id == player.nationality
        )?.name}
      </span>
    </p>
  </div>