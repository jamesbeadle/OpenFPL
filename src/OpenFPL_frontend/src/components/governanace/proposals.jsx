import React, { useState, useEffect, useContext } from 'react';
import { Card, Spinner, Button, Dropdown, Table, ButtonGroup } from 'react-bootstrap';
import { AuthContext } from "../../contexts/AuthContext";
import { OpenFPL_backend as open_fpl_backend } from '../../../../declarations/OpenFPL_backend';
import { Actor } from "@dfinity/agent";
import AddProposalModal from './add-proposal-modal';

const Proposals = ({ isActive }) => {
  const { authClient } = useContext(AuthContext);
  const [data, setData] = useState(null);
  const [isLoading, setIsLoading] = useState(false);
  const [showAddProposalModal, setShowAddProposalModal] = useState(false);
  const proposalStates = ['All', 'Failed', 'Open', 'Executing', 'Rejected', 'Succeeded', 'Accepted'];
  const [page, setPage] = useState(0);
  const count = 25;

  useEffect(() => {
    if (isActive) {
      fetchProposals();
    }
  }, [isActive]);

  const fetchProposals = async () => {
    setIsLoading(true);
    try {
      //get active proposals
    } catch (error) {
      console.error("Failed to fetch active proposals", error);
    } finally {
      setIsLoading(false);
    }
  };

  const handleAddProposalModalClose = (changed) => {
    setShowAddProposalModal(false);
    if (changed) {
      fetchProposals();
    }
  };

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
        <div className="d-flex justify-content-between align-items-center mb-3">
          <h2>DAO Proposals</h2>
          <Button variant="primary" onClick={() => setShowAddProposalModal(true)}>New Proposal</Button>
        </div>

        <Dropdown className="mb-3">
          <Dropdown.Toggle variant="secondary" id="dropdown-basic">
            Filter by Proposal State
          </Dropdown.Toggle>

          <Dropdown.Menu>
            {proposalStates.map((state, index) => (
              <Dropdown.Item key={index}>{state}</Dropdown.Item>
            ))}
          </Dropdown.Menu>
        </Dropdown>

        <Table responsive bordered className="table-fixed light-table mt-1 custom-table">
        <thead>
          <tr>
            <th className="table-col-id"><small>Id</small></th>
            <th className="table-col-detail"><small>Detail</small></th>
            <th className="table-col-yes"><small>Yes</small></th>
            <th className="table-col-no"><small>No</small></th>
            <th className="table-col-status"><small>Status</small></th>
          </tr>
        </thead>
        <tbody>
          {data != null && data.map((entry) => (
            <tr key={entry.id}>
              <td>{entry.id}</td>
              <td>{entry.proposalDetail}</td>
              <td>{entry.yesVotes}</td>
              <td>{entry.noVotes}</td>
              <td>{entry.status}</td>
              <td>
                <Button className="custom-button" onClick={() => handleViewPrediction(entry.principalName)}>
                  View
                </Button>
              </td>
            </tr>
          ))}
        </tbody>
        </Table>
        {data != null && (<div className="d-flex justify-content-center mt-3 mb-3">
          <ButtonGroup>
            <Button className="custom-button" onClick={() => handlePageChange(-1)} disabled={page === 0}>
              Prior
            </Button>
            <div className="d-flex align-items-center mr-3 ml-3">
              <p className="mb-0">Page {page + 1}</p>
            </div>
            <Button className="custom-button" onClick={() => handlePageChange(1)} disabled={(page + 1) * count >= data.totalEntries}>
              Next
            </Button>
          </ButtonGroup>
        </div>)}

        <AddProposalModal
            show={showAddProposalModal}
            onHide={handleAddProposalModalClose}
          />
      </Card.Body>
    </Card>
  );
};

export default Proposals;
