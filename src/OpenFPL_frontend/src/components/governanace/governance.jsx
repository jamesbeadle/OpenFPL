import React, { useState, useEffect, useContext } from 'react';
import { Container, Spinner, Card, Button, Modal, Pagination, Tabs, Tab } from 'react-bootstrap';
import { initSnsWrapper, SnsVote, SnsGovernanceCanister } from '@dfinity/sns';
import { AuthContext } from "../../contexts/AuthContext";
import AddProposalModal from './add-proposal-modal';
import { useNavigate } from 'react-router-dom';

const Governance = () => {
  const { authClient } = useContext(AuthContext);
  const [isLoading, setIsLoading] = useState(true);
  const [activeModalProposal, setActiveModalProposal] = useState(null);
  const [showModal, setShowModal] = useState(false);
  const [showAddProposalModal, setShowAddProposalModal] = useState(null);
  const [lastProposalId, setLastProposalId] = useState(null);
  const [activeTab, setActiveTab] = useState("Proposals");
  const [proposalPageNum, setProposalPageNum] = useState(1);
  const [fixtureValidationPageNum, setFixtureValidationPageNum] = useState(1);
  const [proposalData, setProposalData] = useState([]);
  const [fixtureValidationData, setFixtureValidationData] = useState([]);
  const navigate = useNavigate();

  useEffect(() => {
    if (activeTab === "Proposals") {
      fetchViewData("Proposals");
    } else {
      fetchViewData("Fixture Validation");
    }
  }, [proposalPageNum, fixtureValidationPageNum, activeTab]);


  const handleProposalClick = (proposal) => {
    setActiveModalProposal(proposal);
    setShowModal(true);
  };

  const handleVote = async (decision) => {

    const neurons = await SnsGovernanceCanister.listNeurons({
      principal: authClient.getPrincipal(),
      limit: 100
    });
    
    if (neurons && neurons.length > 0) {
      const neuronId = neurons[0].id[0].NeuronId.toString();
      const vote = decision === 'yes' ? SnsVote.Yes : SnsVote.No;
      
      const voteParams = {
        neuronId: neuronId,
        vote: vote,
        proposalId: activeModalProposal.id
      };
    
      try {
        await registerVote(voteParams);
        setShowModal(false);
      } catch (error) {
        console.error("Error while registering the vote:", error);
      }
    }    
  
  };

  const handleAddProposalModalClose = (changed) => {
    setShowAddProposalModal(false);
    if (changed) {
      fetchProposals();
    }
  };

  const fetchViewData = async (type) => {
    setIsLoading(true);
    const snsWrapper = await initSnsWrapper({
      rootOptions: {
        canisterId: "bboqb-jiaaa-aaaal-qb6ea-cai",
      },
      authClient,
      certified: true,
    });

    const baseParams = {
      limit: 100,
      beforeProposal: lastProposalId,
      includeStatus: [SnsProposalDecisionStatus.PROPOSAL_DECISION_STATUS_OPEN]
    };

    let params = baseParams;

    if (type === "Proposals") {
      params.excludeType = [3000];
    } else if (type === "Fixture Validation") {
      params.excludeType = undefined; // Ensure other types are not excluded
      params.includeType = [3000]; // Only include Fixture Validation type
    }

    
    const fetchedProposals = await snsWrapper.listProposals(params);

    if (fetchedProposals.length > 0) {
      setLastProposalId(fetchedProposals[fetchedProposals.length - 1].getId());
    }

    if (type === "Proposals") {
      setProposalData(fetchedProposals);
    } else {
      setFixtureValidationData(fetchedProposals);
    }

    setIsLoading(false);
  };

  const loadAddFixtureData = () => {
    navigate('/add-fixture-data');  
  };

  return (
    isLoading ? (
      <div className="customOverlay d-flex flex-column align-items-center justify-content-center">
        <Spinner animation="border" />
        <p className='text-center mt-1'>Loading</p>
      </div>) : (
      <Container className="flex-grow-1 my-5">
        <h1>OpenFPL DAO Governance</h1>
        <br />

          <Tabs activeKey={activeTab} id="controlled-tab" onSelect={key => {
              setActiveTab(key);
              if (key === "Proposals") {
                  setProposalPageNum(1);
              } else {
                  setFixtureValidationPageNum(1);
              }
          }}
          > 
            
          <Tab eventKey="Proposals" title="Proposals">
            <Button className="mb-3 float-right" variant="primary" onClick={() => setShowAddProposalModal(true)}>New Proposal</Button>
        
              {proposalData.length == 0 && (
                <p>No proposals to view.</p>
              )}
              {proposalData.map(proposal => (
                 <Card key={proposal.id} onClick={() => handleProposalClick(proposal)}>
                  <Card.Body>
                    <Card.Title>{proposal.title}</Card.Title>
                    <Card.Text>{proposal.description.substring(0, 100)}...</Card.Text>
                  </Card.Body>
                </Card>
              ))}
            
            <Pagination className="mt-3">
                <Pagination.Prev onClick={() => proposalPageNum > 1 && setProposalPageNum(proposalPageNum - 1)} />
                <Pagination.Item>{proposalPageNum}</Pagination.Item>
                <Pagination.Next onClick={() => proposalData.length === 100 && setProposalPageNum(proposalPageNum + 1)} />
            </Pagination>
            
            <AddProposalModal show={showAddProposalModal} onHide={handleAddProposalModalClose} />
          </Tab>
          
          <Tab eventKey="Fixture Validation" title="Fixture Validation">
            <Button className="mb-3 float-right" variant="primary" onClick={() => loadAddFixtureData()}>Create Fixture Proposal</Button>
              {fixtureValidationData.length == 0 && (
                <p>No proposals to view.</p>
              )}
            { fixtureValidationData.map(proposal => (
                <Card key={proposal.id} onClick={() => handleProposalClick(proposal)}>
                  <Card.Body>
                    <Card.Title>{proposal.title}</Card.Title>
                    <Card.Text>{proposal.description.substring(0, 100)}...</Card.Text>
                  </Card.Body>
                </Card>
              ))}
            <Pagination className="mt-3">
                <Pagination.Prev onClick={() => fixtureValidationPageNum > 1 && setFixtureValidationPageNum(fixtureValidationPageNum - 1)} />
                <Pagination.Item>{fixtureValidationPageNum}</Pagination.Item>
                <Pagination.Next onClick={() => fixtureValidationData.length === 100 && setFixtureValidationPageNum(fixtureValidationPageNum + 1)} />
            </Pagination>
          
          </Tab>

          <Modal show={showModal} onHide={() => setShowModal(false)}>
            <Modal.Header closeButton>
              <Modal.Title>{activeModalProposal?.title}</Modal.Title>
            </Modal.Header>
            <Modal.Body>
              {activeModalProposal?.description}
            </Modal.Body>
            <Modal.Footer>
              <Button variant="success" onClick={() => handleVote('yes')}>Yes</Button>
              <Button variant="danger" onClick={() => handleVote('no')}>No</Button>
            </Modal.Footer>
          </Modal>

        </Tabs>

      </Container>
    )
  );
};

export default Governance;
