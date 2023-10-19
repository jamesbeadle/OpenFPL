import React, { useState, useEffect } from 'react';
import { AuthClient } from "@dfinity/auth-client";

export const AuthContext = React.createContext();

export const AuthProvider = ({ children }) => {
  const [authClient, setAuthClient] = useState(null);
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [userPrincipal, setUserPrincipal] = useState(""); //SET AS USER PROFILE AND IMPLEMENT EVERYWHERE, MAYBE THIS IS THE TIME TO REFACTOR THE PROFILE SO CAN GET THIS QUICKLY
  const [loading, setLoading] = useState(true);

  const OLD_MAINNET_IDENTITY_SERVICE_URL = "https://identity.ic0.app";
  const NNS_IC_ORG_ALTERNATIVE_ORIGIN = "https://openfpl.xyz";
  const NNS_IC_APP_DERIVATION_ORIGIN = "https://bgpwv-eqaaa-aaaal-qb6eq-cai.icp0.io";
  
  const getIdentityProvider = () => {
    if (location.host === "nns.ic0.app") {
      return OLD_MAINNET_IDENTITY_SERVICE_URL;
    }
    return process.env.II_URL;
  };

  const isNnsAlternativeOrigin = () => {
    return window.location.origin === NNS_IC_ORG_ALTERNATIVE_ORIGIN;
  };

  const initAuthClient = async () => {
    try{
      const newAuthClient = await AuthClient.create({
        idleOptions: {
          idleTimeout: 1000 * 60 * 60
        }
      });
      await checkLoginStatus(newAuthClient);
      setAuthClient(newAuthClient);
    }
    catch (error){
      console.error('Error during AuthClient initialization:', error);
    }
    finally{
      setLoading(false);
    }
  };

  useEffect(() => {
    initAuthClient();
  }, []);

  const login = async () => {
    try {
      await authClient.login({
        identityProvider: getIdentityProvider(),
        ...(isNnsAlternativeOrigin() && {
          derivationOrigin: NNS_IC_APP_DERIVATION_ORIGIN,
        }),
        maxTimeToLive: BigInt(7 * 24 * 60 * 60 * 1000 * 1000 * 1000),
        onSuccess: async () => {
          const principal = await authClient.getIdentity().getPrincipal();
          setUserPrincipal(principal.toText());
          setIsAuthenticated(true);
        }
      });
    } catch (error) {
      console.error('Login error:', error);
    }
  };

  const logout = async () => {
    try {
      await authClient.logout();
      setUserPrincipal("");
      setIsAuthenticated(false);
    } catch (error) {
      console.error('Logout error:', error);
    }
  };

  const checkLoginStatus = async (client) => {
    if (!client) return;

    const isLoggedIn = await client.isAuthenticated();
    if (isLoggedIn) {
      const principal = await client.getIdentity().getPrincipal(); 
      setUserPrincipal(principal.toText());
      setIsAuthenticated(true);
    } else {
      setUserPrincipal("");
      setIsAuthenticated(false);
    }
  };

  return (
    <AuthContext.Provider value={ { authClient, isAuthenticated, login, logout, userPrincipal }}>
      {!loading && children}
    </AuthContext.Provider>
  );
};
