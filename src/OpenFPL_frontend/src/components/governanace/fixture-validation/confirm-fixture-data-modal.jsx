import React from 'react';
import { Modal, Button} from 'react-bootstrap';

const ConfirmFixtureDataModal = ({ show, onHide, onConfirm  }) => {
    
    return (
        <Modal show={show} onHide={onHide} centered>
            <Modal.Header closeButton>Confirm Fixture Data</Modal.Header>
            <Modal.Body>
                <h1>Please confirm your fixture data.</h1>
                <p className='warning-text small-text'>You will not be able to edit your submission and entries that differ from the accepted consensus data will not receive $FPL rewards. 
                If consensus has already been reached for the fixture your submission will also not be counted.</p>
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


export default ConfirmFixtureDataModal;
