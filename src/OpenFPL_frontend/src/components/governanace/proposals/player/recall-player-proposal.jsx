import React, { useState, useEffect, useContext } from 'react';
import { Form, Button, Alert } from 'react-bootstrap';
import { OpenFPL_backend as open_fpl_backend } from '../../../../../../declarations/OpenFPL_backend';
import { Actor } from "@dfinity/agent";
import { AuthContext } from "../../../../contexts/AuthContext";

const RecallPlayerProposal = () => {
    const { authClient } = useContext(AuthContext);

    const [teams, setTeams] = useState([]);
    const [selectedTeam, setSelectedTeam] = useState("");
    const [loanedPlayers, setLoanedPlayers] = useState([]);
    const [selectedPlayer, setSelectedPlayer] = useState("");
    const [submitStatus, setSubmitStatus] = useState(null);

    useEffect(() => {
        fetchTeamsFromBackend()
        .then(data => setTeams(data))
        .catch(err => console.error(err));
    }, []);

    useEffect(() => {
        if (selectedTeam) {
            fetchLoanedPlayersFromBackend(selectedTeam)
            .then(data => setLoanedPlayers(data))
            .catch(err => console.error(err));
        }
    }, [selectedTeam]);

    const fetchTeamsFromBackend = async () => {
        // Fetch teams logic
    }

    const fetchLoanedPlayersFromBackend = async (teamId) => {
        // Fetch loaned players for the given teamId logic
    }

    const handleRecallPlayer = async (e) => {
        e.preventDefault();

        if (!selectedPlayer) {
            setSubmitStatus("Please select a player to recall.");
            return;
        }

        try {
            await open_fpl_backend.recallLoanedPlayer(selectedPlayer);
            setSubmitStatus("Player recalled successfully!");
        } catch (error) {
            console.error("Error while recalling player: ", error);
            setSubmitStatus("Failed to recall player. Please try again.");
        }
    }

    return (
        <div>
            <Form onSubmit={handleRecallPlayer}>
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
                    <Form.Label>Loaned Players</Form.Label>
                    <Form.Control as="select" value={selectedPlayer} onChange={(e) => setSelectedPlayer(e.target.value)}>
                        <option disabled value="">Select a player</option>
                        {loanedPlayers.map((player) => (
                            <option key={player.id} value={player.id}>{player.firstName} {player.lastName}</option>
                        ))}
                    </Form.Control>
                </Form.Group>

                {submitStatus && <Alert variant={submitStatus.includes("successfully") ? "success" : "danger"}>{submitStatus}</Alert>}

                <Button variant="primary" type="submit">
                    Recall Player
                </Button>
            </Form>
        </div>
    );
};

export default RecallPlayerProposal;
