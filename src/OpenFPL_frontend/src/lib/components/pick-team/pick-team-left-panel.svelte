<script lang="ts">
  import PickTeamPlayers from "./pick-team-players.svelte";
  import BonusPanel from "./bonus-panel.svelte";
  import type { TeamSetup } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

  interface Props {
    fantasyTeam: TeamSetup | undefined;
    teamValue: number;
    pitchView: boolean;
    selectedFormation: string;
    sessionAddedPlayers: number[];
  }
  let { fantasyTeam, teamValue, pitchView, selectedFormation, sessionAddedPlayers }: Props = $props();
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