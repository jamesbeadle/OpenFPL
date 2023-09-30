import React, { useState, useEffect, useContext } from 'react';
import { Container, Spinner, Row, Col, Card, Tabs, Tab, Badge } from 'react-bootstrap';
import { CombinedIcon } from './icons';
import { AuthContext } from "../contexts/AuthContext";
import { DataContext } from "../contexts/DataContext";
import { OpenFPL_backend as open_fpl_backend } from '../../../declarations/OpenFPL_backend';
import { computeTimeLeft } from './helpers';
import Fixtures from './gameplay/fixtures';

const Homepage = () => {

    const { isAuthenticated } = useContext(AuthContext);
    const { fixtures, systemState, teams } = useContext(DataContext);

    const [isLoading, setIsLoading] = useState(true);
    const [currentSeason, setCurrentSeason] = useState(systemState.activeSeason);
    const [currentGameweek, setCurrentGameweek] = useState(systemState.activeGameweek);
    const [filterSeason, setFilterSeason] = useState(systemState.activeSeason.id);
    const [filterGameweek, setFilterGameweek] = useState(systemState.activeGameweek);
    const [activeKey, setActiveKey] = useState("fixtures");
    
    const [managerCount, setManagerCount] = useState(-1);
    const [nextFixture, setNextFixture] = useState(null);
    const [nextFixtureHomeTeam, setNextFixtureHomeTeam] = useState(null);
    const [nextFixtureAwayTeam, setNextFixtureAwayTeam] = useState(null);
    const [days, setDays] = useState(0);
    const [hours, setHours] = useState(0);
    const [minutes, setMinutes] = useState(0);
    const totalPrizePool = 0; //To be implemented
    
    useEffect(() => {
        const fetchViewData = async () => {
            if (filterSeason == 0 || filterGameweek === 0){
                setIsLoading(false);    
                return;
            } 
            await updateCountdowns();
            setIsLoading(false);
        };
        
        fetchViewData();
    }, [filterSeason, filterGameweek, isAuthenticated]);


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
        const timer = setInterval(updateCountdowns, 1000);
        return () => clearInterval(timer);    
    }, []);

    const updateCountdowns = async () => {
        const sortedFixtures = fixtures.sort((a, b) => Number(a.kickOff) - Number(b.kickOff));
        
        const currentTime = Date.now();
        const fixture = sortedFixtures.find(fixture => Number(fixture.kickOff) > currentTime);
        setNextFixture(fixture);
        setNextFixtureHomeTeam(teams.find(x => x.id == fixture.homeTeamId));
        setNextFixtureAwayTeam(teams.find(x => x.id == fixture.awayTeamId));

        if (fixture) {
            const timeLeft = computeTimeLeft(Number(fixture.kickOff));
            const timeLeftInMillis = 
                timeLeft.days * 24 * 60 * 60 * 1000 + 
                timeLeft.hours * 60 * 60 * 1000 + 
                timeLeft.minutes * 60 * 1000 + 
                timeLeft.seconds * 1000;
            
            const d = -Math.floor(timeLeftInMillis / (1000 * 60 * 60 * 24));
            const h = -Math.floor((timeLeftInMillis % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
            const m = -Math.floor((timeLeftInMillis % (1000 * 60 * 60)) / (1000 * 60));
    
            setDays(d);
            setHours(h);
            setMinutes(m);
        } else {
            setDays(0);
            setHours(0);
            setMinutes(0);
        }
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
                                        <p class="home-stat">{totalPrizePool}</p>
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
                                                <p className="home-stat w-100 text-center">{String(days).padStart(2, '0')}</p>
                                            </Col>
                                            <Col xs={4} className="add-colon">
                                                <p className="home-stat w-100 text-center">{String(hours).padStart(2, '0')}</p>
                                            </Col>
                                            <Col xs={4}>
                                                <p className="home-stat w-100 text-center">{String(minutes).padStart(2, '0')}</p>
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
                                                        primaryColour={nextFixtureHomeTeam.primaryHexColour}
                                                        secondaryColour={nextFixtureHomeTeam.SecondaryHexColour}
                                                        thirdColour={nextFixtureHomeTeam.thirdHexColour}
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
                                                        primaryColour={nextFixtureAwayTeam.primaryHexColour}
                                                        secondaryColour={nextFixtureAwayTeam.SecondaryHexColour}
                                                        thirdColour={nextFixtureAwayTeam.thirdHexColour}
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
                                                    <p className="home-stat-header text-center w-100">{nextFixtureHomeTeam.abbreviatedName}</p>
                                                    </Col>
                                                    <Col xs={2}>
                                                </Col>
                                                    <Col xs={5}>
                                                    <p className="home-stat-header text-center w-100">{nextFixtureAwayTeam.abbreviatedName}</p>  
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
