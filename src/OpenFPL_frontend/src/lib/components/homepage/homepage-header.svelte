<script lang="ts">
    import ContentPanel from "../shared/panels/content-panel.svelte";
    import PageHeader from "../shared/panels/page-header.svelte";
    import HomepageGameweekPanel from "./homepage-gameweek-panel.svelte";
    import HomepageNextGamePanel from "./homepage-next-game-panel.svelte";

    export let seasonName: string;
</script>

<PageHeader>
  <ContentPanel>
    <HomepageGameweekPanel {seasonName}/>
  </ContentPanel>
  <ContentPanel>
    <HomepageNextGamePanel />
  </ContentPanel>
</PageHeader>