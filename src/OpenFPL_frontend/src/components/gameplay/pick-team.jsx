import React, { useState, useEffect } from 'react';
import { Container, Row, Col, Card, Button, Dropdown, Spinner, Modal } from 'react-bootstrap';
import { StarIcon, StarOutlineIcon,  PlayerIcon, TransferIcon } from '../icons';
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
              <StarOutlineIcon 
                color="#807A00" 
                width="15" 
                height="15" 
              />
            <h6 className='text-center mt-2'>{`£${player.value}m`}</h6>
            <Button className="w-100 mb-2"><TransferIcon /><small>Sell</small></Button>
        </Col>
      </Row>
    </Card>
  )
}

const BonusPanel = ({bonuses, handleBonusClick, show, handleClose}) => (
  <Row>
  
    {
    bonuses.map((bonus, index) =>
    <Col xs={12} md={3}>
      <Card className='mb-2'>
      <div className='bonus-card-item' key={index}>
      <div className='text-center mb-2'>
        <StarIcon color="#807A00" />
      </div>
      <div className='text-center mb-2'>{bonus.name}</div>
      <Button variant="primary w-100" onClick={() => handleBonusClick(bonus)} block>
        Use
      </Button>
    </div>
      </Card>
    
    </Col> 
    )}
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
  </Row>
);

const FixtureRow = ({ homeTeam, awayTeam }) => (
  <Row className='align-items-center small-text mt-2'>
    <Col xs={2} className='text-center d-flex justify-content-center align-items-center' style={{padding: 0}}>
      <div style={{padding: '0 5px'}}>
        <div style={{backgroundColor: homeTeam.primaryColourHex, width: '20px', height: '20px'}}></div>
        <div style={{borderBottom: `3px solid ${homeTeam.secondaryColourHex}`, width: '20px', marginTop: '2px'}}></div>
      </div>
    </Col>
    <Col xs={3} className='text-center d-flex justify-content-center align-items-center' style={{margin: 0}}>
      <p style={{margin: 0}}><small>{homeTeam.friendlyName}</small></p>
    </Col>
    <Col xs={2} className='text-center d-flex justify-content-center align-items-center' style={{margin: 0}}>
      <small style={{margin: 0}}>vs</small>
    </Col>
    <Col xs={3} className='text-center d-flex justify-content-center align-items-center' style={{margin: 0}}>
      <p style={{margin: 0}}><small>{awayTeam.friendlyName}</small></p>
    </Col>
    <Col xs={2} className='text-center d-flex justify-content-center align-items-center' style={{padding: 0}}>
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
      {shirtNumber: 1, nationality: 'Spain', firstName: 'David', lastName: 'Raya', position: 'GK', team: 'Brentford', value: 14, dateOfBirth: '1985-01-01', primaryColourHex: '#c10000', secondaryColourHex: '#ffffff'},
      {shirtNumber: 2, nationality: 'Brazil', firstName: 'Thiago', lastName: 'Silver', position: 'DF', team: 'Chelsea', value: 20, dateOfBirth: '1985-01-01', primaryColourHex: '#001b71', secondaryColourHex: '#ffffff  '},
      {shirtNumber: 3, nationality: 'Netherlands', firstName: 'Virgil', lastName: 'Van Dijk', position: 'DF', team: 'Liverpool', value: 32.5, dateOfBirth: '1985-01-01', primaryColourHex: '#dc0714', secondaryColourHex: '#ffffff'},
      {shirtNumber: 4, nationality: 'England', firstName: 'John', lastName: 'Stones', position: 'DF', team: 'Man City', value: 22, dateOfBirth: '1985-01-01', primaryColourHex: '#98c5e9', secondaryColourHex: '#ffffff'},
      {shirtNumber: 5, nationality: 'Sweden', firstName: 'Victor', lastName: 'Lindelöf', position: 'DF', team: 'Man United', value: 12.5, dateOfBirth: '1985-01-01', primaryColourHex: '#c70101', secondaryColourHex: '#ffffff'},
      {shirtNumber: 6, nationality: 'Portugal', firstName: 'Matheus', lastName: 'Nunes', position: 'MF', team: 'Wolves', value: 14, dateOfBirth: '1985-01-01', primaryColourHex: '#fdb913', secondaryColourHex: '#231f20'},
      {shirtNumber: 7, nationality: 'England', firstName: 'Mason', lastName: 'Mount', position: 'MF', team: 'Chelsea', value: 39, dateOfBirth: '1985-01-01', primaryColourHex: '#001b71', secondaryColourHex: '#ffffff'},
      {shirtNumber: 8, nationality: 'England', firstName: 'Manuel', lastName: 'Lanzini', position: 'MF', team: 'West Ham', value: 16, dateOfBirth: '1985-01-01', primaryColourHex: '#7c2c3b', secondaryColourHex: '#ffffff'},
      {shirtNumber: 9, nationality: 'England', firstName: 'Emmanuel', lastName: 'Dennis', position: 'FW', team: 'Nottingham Forest', value: 22, dateOfBirth: '1985-01-01', primaryColourHex: '#c8102e', secondaryColourHex: '#efefef'},
      {shirtNumber: 10, nationality: 'England', firstName: 'Harry', lastName: 'Kane', position: 'FW', team: 'Tottenham', value: 84, dateOfBirth: '1985-01-01', primaryColourHex: '#ffffff', secondaryColourHex: '#0b0e1e'},
      null
    ]);
    setBonuses([
      {name: 'Goal Getter'},
      {name: 'Pass Master'},
      {name: 'No Entry'},
      {name: 'Team Boost'},
      {name: 'Safe Hands'},
      {name: 'Star Scorer'},
      {name: 'Brace Bonus'},
      {name: 'Hat Trick Hero'}
    ]);
    setFixtures([
      {
        awayTeam: {
          id: 1,
          name: 'Arsenal',
          primaryColourHex: '#f00000',
          secondaryColourHex: '#ffffff',
          friendlyName: 'Arsenal'
        },
        homeTeam: {
          id: 16,
          name: 'Nottingham Forest',
          primaryColourHex: '#c8102e',
          secondaryColourHex: '#efefef',
          friendlyName: 'Nottingham Forest'
        },
      },
      {
        homeTeam: {
          id: 6,
          name: 'Burnley',
          primaryColourHex: '#5e1444',
          secondaryColourHex: '#f2f2f2',
          friendlyName: 'Burnley'
        },
        awayTeam: {
          id: 13,
          name: 'Manchester City',
          primaryColourHex: '#98c5e9',
          secondaryColourHex: '#ffffff',
          friendlyName: 'Man City'
        },
      },
      {
        awayTeam: {
          id: 3,
          name: 'AFC Bournemouth',
          primaryColourHex: '#d71921',
          secondaryColourHex: '#ffffff',
          friendlyName: 'Bournemouth'
        },
        homeTeam: {
          id: 19,
          name: 'West Ham United',
          primaryColourHex: '#7c2c3b',
          secondaryColourHex: '#2dafe5',
          friendlyName: 'West Ham'
        },
      },
      {
        homeTeam: {
          id: 5,
          name: 'Brighton & Hove Albion',
          primaryColourHex: '#004b95',
          secondaryColourHex: '#ffffff',
          friendlyName: 'Brighton'
        },
        awayTeam: {
          id: 12,
          name: 'Luton Town',
          primaryColourHex: '#f36f24',
          secondaryColourHex: '#fefefe',
          friendlyName: 'Luton'
        },
      },
      {
        awayTeam: {
          id: 9,
          name: 'Everton',
          primaryColourHex: '#0a0ba1',
          secondaryColourHex: '#ffffff',
          friendlyName: 'Everton'
        },
        homeTeam: {
          id: 10,
          name: 'Fulham',
          primaryColourHex: '#000000',
          secondaryColourHex: '#e5231b',
          friendlyName: 'Fulham'
        },
      },
      {
        awayTeam: {
          id: 17,
          name: 'Sheffield United',
          primaryColourHex: '#e20c17',
          secondaryColourHex: '#1d1d1b',
          friendlyName: 'Sheffield United'
        },
        homeTeam: {
          id: 8,
          name: 'Crystal Palace',
          primaryColourHex: '#e91d12',
          secondaryColourHex: '#0055a5',
          friendlyName: 'Crystal Palace'
        },
      },
      {
        homeTeam: {
          id: 15,
          name: 'Newcastle United',
          primaryColourHex: '#000000',
          secondaryColourHex: '#ffffff',
          friendlyName: 'Newcastle'
        },
        awayTeam: {
          id: 2,
          name: 'Aston Villa',
          primaryColourHex: '#7d1142',
          secondaryColourHex: '#ffffff',
          friendlyName: 'Aston Villa'
        },
      },
      {
        awayTeam: {
          id: 4,
          name: 'Brentford',
          primaryColourHex: '#c10000',
          secondaryColourHex: '#ffffff',
          friendlyName: 'Brentford'
        },
        homeTeam: {
          id: 18,
          name: 'Tottenham Hotspur',
          primaryColourHex: '#ffffff',
          secondaryColourHex: '#0b0e1e',
          friendlyName: 'Tottenham'
        },
      },
      {
        homeTeam: {
          id: 7,
          name: 'Chelsea',
          primaryColourHex: '#001b71',
          secondaryColourHex: '#ffffff',
          friendlyName: 'Chelsea'
        },
        awayTeam: {
          id: 11,
          name: 'Liverpool',
          primaryColourHex: '#dc0714',
          secondaryColourHex: '#ffffff',
          friendlyName: 'Liverpool'
        },
      },
      {
        awayTeam: {
          id: 14,
          name: 'Manchester United',
          primaryColourHex: '#c70101',
          secondaryColourHex: '#ffffff',
          friendlyName: 'Man United'
        },
        homeTeam: {
          id: 20,
          name: 'Wolverhampton Wanderers',
          primaryColourHex: '#fdb913',
          secondaryColourHex: '#231f20',
          friendlyName: 'Wolves'
        },
      }
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
        <Row className="mb-4">
          <Col md={9}>
            <Card className="mt-4">
              <Card.Header>
                <Row className="justify-content-between align-items-center">
                  <Col xs={12} md={6}>
                    Team Selection
                  </Col>
                  <Col xs={12} md={6}>
                    <Card className="p-2">
                      <Row className='align-items-center text-center small-text'>
                        <Col xs={12} md={4}>
                            <small>Team Value: £276.0m</small>
                        </Col>
                        <Col xs={12} md={4}>
                          <small>Bank: £24.0m</small>
                        </Col>
                        <Col xs={12} md={4}>
                          <small>Transfers Available: 2</small>
                        </Col>
                      </Row>
                    </Card>
                  </Col>
                </Row>
              </Card.Header>
              <Card.Body>
              <div className='d-flex align-items-center mb-3'>
      <StarOutlineIcon 
        color="#807A00" 
        width="15" 
        height="15" 
      />
      <p style={{marginLeft: '1rem'}} className='mb-0'>Select a player's star icon to receive double points for that player in the next gameweek.</p>
    </div>
                <Row>
                  {renderPlayerSlots(players)}
                </Row>
              </Card.Body>
            </Card>
            <Card className="mt-4">
              <Card.Header>Bonuses</Card.Header>
              <Card.Body>
              <BonusPanel 
              bonuses={bonuses} 
              handleBonusClick={handleBonusClick} 
              show={show} 
              handleClose={handleClose} 
            />
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
