import React, { useState, useEffect } from 'react';
import { Modal, Button, Table, Container, Card } from 'react-bootstrap';
import { getTeamById } from '../helpers';
import { BadgeIcon } from '../icons';
import getFlag from '../country-flag';

const PlayerDetailModal = ({ show, onClose, player, playerGameweek, teams, season }) => {
    if (!player || !playerGameweek) return null;
    const [playerTeam, setPlayerTeam] = useState(getTeamById(teams, player.teamId));
    let goalConcededCount = 0;
    
    useEffect(() => {
        setPlayerTeam(getTeamById(teams, player.teamId));
        console.log(playerGameweek);
    }, [show]);
    
    const getEventName = (eventType) => {
        const eventNames = [
            "Appearance",
            "Goal Scored",
            "Goal Assisted",
            "Goal Conceded - Inferred",
            "Keeper Save",
            "Clean Sheet - Inferred",
            "Penalty Saved",
            "Penalty Missed",
            "Yellow Card",
            "Red Card",
            "Own Goal",
            "Highest Scoring Player"
        ];
        return eventNames[eventType] || "Unknown Event";
    }
    

    return (
        <Modal show={show} onHide={onClose}>
            <Modal.Header closeButton>
                <Modal.Title>
                    Gameweek Detail
                </Modal.Title>
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
                                    primary={playerTeam.primaryColourHex}
                                    secondary={playerTeam.secondaryColourHex}
                                    third={playerTeam.thirdColourHex}
                                    width={32}
                                    height={32}
                                    marginRight={8}
                                /> {playerTeam.friendlyName}
                        </div>
                        <div className='player-modal-season-col'>
                            {season.name}
                        </div>
                        <div className='player-modal-gameweek-col'>
                            Gameweek {playerGameweek.number}
                        </div>
                        <div className="d-none d-md-block player-detail-divider-1"></div>
                        <div className="d-none d-md-block player-detail-divider-2"></div>
                    </div>
                </div>
                <div className='player-modal-header-row'>
                    <div className='player-detail-modal-category-col'>
                        Category
                    </div>
                    <div className='player-detail-modal-quantity-col'>
                        Detail
                    </div>
                    <div className='player-detail-modal-points-col'>
                        Points
                    </div>
                </div>
                {playerGameweek.events.sort((a, b) => {
                   const specialTypes = [0, 4, 5, 6, 7, 8];
                    if (specialTypes.includes(a.eventType) && specialTypes.includes(b.eventType)) {
                        return 0;
                    }
                    if (specialTypes.includes(a.eventType)) {
                        return 1;
                    }
                    if (specialTypes.includes(b.eventType)) {
                        return -1;
                    }
                    return a.eventEndMinute - b.eventEndMinute;
                    }).map((evt, index) => {
                    switch(evt.eventType){
                        case 0:
                            return (<div className='player-modal-category-row row-bottom-border'>        
                                <div className='player-detail-modal-category-col'>Appearance</div>
                                <div className='player-detail-modal-quantity-col'>{`${evt.eventStartMinute}-${evt.eventEndMinute}'`}</div>
                                <div className='player-detail-modal-points-col'>5</div>
                            </div>
                            );
                        case 1:
                            return (<div className='player-modal-category-row row-bottom-border'>        
                                <div className='player-detail-modal-category-col'>Goal Scored</div>
                                <div className='player-detail-modal-quantity-col'>{`${evt.eventEndMinute}'`}</div>
                                <div className='player-detail-modal-points-col'>5</div>
                            </div>
                            );
                        case 2:
                            return (<div className='player-modal-category-row row-bottom-border'>        
                                <div className='player-detail-modal-category-col'>Assist</div>
                                <div className='player-detail-modal-quantity-col'>{`${evt.eventEndMinute}'`}</div>
                                <div className='player-detail-modal-points-col'>5</div>
                            </div>
                            );
                        case 3:
                            goalConcededCount++;
                            return (<div className='player-modal-category-row row-bottom-border'>        
                                <div className='player-detail-modal-category-col'>Goal Conceded</div>
                                <div className='player-detail-modal-quantity-col'>{`${evt.eventEndMinute}'`}</div>
                                <div className='player-detail-modal-points-col'>-</div>
                            </div>
                            );
                        case 4:
                            return (<div className='player-modal-category-row row-bottom-border'>        
                                <div className='player-detail-modal-category-col'>Keeper save</div>
                                <div className='player-detail-modal-quantity-col'>-</div>
                                <div className='player-detail-modal-points-col'>-</div>
                            </div>
                            );
                        case 5:
                            return (<div className='player-modal-category-row row-bottom-border'>        
                                <div className='player-detail-modal-category-col'>Clean Sheet</div>
                                <div className='player-detail-modal-quantity-col'>-</div>
                                <div className='player-detail-modal-points-col'>10</div>
                            </div>
                            );
                        case 6:
                            return (<div className='player-modal-category-row row-bottom-border'>        
                                <div className='player-detail-modal-category-col'>Penalty Save</div>
                                <div className='player-detail-modal-quantity-col'>-</div>
                                <div className='player-detail-modal-points-col'>20</div>
                            </div>
                            );
                        case 7:
                            return (<div className='player-modal-category-row row-bottom-border'>        
                                <div className='player-detail-modal-category-col'>Penalty Missed</div>
                                <div className='player-detail-modal-quantity-col'>-</div>
                                <div className='player-detail-modal-points-col'>-15</div>
                            </div>
                            );
                        case 8:
                            return (<div className='player-modal-category-row row-bottom-border'>        
                                <div className='player-detail-modal-category-col'>Yellow Card</div>
                                <div className='player-detail-modal-quantity-col'>-</div>
                                <div className='player-detail-modal-points-col'>-5</div>
                            </div>
                            );
                        case 9:
                            return (<div className='player-modal-category-row row-bottom-border'>        
                                <div className='player-detail-modal-category-col'>Red Card</div>
                                <div className='player-detail-modal-quantity-col'>-</div>
                                <div className='player-detail-modal-points-col'>-20</div>
                            </div>
                            );
                        case 10:
                            return (<div className='player-modal-category-row row-bottom-border'>        
                                <div className='player-detail-modal-category-col'>Own Goal</div>
                                <div className='player-detail-modal-quantity-col'>{`${evt.eventEndMinute}'`}</div>
                                <div className='player-detail-modal-points-col'>-10</div>
                            </div>
                            );
                        case 11:
                            return (<div className='player-modal-category-row row-bottom-border'>        
                                <div className='player-detail-modal-category-col'>Highest Scoring Player</div>
                                <div className='player-detail-modal-quantity-col'>-</div>
                                <div className='player-detail-modal-points-col'>25</div>
                            </div>
                            );
                    }

                    
                })}
                {goalConcededCount >= 2 && (
                    <div className='player-modal-category-row row-bottom-border'>        
                        <div className='player-detail-modal-category-col'>Goals Conceded x {goalConcededCount}</div>
                        <div className='player-detail-modal-quantity-col'>-</div>
                        <div className='player-detail-modal-points-col'>{-(15 * Math.floor(goalConcededCount / 2))}</div>
                    </div>
                )}



            </Modal.Body>
            <Modal.Footer>
                <Button className='fpl-btn-purple' variant="secondary" onClick={onClose}>
                    Close
                </Button>
            </Modal.Footer>
        </Modal>
    );
};

export default PlayerDetailModal;
