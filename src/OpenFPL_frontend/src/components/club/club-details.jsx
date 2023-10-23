import React, { useState, useContext, useEffect, useRef } from 'react';
import { Container, Card, Tab, Tabs, Spinner, Dropdown, Row, Col, Button } from 'react-bootstrap';
import { CombinedIcon, BadgeIcon } from '../icons';
import { LinkContainer } from 'react-router-bootstrap';
import { useNavigate, useParams } from 'react-router-dom';
import { OpenFPL_backend as open_fpl_backend } from '../../../../declarations/OpenFPL_backend';
import { DataContext } from "../../contexts/DataContext";
import { getTeamById, computeTimeLeft } from '../helpers';
import { getAgeFromDOB, CustomToggle } from '../helpers';
import getFlag from '../country-flag';
import ClubFixtures from './club-fixtures';

const ClubDetails = ({  }) => {
    const [isLoading, setIsLoading] = useState(true);
    
    const [key, setKey] = useState('players');
    
    const { teamId } = useParams();
    const { fixtures, teams, players, systemState } = useContext(DataContext);
    const [currentGameweek, setCurrentGameweek] = useState(systemState.activeGameweek);
    const [days, setDays] = useState(0);
    const [hours, setHours] = useState(0);
    const [minutes, setMinutes] = useState(0);
    const [nextFixtureHomeTeam, setNextFixtureHomeTeam] = useState(null);
    const [nextFixtureAwayTeam, setNextFixtureAwayTeam] = useState(null);
    
    const [team, setTeam] = useState(null);
    const positionDropdownRef = useRef(null);
    const [showPositionDropdown, setShowPositionDropdown] = useState(false);
    const [teamPlayers, setTeamPlayers] = useState(players.filter(player => player.teamId === Number(teamId)));
    const [currentPosition, setCurrentPosition] = useState(-1);
    const [tableData, setTableData] = useState([]);
    const navigate = useNavigate();
  
    const handlePositionBlur = (e) => {
      const currentTarget = e.currentTarget;
      if (!currentTarget.contains(document.activeElement)) {
        setShowPositionDropdown(false);
      }
    };

    useEffect(() => {
        const fetchData = async () => {
            setTeamPlayers(players.filter(player => player.teamId === Number(teamId) && (currentPosition === -1 || player.position === currentPosition)));
        };
        fetchData();
    }, [currentPosition]);

    useEffect(() => {
        const init = async () => {
          const teamDetails = teams.find(t => t.id === Number(teamId));
          setTeam(teamDetails);
          setTeamPlayers(players.filter(player => player.teamId === Number(teamId)));
          setIsLoading(false);
        };
        init();
      }, [teamId, teams]);

    const fetchInitialData = async () => {
        try {
            const teamDetails = teams.find(t => t.id === Number(teamId));
            setTeam(teamDetails);
            const fixturesData = await open_fpl_backend.getFixturesForSeason(systemState.activeSeason.id);
            let teamFixtures = fixturesData
            .filter(f => f.homeTeamId == teamId || f.awayTeamId == teamId)
            .sort((a, b) => a.gameweek - b.gameweek);
            
            const currentTime = BigInt(Date.now() * 1000000);
            const nextFixtureData = teamFixtures.sort((a, b) => Number(a.kickOff) - Number(b.kickOff)).find(fixture => Number(fixture.kickOff) > currentTime);
            setNextFixtureHomeTeam(getTeamById(teams, nextFixtureData.homeTeamId));
            setNextFixtureAwayTeam(getTeamById(teams, nextFixtureData.awayTeamId));
            if (nextFixtureData) {
                const timeLeft = computeTimeLeft(Number(nextFixtureData.kickOff));
                const timeLeftInMillis = 
                    timeLeft.days * 24 * 60 * 60 * 1000 + 
                    timeLeft.hours * 60 * 60 * 1000 + 
                    timeLeft.minutes * 60 * 1000 + 
                    timeLeft.seconds * 1000;
                
                const d = Math.floor(timeLeftInMillis / (1000 * 60 * 60 * 24));
                const h = Math.floor((timeLeftInMillis % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
                const m = Math.floor((timeLeftInMillis % (1000 * 60 * 60)) / (1000 * 60));
        
                setDays(d);
                setHours(h);
                setMinutes(m);
            } else {
                setDays(0);
                setHours(0);
                setMinutes(0);
            }

        } catch (error) {
            console.error(error);
        } finally {
            setIsLoading(false);
        }
    };
  
    useEffect(() => {
        updateTableData();
        fetchInitialData();
    }, []);

    const updateTableData = () => {
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
            fixture.status === 3 && fixture.gameweek <= currentGameweek);
    
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
      };

      const getClubInfo = (teamId) => {
        const club = tableData.find(team => team.teamId == teamId);
        const position = tableData.indexOf(club) + 1;
        const points = club?.points || 0;
        
        return { position, points };
      };
      const { position, points } = getClubInfo(teamId);

    const openPositionDropdown = () => {
      setShowPositionDropdown(!showPositionDropdown);
      setTimeout(() => {
        if (positionDropdownRef.current) {
          const item = positionDropdownRef.current.querySelector(`[data-key="${currentPosition}"]`);
          if (item) {
            item.scrollIntoView({ block: 'nearest', inline: 'nearest' });
          }
        }
      }, 0);
    };

    const loadPlayer = async (player) => {
      navigate(`/player/${player.id}`);
    };

    return (
        isLoading ? (
            <div className="customOverlay d-flex flex-column align-items-center justify-content-center">
                <Spinner animation="border" />
                <p className='text-center mt-1'>Loading</p>
            </div>
        ) :
        <Container fluid className='view-container mt-2'>
            <Row>
                <Col xxl={7} xs={12}>
                    <Card className='mb-3'>
                        <div className="d-flex">
                            <div className="stat-panel flex-grow-1">
                                <Row>
                                    <div className='club-badge-col'>
                                        <p className="small-header-stat w-100">{team.abbreviatedName}</p>
                                    </div>
                                    <div className='club-total-players-col'>
                                        <p className="small-header-stat w-100">Players</p>
                                    </div>
                                    <div className='club-position-col'>
                                        <p className="small-header-stat w-100">Season Position</p>
                                    </div>
                                    <div className='club-points-col'>
                                        <p className="small-header-stat w-100">Points</p>
                                    </div>
                                </Row>
                                <Row>
                                    <div className='club-badge-col'>
                                        <BadgeIcon
                                            primary={team.primaryColourHex}
                                            secondary={team.secondaryColourHex}
                                            third={team.thirdColourHex}
                                            className='badge-icon'
                                        />
                                    </div>
                                    <div className='club-total-players-col'>
                                        <p className="header-stat">{players.filter(x => x.teamId == team.id).length}</p>
                                    </div>
                                    <div className='club-position-col'>
                                        <p className="header-stat">{position}</p>
                                    </div>
                                    <div className='club-points-col'>
                                        <p className="header-stat">{points}</p>
                                    </div>
                                </Row>
                                <Row>
                                    <div className='club-badge-col'>
                                        <p className="small-header-stat">{team.friendlyName}</p>   
                                    </div>
                                    <div className='club-total-players-col'>
                                        <p className="small-header-stat">Total</p>    
                                    </div>
                                    <div className='club-position-col'>
                                        <p className="small-header-stat">{systemState.activeSeason.name}</p>    
                                    </div>
                                    <div className='club-points-col'>
                                        <p className="small-header-stat">Total</p>    
                                    </div>
                                </Row>
                            </div>
                            <div className="d-none d-md-block club-divider-1"></div>
                            <div className="d-none d-md-block club-divider-2"></div>
                            <div className="d-none d-md-block club-divider-3"></div>
                        </div>
                    </Card>
                </Col>

                <Col xxl={5} xs={12}>
                    <Card>
                        <div className="d-flex">
                            <div className="stat-panel flex-grow-1">  
                                <Row>
                                    <div className='home-deadline-col'>
                                        <p className="small-header-stat w-100">Upcoming Game</p>    
                                    </div>
                                    <div className='home-fixture-col'>
                                         
                                    </div>
                                </Row>
                                <Row>
                                    <div className='home-deadline-col'>
                                        <Row>
                                            <Col xs={4} className="add-colon">
                                                <p className="header-stat">{String(days).padStart(2, '0')}</p>
                                            </Col>
                                            <Col xs={4} className="add-colon">
                                                <p className="header-stat">{String(hours).padStart(2, '0')}</p>
                                            </Col>
                                            <Col xs={4}>
                                                <p className="header-stat">{String(minutes).padStart(2, '0')}</p>
                                            </Col>
                                        </Row>  
                                    </div>
                                    <div className='home-fixture-col'>
                                        <Row>
                                            <Col xs={5}>
                                                <div className='text-center badge w-100'>
                                                    {nextFixtureHomeTeam && <CombinedIcon
                                                        primary={nextFixtureHomeTeam.primaryColourHex}
                                                        secondary={nextFixtureHomeTeam.secondaryColourHex}
                                                        third={nextFixtureHomeTeam.thirdColourHex}
                                                        width={60}
                                                        height={60}
                                                    />}
                                                </div>
                                            </Col>
                                            <Col xs={2}>
                                                <p className="w-100 vs">vs</p>
                                            </Col>
                                            <Col xs={5}>
                                                <div className='text-center badge w-100'>
                                                {nextFixtureAwayTeam && <CombinedIcon
                                                        primary={nextFixtureAwayTeam.primaryColourHex}
                                                        secondary={nextFixtureAwayTeam.secondaryColourHex}
                                                        third={nextFixtureAwayTeam.thirdColourHex}
                                                        width={60}
                                                        height={60}
                                                    />}
                                                </div>
                                            </Col>
                                        </Row>
                                    </div>
                                </Row>
                                <Row>
                                    <div className='home-deadline-col'>
                                        <Row>
                                            <Col xs={4}>
                                                <p className="small-header-stat w-100">Day</p> 
                                            </Col>
                                            <Col xs={4}>
                                                <p className="small-header-stat w-100">Hour</p>   
                                            </Col>
                                            <Col xs={4}>
                                                <p className="small-header-stat w-100">Min</p>    
                                            </Col>
                                        </Row>
                                    </div>
                                    <div className='home-fixture-col'>
                                        <Row>
                                            <Col xs={5}>
                                                {nextFixtureHomeTeam && <p className="small-header-stat text-center w-100">{nextFixtureHomeTeam.abbreviatedName}</p>}
                                                </Col>
                                                <Col xs={2}>
                                            </Col>
                                            <Col xs={5}>
                                                {nextFixtureAwayTeam && <p className="small-header-stat text-center w-100">{nextFixtureAwayTeam.abbreviatedName}</p>}
                                            </Col>
                                        </Row>
                                    </div>
                                </Row>
                            </div>
                            <div className="d-none d-md-block home-divider-3"></div>
                        </div>
                    </Card>
                </Col>
            </Row>

            <Row className="mt-2">
                <Col xs={12}>
                    <Card>
                        <div className="d-flex">
                            <div className="flex-grow-1 light-background">
                            <Tabs className="tab-header" id="controlled-tab" activeKey={key} onSelect={(k) => setKey(k)}>
                                <Tab eventKey="players" title="Players">
                                    <div className="dark-tab-row w-100 mx-0">
                                        <Row>
                                            <Col md={12}>
                                                <div className='filter-row' style={{ display: 'flex', justifyContent: 'left', alignItems: 'left' }}>
                                                    <div style={{ display: 'flex', alignItems: 'center' }}>
                                                        <div ref={positionDropdownRef} onBlur={handlePositionBlur}>
                                                        <Dropdown show={showPositionDropdown}>
                                                            <Dropdown.Toggle as={CustomToggle} id="gameweek-selector">
                                                                <Button className='filter-dropdown-btn' style={{ backgroundColor: 'transparent' }} onClick={() => openPositionDropdown()}>
                                                                    Position: 
                                                                    {currentPosition == -1 && ' All'}
                                                                    {currentPosition == 0 && ' Goalkeepers'}
                                                                    {currentPosition == 1 && ' Defenders'}
                                                                    {currentPosition == 2 && ' Midfielders'}
                                                                    {currentPosition == 3 && ' Forwards'}
                                                                </Button>
                                                            </Dropdown.Toggle>
                                                            <Dropdown.Menu style={{ maxHeight: '200px', overflowY: 'auto' }}>
                                                                <Dropdown.Item
                                                                    data-key={-1}
                                                                    className='dropdown-item'
                                                                    key={-1}
                                                                    onMouseDown={() => {setCurrentPosition(-1)}}
                                                                    >
                                                                    All
                                                                </Dropdown.Item>
                                                                <Dropdown.Item
                                                                    data-key={0}
                                                                    className='dropdown-item'
                                                                    key={0}
                                                                    onMouseDown={() => {setCurrentPosition(0)}}
                                                                    >
                                                                    Goalkeepers
                                                                </Dropdown.Item>
                                                                <Dropdown.Item
                                                                    data-key={1}
                                                                    className='dropdown-item'
                                                                    key={1}
                                                                    onMouseDown={() => {setCurrentPosition(1)}}
                                                                    >
                                                                    Defenders
                                                                </Dropdown.Item>
                                                                <Dropdown.Item
                                                                    data-key={2}
                                                                    className='dropdown-item'
                                                                    key={2}
                                                                    onMouseDown={() => {setCurrentPosition(2)}}
                                                                    >
                                                                    Midfielders
                                                                </Dropdown.Item>
                                                                <Dropdown.Item
                                                                    data-key={3}
                                                                    className='dropdown-item'
                                                                    key={3}
                                                                    onMouseDown={() => {setCurrentPosition(3)}}
                                                                    >
                                                                    Forwards
                                                                </Dropdown.Item>
                                                            </Dropdown.Menu>
                                                        </Dropdown>
                                                        </div>
                                                    </div>
                                                </div>
                                            </Col>
                                        </Row>

                                        <Row>

                                        <Container>
                                            <Row style={{ overflowX: 'auto' }}>
                                                <Col xs={12}>
                                                    <div className='light-background table-header-row w-100'  style={{ display: 'flex', alignItems: 'center' }}>
                                                        <div className="club-player-number-col gw-table-header">Shirt</div>
                                                        <div className="club-player-name-col gw-table-header">Player Name</div>
                                                        <div className="club-player-position-col gw-table-header">Position</div>
                                                        <div className="club-player-value-col gw-table-header">Value</div>
                                                        <div className="club-player-age-col gw-table-header">Age</div>
                                                    </div>
                                                </Col>  
                                            </Row>

                                            {teamPlayers.map(player => {
                                                return (
                                                    <Row key={player.id} onClick={() => loadPlayer(player)} style={{ overflowX: 'auto' }}>
                                                    <Col xs={12}>
                                                    <div className="table-row clickable-table-row">
                                                        <div className="club-player-number-col gw-table-col">{player.shirtNumber}</div>
                                                        <div className="club-player-name-col gw-table-col">
                                                            <div>{getFlag(player.nationality, 'player-list-flag')}</div>
                                                            {
                                                                player.firstName.length > 0 ? `${player.firstName} ${player.lastName}` : player.lastName
                                                            }
                                                        </div> 
                                                        {player.position == 0 && <div className="club-player-position-col gw-table-col">GK</div>}
                                                        {player.position == 1 && <div className="club-player-position-col gw-table-col">DF</div>}
                                                        {player.position == 2 && <div className="club-player-position-col gw-table-col">MF</div>}
                                                        {player.position == 3 && <div className="club-player-position-col gw-table-col">FW</div>}
                                                        <div className="club-player-value-col gw-table-col">{`£${(Number(player.value) / 4).toFixed(2)}m`}</div>
                                                        <div className="club-player-age-col gw-table-col">{getAgeFromDOB(player.dateOfBirth)}</div>
                                                     </div>
                                                    </Col>
                                                    </Row>
                                                );
                                            })}
                                        </Container>
                                        </Row>
                                    </div>
                                </Tab>

                                <Tab eventKey="fixtures" title="Fixtures">
                                    {key === 'fixtures' && <ClubFixtures key={teamId} teamId={teamId} />}
                                </Tab>
                                <Tab eventKey="proposals" title="Proposals">
                                    <div className='px-2 mt-2 mb-2'>
                                        <p>After our SNS decentralisation sale, club proposal information will appear here.</p>
                                        <p>More information can be found in our <LinkContainer to="/whitepaper"><a>whitepaper</a></LinkContainer>.</p>
                                    </div>
                                </Tab>
                            </Tabs>
                            </div>
                        </div>
                    </Card>
                </Col>
            </Row>
        </Container>
    );
};

export default ClubDetails;
