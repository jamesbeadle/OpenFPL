<script lang="ts">
    import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
    import type { ClubDTO, PlayerDTO } from "../../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    
    export let header: string;
    export let nextFixtureHomeTeam: ClubDTO | undefined;
    export let nextFixtureAwayTeam: ClubDTO | undefined;
    let highestScoringPlayer: PlayerDTO | null = null;
</script>

<div class="flex-grow">
    <p class="content-panel-header">{header}</p>
    
    <div class="py-2 flex space-x-4">
        <a
          class="flex flex-col items-center justify-center"
          href={`/club?id=${
            nextFixtureHomeTeam ? nextFixtureHomeTeam.id : -1
          }`}
        >
          <BadgeIcon className="header-badge" club={nextFixtureHomeTeam!} />
          <span class="content-panel-header">
            {nextFixtureHomeTeam ? nextFixtureHomeTeam.abbreviatedName : ""}
          </span>
        </a>
        <a
          class="flex flex-col items-center justify-center"
          href={`/club?id=${
            nextFixtureAwayTeam ? nextFixtureAwayTeam.id : -1
          }`}
        >
          <BadgeIcon className="header-badge" club={nextFixtureAwayTeam!}
          />
          <span class="content-panel-header">{
            nextFixtureAwayTeam ? nextFixtureAwayTeam.abbreviatedName : ""}
          </span>
        </a>
    </div>
</div>