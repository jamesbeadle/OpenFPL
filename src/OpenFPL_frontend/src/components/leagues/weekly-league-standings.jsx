import React, { useState, useEffect, useContext } from 'react';
import { Container, Spinner, Table, Pagination, Form } from 'react-bootstrap';

import { AuthContext } from "../../contexts/AuthContext";
import { Actor } from "@dfinity/agent";
import { OpenFPL_backend as open_fpl_backend } from '../../../../declarations/OpenFPL_backend';

const WeeklyLeagueStandings = () => {
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
            const activeSeason = await fetchActiveSeasonId();
            const activeGameweek = await fetchActiveGameweek();
            await fetchViewData(activeSeason, activeGameweek);
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
    
        const activeGameweekData = await open_fpl_backend.getActiveGameweek();
        setSelectedGameweek(activeGameweekData);
    };
    
    const fetchActiveSeasonId = async () => {
        const identity = authClient.getIdentity();
        Actor.agentOf(open_fpl_backend).replaceIdentity(identity);
    
        const activeSeasonIdData = await open_fpl_backend.getActiveSeasonId();
        setSelectedSeason(activeSeasonIdData);
    };

    const fetchViewData = async (season, gameweek) => {
        const identity = authClient.getIdentity();
        Actor.agentOf(open_fpl_backend).replaceIdentity(identity);
    
        const leaderboardData = await open_fpl_backend.getWeeklyLeaderboard(Number(season), Number(gameweek), itemsPerPage, (currentPage - 1) * itemsPerPage); // Update the backend call if needed
        setManagers(leaderboardData.entries);
    };

    const fetchSeasons = async () => {
        const identity = authClient.getIdentity();
        Actor.agentOf(open_fpl_backend).replaceIdentity(identity);
    
        const seasonList = await open_fpl_backend.getSeasons();
        setSeasons(seasonList); 
    };

    const renderedData = managers.slice((currentPage - 1) * itemsPerPage, currentPage * itemsPerPage).map(manager => (
        <tr key={manager.position}>
            <td>{manager.position}</td>
            <td>{manager.username}</td>
            <td>{manager.score}</td>
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
             <Form.Group controlId="seasonSelect">
                <Form.Label>Select Season</Form.Label>
                <Form.Control as="select" value={selectedSeason} onChange={e => {
                    setSelectedSeason(Number(e.target.value));
                    setSelectedGameweek(1);
                }}>
                    {seasons.map(season => <option key={season.id} value={season.id}>{`${season.name} ${season.year}`}</option>)}
                </Form.Control>
            </Form.Group>

            <Form.Group controlId="gameweekSelect">
                <Form.Label>Select Gameweek</Form.Label>
                <Form.Control as="select" value={selectedGameweek} onChange={e => setSelectedGameweek(Number(e.target.value))}>
                    {Array.from({ length: 38 }, (_, index) => (
                        <option key={index + 1} value={index + 1}>Gameweek {index + 1}</option>
                    ))}
                </Form.Control>
            </Form.Group>
            <Table striped bordered hover>
                <thead>
                    <tr>
                        <th>Position</th>
                        <th>Username</th>
                        <th>Score</th>
                    </tr>
                </thead>
                <tbody>
                    {renderedData}
                </tbody>
            </Table>
            <Pagination>{renderedPaginationItems}</Pagination>
        </Container>
    );
};

export default WeeklyLeagueStandings;
