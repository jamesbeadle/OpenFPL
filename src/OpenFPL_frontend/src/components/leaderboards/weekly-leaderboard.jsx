import React, { useState, useEffect } from 'react';
import { Container, Spinner, Table, Pagination, Form, Card, Row, Col, Button } from 'react-bootstrap';
import { Link } from "react-router-dom";
import { OpenFPL_backend as open_fpl_backend } from '../../../../declarations/OpenFPL_backend';

const WeeklyLeaderboard = () => {
    const [isLoading, setIsLoading] = useState(true);
    const [managers, setManagers] = useState({
        totalEntries: 0n,
        seasonId: 0,
        entries: [],
        gameweek: 0
      });
    const [seasons, setSeasons] = useState([]);
    const [currentPage, setCurrentPage] = useState(1);
    const [selectedSeason, setSelectedSeason] = useState(1);
    const [selectedGameweek, setSelectedGameweek] = useState(1);
    const itemsPerPage = 25;
    const [isInitialSetupDone, setIsInitialSetupDone] = useState(false);
    
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
        const fetchInitialData = async () => {
            await fetchSeasons();
            const activeSeasonData = await fetchActiveSeasonId();
            const activeGameweekData = await fetchActiveGameweek();
            
            if(!activeSeasonData || !activeGameweekData){
                return;
            }
            setSelectedSeason(activeSeasonData);
            setSelectedGameweek(activeGameweekData);
            setIsInitialSetupDone(true);
        };
    
        fetchInitialData();
    }, []);

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


    const fetchActiveGameweek = async () => {
        try {
            const activeGameweekData = await open_fpl_backend.getCurrentGameweek();
            return activeGameweekData;
        } catch(error) {
            console.error("Error fetching active gameweek: ", error);
        }
    };
    
    
    const fetchActiveSeasonId = async () => {
        const activeSeasonData = await open_fpl_backend.getCurrentSeason();
        return activeSeasonData.id;
    };

    const fetchViewData = async (season, gameweek) => {
        const leaderboardData = await open_fpl_backend.getWeeklyLeaderboard(Number(season), Number(gameweek), itemsPerPage, (currentPage - 1) * itemsPerPage);
        setManagers(leaderboardData);
    };

    const fetchSeasons = async () => {
        const seasonList = await open_fpl_backend.getSeasons();
        setSeasons(seasonList); 
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
