import React, { useState, useEffect } from 'react';
import { Container, Spinner, Row, Col, Card, Image } from 'react-bootstrap';
import PitchImage from '../../../assets/pitch.png';

const PickTeam = () => {
  
  const [isLoading, setIsLoading] = useState(true);

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
        <p className='text-center mt-1'>Loading Team</p>
      </div>) 
      :
      <Container className="flex-grow-1 my-5">
        <Row>
          <Col md={12}>
            <Card className="mb-4">
              <Card.Body>
                <Image src={PitchImage} className="w-100" />
              </Card.Body>
            </Card>
          </Col>
        </Row>
      </Container>
    );
};

export default PickTeam;
