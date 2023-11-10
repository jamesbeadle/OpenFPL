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

    function handleLogout() {
      authStore.logout();
    }

  </script>
  <style>
    header{
      background-color: rgba(36,37,41,0.9);
    }
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
    .nav-button{
      background-color: transparent;
      padding: 0;
    }
    .nav-button:hover{
      background-color: transparent;
      color: #2CE3A6;
    }
  </style>

  <header>
    <nav class="text-white">
      <div class="px-4 h-16 flex justify-between items-center w-full">
        <a href="/" class="hover:text-gray-400 flex items-center">
          <svg
    xmlns="http://www.w3.org/2000/svg"
    class="h-8 w-auto"
    fill="currentColor"
    viewBox="0 0 137 188"
  >
    <path d="M68.8457 0C43.0009 4.21054 19.8233 14.9859 0.331561 30.5217L0.264282 30.6627V129.685L68.7784 187.97L136.528 129.685L136.543 30.6204C117.335 15.7049 94.1282 4.14474 68.8457 0ZM82.388 145.014C82.388 145.503 82.0804 145.992 81.5806 146.114L68.7784 150.329C68.5285 150.39 68.2786 150.39 68.0287 150.329L55.2265 146.114C54.7267 145.931 54.4143 145.503 54.4143 145.014V140.738C54.4143 140.31 54.6642 139.883 55.039 139.7L67.8413 133.102C68.2161 132.919 68.591 132.919 68.9658 133.102L81.768 139.7C82.1429 139.883 82.388 140.31 82.388 140.738V145.014ZM106.464 97.9137C106.464 98.3414 106.214 98.769 105.777 98.9523L96.6607 103.534C96.036 103.84 95.8486 104.573 96.1609 105.122L105.027 121.189C105.277 121.678 105.215 122.228 104.84 122.594L89.7262 137.134C89.2889 137.561 88.6641 137.561 88.1644 137.256L70.9313 125.099C70.369 124.671 70.2441 123.877 70.7439 123.327L84.4208 108.421C85.2329 107.505 84.2958 106.161 83.1713 106.527L68.7447 111.109C68.4948 111.17 68.2449 111.17 67.9951 111.109L53.6358 106.527C52.4488 106.161 51.5742 107.566 52.3863 108.421L66.0584 123.327C66.5582 123.877 66.4332 124.671 65.871 125.099L48.6379 137.256C48.1381 137.561 47.5134 137.561 47.0761 137.134L31.9671 122.533C31.5923 122.167 31.5298 121.617 31.7797 121.128L40.6461 105.061C40.9585 104.45 40.7086 103.778 40.1463 103.473L31.03 98.8912C30.6552 98.7079 30.3428 98.2803 30.3428 97.8526V65.8413C30.3428 64.9249 31.4049 64.314 32.217 64.8639L39.709 69.8122C40.0214 70.0565 40.2088 70.362 40.2088 70.7896L40.2713 79.0368C40.2713 79.4034 40.4587 79.7699 40.7711 80.0143L51.7616 87.5284C52.5737 88.0782 53.6983 87.4673 53.6358 86.4898L52.9486 71.9503C52.9486 71.5838 52.7612 71.2173 52.4488 71.034L30.8426 56.5556C30.5302 56.3112 30.3428 55.9447 30.3428 55.5781V48.4305C30.3428 48.1862 30.4053 47.8807 30.5927 47.6975L38.3971 38.0452C38.7094 37.6176 39.2717 37.4954 39.7715 37.6786L67.9326 47.8807C68.1825 48.0029 68.4948 48.0029 68.7447 47.8807L96.9106 37.6786C97.4104 37.4954 97.9679 37.6786 98.2802 38.0452L106.089 47.6975C106.277 47.8807 106.339 48.1862 106.339 48.4305V55.5781C106.339 55.9447 106.152 56.3112 105.84 56.5556L84.2333 71.034C84.0459 71.2783 83.8585 71.6449 83.8585 72.0114L83.1713 86.5509C83.1088 87.5284 84.2333 88.1393 85.0455 87.5895L96.036 80.0753C96.3484 79.831 96.5358 79.5255 96.5358 79.0979L96.5983 70.8507C96.5983 70.4842 96.7857 70.1176 97.098 69.8733L104.59 64.9249C105.402 64.3751 106.464 64.9249 106.464 65.9024V97.9137Z" 
    fill='#fffff'/> 
  </svg><b class="ml-2">OpenFPL</b>
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
            <li class="mx-2 flex items-center h-16">
              <button class="flex items-center justify-center px-4 py-2 bg-blue-500 text-white rounded-md shadow hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-300 focus:ring-opacity-50 nav-button" on:click={handleLogout}>
                Disconnect
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
            </li>
            
          </ul>
          <div class={`absolute top-12 right-2.5 bg-black rounded-lg shadow-md z-10 p-2 ${menuOpen ? 'block' : 'hidden'} md:hidden`}>
            <ul class="flex flex-col">
              <li class="p-2">    <a href="/" class={`nav-underline hover:text-gray-400 ${currentClass('/')}`} >Home</a>
              </li>
              <li class="p-2"><a href="/pick-team" class={currentClass('/pick-team')} on:click={toggleMenu}>Squad Selection</a></li>
              <li class="p-2"><a href="/governance" class={currentClass('/governance')} on:click={toggleMenu}>Governance</a></li>
              <li class="p-2"><a href="/profile" class={currentClass('/profile')} on:click={toggleMenu}>Profile</a></li>
              <li class="p-2">
                <button class="flex items-center justify-center px-4 py-2 bg-blue-500 text-white rounded-md shadow hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-300 focus:ring-opacity-50 nav-button" on:click={handleLogout}>
                  Disconnect
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
              </li>
            </ul>
          </div>
        {:else}
        <button class="flex items-center justify-center px-4 py-2 bg-blue-500 text-white rounded-md shadow hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-300 focus:ring-opacity-50 nav-button" on:click={handleLogin}>
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

