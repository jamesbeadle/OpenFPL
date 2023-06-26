import List "mo:base/List";
import Result "mo:base/Result";
import Types "types";
import Debug "mo:base/Debug";
import Array "mo:base/Array";
import Order "mo:base/Order";

module {
    
  public class Teams(){

    private var genesis_teams: [Types.Team] = [
        { id = 1; properName = "Arsenal"; homeColourHex = ""; awayColourHex = ""; name = "Arsenal"; players = [] },
        { id = 2; properName = "Aston Villa"; homeColourHex = ""; awayColourHex = ""; name = "Aston Villa"; players = [] },
        { id = 3; properName = "AFC Bournemouth"; homeColourHex = ""; awayColourHex = ""; name = "Bournemouth"; players = [] },
        { id = 4; properName = "Brentford"; homeColourHex = ""; awayColourHex = ""; name = "Brentford"; players = [] },
        { id = 5; properName = "Brighton & Hove Albion"; homeColourHex = ""; awayColourHex = ""; name = "Brighton"; players = [] },
        { id = 6; properName = "Burnley"; homeColourHex = ""; awayColourHex = ""; name = "Burnley"; players = [] },
        { id = 7; properName = "Chelsea"; homeColourHex = ""; awayColourHex = ""; name = "Chelsea"; players = [] },
        { id = 8; properName = "Crystal Palace"; homeColourHex = ""; awayColourHex = ""; name = "Crystal Palace"; players = [] },
        { id = 9; properName = "Everton"; homeColourHex = ""; awayColourHex = ""; name = "Everton"; players = [] },
        { id = 10; properName = "Fulham"; homeColourHex = ""; awayColourHex = ""; name = "Fulham"; players = [] },
        { id = 11; properName = "Liverpool"; homeColourHex = ""; awayColourHex = ""; name = "Liverpool"; players = [] },
        { id = 12; properName = "Luton Town"; homeColourHex = ""; awayColourHex = ""; name = "Luton"; players = [] },
        { id = 13; properName = "Manchester City"; homeColourHex = ""; awayColourHex = ""; name = "Man City"; players = [] },
        { id = 14; properName = "Manchester United"; homeColourHex = ""; awayColourHex = ""; name = "Man United"; players = [] },
        { id = 15; properName = "Newcastle United"; homeColourHex = ""; awayColourHex = ""; name = "Newcastle"; players = [] },
        { id = 16; properName = "Nottingham Forest"; homeColourHex = ""; awayColourHex = ""; name = "Nottingham Forest"; players = [] },
        { id = 17; properName = "Sheffield United"; homeColourHex = ""; awayColourHex = ""; name = "Sheffield United"; players = [] },
        { id = 18; properName = "Tottenham Hotspur"; homeColourHex = ""; awayColourHex = ""; name = "Tottenham"; players = [] },
        { id = 19; properName = "West Ham United"; homeColourHex = ""; awayColourHex = ""; name = "West Ham"; players = [] },
        { id = 20; properName = "Wolverhampton Wanderers"; homeColourHex = ""; awayColourHex = ""; name = "Wolves"; players = [] }
    ];
    private var teams = List.fromArray(genesis_teams);
    private var nextTeamId : Nat16 = 1;

    public func setData(stable_teams: [Types.Team], stable_teamId : Nat16){
        teams := List.fromArray(stable_teams);
        nextTeamId := stable_teamId;
    };

    public func getTeams() : [Types.Team] {
        let teamsArray = List.toArray(teams);
        let sortedArray = Array.sort(teamsArray, func (a: Types.Team, b: Types.Team): Order.Order {
            if (a.name < b.name) { return #less; };
            if (a.name == b.name) { return #equal; };
            return #greater;
        });
        let sortedTeams = List.fromArray(sortedArray);
        return sortedArray;
    };

    public func getTeamName(teamId: Nat16) : Text {
        let foundTeam = List.find<Types.Team>(teams, func (team: Types.Team): Bool {
            return team.id == teamId;
        });

        switch (foundTeam) {
            case (null) { return "" };
            case (?team) {
                return team.name;
            };
        };
    };

    public func getNextTeamId() : Nat16{
        return nextTeamId;
    };

    public func createTeam(name : Text, properName: Text, homeColourHex: Text, awayColourHex: Text) : Result.Result<(), Types.Error> {
        let id = nextTeamId;
        let newTeam : Types.Team = {
            id = id;
            name = name;
            properName = properName;
            homeColourHex = homeColourHex;
            awayColourHex = awayColourHex;
            players = [];
        };
        
        var newTeamList = List.nil<Types.Team>();
        newTeamList := List.push(newTeam, newTeamList);

        teams := List.append(teams, newTeamList);
        
        nextTeamId := nextTeamId + 1;
        return #ok(());
    };

    public func updateTeam(id : Nat16, name : Text, properName: Text, homeColourHex: Text, awayColourHex: Text) : Result.Result<(), Types.Error> {
        teams := List.map<Types.Team, Types.Team>(teams,
        func (team: Types.Team): Types.Team {
            if (team.id == id) {
            { id = team.id; name = name; players = team.players; properName = team.properName; homeColourHex = team.homeColourHex; awayColourHex = team.awayColourHex; }
            } 
            else { team }
        });

        return #ok(());
    };

    public func deleteTeam(id : Nat16) : Result.Result<(), Types.Error> {
        teams := List.filter(teams, func(team: Types.Team): Bool { team.id != id });
        return #ok(());
    };

  }
}
