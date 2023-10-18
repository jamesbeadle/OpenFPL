import React, { useState, useEffect, useContext, useRef } from 'react';
import { Button, Spinner, Container, Row, Col, Dropdown } from 'react-bootstrap';
import { BadgeIcon, ArrowLeft, ArrowRight } from './icons';
import { DataContext } from "../contexts/DataContext";
import { getTeamById, CustomToggle } from './helpers';
import { useNavigate } from 'react-router-dom';

const LeagueTable = () => {
    const { teams, seasons, fixtures, systemState } = useContext(DataContext);
    const [isLoading, setIsLoading] = useState(true);
    const [currentSeason, setCurrentSeason] = useState(systemState.activeSeason);
    const [currentGameweek, setCurrentGameweek] = useState(systemState.activeGameweek);
    const [tableData, setTableData] = useState([]);
    const [showGameweekDropdown, setShowGameweekDropdown] = useState(false);
    const [showSeasonDropdown, setShowSeasonDropdown] = useState(false);
    const gameweekDropdownRef = useRef(null);
    const seasonDropdownRef = useRef(null);
    const navigate = useNavigate();
    
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
        if(fixtures.length == 0){
            return;
        }
        updateTableData();
    }, [currentSeason, currentGameweek, fixtures]);

    const updateTableData = () => {
        setIsLoading(true);
        const initTeamData = (teamId, table) => {
            if (!table[teamId]) {
                table[teamId] = {
                    teamId,
                    played: 0,
                    wins: 0,
                    draws: 0,
                    losses: 0,
                    goalsFor: 0,
                    goalsAgainst: 0,
                    points: 0
                };
            }
        };
    
        let tempTable = {};
        
        const relevantFixtures = fixtures.filter(fixture => 
            fixture.status === 3 && fixture.gameweek <= currentGameweek);
    
        for (let fixture of relevantFixtures) {
            initTeamData(fixture.homeTeamId, tempTable);
            initTeamData(fixture.awayTeamId, tempTable);
            tempTable[fixture.homeTeamId].id = fixture.homeTeamId;
            tempTable[fixture.awayTeamId].id = fixture.awayTeamId;
    
            tempTable[fixture.homeTeamId].played++;
            tempTable[fixture.awayTeamId].played++;
    
            tempTable[fixture.homeTeamId].goalsFor += fixture.homeGoals;
            tempTable[fixture.homeTeamId].goalsAgainst += fixture.awayGoals;
            
            tempTable[fixture.awayTeamId].goalsFor += fixture.awayGoals;
            tempTable[fixture.awayTeamId].goalsAgainst += fixture.homeGoals;
    
            if (fixture.homeGoals > fixture.awayGoals) {
                tempTable[fixture.homeTeamId].wins++;
                tempTable[fixture.homeTeamId].points += 3;
    
                tempTable[fixture.awayTeamId].losses++;
            } else if (fixture.homeGoals === fixture.awayGoals) {
                tempTable[fixture.homeTeamId].draws++;
                tempTable[fixture.homeTeamId].points += 1;
    
                tempTable[fixture.awayTeamId].draws++;
                tempTable[fixture.awayTeamId].points += 1;
            } else {
                tempTable[fixture.awayTeamId].wins++;
                tempTable[fixture.awayTeamId].points += 3;
    
                tempTable[fixture.homeTeamId].losses++;
            }
        }
    
        const sortedTableData = Object.values(tempTable).sort((a, b) => {
            if (b.points !== a.points) return b.points - a.points;

            const goalDiffA = a.goalsFor - a.goalsAgainst;
            const goalDiffB = b.goalsFor - b.goalsAgainst;

            if (goalDiffB !== goalDiffA) return goalDiffB - goalDiffA;
            if (b.goalsFor !== a.goalsFor) return b.goalsFor - a.goalsFor;

            return a.goalsAgainst - b.goalsAgainst;
        });
        
        setTableData(sortedTableData);
        setIsLoading(false);
    };

    const loadClub = async (clubId) => {
      navigate(`/club/${clubId}`);
    };

      
    const handleGameweekChange = (change) => {
      setCurrentGameweek(prev => Math.min(38, Math.max(1, prev + change)));
    };
    
    const handleSeasonChange = async (change) => {
      const newIndex = seasons.findIndex(season => season.id === currentSeason.id) + change;
      if (newIndex >= 0 && newIndex < seasons.length) {
        setCurrentSeason(seasons[newIndex]);
        setCurrentGameweek(1);
      }
    };

    return (
        isLoading ? (
        <div className="d-flex flex-column align-items-center justify-content-center">
            <Spinner animation="border" />
            <p className='text-center mt-1'>Loading League Table</p>
        </div>) 
        :
        <div className="dark-tab-row w-100 mx-0">
          <Row>
            <Col md={12}>
              <div className='filter-row' style={{ display: 'flex', justifyContent: 'left', alignItems: 'left' }}>
                <div style={{ display: 'flex', alignItems: 'center' }}>
                  <Button className="w-100 justify-content-center fpl-btn left-arrow" onClick={() => handleGameweekChange(-1)} disabled={currentGameweek === 1}>
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
                <div style={{display: 'flex', alignItems: 'center'}}>
                  <Button className="w-100 justify-content-center fpl-btn right-arrow" onClick={() => handleGameweekChange(1)} disabled={currentGameweek === 38}>
                    <ArrowRight />
                  </Button>
                </div>
                <div style={{ display: 'flex', alignItems: 'center' }}>
                  <Button className="w-100 justify-content-center fpl-btn left-arrow"  onClick={() => handleSeasonChange(-1)} disabled={currentSeason.id === seasons[0].id}>
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
                <div style={{ display: 'flex', alignItems: 'center' }}>
                  <Button className="w-100 justify-content-center fpl-btn right-arrow"  onClick={() => handleSeasonChange(1)} disabled={currentSeason.id === seasons[seasons.length - 1].id}>
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
                          <div className="league-position-col gw-table-header">Pos</div>
                          <div className="league-team-col gw-table-header">Team</div>
                          <div className="league-played-col gw-table-header">P</div>
                          <div className="league-won-col gw-table-header">W</div>
                          <div className="league-drawn-col gw-table-header">D</div>
                          <div className="league-lost-col gw-table-header">L</div>
                          <div className="league-goals-col gw-table-header">GF</div>
                          <div className="league-conceded-col gw-table-header">GA</div>
                          <div className="league-goal-difference-col gw-table-header">GD</div>
                          <div className="league-points-col gw-table-header">PTS</div>
                      </div>
                  </Col>  
              </Row>


              
            {tableData.map((team, idx) => {
                const club = getTeamById(teams, team.teamId);

                return (
                <Row onClick={() => loadClub(team.teamId)} key={`id-${idx}`} style={{ overflowX: 'auto' }}>
                    <Col xs={12}>
                        <div className="table-row clickable-table-row">             
                            <div className="league-position-col gw-table-col">{idx + 1}</div>
                                <div className="league-team-col gw-table-col vertical-flex">
                                    <BadgeIcon
                                        primary={club.primaryColourHex}
                                        secondary={club.secondaryColourHex}
                                        third={club.thirdColourHex}
                                        className='badge-icon'
                                        />
                                        {club.friendlyName}
                          </div>
                          <div className="league-played-col gw-table-col">{team.played}</div>
                          <div className="league-won-col gw-table-col">{team.wins}</div>
                          <div className="league-drawn-col gw-table-col">{team.draws}</div>
                          <div className="league-lost-col gw-table-col">{team.losses}</div>
                          <div className="league-goals-col gw-table-col">{team.goalsFor}</div>
                          <div className="league-conceded-col gw-table-col">{team.goalsAgainst}</div>
                          <div className="league-goal-difference-col gw-table-col">{team.goalsFor - team.goalsAgainst}</div>
                          <div className="league-points-col gw-table-col">{team.points}</div>
           
                        </div>
                    </Col>
                </Row>)})    
            }
              

              </Container>

          </Row>
        </div>
    );
};

export default LeagueTable;
