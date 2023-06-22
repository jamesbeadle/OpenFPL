import React, { useState, useContext, useEffect } from 'react';
import { Container, Row, Col, Card, Button, Spinner, ListGroup } from 'react-bootstrap';
import { OpenFPL_backend as open_fpl_backend } from '../../../../declarations/OpenFPL_backend';
import { Actor } from "@dfinity/agent";
import { AuthContext } from "../../contexts/AuthContext";
import { toHexString } from '../helpers';
import UpdateNameModal from './update-name-modal';
import UpdateWalletModal from './update-wallet-modal';
import WithdrawICPModal from './withdraw-icp-modal';
import { CopyIcon } from '../icons';

const Profile = () => {

  const { authClient } = useContext(AuthContext);
  const [isLoading, setIsLoading] = useState(true);
  const [showUpdateNameModal, setShowUpdateNameModal] = useState(false);
  const [showUpdateWalletModal, setShowUpdateWalletModal] = useState(false);
  const [showWithdrawICPModal, setShowWithdrawICPModal] = useState(false);
  const [loadingAccountBalance, setLoadingAccountBalance] = useState(true);
  const [balanceData, setBalanceData] = useState(null);

  const [viewData, setViewData] = useState(null);
  const [copied, setCopied] = useState(false);

  useEffect(() => {
    const fetchData = async () => {
      await fetchViewData();
      setIsLoading(false);
    };
    fetchData();
  }, []);

  useEffect(() => {
    if(!viewData){
      return;
    }
    const fetchData = async () => {
      await fetchAccountBalance();
      setLoadingAccountBalance(false);
    };
    fetchData();
  }, [viewData]);

  const fetchViewData = async () => {
    const identity = authClient.getIdentity();
    Actor.agentOf(open_fpl_backend).replaceIdentity(identity);
    const data = await open_fpl_backend.getProfileDTO();
    setViewData(data);
  };

  const fetchAccountBalance = async () => {
    const identity = authClient.getIdentity();
    Actor.agentOf(open_fpl_backend).replaceIdentity(identity);
    const data = await open_fpl_backend.getAccountBalanceDTO();
    setBalanceData(data);
  };

  const hideUpdateNameModal = async (changed) => {
    if(!changed){
      setShowUpdateNameModal(false); 
      return;
    }
    setIsLoading(true);
    setShowUpdateNameModal(false); 
    await fetchViewData();
    setIsLoading(false);
  };

  const hideUpdateWalletModal = async (changed) => {
    if(!changed){
      setShowUpdateWalletModal(false); 
      return;
    }
    setIsLoading(true);
    setShowUpdateWalletModal(false); 
    await fetchViewData();
    setIsLoading(false);
  };

  const hideWithdrawICPModal = async (changed) => {
    if(!changed){
      setShowWithdrawICPModal(false); 
      return;
    }
    setIsLoading(true);
    setShowWithdrawICPModal(false); 
    await fetchViewData();
    setIsLoading(false);
  };

  return (
      isLoading ? (
        <div className="customOverlay d-flex flex-column align-items-center justify-content-center">
          <Spinner animation="border" />
          <p className='text-center mt-1'>Loading Profile</p>
        </div>
      ) : (
        <Container>
          <Row className="justify-content-md-center">
            <Col md={8}>
              <Card className="mt-4 custom-card mb-4">
                <Card.Body>
                  <h2 className="text-center">Profile</h2>
                  <ListGroup>

                    <ListGroup.Item className="mt-1 mb-1">
                      <h6>Principal Id:</h6>
                      <p><small>{viewData.principalName}</small></p>
                    </ListGroup.Item>

                    <ListGroup.Item className="mt-1 mb-1">
                      <h6>Deposit Address:</h6>
                      <p><small>{toHexString(viewData.depositAddress)}{' '}
                      <CopyIcon onClick={async () => {
                        try {
                          await navigator.clipboard.writeText(toHexString(viewData.depositAddress));
                          setCopied(true);
                        } catch (error) {
                          console.error('Clipboard API error:', error);
                          setCopied(false);
                        }
                      }} />
                      </small></p>
                      {copied && <p className="text-primary"><small>Copied to clipboard.</small></p>}
                    </ListGroup.Item>

                    <ListGroup.Item className="mt-1 mb-1">
                      <h6>Display Name:</h6>
                      <p>
                        <small>{viewData.displayName}</small>&nbsp;&nbsp;
                        <Button className="btn btn-sm ml-3" onClick={() => setShowUpdateNameModal(true)}>Update</Button>
                      </p>
                    </ListGroup.Item>

                    <ListGroup.Item className="mt-1 mb-1">
                      <h6>Account Balance:</h6>
                      {loadingAccountBalance ? (
                        <div className="d-flex flex-column align-items-center justify-content-center mt-3">
                          <Spinner animation="border" />
                          <p className='text-center mt-1'><small>Loading Account Balance</small></p>
                        </div>
                      ) :  (
                        <p>
                          <small>{(Number(balanceData.accountBalance) / 1e8).toFixed(4)} ICP</small>&nbsp;&nbsp;
                          <Button className="btn btn-sm ml-3" onClick={() => setShowWithdrawICPModal(true)}>Withdraw</Button>
                        </p>
                        )}
                    </ListGroup.Item>

                    <ListGroup.Item className="mt-1 mb-1">
                      <h6>Withdraw Wallet Address:</h6>
                      <p>
                        <small>{viewData.walletAddress != "" ? viewData.walletAddress : 'Not Set'}</small>&nbsp;&nbsp;
                        <Button className="btn btn-sm ml-3" onClick={() => setShowUpdateWalletModal(true)}>Update</Button>
                      </p>
                    </ListGroup.Item>
                  </ListGroup>
                  
                </Card.Body>
              </Card>
            </Col>
          </Row>

          <UpdateNameModal
            show={showUpdateNameModal}
            onHide={hideUpdateNameModal}
            displayName={viewData.displayName}
          />

          <UpdateWalletModal
            show={showUpdateWalletModal}
            onHide={hideUpdateWalletModal}
            wallet={viewData.walletAddress}
          />

          {!loadingAccountBalance && (
            <WithdrawICPModal
              show={showWithdrawICPModal}
              onHide={hideWithdrawICPModal}
              balance={balanceData.accountBalance}
              wallet={viewData.walletAddress}
            />
          )}
        </Container>
    )
  );
};

export default Profile;
