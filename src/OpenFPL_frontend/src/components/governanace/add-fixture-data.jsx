import React, { useState, useEffect, useContext } from 'react';
import { Card, Row, Col, Spinner, Button, Container, Tabs, Tab } from 'react-bootstrap';
import { AuthContext } from "../../contexts/AuthContext";
import { OpenFPL_backend as open_fpl_backend } from '../../../../declarations/OpenFPL_backend';
import { useLocation } from 'react-router-dom';

import { StarIcon, RecordIcon, StarOutlineIcon, PersonIcon, CaptainIcon, StopIcon, TwoIcon, ThreeIcon, PersonUpIcon, PersonBoxIcon, StopCircleIcon, PenaltyMissIcon} from '../icons';
import PlayerEventsModal from './player-events-modal';
import PlayerSelectionModal from './select-players-modal';

const AddFixtureData = () => {
  const location = useLocation();
  const queryParams = new URLSearchParams(location.search);
  const fixtureId = queryParams.get('fixtureId');

  const { teams, players } = useContext(AuthContext);
  const [isLoading, setIsLoading] = useState(true);
  const [fixture, setFixture] = useState(null);
  const [showPlayerSelectionModal, setShowPlayerSelectionModal] = useState(false);
  const [showPlayerEventModal, setShowPlayerEventModal] = useState(false);
  const [editingPlayerEvent, setEditingPlayerEvent] = useState(null);
  const [key, setKey] = useState('homeTeam');
  const [teamPlayers, setTeamPlayers] = useState([]);
  const [selectedPlayers, setSelectedPlayers] = useState({
    homeTeam: [],
    awayTeam: [],
  });
  const [playerEventMap, setPlayerEventMap] = useState({});

  const handlePlayerSelection = (team, playerIds) => {
    const prevPlayerIds = selectedPlayers[team];
    const removedPlayerIds = prevPlayerIds.filter(id => !playerIds.includes(id));

    setPlayerEventMap(prevState => {
      let newState = { ...prevState };
      removedPlayerIds.forEach(id => {
        delete newState[id];
      });
      return newState;
    });

    setSelectedPlayers(prevState => ({
      ...prevState,
      [team]: playerIds,
    }));

    setShowPlayerSelectionModal(false);
  };
  
  useEffect(() => {
    const fetchData = async () => {
      try {
        const fetchedFixture = await open_fpl_backend.getFixture(0,0,Number(fixtureId));
        setFixture(fetchedFixture);
      } catch (error) {
        console.error(error);
      } finally {
        setIsLoading(false);
      }
    };

    fetchData();
  }, [fixtureId]);

  
  const renderPlayerCard = (playerId) => {
    const player = players.find(p => p.id == playerId);
    
    // Calculate the total events for this player.
    const totalEvents = playerEventMap[playerId]?.length || 0;

    return (
      <Col xs={12} md={3} key={playerId} >
        <Card className="player-card mb-4">
          <Card.Header>
            <h5>{player.lastName}</h5>
            <p className='small-text mb-0 mt-0'>{player.firstName}</p>
          </Card.Header>
          <Card.Body>
            <p>Events: {totalEvents}</p>
            <Button onClick={() => handleEditPlayerEvents(player)}>Update</Button>
          </Card.Body>
        </Card>
      </Col>
    );
  };

  const handleEditPlayerEvents = (player) => {
    const playerEvents = playerEventMap[player.id];
    setEditingPlayerEvent({
      ...player,
      events: playerEvents,
    });
    setShowPlayerEventModal(true);
  };
  

  const handlePlayerEventAdded = (playerId, newEvents) => {
    let homeGoals = fixture.homeGoals;
    let awayGoals = fixture.awayGoals;

    newEvents.forEach(event => {
      const player = players.find(player => player.id === event.playerId);
      
      if (event.eventType === 1) {
        if (player.teamId === fixture.homeTeamId) {
          homeGoals += 1;
        } else {
          awayGoals += 1;
        }
      } else if (event.eventType === 10) { 
        if (player.teamId === fixture.homeTeamId) {
          awayGoals += 1;
        } else {
          homeGoals += 1;
        }
      }
    });

    setFixture({
      ...fixture,
      homeGoals: homeGoals,
      awayGoals: awayGoals
    });

    // Set the player event in the map
    setPlayerEventMap(prevState => ({
      ...prevState,
      [playerId]: newEvents
    }));
  };

  if (isLoading) {
    return (
      <div className="customOverlay d-flex flex-column align-items-center justify-content-center">
        <Spinner animation="border" />
        <p className='text-center mt-1'>Loading Fixture Data...</p>
      </div>
    );
  };

  const handleSave = async () => {
    try {
      const playerEventsArray = [];
      for (const [playerId, playerEvents] of Object.entries(playerEventMap)) {
        playerEvents.forEach(event => {
          playerEventsArray.push({
            fixtureId: fixture.id,
            playerId: Number(playerId),
            eventType: event.type,
            eventStartMinute: event.startMinute,
            eventEndMinute: event.endMinute,
          });
        });
      }
      await open_fpl_backend.savePlayerEvents(playerEventsArray);
    } catch (error) {
      console.error('Failed to save player events', error);
    }
  };
  

  const getTeamNameFromId = (teamId) => {
    const team = teams.find(team => team.id === teamId);
    if(!team){
      return;
    }
    return team.friendlyName;
  };

  const addTeamPlayers = (teamId, teamType) => {
    const filteredPlayers = players.filter(player => teamId === "" || player.teamId === Number(teamId));
    setTeamPlayers(filteredPlayers);
    setShowPlayerSelectionModal(true);
  };
  
  

  return (
    
    <Container className="flex-grow-1 my-5">
      <h1>Manage Fixture Data</h1>
      <br />
      
      <Card className="custom-card mt-1">
        <Card.Header>
          <Row className="fixture-header mt-4 mb-4 text-center">
            <Col className='align-self-center' xs={2}><p className='w-100 m-0 p-0 text-center'>{fixture.homeGoals}</p></Col>
            <Col className='align-self-center' xs={3}><p className='w-100 m-0 p-0 text-center small-text'>{getTeamNameFromId(fixture.homeTeamId)}</p></Col>
            <Col className='align-self-center v-symbol' xs={2}>v</Col>
            <Col className='align-self-center' xs={3}><p className='w-100 m-0 p-0 text-center small-text'>{getTeamNameFromId(fixture.awayTeamId)}</p></Col>
            <Col className='align-self-center' xs={2}><p className='w-100 m-0 p-0 text-center'>{fixture.awayGoals}</p></Col>
          </Row>
        </Card.Header>
        <Card.Body>
          <Tabs defaultActiveKey="homeTeam" id="profile-tabs" className="mt-4" activeKey={key} onSelect={(k) => setKey(k)}>
            <Tab eventKey="homeTeam" title={getTeamNameFromId(fixture.homeTeamId)}>
              <Container className="flex-grow-1 my-3">
                  <Row className="align-items-center mb-4">
                    <Col>
                      <h5>All Players</h5>
                    </Col>
                    <Col className="d-flex justify-content-end">
                    <Button onClick={() => addTeamPlayers(fixture.homeTeamId, 'homeTeam')} variant="primary">Select Players</Button>

                    </Col>
                  </Row>
                  <Row>
                    {selectedPlayers.homeTeam.map(playerId => renderPlayerCard(playerId))}
                  </Row>
              </Container>
            </Tab>
            <Tab eventKey="awayTeam" title={getTeamNameFromId(fixture.awayTeamId)}>
              <Container className="flex-grow-1 my-3">
                <Row className="align-items-center mb-4">
                  <Col>
                    <h5>All Players</h5>
                  </Col>
                  <Col className="d-flex justify-content-end">
                  <Button onClick={() => addTeamPlayers(fixture.awayTeamId, 'awayTeam')} variant="primary">Select Players</Button>

                  </Col>
                </Row>
                <Row>
                  {selectedPlayers.awayTeam.map(playerId => renderPlayerCard(playerId))}
                </Row>
              </Container>
            </Tab>
          </Tabs>

          <div className="add-fixture-data">

            <Button className="mt-3" variant='success' onClick={handleSave}>
                Save Player Events
            </Button>
            <PlayerSelectionModal 
              show={showPlayerSelectionModal} 
              onHide={() => setShowPlayerSelectionModal(false)}
              onPlayersSelected={handlePlayerSelection}
              teamPlayers={teamPlayers}
              selectedTeam={key}
              selectedPlayers={selectedPlayers}
            />
             <PlayerEventsModal 
              show={showPlayerEventModal} 
              onHide={() => setShowPlayerEventModal(false)}
              onPlayerEventAdded={handlePlayerEventAdded}
              playerEventMap={playerEventMap}
              player={editingPlayerEvent}
            />
          </div>
        </Card.Body>
      </Card>
    </Container>
  );
};

export default AddFixtureData;
