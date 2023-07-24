import List "mo:base/List";
import Result "mo:base/Result";
import T "types";
import Debug "mo:base/Debug";
import Array "mo:base/Array";
import Order "mo:base/Order";
import GenesisData "genesis-data";
import Buffer "mo:base/Buffer";

module {
    
  public class Fixtures(){
    
    private var genesis_seasons: [T.Season] = [
        { id = 1; name = "2023/24"; year = 2023; }
    ];

    private var fixtures = List.fromArray(GenesisData.get_genesis_fixtures());
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
        
        let fixturesArray = List.toArray(List.filter<T.Fixture>(fixtures, func (fixture: T.Fixture) : Bool {
            return fixture.seasonId == seasonId and fixture.gameweek == gameweek;
        }));

        let sortedArray = Array.sort(fixturesArray, func (a: T.Fixture, b: T.Fixture): Order.Order {
            if (a.kickOff < b.kickOff) { return #less; };
            if (a.kickOff == b.kickOff) { return #equal; };
            return #greater;
        });

        return sortedArray;
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
            status = 0;
            events = List.nil<T.PlayerEventData>();
            highestScoringPlayerId = 0;
        };
        
        var newFixtureList = List.nil<T.Fixture>();
        newFixtureList := List.push(newFixture, newFixtureList);

        fixtures := List.append(fixtures, newFixtureList);
        
        nextFixtureId := nextFixtureId + 1;
        return #ok(());
    };

    public func updateStatus(fixtureId: Nat32, status: Nat8) : async T.Fixture {
        
        let foundFixture = List.find<T.Fixture>(fixtures, func (fixture: T.Fixture): Bool {
            return fixture.id == fixtureId;
        });
        switch (foundFixture) {
            case (null) { 
                return { id = 0; seasonId = 0; gameweek = 0; kickOff = 0; awayTeamId = 0; homeTeamId = 0; homeGoals = 0; awayGoals = 0; status = 0; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0;}; };
            case (?foundFixture) {

                let updatedFixture: T.Fixture = {
                    id = foundFixture.id;
                    seasonId = foundFixture.seasonId;
                    gameweek = foundFixture.gameweek;
                    kickOff = foundFixture.kickOff;
                    homeTeamId = foundFixture.homeTeamId;
                    awayTeamId = foundFixture.awayTeamId;
                    homeGoals = foundFixture.homeGoals;
                    awayGoals = foundFixture.awayGoals;
                    status = status;
                    events = List.nil<T.PlayerEventData>();
                    highestScoringPlayerId = foundFixture.highestScoringPlayerId;
                };

                fixtures := List.map<T.Fixture, T.Fixture>(fixtures, func (fixture: T.Fixture): T.Fixture {
                    if (fixture.id == fixtureId) { updatedFixture } else { fixture }
                });
                
                return updatedFixture;
            };
        };
    };

    public func savePlayerEventData(fixtureId: Nat32, playerEventData: List.List<T.PlayerEventData>) : async T.Fixture {
        
        let foundFixture = List.find<T.Fixture>(fixtures, func (fixture: T.Fixture): Bool {
            return fixture.id == fixtureId;
        });
        switch (foundFixture) {
            case (null) { 
                return { id = 0; seasonId = 0; gameweek = 0; kickOff = 0; awayTeamId = 0; homeTeamId = 0; homeGoals = 0; awayGoals = 0; status = 0; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0;}; };
            case (?foundFixture) {

                let updatedFixture: T.Fixture = {
                    id = foundFixture.id;
                    seasonId = foundFixture.seasonId;
                    gameweek = foundFixture.gameweek;
                    kickOff = foundFixture.kickOff;
                    homeTeamId = foundFixture.homeTeamId;
                    awayTeamId = foundFixture.awayTeamId;
                    homeGoals = foundFixture.homeGoals;
                    awayGoals = foundFixture.awayGoals;
                    status = 3;
                    events = playerEventData;
                    highestScoringPlayerId = foundFixture.highestScoringPlayerId;
                };

                fixtures := List.map<T.Fixture, T.Fixture>(fixtures, func (fixture: T.Fixture): T.Fixture {
                    if (fixture.id == fixtureId) { updatedFixture } else { fixture }
                });
                
                return updatedFixture;
            };
        };
    };

    public func updateHighestPlayerIds(fixtures: [T.Fixture]) : async () {
        //implement
    };
  }
}
