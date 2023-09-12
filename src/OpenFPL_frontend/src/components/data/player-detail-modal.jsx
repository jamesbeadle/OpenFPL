import React, { useState, useEffect } from 'react';
import { Modal, Button, Table, Container, Card } from 'react-bootstrap';
import { getTeamById } from '../helpers';

const PlayerDetailModal = ({ show, onClose, player, playerGameweek, teams }) => {
    if (!player || !playerGameweek) return null;
    
    const getEventName = (eventType) => {
        const eventNames = [
            "Appearance",
            "Goal Scored",
            "Goal Assisted",
            "Goal Conceded - Inferred",
            "Keeper Save",
            "Clean Sheet - Inferred",
            "Penalty Saved",
            "Penalty Missed",
            "Yellow Card",
            "Red Card",
            "Own Goal",
            "Highest Scoring Player"
        ];
        return eventNames[eventType] || "Unknown Event";
    }
    

    return (
        <Modal show={show} onHide={onClose}>
            <Modal.Header closeButton>
                <Modal.Title>
                    {(player.firstName != "" ? player.firstName.charAt(0) + "." : "") + player.lastName}
                    <br />
                    <p className='small-text'>{getTeamById(teams, player.teamId).name}</p>
                </Modal.Title>
            </Modal.Header>
            <Modal.Body>
                <Container className="flex-grow-1 my-2">
                    <Card>
                        <Card.Body>
                        {playerGameweek.events.map((evt, index) => {
                            
                            switch(evt.eventType){
                                case 0:
                                    return (<p key={`player-event-${index}`}>Played from {evt.eventStartMinute}-{evt.eventEndMinute} minutes</p>);
                                case 1:
                                    return (<p key={`player-event-${index}`}>Goal on {evt.eventEndMinute} minutes</p>)
                                case 2:
                                    return (<p key={`player-event-${index}`}>Assist on {evt.eventEndMinute} minutes</p>)
                                case 3:
                                    return (<p key={`player-event-${index}`}>Goal conceded on {evt.eventEndMinute} minutes</p>)
                                case 4:
                                    return (<p key={`player-event-${index}`}>Keeper save {evt.eventEndMinute}</p>)
                                case 5:
                                    return (<p key={`player-event-${index}`}>Clean Sheet</p>)
                                case 6:
                                    return (<p key={`player-event-${index}`}>Penalty save on {evt.eventEndMinute} minutes</p>)
                                case 7:
                                    return (<p key={`player-event-${index}`}>Penalty missed on {evt.eventEndMinute} minutes</p>)
                                case 8:
                                    return (<p key={`player-event-${index}`}>Yellow Card</p>)
                                case 9:
                                    return (<p key={`player-event-${index}`}>Red Card</p>)
                                case 10:
                                    return (<p key={`player-event-${index}`}>Own goal on {evt.eventEndMinute} minutes</p>)
                                case 11:
                                    return (<p key={`player-event-${index}`}>Highest Scoring Player</p>)
                                default:
                                    return (<p key={`player-event-${index}`}>{getEventName(evt.eventType)}</p>)
                            }
                            
                            })}
                        </Card.Body>
                    </Card>
                </Container>
            </Modal.Body>
            <Modal.Footer>
                <Button variant="secondary" onClick={onClose}>
                    Close
                </Button>
            </Modal.Footer>
        </Modal>
    );
};

export default PlayerDetailModal;
