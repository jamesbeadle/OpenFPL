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
    private var relegatedTeams = List.fromArray<T.Team>([]);

    public func setData(stable_teams: [T.Team], stable_teamId : Nat16, stable_relegated_teams: [T.Team]){
        if(stable_teams == []){
            return;
        };
        teams := List.fromArray(stable_teams);
        nextTeamId := stable_teamId;
        relegatedTeams := List.fromArray(stable_relegated_teams);
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

    public func getRelegatedTeams() : [T.Team] {
        return List.toArray(relegatedTeams);
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

    public func promoteTeam(proposalPayload: T.PromoteTeamPayload) : async () {
        let teamToPromote = List.find<T.Team>(relegatedTeams, func(t: T.Team) { t.id == proposalPayload.teamId });
        switch(teamToPromote) {
            case (null) {
                let newTeam : T.Team = {
                    id = proposalPayload.teamId;
                    name = proposalPayload.name;
                    friendlyName = proposalPayload.friendlyName;
                    primaryColourHex = proposalPayload.primaryColourHex;
                    secondaryColourHex = proposalPayload.secondaryColourHex;
                    abbreviatedName = proposalPayload.abbreviatedName;
                };
                teams := List.push(newTeam, teams);
            };
            case (?team) {
                teams := List.push(team, teams);
                relegatedTeams := List.filter<T.Team>(relegatedTeams, func(currentTeam: T.Team) : Bool {
                    return currentTeam.id != proposalPayload.teamId;
                });
            };
        };
    };

    public func relegateTeam(proposalPayload: T.RelegateTeamPayload) : async () {
        let teamToRelegate = List.find<T.Team>(teams, func(t: T.Team) { t.id == proposalPayload.teamId });
        switch(teamToRelegate) {
            case (null) { };
            case (?team) {
                relegatedTeams := List.push(team, relegatedTeams);
                teams := List.filter<T.Team>(teams, func(currentTeam: T.Team) : Bool {
                    return currentTeam.id != proposalPayload.teamId;
                });
            };
        };
    };

    public func updateTeam(proposalPayload: T.UpdateTeamPayload) : async () {
        teams := List.map<T.Team, T.Team>(teams, func(currentTeam: T.Team) : T.Team {
            if (currentTeam.id == proposalPayload.teamId) {
                return {
                    id = currentTeam.id;
                    name = proposalPayload.name;
                    friendlyName = proposalPayload.friendlyName;
                    primaryColourHex = proposalPayload.primaryColourHex;
                    secondaryColourHex = proposalPayload.secondaryColourHex;
                    abbreviatedName = proposalPayload.abbreviatedName;
                };
            } else {
                return currentTeam;
            }
        });
    };


  }
}
