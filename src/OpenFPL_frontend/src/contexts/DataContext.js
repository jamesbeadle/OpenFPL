import React, { useState, useEffect } from 'react';
import { useLocation } from 'react-router-dom';
import { player_canister as player_canister } from '../../../declarations/player_canister';
import { OpenFPL_backend as open_fpl_backend } from '../../../declarations/OpenFPL_backend';
import { computeTimeLeft } from '../components/helpers';

export const DataContext = React.createContext();

export const DataProvider = ({ children }) => {
    const location = useLocation();
    const [players, setPlayers] = useState([]);
    const [teams, setTeams] = useState([]);
    const [seasons, setSeasons] = useState([]);
    const [fixtures, setFixtures] = useState([]);
    const [playerEvents, setPlayerEvents] = useState([]);
    const [systemState, setSystemState] = useState(null);
    const [weeklyLeaderboard, setWeeklyLeaderboard] = useState({});
    const [monthlyLeaderboards, setMonthlyLeaderboards] = useState([]);
    const [seasonLeaderboard, setSeasonLeaderboard] = useState({});
    const [backendCanisterHashes, setBackendCanisterHashes] = useState([]);
    const [playerCanisterHashes, setPlayerCanisterHashes] = useState([]);
    const [loading, setLoading] = useState(true);
  
    const checkAndUpdateData = async () => {
        try {
            const backendHashArray = await open_fpl_backend.getDataHashes();
            setBackendCanisterHashes(backendHashArray);
            const playerHashArray = await player_canister.getDataHashes();
            setPlayerCanisterHashes(playerHashArray);
            await initPlayerData(playerHashArray.find(item => item.category === 'players'));
            await initTeamsData(backendHashArray.find(item => item.category === 'teams'));
            await initSeasonsData(backendHashArray.find(item => item.category === 'seasons'));
            await initFixturesData(backendHashArray.find(item => item.category === 'fixtures'));
            await initSystemState(backendHashArray.find(item => item.category === 'system_state'));
        }
        catch (error) {
            console.log(error);
        }
    };

    useEffect(() => {
        checkAndUpdateData();
    }, []);

    useEffect(() => {
        checkAndUpdateData();
    }, [location.pathname]);

    useEffect(() => {

        if(!systemState || Object.keys(systemState).length === 0){
            return;
        }
        const initLeaderboards = async () => {
            
            await initWeeklyLeaderboard(backendCanisterHashes.find(item => item.category === 'weekly_leaderboard'));
            await initMonthlyLeaderboards(backendCanisterHashes.find(item => item.category === 'monthly_leaderboards'));
            await initSeasonLeaderboard(backendCanisterHashes.find(item => item.category === 'season_leaderboard'));  
            await initPlayerEventsData(playerCanisterHashes.find(item => item.category === 'playerEventData'));        
            setLoading(false);  
        };
        initLeaderboards();
    }, [systemState, fixtures]);

    const initPlayerData = async (playerHash) => {
        const cachedHash = localStorage.getItem('players_hash');
        const cachedPlayersData = localStorage.getItem('players_data');
        const cachedPlayers = JSON.parse(cachedPlayersData || '[]');
            
        try {
            if (!playerHash || cachedPlayers.length === 0 || cachedHash !== playerHash.hash) {
                await fetchAllPlayers(playerHash);
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
            
            localStorage.setItem('players_hash', playersHash.hash);
            localStorage.setItem('players_data', JSON.stringify(allPlayersData, replacer));

        } catch (error) {
            console.error("Error fetching all players:", error);
        }
    };

    const initPlayerEventsData = async (playerEventDataHash) => {
        const cachedHash = localStorage.getItem('player_events_hash');
        const cachedPlayerEventsData = localStorage.getItem('player_events_data');
        const cachedPlayerEvents = JSON.parse(cachedPlayerEventsData || '[]');
            
        try {
            if (!playerEventDataHash || cachedPlayerEvents.length === 0 || cachedHash !== playerEventDataHash.hash) {
                await fetchAllPlayerEventsData(playerEventDataHash);
            } else {
                setPlayerEvents(cachedPlayerEvents);
            }
        } catch (error) {
            console.error("Error fetching player event data cache:", error);
        }
    };

    const fetchAllPlayerEventsData = async (playerEventsHash) => {
        try {
            var gameweek = Number(systemState.focusGameweek);
            
            const allPlayersData = await player_canister.getPlayerDetailsForGameweek(systemState.activeSeason.id, gameweek);
            setPlayerEvents(allPlayersData);
            
            localStorage.setItem('player_events_hash', playerEventsHash.hash);
            localStorage.setItem('player_events_data', JSON.stringify(allPlayersData, replacer));

        } catch (error) {
            console.error("Error fetching all player events:", error);
        }
    };

    const initTeamsData = async (teamsHash) => {
        const cachedHash = localStorage.getItem('teams_hash');
        const cachedTeamsData = localStorage.getItem('teams_data');
        const cachedTeams = JSON.parse(cachedTeamsData || '[]');

        try {
            if (!teamsHash || cachedTeams.length === 0 || cachedHash !== teamsHash) {
                await fetchAllTeams(teamsHash);
            } else {
                setTeams(cachedTeams);
            }
        } catch (error) {
            console.error("Error fetching teams data cache:", error);
        }
    };

    const fetchAllTeams = async (teamsHash) => {
            try {
                const allTeamsData = await open_fpl_backend.getTeams();
                setTeams(allTeamsData);
                
                if (teamsHash) {
                    localStorage.setItem('teams_hash', teamsHash.hash);
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
            if (!seasonsHash || cachedSeasons.length === 0 || cachedHash !== seasonsHash) {
                await fetchAllSeasons(seasonsHash);
            } else {
                setSeasons(cachedSeasons);
            }
        } catch (error) {
            console.error("Error fetching seasons data cache:", error);
        }
    };

    const fetchAllSeasons = async (seasonsHash) => {
        try {
        const allSeasonsData = await open_fpl_backend.getSeasons();
        setSeasons(allSeasonsData);

        if (seasonsHash) {
            localStorage.setItem('seasons_hash', seasonsHash.hash);
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
            if (!fixturesHash || cachedFixtures.length === 0 || cachedHash !== fixturesHash) {
                await fetchAllFixtures(fixturesHash);
            } else {
                setFixtures(cachedFixtures);
            }
        } catch (error) {
            console.error("Error fetching fixtures data cache:", error);
        }
    };

    const fetchAllFixtures = async (fixturesHash) => {
        try {
            const allFixturesData = await open_fpl_backend.getFixtureDTOs();
            setFixtures(allFixturesData);
        
            if (fixturesHash) {
                localStorage.setItem('fixtures_hash', fixturesHash.hash);
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
        
            if (!systemStateHash || cachedSystemState != null || cachedHash !== systemStateHash) {
                await fetchSystemState(systemStateHash);
            } else {
                setSystemState(cachedSystemState);
            }
        } catch (error) {
            console.error("Error fetching cached system state:", error);
        }
    };

    const fetchSystemState = async (systemStateHash) => {
        try {
            const systemStateData = await open_fpl_backend.getSystemState();
            setSystemState(systemStateData);
            if (systemStateHash) {
                localStorage.setItem('system_state_hash', systemStateHash.hash);
                localStorage.setItem('system_state_data', JSON.stringify(systemStateData, replacer));
            } else {
                console.error("No hash found for system state.");
            }
        } catch (error) {
            console.error("Error fetching system state:", error);
        }
    };

    const initWeeklyLeaderboard = async (hashObj) => {
        if(fixtures.length == 0){
            return;
        }
        const cachedHash = localStorage.getItem('weekly_leaderboard_hash');
        const cachedData = localStorage.getItem('weekly_leaderboard_data');
        const parsedData = JSON.parse(cachedData || '{}');
            
        if (!hashObj || hashObj.hash !== cachedHash || Object.keys(parsedData).length === 0) {
            fetchWeeklyLeaderboard(hashObj);
        } else {
            setWeeklyLeaderboard(parsedData);
        }
    };

    const fetchWeeklyLeaderboard = async (hashObj) => {
        try {
            var gameweek = Number(systemState.focusGameweek);
            
            const weeklyLeaderboardData = await open_fpl_backend.getWeeklyLeaderboardCache(Number(systemState.activeSeason.id), gameweek);
            
            if (hashObj) {
                localStorage.setItem('weekly_leaderboard_hash', hashObj.hash);
                localStorage.setItem('weekly_leaderboard_data', JSON.stringify(weeklyLeaderboardData, replacer));
            } else {
                console.error("No hash found for weekly leaderboard.");
            }
            
            setWeeklyLeaderboard(weeklyLeaderboardData);
        } catch (error) {
            console.error("Error fetching weekly leaderboard:", error);
        }
    };

    const initMonthlyLeaderboards = async (hashObj) => {
        if(fixtures.length == 0){
            return;
        }
        const cachedHash = localStorage.getItem('monthly_leaderboard_hash');
        const cachedData = localStorage.getItem('monthly_leaderboard_data');
        const parsedData = JSON.parse(cachedData || '[]');
        
        if (!hashObj || hashObj.hash !== cachedHash || Object.keys(parsedData).length === 0) {
            fetchMonthlyLeaderboards(hashObj);
        } else {
            setMonthlyLeaderboards(parsedData);
        }
    };

    const fetchMonthlyLeaderboards = async (hashObj) => {
        try {
            const monthlyLeaderboardsData = await open_fpl_backend.getClubLeaderboardsCache(Number(systemState.activeSeason.id), Number(systemState.activeMonth));
            setMonthlyLeaderboards(monthlyLeaderboardsData); 
            
            if (hashObj) {
                localStorage.setItem('monthly_leaderboards_hash', hashObj.hash);
                localStorage.setItem('monthly_leaderboards_data', JSON.stringify(monthlyLeaderboardsData, replacer));
            } else {
                console.error("No hash found for monthly leaderboards.");
            }
        } catch (error) {
            console.error("Error fetching monthly leaderboard:", error);
        }
    };

    const initSeasonLeaderboard = async (hashObj) => {
        if(fixtures.length == 0){
            return;
        }
        const cachedHash = localStorage.getItem('season_leaderboard_hash');
        const cachedData = localStorage.getItem('season_leaderboard_data');
        const parsedData = JSON.parse(cachedData || '{}');
        
        if (!hashObj || hashObj.hash !== cachedHash || Object.keys(parsedData).length === 0) {
            fetchSeasonLeaderboard(hashObj);
        } else {
            setSeasonLeaderboard(parsedData);
        }
    };

    const fetchSeasonLeaderboard = async (hashObj) => {
        try {
            const seasonLeaderboardData = await open_fpl_backend.getSeasonLeaderboardCache(Number(systemState.activeSeason.id));
            if (hashObj) {
                localStorage.setItem('season_leaderboard_hash', hashObj.hash);
                localStorage.setItem('season_leaderboard_data', JSON.stringify(seasonLeaderboardData, replacer));
            } else {
                console.error("No hash found for season leaderboard.");
            }
            
            setSeasonLeaderboard(seasonLeaderboardData);
        } catch (error) {
            console.error("Error fetching season leaderboard:", error);
        }
    };

    function replacer(key, value) {
        if ((key === 'dateOfBirth' || key === 'value'|| key === 'kickOff' || key === 'totalEntries'|| key === 'position') && typeof value === 'bigint') {
        return Number(value);
        }
        return value;
    }

    return (
        <DataContext.Provider value={ { teams, seasons, fixtures, players, systemState, weeklyLeaderboard, monthlyLeaderboards, seasonLeaderboard, playerEvents }}>
            {!loading && children}
        </DataContext.Provider>
    );
};
