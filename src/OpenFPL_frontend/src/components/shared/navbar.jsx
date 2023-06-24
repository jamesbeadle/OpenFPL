import React, { useState, useContext, useEffect  } from "react";
import { AuthContext } from "../../contexts/AuthContext";
import Container from 'react-bootstrap/Container';
import Navbar from 'react-bootstrap/Navbar';
import Nav from 'react-bootstrap/Nav';
import Button from 'react-bootstrap/Button';
import { Link, useNavigate } from "react-router-dom";
import LogoImage from "../../../assets/logo.png";
import { LogoutIcon, ProfileIcon, GovernanceIcon } from '../icons';

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
    <Navbar expand="lg">
      <Container>
        <Navbar.Brand as={Link} to="/" onClick={() => setExpanded(false)}>
          <img src={LogoImage} alt="openFPL" style={{ maxWidth: '200px', maxHeight: '100%' }} />
        </Navbar.Brand>
    
        <Navbar.Toggle aria-controls="responsive-navbar-nav" />
        <Navbar.Collapse  id="responsive-navbar-nav" className="justify-content-end">
          {isAuthenticated && 
            <>
              <Nav.Link as={Link} to="/governance" onClick={() => setExpanded(false)}  className="custom-nav-link">
                Governance
                <GovernanceIcon className="custom-icon" ></GovernanceIcon>
              </Nav.Link> 
              <Nav.Link as={Link} to="/profile" onClick={() => setExpanded(false)}  className="custom-nav-link">
                Profile
                <ProfileIcon className="custom-icon" ></ProfileIcon>
              </Nav.Link> 
              <Nav.Link onClick={() => {logout(); setExpanded(false);}} className="custom-nav-link mt-2 mt-md-0">
                <button className="btn btn-primary">Disconnect
                <LogoutIcon className="custom-icon" ></LogoutIcon></button>
              </Nav.Link> 
            </>
          }
          {!isAuthenticated && 
            <Button className="nav-link-brand" onClick={() => { login(); setExpanded(false); }}>CONNECT</Button>
          }
          
        </Navbar.Collapse>
      </Container>
    </Navbar>
  );
};

export default MyNavbar;
