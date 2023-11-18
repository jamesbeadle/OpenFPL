<script lang="ts">
    export let showModal: boolean;
    export let closeBonusModal: () => void;
    export let bonusName = '';
    export let bonusDescription = '';
</script>
<style>
    .modal-backdrop {
        z-index: 1000;
    }
</style>
{#if showModal}
<div class="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full modal-backdrop" on:click={closeBonusModal} on:keydown={closeBonusModal}>
    <div class="relative top-20 mx-auto p-5 border w-96 shadow-lg rounded-md bg-white">
        <div class="mt-3 text-center">
            <h3 class="text-lg leading-6 font-medium text-gray-900">
                {bonusName}
            </h3>
            <div class="mt-2 px-7 py-3">
                <p class="text-sm text-gray-500">
                    {bonusDescription}
                </p>
            </div>
            <div class="items-center px-4 py-3">
                <button id="ok-btn" class="px-4 py-2 bg-blue-500 text-white text-base font-medium rounded-md w-full shadow-sm hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-300"
                    on:click={closeBonusModal}>
                    Use
                </button>
            </div>
        </div>
    </div>
</div>
{/if}
