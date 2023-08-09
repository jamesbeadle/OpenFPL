import React, { useState, useEffect, useContext } from 'react';
import { Card, Table, Button, Spinner } from 'react-bootstrap';
import { AuthContext } from "../../contexts/AuthContext";
import { OpenFPL_backend as open_fpl_backend } from '../../../../declarations/OpenFPL_backend';
import { Actor } from "@dfinity/agent";
import { Link } from "react-router-dom";

const FixtureValidationList = () => {
  const { authClient, teams, players } = useContext(AuthContext);
  const [isLoading, setIsLoading] = useState(true);
  const [fixtures, setFixtures] = useState([]);
  const [currentGameweek, setCurrentGameweek] = useState(null);
  const [currentSeason, setCurrentSeason] = useState(null);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const currentGameweekData = await open_fpl_backend.getCurrentGameweek();
        setCurrentGameweek(currentGameweekData);

        const currentSeasonData = await open_fpl_backend.getCurrentSeason();
        setCurrentSeason(currentSeasonData);

        const identity = authClient.getIdentity();
        Actor.agentOf(open_fpl_backend).replaceIdentity(identity);
        
        const fixturesToValidate = await open_fpl_backend.getValidatableFixtures();
        setFixtures(fixturesToValidate);

      } catch (error) {
        console.error(error);
      } finally {
        setIsLoading(false);
      }
    };

    fetchData();
  }, [authClient, teams, players]);

  const getTeamNameFromId = (teamId) => {
    const team = teams.find(team => team.id === teamId);
    if(!team){
      return;
    }
    return team.friendlyName;
  }

  if (isLoading) {
    return (
      <div className="customOverlay d-flex flex-column align-items-center justify-content-center">
        <Spinner animation="border" />
        <p className='text-center mt-1'>Loading Fixtures</p>
      </div>
    );
  }

  return (
    <Card className="custom-card mt-1">
      <Card.Header>{`Season ${currentSeason.name}`} - {`Gameweek ${currentGameweek}`}</Card.Header>
      <Card.Body>
        <Table responsive bordered className="table-fixed light-table">
          <thead>
            <tr>
              <th>#</th>
              <th>Match</th>
              <th>Status</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
            {fixtures.map((fixture, index) => (
                <tr key={fixture.id}>
                  <td>{index + 1}</td>
                  <td>{`${getTeamNameFromId(fixture.homeTeamId)} vs ${getTeamNameFromId(fixture.awayTeamId)}`}</td>
                  <td>{fixture.status === 2 ? "Completed" : "Active"}</td>
                  <td>
                    <Button as={Link} variant={fixture.status === 2 ? "primary" : "secondary"} to={`/add-fixture-data?fixtureId=${fixture.id}`}>
                      Add Player Event Data
                    </Button>
                  </td>
                </tr>
              ))}
          </tbody>
        </Table>
      </Card.Body>
    </Card>
  );
};

export default FixtureValidationList;
