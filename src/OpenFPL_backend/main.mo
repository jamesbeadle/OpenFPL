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

actor Self {
  private let seasonManager = SeasonManager.SeasonManager();
  private let treasuryManager = TreasuryManager.TreasuryManager();
  private let cyclesDispenser = CyclesDispenser.CyclesDispenser();
  private let cyclesCheckInterval : Nat = Utilities.getHour() * 24;
  private let cyclesCheckWalletInterval : Nat = Utilities.getHour() * 24;

  private var cyclesCheckTimerId : ?Timer.TimerId = null;
  private var cyclesCheckWalletTimerId : ?Timer.TimerId = null;


  //Manager calls

  public shared ({ caller }) func getProfile() : async Result.Result<DTOs.ProfileDTO, T.Error> {
    assert not Principal.isAnonymous(caller);
    return await seasonManager.getProfile(Principal.toText(caller));
  };

  public shared ({ caller }) func getCurrentTeam() : async Result.Result<DTOs.PickTeamDTO, T.Error> {
    assert not Principal.isAnonymous(caller);
    return await seasonManager.getCurrentTeam(Principal.toText(caller));
  };

  public shared ({ caller }) func getManager(managerId : Text) : async Result.Result<DTOs.ManagerDTO, T.Error> {
    assert not Principal.isAnonymous(caller);
    return await seasonManager.getManager(managerId);
  };
  

  //Leaderboard calls:

  public shared func getWeeklyLeaderboard(seasonId : T.SeasonId, gameweek : T.GameweekNumber, limit : Nat, offset : Nat, searchTerm : Text) : async Result.Result<DTOs.WeeklyLeaderboardDTO, T.Error> {
    return await seasonManager.getWeeklyLeaderboard(seasonId, gameweek, limit, offset, searchTerm);
  };

  public shared func getMonthlyLeaderboards(seasonId : T.SeasonId, month : T.CalendarMonth) : async Result.Result<[DTOs.MonthlyLeaderboardDTO], T.Error> {
    return await seasonManager.getMonthlyLeaderboards(seasonId, month);
  };

  public shared func getMonthlyLeaderboard(seasonId : T.SeasonId, clubId : T.ClubId, month : T.CalendarMonth, limit : Nat, offset : Nat, searchTerm : Text) : async Result.Result<DTOs.MonthlyLeaderboardDTO, T.Error> {
    return await seasonManager.getMonthlyLeaderboard(seasonId, month, clubId, limit, offset, searchTerm);
  };

  public shared func getSeasonLeaderboard(seasonId : T.SeasonId, limit : Nat, offset : Nat, searchTerm : Text) : async Result.Result<DTOs.SeasonLeaderboardDTO, T.Error> {
    return await seasonManager.getSeasonLeaderboard(seasonId, limit, offset, searchTerm);
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

  public shared query func getFixtures(seasonId : T.SeasonId) : async Result.Result<[DTOs.FixtureDTO], T.Error> {
    return #ok(seasonManager.getFixtures(seasonId));
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

  public shared query func getLoanedPlayers(clubId : T.ClubId) : async Result.Result<[DTOs.PlayerDTO], T.Error> {
    return #ok(seasonManager.getLoanedPlayers(clubId));
  };

  public shared query func getRetiredPlayers(clubId : T.ClubId) : async Result.Result<[DTOs.PlayerDTO], T.Error> {
    return #ok(seasonManager.getRetiredPlayers(clubId));
  };

  public shared query func getPlayerDetailsForGameweek(seasonId : T.SeasonId, gameweek : T.GameweekNumber) : async Result.Result<[DTOs.PlayerPointsDTO], T.Error> {
    return #ok(seasonManager.getPlayerDetailsForGameweek(seasonId, gameweek));
  };

  public shared query func getPlayersMap(seasonId : T.SeasonId, gameweek : T.GameweekNumber) : async Result.Result<[(Nat16, DTOs.PlayerScoreDTO)], T.Error> {
    return #ok(seasonManager.getPlayersMap(seasonId, gameweek));
  };

  public shared query func getPlayerDetails(playerId : T.PlayerId, seasonId : T.SeasonId) : async Result.Result<DTOs.PlayerDetailDTO, T.Error> {
    return #ok(seasonManager.getPlayerDetails(playerId, seasonId));
  };

  public shared query func getCountries() : async Result.Result<[DTOs.CountryDTO], T.Error> {
    return #ok(Countries.countries);
  };

  public shared query ({ caller }) func isUsernameValid(username : Text) : async Bool {
    assert not Principal.isAnonymous(caller);
    let usernameValid = seasonManager.isUsernameValid(username);
    let usernameTaken = seasonManager.isUsernameTaken(username, Principal.toText(caller));
    return usernameValid and not usernameTaken;
  };


  //Update functions:

  public shared ({ caller }) func updateUsername(username : Text) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    return await seasonManager.updateUsername(principalId, username);
  };

  public shared ({ caller }) func updateFavouriteClub(favouriteClubId : T.ClubId) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    return await seasonManager.updateFavouriteClub(principalId, favouriteClubId);
  };

  public shared ({ caller }) func updateProfilePicture(profilePicture : Blob, extension : Text) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    return await seasonManager.updateProfilePicture(principalId, profilePicture, extension);
  };

  public shared ({ caller }) func saveFantasyTeam(fantasyTeam : DTOs.UpdateTeamSelectionDTO) : async Result.Result<(), T.Error> {
    assert not seasonManager.getSystemState().onHold;
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert fantasyTeam.principalId == principalId;
    return await seasonManager.saveFantasyTeam(fantasyTeam);
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
    assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
    return seasonManager.validateSubmitFixtureData(submitFixtureData);
  };

  public shared ({ caller }) func executeSubmitFixtureData(submitFixtureData : DTOs.SubmitFixtureDataDTO) : async () {
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

  public shared query ({ caller }) func validateManageDAONeuron() : async T.RustResult {
    assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
    if (not neuronCreated) {
      return #Err("Neuron not created");
    };

    return #Ok();
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
    return #ok(treasuryManager.validateAddNewToken(newTokenDTO));
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


  //Private league functions
  //TODO
  public shared ({ caller }) func getPrivateLeagues() : async Result.Result<DTOs.ManagerPrivateLeaguesDTO, T.Error> {
    assert not Principal.isAnonymous(caller);
    
    let user = await seasonManager.getManager(Principal.toText(caller));

    switch(user){
      case (#ok dto){
        let privateLeaguesBuffer = Buffer.fromArray<DTOs.ManagerPrivateLeagueDTO>([]);
        for(privateLeagueCanisterId in Iter.fromArray(dto.privateLeagueMemberships)){
          let private_league_canister = actor (privateLeagueCanisterId) : actor {
            getPrivateLeague : () -> async DTOs.ManagerPrivateLeagueDTO;
          };
          let privateLeague = await private_league_canister.getPrivateLeague();
          privateLeaguesBuffer.add({
            canisterId = privateLeagueCanisterId;
            created = Time.now();
            memberCount = privateLeague.memberCount;
            name = dto.username;
            seasonPosition = 0;
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

  public shared ({ caller }) func getPrivateLeagueWeeklyLeaderboard(canisterId: T.CanisterId, seasonId : T.SeasonId, gameweek: T.GameweekNumber, limit : Nat, offset : Nat) : async Result.Result<DTOs.WeeklyLeaderboardDTO, T.Error>{
    assert not Principal.isAnonymous(caller);
    assert(await seasonManager.isPrivateLeagueMember(canisterId, Principal.toText(caller)));
    return await seasonManager.getPrivateLeagueWeeklyLeaderboard(canisterId, seasonId, gameweek, limit, offset);
  };

  public shared ({ caller }) func getPrivateLeagueMonthlyLeaderboard(canisterId: T.CanisterId, seasonId : T.SeasonId, month: T.CalendarMonth, limit : Nat, offset : Nat ) : async Result.Result<DTOs.MonthlyLeaderboardDTO, T.Error>{
    assert not Principal.isAnonymous(caller);
    assert(await seasonManager.isPrivateLeagueMember(canisterId, Principal.toText(caller)));
    return await seasonManager.getPrivateLeagueMonthlyLeaderboard(canisterId, seasonId, month, limit, offset);
  };

  public shared ({ caller }) func getPrivateLeagueSeasonLeaderboard(canisterId: T.CanisterId, seasonId : T.SeasonId, limit : Nat, offset : Nat) : async Result.Result<DTOs.SeasonLeaderboardDTO, T.Error>{
    assert not Principal.isAnonymous(caller);
    assert(await seasonManager.isPrivateLeagueMember(canisterId, Principal.toText(caller)));
    return await seasonManager.getPrivateLeagueSeasonLeaderboard(canisterId, seasonId, limit, offset);
  };

  public shared ({ caller }) func getPrivateLeagueMembers(canisterId: T.CanisterId, limit : Nat, offset : Nat) : async Result.Result<[DTOs.LeagueMemberDTO], T.Error>{
    assert not Principal.isAnonymous(caller);
    assert(await seasonManager.isPrivateLeagueMember(canisterId, Principal.toText(caller)));
    return await seasonManager.getPrivateLeagueMembers(canisterId, limit, offset);
  };
  
  public shared ({ caller }) func createPrivateLeague(newPrivateLeague: DTOs.CreatePrivateLeagueDTO) : async Result.Result<(), T.Error>{
    assert not Principal.isAnonymous(caller);
    assert(newPrivateLeague.termsAgreed);
    assert(seasonManager.privateLeagueIsValid(newPrivateLeague));
    assert(seasonManager.nameAvailable(newPrivateLeague.name));
    assert(seasonManager.canAffordPrivateLeague(Principal.toText(caller)));
    return await seasonManager.createPrivateLeague(newPrivateLeague);
  };

  public shared ({ caller }) func searchUsername(username: Text) : async Result.Result<DTOs.ManagerDTO, T.Error> {
    assert not Principal.isAnonymous(caller);
    return await seasonManager.getManagerByUsername(username);
  };

  public shared ({ caller }) func inviteUserToLeague(canisterId: T.CanisterId, managerId: T.PrincipalId) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    assert await seasonManager.isLeagueAdmin(canisterId, Principal.toText(caller));

    assert(await seasonManager.leagueHasSpace(canisterId));
    
    let isLeagueMember = await seasonManager.isLeagueMember(canisterId, Principal.toText(caller));
    assert not isLeagueMember;

    return await seasonManager.inviteUserToLeague(canisterId, managerId);
  };

  public shared ({ caller }) func updateLeaguePicture(canisterId: T.CanisterId, picture: Blob) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    assert await seasonManager.isLeagueAdmin(canisterId, Principal.toText(caller));
    await seasonManager.updateLeaguePicture(canisterId, picture);
  };

  public shared ({ caller }) func updateLeagueBanner(canisterId: T.CanisterId, banner: Blob) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    assert await seasonManager.isLeagueAdmin(canisterId, Principal.toText(caller));
    await seasonManager.updateLeagueBanner(canisterId, banner);
  };

  public shared ({ caller }) func updateLeagueName(canisterId: T.CanisterId, name: Text) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    assert await seasonManager.isLeagueAdmin(canisterId, Principal.toText(caller));
    await seasonManager.updateLeagueName(canisterId, name);
  };

  public shared ({ caller }) func acceptLeagueInvite(canisterId: T.CanisterId) : async Result.Result<(), T.Error>{
    assert not Principal.isAnonymous(caller);
    assert(await seasonManager.leagueHasSpace(canisterId));

    let isLeagueMember = await seasonManager.isLeagueMember(canisterId, Principal.toText(caller));
    assert not isLeagueMember;

    return await seasonManager.acceptLeagueInvite(canisterId, Principal.toText(caller));
  };

  public shared ({ caller }) func enterLeague(canisterId: T.CanisterId) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    assert(await seasonManager.leagueHasSpace(canisterId));

    let isLeagueMember = await seasonManager.isLeagueMember(canisterId, Principal.toText(caller));
    assert not isLeagueMember;

    let league = await seasonManager.getPrivateLeague(canisterId);
    switch(league.entryType){
      case (#FreeEntry){
        await seasonManager.enterLeague(canisterId, Principal.toText(caller));
      };
      case _ {
        return (#err(#NotFound));
      };
    };
  };

  public shared ({ caller }) func enterLeagueWithFee(canisterId: T.CanisterId) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    assert(await seasonManager.leagueHasSpace(canisterId));

    let isLeagueMember = await seasonManager.isLeagueMember(canisterId, Principal.toText(caller));
    assert not isLeagueMember;

    //check the user can afford the entry fee
    assert(treasuryManager.canAffordEntryFee(canisterId, Principal.toText(caller)));

    //Pay the league entry fee
    await treasuryManager.payEntryFee(canisterId, Principal.toText(caller));

    //add the user to the league
    await seasonManager.enterLeagueWithFee(canisterId, Principal.toText(caller));
  };

  public shared ({ caller }) func acceptInviteAndPayFee(canisterId: T.CanisterId) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    assert(await seasonManager.leagueHasSpace(canisterId));

    let isLeagueMember = await seasonManager.isLeagueMember(canisterId, Principal.toText(caller));
    assert not isLeagueMember;

    //check they have an invite
    assert(seasonManager.inviteExists(canisterId, Principal.toText(caller)));

    //check they can afford the fee
    assert(treasuryManager.canAffordEntryFee(Principal.toText(caller)));

    //Pay the league entry fee
    await treasuryManager.payEntryFee(canisterId, Principal.toText(caller));

    //add the user to the league
    await seasonManager.acceptInvite(canisterId, Principal.toText(caller));
  };

  public shared ({ caller }) func getTokenList() : async Result.Result<[T.TokenInfo], T.Error> {
    assert not Principal.isAnonymous(caller);
    return #ok(treasuryManager.getTokenList());
  };


  //Stable variables backup:

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
    transferWindowActive = false;
    onHold = true;
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

  private stable var stable_timers : [T.TimerInfo] = [];
  private stable var stable_canister_ids : [Text] = [];

  private var nextCyclesCheckTime : Int = 0;
  private var nextWalletCheckTime : Int = 0;

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

    stable_timers := timers;
    stable_canister_ids := cyclesDispenser.getStableCanisterIds();
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

    cyclesDispenser.setStableCanisterIds(stable_canister_ids);

    seasonManager.setBackendCanisterController(Principal.fromActor(Self));
    seasonManager.setTimerBackupFunction(setAndBackupTimer, removeExpiredTimers);
    seasonManager.setStoreCanisterIdFunction(cyclesDispenser.storeCanisterId);

    switch (cyclesCheckTimerId) {
      case (null) {};
      case (?id) {
        Timer.cancelTimer(id);
        cyclesCheckTimerId := null;
      };
    };
    nextCyclesCheckTime := Time.now() + cyclesCheckInterval;
    cyclesCheckTimerId := ?Timer.setTimer<system>(#nanoseconds(cyclesCheckInterval), checkCanisterCycles);

    switch (cyclesCheckWalletTimerId) {
      case (null) {};
      case (?id) {
        Timer.cancelTimer(id);
        cyclesCheckWalletTimerId := null;
      };
    };
    nextWalletCheckTime := Time.now() + cyclesCheckWalletInterval;
    cyclesCheckWalletTimerId := ?Timer.setTimer<system>(#nanoseconds(cyclesCheckWalletInterval), checkCanisterWalletBalance);

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

    beginOpenFPL();
  };

  //Canister wallet topup functions

  private func checkCanisterWalletBalance() : async () {
    let topupThreshold : Nat = 500_000_000_000_000;
    let targetBalance : Nat = 1_000_000_000_000_000;
    let available = Cycles.available();

    if (available < topupThreshold) {
      await burnICPToCycles(Nat64.fromNat(targetBalance - available));
    };
  };

  public func burnICPToCycles(requestedCycles : Nat64) : async () {
    let treasuryAccount = getTreasuryAccount();
    await treasuryManager.sendICPForCycles(treasuryAccount, requestedCycles);
  };


  //Canister cycle topup functions
  
  private func setCheckCyclesTimer() : async () {
    switch (cyclesCheckTimerId) {
      case (null) {};
      case (?id) {
        Timer.cancelTimer(id);
        cyclesCheckTimerId := null;
      };
    };
    nextCyclesCheckTime := Time.now() + cyclesCheckInterval;
    cyclesCheckTimerId := ?Timer.setTimer<system>(#nanoseconds(cyclesCheckInterval), checkCanisterCycles);
  };

  


  public shared ({ caller }) func requestCanisterTopup() : async () {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    await cyclesDispenser.requestCanisterTopup(principalId);
  };

  private func checkCanisterCycles() : async () {

    let balance = Cycles.balance();

    if (balance < 500_000_000_000) {
      await requestCanisterTopup();
    };
    await setCheckCyclesTimer();
  };

  private func getTreasuryAccount() : Account.AccountIdentifier {
    let actorPrincipal : Principal = Principal.fromActor(Self);
    Account.accountIdentifier(actorPrincipal, Account.defaultSubaccount());
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


  //TODO: Remove Temporary Functions

  //The following stable variables can be removed when the neuron has been created and the app has been initialised
  private stable var neuronCreated = false;
  private stable var openFPLInitialised = false;

  
  //Can remove after the DAOs neuron is created
  public shared query ({ caller }) func validateCreateDAONeuron() : async T.RustResult {
    assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
    if (neuronCreated) {
      return #Err("Neuron already created");
    };

    return #Ok();
  };

  //can remove after the DAOs neuron is created
  public shared ({ caller }) func executeCreateDAONeuron() : async () {
    assert Principal.toText(caller) == Environment.SNS_GOVERNANCE_CANISTER_ID;
    if (neuronCreated) {
      return;
    };

    let neuron_controller = actor (Environment.NEURON_CONTROLLER_CANISTER_ID) : actor {
      stake_nns_neuron : () -> async ?NeuronTypes.Response;
    };

    let _ = await neuron_controller.stake_nns_neuron();

    neuronCreated := true;

  };

  //Can be removed when the game has successfully been initialsed
  private func beginOpenFPL () : () {
    if(openFPLInitialised){
      return;
    };
    //Check the cycles balance on the wallet

    //Set the backend 

    //relegate teams that went down

    //set the system so you can pick team
  };

};
