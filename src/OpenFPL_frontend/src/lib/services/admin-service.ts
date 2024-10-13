import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import type { AdminDashboardDTO } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { ActorFactory } from "../../utils/ActorFactory";
import { isError } from "../utils/helpers";

export class AdminService {
  private actor: any;

  constructor() {
    this.actor = ActorFactory.createActor(
      idlFactory,
      process.env.OPENFPL_BACKEND_CANISTER_ID,
    );
  }

  async getAdminDashboard(): Promise<AdminDashboardDTO> {
    const result = await this.actor.getAdminDashboard();
    if (isError(result)) throw new Error("Failed to fetch clubs");
    return result.ok;
  }
}
