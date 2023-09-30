import React, { useState, useEffect, useContext } from 'react';
import { Container, Spinner, Row, Col, Card, Tabs, Tab, Badge, Table, Button, Pagination } from 'react-bootstrap';
import { BadgeIcon, CombinedIcon } from './icons';
import { AuthContext } from "../contexts/AuthContext";
import { DataContext } from "../contexts/DataContext";
import { OpenFPL_backend as open_fpl_backend } from '../../../declarations/OpenFPL_backend';
import { Link } from "react-router-dom";
import { msToTime, computeTimeLeft, getTeamById, groupFixturesByDate } from './helpers';
import Fixtures from './gameplay/fixtures';

const Homepage = () => {

    const { userPrincipal, isAuthenticated } = useContext(AuthContext);
    const { teams, fixtures, systemState, seasonLeaderboard, weeklyLeaderboard } = useContext(DataContext);

    const [isLoading, setIsLoading] = useState(true);
    const [managerCount, setManagerCount] = useState(-1);
    const [seasonTop10, setSeasonTop10] = useState([]);
    const [weeklyTop10, setWeeklyTop10] = useState([]);
    const [filterGameweek, setFilterGameweek] = useState(systemState.activeGameweek);
    const [isActiveGameweek, setIsActiveGameweek] = useState(false);
    const [countdown, setCountdown] = useState(0);

    const [currentGameweek, setCurrentGameweek] = useState(systemState.activeGameweek);
    const [currentSeason, setCurrentSeason] = useState(systemState.activeSeason);
    const [groupedFixtures, setGroupedFixtures] = useState([]);
    const totalPrizePool = 0;
    const [activeKey, setActiveKey] = useState("fixtures");

    
    useEffect(() => {
        if (!fixtures || fixtures.length === 0) {
            return;
        }
        setGroupedFixtures(groupFixturesByDate(getCurrentGameweekFixtures()));
        const fetchViewData = async () => {
            if (filterGameweek === 0) return;

            await updateCountdowns();
            setIsLoading(false);
        };
        
        fetchViewData();
    }, [filterGameweek, fixtures, isAuthenticated]);

    useEffect(() => {
        const fetchViewData = async () => {
            if(Object.keys(seasonLeaderboard).length === 0 || Object.keys(weeklyLeaderboard).length === 0) { return; }
            await updateManagerData();
        };
        
        fetchViewData();
    }, [seasonLeaderboard, weeklyLeaderboard]);

    useEffect(() => {
        const timer = setInterval(updateCountdowns, 1000);
        return () => clearInterval(timer);
    }, [filterGameweek, fixtures]);

    const updateCountdowns = async () => {
        const currentFixtures = getCurrentGameweekFixtures();
        const kickOffs = currentFixtures.map(fixture => computeTimeLeft(Number(fixture.kickOff)));
    
        const kickOffsInMillis = kickOffs.map(obj => 
            obj.days * 24 * 60 * 60 * 1000 + 
            obj.hours * 60 * 60 * 1000 + 
            obj.minutes * 60 * 1000 + 
            obj.seconds * 1000
        );
    
        const timeUntilGameweekBegins = Math.min(...kickOffsInMillis) - 3600000;
        
        if (timeUntilGameweekBegins > 0) {
            setCountdown(msToTime(timeUntilGameweekBegins));
            setIsActiveGameweek(false);
        } else {
            setCountdown(msToTime(0));
            setIsActiveGameweek(true);
        }
    };

    const updateManagerData = async () => {
        try {
            const managerCountData = await open_fpl_backend.getTotalManagers();
            setManagerCount(Number(managerCountData));
    
            const seasonTop10Data = seasonLeaderboard.entries.slice(0, 10);
            setSeasonTop10(seasonTop10Data);
            
            const weeklyTop10Data = weeklyLeaderboard.entries.slice(0, 10).map(entry => ({
                ...entry,
                seasonId: weeklyLeaderboard.seasonId,
                gameweek: weeklyLeaderboard.gameweek
            }));
            
            setWeeklyTop10(weeklyTop10Data);
        } catch (error) {
            console.error(error);
        }
    };

    const getCurrentGameweekFixtures = () => {
        return fixtures.filter(fixture => fixture.gameweek === filterGameweek);
    };

    const handlePrevGameweek = () => {
        if (filterGameweek > 1) {
            setFilterGameweek(prevGameweek => prevGameweek - 1);
        }
      };
      
      const handleNextGameweek = () => {
        if (filterGameweek < 38) {
            setFilterGameweek(nextGameweek => nextGameweek + 1);
        }
      };
    
    const renderStatusBadge = (fixture) => {
        const currentTime = new Date().getTime();
        const kickoffTime = computeTimeLeft(Number(fixture.kickOff));
        const oneHourInMilliseconds = 3600000;
    
        if (fixture.status === 0 && kickoffTime - currentTime <= oneHourInMilliseconds) {
            return (
                <Badge className='bg-warning w-100' style={{ padding: '0.5rem' }}>Pre-Game</Badge>
            );
        }
    
        switch (fixture.status) {
            case 1:
                return (
                    <Badge className='bg-info w-100' style={{ padding: '0.5rem' }}>Active</Badge>
                );
            case 2:
                return (
                    <Badge className='bg-success w-100' style={{ padding: '0.5rem' }}>In Consensus</Badge>
                );
            case 3:
                return (
                    <Badge className='bg-primary w-100' style={{ padding: '0.5rem' }}>Verified</Badge>
                );
        }
    };
    

    return (
        isLoading ? (
            <div className="customOverlay d-flex flex-column align-items-center justify-content-center">
                <Spinner animation="border" />
                <p className='text-center mt-1'>Loading</p>
            </div>
        ) :
        <Container fluid>
            <Row>
                <Col md={7} xs={12}>
                    <Card className='mb-3'>
                        <div className="outer-container d-flex">
                            <div className="home-stat-panel flex-grow-1">
                                
                                <Row className="stat-row-1">
                                    <Col xs={4}>
                                        <p style={{paddingLeft: '40px'}} class="home-stat-header w-100">Gameweek</p>
                                    </Col>
                                    <Col xs={5}>
                                        <p class="home-stat-header w-100">Managers</p>
                                    </Col>
                                    <Col xs={3}>
                                        <p class="home-stat-header w-100">Weekly Prize Pool</p>
                                    </Col>
                                </Row>
                                <Row className="stat-row-2">
                                    <Col xs={4}>
                                        <p style={{paddingLeft: '40px'}} class="home-stat">{currentGameweek}</p>
                                    </Col>
                                    <Col xs={5}>
                                        <p class="home-stat">{managerCount === -1 ? '-' : managerCount.toLocaleString()}</p>
                                    </Col>
                                    <Col xs={3}>
                                        <p class="home-stat">12,242</p>
                                    </Col>
                                </Row>
                                <Row className="stat-row-3">
                                    <Col xs={4}>
                                        <p style={{paddingLeft: '40px'}} class="home-stat-header">{currentSeason.name}</p>   
                                    </Col>
                                    <Col xs={5}>
                                        <p class="home-stat-header">Total</p>    
                                    </Col>
                                    <Col xs={3}>
                                        <p class="home-stat-header">$FPL Tokens</p>   
                                    </Col>
                                </Row>
                            </div>
                            <div className="d-none d-md-block vertical-divider-1"></div>
                            <div className="d-none d-md-block vertical-divider-2"></div>
                        </div>
                    </Card>
                </Col>

                <Col md={5} xs={12}>
                    <Card>
                        <div className="outer-container d-flex">
                            <div class="home-stat-panel flex-grow-1">  
                                <Row className="stat-row-2">
                                    <Col xs={12} md={6}>    
                                        <Row className="stat-row-1">
                                            <p style={{paddingLeft: '32px'}} class="home-stat-header w-100">Upcoming Game</p>    
                                        </Row>
                                        <Row>
                                            <Col xs={4} className="add-colon">
                                                <p className="home-stat w-100 text-center">02</p>
                                            </Col>
                                            <Col xs={4} className="add-colon">
                                            <p className="home-stat w-100 text-center">02</p>

                                            </Col>
                                            <Col xs={4}>
                                            <p className="home-stat w-100 text-center">02</p>
                                    
                                            </Col>
                                        </Row>
                                        <Row className="stat-row-3">
                                            
                                        <Col xs={12}>
                                                <Row>
                                                    <Col xs={4}>
                                                        <p className="home-stat-header text-center w-100">Day</p> 
                                                    </Col>
                                                    <Col xs={4}>
                                                        <p className="home-stat-header text-center w-100">Hour</p>   
                                                    </Col>
                                                    <Col xs={4}>
                                                        <p className="home-stat-header text-center w-100">Min</p>    
                                                    </Col>
                                                </Row>
                                            </Col>
                                        </Row>
                                    </Col>
                                    <Col xs={12} md={6} className="mt-4 mt-md-0">
                                        <Row>
                                            <Col xs={5}>
                                                <div className='text-center badge w-100'>
                                                    <CombinedIcon
                                                        primaryColour={'#123432'}
                                                        secondaryColour={'#432123'}
                                                        thirdColour={'#432123'}
                                                        width={80}
                                                        height={80}
                                                    />
                                                </div>
                                            </Col>
                                            <Col xs={2}>
                                                <p className="w-100 time-colon">vs</p>
                                            </Col>
                                            <Col xs={5}>
                                                <div className='text-center badge w-100'>
                                                    <CombinedIcon
                                                        primaryColour={'#123432'}
                                                        secondaryColour={'#432123'}
                                                        thirdColour={'#432123'}
                                                        width={80}
                                                        height={80}
                                                    />
                                                </div>
                                            </Col>
                                        </Row>
                                        <Row className="stat-row-3">
                                            <Col xs={12}>
                                                <Row>
                                                    <Col xs={5}>
                                                    <p className="home-stat-header text-center w-100">MUN</p>
                                                    </Col>
                                                    <Col xs={2}>
                                                </Col>
                                                    <Col xs={5}>
                                                    <p className="home-stat-header text-center w-100">LVP</p>  
                                                    </Col>
                                                </Row>
                                            </Col>
                                        </Row>
                                    </Col>
                                </Row>
                            </div>
                            <div className="d-none d-md-block vertical-divider-3"></div>
                        </div>
                    </Card>
                </Col>
            </Row>
            
            <Row className="mt-2">
                <Col xs={12}>
                    <Card>
                        <div className="outer-container d-flex">
                            <div className="flex-grow-1 light-background">
                                <Tabs className="home-tab-header" defaultActiveKey="fixtures" id="homepage-tabs" activeKey={activeKey} onSelect={k => setActiveKey(k)}>
                                
                                    <Tab eventKey="fixtures" title="Fixtures">
                                        {activeKey === 'fixtures' && <Fixtures />}
                                    </Tab>
                                    <Tab eventKey="gameweek-points" title="Gameweek Points">
                                    </Tab>
                                    <Tab eventKey="leaderboards" title="Leaderboards">
                                    </Tab>
                                    <Tab eventKey="league-table" title="League Table">
                                    </Tab>
                                </Tabs>
                            </div>
                        </div>
                    </Card>
                </Col>
            </Row>
        </Container>
    );
};

export default Homepage;
