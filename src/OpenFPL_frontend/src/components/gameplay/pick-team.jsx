import React, { useState, useEffect, useContext, useRef } from 'react';
import { Container, Row, Col, Card, Button, Spinner, Dropdown } from 'react-bootstrap';
import { PlusIcon, ShirtIcon, BadgeIcon, RemovePlayerIcon, CaptainIcon, CaptainIconActive, DefaultShirtIcon, StripedShirtIcon} from '../icons';
import { AuthContext } from "../../contexts/AuthContext";
import { DataContext } from "../../contexts/DataContext";
import { fetchFantasyTeam } from "../../AuthFunctions";
import FixturesWidget from './fixtures-widget';
import SelectPlayerModal from './select-player-modal';
import SelectBonusPlayerModal from './select-bonus-player-modal';
import SelectBonusTeamModal from './select-bonus-team-modal';
import ConfirmBonusModal from './confirm-bonus-modal';
import ExampleSponsor from "../../../assets/example-sponsor.png";
import GoalGetter from "../../../assets/goal-getter.png";
import PassMaster from "../../../assets/pass-master.png";
import NoEntry from "../../../assets/no-entry.png";
import TeamBoost from "../../../assets/team-boost.png";
import SafeHands from "../../../assets/safe-hands.png";
import CaptainFantastic from "../../../assets/captain-fantastic.png";
import BraceBonus from "../../../assets/brace-bonus.png";
import HatTrickHero from "../../../assets/hat-trick-hero.png";
import { saveFantasyTeam } from '../../AuthFunctions';
import getFlag from '../country-flag';
import { getTeamById, getPlayerById, getPositionText, getAvailableFormations, computeTimeLeft } from '../helpers';

const PickTeam = () => {
  const { authClient } = useContext(AuthContext);
  const { teams, players, systemState, fixtures } = useContext(DataContext);
  const [isLoading, setIsLoading] = useState(true);
  const [loadingText, setLoadingText] = useState("Loading Team");
  const [currentGameweek, setCurrentGameweek] = useState(systemState.activeGameweek);
  const [currentSeason, setCurrentSeason] = useState(systemState.activeSeason);
  const [showSelectPlayerModal, setShowSelectPlayerModal] = useState(false);
  const [showSelectBonusPlayerModal, setShowSelectBonusPlayerModal] = useState(false);
  const [showSelectBonusTeamModal, setShowSelectBonusTeamModal] = useState(false);
  const [showConfirmBonusModal, setShowConfirmBonusModal] = useState(false);
  const [showFormationDropdown, setShowFormationDropdown] = useState(false);
  const [showListView, setShowListView] = useState(false);
  const [formation, setFormation] = useState('4-4-2');
  const allFormations = ['3-4-3', '3-5-2', '4-3-3', '4-4-2', '4-5-1', '5-4-1', '5-3-2'];
  const [availableFormations, setAvailableFormations] = useState(allFormations);
  const teamPositions = ['Goalkeeper', 'Defender', 'Midfielder', 'Forward'];
  const gk = 1;
  const [df, mf, fw] = formation.split('-').map(Number);
  const [rowPositions, setRowPositions] = useState({ gk: '10%', df: '30%', mf: '50%', fw: '70%' });
  const positionsForBonus = {
    1: null,  
    2: null,
    3: [1]
  }; 

  const cardContainerRef = useRef(null);

  const scroll = (direction) => {
    if (cardContainerRef.current) {
      cardContainerRef.current.scrollBy({
        left: direction === 'left' ? -200 : 200,
        behavior: 'smooth'
      });
    }
  };
  const [selectedPosition, setSelectedPosition] = useState(null);
  const [selectedSlot, setSelectedSlot] = useState(null);
  const [activeIndex, setActiveIndex] = useState(null);


  
  const [selectedBonusId, setSelectedBonusId] = useState(null);
  const [selectedBonusPlayerId, setSelectedBonusPlayerId] = useState(null);
  const [selectedBonusTeamId, setSelectedBonusTeamId] = useState(null);
  
  const [fantasyTeam, setFantasyTeam] = useState({
    players: [],
    bankBalance: 300,
    transfersAvailable: 2
  });
  const [removedPlayers, setRemovedPlayers] = useState([]);
  const [addedPlayers, setAddedPlayers] = useState([]);  

  const [bonuses, setBonuses] = useState([
    {id: 1, name: 'Goal Getter', propertyName: 'goalGetter', icon: GoalGetter},
    {id: 2, name: 'Pass Master', propertyName: 'passMaster', icon: PassMaster},
    {id: 3, name: 'No Entry', propertyName: 'noEntry', icon: NoEntry},
    {id: 4, name: 'Team Boost', propertyName: 'teamBoost', icon: TeamBoost},
    {id: 5, name: 'Safe Hands', propertyName: 'safeHands', icon: SafeHands},
    {id: 6, name: 'Captain Fantastic', propertyName: 'captainFantastic', icon: CaptainFantastic},
    {id: 7, name: 'Brace Bonus', propertyName: 'braceBonus', icon: BraceBonus},
    {id: 8, name: 'Hat Trick Hero', propertyName: 'hatTrickHero', icon: HatTrickHero}
  ]);

  const [days, setDays] = useState(0);
  const [hours, setHours] = useState(0);
  const [minutes, setMinutes] = useState(0);
  const [newTeam, setNewTeam] = useState(false);
  
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
    const panel = document.querySelector('#pitch-bg');
    if(!panel){
      return;
    }
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

  const handleFormationBlur = (e) => {
    const currentTarget = e.currentTarget;
    setTimeout(() => {
      if (!currentTarget.contains(document.activeElement)) {
        setShowFormationDropdown(false);
      }
    }, 0);
  };

  
  useEffect(() => {
    const timer = setInterval(updateCountdowns, 1000);
    return () => clearInterval(timer);    
}, []);

  useEffect(() => {
    if(showListView){
      window.removeEventListener('resize', handleResize);
    }else{
      window.addEventListener('resize', handleResize);
      handleResize();
    }
  }, [showListView]);

  useEffect(() => {
    if(players.length == 0 || teams.length == 0 || fixtures.length == 0){
      return;
    }
    const fetchData = async () => {
      await fetchViewData();
      await setGameweekPickingFor();
    };
    fetchData();
    
  }, [players, teams, fixtures]);

  const fetchViewData = async () => {
    setLoadingText("Loading Team");
    try {
        if(players.length == 0){
          return;
        }

        let fantasyTeamData = await fetchFantasyTeam(authClient);
        if(fantasyTeamData.playerIds.length == 0){
          setNewTeam(true);
          return;
        }

        const playerIdArray = Object.values(fantasyTeamData.playerIds);
        
        const teamPlayers = playerIdArray
          .map(id => players.filter(player => player.teamId > 0).find(player => player.id === id))
          .filter(Boolean); 
        
        const roundedValue = (Number(fantasyTeamData.bankBalance) / 4).toFixed(2);

        fantasyTeamData = {
          ...fantasyTeamData,
            players: teamPlayers || {},
            bankBalance: Math.round(roundedValue * 4) / 4
        };
        setFantasyTeam(fantasyTeamData);        
        setFormations(teamPlayers);
    } catch (error) {
        console.error(error);
    } finally {
        setIsLoading(false);
    }
  };

  useEffect(() => {
    if (!fantasyTeam || !fantasyTeam.players) {
      return false;
    }
    calculateAvailableFormations();
    updateTeamFormation();
  }, [fantasyTeam]);

  const setFormations = async (teamPlayers) => {
    
    const countPlayersByPosition = teamPlayers.reduce((acc, player) => {
      const pos = teamPositions[player.position];
      acc[pos] = (acc[pos] || 0) + 1;
      return acc;
    }, {});
    
    const formationString = `${countPlayersByPosition['Defender']}-${countPlayersByPosition['Midfielder']}-${countPlayersByPosition['Forward']}`;
    setFormation(formationString);
  };

  const calculateAvailableFormations = () => {
    const playerCounts = {0: 0, 1: 0, 2: 0, 3: 0};
    Object.values(fantasyTeam.players).forEach(player => {
      playerCounts[player.position]++;
    });
  
    if (Object.values(fantasyTeam.players).length === 11) {
      const formationString = `${playerCounts[1]}-${playerCounts[2]}-${playerCounts[3]}`;
      setAvailableFormations([formationString]);
      return;
    }
  
    const available = getAvailableFormations(playerCounts);
    setAvailableFormations(available);
  };

  const setGameweekPickingFor = async () => {
    const currentDateTime = new Date();
    const currentGameweekFixtures = fixtures.filter(fixture => fixture.gameweek === systemState.activeGameweek);
    currentGameweekFixtures.sort((a, b) => Number(a.kickOff) - Number(b.kickOff));

    const kickOffInMilliseconds = Number(currentGameweekFixtures[0].kickOff) / 1000000;
    const firstFixtureTime = new Date(kickOffInMilliseconds);
   
    const oneHourBeforeFirstFixture = new Date(firstFixtureTime - 3600000);
    if (currentDateTime >= oneHourBeforeFirstFixture) {
        setCurrentGameweek(systemState.activeGameweek + 1);
    }
    else{
      setCurrentGameweek(systemState.activeGameweek);  
    }
  };

  const isTeamValid = () => {
    
    if (!fantasyTeam.players || Object.keys(fantasyTeam.players).length !== 11) {
      return false;
    }
  
    const positions = Object.values(fantasyTeam.players).map(player => player.position);
    
    const goalkeeperCount = positions.filter(position => position === 0).length;
    const defenderCount = positions.filter(position => position === 1).length;
    const midfielderCount = positions.filter(position => position === 2).length;
    const forwardCount = positions.filter(position => position === 3).length;
    
    if (goalkeeperCount !== 1) {
      return false;
    }
    if (defenderCount < 3 || defenderCount > 5) {
      return false;
    }
    if (midfielderCount < 3 || midfielderCount > 5) {
      return false;
    }
    if (forwardCount < 1 || forwardCount > 3) {
      return false;
    }
  
    const teams = Object.values(fantasyTeam.players).map(player => player.teamId);
    const teamsCount = teams.reduce((acc, team) => {
      acc[team] = (acc[team] || 0) + 1;
      return acc;
    }, {});
    
    if (Object.values(teamsCount).some(count => count > 2)) {
      return false;
    }
  
    return true;
  };

  //All event handlers - refactor

  const handleFormationChange = (newFormation) => {
    setShowFormationDropdown(false);
    setFormation(newFormation);
  };

  const handlePlayerConfirm = (player) => {
    
    setFantasyTeam(prevFantasyTeam => {
      const updatedFantasyTeam = {...prevFantasyTeam};
      const slot = `${selectedPosition}-${activeIndex}`;
      updatedFantasyTeam.players = updatedFantasyTeam.players || {};
      updatedFantasyTeam.players[slot] = player;

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
      if (!updatedFantasyTeam.captainId) {
        updatedFantasyTeam.captainId = sortedPlayers[0] ? sortedPlayers[0].id : null;
      }

      return updatedFantasyTeam;
    });
    setRemovedPlayers(prevRemovedPlayers => prevRemovedPlayers.filter(id => id !== player.id));
    setAddedPlayers(prevAddedPlayers => [...prevAddedPlayers, player.id]);
    calculateAvailableFormations();
    setShowSelectPlayerModal(false);
  };

  const updateTeamFormation = () => {
    const playerCounts = { 1: 0, 2: 0, 3: 0 }; 

    Object.values(fantasyTeam.players || {}).forEach(player => {
      playerCounts[player.position]++;
    });
  
    const inferredFormation = `${playerCounts[1]}-${playerCounts[2]}-${playerCounts[3]}`;
    if (availableFormations.includes(inferredFormation)) {
      setFormation(inferredFormation);
    }
  };

  const handleBonus = (bonusId) => {
      if (bonuses.some(bonus => fantasyTeam[`${bonus.propertyName}Gameweek`] === currentGameweek)) {
          return;
      }
      
      setSelectedBonusId(bonusId);
      if ([1, 2, 3].includes(bonusId)) {
          setShowSelectBonusPlayerModal(true);
      } else if (bonusId === 4) {
          setShowSelectBonusTeamModal(true);
      } else {
          setShowConfirmBonusModal(true);
      }
  };

  const handleConfirmPlayerBonus = (data) => {
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

      setShowSelectBonusPlayerModal(false);
      
  };

  const handleConfirmTeamBonus = (data) => {
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

  const handleConfirmBonus = (bonusType) => {
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
      const soldPlayer = Object.values(fantasyTeam.players).find(player => player.id === playerId);
  
      const slotToDelete = Object.keys(updatedFantasyTeam.players).find(slot => updatedFantasyTeam.players[slot].id === playerId);
      delete updatedFantasyTeam.players[slotToDelete];

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
    calculateAvailableFormations();
  };
  
  const handleSaveTeam = async () => {
    setLoadingText("Saving Team");
    setIsLoading(true);
    const newPlayerIds = Object.values(fantasyTeam.players).map(player => Number(player.id));
    await saveFantasyTeam(authClient, newPlayerIds, fantasyTeam, selectedBonusId, selectedBonusPlayerId, Number(selectedBonusTeamId));    
    await fetchViewData();
    setNewTeam(false);
    setIsLoading(false);
  };

  const handleCaptainSelection = (playerId) => {
    setFantasyTeam(prevFantasyTeam => {
      const updatedFantasyTeam = {...prevFantasyTeam};
      updatedFantasyTeam.captainId = playerId;
  
      return updatedFantasyTeam;
    });
  };

  function autofillTeam() {
    let updatedFantasyTeam = { ...fantasyTeam, players: fantasyTeam.players || {} };
    let remainingBudget = fantasyTeam.bankBalance;
  
    // Count existing players per team
    const teamCounts = {};
    Object.values(updatedFantasyTeam.players).forEach((player) => {
        teamCounts[player.teamId] = (teamCounts[player.teamId] || 0) + 1;
    });

    // Create a shuffled list of eligible team IDs
    let eligibleTeams = Array.from(new Set(players.filter(player => player.teamId > 0).map((player) => player.teamId)));
    eligibleTeams.sort(() => Math.random() - 0.5);
  
    const [defenders, midfielders, forwards] = formation.split("-").map(Number);
    const formationArray = [
        ...Array(defenders).fill(1),
        ...Array(midfielders).fill(2),
        ...Array(forwards).fill(3),
        0,
    ];

    let playerAdded = false;
    formationArray.forEach((position, index) => {
        if (remainingBudget <= 0 || eligibleTeams.length === 0) return;
  
        const teamId = eligibleTeams.shift();
  
        const availablePlayers = players.filter((player) => (
            player.position === position &&
            player.teamId === teamId &&
            !updatedFantasyTeam.players[`${position}-${index}`] &&
            !Object.values(updatedFantasyTeam.players).some(p => p.id === player.id)
        ));
        
        console.log(availablePlayers)
  
        availablePlayers.sort((a, b) => Number(a.value) - Number(b.value));
        const lowerHalf = availablePlayers.slice(0, Math.ceil(availablePlayers.length / 2));
        const selectedPlayer = lowerHalf[Math.floor(Math.random() * lowerHalf.length)];
  
        if (selectedPlayer) {
          const potentialNewBudget = remainingBudget - Number(selectedPlayer.value) / 4;
          if (potentialNewBudget < 0) {
              return;
          }
          const slot = `${position}-${index}`;
          updatedFantasyTeam.players[slot] = selectedPlayer;
          remainingBudget = potentialNewBudget;
          playerAdded = true;
      }
      
    });
    console.log("remainingBudget")
    console.log(remainingBudget)
    if (remainingBudget >= 0 && playerAdded) {
        updatedFantasyTeam.bankBalance = remainingBudget;
        console.log("setting fantasy team 1")
        setFantasyTeam(updatedFantasyTeam);
    }
  }

  
  
  
  


  
  //MOVE TO UTILITIES
  const calculateTeamValue = () => {
    if(fantasyTeam && fantasyTeam.players) {
      const totalValue = Object.values(fantasyTeam.players).reduce((acc, player) => acc + Number(player.value), 0);
      return (totalValue / 4).toFixed(1);
    }
    return null;
  }
  

  //Move to utilities with homepage countdown  
  const updateCountdowns = async () => {
    const sortedFixtures = fixtures.sort((a, b) => Number(a.kickOff) - Number(b.kickOff));
    
    const currentTime = Date.now();
    const fixture = sortedFixtures.find(fixture => Number(fixture.kickOff) > currentTime);
    
    if (fixture) {
        const timeLeft = computeTimeLeft(Number(fixture.kickOff));
        const timeLeftInMillis = 
            timeLeft.days * 24 * 60 * 60 * 1000 + 
            timeLeft.hours * 60 * 60 * 1000 + 
            timeLeft.minutes * 60 * 1000 + 
            timeLeft.seconds * 1000;
        
        const d = -Math.floor(timeLeftInMillis / (1000 * 60 * 60 * 24));
        const h = -Math.floor((timeLeftInMillis % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
        const m = -Math.floor((timeLeftInMillis % (1000 * 60 * 60)) / (1000 * 60));

        setDays(d);
        setHours(h);
        setMinutes(m);
    } else {
        setDays(0);
        setHours(0);
        setMinutes(0);
    }
};

  const renderRow = (count, position) => {
    const playersForPosition = Object.values(fantasyTeam.players)
            .filter(player => player.position === position);

    return (
      <div className={`w-100 row-container pos-${count}`}>
        {Array.from({ length: count }, (_, i) => {
          const slot = `${position}-${i}`;
          const player = playersForPosition[i];
          
          return (
            <div 
              className={`player-container align-items-center justify-content-center pos-${count}`} 
              key={slot}
            >
              {player ? (
                <>
                  {(() => {
                    const foundTeam = teams.find(team => team.id === player.teamId);
                    return (
                      <>
                        <div className="shirt-container">
                          {foundTeam.shirtType == 0 ? <ShirtIcon primary={foundTeam.primaryColourHex} secondary={foundTeam.secondaryColourHex} third={foundTeam.thirdColourHex} className='shirt align-items-center justify-content-center' />
                            : <StripedShirtIcon primary={foundTeam.primaryColourHex} secondary={foundTeam.secondaryColourHex} third={foundTeam.thirdColourHex} className='shirt align-items-center justify-content-center' /> }
                          
                          {(fantasyTeam && fantasyTeam.transfersAvailable > 0) && (<button className="remove-player-button left-side-image p-0" onMouseDown={() => { handleSellPlayer(player.id); }}><RemovePlayerIcon width={14} height={14} /></button>)}
                            
                          <button className="captain-player-button right-side-image p-0" onMouseDown={() => { handleCaptainSelection(player.id); }}>
                            {player.id === fantasyTeam.captainId ? (
                              <CaptainIconActive width={23} height={22} />
                            ) : (
                              <CaptainIcon width={23} height={22} />
                            )}
                          </button>
                        </div>
                        <div className="player-details">
                          <div className="player-name-row">
                            <div style={{marginRight: '4px'}}>{getFlag(player.nationality)}</div>
                            {
                              (player.firstName !== "" ? player.firstName.charAt(0) + ". " : "") + 
                              (player.lastName.length > 8 ? player.lastName.substring(0, 6) + ".." : player.lastName)
                            }

                            {" ("}
                            {getPositionText(player.position)}
                            {")"}
                          </div>
                          <div className="player-info-row">
                            <span className="position-text"> 
                              {foundTeam.abbreviatedName}
                            <span className='pitch-team-badge'>
                              <BadgeIcon 
                                primary={foundTeam.primaryColourHex}
                                secondary={foundTeam.secondaryColourHex}
                                third={foundTeam.thirdColourHex}
                                width={16}
                                height={16}
                              />
                            </span>
                            £{(player.value/4).toFixed(2).toLocaleString()}m</span>
                          </div>
                        </div>
                      </>
                    );
                  })()} 
                </>
              ) : (
                    
                <DefaultShirtIcon    
                onClick={() => {
                  setShowSelectPlayerModal(true);
                  setSelectedPosition(position);
                  setSelectedSlot(slot);
                  setActiveIndex(i);
                }}  className='shirt align-items-center justify-content-center' />
              )}
            </div>
          );
        })}
      </div>
    );
  };
  
  const renderListRows = (count, position, positionText) => {
    const playersForPosition = Object.values(fantasyTeam.players)
            .filter(player => player.position === position);

    return (
      <>
        {Array.from({ length: count }, (_, i) => {
          const slot = `${position}-${i}`;
          const player = playersForPosition[i];
       
          return (
            <div 
              className={`list-player-container align-items-center justify-content-center list-pos-${count}`} 
              key={slot}
            >
              {player ? (
                <>
                  <div className="list-view-player-row">
                    {(() => {
                      const foundTeam = teams.find(team => team.id === player.teamId);
                      return (
                        <div className={`list-view-player-row-sub list-pos-${count}`}>
                          <div className="header-col position-col">{positionText}</div>
                          
                          <div className="header-col captain-col">
                            <button className="captain-player-button p-0" onMouseDown={() => { handleCaptainSelection(player.id); }}>
                              {player.id === fantasyTeam.captainId ? (
                                <CaptainIconActive width={23} height={22} />
                              ) : (
                                <CaptainIcon width={23} height={22} />
                              )}
                            </button>
                          </div>
                          <div className="header-col player-col">
                            <div className="list-player-name-row">
                              <div style={{marginRight: '4px'}}>{getFlag(player.nationality)}</div>
                              {(player.firstName !== "" ? player.firstName.charAt(0) + "." : "") + player.lastName}
                            </div>
                          </div>
                          <div className="header-col team-col">
                            <div className="list-player-info-row">
                              <span className='list-pitch-team-badge'>
                                <BadgeIcon 
                                  primary={foundTeam.primaryColourHex}
                                  secondary={foundTeam.secondaryColourHex}
                                  third={foundTeam.thirdColourHex}
                                  width={16}
                                  height={16}
                                />
                              </span>
                              {foundTeam.abbreviatedName}
                            </div>
                          </div>
                          <div className="header-col value-col">£{(player.value/4).toFixed(2).toLocaleString()}m</div>
                          <div className="header-col button-col">
                            <button className="remove-player-button" onMouseDown={() => { handleSellPlayer(player.id); }}><RemovePlayerIcon width={16} height={16} /></button>
                          </div>
                        </div>
                      );
                    })()}
                  </div>
                </>
              ) : (
                <div className={`list-view-player-row list-pos-${count}`}>
                  <div className="header-col position-col">{positionText}</div>
                  <div className="header-col captain-col"></div>
                  <div className="header-col player-col">Select</div>
                  <div className="header-col team-col"></div>
                  <div className="header-col value-col"></div>
                  <div className="header-col button-col">
                    <button onMouseDown={() => {
                      setShowSelectPlayerModal(true);
                      setSelectedPosition(position);
                      setSelectedSlot(slot);
                      setActiveIndex(i); }} className='add-player-button'><PlusIcon /></button>
                  </div>
                </div>
              )}
            </div>
          );
        })}
      </>
    );
  };
  

  return (
    isLoading ? (
      <div className="customOverlay d-flex flex-column align-items-center justify-content-center">
        <Spinner animation="border" />
        <p className='text-center mt-1'>{loadingText}</p>
      </div>) : (
        <>
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
                                  <Col xs={4}>
                                      <p className="stat-header w-100">Deadline</p>
                                  </Col>
                                  <Col xs={4}>
                                      <p className="stat-header w-100">Players Selected</p>
                                  </Col>
                              </Row>
                              <Row className="stat-row-2">
                                  <Col xs={4}>
                                      <p style={{paddingLeft: '40px'}} className="stat">{currentGameweek}</p>
                                  </Col>
                                  <Col xs={4}>
                                    <Row>
                                      <Col xs={4} className="add-colon">
                                          <p className="stat w-100 text-center">{String(days).padStart(2, '0')}</p>
                                      </Col>
                                      <Col xs={4} className="add-colon">
                                          <p className="stat w-100 text-center">{String(hours).padStart(2, '0')}</p>
                                      </Col>
                                      <Col xs={4}>
                                          <p className="stat w-100 text-center">{String(minutes).padStart(2, '0')}</p>
                                      </Col>
                                    </Row>
                                  </Col>
                                  <Col xs={4}>
                                      <p className="stat">{Object.keys(fantasyTeam.players).length}/11</p>
                                  </Col>
                              </Row>
                              <Row className="stat-row-3">
                                  <Col xs={4}>
                                      <p style={{paddingLeft: '40px'}} className="stat-header">{currentSeason.name}</p>   
                                  </Col>
                                  <Col xs={4}>
                                      <p className="stat-header">
                                        {fixtures.find(x => x.gameweek == currentGameweek).kickOff}  
                                      </p>    
                                  </Col>
                                  <Col xs={4}>
                                      <p className="stat-header">Total</p>   
                                  </Col>
                              </Row>
                          </div>
                          <div className="d-none d-md-block vertical-divider-4"></div>
                          <div className="d-none d-md-block vertical-divider-5"></div>
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
                                      <p style={{paddingLeft: '40px'}} className="stat">£{calculateTeamValue()}m</p>
                                  </Col>
                                  <Col xs={5}>
                                      <p className="stat">£{(fantasyTeam.bankBalance).toFixed(2)}m</p>
                                  </Col>
                                  <Col xs={3}>
                                      <p className="stat">
                                        {
                                          (newTeam) ? 
                                            '-' : 
                                          (fantasyTeam ? fantasyTeam.transfersAvailable : 0)
                                        }</p>
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
                            <Button 
                              onClick={() => setShowListView(false)} 
                              className={`sub-stat-button sub-stat-button-left ${!showListView ? 'active' : ''}`}
                            >
                              Pitch View
                            </Button>
                            <Button 
                              onClick={() => setShowListView(true)} 
                              className={`sub-stat-button sub-stat-button-right ${showListView ? 'active' : ''}`}
                              style={{ marginRight: '40px' }}
                            >
                            List View
                          </Button>                                      
                          <div onBlur={handleFormationBlur}>
                            <Dropdown show={showFormationDropdown}>
                              <Dropdown.Toggle as={CustomToggle} id="dropdown-custom-components">
                                <Button style={{backgroundColor: 'transparent'}} onClick={() => setShowFormationDropdown(!showFormationDropdown)} className="formation-text">Formation: <b>{formation}</b></Button>
                                </Dropdown.Toggle>

                                <Dropdown.Menu className='formation-dropdown'>
                                {allFormations.map(f => (
                                  <Dropdown.Item className='dropdown-item' key={f} onClick={() => handleFormationChange(f)} disabled={!availableFormations.includes(f)}>
                                  {formation === f && <span>✔</span>} {` ${f}`} 
                                  </Dropdown.Item>
                                ))}
                              </Dropdown.Menu>
                            </Dropdown>
                          </div>
                        </div>
                      </Col>

                      <Col xs={6} className="float-right-buttons">
                          <button className='autofill-button' onClick={autofillTeam} disabled={fantasyTeam.players.filter(x => x).length >= 11}>AutoFill</button>
                          <button className='save-team-button' onClick={handleSaveTeam} disabled={!isTeamValid()}>Save Team</button>
                      </Col>
                    </Row>
                </div>
              </div>
            </Card>
          </Col>
          </Row>
          <Row>
            <Col xs={12} md={6}>
              <Card id="pitch-bg" className={showListView ? 'collapse' : ''}>
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
                      {renderRow(gk, 0)}
                    </div>
                  </div>
                  
                  <div className="row-wrapper" style={{ top: rowPositions.df }}>
                    <div className='df-row'>
                      {renderRow(df, 1)}
                    </div>
                  </div>
                  <div className="row-wrapper" style={{ top: rowPositions.mf }}>
                    <div className='mf-row'>
                      {renderRow(mf, 2)}
                    </div>
                  </div>
                  <div className="row-wrapper" style={{ top: rowPositions.fw }}>
                    <div className='fw-row'>
                      {renderRow(fw, 3)}
                    </div>
                  </div>
              </Card>
              
              <Card className={!showListView ? 'collapse' : ''}>
                <Card.Header className="list-view-header-row">
                  <div className="header-col position-col"></div>
                  <div className="header-col captain-col">Captain</div>
                  <div className="header-col player-col">Player Name</div>
                  <div className="header-col team-col">Team</div>
                  <div className="header-col value-col">Value</div>
                  <div className="header-col button-col"></div>
                </Card.Header>

                {renderListRows(gk, 0, 'GK')}

                <div className="list-view-sub-header-row">
                  <div className="header-col position-col"></div>
                  <div className="header-col captain-col">Captain</div>
                  <div className="header-col player-col">Player Name</div>
                  <div className="header-col team-col">Team</div>
                  <div className="header-col value-col">Value</div>
                  <div className="header-col button-col"></div>
                </div>

                {renderListRows(df, 1, 'DF')}

                <div className="list-view-sub-header-row">
                  <div className="header-col position-col"></div>
                  <div className="header-col captain-col">Captain</div>
                  <div className="header-col player-col">Player Name</div>
                  <div className="header-col team-col">Team</div>
                  <div className="header-col value-col">Value</div>
                  <div className="header-col button-col"></div>
                </div>

                {renderListRows(mf, 2, 'MF')}

                <div className="list-view-sub-header-row">
                  <div className="header-col position-col"></div>
                  <div className="header-col captain-col">Captain</div>
                  <div className="header-col player-col">Player Name</div>
                  <div className="header-col team-col">Team</div>
                  <div className="header-col value-col">Value</div>
                  <div className="header-col button-col"></div>
                </div>

                {renderListRows(fw, 3, 'FW')}
              </Card>

              <Card className='mt-3 bonus-panel'>
                <div className={`overlay ${Object.keys(fantasyTeam.players).length === 11 ? 'hidden' : ''}`}>
                  Please select 11 players before choosing a bonus.
                </div>
              <Card.Header className="header-container">
                <span style={{marginLeft: '32px'}}>Bonuses</span>
                <div className="button-container">
                  <button className='card-arrow' onClick={() => scroll('left')}>&lt;</button>
                  <button className='card-arrow' onClick={() => scroll('right')}>&gt;</button>

                </div>
              </Card.Header>
              <div ref={cardContainerRef} className="card-container">
                {bonuses.map((bonus, index) => {
                  const bonusPlayerId = fantasyTeam?.[`${bonus.propertyName}PlayerId`];
                  const bonusTeamId = fantasyTeam?.[`${bonus.propertyName}TeamId`];
                  const bonusGameweek = fantasyTeam?.[`${bonus.propertyName}Gameweek`];
                  const bonusUsed = bonusGameweek !== null && bonusGameweek !== 0 && bonusGameweek !== undefined;

                  let bonusTarget = "Used";
                  if (bonusPlayerId) {
                    bonusTarget = getPlayerById(players, bonusPlayerId).lastName;
                    } else if (bonusTeamId) {
                    bonusTarget = getTeamById(teams, bonusTeamId).friendlyName;
                  }

                  let useButton = (
                    <div className="button-row">
                      <button onClick={() => handleBonus(bonus.id)} className='btn-use-bonus'>Use</button>
                    </div>
                  );

                  if (bonusUsed) {
                    useButton = (
                      <div className="button-row">
                        <div className='txt-used-bonus'>{`${bonusTarget} (GW ${bonusGameweek}`})</div>
                      </div>
                    );
                  }

                  return (
                    <Card className='bonus-card' key={index}>
                      <div className="image-row">
                        <img src={bonus.icon} alt={bonus.icon} className='bonus-image'/>
                      </div>
                      <div className="text-row">
                        <span className='bonus-label'>{bonus.name}</span>
                      </div>
                      {useButton}
                    </Card>
                  );
                })}
              </div>

              </Card>
            </Col>
            <Col xs={12} md={6}>
              <FixturesWidget teams={teams} />
            </Col>
          </Row>
          
        </Container>
        

        {fantasyTeam && fantasyTeam.players && (
          <SelectPlayerModal 
          startingPosition={selectedPosition}
          show={showSelectPlayerModal} 
          handleClose={() => setShowSelectPlayerModal(false)} 
          handleConfirm={handlePlayerConfirm}
          fantasyTeam={fantasyTeam}
          availableFormations={availableFormations}
        />
      )}
      
      {showSelectBonusPlayerModal && <SelectBonusPlayerModal 
        show={showSelectBonusPlayerModal}
        handleClose={() => setShowSelectBonusPlayerModal(false)}
        handleConfirm={handleConfirmPlayerBonus}
        fantasyTeam={fantasyTeam}
        positions={positionsForBonus[selectedBonusId]}
        bonusType={selectedBonusId}
      />}

      {showSelectBonusTeamModal && <SelectBonusTeamModal
        show={showSelectBonusTeamModal}
        handleClose={() => setShowSelectBonusTeamModal(false)}
        handleConfirm={handleConfirmTeamBonus}
        bonusType={selectedBonusId}
      />}

      {showConfirmBonusModal && <ConfirmBonusModal
        show={showConfirmBonusModal}
        handleClose={() => setShowConfirmBonusModal(false)}
        handleConfirm={handleConfirmBonus}
        bonusType={selectedBonusId}
      />}
      </>
      )
  );
};

//Refactor into own view and remove from fixtures widget and fixtures
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
