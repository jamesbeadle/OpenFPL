import { writable } from "svelte/store";
import type {
  ClubDTO,
  FootballLeagueId,
  TransferPlayerDTO,
} from "../../../../declarations/data_canister/data_canister.did";
import { AdminService } from "../services/admin-service";

async function getLeagueClubs(leagueId: FootballLeagueId): Promise<ClubDTO[]> {
  return new AdminService().getLeagueClubs(leagueId);
}

function createAdminStore() {
  async function transferPlayer(
    leagueId: FootballLeagueId,
    dto: TransferPlayerDTO,
  ): Promise<any> {
    return new AdminService().transferPlayer(leagueId, dto);
  }

  return {
    transferPlayer,
    getLeagueClubs,
  };
}

export const adminStore = createAdminStore();
