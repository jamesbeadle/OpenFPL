import React, { createContext, useContext, useState, useEffect } from 'react';  // Added useEffect
import snsGovernance from './path_to_services/snsGovernance';
import { SnsProposalDecisionStatus } from "@dfinity/sns/dist/enums/governance.enums";

const SnsGovernanceContext = createContext();

export const useSnsGovernance = () => {
    return useContext(SnsGovernanceContext);
};

export const SnsGovernanceProvider = ({ children, canisterId }) => {
    const [neurons, setNeurons] = useState([]);
    const [proposals, setProposals] = useState([]);  // Added this state initialization
    const [activeValuationProposals, setActiveValuationProposals] = useState([]);
    const [activeFixtureDataProposals, setActiveFixtureDataProposals] = useState([]);
    const [activeGovernanceProposals, setActiveGovernanceProposals] = useState([]);
    
    const instance = snsGovernance.createInstance(canisterId);
    
    useEffect(() => {
        fetchPlayerValuationProposals();
        fetchAddedFixtureDataProposals();
        fetchSystemUpdateProposals();
    }, []);

    const fetchPlayerValuationProposals = () => fetchProposalsByType(1n, setActiveValuationProposals);
    const fetchAddedFixtureDataProposals = () => fetchProposalsByType(2n, setActiveFixtureDataProposals);
    const fetchSystemUpdateProposals = () => fetchProposalsByType(3n, setActiveGovernanceProposals);
    
    const fetchNeurons = async () => {
        const result = await snsGovernance.listNeurons(instance, {});
        setNeurons(result.neurons);
    };

    const fetchProposalsByType = async (type, setActiveFunction) => {
        const params = {
            includeStatus: [SnsProposalDecisionStatus.PROPOSAL_DECISION_STATUS_OPEN],
            includeType: [type]
        };
        const result = await snsGovernance.listProposals(instance, params);
        if (setActiveFunction) {
            setActiveFunction(result.proposals);
        } else {
            return result.proposals;
        }
    };

    
    const fetchProposals = async () => {
        const result = await snsGovernance.listProposals(instance, {});
        setProposals(result.proposals);
    };

    const getProposal = async (params) => {
        return await snsGovernance.getProposal(instance, params);
    };

    const CustomProposalType = {
        PLAYER_VALUATION: 1n,
        FIXTURE_DATA: 2n,
        MOVE_PLAYER_BETWEEN_TEAM: 3n
    };

    const fetchActivePlayerValuationProposals = () => fetchProposalsByType(CustomProposalType.PLAYER_VALUATION);
    const fetchActiveFixtureDataProposals = () => fetchProposalsByType(CustomProposalType.FIXTURE_DATA);
    const fetchActiveMovePlayerBetweenTeamProposals = () => fetchProposalsByType(CustomProposalType.MOVE_PLAYER_BETWEEN_TEAM);

    const value = {
        neurons,
        proposals,
        fetchNeurons,
        fetchProposals,
        getProposal,
        fetchActivePlayerValuationProposals,
        fetchActiveFixtureDataProposals,
        fetchActiveMovePlayerBetweenTeamProposals
    };

    return (
        <SnsGovernanceContext.Provider value={value}>
            {children}
        </SnsGovernanceContext.Provider>
    );
};
