<script lang="ts">
  import { quintOut } from 'svelte/easing';
  import { fade, scale } from 'svelte/transition';
  import { onMount } from 'svelte';
  import type { Snippet } from 'svelte';
  import CloseIcon from '$lib/icons/CloseIcon.svelte';
 
  interface ModalOptions {
    selector?: string;
    backdropClass?: string;
    onClickOutside?: (event: MouseEvent) => void;
    onEscape?: (event: KeyboardEvent) => void;
  }

  function modal(node: HTMLElement, options?: ModalOptions) {
    const { selector, backdropClass, onClickOutside, onEscape } = options || {};

    let modalParent: HTMLElement;
    if (selector) {
      const query = document.querySelector(selector);
      if (query) modalParent = query as HTMLElement;
      else throw new Error(`No existing node that matches selector "${selector}"`);
    } else {
      modalParent = document.body;
    }

    const backdrop = document.createElement('div');
    if (backdropClass) backdrop.classList.add(...backdropClass.split(' ').filter(Boolean));
    backdrop.append(node);
    modalParent.append(backdrop);

    const onClick = (e: MouseEvent) => {
      console.log('Backdrop clicked', e.target, e.currentTarget);
      const eventPath = e.composedPath();
      const modalContent = node.querySelector('[data-modal-content]');
      console.log('Modal content found:', modalContent);
      console.log('Event path:', eventPath);

      const isClickInsideModal = modalContent && eventPath.includes(modalContent);
      if (isClickInsideModal) {
        console.log('Click was inside modal content, ignoring');
        return;
      }

      console.log('Click was outside modal content, calling onClickOutside');
      onClickOutside?.(e);
    };

    if (onClickOutside) backdrop.addEventListener('click', onClick);

    const onKeyDown = (e: KeyboardEvent) => {
      if (e.key === 'Escape') onEscape?.(e);
    };
    if (onEscape) window.addEventListener('keydown', onKeyDown);

    const focusableElements = node.querySelectorAll(
      'a[href], button, textarea, input, select, [tabindex]:not([tabindex="-1"])'
    );
    const firstFocusable = focusableElements[0] as HTMLElement;
    const lastFocusable = focusableElements[focusableElements.length - 1] as HTMLElement;

    const trapFocus = (e: KeyboardEvent) => {
      if (e.key === 'Tab') {
        if (e.shiftKey && document.activeElement === firstFocusable) {
          e.preventDefault();
          lastFocusable.focus();
        } else if (!e.shiftKey && document.activeElement === lastFocusable) {
          e.preventDefault();
          firstFocusable.focus();
        }
      }
    };

    node.addEventListener('keydown', trapFocus);
    firstFocusable?.focus();

    return {
      destroy() {
        backdrop.remove();
        window.removeEventListener('keydown', onKeyDown);
        node.removeEventListener('keydown', trapFocus);
      }
    };
  }

  interface Props {
    onClose: () => void;
    title: string;
    children: Snippet;
  }

  let { children, onClose, title }: Props = $props();
  let visible = $state(true);

  const close = () => {
    visible = false;
    onClose();
  };

  const onCloseHandler = (event: MouseEvent) => {
    event.stopPropagation();
    close();
  };

  const onEscapeHandler = (event: KeyboardEvent) => {
    close();
  };

  onMount(() => {
    document.body.style.overflow = 'hidden';
    return () => {
      document.body.style.overflow = '';
    };
  });
</script>

{#if visible}
  <div
    class="modal-background"
    use:modal={{
      backdropClass: 'fixed inset-0 bg-black bg-opacity-50 cursor-pointer z-40',
      onClickOutside: onCloseHandler,
      onEscape: onEscapeHandler
    }}
    out:fade={{ duration: 200 }}
    role="dialog"
    aria-labelledby="modalTitle"
    aria-describedby="modalContent"
    tabindex="-1"
  >
  <div
    transition:scale={{ delay: 25, duration: 150, easing: quintOut }}
    class="relative w-full max-w-4xl mx-auto p-4 sm:p-6 z-50"
  >
  <div
  class="bg-gray-800 border border-gray-600 rounded-lg h-[80vh] shadow-2xl flex flex-col"
  data-modal-content
>
  <div class="flex-none px-6 py-4 sm:px-8 sm:py-6 border-b border-gray-600">
    <div class="flex items-center justify-between">
      <h3 id="modalTitle" class="text-2xl text-white md:text-3xl font-semibold">{title}</h3>
      <button
        onclick={close}
        class="p-2 rounded-lg hover:bg-gray-700 transition-colors"
        aria-label="Close modal"
      >
        <CloseIcon className="w-6 h-6" fill="white" />
      </button>
    </div>
  </div>
  <div id="modalContent" class="flex-1 px-6 py-6 overflow-y-auto sm:px-8 sm:py-6">
    {@render children()}
  </div>
</div>
  </div>
  </div>
{/if}