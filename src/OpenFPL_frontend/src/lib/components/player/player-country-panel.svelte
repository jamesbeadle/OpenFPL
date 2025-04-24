<script lang="ts">
    import { countryStore } from "$lib/stores/country-store";
    import { getFlagComponent } from "$lib/utils/Helpers";
    import type { Player } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    
    interface Props {
      player: Player;
    }
    let { player }: Props = $props();
</script>

<div class="flex-grow">
    <p class="content-panel-header">{player.firstName}</p>
    <p class="content-panel-stat">
      {player.lastName}
    </p>
    <p class="content-panel-header">
      <span class="flex flex-row items-center">
        {#if player.nationality > 0}
            {@const flag = getFlagComponent(player.nationality)}
            <flag class="w-12 h-12 xs:w-16 xs:h-16"></flag>
        {/if}{$countryStore.find(
          (x) => x.id == player.nationality
        )?.name}
      </span>
    </p>
  </div>