<script lang="ts">
  import { onMount } from "svelte";
  import { writable, type Writable } from "svelte/store";
  import { systemStore } from "$lib/stores/system-store";
  import { playerStore } from "$lib/stores/player-store";
  import { managerStore } from "$lib/stores/manager-store";
  import { busyStore } from "@dfinity/gix-components";
  import { toastsError, toastsShow } from "$lib/stores/toasts-store";
  import type { PickTeamDTO } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import { allFormations, getAvailableFormations, getHighestValuedPlayerId, getTeamFormation } from "$lib/utils/pick-team.helpers";
  import { convertPlayerPosition } from "$lib/utils/helpers";
  import SetTeamName from "./set-team-name.svelte";
  import LocalSpinner from "../local-spinner.svelte";

  export let fantasyTeam: Writable<PickTeamDTO>;
  export let pitchView: Writable<boolean>;
  export let selectedFormation: Writable<string>;
  export let availableFormations: Writable<string[]>;
  export let transfersAvailable: Writable<number>;
  export let bankBalance: Writable<number>;
  
  let isSaveButtonActive: boolean;

  let activeSeason: string;
  let activeGameweek: number;
  let newUsername = writable("");

  let showUsernameModal = false;

  let bonusUsedInSession = false;
  let transferWindowPlayed = false;
  let transferWindowPlayedInSession = false;
  let isLoading = true;

  $: if ($fantasyTeam && $playerStore.length > 0) {
    disableInvalidFormations();
    isSaveButtonActive = checkSaveButtonConditions();
  }

  $: {
    if ($fantasyTeam) {
      if ($fantasyTeam.playerIds.filter((x) => x > 0).length == 11) {
        const newFormation = getTeamFormation($fantasyTeam, $playerStore);
        $selectedFormation = newFormation;
      }
    }
  }

  onMount(async () => {
    try {
      await systemStore.sync();
      await playerStore.sync();
      loadData();
      disableInvalidFormations()
      console.log($systemStore)
    } catch (error) {
      toastsError({
        msg: { text: "Error loading pick team buttons." },
        err: error,
      });
      console.error("Error loading pick team buttons:", error);
    } finally {
      isLoading = false;
    }
  });
  
  async function loadData() {
    activeSeason = $systemStore?.pickTeamSeasonName ?? "-";
    activeGameweek = $systemStore?.pickTeamGameweek ?? 1;

    const storedViewMode = localStorage.getItem("viewMode");
    if (storedViewMode) {
      pitchView.set(storedViewMode === "pitch");
    }

    let transferWindowGameweek = $fantasyTeam?.transferWindowGameweek ?? 0;
    transferWindowPlayed = transferWindowGameweek > 0;

    fantasyTeam.update((currentTeam) => {
      if (
        currentTeam &&
        (!currentTeam.playerIds || currentTeam.playerIds.length !== 11)
      ) {
        return {
          ...currentTeam,
          playerIds: new Uint16Array(11).fill(0),
        };
      }
      return currentTeam;
    });
  }

  function showPitchView() {
    pitchView.set(true);
  }

  function showListView() {
    pitchView.set(false);
  }

  function disableInvalidFormations() {
    if (!$fantasyTeam || !$fantasyTeam.playerIds || $fantasyTeam.principalId == '') {
      availableFormations.set(Object.keys(allFormations));
      return;
    }

    const formations = getAvailableFormations($playerStore, $fantasyTeam);
    availableFormations.set(formations);
  }

  function checkSaveButtonConditions(): boolean {
    const teamCount = new Map();
    for (const playerId of $fantasyTeam?.playerIds || []) {
      if (playerId > 0) {
        const player = $playerStore.find((p) => p.id === playerId);
        if (player) {
          teamCount.set(player.clubId, (teamCount.get(player.clubId) || 0) + 1);
          if (teamCount.get(player.clubId) > 2) {
            return false;
          }
        }
      }
    }

    if($systemStore?.onHold){
      return false;
    }

    if (!isBonusConditionMet($fantasyTeam)) {
      return false;
    }

    if ($fantasyTeam?.playerIds.filter((id) => id > 0).length !== 11) {
      return false;
    }

    if ($bankBalance < 0) {
      return false;
    }

    if ($transfersAvailable < 0) {
      return false;
    }

    if (!isValidFormation($fantasyTeam, $selectedFormation)) {
      return false;
    }

    console.log("checked conditions")

    return true;
  }

  function isBonusConditionMet(team: PickTeamDTO | null): boolean {
    if (!team) {
      return false;
    }

    const gameweekCounts: { [key: number]: number } = {};

    const bonusGameweeks = [
      team.hatTrickHeroGameweek,
      team.teamBoostGameweek,
      team.captainFantasticGameweek,
      team.braceBonusGameweek,
      team.passMasterGameweek,
      team.goalGetterGameweek,
      team.noEntryGameweek,
      team.safeHandsGameweek,
      team.countrymenGameweek,
      team.prospectsGameweek,
    ];

    for (const gw of bonusGameweeks) {
      if (gw !== 0) {
        gameweekCounts[gw] = (gameweekCounts[gw] || 0) + 1;
        if (gameweekCounts[gw] > 1) {
          return false;
        }
      }
    }

    return true;
  }

  function isValidFormation(
    team: PickTeamDTO,
    selectedFormation: string
  ): boolean {
    const positionCounts: Record<number, number> = { 0: 0, 1: 0, 2: 0, 3: 0 };
    team.playerIds.forEach((id) => {
      const teamPlayer = $playerStore.find((p) => p.id === id);
      if (teamPlayer) {
        positionCounts[convertPlayerPosition(teamPlayer.position)]++;
      }
    });

    const [def, mid, fwd] = selectedFormation.split("-").map(Number);
    const minDef = Math.max(0, def - (positionCounts[1] || 0));
    const minMid = Math.max(0, mid - (positionCounts[2] || 0));
    const minFwd = Math.max(0, fwd - (positionCounts[3] || 0));
    const minGK = Math.max(0, 1 - (positionCounts[0] || 0));

    const additionalPlayersNeeded = minDef + minMid + minFwd + minGK;
    const totalPlayers = Object.values(positionCounts).reduce(
      (a, b) => a + b,
      0
    );

    return totalPlayers + additionalPlayersNeeded <= 11;
  }

  function autofillTeam() {
    if (!$fantasyTeam || !$playerStore) return;

    let updatedFantasyTeam = {
      ...$fantasyTeam,
      playerIds: Uint16Array.from($fantasyTeam.playerIds),
    };
    let remainingBudget = $bankBalance;

    const teamCounts = new Map<number, number>();
    updatedFantasyTeam.playerIds.forEach((playerId) => {
      if (playerId > 0) {
        const player = $playerStore.find((p) => p.id === playerId);
        if (player) {
          teamCounts.set(
            player.clubId,
            (teamCounts.get(player.clubId) || 0) + 1
          );
        }
      }
    });

    const formationPositions = allFormations[$selectedFormation].positions;

    formationPositions.forEach((position, index) => {
      if (remainingBudget <= 0) return;
      if (updatedFantasyTeam.playerIds[index] > 0) return;


      const availablePlayers = $playerStore
        .filter(
          (player) =>
            convertPlayerPosition(player.position) === position &&
            !updatedFantasyTeam.playerIds.includes(player.id) &&
            (teamCounts.get(player.clubId) || 0) < 2
        )
        .sort((a, b) => a.valueQuarterMillions - b.valueQuarterMillions);

      const topN = 3;
      const candidates = availablePlayers.slice(0, topN);
      const randomPlayer =
        candidates[Math.floor(Math.random() * candidates.length)];

      if (randomPlayer) {
        const potentialNewBudget =
          remainingBudget - randomPlayer.valueQuarterMillions;
        if (potentialNewBudget >= 0) {
          updatedFantasyTeam.playerIds[index] = randomPlayer.id;
          remainingBudget = potentialNewBudget;
          teamCounts.set(
            randomPlayer.clubId,
            (teamCounts.get(randomPlayer.clubId) || 0) + 1
          );
        }
      }
    });

    if (remainingBudget >= 0) {
      updatedFantasyTeam.captainId = getHighestValuedPlayerId(updatedFantasyTeam, $playerStore);
      fantasyTeam.set(updatedFantasyTeam);
      bankBalance.set(remainingBudget);
    }
  }

  function playTransferWindow() {
    transferWindowPlayedInSession = true;
    transferWindowPlayed = true;
    transfersAvailable.set(Infinity);
  }

  async function updateUsername() {
    if ($newUsername == "") {
      return;
    }
    let updatedFantasyTeam: PickTeamDTO = {
      ...$fantasyTeam,
      username: $newUsername,
    };
    
    fantasyTeam.set(updatedFantasyTeam);
    showUsernameModal = false;
    saveFantasyTeam();
  }

  async function saveFantasyTeam() {
    console.log("save")
    if (!$fantasyTeam) {
      return;
    }

    if ($fantasyTeam.username == "") {
      showUsernameModal = true;
      return;
    }

    busyStore.startBusy({
      initiator: "save-team",
      text: "Saving fantasy team...",
    });

    let team = $fantasyTeam;
    if (team?.captainId === 0 || !team?.playerIds.includes(team?.captainId)) {
      team!.captainId = getHighestValuedPlayerId(team!, $playerStore);
    }

    if (
      team?.safeHandsGameweek === activeGameweek &&
      team?.safeHandsPlayerId !== team?.playerIds[0]
    ) {
      team.safeHandsPlayerId = team?.playerIds[0];
    }

    if (
      team?.captainFantasticGameweek === activeGameweek &&
      team?.captainFantasticPlayerId !== team?.captainId
    ) {
      team.captainFantasticPlayerId = team?.captainId;
    }

    try {
      console.log(team)
      await managerStore.saveFantasyTeam(
        team!,
        activeGameweek,
        bonusUsedInSession,
        transferWindowPlayedInSession
      );
      busyStore.stopBusy("save-team");
      toastsShow({
        text: "Team saved successully!",
        level: "success",
        position: "bottom",
        duration: 2000,
      });
    } catch (error) {
      toastsError({
        msg: { text: "Error saving team." },
        err: error,
      });
      console.error("Error saving team:", error);
    } finally {
      busyStore.stopBusy("save-team");
    }
  }

  function closeUsernameModal() {
    showUsernameModal = false;
  }
</script>

{#if isLoading}
  <LocalSpinner />
{:else}
  <SetTeamName
    visible={showUsernameModal}
    setUsername={updateUsername}
    cancelModal={closeUsernameModal}
    {newUsername}
  />

  <div class="hidden xl:flex flex-col md:flex-row">
    <div
      class="flex flex-row justify-between items-center text-white bg-panel p-2 rounded-md w-full mb-4"
    >
      <div class="flex flex-row justify-between md:justify-start flex-grow ml-4">
        <button
          class={`btn ${
            pitchView ? `fpl-button` : `inactive-btn`
          } tab-switcher-label rounded-l-md`}
          on:click={showPitchView}
        >
          Pitch View
        </button>
        <button
          class={`btn ${
            !pitchView ? `fpl-button` : `inactive-btn`
          } tab-switcher-label rounded-r-md`}
          on:click={showListView}
        >
          List View
        </button>
      </div>

      <div
        class="text-center md:text-left w-full mt-0 md:ml-8 order-2 mt-4 md:mt-0"
      >
        <span class="text-lg">
          Formation:
          <select
            class="px-4 py-2 border-sm fpl-dropdown text-center"
            bind:value={$selectedFormation}
          >
            {#each $availableFormations as formation}
              <option value={formation}>{formation}</option>
            {/each}
          </select>
        </span>
      </div>

      <div
        class="flex flex-col md:flex-row w-full md:justify-end gap-4 mr-0 md:mr-4 order-1 md:order-3 mt-2 md:mt-0"
      >
        {#if $systemStore && $systemStore.transferWindowActive && $systemStore.seasonActive && $systemStore.calculationMonth == 1}
          <button
            disabled={transferWindowPlayed}
            on:click={playTransferWindow}
            class={`btn w-full md:w-auto px-4 py-2 rounded  
              ${
                !transferWindowPlayed ? "fpl-purple-btn" : "bg-gray-500"
              } text-white min-w-[125px]`}
          >
            Use Transfer Window Bonus
          </button>
        {/if}
        <button
          disabled={$fantasyTeam?.playerIds
            ? $fantasyTeam?.playerIds.filter((x) => x === 0).length === 0
            : true}
          on:click={autofillTeam}
          class={`btn w-full md:w-auto px-4 py-2 rounded  
            ${
              $fantasyTeam?.playerIds &&
              $fantasyTeam?.playerIds.filter((x) => x === 0).length > 0
                ? "fpl-purple-btn"
                : "bg-gray-500"
            } text-white min-w-[125px]`}
        >
          Auto Fill
        </button>
        <button
          disabled={!isSaveButtonActive}
          on:click={saveFantasyTeam}
          class={`btn w-full md:w-auto px-4 py-2 rounded ${
            isSaveButtonActive ? "fpl-purple-btn" : "bg-gray-500"
          } text-white min-w-[125px]`}
        >
          Save Team
        </button>
      </div>
    </div>
  </div>

  <div class="flex xl:hidden flex-col">
    <div class="bg-panel rounded-md xs:flex flex-row">
      <div class="w-full xs:w-1/2">
        <div class="flex">
          <p class="mx-4 mt-4">Gameweek {activeGameweek} {activeSeason}</p>
        </div>
        <div class="flex flex-row ml-4" style="margin-top: 2px;">
          <button
            class={`btn ${
              pitchView ? `fpl-button` : `inactive-btn`
            } rounded-l-md tab-switcher-label`}
            on:click={showPitchView}
          >
            Pitch View
          </button>
          <button
            class={`btn ${
              !pitchView ? `fpl-button` : `inactive-btn`
            } rounded-r-md tab-switcher-label`}
            on:click={showListView}
          >
            List View
          </button>
        </div>
      </div>
      <div class="w-full xs:w-1/2">
        <div class="flex flex-row items-center mx-4 mt-3">
          <p class="mr-2">Formation:</p>
          <select
            class="px-4 xs:mb-1 border-sm fpl-dropdown text-center text-center w-full"
            bind:value={selectedFormation}
          >
            {#each $availableFormations as formation}
              <option value={formation}>{formation}</option>
            {/each}
          </select>
        </div>
        <div class="flex flex-row mx-4 space-x-1">
          <button
            disabled={$fantasyTeam?.playerIds
              ? $fantasyTeam?.playerIds.filter((x) => x === 0).length === 0
              : true}
            on:click={autofillTeam}
            class={`side-button-base  
              ${
                $fantasyTeam?.playerIds &&
                $fantasyTeam?.playerIds.filter((x) => x === 0).length > 0
                  ? "fpl-purple-btn"
                  : "bg-gray-500"
              } text-white`}
          >
            Auto Fill
          </button>
          <button
            disabled={!isSaveButtonActive}
            on:click={saveFantasyTeam}
            class={`side-button-base ${
              isSaveButtonActive ? "fpl-purple-btn" : "bg-gray-500"
            } text-white`}
          >
            Save
          </button>
        </div>
        {#if $systemStore && $systemStore.transferWindowActive && $systemStore.seasonActive && $systemStore.calculationMonth == 1}
          <div class="flex flex-row mx-4 space-x-1 mb-4">
            <button
              disabled={transferWindowPlayed}
              on:click={playTransferWindow}
              class={`btn w-full px-4 py-2 rounded  
                ${
                  !transferWindowPlayed ? "fpl-purple-btn" : "bg-gray-500"
                } text-white min-w-[125px]`}
            >
              Use Transfer Window Bonus
            </button>
          </div>
        {/if}
      </div>
    </div>
  </div>

{/if}
