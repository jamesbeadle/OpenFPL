<script lang="ts">
    import { governanceStore } from "$lib/stores/governance-store";
    import { systemStore } from "$lib/stores/system-store";
    import { Modal } from "@dfinity/gix-components";
    import type { FixtureDTO } from "../../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

    interface UploadData {
        id: number,
        gameweek: number,
        kickOff: number,
        homeClubId: number,
        awayClubId: number
    }

    export let visible: boolean;
    export let cancelModal: () => void;

    let file: File | null = null;
    let fixtureData: FixtureDTO[] = [];

    $: isSubmitDisabled = fixtureData.length == 0;

    let showConfirm = false;
    async function handleFileChange(event: Event) {
        const input = event.target as HTMLInputElement;
        if (!input.files || input.files.length === 0) {
            return;
        }
        file = input.files[0];
        await processFile(file);
    }
    
    async function processFile(file: File) {
        const text = await file.text();
        let uploadedData = parseCSV(text) as UploadData[];
        let fixtureData = uploadedData.map(mapUploadDataToFixtureDTO);
        await governanceStore.addInitialFixtures($systemStore?.calculationSeasonId ?? 0, fixtureData);
    }
    
    function mapUploadDataToFixtureDTO(uploadData: UploadData): FixtureDTO {
        return {
            id: uploadData.id,
            gameweek: uploadData.gameweek,
            kickOff: BigInt(uploadData.kickOff),
            homeClubId: uploadData.homeClubId,
            awayClubId: uploadData.awayClubId,
            status: { Unplayed: null },
            highestScoringPlayerId: 0,
            seasonId: 0,
            events: [],
            homeGoals: 0,
            awayGoals: 0,
        };
    }


    function parseCSV(csvText: string): any[] {
        const rows = csvText.split('\n');
        return rows.map(row => {
        const columns = row.split(',');
            return {
                id: parseInt(columns[0]),
                gameweek: parseInt(columns[1]),
                kickOff: parseInt(columns[2]),
                homeClubId: parseInt(columns[3]),
                awayClubId: parseInt(columns[4])
            };
        });
    }

    function raiseProposal(){
        showConfirm = true;
    }

    async function confirmProposal(){
        await governanceStore.addInitialFixtures($systemStore?.calculationSeasonId ?? 0, fixtureData);
    }
</script>

<Modal {visible} on:nnsClose={cancelModal}>
    <div class="p-4">
        <div class="flex justify-between items-center my-2">
        <h3 class="default-header">Add Initial Fixtures</h3>
        <button class="times-button" on:click={cancelModal}>&times;</button>
        </div>

        <div class="flex justify-start items-center w-full">
            <div class="ml-4">
                <p>Please select a file to upload:</p>
                <input type="file" accept=".csv" on:change="{handleFileChange}" />                
                    <div class="items-center py-3 flex space-x-4">
                        <button
                        class="px-4 py-2 default-button fpl-cancel-btn"
                        type="button"
                        on:click={cancelModal}
                        >
                        Cancel
                        </button>
                        <button
                            class={`${isSubmitDisabled ? "bg-gray-500" : "fpl-purple-btn"} 
                            px-4 py-2 default-button`}
                            on:click={raiseProposal}
                            disabled={isSubmitDisabled}>
                            Raise Proposal
                        </button>
                    </div>

                    {#if showConfirm}
                        <div class="items-center py-3 flex">
                            <p class="text-orange-700">Failed proposals will cost the proposer 10 $FPL tokens.</p>
                        </div>
                        <div class="items-center py-3 flex">
                            
                            <button
                                class={`${isSubmitDisabled ? "bg-gray-500" : "fpl-purple-btn"} 
                                px-4 py-2 default-button w-full`}
                                on:click={confirmProposal}
                                disabled={isSubmitDisabled}>
                                Confirm Submit Proposal
                            </button>
                        </div>
                    {/if}
            </div>
        </div>
    </div>
</Modal>
