import React, { useState, useContext, useEffect  } from "react";
import { AuthContext } from "../../contexts/AuthContext";
import Container from 'react-bootstrap/Container';
import Navbar from 'react-bootstrap/Navbar';
import Nav from 'react-bootstrap/Nav';
import { Link, useNavigate } from "react-router-dom";
import LogoImage from "../../../assets/logo.png";
import { ProfileIcon, GovernanceIcon, TeamIcon, WalletIcon, TableIcon } from '../icons';

const MyNavbar = () => {
  const { isAuthenticated, login, logout } = useContext(AuthContext);
  const navigate = useNavigate();
  const [expanded, setExpanded] = useState(false);

  useEffect(() => {
    if (!isAuthenticated) {
      navigate("/");
    }
  }, [isAuthenticated]);

  return (
    <Navbar expand="lg" expanded={expanded} onToggle={() => setExpanded(!expanded)}>
      <Container>
        <Navbar.Brand as={Link} to="/" onClick={() => setExpanded(false)}>
          <img src={LogoImage} alt="openFPL" style={{ maxWidth: '150px', maxHeight: '100%' }} /> <small className="small-text"><b>BETA</b></small>
        </Navbar.Brand>
    
        <Navbar.Toggle aria-controls="responsive-navbar-nav" />
        <Navbar.Collapse  id="responsive-navbar-nav" className="justify-content-end">
          {isAuthenticated && 
            <>
              <Nav.Link as={Link} to="/pick-team" onClick={() => setExpanded(false)}  className="custom-nav-link mt-2 mt-md-0">
                Pick Team
                <TeamIcon className="custom-icon" ></TeamIcon>
              </Nav.Link> 
              <Nav.Link as={Link} to="/league-table" onClick={() => setExpanded(false)}  className="custom-nav-link mt-2 mt-md-0">
                Table
                <TableIcon className="custom-icon" ></TableIcon>
              </Nav.Link> 
              <Nav.Link as={Link} to="/governance" onClick={() => setExpanded(false)}  className="custom-nav-link mt-2 mt-md-0">
                Governance
                <GovernanceIcon className="custom-icon" ></GovernanceIcon>
              </Nav.Link> 
              <Nav.Link as={Link} to="/profile" onClick={() => setExpanded(false)}  className="custom-nav-link mt-2 mt-md-0">
                Profile
                <ProfileIcon className="custom-icon" ></ProfileIcon>
              </Nav.Link> 
              <Nav.Link onClick={() => {logout(); setExpanded(false);}} className="custom-nav-link mt-2 mt-md-0">
                <button style={{padding: 0}} className="wallet-icon">Disconnect <WalletIcon className="custom-icon" ></WalletIcon></button>
              </Nav.Link> 
            </>
          }
          {!isAuthenticated && 
            <button className="wallet-icon" onClick={() => { login(); setExpanded(false); }}>Connect <WalletIcon className="custom-icon" ></WalletIcon></button>
            
          }
          
        </Navbar.Collapse>
      </Container>
    </Navbar>
  );
};

export default MyNavbar;
