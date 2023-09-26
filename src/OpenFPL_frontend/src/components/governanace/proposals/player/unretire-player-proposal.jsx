import React, { useState } from 'react';
import { Form, Button, Alert, InputGroup, Table, Pagination } from 'react-bootstrap';
import { player_canister as player_canister } from '../../../../../../declarations/player_canister';

const UnretirePlayerProposal = ({ sendDataToParent }) => {
    const [searchTerm, setSearchTerm] = useState("");
    const [retiredPlayers, setRetiredPlayers] = useState([]);
    const [submitStatus, setSubmitStatus] = useState(null);
    const [currentPage, setCurrentPage] = useState(1);
    const itemsPerPage = 5;

    const handleSearch = async () => {
        try {
            const players = await player_canister.getRetiredPlayer(searchTerm);
            setRetiredPlayers(players);
        } catch (err) {
            console.error(err);
        }
    };

    const handleUnretirePlayer = async (player) => {
        try {
            await sendDataToParent(player);
            setSubmitStatus("Player successfully unretired!");
            setRetiredPlayers(prevPlayers => prevPlayers.filter(player => player.id !== playerId));
        } catch (error) {
            console.error("Error while unretiring player: ", error);
            setSubmitStatus("Failed to unretire player. Please try again.");
        }
    };

    const totalPages = Math.ceil(retiredPlayers.length / itemsPerPage);
    const playersToDisplay = retiredPlayers.slice((currentPage - 1) * itemsPerPage, currentPage * itemsPerPage);

    return (
        <div>
            <Form>
                <InputGroup className="mb-3">
                    <Form.Control
                        type="text"
                        placeholder="Search for a retired player by surname"
                        value={searchTerm}
                        onChange={(e) => setSearchTerm(e.target.value)}
                    />
                    <Button variant="outline-secondary" onClick={handleSearch}>
                        Search
                    </Button>
                </InputGroup>
            </Form>

            {submitStatus && <Alert variant={submitStatus.includes("successfully") ? "success" : "danger"}>{submitStatus}</Alert>}

            <Table striped bordered hover>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>First Name</th>
                        <th>Last Name</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    {playersToDisplay.map((player) => (
                        <tr key={player.id}>
                            <td>{player.id}</td>
                            <td>{player.firstName}</td>
                            <td>{player.lastName}</td>
                            <td><Button variant="primary" onClick={() => handleUnretirePlayer(player)}>Unretire</Button></td>
                        </tr>
                    ))}
                </tbody>
            </Table>

            <Pagination>
                <Pagination.Prev onClick={() => setCurrentPage(prevPage => Math.max(prevPage - 1, 1))} />
                {Array.from({length: totalPages}, (_, index) => (
                    <Pagination.Item
                        key={index}
                        active={index + 1 === currentPage}
                        onClick={() => setCurrentPage(index + 1)}
                    >
                        {index + 1}
                    </Pagination.Item>
                ))}
                <Pagination.Next onClick={() => setCurrentPage(prevPage => Math.min(prevPage + 1, totalPages))} />
            </Pagination>
        </div>
    );
};

export default UnretirePlayerProposal;
