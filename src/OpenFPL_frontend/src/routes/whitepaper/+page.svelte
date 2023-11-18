<script lang="ts">
    import ManagerGameweeks from "$lib/components/manager-gameweeks.svelte";
    import Architecture from "$lib/components/whitepaper/architecture.svelte";
    import Dao from "$lib/components/whitepaper/dao.svelte";
    import Gameplay from "$lib/components/whitepaper/gameplay.svelte";
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
    <div class="m-4">
        <div class="bg-panel rounded-lg m-4 p-4">
            <h1 class="p-4 mx-1 text-2xl">OpenFPL Whitepaper</h1>
            <div class="bg-panel rounded-lg m-4">
                <ul class="flex rounded-lg bg-light-gray px-4 pt-2">
                  <li
                    class={`mr-4 text-xs md:text-lg ${
                      activeTab === "vision" ? "active-tab" : ""
                    }`}
                  >
                    <button
                      class={`p-2 ${
                        activeTab === "vision" ? "text-white" : "text-gray-400"
                      }`}
                      on:click={() => setActiveTab("vision")}
                    >
                      Vision
                    </button>
                  </li>
                  <li
                    class={`mr-4 text-xs md:text-lg ${
                      activeTab === "gameplay" ? "active-tab" : ""
                    }`}
                  >
                    <button
                      class={`p-2 ${
                        activeTab === "gameplay" ? "text-white" : "text-gray-400"
                      }`}
                      on:click={() => setActiveTab("gameplay")}
                    >
                      Gameplay
                    </button>
                  </li>
                  <li
                    class={`mr-4 text-xs md:text-lg ${
                      activeTab === "roadmap" ? "active-tab" : ""
                    }`}
                  >
                    <button
                      class={`p-2 ${
                        activeTab === "roadmap" ? "text-white" : "text-gray-400"
                      }`}
                      on:click={() => setActiveTab("roadmap")}
                    >
                      Roadmap
                    </button>
                  </li>
                  <li
                    class={`mr-4 text-xs md:text-lg ${
                      activeTab === "roadmap" ? "active-tab" : ""
                    }`}
                  >
                    <button
                      class={`p-2 ${
                        activeTab === "marketing" ? "text-white" : "text-gray-400"
                      }`}
                      on:click={() => setActiveTab("marketing")}
                    >
                      Marketing
                    </button>
                  </li>
                  <li
                    class={`mr-4 text-xs md:text-lg ${
                      activeTab === "revenue" ? "active-tab" : ""
                    }`}
                  >
                    <button
                      class={`p-2 ${
                        activeTab === "revenue" ? "text-white" : "text-gray-400"
                      }`}
                      on:click={() => setActiveTab("revenue")}
                    >
                      Revenue
                    </button>
                  </li>
                  <li
                    class={`mr-4 text-xs md:text-lg ${
                      activeTab === "dao" ? "active-tab" : ""
                    }`}
                  >
                    <button
                      class={`p-2 ${
                        activeTab === "dao" ? "text-white" : "text-gray-400"
                      }`}
                      on:click={() => setActiveTab("dao")}
                    >
                      DAO
                    </button>
                  </li>
                  <li
                    class={`mr-4 text-xs md:text-lg ${
                      activeTab === "tokenomics" ? "active-tab" : ""
                    }`}
                  >
                    <button
                      class={`p-2 ${
                        activeTab === "tokenomics" ? "text-white" : "text-gray-400"
                      }`}
                      on:click={() => setActiveTab("tokenomics")}
                    >
                      Tokenomics
                    </button>
                  </li>
                  <li
                    class={`mr-4 text-xs md:text-lg ${
                      activeTab === "architecture" ? "active-tab" : ""
                    }`}
                  >
                    <button
                      class={`p-2 ${
                        activeTab === "architecture" ? "text-white" : "text-gray-400"
                      }`}
                      on:click={() => setActiveTab("architecture")}
                    >
                      Architecture
                    </button>
                  </li>
                </ul>
          
                {#if activeTab === "vision"}
                  <Vision />
                {:else if activeTab === "gameplay"}
                  <Gameplay />
                {:else if activeTab === "roadmap"}
                    <Roadmap />
                {:else if activeTab === "marketing"}
                    <ManagerGameweeks />
                {:else if activeTab === "revenue"}
                    <Revenue />
                {:else if activeTab === "dao"}
                    <Dao />
                {:else if activeTab === "tokenomics"}
                    <Tokenomics />
                {:else if activeTab === "architecture"}
                    <Architecture />
                {/if}
              </div>
        </div>
    </div>  
</Layout>   
