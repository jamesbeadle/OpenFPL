import React, { useState, useEffect, useContext } from 'react';
import { Container, Row, Col, Card, Spinner } from 'react-bootstrap';
import { useNavigate } from "react-router-dom";
import { AuthContext } from "../../contexts/AuthContext";

const Admin = () => {
  const { authClient, isAdmin } = useContext(AuthContext);
  const navigate = useNavigate();
  const [isLoading, setIsLoading] = useState(true);
  const [viewData, setViewData] = useState(null);
  
  useEffect(() => {
    if(!isAdmin){
      navigate("/");
    }
    const fetchData = async () => {
      await fetchViewData();
    };
    fetchData();
  }, []);

  const fetchViewData = async () => {
    setIsLoading(false);
  };

  return (
      isLoading ? (
        <div className="customOverlay d-flex flex-column align-items-center justify-content-center">
          <Spinner animation="border" />
          <p className='text-center mt-1'>Loading Admin</p>
        </div>
      ) : 
      <Container>
        <Row className="justify-content-md-center">
          <Col md={8}>
            <Card className="mt-4 custom-card mb-4">
              <Card.Header className="text-center">
                <h2>Admin</h2>
              </Card.Header>
              <Card.Body>
                <p className="mt-3">
                  <strong>Admin View TBC</strong>
                </p>
              </Card.Body>
            </Card>
          </Col>
        </Row>
      </Container>
  );
};

export default Admin;
