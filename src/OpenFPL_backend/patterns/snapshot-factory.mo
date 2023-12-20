module {

  public class SnapshotFactory() {
    /*
    
    //SnapshotFactory //Implements factory to instantiate snapshots
    snapshot-factory.mo
Purpose: Encapsulates the logic for creating snapshot instances of the game state.
Contents:
A SnapshotFactory class with a method like createSnapshot that takes the current state and returns a new snapshot instance.
Potentially multiple factory methods if different types of snapshots are needed for various aspects of the game.



    private func updateSnapshotPoints(principalId : Text, seasonId : Nat16, gameweek : Nat8, teamPoints : Int16) : () {
      let userFantasyTeam = fantasyTeams.get(principalId);

      switch (userFantasyTeam) {
        case (null) {};
        case (?ufTeam) {

          let teamHistoryBuffer = Buffer.fromArray<T.FantasyTeamSeason>([]);

          switch (ufTeam.history) {
            case (null) {};
            case (existingHistory) {
              for (season in List.toIter<T.FantasyTeamSeason>(existingHistory)) {
                if (season.seasonId == seasonId) {
                  let snapshotBuffer = Buffer.fromArray<T.FantasyTeamSnapshot>([]);

                  for (snapshot in List.toIter<T.FantasyTeamSnapshot>(season.gameweeks)) {
                    if (snapshot.gameweek == gameweek) {

                      let updatedSnapshot : T.FantasyTeamSnapshot = {
                        principalId = snapshot.principalId;
                        gameweek = snapshot.gameweek;
                        transfersAvailable = snapshot.transfersAvailable;
                        bankBalance = snapshot.bankBalance;
                        playerIds = snapshot.playerIds;
                        captainId = snapshot.captainId;
                        goalGetterGameweek = snapshot.goalGetterGameweek;
                        goalGetterPlayerId = snapshot.goalGetterPlayerId;
                        passMasterGameweek = snapshot.passMasterGameweek;
                        passMasterPlayerId = snapshot.passMasterPlayerId;
                        noEntryGameweek = snapshot.noEntryGameweek;
                        noEntryPlayerId = snapshot.noEntryPlayerId;
                        teamBoostGameweek = snapshot.teamBoostGameweek;
                        teamBoostTeamId = snapshot.teamBoostTeamId;
                        safeHandsGameweek = snapshot.safeHandsGameweek;
                        safeHandsPlayerId = snapshot.safeHandsPlayerId;
                        captainFantasticGameweek = snapshot.captainFantasticGameweek;
                        captainFantasticPlayerId = snapshot.captainFantasticPlayerId;
                        countrymenGameweek = snapshot.countrymenGameweek;
                        countrymenCountryId = snapshot.countrymenCountryId;
                        prospectsGameweek = snapshot.prospectsGameweek;
                        braceBonusGameweek = snapshot.braceBonusGameweek;
                        hatTrickHeroGameweek = snapshot.hatTrickHeroGameweek;
                        favouriteTeamId = snapshot.favouriteTeamId;
                        teamName = snapshot.teamName;
                        points = teamPoints;
                        transferWindowGameweek = snapshot.transferWindowGameweek;
                      };

                      snapshotBuffer.add(updatedSnapshot);

                    } else { snapshotBuffer.add(snapshot) };
                  };

                  let gameweekSnapshots = Buffer.toArray<T.FantasyTeamSnapshot>(snapshotBuffer);

                  let totalSeasonPoints = Array.foldLeft<T.FantasyTeamSnapshot, Int16>(gameweekSnapshots, 0, func(sumSoFar, x) = sumSoFar + x.points);

                  let updatedSeason : T.FantasyTeamSeason = {
                    gameweeks = List.fromArray(gameweekSnapshots);
                    seasonId = season.seasonId;
                    totalPoints = totalSeasonPoints;
                  };

                  teamHistoryBuffer.add(updatedSeason);

                } else { teamHistoryBuffer.add(season) };
              };
            };
          };

          let updatedUserFantasyTeam : T.UserFantasyTeam = {
            fantasyTeam = ufTeam.fantasyTeam;
            history = List.fromArray(Buffer.toArray<T.FantasyTeamSeason>(teamHistoryBuffer));
          };
          fantasyTeams.put(principalId, updatedUserFantasyTeam);
        };
      };
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

    private func groupByTeam(fantasyTeams : HashMap.HashMap<Text, T.UserFantasyTeam>, allProfiles : HashMap.HashMap<Text, T.Profile>) : HashMap.HashMap<T.TeamId, [(Text, T.UserFantasyTeam)]> {
      let groupedTeams : HashMap.HashMap<T.TeamId, [(Text, T.UserFantasyTeam)]> = HashMap.HashMap<T.TeamId, [(Text, T.UserFantasyTeam)]>(10, Utilities.eqNat16, Utilities.hashNat16);

      for ((principalId, fantasyTeam) in fantasyTeams.entries()) {
        let profile = allProfiles.get(principalId);
        switch (profile) {
          case (null) {};
          case (?foundProfile) {
            let teamId = foundProfile.favouriteTeamId;
            switch (groupedTeams.get(teamId)) {
              case null {
                groupedTeams.put(teamId, [(principalId, fantasyTeam)]);
              };
              case (?existingEntries) {
                let updatedEntries = Buffer.fromArray<(Text, T.UserFantasyTeam)>(existingEntries);
                updatedEntries.add((principalId, fantasyTeam));
                groupedTeams.put(teamId, Buffer.toArray(updatedEntries));
              };
            };
          };
        };
      };

      return groupedTeams;
    };

    private func totalPointsForGameweek(team : T.UserFantasyTeam, seasonId : T.SeasonId, gameweek : T.GameweekNumber) : Int16 {

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

    private func totalPointsForSeason(team : T.UserFantasyTeam, seasonId : T.SeasonId) : Int16 {

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
            totalPoints += gameweek.points;
          };
          return totalPoints;
        };
      };
    };

    private func totalPointsForMonth(team : T.UserFantasyTeam, seasonId : T.SeasonId, monthGameweeks : List.List<Nat8>) : Int16 {

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

    public func snapshotGameweek(seasonId : Nat16, gameweek : T.GameweekNumber) : async () {
      for ((principalId, userFantasyTeam) in fantasyTeams.entries()) {
        let newSnapshot : T.FantasyTeamSnapshot = {
          principalId = userFantasyTeam.fantasyTeam.principalId;
          gameweek = gameweek;
          transfersAvailable = userFantasyTeam.fantasyTeam.transfersAvailable;
          bankBalance = userFantasyTeam.fantasyTeam.bankBalance;
          playerIds = userFantasyTeam.fantasyTeam.playerIds;
          captainId = userFantasyTeam.fantasyTeam.captainId;
          goalGetterGameweek = userFantasyTeam.fantasyTeam.goalGetterGameweek;
          goalGetterPlayerId = userFantasyTeam.fantasyTeam.goalGetterPlayerId;
          passMasterGameweek = userFantasyTeam.fantasyTeam.passMasterGameweek;
          passMasterPlayerId = userFantasyTeam.fantasyTeam.passMasterPlayerId;
          noEntryGameweek = userFantasyTeam.fantasyTeam.noEntryGameweek;
          noEntryPlayerId = userFantasyTeam.fantasyTeam.noEntryPlayerId;
          teamBoostGameweek = userFantasyTeam.fantasyTeam.teamBoostGameweek;
          teamBoostTeamId = userFantasyTeam.fantasyTeam.teamBoostTeamId;
          safeHandsGameweek = userFantasyTeam.fantasyTeam.safeHandsGameweek;
          safeHandsPlayerId = userFantasyTeam.fantasyTeam.safeHandsPlayerId;
          captainFantasticGameweek = userFantasyTeam.fantasyTeam.captainFantasticGameweek;
          captainFantasticPlayerId = userFantasyTeam.fantasyTeam.captainFantasticPlayerId;
          countrymenGameweek = userFantasyTeam.fantasyTeam.countrymenGameweek;
          countrymenCountryId = userFantasyTeam.fantasyTeam.countrymenCountryId;
          prospectsGameweek = userFantasyTeam.fantasyTeam.prospectsGameweek;
          braceBonusGameweek = userFantasyTeam.fantasyTeam.braceBonusGameweek;
          hatTrickHeroGameweek = userFantasyTeam.fantasyTeam.hatTrickHeroGameweek;
          teamName = userFantasyTeam.fantasyTeam.teamName;
          favouriteTeamId = userFantasyTeam.fantasyTeam.favouriteTeamId;
          points = 0;
          transferWindowGameweek = userFantasyTeam.fantasyTeam.transferWindowGameweek;
        };

        var seasonFound = false;

        var updatedSeasons = List.map<T.FantasyTeamSeason, T.FantasyTeamSeason>(
          userFantasyTeam.history,
          func(season : T.FantasyTeamSeason) : T.FantasyTeamSeason {
            if (season.seasonId == seasonId) {
              seasonFound := true;

              let otherSeasonGameweeks = List.filter<T.FantasyTeamSnapshot>(
                season.gameweeks,
                func(snapshot : T.FantasyTeamSnapshot) : Bool {
                  return snapshot.gameweek != gameweek;
                },
              );

              let updatedGameweeks = List.push(newSnapshot, otherSeasonGameweeks);

              return {
                seasonId = season.seasonId;
                totalPoints = season.totalPoints;
                gameweeks = updatedGameweeks;
              };
            };
            return season;
          },
        );

        if (not seasonFound) {
          let newSeason : T.FantasyTeamSeason = {
            seasonId = seasonId;
            totalPoints = 0;
            gameweeks = List.push(newSnapshot, List.nil());
          };

          updatedSeasons := List.push(newSeason, updatedSeasons);
        };

        let updatedUserTeam : T.UserFantasyTeam = {
          fantasyTeam = userFantasyTeam.fantasyTeam;
          history = updatedSeasons;
        };

        fantasyTeams.put(principalId, updatedUserTeam);
      };
    };
    
    */
  };
};
