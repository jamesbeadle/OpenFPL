import React, { useState, useEffect, useContext, useRef } from 'react';
import { Row, Col, Dropdown, Button, Spinner } from 'react-bootstrap';
import { DataContext } from "../contexts/DataContext";
import { ArrowLeft, ArrowRight } from './icons';

const GameweekPoints = () => {
  const { seasons, systemState } = useContext(DataContext);
  const [isLoading, setIsLoading] = useState(true);
  const [currentGameweek, setCurrentGameweek] = useState(systemState.focusGameweek);
  
  const [currentSeason, setCurrentSeason] = useState(systemState.activeSeason);
  const [showGameweekDropdown, setShowGameweekDropdown] = useState(false);
  const [showSeasonDropdown, setShowSeasonDropdown] = useState(false);
  const gameweekDropdownRef = useRef(null);
  const seasonDropdownRef = useRef(null);

  const handleGameweekBlur = (e) => {
    const currentTarget = e.currentTarget;
    if (!currentTarget.contains(document.activeElement)) {
      setShowGameweekDropdown(false);
    }
  };
  
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
  
  };

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
        fetchGameweekPoints(newFixtures);
      } else {
        fetchGameweekPoints(null, null);
      }
    }
  };
  
  const fetchGameweekPoints = async (seasonId, gameweek) => {
    try{
      return await open_fpl_backend.getGameweekPoints(seasonId, gameweek);
    }
    catch (error){
      console.log(error);
    }
  };
  
  const openGameweekDropdown = () => {
    setShowGameweekDropdown(!showGameweekDropdown);
    setTimeout(() => {
      if (gameweekDropdownRef.current) {
        const item = gameweekDropdownRef.current.querySelector(`[data-key="${currentGameweek - 1}"]`);
        if (item) {
          item.scrollIntoView({ block: 'nearest', inline: 'nearest' });
        }
      }
    }, 0);
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
                    <Button className="w-100 justify-content-center fpl-btn" onClick={() => handleGameweekChange(-1)} disabled={currentGameweek === 1}
                      style={{ marginRight: '16px' }} >
                      <ArrowLeft />
                    </Button>
                  </div>
                  <div style={{ display: 'flex', alignItems: 'center' }}>
                    <div ref={gameweekDropdownRef} onBlur={handleGameweekBlur}>
                      <Dropdown show={showGameweekDropdown}>
                        <Dropdown.Toggle as={CustomToggle} id="gameweek-selector">
                          <Button className='filter-dropdown-btn' style={{ backgroundColor: 'transparent' }} onClick={() => openGameweekDropdown()}>Gameweek {currentGameweek}</Button>
                        </Dropdown.Toggle>
                        <Dropdown.Menu style={{ maxHeight: '200px', overflowY: 'auto' }}>
                          {Array.from({ length: 38 }, (_, index) => (
                            <Dropdown.Item
                              data-key={index}
                              className='dropdown-item'
                              key={index}
                              onMouseDown={() => {setCurrentGameweek(index + 1)}}
                            >
                              Gameweek {index + 1} {currentGameweek === (index + 1) ? ' ✔️' : ''}
                            </Dropdown.Item>
                          ))}
                        </Dropdown.Menu>
                      </Dropdown>
                    </div>
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
                    <div ref={seasonDropdownRef} onBlur={handleSeasonBlur}>
                      <Dropdown show={showSeasonDropdown}>
                        <Dropdown.Toggle as={CustomToggle} id="gameweek-selector">
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

            <Container key={player.id}>
                <Row>
                <Col xs={12}>
                    <div className='light-background table-header-row w-100'  style={{ display: 'flex', alignItems: 'center' }}>
                        <div>Pos</div>
                        <div>Player Name</div>
                        <div>Club</div>
                        <div>A</div>
                        <div>HSP</div>
                        <div>GS</div>
                        <div>GA</div>
                        <div>PS</div>
                        <div>CS</div>
                        <div>S</div>
                        <div>YC</div>
                        <div>OG</div>
                        <div>GC</div>
                        <div>MP</div>
                        <div>RC</div>
                    </div>
                </Col>  
                </Row>


                
              {teamEntries.map(player => {
                return (
                        
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

export default GameweekPoints;
