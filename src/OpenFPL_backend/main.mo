import Result "mo:base/Result";
import Time "mo:base/Time";
import Array "mo:base/Array";
import Timer "mo:base/Timer";
import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";
import Int "mo:base/Int";
import SeasonManager "season-manager";
import T "types";
import DTOs "DTOs";

actor Self {

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

  private func transferWindowStartCallback() : async () {
    await seasonManager.transferWindowStartCallback();
    removeExpiredTimers();
  };

  private func transferWindowEndCallback() : async () {
    await seasonManager.transferWindowEndCallback();
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

    var timerBuffer = Buffer.fromArray<T.TimerInfo>(stable_timers);
    timerBuffer.add(newTimerInfo);
    stable_timers := Buffer.toArray(timerBuffer);
  };
  private func defaultCallback() : async () {};

  let seasonManager = SeasonManager.SeasonManager(setAndBackupTimer);  

  public shared query func getDataHashes() : async Result.Result<DTOs.DataCacheDTO, T.Error> {
    return seasonManager.getDataHashes();
  };

  public shared query func getFixtures(seasonId: T.SeasonId) : async Result.Result<[DTOs.FixtureDTO], T.Error>  {
    return seasonManager.getFixtures(seasonId);
  };

  public shared query func getWeeklyLeaderboard(seasonId: T.SeasonId, gameweek: T.GameweekNumber) : async Result.Result<[DTOs.WeeklyLeaderboardDTO], T.Error>  {
    return seasonManager.getWeeklyLeaderboard(seasonId, gameweek);
  };

  public shared query func getMonthlyLeaderboard(seasonId: T.SeasonId, clubId: T.ClubId, month: T.CalendarMonth) : async Result.Result<[DTOs.MonthlyLeaderboardDTO], T.Error>  {
    return seasonManager.getMonthlyLeaderboard(seasonId, clubId, month);
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
    
  public shared func validateRevaluePlayerUp(revaluePlayerUpDTO: DTOs.RevaluePlayerUpDTO) : async Result.Result<(), T.Error> {
    return seasonManager.validateRevaluePlayerUp(revaluePlayerUpDTO);
  };

  public shared func executeRevaluePlayerUp(revaluePlayerUpDTO: DTOs.RevaluePlayerUpDTO) : async Result.Result<(), T.Error> {
    return seasonManager.executeRevaluePlayerUp(revaluePlayerUpDTO);
  };

  public shared func validateRevaluePlayerDown(revaluePlayerDownDTO: DTOs.RevaluePlayerDownDTO) : async Result.Result<(), T.Error> {
    return seasonManager.validateRevaluePlayerDown(revaluePlayerDownDTO);
  };

  public shared func executeRevaluePlayerDown(revaluePlayerDownDTO: DTOs.RevaluePlayerDownDTO) : async Result.Result<(), T.Error> {
    return seasonManager.executeRevaluePlayerDown(revaluePlayerDownDTO);
  };

  public shared func validateSubmitFixtureData(submitFixtureData: DTOs.SubmitFixtureDataDTO) : async Result.Result<(), T.Error> {
    return seasonManager.validateSubmitFixtureData(submitFixtureData);
  };

  public shared func executeSubmitFixtureData(submitFixtureData: DTOs.SubmitFixtureDataDTO) : async Result.Result<(), T.Error> {
    return seasonManager.executeSubmitFixtureData(submitFixtureData);
  };

  public shared func validateAddInitialFixtures(addInitialFixturesDTO: DTOs.AddInitialFixturesDTO) : async Result.Result<(), T.Error> {
    return seasonManager.validateAddInitialFixtures(addInitialFixturesDTO);
  };

  public shared func executeAddInitialFixtures(addInitialFixturesDTO: DTOs.AddInitialFixturesDTO) : async Result.Result<(), T.Error> {
    return seasonManager.executeAddInitialFixtures(addInitialFixturesDTO); 
  };

  public shared func validateRescheduleFixture(rescheduleFixtureDTO: DTOs.RescheduleFixtureDTO) : async Result.Result<(), T.Error> {
    return seasonManager.validateRescheduleFixture(rescheduleFixtureDTO);
  };

  public shared func executeRescheduleFixture(rescheduleFixtureDTO: DTOs.RescheduleFixtureDTO) : async Result.Result<(), T.Error> {
    return seasonManager.executeRescheduleFixture(rescheduleFixtureDTO);
  };

  public shared func validateLoanPlayer(loanPlayerDTO: DTOs.LoanPlayerDTO) : async Result.Result<(), T.Error> {
    return seasonManager.validateLoanPlayer(loanPlayerDTO);
  };

  public shared func executeLoanPlayer(loanPlayerDTO: DTOs.LoanPlayerDTO) : async Result.Result<(), T.Error> {
    return seasonManager.executeLoanPlayer(loanPlayerDTO);
  };

  public shared func validateTransferPlayer(transferPlayerDTO: DTOs.TransferPlayerDTO) : async Result.Result<(), T.Error> {
    return seasonManager.validateTransferPlayer(transferPlayerDTO);
  };

  public shared func executeTransferPlayer(transferPlayerDTO: DTOs.TransferPlayerDTO) : async Result.Result<(), T.Error> {
    return seasonManager.executeTransferPlayer(transferPlayerDTO);
  };

  public shared func validateRecallPlayer(recallPlayerDTO: DTOs.RecallPlayerDTO) : async Result.Result<(), T.Error> {
    return seasonManager.validateRecallPlayer(recallPlayerDTO);
  };

  public shared func executeRecallPlayer(recallPlayerDTO: DTOs.RecallPlayerDTO) : async Result.Result<(), T.Error> {
    return seasonManager.executeRecallPlayer(recallPlayerDTO);
  };

  public shared func validateCreatePlayer(createPlayerDTO: DTOs.CreatePlayerDTO) : async Result.Result<(), T.Error> {
    return seasonManager.validateCreatePlayer(createPlayerDTO);
  };

  public shared func executeCreatePlayer(createPlayerDTO: DTOs.CreatePlayerDTO) : async Result.Result<(), T.Error> {
    return seasonManager.executeCreatePlayer(createPlayerDTO);
  };

  public shared func validateUpdatePlayer(updatePlayerDTO: DTOs.UpdatePlayerDTO) : async Result.Result<(), T.Error> {
    return seasonManager.validateUpdatePlayer(updatePlayerDTO);
  };

  public shared func executeUpdatePlayer(updatePlayerDTO: DTOs.UpdatePlayerDTO) : async Result.Result<(), T.Error> {
    return seasonManager.executeUpdatePlayer(updatePlayerDTO);
  };

  public shared func validateSetPlayerInjury(setPlayerInjuryDTO: DTOs.SetPlayerInjuryDTO) : async Result.Result<(), T.Error> {
    return seasonManager.validateSetPlayerInjury(setPlayerInjuryDTO);
  };

  public shared func executeSetPlayerInjury(setPlayerInjuryDTO: DTOs.SetPlayerInjuryDTO) : async Result.Result<(), T.Error> {
    return seasonManager.executeSetPlayerInjury(setPlayerInjuryDTO);
  };
  
  public shared func validateRetirePlayer(retirePlayerDTO: DTOs.RetirePlayerDTO) : async Result.Result<(), T.Error> {
    return seasonManager.validateRetirePlayer(retirePlayerDTO);
  };

  public shared func executeRetirePlayer(retirePlayerDTO: DTOs.RetirePlayerDTO) : async Result.Result<(), T.Error> {
    return seasonManager.executeRetirePlayer(retirePlayerDTO);
  };

  public shared func validateUnretirePlayer(unretirePlayerDTO: DTOs.UnretirePlayerDTO) : async Result.Result<(), T.Error> {
    return seasonManager.validateUnretirePlayer(unretirePlayerDTO);
  };
  
  public shared func executeUnretirePlayer(unretirePlayerDTO: DTOs.UnretirePlayerDTO) : async Result.Result<(), T.Error> {
    return seasonManager.executeUnretirePlayer(unretirePlayerDTO);
  };

  public shared func validatePromoteFormerClub(promoteFormerClubDTO: DTOs.PromoteFormerClubDTO) : async Result.Result<(), T.Error> {
    return seasonManager.validatePromoteFormerClub(promoteFormerClubDTO);
  };

  public shared func executePromoteFormerClub(promoteFormerClubDTO: DTOs.PromoteFormerClubDTO) : async Result.Result<(), T.Error> {
    return seasonManager.executePromoteFormerClub(promoteFormerClubDTO);
  };

  public shared func validatePromoteNewClub(promoteNewClubDTO: DTOs.PromoteNewClubDTO) : async Result.Result<(), T.Error> {
    return seasonManager.validatePromoteNewClub(promoteNewClubDTO);
  };

  public shared func executePromoteNewClub(promoteNewClubDTO: DTOs.PromoteNewClubDTO) : async Result.Result<(), T.Error> {
    return seasonManager.executePromoteNewClub(promoteNewClubDTO);
  };

  public shared func validateUpdateClub(updateClubDTO: DTOs.UpdateClubDTO) : async Result.Result<(), T.Error> {
    return seasonManager.validateUpdateClub(updateClubDTO);
  };

  public shared func executeUpdateClub(updateClubDTO: DTOs.UpdateClubDTO) : async Result.Result<(), T.Error> {
    return seasonManager.executeUpdateClub(updateClubDTO);
  };



  //DO SEASON MANAGER SO I KNOW THE DATA THAT NEEDS BACKING UP!

  //stable variable backup
  /*
  private stable var stable_profiles : [(Text, T.Profile)] = [];
  private stable var stable_fantasy_teams : [(Text, T.UserFantasyTeam)] = [];
  private stable var stable_active_season_id : Nat16 = 0;
  private stable var stable_active_gameweek : Nat8 = 0;
  private stable var stable_interesting_gameweek : Nat8 = 0;
  private stable var stable_active_fixtures : [T.Fixture] = [];
  private stable var stable_next_fixture_id : Nat32 = 0;
  private stable var stable_next_season_id : Nat16 = 0;
  private stable var stable_seasons : [T.Season] = [];
  private stable var stable_clubs : [T.Club] = [];
  private stable var stable_relegated_clubs : [T.Team] = [];
  private stable var stable_next_team_id : Nat16 = 0;
  private stable var stable_max_votes_per_user : Nat64 = 0;
  private stable var stable_season_leaderboards : [(Nat16, T.SeasonLeaderboards)] = [];
  private stable var stable_monthly_leaderboards : [(T.SeasonId, List.List<T.ClubLeaderboard>)] = [];
  private stable var stable_data_cache_hashes : [T.DataCache] = [];
*/
  private stable var stable_timers : [T.TimerInfo] = [];

  system func preupgrade() {
    /*
    stable_fantasy_teams := fantasyTeamsInstance.getFantasyTeams();
    stable_profiles := profilesInstance.getProfiles();
    stable_active_season_id := seasonManager.getActiveSeasonId();
    stable_active_gameweek := seasonManager.getActiveGameweek();
    stable_interesting_gameweek := seasonManager.getInterestingGameweek();
    stable_next_fixture_id := seasonManager.getNextFixtureId();
    stable_next_season_id := seasonManager.getNextSeasonId();
    stable_seasons := seasonManager.getSeasons();
    stable_clubs := teamsInstance.getTeams();
    stable_relegated_clubs := teamsInstance.getRelegatedTeams();
    stable_next_club_id := teamsInstance.getNextTeamId();
    stable_season_leaderboards := fantasyTeamsInstance.getSeasonLeaderboards();
    stable_monthly_leaderboards := fantasyTeamsInstance.getMonthlyLeaderboards();
    stable_data_cache_hashes := List.toArray(dataCacheHashes);
    */
  };

  system func postupgrade() {
    /*
    profilesInstance.setData(stable_profiles);
    fantasyTeamsInstance.setData(stable_fantasy_teams);
    seasonManager.setData(stable_seasons, stable_active_season_id, stable_active_gameweek, stable_active_fixtures, stable_next_fixture_id, stable_next_season_id, stable_interesting_gameweek);
    teamsInstance.setData(stable_teams, stable_next_team_id, stable_relegated_teams);
    fantasyTeamsInstance.setDataForSeasonLeaderboards(stable_season_leaderboards);
    fantasyTeamsInstance.setDataForMonthlyLeaderboards(stable_monthly_leaderboards);
    dataCacheHashes := List.fromArray(stable_data_cache_hashes);
    */
    recreateTimers();
  };

  private func recreateTimers() {
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

};
