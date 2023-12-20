import Array "mo:base/Array";
import Blob "mo:base/Blob";
import Buffer "mo:base/Buffer";
import Hash "mo:base/Hash";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import List "mo:base/List";
import Nat8 "mo:base/Nat8";
import Nat16 "mo:base/Nat16";
import Nat32 "mo:base/Nat32";
import Option "mo:base/Option";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Text "mo:base/Text";
import Time "mo:base/Time";
import Timer "mo:base/Timer";
import TrieMap "mo:base/TrieMap";

import Account "Account";
import Book "book";
import Countries "Countries";
import FantasyTeams "fantasy-teams";
import Teams "teams";
import Profiles "profiles";
import Rewards "rewards";
import SeasonManager "season-manager";
import SHA224 "SHA224";
import Utilities "utilities";

import T "types";
import DTOs "DTOs";

actor Self {

  let seasonManager = SeasonManager.SeasonManager();  
  
  let closeGameweekTimer: ?Timer = null;
  let janTransferWindowStart: ?Timer = null;
  let activeGameTimers: [Timer] = [];

  public shared func init() : async Result.Result<(), T.Error>  {
    let firstFixture = seasonManager.init();
    switch(firstFixture){
      case (null) {

      };
      case (?returnedFixture){
        //set a timer for 1 hour before the first kick off to begin everything
      };
    };
  };

  private func gameweekBeginExpiredCallback() : async () {
    await seasonManager.gameweekBegin();
    removeExpiredTimers();
  };

  private func gameKickOffExpiredCallback() : async () {
    await seasonManager.gameKickOff();
    removeExpiredTimers();
  };

  private func gameCompletedExpiredCallback() : async () {
    await seasonManager.gameCompleted();
    removeExpiredTimers();
  };

  private func loanExpiredCallback() : async () {
    await seasonManager.loanExpiredCallback();
    removeExpiredTimers();
  };

  private func removeExpiredTimers() : () {
    let currentTime = Time.now();
    stable_timers := Array.filter<T.TimerInfo>(
      stable_timers,
      func(timer : T.TimerInfo) : Bool {
        return timer.triggerTime > currentTime;
      },
    );
  };

  private func setAndBackupTimer(duration : Timer.Duration, callbackName : Text, fixtureId : T.FixtureId) : async () {
    let jobId : Timer.TimerId = switch (callbackName) {
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
        Timer.setTimer(duration, gameCompletedExpiredCallback);
      };
      case _ { };
    };

    let triggerTime = switch (duration) {
      case (#seconds s) {
        Time.now() + s * 1_000_000_000;
      };
      case (#nanoseconds ns) {
        Time.now() + ns;
      };
    };

    let timerInfo : T.TimerInfo = {
      id = jobId;
      triggerTime = triggerTime;
      callbackName = callbackName;
      playerId = 0;
      fixtureId = 0;
    };

    var timerBuffer = Buffer.fromArray<T.TimerInfo>(stable_timers);
    timerBuffer.add(timerInfo);
    stable_timers := Buffer.toArray(timerBuffer);
  };

  public shared query func getDataHashes() : async Result.Result<DTOs.DataCacheDTO, T.Error> {
    return seasonManager.getDataHashes();
  };

  public shared query func getFixtures(seasonId: T.SeasonId) : async Result.Result<[DTOs.FixtureDTO], T.Error>  {
    return seasonManager.getFixtures(seasonId);
  };

  public shared query func getWeeklyLeaderboard(seasonId: T.SeasonId, gameweek: T.GameweekNumber) : async Result.Result<[DTOs.WeeklyLeaderboardDTO], T.Error>  {
    return seasonManager.getWeeklyLeaderboard(seasonId, gameweek);
  };

  public shared query func getClubLeaderboard(seasonId: T.SeasonId, clubId: T.ClubId, month: T.CalendarMonth) : async Result.Result<[DTOs.ClubLeaderboardDTO], T.Error>  {
    return seasonManager.getClubLeaderboard(seasonId, clubId, month);
  };

  public shared query func getSeasonLeaderboard(seasonId: T.SeasonId) : async Result.Result<[DTOs.SeasonLeaderboardDTO], T.Error>  {
    return seasonManager.getSeasonLeaderboard(seasonId);
  };

  public shared query ({ caller }) func getProfile() : async Result.Result<[DTOs.ProfileDTO], T.Error>  {
    assert not Principal.isAnonymous(caller);
    return seasonManager.getProfile(Principal.toText(caller));
  };

  public shared query func getManager(principalId: Text) : async Result.Result<[DTOs.ProfileDTO], T.Error>  {
    return seasonManager.getProfile(principalId);
  };

  public shared query func getTotalManagers() : async Result.Result<[Nat], T.Error>  {
    return seasonManager.getTotalManagers();
  };

  public shared query func getSystemState() : async Result.Result<[DTOs.SystemStateDTO], T.Error>  {
    return seasonManager.getSystemState();
  };

  public shared query func getPlayers() : async Result.Result<[DTOs.PlayerDTO], T.Error>  {
    return seasonManager.getPlayers();
  };

  public shared query func getDetailedPlayers(seasonId: T.SeasonId, gameweek: T.GameweekNumber) : async Result.Result<[DTOs.PlayerDTO], T.Error>  {
    return seasonManager.getDetailedPlayers(seasonId, gameweek);
  };

  public shared query func getCountries() : async Result.Result<[DTOs.CountryDTO], T.Error>  {
    return List.toArray(countriesInstance.countries);
  };

  public shared query ({ caller }) func isUsernameAvailable(username : Text) : async Bool {
    assert not Principal.isAnonymous(caller);
    return seasonManager.isUsernameAvailable(username);
  };

  public shared ({ caller }) func createProfile() : async () {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    return await seasonManager.createProfile(principalId);
  };

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

  public shared ({ caller }) func updateProfilePicture(profilePicture : Blob) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    return await seasonManager.updateProfilePicture(principalId, profilePicture);
  };

  public shared ({ caller }) func saveFantasyTeam(fantasyTeam: DTOs.UpdateFantasyTeamDTO) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    return await seasonManager.saveFantasyTeam(principalId, fantasyTeam);
  };
    




  
  //All the governance entry points

  //Governance canister validation
  public shared func validateRevaluePlayerUp(playerId : T.PlayerId) : async Result.Result<(), T.Error> {
    return seasonManager.validateRevaluePlayerUp(playerId);
  };

  public shared func validateRevaluePlayerDown(playerId : T.PlayerId) : async Result.Result<(), T.Error> {
       return seasonManager.validateRevaluePlayerDown(playerId);
  };

  public shared func validateSubmitFixtureData(fixtureId : T.FixtureId, playerEventData : [T.PlayerEventData]) : async Result.Result<(), T.Error> {
    return seasonManager.validateSubmitFixtureData(fixtureId, playerEventData);
  };

  public shared func validateAddInitialFixtures(seasonId : T.SeasonId, seasonFixtures : [T.Fixture]) : async Result.Result<(), T.Error> {
    return seasonManager.validateAddInitialFixtures(seasonId, seasonFixtures);
  };

  public shared func validateRescheduleFixtures(fixtureId : T.FixtureId, currentFixtureGameweek : T.GameweekNumber, updatedFixtureGameweek : T.GameweekNumber, updatedFixtureDate : Int) : async Result.Result<(), T.Error> {
    return seasonManager.validateRescheduleFixtures(fixtureId, currentFixtureGameweek);
  };

  public shared func validateLoanPlayer(playerId : T.PlayerId, loanTeamId : T.TeamId, loanEndDate : Int) : async Result.Result<(), T.Error> {
   return seasonManager.validateLoanPlayer(fixtureId, currentFixtureGameweek);
 
  };

  public shared func validateTransferPlayer(playerId : T.PlayerId, newTeamId : T.TeamId) : async Result.Result<(), T.Error> {
   return seasonManager.validateTransferPlayer(fixtureId, currentFixtureGameweek);
 
  };

  public shared func validateRecallPlayer(recallPlayerDTO: DTOs.RecallPlayerDTO) : async Result.Result<(), T.Error> {
   return seasonManager.validateRecallPlayer(recallPlayerDTO);
  };

  public shared func validateCreatePlayer(createPlayerDTO: DTOs.CreatePlayerDTO) : async Result.Result<(), T.Error> {
      return seasonManager.validateCreatePlayer(createPlayerDTO);
  };

  public shared func validateUpdatePlayer(updatePlayerDTO: DTOs.UpdatePlayerDTO) : async Result.Result<(), T.Error> {
      return seasonManager.validateUpdatePlayer(fixtureId, currentFixtureGameweek);
 
  };

  public shared func validateSetPlayerInjury(setPlayerInjuryDTO: SetPlayerInjuryDTO) : async Result.Result<(), T.Error> {
      return seasonManager.validateSetPlayerInjury(setPlayerInjuryDTO);
  };

  public shared func validateRetirePlayer(playerId : T.PlayerId, retirementDate : Int) : async Result.Result<(), T.Error> {
       return seasonManager.validateRetirePlayer(fixtureId, currentFixtureGameweek);
 
  };

  public shared func validateUnretirePlayer(playerId : T.PlayerId) : async Result.Result<(), T.Error> {
      return seasonManager.validateUnretirePlayer(fixtureId, currentFixtureGameweek);
 
  };

  public shared func validatePromoteFormerTeam(teamId : T.TeamId) : async Result.Result<(), T.Error> {
   return seasonManager.validatePromoteFormerTeam(fixtureId, currentFixtureGameweek);
 
  };

  public shared func validatePromoteNewTeam(name : Text, friendlyName : Text, abbreviatedName : Text, primaryHexColour : Text, secondaryHexColour : Text, thirdHexColour : Text) : async Result.Result<(), T.Error> {
   return seasonManager.validatePromoteNewTeam(fixtureId, currentFixtureGameweek);
 
  };

  public shared func validateUpdateTeam(teamId : T.TeamId, name : Text, friendlyName : Text, abbreviatedName : Text, primaryHexColour : Text, secondaryHexColour : Text, thirdHexColour : Text) : async Result.Result<(), T.Error> {

      return seasonManager.validateUpdateTeam(fixtureId, currentFixtureGameweek);
 
  };

  //Governance target methods

  public shared func executeRevaluePlayerUp(playerId : T.PlayerId) : async Result.Result<(), T.Error> {
      return seasonManager.executeRevaluePlayerUp(fixtureId, currentFixtureGameweek);
 
  };

  public shared func executeRevaluePlayerDown(seasonId : T.SeasonId, gameweek : T.GameweekNumber, playerId : T.PlayerId) : async Result.Result<(), T.Error> {
       return seasonManager.executeRevaluePlayerDown(fixtureId, currentFixtureGameweek);
 
  };

  public shared func executeSubmitFixtureData(fixtureId : T.FixtureId, playerEventData : [T.PlayerEventData]) : async Result.Result<(), T.Error> {
   return seasonManager.executeSubmitFixtureData(fixtureId, currentFixtureGameweek);
 
  };

  public shared func executeAddInitialFixtures(seasonId : T.SeasonId, seasonFixtures : [T.Fixture]) : async Result.Result<(), T.Error> {
      return seasonManager.executeAddInitialFixtures(fixtureId, currentFixtureGameweek);
 
  };

  public shared func executeRescheduleFixture(fixtureId : T.FixtureId, currentFixtureGameweek : T.GameweekNumber, updatedFixtureGameweek : T.GameweekNumber, updatedFixtureDate : Int) : async Result.Result<(), T.Error> {
       return seasonManager.executeRescheduleFixture(fixtureId, currentFixtureGameweek);
 
  };

  public shared func executeTransferPlayer(playerId : T.PlayerId, newTeamId : T.TeamId) : async Result.Result<(), T.Error> {
      return seasonManager.executeTransferPlayer(fixtureId, currentFixtureGameweek);
 
  };

  public shared func executeLoanPlayer(playerId : T.PlayerId, loanTeamId : T.TeamId, loanEndDate : Int) : async Result.Result<(), T.Error> {
      return seasonManager.executeLoanPlayer(fixtureId, currentFixtureGameweek);
 
  };

  public shared func executeRecallPlayer(playerId : T.PlayerId) : async Result.Result<(), T.Error> {
      return seasonManager.executeRecallPlayer(fixtureId, currentFixtureGameweek);
 
  };

  public shared func executeCreatePlayer(teamId : T.TeamId, position : Nat8, firstName : Text, lastName : Text, shirtNumber : Nat8, value : Nat, dateOfBirth : Int, nationality : T.CountryId) : async Result.Result<(), T.Error> {
      return seasonManager.executeCreatePlayer(fixtureId, currentFixtureGameweek);
 
  };

  public shared func executeUpdatePlayer(playerId : T.PlayerId, position : Nat8, firstName : Text, lastName : Text, shirtNumber : Nat8, dateOfBirth : Int, nationality : T.CountryId) : async Result.Result<(), T.Error> {
       return seasonManager.executeUpdatePlayer(fixtureId, currentFixtureGameweek);
 
  };

  public shared func executeSetPlayerInjury(playerId : T.PlayerId, description : Text, expectedEndDate : Int) : async Result.Result<(), T.Error> {
     return seasonManager.executeSetPlayerInjury(fixtureId, currentFixtureGameweek);
 
  };

  public shared func executeRetirePlayer(playerId : T.PlayerId, retirementDate : Int) : async Result.Result<(), T.Error> {
      return seasonManager.executeRetirePlayer(fixtureId, currentFixtureGameweek);
 
  };

  public shared func executeUnretirePlayer(playerId : T.PlayerId) : async Result.Result<(), T.Error> {
       return seasonManager.executeUnretirePlayer(fixtureId, currentFixtureGameweek);
 
  };

  public shared func executePromoteFormerClub(teamId : T.TeamId) : async Result.Result<(), T.Error> {
       return seasonManager.executePromoteFormerTeam(fixtureId, currentFixtureGameweek);
 
  };

  public shared func executePromoteNewTeam(name : Text, friendlyName : Text, abbreviatedName : Text, primaryHexColour : Text, secondaryHexColour : Text, thirdHexColour : Text, shirtType : Nat8) : async Result.Result<(), T.Error> {
       return seasonManager.executePromoteNewTeam(fixtureId, currentFixtureGameweek);
 
  };

  public shared func executeUpdateTeam(teamId : T.TeamId, name : Text, friendlyName : Text, abbreviatedName : Text, primaryHexColour : Text, secondaryHexColour : Text, thirdHexColour : Text, shirtType : Nat8) : async Result.Result<(), T.Error> {
      return seasonManager.executeUpdateTeam(teamId, name);
 
  };







  //stable variable backup
  private stable var stable_profiles : [(Text, T.Profile)] = [];
  private stable var stable_fantasy_teams : [(Text, T.UserFantasyTeam)] = [];
  private stable var stable_active_season_id : Nat16 = 0;
  private stable var stable_active_gameweek : Nat8 = 0;
  private stable var stable_interesting_gameweek : Nat8 = 0;
  private stable var stable_active_fixtures : [T.Fixture] = [];
  private stable var stable_next_fixture_id : Nat32 = 0;
  private stable var stable_next_season_id : Nat16 = 0;
  private stable var stable_seasons : [T.Season] = [];
  private stable var stable_teams : [T.Team] = [];
  private stable var stable_relegated_teams : [T.Team] = [];
  private stable var stable_next_team_id : Nat16 = 0;
  private stable var stable_max_votes_per_user : Nat64 = 0;
  private stable var stable_season_leaderboards : [(Nat16, T.SeasonLeaderboards)] = [];
  private stable var stable_monthly_leaderboards : [(T.SeasonId, List.List<T.ClubLeaderboard>)] = [];
  private stable var stable_data_cache_hashes : [T.DataCache] = [];
  private stable var stable_timers : [T.TimerInfo] = [];

  system func preupgrade() {

    stable_fantasy_teams := fantasyTeamsInstance.getFantasyTeams();
    stable_profiles := profilesInstance.getProfiles();
    stable_active_season_id := seasonManager.getActiveSeasonId();
    stable_active_gameweek := seasonManager.getActiveGameweek();
    stable_interesting_gameweek := seasonManager.getInterestingGameweek();
    stable_next_fixture_id := seasonManager.getNextFixtureId();
    stable_next_season_id := seasonManager.getNextSeasonId();
    stable_seasons := seasonManager.getSeasons();
    stable_teams := teamsInstance.getTeams();
    stable_relegated_teams := teamsInstance.getRelegatedTeams();
    stable_next_team_id := teamsInstance.getNextTeamId();
    stable_season_leaderboards := fantasyTeamsInstance.getSeasonLeaderboards();
    stable_monthly_leaderboards := fantasyTeamsInstance.getMonthlyLeaderboards();
    stable_data_cache_hashes := List.toArray(dataCacheHashes);
  };

  system func postupgrade() {
    profilesInstance.setData(stable_profiles);
    fantasyTeamsInstance.setData(stable_fantasy_teams);
    seasonManager.setData(stable_seasons, stable_active_season_id, stable_active_gameweek, stable_active_fixtures, stable_next_fixture_id, stable_next_season_id, stable_interesting_gameweek);
    teamsInstance.setData(stable_teams, stable_next_team_id, stable_relegated_teams);
    fantasyTeamsInstance.setDataForSeasonLeaderboards(stable_season_leaderboards);
    fantasyTeamsInstance.setDataForMonthlyLeaderboards(stable_monthly_leaderboards);
    dataCacheHashes := List.fromArray(stable_data_cache_hashes);
    recreateTimers();
  };

  private func recreateTimers() { //NEED TO MAKE SURE THESE ARE THE CORRECT TIMERS TO USE
    let currentTime = Time.now();
    for (timerInfo in Iter.fromArray(stable_timers)) {
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
          case _ {
            ignore Timer.setTimer(duration, defaultCallback);
          };
        };
      };
    };

    //recreate close gameweek timer to be 1 hour before the first fixture of the gameweek you are picking your team for

    //recreate the jan transfer window timer to the next January 1st

    //recreate the close jan transfer window timer for midnight on the 31st Jan

    //recreate timers for active games that are counting down to move a game from inactive to active or active to completed

  };

};
