import * as React from "react";
import { createRoot } from 'react-dom/client';
import { BrowserRouter as Router, Route, Routes } from "react-router-dom";
import '../assets/custom.scss';
import { AuthProvider } from "./contexts/AuthContext";

import MyNavbar from './components/shared/navbar';
import MyFooter from './components/shared/footer';
import Home from "./components/home";
import Profile from "./components/profile/profile";

import Logo from '../assets/logo.png';
import Whitepaper from "./components/whitepaper";
import Gameplay from "./components/gameplay";
import Terms from "./components/terms";
import Definitions from "./components/definitions";
import Architecture from "./components/architecture";

const PrivateWindowFallback = () => {
  return (
    <div style={{ minHeight: "100vh", display: "flex", flexDirection: "column", justifyContent: "center", alignItems: "center" }}>
      <h3 className="text-center">You cannot play from a private browser window.</h3>
      <img src={Logo} alt="openfpl" style={{ maxWidth: '200px', maxHeight: '100%', marginTop: '50px' }} />
      
    </div>
  );
};

const App = () => {

  const [isPrivateWindow, setIsPrivateWindow] = React.useState(false);

  React.useEffect(() => {
    if (window.indexedDB) {
      const request = window.indexedDB.open("TestDB");

      request.onerror = () => {
        setIsPrivateWindow(true);
      };

      request.onsuccess = (event) => {
        const db = event.target.result;
        db.close();
        const deleteRequest = window.indexedDB.deleteDatabase("TestDB");
  
        deleteRequest.onerror = (event) => {
          console.error("Failed to delete TestDB", event);
        };
  
        deleteRequest.onsuccess = () => {
          //console.log("TestDB deleted successfully");
        };
      };
    } else {
      setIsPrivateWindow(true);
    }
  }, []);

  if (isPrivateWindow) {
    return (
      <PrivateWindowFallback />
    );
  }
 
  return (
    <AuthProvider>
      <Router>
        <div style={{ minHeight: "100vh", display: "flex", flexDirection: "column" }}>
          <MyNavbar />
            <Routes>
              <Route path="/" element={<Whitepaper />} />
              <Route path="/whitepaper" element={<Whitepaper   />} />
              <Route path="/gameplay" element={<Gameplay   />} />
              <Route path="/definitions" element={<Definitions   />} />
              <Route path="/terms" element={<Terms   />} />
              <Route path="/architecture" element={<Architecture   />} />
            </Routes>
          <MyFooter />
        </div>
      </Router>   
  </AuthProvider>
  );
};

const root = document.getElementById("app");
createRoot(root).render(
    <App />
);
