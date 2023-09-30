import React, { useState, useEffect, useContext } from 'react';
import { Container, Row, Col, Card, Button, Spinner } from 'react-bootstrap';
import { DataContext } from "../../contexts/DataContext";
import { getTeamById,groupFixturesByDate, computeTimeLeft } from '../helpers';
import { BadgeIcon, ClockIcon, ArrowLeft, ArrowRight } from '../icons';

const Fixtures = () => {
  const { teams, fixtures, systemState } = useContext(DataContext);
  const [isLoading, setIsLoading] = useState(true);
  const [currentGameweek, setCurrentGameweek] = useState(1);
  const [filteredFixtures, setFilteredFixtures] = useState([]);
  
  useEffect(() => {
    const fetchData = async () => {
      await fetchViewData();
      setIsLoading(false);
    };
    fetchData();
  }, []);
  
  const fetchViewData = async () => {
  
    const currentDateTime = new Date();
    const currentGameweekFixtures = fixtures.filter(fixture => fixture.gameweek === systemState.activeGameweek);
    currentGameweekFixtures.sort((a, b) => Number(a.kickOff) - Number(b.kickOff));

    const kickOffInMilliseconds = Number(currentGameweekFixtures[0].kickOff) / 1000000;
    const firstFixtureTime = new Date(kickOffInMilliseconds);
   
    const oneHourBeforeFirstFixture = new Date(firstFixtureTime - 3600000); // Subtract 1 hour from the fixture's start time
   
    if (currentDateTime >= oneHourBeforeFirstFixture) {
        setCurrentGameweek(systemState.activeGameweek + 1);
    }
    else{
      setCurrentGameweek(systemState.activeGameweek);  
    }
  };


  useEffect(() => {
    const filteredFixturesData = fixtures.filter(fixture => fixture.gameweek === currentGameweek);
    setFilteredFixtures(groupFixturesByDate(filteredFixturesData));
  }, [fixtures, currentGameweek]);

  const handleGameweekChange = (change) => {
    setCurrentGameweek(prev => Math.min(38, Math.max(1, prev + change)));
  }

  
    
  const renderStatusBadge = (fixture) => {
    const currentTime = new Date().getTime();
    const kickoffTime = computeTimeLeft(Number(fixture.kickOff));
    const oneHourInMilliseconds = 3600000;

    if (fixture.status === 0 && kickoffTime - currentTime <= oneHourInMilliseconds) {
        return (
            <p className="status-text pregame">Pre-Game</p>
        );
    }

    switch (fixture.status) {
        case 1:
            return (
              <p className="status-text fixture-active">Active</p>
            );
        case 2:
            return (
              <p className="status-text fixture-consensus">In Consensus</p>
            );
        case 3:
            return (
              <p className="status-text fixture-verified">Verified</p>
            );
    }
    return (<p className="status-text fixture-unplayed">Unplayed</p>
    );
  };
  
  
  return (
      <>
        {isLoading ? (
          <div className="d-flex flex-column align-items-center justify-content-center">
            <Spinner animation="border" />
            <p className='text-center mt-1'>Loading Fixtures</p>
          </div>) 
          :
          <div className="dark-tab-row w-100 mx-0">
            <Row>
              <Col md={12} className="mt-3 mb-2">
                <div className='px-4' style={{ display: 'flex', justifyContent: 'left', alignItems: 'left' }}>
                  <div>
                    <Button className="w-100 justify-content-center fpl-btn" onClick={() => handleGameweekChange(-1)} disabled={currentGameweek === 1} 
                      style={{ marginRight: '10px' }} >
                      <ArrowLeft />
                    </Button>
                  </div>
                  <div>
                    <small>Season {currentGameweek}</small>
                  </div>
                  <div style={{ marginRight: 50}}>
                    <Button className="w-100 justify-content-center fpl-btn" onClick={() => handleGameweekChange(1)} disabled={currentGameweek === 38} 
                      style={{ marginLeft: '10px' }} >
                      <ArrowRight />
                    </Button>
                  </div>
                  <div>
                    <Button className="w-100 justify-content-center fpl-btn" onClick={() => handleGameweekChange(-1)} disabled={currentGameweek === 1}
                      style={{ marginRight: '10px' }} >
                      <ArrowLeft />
                    </Button>
                  </div>
                  <div>
                    <small>Gameweek {currentGameweek}</small>
                  </div>
                  <div>
                    <Button className="w-100 justify-content-center fpl-btn" onClick={() => handleGameweekChange(1)} disabled={currentGameweek === 38}
                      style={{ marginLeft: '10px' }} >
                      <ArrowRight />
                    </Button>
                  </div>
                </div>
              </Col>
            </Row>

            <Row>
              {Object.entries(filteredFixtures).map(([date, fixturesForDate], dateIdx) => {
                return (
                    <Container key={dateIdx}>
                      <Row>
                        <Col xs={12}>
                          <div className='light-background date-row w-100'>
                            <p className="w-100 date-header mt-2">{date}</p>
                          </div>
                        </Col>  
                      </Row>
                        
                        {fixturesForDate.map((fixture, idx) => {
                            const homeTeam = getTeamById(teams, fixture.homeTeamId);
                            const awayTeam = getTeamById(teams, fixture.awayTeamId);
                            if (!homeTeam || !awayTeam) {
                                console.error("One of the teams is missing for fixture: ", fixture);
                                return null;
                            }
                            return (
                              <Row>
                                <Col xs={12}>
                                  <div className='table-row w-100'>
                                    <Row key={fixture.id}>
                                      <Col xs={2}>
                                        <p>
                                          <BadgeIcon
                                              primaryColour={'#123432'}
                                              secondaryColour={'#432123'}
                                              thirdColour={'#432123'}
                                              width={26}
                                              height={26}
                                              marginRight={10}
                                          />
                                        {getTeamById(teams, fixture.homeTeamId).friendlyName}</p>
                                      </Col>
                                      <Col xs={1}>
                                        <p className="w-100 text-center">vs</p>
                                      </Col>
                                      <Col xs={1}></Col>
                                      <Col xs={2}>
                                        <p>
                                          <BadgeIcon
                                              primaryColour={'#123432'}
                                              secondaryColour={'#432123'}
                                              thirdColour={'#432123'}
                                              width={26}
                                              height={26}
                                              marginRight={10}
                                          />
                                        {getTeamById(teams, fixture.awayTeamId).friendlyName}</p>

                                      </Col>
                                      <Col xs={4}>
                                        <p>
                                      <ClockIcon
                                              primaryColour={'#123432'}
                                              secondaryColour={'#432123'}
                                              thirdColour={'#432123'}
                                              marginRight={10}
                                          /> 05:30AM</p>
                                      </Col>
                                      <Col xs={1}>
                                        {renderStatusBadge(fixture)}
                                      </Col>

                                  </Row>
                                  </div>
                                </Col>  
                              </Row>
                            );
                        })}
                    </Container>
                );
              })}

            </Row>
          </div>
      }
      </>
  );
};

export default Fixtures;
