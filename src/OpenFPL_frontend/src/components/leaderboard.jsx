import React, { useState, useEffect, useContext, useRef } from 'react';
import { Button, Spinner, Container, Row, Col, Dropdown, Pagination } from 'react-bootstrap';
import { ArrowLeft, ArrowRight } from './icons';
import { DataContext } from "../contexts/DataContext";
import { getTeamById } from './helpers';
import { useNavigate } from 'react-router-dom';

const Leaderboard = () => {
    const { seasons, systemState, weeklyLeaderboard, seasonLeaderboard, monthlyLeaderboards, teams } = useContext(DataContext);
    const [isLoading, setIsLoading] = useState(true);
    const [managers, setManagers] = useState(weeklyLeaderboard);
    const [currentPage, setCurrentPage] = useState(1);
    const [currentSeason, setCurrentSeason] = useState(systemState.activeSeason);
    const [currentGameweek, setCurrentGameweek] = useState(systemState.activeGameweek);
    const [currentLeaderboard, setCurrentLeaderboard] = useState('Weekly');
    const [currentClub, setCurrentClub] = useState(teams.sort((a, b) => a.friendlyName.localeCompare(b.friendlyName))[0]);
    const itemsPerPage = 25;
    
    const [showGameweekDropdown, setShowGameweekDropdown] = useState(false);
    const [showSeasonDropdown, setShowSeasonDropdown] = useState(false);
    const [showLeaderboardDropdown, setShowLeaderboardDropdown] = useState(false);
    const [showClubDropdown, setShowClubDropdown] = useState(false);
    const gameweekDropdownRef = useRef(null);
    const seasonDropdownRef = useRef(null);
    const leaderboardDropdownRef = useRef(null);
    const clubDropdownRef = useRef(null);
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
    
    const handleLeaderboardTypeBlur = (e) => {
        const currentTarget = e.currentTarget;
        setTimeout(() => {
        if (!currentTarget.contains(document.activeElement)) {
            setShowLeaderboardDropdown(false);
        }
        }, 0);
    };
    
    const handleClubBlur = (e) => {
        const currentTarget = e.currentTarget;
        setTimeout(() => {
        if (!currentTarget.contains(document.activeElement)) {
            setShowClubDropdown(false);
        }
        }, 0);
    };
    
    useEffect(() => {
        const fetchData = async () => {
            setIsLoading(true);
            await fetchViewData(currentSeason, currentGameweek, currentLeaderboard, systemState.activeMonth, currentClub.id);
            setIsLoading(false);
        };
        
        fetchData();
    }, [currentSeason, currentGameweek, currentPage, currentLeaderboard]);

    const fetchViewData = async (season, gameweek, leaderboard, month, club) => {

        switch(leaderboard){
            case 'Weekly':
                await getWeeklyLeaderboard(season, gameweek);
                break;
            case 'Monthly':
                console.log("here")
                await getMonthlyLeaderboard(season, month, club);
                break;
            case 'Season':
                await getSeasonLeaderboard(season);
                break;
        }
    };

    const getWeeklyLeaderboard = async (season, gameweek) => {
        if(currentPage <= 4 && gameweek == weeklyLeaderboard.gameweek){
            const start = (currentPage - 1) * itemsPerPage;
            const end = start + itemsPerPage;
            const slicedData = {
                ...weeklyLeaderboard,
                entries: weeklyLeaderboard.entries.slice(start, end)
            };
            setManagers(slicedData);
        }
        else{
            try{
                const leaderboardData = await open_fpl_backend.getWeeklyLeaderboard(Number(season), Number(gameweek), itemsPerPage, (currentPage - 1) * itemsPerPage);
                setManagers(leaderboardData);
            } catch (error){
                console.log(error);
            };  
        }
    };  

    const getMonthlyLeaderboard = async (season, month, club) => {
      console.log(monthlyLeaderboards)
      if(Number(monthlyLeaderboards[0].totalEntries) === 0){
        setManagers(null);    
        return;
      }
        if(currentPage <= 4 && month == systemState.activeMonth){
            const start = (currentPage - 1) * itemsPerPage;
            const end = start + itemsPerPage;
            const slicedData = {
                ...monthlyLeaderboards.find(x => x.clubId == club),
                entries: monthlyLeaderboards.find(x => x.clubId == club).entries.slice(start, end)
            };
            setManagers(slicedData);
        }
        else{
            try{
                const leaderboardData = await open_fpl_backend.getClubLeaderboard(Number(season), Number(month), Number(club), itemsPerPage, (currentPage - 1) * itemsPerPage);
                setManagers(leaderboardData);    
            } catch (error){
                console.log(error);
            };  
        }
    };

    const getSeasonLeaderboard = async (season) => {
      console.log(season)
        if(currentPage <= 4 && season.id == systemState.activeSeason.id){
            const start = (currentPage - 1) * itemsPerPage;
            const end = start + itemsPerPage;
            const slicedData = {
                ...seasonLeaderboard,
                entries: seasonLeaderboard.entries.slice(start, end)
            };
            setManagers(slicedData);
        }
        else{
            try{
                const leaderboardData = await open_fpl_backend.getSeasonLeaderboard(Number(season), itemsPerPage, (currentPage - 1) * itemsPerPage);
                setManagers(leaderboardData);  
            } catch (error){
                console.log(error);
            };  
            
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
  
    const openLeaderboardDropdown = () => {
      setShowLeaderboardDropdown(!showLeaderboardDropdown);
      setTimeout(() => {
        if (leaderboardDropdownRef.current) {
          const item = leaderboardDropdownRef.current.querySelector(`[data-key="${currentLeaderboard}"]`);
          if (item) {
            item.scrollIntoView({ block: 'nearest', inline: 'nearest' });
          }
        }
      }, 0);
    };
  
    const openClubDropdown = () => {
      setShowClubDropdown(!showClubDropdown);
      setTimeout(() => {
        if (clubDropdownRef.current) {
          const item = clubDropdownRef.current.querySelector(`[data-key="${currentClub.id}"]`);
          if (item) {
            item.scrollIntoView({ block: 'nearest', inline: 'nearest' });
          }
        }
      }, 0);
    };

    const renderedPaginationItems = Array.from({ length: Math.ceil(Number(managers.totalEntries) / itemsPerPage) }, (_, index) => (
      <Pagination.Item 
          key={index + 1} 
          active={index + 1 === currentPage} 
          onClick={() => setCurrentPage(index + 1)}
          className="custom-pagination-item"
      >
          {index + 1}
      </Pagination.Item>
    ));

    const loadManager = (managerId) => {
      navigate(`/manager/${managerId}`);
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
                            onMouseDown={() => {setCurrentGameweek(index + 1); setCurrentPage(1);}}
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
                      <Dropdown.Toggle as={CustomToggle} id="season-selector">
                        <Button className='filter-dropdown-btn' style={{ backgroundColor: 'transparent' }} onClick={() => openSeasonDropdown()}>{currentSeason.name}</Button>
                      </Dropdown.Toggle>
                      <Dropdown.Menu style={{ maxHeight: '200px', overflowY: 'auto' }}>
                        
                        {seasons.map(season => 
                          <Dropdown.Item
                            data-key={season.id}
                            className='dropdown-item'
                            key={season.id}
                            onMouseDown={() => {setCurrentSeason(season); setCurrentPage(1);}}
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

                
                <div style={{ display: 'flex', alignItems: 'center' }}>
                  <div ref={leaderboardDropdownRef} onBlur={handleLeaderboardTypeBlur}>
                    <Dropdown show={showLeaderboardDropdown}>
                      <Dropdown.Toggle as={CustomToggle} id="leaderboard-selector">
                        <Button className='filter-dropdown-btn' style={{ backgroundColor: 'transparent' }} onClick={() => openLeaderboardDropdown()}>{currentLeaderboard}</Button>
                      </Dropdown.Toggle>
                      <Dropdown.Menu style={{ maxHeight: '200px', overflowY: 'auto' }}>
                          <Dropdown.Item
                            data-key={0}
                            className='dropdown-item'
                            key={0}
                            onMouseDown={() => {{setCurrentLeaderboard('Weekly'); setCurrentPage(1);}}}
                            >Weekly {currentLeaderboard === 'Weekly' ? ' ✔️' : ''}</Dropdown.Item>
                        <Dropdown.Item
                            data-key={1}
                            className='dropdown-item'
                            key={1}
                            onMouseDown={() => {{setCurrentLeaderboard('Monthly'); setCurrentPage(1);}}}
                            >Monthly {currentLeaderboard === 'Monthly' ? ' ✔️' : ''}</Dropdown.Item>
                        <Dropdown.Item
                            data-key={2}
                            className='dropdown-item'
                            key={2}
                            onMouseDown={() => {{setCurrentLeaderboard('Season'); setCurrentPage(1);}}}
                            >Season {currentLeaderboard === 'Season' ? ' ✔️' : ''}</Dropdown.Item>
                      </Dropdown.Menu>
                    </Dropdown>
                  </div>
                </div>

                {currentLeaderboard == 'Monthly' && <div style={{ display: 'flex', alignItems: 'center', marginLeft: '16px' }}>
                  <div ref={clubDropdownRef} onBlur={handleClubBlur}>
                    <Dropdown show={showClubDropdown}>
                      <Dropdown.Toggle as={CustomToggle} id="club-selector">
                        <Button className='filter-dropdown-btn' style={{ backgroundColor: 'transparent' }} onClick={() => openClubDropdown()}><b>Team: </b>{currentClub.friendlyName}</Button>
                      </Dropdown.Toggle>
                      <Dropdown.Menu style={{ maxHeight: '200px', overflowY: 'auto' }}>
                          {teams.map(team => 
                          <Dropdown.Item
                            data-key={team.id}
                            className='dropdown-item'
                            key={team.id}
                            onMouseDown={() => {setCurrentClub(team); setCurrentPage(1);}}
                          >
                            {team.friendlyName} {currentClub.id === team.id ? ' ✔️' : ''}
                          </Dropdown.Item>
                        )}
                      </Dropdown.Menu>
                    </Dropdown>
                  </div>
                </div>}
              </div>
            </Col>
          </Row>

          <Row>

          <Container>
              <Row style={{ overflowX: 'auto' }}>
                  <Col xs={12}>
                      <div className='light-background table-header-row w-100'  style={{ display: 'flex', alignItems: 'center' }}>
                          <div className="leaderboard-pos-col gw-table-header">Pos</div>
                          <div className="leaderboard-name-col gw-table-header">Manager</div>
                          <div className="leaderboard-points-col gw-table-header">PTS</div>
                      </div>
                  </Col>  
              </Row>


              
            {managers && managers.entries && managers.entries.map(manager => (
                <Row className="clickable-table-row" onClick={() => {loadManager(manager.principalId)}} key={manager.principalId} style={{ overflowX: 'auto' }}>
                    <Col xs={12}>
                        <div className="table-row">  
                            <div className="leaderboard-pos-col gw-table-col">{manager.positionText}</div>
                            <div className="leaderboard-name-col gw-table-col">{manager.principalId == manager.username ? 'Unknown' : manager.username}</div>
                            <div className="leaderboard-points-col gw-table-col">{manager.points}</div>
                        </div>
                    </Col>
                </Row>
            ))    
            }

            {managers && managers.entries && 
            <Container fluid>
              <div className='custom-pagination-container'>
                <Pagination>{renderedPaginationItems}</Pagination>
              </div>
            </Container>
              
            }

            {!managers && 
            <Row className='mt-4'>
              <Col xs={12}>
                  <p className='px-4'>No Entries</p>
              </Col>
            </Row>
            }
              

              </Container>

          </Row>
        </div>
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

export default Leaderboard;
