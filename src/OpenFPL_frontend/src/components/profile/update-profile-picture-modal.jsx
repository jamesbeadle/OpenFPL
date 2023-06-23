import React, { useState } from 'react';
import { Modal, Button, Form, Spinner } from 'react-bootstrap';

const UpdateProfilePictureModal = ({ show, onHide }) => {

    const [isLoading, setIsLoading] = useState(false);
    //const [backend] = useCanister("backend");
    const [picture, setPicture] = useState(null);
    const [pictureError, setPictureError] = useState(null);

    const maxPictureSize = 1000;

    const handleSubmit = async (event) => {
        event.preventDefault();
        
        if (picture && picture.size > maxPictureSize * 1024) {
            setPictureError(`Image size exceeds ${maxPictureSize}KB. Please choose a smaller image.`);
            return;
        }

        setIsLoading(true);
        // create a FileReader object
        const reader = new FileReader();
        // read the file as an ArrayBuffer
        reader.readAsArrayBuffer(picture);

        // when file reading is finished, convert it to a Uint8Array and send it to backend
        reader.onloadend = async () => {
            const arrayBuffer = reader.result;
            const uint8Array = new Uint8Array(arrayBuffer);
            
            // send the Uint8Array to the backend
            //await backend.updateProfilePicture(uint8Array);

            setPicture(null);
            setPictureError(null);
            onHide(true);
        };
    };

    const handlePictureChange = (event) => {
        if (event.target.files && event.target.files[0]) {
            const selectedPicture = event.target.files[0];
            if (selectedPicture.size > maxPictureSize * 1024) {
                setPictureError(`Image size exceeds ${maxPictureSize}KB. Please choose a smaller image.`);
                return;
            }
            setPicture(selectedPicture);
            setPictureError(null);
        }
    }

    const hideModal = () => {
        setPicture(null);
        setPictureError(null);
        onHide(false);
    };

    return (
        <Modal show={show} onHide={hideModal}>
            {isLoading && (
                <div className="customOverlay d-flex flex-column align-items-center justify-content-center">
                <Spinner animation="border" />
                <p className='text-center mt-1'>Saving Picture</p>
                </div>
            )}
            <Modal.Header closeButton>
                <Modal.Title>Set Profile Picture</Modal.Title>
            </Modal.Header>
            <Modal.Body>
                <Form onSubmit={handleSubmit}>
                <Form.Group className="mb-3">
                    <Form.Label>Profile Picture</Form.Label>
                        <Form.Control
                            type="file"
                            accept="image/*"
                            onChange={handlePictureChange}
                        />
                        {pictureError && <Form.Text className="text-danger">{pictureError}</Form.Text>}
                    </Form.Group>
                </Form>
            </Modal.Body>
            <Modal.Footer>
                <Button variant="secondary" onClick={hideModal}>Cancel</Button>
                <Button className="custom-button" onClick={handleSubmit}>Save</Button>
            </Modal.Footer>
        </Modal>
        
    );
};

export default UpdateProfilePictureModal;
