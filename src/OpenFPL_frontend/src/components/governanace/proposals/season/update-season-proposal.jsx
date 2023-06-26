import React, { useState } from 'react';
import { Form, Button } from 'react-bootstrap';

const UpdateSeasonProposal = () => {
    const [seasons, setSeasons] = useState([]);
    const [selectedSeason, setSelectedSeason] = useState("");
    const [seasonName, setSeasonName] = useState("");
    const [startYear, setStartYear] = useState("");

    return (
        <div>
            <Form.Group className="mb-3">
                <Form.Label>Season</Form.Label>
                <Form.Control as="select" value={selectedSeason} onChange={(e) => setSelectedSeason(e.target.value)}>
                    <option disabled value="">Select a season</option>
                    {seasons.map((season, index) => (
                    <option key={index} value={season.id}>{season.name}</option>
                    ))}
                </Form.Control>
            </Form.Group>

            <Form.Group className="mb-3">
                <Form.Label>Season Name</Form.Label>
                <Form.Control type="text" placeholder="Enter season name" value={seasonName} onChange={(e) => setSeasonName(e.target.value)} />
            </Form.Group>

            <Form.Group className="mb-3">
                <Form.Label>Start Year</Form.Label>
                <Form.Control type="number" placeholder="Enter start year" value={startYear} onChange={(e) => setStartYear(e.target.value)} />
            </Form.Group>

            <Button variant="primary" type="submit">
                Submit
            </Button>
        </div>
    );
};

export default UpdateSeasonProposal;
