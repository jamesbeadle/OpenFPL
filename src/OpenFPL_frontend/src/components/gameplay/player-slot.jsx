import React, { useContext } from 'react';
import { Card, Button, Col, Row } from 'react-bootstrap';
import { StarIcon, StarOutlineIcon,  PlayerIcon, TransferIcon, RecordIcon, PersonBoxIcon, StopIcon, PersonUpIcon, PersonIcon, CaptainIcon, TwoIcon, ThreeIcon } from '../icons';
import getFlag from '../country-flag';

import { TeamsContext } from "../../contexts/TeamsContext";

const PlayerDetails = ({ player, captainId, handleCaptainSelection, disableSellButton, handleSellPlayer, bonusId }) => {
  
  const { teams } = useContext(TeamsContext);
  const isCaptain = player.id === captainId;
  const positionCodes = ['GK', 'DF', 'MF', 'FW'];
  const bonusIcons = {
    1: <RecordIcon style={{marginLeft: '1rem'}} />,
    2: <PersonBoxIcon style={{marginLeft: '1rem'}} />,
    3: <StopIcon style={{marginLeft: '1rem'}} />,
    4: <PersonUpIcon style={{marginLeft: '1rem'}} />,
    5: <PersonIcon style={{marginLeft: '1rem'}} />,
    6: <CaptainIcon style={{marginLeft: '1rem'}} />,
    7: <TwoIcon style={{marginLeft: '1rem'}} />,
    8: <ThreeIcon style={{marginLeft: '1rem'}} />
  };
  
  const handleStarClick = (event) => {
    event.stopPropagation();
    handleCaptainSelection(player.id);
  };

  const getTeamById = (teamId) => {
    return teams.find(team => team.id === teamId);
  }

  return (      
    <Card className={`justify-content-center ${isCaptain ? 'captain' : ''}`}>
      <Row className='mx-1 mt-2'>
        <Col xs={3}>
          <Row>
            <div style={{ overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
              <p style={{fontSize: '0.8rem'}} className='text-center mb-0'>{player.shirtNumber == 0 ? '-' : player.shirtNumber}</p>
              <p style={{fontSize: '0.8rem'}} className='text-center mb-1'>{positionCodes[player.position]}</p>  
            </div>
            <PlayerIcon primaryColour={getTeamById(player.teamId).primaryColourHex} secondaryColour={getTeamById(player.teamId).secondaryColourHex} />
          </Row>
        </Col>
        <Col xs={9}>
          <Row>
            <Col xs={9}>
              <div style={{ overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
                <span style={{fontSize: '0.8rem'}} className='mb-0'>
                    {getFlag(player.nationality)} {player.lastName}<br />
                    <small className='text-muted'>{player.firstName == "" ? player.lastName : player.firstName}</small>
                </span>
              </div>
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
            <div style={{ overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
              <span style={{fontSize: '0.94rem'}} className='mb-0'>
                <p className='w-100 mb-0'>
                  <small>{getTeamById(player.teamId).friendlyName}</small>
                </p>
                <p className='w-100'>
                  <small>{`£${(Number(player.value) / 4).toFixed(1)}m`}</small>
                  {bonusIcons[bonusId]}
                </p>
              </span>
              </div>
          </Row>
          
        </Col>
      </Row>
      <Row>
        <Col>
        <Button 
          style={{width: 'calc(100% - 1rem)', margin: '0px 0.5rem'}} 
          className="mb-2" 
          disabled={disableSellButton} 
          onClick={() => handleSellPlayer(player.id)}
        >
          <TransferIcon /><small>Sell</small>
        </Button>


        </Col>
      </Row>
    </Card>
    )
  };

  const PlayerSlot = ({ player, slotNumber, handlePlayerSelection, captainId, handleCaptainSelection, handleSellPlayer, bonusId }) => (
    <Col className='d-flex mt-2 mb-2'>
      <div className='player-slot w-100'>
        {player 
          ? <PlayerDetails player={player} captainId={captainId} handleCaptainSelection={handleCaptainSelection} 
          handleSellPlayer={() => handleSellPlayer(player.id)} bonusId={bonusId}  /> 
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
