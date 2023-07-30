import List "mo:base/List";
import Result "mo:base/Result";
import T "types";
import Array "mo:base/Array";
import Order "mo:base/Order";
import GenesisData "genesis-data";

module {
    
  public class Teams(){

    private var teams = List.fromArray(GenesisData.get_genesis_teams());
    private var nextTeamId : Nat16 = 21;

    public func setData(stable_teams: [T.Team], stable_teamId : Nat16){
        teams := List.fromArray(stable_teams);
        nextTeamId := stable_teamId;
    };

    public func getTeams() : [T.Team] {
        let teamsArray = List.toArray(teams);
        let sortedArray = Array.sort(teamsArray, func (a: T.Team, b: T.Team): Order.Order {
            if (a.name < b.name) { return #less; };
            if (a.name == b.name) { return #equal; };
            return #greater;
        });
        let sortedTeams = List.fromArray(sortedArray);
        return sortedArray;
    };

    public func getTeamName(teamId: Nat16) : Text {
        let foundTeam = List.find<T.Team>(teams, func (team: T.Team): Bool {
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

    public func createTeam(name : Text, friendlyName: Text, primaryColourHex: Text, secondaryColourHex: Text, abbreviatedName: Text) : Result.Result<(), T.Error> {
        let id = nextTeamId;
        let newTeam : T.Team = {
            id = id;
            name = name;
            friendlyName = friendlyName;
            primaryColourHex = primaryColourHex;
            secondaryColourHex = secondaryColourHex;
            abbreviatedName = abbreviatedName;
        };
        
        var newTeamList = List.nil<T.Team>();
        newTeamList := List.push(newTeam, newTeamList);

        teams := List.append(teams, newTeamList);
        
        nextTeamId += 1;
        return #ok(());
    };

/*
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
    */

    public func deleteTeam(id : Nat16) : Result.Result<(), T.Error> {
        teams := List.filter(teams, func(team: T.Team): Bool { team.id != id });
        return #ok(());
    };

    public func promoteTeam(proposalPayload: T.PromoteTeamPayload) : async () {
    };

    public func relegateTeam(proposalPayload: T.RelegateTeamPayload) : async () {
    };

    public func updateTeam(proposalPayload: T.UpdateTeamPayload) : async () {
    };

  }
}
