import { writable } from "svelte/store";
import { isError } from "$lib/utils/helpers";
import { 
    type FantasyTeamSnapshotDTO,
    type CanisterDTO,
    type CanisterInfoDTO,
    type CanisterType,
    type UpdateRewardPoolsDTO,
    type UpdateSystemStatusDTO,
    type StaticCanistersDTO
 } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import { ActorFactory } from "../../utils/ActorFactory";
import { adminStore } from "$lib/stores/admin-store";
import { get } from "svelte/store";
import { toastsError } from "$lib/stores/toasts-store";
 
export const loadCanisters = async (reload = false) => {
    const canisters = get(adminStore);

    if(canisters !== undefined && !reload){
        return;
    }

    let actor: any = ActorFactory.createActor(
        idlFactory,
        process.env.OPENFPL_BACKEND_CANISTER_ID,
      );

    try{
        let result = await actor.getCanisterCyclesBalance();
        if (isError(result)) {
            console.error("Error fetching canister's cycles count");
            return;
        }
        const canisters: CanisterDTO = await actor.getStaticCanisters();
        adminStore.set(canisters);

    } catch(error){

        toastsError({
            msg: { text: "Error fetching cannister cycles" },
            err: error,
          });
    }
}