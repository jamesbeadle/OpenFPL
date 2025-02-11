<script lang="ts">
	import { onMount } from 'svelte';
	import { toasts } from '$lib/stores/toasts-store';
	import type { Toast } from '$lib/stores/toasts-store';
    import { appStore } from '$lib/stores/app-store';

	export let toast: Toast;

	let timer: ReturnType<typeof setTimeout> | null = null;

	onMount(() => {
		if (toast.duration && toast.duration > 0) {
			timer = setTimeout(closeToast, toast.duration);
		}
	});

	function closeToast() {
		toasts.removeToast(toast.id);
	}

	function updateFrontend(){
		appStore.updateFrontend();
	}
</script>

<div class={`fixed top-0 left-0 right-0 z-[9999] p-4 text-white shadow-md flex justify-between items-center bg-${toast.type}`}>
  <span>{toast.message}</span>
  {#if toast.type == "frontend-update"}
	<button on:click={updateFrontend} class="brand-button">Update FootballGod</button>
  {/if}
  <button class="font-bold ml-4" on:click={closeToast}>
    &times;
  </button>
</div>
