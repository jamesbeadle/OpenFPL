<script lang="ts">
    import type { PlayerDetailDTO } from "../../../../declarations/player_canister/player_canister.did";


    export let showModal: boolean;
    export let closeDetailModal: () => void;
    export let playerDetail: PlayerDetailDTO;
</script>
<style>
    .modal-backdrop {
        z-index: 1000;
    }
</style>
{#if showModal}
<div class="fixed inset-0 bg-gray-900 bg-opacity-80 overflow-y-auto h-full w-full modal-backdrop" on:click={closeDetailModal} on:keydown={closeDetailModal}>
    <div class="relative top-20 mx-auto p-5 border w-96 shadow-lg rounded-md bg-panel text-white">
        <div class="mt-3 text-center">
            <h1>{playerDetail.lastName}</h1>
        </div>
    </div>
</div>
{/if}
