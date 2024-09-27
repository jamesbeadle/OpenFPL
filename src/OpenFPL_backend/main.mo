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

  import T "types";
  import DTOs "DTOs";
  import Countries "Countries";
  import Environment "utils/Environment";
  import Utilities "utils/utilities";
  import Account "lib/Account";

  import SeasonManager "season-manager";
  import TreasuryManager "treasury-manager";
  import CyclesDispenser "cycles-dispenser";
  import Root "sns-wrappers/root";
  import Management "./modules/Management";
  import FPLLedger "FPLLedger";
  import ManagerCanister "canister_definitions/manager-canister";

  actor Self {
    
    private let seasonManager = SeasonManager.SeasonManager();
    private let treasuryManager = TreasuryManager.TreasuryManager();
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
      return await seasonManager.getProfile(Principal.toText(caller));
    };

    public shared ({ caller }) func getCurrentTeam() : async Result.Result<DTOs.PickTeamDTO, T.Error> {
      assert not Principal.isAnonymous(caller);
      return await seasonManager.getCurrentTeam(Principal.toText(caller));
    };

    public shared func getManager(dto: DTOs.GetManagerDTO) : async Result.Result<DTOs.ManagerDTO, T.Error> {
      return await seasonManager.getManager(dto);
    };

    public shared func getFantasyTeamSnapshot(dto: DTOs.GetFantasyTeamSnapshotDTO) : async Result.Result<DTOs.FantasyTeamSnapshotDTO, T.Error> {
      return await seasonManager.getFantasyTeamSnapshot(dto);
    };

    //Leaderboard calls:

    public shared func getWeeklyLeaderboard(dto: DTOs.GetWeeklyLeaderboardDTO) : async Result.Result<DTOs.WeeklyLeaderboardDTO, T.Error> {
      return await seasonManager.getWeeklyLeaderboard(dto);
    };

    public shared func getMonthlyLeaderboard(dto: DTOs.GetMonthlyLeaderboardDTO) : async Result.Result<DTOs.MonthlyLeaderboardDTO, T.Error> {
      return await seasonManager.getMonthlyLeaderboard(dto);
    };

    public shared func getSeasonLeaderboard(dto: DTOs.GetSeasonLeaderboardDTO) : async Result.Result<DTOs.SeasonLeaderboardDTO, T.Error> {
      return await seasonManager.getSeasonLeaderboard(dto);
    };


    //Query functions:

    public shared func getClubs() : async Result.Result<[DTOs.ClubDTO], T.Error> {
      return await seasonManager.getClubs();
    };

    public shared query func getDataHashes() : async Result.Result<[DTOs.DataCacheDTO], T.Error> {
      return #ok(seasonManager.getDataHashes());
    };

    public shared func getFixtures(dto: DTOs.GetFixturesDTO) : async Result.Result<[DTOs.FixtureDTO], T.Error> {
      return await seasonManager.getFixtures(dto);
    };

    public shared func getSeasons() : async Result.Result<[DTOs.SeasonDTO], T.Error> {
      return await seasonManager.getSeasons();
    };

    public shared func getPostponedFixtures() : async Result.Result<[DTOs.FixtureDTO], T.Error> {
      return await seasonManager.getPostponedFixtures();
    };

    public shared query func getTotalManagers() : async Result.Result<Nat, T.Error> {
      return #ok(seasonManager.getTotalManagers());
    };

    public shared func getSystemState() : async Result.Result<DTOs.SystemStateDTO, T.Error> {
      return await seasonManager.getSystemStateDTO();
    };

    public shared func getPlayers() : async Result.Result<[DTOs.PlayerDTO], T.Error> {
      return await seasonManager.getPlayers();
    };

    public shared func getLoanedPlayers(dto: DTOs.ClubFilterDTO) : async Result.Result<[DTOs.PlayerDTO], T.Error> {
      return await seasonManager.getLoanedPlayers(dto);
    };

    public shared func getRetiredPlayers(dto: DTOs.ClubFilterDTO) : async Result.Result<[DTOs.PlayerDTO], T.Error> {
      return await seasonManager.getRetiredPlayers(dto);
    };

    public shared func getPlayerDetailsForGameweek(dto: DTOs.GameweekFiltersDTO) : async Result.Result<[DTOs.PlayerPointsDTO], T.Error> {
      return await seasonManager.getPlayerDetailsForGameweek(dto);
    };

    public shared func getPlayersMap(dto: DTOs.GameweekFiltersDTO) : async Result.Result<[(Nat16, DTOs.PlayerScoreDTO)], T.Error> {
      return await seasonManager.getPlayersMap(dto);
    };

    public shared func getPlayerDetails(dto: DTOs.GetPlayerDetailsDTO) : async Result.Result<DTOs.PlayerDetailDTO, T.Error> {
      return await seasonManager.getPlayerDetails(dto);
    };

    public shared query func getCountries() : async Result.Result<[DTOs.CountryDTO], T.Error> {
      return #ok(Countries.countries);
    };

    public shared query ({ caller }) func isUsernameValid(dto: DTOs.UsernameFilterDTO) : async Bool {
      assert not Principal.isAnonymous(caller);
      let usernameValid = seasonManager.isUsernameValid(dto);
      let usernameTaken = seasonManager.isUsernameTaken(dto, Principal.toText(caller));
      return usernameValid and not usernameTaken;
    };


    //Update functions:

    public shared ({ caller }) func updateUsername(dto: DTOs.UpdateUsernameDTO) : async Result.Result<(), T.Error> {
      assert not Principal.isAnonymous(caller);
      let principalId = Principal.toText(caller);
      return await seasonManager.updateUsername(principalId, dto.username);
    };

    public shared ({ caller }) func updateFavouriteClub(dto: DTOs.UpdateFavouriteClubDTO) : async Result.Result<(), T.Error> {
      assert not Principal.isAnonymous(caller);
      let principalId = Principal.toText(caller);
      return await seasonManager.updateFavouriteClub(principalId, dto.favouriteClubId);
    };

    public shared ({ caller }) func updateProfilePicture(dto: DTOs.UpdateProfilePictureDTO) : async Result.Result<(), T.Error> {
      assert not Principal.isAnonymous(caller);
      let principalId = Principal.toText(caller);
      return await seasonManager.updateProfilePicture(principalId, {
        extension = dto.extension;
        managerId = principalId;
        profilePicture = dto.profilePicture;
      });
    };

    public shared ({ caller }) func saveFantasyTeam(fantasyTeam : DTOs.UpdateTeamSelectionDTO) : async Result.Result<(), T.Error> {
      assert not seasonManager.getSystemState().onHold;
      assert not Principal.isAnonymous(caller);
      let principalId = Principal.toText(caller);
      return await seasonManager.saveFantasyTeam(principalId, fantasyTeam);
    };


    //Governance canister validation and execution functions:

    public shared query ({ caller }) func validateRevaluePlayerUp(revaluePlayerUpDTO : DTOs.RevaluePlayerUpDTO) : async T.RustResult {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      return #Err("Governance on hold due to network issues");
      
      //Todo when functionality available: Make cross subnet call to governance canister to see if proposal exists

      //return seasonManager.validateRevaluePlayerUp(revaluePlayerUpDTO);
    };

    public shared ({ caller }) func executeRevaluePlayerUp(revaluePlayerUpDTO : DTOs.RevaluePlayerUpDTO) : async () {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      assert isDataAdmin(Principal.toText(caller));
      switch(await seasonManager.validateRevaluePlayerUp(revaluePlayerUpDTO)){
        case (#ok success){
          let _ = await seasonManager.executeRevaluePlayerUp(revaluePlayerUpDTO);
        };
        case _ {}
      };
    };

    public shared query ({ caller }) func validateRevaluePlayerDown(revaluePlayerDownDTO : DTOs.RevaluePlayerDownDTO) : async T.RustResult {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      return #Err("Governance on hold due to network issues");
      //return seasonManager.validateRevaluePlayerDown(revaluePlayerDownDTO);
    };

    public shared ({ caller }) func executeRevaluePlayerDown(revaluePlayerDownDTO : DTOs.RevaluePlayerDownDTO) : async () {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      assert isDataAdmin(Principal.toText(caller));
      switch(await seasonManager.validateRevaluePlayerDown(revaluePlayerDownDTO)){
        case (#ok success){
          let _ = await seasonManager.executeRevaluePlayerDown(revaluePlayerDownDTO);
        };
        case _ {}
      };
    };

    public shared query ({ caller }) func validateSubmitFixtureData(submitFixtureData : DTOs.SubmitFixtureDataDTO) : async T.RustResult {
      Debug.print(debug_show submitFixtureData);
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      return #Err("Governance on hold due to network issues");
      //return seasonManager.validateSubmitFixtureData(submitFixtureData);
    };

    public shared ({ caller }) func executeSubmitFixtureData(submitFixtureData : DTOs.SubmitFixtureDataDTO) : async () {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      assert isDataAdmin(Principal.toText(caller));
      switch(await seasonManager.validateSubmitFixtureData(submitFixtureData)){
        case (#ok success){
          let _ = await seasonManager.executeSubmitFixtureData(submitFixtureData);
        };
        case _ {}
      };
    };

    public shared query ({ caller }) func validateAddInitialFixtures(addInitialFixturesDTO : DTOs.AddInitialFixturesDTO) : async T.RustResult {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID; 
      return #Err("Governance on hold due to network issues");   
      //return seasonManager.validateAddInitialFixtures(addInitialFixturesDTO);
    };

    public shared ({ caller }) func executeAddInitialFixtures(addInitialFixturesDTO : DTOs.AddInitialFixturesDTO) : async () {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      assert isDataAdmin(Principal.toText(caller));
      switch(await seasonManager.validateAddInitialFixtures(addInitialFixturesDTO)){
        case (#ok success){
          let _ = await seasonManager.executeAddInitialFixtures(addInitialFixturesDTO);
        };
        case _ {}
      };
    };

    public shared query ({ caller }) func validateMoveFixture(moveFixtureDTO : DTOs.MoveFixtureDTO) : async T.RustResult {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      return #Err("Governance on hold due to network issues");
      //return seasonManager.validateMoveFixture(moveFixtureDTO);
    };

    public shared ({ caller }) func executeMoveFixture(moveFixtureDTO : DTOs.MoveFixtureDTO) : async () {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      assert isDataAdmin(Principal.toText(caller));
      switch(await seasonManager.validateMoveFixture(moveFixtureDTO)){
        case (#ok success){
          let _ = await seasonManager.executeMoveFixture(moveFixtureDTO);
        };
        case _ {}
      };
    };

    public shared query ({ caller }) func validatePostponeFixture(postponeFixtureDTO : DTOs.PostponeFixtureDTO) : async T.RustResult {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      return #Err("Governance on hold due to network issues");
      //return seasonManager.validatePostponeFixture(postponeFixtureDTO);
    };

    public shared ({ caller }) func executePostponeFixture(postponeFixtureDTO : DTOs.PostponeFixtureDTO) : async () {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      assert isDataAdmin(Principal.toText(caller));
      switch(await seasonManager.validatePostponeFixture(postponeFixtureDTO)){
        case (#ok success){
          let _ =  await seasonManager.executePostponeFixture(postponeFixtureDTO);
        };
        case _ {}
      };
    };

    public shared query ({ caller }) func validateRescheduleFixture(rescheduleFixtureDTO : DTOs.RescheduleFixtureDTO) : async T.RustResult {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      return #Err("Governance on hold due to network issues");
      //return await seasonManager.validateRescheduleFixture(rescheduleFixtureDTO);
    };

    public shared ({ caller }) func executeRescheduleFixture(rescheduleFixtureDTO : DTOs.RescheduleFixtureDTO) : async () {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      assert isDataAdmin(Principal.toText(caller));
      switch(await seasonManager.validateRescheduleFixture(rescheduleFixtureDTO)){
        case (#ok success){
          let _ = await seasonManager.executeRescheduleFixture(rescheduleFixtureDTO);
        };
        case _ {}
      };
    };

    public shared query ({ caller }) func validateLoanPlayer(loanPlayerDTO : DTOs.LoanPlayerDTO) : async T.RustResult {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      return #Err("Governance on hold due to network issues");
      //return seasonManager.validateLoanPlayer(loanPlayerDTO);
    };

    public shared ({ caller }) func executeLoanPlayer(loanPlayerDTO : DTOs.LoanPlayerDTO) : async () {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      assert isDataAdmin(Principal.toText(caller));
      switch(await seasonManager.validateLoanPlayer(loanPlayerDTO)){
        case (#ok success){
          let _ = await seasonManager.executeLoanPlayer(loanPlayerDTO);
        };
        case _ {}
      };
    };

    public shared query ({ caller }) func validateTransferPlayer(transferPlayerDTO : DTOs.TransferPlayerDTO) : async T.RustResult {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      return #Err("Governance on hold due to network issues");
      //return seasonManager.validateTransferPlayer(transferPlayerDTO);
    };

    public shared ({ caller }) func executeTransferPlayer(transferPlayerDTO : DTOs.TransferPlayerDTO) : async () {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      assert isDataAdmin(Principal.toText(caller));
      switch(await seasonManager.validateTransferPlayer(transferPlayerDTO)){
        case (#ok success){
          let _ = await seasonManager.executeTransferPlayer(transferPlayerDTO);
        };
        case _ {}
      };
    };

    public shared query ({ caller }) func validateRecallPlayer(recallPlayerDTO : DTOs.RecallPlayerDTO) : async T.RustResult {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      return #Err("Governance on hold due to network issues");
      //return seasonManager.validateRecallPlayer(recallPlayerDTO);
    };

    public shared ({ caller }) func executeRecallPlayer(recallPlayerDTO : DTOs.RecallPlayerDTO) : async () {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      assert isDataAdmin(Principal.toText(caller));
      switch(await seasonManager.validateRecallPlayer(recallPlayerDTO)){
        case (#ok success){
          let _ = await seasonManager.executeRecallPlayer(recallPlayerDTO);
        };
        case _ {}
      };
    };

    public shared query ({ caller }) func validateCreatePlayer(createPlayerDTO : DTOs.CreatePlayerDTO) : async T.RustResult {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      return #Err("Governance on hold due to network issues");
      //return seasonManager.validateCreatePlayer(createPlayerDTO);
    };

    public shared ({ caller }) func executeCreatePlayer(createPlayerDTO : DTOs.CreatePlayerDTO) : async () {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      assert isDataAdmin(Principal.toText(caller));
      switch(await seasonManager.validateCreatePlayer(createPlayerDTO)){
        case (#ok success){
          let _ = await seasonManager.executeCreatePlayer(createPlayerDTO);
        };
        case _ {}
      };
    };

    public shared query ({ caller }) func validateUpdatePlayer(updatePlayerDTO : DTOs.UpdatePlayerDTO) : async T.RustResult {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      return #Err("Governance on hold due to network issues");
      //return seasonManager.validateUpdatePlayer(updatePlayerDTO);
    };

    public shared ({ caller }) func executeUpdatePlayer(updatePlayerDTO : DTOs.UpdatePlayerDTO) : async () {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      assert isDataAdmin(Principal.toText(caller));
      switch(await seasonManager.validateUpdatePlayer(updatePlayerDTO)){
        case (#ok success){
          let _ = await seasonManager.executeUpdatePlayer(updatePlayerDTO);
        };
        case _ {}
      };
    };

    public shared query ({ caller }) func validateSetPlayerInjury(setPlayerInjuryDTO : DTOs.SetPlayerInjuryDTO) : async T.RustResult {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      return #Err("Governance on hold due to network issues");
      //return seasonManager.validateSetPlayerInjury(setPlayerInjuryDTO);
    };

    public shared ({ caller }) func executeSetPlayerInjury(setPlayerInjuryDTO : DTOs.SetPlayerInjuryDTO) : async () {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      assert isDataAdmin(Principal.toText(caller));
      switch(await seasonManager.validateSetPlayerInjury(setPlayerInjuryDTO)){
        case (#ok success){
          let _ = await seasonManager.executeSetPlayerInjury(setPlayerInjuryDTO);
        };
        case _ {}
      };
    };

    public shared query ({ caller }) func validateRetirePlayer(retirePlayerDTO : DTOs.RetirePlayerDTO) : async T.RustResult {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      return #Err("Governance on hold due to network issues");
      //return seasonManager.validateRetirePlayer(retirePlayerDTO);
    };

    public shared ({ caller }) func executeRetirePlayer(retirePlayerDTO : DTOs.RetirePlayerDTO) : async () {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      assert isDataAdmin(Principal.toText(caller));
      switch(await seasonManager.validateRetirePlayer(retirePlayerDTO)){
        case (#ok success){
          let _ = await seasonManager.executeRetirePlayer(retirePlayerDTO);
        };
        case _ {}
      };
    };

    public shared query ({ caller }) func validateUnretirePlayer(unretirePlayerDTO : DTOs.UnretirePlayerDTO) : async T.RustResult {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      return #Err("Governance on hold due to network issues");
      //return seasonManager.validateUnretirePlayer(unretirePlayerDTO);
    };

    public shared ({ caller }) func executeUnretirePlayer(unretirePlayerDTO : DTOs.UnretirePlayerDTO) : async () {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      assert isDataAdmin(Principal.toText(caller));
      switch(await seasonManager.validateUnretirePlayer(unretirePlayerDTO)){
        case (#ok success){
          let _ = await seasonManager.executeUnretirePlayer(unretirePlayerDTO);
        };
        case _ {}
      };
    };

    public shared query ({ caller }) func validatePromoteFormerClub(promoteFormerClubDTO : DTOs.PromoteFormerClubDTO) : async T.RustResult {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      return #Err("Governance on hold due to network issues");
      //return seasonManager.validatePromoteFormerClub(promoteFormerClubDTO);
    };

    public shared ({ caller }) func executePromoteFormerClub(promoteFormerClubDTO : DTOs.PromoteFormerClubDTO) : async () {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      assert isDataAdmin(Principal.toText(caller));
      switch(await seasonManager.validatePromoteFormerClub(promoteFormerClubDTO)){
        case (#ok success){
          let _ = await seasonManager.executePromoteFormerClub(promoteFormerClubDTO);
        };
        case _ {}
      };
    };

    public shared query ({ caller }) func validatePromoteNewClub(promoteNewClubDTO : DTOs.PromoteNewClubDTO) : async T.RustResult {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      return #Err("Governance on hold due to network issues");
      //return seasonManager.validatePromoteNewClub(promoteNewClubDTO);
    };

    public shared ({ caller }) func executePromoteNewClub(promoteNewClubDTO : DTOs.PromoteNewClubDTO) : async () {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      assert isDataAdmin(Principal.toText(caller));
      switch(await seasonManager.validatePromoteNewClub(promoteNewClubDTO)){
        case (#ok success){
          let _ = await seasonManager.executePromoteNewClub(promoteNewClubDTO);
        };
        case _ {}
      };
    };

    public shared query ({ caller }) func validateUpdateClub(updateClubDTO : DTOs.UpdateClubDTO) : async T.RustResult {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      return #Err("Governance on hold due to network issues");
      //return seasonManager.validateUpdateClub(updateClubDTO);
    };

    public shared ({ caller }) func executeUpdateClub(updateClubDTO : DTOs.UpdateClubDTO) : async () {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      assert isDataAdmin(Principal.toText(caller));
      switch(await seasonManager.validateUpdateClub(updateClubDTO)){
        case (#ok success){
          let _ = await seasonManager.executeUpdateClub(updateClubDTO);
        };
        case _ {}
      };
    };

    //Game logic callback functions

    private func gameweekBeginExpiredCallback() : async () {
      await seasonManager.gameweekBeginExpired();
      removeExpiredTimers();
    };

    private func gameKickOffExpiredCallback() : async () {
      await seasonManager.gameKickOffExpiredCallback();
      removeExpiredTimers();
    };

    private func gameCompletedExpiredCallback() : async () {
      await seasonManager.gameCompletedExpiredCallback();
      removeExpiredTimers();
    };

    private func transferWindowStartCallback() : async () {
      await seasonManager.transferWindowStartCallback();
      removeExpiredTimers();
    };

    private func transferWindowEndCallback() : async () {
      await seasonManager.transferWindowEndCallback();
      removeExpiredTimers();
    };

    //system callback functions

    private func cyclesCheckCallback() : async () {
      await checkCanisterCycles();
    };

    public shared ({ caller }) func searchUsername(dto: DTOs.UsernameFilterDTO) : async Result.Result<DTOs.ManagerDTO, T.Error> {
      assert not Principal.isAnonymous(caller);
      return await seasonManager.getManagerByUsername(dto.username);
    };

    public shared ({ caller }) func getCanisters(dto: DTOs.GetCanistersDTO) : async Result.Result<DTOs.GetCanistersDTO, T.Error> {
      assert not Principal.isAnonymous(caller);

      let root_canister = actor (Environment.SNS_ROOT_CANISTER_ID) : actor {
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
          let uniqueManagerCanisterIds = seasonManager.getStableUniqueManagerCanisterIds();
          for(canisterId in Iter.fromArray(uniqueManagerCanisterIds)){
            let IC : Management.Management = actor (Environment.Default);
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
          let weeklyLeaderboardCanisters = seasonManager.getStableWeeklyLeaderboardCanisters();
          for(weeklyLeaderboardCanister in Iter.fromArray(weeklyLeaderboardCanisters)){
            let IC : Management.Management = actor (Environment.Default);
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
          let monthlyLeaderboardCanisters = seasonManager.getStableMonthlyLeaderboardsCanisters();
          for(monthlyLeaderboardCanister in Iter.fromArray(monthlyLeaderboardCanisters)){
            let IC : Management.Management = actor (Environment.Default);
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
          let seasonLeaderboardCanisters = seasonManager.getStableSeasonLeaderboardCanisters();
          for(seasonLeaderboardCanister in Iter.fromArray(seasonLeaderboardCanisters)){
            let IC : Management.Management = actor (Environment.Default);
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

    public shared ({ caller }) func getTimers(dto: DTOs.GetTimersDTO) : async Result.Result<DTOs.GetTimersDTO, T.Error> {
      assert not Principal.isAnonymous(caller);
      switch(dto.timerTypeFilter){
        case (#LoanComplete){
          let filteredEntries = Array.filter<T.TimerInfo>(timers, func(timer: T.TimerInfo){
            timer.callbackName == "loanExpired";
          });
          let droppedEntries = List.drop<T.TimerInfo>(List.fromArray(filteredEntries), dto.offset);
          let paginatedEntries = List.take<T.TimerInfo>(droppedEntries, dto.limit);
          return #ok({
            limit = dto.limit;
            offset = dto.offset;
            entries = List.toArray(paginatedEntries);
            totalEntries = Array.size(filteredEntries);
            timerTypeFilter = dto.timerTypeFilter;
          });
        };
        case (#GameComplete){
          let filteredEntries = Array.filter<T.TimerInfo>(timers, func(timer: T.TimerInfo){
            timer.callbackName == "gameCompletedExpired";
          });
          let droppedEntries = List.drop<T.TimerInfo>(List.fromArray(filteredEntries), dto.offset);
          let paginatedEntries = List.take<T.TimerInfo>(droppedEntries, dto.limit);
          return #ok({
            limit = dto.limit;
            offset = dto.offset;
            entries = List.toArray(paginatedEntries);
            totalEntries = Array.size(filteredEntries);
            timerTypeFilter = dto.timerTypeFilter;
          });
        };
        case (#GameKickOff){
          let filteredEntries = Array.filter<T.TimerInfo>(timers, func(timer: T.TimerInfo){
            timer.callbackName == "gameKickOffExpired";
          });
          let droppedEntries = List.drop<T.TimerInfo>(List.fromArray(filteredEntries), dto.offset);
          let paginatedEntries = List.take<T.TimerInfo>(droppedEntries, dto.limit);
          return #ok({
            limit = dto.limit;
            offset = dto.offset;
            entries = List.toArray(paginatedEntries);
            totalEntries = Array.size(filteredEntries);
            timerTypeFilter = dto.timerTypeFilter;
          });
        };
        case (#GameweekBegin){
          let filteredEntries = Array.filter<T.TimerInfo>(timers, func(timer: T.TimerInfo){
            timer.callbackName == "gameweekBeginExpired";
          });
          let droppedEntries = List.drop<T.TimerInfo>(List.fromArray(filteredEntries), dto.offset);
          let paginatedEntries = List.take<T.TimerInfo>(droppedEntries, dto.limit);
          return #ok({
            limit = dto.limit;
            offset = dto.offset;
            entries = List.toArray(paginatedEntries);
            totalEntries = Array.size(filteredEntries);
            timerTypeFilter = dto.timerTypeFilter;
          });
        };
        case (#TransferWindow){
          let filteredEntries = Array.filter<T.TimerInfo>(timers, func(timer: T.TimerInfo){
            timer.callbackName == "transferWindowStart" or timer.callbackName == "transferWindowEnd";
          });
          let droppedEntries = List.drop<T.TimerInfo>(List.fromArray(filteredEntries), dto.offset);
          let paginatedEntries = List.take<T.TimerInfo>(droppedEntries, dto.limit);
          return #ok({
            limit = dto.limit;
            offset = dto.offset;
            entries = List.toArray(paginatedEntries);
            totalEntries = Array.size(filteredEntries);
            timerTypeFilter = dto.timerTypeFilter;
          });
        };
        case (#InjuryExpired){
          let filteredEntries = Array.filter<T.TimerInfo>(timers, func(timer: T.TimerInfo){
            timer.callbackName == "injuryExpired";
          });
          let droppedEntries = List.drop<T.TimerInfo>(List.fromArray(filteredEntries), dto.offset);
          let paginatedEntries = List.take<T.TimerInfo>(droppedEntries, dto.limit);
          return #ok({
            limit = dto.limit;
            offset = dto.offset;
            entries = List.toArray(paginatedEntries);
            totalEntries = Array.size(filteredEntries);
            timerTypeFilter = dto.timerTypeFilter;
          });
        }
      };
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

    public shared ({ caller }) func getSystemLog(dto: DTOs.GetSystemLogDTO) : async Result.Result<DTOs.GetSystemLogDTO, T.Error> {
      assert not Principal.isAnonymous(caller);
      if(dto.limit > 0 and (dto.limit < 1 or dto.limit > 100)){
        return #err(#InvalidData);
      };

      var eventLogs: [T.EventLogEntry] = [];

      eventLogs := Array.filter<T.EventLogEntry>(
        stable_event_logs,
        func(eventLog : T.EventLogEntry) : Bool {
          eventLog.eventType == dto.eventType;
        },
      );

      if(dto.dateStart > 0){
        eventLogs := Array.filter<T.EventLogEntry>(
          stable_event_logs,
          func(eventLog : T.EventLogEntry) : Bool {
            eventLog.eventTime >= dto.dateStart;
          },
        );
      };

      if(dto.dateEnd > 0){
        eventLogs := Array.filter<T.EventLogEntry>(
          stable_event_logs,
          func(eventLog : T.EventLogEntry) : Bool {
            eventLog.eventTime >= dto.dateEnd;
          },
        );
      };

      return #ok({
        dateEnd = dto.dateEnd;
        dateStart = dto.dateStart;
        entries = eventLogs;
        limit = dto.limit;
        offset = dto.offset; 
        eventType = dto.eventType;
        totalEntries = Array.size(stable_event_logs);
      });
    };

    private func recordSystemEvent(eventLog: T.EventLogEntry){
      let eventsBuffer = Buffer.fromArray<T.EventLogEntry>(stable_event_logs);
      eventsBuffer.add({
        eventDetail = eventLog.eventDetail;
        eventId = stable_next_system_event_id;
        eventTime = eventLog.eventTime;
        eventTitle = eventLog.eventTitle;
        eventType = eventLog.eventType;
      }); 
      stable_event_logs := Buffer.toArray(eventsBuffer);
      stable_next_system_event_id += 1;
    };


    //Stable variables backup:

    //event logs
    private stable var stable_event_logs: [T.EventLogEntry] = [];
    private stable var stable_next_system_event_id: Nat = 1;

    //Season Manager
    private stable var stable_reward_pools : [(T.SeasonId, T.RewardPool)] = [];
    private stable var stable_system_state : T.SystemState = {
      calculationGameweek = 6;
      calculationMonth = 9;
      calculationSeasonId = 1;
      pickTeamGameweek = 6;
      pickTeamSeasonId = 1;
      homepageFixturesGameweek = 6;
      homepageManagerGameweek = 6;
      seasonActive = true;
      transferWindowActive = false;
      onHold = false;
      version = "V1.8.0";
    };
    private stable var stable_data_cache_hashes : [T.DataCache] = [];

    //Manager Composite
    private stable var stable_manager_canister_ids : [(T.PrincipalId, T.CanisterId)] = [];
    private stable var stable_manager_usernames : [(T.PrincipalId, Text)] = [];
    private stable var stable_unique_manager_canister_ids : [T.CanisterId] = [];
    private stable var stable_total_managers : Nat = 0;
    private stable var stable_active_manager_canister_id : Text = "";

    //Rewards
    private stable var stable_team_value_leaderboards : [(T.SeasonId, T.TeamValueLeaderboard)] = [];
    private stable var stable_season_rewards : [T.SeasonRewards] = [];
    private stable var stable_monthly_rewards : [T.MonthlyRewards] = [];
    private stable var stable_weekly_rewards : [T.WeeklyRewards] = [];
    private stable var stable_most_valuable_team_rewards : [T.RewardsList] = [];
    private stable var stable_highest_scoring_player_rewards : [T.RewardsList] = [];
    private stable var stable_weekly_ath_scores : [T.HighScoreRecord] = [];
    private stable var stable_monthly_ath_scores : [T.HighScoreRecord] = [];
    private stable var stable_season_ath_scores : [T.HighScoreRecord] = [];
    private stable var stable_weekly_ath_prize_pool : Nat64 = 0;
    private stable var stable_monthly_ath_prize_pool : Nat64 = 0;
    private stable var stable_season_ath_prize_pool : Nat64 = 0;

    //Player Composite
    private stable var stable_next_player_id : T.PlayerId = 1;
    private stable var stable_players : [T.Player] = [];

    //Club Composite
    private stable var stable_clubs : [T.Club] = [];
    private stable var stable_relegated_clubs : [T.Club] = [];
    private stable var stable_next_club_id : T.ClubId = 1;

    //Season Composite
    private stable var stable_seasons : [T.Season] = [];
    private stable var stable_next_season_id : T.SeasonId = 1;
    private stable var stable_next_fixture_id : T.FixtureId = 1;

    //Leaderboard Composite
    private stable var stable_season_leaderboard_canisters : [T.SeasonLeaderboardCanister] = [];
    private stable var stable_monthly_leaderboards_canisters : [T.MonthlyLeaderboardsCanister] = [];
    private stable var stable_weekly_leaderboard_canisters : [T.WeeklyLeaderboardCanister] = [];

    private stable var stable_timers : [T.TimerInfo] = [];
    private stable var stable_topups : [T.CanisterTopup] = [];

    private stable var stable_token_list: [T.TokenInfo] = [];
    private stable var stable_next_token_id : Nat16 = 0;

    system func preupgrade() {
      stable_reward_pools := seasonManager.getStableRewardPools();
      stable_system_state := seasonManager.getStableSystemState();
      stable_data_cache_hashes := seasonManager.getStableDataHashes();

      //Manager Composite
      stable_manager_canister_ids := seasonManager.getStableManagerCanisterIds();
      stable_manager_usernames := seasonManager.getStableManagerUsernames();
      stable_unique_manager_canister_ids := seasonManager.getStableUniqueManagerCanisterIds();
      stable_total_managers := seasonManager.getStableTotalManagers();
      stable_active_manager_canister_id := seasonManager.getStableActiveManagerCanisterId();

      //Rewards
      stable_team_value_leaderboards := seasonManager.getStableTeamValueLeaderboards();
      stable_season_rewards := seasonManager.getStableSeasonRewards();
      stable_monthly_rewards := seasonManager.getStableMonthlyRewards();
      stable_weekly_rewards := seasonManager.getStableWeeklyRewards();
      stable_most_valuable_team_rewards := seasonManager.getStableMostValuableTeamRewards();
      stable_highest_scoring_player_rewards := seasonManager.getStableHighestScoringPlayerRewards();
      stable_weekly_ath_scores := seasonManager.getStableWeeklyATHScores();
      stable_monthly_ath_scores := seasonManager.getStableMonthlyATHScores();
      stable_season_ath_scores := seasonManager.getStableSeasonATHScores();
      stable_weekly_ath_prize_pool := seasonManager.getStableWeeklyATHPrizePool();
      stable_monthly_ath_prize_pool := seasonManager.getStableMonthlyATHPrizePool();
      stable_season_ath_prize_pool := seasonManager.getStableSeasonATHPrizePool();

      //Leaderboard Composite
      stable_season_leaderboard_canisters := seasonManager.getStableSeasonLeaderboardCanisters();
      stable_monthly_leaderboards_canisters := seasonManager.getStableMonthlyLeaderboardsCanisters();
      stable_weekly_leaderboard_canisters := seasonManager.getStableWeeklyLeaderboardCanisters();

      stable_timers := timers;
      stable_topups := cyclesDispenser.getStableTopups();

      stable_token_list := treasuryManager.getStableTokenList();
      stable_next_token_id := treasuryManager.getStableNextTokenId();
    };

    system func postupgrade() {
      
      seasonManager.setStableRewardPools(stable_reward_pools);
      seasonManager.setStableDataHashes(stable_data_cache_hashes);
      seasonManager.setStableSystemState(stable_system_state);

      //Manager Composite
      seasonManager.setStableManagerCanisterIds(stable_manager_canister_ids);
      seasonManager.setStableManagerUsernames(stable_manager_usernames);
      seasonManager.setStableUniqueManagerCanisterIds(stable_unique_manager_canister_ids);
      seasonManager.setStableTotalManagers(stable_total_managers);
      seasonManager.setStableActiveManagerCanisterId(stable_active_manager_canister_id);

      //Rewards
      seasonManager.setStableTeamValueLeaderboards(stable_team_value_leaderboards);
      seasonManager.setStableSeasonRewards(stable_season_rewards);
      seasonManager.setStableMonthlyRewards(stable_monthly_rewards);
      seasonManager.setStableWeeklyRewards(stable_weekly_rewards);
      seasonManager.setStableMostValuableTeamRewards(stable_most_valuable_team_rewards);
      seasonManager.setStableHighestScoringPlayerRewards(stable_highest_scoring_player_rewards);
      seasonManager.setStableWeeklyATHScores(stable_weekly_ath_scores);
      seasonManager.setStableMonthlyATHScores(stable_monthly_ath_scores);
      seasonManager.setStableSeasonATHScores(stable_season_ath_scores);
      seasonManager.setStableWeeklyATHPrizePool(stable_weekly_ath_prize_pool);
      seasonManager.setStableMonthlyATHPrizePool(stable_monthly_ath_prize_pool);
      seasonManager.setStableSeasonATHPrizePool(stable_season_ath_prize_pool);

      //Leaderboard Composite
      seasonManager.setStableSeasonLeaderboardCanisters(stable_season_leaderboard_canisters);
      seasonManager.setStableMonthlyLeaderboardsCanisters(stable_monthly_leaderboards_canisters);
      seasonManager.setStableWeeklyLeaderboardCanisters(stable_weekly_leaderboard_canisters);

      cyclesDispenser.setStableTopups(stable_topups);
      cyclesDispenser.setRecordSystemEventFunction(recordSystemEvent);

      seasonManager.setBackendCanisterController(Principal.fromActor(Self));
      seasonManager.setTimerBackupFunction(setAndBackupTimer, removeExpiredTimers);
      seasonManager.setRecordSystemEventFunction(recordSystemEvent);

      //Treasury Manager
      treasuryManager.setStableTokenList(stable_token_list);
      treasuryManager.setStableNextTokenId(stable_next_token_id);

      timers := stable_timers;
      
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
      ignore Timer.setTimer<system>(#nanoseconds(Int.abs(1)), postUpgradeCallback);
    };
    
    public shared ({ caller }) func setupTesting () : async (){
      Debug.print("SETTING UP TESTING");
    };


    private func postUpgradeCallback() : async (){

      //await updateManagerCanisterWasms();
      
      if(not alreadyInitialisedData){
        seasonManager.initialiseData();
        alreadyInitialisedData := true;
      };
      
      //await seasonManager.removeLeaderboardCanistersAndGetCycles();
      //await logStatus({message = "Leaderboard canisters removed "});

      //set version
      await seasonManager.setVersion("V1.8.0");
      
      //on each update generate new hash values
      await seasonManager.updateCacheHash("clubs");
      await seasonManager.updateCacheHash("fixtures");
      await seasonManager.updateCacheHash("weekly_leaderboard");
      await seasonManager.updateCacheHash("monthly_leaderboards");
      await seasonManager.updateCacheHash("season_leaderboard");
      await seasonManager.updateCacheHash("players");
      await seasonManager.updateCacheHash("player_events");
      await seasonManager.updateCacheHash("countries");
      await seasonManager.updateCacheHash("system_state");

      await cyclesCheckCallback(); 
    };

    private func updateManagerCanisterWasms() : async (){
      let managerCanisterIds = seasonManager.getManagerCanisterIds();
      Debug.print("manager canister ids");
      Debug.print(debug_show managerCanisterIds);
      let IC : Management.Management = actor (Environment.Default);
      for(canisterId in Iter.fromArray(managerCanisterIds)){
        Debug.print(debug_show canisterId);
        await IC.stop_canister({ canister_id = Principal.fromText(canisterId); });
        Debug.print("could stop it");
        
        let oldManagement = actor (canisterId) : actor {};
        let _ = await (system ManagerCanister._ManagerCanister)(#upgrade oldManagement)();
        Debug.print("couldn't upgrade it");
        Debug.print("debug_show");
        await IC.start_canister({ canister_id = Principal.fromText(canisterId); });
      };
    };

    public shared ({ caller }) func logStatus (dto: DTOs.LogStatusDTO) : async (){
      assert not Principal.isAnonymous(caller);

      recordSystemEvent({
        eventDetail = dto.message; 
        eventId = 0;
        eventTime = Time.now();
        eventTitle = "Canister Log";
        eventType = #SystemCheck;
      });
    };
    
    //Canister cycle topup functions
 
    public shared ({ caller }) func requestCanisterTopup(cycles: Nat) : async () {
      assert not Principal.isAnonymous(caller);
      let principalId = Principal.toText(caller);

      let managerCanisterIds = await getManagerCanisterIds();
      let foundManagerCanisterId = Array.find(managerCanisterIds, func(canisterId: T.CanisterId) : Bool{
        canisterId == principalId
      });

      if(Option.isSome(foundManagerCanisterId)){
        await cyclesDispenser.requestCanisterTopup(principalId, cycles);
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

    private var timers : [T.TimerInfo] = [];
    
    public func setTimer(time : Int, callbackName : Text) : async () {
      let duration : Timer.Duration = #seconds(Int.abs(time - Time.now()));
      await setAndBackupTimer(duration, callbackName);
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

    //status functions
    public func getManagerCanisterIds() : async [T.CanisterId] {
      return seasonManager.getManagerCanisterIds();
    };

    public func getActiveManagerCanisterId() : async T.CanisterId {
      return seasonManager.getActiveManagerCanisterId();
    };

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
