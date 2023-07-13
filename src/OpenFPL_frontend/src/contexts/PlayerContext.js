import React, { createContext, useState, useEffect, useContext } from 'react';
import { Actor } from '@dfinity/agent';
import { AuthContext } from "./AuthContext";
import { player_canister as player_canister } from '../../../declarations/player_canister';

export const PlayerContext = createContext();

export const PlayerProvider = (props) => {
  const { authClient } = useContext(AuthContext);
  const [players, setPlayers] = useState([]);

  const fetchAllPlayers = async () => {
    const identity = authClient.getIdentity();
    Actor.agentOf(player_canister).replaceIdentity(identity);
    const allPlayersData = await player_canister.getAllPlayers();
    setPlayers(allPlayersData);
  };

  useEffect(() => {
    if (authClient.isAuthenticated()) {
      fetchAllPlayers();
    }
  }, [authClient]);

  return (
    <PlayerContext.Provider value={{ players, setPlayers }}>
      {props.children}
    </PlayerContext.Provider>
  );
};
