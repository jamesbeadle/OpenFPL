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


  private func calculatePlayerScores(activeSeason : T.SeasonId, activeGameweek : T.GameweekNumber, fixture : T.Fixture) : async T.Fixture {
    let adjFixtures = await playerCanister.calculatePlayerScores(activeSeason, activeGameweek, fixture);
    return adjFixtures;
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

*/


  };
};
