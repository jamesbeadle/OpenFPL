<script lang="ts">
  import Layout from "../Layout.svelte";

  import AddInitialFixtures from "$lib/components/governance/fixture/add-initial-fixtures.svelte";
  import RevaluePlayerUp from "$lib/components/governance/player/revalue-player-up.svelte";
  import RevaluePlayerDown from "$lib/components/governance/player/revalue-player-down.svelte";
  import MoveFixture from "$lib/components/governance/fixture/move-fixture.svelte";
  import PostponeFixture from "$lib/components/governance/fixture/postpone-fixture.svelte";
  import RescheduleFixture from "$lib/components/governance/fixture/reschedule-fixture.svelte";
  import LoanPlayer from "$lib/components/governance/player/loan-player.svelte";
  import TransferPlayer from "$lib/components/governance/player/transfer-player.svelte";
  import RecallPlayer from "$lib/components/governance/player/recall-player.svelte";
  import CreatePlayer from "$lib/components/governance/player/create-player.svelte";
  import UpdatePlayer from "$lib/components/governance/player/update-player.svelte";
  import SetPlayerInjury from "$lib/components/governance/player/set-player-injury.svelte";
  import RetirePlayer from "$lib/components/governance/player/retire-player.svelte";
  import UnretirePlayer from "$lib/components/governance/player/unretire-player.svelte";
  import PromoteNewClub from "$lib/components/governance/club/promote-new-club.svelte";
  import UpdateClub from "$lib/components/governance/club/update-club.svelte";
  import AddFixtureData from "$lib/components/governance/fixture/add-fixture-data.svelte";
  import { ActorFactory } from "../../utils/ActorFactory";
  import { idlFactory } from "../../../../declarations/OpenWSL_backend";
  import { isError } from "$lib/utils/helpers";
  import { toastsError, toastsShow } from "$lib/stores/toasts-store";
  import PlayerCaptainIcon from "$lib/icons/PlayerCaptainIcon.svelte";

  let showRevaluePlayerUpModal: boolean = false;
  let showRevaluePlayerDownModal: boolean = false;
  let showAddInitialFixturesModal: boolean = false;
  let showMoveFixtureModal: boolean = false;
  let showPostponeFixtureModal: boolean = false;
  let showRescheduleFixtureModal: boolean = false;
  let showLoanPlayerModal: boolean = false;
  let showTransferPlayerModal: boolean = false;
  let showRecallPlayerModal: boolean = false;
  let showCreatePlayerModal: boolean = false;
  let showUpdatePlayerModal: boolean = false;
  let showSetPlayerInjuryModal: boolean = false;
  let showRetirePlayerModal: boolean = false;
  let showUnretirePlayerModal: boolean = false;
  let showPromoteNewClubModal: boolean = false;
  let showUpdateClubModal: boolean = false;
  let showAddFixtureDataModal: boolean = false;

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

  function displayMoveFixtureModal(): void {
    showMoveFixtureModal = true;
  }

  function hideMoveFixturesModal(): void {
    showMoveFixtureModal = false;
  }

  function displayPostponeFixtureModal(): void {
    showPostponeFixtureModal = true;
  }

  function hidePostponeFixturesModal(): void {
    showPostponeFixtureModal = false;
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
</script>

<Layout>
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
  <MoveFixture
    visible={showMoveFixtureModal}
    closeModal={hideMoveFixturesModal}
  />
  <PostponeFixture
    visible={showPostponeFixtureModal}
    closeModal={hidePostponeFixturesModal}
  />
  <RescheduleFixture
    visible={showRescheduleFixtureModal}
    closeModal={hideRescehduleFixturesModal}
  />
  <LoanPlayer visible={showLoanPlayerModal} closeModal={hideLoanPlayerModal} />
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
  <PromoteNewClub
    visible={showPromoteNewClubModal}
    closeModal={hidePromoteNewClubModal}
  />
  <UpdateClub visible={showUpdateClubModal} closeModal={hideUpdateClubModal} />
  <AddFixtureData
    visible={showAddFixtureDataModal}
    closeModal={hideAddFixtureDataModal}
  />
  <div class="m-4">
    <div class="bg-panel rounded-md">
      <ul
        class="flex rounded-t-lg bg-light-gray border-b border-gray-700 px-4 pt-2"
      >
        <li class="mr-4 active-tab">
          <button class="text-white">Raise Proposal</button>
        </li>
      </ul>

      <p class="m-4">Player proposals</p>

      <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mt-4 mx-4">
        <div
          class="flex flex-col items-center bg-gray-700 rounded shadow p-4 w-full"
        >
          <div class="flex items-center w-full">
            <button
              class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1 w-full"
              on:click={displayRevaluePlayerUpModal}>Revalue Player Up</button
            >
          </div>
        </div>
        <div
          class="flex flex-col items-center bg-gray-700 rounded shadow p-4 w-full"
        >
          <div class="flex items-center space-x-4 w-full">
            <button
              class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1 w-full"
              on:click={displayRevaluePlayerDownModal}
              >Revalue Player Down</button
            >
          </div>
        </div>
        <div
          class="flex flex-col items-center bg-gray-700 rounded shadow p-4 w-full"
        >
          <div class="flex items-center space-x-4 w-full">
            <button
              class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1 w-full"
              on:click={displayLoanPlayerModal}>Loan Player</button
            >
          </div>
        </div>
        <div
          class="flex flex-col items-center bg-gray-700 rounded shadow p-4 w-full"
        >
          <div class="flex items-center space-x-4 w-full">
            <button
              class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1 w-full"
              on:click={displayTransferPlayerModal}>Transfer Player</button
            >
          </div>
        </div>
        <div
          class="flex flex-col items-center bg-gray-700 rounded shadow p-4 w-full"
        >
          <div class="flex items-center space-x-4 w-full">
            <button
              class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1 w-full"
              on:click={displayRecallPlayerModal}>Recall Player</button
            >
          </div>
        </div>
        <div
          class="flex flex-col items-center bg-gray-700 rounded shadow p-4 w-full"
        >
          <div class="flex items-center space-x-4 w-full">
            <button
              class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1 w-full"
              on:click={displayCreatePlayerModal}>Create Player</button
            >
          </div>
        </div>
        <div
          class="flex flex-col items-center bg-gray-700 rounded shadow p-4 w-full"
        >
          <div class="flex items-center space-x-4 w-full">
            <button
              class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1 w-full"
              on:click={displayUpdatePlayerModal}>Update Player</button
            >
          </div>
        </div>
        <div
          class="flex flex-col items-center bg-gray-700 rounded shadow p-4 w-full"
        >
          <div class="flex items-center space-x-4 w-full">
            <button
              class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1 w-full"
              on:click={displaySetPlayerInjuryModal}>Set Player Injury</button
            >
          </div>
        </div>
        <div
          class="flex flex-col items-center bg-gray-700 rounded shadow p-4 w-full"
        >
          <div class="flex items-center space-x-4 w-full">
            <button
              class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1 w-full"
              on:click={displayRetirePlayerModal}>Retire Player</button
            >
          </div>
        </div>
        <div
          class="flex flex-col items-center bg-gray-700 rounded shadow p-4 w-full"
        >
          <div class="flex items-center space-x-4 w-full">
            <button
              class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1 w-full"
              on:click={displayUnretirePlayerModal}>Unretire Player</button
            >
          </div>
        </div>
      </div>
      <p class="m-4">Fixture proposals</p>
      <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mt-4 mx-4">
        <div
          class="flex flex-col items-center bg-gray-700 rounded shadow p-4 w-full"
        >
          <div class="flex items-center space-x-4 w-full">
            <button
              class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1 w-full"
              on:click={displayAddFixtureDataModal}>Add Fixture Data</button
            >
          </div>
        </div>
        <div
          class="flex flex-col items-center bg-gray-700 rounded shadow p-4 w-full"
        >
          <div class="flex items-center space-x-4 w-full">
            <button
              class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1 w-full"
              on:click={displayAddInitialFixturesModal}
              >Add Initial Fixtures</button
            >
          </div>
        </div>
        <div
          class="flex flex-col items-center bg-gray-700 rounded shadow p-4 w-full"
        >
          <div class="flex items-center space-x-4 w-full">
            <button
              class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1 w-full"
              on:click={displayMoveFixtureModal}>Move Fixture</button
            >
          </div>
        </div>
        <div
          class="flex flex-col items-center bg-gray-700 rounded shadow p-4 w-full"
        >
          <div class="flex items-center space-x-4 w-full">
            <button
              class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1 w-full"
              on:click={displayPostponeFixtureModal}>Postpone Fixture</button
            >
          </div>
        </div>
        <div
          class="flex flex-col items-center bg-gray-700 rounded shadow p-4 w-full"
        >
          <div class="flex items-center space-x-4 w-full">
            <button
              class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1 w-full"
              on:click={displayRescheduleFixtureModal}
              >Reschedule Fixture</button
            >
          </div>
        </div>
      </div>

      <p class="m-4">Club proposals</p>
      <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mt-4 mx-4 mb-4">
        <div
          class="flex flex-col items-center bg-gray-700 rounded shadow p-4 w-full"
        >
          <div class="flex items-center space-x-4 w-full">
            <button
              class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1 w-full"
              on:click={displayPromoteNewClubModal}>Promote New Club</button
            >
          </div>
        </div>
        <div
          class="flex flex-col items-center bg-gray-700 rounded shadow p-4 w-full"
        >
          <div class="flex items-center space-x-4 w-full">
            <button
              class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1 w-full"
              on:click={displayUpdateClubModal}>Update Club</button
            >
          </div>
        </div>
      </div>
    </div>
  </div>
</Layout>
