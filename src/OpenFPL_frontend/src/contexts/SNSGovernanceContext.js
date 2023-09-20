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

    const revaluePlayerUp = async (userPrincipal, playerId) => {
        const proposalTitle = "Increase Player Value Proposal";
        const proposalUrl = "https://openfpl.xyz/governance";
        const proposalSummary = `Proposal to increase the value of player id ${playerId}.`;

        const payload = encodePayload(`(${playerId})`); //IMPLEMENT ENCODING FUNCTION

        const neurons = await listNeurons({ principal: userPrincipal });
        for (const neuron of neurons) {
            const neuronId = neuron.id[0].NeuronId.toString();
            const manageNeuronRequest = createManageNeuronRequestForProposal(
                neuronId, proposalTitle, proposalUrl, proposalSummary, 1000, payload);
            await SnsGovernanceCanister.manageNeuron(manageNeuronRequest);
        }
    };

    const revaluePlayerDown = async (userPrincipal, playerId) => {
        const proposalTitle = "Decrease Player Value Proposal";
        const proposalUrl = "https://openfpl.xyz/governance";
        const proposalSummary = `Proposal to decrease the value of player id ${playerId}.`;

        const payload = encodePayload(`(${playerId})`); //IMPLEMENT ENCODING FUNCTION

        const neurons = await listNeurons({ principal: userPrincipal });
        for (const neuron of neurons) {
            const neuronId = neuron.id[0].NeuronId.toString();
            const manageNeuronRequest = createManageNeuronRequestForProposal(
                neuronId, proposalTitle, proposalUrl, proposalSummary, 2000, payload);
            await SnsGovernanceCanister.manageNeuron(manageNeuronRequest);
        }
    };

    const submitFixtureData = async (userPrincipal, fixtureId, allPlayerEventData) => {
        const proposalTitle = "Fixture Event Data Proposal";
        const proposalUrl = "https://openfpl.xyz/governance";
        const proposalSummary = `Proposal to add event data to fixture ${fixtureId}.`;

        const payload = encodePayload(`(${fixtureId} ${allPlayerEventData})`); //IMPLEMENT ENCODING FUNCTION

        const neurons = await listNeurons({ principal: userPrincipal });
        for (const neuron of neurons) {
            const neuronId = neuron.id[0].NeuronId.toString();
            const manageNeuronRequest = createManageNeuronRequestForProposal(
                neuronId, proposalTitle, proposalUrl, proposalSummary, 3000, payload);
            await SnsGovernanceCanister.manageNeuron(manageNeuronRequest);
        }
    };

    const addIninitalFixtures = async (userPrincipal, seasonId, allSeasonFixtures) => {
        const proposalTitle = "Initial Season Fixtures Proposal";
        const proposalUrl = "https://openfpl.xyz/governance";
        const proposalSummary = `Proposal to add initial fixtures to season ${seasonId}.`;

        const payload = encodePayload(`(${seasonId} ${allSeasonFixtures})`); //IMPLEMENT ENCODING FUNCTION

        const neurons = await listNeurons({ principal: userPrincipal });
        for (const neuron of neurons) {
            const neuronId = neuron.id[0].NeuronId.toString();
            const manageNeuronRequest = createManageNeuronRequestForProposal(
                neuronId, proposalTitle, proposalUrl, proposalSummary, 4000, payload);
            await SnsGovernanceCanister.manageNeuron(manageNeuronRequest);
        }
    };

    const rescheduleFixture = async (userPrincipal, fixtureId, gameweek, updatedFixtureDate) => {
        const proposalTitle = "Reschedule Fixture Proposal";
        const proposalUrl = "https://openfpl.xyz/governance";
        const proposalSummary = `Proposal to reschedule fixture ${fixtureId}.`;

        const payload = encodePayload(`(${fixtureId} ${gameweek} ${updatedFixtureDate})`); //IMPLEMENT ENCODING FUNCTION

        const neurons = await listNeurons({ principal: userPrincipal });
        for (const neuron of neurons) {
            const neuronId = neuron.id[0].NeuronId.toString();
            const manageNeuronRequest = createManageNeuronRequestForProposal(
                neuronId, proposalTitle, proposalUrl, proposalSummary, 4000, payload);
            await SnsGovernanceCanister.manageNeuron(manageNeuronRequest);
        }
    };

    const transferPlayer = async (userPrincipal, playerId, currentTeamId, newTeamId) => {
        const proposalTitle = "Transfer Player Proposal";
        const proposalUrl = "https://openfpl.xyz/governance";
        const proposalSummary = `Proposal to transfer player ${playerId} from team ${currentTeamId} to ${newTeamId}.`;

        const payload = encodePayload(`(${playerId} ${currentTeamId} ${newTeamId})`); //IMPLEMENT ENCODING FUNCTION

        const neurons = await listNeurons({ principal: userPrincipal });
        for (const neuron of neurons) {
            const neuronId = neuron.id[0].NeuronId.toString();
            const manageNeuronRequest = createManageNeuronRequestForProposal(
                neuronId, proposalTitle, proposalUrl, proposalSummary, 4000, payload);
            await SnsGovernanceCanister.manageNeuron(manageNeuronRequest);
        }
    };

    const loanPlayer = async (userPrincipal, playerId, parentTeamId, loanTeamId, loanEndDate) => {
        const proposalTitle = "Loan Player Proposal";
        const proposalUrl = "https://openfpl.xyz/governance";
        const proposalSummary = `Proposal to loan player ${playerId} from team ${parentTeamId} to ${loanTeamId}.`;

        const payload = encodePayload(`(${playerId} ${parentTeamId} ${loanTeamId} ${loanEndDate})`); //IMPLEMENT ENCODING FUNCTION

        const neurons = await listNeurons({ principal: userPrincipal });
        for (const neuron of neurons) {
            const neuronId = neuron.id[0].NeuronId.toString();
            const manageNeuronRequest = createManageNeuronRequestForProposal(
                neuronId, proposalTitle, proposalUrl, proposalSummary, 4000, payload);
            await SnsGovernanceCanister.manageNeuron(manageNeuronRequest);
        }
    };

    const recallPlayer = async (userPrincipal, playerId) => {
        const proposalTitle = "Recall Player Loan Proposal";
        const proposalUrl = "https://openfpl.xyz/governance";
        const proposalSummary = `Proposal to recall loan for player ${playerId}.`;

        const payload = encodePayload(`(${playerId})`); //IMPLEMENT ENCODING FUNCTION

        const neurons = await listNeurons({ principal: userPrincipal });
        for (const neuron of neurons) {
            const neuronId = neuron.id[0].NeuronId.toString();
            const manageNeuronRequest = createManageNeuronRequestForProposal(
                neuronId, proposalTitle, proposalUrl, proposalSummary, 4000, payload);
            await SnsGovernanceCanister.manageNeuron(manageNeuronRequest);
        }
    };

    const createPlayer = async (userPrincipal, teamId, position, firstName, lastName, shirtNumber, value, dateOfBirth, nationality) => {
        const proposalTitle = "Add New Player Proposal";
        const proposalUrl = "https://openfpl.xyz/governance";
        const proposalSummary = `Proposal to add new player ${firstName} ${lastName}.`;

        const payload = encodePayload(`(${teamId} ${position} ${firstName} ${lastName} ${shirtNumber} 
            ${value} ${dateOfBirth} ${nationality})`); //IMPLEMENT ENCODING FUNCTION

        const neurons = await listNeurons({ principal: userPrincipal });
        for (const neuron of neurons) {
            const neuronId = neuron.id[0].NeuronId.toString();
            const manageNeuronRequest = createManageNeuronRequestForProposal(
                neuronId, proposalTitle, proposalUrl, proposalSummary, 4000, payload);
            await SnsGovernanceCanister.manageNeuron(manageNeuronRequest);
        }
    };

    const updatePlayer = async (userPrincipal, position, firstName, lastName, shirtNumber, dateOfBirth, nationality) => {
        const proposalTitle = "Update Player Proposal";
        const proposalUrl = "https://openfpl.xyz/governance";
        const proposalSummary = `Proposal to update new player ${firstName} ${lastName}.`;

        const payload = encodePayload(`(${position} ${firstName} ${lastName} ${shirtNumber} 
            ${dateOfBirth} ${nationality})`); //IMPLEMENT ENCODING FUNCTION

        const neurons = await listNeurons({ principal: userPrincipal });
        for (const neuron of neurons) {
            const neuronId = neuron.id[0].NeuronId.toString();
            const manageNeuronRequest = createManageNeuronRequestForProposal(
                neuronId, proposalTitle, proposalUrl, proposalSummary, 4000, payload);
            await SnsGovernanceCanister.manageNeuron(manageNeuronRequest);
        }
    };

    const setPlayerInjury = async (userPrincipal, playerId, description, expectedEndDate) => {
        const proposalTitle = "Player Injury Proposal";
        const proposalUrl = "https://openfpl.xyz/governance";
        const proposalSummary = `Proposal to update player injury status for player ${playerId}.`;

        const payload = encodePayload(`(${playerId} ${description} ${expectedEndDate})`); //IMPLEMENT ENCODING FUNCTION

        const neurons = await listNeurons({ principal: userPrincipal });
        for (const neuron of neurons) {
            const neuronId = neuron.id[0].NeuronId.toString();
            const manageNeuronRequest = createManageNeuronRequestForProposal(
                neuronId, proposalTitle, proposalUrl, proposalSummary, 4000, payload);
            await SnsGovernanceCanister.manageNeuron(manageNeuronRequest);
        }
    };

    const retirePlayer = async (userPrincipal, playerId, retirementDate) => {
        const proposalTitle = "Player Retirement Proposal";
        const proposalUrl = "https://openfpl.xyz/governance";
        const proposalSummary = `Proposal to retire player ${playerId}.`;

        const payload = encodePayload(`(${playerId} ${retirementDate}`); //IMPLEMENT ENCODING FUNCTION

        const neurons = await listNeurons({ principal: userPrincipal });
        for (const neuron of neurons) {
            const neuronId = neuron.id[0].NeuronId.toString();
            const manageNeuronRequest = createManageNeuronRequestForProposal(
                neuronId, proposalTitle, proposalUrl, proposalSummary, 4000, payload);
            await SnsGovernanceCanister.manageNeuron(manageNeuronRequest);
        }
    };

    const unretirePlayer = async (userPrincipal, playerId) => {
        const proposalTitle = "Unretire Player Proposal";
        const proposalUrl = "https://openfpl.xyz/governance";
        const proposalSummary = `Proposal to unretire player ${playerId}.`;

        const payload = encodePayload(`(${playerId}`); //IMPLEMENT ENCODING FUNCTION

        const neurons = await listNeurons({ principal: userPrincipal });
        for (const neuron of neurons) {
            const neuronId = neuron.id[0].NeuronId.toString();
            const manageNeuronRequest = createManageNeuronRequestForProposal(
                neuronId, proposalTitle, proposalUrl, proposalSummary, 4000, payload);
            await SnsGovernanceCanister.manageNeuron(manageNeuronRequest);
        }
    };

    const promoteFormerTeam = async (userPrincipal, teamId) => {
        const proposalTitle = "Promote Former Team Proposal";
        const proposalUrl = "https://openfpl.xyz/governance";
        const proposalSummary = `Proposal to promote team ${teamId} to the Premier League.`;

        const payload = encodePayload(`(${teamId}`); //IMPLEMENT ENCODING FUNCTION

        const neurons = await listNeurons({ principal: userPrincipal });
        for (const neuron of neurons) {
            const neuronId = neuron.id[0].NeuronId.toString();
            const manageNeuronRequest = createManageNeuronRequestForProposal(
                neuronId, proposalTitle, proposalUrl, proposalSummary, 4000, payload);
            await SnsGovernanceCanister.manageNeuron(manageNeuronRequest);
        }
    };

    const promoteNewTeam = async (userPrincipal, name, friendlyName, abbreviatedName, primaryHexColour, secondaryHexColour, thirdHexColour) => {
        const proposalTitle = "Promote New Team Proposal";
        const proposalUrl = "https://openfpl.xyz/governance";
        const proposalSummary = `Proposal to promote ${name} to the Premier League.`;

        const payload = encodePayload(`(${name} ${friendlyName} ${abbreviatedName} ${primaryHexColour} ${secondaryHexColour} ${thirdHexColour}`); //IMPLEMENT ENCODING FUNCTION

        const neurons = await listNeurons({ principal: userPrincipal });
        for (const neuron of neurons) {
            const neuronId = neuron.id[0].NeuronId.toString();
            const manageNeuronRequest = createManageNeuronRequestForProposal(
                neuronId, proposalTitle, proposalUrl, proposalSummary, 4000, payload);
            await SnsGovernanceCanister.manageNeuron(manageNeuronRequest);
        }
    };

    const updateTeamProposal = async (userPrincipal, name, friendlyName, abbreviatedName, primaryHexColour, secondaryHexColour, thirdHexColour) => {
        const proposalTitle = "Update Team Proposal";
        const proposalUrl = "https://openfpl.xyz/governance";
        const proposalSummary = `Proposal to update ${name} team details.`;

        const payload = encodePayload(`(${name} ${friendlyName} ${abbreviatedName} ${primaryHexColour} ${secondaryHexColour} ${thirdHexColour}`); //IMPLEMENT ENCODING FUNCTION

        const neurons = await listNeurons({ principal: userPrincipal });
        for (const neuron of neurons) {
            const neuronId = neuron.id[0].NeuronId.toString();
            const manageNeuronRequest = createManageNeuronRequestForProposal(
                neuronId, proposalTitle, proposalUrl, proposalSummary, 4000, payload);
            await SnsGovernanceCanister.manageNeuron(manageNeuronRequest);
        }
    };

    return (
        <SnsGovernanceContext.Provider value={{ activeFixtureDataProposals, activeGovernanceProposals, alreadyValuedPlayerIds, remainingWeeklyValuationVotes, revaluePlayerUp, revaluePlayerDown }}>
            {!loading && children}
        </SnsGovernanceContext.Provider>
    );
};
