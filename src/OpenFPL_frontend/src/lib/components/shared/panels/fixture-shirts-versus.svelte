<script lang="ts">
    import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
    import type { ClubDTO, FixtureDTO } from "../../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

    export let fixture: FixtureDTO;
    export let homeClub: ClubDTO;
    export let awayClub: ClubDTO;
</script>
<div class="w-5 md:w-10 items-center justify-center mr-1 md:mr-4">
  <a href={`/club?id=${fixture.homeClubId}`}>
    <BadgeIcon club={homeClub} className="h-4" />
  </a>
</div>
<span>v</span>
<div class="w-5 md:w-10 items-center justify-center ml-1 md:ml-4">
  <a href={`/club?id=${fixture.awayClubId}`}>
    <BadgeIcon club={awayClub} className="h-4" />
  </a>
</div>