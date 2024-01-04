<script lang="ts">
  import { onMount } from "svelte";
  import Layout from "../Layout.svelte";
  import AdminCanisters from "$lib/components/admin/admin-canisters.svelte";
  import AdminFixtures from "$lib/components/admin/admin-fixtures.svelte";
  import AdminTimers from "$lib/components/admin/admin-timers.svelte";
  import SystemStateModal from "$lib/components/admin/system-state-modal.svelte";
  import SnapshotFantasyTeams from "$lib/components/admin/snapshot-fantasy-teams.svelte";
  import { Spinner } from "@dfinity/gix-components";
  import AdminManagers from "$lib/components/admin/admin-managers.svelte";
    import AddInitialFixtures from "$lib/components/governance/fixture/add-initial-fixtures.svelte";

  let showSystemStateModal: boolean = false;
  let showSnapshotModal: boolean = false;
  let showAddInitialFixturesModal: boolean = false; 

  let activeTab: string = "canisters";
  let isLoading = true;

  //proposal types
  /*
  validateRevaluePlayerUp(revaluePlayerUpDTO : DTOs.RevaluePlayerUpDTO)
validateRevaluePlayerDown(revaluePlayerDownDTO : DTOs.RevaluePlayerDownDTO)
validateSubmitFixtureData(submitFixtureData : DTOs.SubmitFixtureDataDTO)
validateAddInitialFixtures(addInitialFixturesDTO : DTOs.AddInitialFixturesDTO)
validateRescheduleFixture(rescheduleFixtureDTO : DTOs.RescheduleFixtureDTO)
validateLoanPlayer(loanPlayerDTO : DTOs.LoanPlayerDTO)
validateTransferPlayer(transferPlayerDTO : DTOs.TransferPlayerDTO)
validateRecallPlayer(recallPlayerDTO : DTOs.RecallPlayerDTO)
validateCreatePlayer(createPlayerDTO : DTOs.CreatePlayerDTO)
validateUpdatePlayer(updatePlayerDTO : DTOs.UpdatePlayerDTO)
validateSetPlayerInjury(setPlayerInjuryDTO : DTOs.SetPlayerInjuryDTO)
validateRetirePlayer(retirePlayerDTO : DTOs.RetirePlayerDTO)
validateUnretirePlayer(unretirePlayerDTO : DTOs.UnretirePlayerDTO)
validatePromoteFormerClub(promoteFormerClubDTO : DTOs.PromoteFormerClubDTO)
validatePromoteNewClub(promoteNewClubDTO : DTOs.PromoteNewClubDTO)
validateUpdateClub(updateClubDTO : DTOs.UpdateClubDTO)
*/

  onMount(async () => {
    isLoading = false;
  });

  function displaySystemStateModal(): void {
    showSystemStateModal = true;
  }

  function setActiveTab(tab: string): void {
    activeTab = tab;
  }

  function hideSystemStateModal(): void {
    showSystemStateModal = false;
  }

  function displaySnapshotModal(): void {
    showSnapshotModal = true;
  }

  function hideSnapshotModal(): void {
    showSnapshotModal = false;
  }

  function displayAddInitialFixturesModal(): void {
    showAddInitialFixturesModal = true;
  }

  function hideAddInitialFixturesModal(): void {
    showAddInitialFixturesModal = false;
  }

</script>

<Layout>
  {#if isLoading}
    <Spinner />
  {:else}
    <SystemStateModal
      visible={showSystemStateModal}
      closeModal={hideSystemStateModal}
      cancelModal={hideSystemStateModal}
    />
    <SnapshotFantasyTeams
      visible={showSnapshotModal}
      closeModal={hideSnapshotModal}
      cancelModal={hideSnapshotModal}
    />
    <AddInitialFixtures
      visible={showAddInitialFixturesModal}
      cancelModal={hideAddInitialFixturesModal}
    />
    <div class="m-4">
      <div class="bg-panel rounded-md">
        <div class="flex flex-col p-4">
          <h1 class="text-xl">OpenFPL Admin</h1>
          <p class="mt-2">This view is for testing purposes only.</p>
        </div>

        <div class="flex flex-row p-4 space-x-4">
          <button
            class="rounded fpl-button px-3 sm:px-2 px-3 py-1"
            on:click={displaySystemStateModal}>System Status</button
          >
          <button
            class="rounded fpl-button px-3 sm:px-2 px-3 py-1"
            on:click={displaySnapshotModal}>Snapshot Fantasy Teams</button
          >
          <button
            class="rounded fpl-button px-3 sm:px-2 px-3 py-1"
            on:click={displayAddInitialFixturesModal}>Add Initial Fixtures</button
          >
        </div>

        <ul
          class="flex rounded-t-lg bg-light-gray px-4 pt-2 border-b border-gray-700"
        >
          <li class={`mr-4 ${activeTab === "canisters" ? "active-tab" : ""}`}>
            <button
              class={`p-2 ${
                activeTab === "canisters" ? "text-white" : "text-gray-400"
              }`}
              on:click={() => setActiveTab("canisters")}>Canisters</button
            >
          </li>
          <li class={`mr-4 ${activeTab === "timers" ? "active-tab" : ""}`}>
            <button
              class={`p-2 ${
                activeTab === "timers" ? "text-white" : "text-gray-400"
              }`}
              on:click={() => setActiveTab("timers")}>Timers</button
            >
          </li>
          <li class={`mr-4 ${activeTab === "fixtures" ? "active-tab" : ""}`}>
            <button
              class={`p-2 ${
                activeTab === "fixtures" ? "text-white" : "text-gray-400"
              }`}
              on:click={() => setActiveTab("fixtures")}>Fixtures</button
            >
          </li>
          <li class={`mr-4 ${activeTab === "managers" ? "active-tab" : ""}`}>
            <button
              class={`p-2 ${
                activeTab === "managers" ? "text-white" : "text-gray-400"
              }`}
              on:click={() => setActiveTab("managers")}>Managers</button
            >
          </li>
        </ul>

        {#if activeTab === "canisters"}
          <AdminCanisters />
        {:else if activeTab === "timers"}
          <AdminTimers />
        {:else if activeTab === "fixtures"}
          <AdminFixtures />
        {:else if activeTab === "managers"}
          <AdminManagers />
        {/if}
      </div>
    </div>
  {/if}
</Layout>
