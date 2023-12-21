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
import SnapshotManager "patterns/snapshot-manager";
import SnapshotFactory "patterns/snapshot-factory";
import PlayerComposite "patterns/player-composite";
import ClubComposite "patterns/club-composite";
import StrategyManager "patterns/strategy-manager";
import ManagerProfileManager "patterns/manager-profile-manager";
import SeasonComposite "patterns/season-composite";
import Utilities "utilities";

module {

  public class SeasonManager(setAndBackupTimer : (duration : Timer.Duration, timerInfo: T.TimerInfo) -> async ()) {

    let strategyManager = StrategyManager.StrategyManager();
    let managerProfileManager = ManagerProfileManager.ManagerProfileManager();
    let playerComposite = PlayerComposite.PlayerComposite();
    let seasonComposite = SeasonComposite.SeasonComposite();
    
    let CANISTER_IDS = {
      retired_players_canister = "pec6o-uqaaa-aaaal-qb7eq-cai";
      former_players_canister = "pec6o-uqaaa-aaaal-qb7eq-cai";
      token_canister = "hwd4h-eyaaa-aaaal-qb6ra-cai";
      governance_canister = "rrkah-fqaaa-aaaaa-aaaaq-cai";
    };

    let tokenCanister = actor (CANISTER_IDS.token_canister) : actor {
      icrc1_name : () -> async Text;
      icrc1_total_supply : () -> async Nat;
      icrc1_balance_of : (T.Account) -> async Nat;
    };

    let former_players_canister = actor (CANISTER_IDS.former_players_canister) : actor {
      getFormerPlayer : (playerId: T.PlayerId) -> async ();
      addFormerPlayer : (playerDTO: DTOs.PlayerDTO) -> async ();
      reinstateFormerPlayer : (playerId: T.PlayerId) -> async ();
    };

    let retired_players_canister = actor (CANISTER_IDS.retired_players_canister) : actor {
      getRetiredPlayer : (playerId: T.PlayerId) -> async ();
      retirePlayer : (playerDTO: DTOs.PlayerDTO) -> async ();
      unretirePlayer : (playerId: T.PlayerId) -> async ();
    };

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

    private var nextClubId : T.ClubId = 1;
    private var nextPlayerId : T.PlayerId = 1;
    private var nextSeasonId : T.SeasonId = 1;
    private var nextFixtureId : T.FixtureId = 1;
    private var managers: HashMap.HashMap<T.PrincipalId, T.Manager> = HashMap.HashMap<T.PrincipalId, T.Manager>(100, Text.equal, Text.hash);
    private var players = List.fromArray<T.Player>([]);
    private var seasons = List.fromArray<T.Season>([]);
    private var profilePictureCanisterIds : HashMap.HashMap<T.PrincipalId, Text> = HashMap.HashMap<T.PrincipalId, Text>(100, Text.equal, Text.hash);    

    private var seasonLeaderboardCanisterIds : HashMap.HashMap<T.SeasonId, Text> = HashMap.HashMap<T.SeasonId, Text>(100, Utilities.eqNat16, Utilities.hashNat16);
    private var monthlyLeaderboardCanisterIds : HashMap.HashMap<T.MonthlyLeaderboardKey, Text> = HashMap.HashMap<T.MonthlyLeaderboardKey, Text>(100, Utilities.eqMonthlyKey, Utilities.hashMonthlyKey);
    private var weeklyLeaderboardCanisterIds : HashMap.HashMap<T.WeeklyLeaderboardKey, Text> = HashMap.HashMap<T.WeeklyLeaderboardKey, Text>(100, Utilities.eqWeeklyKey, Utilities.hashWeeklyKey);

    public func setStableData(
      stable_system_state : T.SystemState,
      stable_data_cache_hashes: [T.DataCache],
      stable_next_club_id: T.ClubId,
      stable_next_player_id: T.PlayerId,
      stable_next_season_id: T.SeasonId,
      stable_next_fixture_id: T.FixtureId,
      stable_managers: [(T.PrincipalId, T.Manager)],
      stable_players: [T.Player],
      stable_seasons: [T.Season],
      stable_profile_picture_canister_ids:  [(T.PrincipalId, Text)],
      stable_season_leaderboard_canister_ids:  [(T.SeasonId, Text)],
      stable_monthly_leaderboard_canister_ids:  [(T.MonthlyLeaderboardKey, Text)],
      stable_weekly_leaderboard_canister_ids:  [(T.WeeklyLeaderboardKey, Text)]) {

      systemState := stable_system_state;
      dataCacheHashes := List.fromArray(stable_data_cache_hashes);
      nextClubId := stable_next_club_id;
      nextPlayerId := stable_next_player_id;
      nextSeasonId := stable_next_season_id;
      nextFixtureId := stable_next_fixture_id;
       
      managers := HashMap.fromIter<T.PrincipalId, T.Manager>(
        stable_managers.vals(),
        stable_managers.size(),
        Text.equal,
        Text.hash,
      );

      players := List.fromArray(stable_players);
      seasons := List.fromArray(stable_seasons);

      profilePictureCanisterIds := HashMap.fromIter<T.PrincipalId, Text>(
        stable_profile_picture_canister_ids.vals(),
        stable_profile_picture_canister_ids.size(),
        Text.equal,
        Text.hash,
      );

      seasonLeaderboardCanisterIds := HashMap.fromIter<T.SeasonId, Text>(
        stable_season_leaderboard_canister_ids.vals(),
        stable_season_leaderboard_canister_ids.size(),
        Utilities.eqNat16, 
        Utilities.hashNat16
      );

      monthlyLeaderboardCanisterIds := HashMap.fromIter<T.MonthlyLeaderboardKey, Text>(
        stable_monthly_leaderboard_canister_ids.vals(),
        stable_monthly_leaderboard_canister_ids.size(),
        Utilities.eqMonthlyKey, 
        Utilities.hashMonthlyKey
      );

      weeklyLeaderboardCanisterIds := HashMap.fromIter<T.WeeklyLeaderboardKey, Text>(
        stable_weekly_leaderboard_canister_ids.vals(),
        stable_weekly_leaderboard_canister_ids.size(),
        Utilities.eqWeeklyKey, 
        Utilities.hashWeeklyKey
      );
      
    };

    public func gameweekBegin() : async () {
      snapshotManager.snapshotFantasyTeams();
      managerProfileManager.resetFantasyTeams();  
    };

    
    public func gameKickOff() : async () {
      updateFixtureStatuses();
      setGameCompletedTimers(); //Look for any active game and set completed 2 hours from kickoff
      await updateCacheHash("fixtures");
    };

    
    public func gameCompleted() : async () {
      updateFixtureStatuses(); //update any active game that is 2 hours after it's kickoff to completed
      await updateCacheHash("fixtures");        
    };

    public func loanExpiredCallback() : async () {
      playerComposite.loanExpired();//go through all players and check if any have their loan expired and recall them to their team if so
      await updateCacheHash("players");        
    };

    
    public func transferWindowStartCallback() : async () {
      //Set a flag to allow the january transfer window when submitting teams but also check for it
      //SETUP THE JAN TRANSFER WINDOW
    };
    
    public func transferWindowEndCallback() : async () {
      //END THE JAN TRANSFER WINDOW
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

    public func validateSubmitFixtureData(submitFixtureDataDTO: DTOs.SubmitFixtureDataDTO) : Bool {
      return seasonComposite.validateSubmitFixtureData(submitFixtureDataDTO);
    };

    public func executeSubmitFixtureData(submitFixtureData: DTOs.SubmitFixtureDataDTO) : async Result.Result<(), T.Error> {
      return seasonComposite.executeSubmitFixtureData(submitFixtureData);
    };
     
    public func validateAddInitialFixtures(addInitialFixturesDTO: DTOs.AddInitialFixturesDTO) : async Result.Result<(), T.Error> {
      return seasonComposite.validateAddInitialFixtures(addInitialFixturesDTO);
    };

    public func executeAddInitialFixtures(addInitialFixturesDTO: DTOs.AddInitialFixturesDTO) : async Result.Result<(), T.Error> { 
      return seasonComposite.executeAddInitialFixtures(addInitialFixturesDTO);
    };

    public func validateRescheduleFixture(rescheduleFixtureDTO: DTOs.RescheduleFixtureDTO) : async Result.Result<(), T.Error> {
      return seasonComposite.validateRescheduleFixture(rescheduleFixtureDTO);
      return #ok();
    };

    public func executeRescheduleFixture(rescheduleFixtureDTO: DTOs.RescheduleFixtureDTO) : async Result.Result<(), T.Error> {
      return seasonComposite.executeRescheduleFixture(rescheduleFixtureDTO);
    };

    public func validateLoanPlayer(loanPlayerDTO: DTOs.LoanPlayerDTO) : async Result.Result<(), T.Error> {
      return playerComposite.validateLoanPlayer(loanPlayerDTO);
    };

    public func executeLoanPlayer(loanPlayerDTO: DTOs.LoanPlayerDTO) : async Result.Result<(), T.Error> {
      return playerComposite.executeLoanPlayer(loanPlayerDTO);
    };

    public func validateTransferPlayer(transferPlayerDTO: DTOs.TransferPlayerDTO) : async Result.Result<(), T.Error> {
      return playerComposite.validateTransferPlayer(transferPlayerDTO);
    };

    public func executeTransferPlayer(transferPlayerDTO: DTOs.TransferPlayerDTO) : async Result.Result<(), T.Error> {
      return playerComposite.executeTransferPlayer(transferPlayerDTO);
    };

    public func validateRecallPlayer(recallPlayerDTO: DTOs.RecallPlayerDTO) : async Result.Result<(), T.Error> {
      return playerComposite.validateRecallPlayer(recallPlayerDTO);
      return #ok();
    };

    public func executeRecallPlayer(recallPlayerDTO: DTOs.RecallPlayerDTO) : async Result.Result<(), T.Error> {
      return playerComposite.executeRecallPlayer(recallPlayerDTO);
    };

    public func validateCreatePlayer(createPlayerDTO: DTOs.CreatePlayerDTO) : async Result.Result<(), T.Error> {
      return playerComposite.validateCreatePlayer(createPlayerDTO);
    };

    public func executeCreatePlayer(createPlayerDTO: DTOs.CreatePlayerDTO) : async Result.Result<(), T.Error> {
      return playerComposite.executeCreatePlayer(createPlayerDTO);
    };

    public func validateUpdatePlayer(updatePlayerDTO: DTOs.UpdatePlayerDTO) : async Result.Result<(), T.Error> {
      return playerComposite.validateUpdatePlayer(updatePlayerDTO);
    };

    public func executeUpdatePlayer(updatePlayerDTO: DTOs.UpdatePlayerDTO) : async Result.Result<(), T.Error> {
      return playerComposite.executeUpdatePlayer(updatePlayerDTO);
    };

    public func validateSetPlayerInjury(setPlayerInjuryDTO: DTOs.SetPlayerInjuryDTO) : async Result.Result<(), T.Error> {
      return playerComposite.validateSetPlayerInjury(setPlayerInjuryDTO);
    };

    public func executeSetPlayerInjury(setPlayerInjuryDTO: DTOs.SetPlayerInjuryDTO) : async Result.Result<(), T.Error> {
      return playerComposite.executeSetPlayerInjury(setPlayerInjuryDTO);
    };
    
    public func validateRetirePlayer(retirePlayerDTO: DTOs.RetirePlayerDTO) : async Result.Result<(), T.Error> {
      return playerComposite.validateRetirePlayer(retirePlayerDTO);
    };

    public func executeRetirePlayer(retirePlayerDTO: DTOs.RetirePlayerDTO) : async Result.Result<(), T.Error> {
      return playerComposite.executeRetirePlayer(retirePlayerDTO);
    };

    public func validateUnretirePlayer(unretirePlayerDTO: DTOs.UnretirePlayerDTO) : async Result.Result<(), T.Error> {
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
