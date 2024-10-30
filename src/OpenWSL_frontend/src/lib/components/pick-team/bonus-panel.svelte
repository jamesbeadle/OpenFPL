<script lang="ts">
  import { onMount } from "svelte";
  import { systemStore } from "$lib/stores/system-store";
  import { writable, type Writable } from "svelte/store";
  import type { PickTeamDTO } from "../../../../../declarations/OpenWSL_backend/OpenWSL_backend.did";
  import type { Bonus } from "$lib/types/bonus";
  import { BonusType } from "$lib/enums/BonusType";
  import UseBonusModal from "$lib/components/pick-team/modals/use-bonus-modal.svelte";
  import Tooltip from "../tooltip.svelte";
    import { storeManager } from "$lib/managers/store-manager";

  export let fantasyTeam: Writable<PickTeamDTO | null>;

  let bonuses = writable<Bonus[]>([
    {
      id: 1,
      name: "Goal Getter",
      image: "/goal-getter.png",
      description:
        "Select a player you think will score in a game to receive a X3 mulitplier for each goal scored.",
      selectionType: BonusType.PLAYER,
      isUsed: isBonusUsed(1),
      usedGameweek: $fantasyTeam?.goalGetterGameweek ?? 0
    },
    {
      id: 2,
      name: "Pass Master",
      image: "/pass-master.png",
      description:
        "Select a player you think will assist in a game to receive a X3 mulitplier for each assist.",
      selectionType: BonusType.PLAYER,
      isUsed: isBonusUsed(2),
      usedGameweek: $fantasyTeam?.passMasterGameweek ?? 0
    },
    {
      id: 3,
      name: "No Entry",
      image: "/no-entry.png",
      description:
        "Select a goalkeeper or defender you think will keep a clean sheet to receive a X3 multipler on their total score.",
      selectionType: BonusType.PLAYER,
      isUsed: isBonusUsed(3),
      usedGameweek: $fantasyTeam?.noEntryGameweek ?? 0
    },
    {
      id: 4,
      name: "Team Boost",
      image: "/team-boost.png",
      description:
        "Receive a X2 multiplier from all players from a single club that are in your team.",
      selectionType: BonusType.TEAM,
      isUsed: isBonusUsed(4),
      usedGameweek: $fantasyTeam?.teamBoostGameweek ?? 0
    },
    {
      id: 5,
      name: "Safe Hands",
      image: "/safe-hands.png",
      description:
        "Receive a X3 multiplier on your goalkeeper if they make 5 saves in a match.",
      selectionType: BonusType.AUTOMATIC,
      isUsed: isBonusUsed(5),
      usedGameweek: $fantasyTeam?.safeHandsGameweek ?? 0
    },
    {
      id: 6,
      name: "Captain Fantastic",
      image: "/captain-fantastic.png",
      description:
        "Receive a X2 multiplier on your team captain's score if they score a goal in a match.",
      selectionType: BonusType.AUTOMATIC,
      isUsed: isBonusUsed(6),
      usedGameweek: $fantasyTeam?.captainFantasticGameweek ?? 0
    },
    {
      id: 7,
      name: "Prospects",
      image: "/prospects.png",
      description: "Receive a X2 multiplier for players under the age of 21.",
      selectionType: BonusType.AUTOMATIC,
      isUsed: isBonusUsed(7),
      usedGameweek: $fantasyTeam?.prospectsGameweek ?? 0
    },
    {
      id: 8,
      name: "One Nation",
      image: "/one-nation.png",
      description:
        "Receive a X2 multiplier for players of a selected nationality.",
      selectionType: BonusType.COUNTRY,
      isUsed: isBonusUsed(8),
      usedGameweek: $fantasyTeam?.oneNationGameweek ?? 0
    },
    {
      id: 9,
      name: "Brace Bonus",
      image: "/brace-bonus.png",
      description:
        "Receive a X2 multiplier on a player's score if they score 2 or more goals in a game. Applies to every player who scores a brace.",
      selectionType: BonusType.AUTOMATIC,
      isUsed: isBonusUsed(9),
      usedGameweek: $fantasyTeam?.braceBonusGameweek ?? 0
    },
    {
      id: 10,
      name: "Hat-Trick Hero",
      image: "/hat-trick-hero.png",
      description:
        "Receive a X3 multiplier on a player's score if they score 3 or more goals in a game. Applies to every player who scores a hat-trick.",
      selectionType: BonusType.AUTOMATIC,
      isUsed: isBonusUsed(10),
      usedGameweek: $fantasyTeam?.hatTrickHeroGameweek ?? 0
    },
  ]);

  let weeklyBonusPlayed = writable<Boolean>(false);

  $: if ($fantasyTeam) {
    updateBonuses();
    $weeklyBonusPlayed = bonusPlayedThisWeek();
  }

  function updateBonuses() {
    bonuses.update(bonusArray => {
      return bonusArray.map(bonus => ({
        ...bonus,
        isUsed: isBonusUsed(bonus.id)
      }));
    });
  }

  onMount(async () => {
    await storeManager.syncStores();
    updateBonuses();
    $weeklyBonusPlayed = bonusPlayedThisWeek();
  });
  let showModal: boolean = false;
  let selectedBonusId = 0;

  $: leftPanelBonuses = $bonuses.slice(0, 5);
  $: rightPanelBonuses = $bonuses.slice(5, 10);
  let bonusUsedInSession = writable<boolean>(false);

  function showBonusModal(bonusId: number): void {
    selectedBonusId = bonusId;
    showModal = true;
  }

  function closeBonusModal(): void {
    showModal = false;
  }

  function isBonusUsed(bonusId: number): boolean {
    if (!$fantasyTeam) return false;
    switch (bonusId) {
      case 1:
        return $fantasyTeam.goalGetterGameweek &&
          $fantasyTeam.goalGetterGameweek > 0
          ? true
          : false;
      case 2:
        return $fantasyTeam.passMasterGameweek &&
          $fantasyTeam.passMasterGameweek > 0
          ? true
          : false;
      case 3:
        return $fantasyTeam.noEntryGameweek && $fantasyTeam.noEntryGameweek > 0
          ? true
          : false;
      case 4:
        return $fantasyTeam.teamBoostGameweek &&
          $fantasyTeam.teamBoostGameweek > 0
          ? true
          : false;
      case 5:
        return $fantasyTeam.safeHandsGameweek &&
          $fantasyTeam.safeHandsGameweek > 0
          ? true
          : false;
      case 6:
        return $fantasyTeam.captainFantasticGameweek &&
          $fantasyTeam.captainFantasticGameweek > 0
          ? true
          : false;
      case 7:
        return $fantasyTeam.prospectsGameweek &&
          $fantasyTeam.prospectsGameweek > 0
          ? true
          : false;
      case 8:
        $fantasyTeam.oneNationGameweek && $fantasyTeam.oneNationGameweek > 0
          ? true
          : false;
        return false;
      case 9:
        return $fantasyTeam.braceBonusGameweek &&
          $fantasyTeam.braceBonusGameweek > 0
          ? true
          : false;
      case 10:
        return $fantasyTeam.hatTrickHeroGameweek &&
          $fantasyTeam.hatTrickHeroGameweek > 0
          ? true
          : false;
      default:
        return false;
    }
  }

  function bonusPlayedThisWeek(): boolean {
    if (!$fantasyTeam) return false;
    let activeGameweek = $systemStore?.pickTeamGameweek;
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

<div class="bg-panel rounded-md flex-1 my-4 lg:mb-0">
  {#if selectedBonusId > 0}
    <UseBonusModal
      visible={showModal}
      bonus={$bonuses[selectedBonusId - 1]}
      {closeBonusModal}
      {fantasyTeam}
      {bonusUsedInSession}
      {updateBonuses}
      {bonuses}
    />
  {/if}
  <div class="flex flex-col md:flex-row bonus-panel-inner">
    <h1 class="m-3 md:m-4">Bonuses</h1>
  </div>
  <div class="flex flex-col xl:flex-row">
    <div class="hidden md:flex items-center w-full xl:w-1/2">
      {#each leftPanelBonuses as bonus}
        <div
          class="flex items-center w-1/5 bonus-panel-inner m-1 md:m-2 xl:m-1 my-2 md:my-3 lg:my-4 rounded-lg border border-gray-700"
        >
          <div class={`flex flex-col justify-center items-center flex-1`}>
            <Tooltip text={bonus.description}>
              <img
                alt={bonus.name}
                src={bonus.image}
                class="h-12 m-2 xl:m-1 mt-4 xl:mt-4 md:h-16"
              />
            </Tooltip>
            <div
              class="mt-1 mb-1 lg:p-2 p-1 lg:px-4 rounded-md flex items-center min-h-[50px] xl:min-h-[60px]"
            >
              <p class="text-center smaller-text">
                {bonus.name}
              </p>
            </div>

            {#if bonus.isUsed}
              <div class="w-full px-1 sm:px-4 mb-2 sm:mb-4 xl:min-h-[40px]">
                <p class="text-center xl:mt-1 smaller-text">
                  Used GW {bonus.usedGameweek}
                </p>
              </div>
            {:else if !$weeklyBonusPlayed}
              <div class="w-full px-1 sm:px-4 mb-2 sm:mb-4">
                <button
                  on:click={() => showBonusModal(bonus.id)}
                  class="fpl-purple-btn rounded-md w-full py-1 min-h-[40px] smaller-text"
                  >View</button
                >
              </div>
            {:else}
              <div class="w-full px-1 sm:px-4 mb-2 sm:mb-4 xl:min-h-[40px]">
                <p class="text-center xl:mt-1 smaller-text">1 Per Week</p>
              </div>
            {/if}
          </div>
        </div>
      {/each}
    </div>
    <div class="hidden md:flex items-center w-full xl:w-1/2">
      {#each rightPanelBonuses as bonus}
        <div
          class="flex items-center w-1/5 bonus-panel-inner m-1 my-2 md:m-2 xl:m-1 rounded-lg border border-gray-700"
        >
          <div class={`flex flex-col justify-center items-center flex-1`}>
            <Tooltip text={bonus.description}>
              <img
                alt={bonus.name}
                src={bonus.image}
                class="h-12 m-2 xl:m-1 mt-4 xl:mt-4 md:h-16"
              />
            </Tooltip>

            <div
              class="mt-1 mb-1 lg:p-2 p-1 lg:px-4 rounded-md flex items-center min-h-[50px] xl:min-h-[60px]"
            >
              <p class="text-center smaller-text">
                {bonus.name}
              </p>
            </div>
            {#if bonus.isUsed}
              <div class="w-full px-1 sm:px-4 mb-2 sm:mb-4 xl:min-h-[40px]">
                <p class="text-center xl:mt-1 smaller-text">
                  Used GW {bonus.usedGameweek}
                </p>
              </div>
            {:else if !$weeklyBonusPlayed}
              <div class="w-full px-1 sm:px-4 mb-2 sm:mb-4">
                <button
                  on:click={() => showBonusModal(bonus.id)}
                  class="fpl-purple-btn rounded-md w-full py-1 min-h-[40px] smaller-text"
                  >Use</button
                >
              </div>
            {:else}
              <div class="w-full px-1 sm:px-4 mb-2 sm:mb-4 xl:min-h-[40px]">
                <p class="text-center xl:mt-1 smaller-text">1 Per Week</p>
              </div>
            {/if}
          </div>
        </div>
      {/each}
    </div>
  </div>

  <div class="flex md:hidden flex-col md:mx-2">
    <div class="flex items-center flex-col mt-1 mx-2 mb-1">
      {#each $bonuses as bonus}
        <div
          class="flex flex-row items-center bonus-panel-inner m-1 rounded-lg border border-gray-700 w-full min-h-[50px]"
        >
          <div class="w-2/12 flex items-center justify-center">
            <Tooltip text={bonus.description}>
              <img
                alt={bonus.name}
                src={bonus.image}
                class="min-w-[30px] max-w-[30px]"
              />
            </Tooltip>
          </div>
          <div class="w-6/12">
            <p class="ml-4">
              {bonus.name}
            </p>
          </div>
          <div class="w-4/12">
            {#if bonus.isUsed}
              <div class="w-full px-1">
                <p class="text-center">
                  Used GW {bonus.usedGameweek}
                </p>
              </div>
            {:else if !$weeklyBonusPlayed}
              <div class="w-full px-1 flex justify-center">
                <button
                  on:click={() => showBonusModal(bonus.id)}
                  class="fpl-purple-btn rounded-md py-1 px-2">View</button
                >
              </div>
            {:else}
              <div class="w-full px-1 flex justify-center">
                <p class="text-center">1 Per Week</p>
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
</style>
