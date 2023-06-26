import React from 'react';
import { Container, Row, Col } from 'react-bootstrap';
import { LinkContainer } from 'react-router-bootstrap';
import TwitterIcon from '../../../assets/twitter.png';
import DiscordIcon from '../../../assets/discord.png';
import OpenChatIcon from '../../../assets/openchat.png';
import LogoImage from '../../../assets/logo.png'; // Your Logo Image

const MyFooter = () => {
  return (
    <footer className="footer mt-auto py-3 custom-footer">
      <Container>
        <Row>
          <Col md={4} className="text-start">
            {/* Place additional content if needed */}
          </Col>
          <Col md={4} className="text-center">
            <div className="social-icons">
                <a href="https://twitter.com/ofpl_dao" target="_blank" rel="noopener noreferrer">
                  <img src={TwitterIcon} alt="Twitter" className="social-icon" />
                </a>
                <a href="https://discord.gg/EzqH6qYa" target="_blank" rel="noopener noreferrer">
                  <img src={DiscordIcon} alt="Discord" className="social-icon" />
                </a>
                <a href="https://oc.app/mww5i-uqaaa-aaaar-aqi2a-cai/?ref=zv6hh-xaaaa-aaaar-ac35q-cai" target="_blank" rel="noopener noreferrer">
                  <img src={OpenChatIcon} alt="OpenChat" className="social-icon" />
                </a>
            </div>
            <img src={LogoImage} alt="openFPL" style={{ maxWidth: '100px', maxHeight: '100%', marginTop: '10px' }} />
          </Col>
          <Col md={4} className="text-end">
            <Row>
              <Col>
                <ul className="footer-links">
                    <li><LinkContainer to="/architecture"><a>OpenFPL Architecture</a></LinkContainer></li>
                    <li><LinkContainer to="/definitions"><a>Further Definitions</a></LinkContainer></li>
                    <li><LinkContainer to="/terms"><a>Terms and Conditions</a></LinkContainer></li>
                </ul>
              </Col>
              <Col>
                <ul className="footer-links">
                  <li><LinkContainer to="/whitepaper"><a>Open FPL Whitepaper</a></LinkContainer></li>
                  <li><LinkContainer to="/dao"><a>Open FPL DAO Actions</a></LinkContainer></li>
                  <li><LinkContainer to="/gameplay"><a>Open FPL Gameplay Rules</a></LinkContainer></li>
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
