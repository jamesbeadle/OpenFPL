import { s as systemStore, A as ActorFactory, i as idlFactory, a as authStore } from "./team-store.js";
import { w as writable } from "./index.js";
import "@dfinity/agent";
function createManagerStore() {
  const { subscribe, set } = writable(null);
  let systemState;
  systemStore.subscribe((value) => {
    systemState = value;
  });
  const actor = ActorFactory.createActor(
    idlFactory,
    { "OPENFPL_BACKEND_CANISTER_ID": "bboqb-jiaaa-aaaal-qb6ea-cai", "OPENFPL_FRONTEND_CANISTER_ID": "bgpwv-eqaaa-aaaal-qb6eq-cai", "PLAYER_CANISTER_CANISTER_ID": "pec6o-uqaaa-aaaal-qb7eq-cai", "TOKEN_CANISTER_CANISTER_ID": "hwd4h-eyaaa-aaaal-qb6ra-cai", "DFX_NETWORK": "ic" }.OPENFPL_BACKEND_CANISTER_ID
  );
  async function getManager(managerId, seasonId, gameweek) {
    try {
      return await actor.getManager(
        managerId,
        seasonId,
        gameweek
      );
    } catch (error) {
      console.error("Error fetching manager for gameweek:", error);
      throw error;
    }
  }
  async function getTotalManagers() {
    try {
      const managerCountData = await actor.getTotalManagers();
      return Number(managerCountData);
    } catch (error) {
      console.error("Error fetching total managers:", error);
      throw error;
    }
  }
  async function getFantasyTeamForGameweek(managerId, gameweek) {
    try {
      const fantasyTeamData = await actor.getFantasyTeamForGameweek(
        managerId,
        systemState?.activeSeason.id,
        gameweek
      );
      return fantasyTeamData;
    } catch (error) {
      console.error("Error fetching fantasy team for gameweek:", error);
      throw error;
    }
  }
  async function getFantasyTeam() {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        { "OPENFPL_BACKEND_CANISTER_ID": "bboqb-jiaaa-aaaal-qb6ea-cai", "OPENFPL_FRONTEND_CANISTER_ID": "bgpwv-eqaaa-aaaal-qb6eq-cai", "PLAYER_CANISTER_CANISTER_ID": "pec6o-uqaaa-aaaal-qb7eq-cai", "TOKEN_CANISTER_CANISTER_ID": "hwd4h-eyaaa-aaaal-qb6ra-cai", "DFX_NETWORK": "ic" }.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );
      const fantasyTeam = await identityActor.getFantasyTeam();
      return fantasyTeam;
    } catch (error) {
      console.error("Error fetching fantasy team:", error);
      throw error;
    }
  }
  async function saveFantasyTeam(userFantasyTeam, activeGameweek) {
    try {
      let bonusPlayed = getBonusPlayed(userFantasyTeam, activeGameweek);
      let bonusPlayerId = getBonusPlayerId(userFantasyTeam, activeGameweek);
      let bonusTeamId = getBonusTeamId(userFantasyTeam, activeGameweek);
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        { "OPENFPL_BACKEND_CANISTER_ID": "bboqb-jiaaa-aaaal-qb6ea-cai", "OPENFPL_FRONTEND_CANISTER_ID": "bgpwv-eqaaa-aaaal-qb6eq-cai", "PLAYER_CANISTER_CANISTER_ID": "pec6o-uqaaa-aaaal-qb7eq-cai", "TOKEN_CANISTER_CANISTER_ID": "hwd4h-eyaaa-aaaal-qb6ra-cai", "DFX_NETWORK": "ic" }.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );
      const fantasyTeam = await identityActor.saveFantasyTeam(
        userFantasyTeam.playerIds,
        userFantasyTeam.captainId,
        bonusPlayed,
        bonusPlayerId,
        bonusTeamId
      );
      return fantasyTeam;
    } catch (error) {
      console.error("Error saving fantasy team:", error);
      throw error;
    }
  }
  function getBonusPlayed(userFantasyTeam, activeGameweek) {
    let bonusPlayed = 0;
    if (userFantasyTeam.goalGetterGameweek === activeGameweek) {
      bonusPlayed = 1;
    }
    if (userFantasyTeam.passMasterGameweek === activeGameweek) {
      bonusPlayed = 2;
    }
    if (userFantasyTeam.noEntryGameweek === activeGameweek) {
      bonusPlayed = 3;
    }
    if (userFantasyTeam.teamBoostGameweek === activeGameweek) {
      bonusPlayed = 4;
    }
    if (userFantasyTeam.safeHandsGameweek === activeGameweek) {
      bonusPlayed = 5;
    }
    if (userFantasyTeam.captainFantasticGameweek === activeGameweek) {
      bonusPlayed = 6;
    }
    if (userFantasyTeam.hatTrickHeroGameweek === activeGameweek) {
      bonusPlayed = 7;
    }
    if (userFantasyTeam.hatTrickHeroGameweek === activeGameweek) {
      bonusPlayed = 8;
    }
    return bonusPlayed;
  }
  function getBonusPlayerId(userFantasyTeam, activeGameweek) {
    let bonusPlayerId = 0;
    if (userFantasyTeam.goalGetterGameweek === activeGameweek) {
      bonusPlayerId = userFantasyTeam.goalGetterPlayerId;
    }
    if (userFantasyTeam.passMasterGameweek === activeGameweek) {
      bonusPlayerId = userFantasyTeam.passMasterPlayerId;
    }
    if (userFantasyTeam.noEntryGameweek === activeGameweek) {
      bonusPlayerId = userFantasyTeam.noEntryPlayerId;
    }
    if (userFantasyTeam.safeHandsGameweek === activeGameweek) {
      bonusPlayerId = userFantasyTeam.safeHandsPlayerId;
    }
    if (userFantasyTeam.captainFantasticGameweek === activeGameweek) {
      bonusPlayerId = userFantasyTeam.captainId;
    }
    return bonusPlayerId;
  }
  function getBonusTeamId(userFantasyTeam, activeGameweek) {
    let bonusTeamId = 0;
    if (userFantasyTeam.teamBoostGameweek === activeGameweek) {
      bonusTeamId = userFantasyTeam.teamBoostTeamId;
    }
    return bonusTeamId;
  }
  return {
    subscribe,
    getManager,
    getTotalManagers,
    getFantasyTeamForGameweek,
    getFantasyTeam,
    saveFantasyTeam
    // Add any other methods as needed
  };
}
createManagerStore();
