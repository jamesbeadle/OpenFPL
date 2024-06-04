import T "../types";
import DTOs "../DTOs";
import Result "mo:base/Result";
import Iter "mo:base/Iter";
import List "mo:base/List";
import Array "mo:base/Array";
import Principal "mo:base/Principal";
import Utilities "../utils/utilities";
import Management "../modules/Management";
import Environment "../utils/Environment";
import Cycles "mo:base/ExperimentalCycles";
import Buffer "mo:base/Buffer";
import TrieMap "mo:base/TrieMap";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Order "mo:base/Order";
import WeeklyLeaderboardCanister "../canister_definitions/weekly-leaderboard";
import MonthlyLeaderboardCanister "../canister_definitions/monthly-leaderboard";
import SeasonLeaderboardCanister "../canister_definitions/season-leaderboard";
import PrivateLeaguesManager "../private-leagues-manager";

module {

  public class LeaderboardComposite() {
    private var seasonLeaderboardCanisters : List.List<T.SeasonLeaderboardCanister> = List.nil();
    private var monthlyLeaderboardCanisters : List.List<T.MonthlyLeaderboardCanister> = List.nil();
    private var weeklyLeaderboardCanisters : List.List<T.WeeklyLeaderboardCanister> = List.nil();

    private var storeCanisterId : ?((canisterId : Text) -> async ()) = null;
    private var backendCanisterController : ?Principal = null;

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
      
      await calculateWeeklyLeaderboards(seasonId, gameweek, fantasyTeamSnapshots);
      await calculateMonthlyLeaderboards(seasonId, gameweek, month, fantasyTeamSnapshots);
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

    private func calculateWeeklyLeaderboards(seasonId : T.SeasonId, gameweek : T.GameweekNumber, snapshots : [T.FantasyTeamSnapshot]) : async () {
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

      let gameweekLeaderboardCanisterId = await createWeeklyLeaderboardCanister(seasonId, gameweek, currentGameweekLeaderboard);

      let gameweekCanisterInfo : T.WeeklyLeaderboardCanister = {
        seasonId = seasonId;
        gameweek = gameweek;
        canisterId = gameweekLeaderboardCanisterId;
      };

      weeklyLeaderboardCanisters := List.append(weeklyLeaderboardCanisters, List.fromArray([gameweekCanisterInfo]));
    };

    private func calculateMonthlyLeaderboards(seasonId : T.SeasonId, gameweek : T.GameweekNumber, month : T.CalendarMonth, snapshots : [T.FantasyTeamSnapshot]) : async () {
      let clubGroup = groupByTeam(snapshots);

      var updatedLeaderboards = List.nil<T.ClubLeaderboard>();

      for ((clubId, userTeams) : (T.ClubId, [T.FantasyTeamSnapshot]) in clubGroup.entries()) {

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

        updatedLeaderboards := List.append<T.ClubLeaderboard>(updatedLeaderboards, List.fromArray([clubMonthlyLeaderboard]));
      };

      for (leaderboard in Iter.fromList(updatedLeaderboards)) {
        let monthlyLeaderboardCanisterId = await createMonthlyLeaderboardCanister(seasonId, month, leaderboard.clubId, leaderboard);

        let clubCanisterInfo : T.MonthlyLeaderboardCanister = {
          seasonId = seasonId;
          month = gameweek;
          clubId = leaderboard.clubId;
          canisterId = monthlyLeaderboardCanisterId;
        };
        monthlyLeaderboardCanisters := List.append(monthlyLeaderboardCanisters, List.fromArray([clubCanisterInfo]));
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

    private func calculateSeasonLeaderboard(seasonId : T.SeasonId, snapshots : [T.FantasyTeamSnapshot]) : async () {
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

      let seasonLeaderboardCanisterId = await createSeasonLeaderboardCanister(seasonId, currentSeasonLeaderboard);
      let sesasonCanisterInfo : T.SeasonLeaderboardCanister = {
        seasonId = seasonId;
        canisterId = seasonLeaderboardCanisterId;
      };
      seasonLeaderboardCanisters := List.append(seasonLeaderboardCanisters, List.fromArray([sesasonCanisterInfo]));
    };

    private func createWeeklyLeaderboardCanister(seasonId : T.SeasonId, gameweek : T.GameweekNumber, weeklyLeaderboard : T.WeeklyLeaderboard) : async Text {
      if (backendCanisterController == null) {
        return "";
      };

      let maxEntriesPerChunk = 10_000;

      Cycles.add<system>(2_000_000_000_000);
      let canister = await WeeklyLeaderboardCanister._WeeklyLeaderboardCanister();
      let IC : Management.Management = actor (Environment.Default);
      let _ = await Utilities.updateCanister_(canister, backendCanisterController, IC);
      let canister_principal = Principal.fromActor(canister);

      let totalEntries = List.size(weeklyLeaderboard.entries);
      await canister.createCanister(seasonId, gameweek, totalEntries);

      var numChunks : Nat = 0;
      if (totalEntries > 0) {
        numChunks := (totalEntries + maxEntriesPerChunk - 1) / maxEntriesPerChunk;
      };
      for (i in Iter.range(0, numChunks)) {
        let startIdx = i * maxEntriesPerChunk;

        let droppedEntries = List.drop<T.LeaderboardEntry>(weeklyLeaderboard.entries, startIdx);
        let leaderboardChunk = List.take<T.LeaderboardEntry>(droppedEntries, maxEntriesPerChunk);
        await canister.addLeaderboardChunk(leaderboardChunk);
      };

      let canisterId = Principal.toText(canister_principal);

      switch (storeCanisterId) {
        case (null) {};
        case (?actualFunction) {
          await actualFunction(canisterId);
        };
      };

      return canisterId;
    };

    private func createMonthlyLeaderboardCanister(seasonId : T.SeasonId, month : T.CalendarMonth, clubId : T.ClubId, monthlyLeaderboard : T.ClubLeaderboard) : async Text {

      if (backendCanisterController == null) {
        return "";
      };

      let maxEntriesPerChunk = 10_000;

      Cycles.add<system>(2_000_000_000_000);
      let canister = await MonthlyLeaderboardCanister._MonthlyLeaderboardCanister();
      let IC : Management.Management = actor (Environment.Default);
      let _ = await Utilities.updateCanister_(canister, backendCanisterController, IC);
      let canister_principal = Principal.fromActor(canister);

      let totalEntries = List.size(monthlyLeaderboard.entries);
      await canister.createCanister(seasonId, month, clubId, totalEntries);

      var numChunks : Nat = 0;
      if (totalEntries > 0) {
        numChunks := (totalEntries + maxEntriesPerChunk - 1) / maxEntriesPerChunk;
      };
      for (i in Iter.range(0, numChunks)) {
        let startIdx = i * maxEntriesPerChunk;

        let droppedEntries = List.drop<T.LeaderboardEntry>(monthlyLeaderboard.entries, startIdx);
        let leaderboardChunk = List.take<T.LeaderboardEntry>(droppedEntries, maxEntriesPerChunk);
        await canister.addLeaderboardChunk(leaderboardChunk);
      };

      let canisterId = Principal.toText(canister_principal);

      switch (storeCanisterId) {
        case (null) {};
        case (?actualFunction) {
          await actualFunction(canisterId);
        };
      };

      return canisterId;
    };

    private func createSeasonLeaderboardCanister(seasonId : T.SeasonId, seasonLeaderboard : T.SeasonLeaderboard) : async Text {

      if (backendCanisterController == null) {
        return "";
      };

      let maxEntriesPerChunk = 10_000;

      Cycles.add<system>(2_000_000_000_000);
      let canister = await SeasonLeaderboardCanister._SeasonLeaderboardCanister();
      let IC : Management.Management = actor (Environment.Default);
      let _ = await Utilities.updateCanister_(canister, backendCanisterController, IC);
      let canister_principal = Principal.fromActor(canister);

      let totalEntries = List.size(seasonLeaderboard.entries);
      await canister.createCanister(seasonId, totalEntries);

      var numChunks : Nat = 0;
      if (totalEntries > 0) {
        numChunks := (totalEntries + maxEntriesPerChunk - 1) / maxEntriesPerChunk;
      };
      for (i in Iter.range(0, numChunks)) {
        let startIdx = i * maxEntriesPerChunk;

        let droppedEntries = List.drop<T.LeaderboardEntry>(seasonLeaderboard.entries, startIdx);
        let leaderboardChunk = List.take<T.LeaderboardEntry>(droppedEntries, maxEntriesPerChunk);
        await canister.addLeaderboardChunk(leaderboardChunk);
      };

      let canisterId = Principal.toText(canister_principal);

      switch (storeCanisterId) {
        case (null) {};
        case (?actualFunction) {
          await actualFunction(canisterId);
        };
      };

      return canisterId;
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

    public func sendWeeklyLeaderboardEntries(privateLeaguesManager: PrivateLeaguesManager.PrivateLeaguesManager, filters: DTOs.GameweekFiltersDTO, managerCanisterIdIndex: TrieMap.TrieMap<T.PrincipalId, T.CanisterId>) : async () {

      let weeklyLeaderboardCanister = List.find<T.WeeklyLeaderboardCanister>(
        weeklyLeaderboardCanisters,
        func(weeklyLeaderboard : T.WeeklyLeaderboardCanister) : Bool {
          return weeklyLeaderboard.seasonId == filters.seasonId and weeklyLeaderboard.gameweek == filters.gameweek;
        },
      );

      switch(weeklyLeaderboardCanister){
        case (null) {};
        case(?foundCanisterInfo){
          let weekly_leaderboard_canister = actor (foundCanisterInfo.canisterId) : actor {
            getEntries : (filters: DTOs.PaginationFiltersDTO, searchTerm : Text) -> async ?DTOs.WeeklyLeaderboardDTO;
            getTotalEntries : () -> async Nat;
          };

          let totalEntries = await weekly_leaderboard_canister.getTotalEntries();
          let chunkSize : Nat = 1000;
          var offset : Nat = 0;

          label here loop {
            if (offset >= totalEntries) {
              break here;
            };

            let entriesDTO = await weekly_leaderboard_canister.getEntries({ limit = chunkSize; offset }, "");
            switch (entriesDTO) {
              case (?dto) {
                await privateLeaguesManager.sendWeeklyLeaderboardEntries(filters, dto.entries, managerCanisterIdIndex);
              };
              case (null) { };
            };

            offset += chunkSize;
          } while (offset < totalEntries);
        };
      };
    };

    public func sendMonthlyLeaderboardEntries(privateLeaguesManager: PrivateLeaguesManager.PrivateLeaguesManager, seasonId: T.SeasonId, month: T.CalendarMonth, managerCanisterIdIndex: TrieMap.TrieMap<T.PrincipalId, T.CanisterId>) : async () {

      let monthlyLeaderboardCanister = List.find<T.MonthlyLeaderboardCanister>(
        monthlyLeaderboardCanisters,
        func(monthlyLeaderboard : T.MonthlyLeaderboardCanister) : Bool {
          return monthlyLeaderboard.seasonId == seasonId and monthlyLeaderboard.month == month;
        },
      );

      switch(monthlyLeaderboardCanister){
        case (null) {};
        case(?foundCanisterInfo){
          let monthly_leaderboard_canister = actor (foundCanisterInfo.canisterId) : actor {
            getEntries : (filters: DTOs.PaginationFiltersDTO, searchTerm : Text) -> async ?DTOs.MonthlyLeaderboardDTO;
            getTotalEntries : () -> async Nat;
          };

          let totalEntries = await monthly_leaderboard_canister.getTotalEntries();
          let chunkSize : Nat = 1000;
          var offset : Nat = 0;

          label here loop {
            if (offset >= totalEntries) {
              break here;
            };

            let entriesDTO = await monthly_leaderboard_canister.getEntries({limit = chunkSize; offset }, "");
            switch (entriesDTO) {
              case (?dto) {
                await privateLeaguesManager.sendMonthlyLeaderboardEntries(seasonId, month, dto.entries, managerCanisterIdIndex);
              };
              case (null) { };
            };

            offset += chunkSize;
          } while (offset < totalEntries);
        };
      };
    };

    public func sendSeasonLeaderboardEntries(privateLeaguesManager: PrivateLeaguesManager.PrivateLeaguesManager, seasonId: T.SeasonId, managerCanisterIdIndex: TrieMap.TrieMap<T.PrincipalId, T.CanisterId>) : async () {

      let seasonLeaderboardCanister = List.find<T.SeasonLeaderboardCanister>(
        seasonLeaderboardCanisters,
        func(seasonLeaderboard : T.SeasonLeaderboardCanister) : Bool {
          return seasonLeaderboard.seasonId == seasonId;
        },
      );

      switch(seasonLeaderboardCanister){
        case (null) {};
        case(?foundCanisterInfo){
          let season_leaderboard_canister = actor (foundCanisterInfo.canisterId) : actor {
            getEntries : (filters: DTOs.PaginationFiltersDTO, searchTerm : Text) -> async ?DTOs.SeasonLeaderboardDTO;
            getTotalEntries : () -> async Nat;
          };

          let totalEntries = await season_leaderboard_canister.getTotalEntries();
          let chunkSize : Nat = 1000;
          var offset : Nat = 0;

          label here loop {
            if (offset >= totalEntries) {
              break here;
            };

            let entriesDTO = await season_leaderboard_canister.getEntries({ limit = chunkSize; offset }, "");
            switch (entriesDTO) {
              case (?dto) {
                await privateLeaguesManager.sendSeasonLeaderboardEntries(seasonId, dto.entries, managerCanisterIdIndex);
              };
              case (null) { };
            };

            offset += chunkSize;
          } while (offset < totalEntries);
        };
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
