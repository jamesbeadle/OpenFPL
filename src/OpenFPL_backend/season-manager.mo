import T "types";
import DTOs "DTOs";
import Timer "mo:base/Timer";
import { now } = "mo:base/Time";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import Array "mo:base/Array";
import List "mo:base/List";
import Buffer "mo:base/Buffer";
import Option "mo:base/Option";
import Nat8 "mo:base/Nat8";
import Time "mo:base/Time";
import Debug "mo:base/Debug";
import Result "mo:base/Result";
import HashMap "mo:base/HashMap";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Principal "mo:base/Principal";
import Blob "mo:base/Blob";
import SnapshotFactory "patterns/snapshot-factory";
import StrategyManager "patterns/strategy-manager";
import SeasonComposite "patterns/composites/season-composite";
import PlayerComposite "patterns/composites/player-composite";
import ClubComposite "patterns/composites/club-composite";
import ManagerComposite "patterns/composites/manager-composite";
import LeaderboardComposite "patterns/composites/leaderboard-composite";
import Utilities "utilities";
import CanisterIds "CanisterIds";

module {

  public class SeasonManager() {

    let strategyManager = StrategyManager.StrategyManager();
    let managerComposite = ManagerComposite.ManagerComposite();
    let playerComposite = PlayerComposite.PlayerComposite();
    let clubComposite = ClubComposite.ClubComposite();
    let seasonComposite = SeasonComposite.SeasonComposite();
    let leaderboardComposite = LeaderboardComposite.LeaderboardComposite();
    var timers: [T.TimerInfo] = [];
    
    private var systemState: T.SystemState = {
      calculationGameweek = 1;
      calculationMonth = 8;
      calculationSeason = 1;
      pickTeamGameweek = 1;
      homepageFixturesGameweek = 1;
      homepageManagerGameweek = 0;
    };

    private var dataCacheHashes : List.List<T.DataCache> = List.fromArray([
      { category = "clubs"; hash = "DEFAULT_VALUE" },
      { category = "fixtures"; hash = "DEFAULT_VALUE" },
      { category = "weekly_leaderboard"; hash = "DEFAULT_VALUE" },
      { category = "monthly_leaderboards"; hash = "DEFAULT_VALUE" },
      { category = "season_leaderboard"; hash = "DEFAULT_VALUE" },
      { category = "players"; hash = "DEFAULT_VALUE" },
      { category = "player_events"; hash = "DEFAULT_VALUE" }
    ]);
   
    public func setStableData(
      stable_system_state : T.SystemState,
      stable_data_cache_hashes: [T.DataCache],
      stable_next_club_id: T.ClubId,
      stable_next_player_id: T.PlayerId,
      stable_next_season_id: T.SeasonId,
      stable_next_fixture_id: T.FixtureId,
      stable_managers: [(T.PrincipalId, T.Manager)],
      stable_clubs: [T.Club],
      stable_players: [T.Player],
      stable_seasons: [T.Season],
      stable_profile_picture_canister_ids:  [(T.PrincipalId, Text)],
      stable_season_leaderboard_canister_ids:  [(T.SeasonId, Text)],
      stable_monthly_leaderboard_canister_ids:  [(T.MonthlyLeaderboardKey, Text)],
      stable_weekly_leaderboard_canister_ids:  [(T.WeeklyLeaderboardKey, Text)]) {

      systemState := stable_system_state;
      dataCacheHashes := List.fromArray(stable_data_cache_hashes);
      clubComposite.setStableData(stable_next_club_id, stable_clubs);
      playerComposite.setStableData(stable_next_player_id, stable_players);
      seasonComposite.setStableData(stable_next_season_id, stable_next_fixture_id, stable_seasons);
      managerComposite.setStableData(stable_managers, stable_profile_picture_canister_ids);
      leaderboardComposite.setStableData(
        stable_season_leaderboard_canister_ids,
        stable_monthly_leaderboard_canister_ids,
        stable_weekly_leaderboard_canister_ids);      
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

    private func setAndBackupTimer(duration : Timer.Duration, timerInfo: T.TimerInfo) : async () {
      let jobId : Timer.TimerId = switch (timerInfo.callbackName) {
        case "gameweekBeginExpired" {
          Timer.setTimer(duration, gameweekBeginExpiredCallback);
        };
        case "gameKickOffExpired" {
          Timer.setTimer(duration, gameKickOffExpiredCallback);
        };
        case "gameCompletedExpired" {
          Timer.setTimer(duration, gameCompletedExpiredCallback);
        };
        case "loanExpired" {
          Timer.setTimer(duration, loanExpiredCallback);
        };
        case "transferWindowStart" {
          Timer.setTimer(duration, transferWindowStartCallback);
        };
        case "transferWindowEnd" {
          Timer.setTimer(duration, transferWindowEndCallback);
        };
        case _ { 
          Timer.setTimer(duration, defaultCallback);
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
        triggerTime = timerInfo.triggerTime;
        callbackName = timerInfo.callbackName;
        playerId = timerInfo.playerId;
        fixtureId = timerInfo.fixtureId;
      };

      var timerBuffer = Buffer.fromArray<T.TimerInfo>(timers);
      timerBuffer.add(newTimerInfo);
      timers := Buffer.toArray(timerBuffer);
    };
    private func defaultCallback() : async () {};

    private func recreateTimers() {
      let currentTime = Time.now();
      for (timerInfo in Iter.fromArray(timers)) {
        let remainingDuration = timerInfo.triggerTime - currentTime;

        if (remainingDuration > 0) {
          let duration : Timer.Duration = #nanoseconds(Int.abs(remainingDuration));

          switch (timerInfo.callbackName) {
            case "gameweekBeginExpired" {
              ignore Timer.setTimer(duration, gameweekBeginExpiredCallback);
            };
            case "gameKickOffExpired" {
              ignore Timer.setTimer(duration, gameKickOffExpiredCallback);
            };
            case "gameCompletedExpired" {
              ignore Timer.setTimer(duration, gameCompletedExpiredCallback);
            };
            case "loanExpired" {
              ignore Timer.setTimer(duration, loanExpiredCallback);
            };
            case "transferWindowStart" {
              ignore Timer.setTimer(duration, transferWindowStartCallback);
            };
            case "transferWindowEnd" {
              ignore Timer.setTimer(duration, transferWindowEndCallback);
            };
            case _ {};
          };
        };
      };
    };

    private func gameweekBeginExpiredCallback() : async () {
      await gameweekBegin();
    };

    private func gameKickOffExpiredCallback() : async () {
      await gameKickOff();
      removeExpiredTimers();
    };

    private func gameCompletedExpiredCallback() : async () {
      await gameCompleted();
      removeExpiredTimers();
    };

    private func loanExpiredCallback() : async () {
      playerComposite.loanExpired();//go through all players and check if any have their loan expired and recall them to their team if so
      await updateCacheHash("players");        
      removeExpiredTimers();
    };

    private func transferWindowStartCallback() : async () {
  //Set a flag to allow the january transfer window when submitting teams but also check for it
        //SETUP THE JAN TRANSFER WINDOW
      await transferWindowStartCallback();
      removeExpiredTimers();
    };

    private func transferWindowEndCallback() : async () {
      //end transfer window
      await transferWindowEndCallback();
      removeExpiredTimers();
    };

    public func gameweekBegin() : async () {
      managerProfileManager.snapshotFantasyTeams();
      managerProfileManager.resetTransfers();  
    };
    
    public func gameKickOff() : async () {
      seasonComposite.updateFixtureStatuses(#Active);

      let timers = getActiveTimers();


      setGameCompletedTimers(); //Look for any active game and set completed 2 hours from kickoff
      await updateCacheHash("fixtures");
    };

    public func gameCompleted() : async () {
      seasonComposite.updateFixtureStatuses(); //update any active game that is 2 hours after it's kickoff to completed
      await updateCacheHash("fixtures");        
    };
    
    public func getSystemState() : DTOs.SystemStateDTO {
      return systemState;
    };
    
    public func getDataHashes() : [DTOs.DataCacheDTO] {
      return List.toArray(dataCacheHashes);
    };
    
    public func getFixtures(seasonId: T.SeasonId) : [DTOs.FixtureDTO] {
      return [];
    };
    
    public func getPlayers() : [DTOs.PlayerDTO] {
      return [];
    };

    public func getDetailedPlayers(seasonId: T.SeasonId, gameweek: T.GameweekNumber) : [DTOs.PlayerDTO] {
      return [];
    };

    public func getWeeklyLeaderboard(seasonId: T.SeasonId, gameweek: T.GameweekNumber) : async Result.Result<DTOs.WeeklyLeaderboardDTO, T.Error> {
      let leaderboardKey: T.WeeklyLeaderboardKey = (seasonId, gameweek);
      let canisterId = weeklyLeaderboardCanisterIds.get(leaderboardKey);
      switch(canisterId){
        case (null) {
          return #err(#NotFound);
        };
        case (?foundCanisterId){
          let weekly_leaderboard_canister = actor (foundCanisterId) : actor {
            getEntries : () -> async DTOs.WeeklyLeaderboardDTO;
          };

          let leaderboardEntries = await weekly_leaderboard_canister.getEntries();
          return #ok(leaderboardEntries);
        };
      };
    };
    
    public func getMonthlyLeaderboard(seasonId: T.SeasonId, month: T.CalendarMonth, clubId: T.ClubId) : async Result.Result<DTOs.MonthlyLeaderboardDTO, T.Error>{
      let leaderboardKey: T.MonthlyLeaderboardKey = (seasonId, month, clubId);
      let canisterId = monthlyLeaderboardCanisterIds.get(leaderboardKey);
      switch(canisterId){
        case (null) {
          return #err(#NotFound);
        };
        case (?foundCanisterId){
          let monthly_leaderboard_canister = actor (foundCanisterId) : actor {
            getEntries : () -> async DTOs.MonthlyLeaderboardDTO;
          };

          let leaderboardEntries = await monthly_leaderboard_canister.getEntries();
          return #ok(leaderboardEntries);
        };
      };
    };

    public func getSeasonLeaderboard(seasonId: T.SeasonId) : async Result.Result<DTOs.SeasonLeaderboardDTO, T.Error>{
      let seasonCanisterId = seasonLeaderboardCanisterIds.get(seasonId);
      switch(seasonCanisterId){
        case (null) {
          return #err(#NotFound);
        };
        case (?foundSeasonCanisterId){
          let season_leaderboard_canister = actor (foundSeasonCanisterId) : actor {
            getEntries : () -> async DTOs.SeasonLeaderboardDTO;
          };

          let leaderboardEntries = await season_leaderboard_canister.getEntries();
          return #ok(leaderboardEntries);
        };
      };
    };
    
    public func getProfile(principalId: Text) : async Result.Result<DTOs.ProfileDTO, T.Error> {
      let manager = managers.get(principalId);
      return await managerProfileManager.getProfile(manager);
    };
    
    /* Will need when profile DTO isn't enough
    public func getManager(principalId: Text){
      
    };
    */
    
    public func getTotalManagers() : Nat{
      let managersWithTeams = Iter.filter<T.Manager>(managers.vals(), func (manager : T.Manager) : Bool { Array.size(manager.playerIds) == 11 });
      return Iter.size(managersWithTeams);
    };

    public func createProfile(principalId: Text, createProfileDTO: DTOs.ProfileDTO) : async Result.Result<(), T.Error> {
      
      var profilePictureCanisterId = "";
      if(createProfileDTO.profilePicture.size() > 0){
        profilePictureCanisterId := managerProfileManager.updateProfilePicture(principalId, createProfileDTO.profilePicture);
      };

      let newManager = managerProfileManager.buildNewManager(principalId, createProfileDTO, profilePictureCanisterId);
      managers.put(principalId, newManager);
      return #ok();
    };

    public func saveFantasyTeam(principalId: Text, updatedFantasyTeam: DTOs.UpdateFantasyTeamDTO) : async Result.Result<(), T.Error>{
      
      if(not strategyManager.isFantasyTeamValid(updatedFantasyTeam)){
        return #err(#InvalidTeamError);
      };

      let updatedManager = managerProfileManager.updateManager(principalId, managers.get(principalId), updatedFantasyTeam);
      managers.put(principalId, updatedManager);

      return #ok();
    };

    public func updateUsername(principalId: Text, updatedUsername: Text) : async Result.Result<(), T.Error>{
      
      if(not managerProfileManager.isUsernameValid(updatedUsername)){
        return #err(#InvalidData);
      };

      if(not managerProfileManager.isUsernameAvailable(updatedUsername)){
        return #err(#NotAllowed);
      };

      let updatedManager = managerProfileManager.updateUsername(principalId, managers.get(principalId), updatedUsername);
      switch(updatedManager){
        case (null){
          return #err(#NotFound);
        };
        case(?foundUpdatedManager){
          managers.put(principalId, foundUpdatedManager);
          return #ok();
        };
      }
    };
    
    public func isUsernameAvailable(username: Text) : Bool{
      return managerProfileManager.isUsernameAvailable(username);
    };

    //Governance validation and execution functions
    public func validateSubmitFixtureData(submitFixtureDataDTO: DTOs.SubmitFixtureDataDTO) : Bool {
      return seasonComposite.validateSubmitFixtureData(submitFixtureDataDTO);
    };

    public func executeSubmitFixtureData(submitFixtureData: DTOs.SubmitFixtureDataDTO) : async Result.Result<(), T.Error> {
      return seasonComposite.executeSubmitFixtureData(submitFixtureData);
    };
     
    public func validateAddInitialFixtures(addInitialFixturesDTO: DTOs.AddInitialFixturesDTO) : Bool {
      return seasonComposite.validateAddInitialFixtures(addInitialFixturesDTO);
    };

    public func executeAddInitialFixtures(addInitialFixturesDTO: DTOs.AddInitialFixturesDTO) : async Result.Result<(), T.Error> { 
      return seasonComposite.executeAddInitialFixtures(addInitialFixturesDTO);
    };

    public func validateRescheduleFixture(rescheduleFixtureDTO: DTOs.RescheduleFixtureDTO) : Bool {
      return seasonComposite.validateRescheduleFixture(rescheduleFixtureDTO);
    };

    public func executeRescheduleFixture(rescheduleFixtureDTO: DTOs.RescheduleFixtureDTO) : async Result.Result<(), T.Error> {
      return seasonComposite.executeRescheduleFixture(rescheduleFixtureDTO);
    };

    public func validateRevaluePlayerUp(revaluePlayerUpDTO: DTOs.RevaluePlayerUpDTO) : Bool {
      return playerComposite.validateRevaluePlayerUp(revaluePlayerUpDTO);
    };

    public func executeRevaluePlayerUp(revaluePlayerUpDTO: DTOs.RevaluePlayerUpDTO) : async Result.Result<(), T.Error> {
       return playerComposite.executeRevaluePlayerUp(revaluePlayerUpDTO);
    };

    public func validateRevaluePlayerDown(revaluePlayerDownDTO: DTOs.RevaluePlayerDownDTO) : Bool {
      return playerComposite.validateRevaluePlayerDown(revaluePlayerDownDTO);
    };

    public func executeRevaluePlayerDown(revaluePlayerDownDTO: DTOs.RevaluePlayerDownDTO) : async Result.Result<(), T.Error> {
      return playerComposite.executeRevaluePlayerDown(revaluePlayerDownDTO);
    };

    public func validateLoanPlayer(loanPlayerDTO: DTOs.LoanPlayerDTO) : Bool {
      return playerComposite.validateLoanPlayer(loanPlayerDTO);
    };

    public func executeLoanPlayer(loanPlayerDTO: DTOs.LoanPlayerDTO) : async Result.Result<(), T.Error> {
      return playerComposite.executeLoanPlayer(loanPlayerDTO);
    };

    public func validateTransferPlayer(transferPlayerDTO: DTOs.TransferPlayerDTO) : Bool {
      return playerComposite.validateTransferPlayer(transferPlayerDTO);
    };

    public func executeTransferPlayer(transferPlayerDTO: DTOs.TransferPlayerDTO) : async Result.Result<(), T.Error> {
      return playerComposite.executeTransferPlayer(transferPlayerDTO);
    };

    public func validateRecallPlayer(recallPlayerDTO: DTOs.RecallPlayerDTO) : Bool {
      return playerComposite.validateRecallPlayer(recallPlayerDTO);
    };

    public func executeRecallPlayer(recallPlayerDTO: DTOs.RecallPlayerDTO) : async Result.Result<(), T.Error> {
      return playerComposite.executeRecallPlayer(recallPlayerDTO);
    };

    public func validateCreatePlayer(createPlayerDTO: DTOs.CreatePlayerDTO) : Bool {
      return playerComposite.validateCreatePlayer(createPlayerDTO);
    };

    public func executeCreatePlayer(createPlayerDTO: DTOs.CreatePlayerDTO) : async Result.Result<(), T.Error> {
      return playerComposite.executeCreatePlayer(createPlayerDTO);
    };

    public func validateUpdatePlayer(updatePlayerDTO: DTOs.UpdatePlayerDTO) : Bool {
      return playerComposite.validateUpdatePlayer(updatePlayerDTO);
    };

    public func executeUpdatePlayer(updatePlayerDTO: DTOs.UpdatePlayerDTO) : async Result.Result<(), T.Error> {
      return playerComposite.executeUpdatePlayer(updatePlayerDTO);
    };

    public func validateSetPlayerInjury(setPlayerInjuryDTO: DTOs.SetPlayerInjuryDTO) : Bool {
      return playerComposite.validateSetPlayerInjury(setPlayerInjuryDTO);
    };

    public func executeSetPlayerInjury(setPlayerInjuryDTO: DTOs.SetPlayerInjuryDTO) : async Result.Result<(), T.Error> {
      return playerComposite.executeSetPlayerInjury(setPlayerInjuryDTO);
    };
    
    public func validateRetirePlayer(retirePlayerDTO: DTOs.RetirePlayerDTO) : Bool {
      return playerComposite.validateRetirePlayer(retirePlayerDTO);
    };

    public func executeRetirePlayer(retirePlayerDTO: DTOs.RetirePlayerDTO) : async Result.Result<(), T.Error> {
      return playerComposite.executeRetirePlayer(retirePlayerDTO);
    };

    public func validateUnretirePlayer(unretirePlayerDTO: DTOs.UnretirePlayerDTO) : Bool {
      return playerComposite.validateUnretirePlayer(unretirePlayerDTO);
    };
    
    public func executeUnretirePlayer(unretirePlayerDTO: DTOs.UnretirePlayerDTO) : async Result.Result<(), T.Error> {
      return playerComposite.executeUnretirePlayer(unretirePlayerDTO);
    };

    public func validatePromoteFormerClub(promoteFormerClubDTO: DTOs.PromoteFormerClubDTO) : async Result.Result<(), T.Error> {
      return clubComposite.validatePromoteFormerClub(promoteFormerClubDTO);
    };

    public func executePromoteFormerClub(promoteFormerClubDTO: DTOs.PromoteFormerClubDTO) : async Result.Result<(), T.Error> {
      return clubComposite.executePromoteFormerClub(promoteFormerClubDTO);
    };

    public func validatePromoteNewClub(promoteNewClubDTO: DTOs.PromoteNewClubDTO) : async Result.Result<(), T.Error> {
      return clubComposite.validatePromoteNewClub(promoteNewClubDTO);
    };

    public func executePromoteNewClub(promoteNewClubDTO: DTOs.PromoteNewClubDTO) : async Result.Result<(), T.Error> {
      return clubComposite.executePromoteNewClub(promoteNewClubDTO);
    };

    public func validateUpdateClub(updateClubDTO: DTOs.UpdateClubDTO) : async Result.Result<(), T.Error> {
      return clubComposite.validateUpdateClub(updateClubDTO);
    };

    public func executeUpdateClub(updateClubDTO: DTOs.UpdateClubDTO) : async Result.Result<(), T.Error> {
      return clubComposite.executeUpdateClub(updateClubDTO);
    };

  };
};
