import React, { useState, useEffect } from 'react';
import { Form, Button } from 'react-bootstrap';

const RemoveMemberProposal = () => {
    const [members, setMembers] = useState([]);
    const [selectedMember, setSelectedMember] = useState("");

    useEffect(() => {
        // Fetch the members data from your backend
        fetchMembersFromBackend()
        .then(data => setMembers(data))
        .catch(err => console.error(err));
    }, []);

    const fetchMembersFromBackend = async () => {
        // Replace with your actual data fetching logic
        const data = [{id: 1, principalId: "Member 1"}, {id: 2, principalId: "Member 2"}];
        return data;
    }

    return (
        <div>
            <Form.Group className="mb-3">
                <Form.Label>Member</Form.Label>
                <Form.Control as="select" value={selectedMember} onChange={(e) => setSelectedMember(e.target.value)}>
                    <option disabled value="">Select a member</option>
                    {members.map((member, index) => (
                    <option key={index} value={member.id}>{member.principalId}</option>
                    ))}
                </Form.Control>
            </Form.Group>

            <Button variant="primary" type="submit">
                Remove
            </Button>
        </div>
    );
};

export default RemoveMemberProposal;
