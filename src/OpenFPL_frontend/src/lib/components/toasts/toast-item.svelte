<script lang="ts">
	import { onMount } from 'svelte';
	import { toasts } from '$lib/stores/toasts-store';
	import type { Toast } from '$lib/stores/toasts-store';
  
	export let toast: Toast;
  
	let timer: ReturnType<typeof setTimeout> | null = null;
  
	onMount(() => {
	  if (toast.duration && toast.duration > 0) {
		timer = setTimeout(() => closeToast(), toast.duration);
	  }
	});
  
	function closeToast() {
	  toasts.removeToast(toast.id);
	}
  </script>
  
  <div
	class="fixed right-0 top-0 m-4 p-4 bg-gray-800 text-white rounded shadow-md"
	style="max-width: 300px"
  >
	<div class="flex items-start">
	  <div class="flex-1">
		<p class="mb-0">{toast.message}</p>
	  </div>
	  <button class="ml-2" on:click={closeToast}>×</button>
	</div>
  </div>
  