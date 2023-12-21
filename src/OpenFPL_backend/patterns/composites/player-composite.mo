import T "../../types";
import DTOs "../../DTOs";
import List "mo:base/List";
import CanisterIds "../../CanisterIds";

module {
  public class PlayerComposite() {
    
    private var nextPlayerId : T.PlayerId = 1;
    private var players = List.fromArray<T.Player>([]);
   
    public func setStableData(stable_next_player_id: T.PlayerId, stable_players: [T.Player]) {
      nextPlayerId := stable_next_player_id;
      players := List.fromArray(stable_players);
    };

    let former_players_canister = actor (CanisterIds.FORMER_PLAYERS_CANISTER_ID) : actor {
      getFormerPlayer : (playerId: T.PlayerId) -> async ();
      addFormerPlayer : (playerDTO: DTOs.PlayerDTO) -> async ();
      reinstateFormerPlayer : (playerId: T.PlayerId) -> async ();
    };

    let retired_players_canister = actor (CanisterIds.RETIRED_PLAYERS_CANISTER_ID) : actor {
      getRetiredPlayer : (playerId: T.PlayerId) -> async ();
      retirePlayer : (playerDTO: DTOs.PlayerDTO) -> async ();
      unretirePlayer : (playerId: T.PlayerId) -> async ();
    };

    public func loanExpired(){
//go through all players and check if any have their loan expired and recall them to their team if so
    };







  
/*

    //PlayerComposite //implements composite allows changes to players
player-composite.mo
Purpose: Manages player-related information, allowing operations to be applied uniformly to individual players or a group of players.
Contents:
A Player class with properties for player details and statistics.
A PlayerComposite class to perform operations like updating stats or availability across multiple players.
Additional methods for player lifecycle management (addition, update, removal).


getPlayer : (playerId : PlayerId) -> async Player;
    getPlayers : () -> async [DTOs.PlayerDTO];
    getPlayersMap : (seasonId : SeasonId, gameweek : GameweekNumber) -> async [(PlayerId, DTOs.PlayerScoreDTO)];
    calculatePlayerScores(seasonId : SeasonId, gameweek : Nat8, fixture : Fixture) : async Fixture;
    revaluePlayerUp : (playerId : PlayerId, activeSeasonId : SeasonId, activeGameweek : GameweekNumber) -> async ();
    revaluePlayerDown : (playerId : PlayerId, activeSeasonId : SeasonId, activeGameweek : GameweekNumber) -> async ();
    transferPlayer : (playerId : PlayerId, newTeamId : TeamId, currentSeasonId : SeasonId, currentGameweek : GameweekNumber) -> async ();
    loanPlayer : (playerId : PlayerId, loanTeamId : TeamId, loanEndDate : Int, currentSeasonId : SeasonId, currentGameweek : GameweekNumber) -> async ();
    recallPlayer : (playerId : PlayerId) -> async ();
    createPlayer : (teamId : TeamId, position : PlayerPosition, firstName : Text, lastName : Text, shirtNumber : Nat8, value : Nat, dateOfBirth : Int, nationality : CountryId) -> async ();
    updatePlayer : (playerId : PlayerId, position : Nat8, firstName : Text, lastName : Text, shirtNumber : Nat8, dateOfBirth : Int, nationality : CountryId) -> async ();
    setPlayerInjury : (playerId : PlayerId, description : Text, expectedEndDate : Int) -> async ();
    retirePlayer : (playerId : PlayerId, retirementDate : Int) -> async ();
    unretirePlayer : (playerId : PlayerId) -> async ();
    recalculatePlayerScores : (fixture : Fixture, seasonId : SeasonId, gameweek : GameweekNumber) -> async ();


*/


      /* reschedule fixture
      if (updatedFixtureDate <= Time.now()) {
        return #err(#InvalidData);
      };

      if (updatedFixtureGameweek <= seasonManager.getActiveGameweek()) {
        return #err(#InvalidData);
      };

      let fixture = await seasonManager.getFixture(seasonManager.getActiveSeason().id, currentFixtureGameweek, fixtureId);
      if (fixture.id == 0 or fixture.status == 3) {
        return #err(#InvalidData);
      };
      */

      
      /* calidate loan plaer
      if (loanEndDate <= Time.now()) {
        return #err(#InvalidData);
      };

      let player = await playerCanister.getPlayer(playerId);
      if (player.id == 0) {
        return #err(#InvalidData);
      };

      //player is not already on loan
      if (player.onLoan) {
        return #err(#InvalidData);
      };

      //loan team exists unless 0
      if (loanTeamId > 0) {
        switch (teamsInstance.getTeam(loanTeamId)) {
          case (null) {
            return #err(#InvalidData);
          };
          case (?foundTeam) {};
        };
      };
      */

      /* transfer player
      let player = await playerCanister.getPlayer(playerId);
      if (player.id == 0) {
        return #err(#InvalidData);
      };

      //new club is premier league team
      if (newTeamId > 0) {
        switch (teamsInstance.getTeam(newTeamId)) {
          case (null) {
            return #err(#InvalidData);
          };
          case (?foundTeam) {};
        };
      };
      */

      
      /* validate recall player
      let player = await playerCanister.getPlayer(playerId);
      if (player.id == 0) {
        return #err(#InvalidData);
      };

      //player is on loan
      if (not player.onLoan) {
        return #err(#InvalidData);
      };
      */

      
      /* validate craeste player
      switch (teamsInstance.getTeam(teamId)) {
        case (null) {
          return #err(#InvalidData);
        };
        case (?foundTeam) {};
      };

      if (Text.size(firstName) > 50) {
        return #err(#InvalidData);
      };

      if (Text.size(lastName) > 50) {
        return #err(#InvalidData);
      };

      if (position > 3) {
        return #err(#InvalidData);
      };

      if (not countriesInstance.isCountryValid(nationality)) {
        return #err(#InvalidData);
      };

      if (Utilities.calculateAgeFromUnix(dateOfBirth) < 16) {
        return #err(#InvalidData);
      };
      */

      
      /* validate update player
      let player = await playerCanister.getPlayer(playerId);
      if (player.id == 0) {
        return #err(#InvalidData);
      };

      if (Text.size(firstName) > 50) {
        return #err(#InvalidData);
      };

      if (Text.size(lastName) > 50) {
        return #err(#InvalidData);
      };

      if (position > 3) {
        return #err(#InvalidData);
      };

      if (not countriesInstance.isCountryValid(nationality)) {
        return #err(#InvalidData);
      };

      if (Utilities.calculateAgeFromUnix(dateOfBirth) < 16) {
        return #err(#InvalidData);
      };
      */

      
      /* set player injury
      let player = await playerCanister.getPlayer(playerId);
      if (player.id == 0 or player.isInjured) {
        return #err(#InvalidData);
      };
      */
      
      /* retire player
      let player = await playerCanister.getPlayer(playerId);
      if (player.id == 0 or player.retirementDate > 0) {
        return #err(#InvalidData);
      };
      */

      
      /* Promote new club
      let allTeams = teamsInstance.getTeams();

      if (Array.size(allTeams) >= 20) {
        return #err(#InvalidData);
      };

      let activeSeason = seasonManager.getActiveSeason();
      let seasonFixtures = seasonManager.getFixturesForSeason(activeSeason.id);
      if (Array.size(seasonFixtures) > 0) {
        return #err(#InvalidData);
      };

      if (Text.size(name) > 100) {
        return #err(#InvalidData);
      };

      if (Text.size(friendlyName) > 50) {
        return #err(#InvalidData);
      };

      if (Text.size(abbreviatedName) != 3) {
        return #err(#InvalidData);
      };

      if (not Utilities.validateHexColor(primaryHexColour)) {
        return #err(#InvalidData);
      };

      if (not Utilities.validateHexColor(secondaryHexColour)) {
        return #err(#InvalidData);
      };

      if (not Utilities.validateHexColor(thirdHexColour)) {
        return #err(#InvalidData);
      };
      */
  };
};
