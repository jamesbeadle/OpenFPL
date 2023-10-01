import React, { useState, useEffect, useContext } from 'react';
import { Container, Row, Col, Card, Button, Spinner } from 'react-bootstrap';
import { DataContext } from "../../contexts/DataContext";
import { getTeamById,groupFixturesByDate, computeTimeLeft } from '../helpers';
import { BadgeIcon, ClockIcon, ArrowLeft, ArrowRight } from '../icons';

const Fixtures = () => {
  const { teams, seasons, fixtures, systemState } = useContext(DataContext);
  const [isLoading, setIsLoading] = useState(true);
  const [currentGameweek, setCurrentGameweek] = useState(systemState.activeGameweek);
  const [currentSeason, setCurrentSeason] = useState(systemState.activeSeason);
  const [filteredFixtures, setFilteredFixtures] = useState([]);
  const [fetchedFixtures, setFetchedFixtures] = useState(null); 
  
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
   
    const oneHourBeforeFirstFixture = new Date(firstFixtureTime - 3600000);
   
    if (currentDateTime >= oneHourBeforeFirstFixture) {
        setCurrentGameweek(systemState.activeGameweek + 1);
    }
    else{
      setCurrentGameweek(systemState.activeGameweek);  
    }
  };

  useEffect(() => {
    const source = fetchedFixtures || fixtures;
    const filteredFixturesData = source.filter(fixture => fixture.gameweek === currentGameweek);
    setFilteredFixtures(groupFixturesByDate(filteredFixturesData));
  }, [fixtures, currentGameweek, fetchedFixtures]);

  const handleGameweekChange = (change) => {
    setCurrentGameweek(prev => Math.min(38, Math.max(1, prev + change)));
  };
  
  const handleSeasonChange = async (change) => {
    const newIndex = seasons.findIndex(season => season.id === currentSeason.id) + change;
    if (newIndex >= 0 && newIndex < seasons.length) {
      setCurrentSeason(seasons[newIndex]);
      setCurrentGameweek(1);
      
      if (seasons[newIndex].id !== systemState.activeSeason.id) {
        const newFixtures = await fetchFixturesForSeason(seasons[newIndex].id);
        setFetchedFixtures(newFixtures);
      } else {
        setFetchedFixtures(null);
      }
    }
  };
  
  const fetchFixturesForSeason = async (seasonId) => {
    try{
      return await open_fpl_backend.getFixturesForSeason(seasonId);
    }
    catch (error){
      console.log(error);
    }
  };
    
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
              <Col md={12}>
                <div className='filter-row' style={{ display: 'flex', justifyContent: 'left', alignItems: 'left' }}>
                  <div style={{ display: 'flex', alignItems: 'center' }}>
                    <Button className="w-100 justify-content-center fpl-btn" onClick={() => handleGameweekChange(-1)} disabled={currentGameweek === 1}
                      style={{ marginRight: '16px' }} >
                      <ArrowLeft />
                    </Button>
                  </div>
                  <div style={{ display: 'flex', alignItems: 'center' }}>
                    <small>Gameweek {currentGameweek}</small>
                  </div>
                  <div style={{display: 'flex', alignItems: 'center', marginRight: 50}}>
                    <Button className="w-100 justify-content-center fpl-btn" onClick={() => handleGameweekChange(1)} disabled={currentGameweek === 38}
                      style={{ marginLeft: '16px' }} >
                      <ArrowRight />
                    </Button>
                  </div>
                  <div style={{ display: 'flex', alignItems: 'center' }}>
                    <Button className="w-100 justify-content-center fpl-btn"  onClick={() => handleSeasonChange(-1)} disabled={currentSeason.id === seasons[0].id} 
                      style={{ marginRight: '16px' }} >
                      <ArrowLeft />
                    </Button>
                  </div>
                  <div style={{ display: 'flex', alignItems: 'center' }}>
                    <small>{currentSeason.name}</small>
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
              {Object.entries(filteredFixtures).map(([date, fixturesForDate], dateIdx) => {
                return (
                    <Container key={dateIdx}>
                      <Row>
                        <Col xs={12}>
                          <div className='light-background date-row w-100'  style={{ display: 'flex', alignItems: 'center' }}>
                            <p className="w-100 date-header">{date}</p>
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
                              <div className="table-row" key={fixture.id}>
                                <div className="col-home-team">
                                  <p className='fixture-team-name'>
                                            <BadgeIcon
                                                primaryColour={'#123432'}
                                                secondaryColour={'#432123'}
                                                thirdColour={'#432123'}
                                                width={48}
                                                height={48}
                                                marginRight={16}
                                            />
                                          {getTeamById(teams, fixture.homeTeamId).friendlyName}
                                    </p>
                                </div>
                                <div className="col-vs">
                                  <p className="w-100 text-center">vs</p>
                                </div>
                                <div className="col-away-team">
                                  <p className='fixture-team-name'>
                                    <BadgeIcon
                                          primaryColour={'#123432'}
                                          secondaryColour={'#432123'}
                                          thirdColour={'#432123'}
                                          width={48}
                                          height={48}
                                          marginRight={16}
                                      />
                                    {getTeamById(teams, fixture.awayTeamId).friendlyName}</p>
                                </div>
                                <div className="col-time">
                                <p>
                                  <ClockIcon
                                                primaryColour={'#123432'}
                                                secondaryColour={'#432123'}
                                                thirdColour={'#432123'}
                                                marginRight={10}
                                                width={20}
                                                height={20}
                                            /> 05:30AM</p>
                                </div>
                                  <div className="col-badge">
                                {renderStatusBadge(fixture)}
                               </div>
                              </div>
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
