<script lang="ts">
  import { onMount } from "svelte";
  import { userStore } from "$lib/stores/user-store";
  import { clubStore } from "$lib/stores/club-store";
  import { storeManager } from "$lib/managers/store-manager";
  import Modal from "$lib/components/shared/modal.svelte";
  import WidgetSpinner from "../shared/widget-spinner.svelte";

  export let visible: boolean;
  
  let isLoading = true;
  let username = "";
  let selectedClub = 0;
  let isSubmitDisabled = true;
  let isCheckingUsername = false;
  let usernameError = "";
  let usernameAvailable = false;

  let usernameTimeout: NodeJS.Timeout;

  $: isSubmitDisabled = !username || selectedClub === 0 || !usernameAvailable || isCheckingUsername;

  async function checkUsername() {
    if (username.length < 3) {
      usernameError = "Username must be at least 3 characters";
      usernameAvailable = false;
      return;
    }
    
    isCheckingUsername = true;
    try {
      const available = await userStore.isUsernameAvailable(username);
      usernameAvailable = available;
      usernameError = available ? "" : "Username is already taken";
    } catch (error) {
      console.error("Error checking username:", error);
      usernameError = "Error checking username availability";
    } finally {
      isCheckingUsername = false;
    }
  }

  function handleUsernameInput() {
    clearTimeout(usernameTimeout);
    usernameAvailable = false;
    if (username.length >= 3) {
      usernameTimeout = setTimeout(checkUsername, 500);
    }
  }

  onMount(async () => {
    await storeManager.syncStores();
    isLoading = false;
  });

  async function createManager() {
    isLoading = true;
    try {
      await userStore.createManager(username, selectedClub);
      closeModal();
    } catch (error) {
      console.error("Error creating manager:", error);
    } finally {
      isLoading = false;
    }
  }

  function closeModal() {
    visible = false;
  }
</script>

<Modal showModal={visible} onClose={closeModal} title="Profile Settings">
  {#if isLoading}
    <WidgetSpinner />
  {:else}
    <div class="p-4">
      <div class="mb-6">
        <h3 class="mb-2">Display Name</h3>
        <input
          type="text"
          bind:value={username}
          on:input={handleUsernameInput}
          class="w-full p-2 text-white rounded-md bg-BrandGray"
          placeholder="Enter display name"
        />
        {#if username.length > 0}
          <div class="mt-2 text-sm">
            {#if isCheckingUsername}
              <p class="text-BrandLightGray">Checking username availability...</p>
            {:else if usernameError}
              <p class="text-BrandRed">{usernameError}</p>
            {:else if usernameAvailable}
              <p class="text-BrandGreen">Username is available!</p>
            {/if}
          </div>
        {/if}
      </div>

      <div class="mb-6">
        <h3 class="mb-2">Favorite Club</h3>
        <select
          bind:value={selectedClub}
          class="w-full p-2 text-white rounded-md bg-BrandGray"
        >
          <option value={0}>Select club</option>
          {#each $clubStore.sort((a, b) => a.friendlyName.localeCompare(b.friendlyName)) as club}
            <option value={club.id}>{club.friendlyName}</option>
          {/each}
        </select>
      </div>

      <div class="flex justify-between">
        <button 
          class="px-8 py-2 text-white border border-white rounded-md"
          on:click={closeModal}
        >
          Cancel
        </button>
        <button 
          class="px-8 py-2 text-white rounded-md bg-BrandPurple disabled:bg-gray-500"
          on:click={createManager}
          disabled={isSubmitDisabled}
        >
          Save
        </button>
      </div>
    </div>
  {/if}
</Modal>
