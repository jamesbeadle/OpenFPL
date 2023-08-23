import React, { useState, useEffect, useContext } from 'react';
import { Row, Col, Card, Button, Spinner } from 'react-bootstrap';
import { OpenFPL_backend as open_fpl_backend } from '../../../../declarations/OpenFPL_backend';
import { AuthContext } from "../../contexts/AuthContext";
import { TeamsContext } from "../../contexts/TeamsContext";
import { Actor } from "@dfinity/agent";
import { FixtureIcon } from '../icons';

const Fixtures = () => {
  const { authClient } = useContext(AuthContext);
  const { teams } = useContext(TeamsContext);
  const [isLoading, setIsLoading] = useState(true);

  const [allFixtures, setAllFixtures] = useState([]);
  const [fixtures, setFixtures] = useState([]);
  const [currentGameweek, setCurrentGameweek] = useState(1);
  
  useEffect(() => {
    const fetchData = async () => {
      await fetchActiveGameweek();
      await fetchViewData();
      setIsLoading(false);
    };
    fetchData();
  }, []);

  const fetchActiveGameweek = async () => {
      const activeGameweekData = await open_fpl_backend.getCurrentGameweek();
      setCurrentGameweek(activeGameweekData);
  };
  
  const fetchViewData = async () => {
    const identity = authClient.getIdentity();
    Actor.agentOf(open_fpl_backend).replaceIdentity(identity);
  
    const fixturesData = await open_fpl_backend.getFixtures();
    setAllFixtures(fixturesData);
  };

  useEffect(() => {
    const filteredFixtures = allFixtures.filter(fixture => fixture.gameweek === currentGameweek);
    setFixtures(filteredFixtures);
  }, [allFixtures, currentGameweek]);

  const handleGameweekChange = (change) => {
    setCurrentGameweek(prev => Math.min(38, Math.max(1, prev + change)));
  }

  const getTeamById = (teamId) => {
    return teams.find(team => team.id === teamId);
  }
  
  
  return (
    isLoading ? (
      <div className="customOverlay d-flex flex-column align-items-center justify-content-center">
        <Spinner animation="border" />
        <p className='text-center mt-1'>Loading Fixtures</p>
      </div>) 
      :
      <Card className="mt-4 mb-4">
        <Card.Header>
        Fixtures
        </Card.Header>
        <Card.Body>
        <Row className="d-flex align-items-center">
            <div style={{flex: 1, padding: '0 5px'}}>
                <Button className="w-100 justify-content-center" onClick={() => handleGameweekChange(-1)} disabled={currentGameweek === 1}>{"<"}</Button>
            </div>
            <div style={{flex: 3, textAlign: 'center', padding: '0 5px'}}>
                <small>Gameweek {currentGameweek}</small>
            </div>
            <div style={{flex: 1, padding: '0 5px'}}>
                <Button className="w-100 justify-content-center" onClick={() => handleGameweekChange(1)} disabled={currentGameweek === 38}>{">"}</Button>
            </div>
        </Row>
        <br />
        {fixtures.map((fixture, i) => (
            <Row className='align-items-center small-text mt-2' key={fixture.id}>
                <Col xs={2} className='text-center d-flex justify-content-center align-items-center' style={{padding: 0}}>
                  <div style={{padding: '0 5px'}}>
                      <FixtureIcon primaryColour={getTeamById(fixture.homeTeamId).primaryColourHex} secondaryColour={getTeamById(fixture.homeTeamId).secondaryColourHex} />
                  </div>
                </Col>
                <Col xs={3} className='text-center d-flex justify-content-center align-items-center' style={{margin: 0}}>
                  <p style={{margin: 0}}><small>{getTeamById(fixture.homeTeamId).abbreviatedName}</small></p>
                </Col>
                <Col xs={2} className='text-center d-flex justify-content-center align-items-center' style={{margin: 0}}>
                  <small style={{margin: 0}}>vs</small>
                </Col>
                <Col xs={3} className='text-center d-flex justify-content-center align-items-center' style={{margin: 0}}>
                  <p style={{margin: 0}}><small>{getTeamById(fixture.awayTeamId).abbreviatedName}</small></p>
                </Col>
                <Col xs={2} className='text-center d-flex justify-content-center align-items-center' style={{padding: 0}}>
                  <div style={{padding: '0 5px'}}>
                      <FixtureIcon primaryColour={getTeamById(fixture.awayTeamId).primaryColourHex} secondaryColour={getTeamById(fixture.awayTeamId).secondaryColourHex} />
                  </div>
                </Col>
            </Row>
        ))}
        </Card.Body>
    </Card>
  );
};

export default Fixtures;
