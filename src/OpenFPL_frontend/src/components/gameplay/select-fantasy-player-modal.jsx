import React, { useContext } from 'react';
import { Modal, Button, Container, Row, Col } from 'react-bootstrap';
import { DataContext } from "../../contexts/DataContext";

const SelectFantasyPlayerModal = ({ show, handleClose, handleConfirm, fantasyTeam, positions, bonusType }) => {
  
  const { players, teams } = useContext(DataContext);
  
  const filteredPlayers = positions 
  ? players.filter(player => positions.includes(player.position) && 
  fantasyTeam.players.some(fantasyPlayer => fantasyPlayer.id === player.id))
  : players.filter(player => fantasyTeam.players.some(fantasyPlayer => fantasyPlayer.id === player.id));
  
  const bonusTitle = (bonusType == 1) ? "Bonus: Goal Getter" :
                      (bonusType == 2) ? "Bonus: Pass Master" :
                      (bonusType == 3) ? "Bonus: No Entry" :
                      (bonusType == 5) ? "Bonus: Safe Hands" : "";

const description = (bonusType == 1) ? "Play your Goal Getter bonus to receive triple points for each goal scored for any selected player." :
  (bonusType == 2) ? "Play your Pass Master bonus to receive triple points for each assist for any selected player." :
  (bonusType == 3) ? "Play your No Entry bonus to receieve triple points on any defenders score if they keep a clean sheet." :
  (bonusType == 5) ? "Play your Safe Hands bonus to receieve a X3 multiplier on your goalkeeper if they make 5 saves in a match." : "";


  const handleSubmit = (data) => {
    handleConfirm(data);
  };
  
  return (
    <Modal show={show} onHide={handleClose} centered>
      <Modal.Header closeButton>
        <Modal.Title>{bonusTitle}</Modal.Title>
      </Modal.Header>
      <Modal.Body>    
        <p>{description}</p>
        <p style={{width: 'calc(100% - 1rem)', margin: '0rem 0rem'}} className='small-text warning-text'><small>A bonus can only be used once per season and only one bonus can be used per gameweek.</small></p>
    
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
                <p className='small-text m-0'>{`£${(Number(player.value) / 4).toFixed(2)}m`}</p>
              </Col>
              <Col xs={3} className='d-flex align-self-center'>
                <Button className="w-100" variant="primary" onClick={() => { handleSubmit({ playerId: player.id, bonusType }); }}>
                  <small>Select</small>
                </Button>
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
