import React from 'react';
import { Container, Row, Col, Card } from 'react-bootstrap';
import { LinkContainer } from 'react-router-bootstrap';
import TwitterIcon from '../../../assets/twitter.png';
import DiscordIcon from '../../../assets/discord.png';
import OpenChatIcon from '../../../assets/openchat.png';
import TelegramLogo from '../../../assets/telegram.png';
import GitHubLogo from '../../../assets/github.png';
import FooterSponsor from '../../../assets/footer_sponsor.png';
import { LogoIcon } from '../icons';

const MyFooter = () => {
  return (
    <footer className="footer py-3 custom-footer">
      <Container fluid className='view-container mt-2'>
        <Card>
          <Row className='footer-container'>
            <Col xs={7}>
              <Row className="footer-links">
                <Col xs={12} className='footer-logo-container'>
                  <LogoIcon fill={'#FFFFFF'} /> <b className="logo-text">OPENFPL</b>
                </Col>
                <Col className='mb-2' xs={12}>
                  <LinkContainer to="/whitepaper"><a className='footer-link'>Whitepaper</a></LinkContainer>
                </Col>
                <Col className='mb-2' xs={12}>
                  <LinkContainer to="/gameplay"><a className='footer-link'>Gameplay Rules</a></LinkContainer>
                </Col>
                <Col className='mb-2' xs={12}>
                  <LinkContainer to="/terms"><a className='footer-link'>Terms and Conditions</a></LinkContainer>
                </Col>
                <Col className='mb-2' xs={12}>
                  <LinkContainer to="/fixture-validation-list" /*Remove this post sns*/><a className='footer-link'>Pre-SNS Fixture Validation</a></LinkContainer>
                </Col>                
              </Row>
              
              <div className='mt-1' style={{display: 'inline-block'}}>
                  <a href="https://oc.app/community/uf3iv-naaaa-aaaar-ar3ta-cai/?ref=zv6hh-xaaaa-aaaar-ac35q-cai" target="_blank" rel="noopener noreferrer">
                    <img src={OpenChatIcon} alt="OpenChat" className="social-icon" />
                  </a>
                  <a href="https://twitter.com/OpenFPL_DAO" target="_blank" rel="noopener noreferrer">
                    <img src={TwitterIcon} alt="Twitter" className="social-icon" />
                  </a>
                  <a href="https://t.co/WmOhFA8JUR" target="_blank" rel="noopener noreferrer">
                    <img src={DiscordIcon} alt="Discord" className="social-icon" />
                  </a>
                  <a href="https://t.co/vVkquMrdOu" target="_blank" rel="noopener noreferrer">
                    <img src={TelegramLogo} alt="OpenChat" className="social-icon" />
                  </a>
                  <a href="https://github.com/jamesbeadle/OpenFPL" target="_blank" rel="noopener noreferrer">
                    <img src={GitHubLogo} alt="GitHub" className="social-icon" />
                  </a>
              </div>
            </Col>
            <Col xs={5} className="text-right footer-sponsor"><a href="https://juno.build" target='_blank'>
              <div>
              <Row>
                <Col className='mt-4 mb-2'>Sponsored By</Col>
              </Row>
              <Row>
                <Col className='mb-2'><img src={FooterSponsor} className='footer-sponsor-image' /></Col>
              </Row>
              <Row>
                <Col>juno.build</Col>
              </Row>
              </div></a>
            </Col>
          </Row>
        </Card>
      </Container>
    </footer>
  );
};

export default MyFooter;
