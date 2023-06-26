import React, { useState, useEffect } from 'react';
import { Form, Button } from 'react-bootstrap';

const CreateFixtureProposal = () => {
    const [seasons, setSeasons] = useState([]);
    const [selectedSeason, setSelectedSeason] = useState("");
    const [teams, setTeams] = useState([]);
    const [selectedHomeTeam, setSelectedHomeTeam] = useState("");
    const [selectedAwayTeam, setSelectedAwayTeam] = useState("");
    const [fixtureDate, setFixtureDate] = useState("");
    const gameWeeks = Array.from({length: 38}, (_, i) => i + 1); // Creates an array of game weeks from 1 to 38
    const [selectedGameWeek, setSelectedGameWeek] = useState("");

    useEffect(() => {
        // Fetch the seasons and teams data from your backend
        fetchSeasonsFromBackend()
        .then(data => setSeasons(data))
        .catch(err => console.error(err));

        fetchTeamsFromBackend()
        .then(data => setTeams(data))
        .catch(err => console.error(err));
    }, []);

    const fetchSeasonsFromBackend = async () => {
        const data = [{id: 1, name: "2022/23"}, {id: 2, name: "2023/24"}];
        return data;
    }

    const fetchTeamsFromBackend = async () => {
        const data = [{id: 1, name: "Arsenal"}, {id: 2, name: "Chelsea"}];
        return data;
    }

    const handleSubmit = (e) => {
        e.preventDefault();

        // Handle the submit action here
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
                <Form.Label>Game Week</Form.Label>
                <Form.Control as="select" value={selectedGameWeek} onChange={(e) => setSelectedGameWeek(e.target.value)}>
                    <option disabled value="">Select a game week</option>
                    {gameWeeks.map((gameWeek, index) => (
                    <option key={index} value={gameWeek}>{`Game Week ${gameWeek}`}</option>
                    ))}
                </Form.Control>
            </Form.Group>

            <Form.Group className="mb-3">
                <Form.Label>Home Team</Form.Label>
                <Form.Control as="select" value={selectedHomeTeam} onChange={(e) => setSelectedHomeTeam(e.target.value)}>
                    <option disabled value="">Select a home team</option>
                    {teams.map((team, index) => (
                    <option key={index} value={team.id}>{team.name}</option>
                    ))}
                </Form.Control>
            </Form.Group>

            <Form.Group className="mb-3">
                <Form.Label>Away Team</Form.Label>
                <Form.Control as="select" value={selectedAwayTeam} onChange={(e) => setSelectedAwayTeam(e.target.value)}>
                    <option disabled value="">Select an away team</option>
                    {teams.map((team, index) => (
                    <option key={index} value={team.id}>{team.name}</option>
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
    
    export default CreateFixtureProposal;
    
