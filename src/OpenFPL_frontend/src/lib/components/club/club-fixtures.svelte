<script lang="ts">
  import { onMount } from "svelte";
  
  import { storeManager } from "$lib/managers/store-manager";
  import { clubStore } from "$lib/stores/club-store";
  import { fixtureStore } from "$lib/stores/fixture-store";
  import { toastsStore } from "$lib/stores/toasts-store";

  import type { FixtureWithClubs } from "$lib/types/fixture-with-clubs";
  import { getFixturesWithTeams } from "$lib/utils/Helpers";

  import LocalSpinner from "../shared/global/local-spinner.svelte";
  import FixtureTypeFilter from "../shared/filters/fixture-type-filter.svelte";
  import ClubFixturesTable from "./club-fixtures-table.svelte";
  
  interface Props {
    clubId: number;
  }
  let { clubId }: Props = $props();

  let isLoading = $state(true);
  let selectedFixtureType = $state(-1);
  let filteredFixtures: FixtureWithClubs[] = $state([]);

  onMount(async () => {
    try {
      await storeManager.syncStores();
      let fixturesWithTeams = getFixturesWithTeams($clubStore, $fixtureStore);
      filteredFixtures = fixturesWithTeams.filter(({ fixture }) => {
          if(selectedFixtureType == -1 ) { return true; }
          if(selectedFixtureType == 0 && fixture.homeClubId === clubId) { return true; }
          if(selectedFixtureType == 1 && fixture.awayClubId === clubId) { return true; }
        } 
      ).sort((a, b) => a.fixture.gameweek - b.fixture.gameweek)
    } catch (error) {
      toastsStore.addToast({ type: 'error', message: `There was an error setting the club fixtures: ${error}`})
    } finally {
      isLoading = false;
    }
  });

</script>

{#if isLoading}
  <LocalSpinner />
{:else}
  <div class="flex flex-col">
    <FixtureTypeFilter {selectedFixtureType} />
    <ClubFixturesTable {filteredFixtures} />
  </div>
{/if}