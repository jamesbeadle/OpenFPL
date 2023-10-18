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
import Governance from "./components/governanace/governance";
import PickTeam from "./components/gameplay/pick-team";
import Homepage from "./components/homepage";
import AddFixtureData from "./components/governanace/pre-sns-fixture-validation/add-fixture-data";
import LeagueTable from "./components/league-table";
import ClubDetails from "./components/club/club-details";
import PlayerDetails from "./components/club/player-details";
import FixtureValidationList from "./components/governanace/pre-sns-fixture-validation/fixture-validation-list";
import PreSNSAddFixtureData from "./components/governanace/pre-sns-fixture-validation/add-fixture-data";
import Manager from "./components/profile/manager";

const App = () => {
 
  return (
    <AuthProvider>
        <Router>
          <DataProvider>
              <div style={{ minHeight: "100vh", display: "flex", flexDirection: "column" }}>
                <MyNavbar />
                  <Routes>
                    <Route path="/" element={<Homepage />} />
                    <Route path="/whitepaper" element={<Whitepaper   />} />
                    <Route path="/gameplay" element={<Gameplay   />} />
                    <Route path="/terms" element={<Terms   />} />
                    <Route path="/profile" element={<Profile /> }/>
                    <Route path="/governance" element={<Governance /> }/>
                    <Route path="/fixture-validation-list" element={<FixtureValidationList /*Remove this post sns*/ /> }/>
                    <Route path="/old-add-fixture-data" element={<PreSNSAddFixtureData /> /*Remove this post sns*/ }/>
                    <Route path="/add-fixture-data" element={<AddFixtureData /> }/>
                    <Route path="/manager/:managerId" element={<Manager />} />
                    <Route path="/pick-team" element={ <PickTeam   /> } />
                    <Route path="/league-table" element={ <LeagueTable   /> } />
                    <Route path="/club/:teamId" element={ <ClubDetails   /> } />
                    <Route path="/player/:playerId" element={ <PlayerDetails   /> } />
                  </Routes>
                <MyFooter />
              </div>
          </DataProvider>
        </Router>   
  </AuthProvider>
  );
};

const root = document.getElementById("app");
createRoot(root).render(
    <App />
);


/*
Taken out for now

            <SnsGovernanceContext>
            </SnsGovernanceContext>
*/
