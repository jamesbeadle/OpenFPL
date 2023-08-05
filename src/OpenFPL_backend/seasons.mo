import List "mo:base/List";
import Result "mo:base/Result";
import T "types";
import Array "mo:base/Array";
import Order "mo:base/Order";
import GenesisData "genesis-data";
import Nat16 "mo:base/Nat16";
import Iter "mo:base/Iter";
import Text "mo:base/Text";
import Char "mo:base/Char";
import Nat8 "mo:base/Nat8";
import Timer "mo:base/Timer";
import Int "mo:base/Int";

module {
    
  public class Seasons(){
    private var seasons = List.fromArray(GenesisData.get_genesis_seasons());

    private var nextFixtureId : Nat32 = 381;
    private var nextSeasonId : Nat16 = 2;

    public func setSeasons(stable_seasons: [T.Season]){
        if(stable_seasons == []){
            return;
        };
        seasons := List.fromArray(stable_seasons);
    };

    public func getSeasons() : [T.Season] {
        List.toArray(seasons);
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

    public func getNextSeasonId() : Nat16{
        return nextSeasonId;
    };

    public func getNextFixtureId() : Nat32{
        return nextFixtureId;
    };

    public func setNextSeasonId(stable_next_season_id: Nat16) : (){
        nextSeasonId := stable_next_season_id;
    };

    public func setNextFixtureId(stable_next_fixture_id: Nat32) : (){
        nextFixtureId := stable_next_fixture_id;
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
                let gameweeks: [T.Gameweek] = Array.tabulate<T.Gameweek>(38, func (index: Nat) : T.Gameweek{
                    return {
                        number = Nat8.fromNat(index + 1);
                        canisterId = "";
                        fixtures = List.nil<T.Fixture>();
                    };
                });

                let newSeason: T.Season = {
                    id = nextSeasonId;
                    name = Nat16.toText(newYear) # subText(Nat16.toText(newYear + 1), 2, 3);
                    year = newYear;
                    gameweeks = List.nil();
                    postponedFixtures = List.nil();
                };

                newSeasonsList := List.push(newSeason, newSeasonsList);
                seasons := List.append(seasons, newSeasonsList);
                nextSeasonId += 1;
            };
        };
    };

    public func getSeason(seasonId: Nat16) : async T.Season {
        let season = List.find<T.Season>(seasons, func (season: T.Season): Bool {
            return season.id == seasonId;
        });
        switch(season){
            case (null) { return {gameweeks= List.nil<T.Gameweek>(); id = 0; name = ""; postponedFixtures = List.nil<T.Fixture>(); year = 0;  }  };
            case (?foundSeason){
                return {
                    id = foundSeason.id; 
                    name = foundSeason.name; 
                    year = foundSeason.year;  
                    gameweeks= List.nil<T.Gameweek>(); 
                    postponedFixtures = List.nil<T.Fixture>(); 
                } };
        };
    };

    public func getFixture(seasonId: T.SeasonId, gameweekNumber: T.GameweekNumber, fixtureId: T.FixtureId) : async T.Fixture {
        let emptyFixture: T.Fixture = { 
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

        let season = List.find<T.Season>(seasons, func (season: T.Season): Bool {
            return season.id == seasonId;
        });
        switch(season){
            case (null) { return emptyFixture; };
            case (?foundSeason){
                let gameweek = List.find<T.Gameweek>(foundSeason.gameweeks, func (gameweek: T.Gameweek): Bool {
                    return gameweek.number == gameweekNumber;
                });

                switch(gameweek){
                    case (null){ return emptyFixture; };
                    case (?foundGameweek){
                        let fixture = List.find<T.Fixture>(foundGameweek.fixtures, func (fixture: T.Fixture): Bool {
                            return fixture.id == fixtureId;
                        });
                        switch(fixture){
                            case (null){ return emptyFixture; };
                            case (?foundFixture){ return foundFixture; };
                        };
                    };
                };
            };
        };
    };

    public func updateStatus(seasonId: Nat16, gameweek: Nat8, fixtureId: Nat32, status: Nat8) : async T.Fixture {
    
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
                                    status = status;
                                    events = fixture.events;
                                    highestScoringPlayerId = fixture.highestScoringPlayerId;
                                };
                            } else {
                                return fixture;
                            }
                        });
                        return {number = gw.number; canisterId = gw.canisterId; fixtures = updatedFixtures};
                    } else {
                        return gw;
                    }
                });
                
                return {id = season.id; name = season.name; year = season.year; gameweeks = updatedGameweeks; postponedFixtures = season.postponedFixtures;};
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
                        return {number = gw.number; canisterId = gw.canisterId; fixtures = updatedFixtures};
                    } else {
                        return gw;
                    }
                });
                return {id = season.id; name = season.name; year = season.year; gameweeks = updatedGameweeks; postponedFixtures = season.postponedFixtures;};
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

                        return {number = gw.number; canisterId = gw.canisterId; fixtures = newFixtures};
                    } else {
                        return gw;
                    };
                });
                
                return {id = season.id; name = season.name; year = season.year; gameweeks = updatedGameweeks; postponedFixtures = season.postponedFixtures;};
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

    public func addInitialFixtures(proposalPayload: T.AddInitialFixturesPayload) : () {
        seasons := List.map<T.Season, T.Season>(seasons, func(currentSeason: T.Season) : T.Season {
            if (currentSeason.id == proposalPayload.seasonId) {

                var seasonGameweeks = List.nil<T.Gameweek>();

                for (i in Iter.range(1, 38)) {
                    let fixturesForCurrentGameweek = Array.filter<T.Fixture>(proposalPayload.fixtures, func (fixture: T.Fixture): Bool {
                        return Nat8.fromNat(i) == fixture.gameweek;
                    });

                    let newGameweek: T.Gameweek = {
                        id = i;
                        number = Nat8.fromNat(i);
                        canisterId = "";
                        fixtures = List.fromArray(fixturesForCurrentGameweek);
                    };

                    seasonGameweeks := List.push(newGameweek, seasonGameweeks);
                };

                return {
                    id = currentSeason.id;
                    name = currentSeason.name;
                    year = currentSeason.year;
                    gameweeks = seasonGameweeks;
                    postponedFixtures = currentSeason.postponedFixtures;
                };
            } else { return currentSeason; } });
    };

    public func getValidatableFixtures(activeSeasonId: Nat16, activeGameweek: Nat8) : [T.Fixture] {
        let season = List.find<T.Season>(seasons, func(s: T.Season) { s.id == activeSeasonId });
        switch(season) {
            case (null) { };
            case (?s) {
                let gameweeks = List.find<T.Gameweek>(s.gameweeks, func(gw: T.Gameweek) { gw.number == activeGameweek });
                switch(gameweeks){
                    case (null) { };
                    case (?gws) {
                        let validatableFixtures = List.filter<T.Fixture>(gws.fixtures, func(fixture: T.Fixture){
                            fixture.status == 2;
                        });
                        return List.toArray(validatableFixtures);
                    };
                };
            };
        };

        return [];
    };
    


  }
}
