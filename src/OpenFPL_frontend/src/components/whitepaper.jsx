import React, { useState, useEffect, useContext } from 'react';
import { Container, Spinner, Row, Col, Card, Accordion } from 'react-bootstrap';
import { AuthContext } from "../contexts/AuthContext";

const Whitepaper = () => {
  
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
              <Card.Header><h2 className="mt-4 mb-4">OpenFPL SNS Whitepaper</h2></Card.Header>
              <Card.Body>
                <Card.Text>
                  Welcome to the OpenFPL whitepaper version 1.
                </Card.Text>
                <Accordion>
                  <Accordion.Item eventKey="0">
                    <Accordion.Header>Product Details</Accordion.Header>
                    <Accordion.Body>
                      Test.
                    </Accordion.Body>
                  </Accordion.Item>
                  <Accordion.Item eventKey="1">
                    <Accordion.Header>OpenFPL DAO</Accordion.Header>
                    <Accordion.Body>
                      Test.
                    </Accordion.Body>
                  </Accordion.Item>
                  <Accordion.Item eventKey="2">
                    <Accordion.Header>FPL Utility Token</Accordion.Header>
                    <Accordion.Body>
                      Test.
                    </Accordion.Body>
                  </Accordion.Item>
                  <Accordion.Item eventKey="3">
                    <Accordion.Header>SNS Token Allocation</Accordion.Header>
                    <Accordion.Body>
                      Test.
                    </Accordion.Body>
                  </Accordion.Item>
                  <Accordion.Item eventKey="4">
                    <Accordion.Header>OpenFPL Treasury</Accordion.Header>
                    <Accordion.Body>
                      Test.
                    </Accordion.Body>
                  </Accordion.Item>
                  <Accordion.Item eventKey="5">
                    <Accordion.Header>Tokenomics</Accordion.Header>
                    <Accordion.Body>
                      Test.
                    </Accordion.Body>
                  </Accordion.Item>
                </Accordion>
              </Card.Body>
            </Card>
          </Col>
        </Row>
      </Container>
    );
};

export default Whitepaper;
