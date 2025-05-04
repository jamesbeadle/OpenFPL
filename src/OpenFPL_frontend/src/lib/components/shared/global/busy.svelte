<script lang="ts">
	import { isNullish, nonNullish } from '@dfinity/utils';
	import { fade } from 'svelte/transition';
	import { busy } from '$lib/stores/busy-store';
	import { handleKeyPress } from '$lib/utils/keyboard.utils';

    import LocalSpinner from './local-spinner.svelte';

	const close = () => {
		if (isNullish($busy) || !$busy.close) {
			return;
		}

		busy.stop();
	};
</script>

{#if nonNullish($busy)}
	<div
		role="button"
		tabindex="-1"
		transition:fade
		onclick={close}
		class:close={$busy.close}
		onkeypress={($event) => handleKeyPress({ $event, callback: close })}
	>
		<div class="inset-0 fixed z-[calc(var(--z-index)+1000)] bg-black bg-opacity-50 flex justify-center items-center flex-col">
			{#if $busy.spinner}
				<div>
					<LocalSpinner />
				</div>
			{/if}

			{#if $busy.close}
				<button 
                    onclick={(event) => { event.stopPropagation(); close(); }}
                    class="self-end m-2 text-xs text-white"
                >
                    Cancel 
                </button>
			{/if}
		</div>
	</div>
{/if}