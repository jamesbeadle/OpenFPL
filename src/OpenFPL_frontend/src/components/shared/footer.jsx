import React from 'react';
import { Container, Row, Col, Button } from 'react-bootstrap';
import { LinkContainer } from 'react-router-bootstrap';
import TwitterIcon from '../../../assets/twitter.png';
import DiscordIcon from '../../../assets/discord.png';
import OpenChatIcon from '../../../assets/openchat.png';

const MyFooter = () => {
  return (
    <footer className="footer mt-auto py-3 custom-footer">
      <Container>
        <Row>
          <Col className="text-center">
            {/* Add the icons with their respective links */}
            <a href="https://twitter.com/ofpl_dao" target="_blank" rel="noopener noreferrer">
              <img src={TwitterIcon} alt="Twitter" className="social-icon" />
            </a>
            <a href="https://discord.gg/EzqH6qYa" target="_blank" rel="noopener noreferrer">
              <img src={DiscordIcon} alt="Discord" className="social-icon" />
            </a>
            <a href="https://oc.app/mww5i-uqaaa-aaaar-aqi2a-cai/?ref=zv6hh-xaaaa-aaaar-ac35q-cai" target="_blank" rel="noopener noreferrer">
              <img src={OpenChatIcon} alt="OpenChat" className="social-icon" />
            </a>
          </Col>
        </Row>
        <Row className="mt-4">
          <Col className="text-center">
            <ul className="footer-links">
              <li><LinkContainer to="/whitepaper"><a>Open FPL Whitepaper</a></LinkContainer></li>
              <li><LinkContainer to="/gameplay"><a>Open FPL Gameplay Rules</a></LinkContainer></li>
              <li><LinkContainer to="/architecture"><a>OpenFPL Architecture</a></LinkContainer></li>
              <li><LinkContainer to="/definitions"><a>Further Definitions</a></LinkContainer></li>
              <li><LinkContainer to="/terms"><a>Terms and Conditions</a></LinkContainer></li>
              <li><a href="https://github.com/jamesbeadle/OpenFPL" target='_blank'>Github</a></li>
            </ul>
          </Col>
        </Row>
        <Row className="mt-4">
          <Col className="text-center">
            OpenFPL
          </Col>
        </Row>
      </Container>
    </footer>
  );
};

export default MyFooter;
