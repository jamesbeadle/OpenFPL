<script lang="ts">
	import { toasts } from '$lib/stores/toasts-store';
	import ToastItem from './toast-item.svelte';
	import { fly } from 'svelte/transition';
  </script>
  
  {#each $toasts as toast (toast.id)}
	<div in:fly={{ y: 20, duration: 200 }}>
	  <ToastItem toast={toast} />
	</div>
  {/each}
  