import React, { useState, useEffect, useContext } from 'react';
import { Form, Button, Alert } from 'react-bootstrap';
import { OpenFPL_backend as open_fpl_backend } from '../../../../../../declarations/OpenFPL_backend';
import { Actor } from "@dfinity/agent";
import { AuthContext } from "../../../../contexts/AuthContext";

const LoanPlayerProposal = () => {
    const { authClient } = useContext(AuthContext);

    const [teams, setTeams] = useState([]);
    const [selectedTeam, setSelectedTeam] = useState("");
    const [players, setPlayers] = useState([]);
    const [selectedPlayer, setSelectedPlayer] = useState("");
    const [loanToTeam, setLoanToTeam] = useState("");
    const [outsideLeague, setOutsideLeague] = useState(false);
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

    const handleLoanPlayer = async (e) => {
        e.preventDefault();

        if (!selectedPlayer || (outsideLeague === false && !loanToTeam)) {
            setSubmitStatus("Please provide all the required fields.");
            return;
        }

        try {
            const loanData = outsideLeague ? { outsideLeague: true } : { teamId: loanToTeam };

            await open_fpl_backend.loanPlayer(selectedPlayer, loanData);
            setSubmitStatus("Player loaned successfully!");
        } catch (error) {
            console.error("Error while loaning player: ", error);
            setSubmitStatus("Failed to loan player. Please try again.");
        }
    }

    return (
        <div>
            <Form onSubmit={handleLoanPlayer}>
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

                <Form.Check 
                    type="checkbox" 
                    label="Transferring Outside of League"
                    onChange={(e) => setOutsideLeague(e.target.checked)}
                    className="mb-3"
                />

                {!outsideLeague && (
                    <Form.Group className="mb-3">
                        <Form.Label>Loan to Team</Form.Label>
                        <Form.Control as="select" value={loanToTeam} onChange={(e) => setLoanToTeam(e.target.value)}>
                            <option disabled value="">Select a team</option>
                            {teams.filter(team => team.id !== selectedTeam).map((team) => (
                                <option key={team.id} value={team.id}>{team.name}</option>
                            ))}
                        </Form.Control>
                    </Form.Group>
                )}

                {submitStatus && <Alert variant={submitStatus.includes("successfully") ? "success" : "danger"}>{submitStatus}</Alert>}

                <Button variant="primary" type="submit">
                    Loan Player
                </Button>
            </Form>
        </div>
    );
};

export default LoanPlayerProposal;
