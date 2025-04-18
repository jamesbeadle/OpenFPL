import { writable } from "svelte/store";
import { PlayerEventsService } from "$lib/services/player-events-service";
import type { GameweekData } from "$lib/interfaces/GameweekData";
import { playerStore } from "./player-store";
import { calculatePlayerScore, extractPlayerData } from "$lib/utils/helpers";
import { fixtureStore } from "./fixture-store";
import { getTotalBonusPoints } from "$lib/utils/pick-team.helpers";
import { appStore } from "./app-store";
import { leagueStore } from "./league-store";
import type {
  Fixture,
  LeagueStatus,
  Player__1,
  PlayerDetailsForGameweek,
  PlayerPoints,
  PlayerScore,
  PlayersMap,
  AppStatus,
  FantasyTeamSnapshot,
  PlayerDetails,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

function createPlayerEventsStore() {
  const { subscribe, set } = writable<PlayerDetailsForGameweek | null>(null);

  async function getPlayerDetails(
    playerId: number,
    seasonId: number,
  ): Promise<PlayerDetails | undefined> {
    return new PlayerEventsService().getPlayerDetails(playerId, seasonId);
  }

  async function getGameweekPlayers(
    fantasyTeam: FantasyTeamSnapshot,
    seasonId: number,
    gameweek: number,
  ): Promise<GameweekData[]> {
    let allPlayerEvents: PlayerPoints[] = [];
    let appStatus: AppStatus | null = null;
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
      allPlayerEvents = allPlayerEventsResult?.playerPoints
        ? allPlayerEventsResult.playerPoints
        : [];
    }

    let allPlayers: Player__1[] = [];
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

    let allFixtures: Fixture[] = [];

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

  async function getPlayerEventsFromLocalStorage(): Promise<PlayerPoints[]> {
    const cachedPlayersData = localStorage.getItem("player_events");
    let cachedPlayerEvents: PlayerPoints[] = [];
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
  ): Promise<PlayerDetailsForGameweek | undefined> {
    return new PlayerEventsService().getPlayerEvents(seasonId, gameweek);
  }

  return {
    subscribe,
    setPlayerEvents: (players: PlayerDetailsForGameweek) => set(players),
    getGameweekPlayers,
    getPlayerEventsFromBackend,
    getPlayerDetails,
  };
}

export const playerEventsStore = createPlayerEventsStore();
