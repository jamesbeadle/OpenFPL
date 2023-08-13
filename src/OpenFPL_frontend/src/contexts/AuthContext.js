import React, { useState, useEffect } from 'react';
import { AuthClient } from "@dfinity/auth-client";
import { Actor } from "@dfinity/agent";
import { player_canister as player_canister } from '../../../declarations/player_canister';
import { OpenFPL_backend as open_fpl_backend } from '../../../declarations/OpenFPL_backend';

export const AuthContext = React.createContext();

export const AuthProvider = ({ children }) => {
  const [authClient, setAuthClient] = useState(null);
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [players, setPlayers] = useState([]);
  const [teams, setTeams] = useState([]);
  const [userPrincipal, setUserPrincipal] = useState("");
  const [loading, setLoading] = useState(true);
 
  useEffect(() => {
    const initAuthClient = async () => {
      const authClient = await AuthClient.create({
        idleOptions: {
          idleTimeout: 1000 * 60 * 60
        }
      });
      authClient.idleManager?.registerCallback?.(refreshLogin);
      setAuthClient(authClient);
      setUserPrincipal(authClient.getIdentity().getPrincipal());

      setLoading(false);
    };
    initAuthClient();
  }, []);

  useEffect(() => {
    if (!authClient) return;
    checkLoginStatus(authClient);
  }, [authClient]);

  const checkLoginStatus = async (client) => {
    if(client == null){
      return false;
    }
    const isLoggedIn = await client.isAuthenticated();
    if (isLoggedIn) {
      setIsAuthenticated(true);
      const newPrincipal = await authClient.getIdentity().getPrincipal();
      setUserPrincipal(newPrincipal.toText());
      return true;
    } else {
      return false;
    }
  };

  const refreshLogin = () => {
    authClient.login({
      onSuccess: async () => {
        const newPrincipal = await authClient.getIdentity().getPrincipal();
        setUserPrincipal(newPrincipal.toText());
      },
    });
  };

  const login = async () => {
    await authClient.login({
      identityProvider: process.env.II_URL,
      maxTimeToLive: BigInt(7 * 24 * 60 * 60 * 1000 * 1000 * 1000),
      onSuccess: async () => {
        const newPrincipal = await authClient.getIdentity().getPrincipal();
        setUserPrincipal(newPrincipal.toText());
        setIsAuthenticated(true);
      }
    });
  };

  const logout = async () => {
    await authClient.logout();
    setUserPrincipal("");
    setIsAuthenticated(false);
  };

  const fetchAllPlayers = async () => {
    if (!isAuthenticated) {
      return;
    }
    
    const identity = authClient.getIdentity();
    Actor.agentOf(player_canister).replaceIdentity(identity);
    const allPlayersData = await player_canister.getAllPlayers();
    setPlayers(allPlayersData);
  };

  
  const fetchAllTeams = async () => {
    const teamsData = await open_fpl_backend.getTeams();
    setTeams(teamsData);
  };

  useEffect(() => {
    fetchAllTeams();
    fetchAllPlayers();
  }, [isAuthenticated]);

  return (
    <AuthContext.Provider value={ { authClient, isAuthenticated, setIsAuthenticated, login, logout, players, teams, userPrincipal  }}>
      {!loading && children}
    </AuthContext.Provider>
  );
};
