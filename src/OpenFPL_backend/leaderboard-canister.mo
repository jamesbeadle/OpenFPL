



//will have a leaderboard whether weekly month or season as the object that contains it defines this information
/*





    public func getWeeklyLeaderboardEntry(managerId : Text, seasonId : T.SeasonId, gameweek : T.GameweekNumber) : ?T.LeaderboardEntry {

      for ((seasonId, seasonLeaderboards) in seasonLeaderboards.entries()) {
        if (seasonId == seasonId) {
          let weeklyLeaderboard = List.find<T.Leaderboard>(
            seasonLeaderboards.gameweekLeaderboards,
            func(gameweekLeaderboard : T.Leaderboard) : Bool {
              return gameweekLeaderboard.gameweek == gameweek;
            },
          );
          switch (weeklyLeaderboard) {
            case (null) {};
            case (?foundWeeklyLeaderboard) {

              return List.find<T.LeaderboardEntry>(
                foundWeeklyLeaderboard.entries,
                func(entry : T.LeaderboardEntry) : Bool {
                  return entry.principalId == managerId;
                },
              );
            };
          };
        };
      };

      return null;
    };

    public func getMonthlyLeaderboardEntry(managerId : Text, seasonId : T.SeasonId, clubId : T.TeamId) : ?T.LeaderboardEntry {

      for ((seasonId, clubLeaderboards) in monthlyLeaderboards.entries()) {
        if (seasonId == seasonId) {

          let clubLeaderboard = List.find<T.ClubLeaderboard>(
            clubLeaderboards,
            func(leaderboard : T.ClubLeaderboard) : Bool {
              return leaderboard.clubId == clubId;
            },
          );

          switch (clubLeaderboard) {
            case (null) {};
            case (?foundClubLeaderboard) {
              return List.find<T.LeaderboardEntry>(
                foundClubLeaderboard.entries,
                func(entry : T.LeaderboardEntry) : Bool {
                  return entry.principalId == managerId;
                },
              );
            };
          };
        };
      };

      return null;
    };

    public func getSeasonLeaderboardEntry(managerId : Text, seasonId : T.SeasonId) : ?T.LeaderboardEntry {

      for ((seasonId, seasonLeaderboards) in seasonLeaderboards.entries()) {
        if (seasonId == seasonId) {
          return List.find<T.LeaderboardEntry>(
            seasonLeaderboards.seasonLeaderboard.entries,
            func(entry : T.LeaderboardEntry) : Bool {
              return entry.principalId == managerId;
            },
          );
        };
      };

      return null;
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
