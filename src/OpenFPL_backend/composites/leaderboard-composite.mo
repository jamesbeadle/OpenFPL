import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Cycles "mo:base/ExperimentalCycles";
import Iter "mo:base/Iter";
import List "mo:base/List";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Text "mo:base/Text";
import TrieMap "mo:base/TrieMap";

import DTOs "../DTOs";
import Environment "../utils/Environment";
import Management "../modules/Management";
import PrivateLeaguesManager "../private-leagues-manager";
import T "../types";
import Utilities "../utils/utilities";

import WeeklyLeaderboardCanister "../canister_definitions/weekly-leaderboard";
import MonthlyLeaderboardsCanister "../canister_definitions/monthly-leaderboards";
import SeasonLeaderboardCanister "../canister_definitions/season-leaderboard";

module {

  public class LeaderboardComposite() {
    private var seasonLeaderboardCanisters : List.List<T.SeasonLeaderboardCanister> = List.nil();
    private var monthlyLeaderboardsCanisters : List.List<T.MonthlyLeaderboardsCanister> = List.nil();
    private var weeklyLeaderboardCanisters : List.List<T.WeeklyLeaderboardCanister> = List.nil();

    private var storeCanisterId : ?((canisterId : Text) -> async ()) = null;
    private var backendCanisterController : ?Principal = null;
    private var recordSystemEvent : ?((eventLog: T.EventLogEntry) -> ()) = null;
    public func setRecordSystemEventFunction(
      _recordSystemEvent : ((eventLog: T.EventLogEntry) -> ()),
    ) {
      recordSystemEvent := ?_recordSystemEvent;
    };

    public func setStoreCanisterIdFunction(
      _storeCanisterId : (canisterId : Text) -> async (),
    ) {
      storeCanisterId := ?_storeCanisterId;
    };

    public func setBackendCanisterController(controller : Principal) {
      backendCanisterController := ?controller;
    };

    public func getWeeklyCanisterId(seasonId : T.SeasonId, gameweek : T.GameweekNumber) : async ?Text {
      let leaderboardCanisterId = List.find<T.WeeklyLeaderboardCanister>(
        weeklyLeaderboardCanisters,
        func(canister : T.WeeklyLeaderboardCanister) : Bool {
          return canister.seasonId == seasonId and canister.gameweek == gameweek;
        },
      );

      switch (leaderboardCanisterId) {
        case (null) { return null };
        case (?foundCanister) {
          return ?foundCanister.canisterId;
        };
      };
    };

    public func getMonthlyCanisterId(seasonId : T.SeasonId, month : T.CalendarMonth) : async ?Text {
      let leaderboardCanisterId = List.find<T.MonthlyLeaderboardsCanister>(
        monthlyLeaderboardsCanisters,
        func(canister : T.MonthlyLeaderboardsCanister) : Bool {
          return canister.seasonId == seasonId and canister.month == month
        },
      );

      switch (leaderboardCanisterId) {
        case (null) { return null };
        case (?foundCanister) {
          return ?foundCanister.canisterId;
        };
      };
    };

    public func getSeasonCanisterId(seasonId : T.SeasonId) : async ?Text {
      let leaderboardCanisterId = List.find<T.SeasonLeaderboardCanister>(
        seasonLeaderboardCanisters,
        func(canister : T.SeasonLeaderboardCanister) : Bool {
          return canister.seasonId == seasonId;
        },
      );

      switch (leaderboardCanisterId) {
        case (null) { return null };
        case (?foundCanister) {
          return ?foundCanister.canisterId;
        };
      };
    };

    public func getWeeklyLeaderboard(dto: DTOs.GetWeeklyLeaderboardDTO) : async Result.Result<DTOs.WeeklyLeaderboardDTO, T.Error> {
      if (dto.limit > 100) {
        return #err(#NotAllowed);
      };

      let leaderboardCanisterId = List.find<T.WeeklyLeaderboardCanister>(
        weeklyLeaderboardCanisters,
        func(canister : T.WeeklyLeaderboardCanister) : Bool {
          return canister.seasonId == dto.seasonId and canister.gameweek == dto.gameweek;
        },
      );

      switch (leaderboardCanisterId) {
        case (null) {
          return #err(#NotFound);
        };
        case (?foundCanister) {
          let weekly_leaderboard_canister = actor (foundCanister.canisterId) : actor {
            getEntries : (filters: DTOs.PaginationFiltersDTO, searchTerm : Text) -> async ?DTOs.WeeklyLeaderboardDTO;
          };

          let leaderboardEntries = await weekly_leaderboard_canister.getEntries(dto, dto.searchTerm);
          switch (leaderboardEntries) {
            case (null) {
              return #err(#NotFound);
            };
            case (?foundLeaderboard) {
              return #ok(foundLeaderboard);
            };
          };
        };
      };
    };

    public func getMonthlyLeaderboard(dto: DTOs.GetMonthlyLeaderboardDTO) : async Result.Result<DTOs.MonthlyLeaderboardDTO, T.Error> {

      if (dto.limit > 100) {
        return #err(#NotAllowed);
      };

      let leaderboardsCanisterId = List.find<T.MonthlyLeaderboardsCanister>(
        monthlyLeaderboardsCanisters,
        func(canister : T.MonthlyLeaderboardsCanister) : Bool {
          return canister.seasonId == dto.seasonId and canister.month == dto.month
        },
      );

      switch (leaderboardsCanisterId) {
        case (null) {
          return #err(#NotFound);
        };
        case (?foundCanister) {
          let monthly_leaderboard_canister = actor (foundCanister.canisterId) : actor {
            getEntries : (filters: DTOs.PaginationFiltersDTO, clubId: T.ClubId, searchTerm : Text) -> async ?DTOs.MonthlyLeaderboardDTO;
          };

          let leaderboardEntries = await monthly_leaderboard_canister.getEntries(dto, dto.clubId, dto.searchTerm);
          switch (leaderboardEntries) {
            case (null) {
              return #err(#NotFound);
            };
            case (?foundLeaderboard) {
              return #ok(foundLeaderboard);
            };
          };
        };
      };
    };

    public func getSeasonLeaderboard(dto: DTOs.GetSeasonLeaderboardDTO) : async Result.Result<DTOs.SeasonLeaderboardDTO, T.Error> {

      if (dto.limit > 100) {
        return #err(#NotAllowed);
      };

      let leaderboardCanisterId = List.find<T.SeasonLeaderboardCanister>(
        seasonLeaderboardCanisters,
        func(canister : T.SeasonLeaderboardCanister) : Bool {
          return canister.seasonId == dto.seasonId;
        },
      );

      switch (leaderboardCanisterId) {
        case (null) {
          return #err(#NotFound);
        };
        case (?foundCanister) {
          let season_leaderboard_canister = actor (foundCanister.canisterId) : actor {
            getEntries : (filters: DTOs.PaginationFiltersDTO, searchTerm : Text) -> async ?DTOs.SeasonLeaderboardDTO;
          };

          let leaderboardEntries = await season_leaderboard_canister.getEntries(dto, dto.searchTerm);
          switch (leaderboardEntries) {
            case (null) {
              return #err(#NotFound);
            };
            case (?foundLeaderboard) {
              return #ok(foundLeaderboard);
            };
          };
        };
      };
    };

    public func getWeeklyLeaderboardEntry(principalId : Text, seasonId : T.SeasonId, gameweek : T.GameweekNumber) : async ?DTOs.LeaderboardEntryDTO {

      let leaderboardCanisterId = List.find<T.WeeklyLeaderboardCanister>(
        weeklyLeaderboardCanisters,
        func(canister : T.WeeklyLeaderboardCanister) : Bool {
          return canister.seasonId == seasonId and canister.gameweek == gameweek;
        },
      );

      switch (leaderboardCanisterId) {
        case (null) {
          return null;
        };
        case (?foundCanister) {
          let weekly_leaderboard_canister = actor (foundCanister.canisterId) : actor {
            getEntry : (principalId : Text) -> async ?DTOs.LeaderboardEntryDTO;
          };

          let leaderboardEntry = await weekly_leaderboard_canister.getEntry(principalId);
          return leaderboardEntry;
        };
      };
    };

    public func getMonthlyLeaderboardEntry(principalId : Text, seasonId : T.SeasonId, month : T.CalendarMonth, clubId : T.ClubId) : async ?DTOs.LeaderboardEntryDTO {

      let leaderboardCanisterId = List.find<T.MonthlyLeaderboardsCanister>(
        monthlyLeaderboardsCanisters,
        func(canister : T.MonthlyLeaderboardsCanister) : Bool {
          return canister.seasonId == seasonId and canister.month == month
        },
      );

      switch (leaderboardCanisterId) {
        case (null) {
          return null;
        };
        case (?foundCanister) {
          let monthly_leaderboard_canister = actor (foundCanister.canisterId) : actor {
            getEntry : (principalId : Text, clubid: T.ClubId) -> async ?DTOs.LeaderboardEntryDTO;
          };

          let leaderboardEntry = await monthly_leaderboard_canister.getEntry(principalId, clubId);
          return leaderboardEntry;
        };
      };
    };

    public func getSeasonLeaderboardEntry(principalId : Text, seasonId : T.SeasonId) : async ?DTOs.LeaderboardEntryDTO {

      let leaderboardCanisterId = List.find<T.SeasonLeaderboardCanister>(
        seasonLeaderboardCanisters,
        func(canister : T.SeasonLeaderboardCanister) : Bool {
          return canister.seasonId == seasonId;
        },
      );

      switch (leaderboardCanisterId) {
        case (null) {
          return null;
        };
        case (?foundCanister) {
          let season_leaderboard_canister = actor (foundCanister.canisterId) : actor {
            getEntry : (principalId : Text) -> async ?DTOs.LeaderboardEntryDTO;
          };

          let leaderboardEntry = await season_leaderboard_canister.getEntry(principalId);
          return leaderboardEntry;
        };
      };
    };

    public func calculateLeaderboards(seasonId : T.SeasonId, gameweek : T.GameweekNumber, month : T.CalendarMonth, uniqueManagerCanisterIds : [T.CanisterId]) : async () {
      
      let weeklyLeaderboardCanister = List.find<T.WeeklyLeaderboardCanister>(weeklyLeaderboardCanisters, 
        func (canister: T.WeeklyLeaderboardCanister) : Bool{
          return canister.seasonId == seasonId and canister.gameweek == gameweek; 
        }
      );

      let monthlyLeaderboardCanister = List.find<T.MonthlyLeaderboardsCanister>(monthlyLeaderboardsCanisters, 
        func (canister: T.MonthlyLeaderboardsCanister) : Bool{
          return canister.seasonId == seasonId and canister.month == month; 
        }
      );

      let seasonLeaderboardCanister = List.find<T.SeasonLeaderboardCanister>(seasonLeaderboardCanisters, 
        func (canister: T.SeasonLeaderboardCanister) : Bool{
          return canister.seasonId == seasonId; 
        }
      );

      var weeklyLeaderboardCanisterId = "";
      var monthlyLeaderboardCanisterId = "";
      var seasonLeaderboardCanisterId = "";

      switch(weeklyLeaderboardCanister){
        case (null){
          weeklyLeaderboardCanisterId := await createWeeklyLeaderboardCanister(seasonId, gameweek);
        };
        case (?foundCanisterInfo){
          weeklyLeaderboardCanisterId := foundCanisterInfo.canisterId;
        };
      };

      switch(monthlyLeaderboardCanister){
        case (null){
          monthlyLeaderboardCanisterId := await createMonthlyLeaderboardsCanister(seasonId, month);
        };
        case (?foundCanisterInfo){
          monthlyLeaderboardCanisterId := foundCanisterInfo.canisterId;
        };
      };

      switch(seasonLeaderboardCanister){
        case (null){
          seasonLeaderboardCanisterId := await createSeasonLeaderboardCanister(seasonId);
        };
        case (?foundCanisterInfo){
          seasonLeaderboardCanisterId := foundCanisterInfo.canisterId;
        };
      };

      let weekly_leaderboard_canister = actor (weeklyLeaderboardCanisterId) : actor {
        addLeaderboardChunk : (entriesChunk : [T.LeaderboardEntry]) -> async ();
        prepareForUpdate : () -> async ();
        finaliseUpdate : () -> async ();
      };

      let monthly_leaderboard_canister = actor (monthlyLeaderboardCanisterId) : actor {
        addLeaderboardChunk : (clubId: T.ClubId, entriesChunk : [T.LeaderboardEntry]) -> async ();
        prepareForUpdate : () -> async ();
        finaliseUpdate : () -> async ();
      };

      let season_leaderboard_canister = actor (seasonLeaderboardCanisterId) : actor {
        addLeaderboardChunk : (entriesChunk : [T.LeaderboardEntry]) -> async ();
        prepareForUpdate : () -> async ();
        finaliseUpdate : () -> async ();
      };

      await weekly_leaderboard_canister.prepareForUpdate();
      await monthly_leaderboard_canister.prepareForUpdate();
      await season_leaderboard_canister.prepareForUpdate();

      for (canisterId in Iter.fromArray(uniqueManagerCanisterIds)) {
        let manager_canister = actor (canisterId) : actor {
          getOrderedSnapshots : (seasonId : T.SeasonId, gameweek : T.GameweekNumber) -> async [T.FantasyTeamSnapshot];
        };

        let orderedSnapshots = await manager_canister.getOrderedSnapshots(seasonId, gameweek);
        
        let groupedByTeam = groupByTeam(orderedSnapshots);

        for(team in groupedByTeam.entries(
        )){
          let fantasyTeamSnapshots = team.1;

          let leaderboardEntries = Array.map<T.FantasyTeamSnapshot, T.LeaderboardEntry>(
          fantasyTeamSnapshots,
            func(snapshot) {
              return createLeaderboardEntry(snapshot.principalId, snapshot.username, snapshot.points);
            },
          );
          await weekly_leaderboard_canister.addLeaderboardChunk(leaderboardEntries);
          await monthly_leaderboard_canister.addLeaderboardChunk(team.0, leaderboardEntries);
          await season_leaderboard_canister.addLeaderboardChunk(leaderboardEntries);
        };
      };

      await weekly_leaderboard_canister.finaliseUpdate();
      await monthly_leaderboard_canister.finaliseUpdate();
      await season_leaderboard_canister.finaliseUpdate();
    };

    private func groupByTeam(snapshots : [T.FantasyTeamSnapshot]) : TrieMap.TrieMap<T.ClubId, [T.FantasyTeamSnapshot]> {
      let groupedTeams : TrieMap.TrieMap<T.ClubId, [T.FantasyTeamSnapshot]> = TrieMap.TrieMap<T.ClubId, [T.FantasyTeamSnapshot]>(Utilities.eqNat16, Utilities.hashNat16);

      for (fantasyTeam in Iter.fromArray(snapshots)) {
        let teamId = fantasyTeam.favouriteClubId;
        switch (groupedTeams.get(teamId)) {
          case null {
            groupedTeams.put(teamId, [fantasyTeam]);
          };
          case (?existingEntries) {
            let updatedEntries = Buffer.fromArray<T.FantasyTeamSnapshot>(existingEntries);
            updatedEntries.add(fantasyTeam);
            groupedTeams.put(teamId, Buffer.toArray(updatedEntries));
          };
        };
      };

      return groupedTeams;
    };

    private func createWeeklyLeaderboardCanister(seasonId : T.SeasonId, gameweek : T.GameweekNumber) : async Text {
      if (backendCanisterController == null) {
        return "";
      };

      Cycles.add<system>(10_000_000_000_000);
      let canister = await WeeklyLeaderboardCanister._WeeklyLeaderboardCanister();
      let IC : Management.Management = actor (Environment.Default);
      let _ = await Utilities.updateCanister_(canister, backendCanisterController, IC);
      let canister_principal = Principal.fromActor(canister);
      let weeklyLeaderboardCanisterId = Principal.toText(canister_principal);

      let gameweekCanisterInfo : T.WeeklyLeaderboardCanister = {
        seasonId = seasonId;
        gameweek = gameweek;
        canisterId = weeklyLeaderboardCanisterId;
      };

      weeklyLeaderboardCanisters := List.append(weeklyLeaderboardCanisters, List.fromArray([gameweekCanisterInfo]));

      return weeklyLeaderboardCanisterId;
    };

    private func createMonthlyLeaderboardsCanister(seasonId : T.SeasonId, month : T.CalendarMonth) : async Text {

      if (backendCanisterController == null) {
        return "";
      };

      Cycles.add<system>(10_000_000_000_000);
      let canister = await MonthlyLeaderboardsCanister._MonthlyLeaderboardsCanister();
      let IC : Management.Management = actor (Environment.Default);
      let _ = await Utilities.updateCanister_(canister, backendCanisterController, IC);
      let canister_principal = Principal.fromActor(canister);
      let monthlyLeaderboardsCanisterId = Principal.toText(canister_principal);

      let monthlyCanisterInfo : T.MonthlyLeaderboardsCanister = {
        seasonId = seasonId;
        month = month;
        canisterId = monthlyLeaderboardsCanisterId;
      };

      monthlyLeaderboardsCanisters := List.append(monthlyLeaderboardsCanisters, List.fromArray([monthlyCanisterInfo]));

      return monthlyLeaderboardsCanisterId;
    };

    private func createSeasonLeaderboardCanister(seasonId : T.SeasonId) : async Text {
      if (backendCanisterController == null) {
        return "";
      };

      Cycles.add<system>(10_000_000_000_000);
      let canister = await SeasonLeaderboardCanister._SeasonLeaderboardCanister();
      let IC : Management.Management = actor (Environment.Default);
      let _ = await Utilities.updateCanister_(canister, backendCanisterController, IC);
      let canister_principal = Principal.fromActor(canister);
      let seasonLeaderboardCanisterId = Principal.toText(canister_principal);

      let seasonCanisterInfo : T.SeasonLeaderboardCanister = {
        seasonId = seasonId;
        canisterId = seasonLeaderboardCanisterId;
      };

      seasonLeaderboardCanisters := List.append(seasonLeaderboardCanisters, List.fromArray([seasonCanisterInfo]));

      return seasonLeaderboardCanisterId;
    };

    private func createLeaderboardEntry(principalId : Text, username : Text, points : Int16) : T.LeaderboardEntry {
      return {
        position = 0;
        positionText = "";
        username = username;
        principalId = principalId;
        points = points;
      };
    };

    public func getStableSeasonLeaderboardCanisters() : [T.SeasonLeaderboardCanister] {
      return List.toArray(seasonLeaderboardCanisters);
    };

    public func setStableSeasonLeaderboardCanisters(stable_season_leaderboard_canisters : [T.SeasonLeaderboardCanister]) {
      seasonLeaderboardCanisters := List.fromArray(stable_season_leaderboard_canisters);
    };

    public func getStableMonthlyLeaderboardsCanisters() : [T.MonthlyLeaderboardsCanister] {
      return List.toArray(monthlyLeaderboardsCanisters);
    };

    public func setStableMonthlyLeaderboardsCanisters(stable_monthly_leaderboards_canisters : [T.MonthlyLeaderboardsCanister]) {
      monthlyLeaderboardsCanisters := List.fromArray(stable_monthly_leaderboards_canisters);
    };

    public func getStableWeeklyLeaderboardCanisters() : [T.WeeklyLeaderboardCanister] {
      return List.toArray(weeklyLeaderboardCanisters);
    };

    public func setStableWeeklyLeaderboardCanisters(stable_weekly_leaderboard_canisters : [T.WeeklyLeaderboardCanister]) {
      weeklyLeaderboardCanisters := List.fromArray(stable_weekly_leaderboard_canisters);
    };

    public func removeLeaderboardCanistersAndGetCycles() : async (){
      
      let IC : Management.Management = actor (Environment.Default);
      for (canister in Iter.fromList(weeklyLeaderboardCanisters)){
        let _ = await Utilities.deleteCanister_(canister.canisterId, IC);
      };

      for (canister in Iter.fromList(monthlyLeaderboardsCanisters)){
        let _ = await Utilities.deleteCanister_(canister.canisterId, IC);
      };

      for (canister in Iter.fromList(seasonLeaderboardCanisters)){
        let _ = await Utilities.deleteCanister_(canister.canisterId, IC);
      };

      seasonLeaderboardCanisters := List.nil();
      monthlyLeaderboardsCanisters := List.nil();
      weeklyLeaderboardCanisters := List.nil();      
    };

    

  };
};
