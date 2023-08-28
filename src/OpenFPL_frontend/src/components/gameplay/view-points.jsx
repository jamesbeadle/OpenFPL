import React, { useState, useEffect } from 'react';
import { Container, Row, Col, Card, Spinner, Button, Image, Table } from 'react-bootstrap';
import { OpenFPL_backend as open_fpl_backend } from '../../../../declarations/OpenFPL_backend';
import { player_canister as player_canister } from '../../../../declarations/player_canister';
import { useParams } from 'react-router-dom';
import PlayerDetailsModal from './player-details-modal';
import LogoImage from "../../../assets/logo.png";
import ProfileImage from '../../../assets/profile_placeholder.png';
import { PlayerIcon, StarIcon, StarOutlineIcon } from '../icons';


const ViewPoints = () => {
    const { manager, gameweek, season } = useParams();
    const [isLoading, setIsLoading] = useState(true);
    const [showModal, setShowModal] = useState(false);
    const [fantasyTeam, setFantasyTeam] = useState({
        players: [],
    });
    const [selectedPlayer, setSelectedPlayer] = useState(null);
    const [selectedPlayerDTO, setSelectedPlayerDTO] = useState(null);
    const [selectedPlayerCaptain, setSelectedPlayerCaptain] = useState(false);
    const [selectedPlayerBonusName, setSelectedPlayerBonusName] = useState('');
    const [selectedPlayerBonusPoints, setSelectedPlayerBonusPoints] = useState(0);
    
    const [teams, setTeams] = useState([]);
    const [fixtures, setFixtures] = useState([]);
    const [players, setPlayers] = useState([]);
    const positionCodes = ['GK', 'DF', 'MF', 'FW'];
    const [gameweekBonus, setGameweekBonus] = useState({name: 'No Bonus Played', player: '', team: ''});
    const [profile, setProfile] = useState(null);
    const [profilePicSrc, setProfilePicSrc] = useState(ProfileImage);
    const [sortedPlayers, setSortedPlayers] = useState([]);

   
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
    };
    useEffect(() => {
        if (fantasyTeam && fantasyTeam.players) {
            const playersWithUpdatedScores = fantasyTeam.players.map(player => {
                const score = calculatePlayerScore(player, fantasyTeam, fixtures);
                return {
                    ...player,
                    points: score
                };
            });
    
            const sortedPlayers = [...playersWithUpdatedScores].sort((a, b) => 
                Number(b.points) - Number(a.points)
            );
            
            setSortedPlayers(sortedPlayers);
            getBonusDetails();
        }
    }, [fantasyTeam]);
    
    
    
    const getTeamById = (teamId) => {
        const team = teams.find(team => team.id === teamId);
        return team;
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
    
    const calculateGoalPoints = (position, goalsScored) => {
        switch (position) {
            case 0: { return 40 * goalsScored; };
            case 1: { return 40 * goalsScored; };
            case 2: { return 30 * goalsScored; };
            case 3: { return 20 * goalsScored; };
            default: { return 0; };
        };
    };
    
    const calculateAssistPoints = (position, goalsAssisted) => {
        switch (position) {
            case 0: { return 30 * goalsAssisted; };
            case 1: { return 30 * goalsAssisted; };
            case 2: { return 20 * goalsAssisted; };
            case 3: { return 20 * goalsAssisted; };
            default: { return 0; };
        };
    };

    const renderPlayer = (playerDTO, isCaptain, fantasyTeam) => {
        const player = players.find(p => p.id === playerDTO.id);

        var bonusName = "";
        var bonusPoints = 0;
        var totalScore = playerDTO.points;

        if(fantasyTeam.goalGetterGameweek == gameweek && fantasyTeam.goalGetterPlayerId == player.id) {
            bonusName = "Goal Getter";
            bonusPoints = calculateGoalPoints(player.position, playerDTO.gameweekData.goals);
        };

        if(fantasyTeam.passMasterGameweek == gameweek && fantasyTeam.passMasterPlayerId == player.id) {
            bonusName = "Pass Master";
            bonusPoints = calculateAssistPoints(player.position, playerDTO.gameweekData.assists);
        };

        if(fantasyTeam.noEntryGameweek == gameweek && (player.position < 2) && player.goalsConceded == 0) {
            bonusName = "No Entry";
            bonusPoints = totalScore * 2;
        };

        if(fantasyTeam.teamBoostGameweek == gameweek && player.teamId == fantasyTeam.teamBoostTeamId) {
            bonusName = "Team Boost";
            bonusPoints = totalScore;
        };

        if(fantasyTeam.safeHandsGameweek == gameweek && player.position == 0 && playerDTO.gameweekData.saves > 4) {
            bonusName = "Safe Hands";
            bonusPoints = totalScore * 2;
        };

        if(fantasyTeam.captainFantasticGameweek == gameweek && fantasyTeam.captainId == player.id && playerDTO.gameweekData.goals > 0) {
            bonusName = "Captain Fantastic";
            bonusPoints = totalScore;
        };

        if(fantasyTeam.braceBonusGameweek == gameweek && playerDTO.gameweekData.goals >= 2) {
            bonusName = "Brace Bonus";
            bonusPoints = totalScore;
        };

        if(fantasyTeam.hatTrickHeroGameweek == gameweek && playerDTO.gameweekData.goals >= 3) {
            bonusName = "Hat-trick Hero";
            bonusPoints = totalScore * 2;
        };
    
        return (
            <tr key={player.id}>
                <td className='points-team-col text-center align-middle'>
                    <PlayerIcon width={20} height={20} primaryColour={getTeamById(player.teamId).primaryColourHex} secondaryColour={getTeamById(player.teamId).secondaryColourHex} />
                </td>
                <td className='points-name-col align-middle'>
                    {isCaptain
                        ? <StarIcon 
                            color="#807A00" 
                            width="15" 
                            height="15" 
                            style={{ marginRight: '5px' }}
                          />
                        : <StarOutlineIcon 
                            color="#807A00" 
                            width="15" 
                            height="15" 
                            style={{ marginRight: '5px' }}
                          />}
                    <small style={{overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap'}}>{player.firstName !== "" ? player.firstName.charAt(0) + "." : ""} {player.lastName} ({positionCodes[player.position]})</small>
                </td>
                <td className='points-points-col align-middle text-center'>{playerDTO.points}</td>
                <td style={{paddingLeft: 0, paddingRight: 0}} className='points-button-col align-middle'><Button className='w-100' onClick={() => handleShowModal(player, playerDTO, isCaptain, bonusName, bonusPoints)}><label className='small-text' >Details</label></Button></td>
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
    
        if (fantasyTeamDTO.safeHandsGameweek === playerDTO.gameweek && playerDTO.position === 0 && playerDTO.gameweekData.saves >= 5) {
            score = score * 3;
        }
    
        if (fantasyTeamDTO.captainFantasticGameweek === playerDTO.gameweek && fantasyTeamDTO.captainId === playerDTO.id && playerDTO.gameweekData.goals > 0) {
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
        if(fantasyTeam.players.length == 0){
            return;
        }
        
        let bonusDetails = {name: 'No Bonus Played', player: '', team: ''};
        if (fantasyTeam.goalGetterGameweek == Number(gameweek)) {
            const player = players.find(p => p.id === fantasyTeam.goalGetterPlayerId);
            if (player) {
                bonusDetails = {
                    name: 'Goal Getter',
                    player: `${player.firstName.charAt(0)}. ${player.lastName}`
                };
            }
        }
    
        if (fantasyTeam.passMasterGameweek == Number(gameweek)) {
            const player = players.find(p => p.id === fantasyTeam.passMasterPlayerId);
            if (player) {
                bonusDetails = {
                    name: 'Pass Master',
                    player: `${player.firstName.charAt(0)}. ${player.lastName}`
                };
            }
        }
    
        if (fantasyTeam.noEntryGameweek == Number(gameweek)) {
            const player = players.find(p => p.id === fantasyTeam.noEntryPlayerId);
            if (player) {
                bonusDetails = {
                    name: 'No Entry',
                    player: `${player.firstName.charAt(0)}. ${player.lastName}`
                };
            }
        }
    
        if (fantasyTeam.teamBoostGameweek == Number(gameweek)) {
            const team = teams.find(t => t.id === fantasyTeam.teamBoostTeamId);
            if (team) {
                bonusDetails = {
                    name: 'Team Boost',
                    player: `${team.friendlyName}`
                };
            }
        }
    
        if (fantasyTeam.safeHandsGameweek == Number(gameweek)) {
            const goalkeeper = players.find(p => fantasyTeam.playerIds.includes(p.id) && p.position === 0);
            if (goalkeeper) {
                bonusDetails = {
                    name: 'Safe Hands',
                    player: `${goalkeeper.firstName.charAt(0)}. ${goalkeeper.lastName}`
                };
            }
        }
    
        if (fantasyTeam.captainFantasticGameweek == Number(gameweek)) {
            const player = players.find(p => p.id === fantasyTeam.captainId);
            if (player) {
                bonusDetails = {
                    name: 'Captain Fantastic',
                    player: `${player.firstName.charAt(0)}. ${player.lastName}`
                };
            }
        }
    
        if (fantasyTeam.braceBonusGameweek == Number(gameweek)) {
            bonusDetails = {
                name: 'Brace Bonus'
            };
        }
    
        if (fantasyTeam.hatTrickHeroGameweek == Number(gameweek)) {
            bonusDetails = {
                name: 'Hat-trick Hero'
            };
        }
        
        setGameweekBonus(bonusDetails);
    
        return bonusDetails;
    }
    

    const handleShowModal = (player, playerDTO, isCaptain, bonusName, bonusPoints) => {
        setSelectedPlayer(player);
        setSelectedPlayerDTO(playerDTO);
        setSelectedPlayerCaptain(isCaptain);
        setSelectedPlayerBonusName(bonusName);
        setSelectedPlayerBonusPoints(bonusPoints);
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
        <Container className="flex-grow-1 my-2">
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
                            <div className='mt-2'>Season: {season}</div>
                            <div>Gameweek: {gameweek}</div>
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

                    <Table responsive className="table-fixed mt-2">
                        <tbody>
                            {sortedPlayers.map(player => renderPlayer(player, player.id == fantasyTeam.captainId, fantasyTeam))}
                        </tbody>
                    </Table>

                    <div className='text-center'>
                        <div>{gameweekBonus.name}</div>
                        <div>{gameweekBonus.player}</div>
                    </div>
                </Card.Body>
            </Card>
   
            {selectedPlayer && selectedPlayerDTO && <PlayerDetailsModal show={showModal} onClose={handleCloseModal} player={selectedPlayer} playerDTO={selectedPlayerDTO} gameweek={gameweek} teams={teams} isCaptain={selectedPlayerCaptain} bonusName={selectedPlayerBonusName} bonusPoints={selectedPlayerBonusPoints}/>}
    
        </Container>
        );
};


export default ViewPoints;
