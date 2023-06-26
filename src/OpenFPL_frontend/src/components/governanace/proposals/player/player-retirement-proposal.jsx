import React, { useState, useEffect } from 'react';
import { Form, ListGroup } from 'react-bootstrap';

const PlayerRetirementProposal = () => {
    const [teams, setTeams] = useState([]);
    const [retiredPlayers, setRetiredPlayers] = useState([]);
    const [searchTerm, setSearchTerm] = useState('');
    const [selectedPlayer, setSelectedPlayer] = useState(null);
    const [selectedTeam, setSelectedTeam] = useState("");

    useEffect(() => {
        // Fetch the teams data from your backend
        fetchTeamsFromBackend()
        .then(data => setTeams(data))
        .catch(err => console.error(err));
    }, []);

    useEffect(() => {
        // Fetch the players data from your backend
        fetchRetiredPlayersFromBackend(searchTerm)
        .then(data => setRetiredPlayers(data))
        .catch(err => console.error(err));
    }, [searchTerm]);

    const fetchTeamsFromBackend = async () => {
        // Replace with your actual data fetching logic
        const data = [{id: 1, name: "Arsenal"}];
        return data;
    }

    const fetchRetiredPlayersFromBackend = async (searchTerm) => {
        // Replace with your actual data fetching logic
        const data = [{id: 1, surname: "Player 1", isRetired: true}];
        return data;
    }

    const handlePlayerSelect = (playerId) => {
        const player = retiredPlayers.find(player => player.id === playerId);
        setSelectedPlayer(player);
    }

    const filteredPlayers = retiredPlayers.filter(player =>
        player.surname.toLowerCase().includes(searchTerm.toLowerCase())
    );

    return (
        <div>
            <Form.Group className="mb-3">
                <Form.Label>Player Surname</Form.Label>
                <Form.Control type="text" placeholder="Search by surname" onChange={(e) => setSearchTerm(e.target.value)} />
                <ListGroup>
                    {filteredPlayers.map((player, index) => (
                    <ListGroup.Item key={index} action onClick={() => handlePlayerSelect(player.id)}>
                        {player.surname}
                    </ListGroup.Item>
                    ))}
                </ListGroup>
            </Form.Group>

            {selectedPlayer && (
                <>
                    <Form.Group className="mb-3">
                        <Form.Label>Player Status</Form.Label>
                        <Form.Check 
                            type="radio"
                            label="Retire Player"
                            name="playerStatusRadio"
                            id="playerStatusRadio1"
                        />
                        <Form.Check 
                            type="radio"
                            label="Unretire Player"
                            name="playerStatusRadio"
                            id="playerStatusRadio2"
                        />
                    </Form.Group>
                    
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
                        <Form.Label>Player Value (in millions)</Form.Label>
                        <Form.Control 
                            type="number" 
                            step="0.1" 
                            placeholder="Enter player value" 
                            onChange={(e) => setPlayerValue(parseFloat(e.target.value))}
                        />
                    </Form.Group>
                </>
            )}
        </div>
    );
};

export default PlayerRetirementProposal;
