import React, { useState, useEffect, useContext } from 'react';
import { Container, Row, Col, Card, Button, Spinner } from 'react-bootstrap';
import { StarIcon, RecordIcon, StarOutlineIcon, PersonIcon, CaptainIcon, StopIcon, TwoIcon, ThreeIcon, PersonUpIcon, PersonBoxIcon } from '../icons';
import { OpenFPL_backend as open_fpl_backend } from '../../../../declarations/OpenFPL_backend';
import { AuthContext } from "../../contexts/AuthContext";
import { Actor } from "@dfinity/agent";
import PlayerSlot from './player-slot';
import Fixtures from './fixtures';
import SelectPlayerModal from './select-player-modal';
import { PlayerContext } from "../../contexts/PlayerContext";
import { TeamContext } from "../../contexts/TeamContext";


const PickTeam = () => {
  const { authClient } = useContext(AuthContext);  
  const [isLoading, setIsLoading] = useState(true);
  const { players } = useContext(PlayerContext);
  const { teams } = useContext(TeamContext);
  const [fantasyTeam, setFantasyTeam] = useState({
    players: [],
    bank: 300,
    transfersAvailable: 0
  });
  
  const [bonuses, setBonuses] = useState([
    {id: 1, name: 'Goal Getter', propertyName: 'goalGetterGameweek'},
    {id: 2, name: 'Pass Master', propertyName: 'passMasterGameweek'},
    {id: 3, name: 'No Entry', propertyName: 'noEntryGameweek'},
    {id: 4, name: 'Team Boost', propertyName: 'teamBoostGameweek'},
    {id: 5, name: 'Safe Hands', propertyName: 'safaHandsGameweek'},
    {id: 6, name: 'Captain Fantastic', propertyName: 'captainFantasticGameweek'},
    {id: 7, name: 'Brace Bonus', propertyName: 'braceBonusGameweek'},
    {id: 8, name: 'Hat Trick Hero', propertyName: 'hatTrickHeroGameweek'}
  ]); 
  const [showSelectPlayerModal, setShowSelectPlayerModal] = useState(false);
  const [selectedSlot, setSelectedSlot] = useState(null);
  const [captainId, setCaptainId] = useState(0);
  const [currentGameweek, setCurrentGameweek] = useState(null);
  const [isTeamValid, setIsTeamValid] = useState(false);
  const [invalidTeamMessage, setInvalidTeamMessage] = useState('');
  


  useEffect(() => {
    const fetchData = async () => {
      await fetchViewData();
      setIsLoading(false);
    };
    fetchData();
  }, []);
  
  useEffect(() => {
    setIsTeamValid(checkTeamValidation());
    setInvalidTeamMessage(getInvalidTeamMessage());
  }, [fantasyTeam.players]);

  const fetchViewData = async () => {
    const identity = authClient.getIdentity();
    Actor.agentOf(open_fpl_backend).replaceIdentity(identity);
    
    let fantasyTeamData = await open_fpl_backend.getFantasyTeam();
    fantasyTeamData = {
      ...fantasyTeamData,
      players: fantasyTeamData.players || [],
      bank: fantasyTeamData.bank || 300
    };
    setFantasyTeam(fantasyTeamData);

    const currentGameweekData = await open_fpl_backend.getCurrentGameweek();
    setCurrentGameweek(currentGameweekData);
  };
  
  const handlePlayerSelection = (slotNumber) => {
    setSelectedSlot(slotNumber);
    setShowSelectPlayerModal(true);
  };

  const handlePlayerConfirm = (player) => {
    setFantasyTeam(prevFantasyTeam => {
      const updatedFantasyTeam = {...prevFantasyTeam};
      updatedFantasyTeam.players[selectedSlot] = player;
      return updatedFantasyTeam;
    });
    setShowSelectPlayerModal(false);
  };
  
  
  const handleBonusClick = (bonusId) => {
    console.log(`Bonus ${bonusId} was clicked`);
  }

    
  const checkTeamValidation = () => {
    if(fantasyTeam.players == undefined){
      return false;
    }
    if (fantasyTeam.players.length !== 11) {
      return false;
    }
    
    const positions = fantasyTeam.players.map(player => player.position);
    const goalkeeperCount = positions.filter(position => position === 0).length;
    const defenderCount = positions.filter(position => position === 1).length;
    const midfielderCount = positions.filter(position => position === 2).length;
    const forwardCount = positions.filter(position => position === 3).length;
    
    if (goalkeeperCount !== 1 || defenderCount < 1 || defenderCount > 3 || midfielderCount < 3 || midfielderCount > 5 || forwardCount < 1 || forwardCount > 3) {
      return false;
    }

    return true;
  };

  const getInvalidTeamMessage = () => {
    if(fantasyTeam.players == undefined){
      return "You must select 11 players";
    }
    if (fantasyTeam.players.length !== 11) {
      return "You must select 11 players";
    }
    
    const positions = fantasyTeam.players.map(player => player.position);
    const goalkeeperCount = positions.filter(position => position === 0).length;
    const defenderCount = positions.filter(position => position === 1).length;
    const midfielderCount = positions.filter(position => position === 2).length;
    const forwardCount = positions.filter(position => position === 3).length;
    
    if (goalkeeperCount !== 1) {
      return "You must have 1 goalkeeper";
    }
    if (defenderCount < 3 || defenderCount > 5) {
      return "You must have between 1 and 3 defenders";
    }
    if (midfielderCount < 3 || midfielderCount > 5) {
      return "You must have between 3 and 5 midfielders";
    }
    if (forwardCount < 1 || forwardCount > 3) {
      return "You must have between 1 and 3 forwards";
    }

    return null;
  };

  
 
  const renderPlayerSlots = () => {
    let rows = [];
    let cols = [];
  
    for (let i = 0; i < 12; i++) {
      const player = fantasyTeam.players[i] || null;
    
      if(i === 11) {
        cols.push(
          <Col md={3} key={'save'} className="d-flex align-items-center">
            <Card className="w-100 save-panel mt-4">
              <Row>
                <Col>
                  <Button className="mt-2" style={{width: 'calc(100% - 1rem)', margin: '0rem 0.5rem'}} variant="success" onClick={handleSaveTeam} disabled={!isTeamValid}>Save Team</Button>
                </Col>
              </Row>
              {!isTeamValid && <p className='m-0 mb-1 p-1 text-center small-text'><small>{invalidTeamMessage}</small></p>}
            </Card>
          </Col>
        );
      } else {
        cols.push(
          <Col md={3} key={i} className="align-items-center">
            {player ? (
              <PlayerSlot 
                player={player}
                slotNumber={i}
                handlePlayerSelection={handlePlayerSelection}
                captainId={captainId} 
                handleCaptainSelection={handleCaptainSelection} 
                handleSellPlayer={handleSellPlayer}
              />
            ) : (
              <Button className="mt-4 w-100" onClick={() => handlePlayerSelection(i)}>
                Add player
              </Button>
            )}
          </Col>
        );
      }
    }
    
  
    if (cols.length > 0) {
      rows.push(<Row className='player-container m-0' key={'row-' + (rows.length + 1)}>{cols}</Row>);
    }
  
    return rows;
  }
  
  const handleSellPlayer = (playerId) => {
    setFantasyTeam(prevFantasyTeam => {
      const updatedFantasyTeam = {...prevFantasyTeam};
      const soldPlayer = players.find(player => player.id === playerId);
  
      updatedFantasyTeam.players = updatedFantasyTeam.players.filter(player => player.id !== playerId);
      updatedFantasyTeam.bank += soldPlayer.value;
      if(updatedFantasyTeam.positionsToFill == undefined){
        updatedFantasyTeam.positionsToFill = [];
      }
      
      switch(soldPlayer.position) {
        case 0:
          updatedFantasyTeam.positionsToFill.push('Goalkeeper');
          break;
        case 1:
          updatedFantasyTeam.positionsToFill.push('Defender');
          break;
        case 2:
          updatedFantasyTeam.positionsToFill.push('Midfielder');
          break;
        case 3:
          updatedFantasyTeam.positionsToFill.push('Forward');
          break;
        default:
      }
      return updatedFantasyTeam;
    });
  };
  
  const calculateTeamValue = () => {
    if(fantasyTeam && fantasyTeam.players) {
      const totalValue = fantasyTeam.players.reduce((acc, player) => acc + player.value, 0);
      return (totalValue).toFixed(1);
    }
    return null;
  }

  const handleSaveTeam = async () => {
    setIsLoading(true);
    try {
      const playerIds = fantasyTeam.players.map(player => player.id);

      const identity = authClient.getIdentity();
      Actor.agentOf(open_fpl_backend).replaceIdentity(identity);
      await open_fpl_backend.saveFantasyTeam(playerIds);
      
      setIsLoading(false);
  
    } catch(error) {
      console.error("Failed to save team", error);
      setIsLoading(false);
    }
  };

  const handleCaptainSelection = (playerId) => {
    setCaptainId(prevCaptainId => (prevCaptainId === playerId ? 0 : playerId));
  };

  const handleAutoFill = () => {
    
    if (players.length === 0) {
      console.error("No player data available for autofill.");
      return;
    }
  
    const maxPlayersPerPosition = {
      'Goalkeeper': 1,
      'Defender': 5,
      'Midfielder': 5,
      'Forward': 3
    };
  
    const teamPositions = ['Goalkeeper', 'Defender', 'Midfielder', 'Forward'];
    const currentTeamPositions = fantasyTeam.players.map(player => player.position);

    console.log(fantasyTeam.positionsToFill)
    let positionsToFill = fantasyTeam.positionsToFill ? [...fantasyTeam.positionsToFill] : [];
    
    teamPositions.forEach(position => {
      let minPlayers;
      switch(position) {
        case 'Goalkeeper':
          minPlayers = 1;
          break;
        case 'Defender':
          minPlayers = 3;
          break;
        case 'Midfielder':
          minPlayers = 3;
          break;
        case 'Forward':
          minPlayers = 1;
          break;
        default:
          minPlayers = 0;
      }
      const currentCount = currentTeamPositions.filter(pos => pos === position).length;
      if (currentCount < minPlayers) {
        positionsToFill.push(...Array(minPlayers - currentCount).fill(position));
      }
    });


    while (positionsToFill.length < 11 - fantasyTeam.players.length) {
      // Get positions that haven't reached their maximum limit yet
      let openPositions = teamPositions.filter(position => 
        (positionsToFill.filter(pos => pos === position).length + currentTeamPositions.filter(pos => pos === position).length)
        < maxPlayersPerPosition[position]
      );
    
      if (openPositions.length === 0) {
        break; // No more positions are open, so we break the loop
      }
    
      // Pick a random position from openPositions
      let randomPosition = openPositions[Math.floor(Math.random() * openPositions.length)];
    
      positionsToFill.push(randomPosition);

      if (fantasyTeam.positionToFill === randomPosition) {
        setFantasyTeam(prevState => ({
          ...prevState,
          positionToFill: null,
        }));
      }
    }
    
    // Sort players by value (price)
    let sortedPlayers = [...players].sort((a, b) => a.value - b.value);
    sortedPlayers = shuffle(sortedPlayers);
  
    // Create a new team based on the sorted players and the positions to fill
    let newTeam = [...fantasyTeam.players];
    let remainingBudget = fantasyTeam.bank;
    for (let i = 0; i < positionsToFill.length; i++) {
      if (newTeam.length >= 11) {
        break;
      }
      let position = positionsToFill[i];
      const positionMapping = ['Goalkeeper', 'Defender', 'Midfielder', 'Forward'];


      for (let j = 0; j < sortedPlayers.length; j++) {
        if (positionMapping[sortedPlayers[j].position] === position && sortedPlayers[j].value <= remainingBudget) {
          newTeam.push(sortedPlayers[j]);
          remainingBudget -= sortedPlayers[j].value;
          sortedPlayers.splice(j, 1);
          positionsToFill.splice(i, 1); // remove the filled position from positionsToFill
          i--; // decrement i to offset the index after splicing
          break;
        }
      }
    }


    newTeam.sort((a, b) => {
      if (a.position < b.position) {
        return -1;
      } else if (a.position > b.position) {
        return 1;
      }
      
      if (a.position === b.position) {
        return b.value - a.value;
      }
    
      return 0;
    });
    
    
    fantasyTeam.positionsToFill = [];
    // Correctly update the state to keep existing properties
    setFantasyTeam(prevState => ({
      ...prevState,
      players: newTeam,
      bank: remainingBudget,
    }));
  };
  
  function shuffle(array) {
    let currentIndex = array.length, temporaryValue, randomIndex;
  
    // While there remain elements to shuffle...
    while (0 !== currentIndex) {
  
      // Pick a remaining element...
      randomIndex = Math.floor(Math.random() * currentIndex);
      currentIndex -= 1;
  
      // And swap it with the current element.
      temporaryValue = array[currentIndex];
      array[currentIndex] = array[randomIndex];
      array[randomIndex] = temporaryValue;
    }
  
    return array;
  }
  
  
  
  
  return (
    isLoading ? (
      <div className="customOverlay d-flex flex-column align-items-center justify-content-center">
        <Spinner animation="border" />
        <p className='text-center mt-1'>Loading Team</p>
      </div>) :
      <Container className="flex-grow-1 my-5 pitch-bg mt-0">
        <Row className="mb-4">
          <Col md={9}>
            <Card className="mt-4">
              <Card.Header>
                <Row className="justify-content-between align-items-center">
                  <Col xs={12} md={3}>
                    Team Selection
                  </Col>
                  <Col xs={12} md={9}>
                    <Card className="p-2 summary-panel">
                      <Row className='align-items-center text-center small-text'>
                        <Col xs={4} md={4}>
                          <p style={{marginBottom: 0}}>
                            £{calculateTeamValue()}m
                            <br />
                            <small>Team Value</small>
                          </p>
                        </Col>
                        <Col xs={4} md={4}>
                          <p style={{marginBottom: 0}}>
                            £{(fantasyTeam.bank).toFixed(1)}m
                            <br />
                            <small>Bank Balance</small>
                          </p>
                        </Col>
                        <Col xs={4} md={4}>
                          <p style={{marginBottom: 0}}>
                            {
                              (fantasyTeam === null || currentGameweek === 1) ? 
                                'Unlimited' 
                                : 
                                
                                (fantasyTeam ? fantasyTeam.transfersAvailable : 0)
                            }
                            <br />
                            <small>Transfers Available</small>
                          </p>
                        </Col>

                      </Row>
                    </Card>
                  </Col>
                </Row>
                <Row className='small-text'>
                  <Col>
                      <small>Status: 2023/24 Pre-season</small>
                  </Col>
                </Row>
              </Card.Header>
              <Card.Body>
                <Row className='mb-2'>
                  <Col md={10}>
                    <div className='d-flex align-items-center mb-3 mt-3'>
                      <StarIcon color="#807A00" width="15" height="15" />
                      <p style={{marginLeft: '1rem'}} className='mb-0'><small>Make a player your captain by selecting their star icon to receive double points for that player in the next gameweek.</small></p>
                    </div>
                  </Col>
                  <Col md={2} className='d-flex align-items-center'>
                    <div className='w-100'>
                      <Button variant="secondary white-text w-100" onClick={handleAutoFill}>AutoFill</Button>
                    </div>
                  </Col>
                </Row>
                <Row>
                  {fantasyTeam && fantasyTeam.players && renderPlayerSlots(fantasyTeam.players, captainId, handleCaptainSelection)}
                </Row>
              </Card.Body>

            </Card>
            <Card className="mt-4">
              <Card.Header>Bonuses</Card.Header>
              <Card.Body>
                <Row>
                  {bonuses.map((bonus, index) => {
                    const bonusPlayedGameweek = fantasyTeam[`${bonus.propertyName}`];
                    const isBonusUsed = bonusPlayedGameweek != undefined && bonusPlayedGameweek !== 0;
                    const isSameGameweek = bonusPlayedGameweek === currentGameweek;
                    return (
                      <Col xs={12} md={3} key={index}>
                        <Card className='mb-2'>
                          <div className='bonus-card-item'>
                            <div className='text-center mb-2 mt-2'>
                            {(() => {
                              switch (bonus.id) {
                                case 1:
                                  return <RecordIcon />;
                                case 2:
                                  return <PersonBoxIcon />;
                                case 3:
                                  return <StopIcon />;
                                case 4:
                                  return <PersonUpIcon />;
                                case 5:
                                  return <PersonIcon />;
                                case 6:
                                  return <CaptainIcon />;
                                case 7:
                                  return <TwoIcon />;
                                case 8:
                                  return <ThreeIcon />;
                                default:
                                  return <StarOutlineIcon />;
                              }})()}
                            </div>
                            <div className='text-center mb-2 mx-1'>{bonus.name}</div>
                            {isBonusUsed ? (
                              <div className='text-center mb-2'>Played Gameweek {bonusPlayedGameweek}</div>
                            ) : (
                              isSameGameweek ? (
                                <div>You can only use 1 bonus per gameweek</div>
                              ) : (
                                <div style={{marginLeft: '1rem', marginRight: '1rem'}}>
                                  <Button variant="info" className="w-100 mb-4" onClick={() => handleBonusClick(bonus.id)}>
                                    Use
                                  </Button>
                                </div>
                              )
                            )}
                          </div>
                        </Card>
                      </Col>
                    );
                  })}
                </Row>
              </Card.Body>
            </Card>
          </Col>
          <Col md={3}>
            <Fixtures teams={teams} />
          </Col>
        </Row>

        <SelectPlayerModal 
          show={showSelectPlayerModal} 
          handleClose={() => setShowSelectPlayerModal(false)} 
          handleConfirm={handlePlayerConfirm}
        />
        
      </Container>
  );
};

export default PickTeam;
