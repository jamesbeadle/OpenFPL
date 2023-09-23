import React, { useState, useEffect } from 'react';
import { Form } from 'react-bootstrap';
import { DataContext } from "../../../../contexts/DataContext";

const RevaluePlayerUpProposal = ({ sendDataToParent }) => {
    const { players } = useContext(DataContext);
    const [selectedPlayer, setSelectedPlayer] = useState("");
    
    const handlePlayerSelect = (event) => {
        setSelectedPlayer(event.target.value);
        const playerToRevalue = players.find(p => p.id === event.target.value);
        sendDataToParent(playerToRevalue);
    };
    
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
        </div>
    );
};

export default RevaluePlayerUpProposal;
