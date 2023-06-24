import React, { useState, useEffect } from 'react';
import { Container, Spinner, Row, Col, Card, Image} from 'react-bootstrap';
import EventCalcImage from "../../assets/event_calc.png";
import CouncilCalcImage from "../../assets/council_calc.png";

const Definitions = () => {
  
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
              <Card.Header><h2 className="mt-4 mb-4">OpenFPL Governance</h2></Card.Header>
              <Card.Body>
                <Card.Text>OpenFPL DAO Governance.</Card.Text>
                <h4 className='mt-4'>Game event data formula</h4>
                <p>Coming soon 
                </p>
              </Card.Body>
            </Card>
          </Col>
        </Row>
      </Container>
    );
};

export default Definitions;
