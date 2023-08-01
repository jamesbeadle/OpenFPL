import React, { useState, useEffect, useContext } from 'react';
import { Form, Button, Alert } from 'react-bootstrap';
import { OpenFPL_backend as open_fpl_backend } from '../../../../declarations/OpenFPL_backend';
import { Actor } from "@dfinity/agent";
import { AuthContext } from "../../contexts/AuthContext";

const RescheduleFixtureProposal = () => {
    const { authClient } = useContext(AuthContext);

    const [seasons, setSeasons] = useState([]);
    const [selectedSeason, setSelectedSeason] = useState("");
    const [gameweeks, setGameweeks] = useState([]);
    const [selectedGameweek, setSelectedGameweek] = useState("");
    const [fixtures, setFixtures] = useState([]);
    const [selectedFixture, setSelectedFixture] = useState("");
    const [fixtureDate, setFixtureDate] = useState("");
    const [isPostponed, setIsPostponed] = useState(false);
    const [postponedFixtures, setPostponedFixtures] = useState([]);
    const [selectedPostponedFixture, setSelectedPostponedFixture] = useState("");
    const [submitStatus, setSubmitStatus] = useState(null);

    useEffect(() => {
        fetchSeasonsFromBackend().then(data => setSeasons(data)).catch(err => console.error(err));
    }, []);

    useEffect(() => {
        if (selectedSeason) {
            fetchGameweeksFromBackend(selectedSeason).then(data => setGameweeks(data)).catch(err => console.error(err));
        }
    }, [selectedSeason]);

    useEffect(() => {
        if (selectedGameweek) {
            fetchFixturesFromBackend(selectedGameweek).then(data => setFixtures(data)).catch(err => console.error(err));
        }
    }, [selectedGameweek]);

    const fetchSeasonsFromBackend = async () => {
        // Use your backend method to fetch seasons. This is a placeholder.
        return [{id: 1, name: "2022/23"}, {id: 2, name: "2023/24"}];
    }

    const fetchGameweeksFromBackend = async (seasonId) => {
        // Use your backend method to fetch gameweeks for a particular season. Placeholder below.
        return [...Array(38).keys()].map(i => ({id: i + 1, name: `Gameweek ${i + 1}`}));
    }

    const fetchFixturesFromBackend = async (gameweekId) => {
        // Use your backend method to fetch fixtures for a particular gameweek. Placeholder below.
        return [{id: 1, name: "Fixture 1"}, {id: 2, name: "Fixture 2"}];
    }

    const handleUpdateFixture = async (e) => {
        e.preventDefault();

        try {
            const identity = authClient.getIdentity();
            Actor.agentOf(open_fpl_backend).replaceIdentity(identity);

            // Update fixture using backend API call.
            // Placeholder below.
            await open_fpl_backend.updateFixture({
                fixtureId: selectedFixture,
                newDate: fixtureDate,
                newGameweek: selectedGameweek
            });

            setSubmitStatus("Fixture successfully rescheduled!");
        } catch (error) {
            console.error("Error while rescheduling fixture: ", error);
            setSubmitStatus("Failed to reschedule. Please try again.");
        }
    }

    return (
        <div>
            <h2>Active Season: {selectedSeason}</h2>

            <Form onSubmit={handleUpdateFixture}>
                {isPostponed ? (
                    <Form.Group className="mb-3">
                        <Form.Label>Select Postponed Fixture</Form.Label>
                        <Form.Control as="select" value={selectedPostponedFixture} onChange={(e) => setSelectedPostponedFixture(e.target.value)}>
                            <option disabled value="">Select a postponed fixture</option>
                            {postponedFixtures.map((fixture, index) => (
                                <option key={index} value={fixture.id}>{fixture.name}</option>
                            ))}
                        </Form.Control>
                    </Form.Group>
                ) : (
                    <>
                        <Form.Group className="mb-3">
                            <Form.Label>Season</Form.Label>
                            <Form.Control as="select" value={selectedSeason} onChange={(e) => setSelectedSeason(e.target.value)}>
                                <option disabled value="">Select a season</option>
                                {seasons.map((season, index) => (
                                    <option key={index} value={season.id}>{season.name}</option>
                                ))}
                            </Form.Control>
                        </Form.Group>

                        <Form.Group className="mb-3">
                            <Form.Label>Gameweek</Form.Label>
                            <Form.Control as="select" value={selectedGameweek} onChange={(e) => setSelectedGameweek(e.target.value)}>
                                <option disabled value="">Select a gameweek</option>
                                {gameweeks.map((gameweek, index) => (
                                    <option key={index} value={gameweek.id}>{gameweek.name}</option>
                                ))}
                            </Form.Control>
                        </Form.Group>

                        <Form.Group className="mb-3">
                            <Form.Label>Fixture</Form.Label>
                            <Form.Control as="select" value={selectedFixture} onChange={(e) => setSelectedFixture(e.target.value)}>
                                <option disabled value="">Select a fixture</option>
                                {fixtures.map((fixture, index) => (
                                    <option key={index} value={fixture.id}>{fixture.name}</option>
                                ))}
                            </Form.Control>
                            </Form.Group>

                            <Form.Group className="mb-3">
                                <Form.Label>Fixture Date</Form.Label>
                                <Form.Control type="date" value={fixtureDate} onChange={(e) => setFixtureDate(e.target.value)} />
                            </Form.Group>
                        </>
                    )}

                    <Form.Group className="mb-3">
                        <Form.Check
                            type="checkbox"
                            label="Postponed"
                            checked={isPostponed}
                            onChange={() => setIsPostponed(!isPostponed)}
                            />
                    </Form.Group>

                    {submitStatus && <Alert variant={submitStatus.includes("success") ? "success" : "danger"}>{submitStatus}</Alert>}

                    <Button variant="primary" type="submit">
                        Submit
                    </Button>
                </Form>
            </div>
        );
    };

export default RescheduleFixtureProposal;

