import React, { useState, useContext } from 'react';
import { Form } from 'react-bootstrap';
import { DataContext } from "../../../../contexts/DataContext";

const UnretirePlayerProposal = ({ sendDataToParent }) => {
    const { retiredPlayers } = useContext(DataContext);
    const [selectedPlayer, setSelectedPlayer] = useState("");

    useEffect(() => {
        sendDataToParent({
            player: selectedPlayer
        });
    }, [selectedPlayer]);

    return (
        <div>
            <Form.Group className="mb-3">
                <Form.Label>Select Retired Player to Unretire</Form.Label>
                <Form.Control as="select" value={selectedPlayer} onChange={e => setSelectedPlayer(e.target.value)}>
                    <option disabled value="">Choose a player</option>
                    {retiredPlayers.map((player, index) => (
                        <option key={index} value={player.id}>{player.firstName} {player.lastName}</option>
                    ))}
                </Form.Control>
            </Form.Group>
        </div>
    );
};

export default UnretirePlayerProposal;
