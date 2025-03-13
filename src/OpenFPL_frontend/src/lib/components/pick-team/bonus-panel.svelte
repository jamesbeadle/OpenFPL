<script lang="ts">
  import { onMount } from "svelte";
  import { writable, type Writable } from "svelte/store";
  import { BonusType } from "$lib/enums/BonusType";
  import { leagueStore } from "$lib/stores/league-store";
  import { bonusPlayedThisWeek, isBonusUsed } from "$lib/utils/pick-team.helpers";
  import type { TeamSelectionDTO } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import type { Bonus } from "$lib/types/bonus";

  import UseBonusModal from "$lib/components/pick-team/modals/use-bonus-modal.svelte";
  import Tooltip from "$lib/components/shared/tooltip.svelte";

  export let fantasyTeam: Writable<TeamSelectionDTO | undefined>;

  let bonuses = writable<Bonus[]>([
    {
      id: 1,
      name: "Goal Getter",
      image: "/goal-getter.png",
      description:
        "Select a player you think will score in a game to receive a X3 mulitplier for each goal scored.",
      selectionType: BonusType.PLAYER,
      isUsed: isBonusUsed($fantasyTeam!, 1),
      usedGameweek: $fantasyTeam?.goalGetterGameweek ?? 0
    },
    {
      id: 2,
      name: "Pass Master",
      image: "/pass-master.png",
      description:
        "Select a player you think will assist in a game to receive a X3 mulitplier for each assist.",
      selectionType: BonusType.PLAYER,
      isUsed: isBonusUsed($fantasyTeam!, 2),
      usedGameweek: $fantasyTeam?.passMasterGameweek ?? 0
    },
    {
      id: 3,
      name: "No Entry",
      image: "/no-entry.png",
      description:
        "Select a goalkeeper or defender you think will keep a clean sheet to receive a X3 multipler on their total score.",
      selectionType: BonusType.PLAYER,
      isUsed: isBonusUsed($fantasyTeam!, 3),
      usedGameweek: $fantasyTeam?.noEntryGameweek ?? 0
    },
    {
      id: 4,
      name: "Team Boost",
      image: "/team-boost.png",
      description:
        "Receive a X2 multiplier from all players from a single club that are in your team.",
      selectionType: BonusType.TEAM,
      isUsed: isBonusUsed($fantasyTeam!, 4),
      usedGameweek: $fantasyTeam?.teamBoostGameweek ?? 0
    },
    {
      id: 5,
      name: "Safe Hands",
      image: "/safe-hands.png",
      description:
        "Receive a X3 multiplier on your goalkeeper if they make 5 saves in a match.",
      selectionType: BonusType.AUTOMATIC,
      isUsed: isBonusUsed($fantasyTeam!, 5),
      usedGameweek: $fantasyTeam?.safeHandsGameweek ?? 0
    },
    {
      id: 6,
      name: "Captain Fantastic",
      image: "/captain-fantastic.png",
      description:
        "Receive a X2 multiplier on your team captain's score if they score a goal in a match.",
      selectionType: BonusType.AUTOMATIC,
      isUsed: isBonusUsed($fantasyTeam!, 6),
      usedGameweek: $fantasyTeam?.captainFantasticGameweek ?? 0
    },
    {
      id: 7,
      name: "Prospects",
      image: "/prospects.png",
      description: "Receive a X2 multiplier for players under the age of 21.",
      selectionType: BonusType.AUTOMATIC,
      isUsed: isBonusUsed($fantasyTeam!, 7),
      usedGameweek: $fantasyTeam?.prospectsGameweek ?? 0
    },
    {
      id: 8,
      name: "One Nation",
      image: "/one-nation.png",
      description:
        "Receive a X2 multiplier for players of a selected nationality.",
      selectionType: BonusType.COUNTRY,
      isUsed: isBonusUsed($fantasyTeam!, 8),
      usedGameweek: $fantasyTeam?.oneNationGameweek ?? 0
    },
    {
      id: 9,
      name: "Brace Bonus",
      image: "/brace-bonus.png",
      description:
        "Receive a X2 multiplier on a player's score if they score 2 or more goals in a game. Applies to every player who scores a brace.",
      selectionType: BonusType.AUTOMATIC,
      isUsed: isBonusUsed($fantasyTeam!, 9),
      usedGameweek: $fantasyTeam?.braceBonusGameweek ?? 0
    },
    {
      id: 10,
      name: "Hat-Trick Hero",
      image: "/hat-trick-hero.png",
      description:
        "Receive a X3 multiplier on a player's score if they score 3 or more goals in a game. Applies to every player who scores a hat-trick.",
      selectionType: BonusType.AUTOMATIC,
      isUsed: isBonusUsed($fantasyTeam!, 10),
      usedGameweek: $fantasyTeam?.hatTrickHeroGameweek ?? 0
    },
  ]);

  let weeklyBonusPlayed = writable<Boolean>(false);

  $: if ($fantasyTeam) {
    updateBonuses();
    setWeeklyBonusPlayed();
  }

  async function setWeeklyBonusPlayed(){
    $weeklyBonusPlayed = bonusPlayedThisWeek($fantasyTeam!, $leagueStore);
    console.log("Bonus Played: " + $weeklyBonusPlayed);
  }

  function updateBonuses() {
    bonuses.update(bonusArray => {
      return bonusArray.map(bonus => ({
        ...bonus,
        isUsed: isBonusUsed($fantasyTeam!, bonus.id)
      }));
    });
  }

  onMount(async () => {
    updateBonuses();
    await setWeeklyBonusPlayed();
  });
  
  let showModal: boolean = false;
  let selectedBonusId = 0;
  let bonusUsedInSession = writable<boolean>(false);
    

  function showBonusModal(bonusId: number): void {
    selectedBonusId = bonusId;
    showModal = true;
  }

  function closeBonusModal(): void {
    showModal = false;
  }
</script>

<div class="bg-panel">
  {#if selectedBonusId > 0}
    <UseBonusModal
      bind:visible={showModal}
      bonus={$bonuses[selectedBonusId - 1]}
      {closeBonusModal}
      {fantasyTeam}
      {bonusUsedInSession}
      {updateBonuses}
      {bonuses}
    />
  {/if}
  <div class="flex flex-col md:flex-row bonus-panel-inner">
    <h1 class="m-4 text-lg lg:text-base">Bonuses</h1>
  </div>
  
  <div class="relative mt-2">
    <div class="overflow-x-auto overflow-y-visible">
      <div class="items-center hidden gap-2 px-1 pb-3 md:flex whitespace-nowrap">
        {#each $bonuses as bonus}
          <div class="w-[160px] mt-2 flex-shrink-0 border border-gray-700 rounded-lg bonus-panel-inner">
            <div class="flex flex-col items-center w-full">
              <div class="flex items-center justify-center w-full h-[80px]">
                  <Tooltip text={bonus.description}>
                    <img
                      alt={bonus.name}
                      src={bonus.image}
                      class="h-12 md:h-16"
                    />
                  </Tooltip>
              </div>
              
              <div class="w-full px-3 min-h-[60px] flex items-center justify-center">
                <p class="text-sm text-center">
                  {bonus.name}
                </p>
              </div>

              <div class="w-full px-3 pb-3">
                {#if bonus.isUsed}
                  <p class="text-sm text-center">
                    Used GW {bonus.usedGameweek}
                  </p>
                {:else if !$weeklyBonusPlayed}
                  <button
                    on:click={() => showBonusModal(bonus.id)}
                    class="w-full py-2 text-sm rounded-md bg-BrandPurple"
                  >Use</button>
                {:else}
                  <p class="text-sm text-center">1 Per Week</p>
                {/if}
              </div>
            </div>
          </div>
        {/each}
      </div>
    </div>
    <div class="absolute top-0 bottom-0 right-0 hidden w-12 pointer-events-none bg-gradient-to-l from-BrandBlack md:block"></div>
  </div>

  <!-- Mobile view -->
  <div class="flex flex-col mx-2 mb-3 md:hidden">
    {#each $bonuses as bonus}
      <div class="flex flex-row items-center bonus-panel-inner m-1 rounded-lg border border-gray-700 w-full min-h-[50px]">
        <div class="flex items-center justify-center w-2/12">
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
            <div class="flex justify-center w-full px-1">
              <button
                on:click={() => showBonusModal(bonus.id)}
                class="px-2 py-1 rounded-md bg-BrandPurple">View</button>
            </div>
          {:else}
            <div class="flex justify-center w-full px-1">
              <p class="text-center">1 Per Week</p>
            </div>
          {/if}
        </div>
      </div>
    {/each}
  </div>
</div>