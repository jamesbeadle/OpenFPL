import React, { useState, useEffect } from 'react';
import { Form, Button } from 'react-bootstrap';

const RemoveSeasonProposal = () => {

    const [seasons, setSeasons] = useState([]);
    const [selectedSeason, setSelectedSeason] = useState("");

    useEffect(() => {
        // fetch the data from your backend
        fetchSeasonsFromBackend()
        .then(data => setSeasons(data))
        .catch(err => console.error(err));
    }, []);
    
    const fetchSeasonsFromBackend = async () => {
        // Replace with your actual data fetching logic
        const data = [{id: 1, name: "2023/2024"}, {id: 2, name: "2022/2023"}];
        return data;
    }

    const handleRemoveSeason = () => {
        // Add your logic to remove the selected season
        console.log(`Remove the season: ${selectedSeason}`);
    }

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

            <Button variant="danger" onClick={handleRemoveSeason}>Remove Season</Button>
        </div>
    );
};

export default RemoveSeasonProposal;
