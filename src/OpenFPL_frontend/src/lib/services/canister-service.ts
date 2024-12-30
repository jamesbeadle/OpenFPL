import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import { ActorFactory } from "../utils/actor.factory";
import { isError } from "../utils/helpers";
import type {
  CanisterDTO,
  GetCanistersDTO,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

export class CanisterService {
  private actor: any;

  constructor() {
    this.actor = ActorFactory.createActor(
      idlFactory,
      process.env.OPENFPL_BACKEND_CANISTER_ID,
    );
  }

  async getCanisters(dto: GetCanistersDTO): Promise<CanisterDTO[]> {
    const result = await this.actor.getCanisters(dto);
    if (isError(result)) throw new Error("Failed to fetch canisters");
    return result.ok;
  }
}
