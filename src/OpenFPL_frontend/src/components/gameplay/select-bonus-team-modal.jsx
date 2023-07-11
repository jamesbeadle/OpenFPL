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
        <p>Select a team below to receive double points for each player of the chosen team.</p>
        {teams?.isLoading ? (
          <p>Loading...</p>
        ) : (
          <Container className="mt-4">
            <Row>
            {teams.sort((a, b) => a.id - b.id).map((team, index) => (
              <Col xs={4} className='mb-2'>
                <Button className="w-100 text-truncate" variant="primary" onClick={() => { handleSubmit(team); }} style={{overflow: 'hidden'}}>
                    <small>{team.friendlyName}</small>
                </Button>
                {/* To create new row after every 3 columns */}
                {(index + 1) % 3 === 0 && <div className="w-100"></div>}
              </Col>
            ))}
            </Row>
          </Container>
        )}
      </Modal.Body>
    </Modal>
  );
};

export default SelectBonusTeamModal;
