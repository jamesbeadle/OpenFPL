import React, { useState, useEffect } from 'react';
import { Form } from 'react-bootstrap';

const AddPlayerProposal = () => {

    const [teams, setTeams] = useState([]);
    const [selectedTeam, setSelectedTeam] = useState("");

    useEffect(() => {
        // fetch the data from your backend
        // replace this with your actual data fetching logic
        fetchTeamsFromBackend()
        .then(data => setTeams(data))
        .catch(err => console.error(err));
    }, []);
    
    const fetchTeamsFromBackend = async () => {
        // Replace with your actual data fetching logic
        // This is just a placeholder
        const data = [{id: 1, name: "Arsenal"}];
        return data;
    }

    return (
        <div>
            <Form.Group className="mb-3">
                <Form.Label>Player Name</Form.Label>
                <Form.Control type="text" placeholder="Enter player name" />
            </Form.Group>

            <Form.Group className="mb-3">
                <Form.Label>Date of Birth</Form.Label>
                <Form.Control type="date" />
            </Form.Group>

            <Form.Group className="mb-3">
                <Form.Label>Team</Form.Label>
                <Form.Control as="select" value={selectedTeam} onChange={(e) => setSelectedTeam(e.target.value)}>
                    <option disabled value="">Select a team</option>
                    {teams.map((team, index) => (
                    <option key={index} value={team.id}>{team.name}</option>
                    ))}
                </Form.Control>
            </Form.Group>

            <Form.Group className="mb-3">
                <Form.Label>Position</Form.Label>
                <Form.Control as="select">
                <option>Select a position</option>
                <option>Goalkeeper</option>
                <option>Defender</option>
                <option>Midfielder</option>
                <option>Forward</option>
                </Form.Control>
            </Form.Group>

            <Form.Group className="mb-3">
                <Form.Label>Proposal Description</Form.Label>
                <Form.Control as="textarea" rows={3} />
            </Form.Group>
        </div>
    );
};

export default AddPlayerProposal;
