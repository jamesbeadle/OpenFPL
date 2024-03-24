import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Cycles "mo:base/ExperimentalCycles";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Time "mo:base/Time";
import Timer "mo:base/Timer";
import Nat64 "mo:base/Nat64";

import Countries "Countries";
import DTOs "DTOs";
import SeasonManager "season-manager";
import T "types";
import CyclesDispenser "cycles-dispenser";
import TreasuryManager "treasury-manager";
import Utilities "utilities";
import Account "lib/Account";
import Environment "Environment";
import NeuronTypes "../neuron_controller/types";

actor Self {
  let seasonManager = SeasonManager.SeasonManager();
  let cyclesDispenser = CyclesDispenser.CyclesDispenser();
  let treasuryManager = TreasuryManager.TreasuryManager();
  private let cyclesCheckInterval : Nat = Utilities.getHour() * 24;
  private let cyclesCheckWalletInterval : Nat = Utilities.getHour() * 24;

  private var cyclesCheckTimerId : ?Timer.TimerId = null;
  private var cyclesCheckWalletTimerId : ?Timer.TimerId = null;

  private var nextCyclesCheckTime : Int = 0;
  private var nextWalletCheckTime : Int = 0;

  //Functions containing inter-canister calls that cannot be query functions:
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
    assert false; // TODO: Remove when the game begins
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert fantasyTeam.principalId == principalId;
    return await seasonManager.saveFantasyTeam(fantasyTeam);
  };

  //Governance canister validation and execution functions:
  public shared func validateRevaluePlayerUp(revaluePlayerUpDTO : DTOs.RevaluePlayerUpDTO) : async Result.Result<Text, Text> {
    return await seasonManager.validateRevaluePlayerUp(revaluePlayerUpDTO);
  };

  public shared func executeRevaluePlayerUp(revaluePlayerUpDTO : DTOs.RevaluePlayerUpDTO) : async () {
    return await seasonManager.executeRevaluePlayerUp(revaluePlayerUpDTO);
  };

  public shared func validateRevaluePlayerDown(revaluePlayerDownDTO : DTOs.RevaluePlayerDownDTO) : async Result.Result<Text, Text> {
    return await seasonManager.validateRevaluePlayerDown(revaluePlayerDownDTO);
  };

  public shared func executeRevaluePlayerDown(revaluePlayerDownDTO : DTOs.RevaluePlayerDownDTO) : async () {
    return await seasonManager.executeRevaluePlayerDown(revaluePlayerDownDTO);
  };

  public shared func validateSubmitFixtureData(submitFixtureData : DTOs.SubmitFixtureDataDTO) : async Result.Result<Text, Text> {
    return await seasonManager.validateSubmitFixtureData(submitFixtureData);
  };

  public shared func executeSubmitFixtureData(submitFixtureData : DTOs.SubmitFixtureDataDTO) : async () {
    return await seasonManager.executeSubmitFixtureData(submitFixtureData);
  };

  public shared func validateAddInitialFixtures(addInitialFixturesDTO : DTOs.AddInitialFixturesDTO) : async Result.Result<Text, Text> {
    return await seasonManager.validateAddInitialFixtures(addInitialFixturesDTO);
  };

  public shared func executeAddInitialFixtures(addInitialFixturesDTO : DTOs.AddInitialFixturesDTO) : async () {
    return await seasonManager.executeAddInitialFixtures(addInitialFixturesDTO);
  };

  public shared func validateMoveFixture(moveFixtureDTO : DTOs.MoveFixtureDTO) : async Result.Result<Text, Text> {
    return await seasonManager.validateMoveFixture(moveFixtureDTO);
  };

  public shared func executeMoveFixture(moveFixtureDTO : DTOs.MoveFixtureDTO) : async () {
    return await seasonManager.executeMoveFixture(moveFixtureDTO);
  };

  public shared func validatePostponeFixture(postponeFixtureDTO : DTOs.PostponeFixtureDTO) : async Result.Result<Text, Text> {
    return await seasonManager.validatePostponeFixture(postponeFixtureDTO);
  };

  public shared func executePostponeFixture(postponeFixtureDTO : DTOs.PostponeFixtureDTO) : async () {
    return await seasonManager.executePostponeFixture(postponeFixtureDTO);
  };

  public shared func validateRescheduleFixture(rescheduleFixtureDTO : DTOs.RescheduleFixtureDTO) : async Result.Result<Text, Text> {
    return await seasonManager.validateRescheduleFixture(rescheduleFixtureDTO);
  };

  public shared func executeRescheduleFixture(rescheduleFixtureDTO : DTOs.RescheduleFixtureDTO) : async () {
    return await seasonManager.executeRescheduleFixture(rescheduleFixtureDTO);
  };

  public shared func validateLoanPlayer(loanPlayerDTO : DTOs.LoanPlayerDTO) : async Result.Result<Text, Text> {
    return await seasonManager.validateLoanPlayer(loanPlayerDTO);
  };

  public shared func executeLoanPlayer(loanPlayerDTO : DTOs.LoanPlayerDTO) : async () {
    return await seasonManager.executeLoanPlayer(loanPlayerDTO);
  };

  public shared func validateTransferPlayer(transferPlayerDTO : DTOs.TransferPlayerDTO) : async Result.Result<Text, Text> {
    return await seasonManager.validateTransferPlayer(transferPlayerDTO);
  };

  public shared func executeTransferPlayer(transferPlayerDTO : DTOs.TransferPlayerDTO) : async () {
    return await seasonManager.executeTransferPlayer(transferPlayerDTO);
  };

  public shared func validateRecallPlayer(recallPlayerDTO : DTOs.RecallPlayerDTO) : async Result.Result<Text, Text> {
    return await seasonManager.validateRecallPlayer(recallPlayerDTO);
  };

  public shared func executeRecallPlayer(recallPlayerDTO : DTOs.RecallPlayerDTO) : async () {
    return await seasonManager.executeRecallPlayer(recallPlayerDTO);
  };

  public shared func validateCreatePlayer(createPlayerDTO : DTOs.CreatePlayerDTO) : async Result.Result<Text, Text> {
    return await seasonManager.validateCreatePlayer(createPlayerDTO);
  };

  public shared func executeCreatePlayer(createPlayerDTO : DTOs.CreatePlayerDTO) : async () {
    return await seasonManager.executeCreatePlayer(createPlayerDTO);
  };

  public shared func validateUpdatePlayer(updatePlayerDTO : DTOs.UpdatePlayerDTO) : async Result.Result<Text, Text> {
    return await seasonManager.validateUpdatePlayer(updatePlayerDTO);
  };

  public shared func executeUpdatePlayer(updatePlayerDTO : DTOs.UpdatePlayerDTO) : async () {
    return await seasonManager.executeUpdatePlayer(updatePlayerDTO);
  };

  public shared func validateSetPlayerInjury(setPlayerInjuryDTO : DTOs.SetPlayerInjuryDTO) : async Result.Result<Text, Text> {
    return await seasonManager.validateSetPlayerInjury(setPlayerInjuryDTO);
  };

  public shared func executeSetPlayerInjury(setPlayerInjuryDTO : DTOs.SetPlayerInjuryDTO) : async () {
    return await seasonManager.executeSetPlayerInjury(setPlayerInjuryDTO);
  };

  public shared func validateRetirePlayer(retirePlayerDTO : DTOs.RetirePlayerDTO) : async Result.Result<Text, Text> {
    return await seasonManager.validateRetirePlayer(retirePlayerDTO);
  };

  public shared func executeRetirePlayer(retirePlayerDTO : DTOs.RetirePlayerDTO) : async () {
    return await seasonManager.executeRetirePlayer(retirePlayerDTO);
  };

  public shared func validateUnretirePlayer(unretirePlayerDTO : DTOs.UnretirePlayerDTO) : async Result.Result<Text, Text> {
    return await seasonManager.validateUnretirePlayer(unretirePlayerDTO);
  };

  public shared func executeUnretirePlayer(unretirePlayerDTO : DTOs.UnretirePlayerDTO) : async () {
    return await seasonManager.executeUnretirePlayer(unretirePlayerDTO);
  };

  public shared func validatePromoteFormerClub(promoteFormerClubDTO : DTOs.PromoteFormerClubDTO) : async Result.Result<Text, Text> {
    return await seasonManager.validatePromoteFormerClub(promoteFormerClubDTO);
  };

  public shared func executePromoteFormerClub(promoteFormerClubDTO : DTOs.PromoteFormerClubDTO) : async () {
    return await seasonManager.executePromoteFormerClub(promoteFormerClubDTO);
  };

  public shared func validatePromoteNewClub(promoteNewClubDTO : DTOs.PromoteNewClubDTO) : async Result.Result<Text, Text> {
    return await seasonManager.validatePromoteNewClub(promoteNewClubDTO);
  };

  public shared func executePromoteNewClub(promoteNewClubDTO : DTOs.PromoteNewClubDTO) : async () {
    return await seasonManager.executePromoteNewClub(promoteNewClubDTO);
  };

  public shared func validateUpdateClub(updateClubDTO : DTOs.UpdateClubDTO) : async Result.Result<Text, Text> {
    return await seasonManager.validateUpdateClub(updateClubDTO);
  };

  public shared func executeUpdateClub(updateClubDTO : DTOs.UpdateClubDTO) : async () {
    return await seasonManager.executeUpdateClub(updateClubDTO);
  };
  public shared query func getBackendCanisterId() : async Result.Result<Text, T.Error> {
    return #ok(Principal.toText(Principal.fromActor(Self)));
  };

  public shared func validateCreateDAONeuron() : async Result.Result<Text, Text> {
    return #ok("Good");
    //TODO: Ensure that all the callers of canisters are the SNS governance canister
      //surely I mark this function differently somehow to stop others just randomly calling it


  };

  public shared func executeCreateDAONeuron() : async () {
    let neuron_controller = actor (Environment.NEURON_CONTROLLER_CANISTER_ID) : actor {
          stake_nns_neuron : T.PrincipalId -> async ?NeuronTypes.Response;
    };

      //conversion of sec1 to duh then principal
      //call neuron controller canister stake nns neuron
      //pass in principal
    let callerPrincipal = "";

    let _ = await neuron_controller.stake_nns_neuron(callerPrincipal);
    
  };

  /*
    //Remove Post SNS, for Dev Post Testing Only
  */
  public shared func init() : async Result.Result<(), T.Error> {

    switch (cyclesCheckTimerId) {
      case (null) {
        await setCheckCyclesTimer();
      };
      case (?id) {};
    };

    switch (cyclesCheckWalletTimerId) {
      case (null) {
        await setCheckCyclesWalletTimer();
      };
      case (?id) {};
    };

    seasonManager.setBackendCanisterController(Principal.fromActor(Self));
    seasonManager.setTimerBackupFunction(setAndBackupTimer, removeExpiredTimers);
    seasonManager.setStoreCanisterIdFunction(cyclesDispenser.storeCanisterId);

    await seasonManager.init();
    return #ok;
  };

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

  private stable var stable_timers : [T.TimerInfo] = [];
  private stable var stable_canister_ids : [Text] = [];

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
  };

  public shared ({ caller }) func requestCanisterTopup() : async () {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    await cyclesDispenser.requestCanisterTopup(principalId);
  };

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

  private func checkCanisterCycles() : async () {

    let balance = Cycles.balance();

    if (balance < 500_000_000_000) {
      await requestCanisterTopup();
    };
    await setCheckCyclesTimer();
  };

  private func setCheckCyclesWalletTimer() : async () {
    switch (cyclesCheckWalletTimerId) {
      case (null) {};
      case (?id) {
        Timer.cancelTimer(id);
        cyclesCheckWalletTimerId := null;
      };
    };
    nextWalletCheckTime := Time.now() + cyclesCheckWalletInterval;
    cyclesCheckWalletTimerId := ?Timer.setTimer<system>(#nanoseconds(cyclesCheckWalletInterval), checkCanisterWalletBalance);
  };

  public func burnICPToCycles(requestedCycles : Nat64) : async () {
    let treasuryAccount = getTreasuryAccount();
    await treasuryManager.sendICPForCycles(treasuryAccount, requestedCycles);
  };

  private func getTreasuryAccount() : Account.AccountIdentifier {
    let actorPrincipal : Principal = Principal.fromActor(Self);
    Account.accountIdentifier(actorPrincipal, Account.defaultSubaccount());
  };

  private func checkCanisterWalletBalance() : async () {
    let topupThreshold : Nat = 750_000_000_000_000;
    let targetBalance : Nat = 1_000_000_000_000_000;
    let available = Cycles.available();

    if (available < topupThreshold) {
      await burnICPToCycles(Nat64.fromNat(targetBalance - available));
    };
    await setCheckCyclesTimer();
  };

  var timers : [T.TimerInfo] = [];
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
};
