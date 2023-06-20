import React, { useState, useEffect } from 'react';
import { Container, Spinner, Row, Col, Card, Table } from 'react-bootstrap';
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
                <p>Player ratings are set either at the start of the DAO or by DAO proposal. These ratings are then adjusted each week by the average ratings for that player by DAO members.</p>
                <p>During a gameweek substitutes are not included in a users score.</p>
                <p>A user is allowed to make 2 transfers per week which are never carried over.</p>
                <p>A user can make a player their captain each gameweek and that player will receive double points.</p>
                <p>In January a user can change their entire team once.</p>
                <p>No more than 3 players from a single premier league club can be in a fantasy football team.</p>

                
                <p>The user can get the following points during a gameweek for their team:</p>

                <Table striped bordered hover className="table-fixed mt-4">
                  <colgroup>
                    <col style={{width: '70%'}} />
                    <col style={{width: '30%'}} />
                  </colgroup>
                  <thead>
                    <tr>
                      <th>For</th>
                      <th>Points</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>Playing up to 60 minutes.</td>
                      <td>1</td>
                    </tr>
                    <tr>
                      <td>Playing 60 minutes or more (excluding stoppage time).</td>
                      <td>2</td>
                    </tr>
                    <tr>
                      <td>Goal scored by a goalkeeper or defender.</td>
                      <td>5</td>
                    </tr>
                    <tr>
                      <td>Goal scored by a goalkeeper or defender.</td>
                      <td>6</td>
                    </tr>
                    <tr>
                      <td>Goal scored by a midfielder.</td>
                      <td>5</td>
                    </tr>
                    <tr>
                      <td>Goal scored by a forward.</td>
                      <td>4</td>
                    </tr>
                    <tr>
                      <td>Assisting a goal.</td>
                      <td>3</td>
                    </tr>
                    <tr>
                      <td>Defender and goalkeeper clean sheets.</td>
                      <td>4</td>
                    </tr>
                    <tr>
                      <td>Midfielder clean sheet bonus.</td>
                      <td>1</td>
                    </tr>
                    <tr>
                      <td>3 keeper saves.</td>
                      <td>1</td>
                    </tr>
                    <tr>
                      <td>Penalty save.</td>
                      <td>5</td>
                    </tr>
                    <tr>
                      <td>Penalty miss.</td>
                      <td>-2</td>
                    </tr>
                    <tr>
                      <td>Bonus points.</td>
                      <td>1-3</td>
                    </tr>
                    <tr>
                      <td>Goal keeper or defender concedes 2 goals.</td>
                      <td>-1</td>
                    </tr>
                    <tr>
                      <td>Yellow card received.</td>
                      <td>-1</td>
                    </tr>
                    <tr>
                      <td>Red card received.</td>
                      <td>-3</td>
                    </tr>
                    <tr>
                      <td>Own goal scored.</td>
                      <td>-2</td>
                    </tr>
                  </tbody>
                </Table>
              </Card.Body>
            </Card>
          </Col>
        </Row>
      </Container>
    );
};

export default Gameplay;
