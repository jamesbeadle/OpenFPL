import React, { useState, useEffect } from 'react';
import { OpenFPL_backend as open_fpl_backend } from '../../../declarations/OpenFPL_backend';

export const TeamsContext = React.createContext();

export const TeamsProvider = ({ children }) => {
    const [teams, setTeams] = useState([]);
    const [loading, setLoading] = useState(true);
 
    useEffect(() => {
        const init = async () => {
            await fetchAllTeams();      
            setLoading(false);
        };    
        init();
    }, []);

    const fetchAllTeams = async () => {
        const teamsData = await open_fpl_backend.getTeams();
        setTeams(teamsData);
    };

    return (
        <TeamsContext.Provider value={ { teams }}>
            {!loading && children}
        </TeamsContext.Provider>
    );
};
