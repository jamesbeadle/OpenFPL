<script lang="ts">
  import { onMount } from "svelte";
  import type { ProfileDTO, Team } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import CopyIcon from "$lib/icons/CopyIcon.svelte";
  import { toastStore } from "$lib/stores/toast";
  import UpdateUsernameModal from "$lib/components/profile/update-username-modal.svelte";
  import UpdateFavouriteTeamModal from "./update-favourite-team-modal.svelte";
  import { UserService } from "$lib/services/UserService";
  import LoadingIcon from "$lib/icons/LoadingIcon.svelte";
  import { TeamService } from "$lib/services/TeamService";
    import { SystemService } from "$lib/services/SystemService";

  let profile: ProfileDTO;
  let profileSrc = "profile_placeholder.png";
  let showUsernameModal: boolean = false;
  let showFavouriteTeamModal: boolean = false;
  let isLoading = true;
  let progress = 0;
  let fileInput: HTMLInputElement;
  let teams: Team[];
  let gameweek: number = 1;

  onMount(async () => {
    try {
      incrementProgress(20);
      const userService = new UserService();
      const profileData = await userService.getProfile();
      incrementProgress(60);
      profile = profileData;
      if(profile.profilePicture.length > 0){
        const blob = new Blob([new Uint8Array(profile.profilePicture)]);
        profileSrc = URL.createObjectURL(blob);
      }

      let teamService = new TeamService();
      teams = await teamService.getTeams();

      let systemService = new SystemService();
      let systemState = await systemService.getSystemState();
      gameweek = systemState?.activeGameweek ?? 1;

      isLoading = false;
    } catch (error) {
      toastStore.show("Error fetching profile detail.", "error");
      console.error("Error fetching profile detail:", error);
    }
  });

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
    try{
      const userService = new UserService();
      await userService.updateProfilePicture(file);
    }
    catch(error){
      toastStore.show("Error updating profile image" ,"error");
      console.error("Error updating profile image" ,error);
    }
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

  input[type='file'] {
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

{#if isLoading}
  <LoadingIcon {progress} />
{:else}
  <UpdateUsernameModal
    newUsername={profile.displayName}
    showModal={showUsernameModal}
    closeModal={closeUsernameModal}
  />
  <UpdateFavouriteTeamModal
    newFavouriteTeam={profile.favouriteTeamId}
    showModal={showFavouriteTeamModal}
    closeModal={closeFavouriteTeamModal}
  />
  <div class="container mx-auto p-4">
    <div class="flex flex-wrap">
      <div class="w-full md:w-auto px-2 ml-4 md:ml-0">
        <div class="group">
          <img src={profileSrc} alt="Profile" class="w-48 md:w-80 mb-1 rounded-lg"/>

          <div class="file-upload-wrapper mt-4">
            <button class="btn-file-upload fpl-button" on:click={clickFileInput}>Upload Photo</button>
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
            class="p-2 px-4 rounded fpl-button"
            on:click={displayUsernameModal}
          >
            Update
          </button>
          <p class="text-xs mb-2 mt-4">Favourite Team:</p>
          <h2 class="text-2xl font-bold mb-2">{teams.find(x => x.id === profile.favouriteTeamId)?.friendlyName}</h2>
          <button
          class="p-2 px-4 rounded fpl-button"
            on:click={displayFavouriteTeamModal}
            disabled={gameweek > 1 && profile.favouriteTeamId > 0}>
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
