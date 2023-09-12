import React, { useState, useEffect } from 'react';
import { Container, Spinner, Table, Pagination, Form, Card, Row, Col, Button } from 'react-bootstrap';
import { Link } from "react-router-dom";
import { DataContext } from "../../contexts/DataContext";
import { OpenFPL_backend as open_fpl_backend } from '../../../../declarations/OpenFPL_backend';

const WeeklyLeaderboard = () => {
    const { seasons, systemState } = useContext(DataContext);
    const [isLoading, setIsLoading] = useState(true);
    const [managers, setManagers] = useState({
        totalEntries: 0n,
        seasonId: 0,
        entries: [],
        gameweek: 0
      });
    const [currentPage, setCurrentPage] = useState(1);
    const [selectedSeason, setSelectedSeason] = useState(systemState.activeSeason.id);
    const [selectedGameweek, setSelectedGameweek] = useState(systemState.activeGameweek);
    const itemsPerPage = 25;
    
    const renderedPaginationItems = Array.from({ length: Math.ceil(Number(managers.totalEntries) / itemsPerPage) }, (_, index) => (
        <Pagination.Item 
            key={index + 1} 
            active={index + 1 === currentPage} 
            onClick={() => setCurrentPage(index + 1)}
        >
            {index + 1}
        </Pagination.Item>
    ));

    useEffect(() => {
        if (!selectedSeason || !selectedGameweek || !isInitialSetupDone) {
            return;
        };

        const fetchData = async () => {
            setIsLoading(true);
            await fetchViewData(selectedSeason, selectedGameweek);
            setIsLoading(false);
        };
        
        fetchData();
    }, [selectedSeason, selectedGameweek, currentPage, isInitialSetupDone]);

    const fetchViewData = async (season, gameweek) => {
        const initialCacheKey = `weekly_leaderboard_hash`;
        const cachedData = JSON.parse(localStorage.getItem(initialCacheKey) || '{}');
        const currentHashArray = await open_fpl_backend.getCurrentHashes();
        const weeklyLeaderboardHashObject = currentHashArray.find(item => item.category === 'weekly_leaderboard');
        
        if (currentPage <= 4 && cachedData && cachedData.hash === weeklyLeaderboardHashObject.hash && cachedData.seasonId === season && cachedData.gameweek === gameweek) {
            setManagers(cachedData);
        } else {
            const leaderboardData = await open_fpl_backend.getWeeklyLeaderboard(Number(season), Number(gameweek), itemsPerPage, (currentPage - 1) * itemsPerPage);
            
            if (currentPage <= 4) { 
                leaderboardData.hash = weeklyLeaderboardHashObject.hash;  // Add the hash to the data for caching purposes
                localStorage.setItem(initialCacheKey, JSON.stringify(leaderboardData)); // Store only initial data
            }
            
            setManagers(leaderboardData);
        }
    };
    
    const renderedData = managers.entries && managers.entries.map(manager => (
        <tr key={manager.principalId}>
            <td className='text-center'>{manager.positionText}</td>
            <td className='text-center'>{manager.principalId == manager.username ? 'Unknown' : manager.username}</td>
            <td className='text-center'><Button as={Link} 
                to={{
                    pathname: `/view-points/${manager.principalId}/${selectedSeason}/${selectedGameweek}`
                }}>{manager.points}</Button>
            </td>
        </tr>
    ));

    return (
        isLoading ? (
        <div className="customOverlay d-flex flex-column align-items-center justify-content-center">
            <Spinner animation="border" />
            <p className='text-center mt-1'>Loading</p>
        </div>
        ) 
        :
        <Container>
            <Card className='mb-2'>
                <Card.Body>
                <Card.Title className='mb-2'>
                    Weekly Leaderboard
                </Card.Title>
                <Row className='mb-2'>
                    <Col xs={12} md={6}>
                        <Form.Group controlId="seasonSelect">
                            <Form.Label>Select Season</Form.Label>
                            <Form.Control as="select" value={selectedSeason} onChange={e => {
                                setSelectedSeason(Number(e.target.value));
                                setSelectedGameweek(1);
                            }}>
                                {seasons.map(season => <option key={season.id} value={season.id}>{`${season.name}`}</option>)}
                            </Form.Control>
                        </Form.Group>
                    </Col>
                    <Col xs={12} md={6}>
                        <Form.Group controlId="gameweekSelect">
                            <Form.Label>Select Gameweek</Form.Label>
                            <Form.Control as="select" value={selectedGameweek} onChange={e => setSelectedGameweek(Number(e.target.value))}>
                                {Array.from({ length: 38 }, (_, index) => (
                                    <option key={index + 1} value={index + 1}>Gameweek {index + 1}</option>
                                ))}
                            </Form.Control>
                        </Form.Group>
                    </Col>
                </Row>
                

            
            <Table  responsive bordered className="table-fixed">
                <thead>
                    <tr>
                        <th className='top10-num-col text-center'><small>Pos.</small></th>
                        <th className='top10-name-col text-center'><small>Manager</small></th>
                        <th className='top10-points-col text-center'><small>Points</small></th>
                    </tr>
                </thead>
                <tbody>
                    {renderedData}
                </tbody>
            </Table>
            <Pagination>{renderedPaginationItems}</Pagination>
                </Card.Body>
            </Card>
             
        </Container>
    );
};

export default WeeklyLeaderboard;
