import * as React from "react";
import { createRoot } from 'react-dom/client';
import { BrowserRouter as Router, Route, Routes } from "react-router-dom";
import '../assets/custom.scss';
import { AuthProvider } from "./contexts/AuthContext";

import MyNavbar from './components/shared/navbar';
import MyFooter from './components/shared/footer';
import Profile from "./components/profile/profile";

import Logo from '../assets/logo.png';
import Whitepaper from "./components/whitepaper/whitepaper";
import Gameplay from "./components/whitepaper/gameplay";
import Terms from "./components/terms";
import Definitions from "./components/whitepaper/definitions";
import Architecture from "./components/whitepaper/architecture";
import DAO from "./components/whitepaper/dao";
import Governance from "./components/governanace/governance";
import PickTeam from "./components/gameplay/pick-team";
import Homepage from "./components/homepage";
import FundedWhitepaper from "./components/whitepaper/funded_whitepaper";
import AddFixtureData from "./components/governanace/add-fixture-data";
import WeeklyLeaderboard from "./components/leaderboards/weekly-leaderboard";
import Leaderboard from "./components/leaderboards/season-leaderboard";
import ViewPoints from "./components/gameplay/view-points";
import { AuthGuard } from "./components/auth-guard";
import { TeamsProvider } from "./contexts/TeamsContext";
import { PlayersProvider } from "./contexts/PlayersContext";

const App = () => {
 
  return (
    <AuthProvider>
      <TeamsProvider>
        <PlayersProvider>
          <Router>
            <div style={{ minHeight: "100vh", display: "flex", flexDirection: "column" }}>
              <MyNavbar />
                <Routes>
                  <Route path="/" element={<Homepage />} />
                  <Route path="/funded-whitepaper" element={<FundedWhitepaper   />} />
                  <Route path="/whitepaper" element={<Whitepaper   />} />
                  <Route path="/gameplay" element={<Gameplay   />} />
                  <Route path="/definitions" element={<Definitions   />} />
                  <Route path="/terms" element={<Terms   />} />
                  <Route path="/architecture" element={<Architecture   />} />
                  <Route path="/profile" element={
                    <AuthGuard>
                      <Profile   />
                    </AuthGuard>
                  }/>
                  <Route path="/dao" element={<DAO   />} />
                  <Route path="/governance" element={
                    <AuthGuard>
                      <Governance   />
                    </AuthGuard>
                  }/>
                  <Route path="/add-fixture-data" element={
                    <AuthGuard>
                      <AddFixtureData   />
                    </AuthGuard>
                  }/>
                  <Route path="/weekly-leaderboard" element={<WeeklyLeaderboard   />} />
                  <Route path="/leaderboard" element={<Leaderboard   />} />
                  <Route path="/view-points/:manager/:season/:gameweek" element={<ViewPoints />} />
                  <Route path="/pick-team" element={
                    <AuthGuard>
                      <PickTeam   />
                    </AuthGuard>
                  } />
                </Routes>
              <MyFooter />
            </div>
          </Router>   
        </PlayersProvider>
      </TeamsProvider>
  </AuthProvider>
  );
};

const root = document.getElementById("app");
createRoot(root).render(
    <App />
);
