import React, { useState, useEffect } from 'react';
import { Container, Spinner, Row, Col, Card} from 'react-bootstrap';

const Terms = () => {
  
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
      </div>
      ) :
      <Container fluid className='view-container mt-2'>
        <Row>
          <Col md={12}>
            <Card className="mb-4">
              <Card.Header>
                <div style={{marginLeft: '16px'}}>OpenFPL DAO Terms and Conditions</div></Card.Header>
              <Card.Body>
                <Card.Text>

                  <p>Last Updated: 13th October 2023</p>
                  <p>By accessing the OpenFPL website ("Site") and participating in the OpenFPL Fantasy Football DAO ("Service"), you agree to comply with and be bound by the following Terms and Conditions.</p>
                  <br />
                  <h3>Acceptance of Terms</h3>
                  <p>You acknowledge that you have read, understood, and agree to be bound by these Terms. These Terms are subject to change by a DAO proposal and vote.</p>
                  <br />
                  
                  <h3>Decentralised Structure</h3>
                  <p>OpenFPL operates as a decentralised autonomous organisation (DAO). As such, traditional legal and liability structures may not apply. Members and users are responsible for their own actions within the DAO framework.</p>
                  <br />
                  
                  <h3>Eligibility</h3>
                  <p>The Service is open to users of all ages.</p>
                  <br />
                  
                  <h3>User Conduct</h3>
                  <p>No Automation or Bots: You agree not to use bots, automated methods, or other non-human ways of interacting with the Site.</p>
                  <br />
                  
                  <h3>Username Policy</h3>
                  <p>You agree not to use usernames that are offensive, vulgar, or infringe on the rights of others.</p>
                  <br />
                  
                  <h3>Changes to Terms</h3>
                  <p>These Terms and Conditions are subject to change. Amendments will be effective upon DAO members' approval via proposal and vote.</p>
                </Card.Text>


              </Card.Body>
            </Card>
          </Col>
        </Row>
      </Container>
    );
};

export default Terms;
