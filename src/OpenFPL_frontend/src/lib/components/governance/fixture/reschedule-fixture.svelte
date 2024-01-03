<script lang="ts">
    import { teamStore } from "$lib/stores/team-store";
import { Modal } from "@dfinity/gix-components";
    import type { ClubDTO } from "../../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

    export let visible: boolean;
    export let closeDetailModal: () => void;

    let gameweeks = Array.from({ length: 38 }, (_, i) => i + 1);
    let selectedGameweek: number;
    
    let date = '';
    let time = '';
    let dateTime = '';
    let isPostponed = false;

    $: dateTime = date + 'T' + time;

    function getTeamById(teamId: number): ClubDTO {
    return $teamStore.find((x) => x.id === teamId)!;
    }
</script>

<Modal {visible} on:nnsClose={closeDetailModal}>
    <div class="p-4">
        <div class="flex justify-between items-center my-2">
        <h3 class="default-header">Reschedule Fixture</h3>
        <button class="times-button" on:click={closeDetailModal}>&times;</button>
        </div>

        <div class="flex justify-start items-center w-full">
            <div class="ml-4">
                <p>Reschedule Fixture:</p>

                <p>Select Gameweek:</p>
     
                <select
                    class="p-2 fpl-dropdown text-center mx-0 md:mx-2 min-w-[100px]"
                    bind:value={selectedGameweek}
                >
                    {#each gameweeks as gameweek}
                        <option value={gameweek}>Gameweek {gameweek}</option>
                    {/each}
                </select>
                
                <select
                    class="p-2 fpl-dropdown text-center mx-0 md:mx-2 min-w-[100px]"
                    bind:value={selectedFixtureId}
                >
                    {#each gameweekFixtures as fixture}
                        {@const homeTeam = getTeamById(fixture.homeClubId)}
                        {@const awayTeam = getTeamById(fixture.awayClubId)}
                        <option value={fixture.id}>{homeTeam.friendlyName} v {awayTeam.friendlyName}</option>
                    {/each}
                </select>

                <p>Postpone Fixture:</p>
                <input type="checkbox" bind:checked={isPostponed} />

                {#if !isPostponed}
                    <p>Select Date:</p>
                    <input type="date" bind:value={date} class="input input-bordered" />
                                
                    <p>Select Time:</p>
                    <input type="time" bind:value={time} class="input input-bordered" />

                    <p>Updated Gameweek:</p>

                    <select
                        class="p-2 fpl-dropdown text-center mx-0 md:mx-2 min-w-[100px]"
                        bind:value={selectedGameweek}
                    >
                        {#each gameweeks as gameweek}
                            <option value={gameweek}>Gameweek {gameweek}</option>
                        {/each}
                    </select>
                {/if}
              
                <!-- //TODO: 
              
    seasonId : T.SeasonId;
    fixtureId : T.FixtureId;
    updatedFixtureGameweek : T.GameweekNumber;
    updatedFixtureDate : Int;
                -->
            </div>
        </div>
    </div>
</Modal>
