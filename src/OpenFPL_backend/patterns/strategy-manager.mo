import DTOs "../DTOs";
import T "../types";
import Array "mo:base/Array";
import HashMap "mo:base/HashMap";
import Text "mo:base/Text";
import Iter "mo:base/Iter";
import Nat16 "mo:base/Nat16";
import List "mo:base/List";

module {

  public class StrategyManager() {
    
    
    
/*


    //recreate close gameweek timer to be 1 hour before the first fixture of the gameweek you are picking your team for

    //recreate the jan transfer window timer to the next January 1st

    //recreate the close jan transfer window timer for midnight on the 31st Jan

    //recreate timers for active games that are counting down to move a game from inactive to active or active to completed

	  //update the cache for the fixtures so users get the updated status about it being completed

      //    let updatedFixture = await seasonsInstance.updateStatus(systemState.calculationSeason, systemState.calculationGameweek, activeFixtures[i].id, 2);
      
      //Check if all games completed, if so:
        //NEED TO CHECK IF JANUARY 1ST IS IN THE UPCOMING GAMEWEEK THEN SET A TIMERS TO BEGIN AND END THE TRANSFER WINDOW IF IT IS
      
//where do I need to know if the season is active?



    //StrategyManager //implements strategy pattern for managing fantasy teams
strategy-manager.mo
Purpose: Implements the Strategy pattern to manage various strategies related to game mechanics and validation rules.
Contents:
Classes or interfaces for different strategies such as TeamValidationStrategy or PointsCalculationStrategy.
Methods to switch between strategies and apply them to the current game state or user actions.
Integration with the PlayerComposite and ClubComposite for applying these strategies to teams and clubs.



      */
//ensure you are going between gameweeks in all scenarios as you want

      //set fixture status to active (1)
      
      //set timers for when each game finishes to call the game completed expired timer


      /*
      let activeFixtures = seasonsInstance.getGameweekFixtures(systemState.calculationSeason, systemState.calculationGameweek);
      for (i in Iter.range(0, Array.size(activeFixtures) -1)) {
        if (activeFixtures[i].kickOff <= Time.now() and activeFixtures[i].status == 0) {

          let updatedFixture = await seasonsInstance.updateStatus(systemState.calculationSeason, systemState.calculationGameweek, activeFixtures[i].id, 1);
          let gameCompletedDuration : Timer.Duration = #nanoseconds(Int.abs((Time.now() + (oneHour * 2)) - Time.now()));
          switch (setAndBackupTimer) {
            case (null) {};
            case (?actualFunction) {
              await actualFunction(gameCompletedDuration, "gameCompletedExpired", activeFixtures[i].id);
            };
          };
        };
      };
      
      
    public func fixtureConsensusReached(seasonId : T.SeasonId, gameweekNumber : T.GameweekNumber, fixtureId : T.FixtureId, consensusPlayerEventData : [T.PlayerEventData]) : async () {
      var getSeasonId = seasonId;
      if (getSeasonId == 0) {
        getSeasonId := activeSeasonId;
      };

      var getGameweekNumber = gameweekNumber;
      if (getGameweekNumber == 0) {
        getGameweekNumber := activeGameweek;
      };

      if (interestingGameweek < activeGameweek) {
        interestingGameweek := activeGameweek;
      };

      let activeFixtures = seasonsInstance.getGameweekFixtures(activeSeasonId, activeGameweek);

      for (i in Iter.range(0, Array.size(activeFixtures) -1)) {
        let fixture = activeFixtures[i];
        if (fixture.id == fixtureId and fixture.status == 2) {
          let updatedFixture = await seasonsInstance.savePlayerEventData(getSeasonId, getGameweekNumber, activeFixtures[i].id, List.fromArray(consensusPlayerEventData));
          await finaliseFixture(updatedFixture);
        };
      };

      await checkGameweekFinished();
      await updateCacheHash("fixtures");
      await updateCacheHash("weekly_leaderboard");
      await updateCacheHash("monthly_leaderboards");
      await updateCacheHash("season_leaderboard");
      await updateCacheHash("system_state");
      await updatePlayerEventDataCache();
    };





    public func finaliseFixture(fixture : T.Fixture) : async () {
      let fixtureWithHighestPlayerId = await calculatePlayerScores(activeSeasonId, activeGameweek, fixture);
      await seasonsInstance.updateHighestPlayerId(activeSeasonId, activeGameweek, fixtureWithHighestPlayerId);
      await calculateFantasyTeamScores(activeSeasonId, activeGameweek);
    };

    private func checkGameweekFinished() : async () {
      let activeFixtures = seasonsInstance.getGameweekFixtures(activeSeasonId, activeGameweek);
      let remainingFixtures = Array.find(
        activeFixtures,
        func(fixture : T.Fixture) : Bool {
          return fixture.status < 3;
        },
      );

      if (Option.isNull(remainingFixtures)) {
        await gameweekVerified();
        await setNextGameweek();
      };
    };

    private func gameweekVerified() : async () {
      //await distributeRewards(); //IMPLEMENT POST SNS
    };

    public func setNextGameweek() : async () {
      if (activeGameweek == 38) {
        await seasonsInstance.createNewSeason(activeSeasonId);
        await resetFantasyTeams();
        await updateCacheHash("system_state");
        await updateCacheHash("weekly_leaderboard");
        await updateCacheHash("monthly_leaderboards");
        await updateCacheHash("season_leaderboard");
        return;
      };

      activeGameweek += 1;

      let activeFixtures = seasonsInstance.getGameweekFixtures(activeSeasonId, activeGameweek);

      let gameweekBeginDuration : Timer.Duration = #nanoseconds(Int.abs(activeFixtures[0].kickOff - Time.now() - oneHour));
      switch (setAndBackupTimer) {
        case (null) {};
        case (?actualFunction) {
          await actualFunction(gameweekBeginDuration, "gameweekBeginExpired", 0);
        };
      };
    };

    public func intialFixturesConfirmed() : async () {
      activeGameweek := 1;
      let activeFixtures = seasonsInstance.getGameweekFixtures(activeSeasonId, activeGameweek);

      let initialGameweekBeginDuration : Timer.Duration = #nanoseconds(Int.abs(activeFixtures[0].kickOff - Time.now() - oneHour));
      switch (setAndBackupTimer) {
        case (null) {};
        case (?actualFunction) {
          await actualFunction(initialGameweekBeginDuration, "gameweekBeginExpired", 0);
        };
      };
    };











	  
	  
    //Private functions used above

    private func seasonActive() : Bool {

      if (activeGameweek > 1) {
        return true;
      };

      let activeFixtures = seasonsInstance.getGameweekFixtures(activeSeasonId, activeGameweek);
      if (List.some(List.fromArray(activeFixtures), func(fixture : T.Fixture) : Bool { return fixture.status > 0 })) {
        return true;
      };

      return false;
    };
	  
    public func resetTransfers() : async () {

      for ((key, value) in fantasyTeams.entries()) {
        let userFantasyTeam = value.fantasyTeam;
        let updatedTeam : T.FantasyTeam = {
          principalId = userFantasyTeam.principalId;
          transfersAvailable = Nat8.fromNat(3);
          bankBalance = userFantasyTeam.bankBalance;
          playerIds = userFantasyTeam.playerIds;
          captainId = userFantasyTeam.captainId;
          goalGetterGameweek = userFantasyTeam.goalGetterGameweek;
          goalGetterPlayerId = userFantasyTeam.goalGetterPlayerId;
          passMasterGameweek = userFantasyTeam.passMasterGameweek;
          passMasterPlayerId = userFantasyTeam.passMasterPlayerId;
          noEntryGameweek = userFantasyTeam.noEntryGameweek;
          noEntryPlayerId = userFantasyTeam.noEntryPlayerId;
          teamBoostGameweek = userFantasyTeam.teamBoostGameweek;
          teamBoostTeamId = userFantasyTeam.teamBoostTeamId;
          safeHandsGameweek = userFantasyTeam.safeHandsGameweek;
          safeHandsPlayerId = userFantasyTeam.safeHandsPlayerId;
          captainFantasticGameweek = userFantasyTeam.captainFantasticGameweek;
          captainFantasticPlayerId = userFantasyTeam.captainFantasticPlayerId;
          countrymenGameweek = userFantasyTeam.countrymenGameweek;
          countrymenCountryId = userFantasyTeam.countrymenCountryId;
          prospectsGameweek = userFantasyTeam.prospectsGameweek;
          braceBonusGameweek = userFantasyTeam.braceBonusGameweek;
          hatTrickHeroGameweek = userFantasyTeam.hatTrickHeroGameweek;
          teamName = userFantasyTeam.teamName;
          favouriteTeamId = userFantasyTeam.favouriteTeamId;
          transferWindowGameweek = userFantasyTeam.transferWindowGameweek;
        };

        let updatedUserTeam : T.UserFantasyTeam = {
          fantasyTeam = updatedTeam;
          history = value.history;
        };

        fantasyTeams.put(key, updatedUserTeam);
      };
    };

    
    public func calculateFantasyTeamScores(seasonId : Nat16, gameweek : Nat8) : async () {
      let allPlayersList = await getPlayersMap(seasonId, gameweek);
      var allPlayers = HashMap.HashMap<Nat16, DTOs.PlayerScoreDTO>(500, Utilities.eqNat16, Utilities.hashNat16);
      for ((key, value) in Iter.fromArray(allPlayersList)) {
        allPlayers.put(key, value);
      };

      for ((key, value) in fantasyTeams.entries()) {

        let currentSeason = List.find<T.FantasyTeamSeason>(
          value.history,
          func(teamSeason : T.FantasyTeamSeason) : Bool {
            return teamSeason.seasonId == seasonId;
          },
        );

        switch (currentSeason) {
          case (null) {};
          case (?foundSeason) {
            let currentSnapshot = List.find<T.FantasyTeamSnapshot>(
              foundSeason.gameweeks,
              func(snapshot : T.FantasyTeamSnapshot) : Bool {
                return snapshot.gameweek == gameweek;
              },
            );
            switch (currentSnapshot) {
              case (null) {};
              case (?foundSnapshot) {

                var totalTeamPoints : Int16 = 0;
                for (i in Iter.range(0, Array.size(foundSnapshot.playerIds) -1)) {
                  let playerId = foundSnapshot.playerIds[i];
                  let playerData = allPlayers.get(playerId);
                  switch (playerData) {
                    case (null) {};
                    case (?player) {

                      var totalScore : Int16 = player.points;

                      // Goal Getter
                      if (foundSnapshot.goalGetterGameweek == gameweek and foundSnapshot.goalGetterPlayerId == playerId) {
                        totalScore += calculateGoalPoints(player.position, player.goalsScored);
                      };

                      // Pass Master
                      if (foundSnapshot.passMasterGameweek == gameweek and foundSnapshot.passMasterPlayerId == playerId) {
                        totalScore += calculateAssistPoints(player.position, player.assists);
                      };

                      // No Entry
                      if (foundSnapshot.noEntryGameweek == gameweek and (player.position < 2) and player.goalsConceded == 0) {
                        totalScore := totalScore * 3;
                      };

                      // Team Boost
                      if (foundSnapshot.teamBoostGameweek == gameweek and player.teamId == foundSnapshot.teamBoostTeamId) {
                        totalScore := totalScore * 2;
                      };

                      // Safe Hands
                      if (foundSnapshot.safeHandsGameweek == gameweek and player.position == 0 and player.saves > 4) {
                        totalScore := totalScore * 3;
                      };

                      // Captain Fantastic
                      if (foundSnapshot.captainFantasticGameweek == gameweek and foundSnapshot.captainId == playerId and player.goalsScored > 0) {
                        totalScore := totalScore * 2;
                      };

                      // Countrymen
                      if (foundSnapshot.countrymenGameweek == gameweek and foundSnapshot.countrymenCountryId == player.nationality) {
                        totalScore := totalScore * 2;
                      };

                      // Prospects
                      if (foundSnapshot.prospectsGameweek == gameweek and Utilities.calculateAgeFromUnix(player.dateOfBirth) < 21) {
                        totalScore := totalScore * 2;
                      };

                      // Brace Bonus
                      if (foundSnapshot.braceBonusGameweek == gameweek and player.goalsScored >= 2) {
                        totalScore := totalScore * 2;
                      };

                      // Hat Trick Hero
                      if (foundSnapshot.hatTrickHeroGameweek == gameweek and player.goalsScored >= 3) {
                        totalScore := totalScore * 3;
                      };

                      // Handle captain bonus
                      if (playerId == foundSnapshot.captainId) {
                        totalScore := totalScore * 2;
                      };

                      totalTeamPoints += totalScore;
                    };
                  };
                };
                updateSnapshotPoints(key, seasonId, gameweek, totalTeamPoints);
              };
            }

          };
        };
      };
      calculateLeaderboards(seasonId, gameweek);
      calculateMonthlyLeaderboards(seasonId, gameweek);
    };


    
    private func calculateLeaderboards(seasonId : Nat16, gameweek : Nat8) : () {

      let seasonEntries = Array.map<(Text, T.UserFantasyTeam), T.LeaderboardEntry>(
        Iter.toArray(fantasyTeams.entries()),
        func(pair) {
          return createLeaderboardEntry(pair.0, pair.1.fantasyTeam.teamName, pair.1, totalPointsForSeason(pair.1, seasonId));
        }

      );

      let gameweekEntries = Array.map<(Text, T.UserFantasyTeam), T.LeaderboardEntry>(
        Iter.toArray(fantasyTeams.entries()),
        func(pair) {
          return createLeaderboardEntry(pair.0, pair.1.fantasyTeam.teamName, pair.1, totalPointsForGameweek(pair.1, seasonId, gameweek));
        },
      );

      let sortedGameweekEntries = List.reverse(mergeSort(List.fromArray(gameweekEntries)));
      let sortedSeasonEntries = List.reverse(mergeSort(List.fromArray(seasonEntries)));

      let positionedGameweekEntries = assignPositionText(sortedGameweekEntries);
      let positionedSeasonEntries = assignPositionText(sortedSeasonEntries);

      let existingSeasonLeaderboard = seasonLeaderboards.get(seasonId);

      let currentGameweekLeaderboard : T.Leaderboard = {
        seasonId = seasonId;
        gameweek = gameweek;
        entries = positionedGameweekEntries;
      };

      var updatedGameweekLeaderboards = List.fromArray<T.Leaderboard>([]);

      switch (existingSeasonLeaderboard) {
        case (null) {
          updatedGameweekLeaderboards := List.fromArray([currentGameweekLeaderboard]);
        };
        case (?foundLeaderboard) {
          var gameweekLeaderboardExists = false;
          updatedGameweekLeaderboards := List.map<T.Leaderboard, T.Leaderboard>(
            foundLeaderboard.gameweekLeaderboards,
            func(leaderboard : T.Leaderboard) : T.Leaderboard {
              if (leaderboard.gameweek == gameweek) {
                gameweekLeaderboardExists := true;
                return currentGameweekLeaderboard;
              } else { return leaderboard };
            },
          );

          if (not gameweekLeaderboardExists) {
            updatedGameweekLeaderboards := List.append(updatedGameweekLeaderboards, List.fromArray([currentGameweekLeaderboard]));
          };

        };
      };

      let updatedSeasonLeaderboard : T.SeasonLeaderboards = {
        seasonLeaderboard = {
          seasonId = seasonId;
          gameweek = gameweek;
          entries = positionedSeasonEntries;
        };
        gameweekLeaderboards = updatedGameweekLeaderboards;
      };

      seasonLeaderboards.put(seasonId, updatedSeasonLeaderboard);

    };

    private func calculateMonthlyLeaderboards(seasonId : Nat16, gameweek : Nat8) : () {

      var monthGameweeks : List.List<Nat8> = List.nil();
      var gameweekMonth : Nat8 = 0;

      func getLatestFixtureTime(fixtures : [T.Fixture]) : Int {
        return Array.foldLeft(
          fixtures,
          fixtures[0].kickOff,
          func(acc : Int, fixture : T.Fixture) : Int {
            if (fixture.kickOff > acc) {
              return fixture.kickOff;
            } else {
              return acc;
            };
          },
        );
      };

      switch (getGameweekFixtures) {
        case (null) {};
        case (?actualFunction) {
          let activeGameweekFixtures = actualFunction(seasonId, gameweek);
          if (activeGameweekFixtures.size() > 0) {
            gameweekMonth := Utilities.unixTimeToMonth(getLatestFixtureTime(activeGameweekFixtures));
            monthGameweeks := List.append(monthGameweeks, List.fromArray([gameweek]));

            var currentGameweek = gameweek;
            label gwLoop while (currentGameweek > 1) {
              currentGameweek -= 1;
              let currentFixtures = actualFunction(seasonId, currentGameweek);
              let currentMonth = Utilities.unixTimeToMonth(getLatestFixtureTime(currentFixtures));
              if (currentMonth == gameweekMonth) {
                monthGameweeks := List.append(monthGameweeks, List.fromArray([currentGameweek]));
              } else {
                break gwLoop;
              };
            };
          };

        };
      };

      let allUserProfiles = getProfiles();
      let profilesMap = HashMap.fromIter<Text, T.Profile>(allUserProfiles.vals(), allUserProfiles.size(), Text.equal, Text.hash);
      let clubGroup = groupByTeam(fantasyTeams, profilesMap);
      var updatedLeaderboards = List.nil<T.ClubLeaderboard>();

      for ((clubId, userTeams) : (T.TeamId, [(Text, T.UserFantasyTeam)]) in clubGroup.entries()) {

        let filteredTeams = List.filter<(Text, T.UserFantasyTeam)>(
          List.fromArray(userTeams),
          func(team : (Text, T.UserFantasyTeam)) : Bool {
            return team.1.fantasyTeam.favouriteTeamId != 0;
          },
        );

        let monthEntries = List.map<(Text, T.UserFantasyTeam), T.LeaderboardEntry>(
          filteredTeams,
          func(pair : (Text, T.UserFantasyTeam)) : T.LeaderboardEntry {
            return createLeaderboardEntry(pair.0, pair.1.fantasyTeam.teamName, pair.1, totalPointsForMonth(pair.1, seasonId, monthGameweeks));
          },
        );

        let sortedMonthEntries = List.reverse(mergeSort(monthEntries));
        let positionedGameweekEntries = assignPositionText(sortedMonthEntries);

        let clubMonthlyLeaderboard : T.ClubLeaderboard = {
          seasonId = seasonId;
          month = gameweekMonth;
          clubId = clubId;
          entries = positionedGameweekEntries;
        };

        updatedLeaderboards := List.append<T.ClubLeaderboard>(updatedLeaderboards, List.fromArray([clubMonthlyLeaderboard]));
      };

      var seasonMonthlyLeaderboards = List.nil<T.ClubLeaderboard>();

      switch (monthlyLeaderboards.get(seasonId)) {
        case (null) {};
        case (?value) { seasonMonthlyLeaderboards := value };
      };

      for (leaderboard in Iter.fromList(seasonMonthlyLeaderboards)) {
        if (not (leaderboard.month == gameweekMonth)) {
          updatedLeaderboards := List.append<T.ClubLeaderboard>(updatedLeaderboards, List.fromArray([leaderboard]));
        };
      };

      monthlyLeaderboards.put(seasonId, updatedLeaderboards);
    };


    func calculateGoalPoints(position : Nat8, goalsScored : Int16) : Int16 {
      switch (position) {
        case 0 { return 40 * goalsScored };
        case 1 { return 40 * goalsScored };
        case 2 { return 30 * goalsScored };
        case 3 { return 20 * goalsScored };
        case _ { return 0 };
      };
    };

    func calculateAssistPoints(position : Nat8, assists : Int16) : Int16 {
      switch (position) {
        case 0 { return 30 * assists };
        case 1 { return 30 * assists };
        case 2 { return 20 * assists };
        case 3 { return 20 * assists };
        case _ { return 0 };
      };
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

    
    public func getSeasonFixtures(seasonId : Nat16) : [T.Fixture] {

      var seasonFixtures = List.nil<T.Fixture>();

      let foundSeason = List.find<T.Season>(
        seasons,
        func(season : T.Season) : Bool {
          return season.id == seasonId;
        },
      );

      switch (foundSeason) {
        case (null) { return [] };
        case (?season) {
          for (gameweek in List.toIter(season.gameweeks)) {
            seasonFixtures := List.append(seasonFixtures, gameweek.fixtures);
          };
        };
      };

      let sortedArray = Array.sort(
        List.toArray(seasonFixtures),
        func(a : T.Fixture, b : T.Fixture) : Order.Order {
          if (a.kickOff < b.kickOff) { return #less };
          if (a.kickOff == b.kickOff) { return #equal };
          return #greater;
        },
      );
      let sortedFixtures = List.fromArray(sortedArray);
      return sortedArray;
    };

    public func getGameweekFixtures(seasonId : Nat16, gameweekNumber : Nat8) : [T.Fixture] {

      let foundSeason = List.find<T.Season>(
        seasons,
        func(season : T.Season) : Bool {
          return season.id == seasonId;
        },
      );

      switch (foundSeason) {
        case (null) { return [] };
        case (?season) {
          let foundGameweek = List.find<T.Gameweek>(
            season.gameweeks,
            func(gameweek : T.Gameweek) : Bool {
              return gameweek.number == gameweekNumber;
            },
          );
          switch (foundGameweek) {
            case (null) { return [] };
            case (?g) {
              let sortedArray = Array.sort(
                List.toArray(g.fixtures),
                func(a : T.Fixture, b : T.Fixture) : Order.Order {
                  if (a.kickOff < b.kickOff) { return #less };
                  if (a.kickOff == b.kickOff) { return #equal };
                  return #greater;
                },
              );
              let sortedFixtures = List.fromArray(sortedArray);
              return sortedArray;
            };
          };
        };
      };
    };

    public func getNextSeasonId() : Nat16 {
      return nextSeasonId;
    };

    public func getNextFixtureId() : Nat32 {
      return nextFixtureId;
    };

    public func setNextSeasonId(stable_next_season_id : Nat16) : () {
      nextSeasonId := stable_next_season_id;
    };

    public func setNextFixtureId(stable_next_fixture_id : Nat32) : () {
      nextFixtureId := stable_next_fixture_id;
    };


    public func getSeason(seasonId : Nat16) : T.Season {
      let season = List.find<T.Season>(
        seasons,
        func(season : T.Season) : Bool {
          return season.id == seasonId;
        },
      );
      switch (season) {
        case (null) {
          return {
            gameweeks = List.nil<T.Gameweek>();
            id = 0;
            name = "";
            postponedFixtures = List.nil<T.Fixture>();
            year = 0;
          };
        };
        case (?foundSeason) {
          return {
            id = foundSeason.id;
            name = foundSeason.name;
            year = foundSeason.year;
            gameweeks = List.nil<T.Gameweek>();
            postponedFixtures = List.nil<T.Fixture>();
          };
        };
      };
    };

    public func getFixture(seasonId : T.SeasonId, gameweekNumber : T.GameweekNumber, fixtureId : T.FixtureId) : async T.Fixture {
      let emptyFixture : T.Fixture = {
        id = 0;
        seasonId = 0;
        gameweek = 0;
        kickOff = 0;
        homeTeamId = 0;
        awayTeamId = 0;
        homeGoals = 0;
        awayGoals = 0;
        status = 0;
        events = List.nil();
        highestScoringPlayerId = 0;
      };

      let season = List.find<T.Season>(
        seasons,
        func(season : T.Season) : Bool {
          return season.id == seasonId;
        },
      );
      switch (season) {
        case (null) { return emptyFixture };
        case (?foundSeason) {
          let gameweek = List.find<T.Gameweek>(
            foundSeason.gameweeks,
            func(gameweek : T.Gameweek) : Bool {
              return gameweek.number == gameweekNumber;
            },
          );

          switch (gameweek) {
            case (null) { return emptyFixture };
            case (?foundGameweek) {
              let fixture = List.find<T.Fixture>(
                foundGameweek.fixtures,
                func(fixture : T.Fixture) : Bool {
                  return fixture.id == fixtureId;
                },
              );
              switch (fixture) {
                case (null) { return emptyFixture };
                case (?foundFixture) { return foundFixture };
              };
            };
          };
        };
      };
    };

    public func updateStatus(seasonId : Nat16, gameweek : Nat8, fixtureId : Nat32, status : Nat8) : async T.Fixture {

      seasons := List.map<T.Season, T.Season>(
        seasons,
        func(season : T.Season) : T.Season {
          if (season.id == seasonId) {

            let updatedGameweeks = List.map<T.Gameweek, T.Gameweek>(
              season.gameweeks,
              func(gw : T.Gameweek) : T.Gameweek {
                if (gw.number == gameweek) {
                  let updatedFixtures = List.map<T.Fixture, T.Fixture>(
                    gw.fixtures,
                    func(fixture : T.Fixture) : T.Fixture {
                      if (fixture.id == fixtureId) {
                        return {
                          id = fixture.id;
                          seasonId = fixture.seasonId;
                          gameweek = fixture.gameweek;
                          kickOff = fixture.kickOff;
                          homeTeamId = fixture.homeTeamId;
                          awayTeamId = fixture.awayTeamId;
                          homeGoals = fixture.homeGoals;
                          awayGoals = fixture.awayGoals;
                          status = status;
                          events = fixture.events;
                          highestScoringPlayerId = fixture.highestScoringPlayerId;
                        };
                      } else {
                        return fixture;
                      };
                    },
                  );
                  return {
                    number = gw.number;
                    canisterId = gw.canisterId;
                    fixtures = updatedFixtures;
                  };
                } else {
                  return gw;
                };
              },
            );

            return {
              id = season.id;
              name = season.name;
              year = season.year;
              gameweeks = updatedGameweeks;
              postponedFixtures = season.postponedFixtures;
            };
          } else {
            return season;
          };
        },
      );

      let modifiedSeason = List.find<T.Season>(
        seasons,
        func(s : T.Season) : Bool {
          return s.id == seasonId;
        },
      );

      switch (modifiedSeason) {
        case (null) {
          return {
            id = 0;
            seasonId = 0;
            gameweek = 0;
            kickOff = 0;
            awayTeamId = 0;
            homeTeamId = 0;
            homeGoals = 0;
            awayGoals = 0;
            status = 0;
            events = List.nil<T.PlayerEventData>();
            highestScoringPlayerId = 0;
          };
        };
        case (?s) {
          let modifiedGameweek = List.find<T.Gameweek>(
            s.gameweeks,
            func(gw : T.Gameweek) : Bool {
              return gw.number == gameweek;
            },
          );

          switch (modifiedGameweek) {
            case (null) {
              return {
                id = 0;
                seasonId = 0;
                gameweek = 0;
                kickOff = 0;
                awayTeamId = 0;
                homeTeamId = 0;
                homeGoals = 0;
                awayGoals = 0;
                status = 0;
                events = List.nil<T.PlayerEventData>();
                highestScoringPlayerId = 0;
              };
            };
            case (?gw) {
              let modifiedFixture = List.find<T.Fixture>(
                gw.fixtures,
                func(f : T.Fixture) : Bool {
                  return f.id == fixtureId;
                },
              );

              switch (modifiedFixture) {
                case (null) {
                  return {
                    id = 0;
                    seasonId = 0;
                    gameweek = 0;
                    kickOff = 0;
                    awayTeamId = 0;
                    homeTeamId = 0;
                    homeGoals = 0;
                    awayGoals = 0;
                    status = 0;
                    events = List.nil<T.PlayerEventData>();
                    highestScoringPlayerId = 0;
                  };
                };
                case (?f) { return f };
              };
            };
          };
        };
      };
    };

    public func savePlayerEventData(seasonId : Nat16, gameweek : Nat8, fixtureId : Nat32, playerEventData : List.List<T.PlayerEventData>) : async T.Fixture {

      seasons := List.map<T.Season, T.Season>(
        seasons,
        func(season : T.Season) : T.Season {
          if (season.id == seasonId) {
            let updatedGameweeks = List.map<T.Gameweek, T.Gameweek>(
              season.gameweeks,
              func(gw : T.Gameweek) : T.Gameweek {
                if (gw.number == gameweek) {
                  let updatedFixtures = List.map<T.Fixture, T.Fixture>(
                    gw.fixtures,
                    func(fixture : T.Fixture) : T.Fixture {
                      if (fixture.id == fixtureId) {
                        return {
                          id = fixture.id;
                          seasonId = fixture.seasonId;
                          gameweek = fixture.gameweek;
                          kickOff = fixture.kickOff;
                          homeTeamId = fixture.homeTeamId;
                          awayTeamId = fixture.awayTeamId;
                          homeGoals = fixture.homeGoals;
                          awayGoals = fixture.awayGoals;
                          status = 3;
                          events = playerEventData;
                          highestScoringPlayerId = fixture.highestScoringPlayerId;
                        };
                      } else {
                        return fixture;
                      };
                    },
                  );
                  return {
                    number = gw.number;
                    canisterId = gw.canisterId;
                    fixtures = updatedFixtures;
                  };
                } else {
                  return gw;
                };
              },
            );
            return {
              id = season.id;
              name = season.name;
              year = season.year;
              gameweeks = updatedGameweeks;
              postponedFixtures = season.postponedFixtures;
            };
          } else {
            return season;
          };
        },
      );

      let modifiedSeason = List.find<T.Season>(
        seasons,
        func(s : T.Season) : Bool {
          return s.id == seasonId;
        },
      );

      switch (modifiedSeason) {
        case (null) {
          return {
            id = 0;
            seasonId = 0;
            gameweek = 0;
            kickOff = 0;
            awayTeamId = 0;
            homeTeamId = 0;
            homeGoals = 0;
            awayGoals = 0;
            status = 0;
            events = List.nil<T.PlayerEventData>();
            highestScoringPlayerId = 0;
          };
        };
        case (?s) {
          let modifiedGameweek = List.find<T.Gameweek>(
            s.gameweeks,
            func(gw : T.Gameweek) : Bool {
              return gw.number == gameweek;
            },
          );

          switch (modifiedGameweek) {
            case (null) {
              return {
                id = 0;
                seasonId = 0;
                gameweek = 0;
                kickOff = 0;
                awayTeamId = 0;
                homeTeamId = 0;
                homeGoals = 0;
                awayGoals = 0;
                status = 0;
                events = List.nil<T.PlayerEventData>();
                highestScoringPlayerId = 0;
              };
            };
            case (?gw) {
              let modifiedFixture = List.find<T.Fixture>(
                gw.fixtures,
                func(f : T.Fixture) : Bool {
                  return f.id == fixtureId;
                },
              );

              switch (modifiedFixture) {
                case (null) {
                  return {
                    id = 0;
                    seasonId = 0;
                    gameweek = 0;
                    kickOff = 0;
                    awayTeamId = 0;
                    homeTeamId = 0;
                    homeGoals = 0;
                    awayGoals = 0;
                    status = 0;
                    events = List.nil<T.PlayerEventData>();
                    highestScoringPlayerId = 0;
                  };
                };
                case (?f) { return f };
              };
            };
          };
        };
      };
    };

    public func updateHighestPlayerId(seasonId : Nat16, gameweek : Nat8, updatedFixture : T.Fixture) : async () {
      seasons := List.map<T.Season, T.Season>(
        seasons,
        func(season : T.Season) : T.Season {
          if (season.id == seasonId) {
            let updatedGameweeks = List.map<T.Gameweek, T.Gameweek>(
              season.gameweeks,
              func(gw : T.Gameweek) : T.Gameweek {
                if (gw.number == gameweek) {
                  let updatedFixtures = List.map<T.Fixture, T.Fixture>(
                    gw.fixtures,
                    func(fixture : T.Fixture) : T.Fixture {
                      if (fixture.id == updatedFixture.id) {
                        return updatedFixture;
                      } else { return fixture };
                    },
                  );
                  return {
                    number = gw.number;
                    canisterId = gw.canisterId;
                    fixtures = updatedFixtures;
                  };
                } else {
                  return gw;
                };
              },
            );
            return {
              id = season.id;
              name = season.name;
              year = season.year;
              gameweeks = updatedGameweeks;
              postponedFixtures = season.postponedFixtures;
            };
          } else {
            return season;
          };
        },
      );
    };

    private func subText(value : Text, indexStart : Nat, indexEnd : Nat) : Text {
      if (indexStart == 0 and indexEnd >= value.size()) {
        return value;
      } else if (indexStart >= value.size()) {
        return "";
      };

      var indexEndValid = indexEnd;
      if (indexEnd > value.size()) {
        indexEndValid := value.size();
      };

      var result : Text = "";
      var iter = Iter.toArray<Char>(Text.toIter(value));
      for (index in Iter.range(indexStart, indexEndValid - 1)) {
        result := result # Char.toText(iter[index]);
      };

      return result;
    };

private func resetTransfers() : async () {
    await fantasyTeamsInstance.resetTransfers();
  };

  private func calculatePlayerScores(activeSeason : T.SeasonId, activeGameweek : T.GameweekNumber, fixture : T.Fixture) : async T.Fixture {
    let adjFixtures = await playerCanister.calculatePlayerScores(activeSeason, activeGameweek, fixture);
    return adjFixtures;
  };

  private func distributeRewards() : async () {
    await rewardsInstance.distributeRewards();
  };

  private func snapshotGameweek(seasonId : Nat16, gameweek : Nat8) : async () {
    await fantasyTeamsInstance.snapshotGameweek(seasonId, gameweek);
  };

  private func calculateFantasyTeamScores(seasonId : Nat16, gameweek : Nat8) : async () {
    return await fantasyTeamsInstance.calculateFantasyTeamScores(seasonId, gameweek);
  };

  private func resetFantasyTeams() : async () {
    await fantasyTeamsInstance.resetFantasyTeams();
  };



  private func updatePlayerEventDataCache() : async () {
    await playerCanister.updatePlayerEventDataCache();
  };


  public shared ({ caller }) func savePlayerEvents(fixtureId : T.FixtureId, allPlayerEvents : [T.PlayerEventData]) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    assert Principal.toText(caller) == adminPrincipal;

    let validPlayerEvents = validatePlayerEvents(allPlayerEvents);

    if (not validPlayerEvents) {
      return #err(#InvalidData);
    };

    let activeSeasonId = seasonManager.getActiveSeasonId();
    let activeGameweek = seasonManager.getActiveGameweek();

    let fixture = await seasonManager.getFixture(activeSeasonId, activeGameweek, fixtureId);

    if (fixture.status != 2) {
      return #err(#NotAllowed);
    };

    let allPlayerEventsBuffer = Buffer.fromArray<T.PlayerEventData>(allPlayerEvents);

    let allPlayers = await playerCanister.getPlayers();

    let homeTeamPlayerIdsBuffer = Buffer.fromArray<Nat16>([]);
    let awayTeamPlayerIdsBuffer = Buffer.fromArray<Nat16>([]);

    for (event in Iter.fromArray(allPlayerEvents)) {
      if (event.teamId == fixture.homeTeamId) {
        homeTeamPlayerIdsBuffer.add(event.playerId);
      } else if (event.teamId == fixture.awayTeamId) {
        awayTeamPlayerIdsBuffer.add(event.playerId);
      };
    };

    let homeTeamDefensivePlayerIdsBuffer = Buffer.fromArray<Nat16>([]);
    let awayTeamDefensivePlayerIdsBuffer = Buffer.fromArray<Nat16>([]);

    for (playerId in Iter.fromArray<Nat16>(Buffer.toArray(homeTeamPlayerIdsBuffer))) {
      let player = Array.find<DTOs.PlayerDTO>(allPlayers, func(p : DTOs.PlayerDTO) : Bool { return p.id == playerId });
      switch (player) {
        case (null) {  };
        case (?actualPlayer) {
          if (actualPlayer.position == 0 or actualPlayer.position == 1) {
            if (Array.find<Nat16>(Buffer.toArray(homeTeamDefensivePlayerIdsBuffer), func(x : Nat16) : Bool { return x == playerId }) == null) {
              homeTeamDefensivePlayerIdsBuffer.add(playerId);
            };
          };
        };
      };
    };

    for (playerId in Iter.fromArray<Nat16>(Buffer.toArray(awayTeamPlayerIdsBuffer))) {
      let player = Array.find<DTOs.PlayerDTO>(allPlayers, func(p : DTOs.PlayerDTO) : Bool { return p.id == playerId });
      switch (player) {
        case (null) {  };
        case (?actualPlayer) {
          if (actualPlayer.position == 0 or actualPlayer.position == 1) {
            if (Array.find<Nat16>(Buffer.toArray(awayTeamDefensivePlayerIdsBuffer), func(x : Nat16) : Bool { return x == playerId }) == null) {
              awayTeamDefensivePlayerIdsBuffer.add(playerId);
            };
          };
        };
      };
    };

    // Get goals for each team
    let homeTeamGoals = Array.filter<T.PlayerEventData>(
      allPlayerEvents,
      func(event : T.PlayerEventData) : Bool {
        return event.teamId == fixture.homeTeamId and event.eventType == 1;
      },
    );

    let awayTeamGoals = Array.filter<T.PlayerEventData>(
      allPlayerEvents,
      func(event : T.PlayerEventData) : Bool {
        return event.teamId == fixture.awayTeamId and event.eventType == 1;
      },
    );

    let homeTeamOwnGoals = Array.filter<T.PlayerEventData>(
      allPlayerEvents,
      func(event : T.PlayerEventData) : Bool {
        return event.teamId == fixture.homeTeamId and event.eventType == 10;
      },
    );

    let awayTeamOwnGoals = Array.filter<T.PlayerEventData>(
      allPlayerEvents,
      func(event : T.PlayerEventData) : Bool {
        return event.teamId == fixture.awayTeamId and event.eventType == 10;
      },
    );

    let totalHomeScored = Array.size(homeTeamGoals) + Array.size(awayTeamOwnGoals);
    let totalAwayScored = Array.size(awayTeamGoals) + Array.size(homeTeamOwnGoals);

    if (totalHomeScored == 0) {
      //add away team clean sheets
      for (playerId in Iter.fromArray(Buffer.toArray(awayTeamDefensivePlayerIdsBuffer))) {
        let player = Array.find<DTOs.PlayerDTO>(allPlayers, func(p : DTOs.PlayerDTO) : Bool { return p.id == playerId });
        switch (player) {
          case (null) {};
          case (?actualPlayer) {
            let cleanSheetEvent : T.PlayerEventData = {
              fixtureId = fixtureId;
              playerId = playerId;
              eventType = 5;
              eventStartMinute = 90;
              eventEndMinute = 90;
              teamId = actualPlayer.teamId;
              position = actualPlayer.position;
            };
            allPlayerEventsBuffer.add(cleanSheetEvent);
          };
        };
      };
    } else {
      //add away team conceded events
      for (goal in Iter.fromArray(homeTeamGoals)) {
        for (playerId in Iter.fromArray(Buffer.toArray(awayTeamDefensivePlayerIdsBuffer))) {
          let player = Array.find<DTOs.PlayerDTO>(allPlayers, func(p : DTOs.PlayerDTO) : Bool { return p.id == playerId });
          switch (player) {
            case (null) {};
            case (?actualPlayer) {
              let concededEvent : T.PlayerEventData = {
                fixtureId = fixtureId;
                playerId = actualPlayer.id;
                eventType = 3;
                eventStartMinute = goal.eventStartMinute;
                eventEndMinute = goal.eventStartMinute;
                teamId = actualPlayer.teamId;
                position = actualPlayer.position;
              };
              allPlayerEventsBuffer.add(concededEvent);
            };
          };
        };
      };
    };

    if (totalAwayScored == 0) {
      //add home team clean sheets
      for (playerId in Iter.fromArray(Buffer.toArray(homeTeamDefensivePlayerIdsBuffer))) {
        let player = Array.find<DTOs.PlayerDTO>(allPlayers, func(p : DTOs.PlayerDTO) : Bool { return p.id == playerId });
        switch (player) {
          case (null) {};
          case (?actualPlayer) {
            let cleanSheetEvent : T.PlayerEventData = {
              fixtureId = fixtureId;
              playerId = playerId;
              eventType = 5;
              eventStartMinute = 90;
              eventEndMinute = 90;
              teamId = actualPlayer.teamId;
              position = actualPlayer.position;
            };
            allPlayerEventsBuffer.add(cleanSheetEvent);
          };
        };
      };
    } else {
      //add home team conceded events
      for (goal in Iter.fromArray(awayTeamGoals)) {
        for (playerId in Iter.fromArray(Buffer.toArray(homeTeamDefensivePlayerIdsBuffer))) {
          let player = Array.find<DTOs.PlayerDTO>(allPlayers, func(p : DTOs.PlayerDTO) : Bool { return p.id == playerId });
          switch (player) {
            case (null) {};
            case (?actualPlayer) {
              let concededEvent : T.PlayerEventData = {
                fixtureId = goal.fixtureId;
                playerId = actualPlayer.id;
                eventType = 3;
                eventStartMinute = goal.eventStartMinute;
                eventEndMinute = goal.eventStartMinute;
                teamId = actualPlayer.teamId;
                position = actualPlayer.position;
              };
              allPlayerEventsBuffer.add(concededEvent);
            };
          };
        };
      };
    };

    await finaliseFixture(fixture.seasonId, fixture.gameweek, fixture.id, Buffer.toArray(allPlayerEventsBuffer));
    return #ok();
  };

  private func finaliseFixture(seasonId : T.SeasonId, gameweekNumber : T.GameweekNumber, fixtureId : T.FixtureId, events : [T.PlayerEventData]) : async () {
    await seasonManager.fixtureConsensusReached(seasonId, gameweekNumber, fixtureId, events);
  };

  public shared ({ caller }) func updateSystemState(systemState : DTOs.UpdateSystemStateDTO) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    assert Principal.toText(caller) == adminPrincipal;
    let result = await seasonManager.updateSystemState(systemState);
    await updateCacheHash("system_state");
    return result;
  };

  public shared ({ caller }) func updateTeamValueInfo() : async () {
    assert not Principal.isAnonymous(caller);
    assert Principal.toText(caller) == adminPrincipal;

    await fantasyTeamsInstance.updateTeamValueInfo();
  };

  public func getTeamValueInfo() : async [Text] {
    await fantasyTeamsInstance.getTeamValueInfo();
  };

  public func getTimers() : async [T.TimerInfo] {
    return stable_timers;
  };

  public shared ({ caller }) func updateHashForCategory(category : Text) : async () {
    assert not Principal.isAnonymous(caller);

    let hashBuffer = Buffer.fromArray<T.DataCache>([]);

    for (hashObj in Iter.fromList(dataCacheHashes)) {
      if (hashObj.category == category) {
        let randomHash = await SHA224.getRandomHash();
        hashBuffer.add({ category = hashObj.category; hash = randomHash });
      } else { hashBuffer.add(hashObj) };
    };

    dataCacheHashes := List.fromArray(Buffer.toArray<T.DataCache>(hashBuffer));
  };

  public shared ({ caller }) func snapshotFantasyTeams() : async () {
    assert not Principal.isAnonymous(caller);
    assert Principal.toText(caller) == adminPrincipal;
    await seasonManager.gameweekBegin();
  };

  public shared ({ caller }) func updateFixture(updatedFixture : DTOs.UpdateFixtureDTO) : async () {
    assert not Principal.isAnonymous(caller);
    assert Principal.toText(caller) == adminPrincipal;

    await seasonManager.updateFixture(updatedFixture);
    await updateHashForCategory("fixtures");
  };


*/
/*
      let eventsBelow0 = Array.filter<T.PlayerEventData>(
      playerEvents,
      func(event : T.PlayerEventData) : Bool {
          return event.eventStartMinute < 0;
        },
      );

      if (Array.size(eventsBelow0) > 0) {
        return false;
      };

      let eventsAbove90 = Array.filter<T.PlayerEventData>(
        playerEvents,
        func(event : T.PlayerEventData) : Bool {
          return event.eventStartMinute > 90;
        },
      );

      if (Array.size(eventsAbove90) > 0) {
        return false;
      };

      let playerEventsMap : TrieMap.TrieMap<T.PlayerId, List.List<T.PlayerEventData>> = TrieMap.TrieMap<T.PlayerId, List.List<T.PlayerEventData>>(Utilities.eqNat16, Utilities.hashNat16);

      for (playerEvent in Iter.fromArray(playerEvents)) {
        switch (playerEventsMap.get(playerEvent.playerId)) {
          case (null) {};
          case (?existingEvents) {
            playerEventsMap.put(playerEvent.playerId, List.push<T.PlayerEventData>(playerEvent, existingEvents));
          };
        };
      };

      for ((playerId, events) in playerEventsMap.entries()) {
        let redCards = List.filter<T.PlayerEventData>(
          events,
          func(event : T.PlayerEventData) : Bool {
            return event.eventType == 9; // Red Card
          },
        );

        if (List.size<T.PlayerEventData>(redCards) > 1) {
          return false;
        };

        let yellowCards = List.filter<T.PlayerEventData>(
          events,
          func(event : T.PlayerEventData) : Bool {
            return event.eventType == 8; // Yellow Card
          },
        );

        if (List.size<T.PlayerEventData>(yellowCards) > 2) {
          return false;
        };

        if (List.size<T.PlayerEventData>(yellowCards) == 2 and List.size<T.PlayerEventData>(redCards) != 1) {
          return false;
        };

        let assists = List.filter<T.PlayerEventData>(
          events,
          func(event : T.PlayerEventData) : Bool {
            return event.eventType == 2; // Goal Assisted
          },
        );

        for (assist in Iter.fromList(assists)) {
          let goalsAtSameMinute = List.filter<T.PlayerEventData>(
            events,
            func(event : T.PlayerEventData) : Bool {
              return event.eventType == 1 and event.eventStartMinute == assist.eventStartMinute;
            },
          );

          if (List.size<T.PlayerEventData>(goalsAtSameMinute) == 0) {
            return false;
          };
        };

        let penaltySaves = List.filter<T.PlayerEventData>(
          events,
          func(event : T.PlayerEventData) : Bool {
            return event.eventType == 6;
          },
        );

        for (penaltySave in Iter.fromList(penaltySaves)) {
          let penaltyMissesAtSameMinute = List.filter<T.PlayerEventData>(
            events,
            func(event : T.PlayerEventData) : Bool {
              return event.eventType == 7 and event.eventStartMinute == penaltySave.eventStartMinute;
            },
          );

          if (List.size<T.PlayerEventData>(penaltyMissesAtSameMinute) == 0) {
            return false;
          };
        };
      };
*/

  };
};
