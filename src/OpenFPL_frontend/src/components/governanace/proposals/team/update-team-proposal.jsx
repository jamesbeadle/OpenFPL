import React, { useState, useContext } from 'react';
import { Form } from 'react-bootstrap';
import { DataContext } from "../../../../contexts/DataContext";

const UpdateTeamProposal = ({ sendDataToParent }) => {
    const { teams } = useContext(DataContext);

    const [teamId, setTeamId] = useState("");
    const [name, setName] = useState("");
    const [friendlyName, setFriendlyName] = useState("");
    const [abbreviatedName, setAbbreviatedName] = useState("");
    const [primaryHexColour, setPrimaryHexColour] = useState("");
    const [secondaryHexColour, setSecondaryHexColour] = useState("");
    const [thirdHexColour, setThirdHexColour] = useState("");

    useEffect(() => {
        sendDataToParent({
            teamId,
            name,
            friendlyName,
            abbreviatedName,
            primaryHexColour,
            secondaryHexColour,
            thirdHexColour
        });
    }, [teamId, name, friendlyName, abbreviatedName, primaryHexColour, secondaryHexColour, thirdHexColour]);

    return (
        <div>
            <Form.Group className="mb-3">
                <Form.Label>Team</Form.Label>
                <Form.Control as="select" value={teamId} onChange={e => setTeamId(e.target.value)}>
                    <option disabled value="">Select a team to update</option>
                    {teams.map((team, index) => (
                        <option key={index} value={team.id}>{team.name}</option>
                    ))}
                </Form.Control>
            </Form.Group>

            <Form.Group className="mb-3">
                <Form.Label>Team Name</Form.Label>
                <Form.Control type="text" value={name} onChange={e => setName(e.target.value)} />
            </Form.Group>

            <Form.Group className="mb-3">
                <Form.Label>Friendly Name</Form.Label>
                <Form.Control type="text" value={friendlyName} onChange={e => setFriendlyName(e.target.value)} />
            </Form.Group>

            <Form.Group className="mb-3">
                <Form.Label>Abbreviated Name</Form.Label>
                <Form.Control type="text" value={abbreviatedName} onChange={e => setAbbreviatedName(e.target.value)} />
            </Form.Group>

            <Form.Group className="mb-3">
                <Form.Label>Primary Colour (Hex)</Form.Label>
                <Form.Control type="color" value={primaryHexColour} onChange={e => setPrimaryHexColour(e.target.value)} />
            </Form.Group>

            <Form.Group className="mb-3">
                <Form.Label>Secondary Colour (Hex)</Form.Label>
                <Form.Control type="color" value={secondaryHexColour} onChange={e => setSecondaryHexColour(e.target.value)} />
            </Form.Group>

            <Form.Group className="mb-3">
                <Form.Label>Third Colour (Hex)</Form.Label>
                <Form.Control type="color" value={thirdHexColour} onChange={e => setThirdHexColour(e.target.value)} />
            </Form.Group>
        </div>
    );
};

export default UpdateTeamProposal;
