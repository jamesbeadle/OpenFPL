<script lang="ts">
  import { writable } from "svelte/store";
  import type {
    FantasyTeam,
    Team,
  } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import type { Bonus } from "$lib/types/bonus";
  import { BonusType } from "$lib/enums/BonusType";
  import UseBonusModal from "$lib/components/pick-team/use-bonus-modal.svelte";

  export let fantasyTeam = writable<FantasyTeam | null>(null);
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
  export let bonusUsedInSession = writable<boolean>(false);

  function showBonusModal(bonusId: number): void {
    selectedBonusId = bonusId;
    showModal = true;
  }

  function closeBonusModal(): void {
    showModal = false;
  }

  function isBonusUsed(bonusId: number): number | false {
    if (!$fantasyTeam) return false;

    switch (bonusId) {
      case 1:
        return $fantasyTeam.goalGetterGameweek &&
          $fantasyTeam.goalGetterGameweek > 0
          ? $fantasyTeam.goalGetterGameweek
          : false;
      case 2:
        return $fantasyTeam.passMasterGameweek &&
          $fantasyTeam.passMasterGameweek > 0
          ? $fantasyTeam.passMasterGameweek
          : false;
      case 3:
        return $fantasyTeam.noEntryGameweek && $fantasyTeam.noEntryGameweek > 0
          ? $fantasyTeam.noEntryGameweek
          : false;
      case 4:
        return $fantasyTeam.teamBoostGameweek &&
          $fantasyTeam.teamBoostGameweek > 0
          ? $fantasyTeam.teamBoostGameweek
          : false;
      case 5:
        return $fantasyTeam.safeHandsGameweek &&
          $fantasyTeam.safeHandsGameweek > 0
          ? $fantasyTeam.safeHandsGameweek
          : false;
      case 6:
        return $fantasyTeam.captainFantasticGameweek &&
          $fantasyTeam.captainFantasticGameweek > 0
          ? $fantasyTeam.captainFantasticGameweek
          : false;
      case 7:
        /* Coming soon: return $fantasyTeam.prospectsGameweek && $fantasyTeam.prospectsGameweek > 0 ? $fantasyTeam.prospectsGameweek : false; */
        return false;
      case 8:
        /* Coming soon: $fantasyTeam.countrymenGameweek && $fantasyTeam.countrymenGameweek > 0 ? $fantasyTeam.countrymenGameweek : false */
        return false;
      case 9:
        return $fantasyTeam.braceBonusGameweek &&
          $fantasyTeam.braceBonusGameweek > 0
          ? $fantasyTeam.braceBonusGameweek
          : false;
      case 10:
        return $fantasyTeam.hatTrickHeroGameweek &&
          $fantasyTeam.hatTrickHeroGameweek > 0
          ? $fantasyTeam.hatTrickHeroGameweek
          : false;
      default:
        return false;
    }
  }

  function bonusPlayedThisWeek(): boolean {
    if (!$fantasyTeam) return false;
    let bonusPlayed: boolean =
      $fantasyTeam?.goalGetterGameweek == activeGameweek ||
      $fantasyTeam?.passMasterGameweek == activeGameweek ||
      $fantasyTeam?.noEntryGameweek == activeGameweek ||
      $fantasyTeam?.teamBoostGameweek == activeGameweek ||
      $fantasyTeam?.safeHandsGameweek == activeGameweek ||
      $fantasyTeam?.captainFantasticGameweek == activeGameweek ||
      $fantasyTeam?.braceBonusGameweek == activeGameweek ||
      $fantasyTeam?.hatTrickHeroGameweek == activeGameweek;
    return bonusPlayed;
  }
</script>

<div class="bonus-panel rounded-md mx-4 flex-1 mb-2 lg:mb-0">
  {#if selectedBonusId > 0}
    <UseBonusModal
      visible={showModal}
      bonus={bonuses[selectedBonusId - 1]}
      {closeBonusModal}
      {fantasyTeam}
      {activeGameweek}
      {bonusUsedInSession}
    />
  {/if}
  <div class="flex flex-col md:flex-row bonus-panel-inner">
    <h1 class="m-3 md:m-4 font-bold">Bonuses</h1>
  </div>
  <div class="flex flex-col xl:flex-row md:mx-2">
    <div class="flex items-center w-100 xl:w-1/2">
      {#each leftPanelBonuses as bonus}
        <div
          class="flex items-center w-1/5 bonus-panel-inner m-1 mt-2 rounded-lg border border-gray-700"
        >
          <div class={`flex flex-col justify-center items-center flex-1`}>
            <img
              alt={bonus.name}
              src={bonus.image}
              class="h-12 m-2 mt-4 md:h-24 xl:h-20"
            />
            <div
              class="mt-1 mb-1 lg:p-2 p-1 lg:px-4 rounded-md min-h-[40px] flex items-center"
            >
              <p
                class="text-center text-xxs sm:text-xs md:text-base font-bold xl:text-sm xl:min-h-[40px]"
              >
                {bonus.name}
              </p>
            </div>

            {#if isBonusUsed(bonus.id)}
              <div class="w-full px-1 sm:px-4 mb-2 sm:mb-4 xl:min-h-[30px]">
                <p class="text-center text-xxs md:text-base xl:text-xs xl:mt-1">
                  Used GW{isBonusUsed(bonus.id)}
                </p>
              </div>
            {:else if !bonusPlayedThisWeek()}
              <div class="w-full px-1 sm:px-4 mb-2 sm:mb-4">
                <button
                  on:click={() => showBonusModal(bonus.id)}
                  class="fpl-purple-btn rounded-md w-full text-xs py-1 min-h-[30px] md:text-base"
                  >Use</button
                >
              </div>
            {:else}
              <div class="w-full px-1 sm:px-4 mb-2 sm:mb-4 xl:min-h-[30px]">
                <p class="text-center text-xxs md:text-base xl:text-xs xl:mt-1">
                  1 Per Week
                </p>
              </div>
            {/if}
          </div>
        </div>
      {/each}
    </div>
    <div class="flex items-center w-100 xl:w-1/2">
      {#each rightPanelBonuses as bonus}
        <div
          class="flex items-center w-1/5 bonus-panel-inner m-1 rounded-lg border border-gray-700"
        >
          <div class={`flex flex-col justify-center items-center flex-1`}>
            <img
              alt={bonus.name}
              src={bonus.image}
              class="h-12 m-2 mt-4 md:h-24 xl:h-20"
            />
            <div
              class="mt-1 mb-1 lg:p-2 p-1 lg:px-4 rounded-md min-h-[40px] flex items-center"
            >
              <p
                class="text-center text-xxs sm:text-xs md:text-base font-bold xl:text-sm xl:min-h-[40px]"
              >
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
            {:else if !bonusPlayedThisWeek()}
              <div class="w-full px-1 sm:px-4 mb-2 sm:mb-4">
                <button
                  on:click={() => showBonusModal(bonus.id)}
                  class="fpl-purple-btn rounded-md w-full text-xs py-1 min-h-[30px] md:text-base"
                  >Use</button
                >
              </div>
            {:else}
              <div class="w-full px-1 sm:px-4 mb-2 sm:mb-4 xl:min-h-[30px]">
                <p class="text-center text-xxs md:text-base xl:text-xs xl:mt-1">
                  1 Per Week
                </p>
              </div>
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
