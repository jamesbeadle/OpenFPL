import React, { useState, useEffect } from 'react';
import { SnsGovernanceCanister } from 'dfinity/sns';
import { SnsProposalDecisionStatus } from "dfinity/sns/dist/enums/governance.enums";
import { AuthContext } from "./AuthContext";
import { DataContext } from "./DataContext";
import { getTeamById } from './helpers';
import { IDL } from "@dfinity/candid";

export const SnsGovernanceContext = React.createContext();

export const SnsGovernanceProvider = ({ children }) => {
    const { teams, systemState } = useContext(DataContext);
    const { authClient } = useContext(AuthContext);
    const location = useLocation();
    const InitArgs = IDL.Record({ 'rrkah-fqaaa-aaaaa-aaaaq-cai' : IDL.Principal });
    
    const [loading, setLoading] = useState(true);
    const [hasNeurons, setHasNeurons] = useState(false);
    
    useEffect(() => {
        getData();
    }, []);
    
    useEffect(() => {
        if (location.pathname !== '/governance') {
            return;
        }
        getData();
    }, [location.pathname]);
  
    const getData = async () => {
        const neurons = await SnsGovernanceCanister.listNeurons({ principal: authClient.getPrincipal() });
        
        if (!neurons || neurons.length === 0) {
            setLoading(false);
            return;
        }
        setHasNeurons(true);
        setLoading(false);
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

    const revaluePlayerUp = async (player) => {
        const proposalTitle = "Increase Player Value Proposal";
        const proposalUrl = "https://openfpl.xyz/governance";
        const proposalSummary = `Proposal to increase the value of ${player.firstName !== "" ? player.firstName.charAt(0) + "." : ""} ${player.lastName}.`;
        const payload = IDL.encode(InitArgs, `(record { playerId=${player.id} })`);
        await submitProposal(proposalTitle, proposalUrl, proposalSummary, 1000, payload);
    };
    
    const revaluePlayerDown = async (player) => {
        const proposalTitle = "Decrease Player Value Proposal";
        const proposalUrl = "https://openfpl.xyz/governance";
        const proposalSummary = `Proposal to decrease the value of ${player.firstName !== "" ? player.firstName.charAt(0) + "." : ""} ${player.lastName}.`;
        const payload = IDL.encode(InitArgs, `(record { playerId=${player.id} })`);
        await submitProposal(proposalTitle, proposalUrl, proposalSummary, 2000, payload);
    };
    
    const submitFixtureData = async (fixture, playerEvents) => {
        const proposalTitle = "Fixture Event Data Proposal";
        const proposalUrl = "https://openfpl.xyz/governance";
        const proposalSummary = `Proposal to add event data to fixture 
            ${getTeamById(teams, fixture.homeTeamId).abbreviateName} v ${getTeamById(teams, fixture.awayTeamId).abbreviateName}.`;
        const playerEventDataString = constructPlayerEventDataString(playerEvents);
        const payload = IDL.encode(InitArgs, `(record { fixtureId: ${fixture.id}; playerEventData: vec {${playerEventDataString}} })`);
        await submitProposal(proposalTitle, proposalUrl, proposalSummary, 3000, payload);
    };

    function constructPlayerEventDataString(events) {
        return events.map(event => `
            record {
                fixtureId=${event.fixtureId};
                playerId=${event.playerId};
                eventType=${event.eventType};
                eventStartMinute=${event.eventStartMinute};
                eventEndMinute=${event.eventEndMinute};
                teamId=${event.teamId};
            }
        `).join('; ');
    };
    
    const addIninitalFixtures = async (season, seasonFixtures) => {
        const proposalTitle = "Initial Season Fixtures Proposal";
        const proposalUrl = "https://openfpl.xyz/governance";
        const proposalSummary = `Proposal to add initial fixtures to season ${season.name}.`;
        const seasonFixturesString = constructFixtureString(seasonFixtures);
        const payload = IDL.encode(InitArgs, `(record { seasonId: ${season.id}; seasonFixtures: vec {${seasonFixturesString}} })`);
        await submitProposal(proposalTitle, proposalUrl, proposalSummary, 4000, payload);
    };

    function constructFixtureString(fixtures) {
        return fixtures.map(fixture => `
            record {
                id=${fixture.id};
                seasonId=${fixture.seasonId};
                gameweek=${fixture.gameweek};
                kickOff=${fixture.kickOff};
                homeTeamId=${fixture.homeTeamId};
                awayTeamId=${fixture.awayTeamId};
                homeGoals=0;
                awayGoals=0;
                status=0;
                events=vec {};
                highestScoringPlayerId=0;
            }
        `).join('; ');
    };

    const rescheduleFixture = async (fixture, currentFixtureGameweek, updatedFixtureGameweek, updatedFixtureDate) => {
        const proposalTitle = "Reschedule Fixture Proposal";
        const proposalUrl = "https://openfpl.xyz/governance";
        const proposalSummary = `Proposal to reschedule fixture 
            ${getTeamById(teams, fixture.homeTeamId).abbreviateName} v ${getTeamById(teams, fixture.awayTeamId).abbreviateName}.`;
        const payload = IDL.encode(InitArgs, `(record { fixtureId=${fixture.id}; currentFixtureGameweek=${currentFixtureGameweek}; updatedFixtureGameweek=${updatedFixtureGameweek}; updatedFixtureDate=${updatedFixtureDate} })`);
        await submitProposal(proposalTitle, proposalUrl, proposalSummary, 5000, payload);
    };

    const transferPlayer = async (player, currentTeamId, newTeamId) => {
        const proposalTitle = "Transfer Player Proposal";
        const proposalUrl = "https://openfpl.xyz/governance";
        const proposalSummary = `Proposal to transfer player ${player.firstName != "" ? player.firstName.charAt(0) + "." : ""} ${player.lastName} from team ${getTeamById(teams, currentTeamId).abbreviateName} to ${getTeamById(teams, newTeamId).abbreviateName}.`;
        const payload = IDL.encode(InitArgs, `(record { playerId=${player.id}; currentTeamId=${currentTeamId}; newTeamId=${newTeamId} })`);
        await submitProposal(proposalTitle, proposalUrl, proposalSummary, functionIdTransfer, payload);
    };
   
    const loanPlayer = async (player, parentTeamId, loanTeamId, loanEndDate) => {
        const proposalTitle = "Loan Player Proposal";
        const proposalUrl = "https://openfpl.xyz/governance";
        const proposalSummary = `Proposal to loan player ${player.firstName != "" ? player.firstName.charAt(0) + "." : ""} ${player.lastName} from team ${getTeamById(teams, parentTeamId).abbreviateName} to ${getTeamById(teams, loanTeamId).abbreviateName}.`;
        const payload = IDL.encode(InitArgs, `(record { playerId=${player.id}; parentTeamId=${parentTeamId}; loanTeamId=${loanTeamId}; loanEndDate=${loanEndDate} })`);
        await submitProposal(proposalTitle, proposalUrl, proposalSummary, 7000, payload);
    };

    const recallPlayer = async (player) => {
        const proposalTitle = "Recall Player Loan Proposal";
        const proposalUrl = "https://openfpl.xyz/governance";
        const proposalSummary = `Proposal to recall loan for player ${player.firstName != "" ? player.firstName.charAt(0) + "." : ""} ${player.lastName}.`;
        const payload = IDL.encode(InitArgs, `(record { playerId=${player.id} })`);
        await submitProposal(proposalTitle, proposalUrl, proposalSummary, 8000, payload);
    };

    const createPlayer = async (teamId, position, firstName, lastName, shirtNumber, value, dateOfBirth, nationality) => {
        const proposalTitle = "Add New Player Proposal";
        const proposalUrl = "https://openfpl.xyz/governance";
        const proposalSummary = `Proposal to add new player ${firstName} ${lastName}.`;
        const payload = IDL.encode(InitArgs, `(record { teamId=${teamId}; position=${position}; firstName=${firstName}; lastName=${lastName}; shirtNumber=${shirtNumber}; value=${value}; dateOfBirth=${dateOfBirth}; nationality=${nationality} })`);
        await submitProposal(proposalTitle, proposalUrl, proposalSummary, 9000, payload);
    };

    const updatePlayer = async (player, position, firstName, lastName, shirtNumber, dateOfBirth, nationality) => {
        const proposalTitle = "Update Player Proposal";
        const proposalUrl = "https://openfpl.xyz/governance";
        const proposalSummary = `Proposal to update new player ${player.firstName != "" ? player.firstName.charAt(0) + "." : ""} ${player.lastName}.`;
        const payload = IDL.encode(InitArgs, `(record { playerId=${player.id}; position=${position}; firstName=${firstName}; lastName=${lastName}; shirtNumber=${shirtNumber}; dateOfBirth=${dateOfBirth}; nationality=${nationality} })`);
        await submitProposal(proposalTitle, proposalUrl, proposalSummary, 10000, payload);
    };

    const setPlayerInjury = async (player, description, expectedEndDate) => {
        const proposalTitle = "Player Injury Proposal";
        const proposalUrl = "https://openfpl.xyz/governance";
        const proposalSummary = `Proposal to update player injury status for player ${player.firstName != "" ? player.firstName.charAt(0) + "." : ""} ${player.lastName}.`;
        const payload = IDL.encode(InitArgs, `(record { playerId=${player.id}; description=${description}; expectedEndDate=${expectedEndDate} })`);
        await submitProposal(proposalTitle, proposalUrl, proposalSummary, 11000, payload);
    };

    const retirePlayer = async (player, retirementDate) => {
        const proposalTitle = "Player Retirement Proposal";
        const proposalUrl = "https://openfpl.xyz/governance";
        const proposalSummary = `Proposal to retire player ${player.firstName != "" ? player.firstName.charAt(0) + "." : ""} ${player.lastName}.`;    
        const payload = IDL.encode(InitArgs, `(record { playerId=${player.id}; retirementDate=${retirementDate} })`);
        await submitProposal(proposalTitle, proposalUrl, proposalSummary, 12000, payload);
    };

    const unretirePlayer = async (player) => {
        const proposalTitle = "Unretire Player Proposal";
        const proposalUrl = "https://openfpl.xyz/governance";
        const proposalSummary = `Proposal to unretire player ${player.firstName != "" ? player.firstName.charAt(0) + "." : ""} ${player.lastName}.`;    
        const payload = IDL.encode(InitArgs, `(record { playerId=${player.id} })`);
        await submitProposal(proposalTitle, proposalUrl, proposalSummary, 13000, payload);
    };
    
    const promoteFormerTeam = async (teamId) => {
        const proposalTitle = "Promote Former Team Proposal";
        const proposalUrl = "https://openfpl.xyz/governance";
        const proposalSummary = `Proposal to promote team ${getTeamById(teams, teamId).abbreviateName}} to the Premier League.`;    
        const payload = IDL.encode(InitArgs, `(record { teamId=${teamId} })`);
        await submitProposal(proposalTitle, proposalUrl, proposalSummary, 14000, payload);
  
    };

    const promoteNewTeam = async (name, friendlyName, abbreviatedName, primaryHexColour, secondaryHexColour, thirdHexColour) => {
        const proposalTitle = "Promote New Team Proposal";
        const proposalUrl = "https://openfpl.xyz/governance";
        const proposalSummary = `Proposal to promote ${name} to the Premier League.`;    
        const payload = IDL.encode(InitArgs, `(record { name=${name}; friendlyName=${friendlyName}; abbreviatedName=${abbreviatedName}; primaryHexColour=${primaryHexColour}; secondaryHexColour=${secondaryHexColour}; thirdHexColour=${thirdHexColour} })`);
        await submitProposal(proposalTitle, proposalUrl, proposalSummary, 15000, payload);
    };
    
    const updateTeam = async (teamId, name, friendlyName, abbreviatedName, primaryHexColour, secondaryHexColour, thirdHexColour) => {
        const proposalTitle = "Update Team Proposal";
        const proposalUrl = "https://openfpl.xyz/governance";
        const proposalSummary = `Proposal to update ${getTeamById(teams, teamId).abbreviatedName} team details.`;
        const payload = IDL.encode(InitArgs, `(record { teamId=${teamId}; name=${name}; friendlyName=${friendlyName}; abbreviatedName=${abbreviatedName}; primaryHexColour=${primaryHexColour}; secondaryHexColour=${secondaryHexColour}; thirdHexColour=${thirdHexColour} })`);
        await submitProposal(proposalTitle, proposalUrl, proposalSummary, 16000, payload);
    };

    const submitProposal = async(proposalTitle, proposalUrl, proposalSummary, functionId, payload) => {
        const neurons = await SnsGovernanceCanister.listNeurons({ principal: authClient.getPrincipal() });
        const neuronId = neurons[0].id;
        const manageNeuronRequest = createManageNeuronRequestForProposal(
            neuronId, proposalTitle, proposalUrl, proposalSummary, functionId, payload
        );
        await SnsGovernanceCanister.manageNeuron(manageNeuronRequest);
    };
    
    return (
        <SnsGovernanceContext.Provider value={{ hasNeurons, revaluePlayerUp, revaluePlayerDown, submitFixtureData, addIninitalFixtures, 
                rescheduleFixture, transferPlayer, loanPlayer, recallPlayer, createPlayer, updatePlayer, setPlayerInjury, retirePlayer, unretirePlayer, promoteFormerTeam, 
                    promoteNewTeam, updateTeam }}>
            {!loading && children}
        </SnsGovernanceContext.Provider>
    );
};
