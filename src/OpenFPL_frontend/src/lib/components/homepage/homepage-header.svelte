<script lang="ts">
    import ContentPanel from "../shared/panels/content-panel.svelte";
    import PageHeader from "../shared/panels/page-header.svelte";
    import HomepageGameweekPanel from "./homepage-gameweek-panel.svelte";
    import HomepageNextGamePanel from "./homepage-next-game-panel.svelte";

    export let seasonId: number;
    export let seasonName: string;
    export let gameweek: number;
</script>

<PageHeader>
  <ContentPanel>
    <HomepageGameweekPanel {seasonId} {seasonName} {gameweek}/>
  </ContentPanel>
  <ContentPanel>
    <HomepageNextGamePanel />
  </ContentPanel>
</PageHeader>