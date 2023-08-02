import React, { useState, useEffect, useContext } from 'react';
import { Container, Row, Col, Card, Spinner } from 'react-bootstrap';
import { StarIcon, PlayerIcon } from '../icons';
import { OpenFPL_backend as open_fpl_backend } from '../../../../declarations/OpenFPL_backend';
import { AuthContext } from "../../contexts/AuthContext";
import { Actor } from "@dfinity/agent";

const ViewPoints = () => {
  const { authClient, teams, players } = useContext(AuthContext);
  const [isLoading, setIsLoading] = useState(true);
  const [fantasyTeam, setFantasyTeam] = useState({
    players: [],
  });
  const [currentGameweek, setCurrentGameweek] = useState(null);

  // ... (similar structure for fetching the data)

  const renderPlayerPoints = (player) => {
     (
      <Card>
        <Row className='mx-1 mt-2'>
            <Col xs={3}>
                <Row>
                    {/* ... (Similar PlayerIcon and info structure) */}
                </Row>
                </Col>
                <Col xs={9}>
                <Row>
                    <Col xs={9}>
                    {/* ... (Similar Player Name structure) */}
                    </Col>
                    <Col xs={3}>
                    {/* Here is where you can display the player's points */}
                    <p>{player.fantasyPoints} pts</p>
                    </Col>
                </Row>
            </Col>
        </Row>
    </Card>
    );
  }


  return (
    isLoading ? (
        <div className="customOverlay d-flex flex-column align-items-center justify-content-center">
        <Spinner animation="border" />
        <p className='text-center mt-1'>Loading Points...</p>
        </div>
    ) :
    <Container className="flex-grow-1 my-5">
        <Row className="mb-4">
        <Col md={9}>
            <Card className="mt-4">
            <Card.Header>
                {/* ... (Same header structure for Gameweek and Team) */}
            </Card.Header>
            <Card.Body>
                {fantasyTeam && fantasyTeam.players && fantasyTeam.players.map(player => renderPlayerPoints(player))}
            </Card.Body>
            </Card>
        </Col>
        </Row>
    </Container>
    );


};


export default ViewPoints;
