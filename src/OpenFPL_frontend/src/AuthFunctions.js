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
  }
}

export const getFantasyTeamForGameweek = async (authClient, manager, seasonId, gameweek) => {
  try {
    const identity = authClient.getIdentity();
    agent.replaceIdentity(identity);
    var team = await open_fpl_backend.getFantasyTeamForGameweek(manager, seasonId, gameweek);
    return team;
  } catch (error) {
    console.error(error);
  }
}

export const fetchValidatableFixtures = async (authClient) => {
  try {
    const identity = authClient.getIdentity();
    agent.replaceIdentity(identity);
    return await open_fpl_backend.getValidatableFixtures();
  } catch (error) {
    console.error(error);
  }
}

export const saveFantasyTeam = async (authClient, newPlayerIds, fantasyTeam, selectedBonusId, selectedBonusPlayerId, selectedBonusTeamId) => {
  try {
    const identity = authClient.getIdentity();
    agent.replaceIdentity(identity);
    await open_fpl_backend.saveFantasyTeam(newPlayerIds, fantasyTeam.captainId ? Number(fantasyTeam.captainId) : 0, selectedBonusId ? Number(selectedBonusId) : 0, selectedBonusPlayerId ? Number(selectedBonusPlayerId) : 0, selectedBonusTeamId ? Number(selectedBonusTeamId) : 0);
  } catch(error) {
    console.error("Failed to save team", error);
  }
};
