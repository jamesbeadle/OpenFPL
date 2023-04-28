import React, { useState, useEffect, useContext } from 'react';
import { Container, Spinner } from 'react-bootstrap';
import { AuthContext } from "../contexts/AuthContext";

const Home = () => {
  
  const [isLoading, setIsLoading] = useState(true);
  const { isAuthenticated, login } = useContext(AuthContext);

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
      <Container className="flex-grow-1">
        <br />
        <div className="d-flex justify-content-center align-items-center" style={{ height: '100%' }}>
          <h2>Welcome to OpenFPL</h2>
        </div>
      </Container>  
    );
};

export default Home;
