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
          {@const FlagComponent = getFlagComponent(player.nationality)}
          <FlagComponent className="w-4 xs:w-6 mx-1" size="16" ariaLabel={`flag of ${player.nationality}`} role='img' />
        {/if}{$countryStore.find(
          (x) => x.id == player.nationality
        )?.name}
      </span>
    </p>
  </div>