<script lang="ts">
  import { onMount } from "svelte";
  import { writable, type Writable } from "svelte/store";
  import { toastsError } from "$lib/stores/toasts-store";
  import { systemStore } from "$lib/stores/system-store";
  import { clubStore } from "$lib/stores/club-store";
  import { playerStore } from "$lib/stores/player-store";

  import { getPositionAbbreviation, getFlagComponent, convertPlayerPosition } from "../../utils/helpers";
  import type { PlayerDTO, PickTeamDTO } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

  import AddPlayerModal from "$lib/components/pick-team/add-player-modal.svelte";
  import ConfirmCaptainChange from "./confirm-captain-change.svelte";
  import AddPlayerIcon from "$lib/icons/AddPlayerIcon.svelte";
  import ShirtIcon from "$lib/icons/ShirtIcon.svelte";
  import ActiveCaptainIcon from "$lib/icons/ActiveCaptainIcon.svelte";
  import AddIcon from "$lib/icons/AddIcon.svelte";
  import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
  import RemovePlayerIcon from "$lib/icons/RemovePlayerIcon.svelte";
  import OpenChatIcon from "$lib/icons/OpenChatIcon.svelte";
  import PlayerCaptainIcon from "$lib/icons/PlayerCaptainIcon.svelte";
  import { allFormations, getTeamFormation } from "$lib/utils/pick-team.helpers";
  import LocalSpinner from "../local-spinner.svelte";

  export let loadingPlayers: Writable<Boolean | null>;
  export let fantasyTeam: Writable<PickTeamDTO | null>;
  export let pitchView: Writable<boolean>;

  export let selectedFormation: Writable<string>;
  export let transfersAvailable: Writable<number>;  
  export let bankBalance: Writable<number>;
  export let teamValue: Writable<number>;
  let pitchHeight = 0;
  let pitchElement: HTMLElement;
  let showAddPlayer = false;
  
  let newTeam = true;
  let selectedPosition = -1;
  let selectedColumn = -1;
  let canSellPlayer = true;
  let sessionAddedPlayers: number[] = [];
  let newCaptainId = writable<number>(0);
  let newCaptain = writable<string>("");

  $: rowHeight = (pitchHeight * 0.9) / 4;
  $: gridSetupComplete = rowHeight > 0;

  $: gridSetup = getGridSetup($selectedFormation);

  $: if ($fantasyTeam && $playerStore.length > 0) {
    updateTeamValue();
  }

  $: {
    if ($fantasyTeam) {
      getGridSetup($selectedFormation);
      if ($fantasyTeam.playerIds.filter((x) => x > 0).length == 11) {
        const newFormation = getTeamFormation($fantasyTeam, $playerStore);
        $selectedFormation = newFormation;
      }
    }
  }

  onMount(async () => {
    try {
      if (typeof window !== "undefined") {
        window.addEventListener("resize", updatePitchHeight);
        updatePitchHeight();
      }

      await loadData();
    } catch (error) {
      toastsError({
        msg: { text: "Error fetching team details." },
        err: error,
      });
      console.error("Error fetching team details:", error);
    } 
  });

  async function loadData() {

    const storedViewMode = localStorage.getItem("viewMode");
    if (storedViewMode) {
      pitchView.set(storedViewMode === "pitch");
    }

    if (!$fantasyTeam) {
      return;
    }

    let principalId = $fantasyTeam?.principalId ?? "";
    if (principalId.length > 0) {
        newTeam = false;
        bankBalance.set(Number($fantasyTeam.bankQuarterMillions));
    }

    let activeGameweek = $systemStore?.pickTeamGameweek ?? 1;

    if (!newTeam && activeGameweek > 1) {
      if ($fantasyTeam.transferWindowGameweek == activeGameweek) {
        transfersAvailable.set(Infinity);
      } else {
        transfersAvailable.set($fantasyTeam.transfersAvailable);
        if ($transfersAvailable <= 0) {
          canSellPlayer = false;
        }
      }
    }

    if($fantasyTeam.firstGameweek){
      transfersAvailable.set(Infinity);
      canSellPlayer = true;
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
  }

  function updatePitchHeight() {
    if (!pitchElement) {
      return;
    }
    pitchHeight = pitchElement.clientHeight;
  }

  function updateTeamValue() {
    if ($fantasyTeam) {
      let totalValue = 0;
      $fantasyTeam.playerIds.forEach((id) => {
        const player = $playerStore.find((p) => p.id === id);
        if (player) {
          totalValue += player.valueQuarterMillions;
        }
      });
      $teamValue = totalValue / 4;
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
        canAddPlayerToCurrentFormation(player, $fantasyTeam, $selectedFormation)
      ) {
        addPlayerToTeam(player, $fantasyTeam, $selectedFormation);
      } else {
        const newFormation = findValidFormationWithPlayer($fantasyTeam, player);
        repositionPlayersForNewFormation($fantasyTeam, newFormation);
        $selectedFormation = newFormation;
        addPlayerToTeam(player, $fantasyTeam, newFormation);
      }
      if (!newTeam && $systemStore?.pickTeamGameweek! > 1) {
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
    team: PickTeamDTO,
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
    team: PickTeamDTO,
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

  function changeCaptain() {
    selectedPosition = -1;
    selectedColumn = -1;
    fantasyTeam.update((currentTeam) => {
      if (!currentTeam) return null;
      return { ...currentTeam, captainId: $newCaptainId };
    });
    showCaptainModal = false;
  }

  function setCaptain(playerId: number) {

    if (playerId > 0) {
      newCaptainId.set(playerId);
      let player = $playerStore.find((x) => x.id === $newCaptainId);
      $newCaptain = `${player?.firstName} ${player?.lastName}`;
      showCaptainModal = true;
      return;
    }

    newCaptainId.set(getHighestValuedPlayerId($fantasyTeam!));
    let player = $playerStore.find((x) => x.id === $newCaptainId);    
    $newCaptain = `${player?.firstName} ${player?.lastName}`;
    showCaptainModal = true;
  }

  

  function getAvailablePositionIndex(
    position: number,
    team: PickTeamDTO,
    formation: string
  ): number {
    const formationArray = allFormations[formation].positions;
    for (let i = 0; i < formationArray.length; i++) {
      if (formationArray[i] === position && team.playerIds[i] === 0) {
        return i;
      }
    }
    return -1;
  }

  function findValidFormationWithPlayer(
    team: PickTeamDTO,
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

    for (const formation of Object.keys(allFormations) as string[]) {
      if (formation === $selectedFormation) {
        continue;
      }

      const formationPositions = allFormations[formation].positions;
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

    return $selectedFormation;
  }

  function repositionPlayersForNewFormation(
    team: PickTeamDTO,
    newFormation: string
  ) {
    const newFormationArray = allFormations[newFormation].positions;
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
        if (!newTeam && $systemStore?.pickTeamGameweek! > 1) {
          transfersAvailable.update((n) => n + 1);
        }
        sessionAddedPlayers = sessionAddedPlayers.filter(
          (id) => id !== playerId
        );
      }
      bankBalance.update(
        (n) =>
          n + $playerStore.find((x) => x.id === playerId)!.valueQuarterMillions 
      );

      return { ...currentTeam, playerIds: newPlayerIds };
    });
  }

  function getHighestValuedPlayerId(team: PickTeamDTO): number {
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

  let showCaptainModal = false;
  
  function closeCaptainModal() {
    showCaptainModal = false;
  }
  
</script>

<ConfirmCaptainChange
  newCaptain={$newCaptain}
  visible={showCaptainModal}
  onClose={closeCaptainModal}
  onConfirm={changeCaptain}
/>

<AddPlayerModal
  {handlePlayerSelection}
  filterPosition={selectedPosition}
  filterColumn={selectedColumn}
  visible={showAddPlayer}
  {closeAddPlayerModal}
  {fantasyTeam}
  {bankBalance}
/>

{#if $loadingPlayers}
  <LocalSpinner />
{:else}
  {#if $pitchView}
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
                {@const player = $playerStore.find((p) => p.id === playerId)}
                <div
                  class="flex flex-col justify-center items-center flex-1 player-card"
                >
                  {#if playerId > 0 && player}
                    {@const team = $clubStore.find((x) => x.id === player.clubId)}
                    <div class="flex flex-col items-center text-center">
                      <div class="flex justify-center items-center">
                        <div class="flex justify-between items-end w-full">
                          {#if canSellPlayer || sessionAddedPlayers.includes(player.id)}
                            <button
                              on:click={() => removePlayer(player.id)}
                              class="bg-red-600 mb-1 rounded-sm"
                            >
                              <RemovePlayerIcon
                                className="w-3 xs:w-4 h-3 xs:h-4 sm:w-6 sm:h-6 p-1"
                              />
                            </button>
                          {:else}
                            <div class="w-4 h-4 sm:w-6 sm:h-6 p-1">&nbsp;</div>
                          {/if}
                          <div class="flex justify-center items-center flex-grow">
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
                                className="w-3 xs:w-4 h-3 xs:h-4 sm:w-7 sm:h-7 md:w-6 md:h-6"
                              />
                            </span>
                          {:else}
                            <button
                              on:click={() => setCaptain(player.id)}
                              class="mb-1"
                            >
                              <PlayerCaptainIcon
                                className="w-3 xs:w-4 h-3 xs:h-4 sm:w-7 sm:h-7 md:w-6 md:h-6"
                              />
                            </button>
                          {/if}
                        </div>
                      </div>
                      <div
                        class="flex flex-col justify-center items-center text-xxs sm:text-xs"
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
                          <p class="xs:hidden truncate min-w-[50px] max-w-[50px]">
                            {player.lastName}
                          </p>
                        </div>
                        <div
                          class="flex justify-center items-center bg-white text-black md:px-2 sm:py-1 rounded-b-md
                          min-w-[60px] xs:min-w-[90px] sm:min-w-[120px]
                          max-w-[60px] xs:max-w-[90px] sm:max-w-[120px]"
                        >
                          <p class="hidden sm:visible sm:min-w-[20px]">
                            {team?.abbreviatedName}
                          </p>
                          <BadgeIcon
                            className="w-2 h-2 xs:h-4 xs:w-4 sm:mx-1 min-w-[15px] pl-2 xs:pl-0"
                            primaryColour={team?.primaryColourHex}
                            secondaryColour={team?.secondaryColourHex}
                            thirdColour={team?.thirdColourHex}
                          />
                          <p class="truncate min-w-[50px] max-w-[50px]">
                            £{(player.valueQuarterMillions / 4).toFixed(2)}m
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
          {@const team = $clubStore.find((x) => x.id === player?.clubId)}

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
{/if}

