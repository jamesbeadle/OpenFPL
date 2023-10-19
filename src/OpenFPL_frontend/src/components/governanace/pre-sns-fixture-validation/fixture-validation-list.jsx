/* This file is for Pre-SNS purposes only to add fixture data, a new file will be created to handle this */

import React, { useState, useEffect, useContext } from 'react';
import { Card, Table, Button, Spinner } from 'react-bootstrap';
import { AuthContext } from "../../../contexts/AuthContext";
import { DataContext } from "../../../contexts/DataContext";
import { fetchValidatableFixtures } from "../../../AuthFunctions";
import { Link } from "react-router-dom";
import { getTeamById } from '../../helpers';
import Container from '../../../../../../node_modules/react-bootstrap/esm/Container';

const FixtureValidationList = () => {
  const { authClient } = useContext(AuthContext);
  const { teams, players, systemState } = useContext(DataContext);
  const [fixtures, setFixtures] = useState([]);
  const [isLoading, setIsLoading] = useState(true);
  const [currentGameweek, setCurrentGameweek] = useState(systemState.activeGameweek);
  const [currentSeason, setCurrentSeason] = useState(systemState.activeSeason);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const fixturesToValidate = await fetchValidatableFixtures(authClient);
        setFixtures(fixturesToValidate);
      } catch (error) {
        console.error(error);
      } finally {
        setIsLoading(false);
      }
    };

    fetchData();
  }, [authClient, teams, players]);

  if (isLoading) {
    return (
      <div className="customOverlay d-flex flex-column align-items-center justify-content-center">
        <Spinner animation="border" />
        <p className='text-center mt-1'>Loading Fixtures</p>
      </div>
    );
  }

  return (
    <Container className="flex-grow-1 my-5">
      <Card>
        <p className='px-4 mt-3'>This view will be removed after the SNS decentralisation sale</p></Card>
      <Card className="custom-card mt-3 px-4">
        <Card.Header>{`Season ${currentSeason.name}`} - {`Gameweek ${currentGameweek}`}</Card.Header>
        <Card.Body>
          <Table responsive bordered className="table-fixed">
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
                    <td>{`${getTeamById(teams, fixture.homeTeamId).name} vs ${getTeamById(teams, fixture.awayTeamId).name}`}</td>
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
    </Container>
  );
};

export default FixtureValidationList;
