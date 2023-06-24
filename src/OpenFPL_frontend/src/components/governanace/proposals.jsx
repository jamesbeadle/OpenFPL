import React, { useEffect, useState } from 'react';
import { Card, Spinner } from 'react-bootstrap';

const Proposals = ({ isActive }) => {
  const [data, setData] = useState(null);
  const [isLoading, setIsLoading] = useState(false);

  useEffect(() => {
    const fetchData = async () => {
      setIsLoading(true);
      // Replace with your actual data fetching logic
      await new Promise(resolve => setTimeout(resolve, 2000)); // For example purposes only
      setIsLoading(false);
      setData('Your data');
    };

    if (isActive) {
      fetchData();
    }
  }, [isActive]);

  if (isLoading) {
    return (
      <div className="customOverlay d-flex flex-column align-items-center justify-content-center">
        <Spinner animation="border" />
        <p className='text-center mt-1'>Loading Proposals</p>
      </div>
    );
  }

  // If not loading, render your component
  return (
    <Card className="custom-card mt-1">
      <Card.Body>
        <h2>DAO Proposals</h2>
        <p>Coming soon: See all active & inactive DAO proposals.</p>
      </Card.Body>
    </Card>
  );
};

export default Proposals;
