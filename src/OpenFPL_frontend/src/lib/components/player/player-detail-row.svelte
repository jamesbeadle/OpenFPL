<script lang="ts">
    import type { Player } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

    interface Props {
        player: Player;
    }

    let { player }: Props = $props();
</script>
<p>{player.firstName} {player.lastName}</p>