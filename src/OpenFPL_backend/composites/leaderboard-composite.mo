import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Cycles "mo:base/ExperimentalCycles";
import Iter "mo:base/Iter";
import List "mo:base/List";
import Nat "mo:base/Nat";
import Order "mo:base/Order";
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
import MonthlyLeaderboardCanister "../canister_definitions/monthly-leaderboard";
import SeasonLeaderboardCanister "../canister_definitions/season-leaderboard";

module {

  public class LeaderboardComposite() {
    private var seasonLeaderboardCanisters : List.List<T.SeasonLeaderboardCanister> = List.nil();
    private var monthlyLeaderboardCanisters : List.List<T.MonthlyLeaderboardCanister> = List.nil();
    private var weeklyLeaderboardCanisters : List.List<T.WeeklyLeaderboardCanister> = List.nil();

    private var storeCanisterId : ?((canisterId : Text) -> async ()) = null;
    private var backendCanisterController : ?Principal = null;

    private let MAX_ENTRIES_PER_CHUNK = 10_000;

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

    public func getMonthlyCanisterId(seasonId : T.SeasonId, month : T.CalendarMonth, clubId : T.ClubId) : async ?Text {
      let leaderboardCanisterId = List.find<T.MonthlyLeaderboardCanister>(
        monthlyLeaderboardCanisters,
        func(canister : T.MonthlyLeaderboardCanister) : Bool {
          return canister.seasonId == seasonId and canister.month == month and canister.clubId == clubId;
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

      let leaderboardCanisterId = List.find<T.MonthlyLeaderboardCanister>(
        monthlyLeaderboardCanisters,
        func(canister : T.MonthlyLeaderboardCanister) : Bool {
          return canister.seasonId == dto.seasonId and canister.month == dto.month and canister.clubId == dto.clubId;
        },
      );

      switch (leaderboardCanisterId) {
        case (null) {
          return #err(#NotFound);
        };
        case (?foundCanister) {
          let monthly_leaderboard_canister = actor (foundCanister.canisterId) : actor {
            getEntries : (filters: DTOs.PaginationFiltersDTO, searchTerm : Text) -> async ?DTOs.MonthlyLeaderboardDTO;
          };

          let leaderboardEntries = await monthly_leaderboard_canister.getEntries(dto, dto.searchTerm);
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

    public func getMonthlyLeaderboards(dto: DTOs.GetMonthlyLeaderboardsDTO, clubs : [DTOs.ClubDTO]) : async Result.Result<[DTOs.ClubLeaderboardDTO], T.Error> {

      let monthlyLeaderboardBuffer = Buffer.fromArray<DTOs.ClubLeaderboardDTO>([]);

      for (club in Iter.fromArray(clubs)) {

        let leaderboardCanisterId = List.find<T.MonthlyLeaderboardCanister>(
          monthlyLeaderboardCanisters,
          func(canister : T.MonthlyLeaderboardCanister) : Bool {
            return canister.seasonId == dto.seasonId and canister.month == dto.month and canister.clubId == club.id;
          },
        );

        switch (leaderboardCanisterId) {

          case (null) {};
          case (?foundCanister) {
            let monthly_leaderboard_canister = actor (foundCanister.canisterId) : actor {
              getEntries : (filters: DTOs.PaginationFiltersDTO) -> async ?DTOs.ClubLeaderboardDTO;
            };

            let leaderboardEntries = await monthly_leaderboard_canister.getEntries({ limit = 100; offset = 0 });
            switch (leaderboardEntries) {
              case (null) {};
              case (?foundLeaderboard) {
                monthlyLeaderboardBuffer.add(foundLeaderboard);
              };
            };
          };
        };

      };

      return #ok(Buffer.toArray(monthlyLeaderboardBuffer));
    };

    public func getSeasonLeaderboard(dto: DTOs.GetSeasonLeaderboardDTO) : async Result.Result<DTOs.SeasonLeaderboardDTO, T.Error> {

      if (dto.limit > 100) {
        return #err(#NotAllowed);
      };

      let leaderboardCanisterId = List.find<T.SeasonLeaderboardCanister>(
        monthlyLeaderboardCanisters,
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

      let leaderboardCanisterId = List.find<T.MonthlyLeaderboardCanister>(
        monthlyLeaderboardCanisters,
        func(canister : T.MonthlyLeaderboardCanister) : Bool {
          return canister.seasonId == seasonId and canister.month == month and canister.clubId == clubId;
        },
      );

      switch (leaderboardCanisterId) {
        case (null) {
          return null;
        };
        case (?foundCanister) {
          let monthly_leaderboard_canister = actor (foundCanister.canisterId) : actor {
            getEntry : (principalId : Text) -> async ?DTOs.LeaderboardEntryDTO;
          };

          let leaderboardEntry = await monthly_leaderboard_canister.getEntry(principalId);
          return leaderboardEntry;
        };
      };
    };

    public func getSeasonLeaderboardEntry(principalId : Text, seasonId : T.SeasonId) : async ?DTOs.LeaderboardEntryDTO {

      let leaderboardCanisterId = List.find<T.SeasonLeaderboardCanister>(
        monthlyLeaderboardCanisters,
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
      
      var fantasyTeamSnapshots: [T.FantasyTeamSnapshot] = [];

      for (canisterId in Iter.fromArray(uniqueManagerCanisterIds)) {
        let manager_canister = actor (canisterId) : actor {
          getOrderedSnapshots : (seasonId : T.SeasonId, gameweek : T.GameweekNumber) -> async [T.FantasyTeamSnapshot];
        };

        let orderedSnapshots = await manager_canister.getOrderedSnapshots(seasonId, gameweek);

        fantasyTeamSnapshots := mergeSortedArrays(fantasyTeamSnapshots, orderedSnapshots, compareSnapshots);
      };
      
      await calculateWeeklyLeaderboard(seasonId, gameweek, fantasyTeamSnapshots);
      await calculateMonthlyLeaderboards(seasonId, month, fantasyTeamSnapshots);
      await calculateSeasonLeaderboard(seasonId, fantasyTeamSnapshots);
    };

    private func compareSnapshots(a : T.FantasyTeamSnapshot, b : T.FantasyTeamSnapshot) : Order.Order {
      if (a.points < b.points) { return #less };
      if (a.points == b.points) { return #equal };
      return #greater;
    };

    public func mergeSortedArrays(arr1: [T.FantasyTeamSnapshot], arr2: [T.FantasyTeamSnapshot], compare: (T.FantasyTeamSnapshot, T.FantasyTeamSnapshot) -> Order.Order) : [T.FantasyTeamSnapshot] {
      let mergedArray = Array.init<T.FantasyTeamSnapshot>(arr1.size() + arr2.size(), arr1[0]);
      var i = 0;
      var j = 0;
      var k = 0;

      while (i < arr1.size() and j < arr2.size()) {
           switch (compare(arr1[i], arr2[j])) {
            case (#less or #equal) {
              mergedArray[k] := arr1[i];
              i += 1;
            };
              
            case (#greater){
                mergedArray[k] := arr2[j];
                j += 1;
            };
        };
        k += 1;
      };

      while (i < arr1.size()) {
          mergedArray[k] := arr1[i];
          i += 1;
          k += 1;
      };

      while (j < arr2.size()) {
          mergedArray[k] := arr2[j];
          j += 1;
          k += 1;
      };

      return Array.freeze(mergedArray);
    };



    private func calculateWeeklyLeaderboard(seasonId : T.SeasonId, gameweek : T.GameweekNumber, snapshots : [T.FantasyTeamSnapshot]) : async () {
      
      let existingCanisterInfo = List.find<T.WeeklyLeaderboardCanister>(weeklyLeaderboardCanisters, func (canister: T.WeeklyLeaderboardCanister) : Bool{
        return canister.seasonId == seasonId and canister.gameweek == gameweek; 
      });

      var weeklyLeaderboardCanisterId = "";

      switch(existingCanisterInfo){
        case (null){
          weeklyLeaderboardCanisterId := await createWeeklyLeaderboardCanister(seasonId, gameweek);
        };
        case (?foundCanisterInfo){
          weeklyLeaderboardCanisterId := foundCanisterInfo.canisterId;
        };
      };
      
      let gameweekEntries = Array.map<T.FantasyTeamSnapshot, T.LeaderboardEntry>(
        snapshots,
        func(snapshot) {
          return createLeaderboardEntry(snapshot.principalId, snapshot.username, snapshot.points);
        },
      );
      let sortedGameweekEntries = List.reverse(Utilities.mergeSortLeaderboard(List.fromArray(gameweekEntries)));
      let positionedGameweekEntries = Utilities.assignPositionText(sortedGameweekEntries);

      let currentGameweekLeaderboard : T.WeeklyLeaderboard = {
        seasonId = seasonId;
        gameweek = gameweek;
        entries = positionedGameweekEntries;
        totalEntries = List.size(positionedGameweekEntries);
      };

      await sendWeeklyLeaderboardToCanister(seasonId, gameweek, currentGameweekLeaderboard, weeklyLeaderboardCanisterId);      
    };

    private func createWeeklyLeaderboardCanister(seasonId : T.SeasonId, gameweek : T.GameweekNumber) : async Text {
      if (backendCanisterController == null) {
        return "";
      };

      Cycles.add<system>(2_000_000_000_000);
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

    private func sendWeeklyLeaderboardToCanister(seasonId : T.SeasonId, gameweek : T.GameweekNumber, weeklyLeaderboard: T.WeeklyLeaderboard, canisterId: T.CanisterId) : async () {
      
      let totalEntries = List.size(weeklyLeaderboard.entries);

      let leaderboard_canister = actor (canisterId) : actor {
        addLeaderboardChunk : (entriesChunk : List.List<T.LeaderboardEntry>) -> async ();
        initialise : (seasonId : T.SeasonId, gameweek : T.GameweekNumber, totalEntries : Nat) -> async ();
      };
      await leaderboard_canister.initialise(seasonId, gameweek, totalEntries);

      var numChunks : Nat = 0;
      if (totalEntries > 0) {
        numChunks := (totalEntries + MAX_ENTRIES_PER_CHUNK - 1) / MAX_ENTRIES_PER_CHUNK;
      };
      for (i in Iter.range(0, numChunks)) {
        let startIdx = i * MAX_ENTRIES_PER_CHUNK;

        let droppedEntries = List.drop<T.LeaderboardEntry>(weeklyLeaderboard.entries, startIdx);
        let leaderboardChunk = List.take<T.LeaderboardEntry>(droppedEntries, MAX_ENTRIES_PER_CHUNK);

        await leaderboard_canister.addLeaderboardChunk(leaderboardChunk);
      };
    };

    private func calculateMonthlyLeaderboards(seasonId : T.SeasonId, month : T.CalendarMonth, snapshots : [T.FantasyTeamSnapshot]) : async () {
      
      let clubGroup = groupByTeam(snapshots);

      for ((clubId, userTeams) : (T.ClubId, [T.FantasyTeamSnapshot]) in clubGroup.entries()) {

        let existingCanisterInfo = List.find<T.MonthlyLeaderboardCanister>(monthlyLeaderboardCanisters, func (canister: T.MonthlyLeaderboardCanister) : Bool{
          return canister.seasonId == seasonId and canister.month == month and canister.clubId == clubId; 
        });

        var monthlyLeaderboardCanisterId = "";

        switch(existingCanisterInfo){
          case (null){
            monthlyLeaderboardCanisterId := await createMonthlyLeaderboardCanister(seasonId, month, clubId);
          };
          case (?foundCanisterInfo){
            monthlyLeaderboardCanisterId := foundCanisterInfo.canisterId;
          };
        };

        let filteredTeams = List.filter<T.FantasyTeamSnapshot>(
          List.fromArray(userTeams),
          func(snapshot : T.FantasyTeamSnapshot) : Bool {
            return snapshot.favouriteClubId != 0;
          },
        );

        let monthEntries = List.map<T.FantasyTeamSnapshot, T.LeaderboardEntry>(
          filteredTeams,
          func(snapshot : T.FantasyTeamSnapshot) : T.LeaderboardEntry {
            return createLeaderboardEntry(snapshot.principalId, snapshot.username, snapshot.monthlyPoints);
          },
        );

        let sortedMonthEntries = List.reverse(Utilities.mergeSortLeaderboard(monthEntries));
        let positionedMonthlyEntries = Utilities.assignPositionText(sortedMonthEntries);

        let clubMonthlyLeaderboard : T.ClubLeaderboard = {
          seasonId = seasonId;
          month = month;
          clubId = clubId;
          entries = positionedMonthlyEntries;
          totalEntries = List.size(positionedMonthlyEntries);
        };
        await sendMonthlyLeaderboardToCanister(seasonId, month, clubId, clubMonthlyLeaderboard, monthlyLeaderboardCanisterId);
      };
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

    private func createMonthlyLeaderboardCanister(seasonId : T.SeasonId, month : T.CalendarMonth, clubId : T.ClubId) : async Text {

      if (backendCanisterController == null) {
        return "";
      };

      Cycles.add<system>(2_000_000_000_000);
      let canister = await MonthlyLeaderboardCanister._MonthlyLeaderboardCanister();
      let IC : Management.Management = actor (Environment.Default);
      let _ = await Utilities.updateCanister_(canister, backendCanisterController, IC);
      let canister_principal = Principal.fromActor(canister);
      let monthlyLeaderboardCanisterId = Principal.toText(canister_principal);

      let monthlyCanisterInfo : T.MonthlyLeaderboardCanister = {
        seasonId = seasonId;
        month = month;
        clubId = clubId;
        canisterId = monthlyLeaderboardCanisterId;
      };

      monthlyLeaderboardCanisters := List.append(monthlyLeaderboardCanisters, List.fromArray([monthlyCanisterInfo]));

      return monthlyLeaderboardCanisterId;
    };


    private func sendMonthlyLeaderboardToCanister(seasonId : T.SeasonId, month : T.CalendarMonth, clubId: T.ClubId, monthlyLeaderboard: T.ClubLeaderboard, canisterId: T.CanisterId) : async () {
      let totalEntries = List.size(monthlyLeaderboard.entries);

      let leaderboard_canister = actor (canisterId) : actor {
        addLeaderboardChunk : (entriesChunk : List.List<T.LeaderboardEntry>) -> async ();
        initialise : (seasonId : T.SeasonId, month : T.CalendarMonth, clubId: T.ClubId, totalEntries : Nat) -> async ();
      };
      await leaderboard_canister.initialise(seasonId, month, clubId, totalEntries);      

      var numChunks : Nat = 0;
      if (totalEntries > 0) {
        numChunks := (totalEntries + MAX_ENTRIES_PER_CHUNK - 1) / MAX_ENTRIES_PER_CHUNK;
      };
      for (i in Iter.range(0, numChunks)) {
        let startIdx = i * MAX_ENTRIES_PER_CHUNK;

        let droppedEntries = List.drop<T.LeaderboardEntry>(monthlyLeaderboard.entries, startIdx);
        let leaderboardChunk = List.take<T.LeaderboardEntry>(droppedEntries, MAX_ENTRIES_PER_CHUNK);
        await leaderboard_canister.addLeaderboardChunk(leaderboardChunk);
      };
    };

    private func calculateSeasonLeaderboard(seasonId : T.SeasonId, snapshots : [T.FantasyTeamSnapshot]) : async () {
      
      let existingCanisterInfo = List.find<T.SeasonLeaderboardCanister>(seasonLeaderboardCanisters, func (canister: T.SeasonLeaderboardCanister) : Bool{
        return canister.seasonId == seasonId; 
      });

      var seasonLeaderboardCanisterId = "";

      switch(existingCanisterInfo){
        case (null){
          seasonLeaderboardCanisterId := await createSeasonLeaderboardCanister(seasonId);
        };
        case (?foundCanisterInfo){
          seasonLeaderboardCanisterId := foundCanisterInfo.canisterId;
        };
      };
      
      
      let seasonEntries = Array.map<T.FantasyTeamSnapshot, T.LeaderboardEntry>(
        snapshots,
        func(snapshot) {
          return createLeaderboardEntry(snapshot.principalId, snapshot.username, snapshot.seasonPoints);
        },
      );
      let sortedSeasonEntries = List.reverse(Utilities.mergeSortLeaderboard(List.fromArray(seasonEntries)));
      let positionedSeasonEntries = Utilities.assignPositionText(sortedSeasonEntries);

      let currentSeasonLeaderboard : T.SeasonLeaderboard = {
        seasonId = seasonId;
        entries = positionedSeasonEntries;
        totalEntries = List.size(positionedSeasonEntries);
      };

      await sendSeasonLeaderboardToCanister(seasonId, currentSeasonLeaderboard, seasonLeaderboardCanisterId);      
    };

    private func createSeasonLeaderboardCanister(seasonId : T.SeasonId) : async Text {
      if (backendCanisterController == null) {
        return "";
      };

      Cycles.add<system>(2_000_000_000_000);
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


    private func sendSeasonLeaderboardToCanister(seasonId : T.SeasonId, seasonLeaderboard: T.SeasonLeaderboard, canisterId: T.CanisterId) : async () {
      let totalEntries = List.size(seasonLeaderboard.entries);

      let leaderboard_canister = actor (canisterId) : actor {
        addLeaderboardChunk : (entriesChunk : List.List<T.LeaderboardEntry>) -> async ();
        initialise : (seasonId : T.SeasonId, totalEntries : Nat) -> async ();
      };
      await leaderboard_canister.initialise(seasonId, totalEntries);      

      var numChunks : Nat = 0;
      if (totalEntries > 0) {
        numChunks := (totalEntries + MAX_ENTRIES_PER_CHUNK - 1) / MAX_ENTRIES_PER_CHUNK;
      };
      for (i in Iter.range(0, numChunks)) {
        let startIdx = i * MAX_ENTRIES_PER_CHUNK;

        let droppedEntries = List.drop<T.LeaderboardEntry>(seasonLeaderboard.entries, startIdx);
        let leaderboardChunk = List.take<T.LeaderboardEntry>(droppedEntries, MAX_ENTRIES_PER_CHUNK);
        await leaderboard_canister.addLeaderboardChunk(leaderboardChunk);
      };
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

    public func getStableMonthlyLeaderboardCanisters() : [T.MonthlyLeaderboardCanister] {
      return List.toArray(monthlyLeaderboardCanisters);
    };

    public func setStableMonthlyLeaderboardCanisters(stable_monthly_leaderboard_canisters : [T.MonthlyLeaderboardCanister]) {
      monthlyLeaderboardCanisters := List.fromArray(stable_monthly_leaderboard_canisters);
    };

    public func getStableWeeklyLeaderboardCanisters() : [T.WeeklyLeaderboardCanister] {
      return List.toArray(weeklyLeaderboardCanisters);
    };

    public func setStableWeeklyLeaderboardCanisters(stable_weekly_leaderboard_canisters : [T.WeeklyLeaderboardCanister]) {
      weeklyLeaderboardCanisters := List.fromArray(stable_weekly_leaderboard_canisters);
    };

  };
};
