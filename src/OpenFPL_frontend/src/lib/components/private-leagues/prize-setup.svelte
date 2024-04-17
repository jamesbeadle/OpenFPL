<script lang="ts">
    import { writable } from "svelte/store";
    import type { CreatePrivateLeagueDTO } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

    
    export let privateLeague = writable<CreatePrivateLeagueDTO | null>(null);
</script>