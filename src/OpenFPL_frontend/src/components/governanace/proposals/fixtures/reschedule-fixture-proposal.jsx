import React, { useState, useContext } from 'react';
import { Form } from 'react-bootstrap';
import { DataContext } from "../../../../contexts/DataContext";
import { dateToUnixNanoseconds } from "../../../helpers";

const RescheduleFixtureProposal = ({ sendDataToParent }) => {
    const { fixtures, gameweeks } = useContext(DataContext);
    const [selectedFixture, setSelectedFixture] = useState("");
    const [currentFixtureGameweek, setCurrentFixtureGameweek] = useState("");
    const [updatedFixtureGameweek, setUpdatedFixtureGameweek] = useState("");
    const [updatedFixtureDate, setUpdatedFixtureDate] = useState("");

    useEffect(() => {
        sendDataToParent({
            fixture: selectedFixture,
            currentFixtureGameweek,
            updatedFixtureGameweek,
            updatedFixtureDate: dateToUnixNanoseconds(updatedFixtureDate)
        });
    }, [selectedFixture, currentFixtureGameweek, updatedFixtureGameweek, updatedFixtureDate]);

    return (
        <div>
            <Form.Group className="mb-3">
                <Form.Label>Fixture</Form.Label>
                <Form.Control as="select" value={selectedFixture} onChange={e => setSelectedFixture(e.target.value)}>
                    <option disabled value="">Select a fixture</option>
                    {fixtures.map((fixture, index) => (
                        <option key={index} value={fixture.id}>{fixture.homeTeam} vs {fixture.awayTeam}</option>
                    ))}
                </Form.Control>
            </Form.Group>

            <Form.Group className="mb-3">
                <Form.Label>Current Gameweek</Form.Label>
                <Form.Control as="select" value={currentFixtureGameweek} onChange={e => setCurrentFixtureGameweek(e.target.value)}>
                    {gameweeks.map((gw, index) => (
                        <option key={index} value={gw.id}>{gw.name}</option>
                    ))}
                </Form.Control>
            </Form.Group>

            <Form.Group className="mb-3">
                <Form.Label>Updated Gameweek</Form.Label>
                <Form.Control as="select" value={updatedFixtureGameweek} onChange={e => setUpdatedFixtureGameweek(e.target.value)}>
                    {gameweeks.map((gw, index) => (
                        <option key={index} value={gw.id}>{gw.name}</option>
                    ))}
                </Form.Control>
            </Form.Group>

            <Form.Group className="mb-3">
                <Form.Label>Updated Fixture Date</Form.Label>
                <Form.Control type="datetime-local" value={updatedFixtureDate} onChange={e => setUpdatedFixtureDate(e.target.value)} />
            </Form.Group>
        </div>
    );
};

export default RescheduleFixtureProposal;
