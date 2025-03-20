<script lang="ts">
  import { page } from "$app/state";
  import { authStore, type AuthSignInParams } from "$lib/stores/auth.store"
  import OpenFPLIcon from "$lib/icons/OpenFPLIcon.svelte";
  import WalletIcon from "$lib/icons/WalletIcon.svelte";
  import { onMount, onDestroy } from "svelte";
  import { goto } from "$app/navigation";
  import { authSignedInStore } from "$lib/derived/auth.derived";
  import { userGetProfilePicture } from "$lib/derived/user.derived";
  import { toasts } from "$lib/stores/toasts-store";

  export let onLogout: () => void = () => {};

  let menuOpen = false;
  let showProfileDropdown = false;

  onMount(() => {
    if (typeof window !== "undefined") {
        document.addEventListener("click", closeDropdownOnClickOutside);
    }
  });

  onDestroy(() => {
    if (typeof window !== "undefined") {
      document.removeEventListener("click", closeDropdownOnClickOutside);
    }
  });

  $: currentClass = (route: string) =>
    page.url.pathname === route
      ? "text-blue-500 nav-underline active"
      : "nav-underline";

  $: currentBorder = (route: string) =>
    page.url.pathname === route ? "active-border" : "";

  function toggleMenu() {
    menuOpen = !menuOpen;
  }

  function handleLogin() {
    let params: AuthSignInParams = {
      domain: import.meta.env.VITE_AUTH_PROVIDER_URL,
    };
    authStore.signIn(params);
  }

  async function handleLogout() {
    showProfileDropdown = false;
    await onLogout();
    toasts.addToast({
      type: "info",
      message: "Logged out successfully",
      duration: 2000,
    });
    goto("/");
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
    <div class="flex items-center justify-between w-full h-16 px-4">
      <a href="/" class="flex items-center hover:text-gray-400">
        <OpenFPLIcon className="h-8 w-auto" /><b class="ml-2">OpenFPL</b>
      </a>
      <button
        class="menu-toggle md:hidden focus:outline-none"
        on:click={toggleMenu}
        aria-label="Toggle Menu"
      >
        <svg
          width="24"
          height="18"
          viewBox="0 0 24 18"
          fill="none"
          xmlns="http://www.w3.org/2000/svg"
          xmlns:xlink="http://www.w3.org/1999/xlink"
        >
          <rect width="24" height="2" rx="1" fill="currentColor" />
          <rect y="8" width="24" height="2" rx="1" fill="currentColor" />
          <rect y="16" width="24" height="2" rx="1" fill="currentColor" />
        </svg>
      </button>
      {#if $authSignedInStore}
        <ul class="hidden h-16 md:flex">
          <li class="flex items-center h-16 mx-2">
            <a
              href="/"
              class="flex items-center h-full nav-underline hover:text-gray-400 ${currentClass(
                '/'
              )}"
            >
              <span class="flex items-center h-full px-4">Home</span>
            </a>
          </li>
          <li class="flex items-center h-16 mx-2">
            <a
              href="/pick-team"
              class="flex items-center h-full nav-underline hover:text-gray-400 ${currentClass(
                '/pick-team'
              )}"
            >
              <span class="flex items-center h-full px-4">Squad Selection</span>
            </a>
          </li>
          <li class="flex items-center flex-1">
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
                      class="flex items-center w-full h-full nav-underline hover:text-gray-400"
                    >
                      <span class="flex items-center w-full h-full">
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
                      class="flex items-center justify-center px-4 pt-1 pb-2 text-white rounded-md shadow focus:outline-none focus:ring-2 focus:ring-blue-300 focus:ring-opacity-50 nav-button"
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
                href="/profile"
                class="flex h-full w-full nav-underline hover:text-gray-400 w-full ${currentClass(
                  '/profile'
                )}"
              >
                <span class="flex items-center w-full h-full">
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
                class="flex items-center w-full h-full hover:text-gray-400"
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
          <li class="flex items-center h-16 mx-2">
            <button
              class="flex items-center justify-center px-4 py-2 text-white bg-blue-500 rounded-md shadow hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-300 focus:ring-opacity-50 nav-button"
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
                class="flex items-center justify-center px-4 py-2 text-white bg-blue-500 rounded-md shadow hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-300 focus:ring-opacity-50 nav-button"
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