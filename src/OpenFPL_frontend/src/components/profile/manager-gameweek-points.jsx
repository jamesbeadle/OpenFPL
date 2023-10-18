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
import PlayerPointsModal from '../modals/player-points-modal';

const ManagerGameweekPoints = ({ gameweeks, setCurrentGameweek }) => {
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

    const handleShowGameweek = async (number) => {
        setCurrentGameweek(number);
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
                                <div className="mgw-points-col gw-table-header">Points</div>
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
                                <div className="mgw-bonus-col gw-table-col">-</div>
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
