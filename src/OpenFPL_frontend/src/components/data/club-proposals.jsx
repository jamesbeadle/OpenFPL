import React, { useState } from 'react';
import { Container } from 'react-bootstrap';

const ClubProposals = ({ teamId }) => {
    const [key, setKey] = useState('details');

    return (
        <Container>
            <p className='mt-4'>Coming Soon</p>
        </Container>
    );
};

export default ClubProposals;
