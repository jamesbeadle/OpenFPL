import React from 'react';
import { Container, Row, Col, Card, Button, Dropdown, Spinner, Modal } from 'react-bootstrap';
import { StarIcon, StarOutlineIcon,  PlayerIcon, TransferIcon } from '../icons';

const BonusPanel = ({bonuses, handleBonusClick, show, handleClose}) => (
    <Row>
    
      {
      bonuses.map((bonus, index) =>
      <Col xs={12} md={3} key={index}>
        <Card className='mb-2'>
        <div className='bonus-card-item'>
        <div className='text-center mb-2'>
          <StarIcon color="#807A00" />
        </div>
        <div className='text-center mb-2'>{bonus.name}</div>
        <Button variant="primary w-100" onClick={() => handleBonusClick(bonus)} style={{ display: 'block' }}>
          Use
        </Button>
      </div>
        </Card>
      
      </Col> 
      )}
      <Modal show={show} onHide={handleClose}>
        <Modal.Header closeButton>
          <Modal.Title>Confirmation</Modal.Title>
        </Modal.Header>
        <Modal.Body>You can only use 1 bonus per gameweek. Are you sure you want to proceed?</Modal.Body>
        <Modal.Footer>
          <Button variant="secondary" onClick={handleClose}>
            Close
          </Button>
          <Button variant="primary" onClick={handleClose}>
            Confirm
          </Button>
        </Modal.Footer>
      </Modal>
    </Row>
  );

  export default BonusPanel;
