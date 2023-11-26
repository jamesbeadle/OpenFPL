<script lang="ts">
  import { onMount } from "svelte";
  import type { ProfileDTO } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import CopyIcon from "$lib/icons/CopyIcon.svelte";
  import { toastStore } from "$lib/stores/toast";
  import UpdateUsernameModal from "$lib/components/update-username-modal.svelte";
  import UpdateFavouriteTeamModal from "./update-favourite-team-modal.svelte";
  import { UserService } from "$lib/services/UserService";
  import LoadingIcon from "$lib/icons/LoadingIcon.svelte";

  const userService = new UserService();

  let profile: ProfileDTO;
  let showUsernameModal: boolean = false;
  let showFavouriteTeamModal: boolean = false;
  let isLoading = true;
  let progress = 0;
  let fileInput: HTMLInputElement;

  function displayUsernameModal(): void {
    showUsernameModal = true;
  }

  function closeUsernameModal(): void {
    showUsernameModal = false;
  }

  function displayFavouriteTeamModal(): void {
    showFavouriteTeamModal = true;
  }

  function closeFavouriteTeamModal(): void {
    showFavouriteTeamModal = false;
  }

  onMount(async () => {
    try {
      incrementProgress(20);
      const profileData = await userService.getProfile();
      incrementProgress(60);
      profile = profileData;
      isLoading = false;
    } catch (error) {
      console.error("Error fetching data:", error);
    }
  });

  function copyToClipboard(text: string) {
    navigator.clipboard.writeText(text).then(() => {
      toastStore.show("Copied", "success");
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
    // Implement the logic to upload the image to your server
    // This could be an API call to your backend
    // Example: await userService.uploadProfileImage(file);
  }

  function incrementProgress(newProgress: number) {
    const step = 1;
    const delay = 100;

    function stepProgress() {
      if (progress < newProgress) {
        progress += step;
        setTimeout(stepProgress, delay);
      }
    }

    stepProgress();
  }
</script>


<style>
  .file-upload-container {
    /* Set to the width of the image or as required */
    width: 100%; /* Assuming the image is full width of its container */
  }

  .file-upload-wrapper {
    position: relative;
    overflow: hidden;
    display: inline-block;
    width: 100%; /* This will make the wrapper full width of its container */
  }

  .btn-file-upload {
    width: 100%; /* This will make the button full width of the wrapper */
    border: none;
    color: white;
    background-color: #6c5ce7;
    padding: 10px 20px;
    border-radius: 5px;
    font-size: 1em;
    cursor: pointer;
    text-align: center;
    display: block;
  }

  input[type='file'] {
    font-size: 100px;
    position: absolute;
    left: 0;
    top: 0;
    opacity: 0;
    width: 100%; /* This ensures the invisible file input spans the entire area of the button */
    height: 100%; /* Match the height of the button to ensure the clickable area is the same */
    cursor: pointer; /* Change the cursor to indicate it's clickable */
  }
</style>

{#if isLoading}
  <LoadingIcon {progress} />
{:else}
  <UpdateUsernameModal
    showModal={showUsernameModal}
    closeModal={closeUsernameModal}
  />
  <UpdateFavouriteTeamModal
    showModal={showFavouriteTeamModal}
    closeModal={closeFavouriteTeamModal}
  />
  <div class="container mx-auto p-4">
    <div class="flex flex-wrap">
      <div class="w-full md:w-auto px-2 ml-4 md:ml-0">
        <div class="group">
          <img src="profile_placeholder.png" alt="Profile" class="w-48 md:w-80 mb-1"/>

          <div class="file-upload-wrapper mt-4">
            <button class="btn-file-upload" on:click={clickFileInput}>Upload Photo</button>
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
          <h2 class="text-2xl font-bold mb-2">{profile.displayName}</h2>
          <button
            class="p-2 px-4 rounded fpl-purple-btn"
            on:click={displayUsernameModal}
          >
            Update
          </button>
          <p class="text-xs mb-2 mt-4">Favourite Team:</p>
          <h2 class="text-2xl font-bold mb-2">Not Set</h2>
          <button
          class="p-2 px-4 rounded fpl-purple-btn"
            on:click={displayFavouriteTeamModal}
          >
            Update
          </button>

          <p class="text-xs mb-2 mt-4">Joined:</p>
          <h2 class="text-2xl font-bold mb-2">August 2023</h2>

          <p class="text-xs mb-2 mt-4">Principal:</p>
          <div class="flex items-center">
            <h2 class="text-xs font-bold">{profile.principalName}</h2>
            <CopyIcon
              onClick={copyToClipboard}
              principalId={profile.principalName}
              className="ml-2 w-4 h-4"
            />
          </div>
        </div>
      </div>
    </div>

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
