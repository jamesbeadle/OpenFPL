import React, { useState, useEffect } from 'react';
import { Container, Row, Col, Card, Spinner, Button } from 'react-bootstrap';
import { OpenFPL_backend as open_fpl_backend } from '../../../../declarations/OpenFPL_backend';
import { player_canister as player_canister } from '../../../../declarations/player_canister';
import { useParams } from 'react-router-dom';
import PlayerDetailsModal from './player-details-modal';

const ViewPoints = () => {
    const { manager, gameweek, season } = useParams();
    const [isLoading, setIsLoading] = useState(true);
    const [fantasyTeam, setFantasyTeam] = useState({
        players: [],
    });
    const [showModal, setShowModal] = useState(false);
    const [selectedPlayer, setSelectedPlayer] = useState(null);
    const [fixtures, setFixtures] = useState([]);
    const [players, setPlayers] = useState([]);
   
    useEffect(() => {
        const fetchData = async () => {
            await fetchViewData();
            setIsLoading(false);
        };
        fetchData();
    }, []);

    
    const extractPlayerData = (playerDTO) => {
        let goals = 0, assists = 0, redCards = 0, yellowCards = 0, missedPenalties = 0, ownGoals = 0, saves = 0, cleanSheets = 0, penaltySaves = 0, goalsConceded = 0, appearance = 0, highestScoringPlayerId = 0;
        playerDTO.events.forEach(event => {
            console.log(event)
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

    const fetchViewData = async () => {
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
    };

    const handleShowModal = (player) => {
        setSelectedPlayer(player);
        setShowModal(true);
    }

    const handleCloseModal = () => {
        setSelectedPlayer(null);
        setShowModal(false);
    }

    
    const renderPlayerPoints = (playerDTO) => {
        const player = players.find(p => p.id === playerDTO.id);
        const playerScore = calculatePlayerScore(playerDTO, fantasyTeam, fixtures);
        return (
        <Card key={player.id}>
            <Row className='mx-1 mt-2'>
                <Col xs={12}>
                    <Row>
                    <Col xs={6}>
                        <h5>{player.firstName} {player.lastName}</h5>
                    </Col>
                    <Col xs={3}>
                        <p>{playerScore} pts</p>
                    </Col>
                    <Col xs={3}>
                        <Button onClick={() => handleShowModal(player)}>Details</Button>
                    </Col>
                    </Row>
                </Col>
            </Row>
        </Card>
        );
    }

    const calculatePlayerScore = (playerDTO, fantasyTeamDTO, fixtures) => {
        if (!playerDTO) {
            console.error("No gameweekData found for player:", playerDTO);
            return 0;
        }
        
        let score = 0; 

        if(playerDTO.gameweekData.appearance > 0){
            score += 5 * playerDTO.gameweekData.appearance;
        }
    
        if (playerDTO.position === 0) {
            if (playerDTO.gameweekData.saves >= 3) {
                score += Math.floor(playerDTO.gameweekData.saves / 3) * 5;
            }
            if (playerDTO.gameweekData.cleanSheets) {
                score += 10;
            }
            if (playerDTO.gameweekData.penaltySaves) {
                score += 20 * playerDTO.gameweekData.penaltySaves;
            }
        }
    
        if (playerDTO.position === 3) {
            score += playerDTO.gameweekData.goals * 10;
            score += playerDTO.gameweekData.assists * 10;
        } else if (playerDTO.position === 2) {
            score += playerDTO.gameweekData.goals * 15;
            score += playerDTO.gameweekData.assists * 10;
        } else {
            score += playerDTO.gameweekData.goals * 20;
            score += playerDTO.gameweekData.assists * 15;
        }
    
        if (playerDTO.gameweekData.redCards) {
            score -= 20;
        }
        if (playerDTO.gameweekData.missedPenalties) {
            score -= 15 * playerDTO.gameweekData.missedPenalties;
        }
        if (playerDTO.position === 0 || playerDTO.position === 1) {
            if (playerDTO.gameweekData.goalsConceded >= 2) {
                score -= Math.floor(playerDTO.gameweekData.goalsConceded / 2) * 15;
            }
        }
        if (playerDTO.gameweekData.ownGoals) {
            score -= 10 * playerDTO.gameweekData.ownGoals;
        }
        if (playerDTO.gameweekData.yellowCards) {
            score -= 5;
        }

        if (fantasyTeamDTO.goalGetterGameweek === playerDTO.gameweek && fantasyTeamDTO.goalGetterPlayerId === playerDTO.id) {
            score += playerDTO.gameweekData.goals * 20; 
        }
    
        if (fantasyTeamDTO.passMasterGameweek === playerDTO.gameweek && fantasyTeamDTO.passMasterPlayerId === playerDTO.id) {
            score += playerDTO.gameweekData.assists * 20; 
        }
    
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
            score += 25;
        }
    
        if (fantasyTeamDTO.captainId === playerDTO.id) {
            score = score * 2;
        }
    
        return score;
    }
    
  
    return (
        isLoading ? (
            <div className="customOverlay d-flex flex-column align-items-center justify-content-center">
            <Spinner animation="border" />
            <p className='text-center mt-1'>Loading Points...</p>
            </div>
        ) :
        <Container className="flex-grow-1 my-5">
            <Row className="mb-4">
            <Col md={9}>
                <Card className="mt-4">
                <Card.Header>
                    {}
                </Card.Header>
                <Card.Body>
                    {fantasyTeam && fantasyTeam.players && fantasyTeam.players.map(player => renderPlayerPoints(player))}
                </Card.Body>
                </Card>
            </Col>
            </Row>    
            {selectedPlayer && <PlayerDetailsModal show={showModal} onClose={handleCloseModal} player={selectedPlayer} />}
    
        </Container>
        );


};


export default ViewPoints;
