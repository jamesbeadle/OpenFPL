<script lang="ts">
  import { goto } from "$app/navigation";
    import { signOut } from "$lib/services/auth-services";
  import type { MenuItem } from "$lib/types/menu";

  interface Props {
    isMenuOpen: boolean;
    toggleMenu: () => void;
  }
  let { isMenuOpen, toggleMenu }: Props = $props();
  
  let menuRef: HTMLDivElement;

  async function handleDisconnect(){
    await signOut();
    goto('/', { replaceState: true });
  }

  const menuItems: MenuItem[] = [
    { path: '/', label: 'Home' },
    { path: '/pick-team', label: 'Apps' },
    { path: '/profile', label: 'Profile' },
    { path: '/', label: 'Sign Out' }
  ]
</script>
<div 
  class="{isMenuOpen ? 'translate-x-0' : 'translate-x-full'} fixed inset-y-0 right-0 z-40 w-full sm:w-80 bg-BrandSlateGray shadow-xl transform transition-transform duration-300 ease-in-out"
  bind:this={menuRef}
>

  <button
    onclick={toggleMenu}
    class="absolute p-2 transition-all duration-200 text-white top-4 right-4 hover:text-BrandBlack hover:scale-110"
    aria-label="Close sidebar"
  >
    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
    </svg>
  </button>

  <nav class="h-full px-6 pt-16 text-lg text-white bg-BrandBlueComp cta-text">
    <ul class="space-y-4">
      {#each menuItems as item}
        <li>
          <a 
            href={item.path}
            onclick={(e) => {
              e.preventDefault();
              toggleMenu();
              if (item.label === 'Sign Out') {
                handleDisconnect();
              } else {
                goto(item.path);
              }
            }}
            class="hover:text-BrandBlue"
          >
            {item.label}
          </a>
        </li>
      {/each}
    </ul>
  </nav>
</div>