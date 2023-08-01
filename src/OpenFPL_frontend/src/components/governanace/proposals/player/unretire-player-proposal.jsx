import React, { useState, useContext, useEffect } from 'react';
import { Form, Button, Alert } from 'react-bootstrap';
import { OpenFPL_backend as open_fpl_backend } from '../../../../declarations/OpenFPL_backend';
import { Actor } from "@dfinity/agent";
import { AuthContext } from "../../contexts/AuthContext";

const UnretirePlayerProposal = () => {
    const { authClient } = useContext(AuthContext);

    const [retiredPlayers, setRetiredPlayers] = useState([]);
    const [selectedPlayer, setSelectedPlayer] = useState("");
    const [submitStatus, setSubmitStatus] = useState(null);

    useEffect(() => {
        fetchRetiredPlayersFromBackend()
        .then(data => setRetiredPlayers(data))
        .catch(err => console.error(err));
    }, []);

    const fetchRetiredPlayersFromBackend = async () => {
        try {
            // Replace with your actual data fetching logic for retired players
            const data = await open_fpl_backend.getRetiredPlayers();
            return data;
        } catch (error) {
            console.error("Error fetching retired players: ", error);
            return [];
        }
    }

    const handleUnretirePlayer = async (e) => {
        e.preventDefault();

        if (!selectedPlayer) {
            setSubmitStatus("Please select a player to unretire.");
            return;
        }

        try {
            await open_fpl_backend.unretirePlayer(selectedPlayer);
            setSubmitStatus("Player successfully unretired!");
            // Optionally, remove the unretired player from the local state
            setRetiredPlayers(prevPlayers => prevPlayers.filter(player => player.id !== selectedPlayer));
        } catch (error) {
            console.error("Error while unretiring player: ", error);
            setSubmitStatus("Failed to unretire player. Please try again.");
        }
    }

    return (
        <div>
            <Form onSubmit={handleUnretirePlayer}>
                <Form.Group className="mb-3">
                    <Form.Label>Retired Players</Form.Label>
                    <Form.Control as="select" value={selectedPlayer} onChange={(e) => setSelectedPlayer(e.target.value)}>
                        <option disabled value="">Select a player to unretire</option>
                        {retiredPlayers.map((player) => (
                            <option key={player.id} value={player.id}>{player.name}</option>
                        ))}
                    </Form.Control>
                </Form.Group>

                {submitStatus && <Alert variant={submitStatus.includes("successfully") ? "success" : "danger"}>{submitStatus}</Alert>}

                <Button variant="primary" type="submit">
                    Unretire Player
                </Button>
            </Form>
        </div>
    );
};

export default UnretirePlayerProposal;
