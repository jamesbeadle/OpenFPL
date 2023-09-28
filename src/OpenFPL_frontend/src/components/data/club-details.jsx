import React, { useState, useContext, useEffect } from 'react';
import { Container, Card, Tab, Tabs, Spinner, Form, Row, Col, Badge, Table } from 'react-bootstrap';
import { LinkContainer } from 'react-router-bootstrap';
import ClubProposals from './club-proposals';
import { DataContext } from "../../contexts/DataContext";
import { useParams } from 'react-router-dom';
import { OpenFPL_backend as open_fpl_backend } from '../../../../declarations/OpenFPL_backend';
import { SmallFixtureIcon } from '../icons';
import { getAgeFromDOB } from '../helpers';
import getFlag from '../country-flag';
import { getTeamById, computeTimeLeft } from '../helpers';

const ClubDetails = ({  }) => {
    const [isLoading, setIsLoading] = useState(true);
    const [key, setKey] = useState('players');
    
    const { teamId } = useParams();
    const { teams, players, seasons, systemState } = useContext(DataContext);
    
    const [team, setTeam] = useState(null);
    const [fixtures, setFixtures] = useState([]);
    const [allTeamFixtures, setAllTeamFixtures] = useState([]);
    const [selectedSeason, setSelectedSeason] = useState(systemState.activeSeason.id);
    const POSITION_MAP = {
        0: 'Goalkeeper',
        1: 'Defender',
        2: 'Midfielder',
        3: 'Forward'
    };
    const [dateRange, setDateRange] = useState({ start: null, end: null });
    const [fixtureFilter, setFixtureFilter] = useState('all');
    
    useEffect(() => {
        const fetchInitialData = async () => {
            try {
                const teamDetails = teams.find(t => t.id === Number(teamId));
                setTeam(teamDetails);
                const fixturesData = await open_fpl_backend.getFixturesForSeason(systemState.activeSeason.id);
                let teamFixtures = fixturesData
                .filter(f => f.homeTeamId == teamId || f.awayTeamId == teamId)
                .sort((a, b) => a.gameweek - b.gameweek);
                setAllTeamFixtures(teamFixtures)
            } catch (error) {
                console.error(error);
            } finally {
                setIsLoading(false);
            }
        };

        fetchInitialData();
    }, []);

    
    useEffect(() => {
        if (!teams || !teamId || allTeamFixtures.length == 0) {
            return;
        };
        const fetchData = async () => {
            const teamDetails = teams.find(t => t.id == teamId);
            setTeam(teamDetails);

            let filteredTeamFixtures = allTeamFixtures
            .filter(f => {
                if (fixtureFilter === 'home' && f.homeTeamId !== Number(teamId)) return false;
                if (fixtureFilter === 'away' && f.awayTeamId !== Number(teamId)) return false;

                if (dateRange.start && f.kickOff < dateRange.start) return false;
                if (dateRange.end && f.kickOff > dateRange.end) return false;

                return true;
            })
            .sort((a, b) => a.gameweek - b.gameweek);


            setFixtures(filteredTeamFixtures);    
        };

        fetchData();
    }, [teamId, teams, fixtureFilter, dateRange, allTeamFixtures]);

    useEffect(() => {
        
        const fetchFixturesForSeason = async (seasonId) => {
            try {
                setIsLoading(true);
                const fixturesData = await open_fpl_backend.getFixturesForSeason(seasonId);
                let teamFixtures = fixturesData
                    .filter(f => f.homeTeamId == teamId || f.awayTeamId == teamId)
                    .sort((a, b) => a.gameweek - b.gameweek);
                setAllTeamFixtures(teamFixtures);
            } catch (error) {
                console.error(error);
            } finally {
                setIsLoading(false);
            }
        };
    
        fetchFixturesForSeason(selectedSeason);
    }, [selectedSeason]);
    
    const teamPlayers = players.filter(player => player.teamId === Number(teamId));

    const groupPlayersByPosition = (players) => {
        return players.reduce((acc, player) => {
            (acc[player.position] = acc[player.position] || []).push(player);
            return acc;
        }, {});
    };

    const sortedAndGroupedPlayers = Object.entries(groupPlayersByPosition(teamPlayers)).map(([position, playersList]) => {
        return {
            position: POSITION_MAP[position],  
            players: playersList.sort((a, b) => {
                if (a.shirtNumber === 0) return 1;
                if (b.shirtNumber === 0) return -1;
                return a.shirtNumber - b.shirtNumber;
            })            
        };
    });

    const renderStatusBadge = (fixture) => {
        const currentTime = new Date().getTime();
        const kickoffTime = computeTimeLeft(Number(fixture.kickOff));
        const oneHourInMilliseconds = 3600000;
    
        if (fixture.status === 0 && kickoffTime - currentTime <= oneHourInMilliseconds) {
            return (
                <Badge className='bg-warning w-100' style={{ padding: '0.5rem' }}>
                    Pre-Game
                </Badge>
            );
        }
    
        switch (fixture.status) {
            case 1:
                return (
                    <Badge className='bg-info w-100' style={{ padding: '0.5rem' }}>
                        Active
                    </Badge>
                );
            case 2:
                return (
                    <Badge className='bg-success w-100' style={{ padding: '0.5rem' }}>
                        In Consensus
                    </Badge>
                );
            case 3:
                return (
                    <Badge className='bg-primary w-100' style={{ padding: '0.5rem' }}>
                        Verified
                    </Badge>
                );
            default:
                return (
                    <Badge className='bg-secondary w-100' style={{ padding: '0.5rem' }}>
                        Unplayed
                    </Badge>
                );
        }
    };

    return (
        isLoading || !team ? (
            <div className="customOverlay d-flex flex-column align-items-center justify-content-center">
                <Spinner animation="border" />
                <p className='text-center mt-1'>Loading</p>
            </div>) :
        (
            <Container>
            <Card className='mb-2 mt-4'>
                <Card.Body>
                    <Card.Title className='mb-2'>
                        <SmallFixtureIcon
                            primaryColour={team.primaryColourHex}
                            secondaryColour={team.secondaryColourHex}
                        />
                        <label style={{marginLeft: '0.5rem'}}>{team.friendlyName} ({team.abbreviatedName})</label>
                        <br />
                        <label className='small-text'>{team.name}</label>
                    </Card.Title>
                    <Tabs id="controlled-tab" className='mt-4' activeKey={key} onSelect={(k) => setKey(k)}>
                        <Tab eventKey="players" title="Players">
                            <div className="players-container">
                                {sortedAndGroupedPlayers.map((group, index) => (
                                    <div key={index} className="player-group">
                                        <h5>{group.position}s</h5>
                                        <Container>
                                            <Row className='mb-2' key={`header-${index}`}>
                                                    <Col className='text-center' xs={1}></Col>
                                                    <Col xs={5}></Col> 
                                                    <Col xs={3}>Value</Col> 
                                                    <Col xs={2}>Age</Col> 
                                            </Row>
                                            {group.players.map(player => (
                                                <Row key={`detail-${player.id}`}>
                                                    <Col className='text-center' xs={1}>{player.shirtNumber == 0 ? '-' : player.shirtNumber}</Col>
                                                    <Col xs={5}>{getFlag(player.nationality)} <LinkContainer style={{marginLeft: '0.25rem'}} to={`/player/${player.id}`}><a className='nav-link-brand'>{player.firstName} {player.lastName}</a></LinkContainer></Col> 
                                                    <Col xs={3}>{`£${(Number(player.value) / 4).toFixed(1)}m`}</Col> 
                                                    <Col xs={2}>{getAgeFromDOB(Number(player.dateOfBirth))}</Col> 
                                                </Row>
                                            ))}
                                        </Container>
                                    </div>
                                ))}
                            </div>
                        </Tab>

                        <Tab eventKey="fixtures" title="Fixtures">
                            <Card className="mt-4 mb-4">
                                <Card.Header>
                                    {team.friendlyName} Fixtures
                                </Card.Header>

                                <Card.Body>
                                    
                                    <Row className='mt-4 mb-4'>
                                        <Col>
                                            <Form.Group controlId="seasonSelect">
                                                <Form.Label>Select Season</Form.Label>
                                                <Form.Control as="select" value={selectedSeason} onChange={e => {
                                                    setSelectedSeason(Number(e.target.value));
                                                }}>
                                                    {seasons.map(season => <option key={season.id} value={season.id}>{`${season.name}`}</option>)}
                                                </Form.Control>
                                            </Form.Group>
                                        </Col>
                                        <Col>
                                            <Form.Group className="mb-2">
                                                <label>
                                                    <Form.Check 
                                                        type="radio" 
                                                        inline
                                                        checked={fixtureFilter === 'all'} 
                                                        onChange={() => setFixtureFilter('all')} 
                                                    />
                                                    All
                                                </label>
                                            </Form.Group>

                                            <Form.Group className="mb-2">
                                                <label>
                                                    <Form.Check 
                                                        type="radio" 
                                                        inline
                                                        checked={fixtureFilter === 'home'} 
                                                        onChange={() => setFixtureFilter('home')} 
                                                    />
                                                    Home
                                                </label>
                                            </Form.Group>

                                            <Form.Group className="mb-2">
                                                <label>
                                                    <Form.Check 
                                                        type="radio" 
                                                        inline
                                                        checked={fixtureFilter === 'away'} 
                                                        onChange={() => setFixtureFilter('away')} 
                                                    />
                                                    Away
                                                </label>
                                            </Form.Group>
                                        </Col>

                                        <Col>
                                            <Form.Group controlId="dateRangeStart">
                                                <Form.Label>Start Date</Form.Label>
                                                <Form.Control type="date" onChange={e => setDateRange(prev => ({ ...prev, start: new Date(e.target.value).getTime() * 1000000 }))} />
                                            </Form.Group>
                                        </Col>
                                        <Col>
                                            <Form.Group controlId="dateRangeEnd">
                                                <Form.Label>End Date</Form.Label>
                                                <Form.Control type="date" onChange={e => setDateRange(prev => ({ ...prev, end: new Date(e.target.value).getTime() * 1000000 }))} />
                                            </Form.Group>
                                        </Col>                        
                                    </Row>
                                    
                                    <Table responsive>
                                        <tbody>
                                            {fixtures.map(fixture => {
                                                const homeTeam = getTeamById(teams, fixture.homeTeamId);
                                                const awayTeam = getTeamById(teams, fixture.awayTeamId);
                                                return (
                                                    <tr key={`fixture-${fixture.id}`} className="align-middle">
                                                        <td className="home-team-name" style={{ textAlign: 'right' }}>{homeTeam.friendlyName}</td>
                                                        <td className="home-team-icon text-center">
                                                            <SmallFixtureIcon
                                                                primaryColour={homeTeam.primaryColourHex}
                                                                secondaryColour={homeTeam.secondaryColourHex}
                                                            />
                                                        </td>
                                                        <td className="text-center align-self-center v-symbol">v</td>
                                                        <td className="text-center away-team-icon">
                                                            <SmallFixtureIcon
                                                                primaryColour={awayTeam.primaryColourHex}
                                                                secondaryColour={awayTeam.secondaryColourHex}
                                                            />
                                                        </td>
                                                        <td className="away-team-name">{awayTeam.friendlyName}</td>
                                                        <td className="text-muted text-center score">{fixture.status === 3 ? `${fixture.homeGoals}-${fixture.awayGoals}` : '-'}</td>
                                                        <td className='text-center status'>
                                                            {renderStatusBadge(fixture)}
                                                        </td>
                                                    </tr>
                                                );
                                            })}
                                        </tbody>
                                    </Table>
                                </Card.Body>
                            </Card>
                        </Tab>
                        <Tab eventKey="proposals" title="Proposals">
                            {key === 'proposals' && <ClubProposals teamId={team.id} />}
                        </Tab>
                    </Tabs>
                </Card.Body>
            </Card>
        </Container>
        )
    );
};

export default ClubDetails;
