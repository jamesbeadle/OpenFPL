import React, { useState, useEffect, useContext } from 'react';
import { Container, Spinner, Table, Pagination, Form } from 'react-bootstrap';

import { AuthContext } from "../../contexts/AuthContext";
import { Actor } from "@dfinity/agent";
import { OpenFPL_backend as open_fpl_backend } from '../../../../declarations/OpenFPL_backend';

const LeagueStandings = () => {
    const [isLoading, setIsLoading] = useState(true);
    const { authClient } = useContext(AuthContext);
    const [managers, setManagers] = useState([]);
    const [seasons, setSeasons] = useState([]);
    const [currentPage, setCurrentPage] = useState(1);
    const [selectedSeason, setSelectedSeason] = useState(1);
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
            await fetchViewData(activeSeason);
            setIsLoading(false);
        };
        fetchIntialData();
    }, []);

    useEffect(() => {
        setCurrentPage(1);
        fetchData();
    }, [selectedSeason]);
    
    useEffect(() => {
        fetchData();
    }, [currentPage]);

    const fetchData = async () => {
        await fetchViewData(selectedSeason);
        setIsLoading(false);
    };
    
    const fetchActiveSeasonId = async () => {
        const identity = authClient.getIdentity();
        Actor.agentOf(open_fpl_backend).replaceIdentity(identity);
    
        const activeSeasonIdData = await open_fpl_backend.getActiveSeasonId();
        setSelectedSeason(activeSeasonIdData);
    };

    const fetchViewData = async (season) => {
        const identity = authClient.getIdentity();
        Actor.agentOf(open_fpl_backend).replaceIdentity(identity);
    
        const leaderboardData = await open_fpl_backend.getSeasonLeaderboard(Number(season), itemsPerPage, (currentPage - 1) * itemsPerPage); // Update the backend call if needed
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
                }}>
                    {seasons.map(season => <option key={season.id} value={season.id}>{`${season.name} ${season.year}`}</option>)}
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

export default LeagueStandings;
