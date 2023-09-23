import React, { useState, useContext } from 'react';
import { Form } from 'react-bootstrap';
import { DataContext } from "../../../../contexts/DataContext";
import { dateToUnixNanoseconds } from "../../../helpers";

const AddPlayerProposal = ({ sendDataToParent }) => {
    const { teams } = useContext(DataContext);
    const [teamId, setTeamId] = useState("");
    const [position, setPosition] = useState("");
    const [firstName, setFirstName] = useState("");
    const [lastName, setLastName] = useState("");
    const [shirtNumber, setShirtNumber] = useState("");
    const [value, setValue] = useState("");
    const [dateOfBirth, setDateOfBirth] = useState("");
    const [nationality, setNationality] = useState("");

    useEffect(() => {
        sendDataToParent({
            teamId,
            position,
            firstName,
            lastName,
            shirtNumber,
            value,
            dateOfBirth: dateToUnixNanoseconds(dateOfBirth),
            nationality
        });
    }, [teamId, position, firstName, lastName, shirtNumber, value, dateOfBirth, nationality]);

    return (
        <div>
            <Form.Group className="mb-3">
                <Form.Label>Team</Form.Label>
                <Form.Control as="select" value={teamId} onChange={e => setTeamId(e.target.value)}>
                    <option disabled value="">Select a team</option>
                    {teams.map((team, index) => (
                        <option key={index} value={team.id}>{team.name}</option>
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
                <Form.Label>Value (£)</Form.Label>
                <Form.Control type="number" value={value} onChange={e => setValue(e.target.value)} />
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

export default AddPlayerProposal;
