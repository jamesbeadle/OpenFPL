import React, { useState, useContext, useEffect } from 'react';
import { Form, Button, Alert } from 'react-bootstrap';
import { OpenFPL_backend as open_fpl_backend } from '../../../../declarations/OpenFPL_backend';
import { Actor } from "@dfinity/agent";
import { AuthContext } from "../../contexts/AuthContext";

const RetirePlayerProposal = () => {
    const { authClient } = useContext(AuthContext);

    const [teams, setTeams] = useState([]);
    const [selectedTeam, setSelectedTeam] = useState("");
    const [players, setPlayers] = useState([]);
    const [selectedPlayer, setSelectedPlayer] = useState("");
    const [submitStatus, setSubmitStatus] = useState(null);

    useEffect(() => {
        fetchTeamsFromBackend()
        .then(data => setTeams(data))
        .catch(err => console.error(err));
    }, []);

    const fetchTeamsFromBackend = async () => {
        try {
            // Replace with your actual data fetching logic for teams
            const data = await open_fpl_backend.getTeams();
            return data;
        } catch (error) {
            console.error("Error fetching teams: ", error);
            return [];
        }
    }

    const handleTeamChange = async (teamId) => {
        setSelectedTeam(teamId);
        
        // Fetch players for the selected team
        fetchPlayersFromBackend(teamId)
        .then(data => setPlayers(data))
        .catch(err => console.error(err));
    }

    const fetchPlayersFromBackend = async (teamId) => {
        try {
            // Replace with your actual data fetching logic for players
            const data = await open_fpl_backend.getPlayersByTeam(teamId);
            return data;
        } catch (error) {
            console.error("Error fetching players: ", error);
            return [];
        }
    }

    const handleRetirePlayer = async (e) => {
        e.preventDefault();

        if (!selectedPlayer) {
            setSubmitStatus("Please select a player to retire.");
            return;
        }

        try {
            await open_fpl_backend.retirePlayer(selectedPlayer);
            setSubmitStatus("Player successfully retired!");
        } catch (error) {
            console.error("Error while retiring player: ", error);
            setSubmitStatus("Failed to retire player. Please try again.");
        }
    }

    return (
        <div>
            <Form onSubmit={handleRetirePlayer}>
                <Form.Group className="mb-3">
                    <Form.Label>Team</Form.Label>
                    <Form.Control as="select" value={selectedTeam} onChange={(e) => handleTeamChange(e.target.value)}>
                        <option disabled value="">Select a team</option>
                        {teams.map((team) => (
                            <option key={team.id} value={team.id}>{team.name}</option>
                        ))}
                    </Form.Control>
                </Form.Group>

                {selectedTeam && (
                    <Form.Group className="mb-3">
                        <Form.Label>Player</Form.Label>
                        <Form.Control as="select" value={selectedPlayer} onChange={(e) => setSelectedPlayer(e.target.value)}>
                            <option disabled value="">Select a player</option>
                            {players.map((player) => (
                                <option key={player.id} value={player.id}>{player.name}</option>
                            ))}
                        </Form.Control>
                    </Form.Group>
                )}

                {submitStatus && <Alert variant={submitStatus.includes("successfully") ? "success" : "danger"}>{submitStatus}</Alert>}

                <Button variant="primary" type="submit">
                    Retire Player
                </Button>
            </Form>
        </div>
    );
};

export default RetirePlayerProposal;
