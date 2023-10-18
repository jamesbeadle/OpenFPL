import React, { useState, useEffect, useContext, useRef } from 'react';
import { Container, Row, Col, Spinner } from 'react-bootstrap';
import { DataContext } from "../../contexts/DataContext";
import { calculateTeamValue, getPlayerById } from '../helpers';
import GoalGetter from "../../../assets/goal-getter.png";
import PassMaster from "../../../assets/pass-master.png";
import NoEntry from "../../../assets/no-entry.png";
import TeamBoost from "../../../assets/team-boost.png";
import SafeHands from "../../../assets/safe-hands.png";
import CaptainFantastic from "../../../assets/captain-fantastic.png";
import BraceBonus from "../../../assets/brace-bonus.png";
import HatTrickHero from "../../../assets/hat-trick-hero.png";

const ManagerGameweekPoints = ({ gameweeks, setCurrentGameweek }) => {
    const { players } = useContext(DataContext);
    
    const handleShowGameweek = async (number) => {
        setCurrentGameweek(number);
    };

    return (
        
        <div className="dark-tab-row w-100 mx-0">
                <Row>

                <Container>
                    <Row style={{ overflowX: 'auto' }}>
                        <Col xs={12}>
                            <div className='light-background table-header-row w-100'  style={{ display: 'flex', alignItems: 'center' }}>
                                <div className="mgw-number-col gw-table-header">Gameweek</div>
                                <div className="mgw-team-value-col gw-table-header">Team Value</div>
                                <div className="mgw-bank-col gw-table-header">Bank Balance</div>
                                <div className="mgw-transfers-col gw-table-header">Transfers Made</div>
                                <div className="mgw-captain-col gw-table-header">Captain</div>
                                <div className="mgw-bonus-col gw-table-header">Bonus Used</div>
                                <div className="mgw-points-col gw-table-header">
                                    
                                </div>
                                
                            </div>
                        </Col>  
                    </Row>


                    
                {gameweeks.map(gameweek => {
                        const captain = getPlayerById(players, gameweek.captainId);
                        const teamPlayers = Object.values(gameweek.playerIds).map(id => players.filter(player => player.teamId > 0).find(player => player.id === id))
                        .filter(Boolean); 
                    return (
                        <Row key={`gw-${gameweek.gameweek}`} onClick={() => handleShowGameweek(gameweek.gameweek)} style={{ overflowX: 'auto' }}>
                            <Col xs={12}>
                            <div className="table-row clickable-table-row">
                                <div className="mgw-number-col gw-table-col">{gameweek.gameweek}</div>
                                <div className="mgw-team-value-col gw-table-col">£{Number(calculateTeamValue(teamPlayers)).toFixed(2)}m</div>
                                <div className="mgw-bank-col gw-table-col">£{(Number(gameweek.bankBalance) / 4).toFixed(2)}m</div>
                                <div className="mgw-transfers-col gw-table-col">{(3-gameweek.transfersAvailable)}</div>
                                <div className="mgw-captain-col gw-table-col">{captain.firstName.length > 0 ? captain.firstName.charAt(0) + "." : ""} {captain.lastName}</div>
                                <div className={`mgw-bonus-col gw-table-col ${(
                                    (gameweek.goalGetterGameweek === gameweek.gameweek) || 
                                    (gameweek.passMasterGameweek === gameweek.gameweek) ||
                                    (gameweek.noEntryGameweek === gameweek.gameweek) || 
                                    (gameweek.safeHandsGameweek === gameweek.gameweek) ||
                                    (gameweek.captainFantasticGameweek === gameweek.gameweek) ||
                                    (gameweek.braceBonusGameweek === gameweek.gameweek) ||
                                    (gameweek.hatTrickHeroGameweek === gameweek.gameweek) ||
                                    (gameweek.teamBoostGameweek === gameweek.gameweek)) ? '' : 'zero-text'}`}>
                                {[
                                    (gameweek.goalGetterGameweek === gameweek.gameweek && <img src={GoalGetter} alt='goal-getter' className='gw-bonus-image'/>),
                                    (gameweek.passMasterGameweek === gameweek.gameweek && <img src={PassMaster} alt='pass-master' className='gw-bonus-image'/>),
                                    (gameweek.noEntryGameweek === gameweek.gameweek && <img src={NoEntry} alt='no-entry' className='gw-bonus-image'/>),
                                    (gameweek.safeHandsGameweek === gameweek.gameweek && <img src={SafeHands} alt='safe-hands' className='gw-bonus-image'/>),
                                    (gameweek.captainFantasticGameweek === gameweek.gameweek && <img src={CaptainFantastic} alt='captain-fantastic' className='gw-bonus-image'/>),
                                    (gameweek.braceBonusGameweek === gameweek.gameweek && <img src={BraceBonus} alt='brace-bonus' className='gw-bonus-image'/>),
                                    (gameweek.hatTrickHeroGameweek === gameweek.gameweek && <img src={HatTrickHero} alt='hat-trick-hero' className='gw-bonus-image'/>),
                                    (gameweek.teamBoostGameweek === gameweek.gameweek && <img src={TeamBoost} alt='team-boost' className='gw-bonus-image'/>)
                                    ].some(Boolean) || '-'}
                                </div>
                                <div className="mgw-points-col gw-table-col">{gameweek.points}</div>
                            </div>
                            </Col>
                            </Row>
                        );
                    })}
                    

                    </Container>
                </Row>
        </div>
    
    );
};

export default ManagerGameweekPoints;
