//TODO - Remove and import correct mops package

import Base "mo:waterway-mops/BaseTypes";
import FootballTypes "mo:waterway-mops/FootballTypes";
import Root "./cleanup/sns-wrappers/root";

//TODO - John we use these in each project so mops?
import Management "./cleanup/Management";
//TODO Do I need 2 environment variables/
import Environment "./Environment";
import Queries "./cleanup/football_god_queries"; //TODO Refactor and remove


/* ----- Mops Packages ----- */

import Array "mo:base/Array";
import Bool "mo:base/Bool";
import Buffer "mo:base/Buffer";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import Nat64 "mo:base/Nat64";
import Nat "mo:base/Nat";
import Option "mo:base/Option";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Text "mo:base/Text";
import Time "mo:base/Time";
import Timer "mo:base/Timer";


/* ----- Canister Definition Files ----- */

import ManagerCanister "./canister_definitions/manager-canister";
import LeaderboardCanister "./canister_definitions/leaderboard-canister";


/* ----- Queries ----- */

import AppQueries "./queries/app_queries";
import LeaderboardQueries "./queries/leaderboard_queries";
import UserQueries "./queries/user_queries";


/* ----- Commands ----- */
import UserCommands "./commands/user_commands";


/* ----- Managers ----- */

import LeaderboardManager "./managers/leaderboard-manager";
import UserManager "./managers/user-manager";
import SeasonManager "./managers/season-manager";
import DataManager "./managers/data-manager";

/* ----- Only Stable Variables Should Use Types ----- */


actor Self {


  /* ----- Stable Canister Variables ----- */ 

  private stable var stable_active_reward_rates : T.RewardRates = {
    allTimeMonthlyHighScoreRewardRate = 0;
    allTimeSeasonHighScoreRewardRate = 0;
    allTimeWeeklyHighScoreRewardRate = 0;
    highestScoringMatchRewardRate = 0;
    monthlyLeaderboardRewardRate = 0;
    mostValuableTeamRewardRate = 0;
    seasonId = 0;
    seasonLeaderboardRewardRate = 0;
    startDate = 0;
    weeklyLeaderboardRewardRate = 0;
  };
  private stable var stable_historic_reward_rates : [T.RewardRates] = [];
  private stable var stable_team_value_leaderboards : [(FootballTypes.SeasonId, T.TeamValueLeaderboard)] = [];
  private stable var stable_weekly_rewards : [T.WeeklyRewards] = [];
  private stable var stable_monthly_rewards : [T.MonthlyRewards] = [];
  private stable var stable_season_rewards : [T.SeasonRewards] = [];
  private stable var stable_most_valuable_team_rewards : [T.RewardsList] = [];
  private stable var stable_high_scoring_player_rewards : [T.RewardsList] = [];
  private stable var stable_weekly_all_time_high_scores : [T.HighScoreRecord] = [];
  private stable var stable_monthly_all_time_high_scores : [T.HighScoreRecord] = [];
  private stable var stable_season_all_time_high_scores : [T.HighScoreRecord] = [];
  private stable var stable_weekly_ath_prize_pool : Nat64 = 0;
  private stable var stable_monthly_ath_prize_pool : Nat64 = 0;
  private stable var stable_season_ath_prize_pool : Nat64 = 0;
  private stable var stable_active_leaderbord_canister_id : Base.CanisterId = "";

  //Season Manager stable variables
  private stable var stable_app_status : T.AppStatus = {
    onHold = false;
    version = "2.1.0";
  };

  private stable var stable_league_gameweek_statuses : [T.LeagueGameweekStatus] = [];
  private stable var stable_league_month_statuses : [T.LeagueMonthStatus] = [];
  private stable var stable_league_season_statuses : [T.LeagueSeasonStatus] = [];

  private stable var stable_data_hashes : [Base.DataHash] = [];
  private stable var stable_player_snapshots : [(FootballTypes.SeasonId, [(FootballTypes.GameweekNumber, [DTOs.PlayerDTO])])] = [];

  //User Manager stable variables

  private stable var stable_manager_canister_ids : [(Base.PrincipalId, Base.CanisterId)] = [];
  private stable var stable_usernames : [(Base.PrincipalId, Text)] = [];
  private stable var stable_unique_manager_canister_ids : [Base.CanisterId] = [];
  private stable var stable_total_managers : Nat = 0;
  private stable var stable_active_manager_canister_id : Base.CanisterId = "";
  private stable var topups : [Base.CanisterTopup] = [];
  private stable var stable_user_icfc_profiles : [(Base.PrincipalId, T.ICFCProfile)] = [];


  private stable var stable_unique_weekly_leaderboard_canister_ids : [Base.CanisterId] = [];
  private stable var stable_weekly_leaderboard_canister_ids : [(FootballTypes.SeasonId, [(FootballTypes.GameweekNumber, Base.CanisterId)])] = [];
  private stable var stable_monthly_leaderboard_canister_ids : [(FootballTypes.SeasonId, [(Base.CalendarMonth, Base.CanisterId)])] = [];
  private stable var stable_season_leaderboard_canister_ids : [(FootballTypes.SeasonId, Base.CanisterId)] = [];


  /* ----- Domain Object Managers ----- */ 

  private let userManager = UserManager.UserManager(Environment.BACKEND_CANISTER_ID);
  private let seasonManager = SeasonManager.SeasonManager();
  private let leaderboardManager = LeaderboardManager.LeaderboardManager(Environment.BACKEND_CANISTER_ID);
  private let dataManager = DataManager.DataManager();


  /* ----- General App Queries ----- */

  public shared query func getAppStatus() : async Result.Result<DTOs.AppStatusDTO, T.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert await hasMembership(principalId);
    return seasonManager.getAppStatus();
  };

  public shared query func getTotalManagers() : async Result.Result<Nat, T.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert await hasMembership(principalId);
    return userManager.getTotalManagers();
  };

  public shared func getActiveRewardRates() : async Result.Result<DTOs.RewardRatesDTO, T.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert await hasMembership(principalId);
    let rewardRates = leaderboardManager.getActiveRewardRates();
    return #ok(rewardRates);
  };


  /* ----- Data Hash Queries ----- */

  public shared composite query func getDataHashes() : async Result.Result<[DTOs.DataHashDTO], T.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert await hasMembership(principalId);
    return seasonManager.getDataHashes();
  };


  /* ----- User Queries ----- */

  public shared ({ caller }) func getProfile(dto: UserQueries.GetProfile) : async Result.Result<UserQueries.Profile, T.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == dto.principalId;
    assert await hasMembership(principalId);
    return await userManager.getProfile(dto);
  };

  public shared ({ caller }) func getICFCProfile(dto: UserQueries.GetICFCProfile) : async Result.Result<UserQueries.ICFCProfile, T.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == dto.principalId;
    assert await hasMembership(principalId);
    return await userManager.getICFCProfile({ principalId = Principal.toText(caller) });
  };

  // TODO: John I don't think we need the following 2 icfc profile functions as the one above should cover it:

  /*
  public shared ({ caller }) func getICFCProfileStatus() : async Result.Result<T.ICFCLinkStatus, T.Error> {
    assert not Principal.isAnonymous(caller);
    assert await hasMembership(Principal.toText(caller));
    return await userManager.getUserICFCProfileStatus(Principal.toText(caller));
  };

  public shared ({ caller }) func getUserIFCFMembership() : async Result.Result<Queries.ICFCMembershipDTO, T.Error> {
    assert not Principal.isAnonymous(caller);
    assert await hasMembership(Principal.toText(caller));
    return await userManager.getUserICFCMembership(Principal.toText(caller));
  };
  */

  public shared ({ caller }) func getTeamSelection(dto: UserQueries.GetTeamSelection) : async Result.Result<UserQueries.TeamSelection, T.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == dto.principalId;
    assert await hasMembership(principalId);
    return await userManager.getTeamSelection(dto);
  };

  public shared func getManager(dto : Queries.GetManagerDTO) : async Result.Result<DTOs.ManagerDTO, T.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert await hasMembership(principalId);
    let weeklyLeaderboardEntry = await leaderboardManager.getWeeklyLeaderboardEntry(dto.principalId, dto.seasonId, dto.gameweek);
    return await userManager.getManager(dto, weeklyLeaderboardEntry, null, null);
  };

  public shared ({ caller }) func getManagerByUsername(dto : UserQueries.GetManagerByUsername) : async Result.Result<UserQueries.Manager, T.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert await hasMembership(principalId);
   return await userManager.getManagerByUsername(dto.username);
  };

  public shared func getFantasyTeamSnapshot(dto : Queries.GetManagerGameweekDTO) : async Result.Result<DTOs.ManagerGameweekDTO, T.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert await hasMembership(principalId);
    return await userManager.getFantasyTeamSnapshot(dto);
  };


  /* ----- User Commands ----- */


  public shared ({ caller }) func linkICFCProfile(dto: UserCommands.LinkICFCProfile) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert await hasMembership(principalId);

    //TODO: John this needs to link a user from OpenFPL to ICFC
    //TODO: Also if created and recalled should repull profile picture username and favourite premier league club if premier league club set

    let dto : Commands.VerifyICFCProfile = {
      principalId = Principal.toText(caller);
    };
    return await userManager.verifyICFCProfile(dto);
  };

  public shared ({ caller }) func updateFavouriteClub(dto : Commands.UpdateFavouriteClubDTO) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    assert await hasMembership(Principal.toText(caller));
    let principalId = Principal.toText(caller);

    let clubsResult = await dataManager.getVerifiedClubs(Environment.LEAGUE_ID);
    switch (clubsResult) {
      case (#ok clubs) {

        let statusResult = await getLeagueStatus();
        switch (statusResult) {
          case (#ok status) {
            return await userManager.updateFavouriteClub(principalId, dto, clubs, status.seasonActive);
          };
          case (#err error) {
            return #err(error);
          };
        };
      };
      case (#err error) {
        return #err(error);
      };
    };
  };
  
  public shared ({ caller }) func saveTeamSelection(dto : Commands.SaveTeamDTO) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    assert await hasMembership(Principal.toText(caller));
    let principalId = Principal.toText(caller);
    let leagueStatusResult = await getLeagueStatus();

    let appStatusResult = seasonManager.getAppStatus();
    switch (appStatusResult) {
      case (#ok appStatus) {
        if (appStatus.onHold) {
          return #err(#SystemOnHold);
        };
      };
      case (#err error) {
        return #err(error);
      };
    };

    switch (leagueStatusResult) {
      case (#ok leagueStatus) {

        if (not leagueStatus.seasonActive) {
          return #err(#NotAllowed);
        };

        let playersResult = await dataManager.getVerifiedPlayers(Environment.LEAGUE_ID);
        switch (playersResult) {
          case (#ok players) {
            return await userManager.saveTeamSelection(principalId, dto, leagueStatus.activeSeasonId, players);
          };
          case (#err error) {
            return #err(error);
          };
        };
      };
      case (#err error) {
        return #err(error);
      };
    };
  };

  public shared ({ caller }) func saveBonusSelection(dto : Commands.SaveBonusDTO) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    assert await hasMembership(Principal.toText(caller));
    let principalId = Principal.toText(caller);
    let leagueStatusResult = await getLeagueStatus();

    let appStatusResult = seasonManager.getAppStatus();
    switch (appStatusResult) {
      case (#ok appStatus) {
        if (appStatus.onHold) {
          return #err(#SystemOnHold);
        };
      };
      case (#err error) {
        return #err(error);
      };
    };

    switch (leagueStatusResult) {
      case (#ok leagueStatus) {

        if (not leagueStatus.seasonActive) {
          return #err(#NotAllowed);
        };

        return await userManager.saveBonusSelection(principalId, dto, leagueStatus.unplayedGameweek);
      };
      case (#err error) {
        return #err(error);
      };
    };
  };


  /* ----- Leaderboard Queries ----- */

  public shared func getWeeklyLeaderboard(dto : Queries.GetWeeklyLeaderboardDTO) : async Result.Result<DTOs.WeeklyLeaderboardDTO, T.Error> {
    return await leaderboardManager.getWeeklyLeaderboard(dto);
  };




  //TODO: John we need to have endpoints to the data canister from here instead of the frontend to check for approved canisters
  
  private func getLeagueStatus() : async Result.Result<FootballTypes.LeagueStatus, T.Error> {
    let data_canister = actor (NetworkEnvironmentVariables.DATA_CANISTER_ID) : actor {
      getLeagueStatus : shared query (leagueId : FootballTypes.LeagueId) -> async Result.Result<FootballTypes.LeagueStatus, T.Error>;
    };
    return await data_canister.getLeagueStatus(Environment.LEAGUE_ID);
  };

  public shared ({ caller }) func getVerifiedPlayers() : async Result.Result<[DTOs.PlayerDTO], T.Error> {
    assert isManagerCanister(Principal.toText(caller));
    return await dataManager.getVerifiedPlayers(Environment.LEAGUE_ID);
  };

  public shared query ({ caller }) func getPlayersSnapshot(dto : Queries.GetSnapshotPlayersDTO) : async [DTOs.PlayerDTO] {
    assert not Principal.isAnonymous(caller); //TODO WHo should be calling this
    return seasonManager.getPlayersSnapshot(dto);
  };

  public shared ({ caller }) func getPlayersMap(dto : Queries.GetPlayersMapDTO) : async Result.Result<[(Nat16, DTOs.PlayerScoreDTO)], T.Error> {
    assert isManagerCanister(Principal.toText(caller));

    let data_canister = actor (NetworkEnvironmentVariables.DATA_CANISTER_ID) : actor {
      getPlayersMap : shared query (leagueId : FootballTypes.LeagueId, dto : Queries.GetPlayersMapDTO) -> async Result.Result<[(Nat16, DTOs.PlayerScoreDTO)], T.Error>;
    };

    return await data_canister.getPlayersMap(Environment.LEAGUE_ID, dto);
  };




  /* ----- WIP ----- */


  /* ----- Football God Data Callback Functions ----- */

  //TODO: Not sure why not called notify - this needs to be looked at

  public shared ({ caller }) func updateDataHashes(category : Text) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    assert Principal.toText(caller) == NetworkEnvironmentVariables.DATA_CANISTER_ID;
    await seasonManager.updateDataHash(category);
    return #ok();
  };

  public shared ({ caller }) func notifyAppLink(dto : Commands.NotifyAppofLink) : async Result.Result<(), T.Error> {
    assert Principal.toText(caller) == NetworkEnvironmentVariables.ICFC_BACKEND_CANISTER_ID;
    let _ = await userManager.linkICFCProfile(dto);
    return #ok();
  };

  public shared ({ caller }) func noitifyAppofICFCProfileUpdate(dto : Commands.UpdateICFCProfile) : async Result.Result<(), T.Error> {
    assert Principal.toText(caller) == NetworkEnvironmentVariables.ICFC_BACKEND_CANISTER_ID;
    let _ = await userManager.updateICFCProfile(dto);
    return #ok();
  };

  public shared ({ caller }) func notifyAppsOfLoan(leagueId : FootballTypes.LeagueId, playerId : FootballTypes.PlayerId) : async Result.Result<(), T.Error> {
    assert Principal.toText(caller) == NetworkEnvironmentVariables.DATA_CANISTER_ID;
    assert leagueId == Environment.LEAGUE_ID;
    await userManager.removePlayerFromTeams(Environment.LEAGUE_ID, playerId, Environment.BACKEND_CANISTER_ID);
    await seasonManager.updateDataHash("players");
    return #ok();
  };

  public shared ({ caller }) func notifyAppsOfLoanExpired(leagueId : FootballTypes.LeagueId, playerId : FootballTypes.PlayerId) : async Result.Result<(), T.Error> {
    assert Principal.toText(caller) == NetworkEnvironmentVariables.DATA_CANISTER_ID;
    assert leagueId == Environment.LEAGUE_ID;
    //TODO

    return #ok();
  };

  public shared ({ caller }) func notifyAppsOfTransfer(leagueId : FootballTypes.LeagueId, playerId : FootballTypes.PlayerId) : async Result.Result<(), T.Error> {
    assert Principal.toText(caller) == NetworkEnvironmentVariables.DATA_CANISTER_ID;
    await userManager.removePlayerFromTeams(Environment.LEAGUE_ID, playerId, Environment.BACKEND_CANISTER_ID);
    await seasonManager.updateDataHash("players");
    return #ok();
  };

  public shared ({ caller }) func notifyAppsOfRetirement(leagueId : FootballTypes.LeagueId, playerId : FootballTypes.PlayerId) : async Result.Result<(), T.Error> {
    assert Principal.toText(caller) == NetworkEnvironmentVariables.DATA_CANISTER_ID;

    //TODO

    return #ok();
  };

  public shared ({ caller }) func notifyAppsOfPositionChange(leagueId : FootballTypes.LeagueId, playerId : FootballTypes.PlayerId) : async Result.Result<(), T.Error> {
    assert Principal.toText(caller) == NetworkEnvironmentVariables.DATA_CANISTER_ID;
    await userManager.removePlayerFromTeams(Environment.LEAGUE_ID, playerId, Environment.BACKEND_CANISTER_ID);
    return #ok();
  };

  public shared ({ caller }) func notifyAppsOfGameweekStarting(leagueId : FootballTypes.LeagueId, seasonId : FootballTypes.SeasonId, gameweek : FootballTypes.GameweekNumber) : async Result.Result<(), T.Error> {
    assert Principal.toText(caller) == NetworkEnvironmentVariables.DATA_CANISTER_ID;

    let data_canister = actor (NetworkEnvironmentVariables.DATA_CANISTER_ID) : actor {
      getPlayers : shared query (leagueId : FootballTypes.LeagueId) -> async Result.Result<[DTOs.PlayerDTO], T.Error>;
    };

    let playersResult = await data_canister.getPlayers(Environment.LEAGUE_ID);

    switch (playersResult) {
      case (#ok players) {
        seasonManager.storePlayersSnapshot(seasonId, gameweek, players);
      };
      case (#err _) {};
    };

    let _ = await userManager.snapshotFantasyTeams(seasonId, gameweek, 0); //TODO MONTH
    await userManager.resetWeeklyTransfers();
    await seasonManager.updateDataHash("league_status");
    return #ok();
  };

  public shared ({ caller }) func notifyAppsOfFixtureFinalised(leagueId : FootballTypes.LeagueId, seasonId : FootballTypes.SeasonId, gameweek : FootballTypes.GameweekNumber) : async Result.Result<(), T.Error> {

    assert Principal.toText(caller) == NetworkEnvironmentVariables.DATA_CANISTER_ID;
    let _ = await userManager.calculateFantasyTeamScores(Environment.LEAGUE_ID, seasonId, gameweek, 0); //TODO month shouldn't be passed in
    let managerCanisterIds = userManager.getUniqueManagerCanisterIds();
    let _ = leaderboardManager.calculateLeaderboards(seasonId, gameweek, 0, managerCanisterIds);

    await seasonManager.updateDataHash("league_status");

    return #ok();
  };

  public shared ({ caller }) func notifyAppsOfSeasonComplete(leagueId : FootballTypes.LeagueId, seasonId : FootballTypes.SeasonId) : async Result.Result<(), T.Error> {

    assert Principal.toText(caller) == NetworkEnvironmentVariables.DATA_CANISTER_ID;

    //TODO

    return #ok();
  };


  /* ----- Private Motoko Actor Functions ----- */

  private func isManagerCanister(principalId : Text) : Bool {
    let managerCanisterIds = userManager.getUniqueManagerCanisterIds();
    return Option.isSome(
      Array.find<Base.PrincipalId>(
        managerCanisterIds,
        func(dataAdmin : Base.PrincipalId) : Bool {
          dataAdmin == principalId;
        },
      )
    );
  };

  private func hasMembership(caller: Base.PrincipalId) : async Bool {
    let membershipResult = await userManager.getUserICFCMembership(caller);
    switch(membershipResult){
      case (#ok membership){
        let membershipType = membership.membershipType;
        if(membershipType == #Founding or membershipType == #Lifetime or membershipType == #Monthly or membershipType == #Seasonal){
          return true;
        };
      };
      case (#err _){}
    };
    return false;
  };

  //TODO: John with the WWL refactoring I'm not sure we need these or atleast they need to be changed to fit in with the cycles management:

  private func checkCanisterCycles() : async () {
    let root_canister = actor (NetworkEnvironmentVariables.SNS_ROOT_CANISTER_ID) : actor {
      get_sns_canisters_summary : (request : Root.GetSnsCanistersSummaryRequest) -> async Root.GetSnsCanistersSummaryResponse;
    };

    let summaryResult = await root_canister.get_sns_canisters_summary({
      update_canister_list = ?false;
    });
    let dappsMinusBackend = Array.filter<Root.CanisterSummary>(
      summaryResult.dapps,
      func(dapp : Root.CanisterSummary) {
        dapp.canister_id != ?Principal.fromText(NetworkEnvironmentVariables.OPENFPL_BACKEND_CANISTER_ID);
      },
    );

    for (dappCanister in Iter.fromArray(dappsMinusBackend)) {
      switch (dappCanister.canister_id) {
        case (?foundCanisterId) {
          let ignoreCanister = Principal.toText(foundCanisterId) == "bboqb-jiaaa-aaaal-qb6ea-cai" or Principal.toText(foundCanisterId) == "bgpwv-eqaaa-aaaal-qb6eq-cai" or Principal.toText(foundCanisterId) == "hqfmc-cqaaa-aaaal-qitcq-cai";
          if (not ignoreCanister) {
            await queryAndTopupCanister(Principal.toText(foundCanisterId), 50_000_000_000_000, 25_000_000_000_000);
          };
        };
        case (null) {};
      };
    };

    //TODO: Remove after assigned to SNS
    await queryAndTopupCanister(Environment.FRONTEND_CANISTER_ID, 50_000_000_000_000, 25_000_000_000_000);
    await queryAndTopupCanister(NetworkEnvironmentVariables.DATA_CANISTER_ID, 50_000_000_000_000, 25_000_000_000_000);

    let managerCanisterIds = userManager.getUniqueManagerCanisterIds();
    for (canisterId in Iter.fromArray(managerCanisterIds)) {
      await queryAndTopupCanister(canisterId, 50_000_000_000_000, 25_000_000_000_000);
    };

    let leaderboardCanisterIds = leaderboardManager.getUniqueLeaderboardCanisterIds();
    for (canisterId in Iter.fromArray(leaderboardCanisterIds)) {
      await queryAndTopupCanister(canisterId, 50_000_000_000_000, 25_000_000_000_000);
    };

    await topupCanister(summaryResult.index, 50_000_000_000_000, 25_000_000_000_000);
    await topupCanister(summaryResult.governance, 50_000_000_000_000, 25_000_000_000_000);
    await topupCanister(summaryResult.ledger, 50_000_000_000_000, 25_000_000_000_000);
    await topupCanister(summaryResult.root, 50_000_000_000_000, 25_000_000_000_000);
    await topupCanister(summaryResult.swap, 5_000_000_000_000, 2_500_000_000_000);
    for (canisterId in Iter.fromArray(summaryResult.archives)) {
      await topupCanister(?canisterId, 5_000_000_000_000, 2_500_000_000_000);
    };

    //ignore Timer.setTimer<system>(#nanoseconds(Int.abs(86_400_000_000_000)), checkCanisterCycles);
    return;
  };

  private func topupCanister(canisterSummary : ?Root.CanisterSummary, topupTriggerAmount : Nat, topupAmount : Nat) : async () {
    switch (canisterSummary) {
      case (?foundCanister) {
        switch (foundCanister.status) {
          case (?foundStatus) {
            if (foundStatus.cycles < topupTriggerAmount) {
              switch (foundCanister.canister_id) {
                case (?foundCanisterId) {
                  let IC : Management.Management = actor (NetworkEnvironmentVariables.Default);
                  let canisterActor = actor (Principal.toText(foundCanisterId)) : actor {};
                  await CanisterUtilities.topup_canister_(canisterActor, IC, topupAmount);

                  let topupsBuffer = Buffer.fromArray<Base.CanisterTopup>(topups);
                  topupsBuffer.add({
                    canisterId = Principal.toText(foundCanisterId);
                    cyclesAmount = topupAmount;
                    topupTime = Time.now();
                  });
                  topups := Buffer.toArray(topupsBuffer);
                };
                case (null) {};
              };
            };
          };
          case (null) {};
        };
      };
      case (null) {};
    };
  };

  private func queryAndTopupCanister(canisterId : Base.CanisterId, cyclesTriggerAmount : Nat, topupAmount : Nat) : async () {
    let IC : Management.Management = actor (NetworkEnvironmentVariables.Default);
    let canisterActor = actor (canisterId) : actor {};

    let canisterStatusResult = await CanisterUtilities.getCanisterStatus_(canisterActor, ?Principal.fromActor(Self), IC);

    switch (canisterStatusResult) {
      case (?canisterStatus) {

        if (canisterStatus.cycles < cyclesTriggerAmount) {
          await CanisterUtilities.topup_canister_(canisterActor, IC, topupAmount);
          let topupsBuffer = Buffer.fromArray<Base.CanisterTopup>(topups);
          topupsBuffer.add({
            canisterId = canisterId;
            cyclesAmount = topupAmount;
            topupTime = Time.now();
          });
          topups := Buffer.toArray(topupsBuffer);
        };
      };
      case (null) {};
    };
  };

  public shared func getManagerCanisterIds() : async Result.Result<[Base.CanisterId], T.Error> {
    return #ok(userManager.getUniqueManagerCanisterIds());
  };

  public shared func getLeaderboardCanisterIds() : async Result.Result<[Base.CanisterId], T.Error> {
    return #ok(leaderboardManager.getStableUniqueLeaderboardCanisterIds());
  };

  public shared func getActiveLeaderboardCanisterId() : async Result.Result<Text, T.Error> {
    return #ok(leaderboardManager.getStableActiveCanisterId());
  };

  public shared func getCanisters(dto : Queries.GetCanistersDTO) : async Result.Result<[Queries.CanisterDTO], T.Error> {
    let canistersBuffer = Buffer.fromArray<Queries.CanisterDTO>([]);
    let root_canister = actor (NetworkEnvironmentVariables.SNS_ROOT_CANISTER_ID) : actor {
      get_sns_canisters_summary : (request : Root.GetSnsCanistersSummaryRequest) -> async Root.GetSnsCanistersSummaryResponse;
    };

    switch (dto.canisterType) {
      case (#SNS) {

        let summaryResult = await root_canister.get_sns_canisters_summary({
          update_canister_list = ?false;
        });
        var snsCanistersBuffer = Buffer.fromArray<Root.CanisterSummary>([]);

        snsCanistersBuffer := appendSNSCanister(snsCanistersBuffer, summaryResult.governance);
        snsCanistersBuffer := appendSNSCanister(snsCanistersBuffer, summaryResult.root);
        snsCanistersBuffer := appendSNSCanister(snsCanistersBuffer, summaryResult.swap);
        snsCanistersBuffer := appendSNSCanister(snsCanistersBuffer, summaryResult.ledger);
        snsCanistersBuffer := appendSNSCanister(snsCanistersBuffer, summaryResult.index);

        for (canister in Iter.fromArray(Buffer.toArray(snsCanistersBuffer))) {
          switch (canister.canister_id) {
            case (?foundCanisterId) {
              let canisterTopups = Array.filter<Base.CanisterTopup>(
                topups,
                func(topup : Base.CanisterTopup) {
                  topup.canisterId == Principal.toText(foundCanisterId);
                },
              );

              switch (canister.status) {
                case (?foundStatus) {

                  canistersBuffer.add({
                    canisterId = Principal.toText(foundCanisterId);
                    cycles = foundStatus.cycles;
                    computeAllocation = foundStatus.settings.compute_allocation;
                    topups = canisterTopups;
                  });

                };
                case (null) {};
              };
            };
            case (null) {};
          };
        };
      };
      case (#Manager) {
        let managerCanisterIds = userManager.getUniqueManagerCanisterIds();
        for (canisterId in Iter.fromArray(managerCanisterIds)) {

          let IC : Management.Management = actor (NetworkEnvironmentVariables.Default);
          let canisterInfo = await (
            IC.canister_status({
              canister_id = Principal.fromText(canisterId);
              num_requested_changes = null;
            })
          );

          let canisterTopups = Array.filter<Base.CanisterTopup>(
            topups,
            func(topup : Base.CanisterTopup) {
              topup.canisterId == canisterId;
            },
          );

          canistersBuffer.add({
            canisterId = canisterId;
            cycles = canisterInfo.cycles;
            computeAllocation = canisterInfo.settings.compute_allocation;
            topups = canisterTopups;
          });
        };
      };
      case (#Leaderboard) {
        let leaderboardCanisterIds = leaderboardManager.getUniqueLeaderboardCanisterIds();
        for (canisterId in Iter.fromArray(leaderboardCanisterIds)) {

          let IC : Management.Management = actor (NetworkEnvironmentVariables.Default);
          let canisterInfo = await (
            IC.canister_status({
              canister_id = Principal.fromText(canisterId);
              num_requested_changes = null;
            })
          );

          let canisterTopups = Array.filter<Base.CanisterTopup>(
            topups,
            func(topup : Base.CanisterTopup) {
              topup.canisterId == canisterId;
            },
          );

          canistersBuffer.add({
            canisterId = canisterId;
            cycles = canisterInfo.cycles;
            computeAllocation = canisterInfo.settings.compute_allocation;
            topups = canisterTopups;
          });
        };
      };
      case (#Archive) {
        let summaryResult = await root_canister.get_sns_canisters_summary({
          update_canister_list = ?false;
        });

        for (archiveCanister in Iter.fromArray(summaryResult.archives)) {
          switch (archiveCanister.canister_id) {
            case (?foundCanisterId) {
              let canisterTopups = Array.filter<Base.CanisterTopup>(
                topups,
                func(topup : Base.CanisterTopup) {
                  topup.canisterId == Principal.toText(foundCanisterId);
                },
              );

              switch (archiveCanister.status) {
                case (?foundStatus) {

                  canistersBuffer.add({
                    canisterId = Principal.toText(foundCanisterId);
                    cycles = foundStatus.cycles;
                    computeAllocation = foundStatus.settings.compute_allocation;
                    topups = canisterTopups;
                  });

                };
                case (null) {};
              };
            };
            case (null) {};
          };
        };
      };
      case (#Dapp) {
        let summaryResult = await root_canister.get_sns_canisters_summary({
          update_canister_list = ?false;
        });
        let dappsMinusBackend = Array.filter<Root.CanisterSummary>(
          summaryResult.dapps,
          func(dapp : Root.CanisterSummary) {
            dapp.canister_id != ?Principal.fromText(NetworkEnvironmentVariables.OPENFPL_BACKEND_CANISTER_ID);
          },
        );
        for (dappCanister in Iter.fromArray(dappsMinusBackend)) {
          switch (dappCanister.canister_id) {
            case (?foundCanisterId) {
              let canisterTopups = Array.filter<Base.CanisterTopup>(
                topups,
                func(topup : Base.CanisterTopup) {
                  topup.canisterId == Principal.toText(foundCanisterId);
                },
              );

              switch (dappCanister.status) {
                case (?foundStatus) {

                  canistersBuffer.add({
                    canisterId = Principal.toText(foundCanisterId);
                    cycles = foundStatus.cycles;
                    computeAllocation = foundStatus.settings.compute_allocation;
                    topups = canisterTopups;
                  });

                };
                case (null) {};
              };
            };
            case (null) {};
          };
        };

        //TODO: Remove after assigned to SNS
        let IC : Management.Management = actor (NetworkEnvironmentVariables.Default);
        let frontendCanisterInfo = await (
          IC.canister_status({
            canister_id = Principal.fromText(Environment.FRONTEND_CANISTER_ID);
            num_requested_changes = null;
          })
        );

        let frontendCanisterTopups = Array.filter<Base.CanisterTopup>(
          topups,
          func(topup : Base.CanisterTopup) {
            topup.canisterId == Environment.FRONTEND_CANISTER_ID;
          },
        );

        canistersBuffer.add({
          canisterId = Environment.FRONTEND_CANISTER_ID;
          cycles = frontendCanisterInfo.cycles;
          computeAllocation = frontendCanisterInfo.settings.compute_allocation;
          topups = frontendCanisterTopups;
        });

        //TODO: Remove after assigned to SNS
        let dataCanisterInfo = await (
          IC.canister_status({
            canister_id = Principal.fromText(NetworkEnvironmentVariables.DATA_CANISTER_ID);
            num_requested_changes = null;
          })
        );

        let dataCanisterTopups = Array.filter<Base.CanisterTopup>(
          topups,
          func(topup : Base.CanisterTopup) {
            topup.canisterId == NetworkEnvironmentVariables.DATA_CANISTER_ID;
          },
        );

        canistersBuffer.add({
          canisterId = NetworkEnvironmentVariables.DATA_CANISTER_ID;
          cycles = dataCanisterInfo.cycles;
          computeAllocation = dataCanisterInfo.settings.compute_allocation;
          topups = dataCanisterTopups;
        });

      };
    };

    return #ok(Buffer.toArray(canistersBuffer));
  };

  private func appendSNSCanister(buffer : Buffer.Buffer<Root.CanisterSummary>, canisterSummary : ?Root.CanisterSummary) : Buffer.Buffer<Root.CanisterSummary> {

    switch (canisterSummary) {
      case (?foundCanister) {
        buffer.add(foundCanister);
      };
      case (null) {};
    };
    return buffer;
  };




  /* ----- END WIP ----- */






  /* ----- Canister Lifecycle Management ----- */

  system func preupgrade() {
    getManagerStableVariables();
  };

  system func postupgrade() {
    setManagerStableVariables();
    ignore Timer.setTimer<system>(#nanoseconds(Int.abs(1)), postUpgradeCallback);
  };

  private func postUpgradeCallback() : async () {  
    //await updateManagerCanisterWasms();
    //await updateLeaderboardCanisterWasms();
  };


  /* ----- Canister Update Functions ----- */

  private func updateManagerCanisterWasms() : async () {
    let managerCanisterIds = userManager.getUniqueManagerCanisterIds();
    let IC : Management.Management = actor (NetworkEnvironmentVariables.Default);
    for (canisterId in Iter.fromArray(managerCanisterIds)) {
      await IC.stop_canister({ canister_id = Principal.fromText(canisterId) });
      let oldManagement = actor (canisterId) : actor {};
      let _ = await (system ManagerCanister._ManagerCanister)(#upgrade oldManagement)();
      await IC.start_canister({ canister_id = Principal.fromText(canisterId) });
    };
  };

  private func updateLeaderboardCanisterWasms() : async () {
    let leaderboardCanisterIds = leaderboardManager.getUniqueLeaderboardCanisterIds();
    let IC : Management.Management = actor (NetworkEnvironmentVariables.Default);
    for (canisterId in Iter.fromArray(leaderboardCanisterIds)) {
      await IC.stop_canister({ canister_id = Principal.fromText(canisterId) });
      let oldLeaderboard = actor (canisterId) : actor {};
      let _ = await (system LeaderboardCanister._LeaderboardCanister)(#upgrade oldLeaderboard)();
      await IC.start_canister({ canister_id = Principal.fromText(canisterId) });
    };
  };

  private func getManagerStableVariables(){
    stable_unique_weekly_leaderboard_canister_ids := leaderboardManager.getStableUniqueLeaderboardCanisterIds();
    stable_weekly_leaderboard_canister_ids := leaderboardManager.getStableWeeklyLeaderboardCanisterIds();
    stable_monthly_leaderboard_canister_ids := leaderboardManager.getStableMonthlyLeaderboardCanisterIds();
    stable_season_leaderboard_canister_ids := leaderboardManager.getStableSeasonLeaderboardCanisterIds();

    stable_active_reward_rates := leaderboardManager.getStableActiveRewardRates();
    stable_historic_reward_rates := leaderboardManager.getStableHistoricRewardRates();

    stable_team_value_leaderboards := leaderboardManager.getStableTeamValueLeaderboards();
    stable_weekly_rewards := leaderboardManager.getStableWeeklyRewards();
    stable_monthly_rewards := leaderboardManager.getStableMonthlyRewards();
    stable_season_rewards := leaderboardManager.getStableSeasonRewards();
    stable_most_valuable_team_rewards := leaderboardManager.getStableMostValuableTeamRewards();
    stable_high_scoring_player_rewards := leaderboardManager.getStableHighestScoringPlayerRewards();

    stable_weekly_all_time_high_scores := leaderboardManager.getStableWeeklyAllTimeHighScores();
    stable_monthly_all_time_high_scores := leaderboardManager.getStableMonthlyAllTimeHighScores();
    stable_season_all_time_high_scores := leaderboardManager.getStableSeasonAllTimeHighScores();
    stable_weekly_ath_prize_pool := leaderboardManager.getStableWeeklyATHPrizePool();
    stable_monthly_ath_prize_pool := leaderboardManager.getStableMonthlyATHPrizePool();
    stable_season_ath_prize_pool := leaderboardManager.getStableSeasonATHPrizePool();

    stable_active_leaderbord_canister_id := leaderboardManager.getStableActiveCanisterId();

    stable_app_status := seasonManager.getStableAppStatus();
    stable_league_gameweek_statuses := seasonManager.getStableLeagueGameweekStatuses();
    stable_league_month_statuses := seasonManager.getStableLeagueMonthStatuses();
    stable_league_season_statuses := seasonManager.getStableLeagueSeasonStatuses();

    stable_data_hashes := seasonManager.getStableDataHashes();
    stable_player_snapshots := seasonManager.getStablePlayersSnapshots();

    stable_manager_canister_ids := userManager.getStableManagerCanisterIds();
    stable_usernames := userManager.getStableUsernames();
    stable_unique_manager_canister_ids := userManager.getStableUniqueManagerCanisterIds();
    stable_total_managers := userManager.getStableTotalManagers();
    stable_active_manager_canister_id := userManager.getStableActiveManagerCanisterId();
    stable_user_icfc_profiles := userManager.getStableUserICFCProfiles();
  };

  private func setManagerStableVariables(){
    leaderboardManager.setStableUniqueLeaderboardCanisterIds(stable_unique_weekly_leaderboard_canister_ids);
    leaderboardManager.setStableWeeklyLeaderboardCanisterIds(stable_weekly_leaderboard_canister_ids);
    leaderboardManager.setStableMonthlyLeaderboardCanisterIds(stable_monthly_leaderboard_canister_ids);
    leaderboardManager.setStableSeasonLeaderboardCanisterIds(stable_season_leaderboard_canister_ids);

    leaderboardManager.setStableActiveRewardRates(stable_active_reward_rates);
    leaderboardManager.setStableHistoricRewardRates(stable_historic_reward_rates);

    leaderboardManager.setStableTeamValueLeaderboards(stable_team_value_leaderboards);
    leaderboardManager.setStableWeeklyRewards(stable_weekly_rewards);
    leaderboardManager.setStableMonthlyRewards(stable_monthly_rewards);
    leaderboardManager.setStableSeasonRewards(stable_season_rewards);
    leaderboardManager.setStableMostValuableTeamRewards(stable_most_valuable_team_rewards);
    leaderboardManager.setStableHighestScoringPlayerRewards(stable_high_scoring_player_rewards);

    leaderboardManager.setStableWeeklyAllTimeHighScores(stable_weekly_all_time_high_scores);
    leaderboardManager.setStableMonthlyAllTimeHighScores(stable_monthly_all_time_high_scores);
    leaderboardManager.setStableSeasonAllTimeHighScores(stable_season_all_time_high_scores);
    leaderboardManager.setStableWeeklyATHPrizePool(stable_weekly_ath_prize_pool);
    leaderboardManager.setStableMonthlyATHPrizePool(stable_monthly_ath_prize_pool);
    leaderboardManager.setStableSeasonATHPrizePool(stable_season_ath_prize_pool);
    leaderboardManager.setStableActiveCanisterId(stable_active_leaderbord_canister_id);

    seasonManager.setStableAppStatus(stable_app_status);
    seasonManager.setStableDataHashes(stable_data_hashes);
    seasonManager.setStablePlayersSnapshots(stable_player_snapshots);

    userManager.setStableManagerCanisterIds(stable_manager_canister_ids);
    userManager.setStableUsernames(stable_usernames);
    userManager.setStableUniqueManagerCanisterIds(stable_unique_manager_canister_ids);
    userManager.setStableTotalManagers(stable_total_managers);
    userManager.setStableActiveManagerCanisterId(stable_active_manager_canister_id);
    userManager.setStableUserICFCProfiles(stable_user_icfc_profiles);
  };
};
