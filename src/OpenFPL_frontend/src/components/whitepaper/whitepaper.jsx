import React, { useState, useEffect } from 'react';
import { Container, Spinner, Row, Col, Card, Accordion, Image, Table, Button } from 'react-bootstrap';
import { ExitIcon } from '../icons';
import { useNavigate } from 'react-router-dom';

const Whitepaper = () => {
  
  const [isLoading, setIsLoading] = useState(true);
  const navigate = useNavigate();

  useEffect(() => {
    const fetchData = async () => {
      await fetchViewData();
      setIsLoading(false);
    };
    fetchData();
  }, []);

  const fetchViewData = async () => {
    
  };
  
  return (
    isLoading ? (
      <div className="customOverlay d-flex flex-column align-items-center justify-content-center">
          <Spinner animation="border" />
          <p className='text-center mt-1'>Loading</p>
      </div>
      ) :
      <Container fluid className='view-container mt-2'>
        <Row>
          <Col md={12}>
            <Card className="mb-4">
              <Card.Header>
                <div style={{marginLeft: '16px'}}>OpenFPL SNS Whitepaper</div></Card.Header>
              <Card.Body>
                <Card.Text>Coming Soon.</Card.Text>
              </Card.Body>
            </Card>
          </Col>
        </Row>
      </Container>
    );
};

export default Whitepaper;
