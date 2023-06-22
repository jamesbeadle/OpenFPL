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
      </div>) 
      :
      <Container className="flex-grow-1 my-5">
        <Row>
          <Col md={12}>
            <Card className="mb-4">
              <Card.Header><h2 className="mt-4 mb-4">OpenFPL DAO Terms and Conditions</h2></Card.Header>
              <Card.Body>
                <Card.Text>
                  <p>Welcome to OpenFPL DAO. Please read these Terms and Conditions carefully before using this platform. By accessing or using the OpenFPL DAO, you agree to be bound by these Terms and Conditions. If you disagree with any part of the terms, you may not access the platform.</p>

                  <h3>1. Eligibility</h3>
                  <p>You must be at least 18 years old to access or use the OpenFPL DAO. By using the platform, you represent and warrant that you are of legal age to form a binding contract and meet all of the foregoing eligibility requirements. If you do not meet all of these requirements, you must not access or use the platform.</p>

                  <h3>2. Prohibited Uses</h3>
                  <p>You may use the platform only for lawful purposes and in accordance with these Terms and Conditions. You agree not to use the platform in any way that violates any applicable local or international law or regulation.</p>

                  <h3>3. Terms and Conditions Updates</h3>
                  <p>Any changes to these Terms and Conditions will be communicated to users in advance, giving them the opportunity to review the updates before they take effect. Continued use of the platform after new terms have taken effect constitutes acceptance of those changes.</p>

                  <h3>4. Responsibilities and Obligations</h3>
                  <p>All users are responsible for ensuring no under 18 year olds participate in any form of gambling in private leagues within OpenFPL DAO. Any user found to be in breach of this will have their account suspended indefinitely.</p>

                  <h3>5. Disclaimer</h3>
                  <p>All information provided on the OpenFPL DAO is provided “as is” without warranties of any kind, either express or implied, including without limitation, warranties of title, implied warranties of merchantability, fitness for a particular purpose or non-infringement of intellectual property.</p>

                  <h3>6. Limitation of Liability</h3>
                  <p>In no event will OpenFPL DAO be liable with respect to any subject matter of this agreement under any contract, negligence, strict liability or other legal or equitable theory for any indirect, incidental, consequential, special, exemplary or punitive damages.</p>
                </Card.Text>


              </Card.Body>
            </Card>
          </Col>
        </Row>
      </Container>
    );
};

export default Terms;
