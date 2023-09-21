import { OpenFPL_backend as open_fpl_backend } from '../../declarations/OpenFPL_backend';
import { Actor } from "@dfinity/agent";

const agent = Actor.agentOf(open_fpl_backend);

export const fetchFantasyTeam = async (authClient) => {
  try {
    const identity = authClient.getIdentity();
    agent.replaceIdentity(identity);
    var team = await open_fpl_backend.getFantasyTeam();
    return team;
  } catch (error) {
    console.error(error);
    throw error;
  }
}
