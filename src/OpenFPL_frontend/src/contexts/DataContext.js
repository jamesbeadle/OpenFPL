import React, { useState, useEffect } from 'react';
import { player_canister as player_canister } from '../../../declarations/player_canister';
import { OpenFPL_backend as open_fpl_backend } from '../../../declarations/OpenFPL_backend';

export const DataContext = React.createContext();

const CACHE_PAGE_LIMIT = 4;

export const DataProvider = ({ children }) => {
  const [players, setPlayers] = useState([]);
  const [teams, setTeams] = useState([]);
  const [seasons, setSeasons] = useState([]);
  const [fixtures, setFixtures] = useState([]);
  const [systemState, setSystemState] = useState(null);
  const [weeklyLeaderboard, setWeeklyLeaderboard] = useState({});
  const [monthlyLeaderboards, setMonthlyLeaderboards] = useState([]);
  const [seasonLeaderboard, setSeasonLeaderboard] = useState({});
  const [currentHashes, setCurrentHashes] = useState([]);
  const [loading, setLoading] = useState(true);
 
  useEffect(() => {
    const init = async () => {
        const currentHashArray = await open_fpl_backend.getCurrentHashes();
        setCurrentHashes(currentHashArray);
        const currentPlayerHash = await player_canister.getPlayersDataCache();
        await initPlayerData(currentPlayerHash);
        await initTeamsData(currentHashArray.find(item => item.category === 'teams'));
        await initSeasonsData(currentHashArray.find(item => item.category === 'seasons'));
        await initFixturesData(currentHashArray.find(item => item.category === 'fixtures'));
        await initSystemState(currentHashArray.find(item => item.category === 'system_state'));
    };    
    init();
  }, []);

  useEffect(() => {
    if(!systemState || Object.keys(systemState).length === 0){
        return null;
    }
    const initLeaderboards = async () => {
        
        for(let i = 1; i <= CACHE_PAGE_LIMIT; i++) {
            await initWeeklyLeaderboard(currentHashes.find(item => item.category === 'weekly_leaderboard'), i);
            await initMonthlyLeaderboards(currentHashes.find(item => item.category === 'monthly_leaderboards'), i);
            await initSeasonLeaderboard(currentHashes.find(item => item.category === 'season_leaderboard'), i);  
        };        
        
        setLoading(false);  
    };
    initLeaderboards();
  }, [systemState]);

  const initPlayerData = async (playerHash) => {
    const cachedHash = localStorage.getItem('players_hash');
    const cachedPlayersData = localStorage.getItem('players_data');
    const cachedPlayers = JSON.parse(cachedPlayersData || '[]');
        
    try {
        if (cachedPlayers.length === 0 || cachedHash !== playerHash.hash) {
          await fetchAllPlayers();
        } else {
          setPlayers(cachedPlayers);
        }
      } catch (error) {
          console.error("Error fetching player data cache:", error);
      }
  };

  const fetchAllPlayers = async (playersHash) => {
    try {
        const allPlayersData = await player_canister.getAllPlayers();
        setPlayers(allPlayersData);
        
        localStorage.setItem('players_hash', playersHash);
        localStorage.setItem('players_data', JSON.stringify(allPlayersData, replacer));

    } catch (error) {
        console.error("Error fetching all players:", error);
    }
  };

  const initTeamsData = async (teamsHash) => {
    const cachedHash = localStorage.getItem('teams_hash');
    const cachedTeamsData = localStorage.getItem('teams_data');
    const cachedTeams = JSON.parse(cachedTeamsData || '[]');
    
    try {
        
        if (!teamsHash) {
            console.error("No hash found for teams.");
            return;
        }

        if (cachedTeams.length === 0 || cachedHash !== teamsHash) {
            await fetchAllTeams();
        } else {
            setTeams(cachedTeams);
        }
    } catch (error) {
        console.error("Error fetching teams data cache:", error);
    }
    };

    const fetchAllTeams = async () => {
        try {
            const allTeamsData = await open_fpl_backend.getTeams();
            setTeams(allTeamsData);
            
            const currentHashArray = await open_fpl_backend.getCurrentHashes();
            const teamHashObject = currentHashArray.find(item => item.category === 'teams');
            
            if (teamHashObject) {
                localStorage.setItem('teams_hash', teamHashObject.hash);
                localStorage.setItem('teams_data', JSON.stringify(allTeamsData, replacer));
            } else {
                console.error("No hash found for teams.");
            }
        } catch (error) {
            console.error("Error fetching teams:", error);
        }
    };

    
    const initSeasonsData = async (seasonsHash) => {
        const cachedHash = localStorage.getItem('seasons_hash');
        const cachedSeasonsData = localStorage.getItem('seasons_data');
        const cachedSeasons = JSON.parse(cachedSeasonsData || '[]');
    
        try {
            if (!seasonsHash) {
                console.error("No hash found for seasons.");
                return;
            }
        
            if (cachedSeasons.length === 0 || cachedHash !== seasonsHash) {
                await fetchAllSeasons();
            } else {
                setSeasons(cachedSeasons);
            }
        } catch (error) {
            console.error("Error fetching seasons data cache:", error);
        }
    };
    
    const fetchAllSeasons = async () => {
        try {
        const allSeasonsData = await open_fpl_backend.getSeasons();
        setSeasons(allSeasonsData);
    
        const currentHashArray = await open_fpl_backend.getCurrentHashes();
        const seasonsHashObject = currentHashArray.find(item => item.category === 'seasons');
    
        if (seasonsHashObject) {
            localStorage.setItem('seasons_hash', seasonsHashObject.hash);
            localStorage.setItem('seasons_data', JSON.stringify(allSeasonsData, replacer));
        } else {
            console.error("No hash found for seasons.");
        }
        } catch (error) {
            console.error("Error fetching seasons:", error);
        }
    };
    
    const initFixturesData = async (fixturesHash) => {
        const cachedHash = localStorage.getItem('fixtures_hash');
        const cachedFixturesData = localStorage.getItem('fixtures_data');
        const cachedFixtures = JSON.parse(cachedFixturesData || '[]');
    
        try {
            if (!fixturesHash) {
                console.error("No hash found for fixtures.");
                return;
            }
        
            if (cachedFixtures.length === 0 || cachedHash !== fixturesHash) {
                await fetchAllFixtures();
            } else {
                setFixtures(cachedFixtures);
            }
        } catch (error) {
            console.error("Error fetching fixtures data cache:", error);
        }
    };
    
    const fetchAllFixtures = async () => {
        try {
        const allFixturesData = await open_fpl_backend.getFixtures();
        setFixtures(allFixturesData);
    
        const currentHashArray = await open_fpl_backend.getCurrentHashes();
        const fixturesHashObject = currentHashArray.find(item => item.category === 'fixtures');
    
        if (fixturesHashObject) {
            localStorage.setItem('fixtures_hash', fixturesHashObject.hash);
            localStorage.setItem('fixtures_data', JSON.stringify(allFixturesData, replacer));
        } else {
            console.error("No hash found for fixtures.");
        }
        } catch (error) {
            console.error("Error fetching fixtures:", error);
        }
    };
    
    const initSystemState = async (systemStateHash) => {
        const cachedHash = localStorage.getItem('system_state_hash');
        const cachedSystemStateData = localStorage.getItem('system_state_data');
        const cachedSystemState = JSON.parse(cachedSystemStateData || null);
    
        try {
            if (!systemStateHash) {
                console.error("No hash found for system state.");
                return;
            }
        
            if (cachedSystemState != null || cachedHash !== systemStateHash) {
                await fetchSystemState();
            } else {
                setSystemState(cachedSystemState);
            }
        } catch (error) {
            console.error("Error fetching cached system state:", error);
        }
    };
    
    const fetchSystemState = async () => {
        try {
            const systemStateData = await open_fpl_backend.getSystemState();
            setSystemState(systemStateData);
            
            const currentHashArray = await open_fpl_backend.getCurrentHashes();
            const systemStateHashObject = currentHashArray.find(item => item.category === 'system_state');
        
            if (systemStateHashObject) {
                localStorage.setItem('system_state_hash', systemStateHashObject);
                localStorage.setItem('system_state_data', JSON.stringify(systemStateData, replacer));
            } else {
                console.error("No hash found for system state.");
            }
        } catch (error) {
            console.error("Error fetching system state:", error);
        }
    };

    const initWeeklyLeaderboard = async (hashArray, pageNumber = 1) => {
        const hashObj = hashArray.find(item => item.category === 'weekly_leaderboard');
        const cachedHash = localStorage.getItem('weekly_leaderboard_hash');
        const cachedData = localStorage.getItem('weekly_leaderboard_data');
        const parsedData = JSON.parse(cachedData || '{}');
        
        if (!hashObj || hashObj.hash !== cachedHash || Object.keys(parsedData).length === 0 || pageNumber > CACHE_PAGE_LIMIT) {
            fetchWeeklyLeaderboard(pageNumber);
        } else {
            setWeeklyLeaderboard(parsedData[pageNumber]);
        }
    };
    
    const fetchWeeklyLeaderboard = async (pageNumber) => {
        try {
            const offset = (pageNumber - 1) * itemsPerPage;
            const weeklyLeaderboardData = await open_fpl_backend.getWeeklyLeaderboard(Number(systemState.activeSeason.id), Number(systemState.activeGameweek), itemsPerPage, offset);
            
            const currentHashArray = await open_fpl_backend.getCurrentHashes();
            const weeklyLeaderboardHashObject = currentHashArray.find(item => item.category === 'weekly_leaderboard');
            
            if (weeklyLeaderboardHashObject) {
                let storedData = JSON.parse(localStorage.getItem('weekly_leaderboard_data') || '{}');
                storedData[pageNumber] = weeklyLeaderboardData;
                
                localStorage.setItem('weekly_leaderboard_hash', weeklyLeaderboardHashObject);
                localStorage.setItem('weekly_leaderboard_data', JSON.stringify(storedData, replacer));
            } else {
                console.error("No hash found for weekly leaderboard.");
            }
            
            setWeeklyLeaderboard(weeklyLeaderboardData);
        } catch (error) {
            console.error("Error fetching weekly leaderboard:", error);
        }
    };

    const initMonthlyLeaderboards = async (hashArray, pageNumber = 1) => {
        const hashObj = hashArray.find(item => item.category === 'monthly_leaderboards');
        const cacheKey = generateCacheKey('monthly_leaderboards_data', pageNumber, systemState.activeSeason.id, systemState.activeMonth);
        const cachedHash = localStorage.getItem('monthly_leaderboards_hash');
        const cachedData = localStorage.getItem(cacheKey);
        const parsedData = JSON.parse(cachedData || '[]');
        
        if (!hashObj || hashObj.hash !== cachedHash || parsedData.length === 0 || pageNumber > CACHE_PAGE_LIMIT) {
            fetchMonthlyLeaderboards(hashObj, pageNumber);
        } else {
            setMonthlyLeaderboards(parsedData);
        }
    };
    
    const fetchMonthlyLeaderboards = async (pageNumber) => {
        try {
            const offset = (pageNumber - 1) * itemsPerPage;
            const monthlyLeaderboardsData = await open_fpl_backend.getMonthlyLeaderboards(Number(systemState.activeSeason.id), Number(systemState.activeMonth), itemsPerPage, offset);
            
            const currentHashArray = await open_fpl_backend.getCurrentHashes();
            const monthlyLeaderboardsHashObject = currentHashArray.find(item => item.category === 'monthly_leaderboards');
            
            if (monthlyLeaderboardsHashObject) {
                const cacheKey = generateCacheKey('monthly_leaderboards_data', pageNumber, systemState.activeSeason.id, systemState.activeMonth);
                localStorage.setItem('monthly_leaderboards_hash', monthlyLeaderboardsHashObject);
                localStorage.setItem(cacheKey, JSON.stringify(monthlyLeaderboardsData, replacer));
            } else {
                console.error("No hash found for monthly leaderboard.");
            }
            
            setMonthlyLeaderboards(monthlyLeaderboardsData);
        } catch (error) {
            console.error("Error fetching monthly leaderboard:", error);
        }
    };
    
    const generateCacheKey = (type, pageNumber, season, month) => {
        return `${type}_page_${pageNumber}_season_${season}_month_${month}`;
    };

    
    const initSeasonLeaderboard = async (hashArray, pageNumber = 1) => {
        const hashObj = hashArray.find(item => item.category === 'season_leaderboard');
        const cachedHash = localStorage.getItem('season_leaderboard_hash');
        const cachedData = localStorage.getItem('season_leaderboard_data');
        const parsedData = JSON.parse(cachedData || '{}');
        
        if (!hashObj || hashObj.hash !== cachedHash || Object.keys(parsedData).length === 0 || pageNumber > CACHE_PAGE_LIMIT) {
            fetchSeasonLeaderboard(pageNumber);
        } else {
            setSeasonLeaderboard(parsedData[pageNumber]);
        }
    };
    
    const fetchSeasonLeaderboard = async (pageNumber) => {
        try {
            const offset = (pageNumber - 1) * itemsPerPage;
            const seasonLeaderboardData = await open_fpl_backend.getSeasonLeaderboard(Number(systemState.activeSeason.id), itemsPerPage, offset);
            
            const currentHashArray = await open_fpl_backend.getCurrentHashes();
            const seasonLeaderboardHashObject = currentHashArray.find(item => item.category === 'season_leaderboard');
            
            if (seasonLeaderboardHashObject) {
                let storedData = JSON.parse(localStorage.getItem('season_leaderboard_data') || '{}');
                storedData[pageNumber] = seasonLeaderboardData;
                
                localStorage.setItem('season_leaderboard_hash', seasonLeaderboardHashObject);
                localStorage.setItem('season_leaderboard_data', JSON.stringify(storedData, replacer));
            } else {
                console.error("No hash found for season leaderboard.");
            }
            
            setSeasonLeaderboard(seasonLeaderboardData);
        } catch (error) {
            console.error("Error fetching season leaderboard:", error);
        }
    };
    

    function replacer(key, value) {
        if ((key === 'dateOfBirth' || key === 'value'|| key === 'kickOff') && typeof value === 'bigint') {
        return Number(value);
        }
        return value;
    }

    return (
        <DataContext.Provider value={ { teams, seasons, fixtures, players, systemState, weeklyLeaderboard, monthlyLeaderboards, seasonLeaderboard }}>
            {!loading && children}
        </DataContext.Provider>
    );
};
