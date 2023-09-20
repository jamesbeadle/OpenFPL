import React, { useEffect, useState, useContext } from 'react';
import { Card, Spinner, Table, Button, Form, Modal, ButtonGroup, Col, Row } from 'react-bootstrap';
import getFlag from '../country-flag';
import { getAgeFromDOB } from '../helpers';
import { DataContext } from "../../contexts/DataContext";
import { SnsGovernanceContext } from "../../contexts/SNSGovernanceContext";

const POSITION_LABELS = ["GK", "DEF", "MID", "FWD"];
const COUNT = 25;

const PlayerValuations = ({ isActive }) => {
  const { players, teams } = useContext(DataContext);
  const { alreadyValuedPlayerIds, remainingWeeklyValuationVotes, revaluePlayerUp, revaluePlayerDown } = useContext(SnsGovernanceContext);
  
  const [viewData, setViewData] = useState([]);
  const [filter, setFilter] = useState({ team: 0, position: -1, page: 0 });
  const [remainingVotes, setRemainingVotes] = useState(remainingVotes); 
  const [modalState, setModalState] = useState({ show: false, voteType: null, player: null });
  const [teamColours, setTeamColours] = useState({});
  const [isLoading, setIsLoading] = useState(false);

  useEffect(() => {
    if (!isActive) return;
    
    const teamColors = teams.reduce((acc, team) => {
      acc[team.id] = { primary: team.primaryColourHex, secondary: team.secondaryColourHex };
      return acc;
    }, {});
    
    setTeamColours(teamColors);
    fetchData();
  }, [isActive, teams, filter]);

  const fetchData = async () => {
    setIsLoading(true);
    await fetchViewData(filter.team, filter.position, filter.page);
    setIsLoading(false);
  };

  const fetchViewData = (teamId, positionId, pageNumber) => {
    const filteredPlayers = players
      .filter(player => (teamId === 0 || player.teamId === teamId) && (positionId === -1 || player.position === positionId))
      .slice(pageNumber * COUNT, (pageNumber + 1) * COUNT);
    
    setViewData({ players: filteredPlayers, totalEntries: filteredPlayers.length });
  };
  
  const handleFilterChange = (field, value) => {
    setFilter(prevFilter => ({ ...prevFilter, [field]: value, page: 0 }));
  };

  if (isLoading) {
    return (
      <div className="customOverlay d-flex flex-column align-items-center justify-content-center">
        <Spinner animation="border" />
        <p className='text-center mt-1'>Loading Player Valuations</p>
      </div>
    );
  }
  
  const handleVote = async (voteType, playerId) => {
    setIsLoading(true);
    try {
      switch(voteType){
        case "positive":
          revaluePlayerUp(playerId);
          break;
        case "negative":
          revaluePlayerDown(playerId);
          break;
        default:
          break
      }
    } catch (error) {
      console.error("Error during the voting process:", error);
    } finally {
      setIsLoading(false);
    }
  };
  
  const confirmVote = () => {
    setRemainingVotes(prevVotes => prevVotes - 1);   
    setModalState({ show: false, voteType: null, player: null });
  };
  
  const handlePageChange = (change) => {
    setFilter(prevFilter => ({ ...prevFilter, page: filter.page + change }));
  };

  const VoteConfirmationModal = () => (
    <Modal show={modalState.show} onHide={() => setModalState({ show: false, voteType: null, player: null })}>
      <Modal.Header closeButton>
        <Modal.Title>Confirm Your Vote</Modal.Title>
      </Modal.Header>
      <Modal.Body>Are you sure you want to rate {modalState.player?.lastName} as {modalState.voteType}?</Modal.Body>
      <Modal.Footer>
        <Button variant="secondary" onClick={() => setModalState({ show: false, voteType: null, player: null })}>Cancel</Button>
        <Button variant="primary" onClick={confirmVote}>Confirm</Button>
      </Modal.Footer>
    </Modal>
  );

  return (
    <Card className="custom-card mt-1">
      <Card.Body>
        <h2>Player Valuations</h2>
        <p>You can rate up to 20 players per gameweek. Your votes are added to the total for each possible change and the DAO will update the players value 
          at the end of the gameweek. You can only vote for a player once per season.</p>

        <p>You have {remainingVotes}/20 players you can vote for this week.</p>

        <VoteConfirmationModal />

        <Row className="mb-4">
          <Col>
            <Form.Group controlId="filterTeam">
              <Form.Label>Filter Team:</Form.Label>
              <Form.Control as="select" value={filter.team || 0} onChange={(e) => handleFilterChange("team", +e.target.value)}>
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
              <Form.Control as="select" value={filter.position || -1} onChange={(e) => handleFilterChange("position", +e.target.value)}>
                  <option value="-1">All</option>
                  <option value="0">Goalkeeper</option>
                  <option value="1">Defender</option>
                  <option value="2">Midfielder</option>
                  <option value="3">Forward</option>
              </Form.Control>
            </Form.Group>  
          </Col>
        </Row>

        <Table responsive bordered className="table-fixed light-table">
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
                    <span>{(player.shirtNumber === 0) ? '-' : player.shirtNumber}</span>
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
                  { alreadyValuedPlayerIds.includes(playerId) ? 
                    <p className="text-muted">Already Valued</p> :
                      
                    <Row className="no-gutters">
                      <Col>
                        <Button 
                          variant="danger" 
                          style={{width: '100%'}} 
                          onClick={() => handleVote("negative", player.id)} 
                          disabled={remainingWeeklyValuationVotes.length === 0}
                        >
                          Update -£0.25m
                        </Button>
                        <p className="text-center mt-1">50%</p>
                      </Col>
                      <Col>
                        <Button 
                          variant="success" 
                          style={{width: '100%'}} 
                          onClick={() => handleVote("positive", player.id)} 
                          disabled={remainingWeeklyValuationVotes.length === 0}
                        >
                          Update +£0.25m
                        </Button>
                        <p className="text-center mt-1">50%</p>
                      </Col>
                    </Row>
                  }
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
            <Button className="primary" onClick={() => handlePageChange(-1)} disabled={filter.page === 0}>
              Prior
            </Button>
            <div className="d-flex align-items-center">
              <p className="mb-0 mx-4">Page {filter.page + 1} / {Math.ceil(viewData.totalEntries / COUNT)}</p>
            </div>

            <Button className="primary" onClick={() => handlePageChange(1)} disabled={(filter.page + 1) >= Math.ceil(viewData.totalEntries / COUNT)}>
              Next
            </Button>
          </ButtonGroup>
        </div>
      </Card.Body>
    </Card>
  );
};

export default PlayerValuations;
