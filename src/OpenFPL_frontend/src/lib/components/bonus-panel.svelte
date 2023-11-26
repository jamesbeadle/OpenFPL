<script lang="ts">
  import { writable } from 'svelte/store';
  import type { FantasyTeam, Team } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import type { Bonus } from "$lib/types/Bonus";
  import { BonusType } from "$lib/enums/BonusType";
  import UseBonusModal from "$lib/components/use-bonus-modal.svelte";
  import type { PlayerDTO } from '../../../../declarations/player_canister/player_canister.did';
  
  export let fantasyTeam = writable<FantasyTeam | null>(null);
  export let handleBonusSelection: (bonus: BonusType) => void;
  export let players: PlayerDTO[];
  export let teams: Team[];
  export let activeGameweek: number;
  
  let showModal: boolean = false;
  let selectedBonusId = 0;

  let bonuses: Bonus[] = [
    {
      id: 1,
      name: "Goal Getter",
      image: "goal-getter.png",
      description:
        "Select a player you think will score in a game to receive a X3 mulitplier for each goal scored.",
      selectionType: BonusType.PLAYER,
    },
    {
      id: 2,
      name: "Pass Master",
      image: "pass-master.png",
      description:
        "Select a player you think will assist in a game to receive a X3 mulitplier for each assist.",
      selectionType: BonusType.PLAYER,
    },
    {
      id: 3,
      name: "No Entry",
      image: "no-entry.png",
      description:
        "Select a goalkeeper or defender you think will keep a clean sheet to receive a X3 multipler on their total score.",
      selectionType: BonusType.PLAYER,
    },
    {
      id: 4,
      name: "Team Boost",
      image: "team-boost.png",
      description:
        "Receive a X2 multiplier from all players from a single club that are in your team.",
      selectionType: BonusType.TEAM,
    },
    {
      id: 5,
      name: "Safe Hands",
      image: "safe-hands.png",
      description:
        "Receive a X3 multiplier on your goalkeeper if they make 5 saves in a match.",
      selectionType: BonusType.AUTOMATIC,
    },
    {
      id: 6,
      name: "Captain Fantastic",
      image: "captain-fantastic.png",
      description:
        "Receive a X2 multiplier on your team captain's score if they score a goal in a match.",
      selectionType: BonusType.AUTOMATIC,
    },
    {
      id: 7,
      name: "Prospects",
      image: "prospects.png",
      description: "Receive a X2 multiplier for players under the age of 21.",
      selectionType: BonusType.AUTOMATIC,
    },
    {
      id: 8,
      name: "Countrymen",
      image: "countrymen.png",
      description:
        "Receive a X2 multiplier for players of a selected nationality.",
      selectionType: BonusType.COUNTRY,
    },
    {
      id: 9,
      name: "Brace Bonus",
      image: "brace-bonus.png",
      description:
        "Receive a X2 multiplier on a player's score if they score 2 or more goals in a game. Applies to every player who scores a brace.",
      selectionType: BonusType.AUTOMATIC,
    },
    {
      id: 10,
      name: "Hat-Trick Hero",
      image: "hat-trick-hero.png",
      description:
        "Receive a X3 multiplier on a player's score if they score 3 or more goals in a game. Applies to every player who scores a hat-trick.",
      selectionType: BonusType.AUTOMATIC,
    },
  ];
  let leftPanelBonuses = bonuses.slice(0, 5);
  let rightPanelBonuses = bonuses.slice(5, 10);

  function showBonusModal(bonusId: number): void {
    selectedBonusId = bonusId;
    showModal = true;
  }

  function closeBonusModal(): void {
    handleBonusSelection(selectedBonusId)
    showModal = false;
  }
</script>

<div class="bonus-panel rounded-md m-4 flex-1">
  {#if selectedBonusId > 0}
    <UseBonusModal
      {showModal}
      bonus={bonuses[selectedBonusId - 1]}
      {closeBonusModal}
      {players}
      {teams}
      {fantasyTeam}
      {activeGameweek}
    />
  {/if}
  <div class="flex flex-col md:flex-row bonus-panel-inner">
    <h1 class="m-4 font-bold">Bonuses</h1>
  </div>
  <div class="flex flex-col md:flex-row">
    <div class="flex items-center w-100 md:w-1/2">
      {#each leftPanelBonuses as bonus}
        <div
          class="flex items-center w-1/5 bonus-panel-inner m-1 md:m-4 rounded-lg border border-gray-700"
        >
          <div class={`flex flex-col justify-center items-center flex-1`}>
            <img alt={bonus.name} src={bonus.image} class="h-10 md:h-24 mt-2" />
            <p class="text-center text-xs mt-4 m-2 font-bold">
              {bonus.name}
            </p>
            <button
              on:click={() => showBonusModal(bonus.id)}
              class="fpl-purple-btn mt-4 mb-8 p-2 px-4 rounded-md min-w-[100px]"
              >Use</button
            >
          </div>
        </div>
      {/each}
    </div>
    <div class="flex items-center w-100 md:w-1/2">
      {#each rightPanelBonuses as bonus}
        <div
          class="flex items-center w-1/5 bonus-panel-inner m-1 md:m-4 rounded-lg border border-gray-700"
        >
          <div class={`flex flex-col justify-center items-center flex-1`}>
            <img alt={bonus.name} src={bonus.image} class="h-10 md:h-24 mt-2" />
            <p class="text-center text-xs mt-4 m-2 font-bold">
              {bonus.name}
            </p>
            <button
              on:click={() => showBonusModal(bonus.id)}
              class="fpl-purple-btn mt-4 mb-8 p-2 px-4 rounded-md min-w-[100px]"
              >Use</button
            >
          </div>
        </div>
      {/each}
    </div>
  </div>
</div>

<style>
  .bonus-panel-inner {
    background-color: rgba(46, 50, 58, 0.9);
  }

  .bonus-panel {
    background-color: rgba(46, 50, 58, 0.8);
  }
</style>
