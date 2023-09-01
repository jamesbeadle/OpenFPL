import React, { useState, useContext, useEffect } from 'react';
import { Container, Card, Tab, Tabs, Spinner, Form, Row, Col } from 'react-bootstrap';
import { LinkContainer } from 'react-router-bootstrap';
import ClubProposals from './club-proposals';
import { TeamsContext } from "../../contexts/TeamsContext";
import { PlayersContext } from "../../contexts/PlayersContext";
import { useParams } from 'react-router-dom';
import { OpenFPL_backend as open_fpl_backend } from '../../../../declarations/OpenFPL_backend';
import { SmallFixtureIcon } from '../icons';
import { getAgeFromDOB } from '../helpers';
import getFlag from '../country-flag';

const PlayerDetails = ({  }) => {
    const { playerId } = useParams();
    const { players } = useContext(PlayersContext);
    const [player, setPlayer] = useState(null);
    const [isLoading, setIsLoading] = useState(true);
    
    useEffect(() => {
        const fetchInitialData = async () => {
            const playerDetails = players.find(p => p.id === Number(playerId));
            setPlayer(playerDetails);
            setIsLoading(false);
        };

        fetchInitialData();
    }, []);

    useEffect(() => {
        if (!players || !playerId) {
            return;
        };
        const fetchData = async () => {
            setIsLoading(true);
            const playerDetails = players.find(p => p.id === Number(playerId));
            setPlayer(playerDetails);
            setIsLoading(false);
        };

        fetchData();
    }, [playerId, players]);

    return (
        isLoading || !player ? (
            <div className="customOverlay d-flex flex-column align-items-center justify-content-center">
                <Spinner animation="border" />
                <p className='text-center mt-1'>Loading</p>
            </div>) :
        (
            <Container>
            <Card className='mb-2 mt-4'>
                <Card.Body>
                    <Card.Title className='mb-2'>
                        {player.firstName} {player.lastName}
                    </Card.Title>
                    <p className='mt-2'>Player Details Coming Soon</p>
                </Card.Body>
            </Card>
        </Container>
        )
    );
};

export default PlayerDetails;
