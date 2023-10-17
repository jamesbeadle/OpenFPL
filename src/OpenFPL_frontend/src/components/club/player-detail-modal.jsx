import React, { useState, useEffect } from 'react';
import { Modal, Button, Table, Container, Card } from 'react-bootstrap';
import { getTeamById } from '../helpers';
import { BadgeIcon } from '../icons';
import getFlag from '../country-flag';

const PlayerDetailModal = ({ show, onClose, player, playerGameweek, teams, season }) => {
    if (!player || !playerGameweek) return null;
    const [playerTeam, setPlayerTeam] = useState(getTeamById(teams, player.teamId));
    const appearanceEvents = [];
    const concededEvents = [];
    const keeperSaveEvents = [];
    const otherEvents = [];
    let goalConcededCount = 0;
    let keeperSaveCount = 0;

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

    switch(player.position){
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

    playerGameweek.events.forEach((evt) => {
        switch (evt.eventType) {
            case 0:
                appearanceEvents.push(evt);
                break;
            case 3:
                concededEvents.push(evt);
                goalConcededCount++;
                break;
            case 4:
                keeperSaveEvents.push(evt);
                keeperSaveCount++;
                break;
            default:
                otherEvents.push(evt);
                break;
        }
    });
    
    concededEvents.sort((a, b) => a.eventEndMinute - b.eventEndMinute);
    keeperSaveEvents.sort((a, b) => a.eventEndMinute - b.eventEndMinute);
    otherEvents.sort((a, b) => a.eventType - b.eventType || a.eventEndMinute - b.eventEndMinute);
    
    const renderEvent = (evt) => {
        switch(evt.eventType){
            case 0:
                return (<div className='player-modal-category-row row-bottom-border'>        
                    <div className='player-detail-modal-category-col'>Appearance</div>
                    <div className='player-detail-modal-quantity-col'>{`${evt.eventStartMinute}-${evt.eventEndMinute}'`}</div>
                    <div className='player-detail-modal-points-col'>{pointsForAppearance}</div>
                </div>
                );
            case 1:
                return (<div className='player-modal-category-row row-bottom-border'>        
                    <div className='player-detail-modal-category-col'>Goal Scored</div>
                    <div className='player-detail-modal-quantity-col'>{`${evt.eventEndMinute}'`}</div>
                    <div className='player-detail-modal-points-col'>{pointsForGoal}</div>
                </div>
                );
            case 2:
                return (<div className='player-modal-category-row row-bottom-border'>        
                    <div className='player-detail-modal-category-col'>Assist</div>
                    <div className='player-detail-modal-quantity-col'>{`${evt.eventEndMinute}'`}</div>
                    <div className='player-detail-modal-points-col'>{pointsForAssist}</div>
                </div>
                );
            case 5:
                return (<div className='player-modal-category-row row-bottom-border'>        
                    <div className='player-detail-modal-category-col'>Clean Sheet</div>
                    <div className='player-detail-modal-quantity-col'>-</div>
                    <div className='player-detail-modal-points-col'>{pointsForCleanSheet}</div>
                </div>
                );
            case 6:
                return (<div className='player-modal-category-row row-bottom-border'>        
                    <div className='player-detail-modal-category-col'>Penalty Save</div>
                    <div className='player-detail-modal-quantity-col'>-</div>
                    <div className='player-detail-modal-points-col'>{pointsForPenaltySave}</div>
                </div>
                );
            case 7:
                return (<div className='player-modal-category-row row-bottom-border'>        
                    <div className='player-detail-modal-category-col'>Penalty Missed</div>
                    <div className='player-detail-modal-quantity-col'>-</div>
                    <div className='player-detail-modal-points-col'>{pointsForPenaltyMiss}</div>
                </div>
                );
            case 8:
                return (<div className='player-modal-category-row row-bottom-border'>        
                    <div className='player-detail-modal-category-col'>Yellow Card</div>
                    <div className='player-detail-modal-quantity-col'>-</div>
                    <div className='player-detail-modal-points-col'>{pointsForYellowCard}</div>
                </div>
                );
            case 9:
                return (<div className='player-modal-category-row row-bottom-border'>        
                    <div className='player-detail-modal-category-col'>Red Card</div>
                    <div className='player-detail-modal-quantity-col'>-</div>
                    <div className='player-detail-modal-points-col'>{pointsForRedCard}</div>
                </div>
                );
            case 10:
                return (<div className='player-modal-category-row row-bottom-border'>        
                    <div className='player-detail-modal-category-col'>Own Goal</div>
                    <div className='player-detail-modal-quantity-col'>{`${evt.eventEndMinute}'`}</div>
                    <div className='player-detail-modal-points-col'>{pointsForOwnGoal}</div>
                </div>
                );
            case 11:
                return (<div className='player-modal-category-row row-bottom-border'>        
                    <div className='player-detail-modal-category-col'>Highest Scoring Player</div>
                    <div className='player-detail-modal-quantity-col'>-</div>
                    <div className='player-detail-modal-points-col'>{pointsForHighestScore}</div>
                </div>
                );
        }
    };

    useEffect(() => {
        setPlayerTeam(getTeamById(teams, player.teamId));
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
                        {getFlag(player.nationality)}
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
                                    className='badge-icon'
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
                <>
                    {appearanceEvents.map(renderEvent)}
                    {concededEvents.map(renderEvent)}
                    {goalConcededCount >= 2 && (
                        <div className='player-modal-category-row row-bottom-border'>
                            <div className='player-detail-modal-category-col'>Goals Conceded x {goalConcededCount}</div>
                            <div className='player-detail-modal-quantity-col'>-</div>
                            <div className='player-detail-modal-points-col'>{-(-pointsForEach2Conceded * Math.floor(goalConcededCount / 2))}</div>
                        </div>
                    )}
                    {keeperSaveEvents.map(renderEvent)}
                    {Math.floor(keeperSaveCount / 3) > 0 && (
                        <div className='player-modal-category-row row-bottom-border'>
                            <div className='player-detail-modal-category-col'>Keeper Save x 3</div>
                            <div className='player-detail-modal-quantity-col'>-</div>
                            <div className='player-detail-modal-points-col'>{pointsFor3Saves * Math.floor(keeperSaveCount / 3)}</div>
                        </div>
                    )}
                    {otherEvents.map(renderEvent)}
                </>
                <div className='player-modal-total-row'>
                    <div className='player-detail-modal-total-col'>
                        Total Points:
                    </div>
                    <div className='player-detail-modal-total-points-col'>{playerGameweek.points}</div>
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

export default PlayerDetailModal;
