  import Array "mo:base/Array";
  import Bool "mo:base/Bool";
  import Buffer "mo:base/Buffer";
  import Cycles "mo:base/ExperimentalCycles";
  import Int "mo:base/Int";
  import Iter "mo:base/Iter";
  import Principal "mo:base/Principal";
  import Result "mo:base/Result";
  import Time "mo:base/Time";
  import Timer "mo:base/Timer";
  import Nat64 "mo:base/Nat64";
  import Nat "mo:base/Nat";
  import Option "mo:base/Option";
  import List "mo:base/List";
  import Order "mo:base/Order";
  import Debug "mo:base/Debug";

  import T "../shared/types";
  import DTOs "../shared/DTOs";
  import Requests "../shared/RequestDTOs";
  import Countries "../shared/Countries";
  import Utilities "../shared/utils/utilities";
  import Account "../shared/lib/Account";

  import Management "../shared/utils/Management";
  import FPLLedger "../shared/def/FPLLedger";
  import ManagerCanister "../shared/canister_definitions/manager-canister";
  import DataManager "../shared/managers/data-manager";
  import LeaderboardManager "../shared/managers/leaderboard-manager";
  import UserManager "../shared/managers/user-manager";
  import SeasonManager "../shared/managers/season-manager";
  import CyclesDispenser "../shared/cycles-dispenser";
  import Environment "./Environment";
  import NetworkEnvironmentVariables "../shared/network_environment_variables";
  import Responses "../shared/ResponseDTOs";

  actor Self {
    
    private let userManager = UserManager.UserManager(Environment.BACKEND_CANISTER_ID, Environment.NUM_OF_GAMEWEEKS);
    private let dataManager = DataManager.DataManager();
    private let seasonManager = SeasonManager.SeasonManager(Environment.NUM_OF_GAMEWEEKS);
    private let leaderboardManager = LeaderboardManager.LeaderboardManager(Environment.BACKEND_CANISTER_ID, Environment.NUM_OF_GAMEWEEKS, Environment.NUM_OF_MONTHS);
    private let cyclesDispenser = CyclesDispenser.CyclesDispenser();
    private let ledger : FPLLedger.Interface = actor (FPLLedger.CANISTER_ID);
    
    private func isDataAdmin(principalId: Text) : Bool {
      return Option.isSome(Array.find<T.PrincipalId>(Environment.ADMIN_PRINCIPALS, func(dataAdmin: T.PrincipalId) : Bool{
        dataAdmin == principalId;
      }));
    };

    private func isManagerCanister(principalId: Text) : Bool {
      let managerCanisterIds = userManager.getUniqueManagerCanisterIds();
      return Option.isSome(Array.find<T.PrincipalId>(managerCanisterIds, func(dataAdmin: T.PrincipalId) : Bool{
        dataAdmin == principalId;
      }));
    }; 

    //Manager calls

    public shared ({ caller }) func getProfile() : async Result.Result<DTOs.ProfileDTO, T.Error> {
      assert not Principal.isAnonymous(caller);
      return await userManager.getProfile({ principalId = Principal.toText(caller) });
    };

    public shared ({ caller }) func getCurrentTeam() : async Result.Result<DTOs.PickTeamDTO, T.Error> {
      assert not Principal.isAnonymous(caller);
      return await userManager.getCurrentTeam(Principal.toText(caller));
    };

    public shared func getManager(dto: Requests.RequestManagerDTO) : async Result.Result<DTOs.ManagerDTO, T.Error> {
      let weeklyLeaderboardEntry = await leaderboardManager.getWeeklyLeaderboardEntry(dto.managerId, dto.seasonId, dto.gameweek);
      let monthlyLeaderboardEntry = await leaderboardManager.getMonthlyLeaderboardEntry(dto.managerId, dto.seasonId, dto.month, dto.clubId);
      let seasonLeaderboardEntry = await leaderboardManager.getSeasonLeaderboardEntry(dto.managerId, dto.seasonId);

      return await userManager.getManager(dto, weeklyLeaderboardEntry, monthlyLeaderboardEntry, seasonLeaderboardEntry);
    };

    public shared func getFantasyTeamSnapshot(dto: DTOs.GetFantasyTeamSnapshotDTO) : async Result.Result<DTOs.FantasyTeamSnapshotDTO, T.Error> {
      return await userManager.getFantasyTeamSnapshot(dto);
    };

    //Leaderboard calls:

    public shared func getWeeklyLeaderboard(dto: DTOs.GetWeeklyLeaderboardDTO) : async Result.Result<DTOs.WeeklyLeaderboardDTO, T.Error> {
      return await leaderboardManager.getWeeklyLeaderboard(dto);
    };

    public shared func getMonthlyLeaderboard(dto: DTOs.GetMonthlyLeaderboardDTO) : async Result.Result<DTOs.MonthlyLeaderboardDTO, T.Error> {
      return await leaderboardManager.getMonthlyLeaderboard(dto);
    };

    public shared func getSeasonLeaderboard(dto: DTOs.GetSeasonLeaderboardDTO) : async Result.Result<DTOs.SeasonLeaderboardDTO, T.Error> {
      return await leaderboardManager.getSeasonLeaderboard(dto);
    };


    //Query functions:

    public shared composite query func getDataHashes() : async Result.Result<[DTOs.DataHashDTO], T.Error> {
      return seasonManager.getDataHashes();
    };

    public shared query func getSystemState() : async Result.Result<DTOs.SystemStateDTO, T.Error> {
      return seasonManager.getSystemState();
    };

    public shared composite query func getLeagues() : async Result.Result<[DTOs.FootballLeagueDTO], T.Error> {
      return await dataManager.getLeagues();
    };

    public shared composite query func getClubs() : async Result.Result<[DTOs.ClubDTO], T.Error> {
      return await dataManager.getClubs(Environment.LEAGUE_ID);
    };

    public shared composite query func getFixtures(dto: Requests.RequestFixturesDTO) : async Result.Result<[DTOs.FixtureDTO], T.Error> {
      return await dataManager.getFixtures(Environment.LEAGUE_ID, dto);
    };

    public shared composite query func getSeasons() : async Result.Result<[DTOs.SeasonDTO], T.Error> {
      return await dataManager.getSeasons(Environment.LEAGUE_ID);
    };

    public shared composite query func getPostponedFixtures() : async Result.Result<[DTOs.FixtureDTO], T.Error> {
      return #err(#NotFound);
      //return await dataManager.getPostponedFixtures(Environment.LEAGUE_ID);
    };

    public shared query func getTotalManagers() : async Result.Result<Nat, T.Error> {
      return userManager.getTotalManagers();
    };

    public shared composite query func getPlayers() : async Result.Result<[DTOs.PlayerDTO], T.Error> {
      Debug.print("getting players");

      let systemStateResult = await getSystemState();
      switch(systemStateResult){
        case (#ok systemState){
          return await dataManager.getPlayers(Environment.LEAGUE_ID, { seasonId = systemState.pickTeamSeasonId });
        };  
        case (#err error){
          return #err(error);
        }
      };
    };

    public shared composite query ( {caller} ) func getSnapshotPlayers(dto: Requests.GetSnapshotPlayers) : async [DTOs.PlayerDTO] {
      assert isManagerCanister(Principal.toText(caller));
      return await dataManager.getSnapshotPlayers(dto);
    };

    public shared composite query func getLoanedPlayers(dto: DTOs.ClubFilterDTO) : async Result.Result<[DTOs.PlayerDTO], T.Error> {
      return await dataManager.getLoanedPlayers(Environment.LEAGUE_ID, dto);
    };

    public shared composite query func getRetiredPlayers(dto: DTOs.ClubFilterDTO) : async Result.Result<[DTOs.PlayerDTO], T.Error> {
      return await dataManager.getRetiredPlayers(Environment.LEAGUE_ID, dto);
    };

    public shared composite query func getPlayerDetailsForGameweek(dto: DTOs.GameweekFiltersDTO) : async Result.Result<[DTOs.PlayerPointsDTO], T.Error> {
      return await dataManager.getPlayerDetailsForGameweek(Environment.LEAGUE_ID, dto);
    };

    public shared composite query func getPlayersMap(dto: DTOs.GameweekFiltersDTO) : async Result.Result<[(Nat16, DTOs.PlayerScoreDTO)], T.Error> {
      return await dataManager.getPlayersMap(Environment.LEAGUE_ID, dto);
    };

    public shared composite query func getPlayerDetails(dto: DTOs.GetPlayerDetailsDTO) : async Result.Result<DTOs.PlayerDetailDTO, T.Error> {
      return await dataManager.getPlayerDetails(Environment.LEAGUE_ID, dto);
    };

    public shared query func getCountries() : async Result.Result<[DTOs.CountryDTO], T.Error> {
      return #ok(Countries.countries);
    };

    public shared query ({ caller }) func isUsernameValid(dto: DTOs.UsernameFilterDTO) : async Bool {
      assert not Principal.isAnonymous(caller);
      let usernameValid = userManager.isUsernameValid(dto.username);
      let usernameTaken = userManager.isUsernameTaken(dto.username, Principal.toText(caller));
      return usernameValid and not usernameTaken;
    };

    //Update functions:

    public shared ({ caller }) func updateUsername(dto: DTOs.UpdateUsernameDTO) : async Result.Result<(), T.Error> {
      assert not Principal.isAnonymous(caller);
      let principalId = Principal.toText(caller);

      let systemStateResult = seasonManager.getSystemState();
      switch(systemStateResult){
        case (#ok systemState){       
          return await userManager.updateUsername(principalId, dto.username, systemState);   
        };
        case (#err error){
          return #err(error);
        }
      }
    };

    public shared ({ caller }) func updateFavouriteClub(dto: DTOs.UpdateFavouriteClubDTO) : async Result.Result<(), T.Error> {
      assert not Principal.isAnonymous(caller);
      let principalId = Principal.toText(caller);
      
      let systemStateResult = seasonManager.getSystemState();
      switch(systemStateResult){
        case (#ok systemState){       

          let clubsResult = await dataManager.getVerifiedClubs(Environment.LEAGUE_ID);
          switch(clubsResult){
            case (#ok clubs){
              return await userManager.updateFavouriteClub(principalId, dto.favouriteClubId, systemState, clubs);
            };
            case (#err error){
              return #err(error);
            }
          };
        };
        case (#err error){
          return #err(error);
        }
      };
    };

    public shared ({ caller }) func updateProfilePicture(dto: DTOs.UpdateProfilePictureDTO) : async Result.Result<(), T.Error> {
      assert not Principal.isAnonymous(caller);
      let principalId = Principal.toText(caller);

      let systemStateResult = seasonManager.getSystemState();
      switch(systemStateResult){
        case (#ok systemState){       

          return await userManager.updateProfilePicture(principalId, {
            extension = dto.extension;
            managerId = principalId;
            profilePicture = dto.profilePicture;
          }, systemState);
        };
        case (#err error){
          return #err(error);
        }
      };      
    };

    public shared ({ caller }) func saveFantasyTeam(fantasyTeam : DTOs.UpdateTeamSelectionDTO) : async Result.Result<(), T.Error> {
      assert not Principal.isAnonymous(caller);
      let principalId = Principal.toText(caller);

      let systemStateResult = seasonManager.getSystemState();
      switch(systemStateResult){
        case (#ok systemState){       
          assert not systemState.onHold;
      
          let playersResult = await dataManager.getVerifiedPlayers(Environment.LEAGUE_ID, { seasonId = systemState.pickTeamSeasonId });
          switch(playersResult){
            case (#ok players){
              return await userManager.saveFantasyTeam(principalId, fantasyTeam, systemState, players);
            };
            case (#err error){
              return #err(error);
            }
          }
        };
        case (#err error){
          return #err(error);
        }
      };
    };

    //Governance canister validation and execution functions:

    public shared query ({ caller }) func validateRevaluePlayerUp(revaluePlayerUpDTO : DTOs.RevaluePlayerUpDTO) : async T.RustResult {
      //assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      return #Err("Governance on hold due to network issues");
      
      //Todo (DFINITY) when functionality available: Make cross subnet call to governance canister to see if proposal exists

      //return seasonManager.validateRevaluePlayerUp(revaluePlayerUpDTO);
    };

    public shared ({ caller }) func executeRevaluePlayerUp(revaluePlayerUpDTO : DTOs.RevaluePlayerUpDTO) : async () {
      //assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      assert isDataAdmin(Principal.toText(caller));

      let systemStateResult = await getSystemState();
      switch(systemStateResult){
        case (#ok systemState){
          switch(await dataManager.validateRevaluePlayerUp(Environment.LEAGUE_ID, revaluePlayerUpDTO)){
            case (#ok success){
              let _ = await dataManager.executeRevaluePlayerUp(Environment.LEAGUE_ID, revaluePlayerUpDTO);
              await seasonManager.updateDataHash("players");
            };
            case _ {}
          };
        };
        case (#err error){

        }
      };
    };

    public shared query ({ caller }) func validateRevaluePlayerDown(revaluePlayerDownDTO : DTOs.RevaluePlayerDownDTO) : async T.RustResult {
      //assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      return #Err("Governance on hold due to network issues");
      //return seasonManager.validateRevaluePlayerDown(revaluePlayerDownDTO);
    };

    public shared ({ caller }) func executeRevaluePlayerDown(revaluePlayerDownDTO : DTOs.RevaluePlayerDownDTO) : async () {
      //assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      assert isDataAdmin(Principal.toText(caller));
      switch(await dataManager.validateRevaluePlayerDown(Environment.LEAGUE_ID, revaluePlayerDownDTO)){
        case (#ok success){
          let _ = await dataManager.executeRevaluePlayerDown(Environment.LEAGUE_ID, revaluePlayerDownDTO);
          await seasonManager.updateDataHash("players");
        };
        case _ {}
      };
    };

    public shared query ({ caller }) func validateSubmitFixtureData(submitFixtureData : DTOs.SubmitFixtureDataDTO) : async T.RustResult {
      Debug.print(debug_show submitFixtureData);
      //assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      return #Err("Governance on hold due to network issues");
      //return seasonManager.validateSubmitFixtureData(submitFixtureData);
    };

    public shared ({ caller }) func executeSubmitFixtureData(submitFixtureData : DTOs.SubmitFixtureDataDTO) : async () {
      //assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      assert isDataAdmin(Principal.toText(caller));
      let systemStateResult = await getSystemState();
      switch(systemStateResult){
        case (#ok systemState){
      
          switch(await dataManager.validateSubmitFixtureData(Environment.LEAGUE_ID, submitFixtureData)){
            case (#ok _){
              let _ = await dataManager.executeSubmitFixtureData(Environment.LEAGUE_ID, systemState.calculationSeasonId, submitFixtureData);

              //TODO (PLAYERS): When calculating score get players built friom all players who appeared in the gameweek
              await userManager.calculateFantasyTeamScores(
                Environment.LEAGUE_ID,
                systemState.calculationSeasonId, submitFixtureData.gameweek, submitFixtureData.month);
                let clubsResult = await dataManager.getVerifiedClubs(Environment.LEAGUE_ID);
                switch(clubsResult){
                  case (#ok clubs){
                    let clubIds = Array.map<DTOs.ClubDTO, T.ClubId>(clubs, func(club: DTOs.ClubDTO){
                      return club.id;
                });
                    await leaderboardManager.calculateLeaderboards(systemState.calculationSeasonId, submitFixtureData.gameweek, submitFixtureData.month, userManager.getUniqueManagerCanisterIds(), clubIds);
                  };
                  case (#err _){}
                };
              
              if(await dataManager.checkGameweekComplete(systemState.calculationSeasonId, submitFixtureData.gameweek)){
                await userManager.resetWeeklyTransfers();
                await leaderboardManager.payWeeklyRewards();
                await seasonManager.incrementCalculationGameweek();
              };

              if(await dataManager.checkMonthComplete(systemState.calculationSeasonId, submitFixtureData.month, submitFixtureData.gameweek)){
                await userManager.resetBonusesAvailable();
                await leaderboardManager.payMonthlyRewards();
                await seasonManager.incrementCalculationMonth();
              };

              if(await dataManager.checkSeasonComplete(systemState.calculationSeasonId)){
                await userManager.resetFantasyTeams();
                await leaderboardManager.paySeasonRewards();
                await seasonManager.incrementCalculationSeason();
                
                /*  //TODO (PAYOUT)
                seasonManager.createNewSeason(systemState);
                  
                let currentSeasonId = seasonComposite.getStableNextSeasonId();
                await calculateRewardPool(currentSeasonId);
                */

                await setTransferWindowTimers();
              };
              
              await seasonManager.updateDataHash("leagues");
              await seasonManager.updateDataHash("seasons");
              await seasonManager.updateDataHash("players");
              await seasonManager.updateDataHash("player_events");
              await seasonManager.updateDataHash("fixtures");
              await seasonManager.updateDataHash("weekly_leaderboard");
              await seasonManager.updateDataHash("monthly_leaderboards");
              await seasonManager.updateDataHash("season_leaderboard");
              await seasonManager.updateDataHash("system_state");
              
            };
            case _ {}
          };

        };
        case (#err error){}
      };
    };



    private func setTransferWindowTimers() : async () {
      let jan1Date = Utilities.nextUnixTimeForDayOfYear(1);
      let jan31Date = Utilities.nextUnixTimeForDayOfYear(31);

      let transferWindowStartDate : Timer.Duration = #nanoseconds(Int.abs(jan1Date - Time.now()));
      let transferWindowEndDate : Timer.Duration = #nanoseconds(Int.abs(jan31Date - Time.now()));

      await setAndBackupTimer(transferWindowStartDate, "transferWindowStart");
      await setAndBackupTimer(transferWindowEndDate, "transferWindowEnd");
    };

    public shared query ({ caller }) func validateAddInitialFixtures(addInitialFixturesDTO : DTOs.AddInitialFixturesDTO) : async T.RustResult {
      //assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID; 
      return #Err("Governance on hold due to network issues");   
      //return seasonManager.validateAddInitialFixtures(addInitialFixturesDTO);
    };

    public shared ({ caller }) func executeAddInitialFixtures(addInitialFixturesDTO : DTOs.AddInitialFixturesDTO) : async () {
      //assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      assert isDataAdmin(Principal.toText(caller));

      let systemStateResult = await getSystemState();
      switch(systemStateResult){
        case (#ok systemState){

          switch(await dataManager.validateAddInitialFixtures(Environment.LEAGUE_ID, addInitialFixturesDTO)){
            case (#ok _){
              let _ = await dataManager.executeAddInitialFixtures(Environment.LEAGUE_ID, addInitialFixturesDTO);
              let seasonFixtures = await dataManager.getVerifiedFixtures(Environment.LEAGUE_ID, { seasonId = systemState.calculationSeasonId});
              switch(seasonFixtures){
                case (#ok fixtures){

                  let sortedFixtures = Array.sort<DTOs.FixtureDTO>(
                    fixtures,
                    func(a : DTOs.FixtureDTO, b : DTOs.FixtureDTO) : Order.Order {
                      if (a.kickOff < b.kickOff) { return #less };
                      if (a.kickOff == b.kickOff) { return #equal };
                      return #greater;
                    },
                  );
                  if(Array.size(sortedFixtures) <= 0){
                    return;
                  };
                  await seasonManager.updateInitialSystemState(sortedFixtures[0]);
                };
                case (#err _){

                }
              };

              await seasonManager.updateDataHash("fixtures");
            };
            case _ {}
          };
        };
        case (#err error){}
      };
    };

    public shared query ({ caller }) func validateMoveFixture(moveFixtureDTO : DTOs.MoveFixtureDTO) : async T.RustResult {
      //assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      return #Err("Governance on hold due to network issues");
      //return seasonManager.validateMoveFixture(moveFixtureDTO);
    };

    public shared ({ caller }) func executeMoveFixture(moveFixtureDTO : DTOs.MoveFixtureDTO) : async () {
      //assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      assert isDataAdmin(Principal.toText(caller));
      switch(await dataManager.validateMoveFixture(Environment.LEAGUE_ID, moveFixtureDTO)){
        case (#ok success){
          let _ = await dataManager.executeMoveFixture(Environment.LEAGUE_ID, moveFixtureDTO);
          await seasonManager.updateDataHash("fixtures");
        };
        case _ {}
      };
    };

    public shared query ({ caller }) func validatePostponeFixture(postponeFixtureDTO : DTOs.PostponeFixtureDTO) : async T.RustResult {
      //assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      return #Err("Governance on hold due to network issues");
      //return seasonManager.validatePostponeFixture(postponeFixtureDTO);
    };

    public shared ({ caller }) func executePostponeFixture(postponeFixtureDTO : DTOs.PostponeFixtureDTO) : async () {
      //assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      assert isDataAdmin(Principal.toText(caller));
      switch(await dataManager.validatePostponeFixture(Environment.LEAGUE_ID, postponeFixtureDTO)){
        case (#ok success){
          let _ =  await dataManager.executePostponeFixture(Environment.LEAGUE_ID, postponeFixtureDTO);
          await seasonManager.updateDataHash("fixtures");
        };
        case _ {}
      };
    };

    public shared query ({ caller }) func validateRescheduleFixture(rescheduleFixtureDTO : DTOs.RescheduleFixtureDTO) : async T.RustResult {
      //assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      return #Err("Governance on hold due to network issues");
      //return await seasonManager.validateRescheduleFixture(rescheduleFixtureDTO);
    };

    public shared ({ caller }) func executeRescheduleFixture(rescheduleFixtureDTO : DTOs.RescheduleFixtureDTO) : async () {
      //assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      assert isDataAdmin(Principal.toText(caller));
      switch(await dataManager.validateRescheduleFixture(Environment.LEAGUE_ID, rescheduleFixtureDTO)){
        case (#ok success){
          let _ = await dataManager.executeRescheduleFixture(Environment.LEAGUE_ID, rescheduleFixtureDTO);
          await seasonManager.updateDataHash("fixtures");
        };
        case _ {}
      };
    };

    public shared query ({ caller }) func validateLoanPlayer(loanPlayerDTO : DTOs.LoanPlayerDTO) : async T.RustResult {
      //assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      return #Err("Governance on hold due to network issues");
      //return seasonManager.validateLoanPlayer(loanPlayerDTO);
    };

    public shared ({ caller }) func executeLoanPlayer(loanPlayerDTO : DTOs.LoanPlayerDTO) : async () {
      //assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      assert isDataAdmin(Principal.toText(caller));
      switch(await dataManager.validateLoanPlayer(Environment.LEAGUE_ID, loanPlayerDTO)){
        case (#ok success){
          let _ = await dataManager.executeLoanPlayer(Environment.LEAGUE_ID, loanPlayerDTO);
          await seasonManager.updateDataHash("players");
        };
        case _ {}
      };
    };

    public shared query ({ caller }) func validateTransferPlayer(transferPlayerDTO : DTOs.TransferPlayerDTO) : async T.RustResult {
      //assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      return #Err("Governance on hold due to network issues");
      //return seasonManager.validateTransferPlayer(transferPlayerDTO);
    };

    public shared ({ caller }) func executeTransferPlayer(transferPlayerDTO : DTOs.TransferPlayerDTO) : async () {
      //assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      assert isDataAdmin(Principal.toText(caller));
      switch(await dataManager.validateTransferPlayer(Environment.LEAGUE_ID, transferPlayerDTO)){
        case (#ok success){
          let _ = await dataManager.executeTransferPlayer(Environment.LEAGUE_ID, transferPlayerDTO);
          await seasonManager.updateDataHash("players");
        };
        case _ {}
      };
    };

    public shared query ({ caller }) func validateRecallPlayer(recallPlayerDTO : DTOs.RecallPlayerDTO) : async T.RustResult {
      //assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      return #Err("Governance on hold due to network issues");
      //return seasonManager.validateRecallPlayer(recallPlayerDTO);
    };

    public shared ({ caller }) func executeRecallPlayer(recallPlayerDTO : DTOs.RecallPlayerDTO) : async () {
      //assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      assert isDataAdmin(Principal.toText(caller));
      switch(await dataManager.validateRecallPlayer(Environment.LEAGUE_ID, recallPlayerDTO)){
        case (#ok success){
          let _ = await dataManager.executeRecallPlayer(Environment.LEAGUE_ID, recallPlayerDTO);
          await seasonManager.updateDataHash("players");
        };
        case _ {}
      };
    };

    public shared query ({ caller }) func validateCreatePlayer(createPlayerDTO : DTOs.CreatePlayerDTO) : async T.RustResult {
      //assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      return #Err("Governance on hold due to network issues");
      //return seasonManager.validateCreatePlayer(createPlayerDTO);
    };

    public shared ({ caller }) func executeCreatePlayer(createPlayerDTO : DTOs.CreatePlayerDTO) : async () {
      //assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      assert isDataAdmin(Principal.toText(caller));
      switch(await dataManager.validateCreatePlayer(Environment.LEAGUE_ID, createPlayerDTO)){
        case (#ok success){
          let _ = await dataManager.executeCreatePlayer(Environment.LEAGUE_ID, createPlayerDTO);
          await seasonManager.updateDataHash("players");
        };
        case _ {}
      };
    };

    public shared query ({ caller }) func validateUpdatePlayer(updatePlayerDTO : DTOs.UpdatePlayerDTO) : async T.RustResult {
      //assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      return #Err("Governance on hold due to network issues");
      //return seasonManager.validateUpdatePlayer(updatePlayerDTO);
    };

    public shared ({ caller }) func executeUpdatePlayer(updatePlayerDTO : DTOs.UpdatePlayerDTO) : async () {
      //assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      assert isDataAdmin(Principal.toText(caller));
      switch(await dataManager.validateUpdatePlayer(Environment.LEAGUE_ID, updatePlayerDTO)){
        case (#ok success){
          let _ = await dataManager.executeUpdatePlayer(Environment.LEAGUE_ID, updatePlayerDTO);
          await seasonManager.updateDataHash("players");
        };
        case _ {}
      };
    };

    public shared query ({ caller }) func validateSetPlayerInjury(setPlayerInjuryDTO : DTOs.SetPlayerInjuryDTO) : async T.RustResult {
      //assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      return #Err("Governance on hold due to network issues");
      //return seasonManager.validateSetPlayerInjury(setPlayerInjuryDTO);
    };

    public shared ({ caller }) func executeSetPlayerInjury(setPlayerInjuryDTO : DTOs.SetPlayerInjuryDTO) : async () {
      //assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      assert isDataAdmin(Principal.toText(caller));
      switch(await dataManager.validateSetPlayerInjury(Environment.LEAGUE_ID, setPlayerInjuryDTO)){
        case (#ok success){
          let _ = await dataManager.executeSetPlayerInjury(Environment.LEAGUE_ID, setPlayerInjuryDTO);
          await seasonManager.updateDataHash("players");
        };
        case _ {}
      };
    };

    public shared query ({ caller }) func validateRetirePlayer(retirePlayerDTO : DTOs.RetirePlayerDTO) : async T.RustResult {
      //assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      return #Err("Governance on hold due to network issues");
      //return seasonManager.validateRetirePlayer(retirePlayerDTO);
    };

    public shared ({ caller }) func executeRetirePlayer(retirePlayerDTO : DTOs.RetirePlayerDTO) : async () {
      //assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      assert isDataAdmin(Principal.toText(caller));
      switch(await dataManager.validateRetirePlayer(Environment.LEAGUE_ID, retirePlayerDTO)){
        case (#ok success){
          let _ = await dataManager.executeRetirePlayer(Environment.LEAGUE_ID, retirePlayerDTO);
          await seasonManager.updateDataHash("players");
        };
        case _ {}
      };
    };

    public shared query ({ caller }) func validateUnretirePlayer(unretirePlayerDTO : DTOs.UnretirePlayerDTO) : async T.RustResult {
      //assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      return #Err("Governance on hold due to network issues");
      //return seasonManager.validateUnretirePlayer(unretirePlayerDTO);
    };

    public shared ({ caller }) func executeUnretirePlayer(unretirePlayerDTO : DTOs.UnretirePlayerDTO) : async () {
      //assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      assert isDataAdmin(Principal.toText(caller));
      switch(await dataManager.validateUnretirePlayer(Environment.LEAGUE_ID, unretirePlayerDTO)){
        case (#ok success){
          let _ = await dataManager.executeUnretirePlayer(Environment.LEAGUE_ID, unretirePlayerDTO);
          await seasonManager.updateDataHash("players");
        };
        case _ {}
      };
    };

    public shared query ({ caller }) func validatePromoteNewClub(promoteNewClubDTO : DTOs.PromoteNewClubDTO) : async T.RustResult {
      //assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      return #Err("Governance on hold due to network issues");
      //return seasonManager.validatePromoteNewClub(promoteNewClubDTO);
    };

    public shared ({ caller }) func executePromoteNewClub(promoteNewClubDTO : DTOs.PromoteNewClubDTO) : async () {
      //assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      assert isDataAdmin(Principal.toText(caller));
      switch(await dataManager.validatePromoteNewClub(Environment.LEAGUE_ID, promoteNewClubDTO)){
        case (#ok success){
          let _ = await dataManager.executePromoteNewClub(Environment.LEAGUE_ID, promoteNewClubDTO);
          await seasonManager.updateDataHash("clubs");
        };
        case _ {}
      };
    };

    public shared query ({ caller }) func validateUpdateClub(updateClubDTO : DTOs.UpdateClubDTO) : async T.RustResult {
      //assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      return #Err("Governance on hold due to network issues");
      //return seasonManager.validateUpdateClub(updateClubDTO);
    };

    public shared ({ caller }) func executeUpdateClub(updateClubDTO : DTOs.UpdateClubDTO) : async () {
      //assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      assert isDataAdmin(Principal.toText(caller));
      switch(await dataManager.validateUpdateClub(Environment.LEAGUE_ID, updateClubDTO)){
        case (#ok success){
          let _ = await dataManager.executeUpdateClub(Environment.LEAGUE_ID, updateClubDTO);
          await seasonManager.updateDataHash("clubs");
        };
        case _ {}
      };
    };

    //system callback functions

    private func cyclesCheckCallback() : async () {
      //await checkCanisterCycles(); TODO
    };

    public shared ({ caller }) func searchUsername(dto: DTOs.UsernameFilterDTO) : async Result.Result<DTOs.ManagerDTO, T.Error> {
      assert not Principal.isAnonymous(caller);
      return await userManager.getManagerByUsername(dto.username);
    };

    public shared ({ caller }) func getRewardPool(dto: DTOs.GetRewardPoolDTO) : async Result.Result<DTOs.GetRewardPoolDTO, T.Error> {
      assert not Principal.isAnonymous(caller);
      let rewardPool = leaderboardManager.getRewardPool(dto.seasonId);
      switch(rewardPool){
        case (null){
          return #err(#NotFound);
        };
        case (?foundRewardPool){
          return #ok({rewardPool = foundRewardPool; seasonId = dto.seasonId});
        }
      };
    };

    public shared ({ caller }) func getTopups(dto: DTOs.GetTopupsDTO) : async Result.Result<DTOs.GetTopupsDTO, T.Error> {
      assert not Principal.isAnonymous(caller);
      
      let topups = cyclesDispenser.getStableTopups();
      let droppedEntries = List.drop<T.CanisterTopup>(List.fromArray(topups), dto.offset);
      let paginatedEntries = List.take<T.CanisterTopup>(droppedEntries, dto.limit);

      return #ok({
        entries = List.toArray<DTOs.TopupDTO>(List.map<T.CanisterTopup, DTOs.TopupDTO>(paginatedEntries, func(entry: T.CanisterTopup) : DTOs.TopupDTO{
          return {
            canisterId = entry.canisterId; toppedUpOn = entry.topupTime; topupAmount = entry.cyclesAmount;
          }
        }));
        limit = dto.limit;
        offset = dto.offset;
        totalEntries = Array.size(topups);
      });
    };

    //stable variables
    private stable var alreadyInitialisedData = false;
    private stable var timers : [T.TimerInfo] = [];

    //stable variables from managers

    //Leaderboard Manager stable variables
    private stable var stable_leaderboard_canisters: [T.LeaderboardCanister] = [];
    
    //Reward Manager stable variables
    private stable var stable_reward_pools : [(T.SeasonId, T.RewardPool)] = [];
    private stable var stable_team_value_leaderboards : [(T.SeasonId, T.TeamValueLeaderboard)] = [];
    private stable var stable_weekly_rewards : [T.WeeklyRewards] = [];
    private stable var stable_monthly_rewards : [T.MonthlyRewards] = [];
    private stable var stable_season_rewards : [T.SeasonRewards] = [];
    private stable var stable_most_valuable_team_rewards : [T.RewardsList] = [];
    private stable var stable_high_scoring_player_rewards : [T.RewardsList] = [];
    private stable var stable_weekly_all_time_high_scores : [T.HighScoreRecord] = [];
    private stable var stable_monthly_all_time_high_scores : [T.HighScoreRecord] = [];
    private stable var stable_season_all_time_high_scores : [T.HighScoreRecord] = [];
    private stable var stable_weekly_ath_prize_pool : Nat64 = 0;
    private stable var stable_monthly_ath_prize_pool : Nat64 = 0;
    private stable var stable_season_ath_prize_pool : Nat64 = 0;
    private stable var stable_active_leaderbord_canister_id : T.CanisterId = "";

    //Season Manager stable variables
    private stable var stable_system_state : T.SystemState = {
      calculationGameweek = 7;
      calculationMonth = 10;
      calculationSeasonId = 1;
      onHold = false;
      pickTeamGameweek = 7;
      pickTeamMonth = 10;
      pickTeamSeasonId = 1;
      seasonActive = true;
      transferWindowActive = false;
      version = "2.0.0";
    };
    private stable var stable_data_hashes : [T.DataHash] = [];

    //User Manager stable variables
    private stable var stable_manager_canister_ids : [(T.PrincipalId, T.CanisterId)] = [];
    private stable var stable_usernames: [(T.PrincipalId, Text)] = [];
    private stable var stable_unique_manager_canister_ids : [T.CanisterId] = [];
    private stable var stable_total_managers : Nat = 0;
    private stable var stable_active_manager_canister_id : T.CanisterId = "";   

    system func preupgrade() {

      stable_leaderboard_canisters := leaderboardManager.getStableLeaderboardCanisters();
      
      stable_reward_pools := leaderboardManager.getStableRewardPools();
      stable_team_value_leaderboards := leaderboardManager.getStableTeamValueLeaderboards();
      stable_weekly_rewards := leaderboardManager.getStableWeeklyRewards();
      stable_monthly_rewards := leaderboardManager.getStableMonthlyRewards();
      stable_season_rewards := leaderboardManager.getStableSeasonRewards();
      stable_most_valuable_team_rewards := leaderboardManager.getStableMostValuableTeamRewards();
      stable_high_scoring_player_rewards := leaderboardManager.getStableHighestScoringPlayerRewards();
      
      stable_weekly_all_time_high_scores := leaderboardManager.getStableWeeklyAllTimeHighScores();
      stable_monthly_all_time_high_scores := leaderboardManager.getStableMonthlyAllTimeHighScores();
      stable_season_all_time_high_scores := leaderboardManager.getStableSeasonAllTimeHighScores();
      stable_weekly_ath_prize_pool := leaderboardManager.getStableWeeklyATHPrizePool();
      stable_monthly_ath_prize_pool := leaderboardManager.getStableMonthlyATHPrizePool();
      stable_season_ath_prize_pool := leaderboardManager.getStableSeasonATHPrizePool();

      stable_active_leaderbord_canister_id := leaderboardManager.getStableActiveCanisterId();

      stable_system_state := seasonManager.getStableSystemState();
      stable_data_hashes := seasonManager.getStableDataHashes();

      stable_manager_canister_ids := userManager.getStableManagerCanisterIds();
      stable_usernames := userManager.getStableUsernames();
      stable_unique_manager_canister_ids := userManager.getStableUniqueManagerCanisterIds();
      stable_total_managers := userManager.getStableTotalManagers();
      stable_active_manager_canister_id := userManager.getStableActiveManagerCanisterId();   

    };

    system func postupgrade() {
      leaderboardManager.setStableWeeklyLeaderboardCanisters(stable_leaderboard_canisters);
      
      leaderboardManager.setStableRewardPools(stable_reward_pools);
      leaderboardManager.setStableTeamValueLeaderboards(stable_team_value_leaderboards);
      leaderboardManager.setStableWeeklyRewards(stable_weekly_rewards);
      leaderboardManager.setStableMonthlyRewards(stable_monthly_rewards);
      leaderboardManager.setStableSeasonRewards(stable_season_rewards);
      leaderboardManager.setStableMostValuableTeamRewards(stable_most_valuable_team_rewards);
      leaderboardManager.setStableHighestScoringPlayerRewards(stable_high_scoring_player_rewards);
      
      leaderboardManager.setStableWeeklyAllTimeHighScores(stable_weekly_all_time_high_scores);
      leaderboardManager.setStableMonthlyAllTimeHighScores(stable_monthly_all_time_high_scores);
      leaderboardManager.setStableSeasonAllTimeHighScores(stable_season_all_time_high_scores);
      leaderboardManager.setStableWeeklyATHPrizePool(stable_weekly_ath_prize_pool);
      leaderboardManager.setStableMonthlyATHPrizePool(stable_monthly_ath_prize_pool);
      leaderboardManager.setStableSeasonATHPrizePool(stable_season_ath_prize_pool);
      leaderboardManager.setStableActiveCanisterId(stable_active_leaderbord_canister_id);

      seasonManager.setStableSystemState(stable_system_state);
      seasonManager.setStableDataHashes(stable_data_hashes);

      userManager.setStableManagerCanisterIds(stable_manager_canister_ids);
      userManager.setStableUsernames(stable_usernames);
      userManager.setStableUniqueManagerCanisterIds(stable_unique_manager_canister_ids);
      userManager.setStableTotalManagers(stable_total_managers);
      userManager.setStableActiveManagerCanisterId(stable_active_manager_canister_id);   

      ignore Timer.setTimer<system>(#nanoseconds(Int.abs(1)), postUpgradeCallback); 
    };

    private func postUpgradeCallback() : async (){

      //TODO (GO LIVE)
      //set system state
      //await checkCanisterCycles(); 
      //await setSystemTimers();

      await seasonManager.updateDataHash("leagues");
      await seasonManager.updateDataHash("clubs");
      await seasonManager.updateDataHash("fixtures");
      await seasonManager.updateDataHash("weekly_leaderboard");
      await seasonManager.updateDataHash("monthly_leaderboards");
      await seasonManager.updateDataHash("season_leaderboard");
      await seasonManager.updateDataHash("players");
      await seasonManager.updateDataHash("player_events");
      await seasonManager.updateDataHash("countries");
      await seasonManager.updateDataHash("system_state");
    };

    //Timer Functions

    private func setSystemTimers() : async (){
      
      let currentTime = Time.now();
      for (timerInfo in Iter.fromArray(timers)) {
        let remainingDuration = timerInfo.triggerTime - currentTime;

        if (remainingDuration > 0) {
          let duration : Timer.Duration = #nanoseconds(Int.abs(remainingDuration));

          switch (timerInfo.callbackName) {
            case "gameweekBeginExpired" {
              ignore Timer.setTimer<system>(duration, gameweekBeginExpiredCallback);
            };
            case "gameKickOffExpired" {
              ignore Timer.setTimer<system>(duration, gameKickOffExpiredCallback);
            };
            case "gameCompletedExpired" {
              ignore Timer.setTimer<system>(duration, gameCompletedExpiredCallback);
            };
            case "transferWindowStart" {
              ignore Timer.setTimer<system>(duration, transferWindowStartCallback);
            };
            case "transferWindowEnd" {
              ignore Timer.setTimer<system>(duration, transferWindowEndCallback);
            };
            case _ {};
          };
        };
      };
    };

    private func gameweekBeginExpiredCallback() : async () {
      await seasonManager.setNextPickTeamGameweek();
      removeExpiredTimers();
      let systemStateResult = seasonManager.getSystemState();
      switch(systemStateResult){
        case (#ok systemState){
          await setGameweekTimers(systemState.pickTeamSeasonId, systemState.pickTeamGameweek);     
          await userManager.snapshotFantasyTeams(systemState.calculationSeasonId, systemState.calculationGameweek, systemState.calculationMonth);
          await seasonManager.updateDataHash("system_state");
        };
        case (#err _){}
      };      
    };

    public func setGameweekTimers(seasonId: T.SeasonId, gameweek: T.GameweekNumber) : async () {
      let fixturesResult = await dataManager.getVerifiedFixtures(Environment.LEAGUE_ID, {seasonId = seasonId});
      switch(fixturesResult){
        case (#ok fixtures){
          let filteredFilters = Array.filter<DTOs.FixtureDTO>(
            fixtures,
            func(fixture : DTOs.FixtureDTO) : Bool {
              return fixture.gameweek == gameweek;
            },
          );

          let sortedArray = Array.sort(
            filteredFilters,
            func(a : DTOs.FixtureDTO, b : DTOs.FixtureDTO) : Order.Order {
              if (a.kickOff < b.kickOff) { return #less };
              if (a.kickOff == b.kickOff) { return #equal };
              return #greater;
            },
          );

          let firstFixture = sortedArray[0];
          let durationToHourBeforeFirstFixture : Timer.Duration = #nanoseconds(Int.abs(firstFixture.kickOff - Utilities.getHour() - Time.now()));
          await setAndBackupTimer(durationToHourBeforeFirstFixture, "gameweekBeginExpired");
          
          await setKickOffTimers(filteredFilters);  
        };
        case (#err _){ }
      }
    };


    private func setKickOffTimers(gameweekFixtures : [DTOs.FixtureDTO]) : async () {
      for (fixture in Iter.fromArray(gameweekFixtures)) {
        let durationToKickOff : Timer.Duration = #nanoseconds(Int.abs(fixture.kickOff - Time.now()));
        await setAndBackupTimer(durationToKickOff, "gameKickOffExpired");

        let durationToEndOfGame : Timer.Duration = #nanoseconds(Int.abs(fixture.kickOff - Time.now() + (Utilities.getHour() * 2)));
        await setAndBackupTimer(durationToEndOfGame, "gameCompletedExpired");
      };
    };

    private func gameKickOffExpiredCallback() : async () {
      await seasonManager.setFixturesToActive();
      removeExpiredTimers();
      await seasonManager.updateDataHash("fixtures");
    };

    private func gameCompletedExpiredCallback() : async () {
      await seasonManager.setFixturesToCompleted();
      removeExpiredTimers();
      await seasonManager.updateDataHash("fixtures");
    };

    private func loanExpiredCallback() : async () {
      await dataManager.loanExpired();
      removeExpiredTimers();
      await seasonManager.updateDataHash("players");
    };

    private func injuryExpiredCallback() : async () {
      await dataManager.injuryExpired();
      removeExpiredTimers();
      await seasonManager.updateDataHash("players");
    };

    private func transferWindowStartCallback() : async () {
      await seasonManager.transferWindowStart();
      removeExpiredTimers();
      await seasonManager.updateDataHash("system_state");
    };

    private func transferWindowEndCallback() : async () {
      await seasonManager.transferWindowEnd();
      removeExpiredTimers();
      await seasonManager.updateDataHash("system_state");
    };

    private func removeExpiredTimers() : () {
      let currentTime = Time.now();
      timers := Array.filter<T.TimerInfo>(
        timers,
        func(timer : T.TimerInfo) : Bool {
          return timer.triggerTime > currentTime;
        },
      );
    };

    private func setAndBackupTimer(duration : Timer.Duration, callbackName : Text) : async () {
      let jobId : Timer.TimerId = switch (callbackName) {
        case "gameweekBeginExpired" {
          Timer.setTimer<system>(duration, gameweekBeginExpiredCallback);
        };
        case "gameKickOffExpired" {
          Timer.setTimer<system>(duration, gameKickOffExpiredCallback);
        };
        case "gameCompletedExpired" {
          Timer.setTimer<system>(duration, gameCompletedExpiredCallback);
        };
        case "transferWindowStart" {
          Timer.setTimer<system>(duration, transferWindowStartCallback);
        };
        case "transferWindowEnd" {
          Timer.setTimer<system>(duration, transferWindowEndCallback);
        };
        case _ {
          Timer.setTimer<system>(duration, defaultCallback);
        };
      };

      let triggerTime = switch (duration) {
        case (#seconds s) {
          Time.now() + s * 1_000_000_000;
        };
        case (#nanoseconds ns) {
          Time.now() + ns;
        };
      };

      let newTimerInfo : T.TimerInfo = {
        id = jobId;
        triggerTime = triggerTime;
        callbackName = callbackName;
      };

      var timerBuffer = Buffer.fromArray<T.TimerInfo>(timers);
      timerBuffer.add(newTimerInfo);
      timers := Buffer.toArray(timerBuffer);
    };

    private func defaultCallback() : async () {};

    private func updateManagerCanisterWasms() : async (){
      let managerCanisterIds = userManager.getUniqueManagerCanisterIds();
      let IC : Management.Management = actor (NetworkEnvironmentVariables.Default);
      for(canisterId in Iter.fromArray(managerCanisterIds)){
        await IC.stop_canister({ canister_id = Principal.fromText(canisterId); });
        let oldManagement = actor (canisterId) : actor {};
        let _ = await (system ManagerCanister._ManagerCanister)(#upgrade oldManagement)();
        await IC.start_canister({ canister_id = Principal.fromText(canisterId); });
      };
    };

    //System timer functions

    public func getBackendCanisterBalance() : async Result.Result<Nat, T.Error> {
      let balance = await ledger.icrc1_balance_of({owner = Principal.fromActor(Self); subaccount = null});
      return #ok(balance);
    };

    public shared func getCanisterCyclesBalance() : async Result.Result<Nat, T.Error> {
      return #ok(Cycles.balance());
    };

    //informational end points

    public shared func getCanisterCyclesAvailable() : async Nat {
      return Cycles.available();
    };

    public shared func getTreasuryAccountPublic() : async Account.AccountIdentifier {
      return getTreasuryAccount();
    };

    private func getTreasuryAccount() : Account.AccountIdentifier {
      let actorPrincipal : Principal = Principal.fromActor(Self);
      Account.accountIdentifier(actorPrincipal, Account.defaultSubaccount());
    };    

    

    //Admin dashboard functions

    public shared ({ caller }) func isAdmin() : async Result.Result<Bool, T.Error> {
      return #ok(isDataAdmin(Principal.toText(caller)));
    };

    //TODO (DFINITY): Put under SNS control at later date

    public shared ({ caller }) func setLeagueName(leagueId: T.FootballLeagueId, leagueName: Text) : async Result.Result<(), T.Error> {
      assert isDataAdmin(Principal.toText(caller));
      
      let result = await dataManager.setLeagueName(leagueId, leagueName);
      await seasonManager.updateDataHash("leagues");
      return result;
    };


    public shared ({ caller }) func setAbbreviatedLeagueName(leagueId: T.FootballLeagueId, abbreviatedName: Text) : async Result.Result<(), T.Error> {
      assert isDataAdmin(Principal.toText(caller));
      let result = await dataManager.setAbbreviatedLeagueName(leagueId, abbreviatedName);
      await seasonManager.updateDataHash("leagues");
      return result;
    };


    public shared ({ caller }) func setLeagueGoverningBody(leagueId: T.FootballLeagueId, governingBody: Text) : async Result.Result<(), T.Error> {
      assert isDataAdmin(Principal.toText(caller));
      let result = await dataManager.setLeagueGoverningBody(leagueId, governingBody);
      await seasonManager.updateDataHash("leagues");
      return result;
    };


    public shared ({ caller }) func setLeagueGender(leagueId: T.FootballLeagueId, gender: T.Gender) : async Result.Result<(), T.Error> {
      assert isDataAdmin(Principal.toText(caller));
      let result = await dataManager.setLeagueGender(leagueId, gender);
      await seasonManager.updateDataHash("leagues");
      return result;
    };


    public shared ({ caller }) func setLeagueDateFormed(leagueId: T.FootballLeagueId, dateFormed: Int) : async Result.Result<(), T.Error> {
      assert isDataAdmin(Principal.toText(caller));
      let result = await dataManager.setLeagueDateFormed(leagueId, dateFormed);
      await seasonManager.updateDataHash("leagues");
      return result;
    };


    public shared ({ caller }) func setLeagueCountryId(leagueId: T.FootballLeagueId, countryId: T.CountryId) : async Result.Result<(), T.Error> {
      assert isDataAdmin(Principal.toText(caller));
      let result = await dataManager.setLeagueCountryId(leagueId, countryId);
      await seasonManager.updateDataHash("leagues");
      return result;
    };


    public shared ({ caller }) func setLeagueLogo(leagueId: T.FootballLeagueId, logo: Blob) : async Result.Result<(), T.Error> {
      assert isDataAdmin(Principal.toText(caller));
      let result = await dataManager.setLeagueLogo(leagueId, logo);
      await seasonManager.updateDataHash("leagues");
      return result;
    };

    public shared ({ caller }) func setTeamCount(leagueId: T.FootballLeagueId, teamCount: Nat8) : async Result.Result<(), T.Error> {
      assert isDataAdmin(Principal.toText(caller));
      
      let result = await dataManager.setLeagueTeamCount(leagueId, teamCount);
      await seasonManager.updateDataHash("leagues");
      return result;
    };

    public shared ({ caller }) func createLeague(dto: Requests.CreateLeagueDTO) : async Result.Result<(), T.Error> {
      assert isDataAdmin(Principal.toText(caller));
      let result = await dataManager.createLeague(dto);
      await seasonManager.updateDataHash("leagues");
      return result;
    };

    public shared ({ caller }) func snapshotManagers(seasonId: T.SeasonId, gameweekNumber: T.GameweekNumber, month: T.CalendarMonth) : async Result.Result<(), T.Error> {
      assert isDataAdmin(Principal.toText(caller));
      return #ok(await userManager.snapshotFantasyTeams(seasonId, month, gameweekNumber));
    };

    public shared ({ caller }) func recalculatePoints(leagueId: T.FootballLeagueId, seasonId: T.SeasonId, gameweekNumber: T.GameweekNumber, month: T.CalendarMonth) : async Result.Result<(), T.Error> {
      assert isDataAdmin(Principal.toText(caller));
      return #ok(await userManager.calculateFantasyTeamScores(leagueId, seasonId, gameweekNumber, month));
    };

    public shared ({ caller }) func viewPayouts(gameweekNumber: T.GameweekNumber) : async Result.Result<(), T.Error> {
      assert isDataAdmin(Principal.toText(caller));
      return #err(#NotFound);
      //return await userManager.viewPayouts(gameweekNumber); //TODO (PAYOUT)
    };

    public shared ({ caller }) func updateRewardPools(dto: Requests.UpdateRewardPoolsDTO) : async Result.Result<(), T.Error> {
      assert isDataAdmin(Principal.toText(caller));
      return #err(#NotFound);
      //return await userManager.updateRewardPools(dto); //TODO (PAYOUT)
    };

    public shared ({ caller }) func updateSystemStatus(dto: Requests.UpdateSystemStatusDTO) : async Result.Result<(), T.Error> {
      assert isDataAdmin(Principal.toText(caller));
      return await seasonManager.updateSystemStatus(dto);
    };

    public shared func getManagerCanisterIds() : async [T.CanisterId]{
      return userManager.getUniqueManagerCanisterIds();
    };

    public shared ({ caller }) func getAdminDashboard() : async Result.Result<Responses.AdminDashboardDTO, T.Error> {
      assert isDataAdmin(Principal.toText(caller));
      
      
      let IC : Management.Management = actor (NetworkEnvironmentVariables.Default);
      let data_canister = await (
        IC.canister_status(
          {
            canister_id = Principal.fromText(NetworkEnvironmentVariables.DATA_CANISTER_ID); 
            num_requested_changes = null
          }
        )
      );
      var dataCanisterCycles = data_canister.cycles;
      
      let openfpl_canister = await (
        IC.canister_status(
          {
            canister_id = Principal.fromText(NetworkEnvironmentVariables.OPENFPL_BACKEND_CANISTER_ID); 
            num_requested_changes = null
          }
        )
      );
      var openFPLCanisterCycles = openfpl_canister.cycles;
      
      let openwsl_canister = await (
        IC.canister_status(
          {
            canister_id = Principal.fromText(NetworkEnvironmentVariables.OPENWSL_BACKEND_CANISTER_ID); 
            num_requested_changes = null
          }
        )
      );
      var openWSLCanisterCycles = openwsl_canister.cycles;
      
      let managerCanisterIds = userManager.getUniqueManagerCanisterIds();
      let managerCanistersBuffer = Buffer.fromArray<(T.CanisterId, Nat)>([]);
        
      for(managerCanisterId in Iter.fromArray(managerCanisterIds)){
        let canisterInfo = await (
          IC.canister_status(
            {
              canister_id = Principal.fromText(managerCanisterId); 
              num_requested_changes = null
            }
          )
        );
        managerCanistersBuffer.add(managerCanisterId, canisterInfo.cycles)
      };

      return #ok({
        dataCanisterCycles = dataCanisterCycles;
        dataCanisterId = NetworkEnvironmentVariables.DATA_CANISTER_ID;
        managerCanisters = Buffer.toArray(managerCanistersBuffer);
        openFPLBackendCycles = openFPLCanisterCycles;
        openFPLCanisterId = NetworkEnvironmentVariables.OPENFPL_BACKEND_CANISTER_ID;
        openWSLBackendCycles = openWSLCanisterCycles;
        openWSLCanisterId = NetworkEnvironmentVariables.OPENWSL_BACKEND_CANISTER_ID
      })
    };



  };
