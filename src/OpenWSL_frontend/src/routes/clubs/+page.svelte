<script lang="ts">
  import { onMount } from "svelte";
  import { toastsError } from "$lib/stores/toasts-store";
  import { clubStore } from "$lib/stores/club-store";
  import Layout from "../Layout.svelte";
  import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
    import { storeManager } from "$lib/managers/store-manager";

  onMount(async () => {
    try {
      await storeManager.syncStores();
      
    } catch (error) {
      toastsError({
        msg: { text: "Error fetching league table." },
        err: error,
      });
      console.error("Error fetching league table:", error);
    } finally {
    }
  });
</script>

<Layout>
  <div class="page-header-wrapper flex w-full">
    <div class="content-panel w-full">
      <div class="w-full grid grid-cols-1 md:grid-cols-4 gap-4 mt-4">
        <p class="col-span-1 md:col-span-4 text-center w-full mb-4">
          Super League Clubs
        </p>
        {#each $clubStore.sort((a, b) => a.id - b.id) as team}
          <div
            class="flex flex-col items-center bg-gray-700 rounded shadow p-4 w-full"
          >
            <div class="flex items-center space-x-4 w-full">
              <BadgeIcon
                primaryColour={team.primaryColourHex}
                secondaryColour={team.secondaryColourHex}
                thirdColour={team.thirdColourHex}
                className="w-8"
              />
              <p class="flex-grow text-lg md:text-sm">{team.friendlyName}</p>
              <a class="mt-auto self-end" href={`/club?id=${team.id}`}>
                <button
                  class="fpl-button text-white font-bold py-2 px-4 rounded self-end"
                >
                  View
                </button>
              </a>
            </div>
          </div>
        {/each}
      </div>
    </div>
  </div>
</Layout>
