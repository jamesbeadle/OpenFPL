import React, { useState, useContext, useEffect, useRef } from 'react';
import { Container, Card, Spinner, Row, Col, Form, Table, Accordion, Button } from 'react-bootstrap';
import { DataContext } from "../../contexts/DataContext";
import { useParams } from 'react-router-dom';
import { player_canister as player_canister } from '../../../../declarations/player_canister';
import { getAgeFromDOB, formatDOB } from '../helpers';
import getFlag from '../country-flag';
import PlayerDetailModal from './player-detail-modal';
import { ShirtIcon } from '../icons';

const PlayerDetails = ({  }) => {
    const { playerId } = useParams();
    const { teams, seasons, fixtures, systemState } = useContext(DataContext);
    const [player, setPlayer] = useState(null);
    const [selectedSeason, setSelectedSeason] = useState(systemState.activeSeason.id);
    const [selectedPlayer, setSelectedPlayer] = useState(null);
    const [selectedPlayerGameweek, setSelectedPlayerGameweek] = useState(null);
    const [showModal, setShowModal] = useState(false);
    const [isLoading, setIsLoading] = useState(true);
    const POSITION_MAP = {
        0: 'Goalkeeper',
        1: 'Defender',
        2: 'Midfielder',
        3: 'Forward'
    };
    const [days, setDays] = useState(0);
    const [hours, setHours] = useState(0);
    const [minutes, setMinutes] = useState(0);
    const [playerTeam, setPlayerTeam] = useState(null);
    const [nextFixtureHomeTeam, setNextFixtureHomeTeam] = useState(null);
    const [nextFixtureAwayTeam, setNextFixtureAwayTeam] = useState(null);
    const [showSeasonDropdown, setShowSeasonDropdown] = useState(false);
    const seasonDropdownRef = useRef(null);

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
        const newIndex = seasons.findIndex(season => season.id === currentSeason.id) + change;
        if (newIndex >= 0 && newIndex < seasons.length) {
            setCurrentSeason(seasons[newIndex]);
            
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
            const item = seasonDropdownRef.current.querySelector(`[data-key="${currentSeason.id}"]`);
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
                                <Row className="stat-row-1">
                                    <div className='player-details-name-col'>
                                    <p className="stat-header w-100 text-center">{player.firstName}</p>
                                         </div>
                                    <div className='player-details-position-col'>
                                        <p className="stat-header w-100">{playerTeam.name}</p>
                                    </div>
                                    <div className='player-details-value-col'>
                                        <p className="stat-header w-100">Value</p>
                                    </div>
                                    <div className='player-details-age-col'>
                                        <p className="stat-header w-100">Age</p>
                                    </div>
                                </Row>
                                <Row className="stat-row-2">
                                    <div className='player-details-name-col'>
                                        {playerTeam.shirtType == 0 ? 
                                            <ShirtIcon
                                                width={'60px'}
                                                height={'61px'}
                                                primary={playerTeam.primaryColourHex} 
                                                secondary={playerTeam.secondaryColourHex} 
                                                third={playerTeam.thirdColourHex} 
                                                className='shirt align-items-center justify-content-center' />
                                        : 
                                            <StripedShirtIcon 
                                                width={'60px'}
                                                height={'61px'}
                                                primary={playerTeam.primaryColourHex} 
                                                secondary={playerTeam.secondaryColourHex} 
                                                third={playerTeam.thirdColourHex} 
                                                className='shirt align-items-center justify-content-center' /> }
                          
                                    </div>
                                    <div className='player-details-position-col'>
                                        <p className="stat">{POSITION_MAP[player.position]}</p>
                                    </div>
                                    <div className='player-details-value-col'>
                                        <p className="stat">{`£${(Number(player.value) / 4).toFixed(2)}m`}</p>
                                    </div>
                                    <div className='player-details-age-col'>
                                        <p className="stat">{getAgeFromDOB(Number(player.dateOfBirth))}</p>
                                    </div>
                                </Row>
                                <Row className="stat-row-3">
                                    <div className='player-details-name-col'>
                                        <p className="stat-header text-center">{player.lastName}</p>   
                                    </div>
                                    <div className='player-details-position-col'>
                                        <p className="stat-header">Shirt Number: {player.shirtNumber}</p>    
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
                                        <p className="stat-header w-100" style={{paddingLeft: '32px'}}>Upcoming Game</p>    
                                    </div>
                                    <div className='home-fixture-col'>
                                         
                                    </div>
                                </Row>
                                <Row className="stat-row-2">
                                    <div className='home-deadline-col'>
                                        <Row  style={{paddingLeft: '32px'}}>
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
                                                <p className="w-100 time-colon">vs</p>
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
                                        <Row style={{paddingLeft: '32px'}}>
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



           {selectedPlayer && selectedPlayerGameweek && <PlayerDetailModal show={showModal} onClose={handleCloseModal} player={selectedPlayer} playerGameweek={selectedPlayerGameweek} teams={teams} />}
        </Container>
    );
};

export default PlayerDetails;
