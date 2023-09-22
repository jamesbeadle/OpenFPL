import React, { useState } from 'react';
import { Modal, Button, Form, Spinner } from 'react-bootstrap';
import AddInitialFixturesProposal from './proposals/fixtures/add-initial-fixtures';
import RescheduleFixtureProposal from './proposals/fixtures/reschedule-fixture-proposal';
import PlayerInjuryProposal from './proposals/player/player-injury-proposal';
import TransferPlayerProposal from './proposals/player/transfer-player-proposal';
import LoanPlayerProposal from './proposals/player/loan-player-proposal';
import AddPlayerProposal from './proposals/player/add-player-proposal';
import UpdatePlayerProposal from './proposals/player/update-player-proposal';
import RetirePlayerProposal from './proposals/player/retire-player-proposal';
import UnretirePlayerProposal from './proposals/player/unretire-player-proposal';
import UpdateTeamProposal from './proposals/team/update-team-proposal';
import PromoteFormerTeamProposal from './proposals/team/promote-former-team-proposal';
import PromoteNewTeamProposal from './proposals/team/promote-new-team-proposal';
import RevaluePlayerProposal from './proposals/player/revalue-player-proposal';
import { useHistory } from 'react-router-dom';

const proposalCategories = [
  { label: 'Player', value: 'player' },
  { label: 'Fixtures', value: 'fixture' },
  { label: 'Team', value: 'team' }
];

const proposalTypes = [
  { label: 'Revalue Player Proposal', value: 'revalue-player', category: 'player', component: RevaluePlayerProposal },
  { label: 'Player Injury Proposal', value: 'player-injury', category: 'player', component: PlayerInjuryProposal },
  { label: 'Create Player Proposal', value: 'player-retirement', category: 'player', component: AddPlayerProposal },
  { label: 'Update Player Proposal', value: 'add-season', category: 'player', component: UpdatePlayerProposal },
  { label: 'Transfer Player Proposal', value: 'transfer-player', category: 'player', component: TransferPlayerProposal },
  { label: 'Loan Player Proposal', value: 'add-player', category: 'player', component: LoanPlayerProposal },
  { label: 'Recall Loan Proposal', value: 'update-player', category: 'player', component: TransferPlayerProposal },
  { label: 'Retire Player Proposal', value: 'remove-season', category: 'player', component: RetirePlayerProposal },
  { label: 'Unretire Player Proposal', value: 'update-season', category: 'player', component: UnretirePlayerProposal },
  { label: 'Add Fixture Data', value: 'add-fixture-data', category: 'fixture', component: null },
  { label: 'Reschedule Fixture Proposal', value: 'reschedule-fixture', category: 'fixture', component: RescheduleFixtureProposal },
  { label: 'Add Initial Fixtures Proposal', value: 'add-initial-fixtures', category: 'fixture', component: AddInitialFixturesProposal },
  { label: 'Promote Former Team Proposal', value: 'promote-former-team', category: 'team', component: PromoteFormerTeamProposal },
  { label: 'Promote New Team Proposal', value: 'promote-new-team', category: 'team', component: PromoteNewTeamProposal },
  { label: 'Update Team Proposal', value: 'update-team', category: 'team', component: UpdateTeamProposal }
];

const AddProposalModal = ({ show, onHide }) => {
  
  const [isLoading, setIsLoading] = useState(false);
  const [selectedCategory, setSelectedCategory] = useState(null);
  const [selectedType, setSelectedType] = useState(null);
  const history = useHistory();

  const handleSubmit = async (event) => {
    event.preventDefault();
    setIsLoading(true);
    onHide(true);
  };

  const hideModal = () => {
    onHide(false);
  };

  const handleTypeChange = (e) => {
    setSelectedType(e.target.value);
    const selectedComponent = proposalTypes.find(type => type.value === e.target.value).component;
    
    if (!selectedComponent) {
      history.push('/add-fixture-data');
    }
  };

  const handleCategoryChange = (e) => {
    setSelectedCategory(e.target.value);
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
            <Form.Control as="select" defaultValue="" onChange={handleCategoryChange}>
              <option disabled value="">Select a proposal category</option>
              {proposalCategories.map((category, index) => (
                <option key={index} value={category.value}>{category.label}</option>
              ))}
            </Form.Control>
          </Form.Group>
          
          <Form.Group className="mb-3">
            <Form.Label>Proposal Type</Form.Label>
            <Form.Control as="select" defaultValue="" onChange={handleTypeChange}>
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
