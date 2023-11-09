<script lang="ts">
  import { page } from '$app/stores';

  let menuOpen = false;
  const routes = ["/home", "/pick-team", "/governance", "/profile"];
  let currentClass: string[] = [];

  $: currentClass = routes.map(route => $page.url.pathname === route ? 'active' : '');

  function toggleMenu() {
    menuOpen = !menuOpen;
  }
</script>

<header>
  <nav class="text-white">
    <div class="px-4  w-100 flex justify-between items-center">
      <a href="/" class="text-white hover:text-gray-400">
        <img src="logo.png" alt="Logo" class="h-8 w-auto logo">
      </a>
      <button class="burger-btn md:hidden" on:click={toggleMenu}>
        <svg width="24" height="18" viewBox="0 0 24 18" fill="none" xmlns="http://www.w3.org/2000/svg">
          <rect width="24" height="2" rx="1" fill="currentColor"/>
          <rect y="8" width="24" height="2" rx="1" fill="currentColor"/>
          <rect y="16" width="24" height="2" rx="1" fill="currentColor"/>
        </svg>      
      </button>
      <ul class="menu">
        <li class="mx-2"><a href="/home" class="text-white hover:text-gray-400 {currentClass[0]}">Home</a></li>
        <li class="mx-2"><a href="/pick-team" class="text-white hover:text-gray-400 {currentClass[1]}">Squad Selection</a></li>
        <li class="mx-2"><a href="/governance" class="text-white hover:text-gray-400 {currentClass[2]}">Governance</a></li>
        <li class="mx-2"><a href="/profile" class="text-white hover:text-gray-400 {currentClass[3]}">Profile</a></li>
      </ul>
    </div>
    
    <div class={menuOpen ? 'menu-open' : ''}>
      <ul class="mobile-menu">
        <li><a href="/home" class="{currentClass[0]}" on:click={toggleMenu}>Home</a></li>
        <li><a href="/pick-team" class="{currentClass[1]}" on:click={toggleMenu}>Squad Selection</a></li>
        <li><a href="/governance" class="{currentClass[2]}" on:click={toggleMenu}>Governance</a></li>
        <li><a href="/profile" class="{currentClass[3]}" on:click={toggleMenu}>Profile</a></li>
      </ul>
    </div>

  </nav>
</header>



<style>
    
  .mobile-menu {
      display: none;
  }

  .logo {
    width: 144px;
    height: auto;
    padding: 16px;
  }
  .active {
    color: #3C71FA;
  }
  
  .menu {
    display: none;
    flex-direction: column;
    align-items: center;
    width: 100%;
  }

  .show-menu {
    display: flex;
  }

  @media (min-width: 768px) {
    .menu {
      display: flex;
      flex-direction: row;
      align-items: center;
      width: auto;
    }
  }

  .burger-btn {
    background: none;
    border: none;
    cursor: pointer;
  }

  .burger-btn:focus {
    outline: none;
  }

  .mobile-menu {
    display: none;
    position: absolute;
    top: 50px;
    right: 10px;
    background-color: #000;
    border-radius: 10px;
    box-shadow: 0px 0px 15px rgba(0, 0, 0, 0.1);
    z-index: 1000;
  }

  .mobile-menu li {
    padding: 10px 20px;
  }

  .menu-open .mobile-menu {
    display: block;
  }

  @media (min-width: 768px) { 
      .mobile-menu {
          display: none !important; 
      }
  }
  
</style>
