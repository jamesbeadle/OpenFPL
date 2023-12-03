<script lang="ts">
  import { onMount, onDestroy } from "svelte";
  import { page } from "$app/stores";
  import { systemStore } from "$lib/stores/system-store";
  import { managerStore } from "$lib/stores/manager-store";
  import { toastsError } from "$lib/stores/toasts-store";
  import type {
    ManagerDTO,
    Season,
    SystemState,
  } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import ViewDetailsIcon from "$lib/icons/ViewDetailsIcon.svelte";
  import LoadingIcon from "$lib/icons/LoadingIcon.svelte";

  let systemState: SystemState | null;
  let isLoading = true;
  export let principalId = "";
  export let viewGameweekDetail: (
    principalId: string,
    selectedGameweek: number
  ) => void;
  let manager: ManagerDTO;
  let selectedGameweek: number = 1;
  let selectedSeason: Season | null = null;

  let unsubscribeSystemState: () => void;

  $: id = $page.url.searchParams.get("id") ?? principalId;

  onMount(async () => {
    try {
      await systemStore.sync();

      unsubscribeSystemState = systemStore.subscribe((value) => {
        systemState = value;
      });

      selectedGameweek = systemState?.activeGameweek ?? selectedGameweek;
      selectedSeason = systemState?.activeSeason ?? selectedSeason;
      manager = await managerStore.getManager(
        id ?? "",
        selectedSeason?.id ?? 1,
        selectedGameweek
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

  onDestroy(() => {
    unsubscribeSystemState?.();
  });
</script>

{#if isLoading}
  <LoadingIcon />
{:else}
  <div class="flex flex-col space-y-4 text-lg mt-4">
    <div class="overflow-x-auto flex-1">
      <div
        class="flex justify-between p-2 border border-gray-700 py-4 bg-light-gray"
      >
        <div class="w-1/4 px-4">Gameweek</div>
        <div class="w-1/4 px-4">Points</div>
        <div class="w-1/4 px-4">&nbsp;</div>
      </div>

      {#each manager.gameweeks as gameweek}
        <div
          class="flex items-center justify-between p-2 py-4 border-b border-gray-700 cursor-pointer"
        >
          <div class="w-1/4 px-4">{gameweek.gameweek}</div>
          <div class="w-1/4 px-4">{gameweek.points}</div>
          <div class="w-1/4 px-4 flex items-center">
            <button
              on:click={() =>
                viewGameweekDetail(gameweek.principalId, gameweek.gameweek)}
            >
              <span class="flex items-center">
                <ViewDetailsIcon className="w-6 mr-2" />View Details
              </span>
            </button>
          </div>
        </div>
      {/each}
    </div>
  </div>
{/if}
