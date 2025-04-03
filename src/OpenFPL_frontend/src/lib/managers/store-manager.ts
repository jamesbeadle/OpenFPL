import { countryStore } from "$lib/stores/country-store";
import { seasonStore } from "$lib/stores/season-store";
import { clubStore } from "$lib/stores/club-store";
import { playerStore } from "$lib/stores/player-store";
import { playerEventsStore } from "$lib/stores/player-events-store";
import { fixtureStore } from "$lib/stores/fixture-store";
import { weeklyLeaderboardStore } from "$lib/stores/weekly-leaderboard-store";
import { leagueStore } from "$lib/stores/league-store";
import { appStore } from "$lib/stores/app-store";
import { RewardRatesService } from "$lib/services/reward-rates-service";
import { rewardRatesStore } from "$lib/stores/reward-pool-store";

import { DataHashService } from "$lib/services/data-hash-service";
import { AppService } from "$lib/services/app-service";
import { LeagueService } from "$lib/services/league-service";
import { CountryService } from "$lib/services/country-service";
import { SeasonService } from "$lib/services/season-service";
import { ClubService } from "$lib/services/club-service";
import { PlayerService } from "$lib/services/player-service";
import { PlayerEventsService } from "$lib/services/player-events-service";
import { FixtureService } from "$lib/services/fixture-service";
import { WeeklyLeaderboardService } from "$lib/services/weekly-leaderboard-service";

import { replacer } from "$lib/utils/helpers";
import { writable } from "svelte/store";

export const globalDataLoaded = writable(false);

class StoreManager {
  private dataHashService: DataHashService;
  private countryService: CountryService;
  private appService: AppService;
  private leagueService: LeagueService;
  private seasonService: SeasonService;
  private clubService: ClubService;
  private playerService: PlayerService;
  private playerEventsService: PlayerEventsService;
  private fixtureService: FixtureService;
  private weeklyLeaderboardService: WeeklyLeaderboardService;
  private rewardRatesService: RewardRatesService;

  private backendCategories: string[] = [
    "app_status",
    "reward_rates",
    "weekly_leaderboard",
    "countries",
    "league_status",
    "seasons",
    "clubs",
    "players",
    "player_events",
    "fixtures",
  ];

  private isSyncing = false;

  constructor() {
    this.dataHashService = new DataHashService();
    this.countryService = new CountryService();
    this.appService = new AppService();
    this.leagueService = new LeagueService();
    this.seasonService = new SeasonService();
    this.clubService = new ClubService();
    this.playerService = new PlayerService();
    this.playerEventsService = new PlayerEventsService();
    this.fixtureService = new FixtureService();
    this.weeklyLeaderboardService = new WeeklyLeaderboardService();
    this.rewardRatesService = new RewardRatesService();
  }

  async syncStores(): Promise<void> {
    if (this.isSyncing) {
      return;
    }
    this.isSyncing = true;
    globalDataLoaded.set(false);
    try {
      await this.syncAppDataHashes();
      globalDataLoaded.set(true);
    } catch (error) {
      console.error("Error syncing stores:", error);
      globalDataLoaded.set(false);
      throw error;
    } finally {
      this.isSyncing = false;
    }
  }

  private async syncAppDataHashes(): Promise<void> {
    const appDataHashes = await this.dataHashService.getAppDataHashes();
    if (appDataHashes == undefined) {
      return;
    }
    for (const category of this.backendCategories) {
      const categoryHash = appDataHashes.find(
        (hash) => hash.category === category,
      );
      if (categoryHash?.hash !== localStorage.getItem(`${category}_hash`)) {
        await this.syncCategory(category);
        localStorage.setItem(`${category}_hash`, categoryHash?.hash || "");
      } else {
        await this.loadFromCache(category);
      }
    }
  }

  private async syncCategory(category: string): Promise<void> {
    switch (category) {
      case "countries":
        const updatedCountries = await this.countryService.getCountries();
        if (!updatedCountries) {
          return;
        }
        countryStore.setCountries(updatedCountries);
        localStorage.setItem(
          "countries",
          JSON.stringify(updatedCountries, replacer),
        );
        break;
      case "league_status":
        const updatedLeagueStatus = await this.leagueService.getLeagueStatus();
        if (!updatedLeagueStatus) {
          return;
        }
        leagueStore.setLeagueStatus(updatedLeagueStatus);
        localStorage.setItem(
          "league_status",
          JSON.stringify(updatedLeagueStatus, replacer),
        );
        break;
      case "app_status":
        const updatedAppStatus = await this.appService.getAppStatus();
        if (!updatedAppStatus) {
          return;
        }
        appStore.setAppStatus(updatedAppStatus);
        localStorage.setItem(
          "app_status",
          JSON.stringify(updatedAppStatus, replacer),
        );
        break;
      case "seasons":
        const updatedSeasons = await this.seasonService.getSeasons();
        if (!updatedSeasons) {
          return;
        }
        seasonStore.setSeasons(updatedSeasons);
        localStorage.setItem(
          "seasons",
          JSON.stringify(updatedSeasons, replacer),
        );
        break;
      case "clubs":
        const updatedClubs = await this.clubService.getClubs();
        if (!updatedClubs) {
          return;
        }
        clubStore.setClubs(updatedClubs);
        localStorage.setItem("clubs", JSON.stringify(updatedClubs, replacer));
        break;
      case "players":
        const updatedPlayers = await this.playerService.getPlayers();
        if (!updatedPlayers) {
          return;
        }
        playerStore.setPlayers(updatedPlayers);
        localStorage.setItem(
          "players",
          JSON.stringify(updatedPlayers, replacer),
        );
        break;
      case "player_events":
        const leagueStatus = await this.leagueService.getLeagueStatus();
        if (!leagueStatus) {
          return;
        }
        const updatedPlayerEvents =
          await this.playerEventsService.getPlayerEvents(
            leagueStatus.activeSeasonId,
            leagueStatus.activeGameweek == 0
              ? leagueStatus.unplayedGameweek
              : leagueStatus.activeGameweek,
          );
        if (!updatedPlayerEvents) {
          return;
        }
        playerEventsStore.setPlayerEvents(updatedPlayerEvents);
        localStorage.setItem(
          "player_events",
          JSON.stringify(updatedPlayerEvents, replacer),
        );
        break;
      case "fixtures":
        const updatedFixtures = await this.fixtureService.getFixtures();
        if (!updatedFixtures) {
          return;
        }
        fixtureStore.setFixtures(updatedFixtures);
        localStorage.setItem(
          "fixtures",
          JSON.stringify(updatedFixtures, replacer),
        );
        break;
      case "weekly_leaderboard":
        leagueStore.subscribe(async (leagueStatus) => {
          if (!leagueStatus) {
            return;
          }
          const updatedWeeklyLeaderboard =
            await this.weeklyLeaderboardService.getWeeklyLeaderboard(
              0,
              leagueStatus.activeSeasonId,
              leagueStatus.activeGameweek == 0
                ? leagueStatus.completedGameweek
                : leagueStatus.activeGameweek,
              "",
            );
          if (!updatedWeeklyLeaderboard) {
            return;
          }
          weeklyLeaderboardStore.setWeeklyLeaderboard(updatedWeeklyLeaderboard);
          localStorage.setItem(
            "weekly_leaderboard",
            JSON.stringify(updatedWeeklyLeaderboard, replacer),
          );
        });
        break;
      case "reward_rates":
        leagueStore.subscribe(async (leagueStatus) => {
          if (!leagueStatus) {
            return;
          }
          const updatedRewardRates =
            await this.rewardRatesService.getRewardRates();
          if (!updatedRewardRates) {
            return;
          }
          rewardRatesStore.setRewardRates(updatedRewardRates);
          localStorage.setItem(
            "reward_rates",
            JSON.stringify(updatedRewardRates, replacer),
          );
        });
        break;
    }
  }

  private async loadFromCache(category: string): Promise<void> {
    const cachedData = localStorage.getItem(category);

    switch (category) {
      case "countries":
        const cachedCountries = JSON.parse(cachedData || "[]");
        countryStore.setCountries(cachedCountries);
        break;
      case "app_status":
        const cachedAppStatus = JSON.parse(cachedData || "null");
        appStore.setAppStatus(cachedAppStatus);
        break;
      case "league_status":
        const cachedLeagueStatus = JSON.parse(cachedData || "null");
        leagueStore.setLeagueStatus(cachedLeagueStatus);
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
      case "reward_rates":
        const cachedRewardRates = JSON.parse(cachedData || "null");
        rewardRatesStore.setRewardRates(cachedRewardRates);
        break;
    }
  }
}

export const storeManager = new StoreManager();
