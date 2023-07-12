import React from 'react';
import { Modal, Button } from 'react-bootstrap';

const ConfirmBonusModal = ({ show, handleClose, handleConfirm, bonusType }) => {

  const handleSubmit = () => {
    handleConfirm(bonusType);
  };

  const bonusTitle = (bonusType == 5) ? "Bonus: Safe Hands" :
                      (bonusType == 6) ? "Bonus: Captain Fantastic" :
                      (bonusType == 7) ? "Bonus: Brace Bonus" :
                      (bonusType == 8) ? "Bonus: Hat Trick Hero" : "";

  const description = (bonusType == 5) ? "Play your Safe Hands bonus to triple your goalkeeper's points for this gameweek." :
                      (bonusType == 6) ? "Play your Captain Fantastic bonus to triple your captain's points for this gameweek if they score a goal." :
                      (bonusType == 7) ? "Play Brace Bonus to double the points for any player in your team that scores 2 or more goals in a match." :
                      (bonusType == 8) ? "Play your Hat Trick Hero bonus to triple the points for any player in your team that scores 3 or more goals in a match." : "";

  return (
    <Modal show={show} onHide={handleClose} centered>
      <Modal.Header closeButton>
        <Modal.Title>{bonusTitle}</Modal.Title>
      </Modal.Header>
      <Modal.Body>
        <p>{description}</p>
        <p style={{width: 'calc(100% - 1rem)', margin: '0rem 0rem'}} className='small-text warning-text'><small>A bonus can only be used once per season and only one bonus can be used per gameweek.</small></p>
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
