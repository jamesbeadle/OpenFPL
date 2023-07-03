import React, { useState, useEffect } from 'react';
import { Container, Row, Col, Card, Button, Dropdown, Spinner, Modal } from 'react-bootstrap';
import { StarIcon, PlayerIcon, TransferIcon } from '../icons';
import getFlag from '../country-flag';

const PlayerSlot = ({ player, slotNumber, handlePlayerSelection }) => (
  <Col md={4} className='d-flex'>
    <div className='player-slot w-100'>
      {player 
        ? <PlayerDetails player={player} /> 
        : <Card className='mb-1 h-100 d-flex flex-column justify-content-center'>
            <Card.Body className='d-flex align-items-center justify-content-center'>
              <Button onClick={() => handlePlayerSelection(slotNumber)} className="w-100">Add Player</Button>
            </Card.Body>
          </Card>}
    </div>
  </Col>
);




const PlayerDetails = ({ player }) => {
  
  return (
    
    <Card className='mb-1'>
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
            <span className='mb-0'>
              {getFlag(player.nationality)} {`${player.shirtNumber}`} {player.lastName}<br />
              <small className='text-muted'>{player.firstName}</small>
              <p className='w-100'>
                <small>{player.team}</small>
              </p>
            </span>
            </Col>
          </Row>
        </Col>
        <Col xs={12} md={4}>
            <h6 className='text-center mt-2'>{`£${player.value}m`}</h6>
            <Button className="w-100 mb-2 mt-2"><TransferIcon /><small>Sell</small></Button>
        </Col>
      </Row>
    </Card>
  )
}

const BonusPanel = ({bonuses, handleBonusClick, show, handleClose}) => (
  <Card>
    <Card.Header>Bonuses Available</Card.Header>
    <Card.Body>
      {bonuses.map((bonus, index) => 
        <Row className='align-items-center mb-2' key={index}>
          <Col xs={2}><StarIcon color="#807A00" margin="0 10px 0 0" /></Col>
          <Col xs={6}>{bonus.name}</Col>
          <Col xs={4}>
            <Button variant="primary" onClick={() => handleBonusClick(bonus)}>
              Use
            </Button>
          </Col>
        </Row>
      )}
    </Card.Body>
    <Modal show={show} onHide={handleClose}>
      <Modal.Header closeButton>
        <Modal.Title>Confirmation</Modal.Title>
      </Modal.Header>
      <Modal.Body>You can only use 1 bonus per gameweek. Are you sure you want to proceed?</Modal.Body>
      <Modal.Footer>
        <Button variant="secondary" onClick={handleClose}>
          Close
        </Button>
        <Button variant="primary" onClick={handleClose}>
          Confirm
        </Button>
      </Modal.Footer>
    </Modal>
  </Card>
);

const FixtureRow = ({ homeTeam, awayTeam }) => (
  <Row className='align-items-center small-text'>
    <Col xs={1} className='text-center d-flex justify-content-center align-items-center' style={{padding: 0}}>
      <div style={{padding: '0 5px'}}>
        <div style={{backgroundColor: homeTeam.primaryColourHex, width: '20px', height: '20px'}}></div>
        <div style={{borderBottom: `3px solid ${homeTeam.secondaryColourHex}`, width: '20px', marginTop: '2px'}}></div>
      </div>
    </Col>
    <Col xs={4} className='text-center d-flex justify-content-center align-items-center' style={{margin: 0}}>
      <p style={{margin: 0}}><small>{homeTeam.name}</small></p>
    </Col>
    <Col xs={2} className='text-center d-flex justify-content-center align-items-center' style={{margin: 0}}>
      <small style={{margin: 0}}>vs</small>
    </Col>
    <Col xs={4} className='text-center d-flex justify-content-center align-items-center' style={{margin: 0}}>
      <p style={{margin: 0}}>{awayTeam.name}</p>
    </Col>
    <Col xs={1} className='text-center d-flex justify-content-center align-items-center' style={{padding: 0}}>
      <div style={{padding: '0 5px'}}>
        <div style={{backgroundColor: awayTeam.primaryColourHex, width: '20px', height: '20px'}}></div>
        <div style={{borderBottom: `3px solid ${awayTeam.secondaryColourHex}`, width: '20px', marginTop: '2px'}}></div>
      </div>
    </Col>
  </Row>
);





const PickTeam = () => {
  
  const [isLoading, setIsLoading] = useState(true);
  const [players, setPlayers] = useState([]);
  const [bonuses, setBonuses] = useState([]);
  const [show, setShow] = useState(false);
  const [fixtures, setFixtures] = useState([]);
  const [currentGameweek, setCurrentGameweek] = useState(1);


  const handleClose = () => setShow(false);
  const handleShow = () => setShow(true);

  const handleBonusClick = (bonus) => {
    // Handle the logic when a bonus is clicked
    console.log(`Bonus ${bonus.name} was clicked`);
    handleShow();
  }

  useEffect(() => {
    const fetchData = async () => {
      await fetchViewData();
      setIsLoading(false);
    };
    fetchData();
  }, []);

  const handlePlayerSelection = (slotNumber) => {
    // Handle player selection logic here
    console.log(`Player slot ${slotNumber} was clicked`);
  }
  
  const renderPlayerSlots = (playerArray) => {
    let rows = [];
    let cols = [];
  
    for (let i = 0; i < playerArray.length; i++) {
      cols.push(
        <PlayerSlot 
          key={i} 
          player={playerArray[i]} 
          slotNumber={i} 
          handlePlayerSelection={handlePlayerSelection} 
        />
      );
  
      // Create a new row every 3 players
      if (cols.length === 3) {
        rows.push(<Row className='player-container' key={i}>{cols}</Row>);
        cols = [];
      }
    }
  
    // If there's an odd number of players, make sure to render the last player
    if (cols.length > 0) {
      rows.push(<Row className='player-container' key={playerArray.length - 1}>{cols}</Row>);
    }
  
    return rows;
  }


  const fetchViewData = async () => {
    setPlayers([
      {shirtNumber: 1, nationality: 'England', firstName: 'Harry', lastName: 'Kane', position: 'GK', team: 'Tottenham', value: 12.5, dateOfBirth: '1985-01-01', primaryColourHex: '#7c2c3b', secondaryColourHex: '#2dafe5'},
      {shirtNumber: 2, nationality: 'England', firstName: 'Harry', lastName: 'Kane', position: 'DF', team: 'Tottenham', value: 12.5, dateOfBirth: '1985-01-01', primaryColourHex: '#7c2c3b', secondaryColourHex: '#2dafe5'},
      {shirtNumber: 3, nationality: 'England', firstName: 'Harry', lastName: 'Kane', position: 'DF', team: 'Tottenham', value: 12.5, dateOfBirth: '1985-01-01', primaryColourHex: '#7c2c3b', secondaryColourHex: '#2dafe5'},
      {shirtNumber: 4, nationality: 'England', firstName: 'Harry', lastName: 'Kane', position: 'DF', team: 'Tottenham', value: 12.5, dateOfBirth: '1985-01-01', primaryColourHex: '#7c2c3b', secondaryColourHex: '#2dafe5'},
      {shirtNumber: 5, nationality: 'England', firstName: 'Harry', lastName: 'Kane', position: 'MF', team: 'Tottenham', value: 12.5, dateOfBirth: '1985-01-01', primaryColourHex: '#7c2c3b', secondaryColourHex: '#2dafe5'},
      {shirtNumber: 6, nationality: 'England', firstName: 'Harry', lastName: 'Kane', position: 'MF', team: 'Tottenham', value: 12.5, dateOfBirth: '1985-01-01', primaryColourHex: '#7c2c3b', secondaryColourHex: '#2dafe5'},
      {shirtNumber: 7, nationality: 'England', firstName: 'Harry', lastName: 'Kane', position: 'MF', team: 'Tottenham', value: 12.5, dateOfBirth: '1985-01-01', primaryColourHex: '#7c2c3b', secondaryColourHex: '#2dafe5'},
      {shirtNumber: 8, nationality: 'England', firstName: 'Harry', lastName: 'Kane', position: 'MF', team: 'Tottenham', value: 12.5, dateOfBirth: '1985-01-01', primaryColourHex: '#7c2c3b', secondaryColourHex: '#2dafe5'},
      {shirtNumber: 9, nationality: 'England', firstName: 'Harry', lastName: 'Kane', position: 'FW', team: 'Tottenham', value: 12.5, dateOfBirth: '1985-01-01', primaryColourHex: '#7c2c3b', secondaryColourHex: '#2dafe5'},
      {shirtNumber: 10, nationality: 'England', firstName: 'Harry', lastName: 'Kane', position: 'FW', team: 'Tottenham', value: 12.5, dateOfBirth: '1985-01-01', primaryColourHex: '#7c2c3b', secondaryColourHex: '#2dafe5'},
      null
    ]);
    setBonuses([
      {name: 'Double Captain'},
      // ... add more bonuses as required
    ]);
    setFixtures([
      {
        homeTeam: {
          name: 'Burnley',
          primaryColourHex: '#6C1D45',
          secondaryColourHex: '#FFFFFF',
        },
        awayTeam: {
          name: 'Man City',
          primaryColourHex: '#6CABDD',
          secondaryColourHex: '#FFFFFF',
        },
      },
      {
        homeTeam: {
          name: 'Arsenal',
          primaryColourHex: '#EF0107',
          secondaryColourHex: '#ffffff',
        },
        awayTeam: {
          name: 'Nottingham Forest',
          primaryColourHex: '#EB1739',
          secondaryColourHex: '#000000',
        },
      },
      // ... add more fixtures as required
    ]);
    
  };

  const handleGameweekChange = (change) => {
    // Ensures the current gameweek is always within the range 1 - 38
    setCurrentGameweek(prev => Math.min(38, Math.max(1, prev + change)));
  }
  
  return (
    isLoading ? (
      <div className="customOverlay d-flex flex-column align-items-center justify-content-center">
        <Spinner animation="border" />
        <p className='text-center mt-1'>Loading Team</p>
      </div>) 
      :
      <Container className="flex-grow-1 my-5 pitch-bg mt-0">
        <Row className="mt-4 mb-4">
          <Col md={9}>
            <Card className="mt-4">
            <Card.Header>
              <Row className="justify-content-between align-items-center">
                <Col xs={12} md={6}>
                  Team Selection
                </Col>
                <Col xs={12} md={6}>
                  <Card className="p-2">
                    <Row className='align-items-center text-center'>
                      <Col xs={12} md={6}>
                          <small>Team Value: £187.5m</small>
                      </Col>
                      <Col xs={12} md={6}>
                        <small>Bank: £3.5m</small>
                      </Col>
                    </Row>
                  </Card>
                </Col>
              </Row>
            </Card.Header>
              <Card.Body>
                <Row>
                  {renderPlayerSlots(players)}
                </Row>
              </Card.Body>
            </Card>
          </Col>
          <Col md={3}>
            <Card className="mt-4 mb-4">
              <Card.Header>
                Fixtures
              </Card.Header>
              <Card.Body>
              <Row className="d-flex align-items-center">
                <div style={{flex: 1, padding: '0 5px'}}>
                  <Button className="w-100 justify-content-center" onClick={() => handleGameweekChange(-1)} disabled={currentGameweek === 1}>{"<"}</Button>
                </div>
                <div style={{flex: 3, textAlign: 'center', padding: '0 5px'}}>
                  <small>Gameweek {currentGameweek}</small>
                </div>
                <div style={{flex: 1, padding: '0 5px'}}>
                  <Button className="w-100 justify-content-center" onClick={() => handleGameweekChange(1)} disabled={currentGameweek === 38}>{">"}</Button>
                </div>
              </Row>




                <br />
                {fixtures.map((fixture, i) => (
                  <FixtureRow key={i} homeTeam={fixture.homeTeam} awayTeam={fixture.awayTeam} />
                ))}
              </Card.Body>
            </Card>
          </Col>
        </Row>
        
      </Container>
  );
};

export default PickTeam;

