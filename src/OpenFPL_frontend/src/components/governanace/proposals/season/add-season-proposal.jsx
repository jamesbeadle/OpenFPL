import React, { useState } from 'react';
import { Form, Button } from 'react-bootstrap';

const AddSeasonProposal = () => {

    const [seasonName, setSeasonName] = useState("");

    const handleAddSeason = () => {
        // Add your logic to add the new season
        console.log(`Add the season: ${seasonName}`);
    }

    return (
        <div>
            <Form.Group className="mb-3">
                <Form.Label>Season</Form.Label>
                <Form.Control 
                  type="text" 
                  value={seasonName} 
                  onChange={(e) => setSeasonName(e.target.value)} 
                  placeholder="Enter season name (e.g., 2023/2024)" 
                />
            </Form.Group>

            <Form.Group className="mb-3">
                <Form.Label>Start Year</Form.Label>
                <Form.Control type="number" placeholder="Enter start year" value={startYear} onChange={(e) => setStartYear(e.target.value)} />
            </Form.Group>

            <Button variant="primary" onClick={handleAddSeason}>Add Season</Button>
        </div>
    );
};

export default AddSeasonProposal;
