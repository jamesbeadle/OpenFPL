import React, { useState, useEffect, useContext } from 'react';
import { Container, Row, Col, Card, Button, Spinner } from 'react-bootstrap';
import { StarIcon, RecordIcon, PersonIcon, CaptainIcon, StopIcon, TwoIcon, ThreeIcon, PersonUpIcon, PersonBoxIcon} from '../icons';
import { OpenFPL_backend as open_fpl_backend } from '../../../../declarations/OpenFPL_backend';
import { AuthContext } from "../../contexts/AuthContext";
import { DataContext } from "../../contexts/DataContext";
import { Actor } from "@dfinity/agent";
import PlayerSlot from './player-slot';
import Fixtures from './fixtures';
import SelectPlayerModal from './select-player-modal';
import SelectFantasyPlayerModal from './select-fantasy-player-modal';
import SelectBonusTeamModal from './select-bonus-team-modal';
import ConfirmBonusModal from './confirm-bonus-modal';
import { fetchFantasyTeam } from "../../AuthFunctions";

const PickTeam = () => {
  const { authClient } = useContext(AuthContext);
  const { teams, players, systemState } = useContext(DataContext);
  const [isLoading, setIsLoading] = useState(true);
  const [loadingText, setLoadingText] = useState("Loading Team");
  const [fantasyTeam, setFantasyTeam] = useState({
    players: [],
    bankBalance: 300,
    transfersAvailable: 2
  });
  
  const [bonuses, setBonuses] = useState([
    {id: 1, name: 'Goal Getter', propertyName: 'goalGetter', icon: <RecordIcon />},
    {id: 2, name: 'Pass Master', propertyName: 'passMaster', icon: <PersonBoxIcon />},
    {id: 3, name: 'No Entry', propertyName: 'noEntry', icon: <StopIcon />},
    {id: 4, name: 'Team Boost', propertyName: 'teamBoost', icon: <PersonUpIcon />},
    {id: 5, name: 'Safe Hands', propertyName: 'safeHands', icon: <PersonIcon />},
    {id: 6, name: 'Captain Fantastic', propertyName: 'captainFantastic', icon: <CaptainIcon />},
    {id: 7, name: 'Brace Bonus', propertyName: 'braceBonus', icon: <TwoIcon />},
    {id: 8, name: 'Hat Trick Hero', propertyName: 'hatTrickHero', icon: <ThreeIcon />}
  ]);

  const [showSelectPlayerModal, setShowSelectPlayerModal] = useState(false);
  const [showSelectFantasyPlayerModal, setShowSelectFantasyPlayerModal] = useState(false);
  const [showSelectBonusTeamModal, setShowSelectBonusTeamModal] = useState(false);
  const [showConfirmBonusModal, setShowConfirmBonusModal] = useState(false);
  const [selectedSlot, setSelectedSlot] = useState(null);
  const [currentGameweek, setCurrentGameweek] = useState(systemState.activeGameweek);
  const [currentSeason, setCurrentSeason] = useState(systemState.activeSeason);
  const [invalidTeamMessage, setInvalidTeamMessage] = useState('');
  const [selectedBonusId, setSelectedBonusId] = useState(null);
  const [selectedBonusPlayerId, setSelectedBonusPlayerId] = useState(null);
  const [selectedBonusTeamId, setSelectedBonusTeamId] = useState(null);
  const positionsForBonus = {
    1: null,  
    2: null,
    3: [1]
  };
  const isTeamValid = invalidTeamMessage === null;
  const [removedPlayers, setRemovedPlayers] = useState([]);
  const [addedPlayers, setAddedPlayers] = useState([]);

  useEffect(() => {
    if(players.length == 0 || teams.length == 0){
      return;
    }
    const fetchData = async () => {
      await fetchViewData();
    };
    fetchData();
  }, [players, teams]);
  
  
  useEffect(() => {
    setInvalidTeamMessage(getInvalidTeamMessage());
  }, [fantasyTeam]);

  const fetchViewData = async () => {
    setLoadingText("Loading Team");
    try {
        if(players.length == 0){
          return;
        }
        
        let fantasyTeamData = await fetchFantasyTeam(authClient);
        if(fantasyTeamData.playerIds.length == 0){
          return;
        }

        const playerIdArray = Object.values(fantasyTeamData.playerIds);

        const teamPlayers = playerIdArray
          .map(id => players.filter(player => player.teamId > 0).find(player => player.id === id))
          .filter(Boolean); 
        
        const roundedValue = (Number(fantasyTeamData.bankBalance) / 4).toFixed(2);

        fantasyTeamData = {
          ...fantasyTeamData,
            players: teamPlayers || [],
            bankBalance: Math.round(roundedValue * 4) / 4
        };
        setFantasyTeam(fantasyTeamData);
        
    } catch (error) {
        console.error(error);
    } finally {
        setIsLoading(false);
    }
};

  
const handlePlayerSelection = (slotNumber) => {
  setSelectedSlot(slotNumber);
  setShowSelectPlayerModal(true);
};

const handlePlayerConfirm = (player) => {
  setFantasyTeam(prevFantasyTeam => {
    const updatedFantasyTeam = {...prevFantasyTeam};
    updatedFantasyTeam.players[selectedSlot] = player;
    updatedFantasyTeam.bankBalance -= Number(player.value) / 4;

    if (!removedPlayers.includes(player.id)) {
      updatedFantasyTeam.transfersAvailable -= 1;
    }

    updatedFantasyTeam.players.sort((a, b) => {
      if (a.position < b.position) {
        return -1;
      } else if (a.position > b.position) {
        return 1;
      }
      
      if (a.position === b.position) {
        return Number(b.value) - Number(a.value);
      }
    
      return 0;
    });

    const sortedPlayers = [...updatedFantasyTeam.players].sort((a, b) => Number(b.value) - Number(a.value));
    updatedFantasyTeam.captainId = sortedPlayers[0] ? sortedPlayers[0].id : null;

    return updatedFantasyTeam;
  });
  setRemovedPlayers(prevRemovedPlayers => prevRemovedPlayers.filter(id => id !== player.id));
  setAddedPlayers(prevAddedPlayers => [...prevAddedPlayers, player.id]);

  setShowSelectPlayerModal(false);
};
  
const handleBonusClick = (bonusId) => {
    // Check if a bonus has already been applied for the current gameweek
    if (bonuses.some(bonus => fantasyTeam[`${bonus.propertyName}Gameweek`] === currentGameweek)) {
        return;
    }
    
    setSelectedBonusId(bonusId);
    if ([1, 2, 3].includes(bonusId)) {
        setShowSelectFantasyPlayerModal(true);
    } else if (bonusId === 4) {
        setShowSelectBonusTeamModal(true);
    } else {
        setShowConfirmBonusModal(true);
    }
};

const handleConfirmPlayerBonusClick = (data) => {
    const bonusObject = bonuses.find((bonus) => bonus.id === data.bonusType);

    if (!bonusObject) {
        console.error("No bonus found for type:", data.bonusType);
        return;
    }

    const bonusGameweekProperty = `${bonusObject.propertyName}Gameweek`;
    const bonusPlayerProperty = `${bonusObject.propertyName}PlayerId`;

    setFantasyTeam((prevFantasyTeam) => ({
        ...prevFantasyTeam,
        [bonusGameweekProperty]: currentGameweek,
        [bonusPlayerProperty]: data.playerId
    }));
    setSelectedBonusId(bonusObject.id);
    setSelectedBonusPlayerId(data.playerId);

    setShowSelectFantasyPlayerModal(false);
    
};

const handleConfirmTeamBonusClick = (data) => {
    const bonusObject = bonuses.find((bonus) => bonus.id === data.bonusType);

    if (!bonusObject) {
        console.error("No bonus found for type:", data.bonusType);
        return;
    }

    const bonusGameweekProperty = `${bonusObject.propertyName}Gameweek`;
    const bonusTeamProperty = `${bonusObject.propertyName}TeamId`;

    setFantasyTeam((prevFantasyTeam) => ({
        ...prevFantasyTeam,
        [bonusGameweekProperty]: currentGameweek,
        [bonusTeamProperty]: data.teamId
    }));
    setSelectedBonusId(bonusObject.id);
    setSelectedBonusTeamId(data.teamId);

    setShowSelectBonusTeamModal(false);
};

const handleConfirmBonusClick = (bonusType) => {
    const bonusObject = bonuses.find((bonus) => bonus.id === bonusType);

    if (!bonusObject) {
        console.error("No bonus found for type:", bonusType);
        return;
    }

    const bonusGameweekProperty = `${bonusObject.propertyName}Gameweek`;

    setFantasyTeam((prevFantasyTeam) => ({
        ...prevFantasyTeam,
        [bonusGameweekProperty]: currentGameweek
    }));
    setSelectedBonusId(bonusObject.id);

    setShowConfirmBonusModal(false);
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
      return "You must have between 3 and 5 defenders";
    }
    if (midfielderCount < 3 || midfielderCount > 5) {
      return "You must have between 3 and 5 midfielders";
    }
    if (forwardCount < 1 || forwardCount > 3) {
      return "You must have between 1 and 3 forwards";
    }
  
    const teams = fantasyTeam.players.map(player => player.teamId);
    const teamsCount = teams.reduce((acc, team) => {
      acc[team] = (acc[team] || 0) + 1;
      return acc;
    }, {});
    
    if (Object.values(teamsCount).some(count => count > 3)) {
      return "Max 3 players from any single club";
    }
  
    return null;
  };
  
  const renderPlayerSlots = () => {
    let rows = [];
    let cols = [];
    
    for (let i = 0; i < 12; i++) {
      const player = fantasyTeam.players[i] || null;
      let disableSellButton = player ? ((fantasyTeam.transfersAvailable <= 0 && currentGameweek > 1) || (fantasyTeam.players.length == 9 && currentGameweek > 1)) && !addedPlayers.includes(player.id) : false; 
      if(i === 11) {
        cols.push(
          <Col md={3} key={'save'} className="d-flex align-items-center">
            <Card className="w-100 save-panel mt-4">
              <Row className="mt-4">
                <Col>
                  {!isTeamValid && <p className='text-center small-text'><small>{invalidTeamMessage}</small></p>}
                  {isTeamValid && <p style={{color: "#16362C"}} className='text-center small-text'><small>Team Valid!</small></p>}
                </Col>
              </Row>
              <Row className="mb-2">
                <Col>
                  <Button style={{width: 'calc(100% - 1rem)', margin: '0rem 0.5rem'}} variant="success" onClick={handleSaveTeam} disabled={!isTeamValid}>Save Team</Button>
                </Col>
              </Row>
            </Card>
          </Col>
        );
      } else {
        cols.push(
          <Col md={3} key={'player-' + (i + 1)} className="align-items-center">
            {player && fantasyTeam ? ((() => {
              let bonusId;
              if (fantasyTeam.goalGetterPlayerId === player.id && fantasyTeam.goalGetterGameweek === currentGameweek) {
                bonusId = 1;
              } else if (fantasyTeam.passMasterPlayerId === player.id && fantasyTeam.passMasterGameweek === currentGameweek) {
                bonusId = 2;
              } else if (fantasyTeam.noEntryPlayerId === player.id && fantasyTeam.noEntryGameweek === currentGameweek) {
                 bonusId = 3;
              }
      
              return (
                <PlayerSlot 
                  player={player}
                  slotNumber={i}
                  handlePlayerSelection={handlePlayerSelection}
                  captainId={fantasyTeam.captainId} 
                  handleCaptainSelection={handleCaptainSelection} 
                  handleSellPlayer={handleSellPlayer}
                  bonusId={bonusId}
                  disableSellButton={disableSellButton}
                />
              );
            })()
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
      updatedFantasyTeam.bankBalance += Number(soldPlayer.value) / 4;

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

      bonuses.forEach(bonus => {
        const bonusGameweek = updatedFantasyTeam[`${bonus.propertyName}Gameweek`];
        const bonusPlayerId = updatedFantasyTeam[`${bonus.propertyName}PlayerId`];
        if (bonusGameweek === currentGameweek && bonusPlayerId === playerId) {
          updatedFantasyTeam[`${bonus.propertyName}Gameweek`] = null;
          updatedFantasyTeam[`${bonus.propertyName}PlayerId`] = null;
        }
      });

      return updatedFantasyTeam;
    });

    setRemovedPlayers(prevRemovedPlayers => [...prevRemovedPlayers, playerId]);
    setAddedPlayers(prevAddedPlayers => prevAddedPlayers.filter(id => id !== playerId));
  };
  
  const calculateTeamValue = () => {
    if(fantasyTeam && fantasyTeam.players) {
      const totalValue = fantasyTeam.players.reduce((acc, player) => acc + Number(player.value), 0);
      return (totalValue / 4).toFixed(1);
    }
    return null;
  }
  
  const handleSaveTeam = async () => {
    setLoadingText("Saving Team");
    setIsLoading(true);
    try {
      const newPlayerIds = fantasyTeam.players.map(player => Number(player.id));
      const identity = authClient.getIdentity();
      Actor.agentOf(open_fpl_backend).replaceIdentity(identity);
      await open_fpl_backend.saveFantasyTeam(newPlayerIds, fantasyTeam.captainId ? Number(fantasyTeam.captainId) : 0, selectedBonusId ? Number(selectedBonusId) : 0, selectedBonusPlayerId ? Number(selectedBonusPlayerId) : 0, selectedBonusTeamId ? Number(selectedBonusTeamId) : 0);
      await fetchViewData();
      setIsLoading(false);
    } catch(error) {
      await fetchViewData();
      console.error("Failed to save team", error);
      setIsLoading(false);
    }
  };

  const handleCaptainSelection = (playerId) => {
    setFantasyTeam(prevFantasyTeam => {
      const updatedFantasyTeam = {...prevFantasyTeam};
      updatedFantasyTeam.captainId = playerId;
  
      return updatedFantasyTeam;
    });
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
    const currentTeamPositions = fantasyTeam.players.map(player => teamPositions[player.position]);


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
    
    let sortedPlayers = [...players].sort((a, b) => Number(b.value) - Number(a.value));
    sortedPlayers = shuffle(sortedPlayers);
  
    let newTeam = [...fantasyTeam.players];
    let remainingBudget = fantasyTeam.bankBalance;
    for (let i = 0; i < positionsToFill.length; i++) {
      if (newTeam.length >= 11) {
        break;
      }
      let position = positionsToFill[i];
      const positionMapping = ['Goalkeeper', 'Defender', 'Midfielder', 'Forward'];

     for (let j = 0; j < sortedPlayers.length; j++) {
        if (positionMapping[sortedPlayers[j].position] === position && 
            (Number(sortedPlayers[j].value) * 4) <= remainingBudget &&
            !newTeam.some((teamPlayer) => teamPlayer.id === sortedPlayers[j].id)
        ) {
          newTeam.push(sortedPlayers[j]);
          remainingBudget -= Number(sortedPlayers[j].value) / 4;
          sortedPlayers.splice(j, 1);
          positionsToFill.splice(i, 1);
          i--;
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
        return Number(b.value) - Number(a.value);
      }
    
      return 0;
    });
    
    
    fantasyTeam.positionsToFill = [];
    
    setFantasyTeam(prevState => ({
      ...prevState,
      players: newTeam,
      bankBalance: remainingBudget,
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
  
  const getPlayerNameFromId = (playerId) => {
    const player = fantasyTeam.players.find(player => player.id === playerId);
    if(!player){
      return;
    }
    return (player.firstName != "" ? player.firstName.charAt(0) + "." : "") + player.lastName;
  }

  const getTeamNameFromId = (teamId) => {
    const team = teams.find(team => team.id === teamId);
    if(!team){
      return;
    }
    return team.friendlyName;
  }
  
  
  return (
    isLoading ? (
      <div className="customOverlay d-flex flex-column align-items-center justify-content-center">
        <Spinner animation="border" />
        <p className='text-center mt-1'>{loadingText}</p>
      </div>) : (
        <Container className="flex-grow-1 my-5 pitch-bg mt-0">
          <Row className="mb-4">
            <Col md={9}>
              <Card className="mt-4">
                <Card.Header>
                  <Row className="justify-content-between align-items-center">
                    <Col xs={12} md={3} className='mb-1'>
                      Team Selection<br />
                      <small className='small-text'>Season: {currentSeason.name}</small><br />
                      <small className='small-text'>Gameweek: {currentGameweek}</small>
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
                              £{(fantasyTeam.bankBalance).toFixed(1)}m
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
                </Card.Header>
                <Card.Body>
                  <Row className='mb-2'>
                    <Col md={10}>
                      <div className='d-flex align-items-center mb-4 mb-md-0'>
                        <StarIcon color="#807A00" width="15pt" height="15pt" />
                        <p style={{marginLeft: '1rem'}} className='mb-0'><small>Make a player your captain by selecting their star icon to receive double points for that player in the next gameweek.</small></p>
                      </div>
                    </Col>
                    <Col md={2} className='d-flex align-items-center'>
                      <Button style={{marginLeft: '0.8rem', marginRight: '0.8rem'}}  variant="secondary white-text w-100" onClick={handleAutoFill}>AutoFill</Button>
                    </Col>
                  </Row>
                  <Row>
                    {fantasyTeam && fantasyTeam.players && renderPlayerSlots(fantasyTeam.players, fantasyTeam.captainId, handleCaptainSelection)}
                  </Row>
                </Card.Body>

              </Card>
              <Card className="mt-4">
                <Card.Header>Bonuses</Card.Header>
                <Card.Body>
                  <Row >
                  {bonuses.map((bonus, index) => {
                    const bonusPlayerId = fantasyTeam?.[`${bonus.propertyName}PlayerId`];
                    const bonusTeamId = fantasyTeam?.[`${bonus.propertyName}TeamId`];
                    const bonusGameweek = fantasyTeam?.[`${bonus.propertyName}Gameweek`];
                    const bonusUsed = bonusGameweek !== null && bonusGameweek !== 0 && bonusGameweek !== undefined;
                    const otherBonusUsedInCurrentWeek = bonuses.some((otherBonus) => {
                    if (otherBonus.propertyName === bonus.propertyName) return false; 
                      const otherBonusGameweek = fantasyTeam?.[`${otherBonus.propertyName}Gameweek`];
                      return otherBonusGameweek === currentGameweek;
                    });
                  
                    let bonusTarget = "";
                    let bonusDescription = "";
                    if (bonusPlayerId) {
                      bonusTarget = getPlayerNameFromId(bonusPlayerId);
                      bonusDescription = "Player: ";
                    } else if (bonusTeamId) {
                      bonusTarget = getTeamNameFromId(bonusTeamId);
                      bonusDescription = "Team: ";
                    } else if(bonusUsed) {
                      bonusTarget = ``;
                    }

                    let isBonusActive = !bonusUsed;
                    let useButton = (
                      <div style={{marginLeft: '1rem', marginRight: '1rem'}}>
                        <Button variant="info" className="w-100 mb-4" onClick={() => handleBonusClick(bonus.id)}>
                          Use
                        </Button>
                      </div>
                    );

                    if (bonusUsed) {
                      useButton = <div className='text-center mb-4'>
                          <small>{`Used in Gameweek ${bonusGameweek}`}</small>
                          <br />
                          <small>{`${bonusDescription}${bonusTarget}`}</small>
                        </div>;
                    } 
                  
                    if (otherBonusUsedInCurrentWeek) {
                      isBonusActive = false;
                      useButton = <p style={{width: 'calc(100% - 1rem)', margin: '0rem 0.5rem'}} className='text-center small-text mb-2'>You can only use 1 bonus each week.</p>;
                    }
                    
                    return (
                      <Col xs={12} md={3} key={index} className='mb-3'>
                        <Card style={{ opacity: isBonusActive ? 1 : 0.5 }}>
                          <div className='bonus-card-item'>
                            <div className='text-center mb-2 mt-2'>
                              {bonus.icon}
                            </div>
                            <div className='text-center mx-1'>{bonus.name}</div>
                            {useButton}
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

          {fantasyTeam && fantasyTeam.players && (
              <SelectPlayerModal 
              show={showSelectPlayerModal} 
              handleClose={() => setShowSelectPlayerModal(false)} 
              handleConfirm={handlePlayerConfirm}
              fantasyTeam={fantasyTeam}
            />
          )}
          
          
          {showSelectFantasyPlayerModal && <SelectFantasyPlayerModal 
            show={showSelectFantasyPlayerModal}
            handleClose={() => setShowSelectFantasyPlayerModal(false)}
            handleConfirm={handleConfirmPlayerBonusClick}
            fantasyTeam={fantasyTeam}
            positions={positionsForBonus[selectedBonusId]}
            bonusType={selectedBonusId}
          />}

          {showSelectBonusTeamModal && <SelectBonusTeamModal
            show={showSelectBonusTeamModal}
            handleClose={() => setShowSelectBonusTeamModal(false)}
            handleConfirm={handleConfirmTeamBonusClick}
            bonusType={selectedBonusId}
          />}

          {showConfirmBonusModal && <ConfirmBonusModal
            show={showConfirmBonusModal}
            handleClose={() => setShowConfirmBonusModal(false)}
            handleConfirm={handleConfirmBonusClick}
            bonusType={selectedBonusId}
          />}
          
        </Container>
      )
  );
};

export default PickTeam;
