import { useState, useEffect } from 'react';
import snsGovernance from './path_to_services/snsGovernance';

const useSnsGovernance = (agent, canisterId) => {
    const [neurons, setNeurons] = useState([]);
    const [proposals, setProposals] = useState([]);
    // ... any other state you want to manage ...

    const instance = snsGovernance.createInstance(agent, canisterId);

    useEffect(() => {
        const fetchNeurons = async () => {
            const result = await snsGovernance.listNeurons(instance, {});
            setNeurons(result.neurons);
        };

        const fetchProposals = async () => {
            const result = await snsGovernance.listProposals(instance, {});
            setProposals(result.proposals);
        };

        // ... any other fetch functions ...

        fetchNeurons();
        fetchProposals();
    }, [instance]);

    // Expose methods to components
    const getProposal = async (params) => {
        return await snsGovernance.getProposal(instance, params);
    };

    // ... any other methods ...

    return {
        neurons,
        proposals,
        getProposal,
        // ... other methods and state ...
    };
};

export default useSnsGovernance;
