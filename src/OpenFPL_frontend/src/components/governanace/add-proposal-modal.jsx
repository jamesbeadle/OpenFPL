import React, { useState, useContext } from 'react';
import { Modal, Button, Form, Spinner } from 'react-bootstrap';
import { AuthContext } from "../../contexts/AuthContext";
import AddInitialFixturesProposal from './proposals/fixtures/add-initial-fixtures';
import RescheduleFixtureProposal from './proposals/fixtures/reschedule-fixture-proposal';
import PlayerInjuryProposal from './proposals/player/player-injury-proposal';
import TransferPlayerProposal from './proposals/player/transfer-player-proposal';
import LoanPlayerProposal from './proposals/player/loan-player-proposal';
import AddPlayerProposal from './proposals/player/add-player-proposal';
import UpdatePlayerProposal from './proposals/player/update-player-proposal';
import RetirePlayerProposal from './proposals/player/retire-player-proposal';
import UnretirePlayerProposal from './proposals/player/unretire-player-proposal';
import PromoteTeamProposal from './proposals/team/promote-team-proposal';
import RelegateTeamProposal from './proposals/team/relegate-team-proposal';
import UpdateTeamProposal from './proposals/team/update-team-proposal';
import UpdateSystemProposal from './proposals/general/update-system-proposal';

const proposalCategories = [
  { label: 'Player', value: 'player' },
  { label: 'Fixtures', value: 'fixture' },
  { label: 'Team', value: 'team' },
  { label: 'General', value: 'general' }
];

const proposalTypes = [
  { label: 'Add Initial Fixtures Proposal', value: 'add-initial-fixtures', category: 'fixture', component: AddInitialFixturesProposal },
  { label: 'Reschedule Fixture Proposal', value: 'reschedule-fixture', category: 'fixture', component: RescheduleFixtureProposal },
  { label: 'Player Injury Proposal', value: 'player-injury', category: 'player', component: PlayerInjuryProposal },
  { label: 'Transfer Player Proposal', value: 'transfer-player', category: 'player', component: TransferPlayerProposal },
  { label: 'Loan Player Proposal', value: 'add-player', category: 'player', component: LoanPlayerProposal },
  { label: 'Recall Loan Proposal', value: 'update-player', category: 'player', component: TransferPlayerProposal },
  { label: 'Create Player Proposal', value: 'player-retirement', category: 'player', component: AddPlayerProposal },
  { label: 'Update Player Proposal', value: 'add-season', category: 'player', component: UpdatePlayerProposal },
  { label: 'Retire Player Proposal', value: 'remove-season', category: 'player', component: RetirePlayerProposal },
  { label: 'Unretire Player Proposal', value: 'update-season', category: 'player', component: UnretirePlayerProposal },
  { label: 'Promote Team Proposal', value: 'promote-team', category: 'team', component: PromoteTeamProposal },
  { label: 'Relegate Team Proposal', value: 'relegate-team', category: 'team', component: RelegateTeamProposal },
  { label: 'Update Team Proposal', value: 'update-team', category: 'team', component: UpdateTeamProposal },
  { label: 'Update System Proposal', value: 'update-system', category: 'general', component: UpdateSystemProposal }
];

const AddProposalModal = ({ show, onHide }) => {
  
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
