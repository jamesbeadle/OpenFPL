import React, { useState, useEffect, useContext } from 'react';
import { Card, Row, Col, Spinner, Button } from 'react-bootstrap';
import { AuthContext } from "../../contexts/AuthContext";
import { OpenFPL_backend as open_fpl_backend } from '../../../../declarations/OpenFPL_backend';

import { StarIcon, RecordIcon, StarOutlineIcon, PersonIcon, CaptainIcon, StopIcon, TwoIcon, ThreeIcon, PersonUpIcon, PersonBoxIcon, StopCircleIcon, PenaltyMissIcon} from '../icons';

const AddFixtureData = ({ match }) => {
  const fixtureId = match.params.fixtureId;
  const { teams, players } = useContext(AuthContext);
  const [isLoading, setIsLoading] = useState(true);
  const [fixture, setFixture] = useState(null);
  const [playerEvents, setPlayerEvents] = useState([]);
  const [showPlayerEventModal, setShowPlayerEventModal] = useState(false);
  const [editingPlayerEvent, setEditingPlayerEvent] = useState(null);
  
  useEffect(() => {
    const fetchData = async () => {
      try {
        const fetchedFixture = await open_fpl_backend.getFixture(fixtureId);
        setFixture(fetchedFixture);
      } catch (error) {
        console.error(error);
      } finally {
        setIsLoading(false);
      }
    };

    fetchData();
  }, [fixtureId]);

  const renderPlayerCard = (playerEvent) => {
    const player = players[playerEvent.playerId];

    const appearanceEvent = playerEvent.events.find(event => event.eventType === 0);
    if (!appearanceEvent) {
        console.error(`No appearance event found for player ${playerEvent.playerId}`);
        return null;  // or handle this situation in another way
    }
    const { eventStartMinute, eventEndMinute } = appearanceEvent;
  
  
    // Counting events
    const counts = {
      goals: 0,
      assists: 0,
      keeperSaves: 0,
      penaltySaves: 0,
      penaltyMisses: 0,
      yellowCards: 0,
      redCards: 0,
      ownGoals: 0,
      cleanSheets: 0, 
      highestScoring: 0,
      goalsConceded: 0
    };
  
    // Group events by their types
    for (const event of playerEvent.events) {
      switch (event.eventType) {
        case 1: counts.goals++; break;
        case 2: counts.assists++; break;
        case 3: counts.goalsConceded++; break;
        case 4: counts.keeperSaves++; break;
        case 5: counts.cleanSheets++; break;
        case 6: counts.penaltySaves++; break;
        case 7: counts.penaltyMisses++; break;
        case 8: counts.yellowCards++; break;
        case 9: counts.redCards++; break;
        case 10: counts.ownGoals++; break;
        case 11: counts.highestScoring++; break;
        default: break;
      }
    }
  
    return (
      <Card className="player-card">
        <Card.Header>
          <h3>{player.surname}</h3>
          <p>{player.firstname}</p>
        </Card.Header>
        <Card.Body>
          <p>Minutes Played: {eventStartMinute}-{eventEndMinute} mins</p>
          {counts.goals > 0 && <p>Goals Scored: {counts.goals}</p>}
          {counts.assists > 0 && <p>Assists: {counts.assists}</p>}
          {counts.goalsConceded > 0 && <p>Goals Conceded: {counts.goalsConceded}</p>}
          {counts.cleanSheets > 0 && <p>Clean Sheet</p>}
          {counts.keeperSaves > 0 &&  <p>Saves: {counts.keeperSaves}</p>}
          {counts.penaltySaves > 0 &&  <p>Penalties Saved: {counts.penaltySaves}</p>}
          {counts.penaltyMisses > 0 &&  <p>Penalties Missed: {counts.penaltyMisses}</p>}
          {counts.yellowCards > 0 && <p>Yellow Cards: {counts.yellowCards}</p>}
          {counts.redCards > 0 && <p>Red Cards: {counts.redCards}</p>}
          {counts.ownGoals > 0 && <p>Own Goals: {counts.ownGoals}</p>}
          {player.position === 0 || player.position === 1 ? <p>Clean Sheet</p> : null}
          {counts.highestScoring > 0 ? <p>Highest Scoring Player</p> : null}
          <Button onClick={() => handleEditPlayerEvents(playerEvent)}>Edit</Button>

        </Card.Body>
      </Card>
    );
  };

  const handleEditPlayerEvents = (playerEvent) => {
      setEditingPlayerEvent(playerEvent);
      setShowPlayerEventModal(true);
  };

  const handlePlayerEventUpdated = (updatedEvent) => {
      setPlayerEvents(prevEvents => 
          prevEvents.map(event => 
              event.playerId === updatedEvent.playerId ? updatedEvent : event
          )
      );
  };

  const handlePlayerEventAdded = (events) => {
    let homeGoals = fixture.homeGoals;
    let awayGoals = fixture.awayGoals;

    events.forEach(event => {
        const player = players[event.playerId];
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

    let inferredEvents = inferEvents([...playerEvents, ...events]);

    setPlayerEvents(inferredEvents);
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
        await open_fpl_backend.savePlayerEvents(playerEvents);
        alert('Events saved successfully!');

    } catch (error) {
        console.error('Failed to save player events', error);
        alert('Error saving player events.');
    }
  };
  
  const inferEvents = (events) => {
    const modifiedEvents = [...events];
  
    for (let event of modifiedEvents) {
      const player = players[event.playerId];
      if ([0, 1].includes(player.position)) {
        const goalsConceded = player.teamId === fixture.homeTeamId ? fixture.awayGoals : fixture.homeGoals;
  
        // Infer Goals Conceded
        if (goalsConceded > 0 && !event.events.some(e => e.eventType === 3)) {
          event.events.push({
            eventType: 3,
            eventStartMinute: 0,
            eventEndTime: 90,
          });
        }
  
        // Infer Clean Sheet
        if (goalsConceded === 0 && !event.events.some(e => e.eventType === 5)) {
          event.events.push({
            eventType: 5,
            eventStartMinute: 0,
            eventEndTime: 90,
          });
        }
      }
    }
  
    const scores = {}; 
    for (let event of modifiedEvents) {
      scores[event.playerId] = (scores[event.playerId] || 0) + 1;
    }

    const highestScore = Math.max(...Object.values(scores));
    const highestScoringPlayers = Object.keys(scores).filter(playerId => scores[playerId] === highestScore);
    if (highestScoringPlayers.length === 1) {
      modifiedEvents.push({
        fixtureId,
        playerId: highestScoringPlayers[0],
        eventType: 11, 
        eventStartMinute: 0,
        eventEndTime: 90,
      });
    }
  
    return modifiedEvents;
  };
  

  return (
    <div className="add-fixture-data">
      <Row className="fixture-header">
        <Col>{fixture.homeGoals}</Col>
        <Col>{teams[fixture.homeTeamId]}</Col>
        <Col>V</Col>
        <Col>{teams[fixture.awayTeamId]}</Col>
        <Col>{fixture.awayGoals}</Col>
      </Row>
      
      <div className="players-grid">
        {playerEvents.map(event => renderPlayerCard(event))}
      </div>

      <Button className="mt-3" onClick={handleSave}>
          Save Player Events
      </Button>
      <PlayerEventModal 
          show={showPlayerEventModal} 
          onHide={() => setShowPlayerEventModal(false)}
          onPlayerEventAdded={handlePlayerEventAdded}
          onPlayerEventUpdated={handlePlayerEventUpdated}
          playerEvent={editingPlayerEvent}
      />
    </div>
  );
};

export default AddFixtureData;
