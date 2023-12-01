import DTOs "../DTOs";
import T "../types";
import List "mo:base/List";
import Array "mo:base/Array";

module {
  public class TestData() {
    public var seasons : [T.Season] = [];
    public var teams : [T.Team] = [];
    public var players : [T.Player] = [];
    public var profiles : [(Text, T.Profile)] = [];
    public var fantasyTeams : [(Text, T.UserFantasyTeam)] = [];
    public var activeSeasonId : Nat16 = 0;
    public var activeGameweek : Nat8 = 0;
    public var interestingGameweek : Nat8 = 0;
    public var activeFixtures : [T.Fixture] = [];
    public var nextFixtureId : Nat32 = 0;
    public var nextSeasonId : Nat16 = 0;
    public var relegatedTeams : [T.Team] = [];
    public var nextTeamId : Nat16 = 0;
    public var maxVotesPerUser : Nat64 = 1;
    public var seasonLeaderboards : [(Nat16, T.SeasonLeaderboards)] = [];
    public var monthlyLeaderboards : [(T.SeasonId, List.List<T.ClubLeaderboard>)] = [];
    public var nextPlayerId : Nat = 0;
    public var mainCanisterDataCacheHashes : [T.DataCache] = [];
    public var playerCanisterDataCacheHashes : [T.DataCache] = [];
    public var mainCanisterTimers : [T.TimerInfo] = [];
    public var playerCanisterTimers : [T.TimerInfo] = [];

    public func setData() {

      players := getDemoPlayers();

      activeSeasonId := 1;
      activeGameweek := 1;
      interestingGameweek := 1;
      nextPlayerId := Array.size(players) + 1;
      nextSeasonId := 2;
      nextTeamId := 21;
      nextFixtureId := 381;

      teams := getDemoTeams();
      seasons := getDemoSeasons();
      activeFixtures := getDemoActiveFixtures();
      /*
        profiles := getDemoProfiles();
        fantasyTeams := getDemoFantasyTeam();
        seasonLeaderboards := getDemoSeasonLeaderboards();
        monthlyLeaderboards := getDemoMonthlyLeaderboards();
        mainCanisterDataCacheHashes := getDemoMainDataCacheHashes();
        playerCanisterDataCacheHashes := getDemoPlayerDataCacheHashes();
        */;
    };

    private func getDemoTeams() : [T.Team] {
      return [];
    };

    private func getDemoPlayers() : [T.Player] {
      return [];
    };

    private func getDemoSeasons() : [T.Season] {
      return [];
    };

    private func getDemoActiveFixtures() : [T.Fixture] {
      return [];
    };

    private func getDemoProfiles() : [T.Profile] {
      return [];
    };

    //private func getDemoFantasyTeam() : T.
  };
};
