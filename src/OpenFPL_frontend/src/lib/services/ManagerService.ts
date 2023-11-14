import { ActorFactory } from "../../utils/ActorFactory";
import { idlFactory } from "../../../../declarations/OpenFPL_backend";

export class ManagerService {
    private actor: any;

    constructor() {
        this.actor = ActorFactory.createActor(idlFactory, process.env.OPENFPL_BACKEND_CANISTER_ID);
    }

    async getTotalManagers(): Promise<number> {
        try {
        const managerCountData = await this.actor.getTotalManagers();
        return Number(managerCountData);
        } catch (error) {
        console.error("Error fetching total managers:", error);
        throw error;
        }
    }
}
