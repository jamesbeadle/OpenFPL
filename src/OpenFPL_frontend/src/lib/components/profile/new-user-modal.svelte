<script lang="ts">
  import { onMount } from "svelte";
  import { userStore } from "$lib/stores/user-store";
  import { clubStore } from "$lib/stores/club-store";
  import { storeManager } from "$lib/managers/store-manager";
  import Modal from "$lib/components/shared/modal.svelte";
  import WidgetSpinner from "../shared/widget-spinner.svelte";
  import { toasts } from "$lib/stores/toasts-store";
  import { authStore } from "$lib/stores/auth.store";
  import { goto } from "$app/navigation";

  export let visible: boolean;
  
  function handleAttemptClose() {
    toasts.addToast({
      type: "error",
      message: "You must set a valid username to continue",
      duration: 3000,
    });
  }

  let isLoading = true;
  let username = "";
  let selectedClub = 0;
  let isSubmitDisabled = true;
  let isCheckingUsername = false;
  let usernameError = "";
  let usernameAvailable = false;

  let usernameTimeout: NodeJS.Timeout;

  $: isSubmitDisabled = !username || !usernameAvailable || isCheckingUsername;

  function handleLogout() {
    toasts.addToast({
      type: "info",
      message: "Logged out successfully",
      duration: 2000,
    });
    authStore.signOut();
    closeModal();
    goto("/");
  }

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
      await userStore.createManager(username, selectedClub || 0);
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

<Modal showModal={visible} onClose={handleAttemptClose} title="New User Setup" closeOnClickOutside={true}>
  {#if isLoading}
    <WidgetSpinner />
    <p class="pb-4 mb-4 text-center">Creating new manager...</p>
  {:else}
    <div class="p-4">
      <div class="mb-6">
        <h3 class="mb-2">Display Name</h3>
        <div class="mb-2 text-sm text-white/50">
          <p>Username requirements:</p>
          <ul class="ml-4 list-disc">
            <li>Between 3-20 characters</li>
            <li>Only letters, numbers, and spaces allowed</li>
          </ul>
        </div>
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
        <h3 class="mb-2">Favorite Club (Optional)</h3>
        <select
          bind:value={selectedClub}
          class="w-full p-2 text-white rounded-md bg-BrandGray"
        >
          <option value={0}>No favorite club</option>
          {#each $clubStore.sort((a, b) => a.friendlyName.localeCompare(b.friendlyName)) as club}
            <option value={club.id}>{club.friendlyName}</option>
          {/each}
        </select>
      </div>

      <div class="flex justify-between">
        <button 
          class="px-6 py-2 text-white rounded-md hover:bg-BrandRed/80 bg-BrandRed"
          on:click={handleLogout}
        >
          Logout
        </button>
        <button 
          class="px-6 py-2 text-white rounded-md hover:bg-BrandPurple/80 bg-BrandPurple disabled:bg-gray-500"
          on:click={createManager}
          disabled={isSubmitDisabled}
        >
          Save
        </button>
      </div>
    </div>
  {/if}
</Modal>
