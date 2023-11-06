import React, { useState, useEffect } from 'react';
import { Container, Spinner, Row, Col, Card, Tabs, Tab } from 'react-bootstrap';
import { useNavigate } from 'react-router-dom';
import Vision from './vision';
import Gameplay from './gameplay';
import Roadmap from './roadmap';
import Marketing from './marketing';
import Revenue from './revenue';
import DAO from './dao';
import Token from './token';
import Architecture from './architecture';

const Whitepaper = () => {
  
  const [isLoading, setIsLoading] = useState(true);
  const navigate = useNavigate();
  const [activeKey, setActiveKey] = useState("vision");

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
      </div>
      ) :
      <Container fluid className='view-container mt-2'>
        <Row className="mt-3">
                <Col xs={12}>
                    <Card>
                        <h1 className='m-4'>OpenFPL Whitepaper</h1>
                        <div className="scrollable-tab-list">
                            <Tabs defaultActiveKey="vision" id="homepage-tabs" activeKey={activeKey} onSelect={k => setActiveKey(k)} className="scrollable-tab-list">
                                <Tab eventKey="vision" title="Vision" className="tab-item">
                                    {activeKey === 'vision' && <Vision />}
                                </Tab>
                                <Tab className="bottom-border-radius tab-item" eventKey="gameplay" title="Gameplay">
                                    {activeKey === 'gameplay' && <Gameplay />}
                                </Tab>
                                <Tab className="bottom-border-radius tab-item" eventKey="roadmap" title="Roadmap">
                                    {activeKey === 'roadmap' && <Roadmap />}
                                </Tab>
                                <Tab className="bottom-border-radius tab-item" eventKey="marketing" title="Marketing">
                                    {activeKey === 'marketing' && <Marketing />}
                                </Tab>
                                <Tab className="bottom-border-radius tab-item" eventKey="revenue" title="Revenue">
                                    {activeKey === 'revenue' && <Revenue />}
                                </Tab>
                                <Tab className="bottom-border-radius tab-item" eventKey="dao" title="DAO">
                                    {activeKey === 'dao' && <DAO />}
                                </Tab>
                                <Tab className="bottom-border-radius tab-item" eventKey="token" title="Tokenomics">
                                    {activeKey === 'token' && <Token />}
                                </Tab>
                                <Tab className="bottom-border-radius tab-item" eventKey="architecture" title="Architecture">
                                    {activeKey === 'architecture' && <Architecture />}
                                </Tab>
                            </Tabs>
                        </div>
                    </Card>
                </Col>
            </Row>
      </Container>
    );
};

export default Whitepaper;
