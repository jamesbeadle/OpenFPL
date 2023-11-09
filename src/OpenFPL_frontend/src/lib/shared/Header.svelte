  <script lang="ts">
    import { page } from '$app/stores';

    let menuOpen = false;
    const routes = ["/", "/pick-team", "/governance", "/profile"];
    
    $: currentClass = (route: string) => $page.url.pathname === route ? 'text-blue-500' : '';
    
    function toggleMenu() {
      menuOpen = !menuOpen;
    }
  </script>

  <header>
    <nav class="text-white">
      <div class="px-4 flex justify-between items-center w-full">
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
        <ul class="hidden md:flex">
          <li class="mx-2"><a href="/" class={`hover:text-gray-400 ${currentClass('/')}`}>Home</a></li>
          <li class="mx-2"><a href="/pick-team" class={`hover:text-gray-400 ${currentClass('/pick-team')}`}>Squad Selection</a></li>
          <li class="mx-2"><a href="/governance" class={`hover:text-gray-400 ${currentClass('/governance')}`}>Governance</a></li>
          <li class="mx-2"><a href="/profile" class={`hover:text-gray-400 ${currentClass('/profile')}`}>Profile</a></li>
        </ul>
      </div>
      
      <div class={`absolute top-12 right-2.5 bg-black rounded-lg shadow-md z-10 p-2 ${menuOpen ? 'block' : 'hidden'} md:hidden`}>
        <ul class="flex flex-col">
          <li class="p-2"><a href="/" class={currentClass('/')} on:click={toggleMenu}>Home</a></li>
          <li class="p-2"><a href="/pick-team" class={currentClass('/pick-team')} on:click={toggleMenu}>Squad Selection</a></li>
          <li class="p-2"><a href="/governance" class={currentClass('/governance')} on:click={toggleMenu}>Governance</a></li>
          <li class="p-2"><a href="/profile" class={currentClass('/profile')} on:click={toggleMenu}>Profile</a></li>
        </ul>
      </div>

    </nav>
  </header>

