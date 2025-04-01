<script lang="ts">
  import type { Writable } from "svelte/store";
  import PickTeamPlayers from "./pick-team-players.svelte";
  import BonusPanel from "./bonus-panel.svelte";
    import type { TeamSetup } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

  export let fantasyTeam: Writable<TeamSetup | undefined>;
  export let pitchView: Writable<boolean>;
  export let selectedFormation: Writable<string>;
  export let teamValue: Writable<number>;
  export let sessionAddedPlayers: Writable<number[]>;
</script>

<div class="flex flex-col w-full">
  <PickTeamPlayers 
    {fantasyTeam} 
    {pitchView} 
    {selectedFormation} 
    {teamValue} 
    {sessionAddedPlayers} 
  />
  <div class="w-full mt-2">
    <BonusPanel {fantasyTeam} />
  </div>
</div> 