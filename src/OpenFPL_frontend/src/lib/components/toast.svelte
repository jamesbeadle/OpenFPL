<script lang="ts">
  import { onMount } from "svelte";
  import { toastStore } from "$lib/stores/toast-store";
  let isScrolled = false;

  function updateScroll() {
    isScrolled = window.pageYOffset > 0;
  }

  onMount(() => {
    window.addEventListener("scroll", updateScroll);
    return () => {
      window.removeEventListener("scroll", updateScroll);
    };
  });
</script>

{#if $toastStore.visible}
  <div
    class={`fixed inset-x-0 ${
      isScrolled ? "top-0" : "bottom-0"
    } toast-panel text-white text-center py-2 ${$toastStore.type}`}
  >
    {$toastStore.message}
  </div>
{/if}

<style>
  @keyframes fadeIn {
    from {
      opacity: 0;
    }
    to {
      opacity: 1;
    }
  }

  @keyframes fadeOut {
    from {
      opacity: 1;
    }
    to {
      opacity: 0;
    }
  }

  .toast-panel {
    animation-name: fadeIn, fadeOut;
    animation-duration: 0.2s, 1s;
    animation-delay: 0s, 2s;
    animation-fill-mode: forwards;
  }
</style>
