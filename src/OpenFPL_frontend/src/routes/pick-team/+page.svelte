<script lang="ts">
  import { onMount } from "svelte";
  import Layout from "../Layout.svelte";
  import { writable } from "svelte/store";
  import { toastsError } from "$lib/stores/toasts-store";
  import { systemStore } from "$lib/stores/system-store";
  import { fixtureStore } from "$lib/stores/fixture-store";
  import { teamStore } from "$lib/stores/team-store";
  import { playerStore } from "$lib/stores/player-store";
  import { managerStore } from "$lib/stores/manager-store";
  import PickTeamHeader from "$lib/components/pick-team/pick-team-header.svelte";
  import PickTeamButtons from "$lib/components/pick-team/pick-team-buttons.svelte";
  import PickTeamPlayers from "$lib/components/pick-team/pick-team-players.svelte";
  import BonusPanel from "$lib/components/pick-team/bonus-panel.svelte";
  import SimpleFixtures from "$lib/components/simple-fixtures.svelte";
  import { Spinner } from "@dfinity/gix-components";
  import {
    getAvailableFormations,
    convertPlayerPosition,
    allFormations,
  } from "../../lib/utils/Helpers";
  import type { PickTeamDTO } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import { goto } from "$app/navigation";

  let activeSeason: string;
  let activeGameweek: number;
  let selectedFormation: string = "4-4-2";
  let selectedPosition = -1;
  let selectedColumn = -1;
  let showCaptainModal = false;
  let newTeam = true;
  let isSaveButtonActive = false;

  const fantasyTeam = writable<PickTeamDTO | null>(null);
  const transfersAvailable = writable(newTeam ? Infinity : 0);
  const bankBalance = writable(1200);
  const pitchView = writable(true);
  const availableFormations = writable<string[]>([
    "3-4-3",
    "3-5-2",
    "4-3-3",
    "4-4-2",
    "4-5-1",
    "5-4-1",
    "5-3-2",
  ]);
  const newCaptain = writable("");
  const newCaptainId = writable(0);
  let canSellPlayer = true;
  let transferWindowPlayed = false;

  let isLoading = true;

  $: if ($fantasyTeam && $playerStore.length > 0) {
    disableInvalidFormations();
    isSaveButtonActive = checkSaveButtonConditions();
  }

  $: {
    if ($fantasyTeam) {
      getGridSetup(selectedFormation);
      if ($fantasyTeam.playerIds.filter((x) => x > 0).length == 11) {
        const newFormation = getTeamFormation($fantasyTeam);
        selectedFormation = newFormation;
      }
    }
  }

  onMount(() => {
    try {
      goto("/"); //TODO: This is removed when the game begins so people can pick a team
      async function loadData() {
        await systemStore.sync();
        await fixtureStore.sync($systemStore?.calculationSeasonId ?? 1);
        await teamStore.sync();
        await playerStore.sync();

        if ($playerStore.length == 0) {
          return;
        }

        activeSeason = $systemStore?.pickTeamSeasonName ?? "-";
        activeGameweek = $systemStore?.pickTeamGameweek ?? 1;

        const storedViewMode = localStorage.getItem("viewMode");
        if (storedViewMode) {
          pitchView.set(storedViewMode === "pitch");
        }

        let userFantasyTeam = await managerStore.getCurrentTeam();
        fantasyTeam.set(userFantasyTeam);

        let principalId = $fantasyTeam?.principalId ?? "";
        let transferWindowGameweek = $fantasyTeam?.transferWindowGameweek ?? 0;
        transferWindowPlayed = transferWindowGameweek > 0;

        if (principalId.length > 0) {
          newTeam = false;
          bankBalance.set(Number(userFantasyTeam.bankQuarterMillions));
        }

        if (!newTeam && activeGameweek > 1) {
          if (userFantasyTeam.transferWindowGameweek == activeGameweek) {
            transfersAvailable.set(Infinity);
          } else {
            transfersAvailable.set(userFantasyTeam.transfersAvailable);
            if ($transfersAvailable <= 0) {
              canSellPlayer = false;
            }
          }
        }

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
        isLoading = false;
      }

      loadData();
    } catch (error) {
      toastsError({
        msg: { text: "Error fetching team details." },
        err: error,
      });
      console.error("Error fetching team details:", error);
      isLoading = false;
    }
  });

  function getGridSetup(formation: string): number[][] {
    const formationSplits = formation.split("-").map(Number);
    const setups = [
      [1],
      ...formationSplits.map((s) =>
        Array(s)
          .fill(0)
          .map((_, i) => i + 1)
      ),
    ];
    return setups;
  }

  function getTeamFormation(team: PickTeamDTO): string {
    const positionCounts: Record<number, number> = { 0: 0, 1: 0, 2: 0, 3: 0 };

    team.playerIds.forEach((id) => {
      const teamPlayer = $playerStore.find((p) => p.id === id);

      if (teamPlayer) {
        positionCounts[convertPlayerPosition(teamPlayer.position)]++;
      }
    });

    for (const formation of Object.keys(allFormations)) {
      const formationPositions = allFormations[formation].positions;
      let isMatch = true;

      const formationCount = formationPositions.reduce((acc, pos) => {
        acc[pos] = (acc[pos] || 0) + 1;
        return acc;
      }, {} as Record<number, number>);

      for (const pos in formationCount) {
        if (formationCount[pos] !== positionCounts[pos]) {
          isMatch = false;
          break;
        }
      }

      if (isMatch) {
        return formation;
      }
    }

    console.error("No valid formation found for the team");
    return selectedFormation;
  }

  function setCaptain(playerId: number) {
    if ($newCaptainId == 0) {
      newCaptainId.set(playerId);
      changeCaptain();
      return;
    }

    newCaptainId.set(playerId);
    let player = $playerStore.find((x) => x.id === playerId);
    newCaptain.update((x) => `${player?.firstName} ${player?.lastName}`);
    showCaptainModal = true;
  }

  function disableInvalidFormations() {
    if (!$fantasyTeam || !$fantasyTeam.playerIds) {
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

    if (!isValidFormation($fantasyTeam, selectedFormation)) {
      return false;
    }

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

  function changeCaptain() {
    selectedPosition = -1;
    selectedColumn = -1;
    fantasyTeam.update((currentTeam) => {
      if (!currentTeam) return null;
      return { ...currentTeam, captainId: $newCaptainId };
    });
    showCaptainModal = false;
  }
</script>

<Layout>
  {#if isLoading}
    <Spinner />
  {:else}
    <div>
      <div class="hidden md:flex">
        <PickTeamHeader {fantasyTeam} {transfersAvailable} {bankBalance} />
      </div>
      <PickTeamButtons
        {fantasyTeam}
        {transfersAvailable}
        {bankBalance}
        {changeCaptain}
        {setCaptain}
        {pitchView}
        {availableFormations}
        {newCaptain}
      />
      <div class="flex flex-col xl:flex-row mt-2 xl:mt-0">
        <PickTeamPlayers
          {fantasyTeam}
          {transfersAvailable}
          {bankBalance}
          {changeCaptain}
          {newCaptainId}
          {setCaptain}
          {pitchView}
        />
        <div class="hidden xl:flex w-full xl:w-1/2 ml-2">
          <SimpleFixtures />
        </div>
        <div class="flex md:hidden w-full mt-4">
          <PickTeamHeader {fantasyTeam} {transfersAvailable} {bankBalance} />
        </div>
      </div>
      <BonusPanel {fantasyTeam} {activeGameweek} />
    </div>
  {/if}
</Layout>
