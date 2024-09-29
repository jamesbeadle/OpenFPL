  import Array "mo:base/Array";
  import Bool "mo:base/Bool";
  import Buffer "mo:base/Buffer";
  import Int "mo:base/Int";
  import Principal "mo:base/Principal";
  import Result "mo:base/Result";
  import Timer "mo:base/Timer";
  import Order "mo:base/Order";
  import Debug "mo:base/Debug";
  import Text "mo:base/Text";
  import Time "mo:base/Time";
  import Iter "mo:base/Iter";
  import TrieMap "mo:base/TrieMap";

  import T "../shared/types";
  import DTOs "../shared/DTOs";
  import Utilities "../shared/utils/utilities";

  actor Self {
      
    private stable var leagues : [T.FootballLeague] = [
      {
        name = "Premier League";
        abbreviation = "EPL";
        numOfTeams = 20;
        relatedGender = #Male;
        governingBody = "FA";
        countryId = 186;
        formed = 698544000000000000;
      },
      {
        name = "Women's Super League";
        abbreviation = "WSL";
        numOfTeams = 12;
        relatedGender = #Female;
        governingBody = "FA";
        countryId = 186;
        formed = 1269388800000000000;
      }
    ];

    private stable var leagueSeasons: [(T.FootballLeagueId, T.Season)] = [];
    private stable var leagueClubs: [(T.FootballLeagueId, [T.Club])] = [];
    private stable var leaguePlayers: [(T.FootballLeagueId, [T.Player])] = [];

    private stable var freeAgents: [T.Player] = [];
    private stable var retiredPlayers: [T.Player] = [];
    private stable var unknownPlayers: [T.Player] = [];

    private stable var untrackedClubs: [T.Club] = [];
    private stable var clubsInAdministration: [T.Club] = [];

    

    system func preupgrade() {

    };

    system func postupgrade() {
    
    };


    

  };
