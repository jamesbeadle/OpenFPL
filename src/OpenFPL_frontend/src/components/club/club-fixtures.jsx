import React, { useState, useEffect, useContext, useRef } from 'react';
import { Container, Row, Col, Dropdown, Button, Spinner } from 'react-bootstrap';
import { DataContext } from "../../contexts/DataContext";
import { getTeamById, computeTimeLeft } from '../helpers';
import { BadgeIcon, ClockIcon, ArrowLeft, ArrowRight } from '../icons';

const ClubFixtures = ({teamId}) => {
  const { teams, seasons, fixtures, systemState } = useContext(DataContext);
  const [isLoading, setIsLoading] = useState(true);
  const [currentSeason, setCurrentSeason] = useState(systemState.activeSeason);
  const [filteredFixtures, setFilteredFixtures] = useState([]);
  const [fetchedFixtures, setFetchedFixtures] = useState(null); 
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
  }, []);
  
  const fetchViewData = async () => {
    console.log(teamId)
  };

  useEffect(() => {
    const source = fetchedFixtures || fixtures;
    const filteredFixturesData = source.filter(fixture => fixture.homeTeamId === teamId || fixture.awayTeamId === teamId);
    setFilteredFixtures(filteredFixturesData);
  }, [fixtures, fetchedFixtures]);
  
  const handleSeasonChange = async (change) => {
    const newIndex = seasons.findIndex(season => season.id === currentSeason.id) + change;
    if (newIndex >= 0 && newIndex < seasons.length) {
      setCurrentSeason(seasons[newIndex]);
      
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
            <p className='text-center mt-1'>Loading Fixtures</p>
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
                                {(() => {
                                  const homeTeam = getTeamById(teams, fixture.homeTeamId);
                                  const awayTeam = getTeamById(teams, fixture.awayTeamId);
                                  return (
                                    <>
                                      <div className="col-home-team">
                                        <p className='fixture-team-name'>
                                          <BadgeIcon
                                            primary={homeTeam.primaryColourHex}
                                            secondary={homeTeam.secondaryColourHex}
                                            third={homeTeam.thirdColourHex}
                                            width={48}
                                            height={48}
                                            marginRight={16}
                                          />
                                          {homeTeam.friendlyName}
                                        </p>
                                      </div>
                                      <div className="col-vs">
                                        <p className="w-100 text-center">vs</p>
                                      </div>
                                      <div className="col-away-team">
                                        <p className='fixture-team-name'>
                                          <BadgeIcon
                                            primary={awayTeam.primaryColourHex}
                                            secondary={awayTeam.secondaryColourHex}
                                            third={awayTeam.thirdColourHex}
                                            width={48}
                                            height={48}
                                            marginRight={16}
                                          />
                                          {awayTeam.friendlyName}
                                        </p>
                                      </div>
                                    </>
                                  );
                                })()}

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

export default ClubFixtures;
