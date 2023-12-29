import T "../types";
import DTOs "../DTOs";
import HashMap "mo:base/HashMap";
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
import WeeklyLeaderboardCanister "../weekly-leaderboard";
import MonthlyLeaderboardCanister "../monthly-leaderboard";
import SeasonLeaderboardCanister "../season-leaderboard";

module {

  public class LeaderboardComposite() {
    private var seasonLeaderboardCanisterIds : HashMap.HashMap<T.SeasonId, Text> = HashMap.HashMap<T.SeasonId, Text>(100, Utilities.eqNat16, Utilities.hashNat16);
    private var monthlyLeaderboardCanisterIds : HashMap.HashMap<T.MonthlyLeaderboardKey, Text> = HashMap.HashMap<T.MonthlyLeaderboardKey, Text>(100, Utilities.eqMonthlyKey, Utilities.hashMonthlyKey);
    private var weeklyLeaderboardCanisterIds : HashMap.HashMap<T.WeeklyLeaderboardKey, Text> = HashMap.HashMap<T.WeeklyLeaderboardKey, Text>(100, Utilities.eqWeeklyKey, Utilities.hashWeeklyKey);

    private var storeCanisterId : ?((canisterId : Text) -> async ()) = null;
    private var backendCanisterController : ?Principal = null;

    public func setStableData(
      stable_season_leaderboard_canister_ids : [(T.SeasonId, Text)],
      stable_monthly_leaderboard_canister_ids : [(T.MonthlyLeaderboardKey, Text)],
      stable_weekly_leaderboard_canister_ids : [(T.WeeklyLeaderboardKey, Text)],
    ) {

      seasonLeaderboardCanisterIds := HashMap.fromIter<T.SeasonId, Text>(
        stable_season_leaderboard_canister_ids.vals(),
        stable_season_leaderboard_canister_ids.size(),
        Utilities.eqNat16,
        Utilities.hashNat16,
      );

      monthlyLeaderboardCanisterIds := HashMap.fromIter<T.MonthlyLeaderboardKey, Text>(
        stable_monthly_leaderboard_canister_ids.vals(),
        stable_monthly_leaderboard_canister_ids.size(),
        Utilities.eqMonthlyKey,
        Utilities.hashMonthlyKey,
      );

      weeklyLeaderboardCanisterIds := HashMap.fromIter<T.WeeklyLeaderboardKey, Text>(
        stable_weekly_leaderboard_canister_ids.vals(),
        stable_weekly_leaderboard_canister_ids.size(),
        Utilities.eqWeeklyKey,
        Utilities.hashWeeklyKey,
      );
    };

    public func setStoreCanisterIdFunction(
      _storeCanisterId : (canisterId : Text) -> async (),
    ) {
      storeCanisterId := ?_storeCanisterId;
    };

    public func setBackendCanisterController(controller : Principal) {
      backendCanisterController := ?controller;
    };

    public func getWeeklyLeaderboard(seasonId : T.SeasonId, gameweek : T.GameweekNumber, limit : Nat, offset : Nat) : async Result.Result<DTOs.WeeklyLeaderboardDTO, T.Error> {

      if (limit > 100) {
        return #err(#NotAllowed);
      };

      let leaderboardKey : T.WeeklyLeaderboardKey = (seasonId, gameweek);
      let canisterId = weeklyLeaderboardCanisterIds.get(leaderboardKey);
      switch (canisterId) {
        case (null) {
          return #err(#NotFound);
        };
        case (?foundCanisterId) {
          let weekly_leaderboard_canister = actor (foundCanisterId) : actor {
            getEntries : (limit : Nat, offset : Nat) -> async ?DTOs.WeeklyLeaderboardDTO;
          };

          let leaderboardEntries = await weekly_leaderboard_canister.getEntries(limit, offset);
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

    public func getMonthlyLeaderboard(seasonId : T.SeasonId, month : T.CalendarMonth, clubId : T.ClubId, limit : Nat, offset : Nat) : async Result.Result<DTOs.MonthlyLeaderboardDTO, T.Error> {

      if (limit > 100) {
        return #err(#NotAllowed);
      };

      let leaderboardKey : T.MonthlyLeaderboardKey = (seasonId, month, clubId);
      let canisterId = monthlyLeaderboardCanisterIds.get(leaderboardKey);
      switch (canisterId) {
        case (null) {
          return #err(#NotFound);
        };
        case (?foundCanisterId) {
          let monthly_leaderboard_canister = actor (foundCanisterId) : actor {
            getEntries : (limit : Nat, offset : Nat) -> async ?DTOs.MonthlyLeaderboardDTO;
          };

          let leaderboardEntries = await monthly_leaderboard_canister.getEntries(limit, offset);
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

    public func getSeasonLeaderboard(seasonId : T.SeasonId, limit : Nat, offset : Nat) : async Result.Result<DTOs.SeasonLeaderboardDTO, T.Error> {

      if (limit > 100) {
        return #err(#NotAllowed);
      };

      let canisterId = seasonLeaderboardCanisterIds.get(seasonId);
      switch (canisterId) {
        case (null) {
          return #err(#NotFound);
        };
        case (?foundCanisterId) {
          let season_leaderboard_canister = actor (foundCanisterId) : actor {
            getEntries : (limit : Nat, offset : Nat) -> async ?DTOs.SeasonLeaderboardDTO;
          };

          let leaderboardEntries = await season_leaderboard_canister.getEntries(limit, offset);
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

      let leaderboardKey : T.WeeklyLeaderboardKey = (seasonId, gameweek);
      let canisterId = weeklyLeaderboardCanisterIds.get(leaderboardKey);
      switch (canisterId) {
        case (null) {
          return null;
        };
        case (?foundCanisterId) {
          let weekly_leaderboard_canister = actor (foundCanisterId) : actor {
            getEntry : (principalId : Text) -> async ?DTOs.LeaderboardEntryDTO;
          };

          let leaderboardEntry = await weekly_leaderboard_canister.getEntry(principalId);
          return leaderboardEntry;
        };
      };
    };

    public func getMonthlyLeaderboardEntry(principalId : Text, seasonId : T.SeasonId, month : T.CalendarMonth, clubId : T.ClubId) : async ?DTOs.LeaderboardEntryDTO {

      let leaderboardKey : T.MonthlyLeaderboardKey = (seasonId, month, clubId);
      let canisterId = monthlyLeaderboardCanisterIds.get(leaderboardKey);
      switch (canisterId) {
        case (null) {
          return null;
        };
        case (?foundCanisterId) {
          let monthly_leaderboard_canister = actor (foundCanisterId) : actor {
            getEntry : (principalId : Text) -> async ?DTOs.LeaderboardEntryDTO;
          };

          let leaderboardEntry = await monthly_leaderboard_canister.getEntry(principalId);
          return leaderboardEntry;
        };
      };
    };

    public func getSeasonLeaderboardEntry(principalId : Text, seasonId : T.SeasonId) : async ?DTOs.LeaderboardEntryDTO {

      let canisterId = seasonLeaderboardCanisterIds.get(seasonId);
      switch (canisterId) {
        case (null) {
          return null;
        };
        case (?foundCanisterId) {
          let season_leaderboard_canister = actor (foundCanisterId) : actor {
            getEntry : (principalId : Text) -> async ?DTOs.LeaderboardEntryDTO;
          };

          let leaderboardEntry = await season_leaderboard_canister.getEntry(principalId);
          return leaderboardEntry;
        };
      };
    };

    public func calculateLeaderboards(seasonId : T.SeasonId, gameweek : T.GameweekNumber, month : T.CalendarMonth, managers : HashMap.HashMap<T.PrincipalId, T.Manager>) : async () {

      let gameweekEntries = Array.map<(Text, T.Manager), T.LeaderboardEntry>(
        Iter.toArray(managers.entries()),
        func(pair) {
          return createLeaderboardEntry(pair.0, pair.1.username, totalPointsForGameweek(pair.1, seasonId, gameweek));
        },
      );

      let sortedGameweekEntries = List.reverse(mergeSort(List.fromArray(gameweekEntries)));
      let positionedGameweekEntries = assignPositionText(sortedGameweekEntries);

      await calculateWeeklyLeaderboards(seasonId, gameweek, positionedGameweekEntries);
      await calculateMonthlyLeaderboards(seasonId, gameweek, month, positionedGameweekEntries, managers);
      await calculateSeasonLeaderboard(seasonId, managers);

    };

    private func calculateWeeklyLeaderboards(seasonId : T.SeasonId, gameweek : T.GameweekNumber, positionedGameweekEntries : ?(T.LeaderboardEntry, List.List<T.LeaderboardEntry>)) : async () {

      let currentGameweekLeaderboard : T.WeeklyLeaderboard = {
        seasonId = seasonId;
        gameweek = gameweek;
        entries = positionedGameweekEntries;
        totalEntries = List.size(positionedGameweekEntries);
      };

      let gameweekLeaderboardCanisterId = await createWeeklyLeaderboardCanister(seasonId, gameweek, currentGameweekLeaderboard);
      weeklyLeaderboardCanisterIds.put((seasonId, gameweek), gameweekLeaderboardCanisterId);
    };

    private func calculateMonthlyLeaderboards(seasonId : T.SeasonId, gameweek : T.GameweekNumber, month : T.CalendarMonth, positionedGameweekEntries : ?(T.LeaderboardEntry, List.List<T.LeaderboardEntry>), managers : HashMap.HashMap<T.PrincipalId, T.Manager>) : async () {
      let clubGroup = groupByTeam(managers);

      var monthGameweeks : List.List<Nat8> = List.nil();
      var gameweekMonth : Nat8 = 0;
      let gameweekFixtures : [T.Fixture] = [];

      if (gameweekFixtures.size() > 0) {
        gameweekMonth := Utilities.unixTimeToMonth(Utilities.getLatestFixtureTime(gameweekFixtures));
        monthGameweeks := List.append(monthGameweeks, List.fromArray([gameweek]));

        var currentGameweek = gameweek;
        label gwLoop while (currentGameweek > 1) {
          currentGameweek -= 1;
          let currentMonth = Utilities.unixTimeToMonth(Utilities.getLatestFixtureTime(gameweekFixtures));
          if (currentMonth == gameweekMonth) {
            monthGameweeks := List.append(monthGameweeks, List.fromArray([currentGameweek]));
          } else {
            break gwLoop;
          };
        };
      };

      var updatedLeaderboards = List.nil<T.ClubLeaderboard>();

      for ((clubId, userTeams) : (T.ClubId, [(Text, T.Manager)]) in clubGroup.entries()) {

        let filteredTeams = List.filter<(Text, T.Manager)>(
          List.fromArray(userTeams),
          func(team : (Text, T.Manager)) : Bool {
            return team.1.favouriteClubId != 0;
          },
        );

        let monthEntries = List.map<(Text, T.Manager), T.LeaderboardEntry>(
          filteredTeams,
          func(pair : (Text, T.Manager)) : T.LeaderboardEntry {
            return createLeaderboardEntry(pair.0, pair.1.username, totalPointsForMonth(pair.1, seasonId, monthGameweeks));
          },
        );

        let sortedMonthEntries = List.reverse(mergeSort(monthEntries));
        let positionedMonthlyEntries = assignPositionText(sortedMonthEntries);

        let clubMonthlyLeaderboard : T.ClubLeaderboard = {
          seasonId = seasonId;
          month = gameweekMonth;
          clubId = clubId;
          entries = positionedGameweekEntries;
          totalEntries = List.size(positionedMonthlyEntries);
        };

        updatedLeaderboards := List.append<T.ClubLeaderboard>(updatedLeaderboards, List.fromArray([clubMonthlyLeaderboard]));
      };

      var monthlyLeaderboards = List.nil<T.ClubLeaderboard>();

      for (leaderboard in Iter.fromList(updatedLeaderboards)) {
        let monthlyLeaderboardCanisterId = await createMonthlyLeaderboardCanister(seasonId, gameweek, month, leaderboard.clubId, leaderboard);
        monthlyLeaderboardCanisterIds.put((seasonId, gameweek, leaderboard.clubId), monthlyLeaderboardCanisterId);
      };
    };

    private func groupByTeam(managers : HashMap.HashMap<T.PrincipalId, T.Manager>) : HashMap.HashMap<T.ClubId, [(Text, T.Manager)]> {
      let groupedTeams : HashMap.HashMap<T.ClubId, [(Text, T.Manager)]> = HashMap.HashMap<T.ClubId, [(Text, T.Manager)]>(10, Utilities.eqNat16, Utilities.hashNat16);

      for ((principalId, fantasyTeam) in managers.entries()) {
        let teamId = fantasyTeam.favouriteClubId;
        switch (groupedTeams.get(teamId)) {
          case null {
            groupedTeams.put(teamId, [(principalId, fantasyTeam)]);
          };
          case (?existingEntries) {
            let updatedEntries = Buffer.fromArray<(Text, T.Manager)>(existingEntries);
            updatedEntries.add((principalId, fantasyTeam));
            groupedTeams.put(teamId, Buffer.toArray(updatedEntries));
          };
        };
      };

      return groupedTeams;
    };

    private func totalPointsForMonth(team : T.Manager, seasonId : T.SeasonId, monthGameweeks : List.List<Nat8>) : Int16 {

      var totalPoints : Int16 = 0;

      let season = List.find(
        team.history,
        func(season : T.FantasyTeamSeason) : Bool {
          return season.seasonId == seasonId;
        },
      );

      switch (season) {
        case (null) { return 0 };
        case (?foundSeason) {
          for (gameweek in Iter.fromList(foundSeason.gameweeks)) {
            if (List.some(monthGameweeks, func(mw : Nat8) : Bool { return mw == gameweek.gameweek })) {
              totalPoints += gameweek.points;
            };
          };
          return totalPoints;
        };
      };
    };

    private func calculateSeasonLeaderboard(seasonId : T.SeasonId, managers : HashMap.HashMap<T.PrincipalId, T.Manager>) : async () {
      let seasonEntries = Array.map<(Text, T.Manager), T.LeaderboardEntry>(
        Iter.toArray(managers.entries()),
        func(pair) {
          return createLeaderboardEntry(pair.0, pair.1.username, totalPointsForSeason(pair.1, seasonId));
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
      seasonLeaderboardCanisterIds.put(seasonId, seasonLeaderboardCanisterId);
    };

    private func createWeeklyLeaderboardCanister(seasonId : T.SeasonId, gameweek : T.GameweekNumber, weeklyLeaderboard : T.WeeklyLeaderboard) : async Text {
      if (backendCanisterController == null) {
        return "";
      };

      Cycles.add(2_000_000_000_000);
      let canister = await WeeklyLeaderboardCanister.WeeklyLeaderboardCanister();
      let IC : Management.Management = actor (ENV.Default);
      let _ = await Utilities.updateCanister_(canister, backendCanisterController, IC);
      let canister_principal = Principal.fromActor(canister);
      await canister.addWeeklyLeaderboard(seasonId, gameweek, weeklyLeaderboard);
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

      Cycles.add(2_000_000_000_000);
      let canister = await MonthlyLeaderboardCanister.MonthlyLeaderboardCanister();
      let IC : Management.Management = actor (ENV.Default);
      let _ = await Utilities.updateCanister_(canister, backendCanisterController, IC);
      let canister_principal = Principal.fromActor(canister);
      await canister.addMonthlyLeaderboard(seasonId, gameweek, clubId, monthlyLeaderboard);
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

      Cycles.add(2_000_000_000_000);
      let canister = await SeasonLeaderboardCanister.SeasonLeaderboardCanister();
      let IC : Management.Management = actor (ENV.Default);
      let _ = await Utilities.updateCanister_(canister, backendCanisterController, IC);
      let canister_principal = Principal.fromActor(canister);
      await canister.addSeasonLeaderboard(seasonId, seasonLeaderboard);
      let canisterId = Principal.toText(canister_principal);

      switch (storeCanisterId) {
        case (null) {};
        case (?actualFunction) {
          await actualFunction(canisterId);
        };
      };

      return canisterId;
    };

    private func totalPointsForSeason(manager : T.Manager, seasonId : T.SeasonId) : Int16 {

      var totalPoints : Int16 = 0;

      let season = List.find(
        manager.history,
        func(season : T.FantasyTeamSeason) : Bool {
          return season.seasonId == seasonId;
        },
      );

      switch (season) {
        case (null) { return 0 };
        case (?foundSeason) {
          for (gameweek in Iter.fromList(foundSeason.gameweeks)) {
            totalPoints += gameweek.points;
          };
          return totalPoints;
        };
      };
    };

    private func totalPointsForGameweek(team : T.Manager, seasonId : T.SeasonId, gameweek : T.GameweekNumber) : Int16 {

      let season = List.find(
        team.history,
        func(season : T.FantasyTeamSeason) : Bool {
          return season.seasonId == seasonId;
        },
      );
      switch (season) {
        case (null) { return 0 };
        case (?foundSeason) {
          let seasonGameweek = List.find(
            foundSeason.gameweeks,
            func(gw : T.FantasyTeamSnapshot) : Bool {
              return gw.gameweek == gameweek;
            },
          );
          switch (seasonGameweek) {
            case null { return 0 };
            case (?foundSeasonGameweek) {
              return foundSeasonGameweek.points;
            };
          };
        };
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

    public func getStableSeasonLeaderboardCanisterIds() : [(T.SeasonId, Text)] {
      return Iter.toArray(seasonLeaderboardCanisterIds.entries());
    };

    public func setStableSeasonLeaderboardCanisterIds(stable_season_leaderboard_canister_ids : [(T.SeasonId, Text)]) {
      seasonLeaderboardCanisterIds := HashMap.fromIter<T.SeasonId, Text>(
        stable_season_leaderboard_canister_ids.vals(),
        stable_season_leaderboard_canister_ids.size(),
        Utilities.eqNat16,
        Utilities.hashNat16,
      );
    };

    public func getStableMonthlyLeaderboardCanisterIds() : [(T.MonthlyLeaderboardKey, Text)] {
      return Iter.toArray(monthlyLeaderboardCanisterIds.entries());
    };

    public func setStableMonthlyLeaderboardCanisterIds(stable_monthly_leaderboard_canister_ids : [(T.MonthlyLeaderboardKey, Text)]) {
      monthlyLeaderboardCanisterIds := HashMap.fromIter<T.MonthlyLeaderboardKey, Text>(
        stable_monthly_leaderboard_canister_ids.vals(),
        stable_monthly_leaderboard_canister_ids.size(),
        Utilities.eqMonthlyKey,
        Utilities.hashMonthlyKey,
      );
    };

    public func getStableWeeklyLeaderboardCanisterIds() : [(T.WeeklyLeaderboardKey, Text)] {
      return Iter.toArray(weeklyLeaderboardCanisterIds.entries());
    };

    public func setStableWeeklyLeaderboardCanisterIds(stable_weekly_leaderboard_canister_ids : [(T.WeeklyLeaderboardKey, Text)]) {
      weeklyLeaderboardCanisterIds := HashMap.fromIter<T.WeeklyLeaderboardKey, Text>(
        stable_weekly_leaderboard_canister_ids.vals(),
        stable_weekly_leaderboard_canister_ids.size(),
        Utilities.eqWeeklyKey,
        Utilities.hashWeeklyKey,
      );
    };

    public func getWeeklyCanisterId(seasonId : T.SeasonId, gameweek : T.GameweekNumber) : ?Text {
      let weeklyLeaderboardKey = (seasonId, gameweek);
      return weeklyLeaderboardCanisterIds.get(weeklyLeaderboardKey);
    };

    public func getMonthlyCanisterId(seasonId : T.SeasonId, month : T.CalendarMonth, club : T.ClubId) : ?Text {
      let monthlyLeaderboardKey = (seasonId, month, club);
      return monthlyLeaderboardCanisterIds.get(monthlyLeaderboardKey);
    };

    public func getSeasonCanisterId(seasonId : T.SeasonId) : ?Text {
      return seasonLeaderboardCanisterIds.get(seasonId);
    };

  };
};
