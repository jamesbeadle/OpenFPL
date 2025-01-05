import { writable } from "svelte/store";
import type {
  FantasyTeamSnapshot,
  PlayerPointsDTO,
  AppStatusDTO,
  FixtureDTO,
  PlayerDetailDTO,
  PlayerDTO,
  LeagueStatus,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { PlayerEventsService } from "$lib/services/player-events-service";
import type { GameweekData } from "$lib/interfaces/GameweekData";
import { playerStore } from "./player-store";
import { calculatePlayerScore, extractPlayerData } from "$lib/utils/helpers";
import { fixtureStore } from "./fixture-store";
import { getTotalBonusPoints } from "$lib/utils/pick-team.helpers";
import { appStore } from "./app-store";
import { leagueStore } from "./league-store";

function createPlayerEventsStore() {
  const { subscribe, set } = writable<PlayerPointsDTO[]>([]);

  async function getPlayerDetails(
    playerId: number,
    seasonId: number,
  ): Promise<PlayerDetailDTO | undefined> {
    return new PlayerEventsService().getPlayerDetails(playerId, seasonId);
  }

  async function getGameweekPlayers(
    fantasyTeam: FantasyTeamSnapshot,
    seasonId: number,
    gameweek: number,
  ): Promise<GameweekData[]> {
    let allPlayerEvents: PlayerPointsDTO[] = [];
    let appStatus: AppStatusDTO | null = null;
    appStore.subscribe((result) => {
      if (result == null) {
        throw new Error("Failed to subscribe to application store");
      }
      appStatus = {
        version: result.version,
        onHold: result.onHold,
      };
    });

    let leagueStatus: LeagueStatus | null = null;
    leagueStore.subscribe((result) => {
      if (result == null) {
        throw new Error("Failed to subscribe to league store");
      }
      leagueStatus = result;
    });

    let activeOrUnplayedGameweek =
      await leagueStore.getActiveOrUnplayedGameweek();

    if (
      leagueStatus!.activeSeasonId === seasonId &&
      activeOrUnplayedGameweek === gameweek
    ) {
      allPlayerEvents = await getPlayerEventsFromLocalStorage();
    } else {
      let allPlayerEventsResult = await getPlayerEventsFromBackend(
        seasonId,
        gameweek,
      );
      allPlayerEvents = allPlayerEventsResult ? allPlayerEventsResult : [];
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
      const bonusPoints = getTotalBonusPoints(entry, fantasyTeam, score);
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
  ): Promise<PlayerPointsDTO[] | undefined> {
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
