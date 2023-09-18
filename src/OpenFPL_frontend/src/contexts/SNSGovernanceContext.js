import React, { createContext, useContext, useState } from 'react';
import snsGovernance from './path_to_services/snsGovernance';

const SnsGovernanceContext = createContext();

export const useSnsGovernance = () => {
    return useContext(SnsGovernanceContext);
};

export const SnsGovernanceProvider = ({ children, agent, canisterId }) => {
    const [neurons, setNeurons] = useState([]);
    const [proposals, setProposals] = useState([]);
    // ... other state ...

    const instance = snsGovernance.createInstance(agent, canisterId);

    const fetchNeurons = async () => {
        const result = await snsGovernance.listNeurons(instance, {});
        setNeurons(result.neurons);
    };

    const fetchProposals = async () => {
        const result = await snsGovernance.listProposals(instance, {});
        setProposals(result.proposals);
    };

    const getProposal = async (params) => {
        return await snsGovernance.getProposal(instance, params);
    };

    // ... any other methods ...

    const value = {
        neurons,
        proposals,
        fetchNeurons,
        fetchProposals,
        getProposal,
        // ... other methods and state ...
    };

    return (
        <SnsGovernanceContext.Provider value={value}>
            {children}
        </SnsGovernanceContext.Provider>
    );
};
