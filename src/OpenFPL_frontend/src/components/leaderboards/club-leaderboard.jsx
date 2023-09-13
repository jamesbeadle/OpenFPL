import React, { useState, useEffect, useContext } from 'react';
import { Container, Spinner, Table, Pagination, Form, Card, Row, Col } from 'react-bootstrap';
import { OpenFPL_backend as open_fpl_backend } from '../../../../declarations/OpenFPL_backend';
import { useParams } from 'react-router-dom';
import { DataContext } from "../../contexts/DataContext";

const ClubLeaderboard = () => {
    const { teams, seasons, systemState, monthlyLeaderboards } = useContext(DataContext);
    const { teamId } = useParams();
    const [isLoading, setIsLoading] = useState(true);
    const [managers, setManagers] = useState(monthlyLeaderboards.find(x => x.clubId == teamId));
    const [currentPage, setCurrentPage] = useState(1);
    const [selectedSeason, setSelectedSeason] = useState(systemState.activeSeasonId);
    const [selectedMonth, setSelectedMonth] = useState(systemState.activeMonth);
    const itemsPerPage = 25;
    const [selectedClub, setSelectedClub] = useState(teamId);
  
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
        if (!selectedSeason || !selectedMonth) {
            return;
        };
        
        const cachedData = monthlyLeaderboards.find(x => x.clubId == selectedClub && x.seasonId == selectedSeason && x.month == selectedMonth);
    
        if (!cachedData) {
            const fetchData = async () => {
                setIsLoading(true);
                await fetchViewData(selectedSeason, selectedMonth, selectedClub);
                setIsLoading(false);
            };
    
            fetchData();
        } else {
            setManagers(cachedData);
            setIsLoading(false);
        }
    }, [selectedSeason, selectedMonth, currentPage, selectedClub]);
    
    const fetchViewData = async (season, month, club) => {
        if (currentPage > 4) {
            const cachedData = monthlyLeaderboards.find(x => x.clubId == club && x.seasonId == season && x.month == month);
            
            if (cachedData) {
                setManagers(cachedData);
            } else {
                const leaderboardData = await open_fpl_backend.getClubLeaderboard(Number(season), Number(month), Number(club), itemsPerPage, (currentPage - 1) * itemsPerPage);
                setManagers(leaderboardData);
            }
        }
    };

    const renderedData = managers.entries && managers.entries.map(manager => (
        <tr key={manager.principalId}>
            <td className='text-center'>{manager.positionText}</td>
            <td className='text-center'>{manager.principalId == manager.username ? 'Unknown' : manager.username}</td>
            <td className='text-center'>{manager.points}</td>
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
                        Club Leaderboard
                    </Card.Title>
                    <Row className='mb-2'>
                        <Col xs={12} md={4}>
                            <Form.Group controlId="clubSelect">
                                <Form.Label>Select Club</Form.Label>
                                <Form.Control as="select" value={selectedClub || ''} onChange={e => { setSelectedClub(Number(e.target.value));  setCurrentPage(1); }}>
                                    {teams.map(club => <option key={club.id} value={club.id}>{club.friendlyName}</option>)}
                                </Form.Control>
                            </Form.Group>
                        </Col>
                        <Col xs={12} md={4}>
                            <Form.Group controlId="seasonSelect">
                                <Form.Label>Select Season</Form.Label>
                                <Form.Control as="select" value={selectedSeason || ''} onChange={e => {
                                    setSelectedSeason(Number(e.target.value));
                                    setCurrentPage(1);
                                }}>

                                    {seasons.map(season => <option key={season.id} value={season.id}>{`${season.name}`}</option>)}
                                </Form.Control>
                            </Form.Group>
                        </Col>
                        <Col xs={12} md={4}>
                            <Form.Group controlId="gameweekSelect">
                                <Form.Label>Select Month</Form.Label>
                                <Form.Control as="select" value={selectedMonth || ''} onChange={e => { setSelectedMonth(Number(e.target.value));  setCurrentPage(1);}}>
                                    <option key={1} value={1}>January</option>
                                    <option key={2} value={2}>February</option>
                                    <option key={3} value={3}>March</option>
                                    <option key={4} value={4}>April</option>
                                    <option key={5} value={5}>May</option>
                                    <option key={6} value={6}>June</option>
                                    <option key={7} value={7}>July</option>
                                    <option key={8} value={8}>August</option>
                                    <option key={9} value={9}>September</option>
                                    <option key={10} value={10}>October</option>
                                    <option key={11} value={11}>November</option>
                                    <option key={12} value={12}>December</option>
                                </Form.Control>
                            </Form.Group>
                        </Col>
                    </Row>
            
                    <Table  responsive bordered className="table-fixed">
                        <thead>
                            <tr>
                                <th className='top10-num-col text-center'><small>Pos.</small></th>
                                <th className='top10-name-large-col text-center'><small>Manager</small></th>
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

export default ClubLeaderboard;
