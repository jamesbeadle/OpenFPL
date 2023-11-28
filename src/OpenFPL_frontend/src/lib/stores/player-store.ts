import { writable } from 'svelte/store';
import { idlFactory } from "../../../../declarations/player_canister";
import { ActorFactory } from "../../utils/ActorFactory";
import { replacer } from "../utils/Helpers";
import { systemStore } from '$lib/stores/system-store';
import { fixtureStore } from '$lib/stores/fixture-store';
import type { DataCache, FantasyTeam, Fixture, SystemState } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import type { PlayerDetailDTO, PlayerDTO, PlayerPointsDTO } from "../../../../declarations/player_canister/player_canister.did";
import type { GameweekData } from '$lib/interfaces/GameweekData';

function createPlayerStore() {
  const { subscribe, set } = writable<PlayerDTO[]>([]);
  
  let systemState: SystemState;
  systemStore.subscribe(value => { systemState = value as SystemState });

  let allFixtures: Fixture[];
  fixtureStore.subscribe(value => allFixtures = value);

  let actor: any = ActorFactory.createActor(
    idlFactory,
    process.env.PLAYER_CANISTER_CANISTER_ID
  );

  async function sync() {
    let category = "players";
    const newHashValues: DataCache[] = await actor.getDataHashes();
    let livePlayersHash = newHashValues.find(x => x.category === category) ?? null;
    const localHash = localStorage.getItem(category);

    if (livePlayersHash?.hash != localHash) {
      let updatedPlayersData = await actor.getAllPlayers();
      localStorage.setItem("players_data", JSON.stringify(updatedPlayersData, replacer));
      localStorage.setItem(category, livePlayersHash?.hash ?? "");
      set(updatedPlayersData);
    } else {
      const cachedPlayersData = localStorage.getItem("players_data");
      let cachedPlayers: PlayerDTO[] = [];
      try {
        cachedPlayers = JSON.parse(cachedPlayersData || "[]");
      } catch (e) {
        cachedPlayers = [];
      }
      set(cachedPlayers);
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

  async function getPlayerDetails(playerId: number, seasonId: number): Promise<PlayerDetailDTO> {
    try {
      const playerDetailData = await actor.getPlayerDetails(playerId, seasonId);
      return playerDetailData;
    } catch (error) {
      console.error("Error fetching player data:", error);
      throw error;
    }
  }

  async function getGameweekPlayers(fantasyTeam: FantasyTeam, gameweek: number) : Promise<GameweekData[]>{
    let allPlayerEvents: PlayerPointsDTO[] = [];
    if(systemState?.focusGameweek === gameweek){
      allPlayerEvents = await getPlayerEvents();
    }
    else{
      allPlayerEvents = await actor.getPlayersDetailsForGameweek(fantasyTeam.playerIds, systemState?.activeSeason.id, gameweek);    
    }
    
    let gameweekData: GameweekData[] = await Promise.all(allPlayerEvents.map(async player => await extractPlayerData(player)));
    
    const playersWithPoints = gameweekData.map(entry => {
      const score = calculatePlayerScore(entry, allFixtures);
      const bonusPoints = calculateBonusPoints(entry, fantasyTeam, score);
      const captainPoints = entry.player.id === fantasyTeam.captainId ? (score + bonusPoints) : 0;
      
      return {
          ...entry,
          points: score,
          bonusPoints: bonusPoints,
          totalPoints: score + bonusPoints + captainPoints
      };
    });


    return await Promise.all(playersWithPoints);
  }
  
  async function extractPlayerData(playerPointsDTO: PlayerPointsDTO) : Promise<GameweekData> {
    let goals = 0, assists = 0, redCards = 0, yellowCards = 0, missedPenalties = 0, ownGoals = 0, 
      saves = 0, cleanSheets = 0, penaltySaves = 0, goalsConceded = 0, appearance = 0, highestScoringPlayerId = 0;
    let goalPoints = 0, assistPoints = 0, goalsConcededPoints = 0, cleanSheetPoints = 0;

    playerPointsDTO.events.forEach(event => {
      switch(event.eventType) {
          case 0:
              appearance += 1;
              break;
          case 1:
              goals += 1;
              switch(playerPointsDTO.position){
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
              switch(playerPointsDTO.position){
                  case 0:
                  case 1:
                      assistPoints += 15;
                      break;
                  case 2:
                      case 3:
                      assistPoints += 10;
                      break;
              };
              break;
          case 3:
              goalsConceded += 1;
              if(playerPointsDTO.position < 2 && goalsConceded % 2 === 0){
                  goalsConcededPoints += -15;
              };
              break;
          case 4:
              saves += 1;
              break;
          case 5:
              cleanSheets += 1;
              if(playerPointsDTO.position < 2 && goalsConceded === 0){
                  cleanSheetPoints += 10;
              };
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

    let allPlayers: PlayerDTO[] = [];
    subscribe(players => allPlayers = players);

    let playerGameweekDetails: GameweekData = {
      player: allPlayers.find(x => x.id === playerPointsDTO.id)!,
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
      totalPoints: 0
    };

    return playerGameweekDetails;
  }

  function calculatePlayerScore (gameweekData: GameweekData, fixtures: Fixture[]) : number {
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

    if(gameweekData.appearance > 0){
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

    switch(gameweekData.player.position){
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
                score += Math.floor(gameweekData.goalsConceded / 2) * pointsForEach2Conceded;
            }

            break;
        case 1:
            pointsForGoal = 20;
            pointsForAssist = 15; 

            if (gameweekData.cleanSheets > 0) {
                score += pointsForCleanSheet;
            }
            if (gameweekData.goalsConceded >= 2) {
                score += Math.floor(gameweekData.goalsConceded / 2) * pointsForEach2Conceded;
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
    };

    const gameweekFixtures = fixtures ? fixtures.filter(fixture => fixture.gameweek === gameweekData.gameweek) : [];
    const playerFixture = gameweekFixtures.find(fixture => 
        (fixture.homeTeamId === gameweekData.player.teamId || fixture.awayTeamId === gameweekData.player.teamId) && 
        fixture.highestScoringPlayerId === gameweekData.player.id
    );
    if (playerFixture) {
        score += pointsForHighestScore;
    }

    
    score += gameweekData.goals * pointsForGoal;

    score += gameweekData.assists * pointsForAssist;

    return score;
  }

  function calculateBonusPoints (gameweekData: GameweekData, fantasyTeam: FantasyTeam, points: number) : number {
    if (!gameweekData) {
      console.error("No gameweek data found:", gameweekData);
      return 0;
  }
  
  let bonusPoints = 0; 
  var pointsForGoal = 0;
  var pointsForAssist = 0;
  switch(gameweekData.player.position){
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
  };

  if(fantasyTeam.goalGetterGameweek === gameweekData.gameweek && fantasyTeam.goalGetterPlayerId === gameweekData.player.id){
      bonusPoints = gameweekData.goals * pointsForGoal * 2;
  }

  if(fantasyTeam.passMasterGameweek === gameweekData.gameweek && fantasyTeam.passMasterPlayerId === gameweekData.player.id){
      bonusPoints = gameweekData.assists * pointsForAssist * 2;
  }
  
  if (fantasyTeam.noEntryGameweek === gameweekData.gameweek && fantasyTeam.noEntryPlayerId === gameweekData.player.id && 
      (gameweekData.player.position === 0 || gameweekData.player.position === 1) && gameweekData.cleanSheets) {
      bonusPoints = points * 2; 
  }

  if (fantasyTeam.safeHandsGameweek === gameweekData.gameweek && gameweekData.player.position === 0 && gameweekData.saves >= 5) {
      bonusPoints = points * 2; 
  }

  if (fantasyTeam.captainFantasticGameweek === gameweekData.gameweek && fantasyTeam.captainId === gameweekData.player.id && gameweekData.goals > 0) {
      bonusPoints = points; 
  }

  if (fantasyTeam.braceBonusGameweek === gameweekData.gameweek && gameweekData.goals >= 2) {
      bonusPoints = points; 
  }

  if (fantasyTeam.hatTrickHeroGameweek === gameweekData.gameweek && gameweekData.goals >= 3) {
      bonusPoints = points * 2; 
  }

  if (fantasyTeam.teamBoostGameweek === gameweekData.gameweek && gameweekData.player.teamId === fantasyTeam.teamBoostTeamId) {
      bonusPoints = points;
  }

  return bonusPoints;
  }
  

  return {
    subscribe,
    sync,
    getPlayerDetails,
    getGameweekPlayers
  };
}

export const playerStore = createPlayerStore();
