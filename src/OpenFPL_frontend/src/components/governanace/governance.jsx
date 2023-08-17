import React, { useState, useEffect } from 'react';
import { Container, Spinner, Tabs, Tab } from 'react-bootstrap';
import FixtureValidationList from './fixture-validation/fixture-validation-list';

const Governance = () => {
  
  const [isLoading, setIsLoading] = useState(true);
  const [key, setKey] = useState('games');

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
        <h1>OpenFPL DAO Governance</h1>
        <br />
        <Tabs defaultActiveKey="games" id="profile-tabs" className="mt-4" activeKey={key} onSelect={(k) => setKey(k)}>
         <Tab eventKey="games" title="Fixture Validation">
            <FixtureValidationList isActive={key === 'games'} />
          </Tab>
        </Tabs>
      </Container>
    );
};

export default Governance;

/* Tabs to add in later:
import PlayerValuations from './player-valuations';
import Proposals from './proposals';
import AdvertisingProposals from './advertising-proposals';


 <Tab eventKey="valuations" title="Player Valuations">
            <PlayerValuations isActive={key === 'valuations'} />
          </Tab>
          <Tab eventKey="proposals" title="Proposals">
              <Proposals isActive={key === 'proposals'} />
          </Tab>  
          
          <Tab eventKey="advertising" title="Advertising Proposals">
            <AdvertisingProposals isActive={key === 'advertising'} />
          </Tab>

*/
