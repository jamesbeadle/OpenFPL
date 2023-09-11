import React, { useContext } from 'react';
import { Modal, Button, Container, Row, Col } from 'react-bootstrap';
import { DataContext } from "../../contexts/DataContext";

const SelectBonusTeamModal = ({ show, handleClose, handleConfirm, bonusType  }) => {
  
  const { teams } = useContext(DataContext);
 
  const handleSubmit = (data) => {
    handleConfirm(data);
  };

  return (
    <Modal show={show} onHide={handleClose} centered>
      <Modal.Header closeButton>
        <Modal.Title>Bonus: Team Boost</Modal.Title>
      </Modal.Header>
      <Modal.Body>
        <p>Select a team below to receive double points for each player of the chosen team.</p>
        <p style={{width: 'calc(100% - 1rem)', margin: '0rem 0rem'}} className='small-text warning-text'><small>A bonus can only be used once per season and only one bonus can be used per gameweek.</small></p>
        {teams?.isLoading ? (
          <p>Loading...</p>
        ) : (
          <Container className="mt-4">
            <Row>
            {teams.sort((a, b) => a.id - b.id).map((team, index) => (
              <Col xs={4} className='mb-2' key={index}>
                <Button className="w-100 text-truncate" variant="primary" onClick={() => { handleSubmit({ teamId: team.id, bonusType }); }} style={{overflow: 'hidden'}}>
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
