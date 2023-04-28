import React, { useState, useEffect, useContext } from 'react';
import { Container, Spinner } from 'react-bootstrap';
import { AuthContext } from "../contexts/AuthContext";

const Whitepaper = () => {
  
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
      <Container className="flex-grow-1">
        <br />
        <div className="d-flex" style={{ height: '100%' }}>
          <h2>OpenFPL SNS Whitepaper</h2>
          <button className='btn btn-primary'>test</button>
        </div>
      </Container>  
    );
};

export default Whitepaper;
