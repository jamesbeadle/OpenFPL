import React, { useState, useEffect } from 'react';
import { Form } from 'react-bootstrap';
import { DataContext } from "../../../../contexts/DataContext";

const IncreasePlayerValueProposal = () => {
    const { players } = useContext(DataContext);
  
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

export default IncreasePlayerValueProposal;
