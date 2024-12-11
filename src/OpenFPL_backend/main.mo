  import Array "mo:base/Array";
  import Bool "mo:base/Bool";
  import Int "mo:base/Int";
  import Iter "mo:base/Iter";
  import Principal "mo:base/Principal";
  import Result "mo:base/Result";
  import Timer "mo:base/Timer";
  import Nat64 "mo:base/Nat64";
  import Nat "mo:base/Nat";
  import Option "mo:base/Option";
  import Text "mo:base/Text";
  import Time "mo:base/Time";
  import Buffer "mo:base/Buffer";
  import List "mo:base/List";
  import Debug "mo:base/Debug";
  import Nat16 "mo:base/Nat16";
  import Nat8 "mo:base/Nat8";

  import Base "../shared/types/base_types";
  import FootballTypes "../shared/types/football_types";
  import T "../shared/types/app_types";
  import DTOs "../shared/dtos/DTOs";
  import RequestDTOs "../shared/dtos/request_DTOs";
  import ResponseDTOs "../shared/dtos/response_DTOs";
  import Countries "../shared/Countries";
  import Root "../shared/sns-wrappers/root";

  import Management "../shared/utils/Management";
  import ManagerCanister "../shared/canister_definitions/manager-canister";
  import LeaderboardCanister "../shared/canister_definitions/leaderboard-canister";
  import DataManager "../shared/managers/data-manager";
  import LeaderboardManager "../shared/managers/leaderboard-manager";
  import UserManager "../shared/managers/user-manager";
  import SeasonManager "../shared/managers/season-manager";
  import Environment "./Environment";
  import NetworkEnvironmentVariables "../shared/network_environment_variables";
  import Utilities "../shared/utils/utilities";

  actor Self {
    
    private let userManager = UserManager.UserManager(Environment.BACKEND_CANISTER_ID, Environment.NUM_OF_GAMEWEEKS);
    private let dataManager = DataManager.DataManager();
    private let seasonManager = SeasonManager.SeasonManager();
    private let leaderboardManager = LeaderboardManager.LeaderboardManager(Environment.BACKEND_CANISTER_ID);
    
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
      let leagueStatusResult = await getLeagueStatus();
      switch(leagueStatusResult){
        case (#ok leagueStatus){       
          return await userManager.getCurrentTeam(Principal.toText(caller), leagueStatus.activeSeasonId);
        };
        case (#err error){
          return #err(error);
        }
      }
    };

    public shared func getLeagueStatus() : async Result.Result<FootballTypes.LeagueStatus, T.Error> {
      let data_canister = actor (NetworkEnvironmentVariables.DATA_CANISTER_ID) : actor {
        getLeagueStatus : shared query (leagueId: FootballTypes.LeagueId) -> async Result.Result<FootballTypes.LeagueStatus, T.Error>;
      };
      return await data_canister.getLeagueStatus(Environment.LEAGUE_ID);
    };

    public shared func getManager(dto: RequestDTOs.RequestManagerDTO) : async Result.Result<DTOs.ManagerDTO, T.Error> {
      
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

    //Verified (non query) calls for when consensus required

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

    public shared query func getAppStatus() : async Result.Result<DTOs.AppStatusDTO, T.Error> {
      return seasonManager.getAppStatus();
    };

    public shared composite query func getClubs() : async Result.Result<[DTOs.ClubDTO], T.Error> {
      let data_canister = actor (NetworkEnvironmentVariables.DATA_CANISTER_ID) : actor {
        getClubs : shared query (leagueId: FootballTypes.LeagueId) -> async Result.Result<[FootballTypes.Club], T.Error>;
      };
      return await data_canister.getClubs(Environment.LEAGUE_ID);
    };

    public shared composite query func getFixtures(leagueId: FootballTypes.LeagueId) : async Result.Result<[DTOs.FixtureDTO], T.Error> {
      let data_canister = actor (NetworkEnvironmentVariables.DATA_CANISTER_ID) : actor {
        getFixtures : shared query (leagueId: FootballTypes.LeagueId) -> async Result.Result<[DTOs.FixtureDTO], T.Error>;
      };
      return await data_canister.getFixtures(leagueId);
    };

    public shared composite query func getSeasons() : async Result.Result<[DTOs.SeasonDTO], T.Error> {
       let data_canister = actor (NetworkEnvironmentVariables.DATA_CANISTER_ID) : actor {
        getSeasons : shared query (leagueId: FootballTypes.LeagueId) -> async Result.Result<[DTOs.SeasonDTO], T.Error>;
      };
      return await data_canister.getSeasons(Environment.LEAGUE_ID);
    };

    public shared composite query func getPostponedFixtures(leagueId: FootballTypes.LeagueId) : async Result.Result<[DTOs.FixtureDTO], T.Error> {
      let data_canister = actor (NetworkEnvironmentVariables.DATA_CANISTER_ID) : actor {
        getPostponedFixtures : shared query (leagueId: FootballTypes.LeagueId) -> async Result.Result<[DTOs.FixtureDTO], T.Error>;
      };
      return await data_canister.getPostponedFixtures(leagueId);
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
    };

    public shared composite query func getPlayerDetailsForGameweek(dto: DTOs.GameweekFiltersDTO) : async Result.Result<[DTOs.PlayerPointsDTO], T.Error> {
      let data_canister = actor (NetworkEnvironmentVariables.DATA_CANISTER_ID) : actor {
        getPlayerDetailsForGameweek : shared query (leagueId: FootballTypes.LeagueId, dto: DTOs.GameweekFiltersDTO) -> async Result.Result<[DTOs.PlayerPointsDTO], T.Error>;
      };
      return await data_canister.getPlayerDetailsForGameweek(Environment.LEAGUE_ID, dto);
    };

    public shared func getPlayersMap(dto: DTOs.GameweekFiltersDTO) : async Result.Result<[(Nat16, DTOs.PlayerScoreDTO)], T.Error> {
      let data_canister = actor (NetworkEnvironmentVariables.DATA_CANISTER_ID) : actor {
        getPlayersMap : shared query (leagueId: FootballTypes.LeagueId, dto: DTOs.GameweekFiltersDTO) -> async Result.Result<[(Nat16, DTOs.PlayerScoreDTO)], T.Error>;
      };
      return await data_canister.getPlayersMap(Environment.LEAGUE_ID, dto);
    };

    public shared func getPlayerDetails(dto: DTOs.GetPlayerDetailsDTO) : async Result.Result<DTOs.PlayerDetailDTO, T.Error> {
      let data_canister = actor (NetworkEnvironmentVariables.DATA_CANISTER_ID) : actor {
        getPlayerDetailsForGameweek : shared query (leagueId: FootballTypes.LeagueId, dto: DTOs.GetPlayerDetailsDTO) -> async Result.Result<DTOs.PlayerDetailDTO, T.Error>;
      };
      return await data_canister.getPlayerDetailsForGameweek(Environment.LEAGUE_ID, dto);
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

      let leagueStatusResult = await getLeagueStatus();
      switch(leagueStatusResult){
        case (#ok leagueStatus){       
          return await userManager.updateUsername(principalId, dto.username, leagueStatus.unplayedGameweek);   
        };
        case (#err error){
          return #err(error);
        }
      }
    };

    public shared ({ caller }) func updateFavouriteClub(dto: DTOs.UpdateFavouriteClubDTO) : async Result.Result<(), T.Error> {
      assert not Principal.isAnonymous(caller);
      let principalId = Principal.toText(caller);
      
      let leagueStatusResult = await getLeagueStatus();
      switch(leagueStatusResult){
        case (#ok leagueStatus){       

          let clubsResult = await dataManager.getVerifiedClubs(Environment.LEAGUE_ID);
          switch(clubsResult){
            case (#ok clubs){
              return await userManager.updateFavouriteClub(principalId, dto.favouriteClubId, leagueStatus.unplayedGameweek, clubs);
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

      let leagueStatusResult = await getLeagueStatus();
      switch(leagueStatusResult){
        case (#ok leagueStatus){       

          return await userManager.updateProfilePicture(principalId, {
            extension = dto.extension;
            managerId = principalId;
            profilePicture = dto.profilePicture;
          }, leagueStatus.unplayedGameweek);
        };
        case (#err error){
          return #err(error);
        }
      };      
    };

    public shared ({ caller }) func saveFantasyTeam(fantasyTeam : DTOs.UpdateTeamSelectionDTO) : async Result.Result<(), T.Error> {
      assert not Principal.isAnonymous(caller);
      let principalId = Principal.toText(caller);
      let leagueStatusResult = await getLeagueStatus();

      let appStatusResult = seasonManager.getAppStatus();
      switch(appStatusResult){
        case (#ok appStatus){
          if (appStatus.onHold) {
            return #err(#SystemOnHold);
          };
        };
        case (#err error){
          return #err(error);
        }
      };
      
      switch(leagueStatusResult){
        case (#ok leagueStatus){     

          if(not leagueStatus.seasonActive){
            return #err(#NotAllowed);
          };    
          
          let playersResult = await dataManager.getVerifiedPlayers(Environment.LEAGUE_ID);
          switch(playersResult){
            case (#ok players){
              return await userManager.saveFantasyTeam(principalId, fantasyTeam, leagueStatus.activeSeasonId, leagueStatus.unplayedGameweek, players);
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
    
    //Canister topup functions
  
    public shared func getCanisters(dto: DTOs.GetCanistersDTO) : async Result.Result<[DTOs.CanisterDTO], T.Error> {
      let canistersBuffer = Buffer.fromArray<DTOs.CanisterDTO>([]);
      let root_canister = actor (NetworkEnvironmentVariables.SNS_ROOT_CANISTER_ID) : actor {
        get_sns_canisters_summary : (request: Root.GetSnsCanistersSummaryRequest) -> async Root.GetSnsCanistersSummaryResponse;
      };
  
      switch(dto.canisterType){
        case (#SNS){

          let summaryResult = await root_canister.get_sns_canisters_summary({update_canister_list = ?false});
          var snsCanistersBuffer = Buffer.fromArray<Root.CanisterSummary>([]);
          
          snsCanistersBuffer := appendSNSCanister(snsCanistersBuffer, summaryResult.governance);
          snsCanistersBuffer := appendSNSCanister(snsCanistersBuffer, summaryResult.root); 
          snsCanistersBuffer := appendSNSCanister(snsCanistersBuffer, summaryResult.swap); 
          snsCanistersBuffer := appendSNSCanister(snsCanistersBuffer, summaryResult.ledger); 
          snsCanistersBuffer := appendSNSCanister(snsCanistersBuffer, summaryResult.index);

          for(canister in Iter.fromArray(Buffer.toArray(snsCanistersBuffer))){
            switch(canister.canister_id){
              case (?foundCanisterId){
                let canisterTopups = Array.filter<Base.CanisterTopup>(topups, func(topup: Base.CanisterTopup){
                  topup.canisterId == Principal.toText(foundCanisterId);
                });

                switch(canister.status){
                  case (?foundStatus){

                    canistersBuffer.add({
                      canisterId = Principal.toText(foundCanisterId);
                      cycles = foundStatus.cycles;
                      computeAllocation = foundStatus.settings.compute_allocation;
                      topups = canisterTopups;
                    });

                  };
                  case (null){}
                };
              };
              case (null){}
            };
          };
        };
        case (#Manager){
          let managerCanisterIds = userManager.getUniqueManagerCanisterIds();
          for(canisterId in Iter.fromArray(managerCanisterIds)){

            let IC : Management.Management = actor (NetworkEnvironmentVariables.Default);
            let canisterInfo = await (
              IC.canister_status(
                {
                  canister_id = Principal.fromText(canisterId); 
                  num_requested_changes = null
                }),
            );

            let canisterTopups = Array.filter<Base.CanisterTopup>(topups, func(topup: Base.CanisterTopup){
              topup.canisterId == canisterId;
            });

            canistersBuffer.add({
              canisterId = canisterId;
              cycles = canisterInfo.cycles;
              computeAllocation = canisterInfo.settings.compute_allocation;
              topups = canisterTopups;
            });
          };
        };
        case (#Leaderboard){
          let leaderboardCanisterIds = leaderboardManager.getUniqueLeaderboardCanisterIds();
          for(canisterId in Iter.fromArray(leaderboardCanisterIds)){

            let IC : Management.Management = actor (NetworkEnvironmentVariables.Default);
            let canisterInfo = await (
              IC.canister_status(
                {
                  canister_id = Principal.fromText(canisterId); 
                  num_requested_changes = null
                }),
            );

            let canisterTopups = Array.filter<Base.CanisterTopup>(topups, func(topup: Base.CanisterTopup){
              topup.canisterId == canisterId;
            });

            canistersBuffer.add({
              canisterId = canisterId;
              cycles = canisterInfo.cycles;
              computeAllocation = canisterInfo.settings.compute_allocation;
              topups = canisterTopups;
            });
          };
        };
        case (#Archive){
          let summaryResult = await root_canister.get_sns_canisters_summary({update_canister_list = ?false});
          
          for (archiveCanister in Iter.fromArray(summaryResult.archives)){
            switch(archiveCanister.canister_id){
              case (?foundCanisterId){
                let canisterTopups = Array.filter<Base.CanisterTopup>(topups, func(topup: Base.CanisterTopup){
                  topup.canisterId == Principal.toText(foundCanisterId);
                });

                switch(archiveCanister.status){
                  case (?foundStatus){

                    canistersBuffer.add({
                      canisterId = Principal.toText(foundCanisterId);
                      cycles = foundStatus.cycles;
                      computeAllocation = foundStatus.settings.compute_allocation;
                      topups = canisterTopups;
                    });

                  };
                  case (null){}
                };
              };
              case (null){}
            };
          };
        };
        case (#Dapp){
          let summaryResult = await root_canister.get_sns_canisters_summary({update_canister_list = ?false});
          let dappsMinusBackend = Array.filter<Root.CanisterSummary>(
            summaryResult.dapps, 
            func(dapp: Root.CanisterSummary){
              dapp.canister_id != ?Principal.fromText(NetworkEnvironmentVariables.OPENFPL_BACKEND_CANISTER_ID);
            }
          );
          for (dappCanister in Iter.fromArray(dappsMinusBackend)){
            switch(dappCanister.canister_id){
              case (?foundCanisterId){
                let canisterTopups = Array.filter<Base.CanisterTopup>(topups, func(topup: Base.CanisterTopup){
                  topup.canisterId == Principal.toText(foundCanisterId);
                });

                switch(dappCanister.status){
                  case (?foundStatus){

                    canistersBuffer.add({
                      canisterId = Principal.toText(foundCanisterId);
                      cycles = foundStatus.cycles;
                      computeAllocation = foundStatus.settings.compute_allocation;
                      topups = canisterTopups;
                    });

                  };
                  case (null){}
                };
              };
              case (null){}
            };
          };

          //TODO: Remove after assigned to SNS
          let IC : Management.Management = actor (NetworkEnvironmentVariables.Default);
          let frontendCanisterInfo = await (
            IC.canister_status(
              {
                canister_id = Principal.fromText(Environment.FRONTEND_CANISTER_ID); 
                num_requested_changes = null
              }),
          );

          let frontendCanisterTopups = Array.filter<Base.CanisterTopup>(topups, func(topup: Base.CanisterTopup){
            topup.canisterId == Environment.FRONTEND_CANISTER_ID;
          });

          canistersBuffer.add({
            canisterId = Environment.FRONTEND_CANISTER_ID;
            cycles = frontendCanisterInfo.cycles;
            computeAllocation = frontendCanisterInfo.settings.compute_allocation;
            topups = frontendCanisterTopups;
          });

          //TODO: Remove after assigned to SNS
          let dataCanisterInfo = await (
            IC.canister_status(
              {
                canister_id = Principal.fromText(NetworkEnvironmentVariables.DATA_CANISTER_ID); 
                num_requested_changes = null
              }),
          );

          let dataCanisterTopups = Array.filter<Base.CanisterTopup>(topups, func(topup: Base.CanisterTopup){
            topup.canisterId == NetworkEnvironmentVariables.DATA_CANISTER_ID;
          });

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

    private func appendSNSCanister(buffer: Buffer.Buffer<Root.CanisterSummary>, canisterSummary: ?Root.CanisterSummary) : Buffer.Buffer<Root.CanisterSummary> {
      
      switch(canisterSummary){
        case (?foundCanister){
          buffer.add(foundCanister);     
        };
        case (null){}
      };
      return buffer;
    };

    private func checkCanisterCycles() : async () {
      let root_canister = actor (NetworkEnvironmentVariables.SNS_ROOT_CANISTER_ID) : actor {
        get_sns_canisters_summary : (request: Root.GetSnsCanistersSummaryRequest) -> async Root.GetSnsCanistersSummaryResponse;
      };

      let summaryResult = await root_canister.get_sns_canisters_summary({update_canister_list = ?false});
      let dappsMinusBackend = Array.filter<Root.CanisterSummary>(
        summaryResult.dapps, 
        func(dapp: Root.CanisterSummary){
          dapp.canister_id != ?Principal.fromText(NetworkEnvironmentVariables.OPENFPL_BACKEND_CANISTER_ID);
        }
      );
      
      for(dappCanister in Iter.fromArray(dappsMinusBackend)){
        switch(dappCanister.canister_id){
          case (?foundCanisterId){
            let ignoreCanister = 
              Principal.toText(foundCanisterId) == "bboqb-jiaaa-aaaal-qb6ea-cai" or 
              Principal.toText(foundCanisterId) == "bgpwv-eqaaa-aaaal-qb6eq-cai" or 
              Principal.toText(foundCanisterId) == "hqfmc-cqaaa-aaaal-qitcq-cai";
            if(not ignoreCanister){
              await queryAndTopupCanister(Principal.toText(foundCanisterId), 50_000_000_000_000, 25_000_000_000_000);
            }
          };
          case (null){}
        };
      };

      //TODO: Remove after assigned to SNS
      await queryAndTopupCanister(Environment.FRONTEND_CANISTER_ID, 50_000_000_000_000, 25_000_000_000_000);
      await queryAndTopupCanister(NetworkEnvironmentVariables.DATA_CANISTER_ID, 50_000_000_000_000, 25_000_000_000_000);
       
      let managerCanisterIds = userManager.getUniqueManagerCanisterIds();
      for(canisterId in Iter.fromArray(managerCanisterIds)){
        await queryAndTopupCanister(canisterId, 50_000_000_000_000, 25_000_000_000_000);
      };

      let leaderboardCanisterIds = leaderboardManager.getUniqueLeaderboardCanisterIds();
      for(canisterId in Iter.fromArray(leaderboardCanisterIds)){
        await queryAndTopupCanister(canisterId, 50_000_000_000_000, 25_000_000_000_000);
      };

      await topupCanister(summaryResult.index, 50_000_000_000_000, 25_000_000_000_000);
      await topupCanister(summaryResult.governance, 50_000_000_000_000, 25_000_000_000_000);
      await topupCanister(summaryResult.ledger, 50_000_000_000_000, 25_000_000_000_000);
      await topupCanister(summaryResult.root, 50_000_000_000_000, 25_000_000_000_000);
      await topupCanister(summaryResult.swap, 5_000_000_000_000, 2_500_000_000_000);
      for(canisterId in Iter.fromArray(summaryResult.archives)){
        await topupCanister(?canisterId, 5_000_000_000_000, 2_500_000_000_000);
      };
      
      ignore Timer.setTimer<system>(#nanoseconds(Int.abs(86_400_000_000_000)), checkCanisterCycles);
      return;
    };

    private func topupCanister(canisterSummary: ?Root.CanisterSummary, topupTriggerAmount: Nat, topupAmount: Nat) : async(){
      switch(canisterSummary){
        case (?foundCanister){
          switch(foundCanister.status){
            case (?foundStatus){
              if(foundStatus.cycles < topupTriggerAmount){
                switch(foundCanister.canister_id){
                  case (?foundCanisterId){
                    let IC : Management.Management = actor (NetworkEnvironmentVariables.Default);
                    let canisterActor = actor (Principal.toText(foundCanisterId)) : actor { };
                    await Utilities.topup_canister_(canisterActor, IC, topupAmount);
                    
                    let topupsBuffer = Buffer.fromArray<Base.CanisterTopup>(topups);
                    topupsBuffer.add({
                      canisterId = Principal.toText(foundCanisterId); 
                      cyclesAmount = topupAmount; 
                      topupTime = Time.now();
                    });
                    topups := Buffer.toArray(topupsBuffer);
                  };
                  case (null){};
                };
              };
            };
            case(null){};
          };
        };
        case (null){}
      };
    };

    private func queryAndTopupCanister(canisterId: Base.CanisterId, cyclesTriggerAmount: Nat, topupAmount: Nat) : async(){
      let IC : Management.Management = actor (NetworkEnvironmentVariables.Default);
      let canisterActor = actor (canisterId) : actor { };

      let canisterStatusResult = await Utilities.getCanisterStatus_(canisterActor, ?Principal.fromActor(Self), IC);
      
      switch(canisterStatusResult){
        case (?canisterStatus){
      
          if(canisterStatus.cycles < cyclesTriggerAmount){
            await Utilities.topup_canister_(canisterActor, IC, topupAmount);
            let topupsBuffer = Buffer.fromArray<Base.CanisterTopup>(topups);
            topupsBuffer.add({
              canisterId = canisterId; 
              cyclesAmount = topupAmount; 
              topupTime = Time.now();
            });
            topups := Buffer.toArray(topupsBuffer);
          }
        };
        case (null){};
      };
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
    private stable var stable_app_status : T.AppStatus = {
      onHold = false;
      version = "2.0.0";
    };

    private stable var stable_league_gameweek_statuses: [T.LeagueGameweekStatus] = [];
    private stable var stable_league_month_statuses: [T.LeagueMonthStatus] = [];
    private stable var stable_league_season_statuses: [T.LeagueSeasonStatus] = [];

    private stable var stable_data_hashes : [Base.DataHash] = [];
    private stable var stable_player_snapshots : [(FootballTypes.SeasonId, [(FootballTypes.GameweekNumber, [DTOs.PlayerDTO])])] = [];

    //User Manager stable variables
    private stable var stable_manager_canister_ids : [(Base.PrincipalId, Base.CanisterId)] = [];
    private stable var stable_usernames: [(Base.PrincipalId, Text)] = [];
    private stable var stable_unique_manager_canister_ids : [Base.CanisterId] = [];
    private stable var stable_total_managers : Nat = 0;
    private stable var stable_active_manager_canister_id : Base.CanisterId = "";   
    private stable var topups: [Base.CanisterTopup] = [];

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

      seasonManager.setStableAppStatus(stable_app_status);
      seasonManager.setStableDataHashes(stable_data_hashes);
      seasonManager.setStablePlayersSnapshots(stable_player_snapshots);

      userManager.setStableManagerCanisterIds(stable_manager_canister_ids);
      userManager.setStableUsernames(stable_usernames);
      userManager.setStableUniqueManagerCanisterIds(stable_unique_manager_canister_ids);
      userManager.setStableTotalManagers(stable_total_managers);
      userManager.setStableActiveManagerCanisterId(stable_active_manager_canister_id);   

      ignore Timer.setTimer<system>(#nanoseconds(Int.abs(1)), postUpgradeCallback); 
    };

    private func postUpgradeCallback() : async (){
      //await seasonManager.putOnHold();       


      //TODO (GO LIVE)
      //set system state
      //ignore setSystemTimers();
      
    
      //ignore updateLeaderboardCanisterWasms();
      //ignore updateManagerCanisterWasms();
      //await userManager.resetWeeklyTransfers();

      await seasonManager.updateDataHash("app_status");
      await seasonManager.updateDataHash("league_status");
      await seasonManager.updateDataHash("countries");
      await seasonManager.updateDataHash("clubs");
      await seasonManager.updateDataHash("fixtures");
      await seasonManager.updateDataHash("players");
      await seasonManager.updateDataHash("player_events");
      await seasonManager.updateDataHash("weekly_leaderboard");
      await seasonManager.updateDataHash("monthly_leaderboards");
      await seasonManager.updateDataHash("season_leaderboard");
      await checkCanisterCycles();
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

    private func updateLeaderboardCanisterWasms() : async (){
      let leaderboardCanisterIds = leaderboardManager.getUniqueLeaderboardCanisterIds();
      let IC : Management.Management = actor (NetworkEnvironmentVariables.Default);
      for(canisterId in Iter.fromArray(leaderboardCanisterIds)){
        await IC.stop_canister({ canister_id = Principal.fromText(canisterId); });
        let oldLeaderboard = actor (canisterId) : actor {};
        let _ = await (system LeaderboardCanister._LeaderboardCanister)(#upgrade oldLeaderboard)();
        await IC.start_canister({ canister_id = Principal.fromText(canisterId); });
      };
    };

    //Functions to be removed when handed back to SNS

    public shared query func getSystemState() : async Result.Result<ResponseDTOs.AppStatusDTO, T.Error> {
      let appStatusResult = seasonManager.getAppStatus();
      switch(appStatusResult){
        case (#ok appStatus){          
          return #ok({
            onHold = appStatus.onHold; 
            version = appStatus.version;
          }); 
        };
        case (#err error){
          return #err(error);
        }
      };
    };

    public shared ({ caller }) func updateSystemState(dto: RequestDTOs.UpdateAppStatusDTO) : async Result.Result<(), T.Error> {
      assert Principal.toText(caller) == NetworkEnvironmentVariables.FOOTBALL_GOD_BACKEND_CANISTER_ID;
      seasonManager.updateSystemStatus(dto);
      await seasonManager.updateDataHash("app_status");
      return #ok();
    };

    public shared ({ caller }) func snapshotManagers() : async Result.Result<(), T.Error> {
      assert Principal.toText(caller) == NetworkEnvironmentVariables.FOOTBALL_GOD_BACKEND_CANISTER_ID;
      let leagueStatusResult = await getLeagueStatus();
      switch(leagueStatusResult){
        case (#ok leagueStatus){

          let playersResult = await dataManager.getVerifiedPlayers(Environment.LEAGUE_ID); 
          switch(playersResult){
            case (#ok players){
              if(leagueStatus.activeGameweek > 0){
                seasonManager.storePlayersSnapshot(leagueStatus.activeSeasonId, leagueStatus.activeGameweek, players);
                let _ = await userManager.snapshotFantasyTeams(Environment.LEAGUE_ID, leagueStatus.activeSeasonId, leagueStatus.activeGameweek, leagueStatus.activeMonth);
                return #ok();
              } else{
                return #err(#InvalidData);
              };
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
      let leagueStatusResult = await getLeagueStatus();
      switch(leagueStatusResult){
        case (#ok leagueStatus){
          if(leagueStatus.activeGameweek > 0){
            let _ = await userManager.calculateFantasyTeamScores(Environment.LEAGUE_ID, leagueStatus.activeSeasonId, leagueStatus.activeGameweek, leagueStatus.activeMonth);
            return #ok();
          } else {
            let _ = await userManager.calculateFantasyTeamScores(Environment.LEAGUE_ID, leagueStatus.activeSeasonId, leagueStatus.completedGameweek, leagueStatus.activeMonth);
            return #ok();
          };          
        };  
        case (#err error){
          return #err(error);
        }
      };
    };

    public shared func getWeeklyLeaderboards() : async [T.WeeklyLeaderboard]{
       var leaderboard_canister = actor ("n26sp-cqaaa-aaaal-qna7q-cai") : actor {
        getWeeklyLeaderboards : () -> async [T.WeeklyLeaderboard];
      };

      return await leaderboard_canister.getWeeklyLeaderboards();

    };

    public shared ({ caller }) func calculateLeaderboards() : async Result.Result<(), T.Error> {
      assert Principal.toText(caller) == NetworkEnvironmentVariables.FOOTBALL_GOD_BACKEND_CANISTER_ID;
      let leagueStatusResult = await getLeagueStatus();
      switch(leagueStatusResult){
        case (#ok leagueStatus){
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
              if(leagueStatus.activeGameweek > 0){           
                let _ = leaderboardManager.calculateLeaderboards(leagueStatus.activeSeasonId, leagueStatus.activeGameweek, 0, managerCanisterIds, clubIds);
                return #ok();
              } else {
                let _ = leaderboardManager.calculateLeaderboards(leagueStatus.activeSeasonId, leagueStatus.completedGameweek, 0, managerCanisterIds, clubIds);
                return #ok();
              };          
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

    public shared ({ caller }) func calculateWeeklyRewards(gameweek: FootballTypes.GameweekNumber) : async Result.Result<(), T.Error> {
      assert Principal.toText(caller) == NetworkEnvironmentVariables.FOOTBALL_GOD_BACKEND_CANISTER_ID;
      let leagueStatusResult = await getLeagueStatus();
      switch(leagueStatusResult){
        case (#ok leagueStatus){       
          return await leaderboardManager.calculateWeeklyRewards(leagueStatus.activeSeasonId, gameweek);     };
        case (#err error){
          return #err(error);
        }
      } 
    };

    public shared ({ caller }) func payWeeklyRewards(gameweek: FootballTypes.GameweekNumber) : async Result.Result<(), T.Error> {
      assert Principal.toText(caller) == NetworkEnvironmentVariables.FOOTBALL_GOD_BACKEND_CANISTER_ID;
      let leagueStatusResult = await getLeagueStatus();
      switch(leagueStatusResult){
        case (#ok leagueStatus){       
          return await leaderboardManager.payWeeklyRewards(leagueStatus.activeSeasonId, gameweek);     
        };
        case (#err error){
          return #err(error);
        }
      } 
    };

    public shared query func getWeeklyRewards(seasonId: FootballTypes.SeasonId, gameweek: FootballTypes.GameweekNumber) : async Result.Result<ResponseDTOs.WeeklyRewardsDTO, T.Error> {
      let weeklyRewardsResult = leaderboardManager.getWeeklyRewards(seasonId, gameweek);
      switch(weeklyRewardsResult){
        case (#ok foundRewards){
          return #ok({
            gameweek = gameweek;
            seasonId = seasonId;
            rewards = List.toArray(foundRewards.rewards);
          })
        };
        case (#err _){
          return #err(#NotFound);
        }
      };
    };

    public shared query func getWeeklyCanisters() : async Result.Result<[(FootballTypes.SeasonId, [(FootballTypes.GameweekNumber, Base.CanisterId)])], T.Error> {
      return #ok(stable_weekly_leaderboard_canister_ids);
    };

    //TODO remove league id and use environent variable
    public shared ({ caller }) func notifyAppsOfLoan(leagueId: FootballTypes.LeagueId, playerId: FootballTypes.PlayerId) : async Result.Result<(), T.Error> {
      assert Principal.toText(caller) == NetworkEnvironmentVariables.DATA_CANISTER_ID;
      await userManager.removePlayerFromTeams(leagueId, playerId, Environment.BACKEND_CANISTER_ID);
      return #ok();
    };

    public shared ({ caller }) func notifyAppsOfTransfer(leagueId: FootballTypes.LeagueId, playerId: FootballTypes.PlayerId) : async Result.Result<(), T.Error> {
      assert Principal.toText(caller) == NetworkEnvironmentVariables.DATA_CANISTER_ID;
      await userManager.removePlayerFromTeams(leagueId, playerId, Environment.BACKEND_CANISTER_ID);
      return #ok();
    };

    public shared ({ caller }) func notifyAppsOfPositionChange(leagueId: FootballTypes.LeagueId, playerId: FootballTypes.PlayerId) : async Result.Result<(), T.Error> {
      assert Principal.toText(caller) == NetworkEnvironmentVariables.DATA_CANISTER_ID;
      await userManager.removePlayerFromTeams(leagueId, playerId, Environment.BACKEND_CANISTER_ID);
      return #ok();
    };

     public shared ({ caller }) func notifyAppsOfGameweekStarting() : async Result.Result<(), T.Error> {
      assert Principal.toText(caller) == NetworkEnvironmentVariables.DATA_CANISTER_ID;
      await userManager.resetWeeklyTransfers();
      return #ok();
    };
    
  };
