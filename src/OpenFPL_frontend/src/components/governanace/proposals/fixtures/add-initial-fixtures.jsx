import React, { useState } from 'react';
import { Form } from 'react-bootstrap';
import Papa from 'papaparse';

const AddInitialFixturesProposal = ({ sendDataToParent }) => {
    const [season, setSeason] = useState("");
    const [fixturesCount, setFixturesCount] = useState(null);
    const [seasonFixtures, setSeasonFixtures] = useState([]);

    const handleFileChange = (event) => {
        const file = event.target.files[0];
        if (file) {
            const reader = new FileReader();
            reader.readAsText(file);
            reader.onload = () => {
                const parsed = Papa.parse(reader.result, { header: true });
                setSeasonFixtures(parsed.data);
                setFixturesCount(parsed.data.length);
            };
        }
    };

    useEffect(() => {
        sendDataToParent({
            season,
            seasonFixtures
        });
    }, [season, seasonFixtures]);

    return (
        <div>
            <Form.Group className="mb-3">
                <Form.Label>Season</Form.Label>
                <Form.Control type="text" value={season} onChange={e => setSeason(e.target.value)} />
            </Form.Group>

            <Form.Group className="mb-3">
                <Form.Label>Upload CSV for Fixtures</Form.Label>
                <Form.Control type="file" accept=".csv" onChange={handleFileChange} />
            </Form.Group>

            {fixturesCount && <p>Found {fixturesCount} fixtures.</p>}
        </div>
    );
};

export default AddInitialFixturesProposal;
