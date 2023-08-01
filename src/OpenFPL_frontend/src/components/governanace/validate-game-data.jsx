import React, { useState, useEffect, useContext } from 'react';
import { Card, Table, Button, Spinner } from 'react-bootstrap';
import { AuthContext } from "../../contexts/AuthContext";
import { OpenFPL_backend as open_fpl_backend } from '../../../../declarations/OpenFPL_backend';
import { Actor } from "@dfinity/agent";

const ValidateGameData = () => {
  const { authClient, teams, players } = useContext(AuthContext);
  const [isLoading, setIsLoading] = useState(true);
  const [games, setGames] = useState([]);
  const [currentGameweek, setCurrentGameweek] = useState(null);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const currentGameweekData = await open_fpl_backend.getCurrentGameweek();
        setCurrentGameweek(currentGameweekData);

        const identity = authClient.getIdentity();
        Actor.agentOf(open_fpl_backend).replaceIdentity(identity);
        
        // Assuming there's a method to fetch games that need validation.
        const gamesToValidate = await open_fpl_backend.getGamesToValidate();
        setGames(gamesToValidate);

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
        <p className='text-center mt-1'>Loading Games</p>
      </div>
    );
  }

  return (
    <Card className="custom-card mt-1">
      <Card.Body>
        <h2>Validating Game Data</h2>
        <h4>{currentGameweek ? `${currentGameweek.season} - ${currentGameweek.gameweek}` : 'Loading gameweek...'}</h4>
        <Table striped bordered hover>
          <thead>
            <tr>
              <th>#</th>
              <th>Match</th>
              <th>Status</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
            {games.map((game, index) => (
              <tr key={game.id}>
                <td>{index + 1}</td>
                <td>{`${game.team1} vs ${game.team2}`}</td>
                <td>{game.status}</td>
                <td>
                  {game.status === 'Completed' ? (
                    <Button variant="primary">Enter Draft Data</Button>
                  ) : (
                    <Button variant="secondary">Enter Data</Button>
                  )}
                </td>
              </tr>
            ))}
          </tbody>
        </Table>
      </Card.Body>
    </Card>
  );
};

export default ValidateGameData;
