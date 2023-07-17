import List "mo:base/List";
import Result "mo:base/Result";
import T "types";
import Debug "mo:base/Debug";
import Array "mo:base/Array";
import Order "mo:base/Order";
import GenesisData "genesis-data";

module {
    
  public class Fixtures(){
    
    private var genesis_seasons: [T.Season] = [
        { id = 1; name = "2023/24"; year = 2023; }
    ];

    private var fixtures = List.fromArray(GenesisData.genesis_fixtures);
    private var seasons = List.fromArray(genesis_seasons);

    private var nextFixtureId : Nat32 = 381;
    private var nextSeasonId : Nat16 = 2;

    public func setData(stable_fixtures: [T.Fixture], stable_fixture_id : Nat32, stable_seasons: [T.Season], stable_season_id: Nat16){
        fixtures := List.fromArray(stable_fixtures);
        nextFixtureId := stable_fixture_id;
        seasons := List.fromArray(stable_seasons);
        nextSeasonId := stable_season_id;
    };

    public func getFixtures(seasonId: Nat16) : [T.Fixture] {
        let fixturesArray = List.toArray(fixtures);
        let sortedArray = Array.sort(fixturesArray, func (a: T.Fixture, b: T.Fixture): Order.Order {
            if (a.kickOff < b.kickOff) { return #less; };
            if (a.kickOff == b.kickOff) { return #equal; };
            return #greater;
        });
        let sortedFixtures = List.fromArray(sortedArray);
        return sortedArray;
    };

    public func getGameweekFixtures(seasonId: Nat16, gameweek: Nat8) : [T.Fixture] {
        return List.toArray(List.filter<T.Fixture>(fixtures, func (fixture: T.Fixture) : Bool {
            return fixture.seasonId == seasonId and fixture.gameweek == gameweek;
        }));
    };

    public func getNextFixtureId() : Nat32{
        return nextFixtureId;
    };

    public func createFixture(seasonId: Nat16, gameweek: Nat8, homeTeamId: Nat16, awayTeamId: Nat16, kickOff: Int) : Result.Result<(), T.Error> {
        let id = nextFixtureId;
        let newFixture : T.Fixture = {
            id = id;
            seasonId = seasonId;
            gameweek = gameweek;
            homeTeamId = homeTeamId;
            awayTeamId = awayTeamId;
            kickOff = kickOff;
            homeGoals = 0;
            awayGoals = 0;
        };
        
        var newFixtureList = List.nil<T.Fixture>();
        newFixtureList := List.push(newFixture, newFixtureList);

        fixtures := List.append(fixtures, newFixtureList);
        
        nextFixtureId := nextFixtureId + 1;
        return #ok(());
    };

  }
}
