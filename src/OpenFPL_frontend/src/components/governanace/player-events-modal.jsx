import React, { useState, useEffect, useContext } from 'react';
import { Modal, Dropdown, Form, Button, Row, Col, Table } from 'react-bootstrap';
import { AuthContext } from "../../contexts/AuthContext";

const PlayerEventModal = ({ show, onHide, onPlayerEventAdded, player, playerEventMap  }) => {
    const { teams, players } = useContext(AuthContext);
    const [playerEvents, setPlayerEvents] = useState([]);
    const [eventType, setEventType] = useState("-1");
    const [eventStartTime, setEventStartTime] = useState("0");
    const [eventEndTime, setEventEndTime] = useState("0");

    useEffect(() => {
        if(!player){
            return;
        }
        const existingEvents = playerEventMap[player.id] || [];
        setPlayerEvents(existingEvents);
        
        setEventType("");
        setEventStartTime("");
        setEventEndTime("");
    }, [player, playerEventMap]);
    

    const getEventOptions = (position) => {
        const generalOptions = [
            { id: 0, label: 'Appearance' },
            { id: 1, label: 'Goal Scored' },
            { id: 2, label: 'Goal Assisted' },
            { id: 7, label: 'Penalty Missed' },
            { id: 8, label: 'Yellow Card' },
            { id: 9, label: 'Red Card' },
            { id: 10, label: 'Own Goal' }
        ];

        if (position === 0) {
            return [
                ...generalOptions,
                { id: 4, label: 'Keeper Save' },
                { id: 6, label: 'Penalty Saved' }
            ];
        }

        return generalOptions;
    };

    const getEventTypeLabel = (id) => {
        const allOptions = [
            { id: 0, label: 'Appearance' },
            { id: 1, label: 'Goal Scored' },
            { id: 2, label: 'Goal Assisted' },
            { id: 7, label: 'Penalty Missed' },
            { id: 8, label: 'Yellow Card' },
            { id: 9, label: 'Red Card' },
            { id: 10, label: 'Own Goal' },
            { id: 4, label: 'Keeper Save' },
            { id: 6, label: 'Penalty Saved' }
        ];
        const option = allOptions.find(option => option.id === id);
        return option ? option.label : '';
      };

    const handleAddEvent = () => {
        
        if (eventType && eventStartTime !== null && eventEndTime !== null) {
            const newEvent = {
                playerId: player.id,
                eventType: Number(eventType),
                eventStartTime: eventStartTime,
                eventEndTime: eventEndTime
            };
            let updatedEvents = [];
            if (Array.isArray(playerEvents)) {
                updatedEvents = [...playerEvents, newEvent];
            } else {
                updatedEvents = [newEvent];
            }
            setPlayerEvents(updatedEvents);
            onPlayerEventAdded(player.id, updatedEvents);
        }
        setEventStartTime(""); setEventEndTime("");
    };
    
    

    const handleRemoveEvent = (indexToRemove) => {
        const updatedEvents = playerEvents.filter((_, index) => index !== indexToRemove);
        setPlayerEvents(updatedEvents);
        onPlayerEventAdded(player.id, updatedEvents);
    };


    return (
        <Modal show={show} onHide={onHide} centered>
        <Modal.Header closeButton>
            {player && <Modal.Title>{player.firstName != "" ? player.firstName.charAt(0) + "." : ""} {player.lastName} - Match Events</Modal.Title>}
        </Modal.Header>
        <Modal.Body>
            <Form>
                <Form.Group as={Row} className='mb-2'>
                    <Col xs={12}>
                        <Form.Control 
                            as="select"
                            value={eventType}
                            onChange={(e) => {setEventType(e.target.value); setEventStartTime(""); setEventEndTime("");}}>
                                <option value="">Select Event</option>
                                {player && getEventOptions(player.position).map(option => (
                                    <option key={option.id} value={option.id}>
                                        {option.label}
                                    </option>
                                ))}
                        </Form.Control>
                    </Col>
                </Form.Group>
                
                {eventType !== "0" ? (
                <Form.Group as={Row} className='mb-2'>
                            <Col xs={6}>
                            <Form.Control 
                                type="number" 
                                placeholder="Event End Time" 
                                min={0}
                                max={90}
                                value={Number(eventEndTime)}   // convert string to number
                                onChange={(e) => {
                                    setEventStartTime(e.target.value);
                                    setEventEndTime(e.target.value);
                                }}
                                />
                            </Col>
                </Form.Group>
                    ) : (
                        <Form.Group as={Row} className='mb-2'>
                            <Col xs={6}>
                            <Form.Control 
                                type="number" 
                                placeholder="Event Start Time" 
                                min={0}
                                max={90}
                                value={Number(eventStartTime)}   // convert string to number
                                onChange={(e) => setEventStartTime(e.target.value)}
                                />
                            </Col>
                            <Col xs={6}>
                            <Form.Control 
                                type="number" 
                                placeholder="Event End Time" 
                                min={0}
                                max={90}
                                value={Number(eventEndTime)}   // convert string to number
                                onChange={(e) => setEventEndTime(e.target.value)}
                                />
                            </Col>
                        </Form.Group>
                    )}
                <Form.Group as={Row} className='mb-2'>
                    <Col>
                        <Button className="w-100" onClick={handleAddEvent}>Add Event</Button>
                    </Col>
                </Form.Group>

                <Table responsive bordered className="table-fixed light-table">
                    <thead>
                        <tr>
                            <th>Event Type</th>
                            <th>Start Minute</th>
                            <th>End Minute</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        {playerEvents.map((event, index) => (
                            <tr key={index}>
                                <td>{getEventTypeLabel(event.eventType)}</td>
                                <td>{event.eventStartTime}</td>
                                <td>{event.eventEndTime}</td>
                                <td>
                                    <Button onClick={() => handleRemoveEvent(index)}>Remove</Button>
                                </td>
                            </tr>
                        ))}
                    </tbody>
                </Table>
            </Form>
        </Modal.Body>
        <Modal.Footer>
            <Button variant="primary" onClick={onHide}>
                Done
            </Button>
        </Modal.Footer>
    </Modal>
    );
   
};


export default PlayerEventModal;
