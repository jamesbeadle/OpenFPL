import List "mo:base/List";
import Result "mo:base/Result";
import T "types";
import Debug "mo:base/Debug";
import Array "mo:base/Array";
import Order "mo:base/Order";
import GenesisData "genesis-data";
import Buffer "mo:base/Buffer";
import Nat16 "mo:base/Nat16";
import Iter "mo:base/Iter";
import Text "mo:base/Text";
import Char "mo:base/Char";

module {
    
  public class Seasons(){
    
    private var seasons = List.fromArray(GenesisData.get_genesis_seasons());

    private var nextFixtureId : Nat32 = 381;
    private var nextSeasonId : Nat16 = 2;

    public func setData(stable_seasons: [T.Season], stable_season_id: Nat16){
        seasons := List.fromArray(stable_seasons);
        nextSeasonId := stable_season_id;
    };

    public func getSeasonFixtures(seasonId: Nat16) : [T.Fixture] {

        var seasonFixtures = List.nil<T.Fixture>();

        let foundSeason = List.find<T.Season>(seasons, func (season: T.Season): Bool {
            return season.id == seasonId;
        });

        switch (foundSeason) {
            case (null) { return []; };
            case (?season) { 
                for(gameweek in List.toIter(season.gameweeks)){
                    seasonFixtures := List.append(seasonFixtures, gameweek.fixtures);
                };
            };
        };
        
        let sortedArray = Array.sort(List.toArray(seasonFixtures), func (a: T.Fixture, b: T.Fixture): Order.Order {
            if (a.kickOff < b.kickOff) { return #less; };
            if (a.kickOff == b.kickOff) { return #equal; };
            return #greater;
        });
        let sortedFixtures = List.fromArray(sortedArray);
        return sortedArray;
    };

    public func getGameweekFixtures(seasonId: Nat16, gameweekNumber: Nat8) : [T.Fixture] {
        
        let foundSeason = List.find<T.Season>(seasons, func (season: T.Season): Bool {
            return season.id == seasonId;
        });

        switch (foundSeason) {
            case (null) { return []; };
            case (?season) { 
                let foundGameweek = List.find<T.Gameweek>(season.gameweeks, func (gameweek: T.Gameweek): Bool {
                    return gameweek.number == gameweekNumber;
                });
                switch(foundGameweek){
                    case (null) { return []; };
                    case (?g) {
                        let sortedArray = Array.sort(List.toArray(g.fixtures), func (a: T.Fixture, b: T.Fixture): Order.Order {
                            if (a.kickOff < b.kickOff) { return #less; };
                            if (a.kickOff == b.kickOff) { return #equal; };
                            return #greater;
                        });
                        let sortedFixtures = List.fromArray(sortedArray);
                        return sortedArray;    
                    };
                };
            };
        };
    };

    public func getNextFixtureId() : Nat32{
        return nextFixtureId;
    };

    public func createNewSeason(activeSeasonId: Nat16) : async () {
        let activeSeason = List.find<T.Season>(seasons, func (season: T.Season): Bool {
            return season.id == activeSeasonId;
        });

        var newSeasonsList = List.nil<T.Season>();
        switch (activeSeason) {
            case (null) { }; 
            case (?season) { 
                let newYear = season.year + 1;
                let newSeason: T.Season = {
                    id = nextSeasonId;
                    name = Nat16.toText(newYear) # subText(Nat16.toText(newYear + 1), 2, 3);
                    year = newYear;
                    gameweeks = List.nil();
                };

                newSeasonsList := List.push(newSeason, newSeasonsList);
                seasons := List.append(seasons, newSeasonsList);
                nextSeasonId := nextSeasonId + 1;
            };
        };
    };

    public func updateStatus(seasonId: Nat16, gameweek: Nat8, fixtureId: Nat32, status: Nat8) : async T.Fixture {
    
        seasons := List.map<T.Season, T.Season>(seasons, func (season: T.Season): T.Season {
            if (season.id == seasonId) {
                
                // When the correct season is found, iterate through its gameweeks.
                let updatedGameweeks = List.map<T.Gameweek, T.Gameweek>(season.gameweeks, func (gw: T.Gameweek): T.Gameweek {
                    if (gw.number == gameweek) {
                        
                        // When the correct gameweek is found, iterate through its fixtures.
                        let updatedFixtures = List.map<T.Fixture, T.Fixture>(gw.fixtures, func (fixture: T.Fixture): T.Fixture {
                            if (fixture.id == fixtureId) {
                                
                                // When the correct fixture is found, update its status.
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
                            }
                        });
                        return {id = gw.id; number = gw.number; canisterId = gw.canisterId; fixtures = updatedFixtures};
                    } else {
                        return gw;
                    }
                });
                
                return {id = season.id; name = season.name; year = season.year; gameweeks = updatedGameweeks};
            } else {
                return season;
            }
        });

        let modifiedSeason = List.find<T.Season>(seasons, func (s: T.Season): Bool {
            return s.id == seasonId;
        });

        switch (modifiedSeason) {
            case (null) { 
                return { id = 0; seasonId = 0; gameweek = 0; kickOff = 0; awayTeamId = 0; homeTeamId = 0; homeGoals = 0; awayGoals = 0; status = 0; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0;}; 
            };
            case (?s) { 
                let modifiedGameweek = List.find<T.Gameweek>(s.gameweeks, func (gw: T.Gameweek): Bool {
                    return gw.number == gameweek;
                });

                switch(modifiedGameweek) {
                    case (null) { return { id = 0; seasonId = 0; gameweek = 0; kickOff = 0; awayTeamId = 0; homeTeamId = 0; homeGoals = 0; awayGoals = 0; status = 0; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0;}; };
                    case (?gw) {
                        let modifiedFixture = List.find<T.Fixture>(gw.fixtures, func (f: T.Fixture): Bool {
                            return f.id == fixtureId;
                        });

                        switch(modifiedFixture) {
                            case (null) { return { id = 0; seasonId = 0; gameweek = 0; kickOff = 0; awayTeamId = 0; homeTeamId = 0; homeGoals = 0; awayGoals = 0; status = 0; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0;}; };
                            case (?f) { return f; };
                        };
                    };
                };
            };
        };
    };


    public func savePlayerEventData(seasonId: Nat16, gameweek: Nat8, fixtureId: Nat32, playerEventData: List.List<T.PlayerEventData>) : async T.Fixture {
    
        seasons := List.map<T.Season, T.Season>(seasons, func (season: T.Season): T.Season {
            if (season.id == seasonId) {
                let updatedGameweeks = List.map<T.Gameweek, T.Gameweek>(season.gameweeks, func (gw: T.Gameweek): T.Gameweek {
                    if (gw.number == gameweek) {           
                        let updatedFixtures = List.map<T.Fixture, T.Fixture>(gw.fixtures, func (fixture: T.Fixture): T.Fixture {
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
                                    status = fixture.status; 
                                    events = playerEventData;
                                    highestScoringPlayerId = fixture.highestScoringPlayerId;
                                };
                            } else {
                                return fixture;
                            }
                        });
                        return {id = gw.id; number = gw.number; canisterId = gw.canisterId; fixtures = updatedFixtures};
                    } else {
                        return gw;
                    }
                });
                return {id = season.id; name = season.name; year = season.year; gameweeks = updatedGameweeks};
            } else {
                return season;
            }
        });

        let modifiedSeason = List.find<T.Season>(seasons, func (s: T.Season): Bool {
            return s.id == seasonId;
        });

        switch (modifiedSeason) {
            case (null) { 
                return { id = 0; seasonId = 0; gameweek = 0; kickOff = 0; awayTeamId = 0; homeTeamId = 0; homeGoals = 0; awayGoals = 0; status = 0; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0;};
            };
            case (?s) { 
                let modifiedGameweek = List.find<T.Gameweek>(s.gameweeks, func (gw: T.Gameweek): Bool {
                    return gw.number == gameweek;
                });

                switch(modifiedGameweek) {
                    case (null) { return { id = 0; seasonId = 0; gameweek = 0; kickOff = 0; awayTeamId = 0; homeTeamId = 0; homeGoals = 0; awayGoals = 0; status = 0; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0;}; };
                    case (?gw) {
                        let modifiedFixture = List.find<T.Fixture>(gw.fixtures, func (f: T.Fixture): Bool {
                            return f.id == fixtureId;
                        });

                        switch(modifiedFixture) {
                            case (null) { return { id = 0; seasonId = 0; gameweek = 0; kickOff = 0; awayTeamId = 0; homeTeamId = 0; homeGoals = 0; awayGoals = 0; status = 0; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0;}; };
                            case (?f) { return f; };
                        };
                    };
                };
            };
        };
    };

    public func updateHighestPlayerIds(seasonId: Nat16, gameweek: Nat8, updatedFixtures: [T.Fixture]) : async () {
        seasons := List.map<T.Season, T.Season>(seasons, func (season: T.Season): T.Season {
            if (season.id == seasonId) {
                let updatedGameweeks = List.map<T.Gameweek, T.Gameweek>(season.gameweeks, func (gw: T.Gameweek): T.Gameweek {
                    if (gw.number == gameweek) {
                        let newFixtures = List.map<T.Fixture, T.Fixture>(gw.fixtures, func (fixture: T.Fixture): T.Fixture {
                            for (updatedFixture in List.toIter(List.fromArray(updatedFixtures))) {
                                if (fixture.id == updatedFixture.id) {
                                    return updatedFixture;
                                }
                            };
                            return fixture;
                        });

                        return {id = gw.id; number = gw.number; canisterId = gw.canisterId; fixtures = newFixtures};
                    } else {
                        return gw;
                    };
                });
                
                return {id = season.id; name = season.name; year = season.year; gameweeks = updatedGameweeks};
            } else {
                return season;
            }
        });
    };

    private func subText(value : Text, indexStart : Nat, indexEnd : Nat) : Text {
        if (indexStart == 0 and indexEnd >= value.size()) {
            return value;
        }
        else if (indexStart >= value.size()) {
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

  }
}
