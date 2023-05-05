import React, { useState, useEffect, useContext } from 'react';
import { Container, Spinner, Row, Col, Card, Accordion } from 'react-bootstrap';
import { AuthContext } from "../contexts/AuthContext";
import Image from "react-bootstrap/Image";

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
              <Card.Header><h2 className="mt-4 mb-4">OpenFPL Whitepaper</h2></Card.Header>
              <Card.Body>
                <Card.Text>
                  Please see below details of the proposed OpenFPL DAO.
                </Card.Text>
                <Accordion>
                  <Accordion.Item eventKey="0">
                    <Accordion.Header as="h1">Product Details</Accordion.Header>
                    <Accordion.Body>
                      <p>
                        OpenFPL is a decentralised fantasy football app for the Premier League running on the Internet Computer blockchain. It will run with rules similar to other 
                        major Premier League fantasy football apps to ensure wide adoption from the existing user base of fantasy football enthusiasts.
                      </p>
                      <p>
                        OpenFPL is a progessive web application (PWA) to work with any device as it were a native app. A canister is created when the max users per canister threshold 
                        is reached allowing the application to scale to the potentially billions of Premier League football fans around the world. A separate canister holds group information. 
                      </p>
                      <p>OpenFPL is <a target='_blank' href="https://www.github.com">open source</a> and runs a collection of canister smart contracts designed
                      to scale to millions of users playing every week.
                      </p>
                      <p>A canister is created for each prediction gameweek and stores around 60 bytes of data for each users prediction. This enables the gameweek canister to hold roughly 70
                         million predictions per week, about 10 times the capacity required for every player using the market leading fantasy football app to make submit their team. </p>
                    </Accordion.Body>
                  </Accordion.Item>
                  <Accordion.Item eventKey="1">
                    <Accordion.Header>OpenFPL DAO</Accordion.Header>
                    <Accordion.Body>
                    </Accordion.Body>
                  </Accordion.Item>
                  <Accordion.Item eventKey="2">
                    <Accordion.Header>FPL Utility Token</Accordion.Header>
                    <Accordion.Body>
                      Test.
                    </Accordion.Body>
                  </Accordion.Item>
                  <Accordion.Item eventKey="3">
                    <Accordion.Header>Genesis Token Allocation</Accordion.Header>
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
