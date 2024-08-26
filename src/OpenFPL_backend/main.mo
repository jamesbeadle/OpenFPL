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
  import NeuronTypes "../neuron_controller/types";
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

    public shared func getMonthlyLeaderboards(dto: DTOs.GetMonthlyLeaderboardsDTO) : async Result.Result<[DTOs.ClubLeaderboardDTO], T.Error> {
      return await seasonManager.getMonthlyLeaderboards(dto);
    };

    public shared func getMonthlyLeaderboard(dto: DTOs.GetMonthlyLeaderboardDTO) : async Result.Result<DTOs.MonthlyLeaderboardDTO, T.Error> {
      return await seasonManager.getMonthlyLeaderboard(dto);
    };

    public shared func getSeasonLeaderboard(dto: DTOs.GetSeasonLeaderboardDTO) : async Result.Result<DTOs.SeasonLeaderboardDTO, T.Error> {
      return await seasonManager.getSeasonLeaderboard(dto);
    };


    //Query functions:

    public shared query func getClubs() : async Result.Result<[DTOs.ClubDTO], T.Error> {
      return #ok(seasonManager.getClubs());
    };

    public shared query func getFormerClubs() : async Result.Result<[DTOs.ClubDTO], T.Error> {
      return #ok(seasonManager.getFormerClubs());
    };

    public shared query func getDataHashes() : async Result.Result<[DTOs.DataCacheDTO], T.Error> {
      return #ok(seasonManager.getDataHashes());
    };

    public shared query func getFixtures(dto: DTOs.GetFixturesDTO) : async Result.Result<[DTOs.FixtureDTO], T.Error> {
      return #ok(seasonManager.getFixtures(dto));
    };

    public shared query func getSeasons() : async Result.Result<[DTOs.SeasonDTO], T.Error> {
      return #ok(seasonManager.getSeasons());
    };

    public shared query func getPostponedFixtures() : async Result.Result<[DTOs.FixtureDTO], T.Error> {
      return #ok(seasonManager.getPostponedFixtures());
    };

    public shared query func getTotalManagers() : async Result.Result<Nat, T.Error> {
      return #ok(seasonManager.getTotalManagers());
    };

    public shared query func getSystemState() : async Result.Result<DTOs.SystemStateDTO, T.Error> {
      return #ok(seasonManager.getSystemState());
    };

    public shared query func getPlayers() : async Result.Result<[DTOs.PlayerDTO], T.Error> {
      return #ok(seasonManager.getPlayers());
    };

    public shared query func getLoanedPlayers(dto: DTOs.ClubFilterDTO) : async Result.Result<[DTOs.PlayerDTO], T.Error> {
      return #ok(seasonManager.getLoanedPlayers(dto));
    };

    public shared query func getRetiredPlayers(dto: DTOs.ClubFilterDTO) : async Result.Result<[DTOs.PlayerDTO], T.Error> {
      return #ok(seasonManager.getRetiredPlayers(dto));
    };

    public shared query func getPlayerDetailsForGameweek(dto: DTOs.GameweekFiltersDTO) : async Result.Result<[DTOs.PlayerPointsDTO], T.Error> {
      return #ok(seasonManager.getPlayerDetailsForGameweek(dto));
    };

    public shared query func getPlayersMap(dto: DTOs.GameweekFiltersDTO) : async Result.Result<[(Nat16, DTOs.PlayerScoreDTO)], T.Error> {
      return #ok(seasonManager.getPlayersMap(dto));
    };

    public shared query func getPlayerDetails(dto: DTOs.GetPlayerDetailsDTO) : async Result.Result<DTOs.PlayerDetailDTO, T.Error> {
      return #ok(seasonManager.getPlayerDetails(dto));
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
      
      //Todo when functionality available: Make cross subnet call to governance canister to see if proposal exists

      return seasonManager.validateRevaluePlayerUp(revaluePlayerUpDTO);
    };

    public shared ({ caller }) func executeRevaluePlayerUp(revaluePlayerUpDTO : DTOs.RevaluePlayerUpDTO) : async () {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      return await seasonManager.executeRevaluePlayerUp(revaluePlayerUpDTO);
    };

    public shared query ({ caller }) func validateRevaluePlayerDown(revaluePlayerDownDTO : DTOs.RevaluePlayerDownDTO) : async T.RustResult {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      return seasonManager.validateRevaluePlayerDown(revaluePlayerDownDTO);
    };

    public shared ({ caller }) func executeRevaluePlayerDown(revaluePlayerDownDTO : DTOs.RevaluePlayerDownDTO) : async () {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      return await seasonManager.executeRevaluePlayerDown(revaluePlayerDownDTO);
    };

    public shared query ({ caller }) func validateSubmitFixtureData(submitFixtureData : DTOs.SubmitFixtureDataDTO) : async T.RustResult {
      Debug.print(debug_show submitFixtureData);
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      return seasonManager.validateSubmitFixtureData(submitFixtureData);
    };

    public shared ({ caller }) func executeSubmitFixtureData(submitFixtureData : DTOs.SubmitFixtureDataDTO) : async () {
      Debug.print(debug_show submitFixtureData);
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      return await seasonManager.executeSubmitFixtureData(submitFixtureData);
    };

    public shared query ({ caller }) func validateAddInitialFixtures(addInitialFixturesDTO : DTOs.AddInitialFixturesDTO) : async T.RustResult {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;    
      return seasonManager.validateAddInitialFixtures(addInitialFixturesDTO);
    };

    public shared ({ caller }) func executeAddInitialFixtures(addInitialFixturesDTO : DTOs.AddInitialFixturesDTO) : async () {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      return await seasonManager.executeAddInitialFixtures(addInitialFixturesDTO);
    };

    public shared query ({ caller }) func validateMoveFixture(moveFixtureDTO : DTOs.MoveFixtureDTO) : async T.RustResult {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      return seasonManager.validateMoveFixture(moveFixtureDTO);
    };

    public shared ({ caller }) func executeMoveFixture(moveFixtureDTO : DTOs.MoveFixtureDTO) : async () {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      return await seasonManager.executeMoveFixture(moveFixtureDTO);
    };

    public shared query ({ caller }) func validatePostponeFixture(postponeFixtureDTO : DTOs.PostponeFixtureDTO) : async T.RustResult {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      return seasonManager.validatePostponeFixture(postponeFixtureDTO);
    };

    public shared ({ caller }) func executePostponeFixture(postponeFixtureDTO : DTOs.PostponeFixtureDTO) : async () {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      return await seasonManager.executePostponeFixture(postponeFixtureDTO);
    };

    public shared query ({ caller }) func validateRescheduleFixture(rescheduleFixtureDTO : DTOs.RescheduleFixtureDTO) : async T.RustResult {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      return seasonManager.validateRescheduleFixture(rescheduleFixtureDTO);
    };

    public shared ({ caller }) func executeRescheduleFixture(rescheduleFixtureDTO : DTOs.RescheduleFixtureDTO) : async () {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      return await seasonManager.executeRescheduleFixture(rescheduleFixtureDTO);
    };

    public shared query ({ caller }) func validateLoanPlayer(loanPlayerDTO : DTOs.LoanPlayerDTO) : async T.RustResult {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      return seasonManager.validateLoanPlayer(loanPlayerDTO);
    };

    public shared ({ caller }) func executeLoanPlayer(loanPlayerDTO : DTOs.LoanPlayerDTO) : async () {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      return await seasonManager.executeLoanPlayer(loanPlayerDTO);
    };

    public shared query ({ caller }) func validateTransferPlayer(transferPlayerDTO : DTOs.TransferPlayerDTO) : async T.RustResult {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      return seasonManager.validateTransferPlayer(transferPlayerDTO);
    };

    public shared ({ caller }) func executeTransferPlayer(transferPlayerDTO : DTOs.TransferPlayerDTO) : async () {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      return await seasonManager.executeTransferPlayer(transferPlayerDTO);
    };

    public shared query ({ caller }) func validateRecallPlayer(recallPlayerDTO : DTOs.RecallPlayerDTO) : async T.RustResult {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      return seasonManager.validateRecallPlayer(recallPlayerDTO);
    };

    public shared ({ caller }) func executeRecallPlayer(recallPlayerDTO : DTOs.RecallPlayerDTO) : async () {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      return await seasonManager.executeRecallPlayer(recallPlayerDTO);
    };

    public shared query ({ caller }) func validateCreatePlayer(createPlayerDTO : DTOs.CreatePlayerDTO) : async T.RustResult {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      return seasonManager.validateCreatePlayer(createPlayerDTO);
    };

    public shared ({ caller }) func executeCreatePlayer(createPlayerDTO : DTOs.CreatePlayerDTO) : async () {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      return await seasonManager.executeCreatePlayer(createPlayerDTO);
    };

    public shared query ({ caller }) func validateUpdatePlayer(updatePlayerDTO : DTOs.UpdatePlayerDTO) : async T.RustResult {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      return seasonManager.validateUpdatePlayer(updatePlayerDTO);
    };

    public shared ({ caller }) func executeUpdatePlayer(updatePlayerDTO : DTOs.UpdatePlayerDTO) : async () {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      return await seasonManager.executeUpdatePlayer(updatePlayerDTO);
    };

    public shared query ({ caller }) func validateSetPlayerInjury(setPlayerInjuryDTO : DTOs.SetPlayerInjuryDTO) : async T.RustResult {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      return seasonManager.validateSetPlayerInjury(setPlayerInjuryDTO);
    };

    public shared ({ caller }) func executeSetPlayerInjury(setPlayerInjuryDTO : DTOs.SetPlayerInjuryDTO) : async () {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      return await seasonManager.executeSetPlayerInjury(setPlayerInjuryDTO);
    };

    public shared query ({ caller }) func validateRetirePlayer(retirePlayerDTO : DTOs.RetirePlayerDTO) : async T.RustResult {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      return seasonManager.validateRetirePlayer(retirePlayerDTO);
    };

    public shared ({ caller }) func executeRetirePlayer(retirePlayerDTO : DTOs.RetirePlayerDTO) : async () {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      return await seasonManager.executeRetirePlayer(retirePlayerDTO);
    };

    public shared query ({ caller }) func validateUnretirePlayer(unretirePlayerDTO : DTOs.UnretirePlayerDTO) : async T.RustResult {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      return seasonManager.validateUnretirePlayer(unretirePlayerDTO);
    };

    public shared ({ caller }) func executeUnretirePlayer(unretirePlayerDTO : DTOs.UnretirePlayerDTO) : async () {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      return await seasonManager.executeUnretirePlayer(unretirePlayerDTO);
    };

    public shared query ({ caller }) func validatePromoteFormerClub(promoteFormerClubDTO : DTOs.PromoteFormerClubDTO) : async T.RustResult {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      return seasonManager.validatePromoteFormerClub(promoteFormerClubDTO);
    };

    public shared ({ caller }) func executePromoteFormerClub(promoteFormerClubDTO : DTOs.PromoteFormerClubDTO) : async () {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      return await seasonManager.executePromoteFormerClub(promoteFormerClubDTO);
    };

    public shared query ({ caller }) func validatePromoteNewClub(promoteNewClubDTO : DTOs.PromoteNewClubDTO) : async T.RustResult {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      return seasonManager.validatePromoteNewClub(promoteNewClubDTO);
    };

    public shared ({ caller }) func executePromoteNewClub(promoteNewClubDTO : DTOs.PromoteNewClubDTO) : async () {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      return await seasonManager.executePromoteNewClub(promoteNewClubDTO);
    };

    public shared query ({ caller }) func validateUpdateClub(updateClubDTO : DTOs.UpdateClubDTO) : async T.RustResult {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      return seasonManager.validateUpdateClub(updateClubDTO);
    };

    public shared ({ caller }) func executeUpdateClub(updateClubDTO : DTOs.UpdateClubDTO) : async () {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      return await seasonManager.executeUpdateClub(updateClubDTO);
    };

    public shared query ({ caller }) func validateManageDAONeuron(command : NeuronTypes.Command) : async T.RustResult {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      if (not neuronCreated) {
        return #Err("Neuron not created");
      };

      //Just to remove unused warning but ensure signatures match, as this is a query function it does nothing
      neuronCommand := ?command;

      return #Ok("Proposal Valid");
    };

    public shared ({ caller }) func executeManageDAONeuron(command : NeuronTypes.Command) : async () {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      if (not neuronCreated) {
        return;
      };

      let neuron_controller = actor (Environment.NEURON_CONTROLLER_CANISTER_ID) : actor {
        manage_neuron : NeuronTypes.Command -> async ?NeuronTypes.Response;
      };

      let _ = await neuron_controller.manage_neuron(command);

      neuronCreated := true;
    };

    public shared query ({ caller }) func validateAddNewToken(newTokenDTO : DTOs.NewTokenDTO) : async T.RustResult {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      return treasuryManager.validateAddNewToken(newTokenDTO);
    };

    public shared ({ caller }) func executeAddNewToken(newTokenDTO : DTOs.NewTokenDTO) : async () {
      assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
      return await treasuryManager.executeAddNewToken(newTokenDTO);
    };

    
    //Function to get the neuron controller neuron id
    
    public shared func getNeuronId() : async Nat64 {
      let neuron_controller = actor (Environment.NEURON_CONTROLLER_CANISTER_ID) : actor {
        getNeuronId : () -> async Nat64;
      };

      return await neuron_controller.getNeuronId();
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

    private func loanExpiredCallback() : async () {
      await seasonManager.loanExpiredCallback();
      removeExpiredTimers();
    };

    private func injuryExpiredCallback() : async () {
      await seasonManager.injuryExpiredCallback();
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

    private func systemCheckCallback() : async () {
      await checkSystem();
    };

    //Private league functions
    
    public shared ({ caller }) func getManagerPrivateLeagues() : async Result.Result<DTOs.ManagerPrivateLeaguesDTO, T.Error> {
      assert not Principal.isAnonymous(caller);
      let managerId = Principal.toText(caller);
      let user = await seasonManager.getManager({managerId});

      let systemState = await getSystemState();
      switch(systemState){
        case (#ok foundState){

          switch(user){
            case (#ok managerDTO){
              let privateLeaguesBuffer = Buffer.fromArray<DTOs.ManagerPrivateLeagueDTO>([]);
              for(privateLeagueCanisterId in Iter.fromArray(managerDTO.privateLeagueMemberships)){
                let private_league_canister = actor (privateLeagueCanisterId) : actor {
                  getManagerPrivateLeague : (managerId: T.PrincipalId, filters: DTOs.GameweekFiltersDTO) -> async DTOs.ManagerPrivateLeagueDTO;
                };
                let privateLeague = await private_league_canister.getManagerPrivateLeague(managerId, {seasonId = foundState.calculationSeasonId; gameweek = foundState.calculationGameweek});
                privateLeaguesBuffer.add({
                  canisterId = privateLeagueCanisterId;
                  created = privateLeague.created;
                  memberCount = privateLeague.memberCount;
                  name = managerDTO.username;
                  seasonPosition = privateLeague.seasonPosition;
                  seasonPositionText = privateLeague.seasonPositionText;
                });
              };
                
              let privateLeagues: DTOs.ManagerPrivateLeaguesDTO = {
                entries = Buffer.toArray(privateLeaguesBuffer);
                totalEntries = privateLeaguesBuffer.size();
              };
              return #ok(privateLeagues);
            };
            case _ { return #err(#NotFound)};
          };

        };
        case _ {
          return #err(#NotFound)
        };
      };
    };

    public shared ({ caller }) func getPrivateLeague(privateLeagueCanisterId: T.CanisterId) : async Result.Result<DTOs.ManagerPrivateLeagueDTO, T.Error> {
      assert not Principal.isAnonymous(caller);
      let managerId = Principal.toText(caller);
      let isLeagueMember = await seasonManager.isLeagueMember(privateLeagueCanisterId, managerId);
      assert isLeagueMember;

      let user = await seasonManager.getManager({managerId});
      let systemState = await getSystemState();
      switch(systemState){
        case (#ok foundState){
          switch(user){
            case (#ok managerDTO){
              let private_league_canister = actor (privateLeagueCanisterId) : actor {
                getManagerPrivateLeague : (managerId: T.PrincipalId, filters: DTOs.GameweekFiltersDTO) -> async DTOs.ManagerPrivateLeagueDTO;
              };
              let privateLeague = await private_league_canister.getManagerPrivateLeague(managerId, {seasonId = foundState.calculationSeasonId; gameweek = foundState.calculationGameweek});
              return #ok({
                canisterId = privateLeagueCanisterId;
                created = privateLeague.created;
                memberCount = privateLeague.memberCount;
                name = managerDTO.username;
                seasonPosition = privateLeague.seasonPosition;
                seasonPositionText = privateLeague.seasonPositionText;
              });
            };
            case _ { return #err(#NotFound)};
          };

        };
        case _ {
          return #err(#NotFound)
        };
      };
    };
    
    public shared ({ caller }) func getPrivateLeagueWeeklyLeaderboard(dto: DTOs.GetPrivateLeagueWeeklyLeaderboard) : async Result.Result<DTOs.WeeklyLeaderboardDTO, T.Error>{
      assert not Principal.isAnonymous(caller);
      assert(await seasonManager.isPrivateLeagueMember(dto.canisterId, Principal.toText(caller)));
      return await seasonManager.getPrivateLeagueWeeklyLeaderboard(dto);
    };

    public shared ({ caller }) func getPrivateLeagueMonthlyLeaderboard(dto: DTOs.GetPrivateLeagueMonthlyLeaderboard) : async Result.Result<DTOs.MonthlyLeaderboardDTO, T.Error>{
      assert not Principal.isAnonymous(caller);
      assert(await seasonManager.isPrivateLeagueMember(dto.canisterId, Principal.toText(caller)));
      return await seasonManager.getPrivateLeagueMonthlyLeaderboard(dto);
    };

    public shared ({ caller }) func getPrivateLeagueSeasonLeaderboard(dto: DTOs.GetPrivateLeagueSeasonLeaderboard) : async Result.Result<DTOs.SeasonLeaderboardDTO, T.Error>{
      assert not Principal.isAnonymous(caller);
      assert(await seasonManager.isPrivateLeagueMember(dto.canisterId, Principal.toText(caller)));
      return await seasonManager.getPrivateLeagueSeasonLeaderboard(dto);
    };

    public shared ({ caller }) func getPrivateLeagueMembers(dto: DTOs.GetLeagueMembersDTO) : async Result.Result<[DTOs.LeagueMemberDTO], T.Error>{
      assert not Principal.isAnonymous(caller);
      assert(await seasonManager.isPrivateLeagueMember(dto.canisterId, Principal.toText(caller)));
      return await seasonManager.getPrivateLeagueMembers(dto);
    };
    
    public shared ({ caller }) func createPrivateLeague(newPrivateLeague: DTOs.CreatePrivateLeagueDTO) : async Result.Result<(), T.Error>{
      assert false; //TODO: Remove when ready to launch private leagues
      assert not Principal.isAnonymous(caller);
      assert(newPrivateLeague.termsAgreed);
      assert(seasonManager.privateLeagueIsValid(newPrivateLeague));
      assert(seasonManager.nameAvailable(newPrivateLeague.name));
      assert(await treasuryManager.canAffordPrivateLeague(Principal.fromActor(Self), Principal.toText(caller), newPrivateLeague.paymentChoice));
      return await seasonManager.createPrivateLeague(Principal.fromActor(Self), caller, newPrivateLeague);
    };

    public shared ({ caller }) func searchUsername(dto: DTOs.UsernameFilterDTO) : async Result.Result<DTOs.ManagerDTO, T.Error> {
      assert not Principal.isAnonymous(caller);
      return await seasonManager.getManagerByUsername(dto.username);
    };

    public shared ({ caller }) func inviteUserToLeague(dto: DTOs.LeagueInviteDTO) : async Result.Result<(), T.Error> {
      assert not Principal.isAnonymous(caller);
      assert await seasonManager.isLeagueAdmin(dto.canisterId, Principal.toText(caller));

      assert(await seasonManager.leagueHasSpace(dto.canisterId));
      
      let isLeagueMember = await seasonManager.isLeagueMember(dto.canisterId, Principal.toText(caller));
      assert not isLeagueMember;

      return await seasonManager.inviteUserToLeague(dto, Principal.toText(caller));
    };

    public shared ({ caller }) func updateLeaguePicture(dto: DTOs.UpdateLeaguePictureDTO) : async Result.Result<(), T.Error> {
      assert not Principal.isAnonymous(caller);
      assert await seasonManager.isLeagueAdmin(dto.canisterId, Principal.toText(caller));
      await seasonManager.updateLeaguePicture(dto);
    };

    public shared ({ caller }) func updateLeagueBanner(dto: DTOs.UpdateLeagueBannerDTO) : async Result.Result<(), T.Error> {
      assert not Principal.isAnonymous(caller);
      assert await seasonManager.isLeagueAdmin(dto.canisterId, Principal.toText(caller));
      await seasonManager.updateLeagueBanner(dto);
    };

    public shared ({ caller }) func updateLeagueName(dto: DTOs.UpdateLeagueNameDTO) : async Result.Result<(), T.Error> {
      assert not Principal.isAnonymous(caller);
      assert await seasonManager.isLeagueAdmin(dto.canisterId, Principal.toText(caller));
      await seasonManager.updateLeagueName(dto);
    };

    //todo: get league invites list for in profile

    public shared ({ caller }) func acceptLeagueInvite(canisterId: T.CanisterId) : async Result.Result<(), T.Error>{
      assert not Principal.isAnonymous(caller);
      assert(await seasonManager.leagueHasSpace(canisterId));

      let isLeagueMember = await seasonManager.isLeagueMember(canisterId, Principal.toText(caller));
      assert not isLeagueMember;

      return await seasonManager.acceptLeagueInvite(canisterId, Principal.toText(caller));
    };

    public shared ({ caller }) func enterLeague(privateLeagueCanisterId: T.CanisterId) : async Result.Result<(), T.Error> {
      assert not Principal.isAnonymous(caller);
      assert(await seasonManager.leagueHasSpace(privateLeagueCanisterId));

      let isLeagueMember = await seasonManager.isLeagueMember(privateLeagueCanisterId, Principal.toText(caller));
      assert not isLeagueMember;

      let privateLeague = await seasonManager.getPrivateLeague(privateLeagueCanisterId);
      switch(privateLeague){
        case (#ok foundPrivateLeague){
          switch(foundPrivateLeague.entryType){
            case (#FreeEntry){
              let managerCanisterId = seasonManager.getManagerCanisterId(Principal.toText(caller));
              let managerUsername = seasonManager.getManagerUsername(Principal.toText(caller));
              switch(managerCanisterId){
                case null { return #err(#NotFound)};
                case (?foundCanisterId){
                  switch(managerUsername){
                    case null { return #err(#NotFound)};
                    case (?foundUsername){
                      await seasonManager.enterLeague(privateLeagueCanisterId, Principal.toText(caller), foundCanisterId, foundUsername);    
                    }
                  }
                }
              };
            };
            case _ {
              return (#err(#NotFound));
            };
          };
        };
        case _ { #err(#NotFound) };
      };    
    };

    public shared ({ caller }) func enterLeagueWithFee(canisterId: T.CanisterId) : async Result.Result<(), T.Error> {
      assert not Principal.isAnonymous(caller);
      assert(await seasonManager.leagueHasSpace(canisterId));
      let userPrincipal = Principal.toText(caller);

      let isLeagueMember = await seasonManager.isLeagueMember(canisterId, userPrincipal);
      assert not isLeagueMember;

      assert(await treasuryManager.canAffordEntryFee(Principal.fromActor(Self), canisterId, userPrincipal));
      await treasuryManager.payEntryFee(Principal.fromActor(Self), canisterId, userPrincipal);
      
      let managerCanisterId = seasonManager.getManagerCanisterId(Principal.toText(caller));
      let managerUsername = seasonManager.getManagerUsername(Principal.toText(caller));
      switch(managerCanisterId){
        case null { return #err(#NotFound)};
        case (?foundCanisterId){
          switch(managerUsername){
            case null { return #err(#NotFound)};
            case (?foundUsername){
              await seasonManager.enterLeague(canisterId, userPrincipal, foundCanisterId, foundUsername);
            }
          }
        }
      };
      
    };

    public shared ({ caller }) func acceptInviteAndPayFee(canisterId: T.CanisterId) : async Result.Result<(), T.Error> {
      assert not Principal.isAnonymous(caller);
      assert(await seasonManager.leagueHasSpace(canisterId));
      let userPrincipal = Principal.toText(caller);

      let isLeagueMember = await seasonManager.isLeagueMember(canisterId, userPrincipal);
      assert not isLeagueMember;
      assert(await seasonManager.inviteExists(canisterId, Principal.toText(caller)));
      
      assert(await treasuryManager.canAffordEntryFee(Principal.fromActor(Self), canisterId, userPrincipal));
      await treasuryManager.payEntryFee(Principal.fromActor(Self), canisterId, userPrincipal);
      await seasonManager.acceptLeagueInvite(canisterId, userPrincipal);
    };

    public shared ({ caller }) func getTokenList() : async Result.Result<[T.TokenInfo], T.Error> {
      assert not Principal.isAnonymous(caller);
      return #ok(treasuryManager.getTokenList());
    };

    public shared ({ caller }) func payPrivateLeagueRewards(dto: DTOs.PrivateLeagueRewardDTO) : async () {
      assert not Principal.isAnonymous(caller);
      let privateLeagueCanisterId = Principal.toText(caller);
      assert seasonManager.leagueExists(privateLeagueCanisterId);
      assert await seasonManager.isPrivateLeagueMember(dto.managerId, privateLeagueCanisterId);
      await seasonManager.payPrivateLeagueReward(Principal.fromActor(Self), privateLeagueCanisterId, treasuryManager.getTokenList(), dto.managerId, dto.amount);
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
          let monthlyLeaderboardCanisters = seasonManager.getStableMonthlyLeaderboardCanisters();
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

    //neuron
    private stable var neuronCommand: ?NeuronTypes.Command = null;
    private stable var neuronCreated = false;

    //event logs
    private stable var stable_event_logs: [T.EventLogEntry] = [];
    private stable var stable_next_system_event_id: Nat = 1;

    //Season Manager
    private stable var stable_reward_pools : [(T.SeasonId, T.RewardPool)] = [];
    private stable var stable_system_state : T.SystemState = {
      calculationGameweek = 1;
      calculationMonth = 8;
      calculationSeasonId = 1;
      pickTeamGameweek = 1;
      pickTeamSeasonId = 1;
      homepageFixturesGameweek = 1;
      homepageManagerGameweek = 1;
      seasonActive = false;
      transferWindowActive = false;
      onHold = false;
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
    private stable var stable_monthly_leaderboard_canisters : [T.MonthlyLeaderboardCanister] = [];
    private stable var stable_weekly_leaderboard_canisters : [T.WeeklyLeaderboardCanister] = [];

    //Private Leagues
    private stable var stable_private_league_canister_ids: [T.CanisterId] = [];
    private stable var stable_private_league_name_index: [(T.CanisterId, Text)] = [];
    private stable var stable_private_league_unaccepted_invites: [(T.PrincipalId, T.LeagueInvite)] = [];

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

      //Player Composite
      stable_next_player_id := seasonManager.getStableNextPlayerId();
      stable_players := seasonManager.getStablePlayers();

      //Club Composite
      stable_clubs := seasonManager.getStableClubs();
      stable_relegated_clubs := seasonManager.getStableRelegatedClubs();
      stable_next_club_id := seasonManager.getStableNextClubId();

      //Season Composite
      stable_seasons := seasonManager.getStableSeasons();
      stable_next_season_id := seasonManager.getStableNextSeasonId();
      stable_next_fixture_id := seasonManager.getStableNextFixtureId();

      //Leaderboard Composite
      stable_season_leaderboard_canisters := seasonManager.getStableSeasonLeaderboardCanisters();
      stable_monthly_leaderboard_canisters := seasonManager.getStableMonthlyLeaderboardCanisters();
      stable_weekly_leaderboard_canisters := seasonManager.getStableWeeklyLeaderboardCanisters();

      //Private Leagues
      stable_private_league_canister_ids := seasonManager.getStablePrivateLeagueCanisterIds();
      stable_private_league_name_index := seasonManager.getStablePrivateLeagueNameIndex();
      stable_private_league_unaccepted_invites := seasonManager.getStableUnacceptedInvites();

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

      //Player Composite
      seasonManager.setStablePlayers(stable_players);
      seasonManager.setStableNextPlayerId(stable_next_player_id);

      //Club Composite
      seasonManager.setStableClubs(stable_clubs);
      seasonManager.setStableRelegatedClubs(stable_relegated_clubs);
      seasonManager.setStableNextClubId(stable_next_club_id);

      //Season Composite
      seasonManager.setStableSeasons(stable_seasons);
      seasonManager.setStableNextSeasonId(stable_next_season_id);
      seasonManager.setStableNextFixtureId(stable_next_fixture_id);

      //Leaderboard Composite
      seasonManager.setStableSeasonLeaderboardCanisters(stable_season_leaderboard_canisters);
      seasonManager.setStableMonthlyLeaderboardCanisters(stable_monthly_leaderboard_canisters);
      seasonManager.setStableWeeklyLeaderboardCanisters(stable_weekly_leaderboard_canisters);

      //Private Leagues
      seasonManager.setStablePrivateLeagueCanisterIds(stable_private_league_canister_ids);
      seasonManager.setStablePrivateLeagueNameIndex(stable_private_league_name_index);
      seasonManager.setStablePrivateLeagueUnacceptedInvites(stable_private_league_unaccepted_invites);

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

    private func postUpgradeCallback() : async (){

      seasonManager.setFixtureToComplete(1,1);
      
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
      let IC : Management.Management = actor (Environment.Default);
      for(canisterId in Iter.fromArray(managerCanisterIds)){
        
        await IC.stop_canister({ canister_id = Principal.fromText(canisterId); });
        
        let oldManagement = actor (canisterId) : actor {};
        let _ = await (system ManagerCanister._ManagerCanister)(#upgrade oldManagement)();
        
        await IC.start_canister({ canister_id = Principal.fromText(canisterId); });
      };
    };

    public shared ({ caller }) func logStatus (dto: DTOs.LogStatusDTO) : async (){
      assert not Principal.isAnonymous(caller);
      let principalId = Principal.toText(caller);

      let managerCanisterIds = await getManagerCanisterIds();
      let foundManagerCanisterId = Array.find(managerCanisterIds, func(canisterId: T.CanisterId) : Bool{
        canisterId == principalId
      });

      if(Option.isSome(foundManagerCanisterId)){
        recordSystemEvent({
            eventDetail = dto.message; 
            eventId = 0;
            eventTime = Time.now();
            eventTitle = "Canister Log";
            eventType = #SystemCheck;
          });
      };
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

    private func checkSystem() : async () {
      
      let eventTime = Time.now();
      let dateString = Utilities.getReadableDate(eventTime);

      let cyclesAvailableResult = await getCanisterCyclesBalance();
      switch(cyclesAvailableResult){
        case (#ok result){
          let totalCanisterCount = seasonManager.getTotalCanisters();
          let totalManagerCount = seasonManager.getTotalManagers();
          
          recordSystemEvent({
            eventDetail = "OpenFPL system check. Backend cycles:  " # Nat.toText(result) # ", total canisters: " # Nat.toText(totalCanisterCount) # ", total managers: " # Nat.toText(totalManagerCount) # "."; 
            eventId = 0;
            eventTime = Time.now();
            eventTitle = "System Check " # dateString # ". (ID: " # Int.toText(stable_next_system_event_id) # ")";
            eventType = #SystemCheck;
          });

          let remainingDuration = Nat64.toNat(Nat64.fromIntWrap(Utilities.getNext6AM() - Time.now()));
          ignore Timer.setTimer<system>(#nanoseconds remainingDuration, systemCheckCallback);

        };
        case (_){

        }
      };
    };

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

    public shared ({ caller }) func getActivePlayers() : async [DTOs.PlayerDTO] {
      let principalId = Principal.toText(caller);
      let uniqueManagerCanisterIds = seasonManager.getUniqueManagerCanisterIds();
      assert Option.isSome(
        Array.find<T.CanisterId>(uniqueManagerCanisterIds, func(canisterId: T.CanisterId){
          canisterId == principalId
        })
      );  
      return seasonManager.getPlayers();
    };

    public shared ({ caller }) func getAllPlayers() : async [DTOs.PlayerDTO] {
      let principalId = Principal.toText(caller);
      let uniqueManagerCanisterIds = seasonManager.getUniqueManagerCanisterIds();
      assert Option.isSome(
        Array.find<T.CanisterId>(uniqueManagerCanisterIds, func(canisterId: T.CanisterId){
          canisterId == principalId
        })
      );  
      return seasonManager.getAllPlayers();
    };

    public shared ({ caller }) func getPlayerPointsMap(seasonId: T.SeasonId, gameweek: T.GameweekNumber) : async [(T.PlayerId, DTOs.PlayerScoreDTO)] {
      let principalId = Principal.toText(caller);
      let uniqueManagerCanisterIds = seasonManager.getUniqueManagerCanisterIds();
      assert Option.isSome(
        Array.find<T.CanisterId>(uniqueManagerCanisterIds, func(canisterId: T.CanisterId){
          canisterId == principalId
        })
      );  
      return await seasonManager.getPlayerPointsMap(seasonId, gameweek);
    };

    private func setupTesting(){
      seasonManager.setupTesting();
    };

    private func cleanFantasyTeams() : async (){
      await seasonManager.cleanFantasyTeams();
    };
    /*
    public func giveBackUnassignedBonuses() : async () {
      //await seasonManager.giveBackUnassignedBonuses();
    };
    */

  };
