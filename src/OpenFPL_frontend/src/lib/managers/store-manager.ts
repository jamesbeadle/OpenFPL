import { countryStore } from "$lib/stores/country-store";
import { systemStore } from "$lib/stores/system-store";
import { seasonStore } from "$lib/stores/season-store";
import { clubStore } from "$lib/stores/club-store";
import { playerStore } from "$lib/stores/player-store";
import { playerEventsStore } from "$lib/stores/player-events-store";
import { fixtureStore } from "$lib/stores/fixture-store";
import { weeklyLeaderboardStore } from "$lib/stores/weekly-leaderboard-store";

import { DataHashService } from "$lib/services/data-hash-service";
import { CountryService } from "$lib/services/country-service";
import { SystemService } from "$lib/services/system-service";
import { SeasonService } from "$lib/services/season-service";
import { ClubService } from "$lib/services/club-service";
import { PlayerService } from "$lib/services/player-service";
import { PlayerEventsService } from "$lib/services/player-events-service";
import { FixtureService } from "$lib/services/fixture-service";
import { WeeklyLeaderboardService } from "$lib/services/weekly-leaderboard-service";

import { isError, replacer } from "$lib/utils/helpers";

class StoreManager {
  private dataHashService: DataHashService;
  private countryService: CountryService;
  private systemService: SystemService;
  private seasonService: SeasonService;
  private clubService: ClubService;
  private playerService: PlayerService;
  private playerEventsService: PlayerEventsService;
  private fixtureService: FixtureService;
  private weeklyLeaderboardService: WeeklyLeaderboardService;

  private categories: string[] = [
    "countries",
    "system_state",
    "seasons",
    "clubs",
    "players",
    "player_events",
    "fixtures",
  ];

  constructor() {
    this.dataHashService = new DataHashService();
    this.countryService = new CountryService();
    this.systemService = new SystemService();
    this.seasonService = new SeasonService();
    this.clubService = new ClubService();
    this.playerService = new PlayerService();
    this.playerEventsService = new PlayerEventsService();
    this.fixtureService = new FixtureService();
    this.weeklyLeaderboardService = new WeeklyLeaderboardService();
  }

  async syncStores(): Promise<void> {
    const newHashes = await this.dataHashService.getDataHashes();

    let error = isError(newHashes);
    if (error) {
      console.error("Error fetching data hashes.");
      return;
    }

    for (const category of this.categories) {
      const categoryHash = newHashes.find((hash) => hash.category === category);

      if (categoryHash?.hash !== localStorage.getItem(`${category}_hash`)) {
        await this.syncCategory(category);
        localStorage.setItem(`${category}_hash`, categoryHash?.hash || "");
      } else {
        this.loadFromCache(category);
      }
    }
  }

  private async syncCategory(category: string): Promise<void> {
    switch (category) {
      case "countries":
        const updatedCountries = await this.countryService.getCountries();
        countryStore.setCountries(updatedCountries);
        localStorage.setItem(
          "countries",
          JSON.stringify(updatedCountries, replacer),
        );
        break;
      case "system_state":
        const updatedSystemState = await this.systemService.getSystemState();
        systemStore.setSystemState(updatedSystemState);
        localStorage.setItem(
          "system_state",
          JSON.stringify(updatedSystemState, replacer),
        );
        break;
      case "seasons":
        const updatedSeasons = await this.seasonService.getSeasons();
        seasonStore.setSeasons(updatedSeasons);
        localStorage.setItem(
          "seasons",
          JSON.stringify(updatedSeasons, replacer),
        );
        break;
      case "clubs":
        const updatedClubs = await this.clubService.getClubs();
        clubStore.setClubs(updatedClubs);
        localStorage.setItem("clubs", JSON.stringify(updatedClubs, replacer));
        break;
      case "players":
        const updatedPlayers = await this.playerService.getPlayers();
        playerStore.setPlayers(updatedPlayers);
        localStorage.setItem(
          "players",
          JSON.stringify(updatedPlayers, replacer),
        );
        break;
      case "player_events":
        const updatedPlayerEvents =
          await this.playerEventsService.getPlayerDetailsForGameweek();
        playerEventsStore.setPlayerEvents(updatedPlayerEvents);
        localStorage.setItem(
          "player_events",
          JSON.stringify(updatedPlayerEvents, replacer),
        );
        break;
      case "fixtures":
        systemStore.subscribe(async (systemState) => {
          const updatedFixtures = await this.fixtureService.getFixtures(
            systemState?.calculationSeasonId ?? 0,
          );
          fixtureStore.setFixtures(updatedFixtures);
          localStorage.setItem(
            "fixtures",
            JSON.stringify(updatedFixtures, replacer),
          );
        });
        break;
      case "weekly_leaderboard":
        systemStore.subscribe(async (systemState) => {
          const updatedWeeklyLeaderboard =
            await this.weeklyLeaderboardService.getWeeklyLeaderboard(
              0,
              systemState?.calculationSeasonId ?? 0,
              0,
              systemState?.calculationGameweek ?? 0,
            );
          weeklyLeaderboardStore.setWeeklyLeaderboard(updatedWeeklyLeaderboard);
          localStorage.setItem(
            "weekly_leaderboard",
            JSON.stringify(updatedWeeklyLeaderboard, replacer),
          );
        });
        break;
    }
  }

  private loadFromCache(category: string): void {
    const cachedData = localStorage.getItem(category);

    switch (category) {
      case "countries":
        const cachedCountries = JSON.parse(cachedData || "[]");
        countryStore.setCountries(cachedCountries);
        break;
      case "system_state":
        const cachedSystemState = JSON.parse(cachedData || "null");
        systemStore.setSystemState(cachedSystemState);
        break;
      case "seasons":
        const cachedSeasons = JSON.parse(cachedData || "");
        seasonStore.setSeasons(cachedSeasons);
        break;
      case "clubs":
        const cachedClubs = JSON.parse(cachedData || "[]");
        clubStore.setClubs(cachedClubs);
        break;
      case "players":
        const cachedPlayers = JSON.parse(cachedData || "[]");
        playerStore.setPlayers(cachedPlayers);
        break;
      case "fixtures":
        const cachedFixtures = JSON.parse(cachedData || "[]");
        fixtureStore.setFixtures(cachedFixtures);
        break;
      case "weekly_leaderboard":
        const cachedWeeklyLeaderboard = JSON.parse(cachedData || "null");
        weeklyLeaderboardStore.setWeeklyLeaderboard(cachedWeeklyLeaderboard);
        break;
    }
  }
}

export const storeManager = new StoreManager();
