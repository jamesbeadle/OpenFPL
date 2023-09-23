import React, { useState, useContext } from 'react';
import { Form } from 'react-bootstrap';
import { DataContext } from "../../../../contexts/DataContext";

const LoanPlayerProposal = ({ sendDataToParent }) => {
    const { players, teams } = useContext(DataContext);
    const [selectedPlayer, setSelectedPlayer] = useState("");
    const [loanTeamId, setLoanTeamId] = useState("");
    const [loanEndDate, setLoanEndDate] = useState("");

    useEffect(() => {
        sendDataToParent({
            player: selectedPlayer,
            loanTeamId,
            loanEndDate
        });
    }, [selectedPlayer, loanTeamId, loanEndDate]);

    return (
        <div>
            <Form.Group className="mb-3">
                <Form.Label>Player</Form.Label>
                <Form.Control as="select" value={selectedPlayer} onChange={e => setSelectedPlayer(e.target.value)}>
                    <option disabled value="">Select a player</option>
                    {players.map((player, index) => (
                        <option key={index} value={player.id}>{player.name}</option>
                    ))}
                </Form.Control>
            </Form.Group>

            <Form.Group className="mb-3">
                <Form.Label>Loan to Team</Form.Label>
                <Form.Control as="select" value={loanTeamId} onChange={e => setLoanTeamId(e.target.value)}>
                    <option disabled value="">Select a team</option>
                    {teams.map((team, index) => (
                        <option key={index} value={team.id}>{team.name}</option>
                    ))}
                </Form.Control>
            </Form.Group>

            <Form.Group className="mb-3">
                <Form.Label>Loan End Date</Form.Label>
                <Form.Control type="date" value={loanEndDate} onChange={e => setLoanEndDate(e.target.value)} />
            </Form.Group>
        </div>
    );
};

export default LoanPlayerProposal;
