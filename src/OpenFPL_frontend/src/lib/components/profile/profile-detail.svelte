<script lang="ts">
  import { onMount } from "svelte";
  import { userStore } from "$lib/stores/user-store";
  import { clubStore } from "$lib/stores/club-store";
  import { systemStore } from "$lib/stores/system-store";
  import { toastsError, toastsShow } from "$lib/stores/toasts-store";
  import UpdateUsernameModal from "$lib/components/profile/update-username-modal.svelte";
  import UpdateFavouriteTeamModal from "./update-favourite-team-modal.svelte";
  import { busyStore, Spinner } from "@dfinity/gix-components";
  import CopyIcon from "$lib/icons/CopyIcon.svelte";
  import { userGetProfilePicture } from "$lib/derived/user.derived";
  import LocalSpinner from "../local-spinner.svelte";
  import WithdrawFplModal from "./withdraw-fpl-modal.svelte";
  import { writable } from "svelte/store";
  import { authStore } from "$lib/stores/auth.store";
  import { getDateFromBigInt } from "$lib/utils/helpers";
    import { storeManager } from "$lib/managers/store-manager";
  
  let showUsernameModal: boolean = false;
  let showFavouriteTeamModal: boolean = false;
  let fileInput: HTMLInputElement;
  let gameweek: number = 1;
  let joinedDate = "";
  let showFPLModal = false;
  let dots = writable('.');
  let fplBalance = 0n;
  let fplBalanceFormatted = "0.0000"; 
  let dot_interval: ReturnType<typeof setInterval>;
  let username = "Not Set";

  let unsubscribeUserProfile: () => void;

  $: gameweek = $systemStore?.calculationGameweek ?? 1;

  $: teamName =
    $clubStore.find((x) => x.id == $userStore?.favouriteClubId)?.friendlyName ??
    "";

  let isLoading = true;
  let loadingBalances = true;

  onMount(async () => {
    try {
      startDotAnimation();
      await storeManager.syncStores();

      unsubscribeUserProfile = userStore.subscribe((value) => {
        if (!value) {
          return;
        }
        username = value.username;
        joinedDate = getDateFromBigInt(Number(value.createDate));
      });
    } catch (error) {
      toastsError({
        msg: { text: "Error fetching profile detail." },
        err: error,
      });
      console.error("Error fetching profile detail:", error);
    } finally {
      isLoading = false;
      await fetchBalances();
    }
  });

  function startDotAnimation(){
    let count = 1;
    dot_interval = setInterval(() => {
      count = (count % 3) + 1;
      dots.set('.'.repeat(count));
    }, 500);
  }

  async function fetchBalances() {
    try {
      fplBalance = await userStore.getFPLBalance();
      fplBalanceFormatted = (Number(fplBalance) / 100_000_000).toFixed(4);
      if(fplBalance){
        clearInterval(dot_interval);
        loadingBalances = false;
      }
    } catch (error) {
      toastsError({
        msg: { text: "Error fetching profile detail." },
        err: error,
      });
      console.error("Error fetching profile detail:", error);
      clearInterval(dot_interval);
      loadingBalances = false;
    }
  }


  function displayUsernameModal(): void {
    showUsernameModal = true;
  }

  async function closeUsernameModal() {
    await userStore.cacheProfile();
    showUsernameModal = false;
  }

  function cancelUsernameModal() {
    showUsernameModal = false;
  }

  function displayFavouriteTeamModal(): void {
    showFavouriteTeamModal = true;
  }

  async function closeFavouriteTeamModal() {
    await userStore.cacheProfile();
    showFavouriteTeamModal = false;
  }

  function cancelFavouriteTeamModal() {
    showFavouriteTeamModal = false;
  }

  function clickFileInput() {
    fileInput.click();
  }

  function handleFileChange(event: Event) {
    const input = event.target as HTMLInputElement;
    if (input.files && input.files[0]) {
      const file = input.files[0];
      if (file.size > 500 * 1024) {
        alert("File size exceeds 500KB");
        return;
      }

      uploadProfileImage(file);
    }
  }

  async function uploadProfileImage(file: File) {
    busyStore.startBusy({
      initiator: "upload-image",
      text: "Uploading profile picture...",
    });

    try {
      await userStore.updateProfilePicture(file);
      await userStore.cacheProfile();
      await userStore.sync();

      toastsShow({
        text: "Profile image updated.",
        level: "success",
        duration: 2000,
      });
    } catch (error) {
      toastsError({
        msg: { text: "Error updating profile image." },
        err: error,
      });
      console.error("Error updating profile image", error);
    } finally {
      busyStore.stopBusy("upload-image");
    }
  }

  async function copyTextAndShowToast() {
    try {
      const textToCopy = $userStore ? $userStore.principalId : "";
      await navigator.clipboard.writeText(textToCopy);
      toastsShow({
        text: "Copied to clipboard.",
        level: "success",
        duration: 2000,
      });
    } catch (err) {
      console.error("Failed to copy:", err);
    }
  }
  
  function loadWithdrawFPLModal(){
    showFPLModal = true;
  };

  async function closeWithdrawFPLModal(){
    showFPLModal = false;
    startDotAnimation();
    await fetchBalances();
  };
</script>

{#if isLoading}
  <LocalSpinner />
{:else}
  <UpdateUsernameModal
    newUsername={$userStore ? $userStore.username : ""}
    visible={showUsernameModal}
    closeModal={closeUsernameModal}
    cancelModal={cancelUsernameModal}
  />
  <UpdateFavouriteTeamModal
    newFavouriteTeam={$userStore ? $userStore.favouriteClubId : 0}
    visible={showFavouriteTeamModal}
    closeModal={closeFavouriteTeamModal}
    cancelModal={cancelFavouriteTeamModal}
  />
  <WithdrawFplModal
    visible={showFPLModal}
    closeModal={closeWithdrawFPLModal}
    cancelModal={closeWithdrawFPLModal}
    fplBalance={fplBalance}
    fplBalanceFormatted={fplBalanceFormatted}
  />
  <div class="container mx-auto p-4">
    <div class="flex flex-wrap">
      <div class="w-full md:w-1/2 lg:w-1/3 xl:w-1/4 px-2">
        <div class="group flex flex-col md:block">
          <img
            src={$userGetProfilePicture}
            alt="Profile"
            class="w-full mb-1 rounded-lg"
          />

          <div class="file-upload-wrapper mt-4">
            <button class="btn-file-upload fpl-button" on:click={clickFileInput}
              >Upload Photo</button
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

      <div class="w-full md:w-1/2 lg:w-2/3 xl:w-3/4 md:px-2 mb-4 md:mb-0">
        <div class="md:ml-4 md:px-4 px-4 mt-2 md:mt-1 rounded-lg">
          <p class="mb-1">Username:</p>
          <h2 class="default-header mb-1 md:mb-2">
            {username}
            </h2>
          <button
            class="text-sm md:text-sm p-1 md:p-2 px-2 md:px-4 rounded fpl-button"
            on:click={displayUsernameModal}
          >
            Update
          </button>
          <p class="mb-1 mt-4">Favourite Team:</p>
          <h2 class="default-header mb-1 md:mb-2">
            {teamName == "" ? "Not Set" : teamName}
          </h2>
          <button
            class={`p-1 md:p-2 px-2 md:px-4 ${
              gameweek > 1 && ($userStore?.favouriteClubId ?? 0) > 0
                ? "bg-gray-500"
                : "fpl-button"
            } rounded`}
            on:click={displayFavouriteTeamModal}
            disabled={gameweek > 1 && ($userStore?.favouriteClubId ?? 0) > 0}
          >
            Update
          </button>

          <p class="mb-1 mt-4">Joined:</p>
          <h2 class="default-header mb-1 md:mb-2">{joinedDate}</h2>

          <p class="mb-1">Principal:</p>
          <div class="flex items-center">
            <button
              class="flex items-center text-left"
              on:click={copyTextAndShowToast}
            >
              <span>{$authStore.identity?.getPrincipal().toText()}</span>
              <CopyIcon className="w-7 xs:w-6 text-left" fill="#FFFFFF" />
            </button>
          </div>
        </div>
      </div>
    </div>
    <div class="flex flex-wrap">
      <div class="w-full px-2 mb-4">
        <div class="mt-4 px-2">
          <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
            <div
              class="flex items-center p-4 rounded-lg shadow-md border border-gray-700"
            >
              <img
                src="/FPLCoin.png"
                alt="FPL"
                class="h-12 w-12 md:h-9 md:w-9"
              />
              <div class="ml-4 md:ml-3 flex flex-col space-y-2">
                  {#if loadingBalances}
                    <div class="dot-animation min-w-[20px]">{$dots}</div>
                  {:else}
                    <p>
                      {fplBalanceFormatted} FPL
                    </p>
                    <button class="text-sm md:text-sm p-1 md:p-2 px-2 md:px-4 rounded fpl-button"
                      on:click={loadWithdrawFPLModal}
                    >
                      Withdraw
                    </button>
                  {/if}
                
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
