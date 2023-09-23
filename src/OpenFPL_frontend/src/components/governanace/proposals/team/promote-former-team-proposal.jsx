import React, { useState, useContext } from 'react';
import { Form } from 'react-bootstrap';
import { DataContext } from "../../../../contexts/DataContext";

const PromoteFormerTeamProposal = ({ sendDataToParent }) => {
    const { formerTeams } = useContext(DataContext);
    const [selectedTeam, setSelectedTeam] = useState("");

    useEffect(() => {
        sendDataToParent({
            teamId: selectedTeam
        });
    }, [selectedTeam]);

    return (
        <div>
            <Form.Group className="mb-3">
                <Form.Label>Select Team to Promote</Form.Label>
                <Form.Control as="select" value={selectedTeam} onChange={e => setSelectedTeam(e.target.value)}>
                    <option disabled value="">Choose a team</option>
                    {formerTeams.map((team, index) => (
                        <option key={index} value={team.id}>{team.name}</option>
                    ))}
                </Form.Control>
            </Form.Group>
        </div>
    );
};

export default PromoteFormerTeamProposal;
