import React, { useState, useContext, useEffect, useRef } from 'react';
import { Container, Card, Spinner, Row, Col, Tabs, Tab, Button, Dropdown } from 'react-bootstrap';
import { DataContext } from "../../contexts/DataContext";
import { useParams } from 'react-router-dom';
import { player_canister as player_canister } from '../../../../declarations/player_canister';
import { getAgeFromDOB, formatDOB } from '../helpers';
import getFlag from '../country-flag';
import PlayerDetailModal from './player-detail-modal';
import { CombinedIcon, BadgeIcon, ShirtIcon, StripedShirtIcon, ArrowLeft, ArrowRight, ViewIcon } from '../icons';
import { OpenFPL_backend as open_fpl_backend } from '../../../../declarations/OpenFPL_backend';
import { getTeamById, computeTimeLeft } from '../helpers';

const PlayerDetails = ({  }) => {
    const { playerId } = useParams();
    const { teams, seasons, fixtures, systemState } = useContext(DataContext);
    const [player, setPlayer] = useState(null);
    const [selectedSeason, setSelectedSeason] = useState(systemState.activeSeason);
    const [selectedPlayer, setSelectedPlayer] = useState(null);
    const [selectedPlayerGameweek, setSelectedPlayerGameweek] = useState(null);
    const [showModal, setShowModal] = useState(false);
    const [isLoading, setIsLoading] = useState(true);
    const POSITION_MAP = {
        0: 'GK',
        1: 'DF',
        2: 'MF',
        3: 'FW'
    };
    const [days, setDays] = useState(0);
    const [hours, setHours] = useState(0);
    const [minutes, setMinutes] = useState(0);
    const [playerTeam, setPlayerTeam] = useState(null);
    const [nextFixtureHomeTeam, setNextFixtureHomeTeam] = useState(null);
    const [nextFixtureAwayTeam, setNextFixtureAwayTeam] = useState(null);
    const [showSeasonDropdown, setShowSeasonDropdown] = useState(false);
    const seasonDropdownRef = useRef(null);
    const [key, setKey] = useState('gameweeks');
    
    const handleSeasonBlur = (e) => {
        const currentTarget = e.currentTarget;
        setTimeout(() => {
        if (!currentTarget.contains(document.activeElement)) {
            setShowSeasonDropdown(false);
        }
        }, 0);
    };
    
    useEffect(() => {
        const fetchInitialData = async () => {
            try{
                const playerDetails = await player_canister.getPlayerDetails(Number(playerId), Number(systemState.activeSeason.id));
                setPlayer(playerDetails);        
                setPlayerTeam(teams.find(x => x.id == playerDetails.teamId));
            
                const fixturesData = await open_fpl_backend.getFixturesForSeason(systemState.activeSeason.id);
                let teamFixtures = fixturesData
                .filter(f => f.homeTeamId == playerDetails.teamId || f.awayTeamId == playerDetails.teamId)
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
            
            
            
            
            } catch (error){
                console.log(error);
            } finally {
                setIsLoading(false);
            }
        };
        fetchInitialData();
    }, []);

    useEffect(() => {
    }, [selectedSeason]);


    const handleSeasonChange = async (change) => {
        const newIndex = seasons.findIndex(season => season.id === selectedSeason.id) + change;
        if (newIndex >= 0 && newIndex < seasons.length) {
            setSelectedSeason(seasons[newIndex]);
            
            if (seasons[newIndex].id !== systemState.activeSeason.id) {
            const newFixtures = await fetchFixturesForSeason(seasons[newIndex].id);
            setFetchedFixtures(newFixtures);
            } else {
            setFetchedFixtures(null);
            }
        }
    };

    const openSeasonDropdown = () => {
        setShowSeasonDropdown(!showSeasonDropdown);
        setTimeout(() => {
            if (seasonDropdownRef.current) {
            const item = seasonDropdownRef.current.querySelector(`[data-key="${selectedSeason.id}"]`);
            if (item) {
                item.scrollIntoView({ block: 'nearest', inline: 'nearest' });
            }
            }
        }, 0);
    };

    const handleShowModal = (player, playerGameweek) => {
        setSelectedPlayer(player);
        setSelectedPlayerGameweek(playerGameweek);
        setShowModal(true);
    }

    const handleCloseModal = () => {
        setSelectedPlayer(null);
        setSelectedPlayerGameweek(null);
        setShowModal(false);
    }
    
    const getGameweekTeam = (fixtureId, playerTeamId) => {
        const fixture = fixtures.find(fixture => fixture.id === fixtureId); 
        if(!fixture){
            return;
        }

        if(playerTeamId == fixture.homeTeamId){
            return teams.find(team => team.id == fixture.awayTeamId);
        }

        if(playerTeamId == fixture.awayTeamId){
            return teams.find(team => team.id == fixture.homeTeamId);
        }

      return null;
    }

    return (
        isLoading ? (
            <div className="customOverlay d-flex flex-column align-items-center justify-content-center">
                <Spinner animation="border" />
                <p className='text-center mt-1'>Loading</p>
            </div>
        ) :
        <Container fluid className='view-container mt-2'>
            <Row>
                <Col md={7} xs={12}>
                    <Card className='mb-3'>
                        <div className="outer-container d-flex">
                            <div className="stat-panel flex-grow-1">
                                <Row className="stat-row-1 vertical-flex">
                                    <div className='player-details-name-col'>
                                    <p className="stat-header w-100 text-center">
                                    {POSITION_MAP[player.position]}
                                    </p>
                                         </div>
                                    <div className='player-details-position-col'>
                                        <p className="stat-header w-100">
                                            <BadgeIcon
                                                primary={playerTeam.primaryColourHex}
                                                secondary={playerTeam.secondaryColourHex}
                                                third={playerTeam.thirdColourHex}
                                                className='player-detail-badge-icon'
                                            /> 
                                         {playerTeam.name}</p>
                                    </div>
                                    <div className='player-details-value-col'>
                                        <p className="stat-header w-100">Value</p>
                                    </div>
                                    <div className='player-details-age-col'>
                                        <p className="stat-header w-100">Age</p>
                                    </div>
                                </Row>
                                <Row className="stat-row-2 vertical-flex">
                                    <div className='player-details-name-col'>
                                        {playerTeam.shirtType == 0 ? 
                                            <ShirtIcon
                                                primary={playerTeam.primaryColourHex} 
                                                secondary={playerTeam.secondaryColourHex} 
                                                third={playerTeam.thirdColourHex} 
                                                className='player-details-shirt-icon align-items-center justify-content-center' />
                                        : 
                                            <StripedShirtIcon 
                                                primary={playerTeam.primaryColourHex} 
                                                secondary={playerTeam.secondaryColourHex} 
                                                third={playerTeam.thirdColourHex} 
                                                className='player-details-shirt-icon align-items-center justify-content-center' /> }
                          
                                    </div>
                                    <div className='player-details-position-col'>
                                        <p className="stat">{player.lastName}</p>
                                    </div>
                                    <div className='player-details-value-col'>
                                        <p className="stat">{`£${(Number(player.value) / 4).toFixed(2)}m`}</p>
                                    </div>
                                    <div className='player-details-age-col'>
                                        <p className="stat">{getAgeFromDOB(Number(player.dateOfBirth))}</p>
                                    </div>
                                </Row>
                                <Row className="stat-row-3 vertical-flex">
                                    <div className='player-details-name-col'>
                                        <p className="stat-header text-center">Shirt: {player.shirtNumber}</p>   
                                    </div>
                                    <div className='player-details-position-col'>
                                        <p className="stat-header" style={{ display: 'flex', alignItems: 'center' }}><div>{getFlag(player.nationality, 'player-details-flag')}</div>{player.firstName}</p>    
                                    </div>
                                    <div className='player-details-value-col'>
                                        <p className="stat-header">{systemState.activeSeason.name}</p>    
                                    </div>
                                    <div className='player-details-age-col'>
                                        <p className="stat-header">{formatDOB(Number(player.dateOfBirth))}</p>    
                                    </div>
                                </Row>
                            </div>
                            <div className="d-none d-md-block player-divider-1"></div>
                            <div className="d-none d-md-block player-divider-2"></div>
                            <div className="d-none d-md-block player-divider-3"></div>
                        </div>
                    </Card>
                </Col>

                <Col md={5} xs={12}>
                    <Card>
                        <div className="outer-container d-flex">
                            <div className="stat-panel flex-grow-1">  
                                <Row className="stat-row-1">
                                    <div className='home-deadline-col'>
                                        <p className="stat-header w-100">Upcoming Game</p>    
                                    </div>
                                    <div className='home-fixture-col'>
                                         
                                    </div>
                                </Row>
                                <Row className="stat-row-2 vertical-flex">
                                    <div className='home-deadline-col'>
                                        <Row>
                                            <Col xs={4} className="add-colon">
                                                <p className="stat">{String(days).padStart(2, '0')}</p>
                                            </Col>
                                            <Col xs={4} className="add-colon">
                                                <p className="stat">{String(hours).padStart(2, '0')}</p>
                                            </Col>
                                            <Col xs={4}>
                                                <p className="stat">{String(minutes).padStart(2, '0')}</p>
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
                                <Row className='stat-row-3'>
                                    <div className='home-deadline-col'>
                                        <Row>
                                            <Col xs={4}>
                                                <p className="stat-header w-100">Day</p> 
                                            </Col>
                                            <Col xs={4}>
                                                <p className="stat-header w-100">Hour</p>   
                                            </Col>
                                            <Col xs={4}>
                                                <p className="stat-header w-100">Min</p>    
                                            </Col>
                                        </Row>
                                    </div>
                                    <div className='home-fixture-col'>
                                        <Row>
                                            <Col xs={5}>
                                                {nextFixtureHomeTeam && <p className="stat-header text-center w-100">{nextFixtureHomeTeam.abbreviatedName}</p>}
                                                </Col>
                                                <Col xs={2}>
                                            </Col>
                                            <Col xs={5}>
                                                {nextFixtureAwayTeam && <p className="stat-header text-center w-100">{nextFixtureAwayTeam.abbreviatedName}</p>}
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

            <Row className='mt-2'>
                <Col xs={12}>
                    <Card>
                        <div className="outer-container d-flex">
                            <div className="flex-grow-1 light-background">
                                <Tabs className="home-tab-header" id="controlled-tab" activeKey={key} onSelect={(k) => setKey(k)}>
                                    <Tab eventKey="gameweeks" title="Gameweek History">
                                        <div className="dark-tab-row w-100 mx-0">
                                            <Row>
                                                <Col md={12}>
                                                    <div className='filter-row' style={{ display: 'flex', justifyContent: 'left', alignItems: 'left' }}>
                                                        <div style={{ display: 'flex', alignItems: 'center' }}>
                                                        <Button className="w-100 justify-content-center fpl-btn left-arrow"  onClick={() => handleSeasonChange(-1)} disabled={selectedSeason.id === seasons[0].id}>
                                                            <ArrowLeft />
                                                        </Button>
                                                        </div>
                                                        <div style={{ display: 'flex', alignItems: 'center' }}>
                                                        <div ref={seasonDropdownRef} onBlur={handleSeasonBlur}>
                                                            <Dropdown show={showSeasonDropdown}>
                                                            <Dropdown.Toggle as={CustomToggle} id="season-selector">
                                                                <Button className='filter-dropdown-btn' style={{ backgroundColor: 'transparent' }} onClick={() => openSeasonDropdown()}>{selectedSeason.name}</Button>
                                                            </Dropdown.Toggle>
                                                            <Dropdown.Menu style={{ maxHeight: '200px', overflowY: 'auto' }}>
                                                                
                                                                {seasons.map(season => 
                                                                <Dropdown.Item
                                                                    data-key={season.id}
                                                                    className='dropdown-item'
                                                                    key={season.id}
                                                                    onMouseDown={() => setSelectedSeason(season)}
                                                                >
                                                                    {season.name} {selectedSeason.id === season.id ? ' ✔️' : ''}
                                                                </Dropdown.Item>
                                                                )}
                                                            </Dropdown.Menu>
                                                            </Dropdown>
                                                        </div>
                                                        </div>
                                                        <div style={{ display: 'flex', alignItems: 'center'}}>
                                                        <Button className="w-100 justify-content-center fpl-btn right-arrow"  onClick={() => handleSeasonChange(1)} disabled={selectedSeason.id === seasons[seasons.length - 1].id}>
                                                            <ArrowRight />
                                                        </Button>
                                                        </div>
                                                    </div>
                                                </Col>
                                            </Row>
                                            <Row>
                                                <Container>
                                                    <Row style={{ overflowX: 'auto' }}>
                                                        <Col xs={12}>
                                                            <div className='light-background table-header-row w-100'  style={{ display: 'flex', alignItems: 'center' }}>
                                                                <div className="gw-history-gw-col gw-table-header">GW</div>
                                                                <div className="gw-history-opponent-col gw-table-header">Opponent</div>
                                                                <div className="gw-history-points-col gw-table-header">Pts</div>
                                                                <div className="gw-history-details-col gw-table-header"></div>
                                                            </div>
                                                        </Col>  
                                                    </Row>
                                                    {selectedSeason && (
                                                        player.gameweeks.map(gw => {
                                                            const opponentTeam = getGameweekTeam(gw.fixtureId, player.teamId);
                                                            return (
                                                            <Row className='mt-2 mt-2' key={`gw-${gw.number}`}>
                                                                <Col xs={12}>
                                                                    <div className='table-row'>
                                                                        <div className="gw-history-gw-col gw-table-col">{gw.number}</div>
                                                                        <div className="gw-history-opponent-col gw-table-col">{
                                                                        <p className='m-0'>
                                                                            <BadgeIcon
                                                                                primary={opponentTeam.primaryColourHex}
                                                                                secondary={opponentTeam.secondaryColourHex}
                                                                                third={opponentTeam.thirdColourHex}
                                                                                className='badge-icon'
                                                                            /> 
                                                                            {opponentTeam.name}
                                                                        </p>
                                                                    }</div>
                                                                        <div className="gw-history-points-col gw-table-col">{gw.points}</div>
                                                                        <div className="gw-history-details-col gw-table-col">
                                                                            <Button className='w-100 h-100 view-details-button' onClick={() => handleShowModal(player, gw)}>
                                                                            <ViewIcon className='view-details-icon' />
                                                                                View Details
                                                                            </Button>
                                                                        </div>
                                                                    </div>
                                                                </Col>
                                                            </Row>
                                                        )})                  
                                                    )}
                                                </Container>
                                            </Row>
                                        </div>
                                    </Tab>
                                </Tabs>
                            </div>
                        </div>
                    </Card>
                </Col>
            </Row>                                                  

           {selectedPlayer && selectedPlayerGameweek && <PlayerDetailModal show={showModal} onClose={handleCloseModal} player={selectedPlayer} playerGameweek={selectedPlayerGameweek} teams={teams} season={selectedSeason} />}
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

export default PlayerDetails;
