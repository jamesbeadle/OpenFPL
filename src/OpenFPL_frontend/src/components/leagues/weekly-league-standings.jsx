import React, { useState, useEffect } from 'react';
import { Container, Table, Pagination, Form } from 'react-bootstrap';

const WeeklyLeagueStandings = () => {
    const [isLoading, setIsLoading] = useState(true);
    const [managers, setManagers] = useState([]);
    const [currentGameweek, setCurrentGameweek] = useState(1);
    const [selectedGameweek, setSelectedGameweek] = useState(1);
    const itemsPerPage = 10;

    useEffect(() => {
        const fetchData = async () => {
            const activeGameweek = await fetchActiveGameweek();
            setSelectedGameweek(activeGameweek);
            await fetchManagerDataForWeek(activeGameweek);
            setIsLoading(false);
        };
        fetchData();
    }, []);

    const fetchActiveGameweek = async () => {
        // Fetch the active gameweek from your backend.
        const response = await fetch('/api/active-gameweek');
        const data = await response.json();
        return data.activeGameweek;
    };

    const fetchManagerDataForWeek = async (gameweek) => {
        // Fetch the data based on the selected gameweek from your backend.
        // Mocked up for demonstration purposes.
        const mockData = Array(100).fill(null).map((_, index) => ({
            position: index + 1,
            username: `manager${index + 1}`,
            score: Math.floor(Math.random() * 100) // Random score for the week
        }));
        setManagers(mockData);
    };

    // Placeholder for pagination and rendering logic
    const renderedData = managers.slice((currentPage - 1) * itemsPerPage, currentPage * itemsPerPage).map(manager => (
        <tr key={manager.position}>
            <td>{manager.position}</td>
            <td>{manager.username}</td>
            <td>{manager.score}</td>
        </tr>
    ));

    return (
        <Container>
            <Form.Group controlId="gameweekSelect">
                <Form.Label>Select Gameweek</Form.Label>
                <Form.Control as="select" value={selectedGameweek} onChange={e => setSelectedGameweek(Number(e.target.value))}>
                    {Array.from({ length: 38 }, (_, index) => (
                        <option key={index + 1} value={index + 1}>Gameweek {index + 1}</option>
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

export default WeeklyLeagueStandings;
