import React, { useState, useEffect } from 'react';
import { Form, Table } from 'react-bootstrap';

const LeagueTable = ({ fixturesData, columns }) => {
    const [selectedGameweek, setSelectedGameweek] = useState(38); // Default to the last gameweek
    const [tableData, setTableData] = useState([]);
    const defaultColumns = [
        'Position', 'Team', 'Played', 'Wins', 'Draws', 'Losses', 'Goals For', 'Goals Against', 'Goal Difference', 'Points'
    ];
    const activeColumns = columns || defaultColumns;

    useEffect(() => {
        updateTableData();
    }, [fixturesData, selectedGameweek]);

    const updateTableData = () => {
        // A helper function to initialize a team's data if it's not already in our table
        const initTeamData = (teamId, table) => {
            if (!table[teamId]) {
                table[teamId] = {
                    teamId,
                    played: 0,
                    wins: 0,
                    draws: 0,
                    losses: 0,
                    goalsFor: 0,
                    goalsAgainst: 0,
                    points: 0
                };
            }
        };
    
        let tempTable = {};
    
        // Filter fixtures up to the selected gameweek and with status 3 (Data Finalised)
        const relevantFixtures = fixturesData.filter(fixture => 
            fixture.status === 3 && fixture.gameweek <= selectedGameweek);
    
        for (let fixture of relevantFixtures) {
            initTeamData(fixture.homeTeamId, tempTable);
            initTeamData(fixture.awayTeamId, tempTable);
    
            tempTable[fixture.homeTeamId].played++;
            tempTable[fixture.awayTeamId].played++;
    
            tempTable[fixture.homeTeamId].goalsFor += fixture.homeGoals;
            tempTable[fixture.homeTeamId].goalsAgainst += fixture.awayGoals;
            
            tempTable[fixture.awayTeamId].goalsFor += fixture.awayGoals;
            tempTable[fixture.awayTeamId].goalsAgainst += fixture.homeGoals;
    
            // Handle Wins, Draws, and Losses
            if (fixture.homeGoals > fixture.awayGoals) {
                tempTable[fixture.homeTeamId].wins++;
                tempTable[fixture.homeTeamId].points += 3;
    
                tempTable[fixture.awayTeamId].losses++;
            } else if (fixture.homeGoals === fixture.awayGoals) {
                tempTable[fixture.homeTeamId].draws++;
                tempTable[fixture.homeTeamId].points += 1;
    
                tempTable[fixture.awayTeamId].draws++;
                tempTable[fixture.awayTeamId].points += 1;
            } else {
                tempTable[fixture.awayTeamId].wins++;
                tempTable[fixture.awayTeamId].points += 3;
    
                tempTable[fixture.homeTeamId].losses++;
            }
        }
    
        const sortedTableData = Object.values(tempTable).sort((a, b) => {
            if (b.points !== a.points) return b.points - a.points;

            const goalDiffA = a.goalsFor - a.goalsAgainst;
            const goalDiffB = b.goalsFor - b.goalsAgainst;

            if (goalDiffB !== goalDiffA) return goalDiffB - goalDiffA;
            if (b.goalsFor !== a.goalsFor) return b.goalsFor - a.goalsFor;

            return a.goalsAgainst - b.goalsAgainst;
        });
    
        setTableData(sortedTableData);
    };
    

    return (
        <div>
            <Form.Group controlId="gameweekSelect">
                <Form.Label>Select Gameweek</Form.Label>
                <Form.Control as="select" value={selectedGameweek} onChange={e => {
                    setSelectedGameweek(Number(e.target.value));
                }}>
                    {Array.from({ length: 38 }, (_, i) => (
                        <option key={i} value={i + 1}>Gameweek {i + 1}</option>
                    ))}
                </Form.Control>
            </Form.Group>

            <Table responsive bordered>
                <thead>
                    <tr>
                        {activeColumns.map(column => (
                            <th key={column}>{column}</th>
                        ))}
                    </tr>
                </thead>
                <tbody>
                    {tableData.map((team, idx) => (
                        <tr key={team.teamId}>
                            {activeColumns.includes('Position') && <td>{idx + 1}</td>}
                            {activeColumns.includes('Team') && <td>{team.teamId /* Replace with team name if available */}</td>}
                            {activeColumns.includes('Played') && <td>{team.played}</td>}
                            {activeColumns.includes('Wins') && <td>{team.wins}</td>}
                            {activeColumns.includes('Draws') && <td>{team.draws}</td>}
                            {activeColumns.includes('Losses') && <td>{team.losses}</td>}
                            {activeColumns.includes('Goals For') && <td>{team.goalsFor}</td>}
                            {activeColumns.includes('Goals Against') && <td>{team.goalsAgainst}</td>}
                            {activeColumns.includes('Goal Difference') && <td>{team.goalsFor - team.goalsAgainst}</td>}
                            {activeColumns.includes('Points') && <td>{team.points}</td>}
                        </tr>
                    ))}
                </tbody>
            </Table>
        </div>
    );
};

export default LeagueTable;
