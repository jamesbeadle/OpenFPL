import React, { useState, useEffect } from 'react';
import { Container, Spinner, Row, Col, Card, Table } from 'react-bootstrap';

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
            <Card className="mb-4 vertical-flex">
              <Card.Body>
                <h4 className='mt-2 mb-3'>OpenFPL Gameplay Rules</h4>
                <p>Please see the below OpenFPL fantasy football gameplay rules.</p>
                
                <p>Each user begins with £300m to purchase players for their team. The value of a player can go up or down depending on how the player is rated in the DAO. 
                  Provided a certain voting threshold is reached for either a £0.25m increase or decrease, the player's value will change in that gameweek.</p>
                
                <p>Each team has 11 players, with no more than 2 selected from any single team. 
                  The team must be in a valid formation, with 1 goalkeeper, 3-5 defenders, 3-5 midfielders and 1-3 strikers. </p>

                <p>Users will setup their team before the gameweek deadline each week. When playing OpenFPL, users have the chance to win FPL tokens depending on how well 
                  the players in their team perform.</p>

                <p>In January, a user can change their entire team once. </p>

                <p>A user is allowed to make 3 transfers per week which are never carried over.</p>

                <p>Each week a user can select a star player. This player will receive double points for the gameweek. If one is not set by the start of the gameweek it will automatically be set to the
                  most valuable player in your team.
                </p>
                <h4 className='mt-4'>Points</h4>
                <p>The user can get the following points during a gameweek for their team:</p>

                <Table bordered className="table-fixed mt-4 white-text">
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
                      <td>Appearing in the game.</td>
                      <td>5</td>
                    </tr>
                    <tr>
                      <td>Every 3 saves a goalkeeper makes.</td>
                      <td>5</td>
                    </tr>
                    <tr>
                      <td>Goalkeeper or defender cleansheet.</td>
                      <td>10</td>
                    </tr>
                    <tr>
                      <td>Forward scores a goal.</td>
                      <td>10</td>
                    </tr>
                    <tr>
                      <td>Midfielder or Forward assists a goal.</td>
                      <td>10</td>
                    </tr>
                    <tr>
                      <td>Midfielder scores a goal.</td>
                      <td>15</td>
                    </tr>
                    <tr>
                      <td>Goalkeeper or defender assists a goal.</td>
                      <td>15</td>
                    </tr>
                    <tr>
                      <td>Goalkeeper or defender scores a goal.</td>
                      <td>20</td>
                    </tr>
                    <tr>
                      <td>Goalkeeper saves a penalty.</td>
                      <td>20</td>
                    </tr>
                    <tr>
                      <td>Player is highest scoring player in match.</td>
                      <td>25</td>
                    </tr>
                    <tr>
                      <td>Player receives a red card.</td>
                      <td>-20</td>
                    </tr>
                    <tr>
                      <td>Player misses a penalty.</td>
                      <td>-15</td>
                    </tr>
                    <tr>
                      <td>Each time a goalkeeper or defender concedes 2 goals.</td>
                      <td>-15</td>
                    </tr>
                    <tr>
                      <td>A player scores an own goal.</td>
                      <td>-10</td>
                    </tr>
                    <tr>
                      <td>A player receives a yellow card.</td>
                      <td>-5</td>
                    </tr>
                  </tbody>
                </Table>

                <h4 className='mt-4'>Bonuses</h4>
                <p>A user can play 1 bonus per gameweek. Each season a user starts with the following 8 bonuses:</p>

                <Table bordered className="table-fixed mt-4 white-text">
                  <colgroup>
                    <col style={{width: '100%'}} />
                  </colgroup>
                  <thead>
                    <tr>
                      <th>Bonus</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td><b>Team Boost</b>: Receive a X2 multiplier from all players from a single club that are in your team.</td>
                    </tr>
                    <tr>
                      <td><b>Goal Getter</b>: Select a player you think will score in a game to receive a X3 mulitplier for each goal scored.</td>
                    </tr>
                    <tr>
                      <td><b>Pass Master</b>: Select a player you think will assist in a game to receive a X3 mulitplier for each assist.</td>
                    </tr>
                    <tr>
                      <td><b>No Entry</b>: Select a goalkeeper or defender you think will keep a clean sheet to receive a X3 multipler on their total score.</td>
                    </tr>
                    <tr>
                      <td><b>Safe Hands</b>: Receive a X3 multiplier on your goalkeeper if they make 5 saves in a match.</td>
                    </tr>
                    <tr>
                      <td><b>Captain Fantastic</b>: Receive a X2 multiplier on your team captain's score if they score a goal in a match.</td>
                    </tr>
                    <tr>
                      <td><b>Brace Bonus</b>: Receive a X2 multiplier on a player's score if they score 2 or more goals in a game. Applies to every player who scores a brace.</td>
                    </tr>
                    <tr>
                      <td><b>Hat Trick Hero</b>: Receive a X3 multiplier on a player's score if they score 3 or more goals in a game. Applies to every player who scores a hat-trick.</td>
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

