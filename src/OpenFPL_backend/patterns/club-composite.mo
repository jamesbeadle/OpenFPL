module {

  public class SnapshotManager() {
    /*
    
    //ClubComposite //implements composite allows changes to players clubs
    club-composite.mo
Purpose: Manages club-related information, encapsulating operations that can be performed on clubs.
Contents:
A Club class representing the details of a football club.
A ClubComposite class that allows uniform operations across all clubs or specific subsets.
Methods for adding, updating, and removing clubs, as well as aggregating club statistics.
    
private var teams = List.fromArray<T.Team>([]);
    private var nextTeamId : Nat16 = 21;
    private var relegatedTeams = List.fromArray<T.Team>([]);

    public func setData(stable_teams : [T.Team], stable_teamId : Nat16, stable_relegated_teams : [T.Team]) {
      if (stable_teams == []) {
        return;
      };
      teams := List.fromArray(stable_teams);
      nextTeamId := stable_teamId;
      relegatedTeams := List.fromArray(stable_relegated_teams);
    };

    public func getTeams() : [T.Team] {
      let teamsArray = List.toArray(teams);
      let sortedArray = Array.sort(
        teamsArray,
        func(a : T.Team, b : T.Team) : Order.Order {
          if (a.name < b.name) { return #less };
          if (a.name == b.name) { return #equal };
          return #greater;
        },
      );
      let sortedTeams = List.fromArray(sortedArray);
      return sortedArray;
    };

    public func getTeam(teamId : T.TeamId) : ?T.Team {
      for (team in Iter.fromList(teams)) {
        if (team.id == teamId) {
          return ?team;
        };
      };
      return null;
    };

    public func getRelegatedTeams() : [T.Team] {
      return List.toArray(relegatedTeams);
    };

    public func getTeamName(teamId : Nat16) : Text {
      let foundTeam = List.find<T.Team>(
        teams,
        func(team : T.Team) : Bool {
          return team.id == teamId;
        },
      );

      switch (foundTeam) {
        case (null) { return "" };
        case (?team) {
          return team.name;
        };
      };
    };

    public func getNextTeamId() : Nat16 {
      return nextTeamId;
    };

    public func promoteFormerTeam(teamId : T.TeamId) : async () {
      let teamToPromote = List.find<T.Team>(relegatedTeams, func(t : T.Team) { t.id == teamId });
      switch (teamToPromote) {
        case (null) {};
        case (?team) {
          teams := List.push(team, teams);
          relegatedTeams := List.filter<T.Team>(
            relegatedTeams,
            func(currentTeam : T.Team) : Bool {
              return currentTeam.id != teamId;
            },
          );
        };
      };
    };

    public func promoteNewTeam(name : Text, friendlyName : Text, abbreviatedName : Text, primaryHexColour : Text, secondaryHexColour : Text, thirdHexColour : Text, shirtType : Nat8) : async () {
      let newTeam : T.Team = {
        id = nextTeamId;
        name = name;
        friendlyName = friendlyName;
        abbreviatedName = abbreviatedName;
        primaryColourHex = primaryHexColour;
        secondaryColourHex = secondaryHexColour;
        thirdColourHex = thirdHexColour;
        shirtType = shirtType;
      };
      teams := List.push(newTeam, teams);
      nextTeamId += 1;
    };

    public func updateTeam(teamId : T.TeamId, name : Text, abbreviatedName : Text, friendlyName : Text, primaryColourHex : Text, secondaryColourHex : Text, thirdHexColour : Text, shirtType : Nat8) : async () {

      teams := List.map<T.Team, T.Team>(
        teams,
        func(currentTeam : T.Team) : T.Team {
          if (currentTeam.id == teamId) {
            return {
              id = currentTeam.id;
              name = name;
              friendlyName = friendlyName;
              primaryColourHex = primaryColourHex;
              secondaryColourHex = secondaryColourHex;
              thirdColourHex = thirdHexColour;
              abbreviatedName = abbreviatedName;
              shirtType = shirtType;
            };
          } else {
            return currentTeam;
          };
        },
      );
    };

    public func reuploadTeams() : async () {
      teams := List.fromArray<T.Team>([
        {
          id = 1;
          secondaryColourHex = "#FFFFFF";
          thirdColourHex = "#F0DCBA";
          name = "Arsenal";
          friendlyName = "Arsenal";
          abbreviatedName = "ARS";
          primaryColourHex = "#D3121A";
          shirtType = 0;
        },
        {
          id = 2;
          secondaryColourHex = "#B7D7FE";
          thirdColourHex = "#FFFFFF";
          name = "Aston Villa";
          friendlyName = "Aston Villa";
          abbreviatedName = "AVL";
          primaryColourHex = "#CA3E69";
          shirtType = 0;
        },
        {
          id = 3;
          secondaryColourHex = "#262729";
          thirdColourHex = "#262729";
          name = "AFC Bournemouth";
          friendlyName = "Bournemouth";
          abbreviatedName = "BOU";
          primaryColourHex = "#CA2D26";
          shirtType = 1;
        },
        {
          id = 4;
          secondaryColourHex = "#FFFFFF";
          thirdColourHex = "#090F14";
          name = "Brentford";
          friendlyName = "Brentford";
          abbreviatedName = "BRE";
          primaryColourHex = "#CF2E26";
          shirtType = 1;
        },
        {
          id = 5;
          secondaryColourHex = "#124098";
          thirdColourHex = "#124098";
          name = "Brighton & Hove Albion";
          friendlyName = "Brighton";
          abbreviatedName = "BRI";
          primaryColourHex = "#FFFFFF";
          shirtType = 1;
        },
        {
          id = 6;
          secondaryColourHex = "#A5D9F7";
          thirdColourHex = "#FFFFFF";
          name = "Burnley";
          friendlyName = "Burnley";
          abbreviatedName = "BUR";
          primaryColourHex = "#781932";
          shirtType = 0;
        },
        {
          id = 7;
          secondaryColourHex = "#FFFFFF";
          thirdColourHex = "#020514";
          name = "Chelsea";
          friendlyName = "Chelsea";
          abbreviatedName = "CHE";
          primaryColourHex = "#2D57C7";
          shirtType = 0;
        },
        {
          id = 8;
          secondaryColourHex = "#E12F44";
          thirdColourHex = "#FFFFFF";
          name = "Crystal Palace";
          friendlyName = "Crystal Palace";
          abbreviatedName = "CRY";
          primaryColourHex = "#1A47A0";
          shirtType = 1;
        },
        {
          id = 9;
          secondaryColourHex = "#FFFFFF";
          thirdColourHex = "#13356D";
          name = "Everton";
          friendlyName = "Everton";
          abbreviatedName = "EVE";
          primaryColourHex = "#0F3DD1";
          shirtType = 0;
        },
        {
          id = 10;
          secondaryColourHex = "#B14C5C";
          thirdColourHex = "#000000";
          name = "Fulham";
          friendlyName = "Fulham";
          abbreviatedName = "FUL";
          primaryColourHex = "#FFFFFF";
          shirtType = 0;
        },
        {
          id = 11;
          secondaryColourHex = "#FFFFFF";
          thirdColourHex = "#2CC4B9";
          name = "Liverpool";
          friendlyName = "Liverpool";
          abbreviatedName = "LIV";
          primaryColourHex = "#E50113";
          shirtType = 0;
        },
        {
          id = 12;
          secondaryColourHex = "#FFFFFF";
          thirdColourHex = "#524360";
          name = "Luton Town";
          friendlyName = "Luton";
          abbreviatedName = "LUT";
          primaryColourHex = "#F46038";
          shirtType = 0;
        },
        {
          id = 13;
          secondaryColourHex = "#FFFFFF";
          thirdColourHex = "#A3E1FE";
          name = "Manchester City";
          friendlyName = "Man City";
          abbreviatedName = "MCI";
          primaryColourHex = "#569ECD";
          shirtType = 0;
        },
        {
          id = 14;
          secondaryColourHex = "#FFFFFF";
          thirdColourHex = "#FEF104";
          name = "Manchester United";
          friendlyName = "Man United";
          abbreviatedName = "MUN";
          primaryColourHex = "#C00814";
          shirtType = 0;
        },
        {
          id = 15;
          secondaryColourHex = "#1A1A1A";
          thirdColourHex = "#1A1A1A";
          name = "Newcastle United";
          friendlyName = "Newcastle";
          abbreviatedName = "NEW";
          primaryColourHex = "#FFFFFF";
          shirtType = 1;
        },
        {
          id = 16;
          secondaryColourHex = "#FFFFFF";
          thirdColourHex = "#FFFFFF";
          name = "Nottingham Forest";
          friendlyName = "Nottingham Forest";
          abbreviatedName = "NFO";
          primaryColourHex = "#BB212A";
          shirtType = 0;
        },
        {
          id = 17;
          secondaryColourHex = "#CF1E25";
          thirdColourHex = "#000000";
          name = "Sheffield United";
          friendlyName = "Sheffield United";
          abbreviatedName = "SHE";
          primaryColourHex = "#FFFFFF";
          shirtType = 1;
        },
        {
          id = 18;
          secondaryColourHex = "#001952";
          thirdColourHex = "#001952";
          name = "Tottenham Hotspur";
          friendlyName = "Tottenham";
          abbreviatedName = "TOT";
          primaryColourHex = "#FFFFFF";
          shirtType = 0;
        },
        {
          id = 19;
          secondaryColourHex = "#A7DAF9";
          thirdColourHex = "#F1D655";
          name = "West Ham United";
          friendlyName = "West Ham";
          abbreviatedName = "WHU";
          primaryColourHex = "#6D202A";
          shirtType = 0;
        },
        {
          id = 20;
          secondaryColourHex = "#2D2D23";
          thirdColourHex = "#2D2D23";
          name = "Wolverhampton Wanderers";
          friendlyName = "Wolves";
          abbreviatedName = "WOL";
          primaryColourHex = "#F7CA3B";
          shirtType = 0;
        },
      ]);
    };


    */
  };
};
