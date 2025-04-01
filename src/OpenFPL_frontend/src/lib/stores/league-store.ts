import { LeagueService } from "$lib/services/league-service";
import { writable } from "svelte/store";
import type { LeagueStatus } from "../../../../declarations/data_canister/data_canister.did";

function createLeagueStore() {
  const { subscribe, set } = writable<LeagueStatus | null>(null);

  async function getActiveOrUnplayedGameweek(): Promise<number> {
    let leagueStatus: LeagueStatus | null = null;
    subscribe((result) => {
      if (result == null) {
        throw new Error("Failed to subscribe to league store");
      }
      leagueStatus = result;
      if (!leagueStatus) {
        return;
      }

      if (leagueStatus.activeGameweek == 0) {
        return leagueStatus.unplayedGameweek;
      }

      return leagueStatus.activeGameweek;
    });
    return 0;
  }

  return {
    subscribe,
    getActiveOrUnplayedGameweek,
    setLeagueStatus: (leagueStatus: LeagueStatus) => set(leagueStatus),
  };
}

export const leagueStore = createLeagueStore();
