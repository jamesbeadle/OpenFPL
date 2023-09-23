import React, { useState, useContext } from 'react';
import { Form } from 'react-bootstrap';
import { DataContext } from "../../../../contexts/DataContext";
import { dateToUnixNanoseconds } from "../../../helpers";

const SetPlayerInjuryProposal = ({ sendDataToParent }) => {
    const { players } = useContext(DataContext);
    const [selectedPlayer, setSelectedPlayer] = useState("");
    const [description, setDescription] = useState("");
    const [expectedEndDate, setExpectedEndDate] = useState("");

    useEffect(() => {
        sendDataToParent({
            player: selectedPlayer,
            description,
            expectedEndDate: dateToUnixNanoseconds(expectedEndDate)
        });
    }, [selectedPlayer, description, expectedEndDate]);

    return (
        <div>
            <Form.Group className="mb-3">
                <Form.Label>Select Player</Form.Label>
                <Form.Control as="select" value={selectedPlayer} onChange={e => setSelectedPlayer(e.target.value)}>
                    <option disabled value="">Choose a player</option>
                    {players.map((player, index) => (
                        <option key={index} value={player.id}>{player.firstName} {player.lastName}</option>
                    ))}
                </Form.Control>
            </Form.Group>

            <Form.Group className="mb-3">
                <Form.Label>Description of Injury</Form.Label>
                <Form.Control type="text" value={description} onChange={e => setDescription(e.target.value)} />
            </Form.Group>

            <Form.Group className="mb-3">
                <Form.Label>Expected End Date of Injury</Form.Label>
                <Form.Control type="date" value={expectedEndDate} onChange={e => setExpectedEndDate(e.target.value)} />
            </Form.Group>
        </div>
    );
};

export default SetPlayerInjuryProposal;
