import React, { useState, useEffect, useContext } from 'react';
import { Form, Spinner, Container, Card, Row, Col } from 'react-bootstrap';
import { LinkContainer } from 'react-router-bootstrap';
import { DataContext } from "../contexts/DataContext";

const LeagueTable = ({ columns }) => {
    const { teams, seasons, fixtures, systemState } = useContext(DataContext);
    const [isLoading, setIsLoading] = useState(true);
    const [selectedSeason, setSelectedSeason] = useState(systemState.activeSeason.id);
    const [selectedGameweek, setSelectedGameweek] = useState(systemState.activeGameweek);
    const [tableData, setTableData] = useState([]);
    const defaultColumns = [
        'Pos', 'Team', 'P', 'W', 'D', 'L', 'GF', 'GA', 'GD', 'Pts'
    ];
    const activeColumns = columns || defaultColumns;
    
    useEffect(() => {
        if(fixtures.length == 0){
            return;
        }
        updateTableData();
    }, [selectedSeason, selectedGameweek, fixtures]);

    const shouldHideColumn = (column) => { 
        return column === 'W' || column === 'D' || column === 'L' || column === 'GF' || column === 'GA';
    };

    const updateTableData = () => {
        setIsLoading(true);
        const initTeamData = (teamId, table) => {
            if (!table[teamId]) {
                table[teamId] = {
                    teamId,
                    played: 0,
                    wins: 0,
                    draws: 0,
                    losses: 0,
                    goalsFor: 0,
                    goalsAgainst: 0,
                    points: 0
                };
            }
        };
    
        let tempTable = {};
        
        const relevantFixtures = fixtures.filter(fixture => 
            fixture.status === 3 && fixture.gameweek <= selectedGameweek);
    
        for (let fixture of relevantFixtures) {
            initTeamData(fixture.homeTeamId, tempTable);
            initTeamData(fixture.awayTeamId, tempTable);
            tempTable[fixture.homeTeamId].id = fixture.homeTeamId;
            tempTable[fixture.awayTeamId].id = fixture.awayTeamId;
    
            tempTable[fixture.homeTeamId].played++;
            tempTable[fixture.awayTeamId].played++;
    
            tempTable[fixture.homeTeamId].goalsFor += fixture.homeGoals;
            tempTable[fixture.homeTeamId].goalsAgainst += fixture.awayGoals;
            
            tempTable[fixture.awayTeamId].goalsFor += fixture.awayGoals;
            tempTable[fixture.awayTeamId].goalsAgainst += fixture.homeGoals;
    
            if (fixture.homeGoals > fixture.awayGoals) {
                tempTable[fixture.homeTeamId].wins++;
                tempTable[fixture.homeTeamId].points += 3;
    
                tempTable[fixture.awayTeamId].losses++;
            } else if (fixture.homeGoals === fixture.awayGoals) {
                tempTable[fixture.homeTeamId].draws++;
                tempTable[fixture.homeTeamId].points += 1;
    
                tempTable[fixture.awayTeamId].draws++;
                tempTable[fixture.awayTeamId].points += 1;
            } else {
                tempTable[fixture.awayTeamId].wins++;
                tempTable[fixture.awayTeamId].points += 3;
    
                tempTable[fixture.homeTeamId].losses++;
            }
        }
    
        const sortedTableData = Object.values(tempTable).sort((a, b) => {
            if (b.points !== a.points) return b.points - a.points;

            const goalDiffA = a.goalsFor - a.goalsAgainst;
            const goalDiffB = b.goalsFor - b.goalsAgainst;

            if (goalDiffB !== goalDiffA) return goalDiffB - goalDiffA;
            if (b.goalsFor !== a.goalsFor) return b.goalsFor - a.goalsFor;

            return a.goalsAgainst - b.goalsAgainst;
        });
        
        setTableData(sortedTableData);
        setIsLoading(false);
    };

    const getTeamNameFromId = (teamId) => {
      const team = teams.find(team => team.id === teamId);
      if(!team){
        return;
      }
      return team.friendlyName;
    }

    const columnToBootstrapClasses = (column) => {
        switch (column) {
            case 'Pos':
                return 'col-2 col-md-1';
            case 'Team':
                return 'col-4 col-md-3';
            case 'P':
                return 'col-2 col-md-1';
            case 'W':
                return 'col-0 col-md-1';
            case 'D':
                return 'col-0 col-md-1';
            case 'L':
                return 'col-0 col-md-1';
            case 'GF':
                return 'col-0 col-md-1';
            case 'GA':
                return 'col-0 col-md-1';
            case 'GD':
                return 'col-2 col-md-1';
            case 'Pts':
                return 'col-2 col-md-1';
            default:
                return 'col';
        }
    };
    

    return (
        isLoading ? (
        <div className="customOverlay d-flex flex-column align-items-center justify-content-center">
            <Spinner animation="border" />
            <p className='text-center mt-1'>Loading</p>
        </div>
        ) 
        :
        <Container>
            <Card className='mb-2 mt-4'>
                <Card.Body>
                    <Card.Title className='mb-2'>
                        Premier League Table
                    </Card.Title>
                    <Row className='mb-2 mt-2'>
                        <Col xs={12} md={6} className='mt-2'>
                            <Form.Group controlId="seasonSelect">
                                <Form.Label>Select Season</Form.Label>
                                <Form.Control as="select" value={selectedSeason} onChange={e => {
                                    setSelectedSeason(Number(e.target.value));
                                    setSelectedGameweek(1);
                                }}>
                                    {seasons.map(season => <option key={season.id} value={season.id}>{`${season.name}`}</option>)}
                                </Form.Control>
                            </Form.Group>
                        </Col>
                        <Col xs={12} md={6} className='mt-2'>
                            <Form.Group controlId="gameweekSelect">
                                <Form.Label>Select Gameweek</Form.Label>
                                <Form.Control as="select" value={selectedGameweek} onChange={e => setSelectedGameweek(Number(e.target.value))}>
                                    {Array.from({ length: 38 }, (_, index) => (
                                        <option key={index + 1} value={index + 1}>Gameweek {index + 1}</option>
                                    ))}
                                </Form.Control>
                            </Form.Group>
                        </Col>
                    </Row>

                    <Container>
                        <Row>
                            {activeColumns.map(column => (
                                <Col key={column} className={`${columnToBootstrapClasses(column)} ${shouldHideColumn(column) ? "d-none d-sm-block" : ""}`}>{column}</Col>
                            ))}
                        </Row>
                        {tableData.map((team, idx) => (
                            <Row key={`id-${idx}`}>
                                <Col className={`${columnToBootstrapClasses('Pos')} ${shouldHideColumn('Pos') ? "d-none d-sm-block" : ""}`}>{idx + 1}</Col>
                                <Col className={`${columnToBootstrapClasses('Team')} ${shouldHideColumn('Team') ? "d-none d-sm-block" : ""}`}><LinkContainer to={`/club/${team.id}`}><a className='nav-link-brand'>{getTeamNameFromId(team.teamId)}</a></LinkContainer></Col>
                                <Col className={`${columnToBootstrapClasses('P')} ${shouldHideColumn('P') ? "d-none d-sm-block" : ""}`}>{team.played}</Col>
                                <Col className={`${columnToBootstrapClasses('W')} ${shouldHideColumn('W') ? "d-none d-sm-block" : ""}`}>{team.wins}</Col>
                                <Col className={`${columnToBootstrapClasses('D')} ${shouldHideColumn('D') ? "d-none d-sm-block" : ""}`}>{team.draws}</Col>
                                <Col className={`${columnToBootstrapClasses('L')} ${shouldHideColumn('L') ? "d-none d-sm-block" : ""}`}>{team.losses}</Col>
                                <Col className={`${columnToBootstrapClasses('GF')} ${shouldHideColumn('GF') ? "d-none d-sm-block" : ""}`}>{team.goalsFor}</Col>
                                <Col className={`${columnToBootstrapClasses('GA')} ${shouldHideColumn('GA') ? "d-none d-sm-block" : ""}`}>{team.goalsAgainst}</Col>
                                <Col className={`${columnToBootstrapClasses('GD')} ${shouldHideColumn('GD') ? "d-none d-sm-block" : ""}`}>{team.goalsFor - team.goalsAgainst}</Col>
                                <Col className={`${columnToBootstrapClasses('Pts')} ${shouldHideColumn('Pts') ? "d-none d-sm-block" : ""}`}>{team.points}</Col>
                            </Row>
                        ))}
                    </Container>

                </Card.Body>
            </Card>
             
        </Container>
    );
};

export default LeagueTable;
