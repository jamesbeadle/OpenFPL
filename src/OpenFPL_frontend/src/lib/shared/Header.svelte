  <script lang="ts">
    import { page } from '$app/stores';
    import { authStore } from '$lib/stores/auth';
    import { derived } from 'svelte/store';

    let menuOpen = false;

    const isAuthenticated = derived(authStore, $authStore => $authStore.identity !== null && $authStore.identity !== undefined);

    $: currentClass = (route: string) => $page.url.pathname === route ? 'text-blue-500 nav-underline active' : 'nav-underline';
 
    function toggleMenu() {
      menuOpen = !menuOpen;
    }
    function handleLogin() {
      authStore.login();
    }
  </script>
  <style>
    .nav-underline {
      position: relative;
      display: inline-block;
      color: white;
    }
    .nav-underline::after {
      content: '';
      position: absolute;
      width: 100%;
      height: 2px;
      background-color: #2CE3A6;
      bottom: 0;
      left: 0;
      transform: scaleX(0);
      transition: transform 0.3s ease-in-out;
      color: #2CE3A6 ;
    }


    .nav-underline:hover::after,
    .nav-underline.active::after {
      transform: scaleX(1);
      color: #2CE3A6 ;
    }

    .nav-underline:hover::after {
      transform: scaleX(1);
      background-color: gray;
    }
  </style>

  <header>
    <nav class="text-white">
      <div class="px-4 h-16 flex justify-between items-center w-full">
        <a href="/" class="hover:text-gray-400">
          <img src="logo.png" alt="Logo" class="h-8 w-auto">
        </a>
        <button class="md:hidden focus:outline-none" on:click={toggleMenu}>
          <svg width="24" height="18" viewBox="0 0 24 18" fill="none" xmlns="http://www.w3.org/2000/svg">
            <rect width="24" height="2" rx="1" fill="currentColor"/>
            <rect y="8" width="24" height="2" rx="1" fill="currentColor"/>
            <rect y="16" width="24" height="2" rx="1" fill="currentColor"/>
          </svg> 
        </button>
        {#if $isAuthenticated}
          <ul class="hidden md:flex">
            <li class="mx-2 flex items-center h-16">
              <a href="/" class="flex items-center h-full nav-underline hover:text-gray-400 ${currentClass('/')}">
                <span class="flex items-center h-full">Home</span>
              </a>
            </li>
            <li class="mx-2 flex items-center h-16">
              <a href="/pick-team" class="flex items-center h-full nav-underline hover:text-gray-400 ${currentClass('/pick-team')}">
                <span class="flex items-center h-full">Squad Selection</span>
              </a>
            </li>
            <li class="mx-2 flex items-center h-16">
              <a href="/governance" class="flex items-center h-full nav-underline hover:text-gray-400 ${currentClass('/governance')}">
                <span class="flex items-center h-full">Governance</span>
              </a>
            </li>
            <li class="mx-2 flex items-center h-16">
              <a href="/profile" class="flex items-center h-full nav-underline hover:text-gray-400 ${currentClass('/profile')}">
                <span class="flex items-center h-full">Profile</span>
              </a>
            </li>
          </ul>
          <div class={`absolute top-12 right-2.5 bg-black rounded-lg shadow-md z-10 p-2 ${menuOpen ? 'block' : 'hidden'} md:hidden`}>
            <ul class="flex flex-col">
              <li class="p-2">    <a href="/" class={`nav-underline hover:text-gray-400 ${currentClass('/')}`} >Home</a>
              </li>
              <li class="p-2"><a href="/pick-team" class={currentClass('/pick-team')} on:click={toggleMenu}>Squad Selection</a></li>
              <li class="p-2"><a href="/governance" class={currentClass('/governance')} on:click={toggleMenu}>Governance</a></li>
              <li class="p-2"><a href="/profile" class={currentClass('/profile')} on:click={toggleMenu}>Profile</a></li>
            </ul>
          </div>
        {:else}
        <button class="flex items-center justify-center px-4 py-2 bg-blue-500 text-white rounded-md shadow hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-300 focus:ring-opacity-50" on:click={handleLogin}>
          Connect
          <svg
            xmlns="http://www.w3.org/2000/svg"
            class="ml-2 h-6 w-6"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
            aria-hidden="true"
          >  
            <path d="M12.136.326A1.5 1.5 0 0 1 14 1.78V3h.5A1.5 1.5 0 0 1 16 4.5v9a1.5 1.5 0 0 1-1.5 1.5h-13A1.5 1.5 0 0 1 0 13.5v-9a1.5 1.5 0 0 1 1.432-1.499L12.136.326zM5.562 3H13V1.78a.5.5 0 0 0-.621-.484L5.562 3zM1.5 4a.5.5 0 0 0-.5.5v9a.5.5 0 0 0 .5.5h13a.5.5 0 0 0 .5-.5v-9a.5.5 0 0 0-.5-.5h-13z"/>
            <path d="M15.5,6.5v3a1,1,0,0,1-1,1h-3.5v-5H14.5A1,1,0,0,1,15.5,6.5Z"/>
            <path d="M12,8a.5,.5 0,1,1,.001,0Z"/>
          </svg>
        </button>
        {/if}
      </div>
      
      

    </nav>
  </header>

