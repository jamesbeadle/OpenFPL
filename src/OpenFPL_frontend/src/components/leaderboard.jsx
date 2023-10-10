import React, { useState, useEffect, useContext, useRef } from 'react';
import { Button, Spinner, Container, Row, Col, Dropdown } from 'react-bootstrap';
import { BadgeIcon, ArrowLeft, ArrowRight } from './icons';
import { DataContext } from "../contexts/DataContext";
import { getTeamById } from './helpers';

const Leaderboard = () => {
    const { seasons, systemState, weeklyLeaderboard, seasonLeaderboard, monthlyLeaderboards } = useContext(DataContext);
    const [isLoading, setIsLoading] = useState(true);
    const [managers, setManagers] = useState(weeklyLeaderboard);
    const [currentPage, setCurrentPage] = useState(1);
    const [currentSeason, setCurrentSeason] = useState(systemState.activeSeason.id);
    const [currentGameweek, setCurrentGameweek] = useState(systemState.activeGameweek);
    const [currentLeaderboard, setCurrentLeaderboard] = useState('Weekly');
    const itemsPerPage = 25;
    
    const [showGameweekDropdown, setShowGameweekDropdown] = useState(false);
    const [showSeasonDropdown, setShowSeasonDropdown] = useState(false);
    const [showLeaderboardDropdown, setShowLeaderboardDropdown] = useState(false);
    const gameweekDropdownRef = useRef(null);
    const seasonDropdownRef = useRef(null);
    const leaderboardDropdownRef = useRef(null);
    
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
    
    useEffect(() => {
        const fetchData = async () => {
            setIsLoading(true);
            await fetchViewData(currentSeason, currentGameweek, currentLeaderboard);
            setIsLoading(false);
        };
        
        fetchData();
    }, [currentSeason, currentGameweek, currentPage]);

    const fetchViewData = async (season, gameweek, leaderboard, month, club) => {

        switch(leaderboard){
            case 'Weekly':
                await getWeeklyLeaderboard(season, gameweek);
                break;
            case 'Monthly':
                await getMonthlyLeaderboard(month, club);
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
        if(currentPage <= 4 && month == systemState.activeMonth){
            const start = (currentPage - 1) * itemsPerPage;
            const end = start + itemsPerPage;
            const slicedData = {
                ...monthlyLeaderboards.find(x => x.clubId == selectedClub),
                entries: monthlyLeaderboards.find(x => x.clubId == selectedClub).entries.slice(start, end)
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
        if(currentPage <= 4 && season == systemState.activeSeason.id){
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

                
                <div style={{ display: 'flex', alignItems: 'center' }}>
                  <div ref={leaderboardDropdownRef} onBlur={handleSeasonBlur}>
                    <Dropdown show={showLeaderboardDropdown}>
                      <Dropdown.Toggle as={CustomToggle} id="leaderboard-selector">
                        <Button className='filter-dropdown-btn' style={{ backgroundColor: 'transparent' }} onClick={() => openLeaderboardDropdown()}>{currentLeaderboard}</Button>
                      </Dropdown.Toggle>
                      <Dropdown.Menu style={{ maxHeight: '200px', overflowY: 'auto' }}>
                          <Dropdown.Item
                            data-key={0}
                            className='dropdown-item'
                            key={0}
                            onMouseDown={() => {setCurrentLeaderboard('Weekly')}}
                            >Weekly</Dropdown.Item>
                        <Dropdown.Item
                            data-key={0}
                            className='dropdown-item'
                            key={0}
                            onMouseDown={() => {setCurrentLeaderboard('Monthly')}}
                            >Monthly</Dropdown.Item>
                        <Dropdown.Item
                            data-key={0}
                            className='dropdown-item'
                            key={0}
                            onMouseDown={() => {setCurrentLeaderboard('Season')}}
                            >Season</Dropdown.Item>
                      </Dropdown.Menu>
                    </Dropdown>
                  </div>
                </div>
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


              
            {managers.entries && managers.entries.map(manager => (
                <Row key={manager.principalId} style={{ overflowX: 'auto' }}>
                    <Col xs={12}>
                        <div className="leaderboard-pos-col gw-table-col">{manager.positionText}</div>
                        <div className="leaderboard-name-col gw-table-col">{manager.principalId == manager.username ? 'Unknown' : manager.username}</div>
                        <div className="leaderboard-points-col gw-table-col">{manager.points}</div>
                    </Col>
                </Row>
            ))    
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
