import { writable } from "svelte/store";
import type { FootballLeagueDTO } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { LeagueService } from "$lib/services/league-service";
import type {
  FootballLeagueId,
  Gender,
} from "../../../../declarations/data_canister/data_canister.did";

function createLeagueStore() {
  const { subscribe, set } = writable<FootballLeagueDTO[]>([]);

  async function updateName(
    leagueId: FootballLeagueId,
    leagueName: string,
  ): Promise<any> {
    return new LeagueService().setLeagueName(leagueId, leagueName);
  }

  async function updateAbbreviatedName(
    leagueId: FootballLeagueId,
    abbreviatedName: string,
  ): Promise<any> {
    return new LeagueService().setAbbreviatedName(leagueId, abbreviatedName);
  }

  async function updateGoverningBody(
    leagueId: FootballLeagueId,
    governingBody: string,
  ): Promise<any> {
    return new LeagueService().setGoverningBody(leagueId, governingBody);
  }

  async function updateGender(
    leagueId: FootballLeagueId,
    gender: Gender,
  ): Promise<any> {
    return new LeagueService().setGender(leagueId, gender);
  }

  async function updateDateFormed(
    leagueId: FootballLeagueId,
    dateFormed: bigint,
  ): Promise<any> {
    return new LeagueService().setDateFormed(leagueId, dateFormed);
  }

  async function updateCountryId(
    leagueId: FootballLeagueId,
    countryId: number,
  ): Promise<any> {
    return new LeagueService().setCountryId(leagueId, countryId);
  }

  async function updateLogo(
    leagueId: FootballLeagueId,
    logo: Uint8Array,
  ): Promise<any> {
    return new LeagueService().setLogo(leagueId, logo);
  }

  async function updateTeamCount(
    leagueId: FootballLeagueId,
    teamCount: number,
  ): Promise<any> {
    return new LeagueService().setTeamCount(leagueId, teamCount);
  }

  return {
    subscribe,
    setLeagues: (leagues: FootballLeagueDTO[]) => set(leagues),
    updateName,
    updateAbbreviatedName,
    updateGoverningBody,
    updateGender,
    updateDateFormed,
    updateCountryId,
    updateLogo,
    updateTeamCount,
  };
}

export const leagueStore = createLeagueStore();
