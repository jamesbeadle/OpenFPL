import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Cycles "mo:base/ExperimentalCycles";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import List "mo:base/List";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Time "mo:base/Time";
import Timer "mo:base/Timer";
import Nat64 "mo:base/Nat64";
import Debug "mo:base/Debug";

import Countries "Countries";
import DTOs "DTOs";
import SeasonManager "season-manager";
import T "types";
import TimerComposite "patterns/timer-composite";
import CyclesDispenser "cycles-dispenser";
import TreasuryManager "treasury-manager";
import Utilities "utilities";
import Account "lib/Account";
import Environment "Environment";
import CanisterIds "CanisterIds";

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

  public shared ({ caller }) func getManager() : async Result.Result<DTOs.ManagerDTO, T.Error> {
    assert not Principal.isAnonymous(caller);
    return await seasonManager.getManager(Principal.toText(caller));
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

  //TODO: Identify why this can't be a query function
  public shared func getPlayersMap(seasonId : T.SeasonId, gameweek : T.GameweekNumber) : async Result.Result<[(Nat16, DTOs.PlayerScoreDTO)], T.Error> {
    return await seasonManager.getPlayersMap(seasonId, gameweek);
  };

  //TODO: Identify why this can't be a query function
  public shared ({ caller }) func getPlayerDetails(playerId : T.PlayerId, seasonId : T.SeasonId) : async Result.Result<DTOs.PlayerDetailDTO, T.Error> {
    return await seasonManager.getPlayerDetails(playerId, seasonId);
  };

  public shared query func getCountries() : async Result.Result<[DTOs.CountryDTO], T.Error> {
    return #ok(Countries.countries);
  };

  public shared query ({ caller }) func isUsernameValid(username : Text) : async Bool {
    assert not Principal.isAnonymous(caller);
    return seasonManager.isUsernameValid(username, Principal.toText(caller));
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

  public shared ({ caller }) func updateProfilePicture(profilePicture : Blob) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    return await seasonManager.updateProfilePicture(principalId, profilePicture);
  };

  public shared ({ caller }) func saveFantasyTeam(fantasyTeam : DTOs.UpdateFantasyTeamDTO) : async Result.Result<(), T.Error> {
    assert false; // TODO: Remove when the game begins
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    return await seasonManager.saveFantasyTeam(principalId, fantasyTeam);
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

  public shared func init() : async Result.Result<(), T.Error> {

    switch (cyclesCheckTimerId) {
      case (null) {
        setCheckCyclesTimer();
      };
      case (?id) {};
    };

    switch (cyclesCheckWalletTimerId) {
      case (null) {
        setCheckCyclesWalletTimer();
      };
      case (?id) {};
    };

    seasonManager.setBackendCanisterController(Principal.fromActor(Self));
    seasonManager.setTimerBackupFunction(timerComposite.setAndBackupTimer, timerComposite.removeExpiredTimers);
    seasonManager.setStoreCanisterIdFunction(cyclesDispenser.storeCanisterId);

    seasonManager.init();
    return #ok;
  };

  private func gameweekBeginExpiredCallback() : async () {
    await seasonManager.gameweekBeginExpired();
    timerComposite.removeExpiredTimers();
  };

  private func gameKickOffExpiredCallback() : async () {
    await seasonManager.gameKickOffExpiredCallback();
    timerComposite.removeExpiredTimers();
  };

  private func gameCompletedExpiredCallback() : async () {
    await seasonManager.gameCompletedExpiredCallback();
    timerComposite.removeExpiredTimers();
  };

  private func loanExpiredCallback() : async () {
    await seasonManager.loanExpiredCallback();
    timerComposite.removeExpiredTimers();
  };

  private func injuryExpiredCallback() : async () {
    await seasonManager.injuryExpiredCallback();
    timerComposite.removeExpiredTimers();
  };

  private func transferWindowStartCallback() : async () {
    await seasonManager.transferWindowStartCallback();
    timerComposite.removeExpiredTimers();
  };

  private func transferWindowEndCallback() : async () {
    await seasonManager.transferWindowEndCallback();
    timerComposite.removeExpiredTimers();
  };

  let timerComposite = TimerComposite.TimerComposite();
  timerComposite.setCallbackFunctions(
    gameweekBeginExpiredCallback,
    gameKickOffExpiredCallback,
    gameCompletedExpiredCallback,
    loanExpiredCallback,
    injuryExpiredCallback,
    transferWindowStartCallback,
    transferWindowEndCallback,
  );

  //Stable backup:
  private stable var stable_timers : [T.TimerInfo] = [];
  private stable var stable_reward_pools : [(T.SeasonId, T.RewardPool)] = [];
  private stable var stable_managers : [(Text, T.Manager)] = [];
  private stable var stable_profile_picture_canister_ids : [(T.PrincipalId, Text)] = [];
  private stable var stable_active_profile_picture_canister_id : Text = "";
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
  private stable var stable_season_leaderboard_canisters : [T.SeasonLeaderboardCanister] = [];
  private stable var stable_monthly_leaderboard_canisters : [T.MonthlyLeaderboardCanister] = [];
  private stable var stable_weekly_leaderboard_canisters : [T.WeeklyLeaderboardCanister] = [];
  private stable var stable_clubs : [T.Club] = [];
  private stable var stable_relegated_clubs : [T.Club] = [];
  private stable var stable_next_club_id : T.ClubId = 1;
  private stable var stable_players : [T.Player] = [];
  private stable var stable_retired_players : [T.Player] = [];
  private stable var stable_former_players : [T.Player] = [];
  private stable var stable_next_player_id : T.PlayerId = 1;
  private stable var stable_seasons : [T.Season] = [];
  private stable var stable_next_season_id : T.SeasonId = 1;
  private stable var stable_next_fixture_id : T.FixtureId = 1;
  private stable var stable_data_cache_hashes : [T.DataCache] = [];
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
  private stable var stable_canister_ids : [Text] = [];

  system func preupgrade() {
    stable_timers := timerComposite.getStableTimers();
    stable_reward_pools := seasonManager.getStableRewardPools();
    stable_managers := seasonManager.getStableManagers();
    stable_profile_picture_canister_ids := seasonManager.getStableProfilePictureCanisterIds();
    stable_active_profile_picture_canister_id := seasonManager.getStableActiveProfilePictureCanisterId();
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
    stable_season_ath_prize_pool := seasonManager.getSeasonATHPrizePool();
    stable_season_leaderboard_canisters := seasonManager.getStableSeasonLeaderboardCanisters();
    stable_monthly_leaderboard_canisters := seasonManager.getStableMonthlyLeaderboardCanisters();
    stable_weekly_leaderboard_canisters := seasonManager.getStableWeeklyLeaderboardCanisters();
    stable_clubs := seasonManager.getStableClubs();
    stable_relegated_clubs := seasonManager.getStableRelegatedClubs();
    stable_next_club_id := seasonManager.getStableNextClubId();
    stable_players := seasonManager.getStablePlayers();
    stable_next_player_id := seasonManager.getStableNextPlayerId();
    stable_seasons := seasonManager.getStableSeasons();
    stable_next_season_id := seasonManager.getStableNextSeasonId();
    stable_next_fixture_id := seasonManager.getStableNextFixtureId();
    stable_data_cache_hashes := seasonManager.getStableDataHashes();
    stable_system_state := seasonManager.getStableSystemState();
    stable_canister_ids := cyclesDispenser.getStableCanisterIds();
  };

  system func postupgrade() {
    cyclesDispenser.setStableCanisterIds(stable_canister_ids);
    seasonManager.setStableManagers(stable_managers);
    seasonManager.setStableProfilePictureCanisterIds(stable_profile_picture_canister_ids);
    seasonManager.setStableActiveProfilePictureCanisterId(stable_active_profile_picture_canister_id);
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
    seasonManager.setSeasonATHPrizePool(stable_season_ath_prize_pool);
    seasonManager.setStableSeasonLeaderboardCanisters(stable_season_leaderboard_canisters);
    seasonManager.setStableMonthlyLeaderboardCanisters(stable_monthly_leaderboard_canisters);
    seasonManager.setStableWeeklyLeaderboardCanisters(stable_weekly_leaderboard_canisters);
    seasonManager.setStableClubs(stable_clubs);
    seasonManager.setStableRelegatedClubs(stable_relegated_clubs);
    seasonManager.setStableNextClubId(stable_next_club_id);
    seasonManager.setStablePlayers(stable_players);
    seasonManager.setStableNextPlayerId(stable_next_player_id);
    seasonManager.setStableSeasons(stable_seasons);
    seasonManager.setStableNextSeasonId(stable_next_season_id);
    seasonManager.setStableNextFixtureId(stable_next_fixture_id);
    seasonManager.setStableDataHashes(stable_data_cache_hashes);
    seasonManager.setStableSystemState(stable_system_state);
    timerComposite.setStableTimers(stable_timers);

    seasonManager.setBackendCanisterController(Principal.fromActor(Self));
    seasonManager.setTimerBackupFunction(timerComposite.setAndBackupTimer, timerComposite.removeExpiredTimers);
    seasonManager.setStoreCanisterIdFunction(cyclesDispenser.storeCanisterId);
    setCheckCyclesTimer();
    setCheckCyclesWalletTimer();
  };

  public shared ({ caller }) func requestCanisterTopup() : async () {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    await cyclesDispenser.requestCanisterTopup(principalId);
  };

  private func setCheckCyclesTimer() {
    switch (cyclesCheckTimerId) {
      case (null) {};
      case (?id) {
        Timer.cancelTimer(id);
        cyclesCheckTimerId := null;
      };
    };
    nextCyclesCheckTime := Time.now() + cyclesCheckInterval;
    cyclesCheckTimerId := ?Timer.setTimer(#nanoseconds(cyclesCheckInterval), checkCanisterCycles);
  };

  private func checkCanisterCycles() : async () {

    let balance = Cycles.balance();

    if (balance < 500_000_000_000) {
      await requestCanisterTopup();
    };
    setCheckCyclesTimer();
  };

  private func setCheckCyclesWalletTimer() {
    switch (cyclesCheckWalletTimerId) {
      case (null) {};
      case (?id) {
        Timer.cancelTimer(id);
        cyclesCheckWalletTimerId := null;
      };
    };
    nextWalletCheckTime := Time.now() + cyclesCheckWalletInterval;
    cyclesCheckWalletTimerId := ?Timer.setTimer(#nanoseconds(cyclesCheckWalletInterval), checkCanisterWalletBalance);
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
    setCheckCyclesTimer();
  };

  /* Admin Section to be removed when DAO */

  let TEMP_ADMIN_PRINCIPAL = "4khjk-mso55-d5gd6-pudbp-627pj-ztvnn-ntn3p-vvujc-2x5dr-kv32c-2ae";

  //Getters for admin functions - //TODO: Can't be query as gets cycles?
  public shared ({ caller }) func adminGetMainCanisterInfo() : async Result.Result<DTOs.AdminMainCanisterInfo, T.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == TEMP_ADMIN_PRINCIPAL;

    let balance = Cycles.balance();
    let network = Environment.DFX_NETWORK;
    var main_canister_id = CanisterIds.MAIN_CANISTER_IC_ID;
    if (network == "local") {
      main_canister_id := CanisterIds.MAIN_CANISTER_LOCAL_ID;
    };

    let dto : DTOs.AdminMainCanisterInfo = {
      cycles = balance;
      canisterId = main_canister_id;
    };

    return #ok(dto);
  };

  public shared ({ caller }) func adminGetWeeklyCanisters(limit : Nat, offset : Nat) : async Result.Result<DTOs.AdminWeeklyCanisterList, T.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == TEMP_ADMIN_PRINCIPAL;

    let weeklyCanisters = seasonManager.getStableWeeklyLeaderboardCanisters();
    let droppedEntries = List.drop<T.WeeklyLeaderboardCanister>(List.fromArray(weeklyCanisters), offset);
    let paginatedEntries = List.take<T.WeeklyLeaderboardCanister>(droppedEntries, limit);

    let canisterInfoBuffer = Buffer.fromArray<DTOs.WeeklyCanisterDTO>([]);

    for (canisterInfo in Iter.fromList(paginatedEntries)) {
      let weekly_leaderboard_canister = actor (canisterInfo.canisterId) : actor {
        getCyclesBalance : () -> async Nat;
      };

      let cycles = await weekly_leaderboard_canister.getCyclesBalance();
      canisterInfoBuffer.add({
        canister = canisterInfo;
        cycles = cycles;
      });
    };

    let dto : DTOs.AdminWeeklyCanisterList = {
      limit = limit;
      offset = offset;
      canisters = Buffer.toArray(canisterInfoBuffer);
      totalEntries = Array.size(weeklyCanisters);
    };

    return #ok(dto);
  };

  public shared ({ caller }) func adminGetMonthlyCanisters(limit : Nat, offset : Nat) : async Result.Result<DTOs.AdminMonthlyCanisterList, T.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == TEMP_ADMIN_PRINCIPAL;

    let monthlyCanisters = seasonManager.getStableMonthlyLeaderboardCanisters();
    let droppedEntries = List.drop<T.MonthlyLeaderboardCanister>(List.fromArray(monthlyCanisters), offset);
    let paginatedEntries = List.take<T.MonthlyLeaderboardCanister>(droppedEntries, limit);

    let canisterInfoBuffer = Buffer.fromArray<DTOs.MonthlyCanisterDTO>([]);

    for (canisterInfo in Iter.fromList(paginatedEntries)) {
      let monthly_leaderboard_canister = actor (canisterInfo.canisterId) : actor {
        getCyclesBalance : () -> async Nat;
      };

      let cycles = await monthly_leaderboard_canister.getCyclesBalance();
      canisterInfoBuffer.add({
        canister = canisterInfo;
        cycles = cycles;
      });
    };

    let dto : DTOs.AdminMonthlyCanisterList = {
      limit = limit;
      offset = offset;
      canisters = Buffer.toArray(canisterInfoBuffer);
      totalEntries = Array.size(monthlyCanisters);
    };

    return #ok(dto);
  };

  public shared ({ caller }) func adminGetSeasonCanisters(limit : Nat, offset : Nat) : async Result.Result<DTOs.AdminSeasonCanisterList, T.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == TEMP_ADMIN_PRINCIPAL;

    let seasonCanisters = seasonManager.getStableSeasonLeaderboardCanisters();
    let droppedEntries = List.drop<T.SeasonLeaderboardCanister>(List.fromArray(seasonCanisters), offset);
    let paginatedEntries = List.take<T.SeasonLeaderboardCanister>(droppedEntries, limit);

    let canisterInfoBuffer = Buffer.fromArray<DTOs.SeasonCanisterDTO>([]);

    for (canisterInfo in Iter.fromList(paginatedEntries)) {
      let season_leaderboard_canister = actor (canisterInfo.canisterId) : actor {
        getCyclesBalance : () -> async Nat;
      };

      let cycles = await season_leaderboard_canister.getCyclesBalance();
      canisterInfoBuffer.add({
        canister = canisterInfo;
        cycles = cycles;
      });
    };

    let dto : DTOs.AdminSeasonCanisterList = {
      limit = limit;
      offset = offset;
      canisters = Buffer.toArray(canisterInfoBuffer);
      totalEntries = Array.size(seasonCanisters);
    };

    return #ok(dto);
  };

  public shared ({ caller }) func adminGetProfileCanisters(limit : Nat, offset : Nat) : async Result.Result<DTOs.AdminProfilePictureCanisterList, T.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == TEMP_ADMIN_PRINCIPAL;

    let profileCanisters = seasonManager.getStableProfilePictureCanisterIds();

    let uniqueCanisterIds = Buffer.fromArray<Text>([]);

    for (canister in Iter.fromArray(profileCanisters)) {
      if (not Buffer.contains<Text>(uniqueCanisterIds, canister.1, func(a : Text, b : Text) : Bool { a == b })) {
        uniqueCanisterIds.add(canister.1);
      };
    };

    let uniqueCanisterArray = Buffer.toArray(uniqueCanisterIds);

    let droppedEntries = List.drop<Text>(List.fromArray(uniqueCanisterArray), offset);
    let paginatedEntries = List.take<Text>(droppedEntries, limit);

    let canisterInfoBuffer = Buffer.fromArray<DTOs.ProfileCanisterDTO>([]);

    for (canisterId in Iter.fromList(paginatedEntries)) {
      let profile_picture_caniter = actor (canisterId) : actor {
        getCyclesBalance : () -> async Nat;
      };

      let cycles = await profile_picture_caniter.getCyclesBalance();
      canisterInfoBuffer.add({
        canisterId = canisterId;
        cycles = cycles;
      });
    };

    let dto : DTOs.AdminProfilePictureCanisterList = {
      limit = limit;
      offset = offset;
      canisters = Buffer.toArray(canisterInfoBuffer);
      totalEntries = Array.size(profileCanisters);
    };

    return #ok(dto);
  };

  public shared query ({ caller }) func adminGetTimers(category : Text, limit : Nat, offset : Nat) : async Result.Result<DTOs.AdminTimerList, T.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == TEMP_ADMIN_PRINCIPAL;

    let timers = timerComposite.getStableTimers();

    let filteredTimers = Array.filter<T.TimerInfo>(
      timers,
      func(timer : T.TimerInfo) : Bool {
        return timer.callbackName == category;
      },
    );

    let droppedEntries = List.drop<DTOs.TimerDTO>(List.fromArray(filteredTimers), offset);
    let paginatedEntries = List.take<DTOs.TimerDTO>(droppedEntries, limit);

    var currentCyclesCheckTimerId = 0;
    var currentWalletCheckTimerId = 0;

    switch (cyclesCheckTimerId) {
      case (null) {};
      case (?id) {
        currentCyclesCheckTimerId := id;
      };
    };

    switch (cyclesCheckWalletTimerId) {
      case (null) {};
      case (?id) {
        currentWalletCheckTimerId := id;
      };
    };

    let dto : DTOs.AdminTimerList = {
      limit = limit;
      offset = offset;
      timers = List.toArray(paginatedEntries);
      totalEntries = Array.size(timers);
      category = category;

      cyclesCheck = {
        id = currentCyclesCheckTimerId;
        triggerTime = nextCyclesCheckTime;
        callbackName = "checkCanisterCycles";
      };
      cyclesWalletCheck = {
        id = currentWalletCheckTimerId;
        triggerTime = nextWalletCheckTime;
        callbackName = "checkCanisterWalletBalance";
      };
    };

    return #ok(dto);
  };

  public shared query ({ caller }) func adminGetFixtures(seasonId : T.SeasonId) : async Result.Result<DTOs.AdminFixtureList, T.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == TEMP_ADMIN_PRINCIPAL;
    return #ok(seasonManager.adminGetFixtures(seasonId));
  };

  public shared query ({ caller }) func adminGetClubs(limit : Nat, offset : Nat) : async Result.Result<DTOs.AdminClubList, T.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == TEMP_ADMIN_PRINCIPAL;
    return #ok(seasonManager.adminGetClubs(limit, offset));
  };

  public shared query ({ caller }) func adminGetPlayers(status : T.PlayerStatus) : async Result.Result<DTOs.AdminPlayerList, T.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == TEMP_ADMIN_PRINCIPAL;
    return #ok(seasonManager.adminGetPlayers(status));
  };

  public shared query ({ caller }) func adminGetManagers(limit : Nat, offset : Nat) : async Result.Result<DTOs.AdminProfileList, T.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == TEMP_ADMIN_PRINCIPAL;
    return #ok(seasonManager.adminGetManagers(limit, offset));
  };

  //Update system state
  //Remove a canister timer
  public shared ({ caller }) func updateSystemState(updateSystemState : DTOs.UpdateSystemStateDTO) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == TEMP_ADMIN_PRINCIPAL;
    return await seasonManager.updateSystemState(updateSystemState);
  };

  public shared ({ caller }) func updateFixture(updatedFixture : DTOs.UpdateFixtureDTO) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == TEMP_ADMIN_PRINCIPAL;
    return await seasonManager.updateFixture(updatedFixture);
  };

  //Add in functions that simultaneously validate and execute each proposal type for testing

  public shared ({ caller }) func adminRevaluePlayerUp(revaluePlayerUpDTO : DTOs.RevaluePlayerUpDTO) : async Result.Result<Text, Text> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == TEMP_ADMIN_PRINCIPAL;
    let result = await seasonManager.validateRevaluePlayerUp(revaluePlayerUpDTO);
    if (result == #ok("Valid")) {
      await seasonManager.executeRevaluePlayerUp(revaluePlayerUpDTO);
      return #ok("Valid");
    };
    return result;
  };

  public shared ({ caller }) func adminRevaluePlayerDown(revaluePlayerDownDTO : DTOs.RevaluePlayerDownDTO) : async Result.Result<Text, Text> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == TEMP_ADMIN_PRINCIPAL;
    let result = await seasonManager.validateRevaluePlayerDown(revaluePlayerDownDTO);
    if (result == #ok("Valid")) {
      await seasonManager.executeRevaluePlayerDown(revaluePlayerDownDTO);
      return #ok("Valid");
    };
    return result;
  };

  public shared ({ caller }) func adminSubmitFixtureData(submitFixtureData : DTOs.SubmitFixtureDataDTO) : async Result.Result<Text, Text> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == TEMP_ADMIN_PRINCIPAL;
    let result = await seasonManager.validateSubmitFixtureData(submitFixtureData);
    if (result == #ok("Valid")) {
      await seasonManager.executeSubmitFixtureData(submitFixtureData);
      return #ok("Valid");
    };
    return result;
  };

  public shared ({ caller }) func adminAddInitialFixtures(addInitialFixturesDTO : DTOs.AddInitialFixturesDTO) : async Result.Result<Text, Text> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == TEMP_ADMIN_PRINCIPAL;
    let result = await seasonManager.validateAddInitialFixtures(addInitialFixturesDTO);
    if (result == #ok("Valid")) {
      await seasonManager.executeAddInitialFixtures(addInitialFixturesDTO);
      return #ok("Valid");
    };
    return result;
  };

  public shared ({ caller }) func adminMoveFixture(moveFixtureDTO : DTOs.MoveFixtureDTO) : async Result.Result<Text, Text> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == TEMP_ADMIN_PRINCIPAL;
    let result = await seasonManager.validateMoveFixture(moveFixtureDTO);
    if (result == #ok("Valid")) {
      await seasonManager.executeMoveFixture(moveFixtureDTO);
      return #ok("Valid");
    };
    return result;
  };

  public shared ({ caller }) func adminPostponeFixture(postponeFixtureDTO : DTOs.PostponeFixtureDTO) : async Result.Result<Text, Text> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == TEMP_ADMIN_PRINCIPAL;
    let result = await seasonManager.validatePostponeFixture(postponeFixtureDTO);
    if (result == #ok("Valid")) {
      await seasonManager.executePostponeFixture(postponeFixtureDTO);
      return #ok("Valid");
    };
    return result;
  };

  public shared ({ caller }) func adminRescheduleFixture(rescheduleFixtureDTO : DTOs.RescheduleFixtureDTO) : async Result.Result<Text, Text> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == TEMP_ADMIN_PRINCIPAL;
    let result = await seasonManager.validateRescheduleFixture(rescheduleFixtureDTO);
    if (result == #ok("Valid")) {
      await seasonManager.executeRescheduleFixture(rescheduleFixtureDTO);
      return #ok("Valid");
    };
    return result;
  };

  public shared ({ caller }) func adminLoanPlayer(loanPlayerDTO : DTOs.LoanPlayerDTO) : async Result.Result<Text, Text> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == TEMP_ADMIN_PRINCIPAL;
    let result = await seasonManager.validateLoanPlayer(loanPlayerDTO);
    if (result == #ok("Valid")) {
      await seasonManager.executeLoanPlayer(loanPlayerDTO);
      return #ok("Valid");
    };
    return result;
  };

  public shared ({ caller }) func adminTransferPlayer(transferPlayerDTO : DTOs.TransferPlayerDTO) : async Result.Result<Text, Text> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == TEMP_ADMIN_PRINCIPAL;
    let result = await seasonManager.validateTransferPlayer(transferPlayerDTO);
    if (result == #ok("Valid")) {
      await seasonManager.executeTransferPlayer(transferPlayerDTO);
      return #ok("Valid");
    };
    return result;
  };

  public shared ({ caller }) func adminRecallPlayer(recallPlayerDTO : DTOs.RecallPlayerDTO) : async Result.Result<Text, Text> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == TEMP_ADMIN_PRINCIPAL;
    let result = await seasonManager.validateRecallPlayer(recallPlayerDTO);
    if (result == #ok("Valid")) {
      await seasonManager.executeRecallPlayer(recallPlayerDTO);
      return #ok("Valid");
    };
    return result;
  };

  public shared ({ caller }) func adminCreatePlayer(createPlayerDTO : DTOs.CreatePlayerDTO) : async Result.Result<Text, Text> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == TEMP_ADMIN_PRINCIPAL;
    let result = await seasonManager.validateCreatePlayer(createPlayerDTO);
    if (result == #ok("Valid")) {
      await seasonManager.executeCreatePlayer(createPlayerDTO);
      return #ok("Valid");
    };
    return result;
  };

  public shared ({ caller }) func adminUpdatePlayer(updatePlayerDTO : DTOs.UpdatePlayerDTO) : async Result.Result<Text, Text> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == TEMP_ADMIN_PRINCIPAL;
    let result = await seasonManager.validateUpdatePlayer(updatePlayerDTO);
    if (result == #ok("Valid")) {
      await seasonManager.executeUpdatePlayer(updatePlayerDTO);
      return #ok("Valid");
    };
    return result;
  };

  public shared ({ caller }) func adminSetPlayerInjury(setPlayerInjuryDTO : DTOs.SetPlayerInjuryDTO) : async Result.Result<Text, Text> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == TEMP_ADMIN_PRINCIPAL;
    let result = await seasonManager.validateSetPlayerInjury(setPlayerInjuryDTO);
    if (result == #ok("Valid")) {
      await seasonManager.executeSetPlayerInjury(setPlayerInjuryDTO);
      return #ok("Valid");
    };
    return result;
  };

  public shared ({ caller }) func adminRetirePlayer(retirePlayerDTO : DTOs.RetirePlayerDTO) : async Result.Result<Text, Text> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == TEMP_ADMIN_PRINCIPAL;
    let result = await seasonManager.validateRetirePlayer(retirePlayerDTO);
    if (result == #ok("Valid")) {
      await seasonManager.executeRetirePlayer(retirePlayerDTO);
      return #ok("Valid");
    };
    return result;
  };

  public shared ({ caller }) func adminUnretirePlayer(unretirePlayerDTO : DTOs.UnretirePlayerDTO) : async Result.Result<Text, Text> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == TEMP_ADMIN_PRINCIPAL;
    let result = await seasonManager.validateUnretirePlayer(unretirePlayerDTO);
    if (result == #ok("Valid")) {
      await seasonManager.executeUnretirePlayer(unretirePlayerDTO);
      return #ok("Valid");
    };
    return result;
  };

  public shared ({ caller }) func adminPromoteFormerClub(promoteFormerClubDTO : DTOs.PromoteFormerClubDTO) : async Result.Result<Text, Text> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == TEMP_ADMIN_PRINCIPAL;
    let result = await seasonManager.validatePromoteFormerClub(promoteFormerClubDTO);
    if (result == #ok("Valid")) {
      await seasonManager.executePromoteFormerClub(promoteFormerClubDTO);
      return #ok("Valid");
    };
    return result;
  };

  public shared ({ caller }) func adminPromoteNewClub(promoteNewClubDTO : DTOs.PromoteNewClubDTO) : async Result.Result<Text, Text> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == TEMP_ADMIN_PRINCIPAL;
    let result = await seasonManager.validatePromoteNewClub(promoteNewClubDTO);
    if (result == #ok("Valid")) {
      await seasonManager.executePromoteNewClub(promoteNewClubDTO);
      return #ok("Valid");
    };
    return result;
  };

  public shared ({ caller }) func adminUpdateClub(updateClubDTO : DTOs.UpdateClubDTO) : async Result.Result<Text, Text> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == TEMP_ADMIN_PRINCIPAL;
    let result = await seasonManager.validateUpdateClub(updateClubDTO);
    if (result == #ok("Valid")) {
      await seasonManager.executeUpdateClub(updateClubDTO);
      return #ok("Valid");
    };
    return result;
  };

};
