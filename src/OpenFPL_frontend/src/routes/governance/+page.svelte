<script lang="ts">
  import Layout from "../Layout.svelte";
  let activeTab: string = "proposals";

  function setActiveTab(tab: string): void {
    activeTab = tab;
  }
</script>

<Layout>
  <div class="m-4">
    <div class="bg-panel rounded-lg m-4">
      <ul class="flex rounded-lg bg-light-gray px-4 pt-2">
        <li class={`mr-4 text-xs md:text-lg ${ activeTab === "proposals" ? "active-tab" : ""
          }`}
        >
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
