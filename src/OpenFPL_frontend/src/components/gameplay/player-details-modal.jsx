import React from 'react';
import { Modal, Table, Button } from 'react-bootstrap';

const PlayerDetailsModal = ({ show, onClose, player }) => {
  
  const calculatePointsForEvent = (eventType) => {
    // Placeholder points for each event type, adjust as necessary
    const eventPoints = [
      5,  // Appearance
      10, // Goal Scored
      7,  // Goal Assisted
      -2, // Goal Conceded
      2,  // Keeper Save
      5,  // Clean Sheet
      10, // Penalty Saved
      -5, // Penalty Missed
      -3, // Yellow Card
      -5, // Red Card
      -3, // Own Goal
      25  // Highest Scoring Player
    ];

    return eventPoints[eventType];
  };

  
  const calculateScoreBreakdown = () => {
    const breakdown = [];
    const gw = player.gameweeks[0];  // for brevity
    
    // Appearance
    breakdown.push({ description: "Appearance", points: 5 });
    
    // Goalkeeper or defender clean sheet
    if ([0, 1].includes(player.position) && gw.cleanSheets) {
        breakdown.push({ description: "Clean Sheet", points: 10 });
    }

    // Goalkeeper makes 3 saves
    if (player.position === 0 && gw.saves >= 3) {
        const savePoints = Math.floor(gw.saves / 3) * 5;
        breakdown.push({ description: `Every 3 Saves`, points: savePoints });
    }

    // Goal Scoring and Assists
    if (gw.goalsScored) {
        if (player.position === 3) {
            breakdown.push({ description: "Goal Scored", points: 10 * gw.goalsScored });
        } else if (player.position === 2) {
            breakdown.push({ description: "Goal Scored", points: 15 * gw.goalsScored });
        } else {  // Goalkeeper or Defender
            breakdown.push({ description: "Goal Scored", points: 20 * gw.goalsScored });
        }
    }

    if (gw.goalAssists) {
        if ([2, 3].includes(player.position)) {
            breakdown.push({ description: "Goal Assisted", points: 10 * gw.goalAssists });
        } else {  // Goalkeeper or Defender
            breakdown.push({ description: "Goal Assisted", points: 15 * gw.goalAssists });
        }
    }

    // Goalkeeper saves a penalty
    if (player.position === 1 && gw.penaltiesSaved) {
        breakdown.push({ description: "Penalty Saved", points: 20 * gw.penaltiesSaved });
    }

    // Highest scoring player in the match
    if (gw.highestScoringPlayer) {
        breakdown.push({ description: "Highest Scoring Player", points: 25 });
    }

    // Negative Points
    if (gw.redCards) {
        breakdown.push({ description: "Red Card", points: -20 });
    }

    if (gw.penaltiesMissed) {
        breakdown.push({ description: "Penalty Missed", points: -15 * gw.penaltiesMissed });
    }

    if ([0, 1].includes(player.position) && gw.goalsConceded >= 2) {
        const concedePoints = Math.floor(gw.goalsConceded / 2) * -15;
        breakdown.push({ description: `Every 2 Goals Conceded`, points: concedePoints });
    }

    if (gw.ownGoals) {
        breakdown.push({ description: "Own Goal", points: -10 * gw.ownGoals });
    }

    if (gw.yellowCards) {
        breakdown.push({ description: "Yellow Card", points: -5 * gw.yellowCards });
    }
    
    return breakdown;
};


  const mapEventType = (type) => {
    const types = {
      0: "Appearance",
      1: "Goal Scored",
      2: "Goal Assisted",
      3: "Goal Conceded",
      4: "Keeper Save",
      5: "Clean Sheet",
      6: "Penalty Saved",
      7: "Penalty Missed",
      8: "Yellow Card",
      9: "Red Card",
      10: "Own Goal",
      11: "Highest Scoring Player",
    };
    return types[type] || "Unknown";
  };
  

  const scoreBreakdown = calculateScoreBreakdown();
  const totalScore = scoreBreakdown.reduce((acc, item) => acc + item.points, 0);


  return (
    <Modal show={show} onHide={onClose}>
      <Modal.Header closeButton>
        <Modal.Title>{player.firstName} {player.lastName}'s Events and Score Breakdown</Modal.Title>
      </Modal.Header>
      <Modal.Body>
        <h5>Event Details</h5>
        <Table striped bordered hover>
          <thead>
            <tr>
              <th>Event Type</th>
              <th>Start Minute</th>
              <th>End Minute</th>
              <th>Points</th>
              <th>Multiplier</th> {/* Added Multiplier Column */}
            </tr>
          </thead>
          <tbody>
            {player.gameweeks[0].events.map(event => (
              <tr key={event.fixtureId}>
                <td>{mapEventType(event.eventType)}</td>
                <td>{event.eventStartMinute}</td>
                <td>{event.eventEndMinute}</td>
                <td>{calculatePointsForEvent(event.eventType)}</td>
                <td>{event.multiplier ? event.multiplier : "-"}</td> {/* Assuming `multiplier` property on each event */}
              </tr>
            ))}
          </tbody>
        </Table>
        <h5>Score Breakdown</h5>
        <Table striped bordered hover>
          <thead>
            <tr>
              <th>Description</th>
              <th>Points</th>
            </tr>
          </thead>
          <tbody>
            {scoreBreakdown.map((item, idx) => (
              <tr key={idx}>
                <td>{item.description}</td>
                <td>{item.points}</td>
              </tr>
            ))}
            <tr>
              <td><strong>Total Score</strong></td>
              <td><strong>{totalScore}</strong></td>
            </tr>
          </tbody>
        </Table>
      </Modal.Body>
      <Modal.Footer>
        <Button variant="secondary" onClick={onClose}>
          Close
        </Button>
      </Modal.Footer>
    </Modal>
  );
};

export default PlayerDetailsModal;
