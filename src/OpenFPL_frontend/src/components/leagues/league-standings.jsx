import React, { useState, useEffect } from 'react';
import { Container, Table, Pagination, Form } from 'react-bootstrap';

const LeagueStandings = () => {
  const [isLoading, setIsLoading] = useState(true);
  const [managers, setManagers] = useState([]);
  const [currentPage, setCurrentPage] = useState(1);
  const [selectedSeason, setSelectedSeason] = useState(''); // Start with empty state
  const itemsPerPage = 10;
  const seasons = ['2022-2023', '2023-2024', '2024-2025']; // Mockup for dropdown, you can fetch this dynamically

  useEffect(() => {
      const fetchData = async () => {
          const currentSeason = await fetchCurrentSeason();
          setSelectedSeason(currentSeason);
          await fetchManagerData(currentSeason);
          setIsLoading(false);
      };
      fetchData();
  }, []);

  const fetchCurrentSeason = async () => {
      // Fetch the current season from your backend.
      const response = await fetch('/api/current-season');
      const data = await response.json();
      return data.currentSeason;
  };

  const fetchManagerData = async (season) => {
      // Fetch the data based on the selected season from your backend.
      // Mocked up for demonstration purposes.
      const mockData = Array(100).fill(null).map((_, index) => ({
          position: index + 1,
          username: `manager${index + 1}`,
          score: Math.floor(Math.random() * 500) // Random score
      }));
      setManagers(mockData);
  };

    const displayedManagers = managers.slice((currentPage - 1) * itemsPerPage, currentPage * itemsPerPage);

    return (
        isLoading ? (
            <Container className="d-flex flex-column align-items-center justify-content-center" style={{ minHeight: "80vh" }}>
                <p>Loading...</p>
            </Container>
        )
        :
        <Container className="my-5">
            <Form.Group controlId="seasonSelect">
                <Form.Label>Select Season</Form.Label>
                <Form.Control as="select" value={selectedSeason} onChange={e => setSelectedSeason(e.target.value)}>
                    {seasons.map(season => <option key={season} value={season}>{season}</option>)}
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
                    {displayedManagers.map(manager => (
                        <tr key={manager.position}>
                            <td>{manager.position}</td>
                            <td>{manager.username}</td>
                            <td>{manager.score}</td>
                        </tr>
                    ))}
                </tbody>
            </Table>
            <Pagination>
                {Array(Math.ceil(managers.length / itemsPerPage)).fill(null).map((_, index) => (
                    <Pagination.Item key={index} active={index + 1 === currentPage} onClick={() => setCurrentPage(index + 1)}>
                        {index + 1}
                    </Pagination.Item>
                ))}
            </Pagination>
        </Container>
    );
};

export default LeagueStandings;
