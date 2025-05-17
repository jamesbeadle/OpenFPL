
/* ----- Mops Packages ----- */

import Array "mo:base/Array";
import Bool "mo:base/Bool";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import Nat64 "mo:base/Nat64";
import Nat "mo:base/Nat";
import Option "mo:base/Option";
import Order "mo:base/Order";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Text "mo:base/Text";
import Timer "mo:base/Timer";

import AppEnums "mo:waterway-mops/product/wwl/enums";
import BaseDefinitions "mo:waterway-mops/base/definitions";
import BaseEnums "mo:waterway-mops/base/enums";
import BaseTypes "mo:waterway-mops/base/types";
import CanisterIds "mo:waterway-mops/product/wwl/canister-ids";
import Countries "mo:waterway-mops/base/countries";
import DateTimeUtilities "mo:waterway-mops/base/utilities/date-time-utilities";
import Environment "Environment";
import FootballDefinitions "mo:waterway-mops/domain/football/definitions";
import FootballIds "mo:waterway-mops/domain/football/ids";
import Ids "mo:waterway-mops/base/ids";
import InterAppCallCommands "mo:waterway-mops/product/icfc/inter-app-call-commands";
import Management "mo:waterway-mops/base/def/management";

import ICFCQueries "mo:waterway-mops/product/icfc/queries";
import BaseQueries "mo:waterway-mops/base/queries";
import PlayerQueries "mo:waterway-mops/product/icfc/data-canister-queries/player-queries";
import LeagueNotificationCommands "mo:waterway-mops/product/icfc/data-canister-notification-commands/league-notification-commands";
import PlayerNotificationCommands "mo:waterway-mops/product/icfc/data-canister-notification-commands/player-notification-commands";



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
import CanisterCommands "mo:waterway-mops/product/wwl/canister-management/commands";
import CanisterQueries "mo:waterway-mops/product/wwl/canister-management/queries";
import CanisterManager "mo:waterway-mops/product/wwl/canister-management/manager";
import FixtureQueries "mo:waterway-mops/product/icfc/data-canister-queries/fixture-queries";
import LeagueQueries "mo:waterway-mops/product/icfc/data-canister-queries/league-queries";
import SeasonQueries "mo:waterway-mops/product/icfc/data-canister-queries/season-queries";
import ClubQueries "mo:waterway-mops/product/icfc/data-canister-queries/club-queries";
import MvpQueries "queries/mvp_queries";

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
  private stable var stable_leaderboard_payouts : [AppTypes.LeaderboardPayout] = [];

  //Season Manager stable variables
  private stable var stable_app_status : BaseTypes.AppStatus = {
    onHold = false;
    version = "2.1.0";
  };

  private stable var stable_league_gameweek_statuses : [AppTypes.LeagueGameweekStatus] = [];
  private stable var stable_league_month_statuses : [AppTypes.LeagueMonthStatus] = [];
  private stable var stable_league_season_statuses : [AppTypes.LeagueSeasonStatus] = [];

  private stable var stable_data_hashes : [BaseTypes.DataHash] = [];

  private stable var stable_player_snapshots : [(FootballIds.SeasonId, [(FootballDefinitions.GameweekNumber, [AppTypes.SnapshotPlayer])])] = [];

  //User Manager stable variables

  private stable var stable_manager_canister_ids : [(Ids.PrincipalId, Ids.CanisterId)] = [];
  private stable var stable_usernames : [(Ids.PrincipalId, Text)] = [];
  private stable var stable_unique_manager_canister_ids : [Ids.CanisterId] = [];
  private stable var stable_total_managers : Nat = 0;
  private stable var stable_active_manager_canister_id : Ids.CanisterId = "";
  private stable var topups : [BaseTypes.CanisterTopup] = [];
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

  public shared ({ caller }) func getAppStatus() : async Result.Result<BaseQueries.AppStatus, BaseEnums.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert await hasMembership(principalId);
    return seasonManager.getAppStatus();
  };

  public shared ({ caller }) func getTotalManagers() : async Result.Result<Nat, BaseEnums.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert await hasMembership(principalId);
    return userManager.getTotalManagers();
  };

  public shared ({ caller }) func getActiveRewardRates() : async Result.Result<AppQueries.RewardRates, BaseEnums.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert await hasMembership(principalId);
    let rewardRates = leaderboardManager.getActiveRewardRates();
    return #ok(rewardRates);
  };

  /* ----- Data Hash Queries ----- */

  public shared ({ caller }) func getDataHashes() : async Result.Result<[BaseQueries.DataHash], BaseEnums.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert await hasMembership(principalId);
    return seasonManager.getDataHashes();
  };

  public shared ({ caller }) func getICFCDataHash() : async Result.Result<Text, BaseEnums.Error> {
    assert not Principal.isAnonymous(caller);
    let dto : UserQueries.GetICFCDataHash = {
      principalId = Principal.toText(caller);
    };
    return userManager.getICFCDataHash(dto);
  };

  /* ----- User Queries ----- */

  public shared ({ caller }) func getProfile() : async Result.Result<UserQueries.CombinedProfile, BaseEnums.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert await hasMembership(principalId);
    let dto : UserQueries.GetProfile = {
      principalId = Principal.toText(caller);
    };
    return await userManager.getCombinedProfile(dto);
  };

  public shared ({ caller }) func getICFCLinkStatus() : async Result.Result<AppEnums.LinkStatus, BaseEnums.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    return await userManager.getUserICFCLinkStatus(principalId);
  };

  public shared ({ caller }) func getTeamSelection() : async Result.Result<UserQueries.TeamSetup, BaseEnums.Error> {
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

  public shared ({ caller }) func getManager(dto : UserQueries.GetManager) : async Result.Result<UserQueries.Manager, BaseEnums.Error> {
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

  public shared ({ caller }) func getManagerByUsername(dto : UserQueries.GetManagerByUsername) : async Result.Result<UserQueries.Manager, BaseEnums.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert await hasMembership(principalId);
    return await userManager.getManagerByUsername(dto.username);
  };

  public shared ({ caller }) func getFantasyTeamSnapshot(dto : UserQueries.GetFantasyTeamSnapshot) : async Result.Result<UserQueries.FantasyTeamSnapshot, BaseEnums.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert await hasMembership(principalId);
    return await userManager.getFantasyTeamSnapshot(dto);
  };

  /* ----- User Commands ----- */

  public shared ({ caller }) func linkICFCProfile() : async Result.Result<(), BaseEnums.Error> {
    assert not Principal.isAnonymous(caller);
    let principalIdText = Principal.toText(caller);

    let dto : ICFCCommands.VerifyICFCProfile = {
      principalId = principalIdText;
    };
    return await userManager.verifyICFCLink(dto);
  };

  public shared ({ caller }) func updateFavouriteClub(dto : UserCommands.SetFavouriteClub) : async Result.Result<(), BaseEnums.Error> {
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

  public shared ({ caller }) func saveTeamSelection(dto : UserCommands.SaveFantasyTeam) : async Result.Result<(), BaseEnums.Error> {
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

  public shared ({ caller }) func saveBonusSelection(dto : UserCommands.PlayBonus) : async Result.Result<(), BaseEnums.Error> {
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

  public shared ({ caller }) func getWeeklyLeaderboard(dto : LeaderboardQueries.GetWeeklyLeaderboard) : async Result.Result<LeaderboardQueries.WeeklyLeaderboard, BaseEnums.Error> {
    assert not Principal.isAnonymous(caller);
    assert await hasMembership(Principal.toText(caller));
    return await leaderboardManager.getWeeklyLeaderboard(dto);
  };

  public shared ({ caller }) func getMonthlyLeaderboard(dto : LeaderboardQueries.GetMonthlyLeaderboard) : async Result.Result<LeaderboardQueries.MonthlyLeaderboard, BaseEnums.Error> {
    assert not Principal.isAnonymous(caller);
    assert await hasMembership(Principal.toText(caller));
    return await leaderboardManager.getMonthlyLeaderboard(dto);
  };

  public shared ({ caller }) func getSeasonLeaderboard(dto : LeaderboardQueries.GetSeasonLeaderboard) : async Result.Result<LeaderboardQueries.SeasonLeaderboard, BaseEnums.Error> {
    assert not Principal.isAnonymous(caller);
    assert await hasMembership(Principal.toText(caller));
    return await leaderboardManager.getSeasonLeaderboard(dto);
  };

  public shared ({ caller }) func getMostValuableTeamLeaderboard(dto : LeaderboardQueries.GetMostValuableTeamLeaderboard) : async Result.Result<LeaderboardQueries.MostValuableTeamLeaderboard, BaseEnums.Error> {
    assert not Principal.isAnonymous(caller);
    assert await hasMembership(Principal.toText(caller));
    return await leaderboardManager.getMostValuableTeamLeaderboard(dto);
  };

  public shared ({ caller }) func getMostValuableGameweekPlayers(dto : MvpQueries.GetMostValuableGameweekPlayers) : async Result.Result<MvpQueries.MostValuableGameweekPlayers, BaseEnums.Error> {
    assert not Principal.isAnonymous(caller);
    assert await hasMembership(Principal.toText(caller));
    return #err(#NotFound); // TODO
  };

  public shared ({ caller }) func getAllTimeHighScores(dto : AppQueries.GetAllTimeHighScores) : async Result.Result<AppQueries.AllTimeHighScores, BaseEnums.Error> {
    assert not Principal.isAnonymous(caller);
    assert await hasMembership(Principal.toText(caller));
    return #err(#NotFound); // TODO
  };

  public shared ({ caller }) func getLeagueStatus() : async Result.Result<LeagueQueries.LeagueStatus, BaseEnums.Error> {
    assert not Principal.isAnonymous(caller);
    assert await hasMembership(Principal.toText(caller));
    return await dataManager.getLeagueStatus({
      leagueId = Environment.LEAGUE_ID;
    });
  };

  public shared ({ caller }) func getCountries() : async Result.Result<BaseQueries.Countries, BaseEnums.Error> {
    assert not Principal.isAnonymous(caller);
    assert await hasMembership(Principal.toText(caller));
    return #ok({
      countries = Countries.countries;
    });
  };

  public shared ({ caller }) func getSeasons(dto : SeasonQueries.GetSeasons) : async Result.Result<SeasonQueries.Seasons, BaseEnums.Error> {
    assert not Principal.isAnonymous(caller);
    assert await hasMembership(Principal.toText(caller));
    return await dataManager.getSeasons(dto);
  };

  public shared ({ caller }) func getClubs(dto : ClubQueries.GetClubs) : async Result.Result<ClubQueries.Clubs, BaseEnums.Error> {
    assert not Principal.isAnonymous(caller);
    assert await hasMembership(Principal.toText(caller));
    return await dataManager.getClubs(dto);
  };

  public shared ({ caller }) func getPlayers(dto : PlayerQueries.GetPlayers) : async Result.Result<PlayerQueries.Players, BaseEnums.Error> {
    assert not Principal.isAnonymous(caller);
    let validMembership = await hasMembership(Principal.toText(caller));
    let managerCanister = isManagerCanister(Principal.toText(caller));

    assert validMembership or managerCanister;
    return await dataManager.getPlayers(dto);
  };

  public shared ({ caller }) func getPlayerEvents(dto : PlayerQueries.GetPlayerDetailsForGameweek) : async Result.Result<PlayerQueries.PlayerDetailsForGameweek, BaseEnums.Error> {
    assert not Principal.isAnonymous(caller);
    assert await hasMembership(Principal.toText(caller));
    return await dataManager.getPlayerDetailsForGameweek(dto);
  };

  public shared ({ caller }) func getFixtures(dto : FixtureQueries.GetFixtures) : async Result.Result<FixtureQueries.Fixtures, BaseEnums.Error> {
    assert not Principal.isAnonymous(caller);
    assert await hasMembership(Principal.toText(caller));
    return await dataManager.getFixtures(dto : FixtureQueries.GetFixtures);
  };

  public shared ({ caller }) func getPlayersSnapshot(dto : AppQueries.GetPlayersSnapshot) : async Result.Result<AppQueries.PlayersSnapshot, BaseEnums.Error> {
    assert not Principal.isAnonymous(caller);

    let validMembership = await hasMembership(Principal.toText(caller));
    let managerCanister = isManagerCanister(Principal.toText(caller));

    assert validMembership or managerCanister;

    return await seasonManager.getPlayersSnapshot(dto);
  };

  public shared ({ caller }) func getPlayersMap(dto : PlayerQueries.GetPlayersMap) : async Result.Result<PlayerQueries.PlayersMap, BaseEnums.Error> {
    assert isManagerCanister(Principal.toText(caller));
    return await dataManager.getPlayersMap(dto);
  };

  public shared ({ caller }) func getPlayerDetails(dto : PlayerQueries.GetPlayerDetails) : async Result.Result<PlayerQueries.PlayerDetails, BaseEnums.Error> {
    assert not Principal.isAnonymous(caller);
    return await dataManager.getPlayerDetails(dto);
  };

  // Temp Test function
  public shared func getAllUserICFCLinks() : async [(Ids.PrincipalId, AppTypes.ICFCLink)] {
    return await userManager.getAllUserICFCLinks();
  };

  /* ----- Football God Callback Canister Interface ----- */

  public shared ({ caller }) func addInitialFixtureNotification(dto : LeagueNotificationCommands.AddInitialFixtureNotification) : async Result.Result<(), BaseEnums.Error> {
    assert Principal.toText(caller) == CanisterIds.ICFC_DATA_CANISTER_ID;
    await seasonManager.resetAllDataHashes();
    await userManager.resetFantasyTeams();
    return #ok();
  };

  public shared ({ caller }) func beginGameweekNotification(dto : LeagueNotificationCommands.BeginGameweekNotification) : async Result.Result<(), BaseEnums.Error> {
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

  private func checkMonthRollover(dto : LeagueNotificationCommands.BeginGameweekNotification, leagueStatus : LeagueQueries.LeagueStatus) : async () {

    let priorGameweek : FootballDefinitions.GameweekNumber = leagueStatus.activeGameweek - 1;
    let fixtures = await dataManager.getFixtures({
      leagueId = dto.leagueId;
      seasonId = dto.seasonId;
    });

    switch (fixtures) {
      case (#ok foundFixtures) {

        let gameweekFixtures = Array.filter<FixtureQueries.Fixture>(
          foundFixtures.fixtures,
          func(entry : FixtureQueries.Fixture) {
            entry.gameweek == priorGameweek;
          },
        );

        let sortedFixtures = Array.sort<FixtureQueries.Fixture>(
          gameweekFixtures,
          func(entry1 : FixtureQueries.Fixture, entry2 : FixtureQueries.Fixture) : Order.Order {
            if (entry1.kickOff > entry2.kickOff) { return #less };
            if (entry1.kickOff == entry2.kickOff) { return #equal };
            return #greater;
          },
        );

        if (Array.size(sortedFixtures) > 0) {
          let firstGameweekFixture : FixtureQueries.Fixture = sortedFixtures[0];
          var priorGameweekMonth : BaseDefinitions.CalendarMonth = DateTimeUtilities.unixTimeToMonth(firstGameweekFixture.kickOff);
          if (leagueStatus.activeMonth > priorGameweekMonth) {
            await userManager.resetBonuses();
          };
        };
      };
      case (#err _) {};
    };
  };

  public shared ({ caller }) func completeGameweekNotification(dto : LeagueNotificationCommands.CompleteGameweekNotification) : async Result.Result<(), BaseEnums.Error> {
    assert Principal.toText(caller) == CanisterIds.ICFC_DATA_CANISTER_ID;
    let managerCanisterIds = userManager.getUniqueManagerCanisterIds();
    let _ = leaderboardManager.calculateLeaderboards(dto.seasonId, dto.gameweek, 0, managerCanisterIds);

    let icfc_backend_canister = actor (CanisterIds.ICFC_BACKEND_CANISTER_ID) : actor {
      requestLeaderboardPayout : (dto : InterAppCallCommands.LeaderboardPayoutRequest) -> async Result.Result<(), BaseEnums.Error>;
    };

    let weeklyLeaderboardResult = await leaderboardManager.getWeeklyLeaderboard({
      seasonId = dto.seasonId;
      gameweek = dto.gameweek;
      page = 0;
      searchTerm = "";
    });

    switch (weeklyLeaderboardResult) {
      case (#ok(foundLeaderboard)) {
        var leaderboard : [InterAppCallCommands.LeaderboardEntry] = [];

        for (entry in Iter.fromArray(foundLeaderboard.entries)) {
          let leaderboardEntry : InterAppCallCommands.LeaderboardEntry = {
            appPrincipalId = entry.principalId;
            rewardAmount = entry.rewardAmount;
            payoutStatus = #Pending;
            payoutDate = null;
          };
          leaderboard := Array.append<InterAppCallCommands.LeaderboardEntry>(leaderboard, [leaderboardEntry]);
        };

        let payoutRequest : InterAppCallCommands.LeaderboardPayoutRequest = {
          app = #OpenFPL;
          leaderboard = leaderboard;
          gameweek = dto.gameweek;
          seasonId = dto.seasonId;
        };

        let sendReq = await icfc_backend_canister.requestLeaderboardPayout(payoutRequest);
        switch (sendReq) {
          case (#err(error)) {
            return #err(error);
          };
          case (#ok(_)) {};
        };

        stable_leaderboard_payouts := Array.append<AppTypes.LeaderboardPayout>(
          stable_leaderboard_payouts,
          [{
            seasonId = dto.seasonId;
            gameweek = dto.gameweek;
            leaderboard = leaderboard;
            totalEntries = Array.size(leaderboard);
            totalEntriesPaid = 0;
          }],
        );
        return #ok();
      };
      case (#err(error)) {
        return #err(error);
      };
    };

  };

  /* ----- ICFC Callback for paid LeaderBoard ----- */
  public shared ({ caller }) func leaderboardPaid(dto : InterAppCallCommands.CompleteLeaderboardPayout) : async Result.Result<(), BaseEnums.Error> {
    assert Principal.toText(caller) == CanisterIds.ICFC_BACKEND_CANISTER_ID;

    let foundPayoutRequest = Array.find<AppTypes.LeaderboardPayout>(
      stable_leaderboard_payouts,
      func(entry : AppTypes.LeaderboardPayout) : Bool {
        entry.seasonId == dto.seasonId and entry.gameweek == dto.gameweek;
      },
    );
    switch (foundPayoutRequest) {
      case (null) {
        return #err(#NotFound);
      };
      case (foundPayoutRequest) {
        stable_leaderboard_payouts := Array.map(
          stable_leaderboard_payouts,
          func(entry : AppTypes.LeaderboardPayout) : AppTypes.LeaderboardPayout {
            if (entry.seasonId == dto.seasonId and entry.gameweek == dto.gameweek) {
              return {
                seasonId = entry.seasonId;
                gameweek = entry.gameweek;
                leaderboard = dto.leaderboard;
                totalEntries = Array.size(dto.leaderboard);
                totalEntriesPaid = Array.size(
                  Array.filter<InterAppCallCommands.LeaderboardEntry>(
                    dto.leaderboard,
                    func(entry : InterAppCallCommands.LeaderboardEntry) : Bool {
                      return entry.payoutStatus == #Paid;
                    },
                  )
                );
              };
            };
            return entry;
          },
        );
      };
    };

    return #ok();
  };

  public shared ({ caller }) func finaliseFixtureNotification(dto : LeagueNotificationCommands.CompleteFixtureNotification) : async Result.Result<(), BaseEnums.Error> {
    assert Principal.toText(caller) == CanisterIds.ICFC_DATA_CANISTER_ID;

    let fixtures = await getFixtures({
      leagueId = Environment.LEAGUE_ID;
      seasonId = dto.seasonId;
    });

    switch (fixtures) {
      case (#ok foundFixtures) {

        let fixture = Array.find<FixtureQueries.Fixture>(
          foundFixtures.fixtures,
          func(entry : FixtureQueries.Fixture) : Bool {
            entry.id == dto.fixtureId;
          },
        );

        switch (fixture) {
          case (?foundFixture) {

            let fixtureGameweekFixtures = Array.filter<FixtureQueries.Fixture>(
              foundFixtures.fixtures,
              func(entry : FixtureQueries.Fixture) {
                entry.gameweek == foundFixture.gameweek;
              },
            );

            let sortedFixtures = Array.sort<FixtureQueries.Fixture>(
              fixtureGameweekFixtures,
              func(entry1 : FixtureQueries.Fixture, entry2 : FixtureQueries.Fixture) : Order.Order {
                if (entry1.kickOff > entry2.kickOff) { return #less };
                if (entry1.kickOff == entry2.kickOff) { return #equal };
                return #greater;
              },
            );

            if (Array.size(sortedFixtures) > 0) {
              let firstGameweekFixture : FixtureQueries.Fixture = sortedFixtures[0];
              var fixtureMonth : BaseDefinitions.CalendarMonth = DateTimeUtilities.unixTimeToMonth(firstGameweekFixture.kickOff);
              let _ = await userManager.calculateFantasyTeamScores(dto.seasonId, foundFixture.gameweek, fixtureMonth);
              await seasonManager.updateDataHash("league_status");
              return #ok();
            };

            return #err(#NotFound);

          };
          case (null) {
            return #err(#NotFound);
          };
        };

      };
      case (#err error) {
        return #err(error);
      };
    };

  };

  public shared ({ caller }) func completeSeasonNotification(dto : LeagueNotificationCommands.CompleteSeasonNotification) : async Result.Result<(), BaseEnums.Error> {
    assert Principal.toText(caller) == CanisterIds.ICFC_DATA_CANISTER_ID;

    //TODO

    return #ok();
  };

  public shared ({ caller }) func revaluePlayerUpNotification(dto : PlayerNotificationCommands.PlayerChangeNotification) : async Result.Result<(), BaseEnums.Error> {

    //recaluclate any manager total team values

    return #err(#NotFound);
  };

  public shared ({ caller }) func revaluePlayerDownNotification(dto : PlayerNotificationCommands.PlayerChangeNotification) : async Result.Result<(), BaseEnums.Error> {

    //recaluclate any manager total team values

    return #err(#NotFound);
  };

  public shared ({ caller }) func loanPlayerNotification(dto : PlayerNotificationCommands.PlayerChangeNotification) : async Result.Result<(), BaseEnums.Error> {
    assert Principal.toText(caller) == CanisterIds.ICFC_DATA_CANISTER_ID;
    assert dto.leagueId == Environment.LEAGUE_ID;
    await userManager.removePlayerFromTeams(Environment.LEAGUE_ID, dto.playerId, CanisterIds.OPENFPL_BACKEND_CANISTER_ID);
    await seasonManager.updateDataHash("players");
    return #ok();
  };

  public shared ({ caller }) func recallPlayerNotification(dto : PlayerNotificationCommands.PlayerChangeNotification) : async Result.Result<(), BaseEnums.Error> {
    return #err(#NotFound);
  };

  public shared ({ caller }) func expireLoanNotification(dto : PlayerNotificationCommands.PlayerChangeNotification) : async Result.Result<(), BaseEnums.Error> {
    assert Principal.toText(caller) == CanisterIds.ICFC_DATA_CANISTER_ID;
    assert dto.leagueId == Environment.LEAGUE_ID;

    // TODO
    //if a player has been removed from a team in the premier league because they were on loan here but the parent club is outside the parent league
    //remove player from fantasy teams

    return #ok();
  };

  public shared ({ caller }) func transferPlayerNotification(dto : PlayerNotificationCommands.PlayerChangeNotification) : async Result.Result<(), BaseEnums.Error> {
    assert Principal.toText(caller) == CanisterIds.ICFC_DATA_CANISTER_ID;
    await userManager.removePlayerFromTeams(Environment.LEAGUE_ID, dto.playerId, CanisterIds.OPENFPL_BACKEND_CANISTER_ID);
    await seasonManager.updateDataHash("players");
    return #ok();
  };

  public shared ({ caller }) func setFreeAgentNotification(dto : PlayerNotificationCommands.PlayerChangeNotification) : async Result.Result<(), BaseEnums.Error> {

    //TODO - This player is a free agent so remove from everyones team

    return #err(#NotFound);
  };

  public shared ({ caller }) func retirePlayerNotification(dto : PlayerNotificationCommands.PlayerChangeNotification) : async Result.Result<(), BaseEnums.Error> {
    assert Principal.toText(caller) == CanisterIds.ICFC_DATA_CANISTER_ID;

    //TODO - This player has retired so remove from everyones team

    return #ok();
  };

  public shared ({ caller }) func changePlayerPositionNotification(dto : PlayerNotificationCommands.PlayerChangeNotification) : async Result.Result<(), BaseEnums.Error> {
    assert Principal.toText(caller) == CanisterIds.ICFC_DATA_CANISTER_ID;
    await userManager.removePlayerFromTeams(Environment.LEAGUE_ID, dto.playerId, CanisterIds.OPENFPL_BACKEND_CANISTER_ID);
    return #ok();
  };

  /* ----- ICFC Canister Callback Functions ----- */

  public shared ({ caller }) func notifyAppLink(dto : ICFCCommands.NotifyAppofLink) : async Result.Result<(), BaseEnums.Error> {
    assert Principal.toText(caller) == Environment.ICFC_BACKEND_CANISTER_ID;
    let _ = await userManager.createICFCLink(dto);
    return #ok();
  };

  public shared ({ caller }) func notifyAppRemoveLink(dto : ICFCCommands.NotifyAppofRemoveLink) : async Result.Result<(), BaseEnums.Error> {
    assert Principal.toText(caller) == Environment.ICFC_BACKEND_CANISTER_ID;
    let _ = await userManager.removeICFCLink(dto);
    return #ok();
  };

  public shared ({ caller }) func noitifyAppofICFCHashUpdate(dto : ICFCCommands.UpdateICFCProfile) : async Result.Result<(), BaseEnums.Error> {
    assert Principal.toText(caller) == Environment.ICFC_BACKEND_CANISTER_ID;
    let _ = await userManager.updateICFCHash(dto);
    return #ok();
  };

  public shared ({ caller }) func getICFCProfileLinks(_ : ICFCQueries.GetICFCLinks) : async Result.Result<[ICFCQueries.ICFCLinks], BaseEnums.Error> {
    assert Principal.toText(caller) == Environment.ICFC_BACKEND_CANISTER_ID;
    return #ok(userManager.getICFCProfileLinks());
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

  public shared func getManagerCanisterIds() : async Result.Result<[Ids.CanisterId], BaseEnums.Error> {
    return #ok(userManager.getUniqueManagerCanisterIds());
  };

  public shared func getLeaderboardCanisterIds() : async Result.Result<[Ids.CanisterId], BaseEnums.Error> {
    return #ok(leaderboardManager.getStableUniqueLeaderboardCanisterIds());
  };

  public shared func getActiveLeaderboardCanisterId() : async Result.Result<Text, BaseEnums.Error> {
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
      onHold = false;
      version = "V.1.0.0";
    });
    //await seasonManager.updateDataHash("app_status");
    //await updateManagerCanisterWasms();
    //await updateLeaderboardCanisterWasms();
    //await seasonManager.resetAllDataHashes();
    //await userManager.resetWeeklyTransfers();
    //await userManager.resetBonuses();  
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
    stable_player_snapshots := seasonManager.getStablePlayersSnapshots();

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
    seasonManager.setStablePlayersSnapshots(stable_player_snapshots);

    userManager.setStableManagerCanisterIds(stable_manager_canister_ids);
    userManager.setStableUsernames(stable_usernames);
    userManager.setStableUniqueManagerCanisterIds(stable_unique_manager_canister_ids);
    userManager.setStableTotalManagers(stable_total_managers);
    userManager.setStableActiveManagerCanisterId(stable_active_manager_canister_id);
    userManager.setStableUserICFCLinks(stable_user_icfc_links);
  };

  /* ----- WWL Canister Management ----- */
  public shared ({ caller }) func getProjectCanisters() : async Result.Result<CanisterQueries.ProjectCanisters, BaseEnums.Error> {
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

  public shared ({ caller }) func addController(dto : CanisterCommands.AddController) : async Result.Result<(), BaseEnums.Error> {
    assert not Principal.isAnonymous(caller);
    assert Principal.toText(caller) == CanisterIds.WATERWAY_LABS_BACKEND_CANISTER_ID;
    let result = await canisterManager.addController(dto);
    return result;
  };
  public shared ({ caller }) func removeController(dto : CanisterCommands.RemoveController) : async Result.Result<(), BaseEnums.Error> {
    assert not Principal.isAnonymous(caller);
    assert Principal.toText(caller) == CanisterIds.WATERWAY_LABS_BACKEND_CANISTER_ID;
    let result = await canisterManager.removeController(dto);
    return result;
  };


};
