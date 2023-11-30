<script lang="ts">
  import { writable, get } from "svelte/store";
  import type {
    FantasyTeam,
    Team,
  } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import type { Bonus } from "$lib/types/Bonus";
  import { BonusType } from "$lib/enums/BonusType";
  import UseBonusModal from "$lib/components/pick-team/use-bonus-modal.svelte";
  import type { PlayerDTO } from "../../../../../declarations/player_canister/player_canister.did";

  export let fantasyTeam = writable<FantasyTeam | null>(null);
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
  let bonusPlayedThisGameweek = false;

  function showBonusModal(bonusId: number): void {
    selectedBonusId = bonusId;
    showModal = true;
  }

  function closeBonusModal(): void {
    showModal = false;
  }

  function isBonusUsed(bonusId: number): number | false {
    const team = get(fantasyTeam);

    if (!team) return false;

    switch (bonusId) {
      case 1:
        return team.goalGetterGameweek && team.goalGetterGameweek > 0
          ? team.goalGetterGameweek
          : false;
      case 2:
        return team.passMasterGameweek && team.passMasterGameweek > 0
          ? team.passMasterGameweek
          : false;
      case 3:
        return team.noEntryGameweek && team.noEntryGameweek > 0
          ? team.noEntryGameweek
          : false;
      case 4:
        return team.teamBoostGameweek && team.teamBoostGameweek > 0
          ? team.teamBoostGameweek
          : false;
      case 5:
        return team.safeHandsGameweek && team.safeHandsGameweek > 0
          ? team.safeHandsGameweek
          : false;
      case 6:
        return team.captainFantasticGameweek &&
          team.captainFantasticGameweek > 0
          ? team.captainFantasticGameweek
          : false;
      case 7:
        /* Coming soon: return team.prospectsGameweek && team.prospectsGameweek > 0 ? team.prospectsGameweek : false; */
        return false;
      case 8:
        /* Coming soon: team.countrymenGameweek && team.countrymenGameweek > 0 ? team.countrymenGameweek : false */
        return false;
      case 9:
        return team.braceBonusGameweek && team.braceBonusGameweek > 0
          ? team.braceBonusGameweek
          : false;
      case 10:
        return team.hatTrickHeroGameweek && team.hatTrickHeroGameweek > 0
          ? team.hatTrickHeroGameweek
          : false;
      default:
        return false;
    }
  }

function bonusPlayedThisWeek(): boolean {
  const team = get(fantasyTeam);

  if (!team) return false;
  let bonusPlayed: boolean = (team?.goalGetterGameweek == activeGameweek || 
    team?.passMasterGameweek == activeGameweek ||
    team?.noEntryGameweek == activeGameweek ||
    team?.teamBoostGameweek == activeGameweek ||
    team?.safeHandsGameweek == activeGameweek ||
    team?.captainFantasticGameweek == activeGameweek ||
    team?.braceBonusGameweek == activeGameweek ||
    team?.hatTrickHeroGameweek == activeGameweek);
    return bonusPlayed;
}
</script>

<div class="bonus-panel rounded-md mx-4 flex-1 mb-2 lg:mb-0">
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
    <h1 class="m-3 md:m-4 font-bold">Bonuses</h1>
  </div>
  <div class="flex flex-col xl:flex-row md:mx-2">
    <div class="flex items-center w-100 xl:w-1/2">
      {#each leftPanelBonuses as bonus}
        <div class="flex items-center w-1/5 bonus-panel-inner m-1 mt-2 rounded-lg border border-gray-700">
          <div class={`flex flex-col justify-center items-center flex-1`}>
            <img alt={bonus.name} src={bonus.image} class="h-12 m-2 mt-4 md:h-24 xl:h-20" />
            <div class="mt-1 mb-1 lg:p-2 p-1 lg:px-4 rounded-md min-h-[40px] flex items-center">
              <p class="text-center text-xxs sm:text-xs md:text-base font-bold xl:text-sm xl:min-h-[40px]">
                {bonus.name}
              </p>
            </div>
            
            {#if isBonusUsed(bonus.id)}
              <div class="w-full px-1 sm:px-4 mb-2 sm:mb-4 xl:min-h-[30px]">
                <p class="text-center text-xxs md:text-base xl:text-xs xl:mt-1">
                  Used GW{isBonusUsed(bonus.id)}
                </p>
              </div>
            {:else}
              {#if !bonusPlayedThisWeek()}
                <div class="w-full px-1 sm:px-4 mb-2 sm:mb-4">
                  <button on:click={() => showBonusModal(bonus.id)} class="fpl-purple-btn rounded-md w-full text-xs py-1 min-h-[30px] md:text-base">Use</button>
                </div>
              {:else}
                <div class="w-full px-1 sm:px-4 mb-2 sm:mb-4 xl:min-h-[30px]">
                  <p class="text-center text-xxs md:text-base xl:text-xs xl:mt-1">
                    1 Per Week
                  </p>
                </div>
              {/if}
            {/if}
          </div>
        </div>
      {/each}
    </div>
    <div class="flex items-center w-100 xl:w-1/2">
      {#each rightPanelBonuses as bonus}
        <div class="flex items-center w-1/5 bonus-panel-inner m-1 rounded-lg border border-gray-700">
          <div class={`flex flex-col justify-center items-center flex-1`}>
            <img alt={bonus.name} src={bonus.image} class="h-12 m-2 mt-4 md:h-24 xl:h-20" />
            <div class="mt-1 mb-1 lg:p-2 p-1 lg:px-4 rounded-md min-h-[40px] flex items-center">
              <p class="text-center text-xxs sm:text-xs md:text-base font-bold xl:text-sm xl:min-h-[40px]">
                {bonus.name}
              </p>
            </div>
            {#if isBonusUsed(bonus.id)}
              <div class="w-full px-1 sm:px-4 mb-2 sm:mb-4 xl:min-h-[30px]">
                <p class="text-center text-xxs md:text-base xl:text-xs xl:mt-1">
                  Used GW{isBonusUsed(bonus.id)}
                </p>
              </div>
            {:else if bonus.id == 7 || bonus.id == 8}
              <!-- Remove when implemented -->
                <div class="w-full px-1 sm:px-4 mb-2 sm:mb-4 xl:min-h-[30px]">
                  <p class="text-center text-xxs md:text-base xl:text-xs xl:mt-1">
                    Coming Soon
                  </p>
                </div>
            {:else}
              {#if !bonusPlayedThisWeek()}
                <div class="w-full px-1 sm:px-4 mb-2 sm:mb-4">
                  <button on:click={() => showBonusModal(bonus.id)} class="fpl-purple-btn rounded-md w-full text-xs py-1 min-h-[30px] md:text-base">Use</button>
                </div>
              {:else}
                <div class="w-full px-1 sm:px-4 mb-2 sm:mb-4 xl:min-h-[30px]">
                  <p class="text-center text-xxs md:text-base xl:text-xs xl:mt-1">
                    1 Per Week
                  </p>
                </div>
              {/if}
            {/if}
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
