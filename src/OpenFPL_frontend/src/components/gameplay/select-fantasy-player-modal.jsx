import React, { useContext } from 'react';
import { Modal, Button, Container, Row, Col } from 'react-bootstrap';
import { PlayerContext } from '../../contexts/PlayerContext';
import { TeamContext } from "../../contexts/TeamContext";

const SelectFantasyPlayerModal = ({ show, handleClose, handleConfirm, fantasyTeam, positions, bonusType }) => {
  
  const { players } = useContext(PlayerContext);
  const { teams } = useContext(TeamContext);
  console.log(fantasyTeam)
  const filteredPlayers = positions 
  ? players.filter(player => positions.includes(player.position) && fantasyTeam.players.some(fantasyPlayer => fantasyPlayer.id === player.id))
  : players.filter(player => fantasyTeam.players.some(fantasyPlayer => fantasyPlayer.id === player.id));



  const handleSubmit = (data) => {
    handleConfirm(data);
  };
  
  return (
    <Modal show={show} onHide={handleClose} centered>
      <Modal.Header closeButton>
        <Modal.Title>Select Player</Modal.Title>
      </Modal.Header>
      <Modal.Body>
        {filteredPlayers?.isLoading ? (
          <p>Loading...</p>
        ) : (
          <Container className="mt-4">
          {
          
          filteredPlayers.map((player) => (
            <Row key={player.id} className='mb-2'>
              <Col xs={1} className='d-flex align-self-center'>
                <p className='small-text m-0'>
                  {(() => {
                    switch (player.position) {
                      case 0:
                        return "GK";
                      case 1:
                        return "DF";
                      case 2:
                        return "MF";
                      case 3:
                        return "FW";
                    }})()}
                </p>
              </Col>
              <Col xs={4} className='d-flex align-self-center'>
                <p className='small-text m-0'>{player.firstName != "" ? player.firstName.charAt(0) + "." : ""} {player.lastName}</p>
              </Col>
              <Col xs={2} className='d-flex align-self-center'>
                <p className='small-text m-0'>{teams.find(team => team.id === player.teamId).abbreviatedName}</p>
              </Col>
              <Col xs={2} className='d-flex align-self-center'>
                <p className='small-text m-0'>{`£${player.value}m`}</p>
              </Col>
              <Col xs={3} className='d-flex align-self-center'>
                {fantasyTeam.players.some(teamPlayer => teamPlayer.id === player.id) 
                  ? <p className='small-text m-0 text-center w-100'>Added</p> 
                  : <Button className="w-100" variant="primary" onClick={() => { handleSubmit({ player, bonusType }); }}>
                      <small>Select</small>
                    </Button>
                }
              </Col>

            </Row>
          ))}
        </Container>
        )}
      </Modal.Body>
    </Modal>
  );
};

export default SelectFantasyPlayerModal;
