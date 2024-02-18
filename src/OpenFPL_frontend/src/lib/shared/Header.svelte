<script lang="ts">
  import { page } from "$app/stores";
  import { authStore, type AuthSignInParams } from "$lib/stores/auth.store";
  import { systemStore } from "$lib/stores/system-store";
  import { countriesStore } from "$lib/stores/country-store";
  import { fixtureStore } from "$lib/stores/fixture-store";
  import { teamStore } from "$lib/stores/team-store";
  import { weeklyLeaderboardStore } from "$lib/stores/weekly-leaderboard-store";
  import { playerStore } from "$lib/stores/player-store";
  import { playerEventsStore } from "$lib/stores/player-events-store";
  import { userStore } from "$lib/stores/user-store";
  import { toastsError } from "$lib/stores/toasts-store";
  import OpenFPLIcon from "$lib/icons/OpenFPLIcon.svelte";
  import WalletIcon from "$lib/icons/WalletIcon.svelte";
  import { onMount, onDestroy } from "svelte";
  import { goto } from "$app/navigation";
  import { authSignedInStore } from "$lib/derived/auth.derived";
  import { userGetProfilePicture } from "$lib/derived/user.derived";

  let menuOpen = false;
  let showProfileDropdown = false;
  let unsubscribeLogin: () => void;

  onMount(async () => {
    if (typeof window !== "undefined") {
      document.addEventListener("click", closeDropdownOnClickOutside);
    }
    try {
      await userStore.sync();
      await authStore.sync();
      await systemStore.sync();
      await countriesStore.sync();
      await fixtureStore.sync($systemStore?.calculationSeasonId ?? 1);

      if ($fixtureStore.length == 0) {
        return;
      }

      await teamStore.sync();
      await playerStore.sync();
      await playerEventsStore.sync();
      await weeklyLeaderboardStore.sync(
        $systemStore?.calculationSeasonId ?? 0,
        $systemStore?.calculationGameweek ?? 0
      );
    } catch (error) {
      toastsError({
        msg: { text: "Error syncing authentication." },
        err: error,
      });
      console.error("Error syncing authentication:", error);
    }
  });

  onDestroy(() => {
    unsubscribeLogin?.();
    if (typeof window !== "undefined") {
      document.removeEventListener("click", closeDropdownOnClickOutside);
    }
  });

  $: currentClass = (route: string) =>
    $page.url.pathname === route
      ? "text-blue-500 nav-underline active"
      : "nav-underline";

  $: currentBorder = (route: string) =>
    $page.url.pathname === route ? "active-border" : "";

  function toggleMenu() {
    menuOpen = !menuOpen;
  }

  function handleLogin() {
    let params: AuthSignInParams = {
      domain: import.meta.env.VITE_AUTH_PROVIDER_URL,
    };
    authStore.signIn(params);
  }

  function handleLogout() {
    authStore.signOut();
    goto("/");
    showProfileDropdown = false;
  }

  function toggleProfileDropdown(event: Event) {
    event.stopPropagation();
    showProfileDropdown = !showProfileDropdown;
  }

  function closeDropdownOnClickOutside(event: MouseEvent) {
    const target = event.target;
    if (target instanceof Element) {
      if (
        !target.closest(".profile-dropdown") &&
        !target.closest(".profile-pic")
      ) {
        showProfileDropdown = false;
      }

      if (
        menuOpen &&
        !target.closest(".mobile-menu-panel") &&
        !target.closest(".menu-toggle")
      ) {
        menuOpen = false;
      }
    }
  }
</script>

<header>
  <nav class="text-white">
    <div class="px-4 h-16 flex justify-between items-center w-full">
      <a href="/" class="hover:text-gray-400 flex items-center">
        <OpenFPLIcon className="h-8 w-auto" /><b class="ml-2">OpenFPL</b>
      </a>
      <button
        class="menu-toggle md:hidden focus:outline-none"
        on:click={toggleMenu}
      >
        <svg
          width="24"
          height="18"
          viewBox="0 0 24 18"
          fill="none"
          xmlns="http://www.w3.org/2000/svg"
        >
          <rect width="24" height="2" rx="1" fill="currentColor" />
          <rect y="8" width="24" height="2" rx="1" fill="currentColor" />
          <rect y="16" width="24" height="2" rx="1" fill="currentColor" />
        </svg>
      </button>
      {#if $authSignedInStore}
        <ul class="hidden md:flex h-16">
          <li class="mx-2 flex items-center h-16">
            <a
              href="/"
              class="flex items-center h-full nav-underline hover:text-gray-400 ${currentClass(
                '/'
              )}"
            >
              <span class="flex items-center h-full px-4">Home</span>
            </a>
          </li>

          <!-- Todo: Pick Team will be added back in when the game begins -->
          <!--
          <li class="mx-2 flex items-center h-16">
            <a
              href="/pick-team"
              class="flex items-center h-full nav-underline hover:text-gray-400 ${currentClass(
                '/pick-team'
              )}"
            >
              <span class="flex items-center h-full px-4">Squad Selection</span>
            </a>
          </li>
          -->
          <li class="mx-2 flex items-center h-16">
            <a
              href="/governance"
              class="flex items-center h-full nav-underline hover:text-gray-400 ${currentClass(
                '/governance'
              )}"
            >
              <span class="flex items-center h-full px-4">Governance</span>
            </a>
          </li>
          <li class="flex flex-1 items-center">
            <div class="relative inline-block">
              <button
                on:click={toggleProfileDropdown}
                class={`h-full flex items-center rounded-sm ${currentBorder(
                  "/profile"
                )}`}
              >
                <img
                  src={$userGetProfilePicture}
                  alt="Profile"
                  class="h-12 rounded-sm profile-pic"
                  aria-label="Toggle Profile"
                />
              </button>
              <div
                class={`absolute right-0 top-full w-48 bg-black rounded-b-md rounded-l-md shadow-lg z-50 profile-dropdown ${
                  showProfileDropdown ? "block" : "hidden"
                }`}
              >
                <ul class="text-gray-700">
                  <li>
                    <a
                      href="/profile"
                      class="flex items-center h-full w-full nav-underline hover:text-gray-400"
                    >
                      <span class="flex items-center h-full w-full">
                        <img
                          src={$userGetProfilePicture}
                          alt="logo"
                          class="h-8 my-2 ml-4 mr-2"
                        />
                        <p class="w-full min-w-[125px] max-w-[125px] truncate">
                          Profile
                        </p>
                      </span>
                    </a>
                  </li>
                  <li>
                    <button
                      class="flex items-center justify-center px-4 pb-2 pt-1 text-white rounded-md shadow focus:outline-none focus:ring-2 focus:ring-blue-300 focus:ring-opacity-50 nav-button"
                      on:click={handleLogout}
                    >
                      Disconnect
                      <WalletIcon className="ml-2 h-6 w-6 mt-1" />
                    </button>
                  </li>
                </ul>
              </div>
            </div>
          </li>
        </ul>
        <div
          class={`mobile-menu-panel absolute top-12 right-2.5 bg-black rounded-lg shadow-md z-10 p-2 ${
            menuOpen ? "block" : "hidden"
          } md:hidden`}
        >
          <ul class="flex flex-col">
            <li class="p-2">
              <a
                href="/"
                class={`nav-underline hover:text-gray-400 ${currentClass("/")}`}
                >Home</a
              >
            </li>
            <li class="p-2">
              <a
                href="/pick-team"
                class={currentClass("/pick-team")}
                on:click={toggleMenu}>Squad Selection</a
              >
            </li>
            <li class="p-2">
              <a
                href="/governance"
                class={currentClass("/governance")}
                on:click={toggleMenu}>Governance</a
              >
            </li>
            <li class="p-2">
              <a
                href="/profile"
                class="flex h-full w-full nav-underline hover:text-gray-400 w-full ${currentClass(
                  '/profile'
                )}"
              >
                <span class="flex items-center h-full w-full">
                  <img
                    src={$userGetProfilePicture}
                    alt="logo"
                    class="w-8 h-8 rounded-sm"
                  />
                  <p class="w-full min-w-[100px] max-w-[100px] truncate p-2">
                    Profile
                  </p>
                </span>
              </a>
            </li>
            <li class="px-2">
              <button
                class="flex h-full w-full hover:text-gray-400 w-full items-center"
                on:click={handleLogout}
              >
                Disconnect
                <WalletIcon className="ml-2 h-6 w-6 mt-1" />
              </button>
            </li>
          </ul>
        </div>
      {:else}
        <ul class="hidden md:flex">
          <li class="mx-2 flex items-center h-16">
            <button
              class="flex items-center justify-center px-4 py-2 bg-blue-500 text-white rounded-md shadow hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-300 focus:ring-opacity-50 nav-button"
              on:click={handleLogin}
            >
              Connect
              <WalletIcon className="ml-2 h-6 w-6 mt-1" />
            </button>
          </li>
        </ul>
        <div
          class={`mobile-menu-panel absolute top-12 right-2.5 bg-black rounded-lg shadow-md z-10 p-2 ${
            menuOpen ? "block" : "hidden"
          } md:hidden`}
        >
          <ul class="flex flex-col">
            <li class="p-2">
              <button
                class="flex items-center justify-center px-4 py-2 bg-blue-500 text-white rounded-md shadow hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-300 focus:ring-opacity-50 nav-button"
                on:click={handleLogin}
              >
                Connect
                <WalletIcon className="ml-2 h-6 w-6 mt-1" />
              </button>
            </li>
          </ul>
        </div>
      {/if}
    </div>
  </nav>
</header>

<style>
  header {
    background-color: rgba(36, 37, 41, 0.9);
  }
  .nav-underline {
    position: relative;
    display: inline-block;
    color: white;
  }
  .nav-underline::after {
    content: "";
    position: absolute;
    width: 100%;
    height: 2px;
    background-color: #2ce3a6;
    bottom: 0;
    left: 0;
    transform: scaleX(0);
    transition: transform 0.3s ease-in-out;
    color: #2ce3a6;
  }

  .nav-underline:hover::after,
  .nav-underline.active::after {
    transform: scaleX(1);
    color: #2ce3a6;
  }

  .nav-underline:hover::after {
    transform: scaleX(1);
    background-color: gray;
  }
  .nav-button {
    background-color: transparent;
  }
  .nav-button:hover {
    background-color: transparent;
    color: #2ce3a6;
    border: none;
  }
</style>
