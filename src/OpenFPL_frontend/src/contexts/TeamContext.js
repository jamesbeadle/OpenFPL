import React, { createContext, useState, useEffect, useContext } from 'react';
import { Actor } from '@dfinity/agent';
import { AuthContext } from "./AuthContext";
import { OpenFPL_backend as open_fpl_backend } from '../../../declarations/OpenFPL_backend';

export const TeamContext = createContext();

export const TeamProvider = (props) => {
  const { authClient } = useContext(AuthContext);
  const [teams, setTeams] = useState([]);

  const fetchAllTeams = async () => {
    const identity = authClient.getIdentity();
    Actor.agentOf(open_fpl_backend).replaceIdentity(identity);
    const teamsData = await open_fpl_backend.getTeams();
    setTeams(teamsData);
  };

  useEffect(() => {
    fetchAllTeams();
  }, []);

  return (
    <TeamContext.Provider value={{ teams, setTeams }}>
      {props.children}
    </TeamContext.Provider>
  );
};
