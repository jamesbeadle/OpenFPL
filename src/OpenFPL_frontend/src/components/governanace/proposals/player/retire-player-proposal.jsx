import React, { useState, useContext } from 'react';
import { Form } from 'react-bootstrap';
import { DataContext } from "../../../../contexts/DataContext";
import { dateToUnixNanoseconds } from "../../../helpers";

const RetirePlayerProposal = ({ sendDataToParent }) => {
    const { players } = useContext(DataContext);
    const [selectedPlayer, setSelectedPlayer] = useState("");
    const [retirementDate, setRetirementDate] = useState("");

    useEffect(() => {
        sendDataToParent({
            player: selectedPlayer,
            retirementDate: dateToUnixNanoseconds(retirementDate)
        });
    }, [selectedPlayer, retirementDate]);

    return (
        <div>
            <Form.Group className="mb-3">
                <Form.Label>Select Player to Retire</Form.Label>
                <Form.Control as="select" value={selectedPlayer} onChange={e => setSelectedPlayer(e.target.value)}>
                    <option disabled value="">Choose a player</option>
                    {players.map((player, index) => (
                        <option key={index} value={player.id}>{player.firstName} {player.lastName}</option>
                    ))}
                </Form.Control>
            </Form.Group>

            <Form.Group className="mb-3">
                <Form.Label>Retirement Date</Form.Label>
                <Form.Control type="date" value={retirementDate} onChange={e => setRetirementDate(e.target.value)} />
            </Form.Group>
        </div>
    );
};

export default RetirePlayerProposal;
