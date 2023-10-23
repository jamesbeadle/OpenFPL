import React, { useState, useContext, useEffect } from 'react';
import { Container, Row, Col, Card, Button, Spinner, Tabs, Tab, Form, Image } from 'react-bootstrap';
import { OpenFPL_backend as open_fpl_backend } from '../../../../declarations/OpenFPL_backend';
import { Actor } from "@dfinity/agent";
import { AuthContext } from "../../contexts/AuthContext";
import { DataContext } from "../../contexts/DataContext";
import { monthNames } from '../helpers';
import UpdateNameModal from './update-name-modal';
import UpdateProfilePictureModal from './update-profile-picture-modal';
import { EditIcon } from '../icons';
import ProfileImage from '../../../assets/profile_placeholder.png';
import ICPCoin from '../../../assets/ICPCoin.png';
import FPLCoin from '../../../assets/FPLCoin.png';
import ckBTCCoin from '../../../assets/ckBTCCoin.png';
import ckETHCoin from '../../../assets/ckETHCoin.png';
import ConfirmFavouriteTeamModal from './confirm-favourite-team-modal';

const Profile = () => {

  const { authClient } = useContext(AuthContext);
  const { teams } = useContext(DataContext);
  const [isLoading, setIsLoading] = useState(true);
  const [showUpdateNameModal, setShowUpdateNameModal] = useState(false);
  const [showUpdateProfilePictureModal, setShowUpdateProfilePictureModal] = useState(false);
  const [favouriteTeam, setFavouriteTeam] = useState(null);
  const [loadingAccountBalance, setLoadingAccountBalance] = useState(true);
  const [balanceData, setBalanceData] = useState(null);

  const [profilePicSrc, setProfilePicSrc] = useState(ProfileImage);
  const [joinedDate, setJoinedDate] = useState('');

  const [viewData, setViewData] = useState(null);
  const [icpAddressCopied, setICPAddressCopied] = useState(false);
  const [fplAddressCopied, setFPLAddressCopied] = useState(false);

  const [showConfirmFavouriteTeamModal, setShowConfirmFavouriteTeamModal] = useState(false);
  const [selectedTeamId, setSelectedTeamId] = useState(null);
  const [selectedTeamName, setSelectedTeamName] = useState("");

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
    try {
        const identity = authClient.getIdentity();
        Actor.agentOf(open_fpl_backend).replaceIdentity(identity);
        const data = await open_fpl_backend.getProfileDTO();
        setViewData(data);

        const dateInMilliseconds = Number(data.createDate / 1000000n);
        const date = new Date(dateInMilliseconds);
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
    } catch (error){
        console.log(error);
    };
  };

  const fetchAccountBalance = async () => {
    try {
      const identity = authClient.getIdentity();
      Actor.agentOf(open_fpl_backend).replaceIdentity(identity);
      const data = await open_fpl_backend.getAccountBalanceDTO();
      setBalanceData(data);
    } catch (error) {
      console.log(error);
    }
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
  
  const handleFavoriteTeamChange = async (event) => {
    setSelectedTeamId(Number(event.target.value));
    let team = teams.find(t => t.id === Number(event.target.value));
    setSelectedTeamName(team.friendlyName);
    setShowConfirmFavouriteTeamModal(true);
  };
  
  const handleConfirmFavouriteTeamClick = async (favouriteTeamId) => {
    try{
      setIsLoading(true);
      const identity = authClient.getIdentity();
      Actor.agentOf(open_fpl_backend).replaceIdentity(identity);
      await open_fpl_backend.updateFavouriteTeam(Number(favouriteTeamId));
      setShowConfirmFavouriteTeamModal(false);
      setFavouriteTeam(Number(favouriteTeamId));  
    } catch (error){
      console.log(error);
    } finally {
      setIsLoading(false);
    }
  };

  return (
      isLoading ? (
        <div className="customOverlay d-flex flex-column align-items-center justify-content-center">
          <Spinner animation="border" />
          <p className='text-center mt-1'>Loading Profile</p>
        </div>
      ) : (
        <Container fluid className='view-container mt-2'>
          <Row>
            <Col xs={12}>
              <Card>
                <div className="d-flex">
                  <div className="flex-grow-1 light-background">
                    <Tabs defaultActiveKey="details" id="profile-tabs" className="tab-header">
                      <Tab eventKey="details" title="Details">
                        <div className="dark-tab-row w-100 mx-0">
                          <Row>
                            <Col xs={12} md={'auto'} className="d-flex justify-content-center mb-2">
                              <div className='profile-picture-col'>
                                <div className="vertical-flex">
                                  <Image src={profilePicSrc} className="profile-detail-image" />
                                  <div className="edit-profile-icon position-absolute top-0 right-0">
                                    <EditIcon onClick={() => setShowUpdateProfilePictureModal(true)} />
                                </div>
                                </div>
                              </div>
                            </Col>
                            <Col xs={12} md={6}>
                              <div className='profile-details-row'>
                                <div className='profile-details-col'>
                                  <div className='profile-detail-row-1'>
                                    <Row>
                                      <div className='profile-display-name-col'>
                                        <p className="stat-header w-100">Display Name</p>
                                      </div>
                                      <div className='profile-favourite-team-col'>
                                        <p className="stat-header w-100">Favourite Team</p>
                                      </div>
                                    </Row>
                                    <Row>
                                      <div className='profile-display-name-col'>  
                                        <p className="header-stat">{viewData.displayName == viewData.principalName ? 'Not Set' : viewData.displayName}</p>
                                      </div>
                                      <div className='profile-favourite-team-col' style={{ display: 'flex', alignItems: 'center' }}>
                                        <Form.Group controlId="favouriteTeam">
                                          <Form.Control className="stat-dropdown" as="select" value={favouriteTeam || 0} onChange={handleFavoriteTeamChange} disabled={!viewData.canUpdateFavouriteTeam}>
                                            <option value="">Select Favourite Team</option>
                                              {teams.map((team) => (
                                              <option key={team.id} value={team.id}>
                                                  {team.friendlyName}
                                              </option>
                                            ))}
                                          </Form.Control>
                                        </Form.Group>
                                      </div>
                                    </Row>
                                    <Row>
                                      <div className='profile-display-name-col'>  
                                        <Button className="fpl-large-btn" onClick={() => setShowUpdateNameModal(true)}>Update</Button>
                                      </div>
                                    </Row>
                                  </div>
                                  <div className='profile-detail-row-2 mt-2'>
                                    <p className='w-100'><b>Joined </b>{joinedDate}</p>
                                    <p className='w-100'><small><b>Principal ID </b>{viewData.principalName}</small></p>
                                  </div>
                                </div>
                              </div>
                            </Col>
                          </Row>
                          <Row className='coins-row' >
                            <Col xs={12} md={6} xxl={3} className='mb-0 mb-md-3'>
                              <div className='coin-col-1 coin-col mb-3 mb-md-0'>
                                <div className='coin-icon-col'>
                                  <img src={ICPCoin} alt="sponsor1" className='coin-icon'/>
                                </div>
                                <div className='coin-name-col'>
                                  <Container>
                                    <Row>
                                      <Col>
                                          <div className='coin-name'>ICP</div>
                                      </Col>
                                    </Row>
                                    <Row>
                                      <Col>
                                          <div className='coin-balance'>0.00 <span className='coin-balance-suffix'>ICP</span></div>
                                      </Col>
                                    </Row>
                                  </Container>
                                </div>
                              </div>
                            </Col>
                            <Col xs={12} md={6} xxl={3} className='mb-0 mb-md-3'>
                            <div className='coin-col-2 coin-col mb-3 mb-md-0'>
                                <div className='coin-icon-col'>
                                  <img src={FPLCoin} alt="sponsor1" className='coin-icon' />
                                </div>
                                <div className='coin-name-col'>
                                  <Container>
                                    <Row>
                                      <Col>
                                          <div className='coin-name'>FPL</div>
                                      </Col>
                                    </Row>
                                    <Row>
                                      <Col>
                                          <div className='coin-balance'>0.00 <span className='coin-balance-suffix'>FPL</span></div>
                                      </Col>
                                    </Row>
                                  </Container>
                                </div>
                              </div>
                            </Col>
                            <Col xs={12} md={6} xxl={3} className='mb-0 mb-md-3'>
                              <div className='coin-col-3 coin-col mb-3 mb-md-0'>
                                <div className='coin-icon-col'>
                                  <img src={ckBTCCoin} alt="sponsor1" className='coin-icon' />
                                </div>
                                <div className='coin-name-col'>
                                  <Container>
                                    <Row>
                                      <Col>
                                          <div className='coin-name'>ckBTC</div>
                                      </Col>
                                    </Row>
                                    <Row>
                                      <Col>
                                          <div className='coin-balance'>0.00 <span className='coin-balance-suffix'>ckBTC</span></div>
                                      </Col>
                                    </Row>
                                  </Container>
                                </div>
                              </div>
                            </Col>
                            <Col xs={12} md={6} xxl={3} className='mb-0 mb-md-3'>
                              <div className='coin-col-4 coin-col mb-3 mb-md-0'>
                                <div className='coin-icon-col'>
                                  <img src={ckETHCoin} alt="sponsor1" className='coin-icon' />
                                </div>
                                <div className='coin-name-col'>
                                  <Container>
                                    <Row>
                                      <Col>
                                          <div className='coin-name'>ckETH</div>
                                      </Col>
                                    </Row>
                                    <Row>
                                      <Col>
                                          <div className='coin-balance'>0.00 <span className='coin-balance-suffix'>ETH</span></div>
                                      </Col>
                                    </Row>
                                  </Container>
                                </div>
                              </div>
                            </Col>
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
                        </div>
                      </Tab>
                      <Tab eventKey="gameweeks" title="Gameweeks">
                        <p className='px-4 mt-4 mb-4'>Gameweek History Coming Soon</p>
                      </Tab>
                      <Tab eventKey="governance" title="Governance">
                        <p className='px-4 mt-4 mb-4'>Governance History Coming Soon</p>
                      </Tab>
                    </Tabs>
                  </div>
                </div>
              </Card>
            </Col>
          </Row>

          {showConfirmFavouriteTeamModal && <ConfirmFavouriteTeamModal
            show={showConfirmFavouriteTeamModal}
            handleClose={() => { setShowConfirmFavouriteTeamModal(false); setSelectedTeamId(null); } }
            handleConfirm={handleConfirmFavouriteTeamClick}
            teamId={selectedTeamId}
            teamName={selectedTeamName}
          />}

        </Container>
    )
  );
};

export default Profile;
