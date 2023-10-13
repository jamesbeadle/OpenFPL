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
    <footer className="footer mt-auto py-3 custom-footer">
      <Container fluid className='view-container mt-2'>
        <Card>
          <Row style={{padding: '20px'}}>
            <Col xs={6}>
                  <ul className="footer-links">
                    <li><LogoIcon width={16} height={16} fill={'#FFFFFF'} /> <b className="footer-logo-text">OPENFPL</b></li>
                    <li><LinkContainer to="/whitepaper"><a className='footer-link'>Whitepaper</a></LinkContainer></li>
                    <li><LinkContainer to="/gameplay"><a className='footer-link'>Gameplay Rules</a></LinkContainer></li>
                      <li><LinkContainer to="/terms"><a className='footer-link'>Terms and Conditions</a></LinkContainer></li>
                      <li><LinkContainer to="/fixture-validation-list" /*Remove this post sns*/><a className='footer-link'>Fixture Validation (To be removed post SNS)</a></LinkContainer></li>
                  </ul>
              <div className='social-icons' style={{display: 'inline-block'}}>
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
            <Col xs={6} className="text-right footer-sponsor"><a href="https://juno.build" target='_blank'>
              <div>
              <Row>
                <Col className='mb-2'>Sponsored By</Col>
              </Row>
              <Row>
                <Col className='mb-2'><img src={FooterSponsor} width={80} /></Col>
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
