<script lang="ts">
    import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
import type { Team } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    import type { PlayerDetailDTO } from "../../../../declarations/player_canister/player_canister.did";
    import { getFlagComponent } from "../../utils/Helpers";


    export let showModal: boolean;
    export let closeDetailModal: () => void;
    export let playerDetail: PlayerDetailDTO;
    export let playerTeam: Team | null;
</script>
<style>
    .modal-backdrop {
        z-index: 1000;
    }
</style>
{#if showModal}
    <div class="fixed inset-0 bg-gray-900 bg-opacity-80 overflow-y-auto h-full w-full modal-backdrop" on:click={closeDetailModal} on:keydown={closeDetailModal}>
        <div class="relative top-20 mx-auto p-5 border border-gray-700 w-96 shadow-lg rounded-md bg-panel text-white" on:click|stopPropagation on:keydown|stopPropagation>
            
            <div class="flex justify-between items-center">
                <h3 class="text-xl font-semibold text-white">Player Detail</h3>                
                <button class="text-white text-3xl" on:click={closeDetailModal}>&times;</button>
            </div>
            
            <div class="flex justify-start items-center w-full">
                <svelte:component class="h-20 w-20" this={getFlagComponent(playerDetail.nationality)} />
                <div class="ml-4">
                    <h3 class="text-2xl mb-2">{playerDetail.firstName} {playerDetail.lastName}</h3>
                    <p class="text-sm text-gray-400 flex items-center">
                        <BadgeIcon
                            className="w-5 h-5 mr-2"
                            primaryColour={playerTeam?.primaryColourHex}
                            secondaryColour={playerTeam?.secondaryColourHex}
                            thirdColour={playerTeam?.thirdColourHex}
                        />
                        {playerTeam?.friendlyName}</p>
                </div>
            </div>
            

            
            <div class="text-center">
                <div class="mt-2">
                    <div class="flex justify-between items-center mt-4">
                        <div class="text-sm font-medium">Appearance</div>
                        <div class="text-sm">1</div>
                    </div>
                </div>
            </div>

            <div class="mt-4 pt-4 border-t border-gray-200">
                <div class="flex justify-between">
                    <span class="text-base font-medium text-gray-400">Total Points:</span>
                    <span class="text-base font-medium">111</span>
                </div>
            </div>
        </div>
    </div>
{/if}
