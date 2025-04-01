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

	$: bgColorClass = 
		toast.type === 'success' ? 'bg-BrandSuccess' :
		toast.type === 'error' ? 'bg-BrandRed' :
		toast.type === 'info' ? 'bg-BrandInfo' :
		toast.type === 'frontend-update' ? 'bg-BrandSlateGray' :
		'bg-BrandInfo';

	$: textColorClass = toast.type === 'success' ? 'text-BrandGray' : 'text-white';
</script>

<div class={`fixed top-0 left-0 right-0 z-[9999] p-4 shadow-md flex justify-between items-center ${bgColorClass} ${textColorClass}`}>
  <span>{toast.message}</span>
  {#if toast.type == "frontend-update"}
	<button on:click={updateFrontend} class="fpl-button">Update OpenFPL</button>
  {/if}
  <button class="ml-4 font-bold" on:click={closeToast}>
    &times;
  </button>
</div>
