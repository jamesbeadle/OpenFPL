import React, { useEffect, useState } from 'react';
import { Card, Spinner } from 'react-bootstrap';

const AdvertisingProposals = ({ isActive }) => {
  const [proposals, setProposals] = useState(null);
  const [isLoading, setIsLoading] = useState(false);

  useEffect(() => {
    const fetchProposals = async () => {
      setIsLoading(true);
      // Replace with your actual data fetching logic
      await new Promise(resolve => setTimeout(resolve, 2000)); // For example purposes only
      setIsLoading(false);
      setProposals('Your proposals');
    };

    if (isActive) {
      fetchProposals();
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
        <h2>Advertising Proposals</h2>
        <p>Earn $FPL rewards for participating in decision making. Check out the latest proposals below.</p>
      </Card.Body>
    </Card>
  );
};

export default AdvertisingProposals;
