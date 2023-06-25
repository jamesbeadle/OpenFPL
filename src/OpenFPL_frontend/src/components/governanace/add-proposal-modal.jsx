import React, { useState, useContext } from 'react';
import { Modal, Button, Form, Spinner } from 'react-bootstrap';
import { OpenFPL_backend as open_fpl_backend } from '../../../../declarations/OpenFPL_backend';
import { Actor } from "@dfinity/agent";
import { AuthContext } from "../../contexts/AuthContext";
import AddPlayerProposal from './proposals/player/add-player-proposal';
import PlayerInjuryProposal from './proposals/player/player-injury-proposal';

const proposalCategories = [
    { label: 'Player', value: 'player' },
    { label: 'Fixture', value: 'fixture' },
    { label: 'Season', value: 'season' },
    { label: 'General', value: 'general' }
];

const proposalTypes = [
    { label: 'Add Player Proposal', value: 'add-player', category: 'player', component: AddPlayerProposal },
    { label: 'Player Injury Proposal', value: 'player-injury', category: 'player', component: PlayerInjuryProposal }
];

const AddProposalModal = ({ show, onHide }) => {
  
  const { authClient } = useContext(AuthContext);
  const [isLoading, setIsLoading] = useState(false);
  const [selectedCategory, setSelectedCategory] = useState(null);
  const [selectedType, setSelectedType] = useState(null);

  const handleSubmit = async (event) => {
    event.preventDefault();
    setIsLoading(true);
    onHide(true);
  };

  const hideModal = () => {
    onHide(false);
  };

  const filteredTypes = proposalTypes.filter(type => type.category === selectedCategory);

  return (
    <Modal show={show} onHide={hideModal}>
      {isLoading && (
        <div className="customOverlay d-flex flex-column align-items-center justify-content-center">
          <Spinner animation="border" />
          <p className='text-center mt-1'>Saving Display Name</p>
        </div>
      )}
      <Modal.Header closeButton>
        <Modal.Title>Submit New Proposal</Modal.Title>
      </Modal.Header>
      <Modal.Body>
        <Form onSubmit={handleSubmit}>
          <Form.Group className="mb-3">
            <Form.Label>Proposal Category</Form.Label>
            <Form.Control as="select" defaultValue="" onChange={(e) => setSelectedCategory(e.target.value)}>
              <option disabled value="">Select a proposal category</option>
              {proposalCategories.map((category, index) => (
                <option key={index} value={category.value}>{category.label}</option>
              ))}
            </Form.Control>
          </Form.Group>
          
          <Form.Group className="mb-3">
            <Form.Label>Proposal Type</Form.Label>
            <Form.Control as="select" defaultValue="" onChange={(e) => setSelectedType(e.target.value)}>
              <option disabled value="">Select a proposal type</option>
              {filteredTypes.map((type, index) => (
                <option key={index} value={type.value}>{type.label}</option>
              ))}
            </Form.Control>
          </Form.Group>
          {selectedType && React.createElement(proposalTypes.find(type => type.value === selectedType).component)}

        </Form>
      </Modal.Body>
      <Modal.Footer>
        <Button variant="secondary" onClick={hideModal}>Cancel</Button>
        <Button onClick={handleSubmit}>Submit</Button>
      </Modal.Footer>
    </Modal>
    
  );
};

export default AddProposalModal;
