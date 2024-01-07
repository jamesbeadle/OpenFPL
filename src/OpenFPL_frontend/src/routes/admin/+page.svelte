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
    import RevaluePlayerUp from "$lib/components/governance/player/revalue-player-up.svelte";
    import RevaluePlayerDown from "$lib/components/governance/player/revalue-player-down.svelte";
    import RescheduleFixture from "$lib/components/governance/fixture/reschedule-fixture.svelte";
    import LoanPlayer from "$lib/components/governance/player/loan-player.svelte";
    import TransferPlayer from "$lib/components/governance/player/transfer-player.svelte";
    import RecallPlayer from "$lib/components/governance/player/recall-player.svelte";
    import CreatePlayer from "$lib/components/governance/player/create-player.svelte";
    import UpdatePlayer from "$lib/components/governance/player/update-player.svelte";
    import SetPlayerInjury from "$lib/components/governance/player/set-player-injury.svelte";
    import RetirePlayer from "$lib/components/governance/player/retire-player.svelte";
    import UnretirePlayer from "$lib/components/governance/player/unretire-player.svelte";
    import PromoteFormerClub from "$lib/components/governance/club/promote-former-club.svelte";
    import PromoteNewClub from "$lib/components/governance/club/promote-new-club.svelte";
    import UpdateClub from "$lib/components/governance/club/update-club.svelte";

  let showSystemStateModal: boolean = false;
  let showSnapshotModal: boolean = false;

  let activeTab: string = "canisters";
  let isLoading = true;

  let showRevaluePlayerUpModal: boolean = false;
  let showRevaluePlayerDownModal: boolean = false;
  let showAddInitialFixturesModal: boolean = false;
  let showRescheduleFixtureModal: boolean = false;
  let showLoanPlayerModal: boolean = false;
  let showTransferPlayerModal: boolean = false;
  let showRecallPlayerModal: boolean = false;
  let showCreatePlayerModal: boolean = false;
  let showUpdatePlayerModal: boolean = false;
  let showSetPlayerInjuryModal: boolean = false;
  let showRetirePlayerModal: boolean = false;
  let showUnretirePlayerModal: boolean = false;
  let showPromoteFormerClubModal: boolean = false;
  let showPromoteNewClubModal: boolean = false;
  let showUpdateClubModal: boolean = false;

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

  function displayRevaluePlayerUpModal(): void {
    showRevaluePlayerUpModal = true;
  }

  function hideRevaluePlayerUpModal(): void {
    showRevaluePlayerUpModal = false;
  }

  function displayRevaluePlayerDownModal(): void {
    showRevaluePlayerDownModal = true;
  }

  function hideRevaluePlayerDownModal(): void {
    showRevaluePlayerDownModal = false;
  }

  function displayAddInitialFixturesModal(): void {
    showAddInitialFixturesModal = true;
  }

  function hideAddInitialFixturesModal(): void {
    showAddInitialFixturesModal = false;
  }

  function displayRescheduleFixtureModal(): void {
    showRescheduleFixtureModal = true;
  }

  function hideRescehduleFixturesModal(): void {
    showRescheduleFixtureModal = false;
  }

  function displayLoanPlayerModal(): void {
    showLoanPlayerModal = true;
  }

  function hideLoanPlayerModal(): void {
    showLoanPlayerModal = false;
  }

  function displayTransferPlayerModal(): void {
    showTransferPlayerModal = true;
  }

  function hideTransferPlayerModal(): void {
    showTransferPlayerModal = false;
  }

  function displayRecallPlayerModal(): void {
    showRecallPlayerModal = true;
  }

  function hideRecallPlayerModal(): void {
    showRecallPlayerModal = false;
  }

  function displayCreatePlayerModal(): void {
    showCreatePlayerModal = true;
  }

  function hideCreatePlayerModal(): void {
    showCreatePlayerModal = false;
  }

  function displayUpdatePlayerModal(): void {
    showUpdatePlayerModal = true;
  }

  function hideUpdatePlayerModal(): void {
    showUpdatePlayerModal = false;
  }

  function displaySetPlayerInjuryModal(): void {
    showSetPlayerInjuryModal = true;
  }

  function hideSetPlayerInjuryModal(): void {
    showSetPlayerInjuryModal = false;
  }

  function displayRetirePlayerModal(): void {
    showRetirePlayerModal = true;
  }

  function hideRetirePlayerModal(): void {
    showRetirePlayerModal = false;
  }

  function displayUnretirePlayerModal(): void {
    showUnretirePlayerModal = true;
  }

  function hideUnretirePlayerModal(): void {
    showUnretirePlayerModal = false;
  }

  function displayPromoteFormerClubModal(): void {
    showPromoteFormerClubModal = true;
  }

  function hidePromoteFormerClubModal(): void {
    showPromoteFormerClubModal = false;
  }

  function displayPromoteNewClubModal(): void {
    showPromoteNewClubModal = true;
  }

  function hidePromoteNewClubModal(): void {
    showPromoteNewClubModal = false;
  }

  function displayUpdateClubModal(): void {
    showUpdateClubModal = true;
  }

  function hideUpdateClubModal(): void {
    showUpdateClubModal = false;
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
    
    <RevaluePlayerUp
      visible={showRevaluePlayerUpModal}
      cancelModal={hideRevaluePlayerUpModal} 
    />
    <RevaluePlayerDown
      visible={showRevaluePlayerDownModal}
      cancelModal={hideRevaluePlayerDownModal}
     />
    <AddInitialFixtures
      visible={showAddInitialFixturesModal}
      cancelModal={hideAddInitialFixturesModal}
    />
  
    <RescheduleFixture
      visible={showRescheduleFixtureModal}
      cancelModal={hideRescehduleFixturesModal}
    />
    <LoanPlayer
      visible={showLoanPlayerModal}
      cancelModal={hideLoanPlayerModal}
    />
    <TransferPlayer
      visible={showTransferPlayerModal}
      cancelModal={hideTransferPlayerModal}
    />
    <RecallPlayer
      visible={showRecallPlayerModal}
      cancelModal={hideRecallPlayerModal}
    />
    <CreatePlayer
      visible={showCreatePlayerModal}
      cancelModal={hideCreatePlayerModal}
    />
    <UpdatePlayer
      visible={showUpdatePlayerModal}
      cancelModal={hideUpdatePlayerModal}
    />
    <SetPlayerInjury
      visible={showSetPlayerInjuryModal}
      cancelModal={hideSetPlayerInjuryModal}
    />
    <RetirePlayer
      visible={showRetirePlayerModal}
      cancelModal={hideRetirePlayerModal}
    />
    <UnretirePlayer
      visible={showUnretirePlayerModal}
      cancelModal={hideUnretirePlayerModal}
    />
    <PromoteFormerClub
      visible={showPromoteFormerClubModal}
      cancelModal={hidePromoteFormerClubModal}
    />
    <PromoteNewClub
      visible={showPromoteNewClubModal}
      cancelModal={hidePromoteNewClubModal}
    />
    <UpdateClub
      visible={showUpdateClubModal}
      cancelModal={hideUpdateClubModal}
    />

    <div class="m-4">
      <div class="bg-panel rounded-md">
        <div class="flex flex-col p-4">
          <h1 class="text-xl">OpenFPL Admin</h1>
          <p class="mt-2">This view is for testing purposes only.</p>
        </div>

        <p class="mt-2 mx-4">Just in case:</p>
        <div class="flex flex-wrap p-4">
          <button
            class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1"
            on:click={displaySnapshotModal}>System Status</button
          >
          <button
            class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1"
            on:click={displaySnapshotModal}>Snapshot Fantasy Teams</button
          >
        </div>

        <p class="mt-2 mx-4">OpenFPL Proposals:</p>
        <div class="flex flex-wrap p-4">
          <button
            class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1"
            on:click={displayAddInitialFixturesModal}
            >Revalue Player Up</button
          >
          <button
            class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1"
            on:click={displayAddInitialFixturesModal}
            >Revalue Player Down</button
          >
          <button
            class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1"
            on:click={displayAddInitialFixturesModal}
            >Submit Fixture Data</button
          >
          <button
            class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1"
            on:click={displayAddInitialFixturesModal}
            >Add Initial Fixtures</button
          >
          <button
            class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1"
            on:click={displayAddInitialFixturesModal}
            >Reschedule Fixtures</button
          >
          <button
            class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1"
            on:click={displayAddInitialFixturesModal}
            >Loan Player</button
          >
          <button
            class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1"
            on:click={displayAddInitialFixturesModal}
            >Transfer Player</button
          >
          <button
            class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1"
            on:click={displayAddInitialFixturesModal}
            >Recall Player</button
          >
          <button
            class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1"
            on:click={displayAddInitialFixturesModal}
            >Create Player</button
          >
          <button
            class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1"
            on:click={displayAddInitialFixturesModal}
            >Update Player</button
          >
          <button
            class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1"
            on:click={displayAddInitialFixturesModal}
            >Set Player Injury</button
          >
          <button
            class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1"
            on:click={displayAddInitialFixturesModal}
            >Retire Player</button
          >
          <button
            class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1"
            on:click={displayAddInitialFixturesModal}
            >Unretire Player</button
          >
          <button
            class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1"
            on:click={displayAddInitialFixturesModal}
            >Promote Former Club</button
          >
          <button
            class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1"
            on:click={displayAddInitialFixturesModal}
            >Promote New Club</button
          >
          <button
            class="rounded fpl-button px-3 sm:px-2 px-3 py-1 my-1"
            on:click={displayAddInitialFixturesModal}
            >Update Club</button
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
