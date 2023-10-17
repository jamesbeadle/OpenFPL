import React from 'react';
import { Modal, Button } from 'react-bootstrap';
import getFlag from '../country-flag';
import GoalGetter from "../../../assets/goal-getter.png";
import PassMaster from "../../../assets/pass-master.png";
import NoEntry from "../../../assets/no-entry.png";
import TeamBoost from "../../../assets/team-boost.png";
import SafeHands from "../../../assets/safe-hands.png";
import CaptainFantastic from "../../../assets/captain-fantastic.png";
import BraceBonus from "../../../assets/brace-bonus.png";
import HatTrickHero from "../../../assets/hat-trick-hero.png";
import { BadgeIcon } from '../icons';
import { useNavigate } from 'react-router-dom';

const PlayerPointsModal = ({ show, onClose, player, playerDTO, season, gameweek, team, isCaptain, bonusId }) => {
    if (!player || !playerDTO || !playerDTO.gameweekData) return null;
    const navigate = useNavigate();
   
    const { gameweekData } = playerDTO;

    const loadClub = async (clubId) => {
      navigate(`/club/${clubId}`);
    };

    return (
        <Modal show={show} onHide={onClose}>
            <Modal.Header closeButton>
                <Modal.Title>Player Details</Modal.Title>
            </Modal.Header>
            <Modal.Body>
                <div className='player-modal-name-row'>
                    <div className='player-modal-flag-col'>
                        {getFlag(player.nationality, '90px')}
                    </div>
                    <div className='player-modal-name-col'>
                        {(player.firstName != "" ? player.firstName.charAt(0) + "." : "") + player.lastName}
                    </div>
                </div>
                <div className="outer-container d-flex">
                    <div className='player-modal-detail-row'>
                        <div onClick={() => loadClub(team.id)} className='player-modal-fixture-col clickable-table-row'>
                            <BadgeIcon
                                    primary={team.primaryColourHex}
                                    secondary={team.secondaryColourHex}
                                    third={team.thirdColourHex}
                                    className='badge-icon'
                                /> {team.friendlyName}
                        </div>
                        <div className='player-modal-season-col'>
                            {season.name}
                        </div>
                        <div className='player-modal-gameweek-col'>
                            Gameweek {gameweek}
                        </div>
                        <div className="d-none d-md-block player-detail-divider-1"></div>
                        <div className="d-none d-md-block player-detail-divider-2"></div>
                    </div>
                </div>
                <div className='player-modal-header-row'>
                    <div className='player-modal-category-col'>
                        Category
                    </div>
                    <div className='player-modal-quantity-col'>
                        Quantity
                    </div>
                    <div className='player-modal-points-col'>
                        Points
                    </div>
                </div>
                <div className='player-modal-category-row row-bottom-border'>
                    <div className='player-modal-category-col'>Appearance</div>
                    <div className='player-modal-quantity-col'>{gameweekData.appearance > 0 ? gameweekData.appearance : "-"}</div>
                    <div className='player-modal-points-col'>{gameweekData.appearance > 0 ? gameweekData.appearance * 5 : "-"}</div>
                </div>
                <div className='player-modal-category-row row-bottom-border'>
                    <div className='player-modal-category-col'>Goals</div>
                    <div className='player-modal-quantity-col'>{gameweekData.goals}</div>
                    <div className='player-modal-points-col'>{gameweekData.goalPoints}</div>
                </div>
                <div className='player-modal-category-row row-bottom-border'>
                    <div className='player-modal-category-col'>Assists</div>
                    <div className='player-modal-quantity-col'>{gameweekData.assists}</div>
                    <div className='player-modal-points-col'>{gameweekData.assistPoints}</div>
                </div>
                <div className='player-modal-category-row row-bottom-border'>
                    <div className='player-modal-category-col'>Yellow Cards</div>
                    <div className='player-modal-quantity-col'>{gameweekData.yellowCards}</div>
                    <div className='player-modal-points-col'>{gameweekData.yellowCards * -5}</div>
                </div>
                <div className='player-modal-category-row row-bottom-border'>
                    <div className='player-modal-category-col'>Red Card</div>
                    <div className='player-modal-quantity-col'>{gameweekData.redCards > 0 ? 'Yes' : '-'}</div>
                    <div className='player-modal-points-col'>{gameweekData.redCards > 0 ? 20 : 0}</div>
                </div>
                {player.position < 2 && (    
                    <>
                        <div className='player-modal-category-row row-bottom-border'>
                            <div className='player-modal-category-col'>Clean Sheet</div>
                            <div className='player-modal-quantity-col'>{gameweekData.cleanSheets > 0 ? 'Yes' : '-'}</div>
                            <div className='player-modal-points-col'>{gameweekData.cleanSheetPoints}</div>
                        </div>
                        <div className='player-modal-category-row row-bottom-border'>
                            <div className='player-modal-category-col'>Conceded</div>
                            <div className='player-modal-quantity-col'>{gameweekData.goalsConceded}</div>
                            <div className='player-modal-points-col'>{gameweekData.goalsConcededPoints}</div>
                        </div>
                    </>
                )}
                {player.position == 0 && (
                    <>
                        <div className='player-modal-category-row row-bottom-border'>
                            <div className='player-modal-category-col'>Saves</div>
                            <div className='player-modal-quantity-col'>{gameweekData.saves}</div>
                            <div className='player-modal-points-col'>{Math.floor(gameweekData.saves / 3) * 5}</div>
                        </div>
                        <div className='player-modal-category-row row-bottom-border'>
                            <div className='player-modal-category-col'>Penalty Saves</div>
                            <div className='player-modal-quantity-col'>{gameweekData.penaltySaves}</div>
                            <div className='player-modal-points-col'>{gameweekData.penaltySaves * 20}</div>
                        </div>
                    </>
                )}
                <div className='player-modal-category-row row-bottom-border'>
                    <div className='player-modal-category-col'>Own Goal</div>
                    <div className='player-modal-quantity-col'>{gameweekData.ownGoals}</div>
                    <div className='player-modal-points-col'>{gameweekData.ownGoals * -10}</div>
                </div>
                <div className='player-modal-category-row row-bottom-border'>
                    <div className='player-modal-category-col'>Penalty Misses</div>
                    <div className='player-modal-quantity-col'>{gameweekData.missedPenalties}</div>
                    <div className='player-modal-points-col'>{gameweekData.missedPenalties * -15}</div>
                </div>
                <div className='player-modal-category-row row-bottom-border'>
                    <div className='player-modal-category-col'>Highest Scoring Player</div>
                    <div className='player-modal-quantity-col'>{gameweekData.highestScoringPlayerId}</div>
                    <div className='player-modal-points-col'>{gameweekData.highestScoringPlayerId * 25}</div>
                </div>
                {playerDTO.points != playerDTO.totalPoints ?? <div className='player-modal-category-row row-bottom-border'>
                    <div className='player-modal-category-col'>Sub Total</div>
                    <div className='player-modal-quantity-col'>-</div>
                    <div className='player-modal-points-col'>{playerDTO.points}</div>
                </div>}
                {bonusId > 0 && (
                    <div className='player-modal-category-row row-bottom-border'>
                        <div className='player-modal-category-col'>{[
                                (bonusId === 1 && "Goal Getter Bonus"),
                                (bonusId === 2 && "Pass Master Bonus"),
                                (bonusId === 3 && "No Entry Bonus"),
                                (bonusId === 4 && "Safe Hands Bonus"),
                                (bonusId === 5 && "Captain Fantastic Bonus"),
                                (bonusId === 6 && "Brace Bonus"),
                                (bonusId === 7 && "Hat-trick Hero Bonus"),
                                (bonusId === 8 && "Team Boost Bonus")
                                ].some(Boolean) || '-'}</div>
                        <div className='player-modal-quantity-col'>
                        {[
                                (bonusId === 1 && <img src={GoalGetter} alt='goal-getter' className='gw-bonus-image'/>),
                                (bonusId === 2 && <img src={PassMaster} alt='pass-master' className='gw-bonus-image'/>),
                                (bonusId === 3 && <img src={NoEntry} alt='no-entry' className='gw-bonus-image'/>),
                                (bonusId === 4 && <img src={SafeHands} alt='safe-hands' className='gw-bonus-image'/>),
                                (bonusId === 5 && <img src={CaptainFantastic} alt='captain-fantastic' className='gw-bonus-image'/>),
                                (bonusId === 6 && <img src={BraceBonus} alt='brace-bonus' className='gw-bonus-image'/>),
                                (bonusId === 7 && <img src={HatTrickHero} alt='hat-trick-hero' className='gw-bonus-image'/>),
                                (bonusId === 8 && <img src={TeamBoost} alt='team-boost' className='gw-bonus-image'/>)
                                ].some(Boolean) || '-'}
                        </div>
                        <div className='player-modal-points-col'>{playerDTO.bonusPoints}</div>
                    </div>
                )}
                                    
                {isCaptain && (
                    <div className='player-modal-category-row row-bottom-border row-bottom-border'>
                        <div className='player-modal-category-col'>Captain Bonus</div>
                        <div className='player-modal-quantity-col'>-</div>
                        <div className='player-modal-points-col'>{playerDTO.points + playerDTO.bonusPoints}</div>
                    </div>
                )}
                <div className='player-modal-total-row'>
                    <div className='player-modal-total-col'>
                        Total Points:
                    </div>
                    <div className='player-modal-total-points-col'>{playerDTO.totalPoints}</div>
                </div>
            </Modal.Body>
            <Modal.Footer>
                <Button className='fpl-btn-purple' variant="secondary" onClick={onClose}>
                    Close
                </Button>
            </Modal.Footer>
        </Modal>
    );
};

export default PlayerPointsModal;
