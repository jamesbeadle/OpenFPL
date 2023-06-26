import React, { useState, useEffect } from 'react';
import { Form, Button } from 'react-bootstrap';

const UpdateTeamProposal = () => {
    const [teams, setTeams] = useState([]);
    const [selectedTeam, setSelectedTeam] = useState("");
    const [teamProperName, setTeamProperName] = useState("");
    const [teamSimpleName, setTeamSimpleName] = useState("");
    const [homeColour, setHomeColour] = useState("");
    const [awayColour, setAwayColour] = useState("");

    useEffect(() => {
        // Fetch the teams data from your backend
        fetchTeamsFromBackend()
        .then(data => setTeams(data))
        .catch(err => console.error(err));
    }, []);

    // Replace this function with your actual data fetching logic
    const fetchTeamsFromBackend = async () => {
        const data = [{id: 1, properName: "Team Proper 1", simpleName: "Team 1", homeColour: "#FFFFFF", awayColour: "#000000"}];
        return data;
    }

    const handleTeamSelect = (e) => {
        const teamId = parseInt(e.target.value, 10); // Parse to integer
        const team = teams.find(team => team.id === teamId); // Match with integer id
        if (team) {
          setSelectedTeam(team.id);
          setTeamProperName(team.properName);
          setTeamSimpleName(team.simpleName);
          setHomeColour(team.homeColour);
          setAwayColour(team.awayColour);
        } else {
          console.error('Team not found:', teamId);
        }
    }

    return (
        <div>
            <Form.Group className="mb-3">
                <Form.Label>Team</Form.Label>
                <Form.Control as="select" value={selectedTeam} onChange={handleTeamSelect}>
                    <option disabled value="">Select a team</option>
                    {teams.map((team, index) => (
                    <option key={index} value={team.id}>{team.properName}</option>
                    ))}
                </Form.Control>
            </Form.Group>

            {selectedTeam && (
                <>
                    <Form.Group className="mb-3">
                        <Form.Label>Proper Name</Form.Label>
                        <Form.Control type="text" value={teamProperName} onChange={(e) => setTeamProperName(e.target.value)} />
                    </Form.Group>

                    <Form.Group className="mb-3">
                        <Form.Label>Simple Name</Form.Label>
                        <Form.Control type="text" value={teamSimpleName} onChange={(e) => setTeamSimpleName(e.target.value)} />
                    </Form.Group>

                    <Form.Group className="mb-3">
                        <Form.Label>Home Colour</Form.Label>
                        <Form.Control type="color" value={homeColour} onChange={(e) => setHomeColour(e.target.value)} />
                    </Form.Group>

                    <Form.Group className="mb-3">
                        <Form.Label>Away Colour</Form.Label>
                        <Form.Control type="color" value={awayColour} onChange={(e) => setAwayColour(e.target.value)} />
                    </Form.Group>

                    <Button variant="primary" type="submit">
                        Submit
                    </Button>
                </>
            )}
        </div>
    );
};

export default UpdateTeamProposal;
