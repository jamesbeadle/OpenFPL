import React, { useState, useEffect } from 'react';
import { Container, Spinner, Row, Col, Card, Image} from 'react-bootstrap';
import ArchitectureImage from "../../assets/architecture.jpg";

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
                <h4>Canister Architecture</h4>
                <p>A canister is created for each prediction gameweek and stores around 60 bytes of data for each users prediction. 
                  This enables the gameweek canister to hold roughly 70 million predictions per week, about 7 times the capacity required for every player 
                  using the market leading fantasy football app to make submit their team.
                </p>
                <p>
                  A canister watcher checks a current gameweek's canisters size and automatically creates additional canisters if the canister size reaches 80% full. 
                </p>
                <Card.Text>Please see below details of the OpenFPL DAO Architecture.</Card.Text>
                <Image src={ArchitectureImage} alt="openfpl" rounded fluid className="ml-4 mr-4 mt-4 mb-4 w-100" />
              </Card.Body>
            </Card>
          </Col>
        </Row>
      </Container>
    );
};

export default Architecture;
