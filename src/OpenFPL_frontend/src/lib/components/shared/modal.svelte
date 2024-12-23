<script lang="ts">
    import { onDestroy, onMount } from "svelte";
    import CrossIcon from "$lib/icons/CrossIcon.svelte";
  
    export let showModal: boolean;
    export let onClose: () => void;
    export let title: string;
  
    let modalElement: HTMLDivElement;
    let startOnBackdrop = false;
  
    const handleKeydown = (e: KeyboardEvent) => {
      if (e.key === 'Escape' && showModal) {
        onClose();
      }
    };
  
    if (typeof window !== "undefined") {
      window.addEventListener("keydown", handleKeydown);
    }
  
    onDestroy(() => {
      if (typeof window !== "undefined") {
        window.removeEventListener("keydown", handleKeydown);
      }
    });
  
    const handlePointerDown = (e: PointerEvent) => {
      if (e.target === e.currentTarget) {
        startOnBackdrop = true;
      } else {
        startOnBackdrop = false;
      }
    };
  
    const handlePointerUp = (e: PointerEvent) => {
      if (startOnBackdrop && e.target === e.currentTarget) {
        onClose();
      }
      startOnBackdrop = false;
    };
  
    onMount(() => {
      if (modalElement && showModal) {
        modalElement.focus();
      }
    });
  </script>
  
  {#if showModal}
    <div
      class="fixed inset-0 z-40 bg-black bg-opacity-50 flex items-center justify-center backdrop-blur-sm"
      role="dialog"
      aria-modal="true"
      tabindex="-1"
      on:pointerdown={handlePointerDown}
      on:pointerup={handlePointerUp}
    >
      <div
        bind:this={modalElement}
        class="bg-BrandYellow rounded-lg shadow-lg max-w-lg md:max-w-3xl w-full mx-4 text-black outline-none focus:outline-none"
        tabindex="-1"
      >
        <header class="flex items-center justify-between py-2 px-6">
          <h2 class="text-3xl condensed">{title}</h2>
          <button
            type="button"
            class="text-black"
            aria-label="Close modal"
            on:click={onClose}
          >
            <CrossIcon className="w-6" />
          </button>
        </header>
        <div class="bg-white p-6 rounded-b-lg overflow-auto max-h-[80vh]">
          <slot />
        </div>
      </div>
    </div>
  {/if}