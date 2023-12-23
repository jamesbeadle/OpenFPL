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



//ensure you are going between gameweeks in all scenarios as you want

      //set fixture status to active (1)
      
      //set timers for when each game finishes to call the game completed expired timer







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

*/


  };
};
