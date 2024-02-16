<script lang="ts">
  import Architecture from "$lib/components/whitepaper/architecture.svelte";
  import Dao from "$lib/components/whitepaper/dao.svelte";
  import Gameplay from "$lib/components/whitepaper/gameplay.svelte";
  import Marketing from "$lib/components/whitepaper/marketing.svelte";
  import Revenue from "$lib/components/whitepaper/revenue.svelte";
  import Roadmap from "$lib/components/whitepaper/roadmap.svelte";
  import Tokenomics from "$lib/components/whitepaper/tokenomics.svelte";
  import Vision from "$lib/components/whitepaper/vision.svelte";
  import Layout from "../Layout.svelte";
  let activeTab: string = "vision";

  function setActiveTab(tab: string): void {
    activeTab = tab;
  }
</script>

<Layout>
  <div class="bg-panel mt-4">
    <h1 class="p-4 mx-1 default-header">OpenFPL Whitepaper</h1>
    <ul
      class="flex flex-nowrap overflow-x-auto bg-light-gray border-b border-gray-700 px-4 pt-2"
    >
      <li class={`mr-4 ${activeTab === "vision" ? "active-tab" : ""}`}>
        <button
          class={`p-2 ${
            activeTab === "vision" ? "text-white" : "text-gray-400"
          }`}
          on:click={() => setActiveTab("vision")}
        >
          Vision
        </button>
      </li>
      <li class={`mr-4 ${activeTab === "gameplay" ? "active-tab" : ""}`}>
        <button
          class={`p-2 ${
            activeTab === "gameplay" ? "text-white" : "text-gray-400"
          }`}
          on:click={() => setActiveTab("gameplay")}
        >
          Gameplay
        </button>
      </li>
      <li class={`mr-4 ${activeTab === "dao" ? "active-tab" : ""}`}>
        <button
          class={`p-2 ${activeTab === "dao" ? "text-white" : "text-gray-400"}`}
          on:click={() => setActiveTab("dao")}
        >
          DAO
        </button>
      </li>
      <li class={`mr-4 ${activeTab === "tokenomics" ? "active-tab" : ""}`}>
        <button
          class={`p-2 ${
            activeTab === "tokenomics" ? "text-white" : "text-gray-400"
          }`}
          on:click={() => setActiveTab("tokenomics")}
        >
          Tokenomics
        </button>
      </li>
      <li class={`mr-4 ${activeTab === "revenue" ? "active-tab" : ""}`}>
        <button
          class={`p-2 ${
            activeTab === "revenue" ? "text-white" : "text-gray-400"
          }`}
          on:click={() => setActiveTab("revenue")}
        >
          Revenue
        </button>
      </li>
      <li class={`mr-4 ${activeTab === "marketing" ? "active-tab" : ""}`}>
        <button
          class={`p-2 ${
            activeTab === "marketing" ? "text-white" : "text-gray-400"
          }`}
          on:click={() => setActiveTab("marketing")}
        >
          Marketing
        </button>
      </li>
      <li class={`mr-4 ${activeTab === "architecture" ? "active-tab" : ""}`}>
        <button
          class={`p-2 ${
            activeTab === "architecture" ? "text-white" : "text-gray-400"
          }`}
          on:click={() => setActiveTab("architecture")}
        >
          Architecture
        </button>
      </li>
      <li class={`mr-4 ${activeTab === "roadmap" ? "active-tab" : ""}`}>
        <button
          class={`p-2 ${
            activeTab === "roadmap" ? "text-white" : "text-gray-400"
          }`}
          on:click={() => setActiveTab("roadmap")}
        >
          Roadmap
        </button>
      </li>
    </ul>

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
