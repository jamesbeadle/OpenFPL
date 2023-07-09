import React from 'react';
import { Card, Button, Col, Row } from 'react-bootstrap';
import { StarIcon, StarOutlineIcon,  PlayerIcon, TransferIcon } from '../icons';
import getFlag from '../country-flag';

const PlayerDetails = ({ player, captainId, handleCaptainSelection, disableSellButton, handleSellPlayer }) => {
  
  const isCaptain = player.id === captainId;

  const handleStarClick = (event) => {
    event.stopPropagation();
    handleCaptainSelection(player.id);
  };

  return (      
    <Card className='mb-1 position-relative'>
      <Row className='mx-1 mt-2'>
        <Col xs={4} md={3}>
          <Row>
            <p className='text-center'>{player.position}</p>
            <PlayerIcon primaryColour={player.primaryColourHex} secondaryColour={player.secondaryColourHex} />
          </Row>
          <Row>
            <div style={{
              borderBottom: `3px solid ${player.primaryColourHex}`,
              width: '100%',
              paddingBottom: '2px'
            }}></div>
              <div style={{
                marginTop: '5px',
                marginBottom: '5px',
                borderBottom: `3px solid ${player.secondaryColourHex}`,
                width: '100%',
              }}></div>
          </Row>
        </Col>
        <Col xs={8} md={5}>
          <Row>
            <Col>
            <span style={{fontSize: '0.94rem'}} className='mb-0'>
              {getFlag(player.nationality)} {`${player.shirtNumber}`} {player.lastName}<br />
              <small className='text-muted'>{player.firstName}</small>
              <p className='w-100'>
                <small>{player.team}</small>
              </p>
            </span>
            </Col>
          </Row>
        </Col>
        <Col xs={12} md={4} className='text-center'>
          {isCaptain
            ? <StarIcon 
                onClick={handleStarClick} 
                color="#807A00" 
                width="15" 
                height="15" 
              />
            : <StarOutlineIcon 
                onClick={handleStarClick} 
                color="#807A00" 
                width="15" 
                height="15" 
              />}
            <h6 className='text-center mt-2'>{`£${player.value}m`}</h6>
            <Button className="w-100 mb-2" disabled={disableSellButton} onClick={handleSellPlayer} ><TransferIcon /><small>Sell</small></Button>
        </Col>
      </Row>
    </Card>
    )
  };

  const PlayerSlot = ({ player, slotNumber, handlePlayerSelection, captainId, handleCaptainSelection, handleSellPlayer }) => (
    <Col md={4} className='d-flex'>
      <div className='player-slot w-100'>
        {player 
          ? <PlayerDetails player={player} captainId={captainId} handleCaptainSelection={handleCaptainSelection} 
          handleSellPlayer={() => handleSellPlayer(slotNumber)}  /> 
          : <Card className='mb-1 h-100 d-flex flex-column justify-content-center'>
              <Card.Body className='d-flex align-items-center justify-content-center'>
                <Button onClick={() => handlePlayerSelection(slotNumber)} className="w-100">Add Player</Button>
              </Card.Body>
            </Card>}
      </div>
    </Col>
);

  
  
export default PlayerSlot;
