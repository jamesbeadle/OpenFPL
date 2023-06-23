import React, { useState } from 'react';
import { Modal, Button, Form, Spinner } from 'react-bootstrap';

const UpgradeMembershipModal = ({ show, onHide }) => {

    const [isLoading, setIsLoading] = useState(false);

    const hideModal = () => {
        setPicture(null);
        setPictureError(null);
        onHide(false);
    };
    
    const handleSubmit = async (event) => {
        event.preventDefault();
    
        onHide(true);
    };

    return (
        <Modal show={show} onHide={hideModal}>
            {isLoading && (
                <div className="customOverlay d-flex flex-column align-items-center justify-content-center">
                <Spinner animation="border" />
                <p className='text-center mt-1'>Loading</p>
                </div>
            )}
            <Modal.Header closeButton>
                <Modal.Title>Diamond Membership</Modal.Title>
            </Modal.Header>
            <Modal.Body>
                <p>More details coming soon.</p>
            </Modal.Body>
            <Modal.Footer>
                <Button variant="secondary" onClick={hideModal}>Cancel</Button>
                <Button className="custom-button" onClick={handleSubmit}>Save</Button>
            </Modal.Footer>
        </Modal>
        
    );
};

export default UpgradeMembershipModal;
