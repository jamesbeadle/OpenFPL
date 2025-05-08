import { leagueStore } from "$lib/stores/league-store";
import { derived, type Readable } from "svelte/store";

interface DisplayData {
  activeGameweek: number;
}

export const leagueStatusStore: Readable<DisplayData> = derived(
  leagueStore,
  (store) => {
    return {
      activeGameweek: 0,
    };
  },
);
