import React, { useState, useEffect, useContext } from 'react';
import { Modal, Dropdown, Form, Button, Row, Col, Slider, Table } from 'react-bootstrap';
import { AuthContext } from "../../contexts/AuthContext";

const PlayerEventModal = ({ show, onHide, onPlayerEventAdded }) => {
    const { teams, players } = useContext(AuthContext);
    const [selectedTeam, setSelectedTeam] = useState(null);
    const [selectedPlayer, setSelectedPlayer] = useState(null);
    const [teamPlayers, setTeamPlayers] = useState([]);
    const [playerEvents, setPlayerEvents] = useState([]);
    const [eventMinute, setEventMinute] = useState(null);
    const [eventType, setEventType] = useState(null);
    const [eventTimeRange, setEventTimeRange] = useState([0, 90]);

    useEffect(() => {
        if (selectedTeam) {
            const teamPlayerList = players.filter(player => player.teamId === selectedTeam);
            setTeamPlayers(teamPlayerList);
        }
    }, [selectedTeam]);

    const getEventOptions = (position) => {
        const generalOptions = [
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

    const handleAddEvent = () => {
        if (eventType && eventMinute !== null) {
            const newEvent = {
                eventType,
                eventStartMinute: eventMinute,
                eventEndTime: eventMinute 
            };
            setPlayerEvents([...playerEvents, newEvent]);
        }
    };

    return (
        <Modal show={show} onHide={onHide} centered>
            <Modal.Header closeButton>
                <Modal.Title>Add Player Event</Modal.Title>
            </Modal.Header>
            <Modal.Body>
                <Form>
                    <Form.Group as={Row}>
                        <Form.Label column sm="4">Select Team:</Form.Label>
                        <Col sm="8">
                            <Dropdown onSelect={(teamId) => setSelectedTeam(teamId)}>
                                {teams.map(team => (
                                    <Dropdown.Item eventKey={team.id} key={team.id}>{team.name}</Dropdown.Item>
                                ))}
                            </Dropdown>
                        </Col>
                    </Form.Group>

                    {selectedTeam && (
                        <Form.Group as={Row}>
                            <Form.Label column sm="4">Select Player:</Form.Label>
                            <Col sm="8">
                                <Dropdown onSelect={(playerId) => setSelectedPlayer(playerId)}>
                                    {teamPlayers.map(player => (
                                        <Dropdown.Item eventKey={player.id} key={player.id}>{player.name}</Dropdown.Item>
                                    ))}
                                </Dropdown>
                            </Col>
                        </Form.Group>
                    )}

                    {selectedPlayer && (
                        <div>
                            <Form.Group>
                                <Form.Label>Minutes Played</Form.Label>
                                <Slider
                                    value={eventTimeRange}
                                    onChange={(changeEvent, newValue) => setEventTimeRange(newValue)}
                                    valueLabelDisplay="auto"
                                    aria-labelledby="range-slider"
                                    min={0}
                                    max={90}
                                />
                            </Form.Group>

                            <Form.Group as={Row}>
                                <Col sm="6">
                                    <Dropdown onSelect={(value) => setEventType(value)}>
                                        {getEventOptions(selectedPlayer.position).map(option => (
                                            <Dropdown.Item eventKey={option.id} key={option.id}>{option.label}</Dropdown.Item>
                                        ))}
                                    </Dropdown>
                                </Col>
                                <Col sm="3">
                                    <Form.Control 
                                        type="number" 
                                        placeholder="Minute" 
                                        min={0}
                                        max={90}
                                        onChange={(e) => setEventMinute(e.target.value)}
                                    />
                                </Col>
                                <Col sm="3">
                                    <Button onClick={handleAddEvent}>Add Event</Button>
                                </Col>
                            </Form.Group>

                            <Table striped bordered hover>
                                <thead>
                                    <tr>
                                        <th>Event Type</th>
                                        <th>Minute</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {playerEvents.map((event, index) => (
                                        <tr key={index}>
                                            <td>{event.eventType}</td>
                                            <td>{event.eventStartMinute}</td>
                                        </tr>
                                    ))}
                                </tbody>
                            </Table>
                        </div>
                    )}
                </Form>
            </Modal.Body>
            <Modal.Footer>
                <Button variant="secondary" onClick={onHide}>
                    Close
                </Button>
                <Button variant="primary" onClick={() => {
                    onPlayerEventAdded(playerEvents);
                    onHide();
                }}>
                    Add Events
                </Button>
            </Modal.Footer>
        </Modal>
    );
};

export default PlayerEventModal;
