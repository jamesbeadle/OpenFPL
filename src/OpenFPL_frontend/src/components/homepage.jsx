import React, { useState, useEffect } from 'react';
import { Container, Spinner, Row, Col, Card, Tabs, Tab, Badge, Table, Button } from 'react-bootstrap';

const Homepage = () => {
  
  const [isLoading, setIsLoading] = useState(true);
  // Sample data to emulate fetching from backend.
  const [managerCount, setManagerCount] = useState(0); // Total number of OpenFPL managers
  const [systemStatus, setSystemStatus] = useState("Operational"); // System status, can be "Operational", "Maintenance", etc.

  useEffect(() => {
    const fetchData = async () => {
      await fetchViewData();
      setIsLoading(false);
    };
    fetchData();
  }, []);

  const fetchViewData = async () => {
    // Here, emulate fetching data
    setManagerCount(15234); // This will come from your backend.
    setSystemStatus("Operational"); // This will come from your backend.
  };

  const fixtures = [
    { homeTeam: 'Team A', awayTeam: 'Team B', status: 'active', score: '1-0' },
    { homeTeam: 'Team C', awayTeam: 'Team D', status: 'unplayed' },
    { homeTeam: 'Team E', awayTeam: 'Team F', status: 'completed', score: '2-2' }
    ];
  
  return (
    isLoading ? (
      <div className="customOverlay d-flex flex-column align-items-center justify-content-center">
        <Spinner animation="border" />
        <p className='text-center mt-1'>Loading</p>
      </div>
    ) 
    :
    <Container fluid className="flex-grow-1 my-5">
        <Row>
            <Col md={8} xs={12}>
                <h4>Season: 2023/24</h4>
                <h5>Gameweek: 1</h5>
                <Card className="mb-4">
                    <Card.Header>Fixtures</Card.Header>
                    <Card.Body>
                        <Table responsive>
                            <tbody>
                                {fixtures.map((fixture, idx) => (
                                    <tr key={idx}>
                                        <td>{fixture.homeTeam} v {fixture.awayTeam}</td>
                                        <td><Badge variant={fixture.status === 'active' ? 'primary' : fixture.status === 'completed' ? 'success' : 'secondary'}>{fixture.status}</Badge></td>
                                        {fixture.score && <td className="text-muted small">{fixture.score}</td>}
                                    </tr>
                                ))}
                            </tbody>
                        </Table>
                    </Card.Body>
                </Card>
                <p>Total Managers: {managerCount}</p>
            </Col>

            <Col md={4} xs={12}>
                <Card className="mb-4">
                    <Card.Header>Leaderboard</Card.Header>
                    <Card.Body>
                        <Tabs defaultActiveKey="gameweek" id="leaderboard-tabs">
                            <Tab eventKey="gameweek" title="Gameweek">
                                <Table responsive>
                                    {/* Sample top players for gameweek */}
                                </Table>
                                <Button href="/weekly-leaderboard" block>View All</Button>
                            </Tab>
                            <Tab eventKey="season" title="Season">
                                <Table responsive>
                                    {/* Sample top players for season */}
                                </Table>
                                <Button href="/leaderboard" block>View All</Button>
                            </Tab>
                        </Tabs>
                    </Card.Body>
                </Card>
            </Col>
        </Row>
    </Container>
  );
};

export default Homepage;
