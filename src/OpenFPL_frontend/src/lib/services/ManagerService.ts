import { ActorFactory } from "../../utils/ActorFactory";

export class ManagerService {
    private actor: any;

    constructor() {
        this.actor = ActorFactory.createActor();
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
