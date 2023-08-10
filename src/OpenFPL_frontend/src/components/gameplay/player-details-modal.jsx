import React from 'react';
import { Modal, Button } from 'react-bootstrap';

const PlayerDetailsModal = ({ show, onClose, player, playerDTO }) => {
    if (!player || !playerDTO || !playerDTO.gameweekData) return null;

    const { gameweekData } = playerDTO;

    const renderDetailItem = (label, value) => (
        <div className="mb-2">
            <strong>{label}:</strong> {value}
        </div>
    );

    return (
        <Modal show={show} onHide={onClose}>
            <Modal.Header closeButton>
                <Modal.Title>Details for {player.firstName} {player.lastName}</Modal.Title>
            </Modal.Header>
            <Modal.Body>
                {renderDetailItem("Appearances", gameweekData.appearance)}
                {renderDetailItem("Goals", gameweekData.goals)}
                {renderDetailItem("Assists", gameweekData.assists)}
                {renderDetailItem("Goals Conceded", gameweekData.goalsConceded)}
                {renderDetailItem("Saves", gameweekData.saves)}
                {renderDetailItem("Clean Sheets", gameweekData.cleanSheets)}
                {renderDetailItem("Penalty Saves", gameweekData.penaltySaves)}
                {renderDetailItem("Missed Penalties", gameweekData.missedPenalties)}
                {renderDetailItem("Yellow Cards", gameweekData.yellowCards)}
                {renderDetailItem("Red Cards", gameweekData.redCards)}
                {renderDetailItem("Own Goals", gameweekData.ownGoals)}
                {renderDetailItem("Highest Scoring Player Id", gameweekData.highestScoringPlayerId)}
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
