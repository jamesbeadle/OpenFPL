import type { GameweekData } from "$lib/interfaces/GameweekData";
import { fixtureStore } from "$lib/stores/fixture-store";
import { playerStore } from "$lib/stores/player-store";
import { systemStore } from "$lib/stores/system-store";
import { writable } from "svelte/store";
import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import type {
  DataCacheDTO,
  FantasyTeamSnapshot,
  FixtureDTO,
  PlayerDTO,
  PlayerDetailDTO,
  PlayerPointsDTO,
  SystemStateDTO,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { ActorFactory } from "../../utils/ActorFactory";
import {
  calculateAgeFromNanoseconds,
  convertEvent,
  convertPlayerPosition,
  isError,
  replacer,
} from "../utils/Helpers";

function createPlayerEventsStore() {
  const { subscribe, set } = writable<PlayerPointsDTO[]>([]);

  let systemState: SystemStateDTO;
  systemStore.subscribe((value) => {
    systemState = value as SystemStateDTO;
  });

  let allFixtures: FixtureDTO[];
  fixtureStore.subscribe((value) => (allFixtures = value));

  let actor: any = ActorFactory.createActor(
    idlFactory,
    process.env.OPENFPL_BACKEND_CANISTER_ID
  );

  async function sync() {
    let category = "player_events";
    const newHashValues = await actor.getDataHashes();

    let error = isError(newHashValues);
    if (error) {
      console.error("Error syncing player events store");
      return;
    }

    let dataCacheValues: DataCacheDTO[] = newHashValues.ok;

    let categoryHash =
      dataCacheValues.find((x: DataCacheDTO) => x.category === category) ??
      null;
    
    const localHash = localStorage.getItem(`${category}_hash`);

    if (categoryHash?.hash != localHash) {
      let result = await actor.getPlayerDetailsForGameweek(
        systemState.calculationSeasonId,
        systemState.calculationGameweek
      );

      if(isError(result)){
        console.error("Error fetching player details for gameweek");
        return;
      }

      let updatedPlayerEventsData = result.ok;

      localStorage.setItem(
        category,
        JSON.stringify(updatedPlayerEventsData, replacer)
      );
      localStorage.setItem(`${category}_hash`, categoryHash?.hash ?? "");
      set(updatedPlayerEventsData);
    } else {
      const cachedPlayersData = localStorage.getItem(category);
      let cachedPlayerEvents: PlayerPointsDTO[] = [];
      try {
        cachedPlayerEvents = JSON.parse(cachedPlayersData || "[]");
      } catch (e) {
        cachedPlayerEvents = [];
      }
      set(cachedPlayerEvents);
    }
  }

  async function getPlayerEvents(): Promise<PlayerPointsDTO[]> {
    const cachedPlayerEventsData = localStorage.getItem("player_events_data");

    let cachedPlayerEvents: PlayerPointsDTO[];
    try {
      cachedPlayerEvents = JSON.parse(cachedPlayerEventsData || "[]");
    } catch (e) {
      cachedPlayerEvents = [];
    }

    return cachedPlayerEvents;
  }

  async function getPlayerDetails(
    playerId: number,
    seasonId: number
  ): Promise<PlayerDetailDTO> {
    try {
      let result = await actor.getPlayerDetails(playerId, seasonId);

      if(isError(result)){
        console.error("Error fetching player details")
      }

      return result.ok;
    } catch (error) {
      console.error("Error fetching player data:", error);
      throw error;
    }
  }

  async function getGameweekPlayers(
    fantasyTeam: FantasyTeamSnapshot,
    gameweek: number
  ): Promise<GameweekData[]> {
    await sync();

    let allPlayerEvents: PlayerPointsDTO[] = [];

    if (systemState?.calculationGameweek === gameweek) {
      allPlayerEvents = await getPlayerEvents();
    } else {
      allPlayerEvents = await actor.getPlayersDetailsForGameweek(
        fantasyTeam.playerIds,
        systemState?.calculationSeasonId,
        gameweek
      );
    }

    let allPlayers: PlayerDTO[] = [];
    const unsubscribe = playerStore.subscribe((players) => {
      allPlayers = players.filter((player) =>
        fantasyTeam.playerIds.includes(player.id)
      );
    });
    unsubscribe();

    let gameweekData: GameweekData[] = await Promise.all(
      allPlayers.map(
        async (player) =>
          await extractPlayerData(
            allPlayerEvents.find((x) => x.id == player.id)!,
            player
          )
      )
    );

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

  async function extractPlayerData(
    playerPointsDTO: PlayerPointsDTO,
    player: PlayerDTO
  ): Promise<GameweekData> {
    let goals = 0,
      assists = 0,
      redCards = 0,
      yellowCards = 0,
      missedPenalties = 0,
      ownGoals = 0,
      saves = 0,
      cleanSheets = 0,
      penaltySaves = 0,
      goalsConceded = 0,
      appearance = 0,
      highestScoringPlayerId = 0;

    let goalPoints = 0,
      assistPoints = 0,
      goalsConcededPoints = 0,
      cleanSheetPoints = 0;

    playerPointsDTO.events.forEach((event) => {
      switch (convertEvent(event.eventType)) {
        case 0:
          appearance += 1;
          break;
        case 1:
          goals += 1;
          switch (convertPlayerPosition(playerPointsDTO.position)) {
            case 0:
            case 1:
              goalPoints += 20;
              break;
            case 2:
              goalPoints += 15;
              break;
            case 3:
              goalPoints += 10;
              break;
          }
          break;
        case 2:
          assists += 1;
          switch (convertPlayerPosition(playerPointsDTO.position)) {
            case 0:
            case 1:
              assistPoints += 15;
              break;
            case 2:
            case 3:
              assistPoints += 10;
              break;
          }
          break;
        case 3:
          goalsConceded += 1;
          if (
            convertPlayerPosition(playerPointsDTO.position) < 2 &&
            goalsConceded % 2 === 0
          ) {
            goalsConcededPoints += -15;
          }
          break;
        case 4:
          saves += 1;
          break;
        case 5:
          cleanSheets += 1;
          if (
            convertPlayerPosition(playerPointsDTO.position) < 2 &&
            goalsConceded === 0
          ) {
            cleanSheetPoints += 10;
          }
          break;
        case 6:
          penaltySaves += 1;
          break;
        case 7:
          missedPenalties += 1;
          break;
        case 8:
          yellowCards += 1;
          break;
        case 9:
          redCards += 1;
          break;
        case 10:
          ownGoals += 1;
          break;
        case 11:
          highestScoringPlayerId += 1;
          break;
      }
    });

    let playerGameweekDetails: GameweekData = {
      player: player,
      points: playerPointsDTO.points,
      appearance: appearance,
      goals: goals,
      assists: assists,
      goalsConceded: goalsConceded,
      saves: saves,
      cleanSheets: cleanSheets,
      penaltySaves: penaltySaves,
      missedPenalties: missedPenalties,
      yellowCards: yellowCards,
      redCards: redCards,
      ownGoals: ownGoals,
      highestScoringPlayerId: highestScoringPlayerId,
      goalPoints: goalPoints,
      assistPoints: assistPoints,
      goalsConcededPoints: goalsConcededPoints,
      cleanSheetPoints: cleanSheetPoints,
      gameweek: playerPointsDTO.gameweek,
      bonusPoints: 0,
      totalPoints: 0,
      isCaptain: false,
      nationality: "",
    };

    return playerGameweekDetails;
  }

  function calculatePlayerScore(
    gameweekData: GameweekData,
    fixtures: FixtureDTO[]
  ): number {
    if (!gameweekData) {
      console.error("No gameweek data found:", gameweekData);
      return 0;
    }

    let score = 0;
    let pointsForAppearance = 5;
    let pointsFor3Saves = 5;
    let pointsForPenaltySave = 20;
    let pointsForHighestScore = 25;
    let pointsForRedCard = -20;
    let pointsForPenaltyMiss = -10;
    let pointsForEach2Conceded = -15;
    let pointsForOwnGoal = -10;
    let pointsForYellowCard = -5;
    let pointsForCleanSheet = 10;

    var pointsForGoal = 0;
    var pointsForAssist = 0;

    if (gameweekData.appearance > 0) {
      score += pointsForAppearance * gameweekData.appearance;
    }

    if (gameweekData.redCards > 0) {
      score += pointsForRedCard;
    }

    if (gameweekData.missedPenalties > 0) {
      score += pointsForPenaltyMiss * gameweekData.missedPenalties;
    }

    if (gameweekData.ownGoals > 0) {
      score += pointsForOwnGoal * gameweekData.ownGoals;
    }

    if (gameweekData.yellowCards > 0) {
      score += pointsForYellowCard * gameweekData.yellowCards;
    }

    switch (convertPlayerPosition(gameweekData.player.position)) {
      case 0:
        pointsForGoal = 20;
        pointsForAssist = 15;

        if (gameweekData.saves >= 3) {
          score += Math.floor(gameweekData.saves / 3) * pointsFor3Saves;
        }
        if (gameweekData.penaltySaves) {
          score += pointsForPenaltySave * gameweekData.penaltySaves;
        }

        if (gameweekData.cleanSheets > 0) {
          score += pointsForCleanSheet;
        }
        if (gameweekData.goalsConceded >= 2) {
          score +=
            Math.floor(gameweekData.goalsConceded / 2) * pointsForEach2Conceded;
        }

        break;
      case 1:
        pointsForGoal = 20;
        pointsForAssist = 15;

        if (gameweekData.cleanSheets > 0) {
          score += pointsForCleanSheet;
        }
        if (gameweekData.goalsConceded >= 2) {
          score +=
            Math.floor(gameweekData.goalsConceded / 2) * pointsForEach2Conceded;
        }

        break;
      case 2:
        pointsForGoal = 15;
        pointsForAssist = 10;
        break;
      case 3:
        pointsForGoal = 10;
        pointsForAssist = 10;
        break;
    }

    const gameweekFixtures = fixtures
      ? fixtures.filter((fixture) => fixture.gameweek === gameweekData.gameweek)
      : [];
    const playerFixtures = gameweekFixtures.filter(
      (fixture) =>
        (fixture.homeClubId === gameweekData.player.clubId ||
          fixture.awayClubId === gameweekData.player.clubId) &&
        fixture.highestScoringPlayerId === gameweekData.player.id
    );

    if (playerFixtures && playerFixtures.length > 0) {
      score += pointsForHighestScore * playerFixtures.length;
    }

    score += gameweekData.goals * pointsForGoal;

    score += gameweekData.assists * pointsForAssist;
    return score;
  }

  function calculateBonusPoints(
    gameweekData: GameweekData,
    fantasyTeam: FantasyTeamSnapshot,
    points: number
  ): number {
    if (!gameweekData) {
      console.error("No gameweek data found:", gameweekData);
      return 0;
    }

    let bonusPoints = 0;
    var pointsForGoal = 0;
    var pointsForAssist = 0;
    switch (convertPlayerPosition(gameweekData.player.position)) {
      case 0:
        pointsForGoal = 20;
        pointsForAssist = 15;
        break;
      case 1:
        pointsForGoal = 20;
        pointsForAssist = 15;
        break;
      case 2:
        pointsForGoal = 15;
        pointsForAssist = 10;
        break;
      case 3:
        pointsForGoal = 10;
        pointsForAssist = 10;
        break;
    }

    if (
      fantasyTeam.goalGetterGameweek === gameweekData.gameweek &&
      fantasyTeam.goalGetterPlayerId === gameweekData.player.id
    ) {
      bonusPoints = gameweekData.goals * pointsForGoal * 2;
    }

    if (
      fantasyTeam.passMasterGameweek === gameweekData.gameweek &&
      fantasyTeam.passMasterPlayerId === gameweekData.player.id
    ) {
      bonusPoints = gameweekData.assists * pointsForAssist * 2;
    }

    if (
      fantasyTeam.noEntryGameweek === gameweekData.gameweek &&
      fantasyTeam.noEntryPlayerId === gameweekData.player.id &&
      (convertPlayerPosition(gameweekData.player.position) === 0 ||
        convertPlayerPosition(gameweekData.player.position) === 1) &&
      gameweekData.cleanSheets
    ) {
      bonusPoints = points * 2;
    }

    if (
      fantasyTeam.safeHandsGameweek === gameweekData.gameweek &&
      convertPlayerPosition(gameweekData.player.position) === 0 &&
      gameweekData.saves >= 5
    ) {
      bonusPoints = points * 2;
    }

    if (
      fantasyTeam.captainFantasticGameweek === gameweekData.gameweek &&
      fantasyTeam.captainId === gameweekData.player.id &&
      gameweekData.goals > 0
    ) {
      bonusPoints = points;
    }

    if (
      fantasyTeam.countrymenGameweek === gameweekData.gameweek &&
      fantasyTeam.countrymenCountryId === gameweekData.player.nationality
    ) {
      bonusPoints = points * 2;
    }

    if (
      fantasyTeam.prospectsGameweek === gameweekData.gameweek &&
      calculateAgeFromNanoseconds(Number(gameweekData.player.dateOfBirth)) < 21
    ) {
      bonusPoints = points * 2;
    }

    if (
      fantasyTeam.braceBonusGameweek === gameweekData.gameweek &&
      gameweekData.goals >= 2
    ) {
      bonusPoints = points;
    }

    if (
      fantasyTeam.hatTrickHeroGameweek === gameweekData.gameweek &&
      gameweekData.goals >= 3
    ) {
      bonusPoints = points * 2;
    }

    if (
      fantasyTeam.teamBoostGameweek === gameweekData.gameweek &&
      gameweekData.player.clubId === fantasyTeam.teamBoostClubId
    ) {
      bonusPoints = points;
    }

    return bonusPoints;
  }

  return {
    subscribe,
    sync,
    getPlayerDetails,
    getGameweekPlayers,
  };
}

export const playerEventsStore = createPlayerEventsStore();
