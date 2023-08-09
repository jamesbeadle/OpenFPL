import React, { useState, useEffect, useContext } from 'react';
import { Container, Spinner, Table, Pagination, Form, Card, Row, Col, Button } from 'react-bootstrap';
import { Link } from "react-router-dom";

import { AuthContext } from "../../contexts/AuthContext";
import { Actor } from "@dfinity/agent";
import { OpenFPL_backend as open_fpl_backend } from '../../../../declarations/OpenFPL_backend';

const WeeklyLeaderboard = () => {
    const [isLoading, setIsLoading] = useState(true);
    const { authClient } = useContext(AuthContext);
    const [managers, setManagers] = useState([]);
    const [seasons, setSeasons] = useState([]);
    const [currentPage, setCurrentPage] = useState(1);
    const [selectedSeason, setSelectedSeason] = useState(1);
    const [selectedGameweek, setSelectedGameweek] = useState(1);
    const itemsPerPage = 10;
    
    const totalPages = Math.ceil(managers.length / itemsPerPage);

    const renderedPaginationItems = Array.from({ length: totalPages }, (_, index) => (
        <Pagination.Item 
            key={index + 1} 
            active={index + 1 === currentPage} 
            onClick={() => setCurrentPage(index + 1)}
        >
            {index + 1}
        </Pagination.Item>
    ));

    useEffect(() => {
        const fetchIntialData = async () => {
            await fetchSeasons();
            await fetchActiveSeasonId();
            await fetchActiveGameweek();
            await fetchViewData(selectedSeason, selectedGameweek);
            setIsLoading(false);
        };
        fetchIntialData();
    }, []);

    useEffect(() => {
        setCurrentPage(1);
        fetchData();
    }, [selectedGameweek, selectedSeason]);
    
    useEffect(() => {
        fetchData();
    }, [currentPage]);

    const fetchData = async () => {
        await fetchViewData(selectedSeason, selectedGameweek);
        setIsLoading(false);
    };

    const fetchActiveGameweek = async () => {
        const identity = authClient.getIdentity();
        Actor.agentOf(open_fpl_backend).replaceIdentity(identity);
    
        const activeGameweekData = await open_fpl_backend.getCurrentGameweek();
        setSelectedGameweek(activeGameweekData);
    };
    
    const fetchActiveSeasonId = async () => {
        const identity = authClient.getIdentity();
        Actor.agentOf(open_fpl_backend).replaceIdentity(identity);
    
        const activeSeasonData = await open_fpl_backend.getCurrentSeason();
        setSelectedSeason(activeSeasonData.id);
    };

    const fetchViewData = async (season, gameweek) => {
        const identity = authClient.getIdentity();
        Actor.agentOf(open_fpl_backend).replaceIdentity(identity);
        const leaderboardData = await open_fpl_backend.getWeeklyLeaderboard(Number(season), Number(gameweek), itemsPerPage, (currentPage - 1) * itemsPerPage); // Update the backend call if needed
        console.log(leaderboardData)
        setManagers(leaderboardData.entries);
    };

    const fetchSeasons = async () => {
        const identity = authClient.getIdentity();
        Actor.agentOf(open_fpl_backend).replaceIdentity(identity);
    
        const seasonList = await open_fpl_backend.getSeasons();
        setSeasons(seasonList); 
    };

    const renderedData = managers.slice((currentPage - 1) * itemsPerPage, currentPage * itemsPerPage).map(manager => (
        <tr key={manager.principalId}>
            <td className='text-center'>{manager.positionText}</td>
            <td className='text-center'>{manager.principalId == manager.username ? 'Unknown' : manager.username}</td>
            <td className='text-center'>{manager.points}</td>
            <td className='text-center'><Button as={Link} to={`/view-points?manager=${manager.principalId}&season=${selectedSeason}&gw=${selectedGameweek}`}>View</Button></td>
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
                                {seasons.map(season => <option key={season.id} value={season.id}>{`${season.name} ${season.year}`}</option>)}
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
                

            
            <Table  responsive bordered className="table-fixed light-table">
                <thead>
                    <tr>
                        <th className='top10-num-col text-center'><small>Pos.</small></th>
                        <th className='top10-name-col text-center'><small>Manager</small></th>
                        <th className='top10-points-col text-center'><small>Points</small></th>
                        <th className='top10-button-col text-center'></th>
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
