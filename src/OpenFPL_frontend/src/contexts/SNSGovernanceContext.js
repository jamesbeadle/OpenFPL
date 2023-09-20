import React, { useState, useEffect } from 'react';
import { SnsGovernanceCanister } from 'dfinity/sns';
import { SnsProposalDecisionStatus } from "dfinity/sns/dist/enums/governance.enums";
import { DataContext } from "../contexts/DataContext";
import { getTeamById } from './helpers';
import { IDL } from "@dfinity/candid";

export const SnsGovernanceContext = React.createContext();

export const SnsGovernanceProvider = ({ children }) => {
    const { teams } = useContext(DataContext);
    const location = useLocation();
    const [activeValuationProposals, setActiveValuationProposals] = useState([]);
    const [activeFixtureDataProposals, setActiveFixtureDataProposals] = useState([]);
    const [activeGovernanceProposals, setActiveGovernanceProposals] = useState([]);
    const [alreadyValuedPlayerIds, setAlreadyValuedPlayerIds ] = useState([]);
    const [remainingWeeklyValuationVotes, setRemainingWeeklyValuationVotes ] = useState([]);
    const InitArgs = IDL.Record({ 'rrkah-fqaaa-aaaaa-aaaaq-cai' : IDL.Principal });
    
    const [loading, setLoading] = useState(true);
  
    const getData = async () => {
        await fetchProposalsByType(1000, setActiveValuationProposals);
        await fetchProposalsByType(2000, setActiveFixtureDataProposals);
        await fetchProposalsByType(3000, setActiveGovernanceProposals);
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

    const revaluePlayerUp = async (userPrincipal, player) => {
        const proposalTitle = "Increase Player Value Proposal";
        const proposalUrl = "https://openfpl.xyz/governance";
        const proposalSummary = `Proposal to increase the value of ${player.firstName != "" ? player.firstName.charAt(0) + "." : ""} ${player.lastName}.`;

        const payload = IDL.encode(InitArgs, (`(${player.id})`));

        const neurons = await listNeurons({ principal: userPrincipal });
        for (const neuron of neurons) {
            const neuronId = neuron.id[0].NeuronId.toString();
            const manageNeuronRequest = createManageNeuronRequestForProposal(
                neuronId, proposalTitle, proposalUrl, proposalSummary, 1000, payload);
            await SnsGovernanceCanister.manageNeuron(manageNeuronRequest);
        }
    };

    const revaluePlayerDown = async (userPrincipal, player) => {
        const proposalTitle = "Decrease Player Value Proposal";
        const proposalUrl = "https://openfpl.xyz/governance";
        const proposalSummary = `Proposal to decrease the value of ${player.firstName != "" ? player.firstName.charAt(0) + "." : ""} ${player.lastName}.`;

        const payload = IDL.encode(InitArgs, (`(${player.id})`));

        const neurons = await listNeurons({ principal: userPrincipal });
        for (const neuron of neurons) {
            const neuronId = neuron.id[0].NeuronId.toString();
            const manageNeuronRequest = createManageNeuronRequestForProposal(
                neuronId, proposalTitle, proposalUrl, proposalSummary, 2000, payload);
            await SnsGovernanceCanister.manageNeuron(manageNeuronRequest);
        }
    };

    const submitFixtureData = async (userPrincipal, fixture, allPlayerEventData) => {
        const proposalTitle = "Fixture Event Data Proposal";
        const proposalUrl = "https://openfpl.xyz/governance";
        const proposalSummary = `Proposal to add event data to fixture 
            ${getTeamById(teams, fixture.homeTeamId).abbreviateName} v ${getTeamById(teams, fixture.awayTeamId).abbreviateName}.`;

            const payload = IDL.encode(InitArgs, (`(${fixture.id} ${allPlayerEventData})`));

        const neurons = await listNeurons({ principal: userPrincipal });
        for (const neuron of neurons) {
            const neuronId = neuron.id[0].NeuronId.toString();
            const manageNeuronRequest = createManageNeuronRequestForProposal(
                neuronId, proposalTitle, proposalUrl, proposalSummary, 3000, payload);
            await SnsGovernanceCanister.manageNeuron(manageNeuronRequest);
        }
    };

    const addIninitalFixtures = async (userPrincipal, season, allSeasonFixtures) => {
        const proposalTitle = "Initial Season Fixtures Proposal";
        const proposalUrl = "https://openfpl.xyz/governance";
        const proposalSummary = `Proposal to add initial fixtures to season ${season.name}.`;

        const payload = IDL.encode(InitArgs, (`(${season.id} ${allSeasonFixtures})`));

        const neurons = await listNeurons({ principal: userPrincipal });
        for (const neuron of neurons) {
            const neuronId = neuron.id[0].NeuronId.toString();
            const manageNeuronRequest = createManageNeuronRequestForProposal(
                neuronId, proposalTitle, proposalUrl, proposalSummary, 4000, payload);
            await SnsGovernanceCanister.manageNeuron(manageNeuronRequest);
        }
    };

    const rescheduleFixture = async (userPrincipal, fixture, gameweek, updatedFixtureDate) => {
        const proposalTitle = "Reschedule Fixture Proposal";
        const proposalUrl = "https://openfpl.xyz/governance";
        const proposalSummary = `Proposal to reschedule fixture 
            ${getTeamById(teams, fixture.homeTeamId).abbreviateName} v ${getTeamById(teams, fixture.awayTeamId).abbreviateName}.`;

        const payload = IDL.encode(InitArgs, (`(${fixture.id} ${gameweek} ${updatedFixtureDate})`));

        const neurons = await listNeurons({ principal: userPrincipal });
        for (const neuron of neurons) {
            const neuronId = neuron.id[0].NeuronId.toString();
            const manageNeuronRequest = createManageNeuronRequestForProposal(
                neuronId, proposalTitle, proposalUrl, proposalSummary, 4000, payload);
            await SnsGovernanceCanister.manageNeuron(manageNeuronRequest);
        }
    };

    const transferPlayer = async (userPrincipal, player, currentTeamId, newTeamId) => {
        const proposalTitle = "Transfer Player Proposal";
        const proposalUrl = "https://openfpl.xyz/governance";
        const proposalSummary = `Proposal to transfer player ${player.firstName != "" ? player.firstName.charAt(0) + "." : ""} ${player.lastName} from team ${getTeamById(teams, currentTeamId).abbreviateName} to ${getTeamById(teams, newTeamId).abbreviateName}.`;

        const payload = IDL.encode(InitArgs, (`(${player.id} ${currentTeamId} ${newTeamId})`));

        const neurons = await listNeurons({ principal: userPrincipal });
        for (const neuron of neurons) {
            const neuronId = neuron.id[0].NeuronId.toString();
            const manageNeuronRequest = createManageNeuronRequestForProposal(
                neuronId, proposalTitle, proposalUrl, proposalSummary, 4000, payload);
            await SnsGovernanceCanister.manageNeuron(manageNeuronRequest);
        }
    };

    const loanPlayer = async (userPrincipal, player, parentTeamId, loanTeamId, loanEndDate) => {
        const proposalTitle = "Loan Player Proposal";
        const proposalUrl = "https://openfpl.xyz/governance";
        const proposalSummary = `Proposal to loan player ${player.firstName != "" ? player.firstName.charAt(0) + "." : ""} ${player.lastName} from team ${getTeamById(teams, parentTeamId).abbreviateName} to ${getTeamById(teams, loanTeamId).abbreviateName}.`;

        const payload = IDL.encode(InitArgs, (`(${playerId} ${parentTeamId} ${loanTeamId} ${loanEndDate})`));

        const neurons = await listNeurons({ principal: userPrincipal });
        for (const neuron of neurons) {
            const neuronId = neuron.id[0].NeuronId.toString();
            const manageNeuronRequest = createManageNeuronRequestForProposal(
                neuronId, proposalTitle, proposalUrl, proposalSummary, 4000, payload);
            await SnsGovernanceCanister.manageNeuron(manageNeuronRequest);
        }
    };

    const recallPlayer = async (userPrincipal, player) => {
        const proposalTitle = "Recall Player Loan Proposal";
        const proposalUrl = "https://openfpl.xyz/governance";
        const proposalSummary = `Proposal to recall loan for player ${player.firstName != "" ? player.firstName.charAt(0) + "." : ""} ${player.lastName}.`;

        const payload = IDL.encode(InitArgs, (`(${player.id})`));

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

        const payload = IDL.encode(InitArgs, (`(${teamId} ${position} ${firstName} ${lastName} ${shirtNumber} 
            ${value} ${dateOfBirth} ${nationality})`));

        const neurons = await listNeurons({ principal: userPrincipal });
        for (const neuron of neurons) {
            const neuronId = neuron.id[0].NeuronId.toString();
            const manageNeuronRequest = createManageNeuronRequestForProposal(
                neuronId, proposalTitle, proposalUrl, proposalSummary, 4000, payload);
            await SnsGovernanceCanister.manageNeuron(manageNeuronRequest);
        }
    };

    const updatePlayer = async (userPrincipal, position, player, firstName, lastName, shirtNumber, dateOfBirth, nationality) => {
        const proposalTitle = "Update Player Proposal";
        const proposalUrl = "https://openfpl.xyz/governance";
        const proposalSummary = `Proposal to update new player ${player.firstName != "" ? player.firstName.charAt(0) + "." : ""} ${player.lastName}.`;

        const payload = IDL.encode(InitArgs, (`(${position} ${firstName} ${lastName} ${shirtNumber} 
            ${dateOfBirth} ${nationality})`));

        const neurons = await listNeurons({ principal: userPrincipal });
        for (const neuron of neurons) {
            const neuronId = neuron.id[0].NeuronId.toString();
            const manageNeuronRequest = createManageNeuronRequestForProposal(
                neuronId, proposalTitle, proposalUrl, proposalSummary, 4000, payload);
            await SnsGovernanceCanister.manageNeuron(manageNeuronRequest);
        }
    };

    const setPlayerInjury = async (userPrincipal, player, description, expectedEndDate) => {
        const proposalTitle = "Player Injury Proposal";
        const proposalUrl = "https://openfpl.xyz/governance";
        const proposalSummary = `Proposal to update player injury status for player ${player.firstName != "" ? player.firstName.charAt(0) + "." : ""} ${player.lastName}.`;

        const payload = IDL.encode(InitArgs, (`(${player.id} ${description} ${expectedEndDate})`));

        const neurons = await listNeurons({ principal: userPrincipal });
        for (const neuron of neurons) {
            const neuronId = neuron.id[0].NeuronId.toString();
            const manageNeuronRequest = createManageNeuronRequestForProposal(
                neuronId, proposalTitle, proposalUrl, proposalSummary, 4000, payload);
            await SnsGovernanceCanister.manageNeuron(manageNeuronRequest);
        }
    };

    const retirePlayer = async (userPrincipal, player, retirementDate) => {
        const proposalTitle = "Player Retirement Proposal";
        const proposalUrl = "https://openfpl.xyz/governance";
        const proposalSummary = `Proposal to retire player ${player.firstName != "" ? player.firstName.charAt(0) + "." : ""} ${player.lastName}.`;

        const payload = IDL.encode(InitArgs, (`(${player.id} ${retirementDate}`));

        const neurons = await listNeurons({ principal: userPrincipal });
        for (const neuron of neurons) {
            const neuronId = neuron.id[0].NeuronId.toString();
            const manageNeuronRequest = createManageNeuronRequestForProposal(
                neuronId, proposalTitle, proposalUrl, proposalSummary, 4000, payload);
            await SnsGovernanceCanister.manageNeuron(manageNeuronRequest);
        }
    };

    const unretirePlayer = async (userPrincipal, player) => {
        const proposalTitle = "Unretire Player Proposal";
        const proposalUrl = "https://openfpl.xyz/governance";
        const proposalSummary = `Proposal to unretire player ${player.firstName != "" ? player.firstName.charAt(0) + "." : ""} ${player.lastName}.`;

        const payload = IDL.encode(InitArgs, (`(${player.id}`));

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
        const proposalSummary = `Proposal to promote team ${getTeamById(teams, teamId).abbreviateName}} to the Premier League.`;

        const payload = IDL.encode(InitArgs, (`(${teamId}`));

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

        const payload = IDL.encode(InitArgs, (`(${name} ${friendlyName} ${abbreviatedName} ${primaryHexColour} ${secondaryHexColour} ${thirdHexColour}`));

        const neurons = await listNeurons({ principal: userPrincipal });
        for (const neuron of neurons) {
            const neuronId = neuron.id[0].NeuronId.toString();
            const manageNeuronRequest = createManageNeuronRequestForProposal(
                neuronId, proposalTitle, proposalUrl, proposalSummary, 4000, payload);
            await SnsGovernanceCanister.manageNeuron(manageNeuronRequest);
        }
    };

    const updateTeamProposal = async (userPrincipal, teamId, name, friendlyName, abbreviatedName, primaryHexColour, secondaryHexColour, thirdHexColour) => {
        const proposalTitle = "Update Team Proposal";
        const proposalUrl = "https://openfpl.xyz/governance";
        const proposalSummary = `Proposal to update ${getTeamById(teams, teamId).abbreviateName}} team details.`;

        const payload = IDL.encode(InitArgs, (`(${teamId} ${name} ${friendlyName} ${abbreviatedName} ${primaryHexColour} ${secondaryHexColour} ${thirdHexColour}`));

        const neurons = await listNeurons({ principal: userPrincipal });
        for (const neuron of neurons) {
            const neuronId = neuron.id[0].NeuronId.toString();
            const manageNeuronRequest = createManageNeuronRequestForProposal(
                neuronId, proposalTitle, proposalUrl, proposalSummary, 4000, payload);
            await SnsGovernanceCanister.manageNeuron(manageNeuronRequest);
        }
    };

    return (
        <SnsGovernanceContext.Provider value={{ activeFixtureDataProposals, activeGovernanceProposals, alreadyValuedPlayerIds, 
            remainingWeeklyValuationVotes, revaluePlayerUp, revaluePlayerDown, submitFixtureData, addIninitalFixtures, rescheduleFixture, 
            transferPlayer, loanPlayer, recallPlayer, createPlayer, updatePlayer, setPlayerInjury, retirePlayer, unretirePlayer, promoteFormerTeam, promoteNewTeam,
            updateTeamProposal }}>
            {!loading && children}
        </SnsGovernanceContext.Provider>
    );
};
