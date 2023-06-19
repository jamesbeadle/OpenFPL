import React, { useState, useEffect } from 'react';
import { Container, Spinner, Row, Col, Card} from 'react-bootstrap';
import { Alert } from '../../../../node_modules/react-bootstrap/esm/index';

const Architecture = () => {
  
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
        <p className='text-center mt-1'>Loading</p>
      </div>) 
      :
      <Container className="flex-grow-1 my-5">
        <Row>
          <Col md={12}>
            <Card className="mb-4">
              <Card.Header><h2 className="mt-4 mb-4">OpenFPL Architecture</h2></Card.Header>
              <Card.Body>
                <Card.Text>Please see below details of the OpenFPL DAO Architecture.</Card.Text>
                <Alert key='warning' variant='warning'>Draft Version: For community feedback only.</Alert>
                <p>Coming Soon</p>
              </Card.Body>
            </Card>
          </Col>
        </Row>
      </Container>
    );
};

export default Architecture;
