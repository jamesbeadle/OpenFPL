import React, { useState, useEffect } from 'react';
import { Form, Checkbox } from 'react-bootstrap';

const PlayerInjuryProposal = () => {
    const [teams, setTeams] = useState([]);
    const [players, setPlayers] = useState([]);
    const [selectedTeam, setSelectedTeam] = useState("");
    const [selectedPlayer, setSelectedPlayer] = useState("");
    const [isInjured, setIsInjured] = useState(false);

    useEffect(() => {
        // Fetch the teams data from your backend
        fetchTeamsFromBackend()
        .then(data => setTeams(data))
        .catch(err => console.error(err));
    }, []);

    useEffect(() => {
        // Fetch the players data from your backend
        fetchPlayersFromBackend(selectedTeam)
        .then(data => setPlayers(data))
        .catch(err => console.error(err));
    }, [selectedTeam]);

    const fetchTeamsFromBackend = async () => {
        // Replace with your actual data fetching logic
        const data = [{id: 1, name: "Arsenal"}];
        return data;
    }

    const fetchPlayersFromBackend = async (teamId) => {
        // Replace with your actual data fetching logic
        const data = [{id: 1, name: "Player 1", isInjured: true}];
        return data;
    }

    const handlePlayerSelect = (e) => {
        const playerId = parseInt(e.target.value, 10); // Parse to integer
        const player = players.find(player => player.id === playerId); // Match with integer id
        if (player) {
          setSelectedPlayer(player.id);
          setIsInjured(player.isInjured);
        } else {
          console.error('Player not found:', playerId);
        }
    }
    

    return (
        <div>
            <Form.Group className="mb-3">
                <Form.Label>Team</Form.Label>
                <Form.Control as="select" value={selectedTeam} onChange={(e) => setSelectedTeam(e.target.value)}>
                    <option disabled value="">Select a team</option>
                    {teams.map((team, index) => (
                    <option key={index} value={team.id}>{team.name}</option>
                    ))}
                </Form.Control>
            </Form.Group>

            <Form.Group className="mb-3">
                <Form.Label>Player</Form.Label>
                <Form.Control as="select" value={selectedPlayer} onChange={handlePlayerSelect}>
                    <option disabled value="">Select a player</option>
                    {players.map((player, index) => (
                    <option key={index} value={player.id}>{player.name}</option>
                    ))}
                </Form.Control>
            </Form.Group>

            {isInjured && (
                <Form.Group className="mb-3">
                    <Form.Check 
                        type="checkbox"
                        label="Mark as not injured"
                    />
                </Form.Group>
            )}

            <Form.Group className="mb-3">
                <Form.Label>Injury End Date</Form.Label>
                <Form.Control type="date" />
            </Form.Group>

            <Form.Group className="mb-3">
                <Form.Label>Injury Description</Form.Label>
                <Form.Control as="textarea" rows={3} />
            </Form.Group>
        </div>
    );
};

export default PlayerInjuryProposal;
