import { writable } from "svelte/store";
import type {
  FantasyTeamSnapshot,
  PlayerPointsDTO,
  SystemStateDTO,
} from "../../../../declarations/OpenWSL_backend/OpenWSL_backend.did";
import type {
  FixtureDTO,
  PlayerDetailDTO,
  PlayerDTO,
} from "../../../../declarations/data_canister/data_canister.did";
import { PlayerEventsService } from "$lib/services/player-events-service";
import type { GameweekData } from "$lib/interfaces/GameweekData";
import { systemStore } from "./system-store";
import { playerStore } from "./player-store";
import {
  calculateBonusPoints,
  calculatePlayerScore,
  extractPlayerData,
} from "$lib/utils/helpers";
import { fixtureStore } from "./fixture-store";

function createPlayerEventsStore() {
  const { subscribe, set } = writable<PlayerPointsDTO[]>([]);

  async function getPlayerDetails(
    playerId: number,
    seasonId: number,
  ): Promise<PlayerDetailDTO> {
    return new PlayerEventsService().getPlayerDetails(playerId, seasonId);
  }

  async function getGameweekPlayers(
    fantasyTeam: FantasyTeamSnapshot,
    seasonId: number,
    gameweek: number,
  ): Promise<GameweekData[]> {
    let allPlayerEvents: PlayerPointsDTO[] = [];
    let systemState: SystemStateDTO | null = null;
    systemStore.subscribe((result) => {
      if (result == null) {
        throw new Error("Failed to subscribe to system store");
      }
      systemState = {
        pickTeamSeasonId: result.pickTeamSeasonId,
        calculationGameweek: result.calculationGameweek,
        transferWindowActive: result.transferWindowActive,
        pickTeamGameweek: result.pickTeamGameweek,
        version: result.version,
        calculationMonth: result.calculationMonth,
        pickTeamMonth: result.pickTeamMonth,
        calculationSeasonId: result.calculationSeasonId,
        onHold: result.onHold,
        seasonActive: result.seasonActive,
      };
    });
    if (systemState == null) {
      throw new Error("Failed to subscribe to system store");
    }

    if (
      (systemState as SystemStateDTO).calculationSeasonId === seasonId &&
      (systemState as SystemStateDTO).calculationGameweek === gameweek
    ) {
      allPlayerEvents = await getPlayerEventsFromLocalStorage();
    } else {
      allPlayerEvents = await getPlayerEventsFromBackend(seasonId, gameweek);
    }

    let allPlayers: PlayerDTO[] = [];
    const unsubscribe = playerStore.subscribe((players) => {
      allPlayers = players.filter((player) =>
        fantasyTeam.playerIds.includes(player.id),
      );
    });
    unsubscribe();

    let gameweekData: GameweekData[] = await Promise.all(
      allPlayers.map(
        async (player) =>
          await extractPlayerData(
            allPlayerEvents.find((x) => x.id == player.id)!,
            player,
          ),
      ),
    );

    let allFixtures: FixtureDTO[] = [];

    const unsubscribeFixtures = fixtureStore.subscribe((fixtures) => {
      allFixtures = fixtures;
    });
    unsubscribeFixtures();

    const playersWithPoints = gameweekData.map((entry) => {
      const score = calculatePlayerScore(entry, allFixtures);
      const bonusPoints = calculateBonusPoints(entry, fantasyTeam, score);
      const captainPoints =
        entry.player.id === fantasyTeam.captainId ? score + bonusPoints : 0;

      return {
        ...entry,
        points: score,
        bonusPoints: bonusPoints,
        totalPoints: score + bonusPoints + captainPoints,
      };
    });

    return await Promise.all(playersWithPoints);
  }

  async function getPlayerEventsFromLocalStorage(): Promise<PlayerPointsDTO[]> {
    const cachedPlayersData = localStorage.getItem("player_events");
    let cachedPlayerEvents: PlayerPointsDTO[] = [];
    try {
      cachedPlayerEvents = JSON.parse(cachedPlayersData || "[]");
    } catch (e) {
      cachedPlayerEvents = [];
    }
    return cachedPlayerEvents;
  }

  async function getPlayerEventsFromBackend(
    seasonId: number,
    gameweek: number,
  ): Promise<PlayerPointsDTO[]> {
    return new PlayerEventsService().getPlayerEvents(seasonId, gameweek);
  }

  return {
    subscribe,
    setPlayerEvents: (players: PlayerPointsDTO[]) => set(players),
    getPlayerDetails,
    getGameweekPlayers,
    getPlayerEventsFromBackend,
  };
}

export const playerEventsStore = createPlayerEventsStore();
