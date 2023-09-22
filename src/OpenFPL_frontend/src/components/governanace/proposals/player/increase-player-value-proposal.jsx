import React, { useState, useEffect } from 'react';
import { Form } from 'react-bootstrap';

const IncreasePlayerValueProposal = () => {
    const [players, setPlayers] = useState([]);
    const [selectedPlayer, setSelectedPlayer] = useState("");
    const [playerValue, setPlayerValue] = useState(null);
    const [playerName, setPlayerName] = useState("");
    const [playerDOB, setPlayerDOB] = useState("");

    useEffect(() => {
        // Fetch the players data from your backend
        fetchPlayersFromBackend()
        .then(data => setPlayers(data))
        .catch(err => console.error(err));
    }, []);

    const fetchPlayersFromBackend = async () => {
        // Replace with your actual data fetching logic
        const data = [{id: 1, name: "Player 1", value: 10.0, dob: "2001-01-01"}];
        return data;
    }

    const handlePlayerSelect = (e) => {
        const playerId = parseInt(e.target.value, 10); // Parse to integer
        const player = players.find(player => player.id === playerId); // Match with integer id
        if (player) {
          setSelectedPlayer(player.id);
          setPlayerValue(player.value);
          setPlayerName(player.name);
          setPlayerDOB(player.dob);
        } else {
          console.error('Player not found:', playerId);
        }
    }

    return (
        <div>
            <Form.Group className="mb-3">
                <Form.Label>Player</Form.Label>
                <Form.Control as="select" value={selectedPlayer} onChange={handlePlayerSelect}>
                    <option disabled value="">Select a player</option>
                    {players.map((player, index) => (
                    <option key={index} value={player.id}>{player.name}</option>
                    ))}
                </Form.Control>
            </Form.Group>

            {selectedPlayer && (
                <>
                    <Form.Group className="mb-3">
                        <Form.Label>Player Name</Form.Label>
                        <Form.Control 
                            type="text" 
                            placeholder="Enter player name" 
                            value={playerName}
                            onChange={(e) => setPlayerName(e.target.value)}
                        />
                    </Form.Group>

                    <Form.Group className="mb-3">
                        <Form.Label>Player Date of Birth</Form.Label>
                        <Form.Control 
                            type="date" 
                            placeholder="Enter player date of birth" 
                            value={playerDOB}
                            onChange={(e) => setPlayerDOB(e.target.value)}
                        />
                    </Form.Group>

                    <Form.Group className="mb-3">
                        <Form.Label>Player Value (in millions)</Form.Label>
                        <Form.Control 
                            type="number" 
                            step="0.1" 
                            placeholder="Enter player value" 
                            value={playerValue}
                            onChange={(e) => setPlayerValue(parseFloat(e.target.value))}
                        />
                    </Form.Group>
                </>
            )}
        </div>
    );
};

export default IncreasePlayerValueProposal;
