import React, { useState, useEffect, useContext } from 'react';
import { Container, Row, Col, Card, Button, Spinner, Dropdown } from 'react-bootstrap';
import { StarIcon, RecordIcon, PersonIcon, CaptainIcon, StopIcon, TwoIcon, ThreeIcon, PersonUpIcon, PersonBoxIcon} from '../icons';
import { OpenFPL_backend as open_fpl_backend } from '../../../../declarations/OpenFPL_backend';
import { AuthContext } from "../../contexts/AuthContext";
import { DataContext } from "../../contexts/DataContext";
import { Actor } from "@dfinity/agent";
import PlayerSlot from './player-slot';
import SelectPlayerModal from './select-player-modal';
import SelectFantasyPlayerModal from './select-fantasy-player-modal';
import SelectBonusTeamModal from './select-bonus-team-modal';
import ConfirmBonusModal from './confirm-bonus-modal';
import { fetchFantasyTeam } from "../../AuthFunctions";
import FixturesWidget from './fixtures-widget';
import ExampleSponsor from "../../../assets/example-sponsor.png";
import Shirt from "../../../assets/shirt.png";

const PickTeam = () => {
  const { authClient } = useContext(AuthContext);
  const { teams, players, systemState } = useContext(DataContext);
  const [isLoading, setIsLoading] = useState(true);
  const [loadingText, setLoadingText] = useState("Loading Team");
  const [currentGameweek, setCurrentGameweek] = useState(systemState.activeGameweek);
  const [currentSeason, setCurrentSeason] = useState(systemState.activeSeason);
  const [invalidTeamMessage, setInvalidTeamMessage] = useState('');
  const [selectedSlot, setSelectedSlot] = useState(null);
  const [selectedBonusId, setSelectedBonusId] = useState(null);
  const [selectedBonusPlayerId, setSelectedBonusPlayerId] = useState(null);
  const [selectedBonusTeamId, setSelectedBonusTeamId] = useState(null);
  const [showSelectPlayerModal, setShowSelectPlayerModal] = useState(false);
  const [showSelectFantasyPlayerModal, setShowSelectFantasyPlayerModal] = useState(false);
  const [showSelectBonusTeamModal, setShowSelectBonusTeamModal] = useState(false);
  const [showConfirmBonusModal, setShowConfirmBonusModal] = useState(false);
  const [showFormationDropdown, setShowFormationDropdown] = useState(false);
  const [formation, setFormation] = useState('4-4-2');
  const gk = 1;
  const [df, mf, fw] = formation.split('-').map(Number);
  const [rowPositions, setRowPositions] = useState({ gk: '10%', df: '30%', mf: '50%', fw: '70%' });

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
 
  const positionsForBonus = {
    1: null,  
    2: null,
    3: [1]
  };

  const isTeamValid = invalidTeamMessage === null;
  const [removedPlayers, setRemovedPlayers] = useState([]);
  const [addedPlayers, setAddedPlayers] = useState([]);

  const handleBlur = (e) => {
    const currentTarget = e.currentTarget;
    setTimeout(() => {
      if (!currentTarget.contains(document.activeElement)) {
        setShowFormationDropdown(false);
      }
    }, 0);
  };

  useEffect(() => {
    if(isLoading){
      return;
    };
    
    

    window.addEventListener('resize', handleResize);
    handleResize();

    return () => {
      window.removeEventListener('resize', handleResize);
    };
  }, [isLoading]);

  const handleResize = () => {
    const panel = document.querySelector('.pitch-bg');
    const panelWidth = panel.offsetWidth;
  
    const aspectRatio = 3216 / 3116;
    const panelHeight = panelWidth / aspectRatio;
  
    panel.style.height = `${panelHeight}px`;
  
    setRowPositions({
      gk: `${0.05 * panelHeight}px`,
      df: `${0.25 * panelHeight}px`,
      mf: `${0.5 * panelHeight}px`,
      fw: `${0.75 * panelHeight}px`,
    });
  };

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

  const handleFormationChange = (newFormation) => {
    setShowFormationDropdown(false);
    setFormation(newFormation);
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
  
  const calculateTeamValue = () => {
    if(fantasyTeam && fantasyTeam.players) {
      const totalValue = fantasyTeam.players.reduce((acc, player) => acc + Number(player.value), 0);
      return (totalValue / 4).toFixed(1);
    }
    return null;
  }
  
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

  const renderRow = (count) => {
    return (
      <div className={`w-100 row-container pos-${count}`}>
        {Array.from({ length: count }, (_, i) => (
          <div className={`player-container align-items-center justify-content-center pos-${count}`} key={i}>
            <img src={Shirt} alt="shirt" className='shirt align-items-center justify-content-center' />
          </div>
        ))}
      </div>
    );
  };
  

  

  return (
    isLoading ? (
      <div className="customOverlay d-flex flex-column align-items-center justify-content-center">
        <Spinner animation="border" />
        <p className='text-center mt-1'>{loadingText}</p>
      </div>) : (
        <Container fluid className='view-container mt-2'>
           <Row>
              <Col md={6} xs={12}>
                  <Card className='mb-3'>
                      <div className="outer-container d-flex">
                          <div className="stat-panel flex-grow-1">
                              
                              <Row className="stat-row-1">
                                  <Col xs={4}>
                                      <p style={{paddingLeft: '40px'}} className="stat-header w-100">Gameweek</p>
                                  </Col>
                                  <Col xs={5}>
                                      <p className="stat-header w-100">Deadline</p>
                                  </Col>
                                  <Col xs={3}>
                                      <p className="stat-header w-100">Players Selected</p>
                                  </Col>
                              </Row>
                              <Row className="stat-row-2">
                                  <Col xs={4}>
                                      <p style={{paddingLeft: '40px'}} className="stat">{currentGameweek}</p>
                                  </Col>
                                  <Col xs={5}>
                                      <p className="stat">countdown</p>
                                  </Col>
                                  <Col xs={3}>
                                      <p className="stat">0/11</p>
                                  </Col>
                              </Row>
                              <Row className="stat-row-3">
                                  <Col xs={4}>
                                      <p style={{paddingLeft: '40px'}} className="stat-header">{currentSeason.name}</p>   
                                  </Col>
                                  <Col xs={5}>
                                      <p className="stat-header">Date</p>    
                                  </Col>
                                  <Col xs={3}>
                                      <p className="stat-header">Total</p>   
                                  </Col>
                              </Row>
                          </div>
                          <div className="d-none d-md-block vertical-divider-1"></div>
                          <div className="d-none d-md-block vertical-divider-2"></div>
                      </div>
                  </Card>
              </Col>

              <Col md={6} xs={12}>
                  <Card className='mb-3'>
                      <div className="outer-container d-flex">
                          <div className="stat-panel flex-grow-1">
                              
                              <Row className="stat-row-1">
                                  <Col xs={4}>
                                      <p style={{paddingLeft: '40px'}} className="stat-header w-100">Team Value</p>
                                  </Col>
                                  <Col xs={5}>
                                      <p className="stat-header w-100">Bank Balance</p>
                                  </Col>
                                  <Col xs={3}>
                                      <p className="stat-header w-100">Transfers</p>
                                  </Col>
                              </Row>
                              <Row className="stat-row-2">
                                  <Col xs={4}>
                                      <p style={{paddingLeft: '40px'}} className="stat">£0.0m</p>
                                  </Col>
                                  <Col xs={5}>
                                      <p className="stat">£300m</p>
                                  </Col>
                                  <Col xs={3}>
                                      <p className="stat">2</p>
                                  </Col>
                              </Row>
                              <Row className="stat-row-3">
                                  <Col xs={4}>
                                      <p style={{paddingLeft: '40px'}} className="stat-header">GBP</p>   
                                  </Col>
                                  <Col xs={5}>
                                      <p className="stat-header">GBP</p>    
                                  </Col>
                                  <Col xs={3}>
                                      <p className="stat-header">Available</p>   
                                  </Col>
                              </Row>
                          </div>
                          <div className="d-none d-md-block vertical-divider-1"></div>
                          <div className="d-none d-md-block vertical-divider-2"></div>
                      </div>
                  </Card>
              </Col>
          </Row>
          <Row>
              <Col xs={12}>
                  <Card className='mb-3'>
                      <div className="outer-container d-flex">
                          <div className="sub-stat-panel flex-grow-1" style={{ display: 'flex', alignItems: 'center' }}>
                            <Row className="sub-stat-wrapper">
                              <Col xs={6} className='align-items-center justify-content-center'>
                                <div style={{ display: 'flex', alignItems: 'center' }}>
                                  <Button className="sub-stat-button sub-stat-button-left active">
                                      Pitch View
                                  </Button>
                                  <Button className="sub-stat-button sub-stat-button-right"
                                    style={{ marginRight: '40px' }} >
                                      List View
                                  </Button>

                                      
                                  <div onBlur={handleBlur}>
                                    <Dropdown show={showFormationDropdown}>
                                      <Dropdown.Toggle as={CustomToggle} id="dropdown-custom-components">
                                        <Button style={{backgroundColor: 'transparent'}} onClick={() => setShowFormationDropdown(!showFormationDropdown)} className="formation-text">Formation: <b>{formation}</b></Button>
                                       </Dropdown.Toggle>

                                       <Dropdown.Menu>
                                        {['3-4-3', '3-5-2', '4-3-3', '4-4-2', '4-5-1', '5-4-1', '5-3-2'].map(f => (
                                          <Dropdown.Item className='formation-dropdown-item' key={f} onClick={() => handleFormationChange(f)}>
                                          {formation === f && <span>✔</span>} {` ${f}`} 
                                         </Dropdown.Item>
                                        ))}
                                      </Dropdown.Menu>
                                    </Dropdown>
                                  </div>
                                </div>
                              </Col>

                              <Col xs={6}>
                                  
                              </Col>
                            </Row>
                          </div>
                      </div>
                  </Card>
              </Col>
          </Row>
          
          
          <Row>
            <Col xs={12} md={6}>
              
            <Card className="pitch-bg">

              <div className="row-wrapper">
                <Row>
                  <Col xs={6} className='d-flex align-items-center justify-content-center'>
                    <img src={ExampleSponsor} alt="sponsor1" className='sponsor1' />
                  </Col>
                  <Col xs={6} className='d-flex align-items-center justify-content-center'>
                    <img src={ExampleSponsor} alt="sponsor2" className='sponsor2' />
                  </Col>
                </Row>
              </div>
              
              
              <div className="row-wrapper" style={{ top: rowPositions.gk }}>
                <div className='gk-row'>
                  {renderRow(gk)}
                </div>
              </div>
              
              <div className="row-wrapper" style={{ top: rowPositions.df }}>
                <div className='df-row'>
                  {renderRow(df)}
                </div>
              </div>
              <div className="row-wrapper" style={{ top: rowPositions.mf }}>
                <div className='mf-row'>
                  {renderRow(mf)}
                </div>
              </div>
              <div className="row-wrapper" style={{ top: rowPositions.fw }}>
                <div className='fw-row'>
                  {renderRow(fw)}
                </div>
              </div>
            </Card>
      
            </Col>
            <Col xs={12} md={6}>
              <FixturesWidget teams={teams} />
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

const CustomToggle = React.forwardRef(({ children, onClick }, ref) => (
  <a
    href=""
    ref={ref}
    onClick={(e) => {
      e.preventDefault();
      onClick(e);
    }}
  >
    {children}
  </a>
));

export default PickTeam;
