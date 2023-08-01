import React, { useState, useContext } from 'react';
import { Form, Button, Alert } from 'react-bootstrap';
import Papa from 'papaparse';
import { OpenFPL_backend as open_fpl_backend } from '../../../../declarations/OpenFPL_backend';
import { Actor } from "@dfinity/agent";
import { AuthContext } from "../../contexts/AuthContext";

const AddInitialFixturesProposal = () => {
    const { authClient } = useContext(AuthContext);

    const [csvFile, setCsvFile] = useState(null);
    const [parsedData, setParsedData] = useState([]);
    const [submitStatus, setSubmitStatus] = useState(null);

    const handleFileChange = (e) => {
        const file = e.target.files[0];
        setCsvFile(file);

        if (file) {
            Papa.parse(file, {
                complete: (result) => {
                    setParsedData(result.data);
                },
                header: true
            });
        }
    }

    const handleSubmit = async (e) => {
        e.preventDefault();

        if (!csvFile || parsedData.length === 0) {
            setSubmitStatus("Please upload a valid CSV file.");
            return;
        }

        try {
            const identity = authClient.getIdentity();
            Actor.agentOf(open_fpl_backend).replaceIdentity(identity);

            // Call your backend function here to send the parsedData
            await open_fpl_backend.addInitialFixtures(parsedData);

            setSubmitStatus("Fixtures successfully added!");
        } catch (error) {
            console.error("Error while adding fixtures: ", error);
            setSubmitStatus("Failed to add fixtures. Please try again.");
        }
    }

    return (
        <Form onSubmit={handleSubmit}>
            <Form.Group className="mb-3">
                <Form.Label>Upload CSV File</Form.Label>
                <Form.Control type="file" accept=".csv" onChange={handleFileChange} />
            </Form.Group>

            {submitStatus && <Alert variant={submitStatus.includes("success") ? "success" : "danger"} className="mt-2">{submitStatus}</Alert>}

            <Button variant="primary" type="submit">
                Submit
            </Button>
        </Form>
    );
};

export default AddInitialFixturesProposal;
