import React from 'react';
import { Modal, Button } from 'react-bootstrap';

const ConfirmBonusModal = ({ show, handleClose, handleConfirm, bonusType }) => {

  const handleSubmit = () => {
    handleConfirm(bonusType);
  };

  return (
    <Modal show={show} onHide={handleClose} centered>
      <Modal.Header closeButton>
        <Modal.Title>Confirm Bonus</Modal.Title>
      </Modal.Header>
      <Modal.Body>
        <p>Are you sure you want to apply the {bonusType} bonus?</p>
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

export default ConfirmBonusModal;
