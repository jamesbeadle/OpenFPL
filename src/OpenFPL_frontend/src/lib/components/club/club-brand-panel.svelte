<script lang="ts">
    import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
    import ShirtIcon from "$lib/icons/ShirtIcon.svelte";
    import type { Club } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

    interface Props {
      club: Club;
    }
    let {  club }: Props = $props();

</script>

<div class="flex flex-col items-center flex-grow">
  <p class="content-panel-header">
    {club.friendlyName}
  </p>
  <div class="flex py-2 space-x-4">
    <BadgeIcon club={club} className="h-4" />
    <ShirtIcon className="h-4" club={club} />
  </div>
  <p class="content-panel-header">
    {club.abbreviatedName}
  </p>
</div>