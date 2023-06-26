import React, { useState, useContext } from 'react';
import { Modal, Button, Form, Spinner } from 'react-bootstrap';
import { OpenFPL_backend as open_fpl_backend } from '../../../../declarations/OpenFPL_backend';
import { Actor } from "@dfinity/agent";
import { AuthContext } from "../../contexts/AuthContext";
import CreateFixtureProposal from './proposals/fixtures/create-fixture-proposal';
import AddPlayerProposal from './proposals/player/add-player-proposal';
import PlayerInjuryProposal from './proposals/player/player-injury-proposal';
import RemoveFixtureProposal from './proposals/fixtures/remove-fixture-proposal';
import UpdateFixtureProposal from './proposals/fixtures/update-fixture-proposal';
import PlayerRetirementProposal from './proposals/player/player-retirement-proposal';
import TransferPlayerProposal from './proposals/player/transfer-player-proposal';
import AddSeasonProposal from './proposals/season/add-season-proposal';
import RemoveSeasonProposal from './proposals/season/remove-season-proposal';
import UpdateSeasonProposal from './proposals/season/update-season-proposal';
import RelegateTeamProposal from './proposals/team/relegate-team-proposal';
import PromoteTeamProposal from './proposals/team/promote-team-proposal';
import UpdateTeamProposal from './proposals/team/update-team-proposal';
import AddMemberProposal from './proposals/validation-council/add-member-proposal';
import RemoveMemberProposal from './proposals/validation-council/remove-member-proposal';
import UpdateSystemProposal from './proposals/general/update-system-proposal';

const proposalCategories = [
  { label: 'Fixture', value: 'fixture' },
  { label: 'Player', value: 'player' },
  { label: 'Season', value: 'season' },
  { label: 'Team', value: 'team' },
  { label: 'Validation Council', value: 'validation-council' },
  { label: 'General', value: 'general' }
];

const proposalTypes = [
  { label: 'Create Fixture Proposal', value: 'create-fixture', category: 'fixture', component: CreateFixtureProposal },
  { label: 'Remove Fixture Proposal', value: 'remove-fixture', category: 'fixture', component: RemoveFixtureProposal },
  { label: 'Update Fixture Proposal', value: 'update-fixture', category: 'fixture', component: UpdateFixtureProposal },
  { label: 'Player Injury Proposal', value: 'player-injury', category: 'player', component: PlayerInjuryProposal },
  { label: 'Transfer Player Proposal', value: 'transfer-player', category: 'player', component: TransferPlayerProposal },
  { label: 'Add Player Proposal', value: 'add-player', category: 'player', component: AddPlayerProposal },
  { label: 'Update Player Proposal', value: 'update-player', category: 'player', component: TransferPlayerProposal },
  { label: 'Player Retirement Proposal', value: 'player-retirement', category: 'player', component: PlayerRetirementProposal },
  { label: 'Add Season Proposal', value: 'add-season', category: 'season', component: AddSeasonProposal },
  { label: 'Remove Season Proposal', value: 'remove-season', category: 'season', component: RemoveSeasonProposal },
  { label: 'Update Season Proposal', value: 'update-season', category: 'season', component: UpdateSeasonProposal },
  { label: 'Relegate Team Proposal', value: 'relegate-team', category: 'team', component: RelegateTeamProposal },
  { label: 'Promote Team Proposal', value: 'promote-team', category: 'team', component: PromoteTeamProposal },
  { label: 'Update Team Proposal', value: 'update-team', category: 'team', component: UpdateTeamProposal },
  { label: 'Add Member Proposal', value: 'add-member', category: 'validation-council', component: AddMemberProposal },
  { label: 'Remove Member Proposal', value: 'remove-member', category: 'validation-council', component: RemoveMemberProposal },
  { label: 'Update System Proposal', value: 'update-system', category: 'general', component: UpdateSystemProposal }
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
