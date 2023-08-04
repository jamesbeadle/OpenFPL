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
import { EditIcon, CopyIcon, StarIcon } from '../icons';
import ProfileImage from '../../../assets/profile_placeholder.png';

const Profile = () => {

  const { authClient } = useContext(AuthContext);
  const [isLoading, setIsLoading] = useState(true);
  const [showUpdateNameModal, setShowUpdateNameModal] = useState(false);
  const [showUpdateProfilePictureModal, setShowUpdateProfilePictureModal] = useState(false);
  const [showWithdrawICPModal, setShowWithdrawICPModal] = useState(false);
  const [showWithdrawFPLModal, setShowWithdrawFPLModal] = useState(false);
  const [favouriteTeam, setFavouriteTeam] = useState(null);
  const [loadingAccountBalance, setLoadingAccountBalance] = useState(true);
  const [balanceData, setBalanceData] = useState(null);

  const [showUpgradeAccountModal, setShowUpgradeAccountModal] = useState(false);
  const [showGetMoreLeaguesModal, setShowGetMoreLeaguesModal] = useState(false);

  const [profilePicSrc, setProfilePicSrc] = useState(ProfileImage);
  const [joinedDate, setJoinedDate] = useState('');

  const [teams, setTeamsData] = useState([]);
  const [viewData, setViewData] = useState(null);
  const [icpAddressCopied, setICPAddressCopied] = useState(false);
  const [fplAddressCopied, setFPLAddressCopied] = useState(false);
  
  useEffect(() => {
    const fetchData = async () => {
      await fetchTeams();
      await fetchViewData();
      setIsLoading(false);
    };
    fetchData();
  }, []);

  
  
  const fetchTeams = async () => {
    const teamsData = await open_fpl_backend.getTeams();
    setTeamsData(teamsData);
  };

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

    const dateInMilliseconds = Number(data.createDate / 1000000n);
    const date = new Date(dateInMilliseconds);
    const monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
    const joinDate = `${monthNames[date.getUTCMonth()]} ${date.getUTCFullYear()}`;
    setJoinedDate(joinDate);

    if (data.profilePicture && data.profilePicture.length > 0) {
     
      const blob = new Blob([data.profilePicture]);
      const blobUrl = URL.createObjectURL(blob);
      setProfilePicSrc(blobUrl);

    } else {
      setProfilePicSrc(ProfileImage);
    }
    setFavouriteTeam(data.favouriteTeamId);
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

  const hideWithdrawFPLModal = async (changed) => {
    if(!changed){
      setShowWithdrawFPLModal(false); 
      return;
    }
    setIsLoading(true);
    setShowWithdrawFPLModal(false); 
    await fetchViewData();
    setIsLoading(false);
  };

  const hideProfilePictureModal = async (changed) => {
    if(!changed){
      setShowUpdateProfilePictureModal(false); 
      return;
    }
    setIsLoading(true);
    setShowUpdateProfilePictureModal(false); 
    await fetchViewData();
    setIsLoading(false);
  };

  const hideUpgradeAccountModal = async (changed) => {
    if(!changed){
      setShowUpgradeAccountModal(false); 
      return;
    }
    setIsLoading(true);
    setShowUpgradeAccountModal(false); 
    await fetchViewData();
    setIsLoading(false);
  };
  
  const handleFavoriteTeamChange = async (event) => {
    setIsLoading(true);
    setFavouriteTeam(Number(event.target.value));
    const identity = authClient.getIdentity();
    Actor.agentOf(open_fpl_backend).replaceIdentity(identity);
    await open_fpl_backend.updateFavouriteTeam(Number(event.target.value));
    setIsLoading(false);
  };

  return (
      isLoading ? (
        <div className="customOverlay d-flex flex-column align-items-center justify-content-center">
          <Spinner animation="border" />
          <p className='text-center mt-1'>Loading Profile</p>
        </div>
      ) : (
        <Container className="flex-grow-1 my-5">
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
                            <ListGroup.Item className="mt-1 mb-1">
                              <h6>Joined: {joinedDate}</h6>
                              <h6>Reputation: {viewData.reputation}</h6>
                              <div>
                                {viewData.reputation === 0 && (
                                  <>
                                    <StarIcon color="#807A00" margin="0 10px 0 0" />
                                    <StarIcon color="#807A00" margin="0 10px 0 0" />
                                    <StarIcon color="#807A00" margin="0 10px 0 0" />
                                  </>
                                )}
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
                              <Form.Group controlId="favouriteTeam">
                                <Form.Label>Favorite Team</Form.Label>
                                <Form.Control as="select" value={favouriteTeam || 0} onChange={handleFavoriteTeamChange}>
                                    <option value="">Select Favourite Team</option>
                                      {teams.map((team) => (
                                      <option key={team.id} value={team.id}>
                                          {team.name}
                                      </option>
                                      ))}
                                </Form.Control>
                              </Form.Group>
                            </ListGroup.Item>
                          </Col>
                        </Row>

                        
                        
                        
                        <ListGroup.Item className="mt-1 mb-1">
                          <h6>Membership Type:</h6>
                          <p>
                            <small>{viewData.membershipType === 0 ? 'Free' : 'Diamond'}</small>&nbsp;&nbsp;
                            
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
                            <p className='text-center mt-1'><small>Loading ICP Balance</small></p>
                          </div>
                        ) :  (
                          <div>
                            <p>
                              <small>{(Number(balanceData.icpBalance) / 1e8).toFixed(4)} ICP</small>&nbsp;&nbsp;
                            </p>
                          </div>
                          )}
                        <p><small>ICP Deposit Address: <br />{toHexString(viewData.icpDepositAddress)}{' '}
                        <CopyIcon onClick={async () => {
                          try {
                            await navigator.clipboard.writeText(toHexString(viewData.icpDepositAddress));
                            setICPAddressCopied(true);
                          } catch (error) {
                            console.error('Clipboard API error:', error);
                            setICPAddressCopied(false);
                          }
                        }} />
                        </small></p>
                        {icpAddressCopied && <p className="text-primary"><small>Copied to clipboard.</small></p>}
                      </ListGroup.Item>

                      <ListGroup.Item className="mt-1 mb-1">
                        <h6>FPL</h6>
                        {loadingAccountBalance ? (
                          <div className="d-flex flex-column align-items-center justify-content-center mt-3">
                            <Spinner animation="border" />
                            <p className='text-center mt-1'><small>Loading FPL Balance</small></p>
                          </div>
                        ) :  (
                          <div>
                            <p>
                              <small>{(Number(balanceData.fplBalance) / 1e8).toFixed(4)} FPL</small>&nbsp;&nbsp;
                            </p>
                          </div>
                          )}
                        <p><small>FPL Deposit Address:<br /> {toHexString(viewData.fplDepositAddress)}{' '}
                        <CopyIcon onClick={async () => {
                          try {
                            await navigator.clipboard.writeText(toHexString(viewData.fplDepositAddress));
                            setFPLAddressCopied(true);
                          } catch (error) {
                            console.error('Clipboard API error:', error);
                            setFPLAddressCopied(false);
                          }
                        }} />
                        </small></p>
                        {fplAddressCopied && <p className="text-primary"><small>Copied to clipboard.</small></p>}
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
                onHide={hideProfilePictureModal}
              />
              <UpgradeMembershipModal
                show={showUpgradeAccountModal}
                onHide={hideUpgradeAccountModal}
              />
              {!loadingAccountBalance && (
                  <WithdrawICPModal
                    show={showWithdrawICPModal}
                    onHide={hideWithdrawICPModal}
                    balance={balanceData.icpBalance}
                  />
              )}
              {!loadingAccountBalance && (
                <WithdrawFPLModal
                  show={showWithdrawFPLModal}
                  onHide={hideWithdrawFPLModal}
                  balance={balanceData.fplBalance}
                />
              )}
            </Tab>
            <Tab eventKey="gameweeks" title="Gameweeks">
              <h3 className='mt-4'>Gameweek History Coming Soon</h3>
            </Tab>
            <Tab eventKey="betting" title="Betting">
              <h3 className='mt-4'>Betting History Coming Soon</h3>
            </Tab>
            <Tab eventKey="governance" title="Governance">
              <h3 className='mt-4'>Governance History Coming Soon</h3>
            </Tab>
          </Tabs>
        </Container>
    )
  );
};

export default Profile;
