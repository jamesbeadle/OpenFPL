<script lang="ts">
  import Layout from "../Layout.svelte";
  let activeTab: string = "proposals";

  function setActiveTab(tab: string): void {
    activeTab = tab;
  }
</script>

<!-- //TODO: List the proposals and add filters etc -->
<Layout>
  <div class="m-4">
    <div class="bg-panel rounded-md">
      <ul
        class="flex rounded-t-lg bg-light-gray border-b border-gray-700 px-4 pt-2"
      >
        <li class={`mr-4 ${activeTab === "proposals" ? "active-tab" : ""}`}>
          <button
            class={`p-2 ${
              activeTab === "proposals" ? "text-white" : "text-gray-400"
            }`}
            on:click={() => setActiveTab("details")}>Proposals</button
          >
        </li>
      </ul>

      {#if activeTab === "proposals"}
        <div class="p-4">
          <p>Proposals will appear here after the SNS decentralisation sale.</p>
          <p>
            For now the OpenFPL team will continue to add fixture data through <a
              class="text-blue-500"
              href="/fixture-validation">this</a
            > view.
          </p>
        </div>
      {/if}
    </div>
  </div>
</Layout>
