module {

  public class SeasonComposite() {
/*
public func getWeeklyLeaderboard(activeSeasonId : Nat16, activeGameweek : Nat8, limit : Nat, offset : Nat) : DTOs.PaginatedLeaderboard {
      switch (seasonLeaderboards.get(activeSeasonId)) {
        case (null) {
          return {
            seasonId = activeSeasonId;
            gameweek = activeGameweek;
            entries = [];
            totalEntries = 0;
          };
        };

        case (?seasonData) {
          let allGameweekLeaderboards = seasonData.gameweekLeaderboards;
          let matchingGameweekLeaderboard = List.find(
            allGameweekLeaderboards,
            func(leaderboard : T.Leaderboard) : Bool {
              return leaderboard.gameweek == activeGameweek;
            },
          );

          switch (matchingGameweekLeaderboard) {
            case (null) {
              return {
                seasonId = activeSeasonId;
                gameweek = activeGameweek;
                entries = [];
                totalEntries = 0;
              };
            };
            case (?foundLeaderboard) {
              let droppedEntries = List.drop<T.LeaderboardEntry>(foundLeaderboard.entries, offset);
              let paginatedEntries = List.take<T.LeaderboardEntry>(droppedEntries, limit);

              return {
                seasonId = activeSeasonId;
                gameweek = activeGameweek;
                entries = List.toArray(paginatedEntries);
                totalEntries = List.size<T.LeaderboardEntry>(foundLeaderboard.entries);
              };
            };
          };
        };
      };
    };

    public func getSeasonLeaderboard(activeSeasonId : Nat16, limit : Nat, offset : Nat) : DTOs.PaginatedLeaderboard {
      switch (seasonLeaderboards.get(activeSeasonId)) {
        case (null) {
          return {
            seasonId = activeSeasonId;
            gameweek = 0;
            entries = [];
            totalEntries = 0;
          };
        };

        case (?seasonData) {
          let allSeasonLeaderboardEntries = seasonData.seasonLeaderboard.entries;

          let droppedEntries = List.drop<T.LeaderboardEntry>(allSeasonLeaderboardEntries, offset);
          let paginatedEntries = List.take<T.LeaderboardEntry>(droppedEntries, limit);

          return {
            seasonId = activeSeasonId;
            gameweek = 0;
            entries = List.toArray(paginatedEntries);
            totalEntries = List.size<T.LeaderboardEntry>(allSeasonLeaderboardEntries);
          };
        };
      };
    };

    public func getClubLeaderboard(seasonId : T.SeasonId, month : Nat8, clubId : T.TeamId, limit : Nat, offset : Nat) : DTOs.PaginatedClubLeaderboard {

      let defaultLeaderboard = {
        seasonId = seasonId;
        month = month;
        clubId = clubId;
        entries = [];
        totalEntries = 0;
      };

      switch (monthlyLeaderboards.get(seasonId)) {
        case (null) { return defaultLeaderboard };
        case (?foundMonthlyLeaderboards) {

          let clubLeaderboard = List.find<T.ClubLeaderboard>(
            foundMonthlyLeaderboards,
            func(monthlyLeaderboard : T.ClubLeaderboard) : Bool {
              return monthlyLeaderboard.month == month and monthlyLeaderboard.clubId == clubId;
            },
          );

          switch (clubLeaderboard) {
            case (null) { return defaultLeaderboard };
            case (?foundClubLeaderboard) {
              let allClubLeaderboardEntries = foundClubLeaderboard.entries;

              let droppedEntries = List.drop<T.LeaderboardEntry>(allClubLeaderboardEntries, offset);
              let paginatedEntries = List.take<T.LeaderboardEntry>(droppedEntries, limit);

              return {
                seasonId = seasonId;
                month = month;
                clubId = clubId;
                entries = List.toArray(paginatedEntries);
                totalEntries = List.size<T.LeaderboardEntry>(allClubLeaderboardEntries);
              };

            };
          };

        };
      };
    };

    public func getClubLeaderboards(seasonId : T.SeasonId, month : Nat8, limit : Nat, offset : Nat) : [DTOs.PaginatedClubLeaderboard] {

      let defaultLeaderboard = {
        seasonId = seasonId;
        month = month;
        clubId = 0;
        entries = [];
        totalEntries = 0;
      };

      switch (monthlyLeaderboards.get(seasonId)) {
        case (null) { return [] };
        case (?foundMonthlyLeaderboards) {

          let monthlyLeaderboards = List.filter<T.ClubLeaderboard>(
            foundMonthlyLeaderboards,
            func(monthlyLeaderboard : T.ClubLeaderboard) : Bool {
              return monthlyLeaderboard.month == month;
            },
          );

          return List.toArray(
            List.map<T.ClubLeaderboard, DTOs.PaginatedClubLeaderboard>(
              monthlyLeaderboards,
              func(monthlyLeaderboard : T.ClubLeaderboard) : DTOs.PaginatedClubLeaderboard {
                return {
                  seasonId = monthlyLeaderboard.seasonId;
                  month = monthlyLeaderboard.month;
                  clubId = monthlyLeaderboard.clubId;
                  entries = List.toArray(monthlyLeaderboard.entries);
                  totalEntries = List.size(monthlyLeaderboard.entries);
                };
              },
            ),
          );
        };
      };
    };
    

    public func recalculateLeaderboards() : async () {
      calculateLeaderboards(1, 1);
      calculateMonthlyLeaderboards(1, 1);
      calculateLeaderboards(1, 2);
      calculateMonthlyLeaderboards(1, 2);
      calculateLeaderboards(1, 3);
      calculateMonthlyLeaderboards(1, 3);
      calculateLeaderboards(1, 4);
      calculateMonthlyLeaderboards(1, 4);
      calculateLeaderboards(1, 5);
      calculateMonthlyLeaderboards(1, 5);
      calculateLeaderboards(1, 6);
      calculateMonthlyLeaderboards(1, 6);
      calculateLeaderboards(1, 7);
      calculateMonthlyLeaderboards(1, 7);
      calculateLeaderboards(1, 8);
      calculateMonthlyLeaderboards(1, 8);
      calculateLeaderboards(1, 9);
      calculateMonthlyLeaderboards(1, 9);
    };










    

    private func createLeaderboardEntry(principalId : Text, username : Text, team : T.UserFantasyTeam, points : Int16) : T.LeaderboardEntry {
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





*/

      
  };
};
