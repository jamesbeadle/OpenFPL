import React, { useState } from 'react';
import { Form, Button } from 'react-bootstrap';

const AddMemberProposal = () => {
    const [principalId, setPrincipalId] = useState("");

    return (
        <div>
            <Form.Group className="mb-3">
                <Form.Label>Principal ID</Form.Label>
                <Form.Control type="text" placeholder="Enter principal id" value={principalId} onChange={(e) => setPrincipalId(e.target.value)} />
            </Form.Group>

            <Button variant="primary" type="submit">
                Submit
            </Button>
        </div>
    );
};

export default AddMemberProposal;
