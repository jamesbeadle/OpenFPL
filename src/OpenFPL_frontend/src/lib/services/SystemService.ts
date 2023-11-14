import { ActorFactory } from "../../utils/ActorFactory";
import { idlFactory } from "../../../../declarations/OpenFPL_backend";

export class SystemService {
    private actor: any;

    constructor() {
        this.actor = ActorFactory.createActor(idlFactory, process.env.OPENFPL_BACKEND_CANISTER_ID);
    }    

    async getSystemState(latestSystemStateHash: string) {
        const cachedHash = localStorage.getItem('system_state_hash');
        const cachedSystemStateData = localStorage.getItem('system_state_data');
        
        if (!latestSystemStateHash || cachedHash !== latestSystemStateHash) {
            return this.fetchSystemState(latestSystemStateHash);
        } else {
            return cachedSystemStateData;
        }
    }
    
    private async fetchSystemState(playersHash: string) {
        try {
            const systemStateData = await this.actor.getSystemState();
            localStorage.setItem('system_state_hash', playersHash);
            localStorage.setItem('system_state_data', systemStateData);
            return systemStateData;
        } catch (error) {
            console.error("Error fetching all players:", error);
            throw error;
        }
    }
}
