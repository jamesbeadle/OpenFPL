import List "mo:base/List";
import Result "mo:base/Result";
import Types "types";
import Debug "mo:base/Debug";
import Array "mo:base/Array";
import Order "mo:base/Order";

module {
    
  public class Teams(){

    private var genesis_teams: [Types.Team] = [
        { id = 1; name = "Arsenal"; primaryColourHex = "#f00000"; secondaryColourHex = "#ffffff"; friendlyName = "Arsenal"; abbreviatedName = "ARS"; },
        { id = 2; name = "Aston Villa"; primaryColourHex = "#7d1142"; secondaryColourHex = "#ffffff"; friendlyName = "Aston Villa"; abbreviatedName = "AVL"; },
        { id = 3; name = "AFC Bournemouth"; primaryColourHex = "#d71921"; secondaryColourHex = "#ffffff"; friendlyName = "Bournemouth"; abbreviatedName = "BOU"; },
        { id = 4; name = "Brentford"; primaryColourHex = "#c10000"; secondaryColourHex = "#ffffff"; friendlyName = "Brentford"; abbreviatedName = "BRE"; },
        { id = 5; name = "Brighton & Hove Albion"; primaryColourHex = "#004b95"; secondaryColourHex = "#ffffff"; friendlyName = "Brighton"; abbreviatedName = "BRI"; },
        { id = 6; name = "Burnley"; primaryColourHex = "#5e1444"; secondaryColourHex = "#f2f2f2"; friendlyName = "Burnley";  abbreviatedName = "BUR";},
        { id = 7; name = "Chelsea"; primaryColourHex = "#001b71"; secondaryColourHex = "#ffffff"; friendlyName = "Chelsea";  abbreviatedName = "CHE";},
        { id = 8; name = "Crystal Palace"; primaryColourHex = "#e91d12"; secondaryColourHex = "#0055a5"; friendlyName = "Crystal Palace";  abbreviatedName = "CRY";},
        { id = 9; name = "Everton"; primaryColourHex = "#0a0ba1"; secondaryColourHex = "#ffffff"; friendlyName = "Everton";  abbreviatedName = "EVE";},
        { id = 10; name = "Fulham"; primaryColourHex = "#000000"; secondaryColourHex = "#e5231b"; friendlyName = "Fulham";  abbreviatedName = "FUL";},
        { id = 11; name = "Liverpool"; primaryColourHex = "#dc0714"; secondaryColourHex = "#ffffff"; friendlyName = "Liverpool";  abbreviatedName = "LIV";},
        { id = 12; name = "Luton Town"; primaryColourHex = "#f36f24"; secondaryColourHex = "#fefefe"; friendlyName = "Luton";  abbreviatedName = "LUT";},
        { id = 13; name = "Manchester City"; primaryColourHex = "#98c5e9"; secondaryColourHex = "#ffffff"; friendlyName = "Man City";  abbreviatedName = "MCI";},
        { id = 14; name = "Manchester United"; primaryColourHex = "#c70101"; secondaryColourHex = "#ffffff"; friendlyName = "Man United";  abbreviatedName = "MUN";},
        { id = 15; name = "Newcastle United"; primaryColourHex = "#000000"; secondaryColourHex = "#ffffff"; friendlyName = "Newcastle";  abbreviatedName = "NEW";},
        { id = 16; name = "Nottingham Forest"; primaryColourHex = "#c8102e"; secondaryColourHex = "#efefef"; friendlyName = "Nottingham Forest";  abbreviatedName = "NFO";},
        { id = 17; name = "Sheffield United"; primaryColourHex = "#e20c17"; secondaryColourHex = "#1d1d1b"; friendlyName = "Sheffield United";  abbreviatedName = "SHE";},
        { id = 18; name = "Tottenham Hotspur"; primaryColourHex = "#ffffff"; secondaryColourHex = "#0b0e1e"; friendlyName = "Tottenham";  abbreviatedName = "TOT";},
        { id = 19; name = "West Ham United"; primaryColourHex = "#7c2c3b"; secondaryColourHex = "#2dafe5"; friendlyName = "West Ham";  abbreviatedName = "WHU";},
        { id = 20; name = "Wolverhampton Wanderers"; primaryColourHex = "#fdb913"; secondaryColourHex = "#231f20"; friendlyName = "Wolves";  abbreviatedName = "WOL";}
    ];
    private var teams = List.fromArray(genesis_teams);
    private var nextTeamId : Nat16 = 21;

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

    public func createTeam(name : Text, friendlyName: Text, primaryColourHex: Text, secondaryColourHex: Text, abbreviatedName: Text) : Result.Result<(), Types.Error> {
        let id = nextTeamId;
        let newTeam : Types.Team = {
            id = id;
            name = name;
            friendlyName = friendlyName;
            primaryColourHex = primaryColourHex;
            secondaryColourHex = secondaryColourHex;
            abbreviatedName = abbreviatedName;
        };
        
        var newTeamList = List.nil<Types.Team>();
        newTeamList := List.push(newTeam, newTeamList);

        teams := List.append(teams, newTeamList);
        
        nextTeamId := nextTeamId + 1;
        return #ok(());
    };

    public func updateTeam(id : Nat16, name : Text, properName: Text, homeColourHex: Text, awayColourHex: Text, abbreviatedName: Text) : Result.Result<(), Types.Error> {
        teams := List.map<Types.Team, Types.Team>(teams,
        func (team: Types.Team): Types.Team {
            if (team.id == id) {
            { id = team.id; name = name; friendlyName = team.friendlyName; primaryColourHex = team.primaryColourHex; secondaryColourHex = team.secondaryColourHex; abbreviatedName = abbreviatedName; }
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
