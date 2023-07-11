import React, { useState, useEffect, useContext } from 'react';
import { Modal, Button, Container, Form, Pagination, Row, Col } from 'react-bootstrap';
import { PlayerContext } from '../../contexts/PlayerContext';
import { TeamContext } from "../../contexts/TeamContext";

const SelectPlayerModal = ({ show, handleClose, handleConfirm }) => {
  
  const { players } = useContext(PlayerContext);
  const { teams } = useContext(TeamContext);
  const [filterTeamId, setFilterTeamId] = useState("");
  const [filterPosition, setFilterPosition] = useState("");
  const [page, setPage] = useState(0);
  const count = 10;
  const [viewData, setViewData] = useState({ players: [], totalEntries: 0 }); 

  const positionOptions = [
    { id: 0, name: "Goalkeeper" },
    { id: 1, name: "Defender" },
    { id: 2, name: "Midfielder" },
    { id: 3, name: "Forward" },
  ];

  useEffect(() => {
    if (!show) {
      setFilterTeamId("");
      setFilterPosition("");
      setPage(0);
    }
  }, [show]);
  
  useEffect(() => {
    if(!Array.isArray(players)){
      return;
    }
    const filteredPlayers = players
    .filter(player => filterTeamId === "" || player.teamId === Number(filterTeamId))
    .filter(player => filterPosition === "" || player.position === Number(filterPosition))

    const totalEntries = filteredPlayers.length; 
    const paginatedPlayers = filteredPlayers.slice(page * count, (page + 1) * count);
  
    setViewData({ players: paginatedPlayers, totalEntries: totalEntries });
  
  }, [players, filterTeamId, filterPosition, page]);
  

  const handlePageChange = (pageNumber) => {
    setPage(pageNumber);
  };

  const handleChangeFilterTeam = (event) => {
    setFilterTeamId(event.target.value);
    setPage(0); 
  };

  const handleChangeFilterPosition = (event) => {
    setFilterPosition(event.target.value);
    setPage(0);
  };

  const handleSubmit = (player) => {
    handleConfirm(player);
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
        <Form className='mb-4'>
          <Row>
            <Col>
              <Form.Group controlId="teamFilter">
                <Form.Label>Filter Team:</Form.Label>
                <Form.Control as="select" value={filterTeamId || ''} onChange={handleChangeFilterTeam}>
                  <option value="">All</option>
                  {teams.map((team, index) => (
                    <option key={index} value={team.id}>
                      {team.name}
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
                  {positionOptions.map((position) => (
                    <option key={position.id} value={position.id}>
                      {position.name}
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
          <Container className="mt-4">
          {viewData.players.map((player) => (
            <Row key={player.id} className='mb-2'>
              <Col xs={1} className='d-flex align-self-center'>
                <p className='small-text m-0'>
                  {(() => {
                    switch (player.position) {
                      case 0:
                        return "GK";
                      case 1:
                        return "DF";
                      case 2:
                        return "MF";
                      case 3:
                        return "FW";
                    }})()}
                </p>
              </Col>
              <Col xs={4} className='d-flex align-self-center'>
                <p className='small-text m-0'>{player.firstName != "" ? player.firstName.charAt(0) + "." : ""} {player.lastName}</p>
              </Col>
              <Col xs={2} className='d-flex align-self-center'>
                <p className='small-text m-0'>{teams.find(team => team.id === player.teamId).abbreviatedName}</p>
              </Col>
              <Col xs={2} className='d-flex align-self-center'>
                <p className='small-text m-0'>{`£${player.value}m`}</p>
              </Col>
              <Col xs={3} className='d-flex align-self-center'>
                <Button className="w-100" variant="primary" onClick={() => {handleSubmit(player);}}>
                  <small>Select</small>
                </Button>
              </Col>
            </Row>
          ))}
          <div style={{ overflowX: 'auto' }}>
            {renderPagination()}
          </div>
        </Container>
        )}
      </Modal.Body>
    </Modal>
  );
};

export default SelectPlayerModal;
