import React, { useState, useEffect, useContext } from 'react';
import { Container, Spinner, Row, Col, Card, Tabs, Tab, Badge, Table, Button } from 'react-bootstrap';
import { FixtureIcon } from './icons';
import { AuthContext } from "../contexts/AuthContext";
import { Actor } from "@dfinity/agent";
import { OpenFPL_backend as open_fpl_backend } from '../../../declarations/OpenFPL_backend';

const Homepage = () => {
  
  const [isLoading, setIsLoading] = useState(true);
  const { authClient, teams } = useContext(AuthContext);
  const [fixtures, setFixtures] = useState([]);
  
  const [managerCount, setManagerCount] = useState(0); // Total number of OpenFPL managers

  useEffect(() => {
    const fetchData = async () => {
      await fetchViewData();
      setIsLoading(false);
    };
    fetchData();
  }, []);

  const fetchViewData = async () => {
    const identity = authClient.getIdentity();
    Actor.agentOf(open_fpl_backend).replaceIdentity(identity);
  
    const fixturesData = await open_fpl_backend.getGameweekFixtures();
    setFixtures(fixturesData);

    const managerCountData = await open_fpl_backend.getTotalManagers();
    setManagerCount(managerCountData);
  };

  const getTeamById = (teamId) => {
    return teams.find(team => team.id === teamId);
  };

    const gameweekLeaders = [
    { position: 1, username: 'James', points: 151 },
    { position: 2, username: 'Sarah', points: 137 },
    { position: 3, username: 'Sam', points: 111 },
    { position: 4, username: 'Jess', points: 104 },
    { position: 5, username: 'Oliver', points: 99 },
    { position: 6, username: 'James', points: 98 },
    { position: 7, username: 'Mark', points: 91 },
    { position: 8, username: 'Liz', points: 87 },
    { position: 9, username: 'Tom', points: 86 },
    { position: 10, username: 'Sean', points: 85 }
    ];

    const seasonLeaders = [
    { position: 1, username: 'EveEvans', points: 1398 },
    { position: 2, username: 'CharlieClark', points: 1375 },
    { position: 3, username: 'JohnDoe', points: 1360 },
    { position: 4, username: 'BobBrown', points: 1325 },
    { position: 5, username: 'AliceSmith', points: 1309 }
    ];
    const totalPrizePool = 0;

    return (
        isLoading ? (
        <div className="customOverlay d-flex flex-column align-items-center justify-content-center">
            <Spinner animation="border" />
            <p className='text-center mt-1'>Loading</p>
        </div>
        ) 
        :
        <Container className="flex-grow-1 my-5">
            <Row>
                <Col md={8} xs={12}>
                    <Row className="mb-3">
                        <Col md={4} xs={12}>
                            <Card className="h-100">
                                <Card.Body>
                                    <Card.Title>Gameweek</Card.Title>
                                    <h5 className="display-sm">1</h5> 
                                    <Card.Text>2023/24</Card.Text>
                                </Card.Body>
                            </Card>
                        </Col>
                        <Col md={4} xs={12}>
                            <Card className="h-100">
                                <Card.Body>
                                    <Card.Title>Managers</Card.Title>
                                    <h5 className="display-sm">{managerCount.toLocaleString()}</h5> 
                                    <Card.Text>Total</Card.Text>
                                </Card.Body>
                            </Card>
                        </Col>
                        <Col md={4} xs={12}>
                            <Card className="h-100">
                                <Card.Body>
                                    <Card.Title>Weekly Prize Pool</Card.Title>
                                    <h5 className="display-sm"><small>{totalPrizePool.toLocaleString()}</small></h5> 
                                    <Card.Text>$FPL</Card.Text>
                                </Card.Body>
                            </Card>
                        </Col>
                    </Row>
                
                    <Card className="mb-4">
                        <Card.Header>Fixtures</Card.Header>
                        <Card.Body>
                            <Table responsive>
                                <tbody>
                                {fixtures.map((fixture, idx) => (
                                    <tr key={idx}>
                                    <td>
                                        <FixtureIcon 
                                        primaryColour={getTeamById(fixture.homeTeamId).primaryColourHex}
                                        secondaryColour={getTeamById(fixture.homeTeamId).secondaryColourHex} 
                                        />
                                        {getTeamById(fixture.homeTeamId).name} v {getTeamById(fixture.awayTeamId).name}
                                        <FixtureIcon 
                                        primaryColour={getTeamById(fixture.awayTeamId).primaryColourHex}
                                        secondaryColour={getTeamById(fixture.awayTeamId).secondaryColourHex} 
                                        />
                                    </td>
                                    {fixture.score && <td className="text-muted text-center small">{fixture.score}</td>}
                                    {!fixture.score && <td className="text-muted text-center small">-</td>}
                                    <td className='text-center'>
                                        <Badge 
                                        className={
                                            fixture.status === 1 ? 'bg-primary' : 
                                            fixture.status === 2 ? 'bg-success' : 'bg-secondary'
                                        } 
                                        style={{ width: '80px', padding: '0.5rem' }}>
                                        {fixture.status === 1 ? 'Active' : 
                                            fixture.status === 2 ? 'Completed' : 'Unplayed'}
                                        </Badge>
                                    </td>
                                    </tr>
                                ))}
                                </tbody>
                            </Table>
                            <Row>
                                <Col>
                                    <div style={{ textAlign: 'right' }}>
                                        <Button>View Gameweek Points</Button>
                                    </div>
                                </Col>
                            </Row>
                        </Card.Body>
                    </Card>

                </Col>

                <Col md={4} xs={12}>
                    <Card className="mb-4">
                        <Card.Header>Leaderboard</Card.Header>
                        <Card.Body>
                            <Tabs defaultActiveKey="gameweek" id="leaderboard-tabs">
                                <Tab eventKey="gameweek" title="Gameweek">
                                    <br />
                                    <Table responsive  className='text-center'>
                                        <thead>
                                            <tr>
                                            <th>#</th>
                                            <th>Username</th>
                                            <th>Points</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            {gameweekLeaders.map((leader) => (
                                            <tr key={leader.position}>
                                                <td>{leader.position}</td>
                                                <td>{leader.username}</td>
                                                <td>{leader.points}</td>
                                            </tr>
                                            ))}
                                        </tbody>
                                    </Table>
                                    <div style={{ textAlign: 'right' }}>
                                    <   Button href="/weekly-leaderboard">View All</Button>
                                    </div>
                                </Tab>
                                <Tab eventKey="season" title="Season">
                                    <br />
                                    <Table responsive>
                                        <thead>
                                            <tr>
                                            <th>#</th>
                                            <th>Username</th>
                                            <th>Points</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            {seasonLeaders.map((leader) => (
                                            <tr key={leader.position}>
                                                <td>{leader.position}</td>
                                                <td>{leader.username}</td>
                                                <td>{leader.points}</td>
                                            </tr>
                                            ))}
                                        </tbody>
                                    </Table>
                                    <div style={{ textAlign: 'right' }}>
                                        <Button href="/leaderboard">View All</Button>
                                    </div>
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
