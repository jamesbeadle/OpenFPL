<script lang="ts">
  import { onMount } from "svelte";
  import { writable, type Writable } from "svelte/store";
  import { systemStore } from "$lib/stores/system-store";
  import { toastsError } from "$lib/stores/toasts-store";
  import { clubStore } from "$lib/stores/club-store";
  import { fixtureStore } from "$lib/stores/fixture-store";
  import { playerStore } from "$lib/stores/player-store";
  import { playerEventsStore } from "$lib/stores/player-events-store";
  import {
    calculateAgeFromNanoseconds,
    convertPlayerPosition,
    getFlagComponent,
    getPositionAbbreviation,
  } from "$lib/utils/helpers";
  import type {
    ClubDTO,
    FantasyTeamSnapshot,
    PlayerDTO,
  } from "../../../../../declarations/OpenWSL_backend/OpenWSL_backend.did";
  import type { GameweekData } from "$lib/interfaces/GameweekData";
  import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
  import FantasyPlayerDetailModal from "../fantasy-player-detail-modal.svelte";
  import ActiveCaptainIcon from "$lib/icons/ActiveCaptainIcon.svelte";
  import { countryStore } from "$lib/stores/country-store";
    import LocalSpinner from "../local-spinner.svelte";
    import { seasonStore } from "$lib/stores/season-store";
    import { storeManager } from "$lib/managers/store-manager";

  let gameweekPlayers = writable<GameweekData[]>([]);
  let gameweeks = Array.from(
    { length: $systemStore?.pickTeamGameweek ?? 1 },
    (_, i) => i + 1
  );

  export let selectedGameweek = writable<number | null>(null);
  export let fantasyTeam = writable<FantasyTeamSnapshot | null>(null);
  export let loadingGameweek = writable<boolean>(true);

  let isLoading = false;
  let showModal = false;
  let selectedTeam: ClubDTO;
  let selectedOpponentTeam: ClubDTO;
  let selectedGameweekData: GameweekData;
  let activeSeasonName: string;

  $: if ($fantasyTeam && $selectedGameweek && $selectedGameweek > 0) {
    updateGameweekPlayers();
  }

  $: if ($selectedGameweek) {
    isLoading = true;
  }

  onMount(async () => {
    try {
      await storeManager.syncStores();
      activeSeasonName = await seasonStore.getSeasonName($systemStore?.pickTeamSeasonId ?? 0) ?? "";
      if (!$fantasyTeam) {
        $gameweekPlayers = [];
        return;
      }
      updateGameweekPlayers();
    } catch (error) {
      toastsError({
        msg: { text: "Error fetching manager gameweek detail." },
        err: error,
      });
      console.error("Error fetching manager gameweek detail:", error);
    } finally {
      $loadingGameweek = false;
    }
  });

  async function updateGameweekPlayers() {
    try {

      if (!$fantasyTeam) {
        gameweekPlayers.set([]);
        return;
      }
   
      let fetchedPlayers = await playerEventsStore.getGameweekPlayers(
        $fantasyTeam!,
        1, //TODO Set from dropdown
        $selectedGameweek!
      );

      calculateBonusPoints(fetchedPlayers, $fantasyTeam);
      
      gameweekPlayers.set(
        fetchedPlayers.sort((a, b) => {
          if (b.totalPoints === a.totalPoints) {
            return (
              b.player.valueQuarterMillions - a.player.valueQuarterMillions
            );
          }
          return b.totalPoints - a.totalPoints;
        })
      );
    } catch (error) {
      toastsError({
        msg: { text: "Error updating gameweek players." },
        err: error,
      });
      console.error("Error updating gameweek players:", error);
    } finally {
      isLoading = false;
    }
  }

  const changeGameweek = (delta: number) => {
    isLoading = true;
    $selectedGameweek = Math.max(1, Math.min(Number(process.env.TOTAL_GAMEWEEKS), $selectedGameweek! + delta));
  };

  function getPlayerDTO(playerId: number): PlayerDTO | null {
    return $playerStore.find((x) => x.id === playerId) ?? null;
  }

  function getPlayerTeam(teamId: number): ClubDTO | null {
    return $clubStore.find((x) => x.id === teamId) ?? null;
  }

  async function showDetailModal(gameweekData: GameweekData) {
    try {
      selectedGameweekData = gameweekData;

      let playerTeamId = gameweekData.player.clubId;
      selectedTeam = $clubStore.find((x) => x.id === playerTeamId)!;

      let playerFixture = $fixtureStore.find(
        (x) =>
          x.gameweek === gameweekData.gameweek &&
          (x.homeClubId === playerTeamId || x.awayClubId === playerTeamId)
      );
      let opponentId =
        playerFixture?.homeClubId === playerTeamId
          ? playerFixture?.awayClubId
          : playerFixture?.homeClubId;
      selectedOpponentTeam = $clubStore.find((x) => x.id === opponentId)!;
      showModal = true;
    } catch (error) {
      toastsError({
        msg: { text: "Error loading gameweek detail." },
        err: error,
      });
      console.error("Error loading gameweek detail:", error);
    }
  }

  function closeDetailModal() {
    showModal = false;
  }

  function calculateBonusPoints(
  gameweekData: GameweekData[],
  fantasyTeam: FantasyTeamSnapshot
) {
    gameweekData.forEach((data) => {
      let bonusPoints = 0;
      if (
        fantasyTeam.goalGetterPlayerId === data.player.id &&
        fantasyTeam.goalGetterGameweek === data.gameweek
      ) {
        bonusPoints += data.goals * data.goalPoints * 2;
      }

      if (
        fantasyTeam.passMasterPlayerId === data.player.id &&
        fantasyTeam.passMasterGameweek === data.gameweek
      ) {
        bonusPoints += data.assists * data.assistPoints * 2;
      }

      if (
        fantasyTeam.noEntryPlayerId === data.player.id &&
        fantasyTeam.noEntryGameweek === data.gameweek &&
        data.cleanSheets > 0 
      ) {
        bonusPoints += data.points * 2;
      }

      if (
        fantasyTeam.teamBoostClubId === data.player.clubId &&
        fantasyTeam.teamBoostGameweek === data.gameweek
      ) {
        bonusPoints += data.points;
      }

      if (
        fantasyTeam.safeHandsPlayerId === data.player.id &&
        fantasyTeam.safeHandsGameweek === data.gameweek &&
        data.saves >= 5
      ) {
        bonusPoints += data.points * 2;
      }

      if (
        fantasyTeam.oneNationCountryId === data.nationalityId &&
        fantasyTeam.oneNationGameweek === data.gameweek
      ) {
        bonusPoints += data.points;
      }

      if (
        isPlayerUnder21(data.player) &&
        fantasyTeam.prospectsGameweek === data.gameweek
      ) {
        bonusPoints += data.points;
      }

      if (
        fantasyTeam.braceBonusGameweek === data.gameweek &&
        data.goals >= 2
      ) {
        bonusPoints += data.points;
      }

      if (
        fantasyTeam.hatTrickHeroGameweek === data.gameweek &&
        data.goals >= 3
      ) {
        bonusPoints += data.points * 2;
      }

      data.bonusPoints = bonusPoints;
      data.totalPoints = data.points + bonusPoints;

      if (
        fantasyTeam.captainFantasticPlayerId === data.player.id &&
        fantasyTeam.captainFantasticGameweek === data.gameweek &&
        data.goals > 0
      ) {
        if (fantasyTeam.captainId === data.player.id) {
          data.totalPoints *= 2;
        }
      } else if (fantasyTeam.captainId === data.player.id) {
        data.totalPoints *= 2;
      }
    });
  }


  function isPlayerUnder21(player: PlayerDTO): boolean {
    let playerAge = calculateAgeFromNanoseconds(Number(player.dateOfBirth));
    return playerAge < 21;
  }

</script>

{#if isLoading}
  <LocalSpinner />
{:else}
  {#if showModal}
    <FantasyPlayerDetailModal
      playerTeam={selectedTeam}
      opponentTeam={selectedOpponentTeam}
      seasonName={activeSeasonName}
      visible={showModal}
      {closeDetailModal}
      gameweekData={selectedGameweekData}
    />
  {/if}
  <div>
    <div class="flex flex-col space-y-4">
      <div class="flex flex-col sm:flex-row gap-4 sm:gap-8">
        <div class="flex items-center space-x-2 ml-4 md:mb-2 md:ml-3">
          <button
            class={`${
              $selectedGameweek === 1 ? "bg-gray-500" : "fpl-button"
            } default-button`}
            on:click={() => changeGameweek(-1)}
            disabled={$selectedGameweek === 1}
          >
            &lt;
          </button>

          <select
            class="p-2 fpl-dropdown text-center mx-0 md:mx-2 min-w-[100px]"
            bind:value={$selectedGameweek}
          >
            {#each gameweeks as gameweek}
              <option value={gameweek}>Gameweek {gameweek}</option>
            {/each}
          </select>

          <button
            class={`${
              $selectedGameweek === $systemStore?.pickTeamGameweek
                ? "bg-gray-500"
                : "fpl-button"
            } default-button ml-1`}
            on:click={() => changeGameweek(1)}
            disabled={$selectedGameweek === $systemStore?.pickTeamGameweek}
          >
            &gt;
          </button>
        </div>
      </div>
    </div>

    <div class="hidden xxs:flex flex-col space-y-4 mt-2">
      {#if $fantasyTeam}
        <div class="overflow-x-auto flex-1">
          <div
            class="flex justify-between p-2 border border-gray-700 py-4 bg-light-gray"
          >
            <div class="w-1/12 text-center">Pos</div>
            <div class="w-2/12">Player</div>
            <div class="w-1/12 hidden lg:flex">Team</div>
            <div class="w-7/12 lg:7/12 flex">
              <div class="w-1/12 text-center">A</div>
              <div class="w-1/12 text-center">HSP</div>
              <div class="w-1/12 text-center">GS</div>
              <div class="w-1/12 text-center">GA</div>
              <div class="w-1/12 text-center">PS</div>
              <div class="w-1/12 text-center">CS</div>
              <div class="w-1/12 text-center">KS</div>
              <div class="w-1/12 text-center">YC</div>
              <div class="w-1/12 text-center">OG</div>
              <div class="w-1/12 text-center">GC</div>
              <div class="w-1/12 text-center">RC</div>
              <div class="w-1/12 text-center">B</div>
            </div>
            <div class="w-1/12 text-center">C</div>
            <div class="w-1/12 text-center">PTS</div>
          </div>

          {#each $gameweekPlayers as data}
            {@const playerDTO = getPlayerDTO(data.player.id)}
            {@const playerTeam = getPlayerTeam(data.player.clubId)}
            {@const playerCountry = $countryStore
              ? $countryStore.find((x) => x.id === playerDTO?.nationality)
              : null}
            <button
              class="w-full"
              on:click={() => {
                showDetailModal(data);
              }}
            >
              <div
                class="flex items-center p-2 justify-between py-4 border-b border-gray-700 cursor-pointer {$fantasyTeam.captainId ==
                playerDTO?.id
                  ? 'captain-row'
                  : ''}"
              >
                <div
                  class="w-1/12 text-center items-center justify-center flex"
                >
                  {#if $fantasyTeam.captainId == playerDTO?.id}
                    <ActiveCaptainIcon className="w-5 sm:w-6 md:w-7" />
                  {:else}
                    {getPositionAbbreviation(
                      convertPlayerPosition(data.player.position)
                    )}
                  {/if}
                </div>
                <div class="w-2/12 flex items-center">
                  <svelte:component
                    this={getFlagComponent(data.player.nationality)}
                    class="w-4 h-4 mr-1 hidden md:flex"
                    size="100"
                  />
                  <span class="flex items-center">
                    <BadgeIcon
                      primaryColour={playerTeam?.primaryColourHex}
                      secondaryColour={playerTeam?.secondaryColourHex}
                      thirdColour={playerTeam?.thirdColourHex}
                      className="w-4 h-4 mr-1 md:hidden"
                    />
                    <p
                      class="truncate min-w-[30px] max-w-[30px] xs:min-w-[50px] xs:max-w-[50px] sm:min-w-[60px] sm:max-w-[60px] md:min-w-[75px] md:max-w-[75px]"
                    >
                      {playerDTO
                        ? playerDTO.firstName.length > 0
                          ? playerDTO.firstName.substring(0, 1) +
                            "." +
                            playerDTO.lastName
                          : playerDTO.lastName
                        : "-"}
                    </p>
                  </span>
                </div>
                <div class="w-1/12 hidden lg:flex text-center">
                  <a href="/club?id={playerTeam?.id}" class="flex items-center">
                    <BadgeIcon
                      primaryColour={playerTeam?.primaryColourHex}
                      secondaryColour={playerTeam?.secondaryColourHex}
                      thirdColour={playerTeam?.thirdColourHex}
                      className="w-4 h-4 mr-2 hidden md:flex"
                    />
                    <span class="hidden md:flex">
                      {playerTeam?.abbreviatedName}
                    </span>
                  </a>
                </div>
                <div class="w-7/12 lg:7/12 flex">
                  <div
                    class={`w-1/12 text-center ${
                      data.appearance > 0 ? "" : "text-gray-500"
                    }`}
                  >
                    {data.appearance}
                  </div>
                  <div
                    class={`w-1/12 text-center ${
                      data.highestScoringPlayerId > 0 ? "" : "text-gray-500"
                    }`}
                  >
                    {data.highestScoringPlayerId}
                  </div>
                  <div
                    class={`w-1/12 text-center ${
                      data.goals > 0 ? "" : "text-gray-500"
                    }`}
                  >
                    {data.goals}
                  </div>
                  <div
                    class={`w-1/12 text-center ${
                      data.assists > 0 ? "" : "text-gray-500"
                    }`}
                  >
                    {data.assists}
                  </div>
                  <div
                    class={`w-1/12 text-center ${
                      data.penaltySaves > 0 ? "" : "text-gray-500"
                    }`}
                  >
                    {data.penaltySaves}
                  </div>
                  <div
                    class={`w-1/12 text-center ${
                      data.cleanSheets > 0 ? "" : "text-gray-500"
                    }`}
                  >
                    {data.cleanSheets}
                  </div>
                  <div
                    class={`w-1/12 text-center ${
                      data.saves > 0 ? "" : "text-gray-500"
                    }`}
                  >
                    {data.saves}
                  </div>
                  <div
                    class={`w-1/12 text-center ${
                      data.yellowCards > 0 ? "" : "text-gray-500"
                    }`}
                  >
                    {data.yellowCards}
                  </div>
                  <div
                    class={`w-1/12 text-center ${
                      data.ownGoals > 0 ? "" : "text-gray-500"
                    }`}
                  >
                    {data.ownGoals}
                  </div>
                  <div
                    class={`w-1/12 text-center ${
                      data.goalsConceded > 0 ? "" : "text-gray-500"
                    }`}
                  >
                    {data.goalsConceded}
                  </div>
                  <div
                    class={`w-1/12 text-center ${
                      data.redCards > 0 ? "" : "text-gray-500"
                    }`}
                  >
                    {data.redCards}
                  </div>
                  <div
                    class={`w-1/12 text-center ${
                      data.bonusPoints > 0 ? "" : "text-gray-500"
                    }`}
                  >
                    {data.bonusPoints}
                  </div>
                </div>
                <div
                  class={`w-1/12 text-center ${
                    $fantasyTeam.captainId == playerDTO?.id
                      ? ""
                      : "text-gray-500"
                  }`}
                >
                  {$fantasyTeam.captainId == playerDTO?.id ? data.points : "-"}
                </div>
                <div class="w-1/12 text-center">{data.totalPoints}</div>
              </div>
            </button>
          {/each}
        </div>
      {:else}
        <p>No Fantasy Team Data</p>
      {/if}
    </div>

    <div class="xxs:hidden flex-col space-y-4 mt-2">
      {#if $fantasyTeam}
        <div class="overflow-x-auto flex-1">
          <div
            class="flex justify-between p-2 border border-gray-700 py-4 bg-light-gray"
          >
            <div class="w-1/12">Pos</div>
            <div class="w-2/12">Player</div>
            <div class="w-1/2 flex">
              <div class="w-4/12 text-center">A</div>
              <div class="w-4/12 text-center">HSP</div>
              <div class="w-4/12 text-center">B</div>
            </div>
            <div class="w-1/12 text-center">PTS</div>
          </div>

          {#each $gameweekPlayers as data}
            {@const playerDTO = getPlayerDTO(data.player.id)}
            {@const playerTeam = getPlayerTeam(data.player.clubId)}
            <button
              class="w-full"
              on:click={() => {
                showDetailModal(data);
              }}
            >
              <div
                class="flex items-center p-2 justify-between py-4 border-b border-gray-700 cursor-pointer {$fantasyTeam.captainId ==
                playerDTO?.id
                  ? 'captain-row'
                  : ''}"
              >
                <div
                  class="w-1/12 text-center items-center justify-center flex"
                >
                  {#if $fantasyTeam.captainId == playerDTO?.id}
                    <ActiveCaptainIcon className="w-5" />
                  {:else}
                    {getPositionAbbreviation(
                      convertPlayerPosition(data.player.position)
                    )}
                  {/if}
                </div>
                <div class="w-2/12 flex items-center">
                  <span class="flex items-center">
                    <BadgeIcon
                      primaryColour={playerTeam?.primaryColourHex}
                      secondaryColour={playerTeam?.secondaryColourHex}
                      thirdColour={playerTeam?.thirdColourHex}
                      className="w-4 h-4 mr-1 md:hidden"
                    />
                    <p class="truncate min-w-[40px] max-w-[40px]">
                      {playerDTO
                        ? playerDTO.firstName.length > 0
                          ? playerDTO.firstName.substring(0, 1) +
                            "." +
                            playerDTO.lastName
                          : playerDTO.lastName
                        : "-"}
                    </p>
                  </span>
                </div>
                <div class="w-1/2 flex">
                  <div
                    class={`w-4/12 text-center ${
                      data.appearance > 0 ? "" : "text-gray-500"
                    }`}
                  >
                    {data.appearance}
                  </div>
                  <div
                    class={`w-4/12 text-center ${
                      data.highestScoringPlayerId > 0 ? "" : "text-gray-500"
                    }`}
                  >
                    {data.highestScoringPlayerId}
                  </div>
                  <div
                    class={`w-4/12 text-center ${
                      data.bonusPoints > 0 ? "" : "text-gray-500"
                    }`}
                  >
                    {data.bonusPoints}
                  </div>
                </div>
                <div class="w-1/12 text-center">{data.totalPoints}</div>
              </div>
            </button>
          {/each}
        </div>
      {:else}
        <p>No Fantasy Team Data</p>
      {/if}
    </div>
  </div>
{/if}

<div class="flex flex-row px-4 py-2">
  <div class="xxs:hidden w-full">
    <div class="flex flex-row space-x-2">
      <div class="w-1/2 flex flex-col">
        <p class="mb-1">A: Appearance</p>
        <p>HSP: Highest Scoring Player</p>
      </div>
      <div class="w-1/2 flex flex-col">
        <p class="mb-1">B: Bonus Points</p>
        <p>PTS: Total Points</p>
      </div>
    </div>
  </div>

  <div
    class="hidden xxs:grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 gap-2 w-full text-xs my-4"
  >
    <p>A: Appearance</p>
    <p>HSP: Highest Scoring Player</p>
    <p>GS: Goals Scored</p>
    <p>GA: Goals Assisted</p>
    <p>PS: Penalties Saved</p>
    <p>CS: Clean Sheets</p>
    <p>KS: Keeper Saves</p>
    <p>YC: Yellow Cards</p>
    <p>OG: Own Goals</p>
    <p>GC: Goals Conceded</p>
    <p>RC: Red Cards</p>
    <p>B: Bonus Points</p>
    <div class="flex items-center">
      <p>C: Captain Points</p>
      <ActiveCaptainIcon className="w-4 md:w-6 ml-2" />
    </div>
    <p>PTS: Total Points</p>
  </div>
</div>
