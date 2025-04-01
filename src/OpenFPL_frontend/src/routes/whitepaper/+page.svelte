<script lang="ts">

  import Layout from "../+layout.svelte";
  import Architecture from "$lib/components/whitepaper/architecture.svelte";
  import Dao from "$lib/components/whitepaper/dao.svelte";
  import Gameplay from "$lib/components/whitepaper/gameplay.svelte";
  import Marketing from "$lib/components/whitepaper/marketing.svelte";
  import Revenue from "$lib/components/whitepaper/revenue.svelte";
  import Roadmap from "$lib/components/whitepaper/roadmap.svelte";
  import Tokenomics from "$lib/components/whitepaper/tokenomics.svelte";
  import Vision from "$lib/components/whitepaper/vision.svelte";
    import TabContainer from "$lib/components/shared/tab-container.svelte";

  let activeTab: string = "vision";

  const tabs = [
    { id: "vision", label: "Vision", authOnly: false },
    { id: "gameplay", label: "Gameplay", authOnly: false },
    { id: "dao", label: "DAO", authOnly: false },
    { id: "tokenomics", label: "Tokenomics", authOnly: false },
    { id: "revenue", label: "Revenue", authOnly: false },
    { id: "marketing", label: "Marketing", authOnly: false },
    { id: "architecture", label: "Architecture", authOnly: false },
    { id: "roadmap", label: "Roadmap", authOnly: false },
  ];

  function setActiveTab(tab: string): void {
    activeTab = tab;
  }

</script>

<Layout>
  <div class="bg-panel mt-4">
    <h1 class="p-4 mx-1 default-header">OpenFPL Whitepaper</h1>

    <TabContainer {tabs} {activeTab} {setActiveTab} isLoggedIn={false}  />

    {#if activeTab === "vision"}
      <Vision />
    {:else if activeTab === "gameplay"}
      <Gameplay />
    {:else if activeTab === "roadmap"}
      <Roadmap />
    {:else if activeTab === "revenue"}
      <Revenue />
    {:else if activeTab === "marketing"}
      <Marketing />
    {:else if activeTab === "dao"}
      <Dao />
    {:else if activeTab === "tokenomics"}
      <Tokenomics />
    {:else if activeTab === "architecture"}
      <Architecture />
    {/if}
  </div>
</Layout>
