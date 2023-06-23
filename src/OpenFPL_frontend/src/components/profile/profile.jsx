import React, { useState, useContext, useEffect } from 'react';
import { Container, Row, Col, Card, Button, Spinner, ListGroup, Tabs, Tab, Form, Image } from 'react-bootstrap';
import { OpenFPL_backend as open_fpl_backend } from '../../../../declarations/OpenFPL_backend';
import { Actor } from "@dfinity/agent";
import { AuthContext } from "../../contexts/AuthContext";
import { toHexString } from '../helpers';
import UpdateNameModal from './update-name-modal';
import WithdrawICPModal from './withdraw-icp-modal';
import WithdrawFPLModal from './withdraw-fpl-modal';
import UpdateProfilePictureModal from './update-profile-picture-modal';
import UpgradeMembershipModal from './upgrade-membership-modal';
import { CopyIcon } from '../icons';
import ProfileImage from '../../../assets/profile_placeholder.png';
import { EditIcon } from '../icons';

const Profile = () => {

  const { authClient } = useContext(AuthContext);
  const [isLoading, setIsLoading] = useState(true);
  const [showUpdateNameModal, setShowUpdateNameModal] = useState(false);
  const [showUpdateProfilePictureModal, setShowUpdateProfilePictureModal] = useState(false);
  const [showWithdrawICPModal, setShowWithdrawICPModal] = useState(false);
  const [showWithdrawFPLModal, setShowWithdrawFPLModal] = useState(false);
  const [loadingAccountBalance, setLoadingAccountBalance] = useState(true);
  const [favoriteTeam, setFavoriteTeam] = useState('');
  const [balanceData, setBalanceData] = useState(null);

  const [showUpgradeAccountModal, setShowUpgradeAccountModal] = useState(false);
  const [showGetMoreLeaguesModal, setShowGetMoreLeaguesModal] = useState(false);

  const [profilePicSrc, setProfilePicSrc] = useState(ProfileImage);

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

  
  const handleFavoriteTeamChange = (event) => {
    setFavoriteTeam(event.target.value);
  };

  return (
      isLoading ? (
        <div className="customOverlay d-flex flex-column align-items-center justify-content-center">
          <Spinner animation="border" />
          <p className='text-center mt-1'>Loading Profile</p>
        </div>
      ) : (
        <Container>
            <br />
            <Tabs defaultActiveKey="details" id="profile-tabs" className="mt- 4">
            <Tab eventKey="details" title="Details">
              <Row className="justify-content-md-center">
                <Col md={8}>
                  <Card className="mt-4 custom-card mb-4">
                    <Card.Body>
                      <h2 className="text-center">Profile</h2>
                      <ListGroup>
                        <Row>
                          <Col md={4}>
                            <ListGroup.Item className="mt-1 mb-1">
                              <div className="text-center">
                                <div className="position-relative d-inline-block">
                                  <Image src={profilePicSrc} roundedCircle className="w-100" />
                                  <div className="position-absolute" style={{ top: "-10px", right: "-10px" }}>
                                    <EditIcon onClick={() => setShowUpdateProfilePictureModal(true)} />
                                  </div>
                                </div>
                              </div>
                            </ListGroup.Item>
                          </Col>
                          <Col md={8}>
                            <ListGroup.Item className="mt-1 mb-1">
                              <h6>Principal Id:</h6>
                              <p><small>{viewData.principalName}</small></p>
                            </ListGroup.Item>

                            <ListGroup.Item className="mt-1 mb-1">
                              <h6>Display Name:</h6>
                              <p>
                                <small>{viewData.displayName}</small>&nbsp;&nbsp;
                                <Button className="btn btn-sm ml-3" onClick={() => setShowUpdateNameModal(true)}>Update</Button>
                              </p>
                            </ListGroup.Item>
                            <ListGroup.Item className="mt-1 mb-1">
                              <h6>Favorite Team:</h6>
                              <Form.Select value={favoriteTeam} onChange={handleFavoriteTeamChange}>
                                <option value="">Choose a team</option>
                                <option value="team1">Arsenal</option>
                                <option value="team1">Aston Villa</option>
                                <option value="team2">Bournemouth</option>
                                <option value="team1">Brentford</option>
                                <option value="team1">Brighton</option>
                                <option value="team1">Burnley</option>
                                <option value="team1">Chelsea</option>
                                <option value="team1">Crystal Palce</option>
                                <option value="team1">Everton</option>
                                <option value="team1">Fulham</option>
                                <option value="team1">Liverpool</option>
                                <option value="team1">Luton</option>
                                <option value="team1">Man City</option>
                                <option value="team1">Man United</option>
                                <option value="team1">Newcastle</option>
                                <option value="team1">Nottingham Forest</option>
                                <option value="team1">Tottenham</option>
                                <option value="team1">West Ham</option>
                                <option value="team1">Wolves</option>
                              </Form.Select>
                            </ListGroup.Item>
                          </Col>
                        </Row>

                        
                        
                        
                        <ListGroup.Item className="mt-1 mb-1">
                          <h6>Membership Type:</h6>
                          <p>
                            <small>{viewData.membershipType}</small>&nbsp;&nbsp;
                            {viewData.membershipType === 'free' && <Button className="btn btn-sm ml-3" onClick={() => setShowUpgradeAccountModal(true)}>Upgrade</Button>}
                          </p>
                        </ListGroup.Item>
                        {viewData.membershipType === 'diamond' && (
                          <ListGroup.Item className="mt-1 mb-1">
                            <h6>Private Leagues:</h6>
                            <p>
                              <small>{viewData.privateLeaguesUsed} / 3</small>&nbsp;&nbsp;
                              <Button className="btn btn-sm ml-3" onClick={() => setShowGetMoreLeaguesModal(true)}>Get more leagues</Button>
                            </p>
                          </ListGroup.Item>
                        )}
                        <ListGroup.Item className="mt-1 mb-1">
                        <h6>ICP</h6>
                        {loadingAccountBalance ? (
                          <div className="d-flex flex-column align-items-center justify-content-center mt-3">
                            <Spinner animation="border" />
                            <p className='text-center mt-1'><small>Loading Account Balance</small></p>
                          </div>
                        ) :  (
                          <div>
                            <p>
                              <small>{(Number(balanceData.accountBalance) / 1e8).toFixed(4)} ICP</small>&nbsp;&nbsp;
                              <Button className="btn btn-sm ml-3" onClick={() => setShowWithdrawICPModal(true)}>Withdraw</Button>
                            </p>
                          </div>
                          )}
                        {copied && <p className="text-primary"><small>Copied to clipboard.</small></p>}
                        <p>Deposit Address: <small>{toHexString(viewData.depositAddress)}{' '}
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
                      </ListGroup.Item>

                      <ListGroup.Item className="mt-1 mb-1">
                        <h6>FPL</h6>
                        {loadingAccountBalance ? (
                          <div className="d-flex flex-column align-items-center justify-content-center mt-3">
                            <Spinner animation="border" />
                            <p className='text-center mt-1'><small>Loading Account Balance</small></p>
                          </div>
                        ) :  (
                          <div>
                            <p>
                              <small>{(Number(balanceData.accountBalance) / 1e8).toFixed(4)} FPL</small>&nbsp;&nbsp;
                              <Button className="btn btn-sm ml-3" onClick={() => setShowWithdrawICPModal(true)}>Withdraw</Button>
                            </p>
                          </div>
                          )}
                        {copied && <p className="text-primary"><small>Copied to clipboard.</small></p>}
                        <p>Deposit Address: <small>{toHexString(viewData.depositAddress)}{' '}
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
                      </ListGroup.Item>
                      </ListGroup>
                    </Card.Body>
                  </Card>    </Col>
              </Row>
              <UpdateNameModal
                show={showUpdateNameModal}
                onHide={hideUpdateNameModal}
                displayName={viewData.displayName}
              />
              <UpdateProfilePictureModal
                show={showUpdateProfilePictureModal}
                onHide={() => setShowUpdateProfilePictureModal(false)}
              />
              <UpgradeMembershipModal
                show={showUpgradeAccountModal}
                onHide={() => setShowUpgradeAccountModal(false)}
              />
              {!loadingAccountBalance && (
                  <WithdrawICPModal
                    show={showWithdrawICPModal}
                    onHide={hideWithdrawICPModal}
                    balance={balanceData.accountBalance}
                  />
              )}
              {!loadingAccountBalance && (
                <WithdrawFPLModal
                  show={showWithdrawFPLModal}
                  onHide={() => setShowWithdrawFPLModal(false)}
                  balance={balanceData.accountBalance}
                />
              )}
            </Tab>
            <Tab eventKey="gameweeks" title="Gameweeks">
              <h3 className='mt-4'>Gameweek History Coming Soon</h3>
            </Tab>
            <Tab eventKey="betting" title="Betting">
              <h3 className='mt-4'>Betting History Coming Soon</h3>
            </Tab>
          </Tabs>
        </Container>
    )
  );
};

export default Profile;
