import React, { useEffect, useState, useContext } from 'react';
import { Card, Spinner, Dropdown, Table, Button, Form, Modal, DropdownButton, Col, Row } from 'react-bootstrap';
import { player_canister as player_canister } from '../../../../declarations/player_canister';
import { OpenFPL_backend as open_fpl_backend } from '../../../../declarations/OpenFPL_backend';
import { format } from 'date-fns';
import { Actor } from "@dfinity/agent";
import { hasFlag } from 'country-flag-icons'
import getFlag from '../country-flag';

import { AuthContext } from "../../contexts/AuthContext";

const POSITION_LABELS = ["GK", "DEF", "MID", "FWD"];

const PlayerValuations = ({ isActive }) => {
  const { authClient } = useContext(AuthContext);
  const [isLoading, setIsLoading] = useState(false);
  const [players, setPlayersData] = useState([]);
  const [teams, setTeamsData] = useState([]);
  const [filterTeam, setFilterTeam] = useState(0);
  const [filterPosition, setFilterPosition] = useState(-1);
  const [remainingVotes, setRemainingVotes] = useState(20);
  const [showConfirmModal, setShowConfirmModal] = useState(false);
  const [selectedVote, setSelectedVote] = useState(null);
  const [selectedPlayer, setSelectedPlayer] = useState(null);

  useEffect(() => {
    const fetchData = async () => {
      setIsLoading(true);
      const teamsData = await open_fpl_backend.getTeams();
      setTeamsData(teamsData);
      setIsLoading(false);
    };

    if (isActive) {
      fetchData();
    }
  }, [isActive, filterTeam]);

  useEffect(() => {
    if(!teams){
      return;
    }
    
    const fetchData = async () => {
      setIsLoading(true);
      const identity = authClient.getIdentity();
      Actor.agentOf(player_canister).replaceIdentity(identity);
      const playersData = await player_canister.getPlayers(Number(filterTeam), Number(filterPosition));
      setPlayersData(playersData);
      setIsLoading(false);
    };

    if (isActive) {
      fetchData();
    }
  }, [isActive, teams]);
  
  const handleFilterTeamChange = async (event) => {
    setIsLoading(true);
    setFilterTeam(Number(event.target.value));
    
    const identity = authClient.getIdentity();
    Actor.agentOf(player_canister).replaceIdentity(identity);
    const playersData = await player_canister.getPlayers(Number(event.target.value), Number(filterPosition));
    setPlayersData(playersData);
    console.log(playersData)
    
    setIsLoading(false);
  };
  
  const handleFilterPositionChange = async (event) => {
   setIsLoading(true);
    setFilterPosition(Number(event.target.value));
    
    const identity = authClient.getIdentity();
    Actor.agentOf(player_canister).replaceIdentity(identity);
    const playersData = await player_canister.getPlayers(Number(filterTeam), Number(event.target.value));
    setPlayersData(playersData);

    setIsLoading(false);
  };

  if (isLoading) {
    return (
      <div className="customOverlay d-flex flex-column align-items-center justify-content-center">
        <Spinner animation="border" />
        <p className='text-center mt-1'>Loading Player Valuations</p>
      </div>
    );
  }

  const getAgeFromDOB = dob => {
    const birthDate = new Date(dob / 1000000);
    const ageDifMs = Date.now() - birthDate.getTime();
    const ageDate = new Date(ageDifMs);
    return Math.abs(ageDate.getUTCFullYear() - 1970);
  };
  
  const handleVote = (voteType, player) => {
    setSelectedVote(voteType);
    setSelectedPlayer(player);
    setShowConfirmModal(true);
  };

  // function to handle vote confirmation
  const confirmVote = () => {
    // Subtract from remaining votes
    setRemainingVotes(remainingVotes - 1);
    
    // Apply vote logic here (add to total votes, calculate percentage, etc.)
  
    // Close modal
    setShowConfirmModal(false);
  };

  // Modal for vote confirmation
  const VoteConfirmationModal = () => (
    <Modal show={showConfirmModal} onHide={() => setShowConfirmModal(false)}>
      <Modal.Header closeButton>
        <Modal.Title>Confirm Your Vote</Modal.Title>
      </Modal.Header>
      <Modal.Body>Are you sure you want to rate {selectedPlayer?.lastName} as {selectedVote}?</Modal.Body>
      <Modal.Footer>
        <Button variant="secondary" onClick={() => setShowConfirmModal(false)}>Cancel</Button>
        <Button variant="primary" onClick={confirmVote}>Confirm</Button>
      </Modal.Footer>
    </Modal>
  );

  // If not loading, render your component
  return (
    <Card className="custom-card mt-1">
      <Card.Body>
        <h2>Player Valuations</h2>
        <p>You can rate up to 20 players per gameweek. Your votes are added to the total for each possible change and the DAO will update the players value at the end of the gameweek.</p>

        <p>You have {remainingVotes}/20 votes left for this week.</p>

        {/* Add the modal */}
        <VoteConfirmationModal />

        <Row className="mb-4">
          <Col>
            <Form.Group controlId="filterTeam">
              <Form.Label>Filter Team:</Form.Label>
              <Form.Control as="select" value={filterTeam || 0} onChange={handleFilterTeamChange}>
                  <option value="">All</option>
                    {teams.map((team) => (
                    <option key={team.id} value={team.id}>
                        {team.name}
                    </option>
                    ))}
              </Form.Control>
            </Form.Group>  
          </Col>
          <Col>
            <Form.Group controlId="filterPosition">
              <Form.Label>Filter Position:</Form.Label>
              <Form.Control as="select" value={filterPosition || 0} onChange={handleFilterPositionChange}>
                  <option value="-1">All</option>
                  <option value="0">Goalkeeper</option>
                  <option value="1">Defender</option>
                  <option value="2">Midfielder</option>
                  <option value="3">Forward</option>
              </Form.Control>
            </Form.Group>  
          </Col>
        </Row>

        <Table striped bordered hover responsive="md">
          <thead>
            <tr>
              <th>#</th>
              <th>Position</th>
              <th>Name</th>
              <th>Value</th>
              <th></th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            {players && players.map(player => (
              <tr key={player.id}>
                <td>{(player.shirtNumber == 0) ? '-' : player.shirtNumber}</td>
                <td>{POSITION_LABELS[player.position]}</td>
                <td className='text-left'>
                  
                  <p className='mb-0'>{getFlag(player.nationality)} {player.lastName}</p>
                  <small className='text-muted'>{player.firstName}</small><br />
                  <small className='text-muted'>Age: {getAgeFromDOB(Number(player.dateOfBirth))}</small>
                </td>
                <td className='align-middle'>
                  <h5 className='ml-4'>£{parseFloat(player.value).toFixed(2)}m</h5>
                </td>
                <td>
                  <Button variant="danger" onClick={() => handleVote("negative", player)}>-</Button>
                  <p>{player.negativeVotes}%</p>
                  <p>{player.totalVotes}</p>
                </td>
                <td>
                  <Button variant="warning" onClick={() => handleVote("neutral", player)}>0</Button>
                  <p>{player.neutralVotes}%</p>
                  <p>{player.totalVotes}</p>
                </td>
                <td>
                  <Button variant="success" onClick={() => handleVote("positive", player)}>+</Button>
                  <p>{player.positiveVotes}%</p>
                  <p>{player.totalVotes}</p>
                </td>
              </tr>
            ))}
          </tbody>
        </Table>
      </Card.Body>
    </Card>
  );
};

export default PlayerValuations;
