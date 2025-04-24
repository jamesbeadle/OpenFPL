<script lang="ts">
    import type { Fixture, MostValuablePlayer } from "../../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    import { clubStore } from "$lib/stores/club-store";
    import { playerStore } from "$lib/stores/player-store";

    interface Props {
        mvps: MostValuablePlayer[];
        fixture: Fixture;
    }

    let { mvps, fixture }: Props = $props();

</script>

{#each mvps as mvp}
    {@const homeClub = $clubStore.find(x => x.id == fixture.homeClubId)!}
    {@const awayClub = $clubStore.find(x => x.id == fixture.awayClubId)!}
    {@const player = $playerStore.find(x => x.id == mvp.playerId)!}
    <div class="flex flex-col">
        <div>{player.firstName} {player.lastName}</div>
        <div>{homeClub.friendlyName} v {awayClub.friendlyName}</div>
        <div>Gameweek Points{mvp.points}</div>
    </div>
{/each}