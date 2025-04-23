<script lang="ts">
    import MenuIcon from "$lib/icons/MenuIcon.svelte";
    import OpenFplIcon from "$lib/icons/OpenFPLIcon.svelte";
    
  interface Props {
    toggleMenu: () => void;
  }

  let { toggleMenu }: Props = $props();

  function handleMenuClick(event: MouseEvent) {
    event.stopPropagation();
    toggleMenu();
  }
</script>

<header class="z-30 flex items-center justify-between h-16 px-4 text-white shadow-md bg-BrandGray/90">
  <a 
    href="/" 
    class="flex items-center space-x-2 transition-transform hover:scale-105"
  >
    <OpenFplIcon className="w-6 h-6" currentColor='white' />
    <span class="logo-text hidden sm:block">Football God</span>
  </a>

  <div class="flex items-center gap-4">
    <button
      onclick={handleMenuClick}
      class="p-2 text-white transition-colors rounded-md bg-BrandBlueComp hover:bg-BrandBlue"
      aria-label="Toggle menu"
    >
      <MenuIcon className="w-6 h-6" fill="white" />
    </button>
  </div>
</header>