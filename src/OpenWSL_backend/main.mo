  import Array "mo:base/Array";
  import Bool "mo:base/Bool";
  import Buffer "mo:base/Buffer";
  import Int "mo:base/Int";
  import Iter "mo:base/Iter";
  import Principal "mo:base/Principal";
  import Result "mo:base/Result";
  import Time "mo:base/Time";
  import Timer "mo:base/Timer";
  import Nat64 "mo:base/Nat64";
  import Nat "mo:base/Nat";
  import Option "mo:base/Option";
  import List "mo:base/List";
  import Order "mo:base/Order";
  import Debug "mo:base/Debug";

  import Base "../shared/types/base_types";
  import FootballTypes "../shared/types/football_types";
  import T "../shared/types/app_types";
  import DTOs "../shared/dtos/DTOs";
  import RequestDTOs "../shared/dtos/request_DTOs";
  import Countries "../shared/Countries";
  import Utilities "../shared/utils/utilities";

  import Management "../shared/utils/Management";
  import ManagerCanister "../shared/canister_definitions/manager-canister";
  import DataManager "../shared/managers/data-manager";
  import LeaderboardManager "../shared/managers/leaderboard-manager";
  import UserManager "../shared/managers/user-manager";
  import SeasonManager "../shared/managers/season-manager";
  import CyclesDispenser "../shared/cycles-dispenser";
  import Environment "./Environment";
  import NetworkEnvironmentVariables "../shared/network_environment_variables";

  actor Self {
    
    private let userManager = UserManager.UserManager(Environment.BACKEND_CANISTER_ID, Environment.NUM_OF_GAMEWEEKS);
    private let dataManager = DataManager.DataManager();
    private let seasonManager = SeasonManager.SeasonManager(Environment.NUM_OF_GAMEWEEKS);
    private let leaderboardManager = LeaderboardManager.LeaderboardManager(Environment.BACKEND_CANISTER_ID, Environment.NUM_OF_GAMEWEEKS, Environment.NUM_OF_MONTHS);
    private let cyclesDispenser = CyclesDispenser.CyclesDispenser();
    
    private func isManagerCanister(principalId: Text) : Bool {
      let managerCanisterIds = userManager.getUniqueManagerCanisterIds();
      return Option.isSome(Array.find<Base.PrincipalId>(managerCanisterIds, func(dataAdmin: Base.PrincipalId) : Bool{
        dataAdmin == principalId;
      }));
    }; 

    //Manager calls

    public shared ({ caller }) func getProfile() : async Result.Result<DTOs.ProfileDTO, T.Error> {
      assert not Principal.isAnonymous(caller);
      return await userManager.getProfile({ principalId = Principal.toText(caller) });
    };

    public shared ({ caller }) func getCurrentTeam() : async Result.Result<DTOs.PickTeamDTO, T.Error> {
      assert not Principal.isAnonymous(caller);
      let systemStateResult = seasonManager.getSystemState();
      switch(systemStateResult){
        case (#ok systemState){       
          return await userManager.getCurrentTeam(Principal.toText(caller), systemState.pickTeamSeasonId, systemState.pickTeamGameweek);
        };
        case (#err error){
          return #err(error);
        }
      }
    };

    public shared func getManager(dto: RequestDTOs.RequestManagerDTO) : async Result.Result<DTOs.ManagerDTO, T.Error> {
      
      /*
      let weeklyLeaderboardEntry = await leaderboardManager.getWeeklyLeaderboardEntry(dto.managerId, dto.seasonId, dto.gameweek);
      let monthlyLeaderboardEntry = await leaderboardManager.getMonthlyLeaderboardEntry(dto.managerId, dto.seasonId, dto.month, dto.clubId);
      let seasonLeaderboardEntry = await leaderboardManager.getSeasonLeaderboardEntry(dto.managerId, dto.seasonId);
      return await userManager.getManager(dto, weeklyLeaderboardEntry, monthlyLeaderboardEntry, seasonLeaderboardEntry);
      */
      return await userManager.getManager(dto, null, null, null);
    };

    public shared func getFantasyTeamSnapshot(dto: DTOs.GetFantasyTeamSnapshotDTO) : async Result.Result<DTOs.FantasyTeamSnapshotDTO, T.Error> {
      return await userManager.getFantasyTeamSnapshot(dto);
    };

    //Leaderboard calls:

    public shared func getWeeklyLeaderboard(dto: DTOs.GetWeeklyLeaderboardDTO) : async Result.Result<DTOs.WeeklyLeaderboardDTO, T.Error> {
      return await leaderboardManager.getWeeklyLeaderboard(dto);
    };

    public shared func getMonthlyLeaderboard(dto: DTOs.GetMonthlyLeaderboardDTO) : async Result.Result<DTOs.MonthlyLeaderboardDTO, T.Error> {
      return await leaderboardManager.getMonthlyLeaderboard(dto);
    };

    public shared func getSeasonLeaderboard(dto: DTOs.GetSeasonLeaderboardDTO) : async Result.Result<DTOs.SeasonLeaderboardDTO, T.Error> {
      return await leaderboardManager.getSeasonLeaderboard(dto);
    };

    //No query calls


    public shared func getVerifiedPlayers() : async Result.Result<[DTOs.PlayerDTO], T.Error> {
      let data_canister = actor (NetworkEnvironmentVariables.DATA_CANISTER_ID) : actor {
        getPlayers : shared query (leagueId: FootballTypes.LeagueId) -> async Result.Result<[DTOs.PlayerDTO], T.Error>;
      };
      return await data_canister.getPlayers(Environment.LEAGUE_ID);
    };

    //Query functions:

    public shared composite query func getDataHashes() : async Result.Result<[DTOs.DataHashDTO], T.Error> {
      return seasonManager.getDataHashes();
    };

    public shared query func getSystemState() : async Result.Result<DTOs.SystemStateDTO, T.Error> {
      return seasonManager.getSystemState();
    };

    public shared composite query func getClubs() : async Result.Result<[DTOs.ClubDTO], T.Error> {
      let data_canister = actor (NetworkEnvironmentVariables.DATA_CANISTER_ID) : actor {
        getClubs : shared query (leagueId: FootballTypes.LeagueId) -> async Result.Result<[FootballTypes.Club], T.Error>;
      };
      return await data_canister.getClubs(Environment.LEAGUE_ID);
      //return await dataManager.getClubs(Environment.LEAGUE_ID); //Todo implement when figure out query function
    };

    public shared composite query func getFixtures(dto: RequestDTOs.RequestFixturesDTO) : async Result.Result<[DTOs.FixtureDTO], T.Error> {
      let data_canister = actor (NetworkEnvironmentVariables.DATA_CANISTER_ID) : actor {
        getFixtures : shared query (dto: RequestDTOs.RequestFixturesDTO) -> async Result.Result<[DTOs.FixtureDTO], T.Error>;
      };
      return await data_canister.getFixtures(dto);
      //return await dataManager.getFixtures(Environment.LEAGUE_ID, dto); //Todo implement when figure out query function
    };

    public shared composite query func getSeasons() : async Result.Result<[DTOs.SeasonDTO], T.Error> {
       let data_canister = actor (NetworkEnvironmentVariables.DATA_CANISTER_ID) : actor {
        getSeasons : shared query (leagueId: FootballTypes.LeagueId) -> async Result.Result<[DTOs.SeasonDTO], T.Error>;
      };
      return await data_canister.getSeasons(Environment.LEAGUE_ID);
      //return await dataManager.getSeasons(Environment.LEAGUE_ID); //Todo implement when figure out query function
    };

    public shared composite query func getPostponedFixtures() : async Result.Result<[DTOs.FixtureDTO], T.Error> {
      return #err(#NotFound);
      //return await dataManager.getPostponedFixtures(Environment.LEAGUE_ID);
    };

    public shared query func getTotalManagers() : async Result.Result<Nat, T.Error> {
      return userManager.getTotalManagers();
    };

    public shared composite query func getPlayers() : async Result.Result<[DTOs.PlayerDTO], T.Error> {
      let data_canister = actor (NetworkEnvironmentVariables.DATA_CANISTER_ID) : actor {
        getPlayers : shared query (leagueId: FootballTypes.LeagueId) -> async Result.Result<[DTOs.PlayerDTO], T.Error>;
      };
      return await data_canister.getPlayers(Environment.LEAGUE_ID);
    };

    public shared query ( {caller} ) func getPlayersSnapshot(dto: RequestDTOs.GetSnapshotPlayers) : async [DTOs.PlayerDTO] {
      assert isManagerCanister(Principal.toText(caller));
      return seasonManager.getPlayersSnapshot(dto);
    };


    public shared composite query func getLoanedPlayers(dto: DTOs.ClubFilterDTO) : async Result.Result<[DTOs.PlayerDTO], T.Error> {
      let data_canister = actor (NetworkEnvironmentVariables.DATA_CANISTER_ID) : actor {
        getLoanedPlayers : shared query (leagueId: FootballTypes.LeagueId, dto: DTOs.ClubFilterDTO) -> async Result.Result<[DTOs.PlayerDTO], T.Error>;
      };
      return await data_canister.getLoanedPlayers(Environment.LEAGUE_ID, dto);
    };

    public shared composite query func getRetiredPlayers(dto: DTOs.ClubFilterDTO) : async Result.Result<[DTOs.PlayerDTO], T.Error> {
      let data_canister = actor (NetworkEnvironmentVariables.DATA_CANISTER_ID) : actor {
        getRetiredPlayers : shared query (leagueId: FootballTypes.LeagueId, dto: DTOs.ClubFilterDTO) -> async Result.Result<[DTOs.PlayerDTO], T.Error>;
      };
      return await data_canister.getRetiredPlayers(Environment.LEAGUE_ID, dto);
      //return await dataManager.getRetiredPlayers(Environment.LEAGUE_ID, dto); //Todo implement when figure out query function
    };

    public shared composite query func getPlayerDetailsForGameweek(dto: DTOs.GameweekFiltersDTO) : async Result.Result<[DTOs.PlayerPointsDTO], T.Error> {
      let data_canister = actor (NetworkEnvironmentVariables.DATA_CANISTER_ID) : actor {
        getPlayerDetailsForGameweek : shared query (leagueId: FootballTypes.LeagueId, dto: DTOs.GameweekFiltersDTO) -> async Result.Result<[DTOs.PlayerPointsDTO], T.Error>;
      };
      return await data_canister.getPlayerDetailsForGameweek(Environment.LEAGUE_ID, dto);
      //return await dataManager.getPlayerDetailsForGameweek(Environment.LEAGUE_ID, dto); //Todo implement when figure out query function
    };

    public shared func getPlayersMap(dto: DTOs.GameweekFiltersDTO) : async Result.Result<[(Nat16, DTOs.PlayerScoreDTO)], T.Error> {
      let data_canister = actor (NetworkEnvironmentVariables.DATA_CANISTER_ID) : actor {
        getPlayersMap : shared query (leagueId: FootballTypes.LeagueId, dto: DTOs.GameweekFiltersDTO) -> async Result.Result<[(Nat16, DTOs.PlayerScoreDTO)], T.Error>;
      };
      return await data_canister.getPlayersMap(Environment.LEAGUE_ID, dto);
      //return await dataManager.getPlayersMap(Environment.LEAGUE_ID, dto); //Todo implement when figure out query function
    };

    public shared func getPlayerDetails(dto: DTOs.GetPlayerDetailsDTO) : async Result.Result<DTOs.PlayerDetailDTO, T.Error> {
      let data_canister = actor (NetworkEnvironmentVariables.DATA_CANISTER_ID) : actor {
        getPlayerDetailsForGameweek : shared query (leagueId: FootballTypes.LeagueId, dto: DTOs.GetPlayerDetailsDTO) -> async Result.Result<DTOs.PlayerDetailDTO, T.Error>;
      };
      return await data_canister.getPlayerDetailsForGameweek(Environment.LEAGUE_ID, dto);
      //return await dataManager.getPlayerDetails(Environment.LEAGUE_ID, dto); //Todo implement when figure out query function
    };

    public shared query func getCountries() : async Result.Result<[DTOs.CountryDTO], T.Error> {
      return #ok(Countries.countries);
    };

    public shared query ({ caller }) func isUsernameValid(dto: DTOs.UsernameFilterDTO) : async Bool {
      assert not Principal.isAnonymous(caller);
      let usernameValid = userManager.isUsernameValid(dto.username);
      let usernameTaken = userManager.isUsernameTaken(dto.username, Principal.toText(caller));
      return usernameValid and not usernameTaken;
    };

    //Update functions:

    public shared ({ caller }) func updateUsername(dto: DTOs.UpdateUsernameDTO) : async Result.Result<(), T.Error> {
      assert not Principal.isAnonymous(caller);
      let principalId = Principal.toText(caller);

      let systemStateResult = seasonManager.getSystemState();
      switch(systemStateResult){
        case (#ok systemState){       
          return await userManager.updateUsername(principalId, dto.username, systemState);   
        };
        case (#err error){
          return #err(error);
        }
      }
    };

    public shared ({ caller }) func updateFavouriteClub(dto: DTOs.UpdateFavouriteClubDTO) : async Result.Result<(), T.Error> {
      assert not Principal.isAnonymous(caller);
      let principalId = Principal.toText(caller);
      
      let systemStateResult = seasonManager.getSystemState();
      switch(systemStateResult){
        case (#ok systemState){       

          let clubsResult = await dataManager.getVerifiedClubs(Environment.LEAGUE_ID);
          switch(clubsResult){
            case (#ok clubs){
              return await userManager.updateFavouriteClub(principalId, dto.favouriteClubId, systemState, clubs);
            };
            case (#err error){
              return #err(error);
            }
          };
        };
        case (#err error){
          return #err(error);
        }
      };
    };

    public shared ({ caller }) func updateProfilePicture(dto: DTOs.UpdateProfilePictureDTO) : async Result.Result<(), T.Error> {
      assert not Principal.isAnonymous(caller);
      let principalId = Principal.toText(caller);

      let systemStateResult = seasonManager.getSystemState();
      switch(systemStateResult){
        case (#ok systemState){       

          return await userManager.updateProfilePicture(principalId, {
            extension = dto.extension;
            managerId = principalId;
            profilePicture = dto.profilePicture;
          }, systemState);
        };
        case (#err error){
          return #err(error);
        }
      };      
    };

    public shared ({ caller }) func saveFantasyTeam(fantasyTeam : DTOs.UpdateTeamSelectionDTO) : async Result.Result<(), T.Error> {
      assert not Principal.isAnonymous(caller);
      let principalId = Principal.toText(caller);
      let systemStateResult = seasonManager.getSystemState();
      switch(systemStateResult){
        case (#ok systemState){       
          assert not systemState.onHold;
          let playersResult = await dataManager.getVerifiedPlayers(Environment.LEAGUE_ID);
          switch(playersResult){
            case (#ok players){
              return await userManager.saveFantasyTeam(principalId, fantasyTeam, systemState, players);
            };
            case (#err error){
              return #err(error);
            }
          }
        };
        case (#err error){
          return #err(error);
        }
      };
    };

    public shared ({ caller }) func searchUsername(dto: DTOs.UsernameFilterDTO) : async Result.Result<DTOs.ManagerDTO, T.Error> {
      assert not Principal.isAnonymous(caller);
      return await userManager.getManagerByUsername(dto.username);
    };

    public shared ({ caller }) func getRewardPool(dto: DTOs.GetRewardPoolDTO) : async Result.Result<DTOs.GetRewardPoolDTO, T.Error> {
      assert not Principal.isAnonymous(caller);
      let rewardPool = leaderboardManager.getRewardPool(dto.seasonId);
      switch(rewardPool){
        case (null){
          return #err(#NotFound);
        };
        case (?foundRewardPool){
          return #ok({rewardPool = foundRewardPool; seasonId = dto.seasonId});
        }
      };
    };

    public shared ({ caller }) func getTopups(dto: DTOs.GetTopupsDTO) : async Result.Result<DTOs.GetTopupsDTO, T.Error> {
      assert not Principal.isAnonymous(caller);
      
      let topups = cyclesDispenser.getStableTopups();
      let droppedEntries = List.drop<Base.CanisterTopup>(List.fromArray(topups), dto.offset);
      let paginatedEntries = List.take<Base.CanisterTopup>(droppedEntries, dto.limit);

      return #ok({
        entries = List.toArray<DTOs.TopupDTO>(List.map<Base.CanisterTopup, DTOs.TopupDTO>(paginatedEntries, func(entry: Base.CanisterTopup) : DTOs.TopupDTO{
          return {
            canisterId = entry.canisterId; toppedUpOn = entry.topupTime; topupAmount = entry.cyclesAmount;
          }
        }));
        limit = dto.limit;
        offset = dto.offset;
        totalEntries = Array.size(topups);
      });
    };

    public shared ({ caller }) func updateDataHashes(category: Text) : async Result.Result<(), T.Error> {
      assert not Principal.isAnonymous(caller);
      assert Principal.toText(caller) == NetworkEnvironmentVariables.DATA_CANISTER_ID;
      await seasonManager.updateDataHash(category);      
      return #ok();
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

    //stable variables
    //TODO: Add back timers
    //private stable var timers : [Base.TimerInfo] = [];

    //stable variables from managers

    //Leaderboard Manager stable variables
    private stable var stable_unique_weekly_leaderboard_canister_ids: [Base.CanisterId] = [];
    private stable var stable_weekly_leaderboard_canister_ids: [(FootballTypes.SeasonId, [(FootballTypes.GameweekNumber, Base.CanisterId)])] = [];
    private stable var stable_monthly_leaderboard_canister_ids: [(FootballTypes.SeasonId, [(Base.CalendarMonth, Base.CanisterId)])] = [];
    private stable var stable_season_leaderboard_canister_ids: [(FootballTypes.SeasonId, Base.CanisterId)] = [];
    
    //Reward Manager stable variables
    private stable var stable_reward_pools : [(FootballTypes.SeasonId, T.RewardPool)] = [];
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
    private stable var stable_system_state : T.SystemState = {
      calculationGameweek = 7;
      calculationMonth = 10;
      calculationSeasonId = 1;
      onHold = false;
      pickTeamGameweek = 7;
      pickTeamMonth = 10;
      pickTeamSeasonId = 1;
      seasonActive = true;
      transferWindowActive = false;
      version = "2.0.0";
    };
    private stable var stable_data_hashes : [Base.DataHash] = [];
    private stable var stable_player_snapshots : [(FootballTypes.SeasonId, [(FootballTypes.GameweekNumber, [DTOs.PlayerDTO])])] = [];

    //User Manager stable variables
    private stable var stable_manager_canister_ids : [(Base.PrincipalId, Base.CanisterId)] = [];
    private stable var stable_usernames: [(Base.PrincipalId, Text)] = [];
    private stable var stable_unique_manager_canister_ids : [Base.CanisterId] = [];
    private stable var stable_total_managers : Nat = 0;
    private stable var stable_active_manager_canister_id : Base.CanisterId = "";   

    system func preupgrade() {

      stable_unique_weekly_leaderboard_canister_ids := leaderboardManager.getStableUniqueLeaderboardCanisterIds();
      stable_weekly_leaderboard_canister_ids := leaderboardManager.getStableWeeklyLeaderboardCanisterIds();
      stable_monthly_leaderboard_canister_ids := leaderboardManager.getStableMonthlyLeaderboardCanisterIds();
      stable_season_leaderboard_canister_ids := leaderboardManager.getStableSeasonLeaderboardCanisterIds();
      
      stable_reward_pools := leaderboardManager.getStableRewardPools();
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

      stable_system_state := seasonManager.getStableSystemState();
      stable_data_hashes := seasonManager.getStableDataHashes();
      stable_player_snapshots := seasonManager.getStablePlayersSnapshots();

      stable_manager_canister_ids := userManager.getStableManagerCanisterIds();
      stable_usernames := userManager.getStableUsernames();
      stable_unique_manager_canister_ids := userManager.getStableUniqueManagerCanisterIds();
      stable_total_managers := userManager.getStableTotalManagers();
      stable_active_manager_canister_id := userManager.getStableActiveManagerCanisterId();   

    };

    system func postupgrade() {
      leaderboardManager.setStableUniqueLeaderboardCanisterIds(stable_unique_weekly_leaderboard_canister_ids);
      leaderboardManager.setStableWeeklyLeaderboardCanisterIds(stable_weekly_leaderboard_canister_ids);
      leaderboardManager.setStableMonthlyLeaderboardCanisterIds(stable_monthly_leaderboard_canister_ids);
      leaderboardManager.setStableSeasonLeaderboardCanisterIds(stable_season_leaderboard_canister_ids);
      
      leaderboardManager.setStableRewardPools(stable_reward_pools);
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

      seasonManager.setStableSystemState(stable_system_state);
      seasonManager.setStableDataHashes(stable_data_hashes);
      seasonManager.setStablePlayersSnapshots(stable_player_snapshots);

      userManager.setStableManagerCanisterIds(stable_manager_canister_ids);
      userManager.setStableUsernames(stable_usernames);
      userManager.setStableUniqueManagerCanisterIds(stable_unique_manager_canister_ids);
      userManager.setStableTotalManagers(stable_total_managers);
      userManager.setStableActiveManagerCanisterId(stable_active_manager_canister_id);   

      seasonManager.setStableDataHashes([
        { category = "clubs"; hash = "OPENFPL_1" },
        { category = "fixtures"; hash = "OPENFPL_1" },
        { category = "weekly_leaderboard"; hash = "OPENFPL_1" },
        { category = "monthly_leaderboards"; hash = "OPENFPL_1" },
        { category = "season_leaderboard"; hash = "OPENFPL_1" },
        { category = "players"; hash = "OPENFPL_1" },
        { category = "player_events"; hash = "OPENFPL_1" },
        { category = "countries"; hash = "OPENFPL_1" },
        { category = "system_state"; hash = "OPENFPL_1" },
        { category = "seasons"; hash = "OPENFPL_1" }
      ]);
      ignore Timer.setTimer<system>(#nanoseconds(Int.abs(1)), postUpgradeCallback); 
    };

    private func postUpgradeCallback() : async (){

      //TODO (GO LIVE)
      //set system state
      //await checkCanisterCycles(); 
      //await setSystemTimers();
      await updateManagerCanisterWasms();

      await seasonManager.updateDataHash("clubs");
      await seasonManager.updateDataHash("fixtures");
      await seasonManager.updateDataHash("weekly_leaderboard");
      await seasonManager.updateDataHash("monthly_leaderboards");
      await seasonManager.updateDataHash("season_leaderboard");
      await seasonManager.updateDataHash("players");
      await seasonManager.updateDataHash("player_events");
      await seasonManager.updateDataHash("countries");
      await seasonManager.updateDataHash("system_state");
    };


    private func updateManagerCanisterWasms() : async (){
      let managerCanisterIds = userManager.getUniqueManagerCanisterIds();
      let IC : Management.Management = actor (NetworkEnvironmentVariables.Default);
      for(canisterId in Iter.fromArray(managerCanisterIds)){
        await IC.stop_canister({ canister_id = Principal.fromText(canisterId); });
        let oldManagement = actor (canisterId) : actor {};
        let _ = await (system ManagerCanister._ManagerCanister)(#upgrade oldManagement)();
        await IC.start_canister({ canister_id = Principal.fromText(canisterId); });
      };
    };

    //Functions to be removed when handed back to SNS

    public shared ({ caller }) func updateSystemState(dto: RequestDTOs.UpdateSystemStateDTO) : async Result.Result<(), T.Error> {
      assert Principal.toText(caller) == NetworkEnvironmentVariables.FOOTBALL_GOD_BACKEND_CANISTER_ID;
      return await seasonManager.updateSystemState(dto);
    };

    public shared ({ caller }) func snapshotManagers() : async Result.Result<(), T.Error> {
      assert Principal.toText(caller) == NetworkEnvironmentVariables.FOOTBALL_GOD_BACKEND_CANISTER_ID;
      let systemStateResult = await getSystemState();
      switch(systemStateResult){
        case (#ok systemState){

          let playersResult = await dataManager.getVerifiedPlayers(Environment.LEAGUE_ID); 
          switch(playersResult){
            case (#ok players){
              seasonManager.storePlayersSnapshot(systemState.pickTeamSeasonId, systemState.pickTeamGameweek, players);
              let _ = await userManager.snapshotFantasyTeams(Environment.LEAGUE_ID, systemState.calculationSeasonId, systemState.calculationGameweek, systemState.calculationMonth);
              return #ok();
            };
            case (#err error){
              return #err(error);
            }
          };
        };  
        case (#err error){
          return #err(error);
        }
      };
    };

    public shared ({ caller }) func calculateGameweekScores() : async Result.Result<(), T.Error> {
      assert Principal.toText(caller) == NetworkEnvironmentVariables.FOOTBALL_GOD_BACKEND_CANISTER_ID;
      let systemStateResult = await getSystemState();
      switch(systemStateResult){
        case (#ok systemState){
          let _ = await userManager.calculateFantasyTeamScores(Environment.LEAGUE_ID, systemState.calculationSeasonId, systemState.calculationGameweek, systemState.calculationMonth);
          return #ok();
        };  
        case (#err error){
          return #err(error);
        }
      };
    };

    public shared ({ caller }) func calculateLeaderboards() : async Result.Result<(), T.Error> {
      assert Principal.toText(caller) == NetworkEnvironmentVariables.FOOTBALL_GOD_BACKEND_CANISTER_ID;
      let systemStateResult = await getSystemState();
      switch(systemStateResult){
        case (#ok systemState){
          let data_canister = actor (NetworkEnvironmentVariables.DATA_CANISTER_ID) : actor {
            getClubs : shared query (leagueId: FootballTypes.LeagueId) -> async Result.Result<[FootballTypes.Club], T.Error>;
          };
          let clubsResult = await data_canister.getClubs(Environment.LEAGUE_ID);

          switch(clubsResult){
            case (#ok clubs){
              let clubIds = Array.map<DTOs.ClubDTO, FootballTypes.ClubId>(clubs, func(club: DTOs.ClubDTO){
                return club.id
              });
              let managerCanisterIds = userManager.getUniqueManagerCanisterIds();
              let _ = leaderboardManager.calculateLeaderboards(systemState.calculationSeasonId, systemState.calculationGameweek, systemState.calculationMonth, managerCanisterIds, clubIds);
              return #ok();
            };
            case (#err error){
              return #err(error)
            }
          };
        };  
        case (#err error){
          return #err(error);
        }
      };
    };

    public shared ({ caller }) func notifyAppsOfLoan(leagueId: FootballTypes.LeagueId, playerId: FootballTypes.PlayerId) : async Result.Result<(), T.Error> {
      assert Principal.toText(caller) == NetworkEnvironmentVariables.DATA_CANISTER_ID;
      await userManager.removePlayerFromTeams(leagueId, playerId, Environment.BACKEND_CANISTER_ID);
      return #ok();
    };

    public shared ({ caller }) func notifyAppsOfPositionChange(leagueId: FootballTypes.LeagueId, playerId: FootballTypes.PlayerId) : async Result.Result<(), T.Error> {
      assert Principal.toText(caller) == NetworkEnvironmentVariables.DATA_CANISTER_ID;
      await userManager.removePlayerFromTeams(leagueId, playerId, Environment.BACKEND_CANISTER_ID);
      return #ok();
    };

    

  };
