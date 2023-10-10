import React from 'react';
import { Modal, Button, Table, Container, Card } from 'react-bootstrap';
import { getTeamById } from '../helpers';

const PlayerPointsModal = ({ show, onClose, player, playerDTO, gameweek, teams, isCaptain, bonusName }) => {
    if (!player || !playerDTO || !playerDTO.gameweekData) return null;

    const { gameweekData } = playerDTO;
    return (
        <Modal show={show} onHide={onClose}>
            <Modal.Header closeButton>
                <Modal.Title>
                    {(player.firstName != "" ? player.firstName.charAt(0) + "." : "") + player.lastName} - Gameweek {gameweek}
                    <br />
                    <p className='small-text'>{getTeamById(teams, player.teamId).name}</p>
                </Modal.Title>
            </Modal.Header>
            <Modal.Body>
                <Container className="flex-grow-1 my-2">
                    <Card>
                        <Card.Body>
                            <Table responsive className="table-fixed">
                                <thead>
                                    <tr>
                                        <th className='points-description-col'></th>
                                        <th className='points-count-col'></th>
                                        <th className='points-value-col text-center'><small>Points</small></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>Appearance</td>
                                        <td className='text-center'>{gameweekData.appearance > 0 ? gameweekData.appearance : "-"}</td>
                                        <td className='text-center'>{gameweekData.appearance > 0 ? gameweekData.appearance * 5 : "-"}</td>
                                    </tr>
                                    <tr>
                                        <td>Goals</td>
                                        <td className='text-center'>{gameweekData.goals}</td>
                                        <td className='text-center'>{gameweekData.goalPoints}</td>
                                    </tr>
                                    <tr>
                                        <td>Assists</td>
                                        <td className='text-center'>{gameweekData.assists}</td>
                                        <td className='text-center'>{gameweekData.assistPoints}</td>
                                    </tr>
                                    <tr>
                                        <td>Yellow Cards</td>
                                        <td className='text-center'>{gameweekData.yellowCards}</td>
                                        <td className='text-center'>{gameweekData.yellowCards * -5}</td>
                                    </tr>
                                    <tr>
                                        <td>Red Card</td>
                                        <td className='text-center'>{gameweekData.redCards > 0 ? 'Yes' : '-'}</td>
                                        <td className='text-center'>{gameweekData.redCards > 0 ? 20 : 0}</td>
                                    </tr>
                                    {player.position < 2 && (
                                    <>
                                        <tr>
                                            <td>Clean Sheet</td>
                                            <td className='text-center'>{gameweekData.cleanSheets > 0 ? 'Yes' : '-'}</td>
                                            <td className='text-center'>{gameweekData.cleanSheetPoints}</td>
                                        </tr>
                                        <tr>
                                            <td>Conceded</td>
                                            <td className='text-center'>{gameweekData.goalsConceded}</td>
                                            <td className='text-center'>{gameweekData.goalsConcededPoints}</td>
                                        </tr>
                                    </>
                                    )}
                                    {player.position == 0 && (
                                        <>
                                            <tr>
                                                <td>Saves</td>
                                                <td className='text-center'>{gameweekData.saves}</td>
                                                <td className='text-center'>{Math.floor(gameweekData.saves / 3) * 5}</td>
                                            </tr>
                                            <tr>
                                                <td>Penalty Saves</td>
                                                <td className='text-center'>{gameweekData.penaltySaves}</td>
                                                <td className='text-center'>{gameweekData.penaltySaves * 20}</td>
                                            </tr>
                                        </>
                                    )}
                                    <tr>
                                        <td>Own Goal</td>
                                        <td className='text-center'>{gameweekData.ownGoals}</td>
                                        <td className='text-center'>{gameweekData.ownGoals * -10}</td>
                                    </tr>
                                    
                                    <tr>
                                        <td>Penalty Misses</td>
                                        <td className='text-center'>{gameweekData.missedPenalties}</td>
                                        <td className='text-center'>{gameweekData.missedPenalties * -15}</td>
                                    </tr>
                                    <tr>
                                        <td>Highest Scoring Player</td>
                                        <td className='text-center'>{gameweekData.highestScoringPlayerId > 0 ? 'YES' : '-'}</td>
                                        <td className='text-center'>{gameweekData.highestScoringPlayerId > 0 ? 25 : 0}</td>
                                    </tr>
                                    <tr>
                                        <td>Points</td>
                                        <td className='text-center'>-</td>
                                        <td className='text-center'>{playerDTO.points}</td>
                                    </tr>
                                    <tr>
                                        <td>{bonusName}</td>
                                        <td className='text-center'>-</td>
                                        <td className='text-center'>{playerDTO.bonusPoints}</td>
                                    </tr>
                                    {isCaptain && (
                                        <tr>
                                            <td>Captain Bonus</td>
                                            <td className='text-center'>x2</td>
                                            <td className='text-center'>{playerDTO.points + playerDTO.bonusPoints}</td>
                                        </tr>
                                    )}
                                    <tr>
                                        <td>Total</td>
                                        <td className='text-center'>-</td>
                                        <td className='text-center'>{playerDTO.totalPoints}</td>
                                    </tr>
                                </tbody>
                            </Table>
                        </Card.Body>
                    </Card>
                </Container>
            </Modal.Body>
            <Modal.Footer>
                <Button variant="secondary" onClick={onClose}>
                    Close
                </Button>
            </Modal.Footer>
        </Modal>
    );
};

export default PlayerPointsModal;
