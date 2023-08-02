import React, { useState, useEffect, useContext } from 'react';
import { Form, Button, Alert } from 'react-bootstrap';
import { OpenFPL_backend as open_fpl_backend } from '../../../../../../declarations/OpenFPL_backend';
import { Actor } from "@dfinity/agent";
import { AuthContext } from "../../../../contexts/AuthContext";

const PlayerInjuryProposal = () => {
    const { authClient } = useContext(AuthContext);

    const [teams, setTeams] = useState([]);
    const [selectedTeam, setSelectedTeam] = useState("");
    const [players, setPlayers] = useState([]);
    const [selectedPlayer, setSelectedPlayer] = useState("");
    const [injuryDescription, setInjuryDescription] = useState("");
    const [expectedEndDate, setExpectedEndDate] = useState("");
    const [submitStatus, setSubmitStatus] = useState(null);

    useEffect(() => {
        fetchTeamsFromBackend()
        .then(data => setTeams(data))
        .catch(err => console.error(err));
    }, []);

    useEffect(() => {
        if (selectedTeam) {
            fetchPlayersFromBackend(selectedTeam)
            .then(data => setPlayers(data))
            .catch(err => console.error(err));
        }
    }, [selectedTeam]);

    const fetchTeamsFromBackend = async () => {
        // Fetch teams logic
    }

    const fetchPlayersFromBackend = async (teamId) => {
        // Fetch players for the given teamId logic
    }

    const handleSetInjury = async (e) => {
        e.preventDefault();

        if (!selectedPlayer || !injuryDescription || !expectedEndDate) {
            setSubmitStatus("Please provide all the required fields.");
            return;
        }

        try {
            const injuryData = {
                description: injuryDescription,
                expectedEndDate: parseInt(expectedEndDate)
            };

            await open_fpl_backend.setPlayerInjury(selectedPlayer, injuryData);
            setSubmitStatus("Player injury successfully set!");
        } catch (error) {
            console.error("Error while setting player injury: ", error);
            setSubmitStatus("Failed to set player injury. Please try again.");
        }
    }

    return (
        <div>
            <Form onSubmit={handleSetInjury}>
                <Form.Group className="mb-3">
                    <Form.Label>Teams</Form.Label>
                    <Form.Control as="select" value={selectedTeam} onChange={(e) => setSelectedTeam(e.target.value)}>
                        <option disabled value="">Select a team</option>
                        {teams.map((team) => (
                            <option key={team.id} value={team.id}>{team.name}</option>
                        ))}
                    </Form.Control>
                </Form.Group>

                <Form.Group className="mb-3">
                    <Form.Label>Players</Form.Label>
                    <Form.Control as="select" value={selectedPlayer} onChange={(e) => setSelectedPlayer(e.target.value)}>
                        <option disabled value="">Select a player</option>
                        {players.map((player) => (
                            <option key={player.id} value={player.id}>{player.firstName} {player.lastName}</option>
                        ))}
                    </Form.Control>
                </Form.Group>

                <Form.Group className="mb-3">
                    <Form.Label>Injury Description</Form.Label>
                    <Form.Control type="text" value={injuryDescription} onChange={(e) => setInjuryDescription(e.target.value)} />
                </Form.Group>

                <Form.Group className="mb-3">
                    <Form.Label>Expected End Date</Form.Label>
                    <Form.Control type="date" value={expectedEndDate} onChange={(e) => setExpectedEndDate(e.target.value)} />
                </Form.Group>

                {submitStatus && <Alert variant={submitStatus.includes("successfully") ? "success" : "danger"}>{submitStatus}</Alert>}

                <Button variant="primary" type="submit">
                    Set Player Injury
                </Button>
            </Form>
        </div>
    );
};

export default PlayerInjuryProposal;
