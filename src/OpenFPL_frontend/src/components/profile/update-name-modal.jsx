import React, { useState, useContext } from 'react';
import { Modal, Button, Form, Spinner } from 'react-bootstrap';
import { OpenFPL_backend as open_fpl_backend } from '../../../../declarations/OpenFPL_backend';
import { Actor } from "@dfinity/agent";
import { AuthContext } from "../../contexts/AuthContext";

const UpdateNameModal = ({ show, onHide, displayName }) => {
  
  const { authClient } = useContext(AuthContext);
  const [isLoading, setIsLoading] = useState(false);
  const [newDisplayName, setNewDisplayName] = useState(displayName);
  const [displayNameError, setDisplayNameError] = useState(null);

  const handleSubmit = async (event) => {
    event.preventDefault();

    if(displayName == newDisplayName){
      hideModal();
      return;
    }
    
    setIsLoading(true);
    let validName = await isDisplayNameValid();
    
    if (!validName) {
        setIsLoading(false);
        return;
    }
    
    try{
      const identity = authClient.getIdentity();
      Actor.agentOf(open_fpl_backend).replaceIdentity(identity);
      await open_fpl_backend.updateDisplayName(newDisplayName);
        
    } catch (error) {
      console.log(error);
    } finally {
      setNewDisplayName('');
      setDisplayNameError(null);
      onHide(true);
    }
    
    
  };

  const isDisplayNameValid = async () => {
    if(authClient == null){
      return;
    }
    try{
      const identity = authClient.getIdentity();
      Actor.agentOf(open_fpl_backend).replaceIdentity(identity);
      const isValid = await open_fpl_backend.isDisplayNameValid(newDisplayName);
    
      if (isValid) {
        setDisplayNameError(null);
      } else {
        setDisplayNameError('Display name must be between 3 and 20 characters long, no special characters and not already taken.');
      }
    
      return isValid;
    } catch (error) {
      console.log(error);
      return false;
    }
  };

  const hideModal = () => {
    setNewDisplayName(displayName);
    setDisplayNameError(null);
    onHide(false);
  };

  return (
    <Modal show={show} onHide={hideModal}>
      {isLoading && (
        <div className="customOverlay d-flex flex-column align-items-center justify-content-center">
          <Spinner animation="border" />
          <p className='text-center mt-1'>Saving Display Name</p>
        </div>
      )}
      <Modal.Header closeButton>
        <Modal.Title>Set Display Name</Modal.Title>
      </Modal.Header>
      <Modal.Body>
        <Form onSubmit={handleSubmit}>
        <Form.Group className="mb-3">
            <Form.Label>Display Name</Form.Label>
                <Form.Control
                    type="text"
                    placeholder="Enter display name"
                    value={newDisplayName}
                    onChange={(event) => setNewDisplayName(event.target.value)}
                />
                {displayNameError && <Form.Text className="text-danger">{displayNameError}</Form.Text>}
            </Form.Group>
        </Form>
      </Modal.Body>
      <Modal.Footer>
        <Button variant="secondary" onClick={hideModal}>Cancel</Button>
        <Button onClick={handleSubmit}>Save</Button>
      </Modal.Footer>
    </Modal>
    
  );
};

export default UpdateNameModal;
