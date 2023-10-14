import React, { useState, useEffect, useContext, useRef } from 'react';
import { Container, Row, Col, Dropdown, Button, Spinner } from 'react-bootstrap';
import { DataContext } from "../../contexts/DataContext";
import { ArrowLeft, ArrowRight, BadgeIcon } from '../icons';
import { getFantasyTeamForGameweek } from '../../AuthFunctions';
import { OpenFPL_backend as open_fpl_backend } from '../../../../declarations/OpenFPL_backend';
import { player_canister as player_canister } from '../../../../declarations/player_canister';
import { getTeamById } from '../helpers';
import GoalGetter from "../../../assets/goal-getter.png";
import PassMaster from "../../../assets/pass-master.png";
import NoEntry from "../../../assets/no-entry.png";
import TeamBoost from "../../../assets/team-boost.png";
import SafeHands from "../../../assets/safe-hands.png";
import CaptainFantastic from "../../../assets/captain-fantastic.png";
import BraceBonus from "../../../assets/brace-bonus.png";
import HatTrickHero from "../../../assets/hat-trick-hero.png";
import PlayerPointsModal from '../modals/player-points-modal';

const ManagerGameweekPoints = ({ gameweeks }) => {
    const { seasons, fixtures, systemState, playerEvents, teams, players } = useContext(DataContext);
    
    const [isLoading, setIsLoading] = useState(true);
    const [currentSeason, setCurrentSeason] = useState(systemState.activeSeason);
    const [showSeasonDropdown, setShowSeasonDropdown] = useState(false);
    const seasonDropdownRef = useRef(null);
    
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
    }, [currentSeason]);
  
    const fetchViewData = async () => {
        console.log("gameweeks")
        console.log(gameweeks)
    };

    const handleSeasonChange = async (change) => {
        const newIndex = seasons.findIndex(season => season.id === currentSeason.id) + change;
        if (newIndex >= 0 && newIndex < seasons.length) {
        setCurrentSeason(seasons[newIndex]);
        
        if (seasons[newIndex].id !== systemState.activeSeason.id) {
            const newFixtures = await fetchFixturesForSeason(seasons[newIndex].id);
            fetchGameweekPoints(newFixtures);
        } else {
            fetchGameweekPoints(null, null);
        }
        }
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
  
    return (
        <>
            {isLoading ? (
            <div className="d-flex flex-column align-items-center justify-content-center">
                <Spinner animation="border" />
                <p className='text-center mt-1'>Loading Gameweek Points</p>
            </div>) 
            :
            <div className="dark-tab-row w-100 mx-0">
                <Row>
                <Col md={12}>
                    <div className='filter-row' style={{ display: 'flex', justifyContent: 'left', alignItems: 'left' }}>
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
                    </div>
                </Col>
                </Row>

                <Row>

                <Container>
                    <Row style={{ overflowX: 'auto' }}>
                        <Col xs={12}>
                            <div className='light-background table-header-row w-100'  style={{ display: 'flex', alignItems: 'center' }}>
                                <div className="mgw-number-col gw-table-header">Gameweek</div>
                                <div className="mgw-transfers-col gw-table-header">Transfers Made</div>
                                <div className="mgw-bank-col gw-table-header">Bank Balance</div>
                                <div className="mgw-captain-col gw-table-header">Captain</div>
                                <div className="mgw-bonus-col gw-table-header">Bonus Used</div>
                                <div className="mgw-points-col gw-table-header">Points</div>
                            </div>
                        </Col>  
                    </Row>


                    
                {gameweeks.map(gameweek => {
                        return (
                        <Row key={`gw-${gameweek.number}`} onClick={() => handleShowGameweek(gameweek.number)} style={{ overflowX: 'auto' }}>
                            <Col xs={12}>
                            <div className="table-row clickable-table-row">
                                <div className="mgw-number-col gw-table-col">{gameweek.gameweek}</div>
                                <div className="mgw-transfers-col gw-table-col">{(3-gameweek.transfersAvailable)}</div>
                                <div className="mgw-bank-col gw-table-col">£{(Number(gameweek.bankBalance) / 4).toFixed(2)}m</div>
                                <div className="mgw-captain-col gw-table-col">{gameweek.captainId}</div>
                                <div className="mgw-bonus-col gw-table-col">{gameweek.gameweek}</div>
                                <div className="mgw-points-col gw-table-col">{gameweek.points}</div>
                            </div>
                            </Col>
                            </Row>
                        );
                    })}
                    

                    </Container>
                </Row>
            </div>
        }
        </>
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

export default ManagerGameweekPoints;
