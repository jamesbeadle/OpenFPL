<script lang="ts">
  import { onMount } from "svelte";
  import { writable } from "svelte/store";
  import type { Writable } from "svelte/store";
  import { toastsError } from "$lib/stores/toasts-store";
  import { systemStore } from "$lib/stores/system-store";
  import { teamStore } from "$lib/stores/team-store";
  import { playerStore } from "$lib/stores/player-store";

  import AddPlayerModal from "$lib/components/pick-team/add-player-modal.svelte";
  import OpenChatIcon from "$lib/icons/OpenChatIcon.svelte";
  import AddPlayerIcon from "$lib/icons/AddPlayerIcon.svelte";
  import ShirtIcon from "$lib/icons/ShirtIcon.svelte";
  import AddIcon from "$lib/icons/AddIcon.svelte";
  import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
  import RemovePlayerIcon from "$lib/icons/RemovePlayerIcon.svelte";
  import PlayerCaptainIcon from "$lib/icons/PlayerCaptainIcon.svelte";
  import ActiveCaptainIcon from "$lib/icons/ActiveCaptainIcon.svelte";
  import {
    getPositionAbbreviation,
    convertPlayerPosition,
    isJanuary,
    getFlagComponent
  } from "../../../lib/utils/Helpers";
  import type {
    PlayerDTO,
    ProfileDTO,
  } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

  interface FormationDetails {
    positions: number[];
  }

  const formations: Record<string, FormationDetails> = {
    "3-4-3": { positions: [0, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3] },
    "3-5-2": { positions: [0, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3] },
    "4-3-3": { positions: [0, 1, 1, 1, 1, 2, 2, 2, 3, 3, 3] },
    "4-4-2": { positions: [0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3] },
    "4-5-1": { positions: [0, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3] },
    "5-4-1": { positions: [0, 1, 1, 1, 1, 1, 2, 2, 2, 2, 3] },
    "5-3-2": { positions: [0, 1, 1, 1, 1, 1, 2, 2, 2, 3, 3] },
  };

  let activeSeason: string;
  let activeGameweek: number;
  let selectedFormation: string = "4-4-2";
  let selectedPosition = -1;
  let selectedColumn = -1;
  let pitchView = true;
  let showAddPlayer = false;
  let teamValue = 0;
  let newTeam = true;
  let isSaveButtonActive = false;

  let sessionAddedPlayers: number[] = [];
    
  export let fantasyTeam: Writable<ProfileDTO | null>;
  export let transfersAvailable: Writable<number>;
  export let bankBalance: Writable<number>;
  export let newCaptainId: Writable<number>;
  export let setCaptain: (captainId: number) => void;
  export let changeCaptain: () => void;

  let pitchHeight = 0;
  let pitchElement: HTMLElement;

  let canSellPlayer = true;
  let transferWindowPlayed = false;
  let transferWindowActive = false;

  let isLoading = true;

  $: gridSetup = getGridSetup(selectedFormation);

  $: if ($fantasyTeam && $playerStore.length > 0) {
    updateTeamValue();
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

  $: rowHeight = (pitchHeight * 0.9) / 4;
  $: gridSetupComplete = rowHeight > 0;

  onMount(() => {
    try {
      if (typeof window !== "undefined") {
        window.addEventListener("resize", updatePitchHeight);
        updatePitchHeight();
      }

      if(isJanuary()){
        transferWindowActive = true;
      }

      async function loadData() {

        activeSeason = $systemStore?.pickTeamSeasonName ?? "-";
        activeGameweek = $systemStore?.pickTeamGameweek ?? 1;

        const storedViewMode = localStorage.getItem("viewMode");
        if (storedViewMode) {
          pitchView = storedViewMode === "pitch";
        }

        
        let transferWindowGameweek = $fantasyTeam?.transferWindowGameweek ?? 0;
        transferWindowPlayed = (transferWindowGameweek > 0);

        if(!$fantasyTeam){
          return;
        }

        if (!newTeam && activeGameweek > 1) {
          if($fantasyTeam.tranferWindowGameweek == activeGameweek){
            transfersAvailable.set(Infinity);
          }
          else{
            transfersAvailable.set($fantasyTeam.transfersAvailable);
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

  function updatePitchHeight() {
    if (!pitchElement) {
      return;
    }
    pitchHeight = pitchElement.clientHeight;
  }
  
  function updateTeamValue() {
    const team = $fantasyTeam;
    if (team) {
      let totalValue = 0;
      team.playerIds.forEach((id) => {
        const player = $playerStore.find((p) => p.id === id);
        if (player) {
          totalValue += player.valueQuarterMillions;
        }
      });
      teamValue = totalValue / 4;
    }
  }

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

  function getTeamFormation(team: ProfileDTO): string {
    const positionCounts: Record<number, number> = { 0: 0, 1: 0, 2: 0, 3: 0 };

    team.playerIds.forEach((id) => {
      const teamPlayer = $playerStore.find((p) => p.id === id);

      if (teamPlayer) {
        positionCounts[convertPlayerPosition(teamPlayer.position)]++;
      }
    });

    for (const formation of Object.keys(formations)) {
      const formationPositions = formations[formation].positions;
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

  function loadAddPlayer(row: number, col: number) {
    selectedPosition = row;
    selectedColumn = col;
    showAddPlayer = true;
  }

  function closeAddPlayerModal() {
    showAddPlayer = false;
  }

  function handlePlayerSelection(player: PlayerDTO) {
    if ($fantasyTeam) {
      if (
        canAddPlayerToCurrentFormation(player, $fantasyTeam, selectedFormation)
      ) {
        addPlayerToTeam(player, $fantasyTeam, selectedFormation);
      } else {
        const newFormation = findValidFormationWithPlayer($fantasyTeam, player);
        repositionPlayersForNewFormation($fantasyTeam, newFormation);
        selectedFormation = newFormation;
        addPlayerToTeam(player, $fantasyTeam, newFormation);
      }
      if (!newTeam && activeGameweek > 1) {
        transfersAvailable.update((n) => (n > 0 ? n - 1 : 0));
        if ($transfersAvailable <= 0) {
          canSellPlayer = false;
        }
        //TODO: Allow sell of insesson players
      }
      bankBalance.update((n) =>
        n - player.valueQuarterMillions > 0
          ? n - player.valueQuarterMillions
          : n
      );

      if (!sessionAddedPlayers.includes(player.id)) {
        sessionAddedPlayers.push(player.id);
      }
    }
  }

  function canAddPlayerToCurrentFormation(
    player: PlayerDTO,
    team: ProfileDTO,
    formation: string
  ): boolean {
    const positionCounts: { [key: number]: number } = {
      0: 0,
      1: 0,
      2: 0,
      3: 0,
    };
    team.playerIds.forEach((id) => {
      const teamPlayer = $playerStore.find((p) => p.id === id);
      if (teamPlayer) {
        positionCounts[convertPlayerPosition(teamPlayer.position)]++;
      }
    });

    positionCounts[convertPlayerPosition(player.position)]++;

    const [def, mid, fwd] = formation.split("-").map(Number);
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

  function addPlayerToTeam(
    player: PlayerDTO,
    team: ProfileDTO,
    formation: string
  ) {
    const indexToAdd = getAvailablePositionIndex(
      convertPlayerPosition(player.position),
      team,
      formation
    );
    if (indexToAdd === -1) {
      console.error("No available position to add the player.");
      return;
    }

    fantasyTeam.update((currentTeam) => {
      if (!currentTeam) return null;
      const newPlayerIds = Uint16Array.from(currentTeam.playerIds);
      if (indexToAdd < newPlayerIds.length) {
        newPlayerIds[indexToAdd] = player.id;
        return { ...currentTeam, playerIds: newPlayerIds };
      } else {
        console.error(
          "Index out of bounds when attempting to add player to team."
        );
        return currentTeam;
      }
    });

    if (!$fantasyTeam) {
      return;
    }

    let updatedTeam = $fantasyTeam;

    if (
      updatedTeam.captainId > 0 &&
      $fantasyTeam.playerIds.filter((x) => x == updatedTeam.captainId).length ==
        0
    ) {
      newCaptainId.set(getHighestValuedPlayerId($fantasyTeam));
      changeCaptain();
    }
  }

  function getAvailablePositionIndex(
    position: number,
    team: ProfileDTO,
    formation: string
  ): number {
    const formationArray = formations[formation].positions;
    for (let i = 0; i < formationArray.length; i++) {
      if (formationArray[i] === position && team.playerIds[i] === 0) {
        return i;
      }
    }
    return -1;
  }

  function findValidFormationWithPlayer(
    team: ProfileDTO,
    player: PlayerDTO
  ): string {
    const positionCounts: Record<number, number> = { 0: 0, 1: 0, 2: 0, 3: 0 };

    team.playerIds.forEach((id) => {
      const teamPlayer = $playerStore.find((p) => p.id === id);
      if (teamPlayer) {
        positionCounts[convertPlayerPosition(teamPlayer.position)]++;
      }
    });

    positionCounts[convertPlayerPosition(player.position)]++;

    let bestFitFormation: string | null = null;
    let minimumAdditionalPlayersNeeded = Number.MAX_SAFE_INTEGER;

    for (const formation of Object.keys(formations) as string[]) {
      if (formation === selectedFormation) {
        continue;
      }

      const formationPositions = formations[formation].positions;
      let formationDetails: Record<number, number> = { 0: 0, 1: 0, 2: 0, 3: 0 };

      formationPositions.forEach((pos) => {
        formationDetails[pos]++;
      });

      const additionalPlayersNeeded = Object.keys(formationDetails).reduce(
        (total, key) => {
          const position = parseInt(key);
          return (
            total +
            Math.max(0, formationDetails[position] - positionCounts[position])
          );
        },
        0
      );

      if (
        additionalPlayersNeeded < minimumAdditionalPlayersNeeded &&
        formationDetails[convertPlayerPosition(player.position)] >
          positionCounts[convertPlayerPosition(player.position)] - 1
      ) {
        bestFitFormation = formation;
        minimumAdditionalPlayersNeeded = additionalPlayersNeeded;
      }
    }

    if (bestFitFormation) {
      return bestFitFormation;
    }

    console.error("No valid formation found for the player");
    return selectedFormation;
  }

  function repositionPlayersForNewFormation(
    team: ProfileDTO,
    newFormation: string
  ) {
    const newFormationArray = formations[newFormation].positions;
    let newPlayerIds: number[] = new Array(11).fill(0);

    team.playerIds.forEach((playerId) => {
      const player = $playerStore.find((p) => p.id === playerId);
      if (player) {
        for (let i = 0; i < newFormationArray.length; i++) {
          if (
            newFormationArray[i] === convertPlayerPosition(player.position) &&
            newPlayerIds[i] === 0
          ) {
            newPlayerIds[i] = playerId;
            break;
          }
        }
      }
    });

    team.playerIds = newPlayerIds;
  }

  function getActualIndex(rowIndex: number, colIndex: number): number {
    let startIndex = gridSetup
      .slice(0, rowIndex)
      .reduce((sum, currentRow) => sum + currentRow.length, 0);
    return startIndex + colIndex;
  }

  function removePlayer(playerId: number) {
    selectedPosition = -1;
    selectedColumn = -1;
    fantasyTeam.update((currentTeam) => {
      if (!currentTeam) return null;

      const playerIndex = currentTeam.playerIds.indexOf(playerId);
      if (playerIndex === -1) {
        console.error("Player not found in the team.");
        return currentTeam;
      }

      const newPlayerIds = Uint16Array.from(currentTeam.playerIds);
      newPlayerIds[playerIndex] = 0;

      if (sessionAddedPlayers.includes(playerId)) {
        if (!newTeam && activeGameweek > 1) {
          transfersAvailable.update((n) => n + 1);
        }
        sessionAddedPlayers = sessionAddedPlayers.filter(
          (id) => id !== playerId
        );
      }
      bankBalance.update(
        (n) =>
          n +
            $playerStore.find((x) => x.id === playerId)!.valueQuarterMillions ??
          0
      );

      return { ...currentTeam, playerIds: newPlayerIds };
    });
  }

  function getHighestValuedPlayerId(team: ProfileDTO): number {
    let highestValue = 0;
    let highestValuedPlayerId = 0;

    team.playerIds.forEach((playerId) => {
      const player = $playerStore.find((p) => p.id === playerId);
      if (player && player.valueQuarterMillions > highestValue) {
        highestValue = player.valueQuarterMillions;
        highestValuedPlayerId = playerId;
      }
    });

    return highestValuedPlayerId;
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

  function isBonusConditionMet(team: ProfileDTO | null): boolean {
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
    team: ProfileDTO,
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
</script>

<AddPlayerModal
  {handlePlayerSelection}
  filterPosition={selectedPosition}
  filterColumn={selectedColumn}
  visible={showAddPlayer}
  {closeAddPlayerModal}
  {fantasyTeam}
  {bankBalance}
/>

{#if pitchView}
  <div class="relative w-full xl:w-1/2 mt-2">
    <img
      src="/pitch.png"
      alt="pitch"
      class="w-full h-auto"
      on:load={updatePitchHeight}
      bind:this={pitchElement}
    />
    {#if gridSetupComplete}
      <div class="absolute top-0 left-0 right-0 bottom-0">
        <div class={`flex justify-around w-full h-auto`}>
          <div class="relative inline-block">
            <img
              class="h-6 sm:h-8 md:h-12 m-0 md:m-1"
              src="/board.png"
              alt="OpenChat"
            />
            <div class="absolute top-0 left-0 w-full h-full">
              <a
                class="flex items-center justify-center w-full h-full px-2 md:px-4 ml-1 md:ml-0"
                target="_blank"
                href="https://oc.app/community/uf3iv-naaaa-aaaar-ar3ta-cai/channel/231651284198326210763327878874377361028/?ref=zv6hh-xaaaa-aaaar-ac35q-cai"
              >
                <OpenChatIcon className="h-4 md:h-6 mr-1 md:mr-2" />
                <span class="text-white text-xs md:text-xl mr-4 oc-logo"
                  >OpenChat</span
                >
              </a>
            </div>
          </div>
          <div class="relative inline-block">
            <img
              class="h-6 sm:h-8 md:h-12 m-0 md:m-1"
              src="/board.png"
              alt="OpenChat"
            />
            <div class="absolute top-0 left-0 w-full h-full">
              <a
                class="flex items-center justify-center w-full h-full px-2 md:px-4 ml-1 md:ml-0"
                target="_blank"
                href="https://oc.app/community/uf3iv-naaaa-aaaar-ar3ta-cai/channel/231651284198326210763327878874377361028/?ref=zv6hh-xaaaa-aaaar-ac35q-cai"
              >
                <OpenChatIcon className="h-4 md:h-6 mr-1 md:mr-2" />
                <span class="text-white text-xs md:text-xl mr-4 oc-logo"
                  >OpenChat</span
                >
              </a>
            </div>
          </div>
        </div>
        {#each gridSetup as row, rowIndex}
          <div
            class="flex justify-around items-center w-full"
            style="height: {rowHeight}px;"
          >
            {#each row as _, colIndex (colIndex)}
              {@const actualIndex = getActualIndex(rowIndex, colIndex)}
              {@const playerIds = $fantasyTeam?.playerIds ?? []}
              {@const playerId = playerIds[actualIndex]}
              {@const player = $playerStore.find(
                (p) => p.id === playerId
              )}
              <div
                class="flex flex-col justify-center items-center flex-1 player-card"
              >
                {#if playerId > 0 && player}
                  {@const team = $teamStore.find(
                    (x) => x.id === player.clubId
                  )}
                  <div class="flex flex-col items-center text-center">
                    <div class="flex justify-center items-center">
                      <div
                        class="flex justify-between items-end w-full"
                      >
                        {#if canSellPlayer && !sessionAddedPlayers.includes(player.id)}
                          <button
                            on:click={() => removePlayer(player.id)}
                            class="bg-red-600 mb-1 rounded-sm"
                          >
                            <RemovePlayerIcon
                              className="w-4 h-4 sm:w-6 sm:h-6 p-1"
                            />
                          </button>
                        {:else}
                          <div class="w-4 h-4 sm:w-6 sm:h-6 p-1">
                            &nbsp;
                          </div>
                        {/if}
                        <div
                          class="flex justify-center items-center flex-grow"
                        >
                          <ShirtIcon
                            className="h-6 xs:h-12 sm:h-12 md:h-16 lg:h-20 xl:h-12 2xl:h-16"
                            primaryColour={team?.primaryColourHex}
                            secondaryColour={team?.secondaryColourHex}
                            thirdColour={team?.thirdColourHex}
                          />
                        </div>
                        {#if $fantasyTeam?.captainId === playerId}
                          <span class="mb-1">
                            <ActiveCaptainIcon
                              className="w-4 h-4 sm:w-7 sm:h-7 md:w-6 md:h-6"
                            />
                          </span>
                        {:else}
                          <button
                            on:click={() => setCaptain(player.id)}
                            class="mb-1"
                          >
                            <PlayerCaptainIcon
                              className="w-4 h-4 sm:w-7 sm:h-7 md:w-6 md:h-6"
                            />
                          </button>
                        {/if}
                      </div>
                    </div>
                    <div
                      class="flex flex-col justify-center items-center text-xs sm:text-xs"
                    >
                      <div
                        class="flex justify-center items-center bg-gray-700 rounded-t-md md:px-2 sm:py-1
                        min-w-[60px] xs:min-w-[90px] sm:min-w-[120px]
                        max-w-[60px] xs:max-w-[90px] sm:max-w-[120px]"
                      >
                        <p class="hidden sm:flex sm:min-w-[15px]">
                          {getPositionAbbreviation(
                            convertPlayerPosition(player.position)
                          )}
                        </p>
                        <svelte:component
                          this={getFlagComponent(player.nationality)}
                          class="hidden xs:flex h-2 w-2 mr-1 sm:h-4 sm:w-4 sm:mx-2 min-w-[15px]"
                        />
                        <p
                          class="hidden xs:block truncate min-w-[50px] max-w-[50px] xs:min-w-[60px] xs:max-w-[60px]"
                        >
                          {player.firstName.length > 0
                            ? player.firstName.substring(0, 1) + "."
                            : ""}
                          {player.lastName}
                        </p>
                        <p
                          class="xs:hidden truncate min-w-[50px] max-w-[50px]"
                        >
                          {player.lastName}
                        </p>
                      </div>
                      <div
                        class="flex justify-center items-center bg-white text-black md:px-2 sm:py-1 rounded-b-md
                        min-w-[60px] xs:min-w-[90px] sm:min-w-[120px]
                        max-w-[60px] xs:max-w-[90px] sm:max-w-[120px]"
                      >
                        <p class="collapse sm:visible sm:min-w-[20px]">
                          {team?.abbreviatedName}
                        </p>
                        <BadgeIcon
                          className="hidden xs:flex h-4 w-4 sm:mx-1 min-w-[15px]"
                          primaryColour={team?.primaryColourHex}
                          secondaryColour={team?.secondaryColourHex}
                          thirdColour={team?.thirdColourHex}
                        />
                        <p class="truncate min-w-[50px] max-w-[50px]">
                          £{(player.valueQuarterMillions / 4).toFixed(
                            2
                          )}m
                        </p>
                      </div>
                    </div>
                  </div>
                {:else}
                  <button
                    on:click={() => loadAddPlayer(rowIndex, colIndex)}
                    class="flex items-center"
                  >
                    <AddPlayerIcon
                      className="h-12 sm:h-16 md:h-20 lg:h-24 xl:h-16 2xl:h-20"
                    />
                  </button>
                {/if}
              </div>
            {/each}
          </div>
        {/each}
      </div>
    {/if}
  </div>
{:else}
  <div class="bg-panel rounded-md">
    {#each gridSetup as row, rowIndex}
      {#if rowIndex === 0}
        <div
          class="flex items-center justify-between py-2 bg-light-gray border-b border-gray-700 px-4"
        >
          <div class="w-1/3">Goalkeeper</div>
          <div class="w-1/6">(c)</div>
          <div class="w-1/3">Team</div>
          <div class="w-1/6">Value</div>
          <div class="w-1/6">&nbsp;</div>
        </div>
      {/if}
      {#if rowIndex === 1}
        <div
          class="flex items-center justify-between py-2 bg-light-gray border-b border-gray-700 px-4"
        >
          <div class="w-1/3">Defenders</div>
          <div class="w-1/6">(c)</div>
          <div class="w-1/3">Team</div>
          <div class="w-1/6">Value</div>
          <div class="w-1/6">&nbsp;</div>
        </div>
      {/if}
      {#if rowIndex === 2}
        <div
          class="flex items-center justify-between py-2 bg-light-gray border-b border-gray-700 px-4"
        >
          <div class="w-1/3">Midfielders</div>
          <div class="w-1/6">(c)</div>
          <div class="w-1/3">Team</div>
          <div class="w-1/6">Value</div>
          <div class="w-1/6">&nbsp;</div>
        </div>
      {/if}
      {#if rowIndex === 3}
        <div
          class="flex items-center justify-between py-2 bg-light-gray border-b border-gray-700 px-4"
        >
          <div class="w-1/3">Forwards</div>
          <div class="w-1/6">(c)</div>
          <div class="w-1/3">Team</div>
          <div class="w-1/6">Value</div>
          <div class="w-1/6">&nbsp;</div>
        </div>
      {/if}
      {#each row as _, colIndex (colIndex)}
        {@const actualIndex = getActualIndex(rowIndex, colIndex)}
        {@const playerIds = $fantasyTeam?.playerIds ?? []}
        {@const playerId = playerIds[actualIndex]}
        {@const player = $playerStore.find((p) => p.id === playerId)}
        {@const team = $teamStore.find((x) => x.id === player?.clubId)}

        <div class="flex items-center justify-between py-2 px-4">
          {#if playerId > 0 && player}
            <div class="w-1/3">
              {player.firstName}
              {player.lastName}
            </div>
            <div class="w-1/6 flex items-center">
              {#if $fantasyTeam?.captainId === playerId}
                <span>
                  <ActiveCaptainIcon className="w-6 h-6" />
                </span>
              {:else}
                <button on:click={() => setCaptain(player.id)}>
                  <PlayerCaptainIcon className="w-6 h-6" />
                </button>
              {/if}
            </div>
            <div class="flex w-1/3 items-center">
              <BadgeIcon
                className="h-5 w-5 mr-2"
                primaryColour={team?.primaryColourHex}
                secondaryColour={team?.secondaryColourHex}
                thirdColour={team?.thirdColourHex}
              />
              <p>
                {team?.name}
              </p>
            </div>
            <div class="w-1/6">
              £{(player.valueQuarterMillions / 4).toFixed(2)}m
            </div>
            <div class="w-1/6 flex items-center">
              <button
                on:click={() => removePlayer(player.id)}
                class="bg-red-600 mb-1 rounded-sm"
              >
                <RemovePlayerIcon className="w-6 h-6 p-2" />
              </button>
            </div>
          {:else}
            <div class="w-1/3">-</div>
            <div class="w-1/6">-</div>
            <div class="w-1/3">-</div>
            <div class="w-1/6">-</div>
            <div class="w-1/6 flex items-center">
              <button
                on:click={() => loadAddPlayer(rowIndex, colIndex)}
                class="rounded fpl-button flex items-center"
              >
                <AddIcon className="w-6 h-6 p-2" />
              </button>
            </div>
          {/if}
        </div>
      {/each}
    {/each}
  </div>
{/if}