import React, { useState, useEffect } from 'react';
import { SnsGovernanceCanister } from 'dfinity/sns';
import { SnsProposalDecisionStatus } from "dfinity/sns/dist/enums/governance.enums";

export const SnsGovernanceContext = React.createContext();

export const SnsGovernanceProvider = ({ children }) => {
    const location = useLocation();
    const [activeValuationProposals, setActiveValuationProposals] = useState([]);
    const [activeFixtureDataProposals, setActiveFixtureDataProposals] = useState([]);
    const [activeGovernanceProposals, setActiveGovernanceProposals] = useState([]);
    const [alreadyValuedPlayerIds, setAlreadyValuedPlayerIds ] = useState([]);
    const [remainingWeeklyValuationVotes, setRemainingWeeklyValuationVotes ] = useState([]);
    
    const [loading, setLoading] = useState(true);
  
    const getData = async () => {
        await fetchProposalsByType(CustomProposalType.PLAYER_VALUATION, setActiveValuationProposals);
        await fetchProposalsByType(CustomProposalType.FIXTURE_DATA, setActiveFixtureDataProposals);
        await fetchProposalsByType(CustomProposalType.MOVE_PLAYER_BETWEEN_TEAM, setActiveGovernanceProposals);
        await fetchRemainingWeeklyValuationVotes();
        await fetchAlreadyValuedPlayerIds();
        setLoading(false);
    };

    useEffect(() => {
        getData();
    }, []);

    useEffect(() => {
        if (location.pathname !== '/governance') {
            return;
        }
        getData();
    }, [location.pathname]);

    const fetchProposalsByType = async (type, setActiveFunction) => {
        const params = {
            includeStatus: [SnsProposalDecisionStatus.PROPOSAL_DECISION_STATUS_OPEN],
            includeType: [type]
        };
        const result = await SnsGovernanceCanister.listProposals(instance, params);
        if (setActiveFunction) {
            setActiveFunction(result.proposals);
        } else {
            return result.proposals;
        }
    };

    const fetchAlreadyValuedPlayerIds = async () => {
        //IMPLEMENT
        setAlreadyValuedPlayerIds([]);
    };

    const fetchRemainingWeeklyValuationVotes = async () => {
        //IMPLEMENT
        setRemainingWeeklyValuationVotes([]);
    };

    const createManageNeuronRequestForProposal = (neuronId, title, url, summary, function_id, payload) => {
        return {
            id: [{ NeuronId: neuronId }],
            command: [{
                MakeProposal: {
                    title: title,
                    url: url,
                    summary: summary,
                    action: {
                        ExecuteGenericNervousSystemFunction: {
                            function_id: function_id,
                            payload: payload
                        }
                    }
                }
            }],
            neuron_id_or_subaccount: [{ NeuronId: neuronId }] 
        };
    };

    const revaluePlayerUp = async (playerId, userPrincipal) => {
        const proposalTitle = "Execute generic function for player";
        const proposalUrl = "https://openfpl.xyz/governance";
        const proposalSummary = `Proposal to execute a generic function for player ${playerId}.`;

        const payload = encodePayload(`(${playerId})`); //IMPLEMENT ENCODING FUNCTION

        const neurons = await listNeurons({ principal: userPrincipal });
        for (const neuron of neurons) {
            const neuronId = neuron.id[0].NeuronId.toString();
            const manageNeuronRequest = createManageNeuronRequestForProposal(neuronId, proposalTitle, proposalUrl, proposalSummary, 1000, payload);
            await SnsGovernanceCanister.manageNeuron(manageNeuronRequest);
        }
    };
    
    const revaluePlayerDown = async (playerId) => {
        const proposalTitle = "Revalue Player Down";
        const proposalUrl = "https://openfpl.xyz/governance";
        const proposalSummary = `Proposal to revalue player ${playerId} upwards.`;
        const actionType = "Motion";
        const actionParams = {
            motion_text: `Proposal to revalue player ${playerId} upwards in value.`
        };
    
        const neuronId = ""; // ??
        const manageNeuronRequest = createManageNeuronRequestForProposal(neuronId, proposalTitle, proposalUrl, proposalSummary, actionType, actionParams);
    
        await SnsGovernanceCanister.manageNeuron(manageNeuronRequest);
        await fetchAlreadyValuedPlayerIds();
    };

    return (
        <SnsGovernanceContext.Provider value={{ activeFixtureDataProposals, activeGovernanceProposals, alreadyValuedPlayerIds, remainingWeeklyValuationVotes, revaluePlayerUp, revaluePlayerDown }}>
            {!loading && children}
        </SnsGovernanceContext.Provider>
    );
};
