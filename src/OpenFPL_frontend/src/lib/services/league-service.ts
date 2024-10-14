import { authStore } from "$lib/stores/auth.store";
import type {
  CreateLeagueDTO,
  FootballLeagueId,
  Gender,
} from "../../../../declarations/data_canister/data_canister.did";
import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import type { FootballLeagueDTO } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { ActorFactory } from "../../utils/ActorFactory";
import { isError } from "../utils/helpers";

export class LeagueService {
  constructor() {}

  async getLeagues(): Promise<FootballLeagueDTO[]> {
    const identityActor: any = await ActorFactory.createIdentityActor(
      authStore,
      process.env.OPENFPL_BACKEND_CANISTER_ID ?? "",
    );

    const result = await identityActor.getLeagues();
    if (isError(result)) throw new Error("Failed to fetch leagues");
    return result.ok;
  }

  async setLeagueName(
    leagueId: FootballLeagueId,
    leagueName: string,
  ): Promise<void> {
    const identityActor: any = await ActorFactory.createIdentityActor(
      authStore,
      process.env.OPENFPL_BACKEND_CANISTER_ID ?? "",
    );

    const result = await identityActor.setLeagueName(leagueId, leagueName);
    if (isError(result)) throw new Error("Failed to set league name");
  }

  async setAbbreviatedName(
    leagueId: FootballLeagueId,
    abbreviatedName: string,
  ): Promise<void> {
    const identityActor: any = await ActorFactory.createIdentityActor(
      authStore,
      process.env.OPENFPL_BACKEND_CANISTER_ID ?? "",
    );

    const result = await identityActor.setAbbreviatedLeagueName(
      leagueId,
      abbreviatedName,
    );
    if (isError(result))
      throw new Error("Failed to set abbreviated league name");
  }

  async setGoverningBody(
    leagueId: FootballLeagueId,
    governingBody: string,
  ): Promise<void> {
    const identityActor: any = await ActorFactory.createIdentityActor(
      authStore,
      process.env.OPENFPL_BACKEND_CANISTER_ID ?? "",
    );

    const result = await identityActor.setLeagueGoverningBody(
      leagueId,
      governingBody,
    );
    if (isError(result)) throw new Error("Failed to set governing body");
  }

  async setGender(leagueId: FootballLeagueId, gender: Gender): Promise<void> {
    const identityActor: any = await ActorFactory.createIdentityActor(
      authStore,
      process.env.OPENFPL_BACKEND_CANISTER_ID ?? "",
    );

    const result = await identityActor.setLeagueGender(leagueId, gender);
    if (isError(result)) throw new Error("Failed to set league gender");
  }

  async setDateFormed(leagueId: FootballLeagueId, date: BigInt): Promise<void> {
    const identityActor: any = await ActorFactory.createIdentityActor(
      authStore,
      process.env.OPENFPL_BACKEND_CANISTER_ID ?? "",
    );

    const result = await identityActor.setLeagueDateFormed(leagueId, date);
    if (isError(result)) throw new Error("Failed to set league formed date");
  }

  async setCountryId(
    leagueId: FootballLeagueId,
    countryId: number,
  ): Promise<void> {
    const identityActor: any = await ActorFactory.createIdentityActor(
      authStore,
      process.env.OPENFPL_BACKEND_CANISTER_ID ?? "",
    );

    const result = await identityActor.setLeagueCountryId(leagueId, countryId);
    if (isError(result)) throw new Error("Failed to set league country");
  }

  async setLogo(leagueId: FootballLeagueId, logo: Uint8Array): Promise<void> {
    const identityActor: any = await ActorFactory.createIdentityActor(
      authStore,
      process.env.OPENFPL_BACKEND_CANISTER_ID ?? "",
    );

    const result = await identityActor.setLeagueLogo(leagueId, logo);
    if (isError(result)) throw new Error("Failed to set league logo");
  }

  async setTeamCount(
    leagueId: FootballLeagueId,
    teamCount: number,
  ): Promise<void> {
    const identityActor: any = await ActorFactory.createIdentityActor(
      authStore,
      process.env.OPENFPL_BACKEND_CANISTER_ID ?? "",
    );

    const result = await identityActor.setTeamCount(leagueId, teamCount);
    if (isError(result)) throw new Error("Failed to set league team count");
  }

  async createLeague(dto: CreateLeagueDTO): Promise<void> {
    const identityActor: any = await ActorFactory.createIdentityActor(
      authStore,
      process.env.OPENFPL_BACKEND_CANISTER_ID ?? "",
    );

    const result = await identityActor.createLeague(dto);
    if (isError(result)) throw new Error("Failed to create league");
  }
}
