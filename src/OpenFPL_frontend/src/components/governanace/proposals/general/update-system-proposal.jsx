import React, { useState } from 'react';
import { Form, Button } from 'react-bootstrap';

const UpdateSystemProposal = () => {
    const [description, setDescription] = useState("");

    const handleSubmit = (e) => {
        e.preventDefault();
    }

    return (
        <Form onSubmit={handleSubmit}>
            <Form.Group className="mb-3">
                <Form.Label>System Update Description</Form.Label>
                <Form.Control 
                    as="textarea" 
                    rows={3} 
                    placeholder="Describe the system update" 
                    value={description} 
                    onChange={(e) => setDescription(e.target.value)}
                    required
                />
            </Form.Group>

            <Button variant="primary" type="submit">
                Submit
            </Button>
        </Form>
    );
};

export default UpdateSystemProposal;
