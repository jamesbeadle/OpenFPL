import React from 'react';
import { Modal, Button} from 'react-bootstrap';

const ConfirmClearDraftModal = ({ show, onHide, onConfirm  }) => {
    
    return (
        <Modal show={show} onHide={onHide} centered>
            <Modal.Header closeButton>Confirm Clear Draft</Modal.Header>
            <Modal.Body>
                <h1>Please confirm you want to clear the draft from your cache.</h1>
            </Modal.Body>
            <Modal.Footer>
                <Button variant="secondary" onClick={onHide}>
                    Cancel
                </Button>
                <Button variant="primary" onClick={onConfirm}>
                    Confirm
                </Button>
            </Modal.Footer>
        </Modal>
    );
   
};

export default ConfirmClearDraftModal;
