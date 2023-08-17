import React, { useState, useEffect } from 'react';
import { AuthClient } from "@dfinity/auth-client";

export const AuthContext = React.createContext();

export const AuthProvider = ({ children }) => {
  const [authClient, setAuthClient] = useState(null);
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [userPrincipal, setUserPrincipal] = useState("");
  const [loading, setLoading] = useState(true);
 
  useEffect(() => {
    const initAuthClient = async () => {
      const newAuthClient = await AuthClient.create({
          idleOptions: {
              idleTimeout: 1000 * 60 * 60
          }
      });
    
      setAuthClient(newAuthClient);
    
      if (newAuthClient) {
          newAuthClient.idleManager?.registerCallback?.(refreshLogin);
          const isLoggedIn = await checkLoginStatus(newAuthClient);
          setIsAuthenticated(isLoggedIn);
      }
    
      setLoading(false);
    };    
    initAuthClient();
}, []);


  useEffect(() => {
      if(authClient) {
          checkLoginStatus(authClient);
      }
  }, [authClient]);


  const checkLoginStatus = async (client) => {
    if(client == null){
      return false;
    }
    const isLoggedIn = await client.isAuthenticated();
    if (isLoggedIn) {
      setIsAuthenticated(true);
      const newPrincipal = await client.getIdentity().getPrincipal(); 
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

  return (
    <AuthContext.Provider value={ { authClient, isAuthenticated, setIsAuthenticated, login, logout, userPrincipal  }}>
      {!loading && children}
    </AuthContext.Provider>
  );
};
