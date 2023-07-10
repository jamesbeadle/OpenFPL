import React, { useContext } from 'react';
import { Card, Button, Col, Row } from 'react-bootstrap';
import { StarIcon, StarOutlineIcon,  PlayerIcon, TransferIcon } from '../icons';
import getFlag from '../country-flag';
import { TeamContext } from "../../contexts/TeamContext";

const PlayerDetails = ({ player, captainId, handleCaptainSelection, disableSellButton, handleSellPlayer }) => {
  
  const { teams } = useContext(TeamContext);
  const isCaptain = player.id === captainId;
  const positionCodes = ['GK', 'DF', 'MF', 'FW'];

  const handleStarClick = (event) => {
    event.stopPropagation();
    handleCaptainSelection(player.id);
  };

  const getTeamById = (teamId) => {
    return teams.find(team => team.id === teamId);
  }

  return (      
    <Card className='h-100 d-flex flex-column justify-content-center'>
      <Row className='mx-1 mt-2'>
        <Col xs={3}>
          <Row>
            <p className='text-center mb-0'>{player.shirtNumber}</p>
            <p className='text-center mb-1'>{positionCodes[player.position]}</p>
            <PlayerIcon primaryColour={getTeamById(player.teamId).primaryColourHex} secondaryColour={getTeamById(player.teamId).secondaryColourHex} />
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
        <Col xs={9}>
          <Row>
            <Col xs={9}>
              <span style={{fontSize: '0.9rem'}} className='mb-0'>
                {getFlag(player.nationality)} {player.lastName}<br />
                <small className='text-muted'>{player.firstName}</small>
              </span>
            </Col>
            <Col xs={3}>
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
            </Col>
          </Row>
          <Row>
          <span style={{fontSize: '0.94rem'}} className='mb-0'>
              <p className='w-100 mb-0'>
                <small>{getTeamById(player.teamId).friendlyName}</small>
              </p>
              <p className='w-100'>
                <small>{`£${player.value}m`}</small>
              </p>
            </span>
          </Row>
          
        </Col>
      </Row>
      <Row>
        <Col>
        <Button 
          style={{width: 'calc(100% - 16px)', margin: '0px 8px'}} 
          className="mb-2" 
          disabled={disableSellButton} 
          onClick={handleSellPlayer} 
        >
          <TransferIcon /><small>Sell</small>
        </Button>


        </Col>
      </Row>
    </Card>
    )
  };

  const PlayerSlot = ({ player, slotNumber, handlePlayerSelection, captainId, handleCaptainSelection, handleSellPlayer }) => (
    <Col className='d-flex mb-4'>
      <div className='player-slot w-100'>
        {player 
          ? <PlayerDetails player={player} captainId={captainId} handleCaptainSelection={handleCaptainSelection} 
          handleSellPlayer={() => handleSellPlayer(slotNumber)}  /> 
          : <Card className='mb-1 h-100 d-flex flex-column justify-content-center'>
              <Card.Body className='d-flex align-items-center justify-content-center'>
                <Button className="d-flex align-items-center justify-content-center p-3" onClick={() => handlePlayerSelection(i)}>
                  Add player
                </Button>
              </Card.Body>
            </Card>}
      </div>
    </Col>
);

  
  
export default PlayerSlot;
