import React, { useState, useEffect } from 'react';
import { Container, Table, Pagination, Form } from 'react-bootstrap';

const ClubLeagueStandings = () => {
    const [isLoading, setIsLoading] = useState(true);
    const [managers, setManagers] = useState([]);
    const [clubs, setClubs] = useState([]);
    const [selectedClub, setSelectedClub] = useState(null);
    const itemsPerPage = 10;

    useEffect(() => {
        const fetchData = async () => {
            const userFavoriteClub = await fetchUserFavoriteClub();
            const availableClubs = await fetchAvailableClubs();
            setClubs(availableClubs);
            setSelectedClub(userFavoriteClub || availableClubs[0]);
            await fetchManagerDataForClub(userFavoriteClub || availableClubs[0]);
            setIsLoading(false);
        };
        fetchData();
    }, []);

    const fetchUserFavoriteClub = async () => {
        // Fetch the user's favorite club from your backend.
        const response = await fetch('/api/user-favorite-club');
        const data = await response.json();
        return data.favoriteClub;
    };

    const fetchAvailableClubs = async () => {
        // Fetch the list of available clubs from your backend.
        const response = await fetch('/api/available-clubs');
        const data = await response.json();
        return data.clubs;
    };

    const fetchManagerDataForClub = async (club) => {
        // Fetch the data based on the selected club from your backend.
        const response = await fetch(`/api/managers-by-club/${club}`);
        const data = await response.json();
        setManagers(data.managers);
    };

    const renderedData = managers.slice(0, itemsPerPage).map(manager => (
        <tr key={manager.position}>
            <td>{manager.position}</td>
            <td>{manager.username}</td>
            <td>{manager.score}</td>
        </tr>
    ));

    return (
        <Container>
            <Form.Group controlId="clubSelect">
                <Form.Label>Select Club</Form.Label>
                <Form.Control as="select" value={selectedClub} onChange={e => setSelectedClub(e.target.value)}>
                    {clubs.map(club => (
                        <option key={club} value={club}>{club}</option>
                    ))}
                </Form.Control>
            </Form.Group>
            <Table striped bordered hover>
                <thead>
                    <tr>
                        <th>Position</th>
                        <th>Username</th>
                        <th>Score</th>
                    </tr>
                </thead>
                <tbody>
                    {renderedData}
                </tbody>
            </Table>
            {/* Placeholder for Pagination Component */}
            <Pagination>{/* Pagination items go here */}</Pagination>
        </Container>
    );
};

export default ClubLeagueStandings;
