import React, { useState, useEffect } from 'react';
import { Container, Spinner, CardDeck, Card, Button, Modal, Dropdown, Pagination } from 'react-bootstrap';
import { initSnsWrapper } from '@dfinity/sns';
import { AuthContext } from "../../contexts/AuthContext";
import AddProposalModal from './add-proposal-modal';

const Governance = () => {
  const { authClient } = useContext(AuthContext);
  const [isLoading, setIsLoading] = useState(true);
  const [proposals, setProposals] = useState([]);
  const [activeModalProposal, setActiveModalProposal] = useState(null);
  const [showModal, setShowModal] = useState(false);
  const [showAddProposalModal, setShowAddProposalModal] = useState(null);
  const [pageNum, setPageNum] = useState(1);
  const [lastProposalId, setLastProposalId] = useState(null);

  useEffect(() => {
    fetchViewData();
  }, [pageNum]);

  const fetchViewData = async () => {
    setIsLoading(true);

    const snsWrapper = await initSnsWrapper({
      rootOptions: {
        canisterId: "bboqb-jiaaa-aaaal-qb6ea-cai", 
      },
      authClient,
      certified: true,
    });

    const params = {
      limit: 100, 
      beforeProposal: lastProposalId,
      includeStatus: [SnsProposalDecisionStatus.PROPOSAL_DECISION_STATUS_OPEN]
    };

    const fetchedProposals = await snsWrapper.listProposals(params);

    if (fetchedProposals.length > 0) {
      setLastProposalId(fetchedProposals[fetchedProposals.length - 1].getId());
    }
    setProposals(fetchedProposals);
    setIsLoading(false);
  };

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

  return (
    isLoading ? (
      <div className="customOverlay d-flex flex-column align-items-center justify-content-center">
        <Spinner animation="border" />
        <p className='text-center mt-1'>Loading</p>
      </div>) : (
      <Container className="flex-grow-1 my-5">
        <h1>OpenFPL DAO Governance</h1>
        <br />
        <Button className="mb-3 float-right" variant="primary" onClick={() => setShowAddProposalModal(true)}>New Proposal</Button>
     
        <CardDeck>
          {proposals.map(proposal => (
            <Card key={proposal.id} onClick={() => handleProposalClick(proposal)}>
              <Card.Body>
                <Card.Title>{proposal.title}</Card.Title>
                <Card.Text>{proposal.description.substring(0, 100)}...</Card.Text>
                <Button variant="success" onClick={() => handleVote('yes')}>Yes</Button>
                <Button variant="danger" onClick={() => handleVote('no')}>No</Button>
              </Card.Body>
            </Card>
          ))}
        </CardDeck>
        
        <Pagination className="mt-3">
          <Pagination.Prev onClick={() => pageNum > 1 && setPageNum(pageNum - 1)} />
          <Pagination.Item>{pageNum}</Pagination.Item>
          <Pagination.Next onClick={() => proposals.length === 100 && setPageNum(pageNum + 1)} />
        </Pagination>

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
        
        <AddProposalModal
            show={showAddProposalModal}
            onHide={handleAddProposalModalClose}
          />
      </Container>
    )
  );
};

export default Governance;
