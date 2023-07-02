import React, { useEffect, useState, useContext } from 'react';
import { Card, Spinner, Dropdown, Table, Button, Form, Modal, ButtonGroup, Col, Row } from 'react-bootstrap';
import { player_canister as player_canister } from '../../../../declarations/player_canister';
import { OpenFPL_backend as open_fpl_backend } from '../../../../declarations/OpenFPL_backend';
import { format } from 'date-fns';
import { Actor } from "@dfinity/agent";
import { hasFlag } from 'country-flag-icons'
import getFlag from '../country-flag';
import { getAgeFromDOB } from '../helpers';

import { AuthContext } from "../../contexts/AuthContext";

const POSITION_LABELS = ["GK", "DEF", "MID", "FWD"];

const PlayerValuations = ({ isActive }) => {
  const { authClient } = useContext(AuthContext);
  const [isLoading, setIsLoading] = useState(false);
  const [viewData, setViewData] = useState([]);
  const [teams, setTeamsData] = useState([]);
  const [filterTeam, setFilterTeam] = useState(0);
  const [filterPosition, setFilterPosition] = useState(-1);
  const [remainingVotes, setRemainingVotes] = useState(20);
  const [showConfirmModal, setShowConfirmModal] = useState(false);
  const [selectedVote, setSelectedVote] = useState(null);
  const [selectedPlayer, setSelectedPlayer] = useState(null);
  const [teamColours, setTeamColours] = useState({});
  const [page, setPage] = useState(0);
  const count = 25;

  useEffect(() => {
    const fetchData = async () => {
      setIsLoading(true);
      const teamsData = await open_fpl_backend.getTeams();
      setTeamsData(teamsData);

      const teamColors = {};
        teamsData.forEach(team => {
        teamColors[team.id] = {
          primary: team.primaryColourHex,
          secondary: team.secondaryColourHex
        };
      });
      setTeamColours(teamColors);

      setIsLoading(false);
    };

    if (isActive) {
      fetchData();
    }
  }, [isActive]);

  useEffect(() => {
    if(!teams){
      return;
    }
    
    const fetchData = async () => {
      setIsLoading(true);
      await fetchViewData(filterTeam, filterPosition, page);
      setIsLoading(false);
    };

    if (isActive) {
      fetchData();
    }
  }, [isActive, teams, page, filterTeam, filterPosition]);
  
  const handleFilterTeamChange = async (event) => {
    setIsLoading(true);
    setFilterTeam(Number(event.target.value));
    setPage(0);
    await fetchViewData(event.target.value, filterPosition, 0);
    setIsLoading(false);
  };
  
  const handleFilterPositionChange = async (event) => {
    setIsLoading(true);
    setFilterPosition(Number(event.target.value));
    setPage(0);
    await fetchViewData(filterTeam, event.target.value, 0);
  };

  const fetchViewData = async (teamId, positionId, pageNumber) => {
    const identity = authClient.getIdentity();
    Actor.agentOf(player_canister).replaceIdentity(identity);
    const playersData = await player_canister.getPlayers(Number(teamId), Number(positionId), Number(pageNumber) * Number(count), Number(count));
    setViewData(playersData);
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

  const handlePageChange = (change) => {
    setPage((prevPage) => prevPage + change);
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
        <p>You can rate up to 20 players per gameweek. Your votes are added to the total for each possible change and the DAO will update the players value 
          at the end of the gameweek. You can only vote for a player once per season.</p>

        <p>You have {remainingVotes}/20 players you can vote for this week.</p>

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
              <th>Voting</th>
            </tr>
          </thead>
          <tbody>
            {viewData && viewData.players && viewData.players.map(player => (
              <tr key={player.id}>
                <td className='align-middle'>
                  <div className='d-flex flex-column justify-content-center'>
                    <span>{(player.shirtNumber == 0) ? '-' : player.shirtNumber}</span>
                  </div>
                </td>
                <td className='align-middle'>
                  <div className='d-flex flex-column justify-content-center'>
                    <span>{POSITION_LABELS[player.position]}</span>
                    <small className='text-muted'>Age: {getAgeFromDOB(Number(player.dateOfBirth))}</small>
                  </div>
                </td>
                <td className='text-left align-middle'>
                  <div className='d-flex flex-column justify-content-center'>
                    <div style={{
                      display: 'inline-block',
                      paddingBottom: '2px'
                    }}>
                      <span className='mb-0'>
                        {getFlag(player.nationality)} {player.lastName}<br />
                        <small className='text-muted'>{player.firstName}</small>
                      </span>
                      <div style={{
                        display: 'flex',
                        justifyContent: 'space-between',
                        alignItems: 'center',
                        paddingBottom: '2px'
                      }}>
                        <div style={{
                          borderBottom: `3px solid ${(teamColours[player.teamId] || {}).secondary || 'defaultColor'}`,
                          width: '50%',
                        }}></div>
                        <span style={{ width: '50%', textAlign: 'right' }}>
                          <small>{teams.find(team => team.id === player.teamId)?.friendlyName}</small>
                        </span>
                      </div>
                      <div style={{
                        borderBottom: `3px solid ${(teamColours[player.teamId] || {}).primary || 'defaultColor'}`,
                        width: '100%',
                        paddingBottom: '2px'
                      }}></div>

                    </div>
                  </div>
                </td>
                <td className='align-middle text-center'>
                  <h5 className='ml-4'>£{parseFloat(player.value).toFixed(2)}m</h5>
                </td>
                <td>
                  <Row className="no-gutters">
                    <Col>
                      <Button variant="danger" style={{width: '100%'}} onClick={() => handleVote("negative", player)}>Update -£0.25m</Button>
                      <p className="text-center mt-1">50%</p>
                    </Col>
                    <Col>
                      <Button variant="success" style={{width: '100%'}} onClick={() => handleVote("positive", player)}>Update +£0.25m</Button>
                      <p className="text-center mt-1">50%</p>
                    </Col>
                  </Row>
                  <Row>
                    <Col>
                      <p className="text-center"><small>Total Weekly Votes: 0</small></p>
                    </Col>
                  </Row>
                </td>
              </tr>
            ))}
          </tbody>
        </Table>
        <div className="d-flex justify-content-center mt-3 mb-3">
          <ButtonGroup>
            <Button className="primary" onClick={() => handlePageChange(-1)} disabled={page === 0}>
              Prior
            </Button>
            <div className="d-flex align-items-center">
              <p className="mb-0 mx-4">Page {page + 1} / {Math.ceil(viewData.totalEntries / count)}</p>
            </div>

            <Button className="primary" onClick={() => handlePageChange(1)} disabled={(page + 1) >= Math.ceil(viewData.totalEntries / count)}>
              Next
            </Button>
          </ButtonGroup>
        </div>
      </Card.Body>
    </Card>
  );
};

export default PlayerValuations;
