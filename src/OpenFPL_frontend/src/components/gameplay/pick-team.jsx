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
    bank: 3000,
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
      bank: fantasyTeamData.bank || 3000
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
    const goalkeeperCount = positions.filter(position => position === 'Goalkeeper').length;
    const defenderCount = positions.filter(position => position === 'Defender').length;
    const midfielderCount = positions.filter(position => position === 'Midfielder').length;
    const forwardCount = positions.filter(position => position === 'Forward').length;
    
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
    const goalkeeperCount = positions.filter(position => position === 'Goalkeeper').length;
    const defenderCount = positions.filter(position => position === 'Defender').length;
    const midfielderCount = positions.filter(position => position === 'Midfielder').length;
    const forwardCount = positions.filter(position => position === 'Forward').length;
    
    if (goalkeeperCount !== 1) {
      return "You must have 1 goalkeeper";
    }
    if (defenderCount < 1 || defenderCount > 3) {
      return "You must have between 1 and 3 defenders";
    }
    if (midfielderCount < 3 || midfielderCount > 5) {
      return "You must have between 3 and 5 midfielders";
    }
    if (forwardCount < 1 || forwardCount > 3) {
      return "You must have between 1 and 3 forwards";
    }

    return "Invalid team";
  };

  
 
  const renderPlayerSlots = () => {
    let rows = [];
    let cols = [];
  
    for (let i = 0; i < 12; i++) {
      const player = fantasyTeam.players[i] || null;
    
      if(i === 11) {
        cols.push(
          <Col md={3} key={'save'} className="d-flex align-items-center">
            <Card className="w-100 save-panel">
              <Row>
                <Col>
                  <Button className='w-100' variant="success" onClick={handleSaveTeam} disabled={!isTeamValid}>Save Team</Button>
                </Col>
              </Row>
              {!isTeamValid && <p className='m-0 text-center'><small>{invalidTeamMessage}</small></p>}
            </Card>
          </Col>
        );
      } else {
        cols.push(
          <Col md={3} key={i} className="d-flex align-items-center">
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
              <Button className="m-3 w-100" onClick={() => handlePlayerSelection(i)}>
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
      // filter out the sold player
      updatedFantasyTeam.players = updatedFantasyTeam.players.filter(player => player.id !== playerId);
      // add player's value back to bank
      updatedFantasyTeam.bank += players.find(player => player.id === playerId).value;
      return updatedFantasyTeam;
    });
  };
  
  const calculateTeamValue = () => {
    if(fantasyTeam && fantasyTeam.players) {
      const totalValue = fantasyTeam.players.reduce((acc, player) => acc + player.value, 0);
      return (totalValue / 10).toFixed(1);
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
    // Make sure we have all the players data
    if (players.length === 0) {
      console.error("No player data available for autofill.");
      return;
    }
  
    // Define position names
    const positionNames = ['Goalkeeper', 'Defender', 'Midfielder', 'Forward'];
  
    // Generate list of available positions for auto-fill (remaining positions to be filled in team)
    const teamPositions = ['Goalkeeper', 'Defender', 'Midfielder', 'Forward'];
    const currentTeamPositions = fantasyTeam.players.map(player => positionNames[player.position]);
    const positionsToFill = teamPositions.map(position => {
      let minPlayers, maxPlayers;
      switch(position) {
        case 'Goalkeeper':
          minPlayers = 1;
          maxPlayers = 1;
          break;
        case 'Defender':
          minPlayers = 3;
          maxPlayers = 5;
          break;
        case 'Midfielder':
          minPlayers = 3;
          maxPlayers = 5;
          break;
        case 'Forward':
          minPlayers = 1;
          maxPlayers = 3;
          break;
        default:
          minPlayers = 0;
          maxPlayers = 0;
      }
      const currentCount = currentTeamPositions.filter(pos => pos === position).length;
      const positionsToAdd = Math.max(minPlayers - currentCount, 0);
      const positionsToReplace = Math.min(maxPlayers - currentCount, positionsToAdd);
      return Array(positionsToAdd + positionsToReplace).fill(position);
    }).flat();
  
    // Sort players by value (price)
    const sortedPlayers = [...players].sort((a, b) => a.value - b.value);
  
    // Create a new team based on the sorted players and the positions to fill
    let newTeam = [...fantasyTeam.players];
    let remainingBudget = fantasyTeam.bank;
    for (let position of positionsToFill) {
      for (let i = 0; i < sortedPlayers.length; i++) {
        if (positionNames[sortedPlayers[i].position] === position && sortedPlayers[i].value <= remainingBudget) {
          newTeam.push(sortedPlayers[i]);
          remainingBudget -= sortedPlayers[i].value;
          sortedPlayers.splice(i, 1);
          break;
        }
      }
    }
  
    if (newTeam.length > 11) {
      newTeam = newTeam.slice(0, 11);
    }
  
    // Correctly update the state to keep existing properties
    setFantasyTeam(prevState => ({
      ...prevState,
      players: newTeam,
      bank: remainingBudget,
    }));
  };
  
  
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
                            £{(fantasyTeam.bank / 10).toFixed(1)}m
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
                <Row>
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
                            <div className='text-center mb-2'>{bonus.name}</div>
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
