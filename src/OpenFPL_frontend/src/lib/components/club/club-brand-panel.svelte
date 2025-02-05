<script lang="ts">
    import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
    import ShirtIcon from "$lib/icons/ShirtIcon.svelte";
    import type { ClubDTO } from "../../../../../declarations/data_canister/data_canister.did";

    export let club: ClubDTO;
</script>

<div class="flex-grow flex flex-col items-center">
  <p class="content-panel-header">
    {club.friendlyName}
  </p>
  <div class="py-2 flex space-x-4">
    <BadgeIcon club={club} className="h-4" />
    <ShirtIcon className="h-4" club={club} />
  </div>
  <p class="content-panel-header">
    {club.abbreviatedName}
  </p>
</div>