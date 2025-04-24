<script lang="ts">
  import { onMount } from "svelte";
  
  import { seasonStore } from "$lib/stores/season-store";
  import { leagueStore } from "$lib/stores/league-store";
  import { globalDataLoaded } from "$lib/managers/store-manager";
  import ContentPanel from "../../shared/panels/content-panel.svelte";
  import PageHeader from "../../shared/panels/page-header.svelte";
  import HomepageGameweekPanel from "./homepage-gameweek-panel.svelte";
  import HomepageNextGamePanel from "./homepage-next-game-panel.svelte";

    let isLoading = $state(true);
    let seasonName = $state("");

    onMount(() => {
    if(globalDataLoaded){
        loadCurrentStatusDetails();
        isLoading = false;
      }
    });

    async function loadCurrentStatusDetails(){
      seasonName = await seasonStore.getSeasonName($leagueStore?.activeSeasonId ?? 1) ?? "-";
    }
</script>

<PageHeader>
  <ContentPanel>
    <HomepageGameweekPanel {seasonName}/>
  </ContentPanel>
  <ContentPanel>
    <HomepageNextGamePanel />
  </ContentPanel>
</PageHeader>