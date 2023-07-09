import React, { useState, useEffect, useContext } from 'react';
import { Container, Row, Col, Card, Button, Spinner } from 'react-bootstrap';
import { StarIcon, StarOutlineIcon } from '../icons';
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
  const [fantasyTeam, setFantasyTeam] = useState(null);
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


  useEffect(() => {
    const fetchData = async () => {
      await fetchViewData();
      setIsLoading(false);
    };
    fetchData();
  }, []);

  const fetchViewData = async () => {
    const identity = authClient.getIdentity();
    Actor.agentOf(open_fpl_backend).replaceIdentity(identity);

    const fantasyTeamData = await open_fpl_backend.getFantasyTeam();
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
  
  const renderPlayerSlots = (playerArray, captainId, handleCaptainSelection) => {
    let rows = [];
    let cols = [];

    const disableSellButton = currentGameweek === 1 || !fantasyTeam || (fantasyTeam && fantasyTeam.transfersAvailable === 0);

    for (let i = 0; i < playerArray.length; i++) {
      cols.push(
        <PlayerSlot 
          key={i} 
          player={playerArray[i]} 
          slotNumber={i} 
          handlePlayerSelection={handlePlayerSelection}
          captainId={captainId} 
          handleCaptainSelection={handleCaptainSelection} 
          disableSellButton={disableSellButton}
          handleSellPlayer={handleSellPlayer}
        />
      );
  
      if (cols.length === 3 || i === playerArray.length - 1) {
        rows.push(<Row className='player-container' key={i}>{cols}</Row>);
        cols = [];
      }
    }
    
    // Add Save button as 12th tile
    cols.push(
      <Col className="d-flex justify-content-center align-items-center">
        <Button variant="primary" onClick={handleSaveTeam}>Save</Button>
      </Col>
    );
    
    rows.push(<Row className='player-container' key={playerArray.length}>{cols}</Row>);
  
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
  
    // Generate list of available positions for auto-fill (remaining positions to be filled in team)
    const teamPositions = ['Goalkeeper', 'Defender', 'Midfielder', 'Forward'];
    const currentTeamPositions = fantasyTeam.players.map(player => player.position);
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
    let remainingBudget = fantasyTeam.bankBalance;
    for (let position of positionsToFill) {
      for (let i = 0; i < sortedPlayers.length; i++) {
        if (sortedPlayers[i].position === position && sortedPlayers[i].value <= remainingBudget) {
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
  
    setFantasyTeam(newTeam);
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
                  <Col xs={12} md={6}>
                    Team Selection
                  </Col>
                  <Col xs={12} md={6}>
                    <Card className="p-2">
                      <Row className='align-items-center text-center small-text'>
                        <Col xs={12} md={4}>
                            <small>Team Value: £{calculateTeamValue()}m</small>
                        </Col>
                        <Col xs={12} md={4}>
                          <small>Bank: £{(fantasyTeam ? fantasyTeam.bank / 10 : 0).toFixed(1)}m</small>
                        </Col>
                        <Col xs={12} md={4}>
                          <small>Transfers Available: 
                            {
                              (fantasyTeam === null || currentGameweek === 1) ? 
                                'unlimited' 
                                : 
                                (fantasyTeam ? fantasyTeam.transfersAvailable : 0)
                            }
                          </small>
                        </Col>

                      </Row>
                      <Row className='align-items-center text-center small-text'>
                        <Col>
                            <small>System Status: Preseason</small>
                        </Col>
                      </Row>
                    </Card>
                  </Col>
                </Row>
              </Card.Header>
              <Card.Body>
                <div className='d-flex align-items-center mb-3'>
                  <StarOutlineIcon color="#807A00" width="15" height="15" />
                  <p style={{marginLeft: '1rem'}} className='mb-0'>Make a player your captain by selecting their star icon to receive double points for that player in the next gameweek.</p>
                </div>
                <Button variant="primary" onClick={handleAutoFill}>
                  AutoFill
                </Button>
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
                    const isBonusUsed = bonusPlayedGameweek !== 0;
                    const isSameGameweek = bonusPlayedGameweek === currentGameweek;
                    return (
                      <Col xs={12} md={3} key={index}>
                        <Card className='mb-2'>
                          <div className='bonus-card-item'>
                            <div className='text-center mb-2'>
                              <StarIcon color="#807A00" />
                            </div>
                            <div className='text-center mb-2'>{bonus.name}</div>
                            {isBonusUsed ? (
                              <div className='text-center mb-2'>Played Gameweek {bonusPlayedGameweek}</div>
                            ) : (
                              isSameGameweek ? (
                                <div>You can only use 1 bonus per gameweek</div>
                              ) : (
                                <Button variant="primary w-100" onClick={() => handleBonusClick(bonus.id)}>
                                  Use
                                </Button>
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
