import T "../types";
import DTOs "../DTOs";
import Result "mo:base/Result";
import Iter "mo:base/Iter";
import List "mo:base/List";
import Array "mo:base/Array";
import Int "mo:base/Int";
import Principal "mo:base/Principal";
import Utilities "../utilities";
import Management "../modules/Management";
import ENV "../utils/Env";
import Cycles "mo:base/ExperimentalCycles";
import Buffer "mo:base/Buffer";
import Debug "mo:base/Debug";
import TrieMap "mo:base/TrieMap";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import WeeklyLeaderboardCanister "../weekly-leaderboard";
import MonthlyLeaderboardCanister "../monthly-leaderboard";
import SeasonLeaderboardCanister "../season-leaderboard";

module {

  public class LeaderboardComposite() {
    private var seasonLeaderboardCanisters : List.List<T.SeasonLeaderboardCanister> = List.nil();
    private var monthlyLeaderboardCanisters : List.List<T.MonthlyLeaderboardCanister> = List.nil();
    private var weeklyLeaderboardCanisters : List.List<T.WeeklyLeaderboardCanister> = List.nil();

    private var storeCanisterId : ?((canisterId : Text) -> async ()) = null;
    private var backendCanisterController : ?Principal = null;

    public func setStableData(
      stable_season_leaderboard_canisters : [T.SeasonLeaderboardCanister],
      stable_monthly_leaderboard_canisters : [T.MonthlyLeaderboardCanister],
      stable_weekly_leaderboard_canisters : [T.WeeklyLeaderboardCanister],
    ) {

      seasonLeaderboardCanisters := List.fromArray(stable_season_leaderboard_canisters);
      monthlyLeaderboardCanisters := List.fromArray(stable_monthly_leaderboard_canisters);
      weeklyLeaderboardCanisters := List.fromArray(stable_weekly_leaderboard_canisters);
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

    public func getWeeklyLeaderboard(seasonId : T.SeasonId, gameweek : T.GameweekNumber, limit : Nat, offset : Nat, searchTerm : Text) : async Result.Result<DTOs.WeeklyLeaderboardDTO, T.Error> {
      if (limit > 100) {
        return #err(#NotAllowed);
      };

      let leaderboardCanisterId = List.find<T.WeeklyLeaderboardCanister>(
        weeklyLeaderboardCanisters,
        func(canister : T.WeeklyLeaderboardCanister) : Bool {
          return canister.seasonId == seasonId and canister.gameweek == gameweek;
        },
      );

      switch (leaderboardCanisterId) {
        case (null) {
          return #err(#NotFound);
        };
        case (?foundCanister) {
          let weekly_leaderboard_canister = actor (foundCanister.canisterId) : actor {
            getEntries : (limit : Nat, offset : Nat, searchTerm : Text) -> async ?DTOs.WeeklyLeaderboardDTO;
          };

          let leaderboardEntries = await weekly_leaderboard_canister.getEntries(limit, offset, searchTerm);
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

    public func getMonthlyLeaderboard(seasonId : T.SeasonId, month : T.CalendarMonth, clubId : T.ClubId, limit : Nat, offset : Nat, searchTerm : Text) : async Result.Result<DTOs.MonthlyLeaderboardDTO, T.Error> {

      if (limit > 100) {
        return #err(#NotAllowed);
      };

      let leaderboardCanisterId = List.find<T.MonthlyLeaderboardCanister>(
        monthlyLeaderboardCanisters,
        func(canister : T.MonthlyLeaderboardCanister) : Bool {
          return canister.seasonId == seasonId and canister.month == month and canister.clubId == clubId;
        },
      );

      switch (leaderboardCanisterId) {
        case (null) {
          return #err(#NotFound);
        };
        case (?foundCanister) {
          let monthly_leaderboard_canister = actor (foundCanister.canisterId) : actor {
            getEntries : (limit : Nat, offset : Nat, searchTerm : Text) -> async ?DTOs.MonthlyLeaderboardDTO;
          };

          let leaderboardEntries = await monthly_leaderboard_canister.getEntries(limit, offset, searchTerm);
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

    public func getMonthlyLeaderboards(seasonId : T.SeasonId, month : T.CalendarMonth, clubs : [DTOs.ClubDTO]) : async Result.Result<[DTOs.MonthlyLeaderboardDTO], T.Error> {

      let monthlyLeaderboardBuffer = Buffer.fromArray<DTOs.MonthlyLeaderboardDTO>([]);

      for (club in Iter.fromArray(clubs)) {

        let leaderboardCanisterId = List.find<T.MonthlyLeaderboardCanister>(
          monthlyLeaderboardCanisters,
          func(canister : T.MonthlyLeaderboardCanister) : Bool {
            return canister.seasonId == seasonId and canister.month == month and canister.clubId == club.id;
          },
        );

        switch (leaderboardCanisterId) {

          case (null) {};
          case (?foundCanister) {
            let monthly_leaderboard_canister = actor (foundCanister.canisterId) : actor {
              getEntries : (limit : Nat, offset : Nat) -> async ?DTOs.MonthlyLeaderboardDTO;
            };

            let leaderboardEntries = await monthly_leaderboard_canister.getEntries(100, 0);
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

    public func getSeasonLeaderboard(seasonId : T.SeasonId, limit : Nat, offset : Nat, searchTerm : Text) : async Result.Result<DTOs.SeasonLeaderboardDTO, T.Error> {

      if (limit > 100) {
        return #err(#NotAllowed);
      };

      let leaderboardCanisterId = List.find<T.SeasonLeaderboardCanister>(
        monthlyLeaderboardCanisters,
        func(canister : T.SeasonLeaderboardCanister) : Bool {
          return canister.seasonId == seasonId;
        },
      );

      switch (leaderboardCanisterId) {
        case (null) {
          return #err(#NotFound);
        };
        case (?foundCanister) {
          let season_leaderboard_canister = actor (foundCanister.canisterId) : actor {
            getEntries : (limit : Nat, offset : Nat, searchTerm : Text) -> async ?DTOs.SeasonLeaderboardDTO;
          };

          let leaderboardEntries = await season_leaderboard_canister.getEntries(limit, offset, searchTerm);
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

      let fantasyTeamSnapshotsBuffer = Buffer.fromArray<T.FantasyTeamSnapshot>([]);
      
      for (canisterId in Iter.fromArray(uniqueManagerCanisterIds)) {
        let manager_canister = actor (canisterId) : actor {
          getSnapshots : (seasonId : T.SeasonId, gameweek : T.GameweekNumber) -> async [T.FantasyTeamSnapshot];
        };

        let snapshots = await manager_canister.getSnapshots(seasonId, gameweek);
        fantasyTeamSnapshotsBuffer.append(Buffer.fromArray(snapshots));
      };
      
      await calculateWeeklyLeaderboards(seasonId, gameweek, Buffer.toArray(fantasyTeamSnapshotsBuffer));
      await calculateMonthlyLeaderboards(seasonId, gameweek, month, Buffer.toArray(fantasyTeamSnapshotsBuffer));
      await calculateSeasonLeaderboard(seasonId, Buffer.toArray(fantasyTeamSnapshotsBuffer));

    };

    private func calculateWeeklyLeaderboards(seasonId : T.SeasonId, gameweek : T.GameweekNumber, snapshots: [T.FantasyTeamSnapshot]) : async () {
      let gameweekEntries = Array.map<T.FantasyTeamSnapshot, T.LeaderboardEntry>(
        snapshots,
        func(snapshot) {
          return createLeaderboardEntry(snapshot.principalId, snapshot.username, snapshot.points);
        },
      );
      let sortedGameweekEntries = List.reverse(mergeSort(List.fromArray(gameweekEntries)));
      let positionedGameweekEntries = assignPositionText(sortedGameweekEntries);

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

//TODO: Need to use month being stored with snapshot
    private func calculateMonthlyLeaderboards(seasonId : T.SeasonId, gameweek : T.GameweekNumber, month : T.CalendarMonth, snapshots: [T.FantasyTeamSnapshot]) : async () {
      let clubGroup = groupByTeam(snapshots);
      
      var updatedLeaderboards = List.nil<T.ClubLeaderboard>();

      for ((clubId, userTeams) : (T.ClubId, [T.FantasyTeamSnapshot]) in clubGroup.entries()) {

        let filteredTeams = List.filter<T.FantasyTeamSnapshot>(
          List.fromArray(userTeams),
          func(snapshot: T.FantasyTeamSnapshot) : Bool {
            return snapshot.favouriteClubId != 0;
          },
        );

        let monthEntries = List.map<T.FantasyTeamSnapshot, T.LeaderboardEntry>(
          filteredTeams,
          func(snapshot : T.FantasyTeamSnapshot) : T.LeaderboardEntry {
            return createLeaderboardEntry(snapshot.principalId, snapshot.username, snapshot.monthlyPoints);
          },
        );

        let sortedMonthEntries = List.reverse(mergeSort(monthEntries));
        let positionedMonthlyEntries = assignPositionText(sortedMonthEntries);

        let clubMonthlyLeaderboard : T.ClubLeaderboard = {
          seasonId = seasonId;
          month = month;
          clubId = clubId;
          entries = positionedMonthlyEntries;
          totalEntries = List.size(positionedMonthlyEntries);
        };

        updatedLeaderboards := List.append<T.ClubLeaderboard>(updatedLeaderboards, List.fromArray([clubMonthlyLeaderboard]));
      };

      var monthlyLeaderboards = List.nil<T.ClubLeaderboard>();

      for (leaderboard in Iter.fromList(updatedLeaderboards)) {
        let monthlyLeaderboardCanisterId = await createMonthlyLeaderboardCanister(seasonId, gameweek, month, leaderboard.clubId, leaderboard);

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

    private func calculateSeasonLeaderboard(seasonId : T.SeasonId, snapshots: [T.FantasyTeamSnapshot]) : async () {
      let seasonEntries = Array.map<T.FantasyTeamSnapshot, T.LeaderboardEntry>(
        snapshots,
        func(snapshot) {
          return createLeaderboardEntry(snapshot.principalId, snapshot.username, snapshot.seasonPoints);
        },
      );
      let sortedSeasonEntries = List.reverse(mergeSort(List.fromArray(seasonEntries)));
      let positionedSeasonEntries = assignPositionText(sortedSeasonEntries);

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

      Cycles.add(2_000_000_000_000);
      let canister = await WeeklyLeaderboardCanister.WeeklyLeaderboardCanister();
      let IC : Management.Management = actor (ENV.Default);
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

    private func createMonthlyLeaderboardCanister(seasonId : T.SeasonId, gameweek : T.GameweekNumber, month : T.CalendarMonth, clubId : T.ClubId, monthlyLeaderboard : T.ClubLeaderboard) : async Text {

      if (backendCanisterController == null) {
        return "";
      };

      let maxEntriesPerChunk = 10_000;

      Cycles.add(2_000_000_000_000);
      let canister = await MonthlyLeaderboardCanister.MonthlyLeaderboardCanister();
      let IC : Management.Management = actor (ENV.Default);
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

      Cycles.add(2_000_000_000_000);
      let canister = await SeasonLeaderboardCanister.SeasonLeaderboardCanister();
      let IC : Management.Management = actor (ENV.Default);
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

    private func assignPositionText(sortedEntries : List.List<T.LeaderboardEntry>) : List.List<T.LeaderboardEntry> {
      var position = 1;
      var previousScore : ?Int16 = null;
      var currentPosition = 1;

      func updatePosition(entry : T.LeaderboardEntry) : T.LeaderboardEntry {
        if (previousScore == null) {
          previousScore := ?entry.points;
          let updatedEntry = {
            entry with position = position;
            positionText = Int.toText(position);
          };
          currentPosition += 1;
          return updatedEntry;
        } else if (previousScore == ?entry.points) {
          currentPosition += 1;
          return { entry with position = position; positionText = "-" };
        } else {
          position := currentPosition;
          previousScore := ?entry.points;
          let updatedEntry = {
            entry with position = position;
            positionText = Int.toText(position);
          };
          currentPosition += 1;
          return updatedEntry;
        };
      };

      return List.map(sortedEntries, updatePosition);
    };

    private func compare(entry1 : T.LeaderboardEntry, entry2 : T.LeaderboardEntry) : Bool {
      return entry1.points <= entry2.points;
    };

    func mergeSort(entries : List.List<T.LeaderboardEntry>) : List.List<T.LeaderboardEntry> {
      let len = List.size(entries);
      if (len <= 1) {
        return entries;
      } else {
        let (firstHalf, secondHalf) = List.split(len / 2, entries);
        return List.merge(mergeSort(firstHalf), mergeSort(secondHalf), compare);
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
