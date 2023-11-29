<script lang="ts">
  import { onMount, onDestroy } from "svelte";
  import { userStore } from "$lib/stores/user-store";
  import { teamStore } from "$lib/stores/team-store";
  import { systemStore } from "$lib/stores/system-store";
  import { toastStore } from "$lib/stores/toast-store";
  import type {
    ProfileDTO,
    SystemState,
    Team,
  } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import CopyIcon from "$lib/icons/CopyIcon.svelte";
  import UpdateUsernameModal from "$lib/components/profile/update-username-modal.svelte";
  import UpdateFavouriteTeamModal from "./update-favourite-team-modal.svelte";
  import LoadingIcon from "$lib/icons/LoadingIcon.svelte";
  import { writable, type Writable } from "svelte/store";
  import { loadingText } from "$lib/stores/global-stores";

  let teams: Team[];
  let systemState: SystemState | null;
  let profile: Writable<ProfileDTO | null> = writable(null);
  let profileSrc: Writable<string> = writable("profile_placeholder.png");
  let showUsernameModal: boolean = false;
  let showFavouriteTeamModal: boolean = false;
  let fileInput: HTMLInputElement;
  let gameweek: number = 1;
  let isLoading = writable(false);

  let unsubscribeTeams: () => void;
  let unsubscribeSystemState: () => void;

  onMount(async () => {
    isLoading.set(true);
    try {
      await teamStore.sync();
      await systemStore.sync();

      unsubscribeTeams = teamStore.subscribe((value) => {
        teams = value;
      });

      unsubscribeSystemState = systemStore.subscribe((value) => {
        systemState = value;
      });

      const profileData = await userStore.getProfile();
      profile.set(profileData);

      if (profileData && profileData.profilePicture.length > 0) {
        const blob = new Blob([new Uint8Array(profileData.profilePicture)]);
        profileSrc.set(URL.createObjectURL(blob));
      }
      gameweek = systemState?.activeGameweek ?? 1;
    } catch (error) {
      toastStore.show("Error fetching profile detail.", "error");
      console.error("Error fetching profile detail:", error);
    } finally {
      isLoading.set(false);
    }
  });

  onDestroy(() => {
    unsubscribeTeams?.();
    unsubscribeSystemState?.();
  });

  function displayUsernameModal(): void {
    showUsernameModal = true;
  }

  async function closeUsernameModal() {
    const profileData = await userStore.getProfile();
    profile.set(profileData);
    showUsernameModal = false;
  }

  function cancelUsernameModal() {
    showUsernameModal = false;
  }

  function displayFavouriteTeamModal(): void {
    showFavouriteTeamModal = true;
  }

  async function closeFavouriteTeamModal() {
    const profileData = await userStore.getProfile();
    profile.set(profileData);
    showFavouriteTeamModal = false;
  }

  function cancelFavouriteTeamModal() {
    showFavouriteTeamModal = false;
  }

  function copyToClipboard(text: string) {
    navigator.clipboard.writeText(text).then(() => {
      toastStore.show("Copied!", "success");
    });
  }

  function clickFileInput() {
    fileInput.click();
  }

  function handleFileChange(event: Event) {
    const input = event.target as HTMLInputElement;
    if (input.files && input.files[0]) {
      const file = input.files[0];
      if (file.size > 1000 * 1024) {
        alert("File size exceeds 1000KB");
        return;
      }

      uploadProfileImage(file);
    }
  }

  async function uploadProfileImage(file: File) {
    isLoading.set(true);
    loadingText.set("Updating Profile Picture");
    try {
      await userStore.updateProfilePicture(file);
      const profileData = await userStore.getProfile();
      profile.set(profileData);
      if (profileData && profileData.profilePicture.length > 0) {
        const blob = new Blob([new Uint8Array(profileData.profilePicture)]);
        profileSrc.set(URL.createObjectURL(blob));
      }
      toastStore.show("Profile image updated.", "success");
    } catch (error) {
      toastStore.show("Error updating profile image", "error");
      console.error("Error updating profile image", error);
    } finally {
      isLoading.set(false);
      loadingText.set("Loading");
    }
  }
</script>

{#if $isLoading}
  <LoadingIcon />
{:else}
  <UpdateUsernameModal
    newUsername={$profile ? $profile.displayName : ""}
    showModal={showUsernameModal}
    closeModal={closeUsernameModal}
    cancelModal={cancelUsernameModal}
    {isLoading}
  />
  <UpdateFavouriteTeamModal
    newFavouriteTeam={$profile ? $profile.favouriteTeamId : 0}
    showModal={showFavouriteTeamModal}
    closeModal={closeFavouriteTeamModal}
    cancelModal={cancelFavouriteTeamModal}
    {isLoading}
  />
  <div class="container mx-auto p-4">
    {#if $profile}
      <div class="flex flex-wrap">
        <div class="w-full md:w-auto px-2 ml-4 md:ml-0">
          <div class="group">
            <img
              src={$profileSrc}
              alt="Profile"
              class="w-48 md:w-80 mb-1 rounded-lg"
            />

            <div class="file-upload-wrapper mt-4">
              <button
                class="btn-file-upload fpl-button"
                on:click={clickFileInput}>Upload Photo</button
              >
              <input
                type="file"
                id="profile-image"
                accept="image/*"
                bind:this={fileInput}
                on:change={handleFileChange}
                style="opacity: 0; position: absolute; left: 0; top: 0;"
              />
            </div>
          </div>
        </div>

        <div class="w-full md:w-3/4 px-2 mb-4">
          <div class="ml-4 p-4 rounded-lg">
            <p class="text-xs mb-2">Display Name:</p>
            <h2 class="text-2xl font-bold mb-2">{$profile?.displayName}</h2>
            <button
              class="p-2 px-4 rounded fpl-button"
              on:click={displayUsernameModal}
            >
              Update
            </button>
            <p class="text-xs mb-2 mt-4">Favourite Team:</p>
            <h2 class="text-2xl font-bold mb-2">
              {teams.find((x) => x.id === $profile?.favouriteTeamId)
                ?.friendlyName}
            </h2>
            <button
              class="p-2 px-4 rounded fpl-button"
              on:click={displayFavouriteTeamModal}
              disabled={gameweek > 1 && ($profile?.favouriteTeamId ?? 0) > 0}
            >
              Update
            </button>

            <p class="text-xs mb-2 mt-4">Joined:</p>
            <h2 class="text-2xl font-bold mb-2">August 2023</h2>

            <p class="text-xs mb-2 mt-4">Principal:</p>
            <div class="flex items-center">
              <h2 class="text-xs font-bold">{$profile?.principalName}</h2>
              <CopyIcon
                onClick={copyToClipboard}
                principalId={$profile?.principalName}
                className="ml-2 w-4 h-4"
              />
            </div>
          </div>
        </div>
      </div>
    {/if}
    <div class="flex flex-wrap -mx-2 mt-4">
      <div class="w-full px-2 mb-4">
        <div class="mt-4 px-2">
          <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
            <div
              class="flex items-center p-4 rounded-lg shadow-md border border-gray-700"
            >
              <img src="ICPCoin.png" alt="ICP" class="h-12 w-12" />
              <div class="ml-4">
                <p class="font-bold">ICP</p>
                <p>0.00 ICP</p>
              </div>
            </div>
            <div
              class="flex items-center p-4 rounded-lg shadow-md border border-gray-700"
            >
              <img src="FPLCoin.png" alt="FPL" class="h-12 w-12" />
              <div class="ml-4">
                <p class="font-bold">FPL</p>
                <p>0.00 FPL</p>
              </div>
            </div>
            <div
              class="flex items-center p-4 rounded-lg shadow-md border border-gray-700"
            >
              <img src="ckBTCCoin.png" alt="ICP" class="h-12 w-12" />
              <div class="ml-4">
                <p class="font-bold">ckBTC</p>
                <p>0.00 ckBTC</p>
              </div>
            </div>
            <div
              class="flex items-center p-4 rounded-lg shadow-md border border-gray-700"
            >
              <img src="ckETHCoin.png" alt="ICP" class="h-12 w-12" />
              <div class="ml-4">
                <p class="font-bold">ckETH</p>
                <p>0.00 ckETH</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
{/if}

<style>
  .file-upload-wrapper {
    position: relative;
    overflow: hidden;
    display: inline-block;
    width: 100%;
  }

  .btn-file-upload {
    width: 100%;
    border: none;
    padding: 10px 20px;
    border-radius: 5px;
    font-size: 1em;
    cursor: pointer;
    text-align: center;
    display: block;
  }

  input[type="file"] {
    font-size: 100px;
    position: absolute;
    left: 0;
    top: 0;
    opacity: 0;
    width: 100%;
    height: 100%;
    cursor: pointer;
  }
</style>
