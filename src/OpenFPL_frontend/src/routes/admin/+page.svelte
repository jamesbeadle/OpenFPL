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
  import AddFixtureData from "$lib/components/governance/fixture/add-fixture-data.svelte";
  import { ActorFactory } from "../../utils/ActorFactory";
  import { idlFactory } from "../../../../declarations/OpenFPL_backend";
  import { isError } from "$lib/utils/Helpers";
  import { toastsError, toastsShow } from "$lib/stores/toasts-store";

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
  let showAddFixtureDataModal: boolean = false;

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

  function displayAddFixtureDataModal(): void {
    showAddFixtureDataModal = true;
  }

  function hideAddFixtureDataModal(): void {
    showAddFixtureDataModal = false;
  }

  async function init() {
    isLoading = true;

    localStorage.clear();
    let actor: any = ActorFactory.createActor(
      idlFactory,
      process.env.OPENFPL_BACKEND_CANISTER_ID
    );
    let result = await actor.init();

    if (isError(result)) {
      toastsError({
        msg: { text: "Error submitting proposal." },
      });
      isLoading = false;
    }

    toastsShow({
      text: "Application Initialised.",
      level: "success",
      duration: 2000,
    });

    isLoading = false;
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
      closeModal={hideRevaluePlayerUpModal}
    />
    <RevaluePlayerDown
      visible={showRevaluePlayerDownModal}
      closeModal={hideRevaluePlayerDownModal}
    />
    <AddInitialFixtures
      visible={showAddInitialFixturesModal}
      closeModal={hideAddInitialFixturesModal}
    />

    <RescheduleFixture
      visible={showRescheduleFixtureModal}
      closeModal={hideRescehduleFixturesModal}
    />
    <LoanPlayer
      visible={showLoanPlayerModal}
      closeModal={hideLoanPlayerModal}
    />
    <TransferPlayer
      visible={showTransferPlayerModal}
      closeModal={hideTransferPlayerModal}
    />
    <RecallPlayer
      visible={showRecallPlayerModal}
      closeModal={hideRecallPlayerModal}
    />
    <CreatePlayer
      visible={showCreatePlayerModal}
      closeModal={hideCreatePlayerModal}
    />
    <UpdatePlayer
      visible={showUpdatePlayerModal}
      closeModal={hideUpdatePlayerModal}
    />
    <SetPlayerInjury
      visible={showSetPlayerInjuryModal}
      closeModal={hideSetPlayerInjuryModal}
    />
    <RetirePlayer
      visible={showRetirePlayerModal}
      closeModal={hideRetirePlayerModal}
    />
    <UnretirePlayer
      visible={showUnretirePlayerModal}
      closeModal={hideUnretirePlayerModal}
    />
    <PromoteFormerClub
      visible={showPromoteFormerClubModal}
      closeModal={hidePromoteFormerClubModal}
    />
    <PromoteNewClub
      visible={showPromoteNewClubModal}
      closeModal={hidePromoteNewClubModal}
    />
    <UpdateClub
      visible={showUpdateClubModal}
      closeModal={hideUpdateClubModal}
    />
    <AddFixtureData
      visible={showAddFixtureDataModal}
      closeModal={hideAddFixtureDataModal}
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
            on:click={init}>Init</button
          >
          <button
            class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1"
            on:click={displaySystemStateModal}>System Status</button
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
            on:click={displayRevaluePlayerUpModal}>Revalue Player Up</button
          >
          <button
            class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1"
            on:click={displayRevaluePlayerDownModal}>Revalue Player Down</button
          >
          <button
            class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1"
            on:click={displayAddInitialFixturesModal}
            >Add Initial Fixtures</button
          >
          <button
            class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1"
            on:click={displayRescheduleFixtureModal}>Reschedule Fixtures</button
          >
          <button
            class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1"
            on:click={displayLoanPlayerModal}>Loan Player</button
          >
          <button
            class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1"
            on:click={displayTransferPlayerModal}>Transfer Player</button
          >
          <button
            class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1"
            on:click={displayRecallPlayerModal}>Recall Player</button
          >
          <button
            class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1"
            on:click={displayCreatePlayerModal}>Create Player</button
          >
          <button
            class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1"
            on:click={displayUpdatePlayerModal}>Update Player</button
          >
          <button
            class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1"
            on:click={displaySetPlayerInjuryModal}>Set Player Injury</button
          >
          <button
            class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1"
            on:click={displayRetirePlayerModal}>Retire Player</button
          >
          <button
            class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1"
            on:click={displayUnretirePlayerModal}>Unretire Player</button
          >
          <button
            class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1"
            on:click={displayPromoteFormerClubModal}>Promote Former Club</button
          >
          <button
            class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1"
            on:click={displayPromoteNewClubModal}>Promote New Club</button
          >
          <button
            class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1"
            on:click={displayUpdateClubModal}>Update Club</button
          >
          <button
            class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1"
            on:click={displayAddFixtureDataModal}>Add Fixture Data</button
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
