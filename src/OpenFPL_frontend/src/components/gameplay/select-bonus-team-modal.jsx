import React, { useContext } from 'react';
import { Modal, Button, Container, Row, Col } from 'react-bootstrap';
import { TeamContext } from "../../contexts/TeamContext";

const SelectBonusTeamModal = ({ show, handleClose, handleConfirm, bonusType  }) => {
  
  const { teams } = useContext(TeamContext);
  
  const handleSubmit = (team) => {
    handleConfirm({ team, bonusType });
  };

  return (
    <Modal show={show} onHide={handleClose} centered>
      <Modal.Header closeButton>
        <Modal.Title>Select Team</Modal.Title>
      </Modal.Header>
      <Modal.Body>
        {teams?.isLoading ? (
          <p>Loading...</p>
        ) : (
          <Container className="mt-4">
            {teams.map((team) => (
              <Row key={team.id} className='mb-2'>
                <Col xs={9} className='d-flex align-self-center'>
                  <p className='small-text m-0'>{team.name}</p>
                </Col>
                <Col xs={3} className='d-flex align-self-center'>
                    <Button className="w-100" variant="primary" onClick={() => { handleSubmit(team); }}>
                        <small>Select</small>
                    </Button>
                </Col>
              </Row>
            ))}
          </Container>
        )}
      </Modal.Body>
    </Modal>
  );
};

export default SelectBonusTeamModal;
