import React, { useState, useEffect, useContext } from 'react';
import { Modal, Button, Table, Form, Pagination, Row, Col } from 'react-bootstrap';
import { PlayerContext } from '../../contexts/PlayerContext';
import { TeamContext } from "../../contexts/TeamContext";

const SelectPlayerModal = ({ show, handleClose, handleConfirm }) => {
  
  const { players } = useContext(PlayerContext);
  const { teams } = useContext(TeamContext);
  const [selectedPlayer, setSelectedPlayer] = useState(null);
  const [filterTeam, setFilterTeam] = useState("");
  const [filterPosition, setFilterPosition] = useState("");
  const [page, setPage] = useState(0);
  const count = 25;
  const [viewData, setViewData] = useState({ players: [], totalEntries: 0 }); 

  const positionOptions = [
    { id: 0, name: "Goalkeepers" },
    { id: 1, name: "Defenders" },
    { id: 2, name: "Midfielders" },
    { id: 3, name: "Forwards" },
  ];
  
  useEffect(() => {
    if(!Array.isArray(players)){
      return;
    }
    
    const filteredPlayers = players
      .filter(player => player.team.toLowerCase().includes(filterTeam.toLowerCase()))
      .filter(player => player.position.toLowerCase().includes(filterPosition.toLowerCase()))
      .slice(page * count, (page + 1) * count);
  
    setViewData({ players: filteredPlayers, totalEntries: filteredPlayers.length });
  
  }, [players, filterTeam, filterPosition, page]);


  const handlePageChange = (pageNumber) => {
    setPage(pageNumber);
  };

  const handleChangeFilterTeam = (event) => {
    setFilterTeam(event.target.value);
    setPage(0); 
  };

  const handleChangeFilterPosition = (event) => {
    setFilterPosition(event.target.value);
    setPage(0);
  };

  const handleSubmit = () => {
    handleConfirm(selectedPlayer);
  };

  const renderPagination = () => {
    let items = [];
    for (let number = 1; number <= Math.ceil(viewData.totalEntries / count); number++) {
      items.push(
        <Pagination.Item key={number} active={number === page + 1} onClick={() => handlePageChange(number - 1)}>
          {number}
        </Pagination.Item>,
      );
    }
    return <Pagination>{items}</Pagination>;
  };

  return (
    <Modal show={show} onHide={handleClose} centered>
      <Modal.Header closeButton>
        <Modal.Title>Select Player</Modal.Title>
      </Modal.Header>
      <Modal.Body>
        <Form>
          <Row>
            <Col>
              <Form.Group controlId="teamFilter">
                <Form.Label>Filter Team:</Form.Label>
                <Form.Control as="select" value={filterTeam || ''} onChange={handleChangeFilterTeam}>
                  <option value="">All</option>
                  {teams.map((team, index) => (
                    <option key={index} value={team}>
                      {team}
                    </option>
                  ))}
                </Form.Control>
              </Form.Group>
            </Col>
            <Col>
              <Form.Group controlId="positionFilter">
                <Form.Label>Filter Position:</Form.Label>
                <Form.Control as="select" value={filterPosition || ''} onChange={handleChangeFilterPosition}>
                  <option value="">All</option>
                  {positionOptions.map((position, index) => (
                    <option key={index} value={position}>
                      {position}
                    </option>
                  ))}
                </Form.Control>
              </Form.Group>
            </Col>
          </Row>
        </Form>
        {players?.isLoading ? (
          <p>Loading...</p>
        ) : (
          <>
            <Table striped bordered hover>
              <thead>
                <tr>
                  <th>Name</th>
                  <th>Team</th>
                  <th>Position</th>
                  <th>Select</th>
                </tr>
              </thead>
              <tbody>
                {viewData.players.map((player) => (
                  <tr key={player.id}>
                    <td>{player.name}</td>
                    <td>{player.team}</td>
                    <td>{player.position}</td>
                    <td>
                      <Button variant="primary" onClick={() => setSelectedPlayer(player)}>
                        Select
                      </Button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </Table>
            {renderPagination()}
          </>
        )}
      </Modal.Body>
      <Modal.Footer>
        <Button variant="secondary" onClick={handleClose}>
          Close
        </Button>
        <Button variant="primary" onClick={handleSubmit} disabled={!selectedPlayer}>
          Confirm
        </Button>
      </Modal.Footer>
    </Modal>
  );
};

export default SelectPlayerModal;
