import React, { useState, useEffect } from 'react';
import { player_canister as player_canister } from '../../../declarations/player_canister';
import { OpenFPL_backend as open_fpl_backend } from '../../../declarations/OpenFPL_backend';

export const DataContext = React.createContext();

export const DataProvider = ({ children }) => {
  const [players, setPlayers] = useState([]);
  const [teams, setTeams] = useState([]);
  const [seasons, setSeasons] = useState([]);
  const [fixtures, setFixtures] = useState([]);
  const [systemState, setSystemState] = useState(null);
  const [loading, setLoading] = useState(true);
 
  useEffect(() => {
    const init = async () => {
        await initPlayerData();
        await initTeamsData();
        await initSeasonsData();
        await initFixturesData();
        await initSystemState();
        setLoading(false);
    };    
    init();
  }, []);

  const initPlayerData = async () => {
    const cachedHash = localStorage.getItem('players_hash');
    const cachedPlayersData = localStorage.getItem('players_data');
    const cachedPlayers = JSON.parse(cachedPlayersData || '[]');
        
    try {
        const currentHash = await player_canister.getPlayerDataCache();
        if (cachedPlayers.length === 0 || cachedHash !== currentHash.hash) {
          await fetchAllPlayers();
        } else {
          setPlayers(cachedPlayers);
        }
      } catch (error) {
          console.error("Error fetching player data cache:", error);
      }
  };

  const fetchAllPlayers = async () => {
    try {
        const allPlayersData = await player_canister.getAllPlayers();
        setPlayers(allPlayersData);
        
        const currentHash = await player_canister.getPlayerDataCache();
        localStorage.setItem('players_hash', currentHash.hash);
        localStorage.setItem('players_data', JSON.stringify(allPlayersData, replacer));

    } catch (error) {
        console.error("Error fetching all players:", error);
    }
  };

  const initTeamsData = async () => {
    const cachedHash = localStorage.getItem('teams_hash');
    const cachedTeamsData = localStorage.getItem('teams_data');
    const cachedTeams = JSON.parse(cachedTeamsData || '[]');
    
    try {
        const currentHashArray = await open_fpl_backend.getDataHashes();
        const teamHashObject = currentHashArray.find(item => item.category === 'teams');

        if (!teamHashObject) {
            console.error("No hash found for teams.");
            return;
        }

        if (cachedTeams.length === 0 || cachedHash !== teamHashObject.hash) {
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

    
    const initSeasonsData = async () => {
        const cachedHash = localStorage.getItem('seasons_hash');
        const cachedSeasonsData = localStorage.getItem('seasons_data');
        const cachedSeasons = JSON.parse(cachedSeasonsData || '[]');
    
        try {
            const currentHashArray = await open_fpl_backend.getCurrentHashes();
            const seasonsHashObject = currentHashArray.find(item => item.category === 'seasons');
        
            if (!seasonsHashObject) {
                console.error("No hash found for seasons.");
                return;
            }
        
            if (cachedSeasons.length === 0 || cachedHash !== seasonsHashObject.hash) {
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
    
    const initFixturesData = async () => {
        const cachedHash = localStorage.getItem('fixtures_hash');
        const cachedFixturesData = localStorage.getItem('fixtures_data');
        const cachedFixtures = JSON.parse(cachedFixturesData || '[]');
    
        try {
            const currentHashArray = await open_fpl_backend.getCurrentHashes();
            const fixturesHashObject = currentHashArray.find(item => item.category === 'fixtures');
        
            if (!fixturesHashObject) {
                console.error("No hash found for fixtures.");
                return;
            }
        
            if (cachedFixtures.length === 0 || cachedHash !== fixturesHashObject.hash) {
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
    
    const initSystemState = async () => {
        const cachedHash = localStorage.getItem('system_state_hash');
        const cachedSystemStateData = localStorage.getItem('system_state_data');
        const cachedSystemState = JSON.parse(cachedSystemStateData || null);
    
        try {
            const currentHashArray = await open_fpl_backend.getCurrentHashes();
            const systemStateHashObject = currentHashArray.find(item => item.category === 'system_state');
        
            if (!systemStateHashObject) {
                console.error("No hash found for system state.");
                return;
            }
        
            if (cachedSystemState != null || cachedHash !== systemStateHashObject.hash) {
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
            const fixturesHashObject = currentHashArray.find(item => item.category === 'system_state');
        
            if (fixturesHashObject) {
                localStorage.setItem('system_state_hash', fixturesHashObject.hash);
                localStorage.setItem('system_state_data', JSON.stringify(systemStateData, replacer));
            } else {
                console.error("No hash found for fixtures.");
            }
        } catch (error) {
            console.error("Error fetching fixtures:", error);
        }
    };


    function replacer(key, value) {
        if ((key === 'dateOfBirth' || key === 'value'|| key === 'kickOff') && typeof value === 'bigint') {
        return Number(value);
        }
        return value;
    }

    return (
        <DataContext.Provider value={ { teams, seasons, fixtures, players, systemState }}>
            {!loading && children}
        </DataContext.Provider>
    );
};
