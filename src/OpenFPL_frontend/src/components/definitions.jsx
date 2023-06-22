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
              <Card.Header><h2 className="mt-4 mb-4">OpenFPL DAO Forumla Definitions</h2></Card.Header>
              <Card.Body>
                <Card.Text>Please see below further definitions of formula mentioned in the OpenFPL DAO.</Card.Text>
                <h4 className='mt-4'>Game event data formula</h4>
                <p>After a game has finished its state moves to awaiting consensus. When in this state it appears in the OpenFPL DAO for neuron holders to
                  fill in statistical information for the game. 
                </p>
                <p>
                  A neuron holder receives rewards, proportional to their voting power for each correcly completed game.  
                </p>
                <p>
                  These rewards are subject to a time multiplier, with earlier submissions receiving a higher time multiplier than lower submissions.
                </p>
                <p>Please see below sample calcuation on how rewards would be calculated using the intial DAO setup values:</p>
                <p>A user doesn't know how early they are in adding the data until after consensus has been reached.</p>
                
                <Image src={EventCalcImage} alt="openfpl" rounded fluid className="ml-4 mr-4 mt-4 mb-4 w-100" />
                <h4 className='mt-4'>Data Validation Council Rewards Formula</h4>
                <p>If a game reaches consensus and the result is different from the secondary third party check, they game appears as unresolved until any members of the 
                  data validation council have confirmed the result with a voting power of 1,000,000 split with a maximum voting power of 100,000 per neuron. 
                </p>
                <p>
                  A council member neuron receives rewards vor confirming results, proportional to their voting power on the votes cast.  
                </p>
                <p>
                  These rewards are subject to a time multiplier, with earlier submissions receiving a higher time multiplier than lower submissions.
                </p>
                <p>Please see below sample calcuation on how rewards would be calculated using the intial DAO setup values:</p>
                <p>A council member doesn't know how early they are in confirm the correct data until after consensus has been reached.</p>
                
                <Image src={CouncilCalcImage} alt="openfpl" rounded fluid className="ml-4 mr-4 mt-4 mb-4 w-100" />

                <h4 className='mt-4'>Player Pricing Formula and Reward Calculation</h4>
                <p>A players value will go up when a user adjusts their rating within the DAO. Users can select a positive or negative rating for any player, 3 times a season. 
                  The ratings for that player are averaged for each week, weighted by voting power and a players price adjusts.</p>
                

              </Card.Body>
            </Card>
          </Col>
        </Row>
      </Container>
    );
};

export default Definitions;
