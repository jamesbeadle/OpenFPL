import React, { useState, useEffect } from 'react';
import { Container, Spinner, Row, Col, Card } from 'react-bootstrap';
import TeamData from './team-data';
import PlayerData from './player-data';
import FixtureData from './fixture-data';

const DataViewer = () => {
  
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
        <h1>OpenFPL DAO Data Viewer</h1>
        <br />
        <Tabs defaultActiveKey="data" id="data-tabs" className="mt-4" activeKey={key} onSelect={(k) => setKey(k)}>
          <Tab eventKey="teams" title="Teams">
              <TeamData isActive={key === 'teams'} />
          </Tab>  
          <Tab eventKey="players" title="Players">
            <PlayerData isActive={key === 'players'} />
          </Tab>
          <Tab eventKey="fixtures" title="Fixtures">
            <FixtureData isActive={key === 'fixtures'} />
          </Tab>
        </Tabs>
      </Container>
    );
};

export default DataViewer;
