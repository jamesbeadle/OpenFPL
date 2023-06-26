import React, { useState, useEffect } from 'react';
import { Form, Button } from 'react-bootstrap';

const UpdateFixtureProposal = () => {
    const [seasons, setSeasons] = useState([]);
    const [selectedSeason, setSelectedSeason] = useState("");
    const [gameweeks, setGameweeks] = useState([]);
    const [selectedGameweek, setSelectedGameweek] = useState("");
    const [fixtures, setFixtures] = useState([]);
    const [selectedFixture, setSelectedFixture] = useState("");
    const [fixtureDate, setFixtureDate] = useState("");

    useEffect(() => {
        // Fetch the seasons, gameweeks, and fixtures data from your backend
        fetchSeasonsFromBackend()
        .then(data => setSeasons(data))
        .catch(err => console.error(err));
        
        fetchGameweeksFromBackend()
        .then(data => setGameweeks(data))
        .catch(err => console.error(err));
        
        fetchFixturesFromBackend()
        .then(data => setFixtures(data))
        .catch(err => console.error(err));
    }, []);

    const fetchSeasonsFromBackend = async () => {
        // Replace with your actual data fetching logic
        const data = [{id: 1, name: "2022/23"}, {id: 2, name: "2023/24"}];
        return data;
    }

    const fetchGameweeksFromBackend = async () => {
        // Replace with your actual data fetching logic
        const data = [...Array(38).keys()].map(i => ({id: i + 1, name: `Gameweek ${i + 1}`}));
        return data;
    }

    const fetchFixturesFromBackend = async () => {
        // Replace with your actual data fetching logic
        const data = [{id: 1, name: "Fixture 1"}, {id: 2, name: "Fixture 2"}];
        return data;
    }

    const handleUpdateFixture = (e) => {
        e.preventDefault();
        console.log(`Updated Fixture: ${selectedFixture} to Date: ${fixtureDate}`);
    }

    return (
        <Form onSubmit={handleUpdateFixture}>
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
                <Form.Label>Gameweek</Form.Label>
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
                    <option disabled value="">
                    Select a fixture
                    </option>
                    {fixtures.map((fixture, index) => (
                        <option key={index} value={fixture.id}>{fixture.name}</option>
                    ))}
                </Form.Control>
            </Form.Group>

            <Form.Group className="mb-3">
                <Form.Label>Fixture Date</Form.Label>
                <Form.Control type="date" value={fixtureDate} onChange={(e) => setFixtureDate(e.target.value)} />
            </Form.Group>

            <Button variant="primary" type="submit">
                Submit
            </Button>
        </Form>
    );
};

export default UpdateFixtureProposal;
