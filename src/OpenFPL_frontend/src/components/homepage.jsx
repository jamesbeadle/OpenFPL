import React, { useState, useEffect, useContext } from 'react';
import { Container, Spinner, Row, Col, Card, Tabs, Tab } from 'react-bootstrap';
import { CombinedIcon } from './icons';
import { OpenFPL_backend as open_fpl_backend } from '../../../declarations/OpenFPL_backend';
import { AuthContext } from "../contexts/AuthContext";
import { DataContext } from "../contexts/DataContext";
import { computeTimeLeft } from './helpers';
import Fixtures from './fixtures';
import GameweekPoints from './gameweek-points';
import LeagueTable from './league-table';
import Leaderboard from './leaderboard';

const Homepage = () => {

    const { isAuthenticated } = useContext(AuthContext);
    const { fixtures, systemState, teams } = useContext(DataContext);

    const [isLoading, setIsLoading] = useState(true);
    const [currentSeason, setCurrentSeason] = useState(systemState.activeSeason);
    const [currentGameweek, setCurrentGameweek] = useState(systemState.activeGameweek);
    const [activeKey, setActiveKey] = useState("fixtures");
    
    const [managerCount, setManagerCount] = useState(-1);
    const [nextFixtureHomeTeam, setNextFixtureHomeTeam] = useState(null);
    const [nextFixtureAwayTeam, setNextFixtureAwayTeam] = useState(null);
    const [days, setDays] = useState(0);
    const [hours, setHours] = useState(0);
    const [minutes, setMinutes] = useState(0);
    const totalPrizePool = 0;
    
    useEffect(() => {
        if(!isAuthenticated && activeKey == 'gameweek-points'){
            setActiveKey('fixtures');
        }
        const fetchViewData = async () => {
            await updateCountdowns();
            setIsLoading(false);
        };
        
        fetchViewData();
    }, [isAuthenticated]);

    useEffect(() => {
        const fetchManagerCount = async () => {
            try{
                const managerCountData = await open_fpl_backend.getTotalManagers();
                setManagerCount(Number(managerCountData));
            } catch (error){
                console.log(error);
            }
        };

        fetchManagerCount();
        const timer = setInterval(updateCountdowns, 1000 * 60);
        return () => clearInterval(timer);    
    }, []);

    const updateCountdowns = async () => {
        const sortedFixtures = fixtures.sort((a, b) => Number(a.kickOff) - Number(b.kickOff));
        const currentTime = BigInt(Date.now() * 1000000);

        const fixture = sortedFixtures.find(fixture => Number(fixture.kickOff) > currentTime);
        setNextFixtureHomeTeam(teams.find(x => x.id == fixture.homeTeamId));
        setNextFixtureAwayTeam(teams.find(x => x.id == fixture.awayTeamId));
        if (fixture) {
            const timeLeft = computeTimeLeft(Number(fixture.kickOff));
            const timeLeftInMillis = 
                timeLeft.days * 24 * 60 * 60 * 1000 + 
                timeLeft.hours * 60 * 60 * 1000 + 
                timeLeft.minutes * 60 * 1000 + 
                timeLeft.seconds * 1000;
            
            const d = Math.floor(timeLeftInMillis / (1000 * 60 * 60 * 24));
            const h = Math.floor((timeLeftInMillis % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
            const m = Math.floor((timeLeftInMillis % (1000 * 60 * 60)) / (1000 * 60));
    
            setDays(d);
            setHours(h);
            setMinutes(m);
        } else {
            setDays(0);
            setHours(0);
            setMinutes(0);
        }
    };

    return (
        isLoading ? (
            <div className="customOverlay d-flex flex-column align-items-center justify-content-center">
                <Spinner animation="border" />
                <p className='text-center mt-1'>Loading</p>
            </div>
        ) :
        <Container fluid className='view-container mt-2'>
            <Row>
                <Col xxl={7} xs={12}>
                    <Card className='mb-3 mb-lg-0'>
                        <div className="d-flex">
                            <div className="stat-panel flex-grow-1">
                                <Row>
                                    <div className='home-gameweek-col'>
                                        <p className="small-header-stat w-100">Gameweek</p>
                                    </div>
                                    <div className='home-managers-col'>
                                        <p className="small-header-stat w-100">Managers</p>
                                    </div>
                                    <div className='home-prize-col'>
                                        <p className="small-header-stat w-100">Weekly Prize Pool</p>
                                    </div>
                                </Row>
                                <Row>
                                    <div className='home-gameweek-col vertical-flex'>
                                        <p className="header-stat">{currentGameweek}</p>
                                    </div>
                                    <div className='home-managers-col vertical-flex'>
                                        <p className="header-stat">{managerCount === -1 ? '-' : managerCount.toLocaleString()}</p>
                                    </div>
                                    <div className='home-prize-col vertical-flex'>
                                        <p className="header-stat">{totalPrizePool.toLocaleString()}</p>
                                    </div>
                                </Row>
                                <Row>
                                    <div className='home-gameweek-col vertical-flex'>
                                        <p className="small-header-stat">{currentSeason.name}</p>   
                                    </div>
                                    <div className='home-managers-col vertical-flex'>
                                        <p className="small-header-stat">Total</p>    
                                    </div>
                                    <div className='home-prize-col vertical-flex'>
                                        <p className="small-header-stat">$FPL</p>   
                                    </div>
                                </Row>
                            </div>
                            <div className="home-divider-1"></div>
                            <div className="home-divider-2"></div>
                        </div>
                    </Card>
                </Col>

                <Col xxl={5} xs={12} className='mt-lg-4 mt-xxl-0'>
                    <Card>
                        <div className="d-flex">
                            <div className="stat-panel flex-grow-1">  
                                <Row>
                                    <div className='home-deadline-col'>
                                        <p className="small-header-stat w-100">Upcoming Game</p>    
                                    </div>
                                    <div className='home-fixture-col'>
                                         
                                    </div>
                                </Row>
                                <Row>
                                    <div className='home-deadline-col'>
                                        <Row className='countdown'>
                                            <Col xs={4} className="add-colon">
                                                <p className="header-stat">{String(days).padStart(2, '0')}</p>
                                            </Col>
                                            <Col xs={4} className="add-colon">
                                                <p className="header-stat">{String(hours).padStart(2, '0')}</p>
                                            </Col>
                                            <Col xs={4}>
                                                <p className="header-stat">{String(minutes).padStart(2, '0')}</p>
                                            </Col>
                                        </Row>  
                                    </div>
                                    <div className='home-fixture-col p-0'>
                                        <Row>
                                            <Col xs={5}>
                                                <div className='text-center badge w-100 p-0'>
                                                    {nextFixtureHomeTeam && <CombinedIcon
                                                        primary={nextFixtureHomeTeam.primaryColourHex}
                                                        secondary={nextFixtureHomeTeam.SecondaryColourHex}
                                                        third={nextFixtureHomeTeam.thirdColourHex}
                                                    />}
                                                </div>
                                            </Col>
                                            <Col xs={2}>
                                                <p className="w-100 vs p-0">vs</p>
                                            </Col>
                                            <Col xs={5}>
                                                <div className='text-center badge w-100 p-0'>
                                                {nextFixtureAwayTeam && <CombinedIcon
                                                        primary={nextFixtureAwayTeam.primaryColourHex}
                                                        secondary={nextFixtureAwayTeam.SecondaryColourHex}
                                                        third={nextFixtureAwayTeam.thirdColourHex}
                                                    />}
                                                </div>
                                            </Col>
                                        </Row>
                                    </div>
                                </Row>
                                <Row>
                                    <div className='home-deadline-col'>
                                        <Row>
                                            <Col xs={4}>
                                                <p className="small-header-stat w-100">Day</p> 
                                            </Col>
                                            <Col xs={4}>
                                                <p className="small-header-stat w-100">Hour</p>   
                                            </Col>
                                            <Col xs={4}>
                                                <p className="small-header-stat w-100">Min</p>    
                                            </Col>
                                        </Row>
                                    </div>
                                    <div className='home-fixture-col p-0'>
                                        <Row>
                                            <Col xs={5}>
                                                {nextFixtureHomeTeam && <p className="small-header-stat text-center w-100">{nextFixtureHomeTeam.abbreviatedName}</p>}
                                                </Col>
                                                <Col xs={2}>
                                            </Col>
                                            <Col xs={5}>
                                                {nextFixtureAwayTeam && <p className="small-header-stat text-center w-100">{nextFixtureAwayTeam.abbreviatedName}</p>  }
                                            </Col>
                                        </Row>
                                    </div>
                                </Row>
                            </div>
                            <div className="home-divider-3"></div>
                        </div>
                    </Card>
                </Col>
            </Row>
            
            <Row className="mt-3">
                <Col xs={12}>
                    <Card>
                        <div className="d-flex">
                            <div className="flex-grow-1 light-background top-border-radius">
                                <Tabs className="tab-header" defaultActiveKey="fixtures" id="homepage-tabs" activeKey={activeKey} onSelect={k => setActiveKey(k)}>
                                    <Tab className="bottom-border-radius" eventKey="fixtures" title="Fixtures">
                                        {activeKey === 'fixtures' && <Fixtures />}
                                    </Tab>
                                    {isAuthenticated && 
                                        <Tab eventKey="gameweek-points" title="Gameweek Points">
                                            {activeKey === 'gameweek-points' && <GameweekPoints />}
                                        </Tab>
                                    }
                                    <Tab eventKey="leaderboards" title="Leaderboards">
                                        {activeKey === 'leaderboards' && <Leaderboard />}
                                    </Tab>
                                    <Tab eventKey="league-table" title="League Table">
                                        {activeKey === 'league-table' && <LeagueTable />}
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
