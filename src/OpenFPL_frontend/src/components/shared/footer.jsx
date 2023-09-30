import React from 'react';
import { Container, Row, Col } from 'react-bootstrap';
import { LinkContainer } from 'react-router-bootstrap';
import TwitterIcon from '../../../assets/twitter.png';
import DiscordIcon from '../../../assets/discord.png';
import OpenChatIcon from '../../../assets/openchat.png';
import TelegramLogo from '../../../assets/telegram.png';
import GitHubLogo from '../../../assets/github.png';
import LogoImage from '../../../assets/logo.png';

const MyFooter = () => {
  return (
    <footer className="footer mt-auto py-3 custom-footer">
      <Container fluid>
        <Row>
          <Col md={4}>
            <p className='social-icons' style={{display: 'inline-block'}}>
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
            </p>
          </Col>
          <Col md={4} xs={12} className="text-center">
            <img src={LogoImage} alt="openFPL" style={{ maxWidth: '100px', maxHeight: '100%', marginTop: '10px' }} />
          </Col>
          <Col md={4} xs={12} className="text-md-end text-center">
            <Row className="mt-4">
              <Col md={12} xs={12}>
                <ul className="footer-links">
                  <li><LinkContainer to="/funded-whitepaper"><a className='footer-link'>Whitepaper</a></LinkContainer></li>
                  <li><LinkContainer to="/gameplay"><a className='footer-link'>Gameplay Rules</a></LinkContainer></li>
                    <li><LinkContainer to="/terms"><a className='footer-link'>Terms and Conditions</a></LinkContainer></li>
                    <li><LinkContainer to="/fixture-validation-list" /*Remove this post sns*/><a className='footer-link'>Fixture Validation (To be removed post SNS)</a></LinkContainer></li>
                </ul>
              </Col>
            </Row>
          </Col>
        </Row>
      </Container>
    </footer>
  );
};

export default MyFooter;
