import React, { useState, useEffect } from 'react';
import { player_canister as player_canister } from '../../../declarations/player_canister';

export const PlayersContext = React.createContext();

export const PlayersProvider = ({ children }) => {
  const [players, setPlayers] = useState([]);
  const [loading, setLoading] = useState(true);
 
  useEffect(() => {
    const init = async () => {
        const cachedHash = localStorage.getItem('players_hash');
        const cachedPlayersData = localStorage.getItem('players_data');
        const cachedPlayers = JSON.parse(cachedPlayersData || '[]');
        
        try {
          const currentHash = await player_canister.getPlayerDataCache();
          if (cachedPlayers.length === 0 || cachedHash !== currentHash.hash) {
            console.log("setting players from backend");
            await fetchAllPlayers();
          } else {
            console.log("setting players from cache");
            setPlayers(cachedPlayers);
          }
        } catch (error) {
            console.error("Error fetching player data cache:", error);
        }
        
        setLoading(false);
    };    
    init();
  }, []);

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

  function replacer(key, value) {
    if (key === 'dateOfBirth' || key === 'value' && typeof value === 'bigint') {
      return Number(value);
    }
    return value;
  }

  return (
    <PlayersContext.Provider value={ { players }}>
      {!loading && children}
    </PlayersContext.Provider>
  );
};
