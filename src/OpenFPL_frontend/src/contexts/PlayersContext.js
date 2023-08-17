import React, { useState, useEffect } from 'react';
import { player_canister as player_canister } from '../../../declarations/player_canister';

export const PlayersContext = React.createContext();

export const PlayersProvider = ({ children }) => {
  const [players, setPlayers] = useState([]);
  const [loading, setLoading] = useState(true);
 
  useEffect(() => {
    const init = async () => {
        await fetchAllPlayers();      
        setLoading(false);
      };    
      init();
      
    }, []);

  const fetchAllPlayers = async () => {
    const allPlayersData = await player_canister.getAllPlayers();
    setPlayers(allPlayersData);
  };

  return (
    <PlayersContext.Provider value={ { players }}>
      {!loading && children}
    </PlayersContext.Provider>
  );
};
