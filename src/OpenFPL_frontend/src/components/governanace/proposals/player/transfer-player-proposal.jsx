import React, { useState, useEffect } from 'react';
import { Form, Checkbox } from 'react-bootstrap';

const TransferPlayerProposal = () => {
    const [teams, setTeams] = useState([]);
    const [players, setPlayers] = useState([]);
    const [selectedTeamFrom, setSelectedTeamFrom] = useState("");
    const [selectedTeamTo, setSelectedTeamTo] = useState("");
    const [selectedPlayer, setSelectedPlayer] = useState("");
    const [outsidePL, setOutsidePL] = useState(false);

    useEffect(() => {
        // Fetch the teams data from your backend
        fetchTeamsFromBackend()
        .then(data => setTeams(data))
        .catch(err => console.error(err));
    }, []);

    useEffect(() => {
        // Fetch the players data from your backend
        fetchPlayersFromBackend(selectedTeamFrom)
        .then(data => setPlayers(data))
        .catch(err => console.error(err));
    }, [selectedTeamFrom]);

    const fetchTeamsFromBackend = async () => {
        // Replace with your actual data fetching logic
        const data = [{id: 1, name: "Arsenal"}];
        return data;
    }

    const fetchPlayersFromBackend = async (teamId) => {
        // Replace with your actual data fetching logic
        const data = [{id: 1, name: "Player 1"}];
        return data;
    }

    const handleOutsidePLChange = (e) => {
        setOutsidePL(e.target.checked);
        if (e.target.checked) {
          setSelectedTeamTo(""); // reset the selected team to if moving outside PL
        }
    }

    return (
        <div>
            <Form.Group className="mb-3">
                <Form.Label>From Team</Form.Label>
                <Form.Control as="select" value={selectedTeamFrom} onChange={(e) => setSelectedTeamFrom(e.target.value)}>
                    <option disabled value="">Select a team</option>
                    {teams.map((team, index) => (
                    <option key={index} value={team.id}>{team.name}</option>
                    ))}
                </Form.Control>
            </Form.Group>

            <Form.Group className="mb-3">
                <Form.Label>Player</Form.Label>
                <Form.Control as="select" value={selectedPlayer} onChange={(e) => setSelectedPlayer(e.target.value)}>
                    <option disabled value="">Select a player</option>
                    {players.map((player, index) => (
                    <option key={index} value={player.id}>{player.name}</option>
                    ))}
                </Form.Control>
            </Form.Group>

            <Form.Group className="mb-3">
                <Form.Check 
                    type="checkbox"
                    label="Moving to a team outside the Premier League"
                    onChange={handleOutsidePLChange}
                />
            </Form.Group>

            {!outsidePL && (
                <Form.Group className="mb-3">
                    <Form.Label>To Team</Form.Label>
                    <Form.Control as="select" value={selectedTeamTo} onChange={(e) => setSelectedTeamTo(e.target.value)}>
                        <option disabled value="">Select a team</option>
                        {teams.map((team, index) => (
                        <option key={index} value={team.id}>{team.name}</option>
                        ))}
                    </Form.Control>
                </Form.Group>
            )}
        </div>
    );
};

export default TransferPlayerProposal;
