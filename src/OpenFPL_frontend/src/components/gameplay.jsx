import React, { useState, useEffect } from 'react';
import { Container, Spinner, Row, Col, Card} from 'react-bootstrap';
import { Alert } from '../../../../node_modules/react-bootstrap/esm/index';

const Gameplay = () => {
  
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
              <Card.Header><h2 className="mt-4 mb-4">OpenFPL Gameplay Rules</h2></Card.Header>
              <Card.Body>
                <Card.Text>Please see below detailed rules of the OpenFPL fantasy football game.</Card.Text>
                <Alert key='warning' variant='warning'>Draft Version: For community feedback only.</Alert>
                <p>Users will setup their team before the gameweek deadline each week. When playing OpenFPL, users have the chance to win FPL tokens depending how well the players
                  in their team perform.
                </p>
                <p>The users select 15 players, 11 playing and 4 substitutes from any Premier League team.</p>
                <p>Users have a budget of 120m to pick a team at the start of the season.</p>
                <p>A players value may go up or down depending on how the community votes on a player throughout the season.</p>
              </Card.Body>
            </Card>
          </Col>
        </Row>
      </Container>
    );
};

export default Gameplay;
