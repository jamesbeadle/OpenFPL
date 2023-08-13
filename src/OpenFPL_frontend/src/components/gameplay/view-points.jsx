import React, { useState, useEffect } from 'react';
import { Container, Row, Col, Card, Spinner, Button, Image } from 'react-bootstrap';
import { OpenFPL_backend as open_fpl_backend } from '../../../../declarations/OpenFPL_backend';
import { player_canister as player_canister } from '../../../../declarations/player_canister';
import { useParams } from 'react-router-dom';
import PlayerDetailsModal from './player-details-modal';
import LogoImage from "../../../assets/logo.png";
import { useLocation } from 'react-router-dom';
import ProfileImage from '../../../assets/profile_placeholder.png';
import { PlayerIcon, StarIcon, StarOutlineIcon } from '../icons';


const ViewPoints = () => {
    const { manager, gameweek, season } = useParams();
    const location = useLocation();
    const rank = location.state?.rank;
    const [isLoading, setIsLoading] = useState(true);
    const [showModal, setShowModal] = useState(false);
    const [fantasyTeam, setFantasyTeam] = useState({
        players: [],
    });
    const [selectedPlayer, setSelectedPlayer] = useState(null);
    const [selectedPlayerDTO, setSelectedPlayerDTO] = useState(null);
    const [teams, setTeams] = useState([]);
    const [fixtures, setFixtures] = useState([]);
    const [players, setPlayers] = useState([]);
    const positionCodes = ['GK', 'DF', 'MF', 'FW'];
    const [gameweekBonus, setGameweekBonus] = useState(null);
    const [profile, setProfile] = useState(null);
    const [profilePicSrc, setProfilePicSrc] = useState(ProfileImage);
   
    useEffect(() => {
        const fetchData = async () => {
            await fetchViewData();
            setIsLoading(false);
        };
        fetchData();
    }, []);

    const fetchViewData = async () => {
        
        const teamsData = await open_fpl_backend.getTeams();
        setTeams(teamsData);
        
        const fixturesData = await open_fpl_backend.getFixtures();
        setFixtures(fixturesData);
        
        const fetchedFantasyTeam = await open_fpl_backend.getFantasyTeamForGameweek(manager, Number(season), Number(gameweek)); 
        const detailedPlayersRaw = await open_fpl_backend.getPlayersDetailsForGameweek(fetchedFantasyTeam.playerIds, Number(season), Number(gameweek));
        
        const detailedPlayers = detailedPlayersRaw.map(player => extractPlayerData(player));
        const playerData = await player_canister.getAllPlayers();
        setPlayers(playerData);
        setFantasyTeam({
            ...fetchedFantasyTeam,
            players: detailedPlayers,
        });

        const profileData = await open_fpl_backend.getPublicProfileDTO(manager);
        setProfile(profileData);

        
        if (profileData.profilePicture && profileData.profilePicture.length > 0) {
        
            const blob = new Blob([profileData.profilePicture]);
            const blobUrl = URL.createObjectURL(blob);
            setProfilePicSrc(blobUrl);
    
        } else {
            setProfilePicSrc(ProfileImage);
        }

        getBonusDetails();
    };
    
    const getTeamById = (teamId) => {
        const team = teams.find(team => team.id === teamId);
        return team;
    };
    
    const extractPlayerData = (playerDTO) => {
        let goals = 0, assists = 0, redCards = 0, yellowCards = 0, missedPenalties = 0, ownGoals = 0, saves = 0, cleanSheets = 0, penaltySaves = 0, goalsConceded = 0, appearance = 0, highestScoringPlayerId = 0;
        playerDTO.events.forEach(event => {
            switch(event.eventType) {
                case 0:
                    appearance += 1;
                    break;
                case 1:
                    goals += 1;
                    break;
                case 2:
                    assists += 1;
                    break;
                case 3:
                    goalsConceded += 1;
                    break;
                case 4:
                    saves += 1;
                    break;
                case 5:
                    cleanSheets += 1;
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
                highestScoringPlayerId
            }
        };
    };

    const renderPlayer = (playerDTO) => {
        const player = players.find(p => p.id === playerDTO.id);
        const playerScore = calculatePlayerScore(playerDTO, fantasyTeam, fixtures);
        return (
            <tr key={player.id}>
                <td>
                    <PlayerIcon primaryColour={getTeamById(player.teamId).primaryColourHex} secondaryColour={getTeamById(player.teamId).secondaryColourHex} />
                </td>
                <td>{positionCodes[player.position]}</td>
                <td>{player.shirtNumber == 0 ? '-' : player.shirtNumber}</td>
                <td>{player.isCaptain
                        ? <StarIcon 
                            color="#807A00" 
                            width="15" 
                            height="15" 
                        />
                        : <StarOutlineIcon 
                            color="#807A00" 
                            width="15" 
                            height="15" 
                        />}
                        
                        {player.firstName != "" ? player.firstName.charAt(0) + "." : ""} {player.lastName}
                </td>
                <td>{playerScore}</td>
                <td><Button onClick={() => handleShowModal(player, playerDTO)}><label className='small-text' >Details</label></Button></td>
            </tr>
        );
    }

    const calculatePlayerScore = (playerDTO, fantasyTeamDTO, fixtures) => {
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
            score -= pointsForRedCard;
        }

        if (playerDTO.gameweekData.missedPenalties > 0) {
            score -= pointsForPenaltyMiss * playerDTO.gameweekData.missedPenalties;
        }

        if (playerDTO.position === 0 || playerDTO.position === 1) {
        }

        if (playerDTO.gameweekData.ownGoals > 0) {
            score -= pointsForOwnGoal * playerDTO.gameweekData.ownGoals;
        }

        if (playerDTO.gameweekData.yellowCards > 0) {
            score -= pointsForYellowCard * playerDTO.gameweekData.yellowCards;
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
                    score -= Math.floor(playerDTO.gameweekData.goalsConceded / 2) * pointsForEach2Conceded;
                }

                break;
            case 1:
                pointsForGoal = 20;
                pointsForAssist = 15; 

                if (playerDTO.gameweekData.cleanSheets > 0) {
                    score += pointsForCleanSheet;
                }
                if (playerDTO.gameweekData.goalsConceded >= 2) {
                    score -= Math.floor(playerDTO.gameweekData.goalsConceded / 2) * pointsForEach2Conceded;
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


        score += (fantasyTeamDTO.goalGetterGameweek === playerDTO.gameweek && fantasyTeamDTO.goalGetterPlayerId === playerDTO.id) ? 
            (playerDTO.gameweekData.goals * pointsForGoal) * 3 : 
            playerDTO.gameweekData.goals * pointsForGoal;

        score += (fantasyTeamDTO.passMasterGameweek === playerDTO.gameweek && fantasyTeamDTO.passMasterPlayerId === playerDTO.id) ? 
            (playerDTO.gameweekData.assists * pointsForAssist) * 3 : 
            playerDTO.gameweekData.assists * pointsForAssist;


        if (fantasyTeamDTO.noEntryGameweek === playerDTO.gameweek && fantasyTeamDTO.noEntryPlayerId === playerDTO.id && 
            (playerDTO.position === 0 || playerDTO.position === 1) && playerDTO.gameweekData.cleanSheets) {
            score = score * 3; 
        }
    
        if (fantasyTeamDTO.safeHandsGameweek === playerDTO.gameweek && fantasyTeamDTO.safeHandsPlayerId === playerDTO.id && 
            playerDTO.position === 0 && playerDTO.gameweekData.saves >= 5) {
            score = score * 3;
        }
    
        if (fantasyTeamDTO.captainFantasticGameweek === playerDTO.gameweek && fantasyTeamDTO.captainFantasticPlayerId === playerDTO.id && playerDTO.gameweekData.goals > 0) {
            score = score * 2;
        }
    
        if (fantasyTeamDTO.braceBonusGameweek === playerDTO.gameweek && playerDTO.gameweekData.goals >= 2) {
            score = score * 2;
        }
    
        if (fantasyTeamDTO.hatTrickHeroGameweek === playerDTO.gameweek && playerDTO.gameweekData.goals >= 3) {
            score = score * 3;
        }
    
        if (fantasyTeamDTO.teamBoostGameweek === playerDTO.gameweek && playerDTO.teamId === fantasyTeamDTO.teamBoostTeamId) {
            score = score * 2;
        }
    
        const gameweekFixtures = fixtures ? fixtures.filter(fixture => fixture.gameweek === playerDTO.gameweek) : [];
        const playerFixture = gameweekFixtures.find(fixture => 
            (fixture.homeTeamId === playerDTO.teamId || fixture.awayTeamId === playerDTO.teamId) && 
            fixture.highestScoringPlayerId === playerDTO.id
        );
        if (playerFixture) {
            score += pointsForHighestScore;
        }
    
        if (fantasyTeamDTO.captainId === playerDTO.id) {
            score = score * 2;
        }
    
        return score;
    };

    const getBonusDetails = () => {

        let bonusDetails = [];

        if (fantasyTeam.goalGetterGameweek === Number(gameweek)) {
            const player = fantasyTeam.players.find(p => p.id === fantasyTeam.goalGetterPlayerId);
            if (player) {
                bonusDetails.push({
                    name: 'Goal Getter',
                    player: `${player.firstName} ${player.lastName}`
                });
            }
        }
    
        if (fantasyTeam.passMasterGameweek === Number(gameweek)) {
            const player = fantasyTeam.players.find(p => p.id === fantasyTeam.passMasterPlayerId);
            if (player) {
                bonusDetails.push({
                    name: 'Pass Master',
                    player: `${player.firstName} ${player.lastName}`
                });
            }
        }
    
        if (fantasyTeam.noEntryGameweek === Number(gameweek)) {
            const player = fantasyTeam.players.find(p => p.id === fantasyTeam.noEntryPlayerId);
            if (player) {
                bonusDetails.push({
                    name: 'No Entry',
                    player: `${player.firstName} ${player.lastName}`
                });
            }
        }
    
        if (fantasyTeam.teamBoostGameweek === Number(gameweek)) {
            const team = teams.find(t => t.id === fantasyTeam.teamBoostTeamId);
            if (team) {
                bonusDetails.push({
                    name: 'Team Boost',
                    player: `${team.friendlyName}`
                });
            }
        }
    
        if (fantasyTeam.safeHandsGameweek === Number(gameweek)) {
            const player = fantasyTeam.players.find(p => p.id === fantasyTeam.safeHandsPlayerId);
            if (player) {
                bonusDetails.push({
                    name: 'Safe Hands',
                    player: `${player.firstName} ${player.lastName}`
                });
            }
        }
    
        if (fantasyTeam.captainFantasticGameweek === Number(gameweek)) {
            const player = fantasyTeam.players.find(p => p.id === fantasyTeam.captainFantasticPlayerId);
            if (player) {
                bonusDetails.push({
                    name: 'Captain Fantastic',
                    player: `${player.firstName} ${player.lastName}`
                });
            }
        }
    
        if (fantasyTeam.braceBonusGameweek === Number(gameweek)) {
            bonusDetails.push({
                name: 'Pass Master'
            });
        }
    
        if (fantasyTeam.hatTrickHeroGameweek === Number(gameweek)) {
            bonusDetails.push({
                name: 'Hat-trick Hero'
            });
        }

        setGameweekBonus(bonusDetails);
    
        return bonusDetails;
    }
    

    const handleShowModal = (player, playerDTO) => {
        setSelectedPlayer(player);
        setSelectedPlayerDTO(playerDTO);
        setShowModal(true);
    }
    
    const handleCloseModal = () => {
        setSelectedPlayer(null);
        setShowModal(false);
    }
  
    return (
        isLoading ? (
            <div className="customOverlay d-flex flex-column align-items-center justify-content-center">
            <Spinner animation="border" />
            <p className='text-center mt-1'>Loading Points...</p>
            </div>
        ) :
        <Container className="flex-grow-1 my-5">
            <Card>
                <Card.Header className="score-card-header">
                    <img src={LogoImage} alt="openFPL" style={{ maxWidth: '5rem' }} />
                    <div>
                        <span><small>{profile.displayName}</small></span>
                        <Image src={profilePicSrc} roundedCircle className="score-card-profile-pic" />
                    </div>
                </Card.Header>
                <Card.Body>
                    <Row>
                        <Col>
                            <div>Season: {season}</div>
                            <div>Gameweek: {gameweek}</div>
                            <div>Rank: {rank}</div>
                        </Col>
                        <Col className='col-right'>
                            <div className='score-box'>
                                <p className='small-text'>
                                    Points:
                                </p>
                                <h1>{fantasyTeam.points}</h1>
                            </div>
                            
                        </Col>
                    </Row>

                    <table className="player-table">
                        <thead>
                            <tr>
                                <th>Club</th>
                                <th>Position</th>
                                <th>Shirt</th>
                                <th>Name</th>
                                <th>Points</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                            {fantasyTeam && fantasyTeam.players && fantasyTeam.players.map(player => renderPlayer(player))}
                        </tbody>
                    </table>

                    <div>
                        <div>{gameweekBonus.name}</div>
                        <div>{gameweekBonus.player}</div>
                    </div>
                </Card.Body>
            </Card>
   
            {selectedPlayer && selectedPlayerDTO && <PlayerDetailsModal show={showModal} onClose={handleCloseModal} player={selectedPlayer} playerDTO={selectedPlayerDTO} />}
    
        </Container>
        );
};


export default ViewPoints;
