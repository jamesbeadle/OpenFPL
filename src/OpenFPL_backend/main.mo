//TODO - Remove and import correct mops package

import Base "mo:waterway-mops/BaseTypes";
import Ids "mo:waterway-mops/Ids";
import BaseTypes "mo:waterway-mops/BaseTypes";
import Enums "mo:waterway-mops/Enums";
import ICFCEnums "mo:waterway-mops/ICFCEnums";
import CanisterIds "mo:waterway-mops/CanisterIds";
import Management "mo:waterway-mops/Management";
import CanisterUtilities "mo:waterway-mops/CanisterUtilities";
import FootballIds "mo:waterway-mops/football/FootballIds";
import FootballDefinitions "mo:waterway-mops/football/FootballDefinitions";
import BaseDefinitions "mo:waterway-mops/BaseDefinitions";
import BaseQueries "mo:waterway-mops/queries/BaseQueries";
import Root "mo:waterway-mops/sns-wrappers/root";
import PlayerQueries "mo:waterway-mops/queries/football-queries/PlayerQueries";
import Environment "Environment";
import LeagueNotificationCommands "mo:waterway-mops/football/LeagueNotificationCommands";
import PlayerNotificationCommands "mo:waterway-mops/football/PlayerNotificationCommands";
import BaseUtilities "mo:waterway-mops/BaseUtilities";
import DateTimeUtilities "mo:waterway-mops/DateTimeUtilities";
import LeaderboardPayoutCommands "mo:waterway-mops/football/LeaderboardPayoutCommands";
import DataCanister "canister:data_canister";

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
import List "mo:base/List";
import Debug "mo:base/Debug";
import Order "mo:base/Order";
import Countries "mo:waterway-mops/def/Countries";

/* ----- Canister Definition Files ----- */

import ManagerCanister "./canister_definitions/manager-canister";
import LeaderboardCanister "./canister_definitions/leaderboard-canister";

/* ----- Queries ----- */

import AppQueries "./queries/app_queries";
import LeaderboardQueries "./queries/leaderboard_queries";
import UserQueries "./queries/user_queries";

/* ----- Commands ----- */
import UserCommands "./commands/user_commands";
import ICFCCommands "./commands/icfc_commands";

/* ----- Managers ----- */

import LeaderboardManager "./managers/leaderboard-manager";
import UserManager "./managers/user-manager";
import SeasonManager "./managers/season-manager";
import DataManager "./managers/data-manager";
import AppTypes "types/app_types";

/* ----- WWL Canister Management ----- */
import CanisterCommands "mo:waterway-mops/canister-management/CanisterCommands";
import CanisterQueries "mo:waterway-mops/canister-management/CanisterQueries";
import CanisterManager "mo:waterway-mops/canister-management/CanisterManager";
import FixtureQueries "mo:waterway-mops/queries/football-queries/FixtureQueries";

/* ----- Only Stable Variables Should Use Types ----- */


actor Self {

  /* ----- Stable Canister Variables ----- */

  private stable var stable_active_reward_rates : AppTypes.RewardRates = {
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
  private stable var stable_historic_reward_rates : [AppTypes.RewardRates] = [];
  private stable var stable_team_value_leaderboards : [(FootballIds.SeasonId, AppTypes.TeamValueLeaderboard)] = [];
  private stable var stable_weekly_rewards : [AppTypes.WeeklyRewards] = [];
  private stable var stable_monthly_rewards : [AppTypes.MonthlyRewards] = [];
  private stable var stable_season_rewards : [AppTypes.SeasonRewards] = [];
  private stable var stable_most_valuable_team_rewards : [AppTypes.RewardsList] = [];
  private stable var stable_high_scoring_player_rewards : [AppTypes.RewardsList] = [];
  private stable var stable_weekly_all_time_high_scores : [AppTypes.HighScoreRecord] = [];
  private stable var stable_monthly_all_time_high_scores : [AppTypes.HighScoreRecord] = [];
  private stable var stable_season_all_time_high_scores : [AppTypes.HighScoreRecord] = [];
  private stable var stable_weekly_ath_prize_pool : Nat64 = 0;
  private stable var stable_monthly_ath_prize_pool : Nat64 = 0;
  private stable var stable_season_ath_prize_pool : Nat64 = 0;
  private stable var stable_active_leaderbord_canister_id : Ids.CanisterId = "";
  private stable var stable_leaderboard_payout_requests : [LeaderboardPayoutCommands.PayoutRequest] = [];

  //Season Manager stable variables
  private stable var stable_app_status : BaseTypes.AppStatus = {
    onHold = false;
    version = "2.1.0";
  };

  private stable var stable_league_gameweek_statuses : [AppTypes.LeagueGameweekStatus] = [];
  private stable var stable_league_month_statuses : [AppTypes.LeagueMonthStatus] = [];
  private stable var stable_league_season_statuses : [AppTypes.LeagueSeasonStatus] = [];

  private stable var stable_data_hashes : [Base.DataHash] = [];

  private stable var stable_player_snapshots : [(FootballIds.SeasonId, [(FootballDefinitions.GameweekNumber, [DataCanister.Player])])] = [];

  //User Manager stable variables

  private stable var stable_manager_canister_ids : [(Ids.PrincipalId, Ids.CanisterId)] = [];
  private stable var stable_usernames : [(Ids.PrincipalId, Text)] = [];
  private stable var stable_unique_manager_canister_ids : [Ids.CanisterId] = [];
  private stable var stable_total_managers : Nat = 0;
  private stable var stable_active_manager_canister_id : Ids.CanisterId = "";
  private stable var topups : [Base.CanisterTopup] = [];
  private stable var stable_user_icfc_links : [(Ids.PrincipalId, AppTypes.ICFCLink)] = [];

  private stable var stable_unique_weekly_leaderboard_canister_ids : [Ids.CanisterId] = [];
  private stable var stable_weekly_leaderboard_canister_ids : [(FootballIds.SeasonId, [(FootballDefinitions.GameweekNumber, Ids.CanisterId)])] = [];
  private stable var stable_monthly_leaderboard_canister_ids : [(FootballIds.SeasonId, [(BaseDefinitions.CalendarMonth, Ids.CanisterId)])] = [];
  private stable var stable_season_leaderboard_canister_ids : [(FootballIds.SeasonId, Ids.CanisterId)] = [];

  /* ----- Domain Object Managers ----- */

  private let userManager = UserManager.UserManager();
  private let seasonManager = SeasonManager.SeasonManager();
  private let leaderboardManager = LeaderboardManager.LeaderboardManager();

  private let dataManager = DataManager.DataManager();
  private let canisterManager = CanisterManager.CanisterManager();

  /* ----- General App Queries ----- */

  public shared ({ caller }) func getAppStatus() : async Result.Result<BaseQueries.AppStatus, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert await hasMembership(principalId);
    return seasonManager.getAppStatus();
  };

  public shared ({ caller }) func getTotalManagers() : async Result.Result<Nat, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert await hasMembership(principalId);
    return userManager.getTotalManagers();
  };

  public shared ({ caller }) func getActiveRewardRates() : async Result.Result<AppQueries.RewardRates, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert await hasMembership(principalId);
    let rewardRates = leaderboardManager.getActiveRewardRates();
    return #ok(rewardRates);
  };

  /* ----- Data Hash Queries ----- */

  public shared ({ caller }) func getDataHashes() : async Result.Result<[DataCanister.DataHash], Enums.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert await hasMembership(principalId);
    return seasonManager.getDataHashes();
  };

  public shared ({ caller }) func getICFCDataHash() : async Result.Result<Text, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    let dto : UserQueries.GetICFCDataHash = {
      principalId = Principal.toText(caller);
    };
    return userManager.getICFCDataHash(dto);
  };

  /* ----- User Queries ----- */

  public shared ({ caller }) func getProfile() : async Result.Result<UserQueries.CombinedProfile, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert await hasMembership(principalId);
    let dto : UserQueries.GetProfile = {
      principalId = Principal.toText(caller);
    };
    return await userManager.getCombinedProfile(dto);
  };

  public shared ({ caller }) func getICFCLinkStatus() : async Result.Result<ICFCEnums.ICFCLinkStatus, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    return await userManager.getUserICFCLinkStatus(principalId);
  };

  public shared ({ caller }) func getTeamSelection() : async Result.Result<UserQueries.TeamSetup, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert await hasMembership(principalId);
    let statusResult = await getLeagueStatus();
    let dto : UserQueries.GetTeamSetup = {
      principalId = Principal.toText(caller);
    };
    switch (statusResult) {
      case (#ok status) {
        return await userManager.getTeamSetup(dto, status.activeSeasonId);
      };
      case (#err error) {
        return #err(error);
      };
    };
  };

  public shared ({ caller }) func getManager(dto : UserQueries.GetManager) : async Result.Result<UserQueries.Manager, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert await hasMembership(principalId);
    let statusResult = await getLeagueStatus();
    switch (statusResult) {
      case (#ok status) {

        /*
          // TOOD: Again this is just for display purposes so you cans see some high level information in the manager object but at this point the calculation process is too long
            //We should possible just track this informaation directly in the manager object and not call out to get the information as it'll be more expenive.

            An example of one of the calls to get the weekly leaderboard information


          let weeklyLeaderboardEntry = await leaderboardManager.getWeeklyLeaderboardEntry(dto.principalId, status.activeSeasonId, status.activeGameweek);

        */

        return await userManager.getManager(dto, status.activeSeasonId, null, null, null);
      };
      case (#err error) {
        return #err(error);
      };
    };
  };

  public shared ({ caller }) func getManagerByUsername(dto : UserQueries.GetManagerByUsername) : async Result.Result<UserQueries.Manager, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert await hasMembership(principalId);
    return await userManager.getManagerByUsername(dto.username);
  };

  public shared ({ caller }) func getFantasyTeamSnapshot(dto : UserQueries.GetFantasyTeamSnapshot) : async Result.Result<UserQueries.FantasyTeamSnapshot, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert await hasMembership(principalId);
    return await userManager.getFantasyTeamSnapshot(dto);
  };

  /* ----- User Commands ----- */

  public shared ({ caller }) func linkICFCProfile() : async Result.Result<(), Enums.Error> {
    assert not Principal.isAnonymous(caller);
    let principalIdText = Principal.toText(caller);

    let dto : ICFCCommands.VerifyICFCProfile = {
      principalId = principalIdText;
    };
    return await userManager.verifyICFCLink(dto);
  };

  public shared ({ caller }) func updateFavouriteClub(dto : UserCommands.SetFavouriteClub) : async Result.Result<(), Enums.Error> {
    assert not Principal.isAnonymous(caller);
    assert await hasMembership(Principal.toText(caller));
    let principalId = Principal.toText(caller);
    assert dto.principalId == principalId;

    let clubsResult = await dataManager.getClubs({
      leagueId = Environment.LEAGUE_ID;
    });
    switch (clubsResult) {
      case (#ok clubs) {

        let statusResult = await getLeagueStatus();
        switch (statusResult) {
          case (#ok status) {
            return await userManager.updateFavouriteClub(dto, clubs.clubs, status.seasonActive);
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

  public shared ({ caller }) func saveTeamSelection(dto : UserCommands.SaveFantasyTeam) : async Result.Result<(), Enums.Error> {
    assert not Principal.isAnonymous(caller);
    assert await hasMembership(Principal.toText(caller));
    let principalId = Principal.toText(caller);
    let leagueStatusResult = await getLeagueStatus();
    assert dto.principalId == principalId;

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

        let playersResult = await dataManager.getPlayers({
          leagueId = Environment.LEAGUE_ID;
        });
        switch (playersResult) {
          case (#ok players) {
            return await userManager.saveTeamSelection(dto, leagueStatus.activeSeasonId, leagueStatus.unplayedGameweek, players.players);
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

  public shared ({ caller }) func saveBonusSelection(dto : UserCommands.PlayBonus) : async Result.Result<(), Enums.Error> {
    assert not Principal.isAnonymous(caller);
    assert await hasMembership(Principal.toText(caller));
    let principalId = Principal.toText(caller);
    let leagueStatusResult = await getLeagueStatus();
    assert dto.principalId == principalId;

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

        return await userManager.saveBonusSelection(dto, leagueStatus.unplayedGameweek);
      };
      case (#err error) {
        return #err(error);
      };
    };
  };

  /* ----- Leaderboard Queries ----- */

  public shared func getWeeklyLeaderboard(dto : LeaderboardQueries.GetWeeklyLeaderboard) : async Result.Result<LeaderboardQueries.WeeklyLeaderboard, Enums.Error> {
    return await leaderboardManager.getWeeklyLeaderboard(dto);
  };

  public shared func getMonthlyLeaderboard(dto : LeaderboardQueries.GetMonthlyLeaderboard) : async Result.Result<LeaderboardQueries.MonthlyLeaderboard, Enums.Error> {
    return await leaderboardManager.getMonthlyLeaderboard(dto);
  };

  public shared func getSeasonLeaderboard(dto : LeaderboardQueries.GetSeasonLeaderboard) : async Result.Result<LeaderboardQueries.SeasonLeaderboard, Enums.Error> {
    return await leaderboardManager.getSeasonLeaderboard(dto);
  };

  public shared func mostValuableTeamLeaderboard(dto : LeaderboardQueries.GetMostValuableTeamLeaderboard) : async Result.Result<LeaderboardQueries.MostValuableTeamLeaderboard, Enums.Error> {
    return await leaderboardManager.mostValuableTeamLeaderboard(dto);
  };

  public shared ({ caller }) func getLeagueStatus() : async Result.Result<DataCanister.LeagueStatus, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    assert await hasMembership(Principal.toText(caller));
    return await dataManager.getLeagueStatus({
      leagueId = Environment.LEAGUE_ID;
    });
  };

  public shared ({ caller }) func getCountries() : async Result.Result<BaseQueries.Countries, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    assert await hasMembership(Principal.toText(caller));
    return #ok({
      countries = Countries.countries;
    });
  };

  public shared ({ caller }) func getSeasons(dto : DataCanister.GetSeasons) : async Result.Result<DataCanister.Seasons, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    assert await hasMembership(Principal.toText(caller));
    return await dataManager.getSeasons(dto);
  };

  public shared ({ caller }) func getClubs(dto : DataCanister.GetClubs) : async Result.Result<DataCanister.Clubs, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    assert await hasMembership(Principal.toText(caller));
    return await dataManager.getClubs(dto);
  };

  public shared ({ caller }) func getPlayers(dto : DataCanister.GetPlayers) : async Result.Result<DataCanister.Players, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    assert await hasMembership(Principal.toText(caller));
    return await dataManager.getPlayers(dto);
  };

  public shared ({ caller }) func getPlayerEvents(dto : DataCanister.GetPlayerDetailsForGameweek) : async Result.Result<DataCanister.PlayerDetailsForGameweek, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    assert await hasMembership(Principal.toText(caller));
    return await dataManager.getPlayerDetailsForGameweek(dto);
  };

  public shared ({ caller }) func getFixtures(dto : DataCanister.GetFixtures) : async Result.Result<DataCanister.Fixtures, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    assert await hasMembership(Principal.toText(caller));
    return await dataManager.getFixtures(dto : DataCanister.GetFixtures);
  };

  public shared ({ caller }) func getPlayersSnapshot(dto : AppQueries.GetPlayersSnapshot) : async Result.Result<AppQueries.PlayersSnapshot, Enums.Error> {
    assert not Principal.isAnonymous(caller);

    let validMembership = await hasMembership(Principal.toText(caller));
    let managerCanister = isManagerCanister(Principal.toText(caller));

    assert validMembership or managerCanister;

    return await seasonManager.getPlayersSnapshot(dto);
  };

  public shared ({ caller }) func getPlayersMap(dto : DataCanister.GetPlayersMap) : async Result.Result<DataCanister.PlayersMap, Enums.Error> {
    assert isManagerCanister(Principal.toText(caller));
    return await dataManager.getPlayersMap(dto);
  };

  public shared ({ caller }) func getPlayerDetails(dto : DataCanister.GetPlayerDetails) : async Result.Result<PlayerQueries.PlayerDetails, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    return await dataManager.getPlayerDetails(dto);
  };

  public shared ({ caller }) func getPostponedFixtures(dto : DataCanister.GetPostponedFixtures) : async Result.Result<DataCanister.PostponedFixtures, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    return await dataManager.getPostponedFixtures(dto);
  };

  // Temp Test function
  public shared func getAllUserICFCLinks() : async [(Ids.PrincipalId, AppTypes.ICFCLink)] {
    return await userManager.getAllUserICFCLinks();
  };

  /* ----- Football God Callback Canister Interface ----- */

  public shared ({ caller }) func addInitialFixtureNotification(dto : LeagueNotificationCommands.AddInitialFixtureNotification) : async Result.Result<(), Enums.Error> {
    await seasonManager.resetAllDataHashes();
    await userManager.resetFantasyTeams();
    return #ok();
  };

  public shared ({ caller }) func beginGameweekNotification(dto : LeagueNotificationCommands.BeginGameweekNotification) : async Result.Result<(), Enums.Error> {
    assert Principal.toText(caller) == CanisterIds.ICFC_DATA_CANISTER_ID;
    let playersResult = await dataManager.getPlayers({
      leagueId = Environment.LEAGUE_ID;
    });

    switch (playersResult) {
      case (#ok players) {

        let seasonState = await dataManager.getLeagueStatus({
          leagueId = dto.leagueId;
        });
        switch (seasonState) {
          case (#ok foundState) {

            seasonManager.storePlayersSnapshot(dto.seasonId, dto.gameweek, players);
            await userManager.snapshotFantasyTeams(dto.seasonId, dto.gameweek, foundState.activeMonth);
            await userManager.resetWeeklyTransfers();
            await seasonManager.updateDataHash("league_status");
            await checkMonthRollover(dto, foundState);
            return #ok();

          };
          case (#err error) {
            return #err(error);
          };
        };

      };
      case (#err _) {
        return #err(#NotFound);
      };
    };
  };

  private func checkMonthRollover(dto : LeagueNotificationCommands.BeginGameweekNotification, leagueStatus : DataCanister.LeagueStatus) : async () {

    let priorGameweek : FootballDefinitions.GameweekNumber = leagueStatus.activeGameweek - 1;
    let fixtures = await dataManager.getFixtures({
      leagueId = dto.leagueId;
      seasonId = dto.seasonId;
    });

    switch (fixtures) {
      case (#ok foundFixtures) {

        let gameweekFixtures = Array.filter<DataCanister.Fixture>(
          foundFixtures.fixtures,
          func(entry : DataCanister.Fixture) {
            entry.gameweek == (leagueStatus.activeGameweek - 1);
          },
        );

        let sortedFixtures = Array.sort<DataCanister.Fixture>(
          gameweekFixtures,
          func(entry1 : DataCanister.Fixture, entry2 : DataCanister.Fixture) : Order.Order {
            if (entry1.kickOff > entry2.kickOff) { return #less };
            if (entry1.kickOff == entry2.kickOff) { return #equal };
            return #greater;
          },
        );

        if (Array.size(sortedFixtures) > 0) {
          let firstGameweekFixture : DataCanister.Fixture = sortedFixtures[0];
          var priorGameweekMonth : BaseDefinitions.CalendarMonth = DateTimeUtilities.unixTimeToMonth(firstGameweekFixture.kickOff);
          if (leagueStatus.activeMonth > priorGameweekMonth) {
            await userManager.resetBonuses();
          };
        };
      };
      case (#err _) {};
    };
  };

  public shared ({ caller }) func completeGameweekNotification(dto : LeagueNotificationCommands.CompleteGameweekNotification) : async Result.Result<(), Enums.Error> {

    let managerCanisterIds = userManager.getUniqueManagerCanisterIds();
    let _ = leaderboardManager.calculateLeaderboards(dto.seasonId, dto.gameweek, 0, managerCanisterIds);

    let icfc_backend_canister = actor (CanisterIds.ICFC_BACKEND_CANISTER_ID) : actor {
      requestLeaderboardPayout : (dto : LeaderboardPayoutCommands.LeaderboardPayoutRequest) -> async Result.Result<(), Enums.Error>;
    };

    let weeklyLeaderboardResult = await leaderboardManager.getWeeklyLeaderboard({
      seasonId = dto.seasonId;
      gameweek = dto.gameweek;
      page = 0;
      searchTerm = "";
    });

    switch (weeklyLeaderboardResult) {
      case (#ok(foundLeaderboard)) {
        var entries : [LeaderboardPayoutCommands.LeaderboardEntry] = [];
        for (entry in Iter.fromArray(foundLeaderboard.entries)) {
          let leaderboardEntry : LeaderboardPayoutCommands.LeaderboardEntry = {
            principalId = entry.principalId;
            rewardAmount = entry.rewardAmount;
          };
          entries := Array.append<LeaderboardPayoutCommands.LeaderboardEntry>(entries, [leaderboardEntry]);
        };

        let payoutRequest : LeaderboardPayoutCommands.LeaderboardPayoutRequest = {
          app = #ICFC;
          entries = entries;
          gameweek = dto.gameweek;
          seasonId = dto.seasonId;
          token = #ICFC;
        };

        let res = await icfc_backend_canister.requestLeaderboardPayout(payoutRequest);

        switch (res) {
          case (#ok(_)) {
            stable_leaderboard_payout_requests := Array.append<LeaderboardPayoutCommands.PayoutRequest>(
              stable_leaderboard_payout_requests,
              [{
                seasonId = dto.seasonId;
                gameweek = dto.gameweek;
                payoutStatus = #Pending;
                payoutDate = null;
              }],
            );
          };
          case (#err(error)) {
            return #err(error);
          };
        };

        return #ok();
      };
      case (#err(error)) {
        return #err(error);
      };
    };

  };

  /* ----- ICFC Callback for paid LeaderBoard ----- */
  public shared ({ caller }) func leaderboardPaid(dto : LeaderboardPayoutCommands.CompleteLeaderboardPayout) : async Result.Result<(), Enums.Error> {
    assert Principal.toText(caller) == CanisterIds.ICFC_BACKEND_CANISTER_ID;

    let foundPayoutRequest = Array.find<LeaderboardPayoutCommands.PayoutRequest>(
      stable_leaderboard_payout_requests,
      func(entry : LeaderboardPayoutCommands.PayoutRequest) : Bool {
        entry.seasonId == dto.seasonId and entry.gameweek == dto.gameweek;
      },
    );
    switch (foundPayoutRequest) {
      case (null) {
        return #err(#NotFound);
      };
      case (foundPayoutRequest) {
        stable_leaderboard_payout_requests := Array.map(
          stable_leaderboard_payout_requests,
          func(entry : LeaderboardPayoutCommands.PayoutRequest) : LeaderboardPayoutCommands.PayoutRequest {
            if (entry.seasonId == dto.seasonId and entry.gameweek == dto.gameweek) {
              return {
                seasonId = entry.seasonId;
                gameweek = entry.gameweek;
                payoutStatus = #Paid;
                payoutDate = ?Time.now();
              };
            };
            return entry;
          },
        );
      };
    };

    return #ok();
  };

  public shared ({ caller }) func finaliseFixtureNotification(dto : LeagueNotificationCommands.CompleteFixtureNotification) : async Result.Result<(), Enums.Error> {
    assert Principal.toText(caller) == CanisterIds.ICFC_DATA_CANISTER_ID;

    let fixtures = await getFixtures({ leagueId = Environment.LEAGUE_ID; seasonId = dto.seasonId });

    switch(fixtures){
      case (#ok foundFixtures){
        
        let fixture = Array.find<FixtureQueries.Fixture>(foundFixtures.fixtures, func(entry:FixtureQueries.Fixture) : Bool {
          entry.id == dto.fixtureId;
        });

        switch(fixture){
          case (?foundFixture){

            let fixtureGameweekFixtures = Array.filter<FixtureQueries.Fixture>(foundFixtures.fixtures, func(entry: FixtureQueries.Fixture){
              entry.gameweek == foundFixture.gameweek; 
            });

            let sortedFixtures = Array.sort<DataCanister.Fixture>(
              fixtureGameweekFixtures,
              func(entry1 : DataCanister.Fixture, entry2 : DataCanister.Fixture) : Order.Order {
                if (entry1.kickOff > entry2.kickOff) { return #less };
                if (entry1.kickOff == entry2.kickOff) { return #equal };
                return #greater;
              },
            );

            if (Array.size(sortedFixtures) > 0) {
              let firstGameweekFixture : DataCanister.Fixture = sortedFixtures[0];
              var fixtureMonth : BaseDefinitions.CalendarMonth = DateTimeUtilities.unixTimeToMonth(firstGameweekFixture.kickOff);
              let _ = await userManager.calculateFantasyTeamScores(Environment.LEAGUE_ID, dto.seasonId, foundFixture.gameweek, fixtureMonth);
              await seasonManager.updateDataHash("league_status");
              return #ok();  
            };

            return #err(#NotFound);
            
          };
          case (null){
            return #err(#NotFound);
          }
        };

      };
      case (#err error){
        return #err(error);
      }
    };

  };

  public shared ({ caller }) func completeSeasonNotification(dto : LeagueNotificationCommands.CompleteSeasonNotification) : async Result.Result<(), Enums.Error> {
    assert Principal.toText(caller) == CanisterIds.ICFC_DATA_CANISTER_ID;

    //TODO

    return #ok();
  };

  public shared ({ caller }) func revaluePlayerUpNotification(dto : PlayerNotificationCommands.PlayerChangeNotification) : async Result.Result<(), Enums.Error> {

    //recaluclate any manager total team values

    return #err(#NotFound);
  };

  public shared ({ caller }) func revaluePlayerDownNotification(dto : PlayerNotificationCommands.PlayerChangeNotification) : async Result.Result<(), Enums.Error> {

    //recaluclate any manager total team values

    return #err(#NotFound);
  };

  public shared ({ caller }) func loanPlayerNotification(dto : PlayerNotificationCommands.PlayerChangeNotification) : async Result.Result<(), Enums.Error> {
    assert Principal.toText(caller) == CanisterIds.ICFC_DATA_CANISTER_ID;
    assert dto.leagueId == Environment.LEAGUE_ID;
    await userManager.removePlayerFromTeams(Environment.LEAGUE_ID, dto.playerId, CanisterIds.OPENFPL_BACKEND_CANISTER_ID);
    await seasonManager.updateDataHash("players");
    return #ok();
  };

  public shared ({ caller }) func recallPlayerNotification(dto : PlayerNotificationCommands.PlayerChangeNotification) : async Result.Result<(), Enums.Error> {
    return #err(#NotFound);
  };

  public shared ({ caller }) func expireLoanNotification(dto : PlayerNotificationCommands.PlayerChangeNotification) : async Result.Result<(), Enums.Error> {
    assert Principal.toText(caller) == CanisterIds.ICFC_DATA_CANISTER_ID;
    assert dto.leagueId == Environment.LEAGUE_ID;

    //TODO

    return #ok();
  };

  public shared ({ caller }) func transferPlayerNotification(dto : PlayerNotificationCommands.PlayerChangeNotification) : async Result.Result<(), Enums.Error> {
    assert Principal.toText(caller) == CanisterIds.ICFC_DATA_CANISTER_ID;
    await userManager.removePlayerFromTeams(Environment.LEAGUE_ID, dto.playerId, CanisterIds.OPENFPL_BACKEND_CANISTER_ID);
    await seasonManager.updateDataHash("players");
    return #ok();
  };

  public shared ({ caller }) func setFreeAgentNotification(dto : PlayerNotificationCommands.PlayerChangeNotification) : async Result.Result<(), Enums.Error> {

    //TODO - This player is a free agent so remove from everyones team

    return #err(#NotFound);
  };

  public shared ({ caller }) func retirePlayerNotification(dto : PlayerNotificationCommands.PlayerChangeNotification) : async Result.Result<(), Enums.Error> {
    assert Principal.toText(caller) == CanisterIds.ICFC_DATA_CANISTER_ID;

    //TODO - This player has retired so remove from everyones team

    return #ok();
  };

  public shared ({ caller }) func changePlayerPositionNotification(dto : PlayerNotificationCommands.PlayerChangeNotification) : async Result.Result<(), Enums.Error> {
    assert Principal.toText(caller) == CanisterIds.ICFC_DATA_CANISTER_ID;
    await userManager.removePlayerFromTeams(Environment.LEAGUE_ID, dto.playerId, CanisterIds.OPENFPL_BACKEND_CANISTER_ID);
    return #ok();
  };

  /* ----- ICFC Canister Callback Functions ----- */

  public shared ({ caller }) func notifyAppLink(dto : ICFCCommands.NotifyAppofLink) : async Result.Result<(), Enums.Error> {
    assert Principal.toText(caller) == Environment.ICFC_BACKEND_CANISTER_ID;
    let _ = await userManager.createICFCLink(dto);
    return #ok();
  };

  public shared ({ caller }) func notifyAppRemoveLink(dto : ICFCCommands.NotifyAppofRemoveLink) : async Result.Result<(), Enums.Error> {
    assert Principal.toText(caller) == Environment.ICFC_BACKEND_CANISTER_ID;
    let _ = await userManager.removeICFCLink(dto);
    return #ok();
  };

  public shared ({ caller }) func noitifyAppofICFCHashUpdate(dto : ICFCCommands.UpdateICFCProfile) : async Result.Result<(), Enums.Error> {
    assert Principal.toText(caller) == Environment.ICFC_BACKEND_CANISTER_ID;
    let _ = await userManager.updateICFCHash(dto);
    return #ok();
  };

  /* ----- Private Motoko Actor Functions ----- */

  private func isManagerCanister(principalId : Text) : Bool {
    let managerCanisterIds = userManager.getUniqueManagerCanisterIds();
    return Option.isSome(
      Array.find<Ids.PrincipalId>(
        managerCanisterIds,
        func(dataAdmin : Ids.PrincipalId) : Bool {
          dataAdmin == principalId;
        },
      )
    );
  };

  private func hasMembership(caller : Ids.PrincipalId) : async Bool {
    return true;
    let dto : UserQueries.GetICFCMembership = {
      principalId = caller;
    };
    let membershipResult = await userManager.getUserICFCMembership(dto);
    switch (membershipResult) {
      case (#ok(membership)) {
        if (membership == #Founding or membership == #Lifetime or membership == #Monthly or membership == #Seasonal) {
          return true;
        };
      };
      case (#err _) {};
    };
    return false;
  };

  // private func checkCanisterCycles() : async () {
  //   let root_canister = actor (CanisterIds.ICFC_SNS_ROOT_CANISTER_ID) : actor {
  //     get_sns_canisters_summary : (request : Root.GetSnsCanistersSummaryRequest) -> async Root.GetSnsCanistersSummaryResponse;
  //   };

  //   let summaryResult = await root_canister.get_sns_canisters_summary({
  //     update_canister_list = ?false;
  //   });
  //   let dappsMinusBackend = Array.filter<Root.CanisterSummary>(
  //     summaryResult.dapps,
  //     func(dapp : Root.CanisterSummary) {
  //       dapp.canister_id != ?Principal.fromText(CanisterIds.OPENFPL_BACKEND_CANISTER_ID);
  //     },
  //   );

  //   for (dappCanister in Iter.fromArray(dappsMinusBackend)) {
  //     switch (dappCanister.canister_id) {
  //       case (?foundCanisterId) {
  //         let ignoreCanister = Principal.toText(foundCanisterId) == "bboqb-jiaaa-aaaal-qb6ea-cai" or Principal.toText(foundCanisterId) == "bgpwv-eqaaa-aaaal-qb6eq-cai" or Principal.toText(foundCanisterId) == "hqfmc-cqaaa-aaaal-qitcq-cai";
  //         if (not ignoreCanister) {
  //           await queryAndTopupCanister(Principal.toText(foundCanisterId), 50_000_000_000_000, 25_000_000_000_000);
  //         };
  //       };
  //       case (null) {};
  //     };
  //   };

  //   //TODO: Remove after assigned to SNS
  //   await queryAndTopupCanister(Environment.FRONTEND_CANISTER_ID, 50_000_000_000_000, 25_000_000_000_000);
  //   await queryAndTopupCanister(CanisterIds.ICFC_DATA_CANISTER_ID, 50_000_000_000_000, 25_000_000_000_000);

  //   let managerCanisterIds = userManager.getUniqueManagerCanisterIds();
  //   for (canisterId in Iter.fromArray(managerCanisterIds)) {
  //     await queryAndTopupCanister(canisterId, 50_000_000_000_000, 25_000_000_000_000);
  //   };

  //   let leaderboardCanisterIds = leaderboardManager.getUniqueLeaderboardCanisterIds();
  //   for (canisterId in Iter.fromArray(leaderboardCanisterIds)) {
  //     await queryAndTopupCanister(canisterId, 50_000_000_000_000, 25_000_000_000_000);
  //   };

  //   await topupCanister(summaryResult.index, 50_000_000_000_000, 25_000_000_000_000);
  //   await topupCanister(summaryResult.governance, 50_000_000_000_000, 25_000_000_000_000);
  //   await topupCanister(summaryResult.ledger, 50_000_000_000_000, 25_000_000_000_000);
  //   await topupCanister(summaryResult.root, 50_000_000_000_000, 25_000_000_000_000);
  //   await topupCanister(summaryResult.swap, 5_000_000_000_000, 2_500_000_000_000);
  //   for (canisterId in Iter.fromArray(summaryResult.archives)) {
  //     await topupCanister(?canisterId, 5_000_000_000_000, 2_500_000_000_000);
  //   };

  //   //ignore Timer.setTimer<system>(#nanoseconds(Int.abs(86_400_000_000_000)), checkCanisterCycles);
  //   return;
  // };

  // private func topupCanister(canisterSummary : ?Root.CanisterSummary, topupTriggerAmount : Nat, topupAmount : Nat) : async () {
  //   switch (canisterSummary) {
  //     case (?foundCanister) {
  //       switch (foundCanister.status) {
  //         case (?foundStatus) {
  //           if (foundStatus.cycles < topupTriggerAmount) {
  //             switch (foundCanister.canister_id) {
  //               case (?foundCanisterId) {
  //                 let IC : Management.Management = actor (CanisterIds.Default);
  //                 let canisterActor = actor (Principal.toText(foundCanisterId)) : actor {};
  //                 await CanisterUtilities.topup_canister_(canisterActor, IC, topupAmount);

  //                 let topupsBuffer = Buffer.fromArray<Base.CanisterTopup>(topups);
  //                 topupsBuffer.add({
  //                   canisterId = Principal.toText(foundCanisterId);
  //                   cyclesAmount = topupAmount;
  //                   topupTime = Time.now();
  //                 });
  //                 topups := Buffer.toArray(topupsBuffer);
  //               };
  //               case (null) {};
  //             };
  //           };
  //         };
  //         case (null) {};
  //       };
  //     };
  //     case (null) {};
  //   };
  // };

  // private func queryAndTopupCanister(canisterId : Ids.CanisterId, cyclesTriggerAmount : Nat, topupAmount : Nat) : async () {
  //   let IC : Management.Management = actor (CanisterIds.Default);
  //   let canisterActor = actor (canisterId) : actor {};

  //   let canisterStatusResult = await CanisterUtilities.getCanisterStatus_(canisterActor, ?Principal.fromActor(Self), IC);

  //   switch (canisterStatusResult) {
  //     case (?canisterStatus) {

  //       if (canisterStatus.cycles < cyclesTriggerAmount) {
  //         await CanisterUtilities.topup_canister_(canisterActor, IC, topupAmount);
  //         let topupsBuffer = Buffer.fromArray<Base.CanisterTopup>(topups);
  //         topupsBuffer.add({
  //           canisterId = canisterId;
  //           cyclesAmount = topupAmount;
  //           topupTime = Time.now();
  //         });
  //         topups := Buffer.toArray(topupsBuffer);
  //       };
  //     };
  //     case (null) {};
  //   };
  // };

  public shared func getManagerCanisterIds() : async Result.Result<[Ids.CanisterId], Enums.Error> {
    return #ok(userManager.getUniqueManagerCanisterIds());
  };

  public shared func getLeaderboardCanisterIds() : async Result.Result<[Ids.CanisterId], Enums.Error> {
    return #ok(leaderboardManager.getStableUniqueLeaderboardCanisterIds());
  };

  public shared func getActiveLeaderboardCanisterId() : async Result.Result<Text, Enums.Error> {
    return #ok(leaderboardManager.getStableActiveCanisterId());
  };

  /* ----- Canister Lifecycle Management ----- */

  system func preupgrade() {
    getManagerStableVariables();
  };

  system func postupgrade() {
    setManagerStableVariables();
    ignore Timer.setTimer<system>(#nanoseconds(Int.abs(1)), postUpgradeCallback);
  };

  private func postUpgradeCallback() : async () {
    seasonManager.setStableAppStatus({
      onHold = true;
      version = "V.0.9.9";

    });
    await seasonManager.updateDataHash("app_status");

  };

  /* ----- Canister Update Functions ----- */

  private func updateManagerCanisterWasms() : async () {
    let managerCanisterIds = userManager.getUniqueManagerCanisterIds();
    let IC : Management.Management = actor (CanisterIds.Default);
    for (canisterId in Iter.fromArray(managerCanisterIds)) {
      await IC.stop_canister({ canister_id = Principal.fromText(canisterId) });
      let oldManagement = actor (canisterId) : actor {};
      let _ = await (system ManagerCanister._ManagerCanister)(#upgrade oldManagement)();
      await IC.start_canister({ canister_id = Principal.fromText(canisterId) });
    };
  };

  private func updateLeaderboardCanisterWasms() : async () {
    let leaderboardCanisterIds = leaderboardManager.getUniqueLeaderboardCanisterIds();
    let IC : Management.Management = actor (CanisterIds.Default);
    for (canisterId in Iter.fromArray(leaderboardCanisterIds)) {
      await IC.stop_canister({ canister_id = Principal.fromText(canisterId) });
      let oldLeaderboard = actor (canisterId) : actor {};
      let _ = await (system LeaderboardCanister._LeaderboardCanister)(#upgrade oldLeaderboard)();
      await IC.start_canister({ canister_id = Principal.fromText(canisterId) });
    };
  };

  private func getManagerStableVariables() {
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

    stable_data_hashes := seasonManager.getStableDataHashes();
    //stable_player_snapshots := seasonManager.getStablePlayersSnapshots();

    stable_manager_canister_ids := userManager.getStableManagerCanisterIds();
    stable_usernames := userManager.getStableUsernames();
    stable_unique_manager_canister_ids := userManager.getStableUniqueManagerCanisterIds();
    stable_total_managers := userManager.getStableTotalManagers();
    stable_active_manager_canister_id := userManager.getStableActiveManagerCanisterId();
    stable_user_icfc_links := userManager.getStableUserICFCLinks();
  };

  private func setManagerStableVariables() {
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
    //seasonManager.setStablePlayersSnapshots(stable_player_snapshots);

    userManager.setStableManagerCanisterIds(stable_manager_canister_ids);
    userManager.setStableUsernames(stable_usernames);
    userManager.setStableUniqueManagerCanisterIds(stable_unique_manager_canister_ids);
    userManager.setStableTotalManagers(stable_total_managers);
    userManager.setStableActiveManagerCanisterId(stable_active_manager_canister_id);
    userManager.setStableUserICFCLinks(stable_user_icfc_links);
  };

  /* ----- WWL Canister Management ----- */
  public shared ({ caller }) func getProjectCanisters() : async Result.Result<CanisterQueries.ProjectCanisters, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    assert Principal.toText(caller) == CanisterIds.WATERWAY_LABS_BACKEND_CANISTER_ID;

    var projectCanisters : [CanisterQueries.Canister] = [];

    let managerCanisterIds = userManager.getUniqueManagerCanisterIds();
    for (canisterId in Iter.fromArray(managerCanisterIds)) {
      let manager_dto : CanisterQueries.Canister = {
        canisterId = canisterId;
        canisterType = #Dynamic;
        canisterName = "OpenFPL Manager Canister";
        app = #OpenFPL;
      };
      projectCanisters := Array.append<CanisterQueries.Canister>(projectCanisters, [manager_dto]);
    };

    let leaderboardCanisterIds = leaderboardManager.getUniqueLeaderboardCanisterIds();
    for (canisterId in Iter.fromArray(leaderboardCanisterIds)) {
      let leaderboard_dto : CanisterQueries.Canister = {
        canisterId = canisterId;
        canisterType = #Dynamic;
        canisterName = "OpenFPL Leaderboard Canister";
        app = #OpenFPL;
      };
      projectCanisters := Array.append<CanisterQueries.Canister>(projectCanisters, [leaderboard_dto]);
    };

    var backend_dto : CanisterQueries.Canister = {
      canisterId = CanisterIds.OPENFPL_BACKEND_CANISTER_ID;
      canisterType = #Static;
      canisterName = "OpenFPL Backend Canister";
      app = #OpenFPL;
    };
    projectCanisters := Array.append<CanisterQueries.Canister>(projectCanisters, [backend_dto]);

    let frontend_dto : CanisterQueries.Canister = {
      canisterId = Environment.OpenFPL_FRONTEND_CANISTER_ID;
      canisterType = #Static;
      canisterName = "OpenFPL Frontend Canister";
      app = #OpenFPL;
    };
    projectCanisters := Array.append<CanisterQueries.Canister>(projectCanisters, [frontend_dto]);

    let res : CanisterQueries.ProjectCanisters = {
      entries = projectCanisters;
    };
    return #ok(res);
  };

  public shared ({ caller }) func addController(dto : CanisterCommands.AddController) : async Result.Result<(), Enums.Error> {
    assert not Principal.isAnonymous(caller);
    assert Principal.toText(caller) == CanisterIds.WATERWAY_LABS_BACKEND_CANISTER_ID;
    let result = await canisterManager.addController(dto);
    return result;
  };
  public shared ({ caller }) func removeController(dto : CanisterCommands.RemoveController) : async Result.Result<(), Enums.Error> {
    assert not Principal.isAnonymous(caller);
    assert Principal.toText(caller) == CanisterIds.WATERWAY_LABS_BACKEND_CANISTER_ID;
    let result = await canisterManager.removeController(dto);
    return result;
  };
};
