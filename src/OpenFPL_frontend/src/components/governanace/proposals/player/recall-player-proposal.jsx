import React, { useState, useContext } from 'react';
import { Form } from 'react-bootstrap';
import { DataContext } from "../../../../contexts/DataContext";

const RecallPlayerProposal = ({ sendDataToParent }) => {
    const { players } = useContext(DataContext);
    const [selectedPlayer, setSelectedPlayer] = useState("");

    useEffect(() => {
        sendDataToParent({
            player: selectedPlayer
        });
    }, [selectedPlayer]);

    return (
        <div>
            <Form.Group className="mb-3">
                <Form.Label>Player to Recall</Form.Label>
                <Form.Control as="select" value={selectedPlayer} onChange={e => setSelectedPlayer(e.target.value)}>
                    <option disabled value="">Select a player</option>
                    {players.map((player, index) => (
                        <option key={index} value={player.id}>{player.name}</option>
                    ))}
                </Form.Control>
            </Form.Group>
        </div>
    );
};

export default RecallPlayerProposal;
