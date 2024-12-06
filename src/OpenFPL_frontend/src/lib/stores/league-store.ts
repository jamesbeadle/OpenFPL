import { LeagueService } from "$lib/services/league-service";
import type { LeagueStatus } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { writable } from "svelte/store";

function createLeagueStore() {
  const { subscribe, set } = writable<LeagueStatus | null>(null);

  async function getLeagueStatus(): Promise<LeagueStatus> {
    return await new LeagueService().getLeagueStatus();
  }

  return {
    subscribe,
    getLeagueStatus,
    setLeagueStatus: (leagueStatus: LeagueStatus) => set(leagueStatus),
  };
}

export const leagueStore = createLeagueStore();
