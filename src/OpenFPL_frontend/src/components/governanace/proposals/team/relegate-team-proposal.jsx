import React, { useState, useEffect } from 'react';
import { Form, Button } from 'react-bootstrap';

const RelegateTeamProposal = () => {
    const [currentSeasonTeams, setCurrentSeasonTeams] = useState([]);
    const [selectedTeam, setSelectedTeam] = useState("");
    const [seasons, setSeasons] = useState([]);
    const [selectedSeason, setSelectedSeason] = useState("");

    useEffect(() => {
        // Fetch the current season teams and seasons data from your backend
        fetchCurrentSeasonTeamsFromBackend()
        .then(data => setCurrentSeasonTeams(data))
        .catch(err => console.error(err));

        fetchSeasonsFromBackend()
        .then(data => setSeasons(data))
        .catch(err => console.error(err));
    }, []);

    // Replace these functions with your actual data fetching logic
    const fetchCurrentSeasonTeamsFromBackend = async () => {
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
                    {currentSeasonTeams.map((team, index) => (
                    <option key={index} value={team.id}>{team.name}</option>
                    ))}
                </Form.Control>
            </Form.Group>

            <Form.Group className="mb-3">
                <Form.Label>Relegation Season</Form.Label>
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

export default RelegateTeamProposal;
