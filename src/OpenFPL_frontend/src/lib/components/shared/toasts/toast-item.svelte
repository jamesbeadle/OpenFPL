<script lang="ts">
	import { onMount } from 'svelte';
	import {toastsStore } from '$lib/stores/toasts-store';
	import type { Toast } from '$lib/stores/toasts-store';
    import { appStore } from '$lib/stores/app-store';

	interface Props {
		toast: Toast;
    }
    let { toast }: Props = $props();


	let timer: ReturnType<typeof setTimeout> | null = null;
	let bgColorClass = $state("");
	let textColorClass = $state("");

	onMount(() => {
		if (toast.duration && toast.duration > 0) {
			timer = setTimeout(closeToast, toast.duration);
		}
	});
  
	$effect(() => {
		bgColorClass = 
			toast.type === 'success' ? 'bg-BrandSuccess' :
			toast.type === 'error' ? 'bg-BrandRed' :
			toast.type === 'info' ? 'bg-BrandInfo' :
			toast.type === 'frontend-update' ? 'bg-BrandSlateGray' :
			'bg-BrandInfo';
			textColorClass = toast.type === 'success' ? 'text-BrandGray' : 'text-white';
	});

	function closeToast() {
		toasts.removeToast(toast.id);
	}

	function updateFrontend(){
		appStore.updateFrontend();
	}

</script>

<div class={`fixed top-0 left-0 right-0 z-[9999] p-4 shadow-md flex justify-between items-center ${bgColorClass} ${textColorClass}`}>
  <span>{toast.message}</span>
  {#if toast.type == "frontend-update"}
	<button onclick={updateFrontend} class="fpl-button">Update OpenFPL</button>
  {/if}
  <button class="ml-4 font-bold" onclick={closeToast}>
    &times;
  </button>
</div>
