import * as React from "react";
import { createRoot } from 'react-dom/client';
import { BrowserRouter as Router, Route, Routes } from "react-router-dom";
import '../assets/custom.scss';
import { AuthProvider } from "./contexts/AuthContext";
import { DataProvider } from "./contexts/DataContext";
import { SnsGovernanceContext } from "./contexts/SNSGovernanceContext";

import MyNavbar from './components/shared/navbar';
import MyFooter from './components/shared/footer';
import Profile from "./components/profile/profile";

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
import AddFixtureData from "./components/governanace/fixture-validation/add-fixture-data";
import WeeklyLeaderboard from "./components/leaderboards/weekly-leaderboard";
import Leaderboard from "./components/leaderboards/season-leaderboard";
import ViewPoints from "./components/gameplay/view-points";
import LeagueTable from "./components/league-table";
import ClubDetails from "./components/data/club-details";
import PlayerDetails from "./components/data/player-details";
import ClubLeaderboard from "./components/leaderboards/club-leaderboard";

const App = () => {
 
  return (
    <AuthProvider>
        <Router>
          <DataProvider>
            <SnsGovernanceContext>
              <div style={{ minHeight: "100vh", display: "flex", flexDirection: "column" }}>
                <MyNavbar />
                  <Routes>
                    <Route path="/" element={<Homepage />} />
                    <Route path="/funded-whitepaper" element={<FundedWhitepaper />} />
                    <Route path="/whitepaper" element={<Whitepaper   />} />
                    <Route path="/gameplay" element={<Gameplay   />} />
                    <Route path="/definitions" element={<Definitions   />} />
                    <Route path="/terms" element={<Terms   />} />
                    <Route path="/architecture" element={<Architecture />} />
                    <Route path="/profile" element={<Profile /> }/>
                    <Route path="/dao" element={<DAO />} />
                    <Route path="/governance" element={<Governance /> }/>
                    <Route path="/add-fixture-data" element={<AddFixtureData /> }/>
                    <Route path="/weekly-leaderboard" element={<WeeklyLeaderboard />} />
                    <Route path="/leaderboard" element={<Leaderboard />} />
                    <Route path="/view-points/:manager/:season/:gameweek" element={<ViewPoints />} />
                    <Route path="/pick-team" element={ <PickTeam   /> } />
                    <Route path="/league-table" element={ <LeagueTable   /> } />
                    <Route path="/club/:teamId" element={ <ClubDetails   /> } />
                    <Route path="/player/:playerId" element={ <PlayerDetails   /> } />
                    <Route path="/club-leaderboard/:teamId" element={ <ClubLeaderboard   /> } />
                  </Routes>
                <MyFooter />
              </div>
            </SnsGovernanceContext>
          </DataProvider>
        </Router>   
  </AuthProvider>
  );
};

const root = document.getElementById("app");
createRoot(root).render(
    <App />
);
