import T "types";
import DTOs "DTOs";
import List "mo:base/List";
import Option "mo:base/Option";
import Nat8 "mo:base/Nat8";
import Debug "mo:base/Debug";
import Result "mo:base/Result";
import HashMap "mo:base/HashMap";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Principal "mo:base/Principal";
import Blob "mo:base/Blob";
import Iter "mo:base/Iter";
import Buffer "mo:base/Buffer";
import Timer "mo:base/Timer";
import Array "mo:base/Array";
import Order "mo:base/Order";
import Int "mo:base/Int";
import Time "mo:base/Time";
import SnapshotFactory "patterns/snapshot-factory";
import StrategyManager "patterns/strategy-manager";
import SeasonComposite "patterns/composites/season-composite";
import PlayerComposite "patterns/composites/player-composite";
import ClubComposite "patterns/composites/club-composite";
import ManagerComposite "patterns/composites/manager-composite";
import LeaderboardComposite "patterns/composites/leaderboard-composite";
import TimerComposite "patterns/composites/timer-composite";
import SHA224 "./lib/SHA224";
import Utilities "utilities";
import CanisterIds "CanisterIds";

module {

  public class SeasonManager() {

    private var setAndBackupTimer : ?((duration : Timer.Duration, callbackName : Text) -> ()) = null;
    
    let strategyManager = StrategyManager.StrategyManager();
    let managerComposite = ManagerComposite.ManagerComposite();
    let playerComposite = PlayerComposite.PlayerComposite();
    let clubComposite = ClubComposite.ClubComposite();
    let seasonComposite = SeasonComposite.SeasonComposite();
    let leaderboardComposite = LeaderboardComposite.LeaderboardComposite();
    
    private var systemState: T.SystemState = {
      calculationGameweek = 1;
      calculationMonth = 8;
      calculationSeason = 1;
      pickTeamGameweek = 1;
      homepageFixturesGameweek = 1;
      homepageManagerGameweek = 0;
      transferWindowActive = false;
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
      stable_timers: [T.TimerInfo],
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
      //timerComposite.setStableData(stable_timers);
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
    
    public func setTimerBackupFunction(_setAndBackupTimer : (duration : Timer.Duration, callbackName : Text) -> ()) {
      setAndBackupTimer := ?_setAndBackupTimer;
    };

    private func updateCacheHash(category : Text) : async () {
      let hashBuffer = Buffer.fromArray<T.DataCache>([]);

      for (hashObj in Iter.fromList(dataCacheHashes)) {
        if (hashObj.category == category) {
          let randomHash = await SHA224.getRandomHash();
          hashBuffer.add({ category = hashObj.category; hash = randomHash });
        } else { hashBuffer.add(hashObj) };
      };

      dataCacheHashes := List.fromArray(Buffer.toArray<T.DataCache>(hashBuffer));
    };
    
    public func getSystemState() : DTOs.SystemStateDTO {
      return systemState;
    };
    
    public func getDataHashes() : [DTOs.DataCacheDTO] {
      return List.toArray(dataCacheHashes);
    };
    
    public func getFixtures(seasonId: T.SeasonId) : [DTOs.FixtureDTO] {
      return seasonComposite.getFixtures(seasonId);
    };
    
    public func getPlayers() : [DTOs.PlayerDTO] {
      return playerComposite.getPlayers(systemState.calculationSeason);
    };

    public func getPlayerDetailsForGameweek(seasonId: T.SeasonId, gameweek: T.GameweekNumber) : [DTOs.PlayerPointsDTO] {
      return playerComposite.getPlayerDetailsForGameweek(seasonId, gameweek);
    };

    public func getWeeklyLeaderboard(seasonId: T.SeasonId, gameweek: T.GameweekNumber, limit : Nat, offset : Nat) : async Result.Result<DTOs.WeeklyLeaderboardDTO, T.Error> {
      return await leaderboardComposite.getWeeklyLeaderboard(seasonId, gameweek, limit, offset);
    };
    
    public func getMonthlyLeaderboard(seasonId: T.SeasonId, month: T.CalendarMonth, clubId: T.ClubId, limit : Nat, offset : Nat) : async Result.Result<DTOs.MonthlyLeaderboardDTO, T.Error>{
      return await leaderboardComposite.getMonthlyLeaderboard(seasonId, month, clubId, limit, offset);
    };

    public func getSeasonLeaderboard(seasonId: T.SeasonId, limit : Nat, offset : Nat) : async Result.Result<DTOs.SeasonLeaderboardDTO, T.Error>{
      return await leaderboardComposite.getSeasonLeaderboard(seasonId, limit, offset);
    };
    
    public func getProfile(principalId: Text) : async Result.Result<DTOs.ProfileDTO, T.Error> {
      return await managerComposite.getProfile(principalId);
    };
    
    public func getManager(principalId: Text) : async Result.Result<DTOs.ProfileDTO, T.Error>{
      return await managerComposite.getManager(principalId);
    };
    
    public func getTotalManagers() : Nat{
      return managerComposite.getTotalManagers();
    };

    public func createProfile(principalId: Text, createProfileDTO: DTOs.ProfileDTO) : async Result.Result<(), T.Error> {
      return await managerComposite.createProfile(principalId, createProfileDTO);
    };

    public func saveFantasyTeam(principalId: Text, updatedFantasyTeam: DTOs.UpdateFantasyTeamDTO) : async Result.Result<(), T.Error>{
      
      if(not strategyManager.isFantasyTeamValid(updatedFantasyTeam)){
        return #err(#InvalidTeamError);
      };

      return await managerComposite.updateManager(principalId, updatedFantasyTeam);
    };

    public func updateUsername(principalId: Text, updatedUsername: Text) : async Result.Result<(), T.Error>{
      return await managerComposite.updateUsername(principalId, updatedUsername);
    };
    
    public func isUsernameAvailable(username: Text) : Bool{
      return managerComposite.isUsernameAvailable(username);
    };

    public func updateFavouriteClub(principalId: Text, clubId: T.ClubId) : async Result.Result<(), T.Error>{
      return await managerComposite.updateFavouriteClub(principalId, clubId);
    };

    //Governance validation and execution functions
    public func validateSubmitFixtureData(submitFixtureDataDTO: DTOs.SubmitFixtureDataDTO) : async Result.Result<Text,Text> {
      return await seasonComposite.validateSubmitFixtureData(submitFixtureDataDTO);
    };

    public func executeSubmitFixtureData(submitFixtureData: DTOs.SubmitFixtureDataDTO) : async () {
      return await seasonComposite.executeSubmitFixtureData(submitFixtureData);
    };
     
    public func validateAddInitialFixtures(addInitialFixturesDTO: DTOs.AddInitialFixturesDTO) : async Result.Result<Text,Text> {
      let clubs = clubComposite.getClubs();
      return await seasonComposite.validateAddInitialFixtures(addInitialFixturesDTO, systemState.calculationSeason, clubs);
    };

    public func executeAddInitialFixtures(addInitialFixturesDTO: DTOs.AddInitialFixturesDTO) : async () { 
      
      await seasonComposite.executeAddInitialFixtures(addInitialFixturesDTO);
      
      let fixtures = seasonComposite.getFixtures(systemState.calculationSeason);
      if(Array.size(fixtures) == 0){
        return;
      };
      
      let sortedArray = Array.sort(fixtures,
        func(a : DTOs.FixtureDTO, b : DTOs.FixtureDTO) : Order.Order {
          if (a.kickOff < b.kickOff) { return #less };
          if (a.kickOff == b.kickOff) { return #equal };
          return #greater;
        },
      );
      
      let firstFixture = sortedArray[0];
      let durationToHourBeforeFirstFixture : Timer.Duration = #nanoseconds(Int.abs(firstFixture.kickOff - Utilities.getHour() - Time.now()));
      switch (setAndBackupTimer) {
        case (null) {};
        case (?actualFunction) {
          actualFunction(durationToHourBeforeFirstFixture, "gameweekBeginExpired");
        };
      };
    };

    public func validateRescheduleFixture(rescheduleFixtureDTO: DTOs.RescheduleFixtureDTO) : async Result.Result<Text,Text> {
      return await seasonComposite.validateRescheduleFixture(rescheduleFixtureDTO);
    };

    public func executeRescheduleFixture(rescheduleFixtureDTO: DTOs.RescheduleFixtureDTO) : async () {
      return await seasonComposite.executeRescheduleFixture(rescheduleFixtureDTO);
    };

    public func validateRevaluePlayerUp(revaluePlayerUpDTO: DTOs.RevaluePlayerUpDTO) : async Result.Result<Text,Text> {
      return await playerComposite.validateRevaluePlayerUp(revaluePlayerUpDTO);
    };

    public func executeRevaluePlayerUp(revaluePlayerUpDTO: DTOs.RevaluePlayerUpDTO) : async () {
       return await playerComposite.executeRevaluePlayerUp(revaluePlayerUpDTO);
    };

    public func validateRevaluePlayerDown(revaluePlayerDownDTO: DTOs.RevaluePlayerDownDTO) : async Result.Result<Text,Text> {
      return await playerComposite.validateRevaluePlayerDown(revaluePlayerDownDTO);
    };

    public func executeRevaluePlayerDown(revaluePlayerDownDTO: DTOs.RevaluePlayerDownDTO) : async () {
      return await playerComposite.executeRevaluePlayerDown(revaluePlayerDownDTO);
    };

    public func validateLoanPlayer(loanPlayerDTO: DTOs.LoanPlayerDTO) : async Result.Result<Text,Text> {
      return await playerComposite.validateLoanPlayer(loanPlayerDTO);
    };

    public func executeLoanPlayer(loanPlayerDTO: DTOs.LoanPlayerDTO) : async () {
      return await playerComposite.executeLoanPlayer(loanPlayerDTO);
    };

    public func validateTransferPlayer(transferPlayerDTO: DTOs.TransferPlayerDTO) : async Result.Result<Text,Text> {
      return await playerComposite.validateTransferPlayer(transferPlayerDTO);
    };

    public func executeTransferPlayer(transferPlayerDTO: DTOs.TransferPlayerDTO) : async () {
      return await playerComposite.executeTransferPlayer(transferPlayerDTO);
    };

    public func validateRecallPlayer(recallPlayerDTO: DTOs.RecallPlayerDTO) : async Result.Result<Text,Text> {
      return await playerComposite.validateRecallPlayer(recallPlayerDTO);
    };

    public func executeRecallPlayer(recallPlayerDTO: DTOs.RecallPlayerDTO) : async () {
      return await playerComposite.executeRecallPlayer(recallPlayerDTO);
    };

    public func validateCreatePlayer(createPlayerDTO: DTOs.CreatePlayerDTO) : async Result.Result<Text,Text> {
      return await playerComposite.validateCreatePlayer(createPlayerDTO);
    };

    public func executeCreatePlayer(createPlayerDTO: DTOs.CreatePlayerDTO) : async () {
      return await playerComposite.executeCreatePlayer(createPlayerDTO);
    };

    public func validateUpdatePlayer(updatePlayerDTO: DTOs.UpdatePlayerDTO) : async Result.Result<Text,Text> {
      return await playerComposite.validateUpdatePlayer(updatePlayerDTO);
    };

    public func executeUpdatePlayer(updatePlayerDTO: DTOs.UpdatePlayerDTO) : async () {
      return await playerComposite.executeUpdatePlayer(updatePlayerDTO);
    };

    public func validateSetPlayerInjury(setPlayerInjuryDTO: DTOs.SetPlayerInjuryDTO) : async Result.Result<Text,Text> {
      return await playerComposite.validateSetPlayerInjury(setPlayerInjuryDTO);
    };

    public func executeSetPlayerInjury(setPlayerInjuryDTO: DTOs.SetPlayerInjuryDTO) : async () {
      return await playerComposite.executeSetPlayerInjury(setPlayerInjuryDTO);
    };
    
    public func validateRetirePlayer(retirePlayerDTO: DTOs.RetirePlayerDTO) : async Result.Result<Text,Text> {
      return await playerComposite.validateRetirePlayer(retirePlayerDTO);
    };

    public func executeRetirePlayer(retirePlayerDTO: DTOs.RetirePlayerDTO) : async () {
      return await playerComposite.executeRetirePlayer(retirePlayerDTO);
    };

    public func validateUnretirePlayer(unretirePlayerDTO: DTOs.UnretirePlayerDTO) : async Result.Result<Text,Text> {
      return await playerComposite.validateUnretirePlayer(unretirePlayerDTO);
    };
    
    public func executeUnretirePlayer(unretirePlayerDTO: DTOs.UnretirePlayerDTO) : async () {
      return await playerComposite.executeUnretirePlayer(unretirePlayerDTO);
    };

    public func validatePromoteFormerClub(promoteFormerClubDTO: DTOs.PromoteFormerClubDTO) : async Result.Result<Text,Text> {
      return await clubComposite.validatePromoteFormerClub(promoteFormerClubDTO);
    };

    public func executePromoteFormerClub(promoteFormerClubDTO: DTOs.PromoteFormerClubDTO) : async () {
      return await clubComposite.executePromoteFormerClub(promoteFormerClubDTO);
    };

    public func validatePromoteNewClub(promoteNewClubDTO: DTOs.PromoteNewClubDTO) : async Result.Result<Text,Text> {
      return await clubComposite.validatePromoteNewClub(promoteNewClubDTO);
    };

    public func executePromoteNewClub(promoteNewClubDTO: DTOs.PromoteNewClubDTO) : async () {
      return await clubComposite.executePromoteNewClub(promoteNewClubDTO);
    };

    public func validateUpdateClub(updateClubDTO: DTOs.UpdateClubDTO) : async Result.Result<Text,Text> {
      return await clubComposite.validateUpdateClub(updateClubDTO);
    };

    public func executeUpdateClub(updateClubDTO: DTOs.UpdateClubDTO) : async () {
      return await clubComposite.executeUpdateClub(updateClubDTO);
    };
    
    //Stable data getters and setters:
    public func getStableManagers(): [(Text, T.Manager)] {
      return managerComposite.getStableManagers();
    };

    public func setStableManagers(stable_managers: [(Text, T.Manager)]){
      managerComposite.setStableManagers(stable_managers);
    };

    public func getStableProfilePictureCanisterIds(): [(T.PrincipalId, Text)] {
      return managerComposite.getStableProfilePictureCanisterIds();
    };

    public func setStableProfilePictureCanisterIds(stable_profile_picture_canister_ids: [(T.PrincipalId, Text)]){
      managerComposite.setStableProfilePictureCanisterIds(stable_profile_picture_canister_ids);
    };

    public func getStableSeasonLeaderboardCanisterIds(): [(T.SeasonId, Text)] {
      return leaderboardComposite.getStableSeasonLeaderboardCanisterIds();
    };

    public func setStableSeasonLeaderboardCanisterIds(stable_season_leaderboard_canister_ids: [(T.SeasonId, Text)]) {
      leaderboardComposite.setStableSeasonLeaderboardCanisterIds(stable_season_leaderboard_canister_ids);
    };

    public func getStableMonthlyLeaderboardCanisterIds(): [(T.MonthlyLeaderboardKey, Text)] {
      return leaderboardComposite.getStableMonthlyLeaderboardCanisterIds();
    };

    public func setStableMonthlyLeaderboardCanisterIds(stable_monthly_leaderboard_canister_ids: [(T.MonthlyLeaderboardKey, Text)]) {
      leaderboardComposite.setStableMonthlyLeaderboardCanisterIds(stable_monthly_leaderboard_canister_ids);
    };

    public func getStableWeeklyLeaderboardCanisterIds(): [(T.WeeklyLeaderboardKey, Text)] {
      return leaderboardComposite.getStableWeeklyLeaderboardCanisterIds();
    };

    public func setStableWeeklyLeaderboardCanisterIds(stable_weekly_leaderboard_canister_ids: [(T.WeeklyLeaderboardKey, Text)]) {
      leaderboardComposite.setStableWeeklyLeaderboardCanisterIds(stable_weekly_leaderboard_canister_ids);
    };

    public func getStableClubs(): [T.Club] {
      return clubComposite.getStableClubs();
    };

    public func setStableClubs(stable_clubs: [T.Club]) {
      clubComposite.setStableClubs(stable_clubs);
    };

    public func getStableRelegatedClubs(): [T.Club] {
      return clubComposite.getStableRelegatedClubs();
    };

    public func setStableRelegatedClubs(stable_relegated_clubs: [T.Club]) {
      clubComposite.setStableRelegatedClubs(stable_relegated_clubs);
    };

    public func getStableNextClubId(): T.ClubId {
      return clubComposite.getStableNextClubId();
    };

    public func setStableNextClubId(stable_next_club_id: T.ClubId) {
      clubComposite.setStableNextClubId(stable_next_club_id);
    };

    public func getStablePlayers(): [T.Player] {
      return playerComposite.getStablePlayers();
    };

    public func setStablePlayers(stable_players: [T.Player]) {
      playerComposite.setStablePlayers(stable_players);
    };

    public func getStableNextPlayerId() : T.PlayerId {
      return playerComposite.getStableNextPlayerId();
    };

    public func setStableNextPlayerId(stable_next_player_id: T.PlayerId) {
      playerComposite.setStableNextPlayerId(stable_next_player_id);
    };

    public func getStableSeasons() : [T.Season] {
      return seasonComposite.getStableSeasons();
    };

    public func setStableSeasons(stable_seasons: [T.Season]) {
      seasonComposite.setStableSeasons(stable_seasons);
    };

    public func getStableNextSeasonId() : T.SeasonId {
      return seasonComposite.getStableNextSeasonId();
    };

    public func setStableNextSeasonId(stable_next_season_id: T.SeasonId) {
      seasonComposite.setStableNextSeasonId(stable_next_season_id);
    };

    public func getStableNextFixtureId() : T.FixtureId {
      return seasonComposite.getStableNextFixtureId();
    };

    public func setStableNextFixtureId(stable_next_fixture_id: T.FixtureId) {
      seasonComposite.setStableNextFixtureId(stable_next_fixture_id);
    };

    public func getStableDataHashes() : [T.DataCache] {
      return List.toArray(dataCacheHashes);
    };

    public func setStableDataHashes(stable_data_cache_hashes: [T.DataCache]) {
      dataCacheHashes := List.fromArray(stable_data_cache_hashes);
    };

    public func getStableSystemState()  : T.SystemState {
      return systemState;
    };

    public func setStableSystemState(stable_system_state: T.SystemState) {
      systemState := stable_system_state;
    };
  };
};
