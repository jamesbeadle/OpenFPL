<script lang="ts">
  import { page } from "$app/stores";
  import { authStore, type AuthSignInParams } from "$lib/stores/auth";
  import { toastStore } from "$lib/stores/toast-store";
  import OpenFPLIcon from "$lib/icons/OpenFPLIcon.svelte";
  import WalletIcon from "$lib/icons/WalletIcon.svelte";
  import { onMount, onDestroy } from "svelte";
  import { goto } from "$app/navigation";

  let menuOpen = false;
  let isLoggedIn = false;

  let unsubscribeLogin: () => void;

  onMount(async () => {
    try {
      await authStore.sync();
      unsubscribeLogin = authStore.subscribe((store) => {
        isLoggedIn = store.identity !== null && store.identity !== undefined;
      });
    } catch (error) {
      toastStore.show("Error syncing authentication.", "error");
      console.error("EError syncing authentication:", error);
    }
  });

  onDestroy(() => {
    unsubscribeLogin?.();
  });

  $: currentClass = (route: string) =>
    $page.url.pathname === route
      ? "text-blue-500 nav-underline active"
      : "nav-underline";

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
  }
</script>

<header>
  <nav class="text-white">
    <div class="px-4 h-16 flex justify-between items-center w-full">
      <a href="/" class="hover:text-gray-400 flex items-center">
        <OpenFPLIcon className="h-8 w-auto" /><b class="ml-2">OpenFPL</b>
      </a>
      <button class="md:hidden focus:outline-none" on:click={toggleMenu}>
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
      {#if isLoggedIn}
        <ul class="hidden md:flex text-base md:text-xs lg:text-base">
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
          <li class="mx-2 flex items-center h-16">
            <a
              href="/profile"
              class="flex items-center h-full nav-underline hover:text-gray-400 ${currentClass(
                '/profile'
              )}"
            >
              <span class="flex items-center h-full px-4">Profile</span>
            </a>
          </li>
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
          <li class="mx-2 flex items-center h-16">
            <button
              class="flex items-center justify-center px-4 py-2 text-white rounded-md shadow focus:outline-none focus:ring-2 focus:ring-blue-300 focus:ring-opacity-50 nav-button"
              on:click={handleLogout}
            >
              Disconnect
              <WalletIcon className="ml-2 h-6 w-6 mt-1" />
            </button>
          </li>
        </ul>
        <div
          class={`absolute top-12 right-2.5 bg-black rounded-lg shadow-md z-10 p-2 ${
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
                class={currentClass("/profile")}
                on:click={toggleMenu}>Profile</a
              >
            </li>
            <li class="p-2">
              <button
                class="flex items-center justify-center px-4 py-2 text-white rounded-md shadow focus:outline-none focus:ring-2 focus:ring-blue-300 focus:ring-opacity-50 nav-button"
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
          class={`absolute top-12 right-2.5 bg-black rounded-lg shadow-md z-10 p-2 ${
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
