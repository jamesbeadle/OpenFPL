<script lang="ts">
  import { onMount } from "svelte";
  import { writable, type Writable } from "svelte/store";
  import { page } from "$app/stores";
  import { systemStore } from "$lib/stores/system-store";
  import { managerStore } from "$lib/stores/manager-store";
  import { toastsError } from "$lib/stores/toasts-store";
  import type {
    FantasyTeamSnapshot,
    ManagerDTO,
    Season,
  } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import ViewDetailsIcon from "$lib/icons/ViewDetailsIcon.svelte";
  import LoadingIcon from "$lib/icons/LoadingIcon.svelte";
  import type { GameweekData } from "$lib/interfaces/GameweekData";

  export let principalId = "";
  export let viewGameweekDetail: (
    principalId: string,
    selectedGameweek: number
  ) => void;
  let manager: ManagerDTO;
  export let selectedGameweek = writable<number | null>(null);
  let selectedSeason: Season | null;
  let isLoading = true;

  $: id = $page.url.searchParams.get("id") ?? principalId;

  onMount(async () => {
    try {
      await systemStore.sync();
      selectedSeason = $systemStore?.activeSeason ?? null;
      manager = await managerStore.getManager(
        id ?? "",
        selectedSeason?.id ?? 1,
        $selectedGameweek!
      );
    } catch (error) {
      toastsError({
        msg: { text: "Error fetching manager gameweeks." },
        err: error,
      });
      console.error("Error fetching manager gameweeks:", error);
    } finally {
      isLoading = false;
    }
  });

  function getBonusIcon(snapshot: FantasyTeamSnapshot) {
    if (snapshot.goalGetterGameweek === snapshot.gameweek) {
      return `<img src="goal-getter.png" alt="Bonus" class="w-9" />`;
    } else if (snapshot.passMasterGameweek === snapshot.gameweek) {
      return `<img src="pass-master.png" alt="Bonus" class="w-9" />`;
    } else if (snapshot.noEntryGameweek === snapshot.gameweek) {
      return `<img src="no-entry.png" alt="Bonus" class="w-9" />`;
    } else if (snapshot.teamBoostGameweek === snapshot.gameweek) {
      return `<img src="team-boost.png" alt="Bonus" class="w-9" />`;
    } else if (snapshot.safeHandsGameweek === snapshot.gameweek) {
      return `<img src="safe-hands.png" alt="Bonus" class="w-9" />`;
    } else if (snapshot.captainFantasticGameweek === snapshot.gameweek) {
      return `<img src="captain-fantastic.png" alt="Bonus" class="w-9" />`;
    } else if (snapshot.braceBonusGameweek === snapshot.gameweek) {
      return `<img src="brace-bonus.png" alt="Bonus" class="w-9" />`;
    } else if (snapshot.hatTrickHeroGameweek === snapshot.gameweek) {
      return `<img src="hat-trick-hero.png" alt="Bonus" class="w-9" />`;
    } else {
      return "-";
    }
  }
</script>

{#if isLoading}
  <LoadingIcon />
{:else}
  <div class="flex flex-col space-y-4 text-lg mt-4">
    <div class="overflow-x-auto flex-1">
      <div
        class="flex justify-between p-2 border border-gray-700 py-4 bg-light-gray"
      >
        <div class="w-2/12 px-4">Gameweek</div>
        <div class="w-3/12 px-4">Captain</div>
        <div class="w-3/12 px-4">Bonus</div>
        <div class="w-2/12 px-4">Points</div>
        <div class="w-2/12 px-4">&nbsp;</div>
      </div>

      {#each manager.gameweeks as gameweek}
        <button
          class="w-full"
          on:click={() =>
            viewGameweekDetail(gameweek.principalId, gameweek.gameweek)}
        >
          <div
            class="flex items-center text-left justify-between p-2 py-4 border-b border-gray-700 cursor-pointer"
          >
            <div class="w-2/12 px-4">{gameweek.gameweek}</div>
            <div class="w-3/12 px-4">{gameweek.captainId}</div>
            <div class="w-3/12 px-4">{@html getBonusIcon(gameweek)}</div>
            <div class="w-2/12 px-4">{gameweek.points}</div>
            <div class="w-2/12 px-4 flex items-center">
              <span class="flex items-center">
                <ViewDetailsIcon className="w-6 mr-2" />View Details
              </span>
            </div>
          </div>
        </button>
      {/each}
    </div>
  </div>
{/if}
