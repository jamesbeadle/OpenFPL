import React, { useState, useEffect } from 'react';
import { Form, Button } from 'react-bootstrap';

const PromoteTeamProposal = () => {
    const [relegatedTeams, setRelegatedTeams] = useState([]);
    const [selectedTeam, setSelectedTeam] = useState("");
    const [newTeamName, setNewTeamName] = useState("");
    const [newProperTeamName, setNewProperTeamName] = useState("");
    const [homeColour, setHomeColour] = useState("#FFFFFF");
    const [awayColour, setAwayColour] = useState("#000000");
    const [seasons, setSeasons] = useState([]);
    const [selectedSeason, setSelectedSeason] = useState("");

    useEffect(() => {
        // Fetch the relegated teams and seasons data from your backend
        fetchRelegatedTeamsFromBackend()
        .then(data => setRelegatedTeams(data))
        .catch(err => console.error(err));

        fetchSeasonsFromBackend()
        .then(data => setSeasons(data))
        .catch(err => console.error(err));
    }, []);

    // Replace these functions with your actual data fetching logic
    const fetchRelegatedTeamsFromBackend = async () => {
        const data = [{id: 1, name: "Team 1"}, {id: 2, name: "Team 2"}];
        return data;
    }

    const fetchSeasonsFromBackend = async () => {
        const data = [{id: 1, name: "2022/23"}, {id: 2, name: "2023/24"}];
        return data;
    }

    return (
        <div>
            <Form.Group className="mb-3">
                <Form.Label>Team</Form.Label>
                <Form.Control as="select" value={selectedTeam} onChange={(e) => setSelectedTeam(e.target.value)}>
                    <option disabled value="">Select a team</option>
                    {relegatedTeams.map((team, index) => (
                    <option key={index} value={team.id}>{team.name}</option>
                    ))}
                </Form.Control>
                <Form.Text className="text-muted">
                    Or add a new team
                </Form.Text>
                <Form.Control type="text" placeholder="Enter new team proper name" value={newProperTeamName} onChange={(e) => setNewProperTeamName(e.target.value)} />
                <Form.Control type="text" placeholder="Enter new team simple name" value={newTeamName} onChange={(e) => setNewTeamName(e.target.value)} />
            </Form.Group>

            <Form.Group className="mb-3">
                <Form.Label>Home Colour</Form.Label>
                <Form.Control type="color" value={homeColour} onChange={(e) => setHomeColour(e.target.value)} />
            </Form.Group>

            <Form.Group className="mb-3">
                <Form.Label>Away Colour</Form.Label>
                <Form.Control type="color" value={awayColour} onChange={(e) => setAwayColour(e.target.value)} />
            </Form.Group>

            <Form.Group className="mb-3">
                <Form.Label>Season</Form.Label>
                <Form.Control as="select" value={selectedSeason} onChange={(e) => setSelectedSeason(e.target.value)}>
                    <option disabled value="">Select a season</option>
                    {seasons.map((season, index) => (
                    <option key={index} value={season.id}>{season.name}</option>
                    ))}
                </Form.Control>
            </Form.Group>

            <Button variant="primary" type="submit">
                Submit
            </Button>
        </div>
    );
};

export default PromoteTeamProposal;

