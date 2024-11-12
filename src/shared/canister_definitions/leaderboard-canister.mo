import List "mo:base/List";
import Principal "mo:base/Principal";
import Text "mo:base/Text";
import Array "mo:base/Array";
import Order "mo:base/Order";
import Iter "mo:base/Iter";
import Buffer "mo:base/Buffer";
import Time "mo:base/Time";
import Timer "mo:base/Timer";
import Int "mo:base/Int";
import Option "mo:base/Option";
import Nat16 "mo:base/Nat16";
import Nat8 "mo:base/Nat8";
import Nat "mo:base/Nat";

import DTOs "../../shared/dtos/DTOs";
import Base "../../shared/types/base_types";
import FootballTypes "../../shared/types/football_types";
import T "../../shared/types/app_types";
import Utilities "../../shared/utils/utilities";
import Environment "../network_environment_variables";

actor class _LeaderboardCanister() {
  
  private stable var weekly_leaderboards : [T.WeeklyLeaderboard] = [];
  private stable var monthly_leaderboards : [T.MonthlyLeaderboard] = [];
  private stable var season_leaderboards : [T.SeasonLeaderboard] = [];

  private stable var entryUpdatesAllowed = false;
  private stable var controllerPrincipalId = "";
  private stable var initialised = false;
  
  //remove debug only
  public shared func getWeeklyLeaderboards() : async [T.WeeklyLeaderboard]{
    return weekly_leaderboards;
  };

  public shared ({caller}) func initialise(_controllerPrincipalId: Text) : async (){
    if(initialised){
      return;
    };

    let callerInArray = Array.find<Base.CanisterId>([Environment.OPENFPL_BACKEND_CANISTER_ID, Environment.OPENWSL_BACKEND_CANISTER_ID], func(canisterId: Base.CanisterId) : Bool{
      canisterId == Principal.toText(caller);
    });

    if(Option.isSome(callerInArray)){
      controllerPrincipalId := _controllerPrincipalId;
    };
    initialised := true;
  };

  public shared ({ caller }) func prepareForUpdate(seasonId: FootballTypes.SeasonId, month: Base.CalendarMonth, gameweek: FootballTypes.GameweekNumber, clubId: FootballTypes.ClubId) : async () {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == controllerPrincipalId;

    if(month == 0 and gameweek == 0){
      season_leaderboards := Array.filter<T.SeasonLeaderboard>(season_leaderboards, func(leaderboard: T.SeasonLeaderboard) : Bool{
        leaderboard.seasonId != seasonId;
      });
      return;
    };

    if(month > 0){
      monthly_leaderboards := Array.filter<T.MonthlyLeaderboard>(monthly_leaderboards, func(leaderboard: T.MonthlyLeaderboard) : Bool{
        leaderboard.seasonId != seasonId and leaderboard.month != month and leaderboard.clubId != clubId;
      });
      return;
    };
    weekly_leaderboards := Array.filter<T.WeeklyLeaderboard>(weekly_leaderboards, func(leaderboard: T.WeeklyLeaderboard) : Bool{
      leaderboard.seasonId != seasonId and leaderboard.gameweek != gameweek;
    });
    entryUpdatesAllowed := true;
  };

  public shared ({ caller }) func addLeaderboardChunk(seasonId: FootballTypes.SeasonId, month: Base.CalendarMonth, gameweek: FootballTypes.GameweekNumber, clubId: FootballTypes.ClubId, entriesChunk : [T.LeaderboardEntry]) : async () {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == controllerPrincipalId;

    if(month == 0 and gameweek == 0){
      addSeasonLeaderboardChunk(seasonId, entriesChunk);
      return;
    };

    if(month == 0){
      addGameweekLeaderboardChunk(seasonId, gameweek, entriesChunk);
      return;
    };

    addMonthLeaderboardChunk(seasonId, month, clubId, entriesChunk);
  };

  public shared ({ caller }) func finaliseUpdate(seasonId: FootballTypes.SeasonId, month: Base.CalendarMonth, gameweek: FootballTypes.GameweekNumber) : async () {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == controllerPrincipalId;
    entryUpdatesAllowed := false;

    await calculateLeaderboards(seasonId, gameweek, month);
  };

  private func addGameweekLeaderboardChunk(seasonId: FootballTypes.SeasonId, gameweek: FootballTypes.GameweekNumber, entriesChunk : [T.LeaderboardEntry]){
    var currentLeaderboard: ?T.WeeklyLeaderboard = null;

    currentLeaderboard := Array.find(weekly_leaderboards, func(leaderboard: T.WeeklyLeaderboard) : Bool {
      leaderboard.seasonId == seasonId and leaderboard.gameweek == gameweek;
    });

    
    
    switch(currentLeaderboard){
      case (?foundLeaderboard){
        weekly_leaderboards := Array.map<T.WeeklyLeaderboard, T.WeeklyLeaderboard>(weekly_leaderboards, func(leaderboard: T.WeeklyLeaderboard){
          if(leaderboard.seasonId == foundLeaderboard.seasonId and leaderboard.gameweek == foundLeaderboard.gameweek){
            
            let updatedLeaderboardEntries = List.append<T.LeaderboardEntry>(leaderboard.entries, List.fromArray(entriesChunk));
            return {
              entries = updatedLeaderboardEntries;
              gameweek = leaderboard.gameweek;
              seasonId = leaderboard.seasonId;
              totalEntries = List.size(updatedLeaderboardEntries);
            };
          } else {
            return leaderboard;
          }
        });
      };
      case (null) {
        let weeklyLeaderboardsBuffer = Buffer.fromArray<T.WeeklyLeaderboard>(weekly_leaderboards);
        weeklyLeaderboardsBuffer.add({
          entries = List.fromArray(entriesChunk);
          gameweek = gameweek;
          seasonId = seasonId;
          totalEntries = Array.size(entriesChunk);
        });
        
        weekly_leaderboards := Buffer.toArray(weeklyLeaderboardsBuffer);
      }
    };
  };

  private func addMonthLeaderboardChunk(seasonId: FootballTypes.SeasonId, month: Base.CalendarMonth, clubId: FootballTypes.ClubId, entriesChunk : [T.LeaderboardEntry]){
    var currentLeaderboard: ?T.MonthlyLeaderboard = null;

    currentLeaderboard := Array.find(monthly_leaderboards, func(leaderboard: T.MonthlyLeaderboard) : Bool {
      leaderboard.seasonId == seasonId and leaderboard.month == month and leaderboard.clubId == clubId;
    });

    
    
    switch(currentLeaderboard){
      case (?foundLeaderboard){
        monthly_leaderboards := Array.map<T.MonthlyLeaderboard, T.MonthlyLeaderboard>(monthly_leaderboards, func(leaderboard: T.MonthlyLeaderboard){
          if(leaderboard.seasonId == foundLeaderboard.seasonId and leaderboard.month == foundLeaderboard.month and leaderboard.clubId == foundLeaderboard.clubId){
            
            let updatedLeaderboardEntries = List.append<T.LeaderboardEntry>(leaderboard.entries, List.fromArray(entriesChunk));
            return {
              entries = updatedLeaderboardEntries;
              month = leaderboard.month;
              clubId = leaderboard.clubId;
              seasonId = leaderboard.seasonId;
              totalEntries = List.size(updatedLeaderboardEntries);
            };
          } else {
            return leaderboard;
          }
        });
      };
      case (null) {
        let monthlyLeaderboardsBuffer = Buffer.fromArray<T.MonthlyLeaderboard>(monthly_leaderboards);
        monthlyLeaderboardsBuffer.add({
          entries = List.fromArray(entriesChunk);
          month = month;
          clubId = clubId;
          seasonId = seasonId;
          totalEntries = Array.size(entriesChunk);
        });
        
        monthly_leaderboards := Buffer.toArray(monthlyLeaderboardsBuffer);
      }
    };
  };

  private func addSeasonLeaderboardChunk(seasonId: FootballTypes.SeasonId, entriesChunk : [T.LeaderboardEntry]){
    var currentLeaderboard: ?T.SeasonLeaderboard = null;

    currentLeaderboard := Array.find(season_leaderboards, func(leaderboard: T.SeasonLeaderboard) : Bool {
      leaderboard.seasonId == seasonId;
    });

    
    
    switch(currentLeaderboard){
      case (?foundLeaderboard){
        season_leaderboards := Array.map<T.SeasonLeaderboard, T.SeasonLeaderboard>(season_leaderboards, func(leaderboard: T.SeasonLeaderboard){
          if(leaderboard.seasonId == foundLeaderboard.seasonId){
            
            let updatedLeaderboardEntries = List.append<T.LeaderboardEntry>(leaderboard.entries, List.fromArray(entriesChunk));
            return {
              entries = updatedLeaderboardEntries;
              seasonId = leaderboard.seasonId;
              totalEntries = List.size(updatedLeaderboardEntries);
            };
          } else {
            return leaderboard;
          }
        });
      };
      case (null) {
        let seasonLeaderboardsBuffer = Buffer.fromArray<T.SeasonLeaderboard>(season_leaderboards);
        seasonLeaderboardsBuffer.add({
          entries = List.fromArray(entriesChunk);
          seasonId = seasonId;
          totalEntries = Array.size(entriesChunk);
        });
        
        season_leaderboards := Buffer.toArray(seasonLeaderboardsBuffer);
      }
    };
  };

  private func calculateLeaderboards(seasonId: FootballTypes.SeasonId, gameweek: FootballTypes.GameweekNumber, month: Base.CalendarMonth) : async (){
    
    
    if(month == 0 and gameweek == 0){
      calculateSeasonLeaderboard(seasonId);
      return;
    };  

    if(gameweek == 0){
      calculateMonthlyLeaderboards(seasonId, month);
      return;
    };

    await calculateWeeklyLeaderboard(seasonId, gameweek); 
  };

  private func calculateSeasonLeaderboard(seasonId: FootballTypes.SeasonId){

    var currentLeaderboard: ?T.SeasonLeaderboard = null;

    currentLeaderboard := Array.find(season_leaderboards, func(leaderboard: T.SeasonLeaderboard) : Bool {
      leaderboard.seasonId == seasonId
    });
    
    switch(currentLeaderboard){
      case (?foundLeaderboard){

        let sortedGameweekEntries = Array.sort(List.toArray(foundLeaderboard.entries), func(entry1: T.LeaderboardEntry, entry2: T.LeaderboardEntry) : Order.Order{
          if (entry1.points < entry2.points) { return #greater };
          if (entry1.points == entry2.points) { return #equal };
              return #less;
        });

        let positionedGameweekEntries = Utilities.assignPositionText(List.fromArray<T.LeaderboardEntry>(sortedGameweekEntries));

        var updatedLeaderboard: T.SeasonLeaderboard = {
          seasonId = foundLeaderboard.seasonId;
          entries = positionedGameweekEntries;
          totalEntries = List.size(positionedGameweekEntries);
        };
        season_leaderboards := Array.map<T.SeasonLeaderboard, T.SeasonLeaderboard>(season_leaderboards, func(leaderboard: T.SeasonLeaderboard){
          if(leaderboard.seasonId == seasonId){
            return updatedLeaderboard;
          } else { return leaderboard };
        });
      };
      case (null){}
    };   
  };

  private func calculateMonthlyLeaderboards(seasonId: FootballTypes.SeasonId, month: Base.CalendarMonth){
    
    let currentLeaderboards = Array.filter(monthly_leaderboards, func(leaderboard: T.MonthlyLeaderboard) : Bool {
      leaderboard.seasonId == seasonId and month == month
    });

    for(monthlyLeaderboard in Iter.fromArray(currentLeaderboards)){

      let sortedGameweekEntries = Array.sort(List.toArray(monthlyLeaderboard.entries), func(entry1: T.LeaderboardEntry, entry2: T.LeaderboardEntry) : Order.Order{
        if (entry1.points < entry2.points) { return #greater };
        if (entry1.points == entry2.points) { return #equal };
            return #less;
      });

      let positionedGameweekEntries = Utilities.assignPositionText(List.fromArray<T.LeaderboardEntry>(sortedGameweekEntries));

      var updatedLeaderboard: T.MonthlyLeaderboard = {
        seasonId = monthlyLeaderboard.seasonId;
        entries = positionedGameweekEntries;
        totalEntries = List.size(positionedGameweekEntries);
        clubId = monthlyLeaderboard.clubId;
        month = month;
      };

      monthly_leaderboards := Array.map<T.MonthlyLeaderboard, T.MonthlyLeaderboard>(monthly_leaderboards, func(leaderboard: T.MonthlyLeaderboard){
        if(leaderboard.seasonId == seasonId and leaderboard.month == month and leaderboard.clubId == updatedLeaderboard.clubId){
          return updatedLeaderboard;
        } else { return leaderboard };
      });
    };
      
  };

  private func calculateWeeklyLeaderboard(seasonId: FootballTypes.SeasonId, gameweek: FootballTypes.GameweekNumber) : async (){
    var currentLeaderboard: ?T.WeeklyLeaderboard = null;

    currentLeaderboard := Array.find(weekly_leaderboards, func(leaderboard: T.WeeklyLeaderboard) : Bool {
      leaderboard.seasonId == seasonId and leaderboard.gameweek == gameweek
    });
    
    switch(currentLeaderboard){
      case (?foundLeaderboard){

        let sortedGameweekEntries = Array.sort(List.toArray(foundLeaderboard.entries), func(entry1: T.LeaderboardEntry, entry2: T.LeaderboardEntry) : Order.Order{
          if (entry1.points < entry2.points) { return #greater };
          if (entry1.points == entry2.points) { return #equal };
              return #less;
        });

        let positionedGameweekEntries = Utilities.assignPositionText(List.fromArray<T.LeaderboardEntry>(sortedGameweekEntries));

        var updatedLeaderboard: T.WeeklyLeaderboard = {
          seasonId = foundLeaderboard.seasonId;
          entries = positionedGameweekEntries;
          totalEntries = List.size(positionedGameweekEntries);
          gameweek = gameweek;
        };

        let leaderboardBuffer = Buffer.fromArray<T.WeeklyLeaderboard>(
          Array.filter<T.WeeklyLeaderboard>(weekly_leaderboards, func(leaderboard: T.WeeklyLeaderboard){
            return leaderboard.seasonId != seasonId or gameweek != gameweek
          })
        );
        leaderboardBuffer.add(updatedLeaderboard);
        weekly_leaderboards := Buffer.toArray(leaderboardBuffer);
      };
      case (null){}
    };   
  };

  public shared query ({ caller }) func getWeeklyRewardLeaderboard(seasonId: FootballTypes.SeasonId, gameweek: FootballTypes.GameweekNumber) : async ?DTOs.WeeklyLeaderboardDTO {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == controllerPrincipalId;

    var currentLeaderboard: ?T.WeeklyLeaderboard = null;

    currentLeaderboard := Array.find(weekly_leaderboards, func(leaderboard: T.WeeklyLeaderboard) : Bool {
      leaderboard.seasonId == seasonId and leaderboard.gameweek == gameweek;
    });

    switch (currentLeaderboard) {
      case (null) { return null };
      case (?foundLeaderboard) {

        let entriesArray = List.toArray(foundLeaderboard.entries);
        let sortedArray = Array.sort(
          entriesArray,
          func(a : T.LeaderboardEntry, b : T.LeaderboardEntry) : Order.Order {
            if (a.points < b.points) { return #greater };
            if (a.points == b.points) { return #equal };
            return #less;
          },
        );
        
        let cutoffIndex = 99;
        let lastQualifyingPoints = sortedArray[cutoffIndex].points;
        var lastIndexForPrizes = cutoffIndex;
        let totalEntries : Nat = List.size(foundLeaderboard.entries);

        if (totalEntries <= 0) {
          return null;
        };

        let totalEntriesIndex : Nat = totalEntries - 1;

        while (
          lastIndexForPrizes < totalEntriesIndex and List.toArray(foundLeaderboard.entries)[lastIndexForPrizes + 1].points == lastQualifyingPoints,
        ) {
          lastIndexForPrizes := lastIndexForPrizes + 1;
        };

        let indexes : [Nat] = Array.tabulate<Nat>(Array.size(sortedArray), func(i : Nat) : Nat { i });

        let entriesWithIndex : [(T.LeaderboardEntry, Nat)] = Array.map<Nat, (T.LeaderboardEntry, Nat)>(indexes, func(i : Nat) : (T.LeaderboardEntry, Nat) { (sortedArray[i], i) });

        let qualifyingEntriesWithIndex = Array.filter(
          entriesWithIndex,
          func(pair : (T.LeaderboardEntry, Nat)) : Bool {
            let (_, index) = pair;
            index <= lastIndexForPrizes;
          },
        );

        let qualifyingEntries = Array.map(
          qualifyingEntriesWithIndex,
          func(pair : (T.LeaderboardEntry, Nat)) : T.LeaderboardEntry {
            let (entry, _) = pair;
            entry;
          },
        );
        return ?{
          seasonId = seasonId;
          gameweek = gameweek;
          entries = qualifyingEntries;
          totalEntries = Array.size(qualifyingEntries);
        };
      };
    };
  };

  public shared query ({ caller }) func getSeasonRewardLeaderboard(seasonId: FootballTypes.SeasonId) : async ?DTOs.SeasonLeaderboardDTO {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == controllerPrincipalId;

    var currentLeaderboard: ?T.SeasonLeaderboard = null;

    currentLeaderboard := Array.find(weekly_leaderboards, func(leaderboard: T.SeasonLeaderboard) : Bool {
      leaderboard.seasonId == seasonId
    });

    switch (currentLeaderboard) {
      case (null) { return null };
      case (?foundLeaderboard) {

        let entriesArray = List.toArray(foundLeaderboard.entries);
        let sortedArray = Array.sort(
          entriesArray,
          func(a : T.LeaderboardEntry, b : T.LeaderboardEntry) : Order.Order {
            if (a.points < b.points) { return #greater };
            if (a.points == b.points) { return #equal };
            return #less;
          },
        );

        let cutoffIndex = 99;
        let lastQualifyingPoints = sortedArray[cutoffIndex].points;
        var lastIndexForPrizes = cutoffIndex;
        let totalEntries : Nat = List.size(foundLeaderboard.entries);

        if (totalEntries <= 0) {
          return null;
        };

        let totalEntriesIndex : Nat = totalEntries - 1;

        while (
          lastIndexForPrizes < totalEntriesIndex and List.toArray(foundLeaderboard.entries)[lastIndexForPrizes + 1].points == lastQualifyingPoints,
        ) {
          lastIndexForPrizes := lastIndexForPrizes + 1;
        };

        let indexes : [Nat] = Array.tabulate<Nat>(Array.size(sortedArray), func(i : Nat) : Nat { i });

        let entriesWithIndex : [(T.LeaderboardEntry, Nat)] = Array.map<Nat, (T.LeaderboardEntry, Nat)>(indexes, func(i : Nat) : (T.LeaderboardEntry, Nat) { (sortedArray[i], i) });

        let qualifyingEntriesWithIndex = Array.filter(
          entriesWithIndex,
          func(pair : (T.LeaderboardEntry, Nat)) : Bool {
            let (_, index) = pair;
            index <= lastIndexForPrizes;
          },
        );

        let qualifyingEntries = Array.map(
          qualifyingEntriesWithIndex,
          func(pair : (T.LeaderboardEntry, Nat)) : T.LeaderboardEntry {
            let (entry, _) = pair;
            entry;
          },
        );
        return ?{
          seasonId = seasonId;
          entries = qualifyingEntries;
          totalEntries = Array.size(qualifyingEntries);
        };
      };
    };
  };

  public shared query ({ caller }) func getMonthlyRewardLeaderboard(seasonId: FootballTypes.SeasonId, month: Base.CalendarMonth, clubId: FootballTypes.ClubId) : async ?DTOs.MonthlyLeaderboardDTO {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == controllerPrincipalId;

    var currentLeaderboard: ?T.MonthlyLeaderboard = null;

    currentLeaderboard := Array.find(monthly_leaderboards, func(leaderboard: T.MonthlyLeaderboard) : Bool {
      leaderboard.seasonId == seasonId and leaderboard.month == month and leaderboard.clubId == clubId
    });

    switch (currentLeaderboard) {
      case (null) { return null };
      case (?foundLeaderboard) {

        let entriesArray = List.toArray(foundLeaderboard.entries);
        let sortedArray = Array.sort(
          entriesArray,
          func(a : T.LeaderboardEntry, b : T.LeaderboardEntry) : Order.Order {
            if (a.points < b.points) { return #greater };
            if (a.points == b.points) { return #equal };
            return #less;
          },
        );

        let cutoffIndex = 99;
        let lastQualifyingPoints = sortedArray[cutoffIndex].points;
        var lastIndexForPrizes = cutoffIndex;
        let totalEntries : Nat = List.size(foundLeaderboard.entries);

        if (totalEntries <= 0) {
          return null;
        };

        let totalEntriesIndex : Nat = totalEntries - 1;

        while (
          lastIndexForPrizes < totalEntriesIndex and List.toArray(foundLeaderboard.entries)[lastIndexForPrizes + 1].points == lastQualifyingPoints,
        ) {
          lastIndexForPrizes := lastIndexForPrizes + 1;
        };

        let indexes : [Nat] = Array.tabulate<Nat>(Array.size(sortedArray), func(i : Nat) : Nat { i });

        let entriesWithIndex : [(T.LeaderboardEntry, Nat)] = Array.map<Nat, (T.LeaderboardEntry, Nat)>(indexes, func(i : Nat) : (T.LeaderboardEntry, Nat) { (sortedArray[i], i) });

        let qualifyingEntriesWithIndex = Array.filter(
          entriesWithIndex,
          func(pair : (T.LeaderboardEntry, Nat)) : Bool {
            let (_, index) = pair;
            index <= lastIndexForPrizes;
          },
        );

        let qualifyingEntries = Array.map(
          qualifyingEntriesWithIndex,
          func(pair : (T.LeaderboardEntry, Nat)) : T.LeaderboardEntry {
            let (entry, _) = pair;
            entry;
          },
        );
        return ?{
          seasonId = seasonId;
          entries = qualifyingEntries;
          totalEntries = Array.size(qualifyingEntries);
          month = month;
          clubId = clubId;
        };
      };
    };
  };

  public shared ({ caller }) func getWeeklyLeaderboardEntries(seasonId: FootballTypes.SeasonId, gameweek: FootballTypes.GameweekNumber, filters: DTOs.PaginationFiltersDTO, searchTerm : Text) : async ?DTOs.WeeklyLeaderboardDTO {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == controllerPrincipalId;

    var currentLeaderboard: ?T.WeeklyLeaderboard = null;

    currentLeaderboard := Array.find(weekly_leaderboards, func(leaderboard: T.WeeklyLeaderboard) : Bool {
      leaderboard.seasonId == seasonId and leaderboard.gameweek == gameweek;
    });

    switch (currentLeaderboard) {
      case (null) {
        return null;
      };
      case (?foundLeaderboard) {
        let filteredEntries = List.filter<T.LeaderboardEntry>(
          foundLeaderboard.entries,
          func(entry : T.LeaderboardEntry) : Bool {
            Text.startsWith(entry.username, #text searchTerm);
          },
        );

        let sortedGameweekEntries = Array.sort(List.toArray(filteredEntries), func(entry1: T.LeaderboardEntry, entry2: T.LeaderboardEntry) : Order.Order{
          if (entry1.points < entry2.points) { return #greater };
          if (entry1.points == entry2.points) { return #equal };
              return #less;
        });

        let droppedEntries = List.drop<T.LeaderboardEntry>(List.fromArray(sortedGameweekEntries), filters.offset);
        let paginatedEntries = List.take<T.LeaderboardEntry>(droppedEntries, filters.limit);

        let leaderboardDTO : DTOs.WeeklyLeaderboardDTO = {
          seasonId = foundLeaderboard.seasonId;
          gameweek = foundLeaderboard.gameweek;
          entries = List.toArray(paginatedEntries);
          totalEntries = List.size(foundLeaderboard.entries);
        };

        return ?leaderboardDTO;
      };
    };
  };

  public shared query ({ caller }) func getMonthlyLeaderboardEntries(seasonId: FootballTypes.SeasonId, month: Base.CalendarMonth, clubId: FootballTypes.ClubId, filters: DTOs.PaginationFiltersDTO, searchTerm : Text) : async ?DTOs.MonthlyLeaderboardDTO {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == controllerPrincipalId;

    var currentLeaderboard: ?T.MonthlyLeaderboard = null;

    currentLeaderboard := Array.find(monthly_leaderboards, func(leaderboard: T.MonthlyLeaderboard) : Bool {
      leaderboard.seasonId == seasonId and leaderboard.month == month and leaderboard.clubId == clubId
    });

    switch (currentLeaderboard) {
      case (null) {
        return null;
      };
      case (?foundLeaderboard) {
        let filteredEntries = List.filter<T.LeaderboardEntry>(
          foundLeaderboard.entries,
          func(entry : T.LeaderboardEntry) : Bool {
            Text.startsWith(entry.username, #text searchTerm);
          },
        );

        let droppedEntries = List.drop<T.LeaderboardEntry>(filteredEntries, filters.offset);
        let paginatedEntries = List.take<T.LeaderboardEntry>(droppedEntries, filters.limit);

        let leaderboardDTO : DTOs.MonthlyLeaderboardDTO = {
          seasonId = foundLeaderboard.seasonId;
          month = foundLeaderboard.month;
          clubId = foundLeaderboard.clubId;
          entries = List.toArray(paginatedEntries);
          totalEntries = List.size(foundLeaderboard.entries);
        };

        return ?leaderboardDTO;
      };
    };
  };

  public shared query ({ caller }) func getSeasonLeaderboardEntries(seasonId: FootballTypes.SeasonId, filters: DTOs.PaginationFiltersDTO, searchTerm : Text) : async ?DTOs.SeasonLeaderboardDTO {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == controllerPrincipalId;

    var currentLeaderboard: ?T.WeeklyLeaderboard = null;

    currentLeaderboard := Array.find(weekly_leaderboards, func(leaderboard: T.SeasonLeaderboard) : Bool {
      leaderboard.seasonId == seasonId;
    });

    switch (currentLeaderboard) {
      case (null) {
        return null;
      };
      case (?foundLeaderboard) {
        let filteredEntries = List.filter<T.LeaderboardEntry>(
          foundLeaderboard.entries,
          func(entry : T.LeaderboardEntry) : Bool {
            Text.startsWith(entry.username, #text searchTerm);
          },
        );

        let droppedEntries = List.drop<T.LeaderboardEntry>(filteredEntries, filters.offset);
        let paginatedEntries = List.take<T.LeaderboardEntry>(droppedEntries, filters.limit);

        let leaderboardDTO : DTOs.SeasonLeaderboardDTO = {
          seasonId = foundLeaderboard.seasonId;
          entries = List.toArray(paginatedEntries);
          totalEntries = List.size(foundLeaderboard.entries);
        };

        return ?leaderboardDTO;
      };
    };
  };

  public shared query ({ caller }) func getWeeklyLeaderboardEntry(seasonId: FootballTypes.SeasonId, gameweek: FootballTypes.GameweekNumber, principalId : Text) : async ?DTOs.LeaderboardEntryDTO {
    assert not Principal.isAnonymous(caller);
    let callerPrincipalId = Principal.toText(caller);
    assert callerPrincipalId == controllerPrincipalId;

    var currentLeaderboard: ?T.WeeklyLeaderboard = null;

    currentLeaderboard := Array.find(weekly_leaderboards, func(leaderboard: T.WeeklyLeaderboard) : Bool {
      leaderboard.seasonId == seasonId and leaderboard.gameweek == gameweek;
    });

    switch (currentLeaderboard) {
      case (null) {
        return null;
      };
      case (?foundLeaderboard) {
        let _ = List.find<T.LeaderboardEntry>(
          foundLeaderboard.entries,
          func(entry : DTOs.LeaderboardEntryDTO) : Bool {
            return entry.principalId == principalId;
          },
        );
      };
    };
  };

  public shared query ({ caller }) func getMonthlyLeaderboardEntry(seasonId: FootballTypes.SeasonId, month: Base.CalendarMonth, clubId: FootballTypes.ClubId, principalId : Text) : async ?DTOs.LeaderboardEntryDTO {
    assert not Principal.isAnonymous(caller);
    let callerPrincipalId = Principal.toText(caller);
    assert callerPrincipalId == controllerPrincipalId;

    var currentLeaderboard: ?T.MonthlyLeaderboard = null;

    currentLeaderboard := Array.find(monthly_leaderboards, func(leaderboard: T.MonthlyLeaderboard) : Bool {
      leaderboard.seasonId == seasonId and leaderboard.month == month and leaderboard.clubId == clubId;
    });

    switch (currentLeaderboard) {
      case (null) {
        return null;
      };
      case (?foundLeaderboard) {
        let _ = List.find<T.LeaderboardEntry>(
          foundLeaderboard.entries,
          func(entry : DTOs.LeaderboardEntryDTO) : Bool {
            return entry.principalId == principalId;
          },
        );
      };
    };
  };

  public shared query ({ caller }) func getSeasonLeaderboardEntry(seasonId: FootballTypes.SeasonId, principalId : Text) : async ?DTOs.LeaderboardEntryDTO {
    assert not Principal.isAnonymous(caller);
    let callerPrincipalId = Principal.toText(caller);
    assert callerPrincipalId == controllerPrincipalId;

    var currentLeaderboard: ?T.SeasonLeaderboard = null;

    currentLeaderboard := Array.find(weekly_leaderboards, func(leaderboard: T.SeasonLeaderboard) : Bool {
      leaderboard.seasonId == seasonId;
    });

    switch (currentLeaderboard) {
      case (null) {
        return null;
      };
      case (?foundLeaderboard) {
        let _ = List.find<T.LeaderboardEntry>(
          foundLeaderboard.entries,
          func(entry : DTOs.LeaderboardEntryDTO) : Bool {
            return entry.principalId == principalId;
          },
        );
      };
    };
  };

  public shared ({ caller }) func getTotalLeaderboards() : async Nat {
    assert not Principal.isAnonymous(caller);
    let callerPrincipalId = Principal.toText(caller);
    assert callerPrincipalId == controllerPrincipalId;

    return Array.size(weekly_leaderboards) + Array.size(monthly_leaderboards) + Array.size(season_leaderboards);
  };
  
  system func preupgrade() {};

  system func postupgrade() {
    ignore Timer.setTimer<system>(#nanoseconds(Int.abs(1)), postUpgradeCallback); 
  };

  private func postUpgradeCallback() : async (){
  };
};
