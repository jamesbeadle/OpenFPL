import React, { useState, useEffect, useContext } from 'react';
import { Card, Row, Col, Spinner, Button, Container, Tabs, Tab } from 'react-bootstrap';
import { AuthContext } from "../../contexts/AuthContext";
import { OpenFPL_backend as open_fpl_backend } from '../../../../declarations/OpenFPL_backend';
import { useLocation } from 'react-router-dom';

import { StarIcon, RecordIcon, StarOutlineIcon, PersonIcon, CaptainIcon, StopIcon, TwoIcon, ThreeIcon, PersonUpIcon, PersonBoxIcon, StopCircleIcon, PenaltyMissIcon} from '../icons';
import PlayerEventsModal from './player-events-modal';
import PlayerSelectionModal from './select-players-modal';
import ConfirmFixtureDataModal from './confirm-fixture-data-modal';

const AddFixtureData = () => {
  const location = useLocation();
  const queryParams = new URLSearchParams(location.search);
  const fixtureId = queryParams.get('fixtureId');

  const { teams, players } = useContext(AuthContext);
  const [isLoading, setIsLoading] = useState(true);
  const [fixture, setFixture] = useState(null);
  const [showPlayerSelectionModal, setShowPlayerSelectionModal] = useState(false);
  const [showPlayerEventModal, setShowPlayerEventModal] = useState(false);
  const [showConfirmDataModal, setShowConfirmDataModal] = useState(false);
  
  const [editingPlayerEvent, setEditingPlayerEvent] = useState(null);
  const [key, setKey] = useState('homeTeam');
  const [teamPlayers, setTeamPlayers] = useState([]);
  const [selectedPlayers, setSelectedPlayers] = useState({
    homeTeam: [],
    awayTeam: [],
  });
  const [playerEventMap, setPlayerEventMap] = useState({});

 
  const handlePlayerSelection = (team, playerIds) => {
    // Remove events for any deselected players
    const currentPlayerIds = selectedPlayers[team];
    const removedPlayerIds = currentPlayerIds.filter(id => !playerIds.includes(id));
    let remainingPlayerEventMap = playerEventMap; // Initialize remainingPlayerEventMap to be the same as the current playerEventMap
    if (removedPlayerIds.length > 0) {
      removedPlayerIds.forEach(removedPlayerId => {
        const {[removedPlayerId]: value, ...newRemainingPlayerEventMap} = remainingPlayerEventMap;
        remainingPlayerEventMap = newRemainingPlayerEventMap; // Update remainingPlayerEventMap to remove the deselected player
      });
    }
  
    setPlayerEventMap(remainingPlayerEventMap);
  
    // Update selectedPlayers state
    setSelectedPlayers(prevState => ({
      ...prevState,
      [team]: playerIds,
    }));
  
    // Calculate and set the new fixture stats
    const newFixtureStats = calculateFixtureStats(remainingPlayerEventMap, players, fixture); // Calculate the new fixture stats with the updated playerEventMap
    setFixture(prevFixture => ({
      ...prevFixture,
      ...newFixtureStats
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
    // Calculate the new playerEventMap
    const newPlayerEventMap = {
      ...playerEventMap,
      [playerId]: newEvents
    };

    // Add events to playerEventMap
    setPlayerEventMap(newPlayerEventMap);
  
    // Calculate and set the new fixture stats
    const newFixtureStats = calculateFixtureStats(newPlayerEventMap, players, fixture);
    setFixture(prevFixture => ({
      ...prevFixture,
      ...newFixtureStats
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

  const handleSaveFixtureData = async () => {
    setShowConfirmDataModal(false);
    try {
      const playerEventsArray = [];
      for (const [playerId, playerEvents] of Object.entries(playerEventMap)) {
        const playerTeamId = players.find(p => p.id == playerId)?.teamId;
        playerEvents.forEach(event => {
          playerEventsArray.push({
            fixtureId: fixture.id,
            playerId: Number(playerId),
            eventType: Number(event.eventType),
            eventStartMinute: Number(event.eventStartTime),
            eventEndMinute: Number(event.eventEndTime),
            teamId: playerTeamId
          });
        });
      }
      console.log(playerEventsArray)
      await open_fpl_backend.savePlayerEvents(fixture.id, playerEventsArray);
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
  
  const calculateFixtureStats = (playerEventMap, players, fixture) => {
    const initialStats = {
      homeGoals: 0,
      awayGoals: 0,
      goals: 0,
      assists: 0,
      redCards: 0,
      yellowCards: 0,
      appearances: 0,
      penaltyMissed: 0,
      penaltySaves: 0,
      keeperSaves: 0,
      ownGoals: 0
    };
  
    Object.values(playerEventMap).flat().forEach((event) => {
      const playerTeam = players.find(player => player.id === event.playerId).teamId;
      const isHomeTeam = playerTeam === fixture.homeTeamId;
  
      switch(event.eventType) {
        case 0: // Appearance
          initialStats.appearances++
          break;
        case 1: // Goal Scored
          isHomeTeam ? initialStats.homeGoals++ : initialStats.awayGoals++;
          initialStats.goals++
          break;
        case 2: // Goal Assisted
          initialStats.assists++
          break;
        case 4: // Keeper Save
          initialStats.assists++
          break;
        case 2: // Penalty Save
          initialStats.penaltySaves++
          break;
        case 7: // Penalty Miss
          initialStats.penaltyMissed++
          break;
        case 8: // Yellow Card
          initialStats.yellowCards++
          break;
        case 9: // Red Card
          initialStats.redCards++
          break;
        case 10: // Own Goal
          isHomeTeam ? initialStats.awayGoals++ : initialStats.homeGoals++;
          initialStats.ownGoals++;
          initialStats.goals++;
          break;
        case eventTypeX: // Assist
          isHomeTeam ? initialStats.homeAssists++ : initialStats.awayAssists++;
          initialStats.ownGoals++;
          initialStats.goals++;
          break;
        // Add cases for other event types here
        default:
          break;
      }
    });
  
    return initialStats;
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
              <Button className="mt-3 mb-3" variant='success' onClick={() => setShowConfirmDataModal(true)} 
                disabled={
                  !fixture.appearances || 
                  fixture.appearances === 0 || 
                  fixture.appearances !== selectedPlayers.homeTeam.length + selectedPlayers.awayTeam.length
              }>
                  Save Player Events
              </Button>
              <Row>
                <Col xs={12} md={3}>
                  Appearances: {fixture.appearances ? fixture.appearances : 0}
                </Col>
                <Col xs={12} md={3}>
                  Goals: {fixture.appearances ? fixture.goals : 0}
                </Col>
                <Col xs={12} md={3}>
                  Assists: {fixture.assists ? fixture.assists : 0}
                </Col>
                <Col xs={12} md={3}>
                  Red Cards: {fixture.redCards ? fixture.redCards : 0}
                </Col>
                <Col xs={12} md={3}>
                  Yellow Cards: {fixture.yellowCards ? fixture.yellowCards : 0}
                </Col>
                <Col xs={12} md={3}>
                  Penalties Missed: {fixture.penaltyMissed ? fixture.penaltyMissed : 0}
                </Col>
                <Col xs={12} md={3}>
                  Penalties Saved: {fixture.penaltySaves ? fixture.penaltySaves : 0}
                </Col>
                <Col xs={12} md={3}>
                  Keeper Saves: {fixture.keeperSaves ? fixture.keeperSaves : 0}
                </Col>
                <Col xs={12} md={3}>
                  Own Goals: {fixture.ownGoals ? fixture.ownGoals : 0}
                </Col>
              </Row>
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
            
            <ConfirmFixtureDataModal 
              show={showConfirmDataModal} 
              onHide={() => setShowConfirmDataModal(false)}
              onConfirm={handleSaveFixtureData}
            />
          </div>
        </Card.Body>
      </Card>
    </Container>
  );
};

export default AddFixtureData;
