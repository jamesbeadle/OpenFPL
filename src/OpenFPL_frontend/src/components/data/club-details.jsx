import React, { useState, useContext, useEffect, useRef } from 'react';
import { Container, Card, Tab, Tabs, Spinner, Dropdown, Row, Col, Badge, Button } from 'react-bootstrap';
import { LinkContainer } from 'react-router-bootstrap';
import ClubProposals from './club-proposals';
import { DataContext } from "../../contexts/DataContext";
import { useParams } from 'react-router-dom';
import { OpenFPL_backend as open_fpl_backend } from '../../../../declarations/OpenFPL_backend';
import { SmallFixtureIcon, CombinedIcon } from '../icons';
import { getAgeFromDOB } from '../helpers';
import getFlag from '../country-flag';
import { getTeamById, computeTimeLeft } from '../helpers';
import { BadgeIcon } from '../icons';

const ClubDetails = ({  }) => {
    const [isLoading, setIsLoading] = useState(true);
    const [key, setKey] = useState('players');
    
    const { teamId } = useParams();
    const { teams, players, seasons, systemState } = useContext(DataContext);
    const [days, setDays] = useState(0);
    const [hours, setHours] = useState(0);
    const [minutes, setMinutes] = useState(0);
    const [nextOpponent, setNextOpponent] = useState(null);
    
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
    const positionDropdownRef = useRef(null);
    const [showPositionDropdown, setShowPositionDropdown] = useState(false);
    const [currentPosition, setCurrentPosition] = useState('All');
 
    const handlePositionBlur = (e) => {
      const currentTarget = e.currentTarget;
      if (!currentTarget.contains(document.activeElement)) {
        setShowPositionDropdown(false);
      }
    };
  
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

    return (
        isLoading ? (
            <div className="customOverlay d-flex flex-column align-items-center justify-content-center">
                <Spinner animation="border" />
                <p className='text-center mt-1'>Loading</p>
            </div>
        ) :
        <Container fluid className='view-container mt-2'>
            <Row className="mt-2">
                <Col xs={12}>
                    <Card>
                        <div className="outer-container d-flex">
                            <div className="flex-grow-1 light-background">
                            <Tabs className="home-tab-header" id="controlled-tab" activeKey={key} onSelect={(k) => setKey(k)}>
                                <Tab eventKey="players" title="Players">
                                    <div className="dark-tab-row w-100 mx-0">
                                        <Row>
                                            <Col md={12}>
                                                <div className='filter-row' style={{ display: 'flex', justifyContent: 'left', alignItems: 'left' }}>
                                                    <div style={{ display: 'flex', alignItems: 'center' }}>
                                                        <div ref={positionDropdownRef} onBlur={handlePositionBlur}>
                                                        <Dropdown show={showPositionDropdown}>
                                                            <Dropdown.Toggle as={CustomToggle} id="gameweek-selector">
                                                            <Button className='filter-dropdown-btn' style={{ backgroundColor: 'transparent' }} onClick={() => openPositionDropdown()}>{currentPosition}</Button>
                                                            </Dropdown.Toggle>
                                                            <Dropdown.Menu style={{ maxHeight: '200px', overflowY: 'auto' }}>
                                                                <Dropdown.Item
                                                                    data-key={0}
                                                                    className='dropdown-item'
                                                                    key={0}
                                                                    onMouseDown={() => {setCurrentPosition('ALL')}}
                                                                    >
                                                                    ALL
                                                                </Dropdown.Item>
                                                                <Dropdown.Item
                                                                    data-key={0}
                                                                    className='dropdown-item'
                                                                    key={0}
                                                                    onMouseDown={() => {setCurrentPosition('Defenders')}}
                                                                    >
                                                                    Defenders
                                                                </Dropdown.Item>
                                                                <Dropdown.Item
                                                                    data-key={0}
                                                                    className='dropdown-item'
                                                                    key={0}
                                                                    onMouseDown={() => {setCurrentPosition('Midfielders')}}
                                                                    >
                                                                    Midfielders
                                                                </Dropdown.Item>
                                                                <Dropdown.Item
                                                                    data-key={0}
                                                                    className='dropdown-item'
                                                                    key={0}
                                                                    onMouseDown={() => {setCurrentPosition('Forwards')}}
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
                                                    <Row onClick={() => loadPlayer(player)} style={{ overflowX: 'auto' }}>
                                                    <Col xs={12}>
                                                    <div className="table-row clickable-table-row" key={player.id}>
                                                        <div className="club-player-number-col gw-table-col">{player.shirtNumber}</div>
                                                        {player.firstName.length > 0 ? 
                                                            <div className="club-player-name-col gw-table-col">{`${player.firstName} ${player.lastName}`}</div> 
                                                        :
                                                            <div className="club-player-name-col gw-table-col">{player.lastName}</div>
                                                        }
                                                        {player.position == 0 && <div className="club-player-position-col gw-table-col">GK</div>}
                                                        {player.position == 1 && <div className="club-player-position-col gw-table-col">DF</div>}
                                                        {player.position == 2 && <div className="club-player-position-col gw-table-col">MF</div>}
                                                        {player.position == 3 && <div className="club-player-position-col gw-table-col">FW</div>}
                                                        <div className="club-player-value-col gw-table-col">{player.value}</div>
                                                        <div className="club-player-age-col gw-table-col">{player.dateOfBirth}</div>
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
                                    
                                </Tab>
                                <Tab eventKey="proposals" title="Proposals">
                                    <h1>Proposals coming soon</h1>
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

const CustomToggle = React.forwardRef(({ children, onClick }, ref) => (
  <a
    href=""
    ref={ref}
    onClick={(e) => {
      e.preventDefault();
      onClick(e);
    }}
  >
    {children}
  </a>
));

export default ClubDetails;
