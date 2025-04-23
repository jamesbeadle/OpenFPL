<script lang="ts">
    import { onDestroy, onMount, type Snippet } from "svelte";
    import CrossIcon from "$lib/icons/CrossIcon.svelte";
  
    interface Props {
      showModal: boolean;
      onClose: () => void;
      title: string;
      closeOnClickOutside?: boolean;
      children: Snippet;
    }

    let { showModal, onClose, title, closeOnClickOutside = true, children }: Props = $props();
  
    let modalElement: HTMLDivElement | undefined = $state(undefined);
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
      if (closeOnClickOutside && startOnBackdrop && e.target === e.currentTarget) {
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
      class="fixed inset-0 z-40 flex items-center justify-center bg-black bg-opacity-50 backdrop-blur-sm"
      role="dialog"
      aria-modal="true"
      tabindex="-1"
      onpointerdown={handlePointerDown}
      onpointerup={handlePointerUp}
    >
      <div
        bind:this={modalElement}
        class="w-full max-w-lg mx-4 text-white rounded shadow outline-none bg-BrandBlack md:max-w-3xl focus:outline-none"
        tabindex="-1"
      >
        <header class="flex items-center justify-between p-4">
          <h2 class="text-xl condensed">{title}</h2>
          <button
            type="button"
            class="text-black"
            aria-label="Close modal"
            onclick={onClose}
          >
            <CrossIcon className="w-4" fill='white' />
          </button>
        </header>
        <div class="bg-Brand p-6 rounded-b-lg overflow-auto max-h-[80vh]">
          <div class=""></div>
          {@render children()}
        </div>
      </div>
    </div>
  {/if}