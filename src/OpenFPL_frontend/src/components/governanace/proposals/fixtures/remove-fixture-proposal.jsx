import React, { useState, useEffect } from 'react';
import { Form, Button } from 'react-bootstrap';

const RemoveFixtureProposal = () => {
    const [seasons, setSeasons] = useState([]);
    const [selectedSeason, setSelectedSeason] = useState("");
    const [gameweeks, setGameweeks] = useState([]);
    const [selectedGameweek, setSelectedGameweek] = useState("");
    const [fixtures, setFixtures] = useState([]);
    const [selectedFixture, setSelectedFixture] = useState("");

    useEffect(() => {
        fetchSeasonsFromBackend()
        .then(data => setSeasons(data))
        .catch(err => console.error(err));
    }, []);

    useEffect(() => {
        if (selectedSeason) {
            fetchGameweeksFromBackend()
            .then(data => setGameweeks(data))
            .catch(err => console.error(err));
        }
    }, [selectedSeason]);

    useEffect(() => {
        if (selectedGameweek) {
            fetchFixturesFromBackend()
            .then(data => setFixtures(data))
            .catch(err => console.error(err));
        }
    }, [selectedGameweek]);

    // Replace with your actual data fetching logic
    const fetchSeasonsFromBackend = async () => {
        const data = [{id: 1, name: "2023/24"}, {id: 2, name: "2024/25"}];
        return data;
    }

    const fetchGameweeksFromBackend = async () => {
        const data = Array.from({length: 38}, (_, i) => ({id: i+1, name: `Gameweek ${i+1}`}));
        return data;
    }

    const fetchFixturesFromBackend = async () => {
        const data = [{id: 1, name: "Fixture 1"}, {id: 2, name: "Fixture 2"}];
        return data;
    }

    const handleSubmit = (e) => {
        e.preventDefault();
        // Handle the form submission here
        console.log(`Removing fixture: ${selectedFixture}`);
    }

    return (
        <Form onSubmit={handleSubmit}>
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
                <Form.Label>Game week</Form.Label>
                <Form.Control as="select" value={selectedGameweek} onChange={(e) => setSelectedGameweek(e.target.value)}>
                    <option disabled value="">Select a gameweek</option>
                    {gameweeks.map((gameweek, index) => (
                        <option key={index} value={gameweek.id}>{gameweek.name}</option>
                    ))}
                </Form.Control>
            </Form.Group>

            <Form.Group className="mb-3">
                <Form.Label>Fixture</Form.Label>
                <Form.Control as="select" value={selectedFixture} onChange={(e) => setSelectedFixture(e.target.value)}>
                    <option disabled value="">Select a fixture</option>
                    {fixtures.map((fixture, index) => (
                        <option key={index} value={fixture.id}>{fixture.name}</option>
                    ))}
                </Form.Control>
            </Form.Group>

            <Button variant="primary" type="submit">
                Remove Fixture
            </Button>
        </Form>
    );
};

export default RemoveFixtureProposal;

