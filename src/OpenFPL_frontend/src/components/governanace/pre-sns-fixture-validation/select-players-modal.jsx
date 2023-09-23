import React, { useState, useEffect } from 'react';
import { Modal, Button, Row, Col, Form } from 'react-bootstrap';

const SelectPlayersModal = ({ show, onHide, onPlayersSelected, teamPlayers, selectedTeam, currentSelectedPlayers }) => {
    const [selectedPlayers, setSelectedPlayers] = useState({});
    const [initialSelectedPlayers, setInitialSelectedPlayers] = useState({});

    useEffect(() => {
        if (show) {
            // Only capture the initial state once when the modal first shows.
            if (!initialSelectedPlayers[selectedTeam]) {
                setInitialSelectedPlayers({ ...initialSelectedPlayers, [selectedTeam]: selectedPlayers[selectedTeam] });
            }
        } else {
            // Clear initial selection when modal hides.
            setInitialSelectedPlayers({});
        }
    }, [show]);

    const handlePlayerCheck = (playerId, isChecked) => {
        setSelectedPlayers(prevState => {
            if (isChecked) {
                return {
                    ...prevState,
                    [selectedTeam]: [...(prevState[selectedTeam] || []), playerId]
                };
            } else {
                return {
                    ...prevState,
                    [selectedTeam]: (prevState[selectedTeam] || []).filter(id => id !== playerId)
                };
            }
        });
    };

    const handleSelectPlayers = () => {
        const selectedPlayerIds = selectedPlayers[selectedTeam] || [];
        onPlayersSelected(selectedTeam, selectedPlayerIds);
        onHide();
    };

    const handleCancel = () => {
        setSelectedPlayers(prevState => ({
            ...prevState,
            [selectedTeam]: initialSelectedPlayers[selectedTeam]
        }));
        onHide();
    };
    

    const renderPlayerList = () => {
        if(teamPlayers == undefined){
            return;
        }
        
        const sortedPlayers = teamPlayers.sort((a, b) => a.lastName.localeCompare(b.lastName));

        const halfLength = Math.ceil(sortedPlayers.length / 2);
        const firstHalf = sortedPlayers.slice(0, halfLength);
        const secondHalf = sortedPlayers.slice(halfLength);

        return (
            <Row>
                <Col>
                    {firstHalf.map(player => (
                        <Form.Check
                            key={player.id}
                            type="checkbox"
                            id={`player-${player.id}`}
                            label={`${player.firstName.length > 0 ? player.firstName.charAt(0) + '.' : '' } ${player.lastName}`}
                            checked={(selectedPlayers[selectedTeam] || []).includes(player.id)}
                            onChange={e => handlePlayerCheck(player.id, e.target.checked)}
                                            />
                    ))}
                </Col>
                <Col>
                    {secondHalf.map(player => (
                        <Form.Check
                            key={player.id}
                            type="checkbox"
                            id={`player-${player.id}`}
                            label={`${player.firstName.length > 0 ? player.firstName.charAt(0) + '.' : '' } ${player.lastName}`}
                            checked={(selectedPlayers[selectedTeam] || []).includes(player.id)}
                            onChange={e => handlePlayerCheck(player.id, e.target.checked)}
                                    />
                    ))}
                </Col>
            </Row>
        );
    };

    return (
        <Modal
            show={show}
            onHide={handleCancel}
            size="lg"
        >
            <Modal.Header closeButton>
                <Modal.Title>Select Players</Modal.Title>
            </Modal.Header>
            <Modal.Body>
                {renderPlayerList()}
            </Modal.Body>
            <Modal.Footer>
                <Button variant="secondary" onClick={handleCancel}>
                    Cancel
                </Button>
                <Button variant="primary" onClick={handleSelectPlayers}>
                    Select Players
                </Button>
            </Modal.Footer>
        </Modal>
    );
};

export default SelectPlayersModal;
