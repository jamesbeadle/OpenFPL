<script lang="ts">
    import type { Bonus } from "$lib/types/Bonus";

    export let showModal: boolean;
    export let closeBonusModal: () => void;
    export let bonus: Bonus = {
        id: 0,
        name: '',
        description: '',
        image: '',
        selectionType: 0
    };
</script>
<style>
    .modal-backdrop {
        z-index: 1000;
    }
</style>
{#if showModal}
<div class="fixed inset-0 bg-gray-900 bg-opacity-80 overflow-y-auto h-full w-full modal-backdrop" on:click={closeBonusModal} on:keydown={closeBonusModal}>
    <div class="relative top-20 mx-auto p-5 border w-96 shadow-lg rounded-md bg-panel text-white">
        <img src={bonus.image} class="w-16 mx-auto block" alt={bonus.name} />
        <div class="mt-3 text-center">
            <h3 class="text-lg leading-6 font-medium">
                {bonus.name}
            </h3>
            <div class="mt-2 px-7 py-3">
                <p class="text-sm">
                    {bonus.description}
                </p>
            </div>
            <div class="items-center px-4 py-3 flex space-x-4">
                <button id="ok-btn" class="px-4 py-2 fpl-cancel-btn text-white text-base font-medium rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300"
                    on:click={closeBonusModal}>
                    Cancel
                </button>
                <button id="ok-btn" class="px-4 py-2 fpl-purple-btn text-white text-base font-medium rounded-md w-full shadow-sm  focus:outline-none focus:ring-2 focus:ring-blue-300"
                    on:click={closeBonusModal}>
                    Use
                </button>
            </div>
        </div>
    </div>
</div>
{/if}
