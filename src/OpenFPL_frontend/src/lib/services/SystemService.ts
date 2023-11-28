import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import type {
  DataCache,
  SystemState,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { ActorFactory } from "../../utils/ActorFactory";
import { replacer } from "../utils/Helpers";

export class SystemService {
  private actor: any;

  constructor() {
    this.actor = ActorFactory.createActor(
      idlFactory,
      process.env.OPENFPL_BACKEND_CANISTER_ID
    );
  }

  async updateSystemStateData() {
    let category = "system_state";
    const newHashValues: DataCache[] = await this.actor.getDataHashes();
    let liveHash = newHashValues.find((x) => x.category === category) ?? null;
    const localHash = localStorage.getItem(category);

    if (liveHash?.hash != localHash) {
      let updatedSystemStateData = await this.actor.getSystemState();
      localStorage.setItem(
        "system_state_data",
        JSON.stringify(updatedSystemStateData, replacer)
      );
      localStorage.setItem(category, liveHash?.hash ?? "");
    }
  }

  async getSystemState(): Promise<SystemState | null> {
    const cachedTeamsData = localStorage.getItem("system_state_data");

    let cachedSystemState: SystemState | null;
    try {
      cachedSystemState = JSON.parse(cachedTeamsData || "{}");
    } catch (e) {
      cachedSystemState = null;
    }

    return cachedSystemState;
  }
}
