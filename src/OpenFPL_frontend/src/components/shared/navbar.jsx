import React, { useState, useContext, useEffect  } from "react";
import { AuthContext } from "../../contexts/AuthContext";
import Container from 'react-bootstrap/Container';
import Navbar from 'react-bootstrap/Navbar';
import Nav from 'react-bootstrap/Nav';
import { Link, useNavigate } from "react-router-dom";
import LogoImage from "../../../assets/logo.png";
import { WalletIcon } from '../icons';
import { useLocation } from 'react-router-dom';

const MyNavbar = () => {
  const { isAuthenticated, login, logout } = useContext(AuthContext);
  const navigate = useNavigate();
  const [expanded, setExpanded] = useState(false);
  const location = useLocation();
  const isActive = (path) => location.pathname === path;

  useEffect(() => {
    if (!isAuthenticated) {
      navigate("/");
    }
  }, [isAuthenticated]);

  return (
    <Navbar className='mb-3 custom-navbar' expand="lg" expanded={expanded} onToggle={() => setExpanded(!expanded)}>
      <Container fluid>
        <Navbar.Brand as={Link} to="/" onClick={() => setExpanded(false)}>
          <img src={LogoImage} alt="openFPL" style={{ maxWidth: '200px', maxHeight: '100%' }} />
        </Navbar.Brand>
    
        <Navbar.Toggle aria-controls="responsive-navbar-nav" />
        <Navbar.Collapse  id="responsive-navbar-nav" className="justify-content-end">
          {isAuthenticated && 
            <>
              <Nav.Link as={Link} to="/" onClick={() => setExpanded(false)} className={`custom-nav-link mt-2 mt-md-0 ${isActive('/') ? 'active-link' : ''}`}>
                Home
                { isActive('/') && <div className="nav-caret"></div>}
              </Nav.Link> 
              <Nav.Link as={Link} to="/pick-team" onClick={() => setExpanded(false)} className={`custom-nav-link mt-2 mt-md-0 ${isActive('/league-table') ? 'active-link' : ''}`}>
                Squad Selection
                { isActive('/pick-team') && <div className="nav-caret"></div>}
             </Nav.Link> 
              <Nav.Link as={Link} to="/profile" onClick={() => setExpanded(false)} className={`custom-nav-link mt-2 mt-md-0 ${isActive('/profile') ? 'active-link' : ''}`}>
                Profile
                { isActive('/profile') && <div className="nav-caret"></div>}
              </Nav.Link> 
              
              <Nav.Link as={Link} to="/governance" onClick={() => setExpanded(false)} className={`custom-nav-link mt-2 mt-md-0 ${isActive('/governance') ? 'active-link' : ''}`}>
                Governance
                { isActive('/governance') && <div className="nav-caret"></div>}
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
