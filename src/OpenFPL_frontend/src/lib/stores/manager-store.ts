import { authStore } from "$lib/stores/auth.store";
import { systemStore } from "$lib/stores/system-store";
import { isError, replacer } from "$lib/utils/Helpers";
import { writable } from "svelte/store";
import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import type {
  DataCacheDTO,
  FantasyTeamSnapshot,
  ManagerDTO,
  PickTeamDTO,
  SystemStateDTO
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { ActorFactory } from "../../utils/ActorFactory";

function createManagerStore() {
  const { subscribe, set } = writable<PickTeamDTO | null>(null);

  let systemState: SystemStateDTO;
  systemStore.subscribe((value) => {
    systemState = value as SystemStateDTO;
  });

  let actor: any = ActorFactory.createActor(
    idlFactory,
    process.env.OPENFPL_BACKEND_CANISTER_ID
  );

  let newManager = {
    playerIds: [],
    countrymenCountryId: 0,
    username: "",
    goalGetterPlayerId: 0,
    hatTrickHeroGameweek: 0,
    transfersAvailable: 0,
    termsAccepted: false,
    teamBoostGameweek: 0,
    captainFantasticGameweek: 0,
    createDate: 0n,
    countrymenGameweek: 0,
    bankQuarterMillions: 0,
    noEntryPlayerId: 0,
    safeHandsPlayerId: 0,
    history: [],
    braceBonusGameweek: 0,
    favouriteClubId: 0,
    passMasterGameweek: 0,
    teamBoostClubId: 0,
    goalGetterGameweek: 0,
    captainFantasticPlayerId: 0,
    profilePicture: [],
    transferWindowGameweek: 0,
    noEntryGameweek: 0,
    prospectsGameweek: 0,
    safeHandsGameweek: 0,
    principalId: "",
    passMasterPlayerId: 0,
    captainId: 0,
    monthlyBonusesAvailable: 0,
  };

  async function getPublicProfile(principalId: string): Promise<ManagerDTO> {
    try {
      let result = await actor.getManager(principalId);

      if (isError(result)) {
        console.error("Error getting public profile");
      }

      let profile = result.ok;
      return profile;
    } catch (error) {
      console.error("Error fetching manager profile for gameweek:", error);
      throw error;
    }
  }

  async function getTotalManagers(): Promise<number> {
    try {
      let result = await actor.getTotalManagers();

      if (isError(result)) {
        console.error("Error getting public profile");
      }

      const managerCountData = result.ok;
      return Number(managerCountData);
    } catch (error) {
      console.error("Error fetching total managers:", error);
      throw error;
    }
  }

  async function getFantasyTeamForGameweek(
    managerId: string,
    gameweek: number
  ): Promise<FantasyTeamSnapshot | null> {
    try {
      const category = "gameweek_points";
      const newHashValues = await actor.getDataHashes();

      let error = isError(newHashValues);
      if (error) {
        console.error("Error fetching hash values");
        return null;
      }

      let dataCacheValues: DataCacheDTO[] = newHashValues.ok;

      let weelklyLeaderboardHash =
        dataCacheValues.find(
          (x: DataCacheDTO) => x.category === "weekly_leaderboard_hash"
        ) ?? null;

      const localHash = localStorage.getItem(`${category}_hash`);

      if (weelklyLeaderboardHash != localHash) {
        let result = await actor.getManagerGameweek(
          managerId,
          systemState?.calculationGameweek,
          gameweek
        );

        if (isError(result)) {
          console.error("Error fetching fantasy team for gameweek:");
        }

        let snapshot = result.ok;
        localStorage.setItem(category, JSON.stringify(snapshot, replacer));
        localStorage.setItem(
          `${category}_hash`,
          weelklyLeaderboardHash?.hash ?? ""
        );
        const fantasyTeamData = result.ok;
        return fantasyTeamData;
      } else {
        const cachedSnapshot = localStorage.getItem(category);
        let snapshot = JSON.parse(cachedSnapshot || "undefined");
        return snapshot;
      }
    } catch (error) {
      console.error("Error fetching fantasy team for gameweek:", error);
      throw error;
    }
  }

  async function getCurrentTeam(): Promise<PickTeamDTO> {
    try {
      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );
      const result = await identityActor.getCurrentTeam();

      if (isError(result)) {
        return newManager;
      }

      let fantasyTeam = result.ok;
      return fantasyTeam;
    } catch (error) {
      console.error("Error fetching fantasy team:", error);
      throw error;
    }
  }

  async function saveFantasyTeam(
    userFantasyTeam: PickTeamDTO,
    activeGameweek: number,
    bonusUsedInSession: boolean,
    transferWindowPlayedInSession: boolean
  ): Promise<any> {
    try {
      let bonusPlayed = 0;
      let bonusPlayerId = 0;
      let bonusTeamId = 0;
      let bonusCountryId = 0;

      if (bonusUsedInSession) {
        bonusPlayerId = getBonusPlayerId(userFantasyTeam, activeGameweek);
        bonusTeamId = getBonusTeamId(userFantasyTeam, activeGameweek);
        bonusPlayed = getBonusPlayed(userFantasyTeam, activeGameweek);
        bonusCountryId = getBonusCountryId(userFantasyTeam, activeGameweek);
      }

      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );

      let dto: PickTeamDTO = {
        playerIds: userFantasyTeam.playerIds,
        captainId: userFantasyTeam.captainId,
        goalGetterGameweek:
          bonusPlayed == 1
            ? activeGameweek
            : userFantasyTeam.goalGetterGameweek,
        goalGetterPlayerId: bonusPlayerId,
        passMasterGameweek:
          bonusPlayed == 2
            ? activeGameweek
            : userFantasyTeam.goalGetterGameweek,
        passMasterPlayerId: bonusPlayerId,
        noEntryGameweek:
          bonusPlayed == 3
            ? activeGameweek
            : userFantasyTeam.goalGetterGameweek,
        noEntryPlayerId: bonusPlayerId,
        teamBoostGameweek:
          bonusPlayed == 4
            ? activeGameweek
            : userFantasyTeam.goalGetterGameweek,
        teamBoostClubId: bonusTeamId,
        safeHandsGameweek:
          bonusPlayed == 5
            ? activeGameweek
            : userFantasyTeam.goalGetterGameweek,
        safeHandsPlayerId: bonusPlayerId,
        captainFantasticGameweek:
          bonusPlayed == 6
            ? activeGameweek
            : userFantasyTeam.goalGetterGameweek,
        captainFantasticPlayerId: bonusPlayerId,
        countrymenGameweek:
          bonusPlayed == 7
            ? activeGameweek
            : userFantasyTeam.goalGetterGameweek,
        countrymenCountryId: bonusCountryId,
        prospectsGameweek:
          bonusPlayed == 8
            ? activeGameweek
            : userFantasyTeam.goalGetterGameweek,
        braceBonusGameweek:
          bonusPlayed == 9
            ? activeGameweek
            : userFantasyTeam.goalGetterGameweek,
        hatTrickHeroGameweek:
          bonusPlayed == 10
            ? activeGameweek
            : userFantasyTeam.goalGetterGameweek,
        transferWindowGameweek: transferWindowPlayedInSession
          ? activeGameweek
          : userFantasyTeam.transferWindowGameweek,
        username: userFantasyTeam.username,
        transfersAvailable: 0,
        bankQuarterMillions: 0,
        principalId: "",
        monthlyBonusesAvailable: 0
      };

      let result = await identityActor.saveFantasyTeam(dto);

      if (isError(result)) {
        console.error("Error saving fantasy team");
        return;
      }

      const fantasyTeam = result.ok;
      return fantasyTeam;
    } catch (error) {
      console.error("Error saving fantasy team:", error);
      throw error;
    }
  }

  function getBonusPlayed(
    userFantasyTeam: PickTeamDTO,
    activeGameweek: number
  ): number {
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

    if (userFantasyTeam.prospectsGameweek === activeGameweek) {
      bonusPlayed = 7;
    }

    if (userFantasyTeam.countrymenGameweek === activeGameweek) {
      bonusPlayed = 8;
    }

    if (userFantasyTeam.hatTrickHeroGameweek === activeGameweek) {
      bonusPlayed = 9;
    }

    if (userFantasyTeam.hatTrickHeroGameweek === activeGameweek) {
      bonusPlayed = 10;
    }

    return bonusPlayed;
  }

  function getBonusPlayerId(
    userFantasyTeam: PickTeamDTO,
    activeGameweek: number
  ): number {
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

  function getBonusTeamId(
    userFantasyTeam: PickTeamDTO,
    activeGameweek: number
  ): number {
    let bonusTeamId = 0;

    if (userFantasyTeam.teamBoostGameweek === activeGameweek) {
      bonusTeamId = userFantasyTeam.teamBoostClubId;
    }

    return bonusTeamId;
  }

  function getBonusCountryId(
    userFantasyTeam: PickTeamDTO,
    activeGameweek: number
  ): number {
    let bonusCountryId = 0;

    if (userFantasyTeam.countrymenGameweek === activeGameweek) {
      bonusCountryId = userFantasyTeam.countrymenCountryId;
    }

    return bonusCountryId;
  }

  async function snapshotFantasyTeams() {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );
      await identityActor.snapshotFantasyTeams();
    } catch (error) {
      console.error("Error snapshotting fantasy teams:", error);
      throw error;
    }
  }

  return {
    subscribe,
    getTotalManagers,
    getFantasyTeamForGameweek,
    getCurrentTeam,
    saveFantasyTeam,
    snapshotFantasyTeams,
    getPublicProfile,
  };
}

export const managerStore = createManagerStore();
