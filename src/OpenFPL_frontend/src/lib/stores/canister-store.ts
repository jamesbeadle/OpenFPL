import { CanisterService } from "$lib/services/canister-service";
import type {
  CanisterDTO,
  GetCanistersDTO,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

function createCanisterStore() {
  async function getCanisters(dto: GetCanistersDTO): Promise<CanisterDTO[]> {
    return new CanisterService().getCanisters(dto);
  }

  return {
    getCanisters,
  };
}

export const canisterStore = createCanisterStore();
