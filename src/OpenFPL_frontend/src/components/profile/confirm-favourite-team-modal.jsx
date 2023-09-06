import React from 'react';
import { Modal, Button } from 'react-bootstrap';

const ConfirmFavouriteTeamModal = ({ show, handleClose, handleConfirm, teamId, teamName }) => {

  const handleSubmit = () => {
    handleConfirm(teamId);
  };

  return (
    <Modal show={show} onHide={handleClose} centered>
      <Modal.Header closeButton>
        <Modal.Title>Confirm Update Favourite Team</Modal.Title>
      </Modal.Header>
      <Modal.Body>
        <p>Please confirm you would like to update your favourite team to {teamName}</p>
        <p style={{width: 'calc(100% - 1rem)', margin: '0rem 0rem'}} className='small-text warning-text'>
            <small>Your favourite team can only be changed between seasons.</small></p>
      </Modal.Body>
      <Modal.Footer>
        <Button variant="secondary" onClick={handleClose}>
          Cancel
        </Button>
        <Button variant="primary" onClick={handleSubmit}>
          Confirm
        </Button>
      </Modal.Footer>
    </Modal>
  );
};

export default ConfirmFavouriteTeamModal;
