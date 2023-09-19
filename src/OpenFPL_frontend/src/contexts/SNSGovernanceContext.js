import React, { useState, useEffect } from 'react';
import { SnsGovernanceCanister } from 'dfinity/sns';
import { SnsProposalDecisionStatus } from "dfinity/sns/dist/enums/governance.enums";

const SnsGovernanceContext = React.createContext();

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

    const revaluePlayerUp = async (playerId) => {

        const existingProposal = activeValuationProposals.find(x => x.type == 'REVALUE PLAYER UP' && x.playerId == playerId);

        if(existingProposal){
            const voteParams = {
                vote: SnsVote.Yes,
                proposalId: existingProposal.id
            };
            await SnsGovernanceCanister.registerVote(voteParams);
        }
        else{
            const newProposalId = await createNewRevaluePlayerUpProposal(player.id);
            
            const voteParams = {
                vote: SnsVote.Yes,
                proposalId: newProposalId
            };
            await SnsGovernanceCanister.registerVote(voteParams);
        }
        getData();
    };

    const revaluePlayerDown = async (playerId) => {
        const existingProposal = activeValuationProposals.find(x => x.type == 'REVALUE PLAYER DOWN' && x.playerId == playerId);

        if(existingProposal){
            //submit the vote
        }
        else{
            const newProposalId = await createNewRevaluePlayerDownProposal(player.id);
            
                //submit the vote

        }
        getData();
    };

    const createNewRevaluePlayerUpProposal = async (playerId) => {

    };

    const createNewRevaluePlayerDownProposal = async (playerId) => {

    };

    const CustomProposalType = {
        PLAYER_VALUATION: 1n,
        FIXTURE_DATA: 2n,
        MOVE_PLAYER_BETWEEN_TEAM: 3n
    };

    return (
        <SnsGovernanceContext.Provider value={{ activeFixtureDataProposals, activeGovernanceProposals, alreadyValuedPlayerIds, remainingWeeklyValuationVotes }}>
            {!loading && children}
        </SnsGovernanceContext.Provider>
    );
};
