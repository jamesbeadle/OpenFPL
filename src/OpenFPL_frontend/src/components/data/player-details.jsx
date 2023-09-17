import React, { useState, useContext, useEffect } from 'react';
import { Container, Card, Spinner, Row, Col, Form, Table, Accordion, Button } from 'react-bootstrap';
import { DataContext } from "../../contexts/DataContext";
import { useParams } from 'react-router-dom';
import { player_canister as player_canister } from '../../../../declarations/player_canister';
import { getAgeFromDOB, formatDOB } from '../helpers';
import getFlag from '../country-flag';
import PlayerDetailModal from './player-detail-modal';

const PlayerDetails = ({  }) => {
    const { playerId } = useParams();
    const { teams, seasons, fixtures, systemState } = useContext(DataContext);
    const [player, setPlayer] = useState(null);
    const [selectedSeason, setSelectedSeason] = useState(systemState.activeSeason.id);
    const [selectedPlayer, setSelectedPlayer] = useState(null);
    const [selectedPlayerGameweek, setSelectedPlayerGameweek] = useState(null);
    const [showModal, setShowModal] = useState(false);
    const [isLoading, setIsLoading] = useState(true);
    
    useEffect(() => {
        const fetchInitialData = async () => {
           
            const playerDetails = await player_canister.getPlayerDetails(Number(playerId), Number(activeSeasonData.id));
            setPlayer(playerDetails);
            setIsLoading(false);
        };

        fetchInitialData();
    }, []);

    useEffect(() => {
        
    }, [selectedSeason]);


    const getTeamNameFromId = (teamId) => {
      const team = teams.find(team => team.id === teamId);
      if(!team){
        return;
      }
      return team.friendlyName;
    }

    const getGameweekTeamName = (fixtureId, playerTeamId) => {
        const fixture = fixtures.find(fixture => fixture.id === fixtureId); 
        if(!fixture){
            return;
        }

        if(playerTeamId == fixture.homeTeamId){
            return teams.find(team => team.id == fixture.awayTeamId).friendlyName;
        }

        if(playerTeamId == fixture.awayTeamId){
            return teams.find(team => team.id == fixture.homeTeamId).friendlyName;
        }

      return "";
    }

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
        isLoading || !player ? (
            <div className="customOverlay d-flex flex-column align-items-center justify-content-center">
                <Spinner animation="border" />
                <p className='text-center mt-1'>Loading</p>
            </div>) :
        (
            <Container>
            <Card className='mb-2 mt-4'>
                <Card.Body>
                    <Card.Title className='mb-2'>
                        {getFlag(player.nationality)} {player.firstName} {player.lastName}
                    </Card.Title>
                    <Row>
                        <p>{getTeamNameFromId(player.teamId)}</p>
                    </Row>
                    <Row>
                        <p>Value: {`£${(Number(player.value) / 4).toFixed(1)}m`}</p>
                    </Row>
                    <Row>
                        <p>Born: {formatDOB(Number(player.dateOfBirth))} ({getAgeFromDOB(Number(player.dateOfBirth))})</p>
                    </Row>
                    <h5>Gameweek History</h5>

                    <Row className='mb-2'>
                        <Col xs={12} md={6}>
                            <Form.Group controlId="seasonSelect">
                                <Form.Label>Select Season</Form.Label>
                                <Form.Control as="select" value={selectedSeason || ''} onChange={e => {
                                    setSelectedSeason(Number(e.target.value));
                                }}>

                                    {seasons.map(season => <option key={season.id} value={season.id}>{`${season.name}`}</option>)}
                                </Form.Control>
                            </Form.Group>
                        </Col>
                    </Row>

                    <Container>
                        <Row className='mt-2 mt-2'>
                            <Col xs={2}>GW</Col>
                            <Col xs={5}>Opponent</Col>
                            <Col xs={2}>Pts</Col>
                            <Col xs={3}></Col>
                        </Row>
                        {selectedSeason && (
                            player.gameweeks.map(gw => (
                                <Row className='mt-2 mt-2' key={`gw-${gw.number}`}>
                                    <Col xs={2}>{gw.number}</Col>
                                    <Col xs={5}>{getGameweekTeamName(gw.fixtureId, player.teamId)}</Col>
                                    <Col xs={2}>{gw.points}</Col>
                                    <Col xs={3}><Button className='w-100 h-100' onClick={() => handleShowModal(player, gw)}><label className='small-text'>Details</label></Button></Col>
                                </Row>
                            ))                  
                        )}
                    </Container>

                </Card.Body>
            </Card>
            {selectedPlayer && selectedPlayerGameweek && <PlayerDetailModal show={showModal} onClose={handleCloseModal} player={selectedPlayer} playerGameweek={selectedPlayerGameweek} teams={teams} />}
        </Container>
        )
    );
};

export default PlayerDetails;
