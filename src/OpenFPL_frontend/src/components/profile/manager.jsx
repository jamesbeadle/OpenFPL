import React, { useState, useContext, useEffect, useRef } from 'react';
import { Image, Container, Row, Col, Button, Spinner, Dropdown, Card } from 'react-bootstrap';
import { OpenFPL_backend as open_fpl_backend } from '../../../../declarations/OpenFPL_backend';
import { player_canister as player_canister } from '../../../../declarations/player_canister';
import { DataContext } from "../../contexts/DataContext";
import ProfileImage from '../../../assets/profile_placeholder.png';
import { useParams } from 'react-router-dom';
import { ArrowLeft, ArrowRight, BadgeIcon } from '../icons';
import { getTeamById } from '../helpers';
import ManagerGameweekPoints from './manager-gameweek-points';

const Manager = () => {
    const { managerId } = useParams();
    const { teams, seasons, systemState, playerEvents, fixtures, players } = useContext(DataContext);
    const [isLoading, setIsLoading] = useState(true);
    const [viewData, setViewData] = useState(null);
    const [profilePicSrc, setProfilePicSrc] = useState(ProfileImage);
    const [joinedDate, setJoinedDate] = useState('');
    const [favouriteTeam, setFavouriteTeam] = useState(null);
  
    const [currentGameweek, setCurrentGameweek] = useState(systemState.activeGameweek);
    const [currentSeason, setCurrentSeason] = useState(systemState.activeSeason);
    const gameweekDropdownRef = useRef(null);
    const seasonDropdownRef = useRef(null);
    const [showGameweekDropdown, setShowGameweekDropdown] = useState(false);
    const [showSeasonDropdown, setShowSeasonDropdown] = useState(false);
    const [fantasyTeam, setFantasyTeam] = useState({
      players: [],
    });
    const [sortedPlayers, setSortedPlayers] = useState([]);
    const positionCodes = ['GK', 'DF', 'MF', 'FW'];
    const [selectedPlayer, setSelectedPlayer] = useState(null);
    const [selectedPlayerDTO, setSelectedPlayerDTO] = useState(null);
    const [selectedPlayerCaptain, setSelectedPlayerCaptain] = useState(false);
    const [showModal, setShowModal] = useState(false);
    const [showListView, setShowListView] = useState(true);
    
    const handleGameweekBlur = (e) => {
      const currentTarget = e.currentTarget;
      if (!currentTarget.contains(document.activeElement)) {
        setShowGameweekDropdown(false);
      }
    };
    
    const handleSeasonBlur = (e) => {
      const currentTarget = e.currentTarget;
      setTimeout(() => {
        if (!currentTarget.contains(document.activeElement)) {
          setShowSeasonDropdown(false);
        }
      }, 0);
    };

    useEffect(() => {
    const fetchData = async () => {
          await fetchViewData();
          setIsLoading(false);
        };
        fetchData();
    }, [currentGameweek]);

    const fetchViewData = async () => {
        try {
            const data = await open_fpl_backend.getManager(managerId, currentSeason.id, currentGameweek);
            setViewData(data);
            console.log(data);
            loadFantasyTeam(data);
            setProfileData(data);
        } catch (error){
            console.log(error);
        };
    };

    const loadFantasyTeam = async (data) => {
      const activeGameweek = data.gameweeks.find(x => x.gameweek == currentGameweek);
      if(!activeGameweek){
        setFantasyTeam({
          ...activeGameweek,
          players: [],
        });
        return;
      }
      if(currentGameweek == systemState.focusGameweek && currentSeason.id == systemState.activeSeason.id){
        const detailedPlayers = playerEvents.map(player => extractPlayerData(player));
        const playersInTeam = detailedPlayers.filter(player => activeGameweek.playerIds.includes(player.id));
    
        setFantasyTeam({
            ...activeGameweek,
            players: playersInTeam,
        });
      }
      else
      {
        console.log("HERE")
          const detailedPlayersRaw = await player_canister.getPlayersDetailsForGameweek(activeGameweek.playerIds, currentSeason.id, currentGameweek);    
          const detailedPlayers = detailedPlayersRaw.map(player => extractPlayerData(player));
          setFantasyTeam({
              ...activeGameweek,
              players: detailedPlayers,
          });
      }
    };

    const setProfileData = async (data) => {

      const dateInMilliseconds = Number(data.createDate / 1000000n);
      const date = new Date(dateInMilliseconds);
      const monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
      const joinDate = `${monthNames[date.getUTCMonth()]} ${date.getUTCFullYear()}`;
      setJoinedDate(joinDate);

      if (data.profilePicture && data.profilePicture.length > 0) {
      
      const blob = new Blob([data.profilePicture]);
      const blobUrl = URL.createObjectURL(blob);
        setProfilePicSrc(blobUrl);
      } else {
        setProfilePicSrc(ProfileImage);
      }
      setFavouriteTeam(data.favouriteTeamId);
    };

    
    useEffect(() => {
      console.log("fantasyTeam.players")
      console.log(fantasyTeam.players)
      if (fantasyTeam && fantasyTeam.players) {
        
          const playersWithUpdatedScores = fantasyTeam.players.map(player => {
              const score = calculatePlayerScore(player, fixtures);
              const bonusPoints = calculateBonusPoints(player, fantasyTeam, score);
              const captainPoints = player.id == fantasyTeam.captainId ? (score + bonusPoints) : 0;
              
              return {
                  ...player,
                  points: score,
                  bonusPoints: bonusPoints,
                  totalPoints: score + bonusPoints + captainPoints
              };
          });
  
          const sortedPlayers = [...playersWithUpdatedScores].sort((a, b) => 
              Number(b.totalPoints) - Number(a.totalPoints)
          );
          
          setSortedPlayers(sortedPlayers);
      }
    }, [fantasyTeam]);
    
    const handleGameweekChange = (change) => {
      console.log(change)
      setCurrentGameweek(prev => Math.min(38, Math.max(1, prev + change)));
    };
    
    const handleSeasonChange = async (change) => {
      const newIndex = seasons.findIndex(season => season.id === currentSeason.id) + change;
      if (newIndex >= 0 && newIndex < seasons.length) {
        setCurrentSeason(seasons[newIndex]);
        setCurrentGameweek(1);
      }
    };

    const openGameweekDropdown = () => {
      setShowGameweekDropdown(!showGameweekDropdown);
      setTimeout(() => {
        if (gameweekDropdownRef.current) {
          const item = gameweekDropdownRef.current.querySelector(`[data-key="${currentGameweek - 1}"]`);
          if (item) {
            item.scrollIntoView({ block: 'nearest', inline: 'nearest' });
          }
        }
      }, 0);
    };
  
    const openSeasonDropdown = () => {
      setShowSeasonDropdown(!showSeasonDropdown);
      setTimeout(() => {
        if (seasonDropdownRef.current) {
          const item = seasonDropdownRef.current.querySelector(`[data-key="${currentSeason.id}"]`);
          if (item) {
            item.scrollIntoView({ block: 'nearest', inline: 'nearest' });
          }
        }
      }, 0);
    };

    const extractPlayerData = (playerDTO) => {
        let goals = 0, assists = 0, redCards = 0, yellowCards = 0, missedPenalties = 0, ownGoals = 0, saves = 0, cleanSheets = 0, penaltySaves = 0, goalsConceded = 0, appearance = 0, highestScoringPlayerId = 0;
        let goalPoints = 0, assistPoints = 0, goalsConcededPoints = 0, cleanSheetPoints = 0;

        playerDTO.events.forEach(event => {
            switch(event.eventType) {
                case 0:
                    appearance += 1;
                    break;
                case 1:
                    goals += 1;
                    switch(playerDTO.position){
                        case 0:
                        case 1:
                            goalPoints += 20;
                            break;
                        case 2:
                            goalPoints += 15;
                            break;
                        case 3:
                            goalPoints += 10;
                            break;
                    }
                    break;
                case 2:
                    assists += 1;
                    switch(playerDTO.position){
                        case 0:
                        case 1:
                            assistPoints += 15;
                            break;
                        case 2:
                            case 3:
                            assistPoints += 10;
                            break;
                    };
                    break;
                case 3:
                    goalsConceded += 1;
                    if(playerDTO.position < 2 && goalsConceded % 2 == 0){
                        goalsConcededPoints += -15;
                    };
                    break;
                case 4:
                    saves += 1;
                    break;
                case 5:
                    cleanSheets += 1;
                    if(playerDTO.position < 2 && goalsConceded == 0){
                        cleanSheetPoints += 10;
                    };
                    break;
                case 6:
                    penaltySaves += 1;
                    break;
                case 7:
                    missedPenalties += 1;
                    break;
                case 8:
                    yellowCards += 1;
                    break;
                case 9:
                    redCards += 1;
                    break;
                case 10:
                    ownGoals += 1;
                    break;
                case 11:
                    highestScoringPlayerId += 1;
                    break;
            }
        });
    
        return {
            ...playerDTO,
            gameweekData: {
                appearance,
                goals,
                assists,
                goalsConceded,
                saves,
                cleanSheets,
                penaltySaves,
                missedPenalties,
                yellowCards,
                redCards,
                ownGoals,
                highestScoringPlayerId,
                goalPoints,
                assistPoints,
                goalsConcededPoints,
                cleanSheetPoints
            }
        };
    };

    const calculatePlayerScore = (playerDTO, fixtures) => {
      if (!playerDTO) {
          console.error("No gameweekData found for player:", playerDTO);
          return 0;
      }
      
      let score = 0; 

      let pointsForAppearance = 5;
      let pointsFor3Saves = 5;
      let pointsForPenaltySave = 20;
      let pointsForHighestScore = 25;
      let pointsForRedCard = -20;
      let pointsForPenaltyMiss = -10;
      let pointsForEach2Conceded = -15;
      let pointsForOwnGoal = -10;
      let pointsForYellowCard = -5;
      let pointsForCleanSheet = 10;

      var pointsForGoal = 0;
      var pointsForAssist = 0;

      if(playerDTO.gameweekData.appearance > 0){
          score += pointsForAppearance * playerDTO.gameweekData.appearance;
      }

      if (playerDTO.gameweekData.redCards > 0) {
          score += pointsForRedCard;
      }

      if (playerDTO.gameweekData.missedPenalties > 0) {
          score += pointsForPenaltyMiss * playerDTO.gameweekData.missedPenalties;
      }

      if (playerDTO.gameweekData.ownGoals > 0) {
          score += pointsForOwnGoal * playerDTO.gameweekData.ownGoals;
      }

      if (playerDTO.gameweekData.yellowCards > 0) {
          score += pointsForYellowCard * playerDTO.gameweekData.yellowCards;
      }
  
      switch(playerDTO.position){
          case 0:
              pointsForGoal = 20;
              pointsForAssist = 15;     
              
              if (playerDTO.gameweekData.saves >= 3) {
                  score += Math.floor(playerDTO.gameweekData.saves / 3) * pointsFor3Saves;
              }
              if (playerDTO.gameweekData.penaltySaves) {
                  score += pointsForPenaltySave * playerDTO.gameweekData.penaltySaves;
              }

              if (playerDTO.gameweekData.cleanSheets > 0) {
                  score += pointsForCleanSheet;
              }
              if (playerDTO.gameweekData.goalsConceded >= 2) {
                  score += Math.floor(playerDTO.gameweekData.goalsConceded / 2) * pointsForEach2Conceded;
              }

              break;
          case 1:
              pointsForGoal = 20;
              pointsForAssist = 15; 

              if (playerDTO.gameweekData.cleanSheets > 0) {
                  score += pointsForCleanSheet;
              }
              if (playerDTO.gameweekData.goalsConceded >= 2) {
                  score += Math.floor(playerDTO.gameweekData.goalsConceded / 2) * pointsForEach2Conceded;
              }

              break;
          case 2:
              pointsForGoal = 15;
              pointsForAssist = 10; 
              break;
          case 3:
              pointsForGoal = 10;
              pointsForAssist = 10; 
              break;
      };
  
      const gameweekFixtures = fixtures ? fixtures.filter(fixture => fixture.gameweek === playerDTO.gameweek) : [];
      const playerFixture = gameweekFixtures.find(fixture => 
          (fixture.homeTeamId === playerDTO.teamId || fixture.awayTeamId === playerDTO.teamId) && 
          fixture.highestScoringPlayerId === playerDTO.id
      );
      if (playerFixture) {
          score += pointsForHighestScore;
      }

      
      score += playerDTO.gameweekData.goals * pointsForGoal;

      score += playerDTO.gameweekData.assists * pointsForAssist;

      return score;
    };

    const calculateBonusPoints = (playerDTO, fantasyTeamDTO, points) => {
        if (!playerDTO) {
            console.error("No gameweekData found for player:", playerDTO);
            return 0;
        }
        
        let bonusPoints = 0; 
        var pointsForGoal = 0;
        var pointsForAssist = 0;
        switch(playerDTO.position){
            case 0:
                pointsForGoal = 20;
                pointsForAssist = 15;  
                break;
            case 1:
                pointsForGoal = 20;
                pointsForAssist = 15; 
                break;
            case 2:
                pointsForGoal = 15;
                pointsForAssist = 10; 
                break;
            case 3:
                pointsForGoal = 10;
                pointsForAssist = 10; 
                break;
        };
  
        if(fantasyTeamDTO.goalGetterGameweek === playerDTO.gameweek && fantasyTeamDTO.goalGetterPlayerId === playerDTO.id){
            bonusPoints = playerDTO.gameweekData.goals * pointsForGoal * 2;
        }
  
        if(fantasyTeamDTO.passMasterGameweek === playerDTO.gameweek && fantasyTeamDTO.passMasterPlayerId === playerDTO.id){
            bonusPoints = playerDTO.gameweekData.assists * pointsForAssist * 2;
        }
        
        if (fantasyTeamDTO.noEntryGameweek === playerDTO.gameweek && fantasyTeamDTO.noEntryPlayerId === playerDTO.id && 
            (playerDTO.position === 0 || playerDTO.position === 1) && playerDTO.gameweekData.cleanSheets) {
            bonusPoints = points * 2; 
        }
    
        if (fantasyTeamDTO.safeHandsGameweek === playerDTO.gameweek && playerDTO.position === 0 && playerDTO.gameweekData.saves >= 5) {
            bonusPoints = points * 2; 
        }
    
        if (fantasyTeamDTO.captainFantasticGameweek === playerDTO.gameweek && fantasyTeamDTO.captainId === playerDTO.id && playerDTO.gameweekData.goals > 0) {
            bonusPoints = points; 
        }
    
        if (fantasyTeamDTO.braceBonusGameweek === playerDTO.gameweek && playerDTO.gameweekData.goals >= 2) {
            bonusPoints = points; 
        }
    
        if (fantasyTeamDTO.hatTrickHeroGameweek === playerDTO.gameweek && playerDTO.gameweekData.goals >= 3) {
            bonusPoints = points * 2; 
        }
    
        if (fantasyTeamDTO.teamBoostGameweek === playerDTO.gameweek && playerDTO.teamId === fantasyTeamDTO.teamBoostTeamId) {
            bonusPoints = points;
        }
    
        return bonusPoints;
    };

    const loadToGameweek = async (number) => {
      setShowListView(false);
      setCurrentGameweek(number);
    };

    return (
        isLoading ? (
            <div className="customOverlay d-flex flex-column align-items-center justify-content-center">
            <Spinner animation="border" />
            <p className='text-center mt-1'>Loading Manager</p>
            </div>
        ) : (
        <Container fluid className='view-container mt-2'>
          <Row>
            <Col md={7} xs={12}>
                <Card className='mb-3'>
                    <div className="outer-container d-flex">
                      
                    <div className='manager-details-row w-100' style={{ display: 'flex', justifyContent: 'left', alignItems: 'left' }}>
                                <div className='manager-picture-col'>
                                  <div className="position-relative d-inline-block">
                                    <Image src={profilePicSrc} className="w-100 manager-profile-image" />
                                    </div>
                                </div>
                                <div className='manager-details-col'>
                                  <div className='manager-detail-row-1'>
                                    <Row className="stat-row-1">
                                      <div className='manager-display-name-col'>
                                        <p className="stat-header w-100">Manager</p>
                                      </div>
                                      <div className='manager-favourite-team-col'>
                                        <p className="stat-header w-100">Favourite Team</p>
                                      </div>
                                      <div className='manager-joined-col'>
                                        <p className="stat-header w-100">Joined</p>
                                      </div>
                                    </Row>
                                    <Row className="stat-row-2">
                                    <div className='manager-display-name-col'>
                                        <p className="stat">{viewData.displayName == viewData.principalId ? '-' : viewData.displayName}</p>
                                      </div>
                                      <div className='manager-favourite-team-col'>
                                        <p className="stat">{viewData.favouriteTeamId == 0 ? '-' : getTeamById(teams, viewData.favouriteTeamId).friendlyName}</p>
                                      </div>
                                      <div className='manager-joined-col'>
                                        <p className="stat">{joinedDate}</p>
                                      </div>
                                    </Row>
                                  </div>
                                </div>
                              </div>
                          </div>
                </Card>
            </Col>

            <Col md={5} xs={12}>
              <Card className='mb-3'>
                <div className="outer-container d-flex">
                  <div className="stat-panel flex-grow-1">
                      <Row className="stat-row-1">
                          <div className='leaderboard-pos-col'>
                              <p className="stat-header w-100" style={{paddingLeft: '32px'}}>Leaderboard Positions</p>    
                          </div>
                          <div className='leaderboard-pos-col'>
                                
                          </div>
                          <div className='leaderboard-pos-col'>
                                
                          </div>
                      </Row>
                      <Row className="stat-row-2">
                          <div className='leaderboard-pos-col'>
                            TEAM NAME
                          </div>
                          <div className='leaderboard-pos-col'>
                            favourite team id
                          </div>
                          <div className='leaderboard-pos-col'>
                          </div>
                      </Row>
                      <Row className="stat-row-3">
                          <div className='leaderboard-pos-col'>
                          </div>
                          <div className='leaderboard-pos-col'>
                              <p className="stat-header">Gameweek {systemState.activeGameweek}</p>    
                          </div>
                          <div className='leaderboard-pos-col'>
                              <p className="stat-header">{currentSeason.name}</p>    
                          </div>
                      </Row>
                  </div>
                  <div className="d-none d-md-block club-divider-1"></div>
                  <div className="d-none d-md-block club-divider-2"></div>
                  <div className="d-none d-md-block club-divider-3"></div>
                </div>
              </Card>
            </Col>
          </Row>
          
          <Card>
            <Row>
              <Col md={12}>
                <div className='filter-row mb-2 mt-2' style={{ display: 'flex', justifyContent: 'left', alignItems: 'left' }}>
                  <div style={{ display: 'flex', alignItems: 'center' }}>
                    <Button 
                      onClick={() => setShowListView(true)} 
                      className={`sub-stat-button sub-stat-button-left ${showListView ? 'active' : ''}`}
                    >
                      Gameweeks
                    </Button>
                    <Button 
                        onClick={() => setShowListView(false)} 
                        className={`sub-stat-button sub-stat-button-right ${!showListView ? 'active' : ''}`}
                        style={{ marginRight: '40px' }}
                      >
                      Details
                    </Button>                                      
                  </div>
                  {!showListView && <>
                    <div style={{ display: 'flex', alignItems: 'center' }}>
                      <Button className="w-100 justify-content-center fpl-btn" onClick={() => handleGameweekChange(-1)} disabled={currentGameweek === 1}
                        style={{ marginRight: '16px' }} >
                        <ArrowLeft />
                      </Button>
                    </div>
                    <div style={{ display: 'flex', alignItems: 'center' }}>
                      <div ref={gameweekDropdownRef} onBlur={handleGameweekBlur}>
                        <Dropdown show={showGameweekDropdown}>
                          <Dropdown.Toggle as={CustomToggle} id="gameweek-selector">
                            <Button className='filter-dropdown-btn' style={{ backgroundColor: 'transparent' }} onClick={() => openGameweekDropdown()}>Gameweek {currentGameweek}</Button>
                          </Dropdown.Toggle>
                          <Dropdown.Menu style={{ maxHeight: '200px', overflowY: 'auto' }}>
                            {Array.from({ length: 38 }, (_, index) => (
                              <Dropdown.Item
                                data-key={index}
                                className='dropdown-item'
                                key={index}
                                onMouseDown={() => {setCurrentGameweek(index + 1)}}
                              >
                                Gameweek {index + 1} {currentGameweek === (index + 1) ? ' ✔️' : ''}
                              </Dropdown.Item>
                            ))}
                          </Dropdown.Menu>
                        </Dropdown>
                      </div>
                    </div>
                    <div style={{display: 'flex', alignItems: 'center', marginRight: 50}}>
                      <Button className="w-100 justify-content-center fpl-btn" onClick={() => handleGameweekChange(1)} disabled={currentGameweek === 38}
                        style={{ marginLeft: '16px' }} >
                        <ArrowRight />
                      </Button>
                    </div>
                    <div style={{ display: 'flex', alignItems: 'center' }}>
                      <Button className="w-100 justify-content-center fpl-btn"  onClick={() => handleSeasonChange(-1)} disabled={currentSeason.id === seasons[0].id} 
                        style={{ marginRight: '16px' }} >
                        <ArrowLeft />
                      </Button>
                    </div>
                    <div style={{ display: 'flex', alignItems: 'center' }}>
                      <div ref={seasonDropdownRef} onBlur={handleSeasonBlur}>
                        <Dropdown show={showSeasonDropdown}>
                          <Dropdown.Toggle as={CustomToggle} id="season-selector">
                            <Button className='filter-dropdown-btn' style={{ backgroundColor: 'transparent' }} onClick={() => openSeasonDropdown()}>{currentSeason.name}</Button>
                          </Dropdown.Toggle>
                          <Dropdown.Menu style={{ maxHeight: '200px', overflowY: 'auto' }}>
                            
                            {seasons.map(season => 
                              <Dropdown.Item
                                data-key={season.id}
                                className='dropdown-item'
                                key={season.id}
                                onMouseDown={() => setCurrentSeason(season)}
                              >
                                {season.name} {currentSeason.id === season.id ? ' ✔️' : ''}
                              </Dropdown.Item>
                            )}
                          </Dropdown.Menu>
                        </Dropdown>
                      </div>
                    </div>
                    <div style={{ display: 'flex', alignItems: 'center', marginRight: 50 }}>
                      <Button className="w-100 justify-content-center fpl-btn"  onClick={() => handleSeasonChange(1)} disabled={currentSeason.id === seasons[seasons.length - 1].id} 
                        style={{ marginLeft: '16px' }} >
                        <ArrowRight />
                      </Button>
                    </div>
                    <div style={{ display: 'flex', alignItems: 'center', marginLeft: 'auto', marginRight: '90px' }}>
                      <label className='gameweek-total-points'>Total Points: {fantasyTeam.points}</label>
                    </div>
                  </>}
                </div>
              </Col>
            </Row>
            
            {!showListView && 
              <Container fluid>
                <Row style={{ overflowX: 'auto' }}>
                    <Col xs={12}>
                        <div className='light-background table-header-row w-100'  style={{ display: 'flex', alignItems: 'center' }}>
                            <div className="gw-points-position-col gw-table-header">Pos</div>
                            <div className="gw-points-name-col gw-table-header">Player Name</div>
                            <div className="gw-points-club-col gw-table-header">Club</div>
                            <div className="gw-points-appearances-col gw-table-header">A</div>
                            <div className="gw-points-highest-scoring-col gw-table-header">HSP</div>
                            <div className="gw-points-goals-col gw-table-header">GS</div>
                            <div className="gw-points-assists-col gw-table-header">GA</div>
                            <div className="gw-points-pen-saves-col gw-table-header">PS</div>
                            <div className="gw-points-clean-sheets-col gw-table-header">CS</div>
                            <div className="gw-points-saves-col gw-table-header">KS</div>
                            <div className="gw-points-yellow-cards-col gw-table-header">YC</div>
                            <div className="gw-points-own-goals-col gw-table-header">OG</div>
                            <div className="gw-points-goals-conceded-col gw-table-header">GC</div>
                            <div className="gw-points-missed-pen-col gw-table-header">MP</div>
                            <div className="gw-points-red-card-col gw-table-header">RC</div>
                            <div className="gw-points-red-card-col gw-table-header">B</div>
                            <div className="gw-points-red-card-col gw-table-header">PTS</div>
                        </div>
                    </Col>  
                </Row>
                {sortedPlayers.map(playerDTO => {
                  const player = players.find(p => p.id === playerDTO.id);
                  const playerTeam = getTeamById(teams, player.teamId);
                  if (!playerTeam) {
                      console.error("One of the teams is missing for player: ", player);
                      return null;
                  }
                  return (
                    <Row key={player.id} onClick={() => handleShowModal(player, playerDTO, player.id == fantasyTeam.captainId)} style={{ overflowX: 'auto' }}>
                        <Col xs={12}>
                          <div className="table-row clickable-table-row">
                            <div className="gw-points-position-col gw-table-col">{positionCodes[player.position]}</div>
                            <div className="gw-points-name-col gw-table-col">{(player.firstName != "" ? player.firstName.charAt(0) + "." : "") + player.lastName}</div>
                            <div className="gw-points-club-col gw-table-col">
                            <BadgeIcon
                                primary={playerTeam.primaryColourHex}
                                secondary={playerTeam.secondaryColourHex}
                                third={playerTeam.thirdColourHex}
                                width={48}
                                height={48}
                                marginRight={16}
                              />
                              {playerTeam.friendlyName}
                            </div>
                            <div className={`gw-points-appearances-col gw-table-col ${playerDTO.gameweekData.appearance === 0 ? 'zero-text' : ''}`}>
                              {playerDTO.gameweekData.appearance}
                            </div>
                            <div className={`gw-points-highest-scoring-col gw-table-col ${playerDTO.gameweekData.highestScoringPlayerId === 0 ? 'zero-text' : ''}`}>
                              {playerDTO.gameweekData.highestScoringPlayerId}
                            </div>
                            <div className={`gw-points-goals-col gw-table-col ${playerDTO.gameweekData.goals === 0 ? 'zero-text' : ''}`}>
                              {playerDTO.gameweekData.goals}
                            </div>
                            <div className={`gw-points-assists-col gw-table-col ${playerDTO.gameweekData.assists === 0 ? 'zero-text' : ''}`}>
                              {playerDTO.gameweekData.assists}
                            </div>
                            <div className={`gw-points-pen-saves-col gw-table-col ${playerDTO.gameweekData.penaltySaves === 0 ? 'zero-text' : ''}`}>
                              {playerDTO.gameweekData.penaltySaves}
                            </div>
                            <div className={`gw-points-clean-sheets-col gw-table-col ${playerDTO.gameweekData.cleanSheets === 0 ? 'zero-text' : ''}`}>
                              {playerDTO.gameweekData.cleanSheets}
                            </div>
                            <div className={`gw-points-saves-col gw-table-col ${playerDTO.gameweekData.saves === 0 ? 'zero-text' : ''}`}>
                              {playerDTO.gameweekData.saves}
                            </div>
                            <div className={`gw-points-yellow-cards-col gw-table-col ${playerDTO.gameweekData.yellowCards === 0 ? 'zero-text' : ''}`}>
                              {playerDTO.gameweekData.yellowCards}
                            </div>
                            <div className={`gw-points-own-goals-col gw-table-col ${playerDTO.gameweekData.ownGoals === 0 ? 'zero-text' : ''}`}>
                              {playerDTO.gameweekData.ownGoals}
                            </div>
                            <div className={`gw-points-goals-conceded-col gw-table-col ${playerDTO.gameweekData.goalsConceded === 0 ? 'zero-text' : ''}`}>
                              {playerDTO.gameweekData.goalsConceded}  
                            </div>
                            <div className={`gw-points-missed-pen-col gw-table-col ${playerDTO.gameweekData.missedPenalties === 0 ? 'zero-text' : ''}`}>
                              {playerDTO.gameweekData.missedPenalties}
                            </div>
                            <div className={`gw-points-red-card-col gw-table-col ${playerDTO.gameweekData.redCards === 0 ? 'zero-text' : ''}`}>
                              {playerDTO.gameweekData.redCards}
                            </div>
                            <div className={`gw-points-bonus-col gw-table-col ${(
                                (fantasyTeam.goalGetterGameweek === currentGameweek && fantasyTeam.goalGetterPlayerId === player.id) || 
                                (fantasyTeam.passMasterGameweek == currentGameweek && fantasyTeam.passMasterPlayerId == player.id) ||
                                (fantasyTeam.noEntryGameweek == currentGameweek && fantasyTeam.noEntryPlayerId == player.id) || 
                                (fantasyTeam.safeHandsGameweek == currentGameweek && player.position === 0 && playerDTO.gameweekData.saves >= 5) ||
                                (fantasyTeam.captainFantasticGameweek == currentGameweek && fantasyTeam.captainId == player.id && playerDTO.gameweekData.goals > 0) ||
                                (fantasyTeam.braceBonusGameweek == currentGameweek && playerDTO.gameweekData.goals >= 2) ||
                                (fantasyTeam.hatTrickHeroGameweek == currentGameweek && playerDTO.gameweekData.goals >= 3) ||
                                (fantasyTeam.teamBoostGameweek == currentGameweek && fantasyTeam.teamBoostTeamId == player.teamId)) ? '' : 'zero-text'}`}>
                              {[
                                (fantasyTeam.goalGetterGameweek === currentGameweek && fantasyTeam.goalGetterPlayerId === player.id && <img src={GoalGetter} alt='goal-getter' className='gw-bonus-image'/>),
                                (fantasyTeam.passMasterGameweek == currentGameweek && fantasyTeam.passMasterPlayerId == player.id && <img src={PassMaster} alt='pass-master' className='gw-bonus-image'/>),
                                (fantasyTeam.noEntryGameweek == currentGameweek && fantasyTeam.noEntryPlayerId == player.id && <img src={NoEntry} alt='no-entry' className='gw-bonus-image'/>),
                                (fantasyTeam.safeHandsGameweek == currentGameweek && player.position === 0 && playerDTO.gameweekData.saves >= 5 && <img src={SafeHands} alt='safe-hands' className='gw-bonus-image'/>),
                                (fantasyTeam.captainFantasticGameweek == currentGameweek && fantasyTeam.captainId == player.id && playerDTO.gameweekData.goals > 0 && <img src={CaptainFantastic} alt='captain-fantastic' className='gw-bonus-image'/>),
                                (fantasyTeam.braceBonusGameweek == currentGameweek && playerDTO.gameweekData.goals >= 2 && <img src={BraceBonus} alt='brace-bonus' className='gw-bonus-image'/>),
                                (fantasyTeam.hatTrickHeroGameweek == currentGameweek && playerDTO.gameweekData.goals >= 3 && <img src={HatTrickHero} alt='hat-trick-hero' className='gw-bonus-image'/>),
                                (fantasyTeam.teamBoostGameweek == currentGameweek && fantasyTeam.teamBoostTeamId == player.teamId && <img src={TeamBoost} alt='team-boost' className='gw-bonus-image'/>)
                                ].some(Boolean) || '-'}
                            </div>
                            <div className="gw-points-points-col gw-table-col">{playerDTO.totalPoints}</div>
                          </div>
                        </Col>
                    </Row>
                    );
                })}
                {sortedPlayers.length == 0 && <p className='px-4 mt-4 mb-4'>No team found for gameweek.</p> }
              </Container>
            }

            {showListView && 
            
              <Container fluid>
                <ManagerGameweekPoints setCurrentGameweek={loadToGameweek} gameweeks={viewData.gameweeks} />
              </Container>
            }

          </Card>
          {selectedPlayer && selectedPlayerDTO && <PlayerPointsModal show={showModal} onClose={handleCloseModal} player={selectedPlayer} playerDTO={selectedPlayerDTO} gameweek={currentGameweek} isCaptain={selectedPlayerCaptain} bonusId={getBonusId()} team={getTeamById(teams, selectedPlayer.teamId)} season={currentSeason} />}
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

export default Manager;
