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
  const [loading, setLoading] = useState(true);

  const deleteIndexedDB = (dbName) => {
    return new Promise((resolve, reject) => {
      const request = window.indexedDB.deleteDatabase(dbName);
    
      request.onsuccess = () => {
        console.log('IndexedDB successfully deleted');
        window.location.reload();
        resolve();
      };
  
      request.onerror = (event) => {
        console.error('Error deleting IndexedDB:', event);
        reject(event);
      };
  
      request.onblocked = () => {
        console.warn('IndexedDB delete request blocked. Please close all other tabs using the database.');
      };
    });
  };
 
  useEffect(() => {
    const initAuthClient = async () => {
      try{
        const authClient = await AuthClient.create({
          idleOptions: {
            idleTimeout: 1000 * 60 * 60
          }
        });
        await checkLoginStatus(authClient);
        setAuthClient(authClient);
      }
      catch (error){
        console.error('Error during AuthClient initialization:', error);
        await deleteIndexedDB('auth-client-db');
      }
      finally{
        setLoading(false);
      }
    };
    initAuthClient();
  }, []);

  useEffect(() => {
    if (!authClient) return;

    const interval = setInterval(() => {
      checkLoginStatus(authClient);
    }, 60000);

    return () => {
      clearInterval(interval);
    };
  }, [authClient]);

  const login = async () => {
    await authClient.login({
      identityProvider: process.env.II_URL,
      maxTimeToLive: BigInt(7 * 24 * 60 * 60 * 1000 * 1000 * 1000),
      onSuccess: async () => {
        setIsAuthenticated(true);
      }
    });
  };

  const logout = async () => {
    await authClient.logout();
    setIsAuthenticated(false);
  };

  const checkLoginStatus = async (client) => {
    if(client == null){
      return false;
    }
    const isLoggedIn = await client.isAuthenticated();
    if (isLoggedIn && isTokenValid(client)) {
      setIsAuthenticated(true);
      return true;
    } else {
      return false;
    }
  };
  

  const isTokenValid = (client) => {
    try {
      const identity = client.getIdentity();
      if (!identity || !identity._delegation || !identity._delegation.delegations) return false;

      const delegation = identity._delegation.delegations[0];
      if (!delegation) return false;

      const expiration = BigInt(delegation.delegation.expiration);
      const currentTime = BigInt(Date.now() * 1000000);
      return currentTime < expiration;
    } catch (error) {
      return false;
    }
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
    if (!isAuthenticated) {
      return;
    }

    const identity = authClient.getIdentity();
    Actor.agentOf(player_canister).replaceIdentity(identity);
    const teamsData = await open_fpl_backend.getTeams();
    setTeams(teamsData);
  };

  useEffect(() => {
    fetchAllTeams();
    fetchAllPlayers();
  }, [isAuthenticated]);

  return (
    <AuthContext.Provider value={ { authClient, isAuthenticated, setIsAuthenticated, login, logout, players, teams  }}>
      {!loading && children}
    </AuthContext.Provider>
  );
};
