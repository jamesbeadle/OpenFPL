import List "mo:base/List";
import Principal "mo:base/Principal";
import Text "mo:base/Text";
import Array "mo:base/Array";
import Order "mo:base/Order";
import Iter "mo:base/Iter";
import Buffer "mo:base/Buffer";
import Timer "mo:base/Timer";
import Int "mo:base/Int";
import Option "mo:base/Option";
import Nat "mo:base/Nat";
import TrieMap "mo:base/TrieMap";

import Base "mo:waterway-mops/BaseTypes";
import FootballTypes "mo:waterway-mops/FootballTypes";
import LeaderboardQueries "../../OpenFPL_backend/queries/leaderboard_queries";
import LeaderboardUtilities "../utilities/leaderboard_utilities";
import AppTypes "../types/app_types";
import MopsCanisterIds "../cleanup/mops_canister_ids";

actor class _LeaderboardCanister() {

  private stable var weekly_leaderboards : [AppTypes.WeeklyLeaderboard] = [];
  private stable var monthly_leaderboards : [AppTypes.MonthlyLeaderboard] = [];
  private stable var season_leaderboards : [AppTypes.SeasonLeaderboard] = [];

  private stable var entryUpdatesAllowed = false;

  private let LEADERBOARD_ROW_COUNT_LIMIT = 25;

  public shared ({ caller }) func prepareForUpdate(
    seasonId : FootballTypes.SeasonId,
    month : Base.CalendarMonth,
    gameweek : FootballTypes.GameweekNumber,
    clubId : FootballTypes.ClubId,
  ) : async () {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == MopsCanisterIds.OPENFPL_BACKEND_CANISTER_ID;

    if (month == 0 and gameweek == 0) {
      season_leaderboards := Array.filter<AppTypes.SeasonLeaderboard>(
        season_leaderboards,
        func(leaderboard : AppTypes.SeasonLeaderboard) : Bool {
          leaderboard.seasonId != seasonId;
        },
      );
      return;
    };

    if (month > 0) {
      monthly_leaderboards := Array.filter<AppTypes.MonthlyLeaderboard>(
        monthly_leaderboards,
        func(leaderboard : AppTypes.MonthlyLeaderboard) : Bool {
          not (
            leaderboard.seasonId == seasonId and leaderboard.month == month and leaderboard.clubId == clubId
          );
        },
      );
      return;
    };

    weekly_leaderboards := Array.filter<AppTypes.WeeklyLeaderboard>(
      weekly_leaderboards,
      func(leaderboard : AppTypes.WeeklyLeaderboard) : Bool {
        not (
          leaderboard.seasonId == seasonId and leaderboard.gameweek == gameweek
        );
      },
    );
    entryUpdatesAllowed := true;
  };

  public shared ({ caller }) func addLeaderboardChunk(seasonId : FootballTypes.SeasonId, month : Base.CalendarMonth, gameweek : FootballTypes.GameweekNumber, clubId : FootballTypes.ClubId, entriesChunk : [AppTypes.LeaderboardEntry]) : async () {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == MopsCanisterIds.OPENFPL_BACKEND_CANISTER_ID;

    if (month == 0 and gameweek == 0) {
      addSeasonLeaderboardChunk(seasonId, entriesChunk);
      return;
    };

    if (month == 0) {
      addGameweekLeaderboardChunk(seasonId, gameweek, entriesChunk);
      return;
    };

    addMonthLeaderboardChunk(seasonId, month, clubId, entriesChunk);
  };

  public shared ({ caller }) func finaliseUpdate(seasonId : FootballTypes.SeasonId, month : Base.CalendarMonth, gameweek : FootballTypes.GameweekNumber) : async () {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == MopsCanisterIds.OPENFPL_BACKEND_CANISTER_ID;
    entryUpdatesAllowed := false;

    await calculateLeaderboards(seasonId, gameweek, month);
  };

  private func addGameweekLeaderboardChunk(seasonId : FootballTypes.SeasonId, gameweek : FootballTypes.GameweekNumber, entriesChunk : [AppTypes.LeaderboardEntry]) {
    var currentLeaderboard : ?AppTypes.WeeklyLeaderboard = null;

    currentLeaderboard := Array.find(
      weekly_leaderboards,
      func(leaderboard : AppTypes.WeeklyLeaderboard) : Bool {
        leaderboard.seasonId == seasonId and leaderboard.gameweek == gameweek;
      },
    );

    switch (currentLeaderboard) {
      case (?foundLeaderboard) {
        weekly_leaderboards := Array.map<AppTypes.WeeklyLeaderboard, AppTypes.WeeklyLeaderboard>(
          weekly_leaderboards,
          func(leaderboard : AppTypes.WeeklyLeaderboard) {
            if (leaderboard.seasonId == foundLeaderboard.seasonId and leaderboard.gameweek == foundLeaderboard.gameweek) {

              let updatedLeaderboardEntries = List.append<AppTypes.LeaderboardEntry>(leaderboard.entries, List.fromArray(entriesChunk));
              return {
                entries = updatedLeaderboardEntries;
                gameweek = leaderboard.gameweek;
                seasonId = leaderboard.seasonId;
                totalEntries = List.size(updatedLeaderboardEntries);
              };
            } else {
              return leaderboard;
            };
          },
        );
      };
      case (null) {
        let weeklyLeaderboardsBuffer = Buffer.fromArray<AppTypes.WeeklyLeaderboard>(weekly_leaderboards);
        weeklyLeaderboardsBuffer.add({
          entries = List.fromArray(entriesChunk);
          gameweek = gameweek;
          seasonId = seasonId;
          totalEntries = Array.size(entriesChunk);
        });

        weekly_leaderboards := Buffer.toArray(weeklyLeaderboardsBuffer);
      };
    };
  };

  private func addMonthLeaderboardChunk(seasonId : FootballTypes.SeasonId, month : Base.CalendarMonth, clubId : FootballTypes.ClubId, entriesChunk : [AppTypes.LeaderboardEntry]) {
    var currentLeaderboard : ?AppTypes.MonthlyLeaderboard = null;

    currentLeaderboard := Array.find(
      monthly_leaderboards,
      func(leaderboard : AppTypes.MonthlyLeaderboard) : Bool {
        leaderboard.seasonId == seasonId and leaderboard.month == month and leaderboard.clubId == clubId;
      },
    );

    switch (currentLeaderboard) {
      case (?foundLeaderboard) {
        monthly_leaderboards := Array.map<AppTypes.MonthlyLeaderboard, AppTypes.MonthlyLeaderboard>(
          monthly_leaderboards,
          func(leaderboard : AppTypes.MonthlyLeaderboard) {
            if (leaderboard.seasonId == foundLeaderboard.seasonId and leaderboard.month == foundLeaderboard.month and leaderboard.clubId == foundLeaderboard.clubId) {

              let updatedLeaderboardEntries = List.append<AppTypes.LeaderboardEntry>(leaderboard.entries, List.fromArray(entriesChunk));
              return {
                entries = updatedLeaderboardEntries;
                month = leaderboard.month;
                clubId = leaderboard.clubId;
                seasonId = leaderboard.seasonId;
                totalEntries = List.size(updatedLeaderboardEntries);
              };
            } else {
              return leaderboard;
            };
          },
        );
      };
      case (null) {
        let monthlyLeaderboardsBuffer = Buffer.fromArray<AppTypes.MonthlyLeaderboard>(monthly_leaderboards);
        monthlyLeaderboardsBuffer.add({
          entries = List.fromArray(entriesChunk);
          month = month;
          clubId = clubId;
          seasonId = seasonId;
          totalEntries = Array.size(entriesChunk);
        });

        monthly_leaderboards := Buffer.toArray(monthlyLeaderboardsBuffer);
      };
    };
  };

  private func addSeasonLeaderboardChunk(seasonId : FootballTypes.SeasonId, entriesChunk : [AppTypes.LeaderboardEntry]) {
    var currentLeaderboard : ?AppTypes.SeasonLeaderboard = null;

    currentLeaderboard := Array.find(
      season_leaderboards,
      func(leaderboard : AppTypes.SeasonLeaderboard) : Bool {
        leaderboard.seasonId == seasonId;
      },
    );

    switch (currentLeaderboard) {
      case (?foundLeaderboard) {
        season_leaderboards := Array.map<AppTypes.SeasonLeaderboard, AppTypes.SeasonLeaderboard>(
          season_leaderboards,
          func(leaderboard : AppTypes.SeasonLeaderboard) {
            if (leaderboard.seasonId == foundLeaderboard.seasonId) {

              let updatedLeaderboardEntries = List.append<AppTypes.LeaderboardEntry>(leaderboard.entries, List.fromArray(entriesChunk));
              return {
                entries = updatedLeaderboardEntries;
                seasonId = leaderboard.seasonId;
                totalEntries = List.size(updatedLeaderboardEntries);
              };
            } else {
              return leaderboard;
            };
          },
        );
      };
      case (null) {
        let seasonLeaderboardsBuffer = Buffer.fromArray<AppTypes.SeasonLeaderboard>(season_leaderboards);
        seasonLeaderboardsBuffer.add({
          entries = List.fromArray(entriesChunk);
          seasonId = seasonId;
          totalEntries = Array.size(entriesChunk);
        });

        season_leaderboards := Buffer.toArray(seasonLeaderboardsBuffer);
      };
    };
  };

  private func calculateLeaderboards(seasonId : FootballTypes.SeasonId, gameweek : FootballTypes.GameweekNumber, month : Base.CalendarMonth) : async () {

    if (month == 0 and gameweek == 0) {
      calculateSeasonLeaderboard(seasonId);
      return;
    };

    if (gameweek == 0) {
      calculateMonthlyLeaderboards(seasonId, month);
      return;
    };

    await calculateWeeklyLeaderboard(seasonId, gameweek);
  };

  private func calculateSeasonLeaderboard(seasonId : FootballTypes.SeasonId) {

    var currentLeaderboard : ?AppTypes.SeasonLeaderboard = null;

    currentLeaderboard := Array.find(
      season_leaderboards,
      func(leaderboard : AppTypes.SeasonLeaderboard) : Bool {
        leaderboard.seasonId == seasonId;
      },
    );

    switch (currentLeaderboard) {
      case (?foundLeaderboard) {

        let sortedGameweekEntries = Array.sort(
          List.toArray(foundLeaderboard.entries),
          func(entry1 : AppTypes.LeaderboardEntry, entry2 : AppTypes.LeaderboardEntry) : Order.Order {
            if (entry1.points < entry2.points) { return #greater };
            if (entry1.points == entry2.points) { return #equal };
            return #less;
          },
        );

        let positionedGameweekEntries = LeaderboardUtilities.assignPositionText(List.fromArray<AppTypes.LeaderboardEntry>(sortedGameweekEntries));

        var updatedLeaderboard : AppTypes.SeasonLeaderboard = {
          seasonId = foundLeaderboard.seasonId;
          entries = positionedGameweekEntries;
          totalEntries = List.size(positionedGameweekEntries);
        };
        season_leaderboards := Array.map<AppTypes.SeasonLeaderboard, AppTypes.SeasonLeaderboard>(
          season_leaderboards,
          func(leaderboard : AppTypes.SeasonLeaderboard) {
            if (leaderboard.seasonId == seasonId) {
              return updatedLeaderboard;
            } else { return leaderboard };
          },
        );
      };
      case (null) {};
    };
  };

  private func calculateMonthlyLeaderboards(seasonId : FootballTypes.SeasonId, month : Base.CalendarMonth) {

    let currentLeaderboards = Array.filter(
      monthly_leaderboards,
      func(leaderboard : AppTypes.MonthlyLeaderboard) : Bool {
        leaderboard.seasonId == seasonId and leaderboard.month == month
      },
    );

    for (monthlyLeaderboard in Iter.fromArray(currentLeaderboards)) {

      let sortedGameweekEntries = Array.sort(
        List.toArray(monthlyLeaderboard.entries),
        func(entry1 : AppTypes.LeaderboardEntry, entry2 : AppTypes.LeaderboardEntry) : Order.Order {
          if (entry1.points < entry2.points) { return #greater };
          if (entry1.points == entry2.points) { return #equal };
          return #less;
        },
      );

      let positionedGameweekEntries = LeaderboardUtilities.assignPositionText(List.fromArray<AppTypes.LeaderboardEntry>(sortedGameweekEntries));

      var updatedLeaderboard : AppTypes.MonthlyLeaderboard = {
        seasonId = monthlyLeaderboard.seasonId;
        entries = positionedGameweekEntries;
        totalEntries = List.size(positionedGameweekEntries);
        clubId = monthlyLeaderboard.clubId;
        month = month;
      };

      monthly_leaderboards := Array.map<AppTypes.MonthlyLeaderboard, AppTypes.MonthlyLeaderboard>(
        monthly_leaderboards,
        func(leaderboard : AppTypes.MonthlyLeaderboard) {
          if (leaderboard.seasonId == seasonId and leaderboard.month == month and leaderboard.clubId == updatedLeaderboard.clubId) {
            return updatedLeaderboard;
          } else { return leaderboard };
        },
      );
    };

  };

  private func calculateWeeklyLeaderboard(seasonId : FootballTypes.SeasonId, gameweek : FootballTypes.GameweekNumber) : async () {
    var currentLeaderboard : ?AppTypes.WeeklyLeaderboard = null;

    currentLeaderboard := Array.find(
      weekly_leaderboards,
      func(leaderboard : AppTypes.WeeklyLeaderboard) : Bool {
        leaderboard.seasonId == seasonId and leaderboard.gameweek == gameweek
      },
    );

    switch (currentLeaderboard) {
      case (?foundLeaderboard) {

        let dedupedEntries = removeDuplicateEntries(List.toArray(foundLeaderboard.entries));

        let sortedGameweekEntries = Array.sort(
          dedupedEntries,
          func(entry1 : AppTypes.LeaderboardEntry, entry2 : AppTypes.LeaderboardEntry) : Order.Order {
            if (entry1.points < entry2.points) { return #greater };
            if (entry1.points == entry2.points) { return #equal };
            return #less;
          },
        );

        let positionedGameweekEntries = LeaderboardUtilities.assignPositionText(List.fromArray<AppTypes.LeaderboardEntry>(sortedGameweekEntries));

        var updatedLeaderboard : AppTypes.WeeklyLeaderboard = {
          seasonId = foundLeaderboard.seasonId;
          entries = positionedGameweekEntries;
          totalEntries = List.size(positionedGameweekEntries);
          gameweek = gameweek;
        };

        let leaderboardBuffer = Buffer.fromArray<AppTypes.WeeklyLeaderboard>(
          Array.filter<AppTypes.WeeklyLeaderboard>(
            weekly_leaderboards,
            func(leaderboard : AppTypes.WeeklyLeaderboard) {
              return not (leaderboard.seasonId == seasonId and leaderboard.gameweek == gameweek);
            },
          )
        );

        leaderboardBuffer.add(updatedLeaderboard);
        weekly_leaderboards := Buffer.toArray(leaderboardBuffer);
      };
      case (null) {};
    };
  };

  private func removeDuplicateEntries(entries : [AppTypes.LeaderboardEntry]) : [AppTypes.LeaderboardEntry] {
    let seen = TrieMap.TrieMap<Text, Bool>(Text.equal, Text.hash);

    let buffer = Buffer.fromArray<AppTypes.LeaderboardEntry>([]);

    for (entry in Iter.fromArray(entries)) {
      if (seen.get(entry.principalId) == null) {
        seen.put(entry.principalId, true);
        buffer.add(entry);
      };
    };

    return Buffer.toArray(buffer);
  };

  /* TODO

  public shared query ({ caller }) func getWeeklyRewardLeaderboard(seasonId : FootballTypes.SeasonId, gameweek : FootballTypes.GameweekNumber) : async ?LeaderboardQ.WeeklyLeaderboardDTO {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == MopsCanisterIds.OPENFPL_BACKEND_CANISTER_ID;

    var currentLeaderboard : ?AppTypes.WeeklyLeaderboard = null;

    currentLeaderboard := Array.find(
      weekly_leaderboards,
      func(leaderboard : AppTypes.WeeklyLeaderboard) : Bool {
        leaderboard.seasonId == seasonId and leaderboard.gameweek == gameweek;
      },
    );

    switch (currentLeaderboard) {
      case (null) { return null };
      case (?foundLeaderboard) {

        let entriesArray = List.toArray(foundLeaderboard.entries);
        let sortedArray = Array.sort(
          entriesArray,
          func(a : AppTypes.LeaderboardEntry, b : AppTypes.LeaderboardEntry) : Order.Order {
            if (a.points < b.points) { return #greater };
            if (a.points == b.points) { return #equal };
            return #less;
          },
        );

        let cutoffIndex = 99;
        let lastQualifyingPoints = sortedArray[cutoffIndex].points;
        var lastIndexForPrizes = cutoffIndex;
        let totalEntries : Nat = List.size(foundLeaderboard.entries);

        if (totalEntries <= 0) {
          return null;
        };

        let totalEntriesIndex : Nat = totalEntries - 1;

        while (
          lastIndexForPrizes < totalEntriesIndex and List.toArray(foundLeaderboard.entries)[lastIndexForPrizes + 1].points == lastQualifyingPoints
        ) {
          lastIndexForPrizes := lastIndexForPrizes + 1;
        };

        let indexes : [Nat] = Array.tabulate<Nat>(Array.size(sortedArray), func(i : Nat) : Nat { i });

        let entriesWithIndex : [(AppTypes.LeaderboardEntry, Nat)] = Array.map<Nat, (AppTypes.LeaderboardEntry, Nat)>(indexes, func(i : Nat) : (AppTypes.LeaderboardEntry, Nat) { (sortedArray[i], i) });

        let qualifyingEntriesWithIndex = Array.filter(
          entriesWithIndex,
          func(pair : (AppTypes.LeaderboardEntry, Nat)) : Bool {
            let (_, index) = pair;
            index <= lastIndexForPrizes;
          },
        );

        let qualifyingEntries = Array.map(
          qualifyingEntriesWithIndex,
          func(pair : (AppTypes.LeaderboardEntry, Nat)) : AppTypes.LeaderboardEntry {
            let (entry, _) = pair;
            entry;
          },
        );
        return ?{
          seasonId = seasonId;
          gameweek = gameweek;
          entries = qualifyingEntries;
          totalEntries = Array.size(qualifyingEntries);
        };
      };
    };
  };

  */

  public shared ({ caller }) func getWeeklyLeaderboardEntries(dto : LeaderboardQueries.GetWeeklyLeaderboard) : async ?LeaderboardQueries.WeeklyLeaderboard {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == MopsCanisterIds.OPENFPL_BACKEND_CANISTER_ID;

    var currentLeaderboard : ?AppTypes.WeeklyLeaderboard = null;

    currentLeaderboard := Array.find(
      weekly_leaderboards,
      func(leaderboard : AppTypes.WeeklyLeaderboard) : Bool {
        leaderboard.seasonId == dto.seasonId and leaderboard.gameweek == dto.gameweek;
      },
    );

    switch (currentLeaderboard) {
      case (null) {
        return null;
      };
      case (?foundLeaderboard) {
        let filteredEntries = List.filter<AppTypes.LeaderboardEntry>(
          foundLeaderboard.entries,
          func(entry : AppTypes.LeaderboardEntry) : Bool {
            let term = dto.searchTerm;
            Text.startsWith(entry.username, #text term);
          },
        );

        let sortedGameweekEntries = Array.sort(
          List.toArray(filteredEntries),
          func(entry1 : AppTypes.LeaderboardEntry, entry2 : AppTypes.LeaderboardEntry) : Order.Order {
            if (entry1.points < entry2.points) { return #greater };
            if (entry1.points == entry2.points) { return #equal };
            return #less;
          },
        );

        let droppedEntries = List.drop<AppTypes.LeaderboardEntry>(List.fromArray(sortedGameweekEntries), dto.offset);
        let paginatedEntries = List.take<AppTypes.LeaderboardEntry>(droppedEntries, LEADERBOARD_ROW_COUNT_LIMIT);

        let leaderboardDTO : LeaderboardQueries.WeeklyLeaderboard = {
          seasonId = foundLeaderboard.seasonId;
          gameweek = foundLeaderboard.gameweek;
          entries = List.toArray(paginatedEntries);
          totalEntries = List.size(foundLeaderboard.entries);
        };

        return ?leaderboardDTO;
      };
    };
  };

/* TODO
  public shared query ({ caller }) func getWeeklyLeaderboardEntry(seasonId : FootballTypes.SeasonId, gameweek : FootballTypes.GameweekNumber, principalId : Text) : async ?DTOs.LeaderboardEntryDTO {
    assert not Principal.isAnonymous(caller);
    let callerPrincipalId = Principal.toText(caller);
    assert callerPrincipalId == MopsCanisterIds.OPENFPL_BACKEND_CANISTER_ID;

    var currentLeaderboard : ?AppTypes.WeeklyLeaderboard = null;

    currentLeaderboard := Array.find(
      weekly_leaderboards,
      func(leaderboard : AppTypes.WeeklyLeaderboard) : Bool {
        leaderboard.seasonId == seasonId and leaderboard.gameweek == gameweek;
      },
    );

    switch (currentLeaderboard) {
      case (null) {
        return null;
      };
      case (?foundLeaderboard) {
        let _ = List.find<AppTypes.LeaderboardEntry>(
          foundLeaderboard.entries,
          func(entry : DTOs.LeaderboardEntryDTO) : Bool {
            return entry.principalId == principalId;
          },
        );
      };
    };
  };
*/
  public shared ({ caller }) func getTotalLeaderboards() : async Nat {
    assert not Principal.isAnonymous(caller);
    let callerPrincipalId = Principal.toText(caller);
    assert callerPrincipalId == MopsCanisterIds.OPENFPL_BACKEND_CANISTER_ID;

    return Array.size(weekly_leaderboards) + Array.size(monthly_leaderboards) + Array.size(season_leaderboards);
  };

  system func preupgrade() {};

  system func postupgrade() {
    ignore Timer.setTimer<system>(#nanoseconds(Int.abs(1)), postUpgradeCallback);
  };

  private func postUpgradeCallback() : async () {};
};
