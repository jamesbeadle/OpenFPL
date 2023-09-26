import React, { useState, useContext } from 'react';
import { Form } from 'react-bootstrap';
import { DataContext } from "../../../../contexts/DataContext";

const TransferPlayerProposal = ({ sendDataToParent }) => {
    const { players, teams } = useContext(DataContext);
    const [selectedPlayer, setSelectedPlayer] = useState("");
    const [newTeamId, setNewTeamId] = useState("");

    useEffect(() => {
        sendDataToParent({
            player: selectedPlayer,
            newTeamId
        });
    }, [selectedPlayer, newTeamId]);

    return (
        <div>
            <Form.Group className="mb-3">
                <Form.Label>Player</Form.Label>
                <Form.Control as="select" value={selectedPlayer} onChange={e => setSelectedPlayer(e.target.value)}>
                    <option disabled value="">Select a player</option>
                    {players.map((player, index) => (
                        <option key={index} value={player.id}>{player.name}</option>
                    ))}
                </Form.Control>
            </Form.Group>

            <Form.Group className="mb-3">
                <Form.Label>New Team</Form.Label>
                <Form.Control as="select" value={newTeamId} onChange={e => setNewTeamId(e.target.value)}>
                    <option disabled value="">Select a team</option>
                    {teams.map((team, index) => (
                        <option key={index} value={team.id}>{team.name}</option>
                    ))}
                </Form.Control>
            </Form.Group>
        </div>
    );
};

export default TransferPlayerProposal;
