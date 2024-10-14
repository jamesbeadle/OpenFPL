  import Array "mo:base/Array";
  import Bool "mo:base/Bool";
  import Buffer "mo:base/Buffer";
  import Cycles "mo:base/ExperimentalCycles";
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

  import T "../shared/types";
  import DTOs "../shared/DTOs";
  import Requests "../shared/RequestDTOs";
  import Countries "../shared/Countries";
  import Utilities "../shared/utils/utilities";
  import Account "../shared/lib/Account";

  import Management "../shared/utils/Management";
  import FPLLedger "../shared/def/FPLLedger";
  import ManagerCanister "../shared/canister_definitions/manager-canister";
  import DataManager "../shared/managers/data-manager";
  import LeaderboardManager "../shared/managers/leaderboard-manager";
  import UserManager "../shared/managers/user-manager";
  import SeasonManager "../shared/managers/season-manager";
  import CyclesDispenser "../shared/cycles-dispenser";
  import Environment "./Environment";
  import NetworkEnvironmentVariables "../shared/network_environment_variables";
  import Responses "../shared/ResponseDTOs";

  actor Self {
    
    private let userManager = UserManager.UserManager(Environment.BACKEND_CANISTER_ID, Environment.NUM_OF_GAMEWEEKS);
    private let dataManager = DataManager.DataManager();
    private let seasonManager = SeasonManager.SeasonManager(Environment.NUM_OF_GAMEWEEKS);
    private let leaderboardManager = LeaderboardManager.LeaderboardManager(Environment.BACKEND_CANISTER_ID, Environment.NUM_OF_GAMEWEEKS, Environment.NUM_OF_MONTHS);
    private let cyclesDispenser = CyclesDispenser.CyclesDispenser();
    private let ledger : FPLLedger.Interface = actor (FPLLedger.CANISTER_ID);
    
    private func isDataAdmin(principalId: Text) : Bool {
      return Option.isSome(Array.find<T.PrincipalId>(dataAdmins, func(dataAdmin: T.PrincipalId) : Bool{
        dataAdmin == principalId;
      }));
    };

    private func isManagerCanister(principalId: Text) : Bool {
      let managerCanisterIds = userManager.getUniqueManagerCanisterIds();
      return Option.isSome(Array.find<T.PrincipalId>(managerCanisterIds, func(dataAdmin: T.PrincipalId) : Bool{
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
      return await userManager.getCurrentTeam(Principal.toText(caller));
    };

    public shared func getManager(dto: Requests.RequestManagerDTO) : async Result.Result<DTOs.ManagerDTO, T.Error> {
      let weeklyLeaderboardEntry = await leaderboardManager.getWeeklyLeaderboardEntry(dto.managerId, dto.seasonId, dto.gameweek);
      let monthlyLeaderboardEntry = await leaderboardManager.getMonthlyLeaderboardEntry(dto.managerId, dto.seasonId, dto.month, dto.clubId);
      let seasonLeaderboardEntry = await leaderboardManager.getSeasonLeaderboardEntry(dto.managerId, dto.seasonId);

      return await userManager.getManager(dto, weeklyLeaderboardEntry, monthlyLeaderboardEntry, seasonLeaderboardEntry);
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


    //Query functions:

    public shared query func getDataHashes() : async Result.Result<[DTOs.DataHashDTO], T.Error> {
      return seasonManager.getDataHashes();
    };

    public shared func getSystemState() : async Result.Result<DTOs.SystemStateDTO, T.Error> {
      return await seasonManager.getSystemState();
    };

    public shared func getLeagues() : async Result.Result<[DTOs.FootballLeagueDTO], T.Error> {
      return await dataManager.getLeagues();
    };

    public shared func getClubs() : async Result.Result<[DTOs.ClubDTO], T.Error> {
      return await dataManager.getClubs(Environment.LEAGUE_ID);
    };

    public shared func getFixtures(dto: Requests.RequestFixturesDTO) : async Result.Result<[DTOs.FixtureDTO], T.Error> {
      return await dataManager.getFixtures(Environment.LEAGUE_ID, dto);
    };

    public shared func getSeasons() : async Result.Result<[DTOs.SeasonDTO], T.Error> {
      return await dataManager.getSeasons(Environment.LEAGUE_ID);
    };

    public shared func getPostponedFixtures() : async Result.Result<[DTOs.FixtureDTO], T.Error> {
      return #err(#NotFound);
      //return await dataManager.getPostponedFixtures(Environment.LEAGUE_ID);
    };

    public shared func getTotalManagers() : async Result.Result<Nat, T.Error> {
      return await userManager.getTotalManagers();
    };

    public shared func getPlayers() : async Result.Result<[DTOs.PlayerDTO], T.Error> {
      Debug.print("getting players");

      let systemStateResult = await getSystemState();
      switch(systemStateResult){
        case (#ok systemState){
          return await dataManager.getPlayers(Environment.LEAGUE_ID, { seasonId = systemState.pickTeamSeasonId });
        };  
        case (#err error){
          return #err(error);
        }
      };
    };

     public shared ( {caller} ) func getSnapshotPlayers(dto: Requests.GetSnapshotPlayers) : async [DTOs.PlayerDTO] {
      assert isManagerCanister(Principal.toText(caller));
      return await dataManager.getSnapshotPlayers(dto);
    };

    public shared func getLoanedPlayers(dto: DTOs.ClubFilterDTO) : async Result.Result<[DTOs.PlayerDTO], T.Error> {
      return await dataManager.getLoanedPlayers(Environment.LEAGUE_ID, dto);
    };

    public shared func getRetiredPlayers(dto: DTOs.ClubFilterDTO) : async Result.Result<[DTOs.PlayerDTO], T.Error> {
      return await dataManager.getRetiredPlayers(Environment.LEAGUE_ID, dto);
    };

    public shared func getPlayerDetailsForGameweek(dto: DTOs.GameweekFiltersDTO) : async Result.Result<[DTOs.PlayerPointsDTO], T.Error> {
      return await dataManager.getPlayerDetailsForGameweek(Environment.LEAGUE_ID, dto);
    };

    public shared func getPlayersMap(dto: DTOs.GameweekFiltersDTO) : async Result.Result<[(Nat16, DTOs.PlayerScoreDTO)], T.Error> {
      return await dataManager.getPlayersMap(Environment.LEAGUE_ID, dto);
    };

    public shared func getPlayerDetails(dto: DTOs.GetPlayerDetailsDTO) : async Result.Result<DTOs.PlayerDetailDTO, T.Error> {
      return await dataManager.getPlayerDetails(Environment.LEAGUE_ID, dto);
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

      let systemStateResult = await seasonManager.getSystemState();
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
      
      let systemStateResult = await seasonManager.getSystemState();
      switch(systemStateResult){
        case (#ok systemState){       

          let clubsResult = await dataManager.getClubs(Environment.LEAGUE_ID);
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

      let systemStateResult = await seasonManager.getSystemState();
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

      let systemStateResult = await seasonManager.getSystemState();
      switch(systemStateResult){
        case (#ok systemState){       
          assert not systemState.onHold;
      
          let playersResult = await dataManager.getPlayers(Environment.LEAGUE_ID, { seasonId = systemState.pickTeamSeasonId });
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

    //Gameplay entry Points

    public shared ({ caller }) func executeSubmitFixtureData(submitFixtureData : DTOs.SubmitFixtureDataDTO) : async () {
      //assert Principal.toText(caller) == NetworkEnvironmentVariables.SNS_GOVERNANCE_CANISTER_ID;
      assert isDataAdmin(Principal.toText(caller));
      let systemStateResult = await getSystemState();
      switch(systemStateResult){
        case (#ok systemState){
      
          switch(await dataManager.validateSubmitFixtureData(Environment.LEAGUE_ID, submitFixtureData)){
            case (#ok _){
              let _ = await dataManager.executeSubmitFixtureData(Environment.LEAGUE_ID, systemState.calculationSeasonId, submitFixtureData);

              //TODO LATER: When calculating score get players built friom all players who appeared in the gameweek
              await userManager.calculateFantasyTeamScores(
                Environment.LEAGUE_ID,
                systemState.calculationSeasonId, submitFixtureData.gameweek, submitFixtureData.month);
                let clubsResult = await dataManager.getClubs(Environment.LEAGUE_ID);
                switch(clubsResult){
                  case (#ok clubs){
                    let clubIds = Array.map<DTOs.ClubDTO, T.ClubId>(clubs, func(club: DTOs.ClubDTO){
                      return club.id;
                    });
                    await leaderboardManager.calculateLeaderboards(systemState.calculationSeasonId, submitFixtureData.gameweek, submitFixtureData.month, userManager.getUniqueManagerCanisterIds(), clubIds);
                  };
                  case (#err _){}
                };
              
              if(await dataManager.checkGameweekComplete(systemState.calculationSeasonId, submitFixtureData.gameweek)){
                await userManager.resetWeeklyTransfers();
                await leaderboardManager.payWeeklyRewards();
                await seasonManager.incrementCalculationGameweek();
              };

              if(await dataManager.checkMonthComplete(systemState.calculationSeasonId, submitFixtureData.month, submitFixtureData.gameweek)){
                await userManager.resetBonusesAvailable();
                await leaderboardManager.payMonthlyRewards();
                await seasonManager.incrementCalculationMonth();
              };

              if(await dataManager.checkSeasonComplete(systemState.calculationSeasonId)){
                await userManager.resetFantasyTeams();
                await leaderboardManager.paySeasonRewards();
                await seasonManager.incrementCalculationSeason();
                
                /* Todo
                seasonManager.createNewSeason(systemState);
                  
                let currentSeasonId = seasonComposite.getStableNextSeasonId();
                await calculateRewardPool(currentSeasonId); //TODO LATER SPLIT NEW VALUES
                */

                await setTransferWindowTimers();
              };
              
              await seasonManager.updateDataHash("seasons");
              await seasonManager.updateDataHash("players");
              await seasonManager.updateDataHash("player_events");
              await seasonManager.updateDataHash("fixtures");
              await seasonManager.updateDataHash("weekly_leaderboard");
              await seasonManager.updateDataHash("monthly_leaderboards");
              await seasonManager.updateDataHash("season_leaderboard");
              await seasonManager.updateDataHash("system_state");
              
            };
            case _ {}
          };

        };
        case (#err error){}
      };
    };



    private func setTransferWindowTimers() : async () {
      let jan1Date = Utilities.nextUnixTimeForDayOfYear(1);
      let jan31Date = Utilities.nextUnixTimeForDayOfYear(31);

      let transferWindowStartDate : Timer.Duration = #nanoseconds(Int.abs(jan1Date - Time.now()));
      let transferWindowEndDate : Timer.Duration = #nanoseconds(Int.abs(jan31Date - Time.now()));

      await setAndBackupTimer(transferWindowStartDate, "transferWindowStart");
      await setAndBackupTimer(transferWindowEndDate, "transferWindowEnd");
    };
    
    
    //system callback functions

    private func cyclesCheckCallback() : async () {
      //await checkCanisterCycles(); TODO
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
      let droppedEntries = List.drop<T.CanisterTopup>(List.fromArray(topups), dto.offset);
      let paginatedEntries = List.take<T.CanisterTopup>(droppedEntries, dto.limit);

      return #ok({
        entries = List.toArray<DTOs.TopupDTO>(List.map<T.CanisterTopup, DTOs.TopupDTO>(paginatedEntries, func(entry: T.CanisterTopup) : DTOs.TopupDTO{
          return {
            canisterId = entry.canisterId; toppedUpOn = entry.topupTime; topupAmount = entry.cyclesAmount;
          }
        }));
        limit = dto.limit;
        offset = dto.offset;
        totalEntries = Array.size(topups);
      });
    };

    //stable variables
    private stable var dataAdmins : [T.PrincipalId] = [];
    private stable var alreadyInitialisedData = false;
    private stable var timers : [T.TimerInfo] = [];

    //stable variables from managers

    //Leaderboard Manager stable variables
    private stable var stable_leaderboard_canisters: [T.LeaderboardCanister] = [];
    
    //Reward Manager stable variables
    private stable var stable_reward_pools : [(T.SeasonId, T.RewardPool)] = [];
    private stable var stable_team_value_leaderboards : [(T.SeasonId, T.TeamValueLeaderboard)] = [];
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
    private stable var stable_active_leaderbord_canister_id : T.CanisterId = "";

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
    private stable var stable_data_hashes : [T.DataHash] = [];

    //User Manager stable variables
    private stable var stable_manager_canister_ids : [(T.PrincipalId, T.CanisterId)] = [];
    private stable var stable_usernames: [(T.PrincipalId, Text)] = [];
    private stable var stable_unique_manager_canister_ids : [T.CanisterId] = [];
    private stable var stable_total_managers : Nat = 0;
    private stable var stable_active_manager_canister_id : T.CanisterId = "";   

    system func preupgrade() {

      stable_leaderboard_canisters := leaderboardManager.getStableLeaderboardCanisters();
      
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

      stable_manager_canister_ids := userManager.getStableManagerCanisterIds();
      stable_usernames := userManager.getStableUsernames();
      stable_unique_manager_canister_ids := userManager.getStableUniqueManagerCanisterIds();
      stable_total_managers := userManager.getStableTotalManagers();
      stable_active_manager_canister_id := userManager.getStableActiveManagerCanisterId();   

    };

    system func postupgrade() {
      leaderboardManager.setStableWeeklyLeaderboardCanisters(stable_leaderboard_canisters);
      
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

      userManager.setStableManagerCanisterIds(stable_manager_canister_ids);
      userManager.setStableUsernames(stable_usernames);
      userManager.setStableUniqueManagerCanisterIds(stable_unique_manager_canister_ids);
      userManager.setStableTotalManagers(stable_total_managers);
      userManager.setStableActiveManagerCanisterId(stable_active_manager_canister_id);   

      ignore Timer.setTimer<system>(#nanoseconds(Int.abs(1)), postUpgradeCallback); 
    };

    private func postUpgradeCallback() : async (){

      //TODO now
      //set system state

      //TODO: Set each canister to have the openfpl backend as a controller

      //await checkCanisterCycles(); 
      //await setSystemTimers();
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

    //Timer Functions

    private func setSystemTimers() : async (){
      
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

    private func gameweekBeginExpiredCallback() : async () {
      await seasonManager.setNextPickTeamGameweek();
      removeExpiredTimers();
      let systemStateResult = await seasonManager.getSystemState();
      switch(systemStateResult){
        case (#ok systemState){
          await setGameweekTimers(systemState.pickTeamSeasonId, systemState.pickTeamGameweek);     
          await userManager.snapshotFantasyTeams(systemState.calculationSeasonId, systemState.calculationGameweek, systemState.calculationMonth);
          await seasonManager.updateDataHash("system_state");
        };
        case (#err _){}
      };      
    };

    public func setGameweekTimers(seasonId: T.SeasonId, gameweek: T.GameweekNumber) : async () {
      let fixturesResult = await dataManager.getFixtures(Environment.LEAGUE_ID, {seasonId = seasonId});
      switch(fixturesResult){
        case (#ok fixtures){
          let filteredFilters = Array.filter<DTOs.FixtureDTO>(
            fixtures,
            func(fixture : DTOs.FixtureDTO) : Bool {
              return fixture.gameweek == gameweek;
            },
          );

          let sortedArray = Array.sort(
            filteredFilters,
            func(a : DTOs.FixtureDTO, b : DTOs.FixtureDTO) : Order.Order {
              if (a.kickOff < b.kickOff) { return #less };
              if (a.kickOff == b.kickOff) { return #equal };
              return #greater;
            },
          );

          let firstFixture = sortedArray[0];
          let durationToHourBeforeFirstFixture : Timer.Duration = #nanoseconds(Int.abs(firstFixture.kickOff - Utilities.getHour() - Time.now()));
          await setAndBackupTimer(durationToHourBeforeFirstFixture, "gameweekBeginExpired");
          
          await setKickOffTimers(filteredFilters);  
        };
        case (#err _){ }
      }
    };


    private func setKickOffTimers(gameweekFixtures : [DTOs.FixtureDTO]) : async () {
      for (fixture in Iter.fromArray(gameweekFixtures)) {
        let durationToKickOff : Timer.Duration = #nanoseconds(Int.abs(fixture.kickOff - Time.now()));
        await setAndBackupTimer(durationToKickOff, "gameKickOffExpired");

        let durationToEndOfGame : Timer.Duration = #nanoseconds(Int.abs(fixture.kickOff - Time.now() + (Utilities.getHour() * 2)));
        await setAndBackupTimer(durationToEndOfGame, "gameCompletedExpired");
      };
    };

    private func gameKickOffExpiredCallback() : async () {
      await seasonManager.setFixturesToActive();
      removeExpiredTimers();
      await seasonManager.updateDataHash("fixtures");
    };

    private func gameCompletedExpiredCallback() : async () {
      await seasonManager.setFixturesToCompleted();
      removeExpiredTimers();
      await seasonManager.updateDataHash("fixtures");
    };

    private func loanExpiredCallback() : async () {
      await dataManager.loanExpired();
      removeExpiredTimers();
      await seasonManager.updateDataHash("players");
    };

    private func injuryExpiredCallback() : async () {
      await dataManager.injuryExpired();
      removeExpiredTimers();
      await seasonManager.updateDataHash("players");
    };

    private func transferWindowStartCallback() : async () {
      await seasonManager.transferWindowStart();
      removeExpiredTimers();
      await seasonManager.updateDataHash("system_state");
    };

    private func transferWindowEndCallback() : async () {
      await seasonManager.transferWindowEnd();
      removeExpiredTimers();
      await seasonManager.updateDataHash("system_state");
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

    //System timer functions

    public func getBackendCanisterBalance() : async Result.Result<Nat, T.Error> {
      let balance = await ledger.icrc1_balance_of({owner = Principal.fromActor(Self); subaccount = null});
      return #ok(balance);
    };

    public shared func getCanisterCyclesBalance() : async Result.Result<Nat, T.Error> {
      return #ok(Cycles.balance());
    };

    //informational end points

    public shared func getCanisterCyclesAvailable() : async Nat {
      return Cycles.available();
    };

    public shared func getTreasuryAccountPublic() : async Account.AccountIdentifier {
      return getTreasuryAccount();
    };

    private func getTreasuryAccount() : Account.AccountIdentifier {
      let actorPrincipal : Principal = Principal.fromActor(Self);
      Account.accountIdentifier(actorPrincipal, Account.defaultSubaccount());
    };

    //Game movement functions
      //from openfpl data canister    

    public shared ({ caller }) func snapshotManagers(gameweekNumber: T.GameweekNumber) : async Result.Result<(), T.Error> {
      //TODO: Add isadmin check
      return #err(#NotFound);
    };

    public shared ({ caller }) func recalculatePoints(gameweekNumber: T.GameweekNumber) : async Result.Result<(), T.Error> {
      //TODO: Add isadmin check
      return #err(#NotFound);
    };

    public shared ({ caller }) func viewPayouts(gameweekNumber: T.GameweekNumber) : async Result.Result<(), T.Error> {
      //TODO: Add isadmin check
      return #err(#NotFound);
    };

    public shared ({ caller }) func updateRewardPools(dto: Requests.UpdateRewardPoolsDTO) : async Result.Result<(), T.Error> {
      //TODO: Add isadmin check
      return #err(#NotFound);
    };

    public shared ({ caller }) func updateSystemStatus(dto: Requests.UpdateSystemStatusDTO) : async Result.Result<(), T.Error> {
      //TODO: Add isadmin check
      return #err(#NotFound);
    };



  };
