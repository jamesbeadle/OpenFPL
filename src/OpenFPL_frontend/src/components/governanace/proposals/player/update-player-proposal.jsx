import React, { useState, useContext } from 'react';
import { Form } from 'react-bootstrap';
import { DataContext } from "../../../../contexts/DataContext";
import { dateToUnixNanoseconds } from "../../../helpers";

const UpdatePlayerProposal = ({ sendDataToParent }) => {
    const { players } = useContext(DataContext);
    const [selectedPlayer, setSelectedPlayer] = useState("");
    const [position, setPosition] = useState("");
    const [firstName, setFirstName] = useState("");
    const [lastName, setLastName] = useState("");
    const [shirtNumber, setShirtNumber] = useState("");
    const [dateOfBirth, setDateOfBirth] = useState("");
    const [nationality, setNationality] = useState("");

    useEffect(() => {
        sendDataToParent({
            player: selectedPlayer,
            position,
            firstName,
            lastName,
            shirtNumber,
            dateOfBirth: dateToUnixNanoseconds(dateOfBirth),
            nationality
        });
    }, [selectedPlayer, position, firstName, lastName, shirtNumber, dateOfBirth, nationality]);

    useEffect(() => {
        if (selectedPlayer) {
            const chosenPlayer = players.find(player => player.id === selectedPlayer);
            if (chosenPlayer) {
                setPosition(chosenPlayer.position);
                setFirstName(chosenPlayer.firstName);
                setLastName(chosenPlayer.lastName);
                setShirtNumber(chosenPlayer.shirtNumber);
                
                // Convert the date from Unix Nanoseconds to the required format for input type=date
                const dateFromNanoseconds = new Date(chosenPlayer.dateOfBirth / 1000000).toISOString().split('T')[0];
                setDateOfBirth(dateFromNanoseconds);
                
                setNationality(chosenPlayer.nationality);
            }
        }
    }, [selectedPlayer, players]);

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
                <Form.Label>Position</Form.Label>
                <Form.Control type="text" value={position} onChange={e => setPosition(e.target.value)} />
            </Form.Group>

            <Form.Group className="mb-3">
                <Form.Label>First Name</Form.Label>
                <Form.Control type="text" value={firstName} onChange={e => setFirstName(e.target.value)} />
            </Form.Group>

            <Form.Group className="mb-3">
                <Form.Label>Last Name</Form.Label>
                <Form.Control type="text" value={lastName} onChange={e => setLastName(e.target.value)} />
            </Form.Group>

            <Form.Group className="mb-3">
                <Form.Label>Shirt Number</Form.Label>
                <Form.Control type="number" value={shirtNumber} onChange={e => setShirtNumber(e.target.value)} />
            </Form.Group>

            <Form.Group className="mb-3">
                <Form.Label>Date of Birth</Form.Label>
                <Form.Control type="date" value={dateOfBirth} onChange={e => setDateOfBirth(e.target.value)} />
            </Form.Group>

            <Form.Group className="mb-3">
                <Form.Label>Nationality</Form.Label>
                <Form.Control type="text" value={nationality} onChange={e => setNationality(e.target.value)} />
            </Form.Group>
        </div>
    );
};

export default UpdatePlayerProposal;
