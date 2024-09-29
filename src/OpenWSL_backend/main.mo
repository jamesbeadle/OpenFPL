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

  import Root "../shared/sns-wrappers/root";
  import Management "../shared/utils/Management";
  import FPLLedger "../shared/def/FPLLedger";
  import ManagerCanister "../shared/canister_definitions/manager-canister";
  import DataManager "../shared/managers/data-manager";
  import LeaderboardManager "../shared/managers/leaderboard-manager";
  import UserManager "../shared/managers/user-manager";
  import SeasonManager "../shared/managers/season-manager";
  import RequestDtOs "../shared/RequestDTOs";
import CyclesDispenser "../shared/cycles-dispenser";
import Environment "../OpenFPL_backend/Environment";
import NetworkEnvironmentVariables "../shared/network_environment_variables";

  actor Self {
    
    private let userManager = UserManager.UserManager(Environment.BACKEND_CANISTER_ID);
    private let dataManager = DataManager.DataManager();
    private let seasonManager = SeasonManager.SeasonManager();
    private let leaderboardManager = LeaderboardManager.LeaderboardManager(Environment.BACKEND_CANISTER_ID);
    private let cyclesDispenser = CyclesDispenser.CyclesDispenser();
    private let ledger : FPLLedger.Interface = actor (FPLLedger.CANISTER_ID);

    private stable var dataAdmins : [T.PrincipalId] = [];
    private stable var alreadyInitialisedData = false;
    
    private func isDataAdmin(principalId: Text) : Bool {
      return Option.isSome(Array.find<T.PrincipalId>(dataAdmins, func(dataAdmin: T.PrincipalId){
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

    public shared query func getDataHashes() : async Result.Result<[DTOs.DataHashDTO], T.Error> {
      return seasonManager.getDataHashes();
    };

    public shared func getSystemState() : async Result.Result<DTOs.SystemStateDTO, T.Error> {
      return await seasonManager.getSystemState();
    };

    public shared func getClubs() : async Result.Result<[DTOs.ClubDTO], T.Error> {
      return await dataManager.getClubs();
    };

    public shared func getFixtures(dto: RequestDtOs.RequestFixturesDTO) : async Result.Result<[DTOs.FixtureDTO], T.Error> {
      return await dataManager.getFixtures(dto);
    };

    public shared func getSeasons() : async Result.Result<[DTOs.SeasonDTO], T.Error> {
      return await dataManager.getSeasons();
    };

    public shared func getPostponedFixtures() : async Result.Result<[DTOs.FixtureDTO], T.Error> {
      return await dataManager.getPostponedFixtures();
    };

    public shared func getTotalManagers() : async Result.Result<Nat, T.Error> {
      return await userManager.getTotalManagers();
    };

    public shared func getPlayers() : async Result.Result<[DTOs.PlayerDTO], T.Error> {
      return await dataManager.getPlayers();
    };

    public shared func getLoanedPlayers(dto: DTOs.ClubFilterDTO) : async Result.Result<[DTOs.PlayerDTO], T.Error> {
      return await dataManager.getLoanedPlayers(dto);
    };

    public shared func getRetiredPlayers(dto: DTOs.ClubFilterDTO) : async Result.Result<[DTOs.PlayerDTO], T.Error> {
      return await dataManager.getRetiredPlayers(dto);
    };

    public shared func getPlayerDetailsForGameweek(dto: DTOs.GameweekFiltersDTO) : async Result.Result<[DTOs.PlayerPointsDTO], T.Error> {
      return await dataManager.getPlayerDetailsForGameweek(dto);
    };

    public shared func getPlayersMap(dto: DTOs.GameweekFiltersDTO) : async Result.Result<[(Nat16, DTOs.PlayerScoreDTO)], T.Error> {
      return await dataManager.getPlayersMap(dto);
    };

    public shared func getPlayerDetails(dto: DTOs.GetPlayerDetailsDTO) : async Result.Result<DTOs.PlayerDetailDTO, T.Error> {
      return await dataManager.getPlayerDetails(dto);
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

      let systemStateResult = await seasonManager.getSystemState();
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
      
      let systemStateResult = await seasonManager.getSystemState();
      switch(systemStateResult){
        case (#ok systemState){       

          let clubsResult = await dataManager.getClubs();
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

      let systemStateResult = await seasonManager.getSystemState();
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

      let systemStateResult = await seasonManager.getSystemState();
      switch(systemStateResult){
        case (#ok systemState){       
          assert not systemState.onHold;
      
          let playersResult = await dataManager.getPlayers();
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
      assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      return #Err("Governance on hold due to network issues");
      
      //Todo when functionality available: Make cross subnet call to governance canister to see if proposal exists

      //return seasonManager.validateRevaluePlayerUp(revaluePlayerUpDTO);
    };

    public shared ({ caller }) func executeRevaluePlayerUp(revaluePlayerUpDTO : DTOs.RevaluePlayerUpDTO) : async () {
      assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      assert isDataAdmin(Principal.toText(caller));
      switch(await dataManager.validateRevaluePlayerUp(revaluePlayerUpDTO)){
        case (#ok success){
          let _ = await dataManager.executeRevaluePlayerUp(revaluePlayerUpDTO);
        };
        case _ {}
      };
    };

    public shared query ({ caller }) func validateRevaluePlayerDown(revaluePlayerDownDTO : DTOs.RevaluePlayerDownDTO) : async T.RustResult {
      assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      return #Err("Governance on hold due to network issues");
      //return seasonManager.validateRevaluePlayerDown(revaluePlayerDownDTO);
    };

    public shared ({ caller }) func executeRevaluePlayerDown(revaluePlayerDownDTO : DTOs.RevaluePlayerDownDTO) : async () {
      assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      assert isDataAdmin(Principal.toText(caller));
      switch(await dataManager.validateRevaluePlayerDown(revaluePlayerDownDTO)){
        case (#ok success){
          let _ = await dataManager.executeRevaluePlayerDown(revaluePlayerDownDTO);
        };
        case _ {}
      };
    };

    public shared query ({ caller }) func validateSubmitFixtureData(submitFixtureData : DTOs.SubmitFixtureDataDTO) : async T.RustResult {
      Debug.print(debug_show submitFixtureData);
      assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      return #Err("Governance on hold due to network issues");
      //return seasonManager.validateSubmitFixtureData(submitFixtureData);
    };

    public shared ({ caller }) func executeSubmitFixtureData(submitFixtureData : DTOs.SubmitFixtureDataDTO) : async () {
      assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      assert isDataAdmin(Principal.toText(caller));
      switch(await dataManager.validateSubmitFixtureData(submitFixtureData)){
        case (#ok success){
          let _ = await dataManager.executeSubmitFixtureData(submitFixtureData);
        };
        case _ {}
      };
    };

    public shared query ({ caller }) func validateAddInitialFixtures(addInitialFixturesDTO : DTOs.AddInitialFixturesDTO) : async T.RustResult {
      assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID; 
      return #Err("Governance on hold due to network issues");   
      //return seasonManager.validateAddInitialFixtures(addInitialFixturesDTO);
    };

    public shared ({ caller }) func executeAddInitialFixtures(addInitialFixturesDTO : DTOs.AddInitialFixturesDTO) : async () {
      assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      assert isDataAdmin(Principal.toText(caller));
      switch(await dataManager.validateAddInitialFixtures(addInitialFixturesDTO)){
        case (#ok success){
          let _ = await dataManager.executeAddInitialFixtures(addInitialFixturesDTO);
        };
        case _ {}
      };
    };

    public shared query ({ caller }) func validateMoveFixture(moveFixtureDTO : DTOs.MoveFixtureDTO) : async T.RustResult {
      assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      return #Err("Governance on hold due to network issues");
      //return seasonManager.validateMoveFixture(moveFixtureDTO);
    };

    public shared ({ caller }) func executeMoveFixture(moveFixtureDTO : DTOs.MoveFixtureDTO) : async () {
      assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      assert isDataAdmin(Principal.toText(caller));
      switch(await dataManager.validateMoveFixture(moveFixtureDTO)){
        case (#ok success){
          let _ = await dataManager.executeMoveFixture(moveFixtureDTO);
        };
        case _ {}
      };
    };

    public shared query ({ caller }) func validatePostponeFixture(postponeFixtureDTO : DTOs.PostponeFixtureDTO) : async T.RustResult {
      assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      return #Err("Governance on hold due to network issues");
      //return seasonManager.validatePostponeFixture(postponeFixtureDTO);
    };

    public shared ({ caller }) func executePostponeFixture(postponeFixtureDTO : DTOs.PostponeFixtureDTO) : async () {
      assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      assert isDataAdmin(Principal.toText(caller));
      switch(await dataManager.validatePostponeFixture(postponeFixtureDTO)){
        case (#ok success){
          let _ =  await dataManager.executePostponeFixture(postponeFixtureDTO);
        };
        case _ {}
      };
    };

    public shared query ({ caller }) func validateRescheduleFixture(rescheduleFixtureDTO : DTOs.RescheduleFixtureDTO) : async T.RustResult {
      assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      return #Err("Governance on hold due to network issues");
      //return await seasonManager.validateRescheduleFixture(rescheduleFixtureDTO);
    };

    public shared ({ caller }) func executeRescheduleFixture(rescheduleFixtureDTO : DTOs.RescheduleFixtureDTO) : async () {
      assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      assert isDataAdmin(Principal.toText(caller));
      switch(await dataManager.validateRescheduleFixture(rescheduleFixtureDTO)){
        case (#ok success){
          let _ = await dataManager.executeRescheduleFixture(rescheduleFixtureDTO);
        };
        case _ {}
      };
    };

    public shared query ({ caller }) func validateLoanPlayer(loanPlayerDTO : DTOs.LoanPlayerDTO) : async T.RustResult {
      assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      return #Err("Governance on hold due to network issues");
      //return seasonManager.validateLoanPlayer(loanPlayerDTO);
    };

    public shared ({ caller }) func executeLoanPlayer(loanPlayerDTO : DTOs.LoanPlayerDTO) : async () {
      assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      assert isDataAdmin(Principal.toText(caller));
      switch(await dataManager.validateLoanPlayer(loanPlayerDTO)){
        case (#ok success){
          let _ = await dataManager.executeLoanPlayer(loanPlayerDTO);
        };
        case _ {}
      };
    };

    public shared query ({ caller }) func validateTransferPlayer(transferPlayerDTO : DTOs.TransferPlayerDTO) : async T.RustResult {
      assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      return #Err("Governance on hold due to network issues");
      //return seasonManager.validateTransferPlayer(transferPlayerDTO);
    };

    public shared ({ caller }) func executeTransferPlayer(transferPlayerDTO : DTOs.TransferPlayerDTO) : async () {
      assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      assert isDataAdmin(Principal.toText(caller));
      switch(await dataManager.validateTransferPlayer(transferPlayerDTO)){
        case (#ok success){
          let _ = await dataManager.executeTransferPlayer(transferPlayerDTO);
        };
        case _ {}
      };
    };

    public shared query ({ caller }) func validateRecallPlayer(recallPlayerDTO : DTOs.RecallPlayerDTO) : async T.RustResult {
      assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      return #Err("Governance on hold due to network issues");
      //return seasonManager.validateRecallPlayer(recallPlayerDTO);
    };

    public shared ({ caller }) func executeRecallPlayer(recallPlayerDTO : DTOs.RecallPlayerDTO) : async () {
      assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      assert isDataAdmin(Principal.toText(caller));
      switch(await dataManager.validateRecallPlayer(recallPlayerDTO)){
        case (#ok success){
          let _ = await dataManager.executeRecallPlayer(recallPlayerDTO);
        };
        case _ {}
      };
    };

    public shared query ({ caller }) func validateCreatePlayer(createPlayerDTO : DTOs.CreatePlayerDTO) : async T.RustResult {
      assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      return #Err("Governance on hold due to network issues");
      //return seasonManager.validateCreatePlayer(createPlayerDTO);
    };

    public shared ({ caller }) func executeCreatePlayer(createPlayerDTO : DTOs.CreatePlayerDTO) : async () {
      assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      assert isDataAdmin(Principal.toText(caller));
      switch(await dataManager.validateCreatePlayer(createPlayerDTO)){
        case (#ok success){
          let _ = await dataManager.executeCreatePlayer(createPlayerDTO);
        };
        case _ {}
      };
    };

    public shared query ({ caller }) func validateUpdatePlayer(updatePlayerDTO : DTOs.UpdatePlayerDTO) : async T.RustResult {
      assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      return #Err("Governance on hold due to network issues");
      //return seasonManager.validateUpdatePlayer(updatePlayerDTO);
    };

    public shared ({ caller }) func executeUpdatePlayer(updatePlayerDTO : DTOs.UpdatePlayerDTO) : async () {
      assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      assert isDataAdmin(Principal.toText(caller));
      switch(await dataManager.validateUpdatePlayer(updatePlayerDTO)){
        case (#ok success){
          let _ = await dataManager.executeUpdatePlayer(updatePlayerDTO);
        };
        case _ {}
      };
    };

    public shared query ({ caller }) func validateSetPlayerInjury(setPlayerInjuryDTO : DTOs.SetPlayerInjuryDTO) : async T.RustResult {
      assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      return #Err("Governance on hold due to network issues");
      //return seasonManager.validateSetPlayerInjury(setPlayerInjuryDTO);
    };

    public shared ({ caller }) func executeSetPlayerInjury(setPlayerInjuryDTO : DTOs.SetPlayerInjuryDTO) : async () {
      assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      assert isDataAdmin(Principal.toText(caller));
      switch(await dataManager.validateSetPlayerInjury(setPlayerInjuryDTO)){
        case (#ok success){
          let _ = await dataManager.executeSetPlayerInjury(setPlayerInjuryDTO);
        };
        case _ {}
      };
    };

    public shared query ({ caller }) func validateRetirePlayer(retirePlayerDTO : DTOs.RetirePlayerDTO) : async T.RustResult {
      assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      return #Err("Governance on hold due to network issues");
      //return seasonManager.validateRetirePlayer(retirePlayerDTO);
    };

    public shared ({ caller }) func executeRetirePlayer(retirePlayerDTO : DTOs.RetirePlayerDTO) : async () {
      assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      assert isDataAdmin(Principal.toText(caller));
      switch(await dataManager.validateRetirePlayer(retirePlayerDTO)){
        case (#ok success){
          let _ = await dataManager.executeRetirePlayer(retirePlayerDTO);
        };
        case _ {}
      };
    };

    public shared query ({ caller }) func validateUnretirePlayer(unretirePlayerDTO : DTOs.UnretirePlayerDTO) : async T.RustResult {
      assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      return #Err("Governance on hold due to network issues");
      //return seasonManager.validateUnretirePlayer(unretirePlayerDTO);
    };

    public shared ({ caller }) func executeUnretirePlayer(unretirePlayerDTO : DTOs.UnretirePlayerDTO) : async () {
      assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      assert isDataAdmin(Principal.toText(caller));
      switch(await dataManager.validateUnretirePlayer(unretirePlayerDTO)){
        case (#ok success){
          let _ = await dataManager.executeUnretirePlayer(unretirePlayerDTO);
        };
        case _ {}
      };
    };

    public shared query ({ caller }) func validatePromoteFormerClub(promoteFormerClubDTO : DTOs.PromoteFormerClubDTO) : async T.RustResult {
      assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      return #Err("Governance on hold due to network issues");
      //return seasonManager.validatePromoteFormerClub(promoteFormerClubDTO);
    };

    public shared ({ caller }) func executePromoteFormerClub(promoteFormerClubDTO : DTOs.PromoteFormerClubDTO) : async () {
      assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      assert isDataAdmin(Principal.toText(caller));
      switch(await dataManager.validatePromoteFormerClub(promoteFormerClubDTO)){
        case (#ok success){
          let _ = await dataManager.executePromoteFormerClub(promoteFormerClubDTO);
        };
        case _ {}
      };
    };

    public shared query ({ caller }) func validatePromoteNewClub(promoteNewClubDTO : DTOs.PromoteNewClubDTO) : async T.RustResult {
      assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      return #Err("Governance on hold due to network issues");
      //return seasonManager.validatePromoteNewClub(promoteNewClubDTO);
    };

    public shared ({ caller }) func executePromoteNewClub(promoteNewClubDTO : DTOs.PromoteNewClubDTO) : async () {
      assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      assert isDataAdmin(Principal.toText(caller));
      switch(await dataManager.validatePromoteNewClub(promoteNewClubDTO)){
        case (#ok success){
          let _ = await dataManager.executePromoteNewClub(promoteNewClubDTO);
        };
        case _ {}
      };
    };

    public shared query ({ caller }) func validateUpdateClub(updateClubDTO : DTOs.UpdateClubDTO) : async T.RustResult {
      assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      return #Err("Governance on hold due to network issues");
      //return seasonManager.validateUpdateClub(updateClubDTO);
    };

    public shared ({ caller }) func executeUpdateClub(updateClubDTO : DTOs.UpdateClubDTO) : async () {
      assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      assert isDataAdmin(Principal.toText(caller));
      switch(await dataManager.validateUpdateClub(updateClubDTO)){
        case (#ok success){
          let _ = await dataManager.executeUpdateClub(updateClubDTO);
        };
        case _ {}
      };
    };

    //system callback functions

    private func cyclesCheckCallback() : async () {
      await checkCanisterCycles();
    };

    public shared ({ caller }) func searchUsername(dto: DTOs.UsernameFilterDTO) : async Result.Result<DTOs.ManagerDTO, T.Error> {
      assert not Principal.isAnonymous(caller);
      return await userManager.getManagerByUsername(dto.username);
    };

    public shared ({ caller }) func getCanisters(dto: DTOs.GetCanistersDTO) : async Result.Result<DTOs.GetCanistersDTO, T.Error> {
      assert not Principal.isAnonymous(caller);

      let root_canister = actor (NetworkEnvironmentVariables.SNS_ROOT_CANISTER_ID) : actor {
        get_sns_canisters_summary : (request: Root.GetSnsCanistersSummaryRequest) -> async Root.GetSnsCanistersSummaryResponse;
      };

      let summary = await root_canister.get_sns_canisters_summary({update_canister_list = ?false});

      let canisterBuffer = Buffer.fromArray<DTOs.CanisterDTO>([]);

      let topups = cyclesDispenser.getStableTopups();
      let sortedTopups = Array.sort(
        topups,
        func(a : T.CanisterTopup, b : T.CanisterTopup) : Order.Order {
          if (a.topupTime > b.topupTime) { return #greater };
          if (a.topupTime == b.topupTime) { return #equal };
          return #less;
        },
      );

      switch(dto.canisterTypeFilter){
        case (#SNS){
          switch(summary.governance){
            case (null){ };
            case (?canister){
              switch(canister.canister_id){
                  case (null) {};
                  case (?foundCanisterId){
                    let status = canister.status;
                    switch(status){
                      case (null){};
                      case (?foundStatus){
                        let lastTopup = Array.find<T.CanisterTopup>(sortedTopups, func(topup: T.CanisterTopup){
                            topup.canisterId == Principal.toText(foundCanisterId);
                        });
                        var topupTime: Int = 0;
                        switch(lastTopup){
                          case (null){};
                          case (?foundTopup){
                          topupTime := foundTopup.topupTime;
                          };
                        };
                        canisterBuffer.add({
                          canisterId = Principal.toText(foundCanisterId);
                          canister_type = #SNS;
                          cycles = foundStatus.cycles;
                          lastTopup = topupTime;
                        });
                      }
                    };
                  };
                };
            };
          };          
          
          switch(summary.index){
            case (null){ };
            case (?canister){
              switch(canister.canister_id){
                case (null) {};
                case (?foundCanisterId){
                  let status = canister.status;
                  switch(status){
                    case (null){};
                    case (?foundStatus){
                      let lastTopup = Array.find<T.CanisterTopup>(sortedTopups, func(topup: T.CanisterTopup){
                          topup.canisterId == Principal.toText(foundCanisterId);
                      });
                      var topupTime: Int = 0;
                      switch(lastTopup){
                        case (null){};
                        case (?foundTopup){
                        topupTime := foundTopup.topupTime;
                        };
                      };
                      canisterBuffer.add({
                        canisterId = Principal.toText(foundCanisterId);
                        canister_type = #SNS;
                        cycles = foundStatus.cycles;
                        lastTopup = topupTime;
                      });
                    }
                  };
                };
              };
            };
          };
          
          switch(summary.ledger){
            case (null){ };
            case (?canister){
              switch(canister.canister_id){
                case (null) {};
                case (?foundCanisterId){
                  let status = canister.status;
                  switch(status){
                    case (null){};
                    case (?foundStatus){
                      let lastTopup = Array.find<T.CanisterTopup>(sortedTopups, func(topup: T.CanisterTopup){
                          topup.canisterId == Principal.toText(foundCanisterId);
                      });
                      var topupTime: Int = 0;
                      switch(lastTopup){
                        case (null){};
                        case (?foundTopup){
                        topupTime := foundTopup.topupTime;
                        };
                      };
                      canisterBuffer.add({
                        canisterId = Principal.toText(foundCanisterId);
                        canister_type = #SNS;
                        cycles = foundStatus.cycles;
                        lastTopup = topupTime;
                      });
                    }
                  };
                };
              };
            };
          };
          
          switch(summary.root){
            case (null){ };
            case (?canister){
              switch(canister.canister_id){
                case (null) {};
                case (?foundCanisterId){
                  let status = canister.status;
                    switch(status){
                    case (null){};
                    case (?foundStatus){
                      let lastTopup = Array.find<T.CanisterTopup>(sortedTopups, func(topup: T.CanisterTopup){
                          topup.canisterId == Principal.toText(foundCanisterId);
                      });
                      var topupTime: Int = 0;
                      switch(lastTopup){
                        case (null){};
                        case (?foundTopup){
                        topupTime := foundTopup.topupTime;
                        };
                      };
                      canisterBuffer.add({
                        canisterId = Principal.toText(foundCanisterId);
                        canister_type = #SNS;
                        cycles = foundStatus.cycles;
                        lastTopup = topupTime;
                      });
                    }
                  };
                };
              };
            };
          };
          
          switch(summary.swap){
            case (null){ };
            case (?canister){
              switch(canister.canister_id){
                  case (null) {};
                  case (?foundCanisterId){
                    let status = canister.status;
                      switch(status){
                      case (null){};
                      case (?foundStatus){
                        let lastTopup = Array.find<T.CanisterTopup>(sortedTopups, func(topup: T.CanisterTopup){
                            topup.canisterId == Principal.toText(foundCanisterId);
                        });
                        var topupTime: Int = 0;
                        switch(lastTopup){
                          case (null){};
                          case (?foundTopup){
                          topupTime := foundTopup.topupTime;
                          };
                        };
                        canisterBuffer.add({
                          canisterId = Principal.toText(foundCanisterId);
                          canister_type = #SNS;
                          cycles = foundStatus.cycles;
                          lastTopup = topupTime;
                        });
                      }
                    };
                  };
                };

            };
          };
        };
        case (#Dapp){
          for(canister in Iter.fromArray(summary.dapps)){
            switch(canister.canister_id){
              case (null) {};
              case (?foundCanisterId){
                let status = canister.status;
                switch(status){
                  case (null){};
                  case (?foundStatus){
                    let lastTopup = Array.find<T.CanisterTopup>(sortedTopups, func(topup: T.CanisterTopup){
                        topup.canisterId == Principal.toText(foundCanisterId);
                    });
                    var topupTime: Int = 0;
                    switch(lastTopup){
                      case (null){};
                      case (?foundTopup){
                      topupTime := foundTopup.topupTime;
                      };
                    };
                    canisterBuffer.add({
                      canisterId = Principal.toText(foundCanisterId);
                      canister_type = #Dapp;
                      cycles = foundStatus.cycles;
                      lastTopup = topupTime;
                    });
                  }
                };
              };
            };
          };
        };
        case (#Manager){
          let uniqueManagerCanisterIds = userManager.getUniqueManagerCanisterIds();
          for(canisterId in Iter.fromArray(uniqueManagerCanisterIds)){
            let IC : Management.Management = actor (NetworkEnvironmentVariables.Default);
            let canisterInfo = await (
              IC.canister_status(
                {
                  canister_id = Principal.fromText(canisterId); 
                  num_requested_changes = null
                }),
            );
            let cycles: Nat = canisterInfo.cycles;

            let lastTopup = Array.find<T.CanisterTopup>(sortedTopups, func(topup: T.CanisterTopup){
                topup.canisterId == canisterId;
            });
            var topupTime: Int = 0;
            switch(lastTopup){
              case (null){};
              case (?foundTopup){
              topupTime := foundTopup.topupTime;
              };
            };

            canisterBuffer.add({
              canisterId = canisterId;
              canister_type = #Manager;
              cycles = cycles;
              lastTopup = topupTime;
            });
          };
        };
        case (#Archive){
          for(canister in Iter.fromArray(summary.archives)){
            switch(canister.canister_id){
              case (null) {};
              case (?foundCanisterId){
                let status = canister.status;
                switch(status){
                  case (null){};
                  case (?foundStatus){
                    let lastTopup = Array.find<T.CanisterTopup>(sortedTopups, func(topup: T.CanisterTopup){
                        topup.canisterId == Principal.toText(foundCanisterId);
                    });
                    var topupTime: Int = 0;
                    switch(lastTopup){
                      case (null){};
                      case (?foundTopup){
                      topupTime := foundTopup.topupTime;
                      };
                    };
                    canisterBuffer.add({
                      canisterId = Principal.toText(foundCanisterId);
                      canister_type = #SNS;
                      cycles = foundStatus.cycles;
                      lastTopup = topupTime;
                    });
                  }
                };
              };
            };
          };
        };
        case (#WeeklyLeaderboard){
          let weeklyLeaderboardCanisters = leaderboardManager.getWeeklyLeaderboardCanisters();
          for(weeklyLeaderboardCanister in Iter.fromArray(weeklyLeaderboardCanisters)){
            let IC : Management.Management = actor (NetworkEnvironmentVariables.Default);
            let canisterInfo = await (
              IC.canister_status(
                {
                  canister_id = Principal.fromText(weeklyLeaderboardCanister.canisterId); 
                  num_requested_changes = null
                }),
            );
            let cycles: Nat = canisterInfo.cycles;

            let lastTopup = Array.find<T.CanisterTopup>(sortedTopups, func(topup: T.CanisterTopup){
                topup.canisterId == weeklyLeaderboardCanister.canisterId;
            });
            var topupTime: Int = 0;
            switch(lastTopup){
              case (null){};
              case (?foundTopup){
              topupTime := foundTopup.topupTime;
              };
            };

            canisterBuffer.add({
              canisterId = weeklyLeaderboardCanister.canisterId;
              canister_type = #WeeklyLeaderboard;
              cycles = cycles;
              lastTopup = topupTime;
            });
          };
        };
        case (#MonthlyLeaderboard){
          let monthlyLeaderboardCanisters = leaderboardManager.getMonthlyLeaderboardsCanisters();
          for(monthlyLeaderboardCanister in Iter.fromArray(monthlyLeaderboardCanisters)){
            let IC : Management.Management = actor (NetworkEnvironmentVariables.Default);
            let canisterInfo = await (
              IC.canister_status(
                {
                  canister_id = Principal.fromText(monthlyLeaderboardCanister.canisterId); 
                  num_requested_changes = null
                }),
            );
            let cycles: Nat = canisterInfo.cycles;

            let lastTopup = Array.find<T.CanisterTopup>(sortedTopups, func(topup: T.CanisterTopup){
                topup.canisterId == monthlyLeaderboardCanister.canisterId;
            });
            var topupTime: Int = 0;
            switch(lastTopup){
              case (null){};
              case (?foundTopup){
              topupTime := foundTopup.topupTime;
              };
            };

            canisterBuffer.add({
              canisterId = monthlyLeaderboardCanister.canisterId;
              canister_type = #MonthlyLeaderboard;
              cycles = cycles;
              lastTopup = topupTime;
            });
          };

        };
        case (#SeasonLeaderboard){
          let seasonLeaderboardCanisters = leaderboardManager.getSeasonLeaderboardCanisters();
          for(seasonLeaderboardCanister in Iter.fromArray(seasonLeaderboardCanisters)){
            let IC : Management.Management = actor (NetworkEnvironmentVariables.Default);
            let canisterInfo = await (
              IC.canister_status(
                {
                  canister_id = Principal.fromText(seasonLeaderboardCanister.canisterId); 
                  num_requested_changes = null
                }),
            );
            let cycles: Nat = canisterInfo.cycles;

            let lastTopup = Array.find<T.CanisterTopup>(sortedTopups, func(topup: T.CanisterTopup){
                topup.canisterId == seasonLeaderboardCanister.canisterId;
            });
            var topupTime: Int = 0;
            switch(lastTopup){
              case (null){};
              case (?foundTopup){
              topupTime := foundTopup.topupTime;
              };
            };

            canisterBuffer.add({
              canisterId = seasonLeaderboardCanister.canisterId;
              canister_type = #SeasonLeaderboard;
              cycles = cycles;
              lastTopup = topupTime;
            });
          };
   
        };
      };

      let canisterList = List.fromArray(Buffer.toArray(canisterBuffer));

      let droppedEntries = List.drop<DTOs.CanisterDTO>(canisterList, dto.offset);
      let paginatedEntries = List.take<DTOs.CanisterDTO>(droppedEntries, dto.limit);

      return #ok({
        canisterTypeFilter = dto.canisterTypeFilter;
        entries = List.toArray(paginatedEntries);
        limit = dto.limit;
        offset = dto.offset;
        totalEntries = List.size(canisterList);
      });
      
    };

    public shared ({ caller }) func getRewardPool(dto: DTOs.GetRewardPoolDTO) : async Result.Result<DTOs.GetRewardPoolDTO, T.Error> {
      assert not Principal.isAnonymous(caller);
      let rewardPool = seasonManager.getRewardPool(dto.seasonId);
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
    private stable var timers : [T.TimerInfo] = [];

    system func preupgrade() {

    };

    system func postupgrade() {

    };

    private func postUpgradeCallback() : async (){
      await checkCanisterCycles(); 
      await setSystemTimers();
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
            case "loanExpired" {
              ignore Timer.setTimer<system>(duration, loanExpiredCallback);
            };
            case "injuryExpired" {
              ignore Timer.setTimer<system>(duration, injuryExpiredCallback);
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
      ignore Timer.setTimer<system>(#nanoseconds(Int.abs(1)), postUpgradeCallback);
    };

    private func gameweekBeginExpiredCallback() : async () {
      await seasonManager.setNextPickTeamGameweek();
      removeExpiredTimers();
      let systemStateResult = await seasonManager.getSystemState();
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
      let fixturesResult = await dataManager.getFixtures({seasonId = seasonId});
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
        case "loanExpired" {
          Timer.setTimer<system>(duration, loanExpiredCallback);
        };
        case "injuryExpired" {
          Timer.setTimer<system>(duration, injuryExpiredCallback);
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
        let _ = await (system ManagerCanister._ManagerCanister)(#upgrade oldManagement)(Environment.BACKEND_CANISTER_ID);
        await IC.start_canister({ canister_id = Principal.fromText(canisterId); });
      };
    };

    private func checkCanisterCycles() : async () {

      let canisterTypes = List.fromArray<T.CanisterType>([
        #Dapp,
        #Manager,
        #WeeklyLeaderboard,
        #MonthlyLeaderboard,
        #SeasonLeaderboard,
        #SNS,
        #Archive
      ]);

      for(canisterType in Iter.fromList(canisterTypes)){
        let canisters = await getCanisters(
        {
          canisterTypeFilter = canisterType;
          entries = [];
          limit = 999999;
          offset = 0;
          totalEntries = 0
        });

        switch(canisters){
          case (#ok result){
            for(canister in Iter.fromArray(result.entries)){
              if(canister.cycles < 10_000_000_000_000){
                await cyclesDispenser.requestCanisterTopup(canister.canisterId, 2_000_000_000_000);
              };
            }
          };
          case _ {}
        };
      };

      let remainingDuration = Utilities.getHour() * 24;
      ignore Timer.setTimer<system>(#nanoseconds remainingDuration, cyclesCheckCallback);
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

  };
