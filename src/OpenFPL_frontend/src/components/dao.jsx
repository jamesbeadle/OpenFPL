import React, { useState, useEffect } from 'react';
import { Container, Spinner, Row, Col, Card, ListGroup } from 'react-bootstrap';

const DAO = () => {
  
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
              <Card.Header><h2 className="mt-4 mb-4">OpenFPL DAO</h2></Card.Header>
              <Card.Body>
                <h4>Proposals</h4>
                <Card.Text>Please see below built in functions a neuron holder can raise a DAO proposal for by category:</Card.Text>
                <ListGroup>
                    <ListGroup.Item className="mt-1 mb-1">
                        <h6>Team:</h6>
                        <ul>
                            <li>Add a new team.</li>
                            <li>Update a team.</li>
                            <li>Relegate a team.</li>
                            <li>Reinstate a promoted team.</li>
                        </ul>
                    </ListGroup.Item>
                </ListGroup>
                <ListGroup>
                    <ListGroup.Item className="mt-1 mb-1">
                        <h6>Player:</h6>
                        <ul>
                            <li>Add a new player to a team.</li>
                            <li>Update an existing players details.</li>
                            <li>Transfer a player to another team.</li>
                            <li>Transfer a player to team outside of the Premier League.</li>
                            <li>Retire a player.</li>
                            <li>Bring a player out of retirement to a specific team.</li>
                            <li>Set a player as injured with the expected injury duration.</li>
                            <li>Revalue a player using a specific value.</li>
                        </ul>
                    </ListGroup.Item>
                </ListGroup>
                <ListGroup>
                    <ListGroup.Item className="mt-1 mb-1">
                        <h6>Fixtures:</h6>
                        <ul>
                            <li>Create fixtures.</li>
                            <li>Remove fixtures.</li>
                            <li>Update fixture date or time.</li>
                        </ul>
                    </ListGroup.Item>
                </ListGroup>
                <ListGroup>
                    <ListGroup.Item className="mt-1 mb-1">
                        <h6>Gameweek:</h6>
                        <ul>
                            <li>Add fixtures to a gameweek.</li>
                            <li>Remove fixtures from a gameweek.</li>
                            <li>Transfer fixtures between current and future gameweeks.</li>
                            <li>Postpone fixtures within a gameweek.</li>
                            <li>Add postponed fixtures to a gameweek.</li>
                        </ul>
                    </ListGroup.Item>
                </ListGroup>
                <ListGroup>
                    <ListGroup.Item className="mt-1 mb-1">
                        <h6>Data Validation Council:</h6>
                        <ul>
                            <li>Add user principal as council member.</li>
                            <li>Remove user principal as council member.</li>
                        </ul>
                    </ListGroup.Item>
                </ListGroup>
                <ListGroup>
                    <ListGroup.Item className="mt-1 mb-1">
                        <h6>General Development:</h6>
                        <ul>
                            <li>Proposals to update the codebase.</li>
                            <li>Proposals to update DAO variables.</li>
                        </ul>
                    </ListGroup.Item>
                </ListGroup>
                <h4>Automatic DAO Actions</h4>
                <ListGroup>
                    <ListGroup.Item className="mt-1 mb-1">
                        <p>The DAO is designed to automatically manage a season by performing actions at key stages in the applications lifecycle:</p>
                        <ul>
                            <li><p>The DAO begins with the first season set to 'Active', the first gameweek set to 'Transfers Enabled' 
                                and all fixtures within that gameweek have a status of 'Unplayed'.</p></li>
                            <li><p><b>Transfers Enabled</b>: Users are able to make transfers in and out of their team up to 1 hour before the first kickoff of a gameweek's fixtures.</p></li>
                            <li><p><b>Active</b>: A gameweek becomes active 1 hour before the first kickoff. At this point users are unable to make transfers and users are able to see their live scores. 
                            All games start with a status of unplayed.</p></li>
                            <li><p><b>Active (Game active)</b>: Each game will automatically be set to active at kickoff for 1 hour 45 minutes. 
                            This will enable users to add certain data points that will autofill on their game data input form. 
                            This will provide real time data and enable live score projection.</p></li>
                            <li><p><b>Consensus Required</b>: 1 hour and 45 minutes after kickoff a game has its status set to 'Conensus Required'. 
                            The game then appears for data validation for neuron holders to provide information on certain data points or confirm data entered during the active game state. 
                            </p></li>
                            <li><p><b>Consensus Acheived</b>: When a certain voting power has been met or 12 hours have passed the values are used to confirm the data for the fixture.
                             The DAO will then check if this is the final game to be completed, if it is then it will then close the gameweek. 
                            </p></li>
                            <li><p><b>Completed</b>: A gameweeks final status is completed.</p></li>
                        </ul>
                        <p>When a gameweek is marked as completed the DAO performs the following additional actions:</p>
                        <ul>
                            <li><p>The DAO calculates and stores all scores for each users team.</p></li>
                            <li><p>The DAO calculates rewards and distributes them to users.</p></li>
                            <li><p>When the DAO closes the gameweek it will set the following gameweek as the active one, enabling transfers to begin for the gameweek.</p></li>
                            <li><p>The DAO sets the closed gameweek as completed, storing any confimed gameplay data and triggering the data validation process.</p></li>
                            <li><p>If gameweek 38 is closed, the DAO marks the current season as closed.</p></li>
                            <li><p>If gameweek 38 is closed, the DAO creates the following season and sets the gameweek to gameweek 1 with a status of 'Transfers Enabled'.</p></li>
                            <li><p>If gameweek 38 is closed, the DAO rewards users in FPL from the treasury for season long acheivements, player valuations, validating game data and participating with the data verification council.</p></li>
                            <li><p>If gameweek 38 is closed, the DAO mints the FPL rewards for the following season which are transferred to the treasury.</p></li>
                        </ul>
                        <p>The DAO also resets the check on players a user has rated every 3 months, allowing a new rating to be provided by the user.</p>
                    </ListGroup.Item>
                </ListGroup>

              </Card.Body>
            </Card>
          </Col>
        </Row>
      </Container>
    );
};

export default DAO;
