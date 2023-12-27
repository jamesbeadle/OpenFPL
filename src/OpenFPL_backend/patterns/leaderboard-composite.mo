import T "../types";
import DTOs "../DTOs";
import HashMap "mo:base/HashMap";
import Result "mo:base/Result";
import Iter "mo:base/Iter";
import List "mo:base/List";
import Array "mo:base/Array";
import Utilities "../utilities";

module {

  public class LeaderboardComposite() {
    private var seasonLeaderboardCanisterIds : HashMap.HashMap<T.SeasonId, Text> = HashMap.HashMap<T.SeasonId, Text>(100, Utilities.eqNat16, Utilities.hashNat16);
    private var monthlyLeaderboardCanisterIds : HashMap.HashMap<T.MonthlyLeaderboardKey, Text> = HashMap.HashMap<T.MonthlyLeaderboardKey, Text>(100, Utilities.eqMonthlyKey, Utilities.hashMonthlyKey);
    private var weeklyLeaderboardCanisterIds : HashMap.HashMap<T.WeeklyLeaderboardKey, Text> = HashMap.HashMap<T.WeeklyLeaderboardKey, Text>(100, Utilities.eqWeeklyKey, Utilities.hashWeeklyKey);
   
    private var storeCanisterId : ?((canisterId : Text) -> async ()) = null;

    public func setStableData(
      stable_season_leaderboard_canister_ids:  [(T.SeasonId, Text)],
      stable_monthly_leaderboard_canister_ids:  [(T.MonthlyLeaderboardKey, Text)],
      stable_weekly_leaderboard_canister_ids:  [(T.WeeklyLeaderboardKey, Text)]) {

      seasonLeaderboardCanisterIds := HashMap.fromIter<T.SeasonId, Text>(
        stable_season_leaderboard_canister_ids.vals(),
        stable_season_leaderboard_canister_ids.size(),
        Utilities.eqNat16, 
        Utilities.hashNat16
      );

      monthlyLeaderboardCanisterIds := HashMap.fromIter<T.MonthlyLeaderboardKey, Text>(
        stable_monthly_leaderboard_canister_ids.vals(),
        stable_monthly_leaderboard_canister_ids.size(),
        Utilities.eqMonthlyKey, 
        Utilities.hashMonthlyKey
      );

      weeklyLeaderboardCanisterIds := HashMap.fromIter<T.WeeklyLeaderboardKey, Text>(
        stable_weekly_leaderboard_canister_ids.vals(),
        stable_weekly_leaderboard_canister_ids.size(),
        Utilities.eqWeeklyKey, 
        Utilities.hashWeeklyKey
      );
    };
    
    public func setStoreCanisterIdFunction(
      _storeCanisterId : (canisterId : Text) -> async ()) {
      storeCanisterId := ?_storeCanisterId;
    };

    public func getWeeklyLeaderboard(seasonId : T.SeasonId, gameweek : T.GameweekNumber, limit : Nat, offset : Nat) : async Result.Result<DTOs.WeeklyLeaderboardDTO, T.Error> {
      
      if(limit > 100){
        return #err(#NotAllowed);
      };
      
      let leaderboardKey: T.WeeklyLeaderboardKey = (seasonId, gameweek);
      let canisterId = weeklyLeaderboardCanisterIds.get(leaderboardKey);
      switch(canisterId){
        case (null) {
          return #err(#NotFound);
        };
        case (?foundCanisterId){
          let weekly_leaderboard_canister = actor (foundCanisterId) : actor {
            getEntries : (limit : Nat, offset : Nat) -> async DTOs.WeeklyLeaderboardDTO;
          };

          let leaderboardEntries = await weekly_leaderboard_canister.getEntries(limit, offset);
          return #ok(leaderboardEntries);
        };
      };
    };

    public func getMonthlyLeaderboard(seasonId : T.SeasonId, month : T.CalendarMonth, clubId: T.ClubId, limit : Nat, offset : Nat) : async Result.Result<DTOs.MonthlyLeaderboardDTO, T.Error> {
      
      if(limit > 100){
        return #err(#NotAllowed);
      };
      
      let leaderboardKey: T.MonthlyLeaderboardKey = (seasonId, month, clubId);
      let canisterId = monthlyLeaderboardCanisterIds.get(leaderboardKey);
      switch(canisterId){
        case (null) {
          return #err(#NotFound);
        };
        case (?foundCanisterId){
          let monthly_leaderboard_canister = actor (foundCanisterId) : actor {
            getEntries : (limit : Nat, offset : Nat) -> async DTOs.MonthlyLeaderboardDTO;
          };

          let leaderboardEntries = await monthly_leaderboard_canister.getEntries(limit, offset);
          return #ok(leaderboardEntries);
        };
      };
    };

    public func getSeasonLeaderboard(seasonId : T.SeasonId, limit : Nat, offset : Nat) : async Result.Result<DTOs.SeasonLeaderboardDTO, T.Error> {
      
      if(limit > 100){
        return #err(#NotAllowed);
      };
      
      let canisterId = seasonLeaderboardCanisterIds.get(seasonId);
      switch(canisterId){
        case (null) {
          return #err(#NotFound);
        };
        case (?foundCanisterId){
          let season_leaderboard_canister = actor (foundCanisterId) : actor {
            getEntries : (limit : Nat, offset : Nat) -> async DTOs.SeasonLeaderboardDTO;
          };

          let leaderboardEntries = await season_leaderboard_canister.getEntries(limit, offset);
          return #ok(leaderboardEntries);
        };
      };
    };

    public func getWeeklyLeaderboardEntry(principalId: Text, seasonId : T.SeasonId, gameweek : T.GameweekNumber) : async ?DTOs.LeaderboardEntryDTO {
      
      let leaderboardKey: T.WeeklyLeaderboardKey = (seasonId, gameweek);
      let canisterId = weeklyLeaderboardCanisterIds.get(leaderboardKey);
      switch(canisterId){
        case (null) {
          return null;
        };
        case (?foundCanisterId){
          let weekly_leaderboard_canister = actor (foundCanisterId) : actor {
            getEntries : (limit : Nat, offset : Nat) -> async DTOs.WeeklyLeaderboardDTO;
            getEntry : (principalId: Text) -> async DTOs.LeaderboardEntryDTO;
          };

          let leaderboardEntry = await weekly_leaderboard_canister.getEntry(principalId);
          return ?leaderboardEntry;
        };
      };
    };

    public func getMonthlyLeaderboardEntry(principalId: Text, seasonId : T.SeasonId, month : T.CalendarMonth, clubId: T.ClubId) : async ?DTOs.LeaderboardEntryDTO {
      
      let leaderboardKey: T.MonthlyLeaderboardKey = (seasonId, month, clubId);
      let canisterId = monthlyLeaderboardCanisterIds.get(leaderboardKey);
      switch(canisterId){
        case (null) {
          return null;
        };
        case (?foundCanisterId){
          let monthly_leaderboard_canister = actor (foundCanisterId) : actor {
            getEntries : (limit : Nat, offset : Nat) -> async DTOs.MonthlyLeaderboardDTO;
            getEntry : (principalId: Text) -> async DTOs.LeaderboardEntryDTO;
          };

          let leaderboardEntry = await monthly_leaderboard_canister.getEntry(principalId);
          return ?leaderboardEntry;
        };
      };
    };

    public func getSeasonLeaderboardEntry(principalId: Text, seasonId : T.SeasonId) : async ?DTOs.LeaderboardEntryDTO {
      
      let canisterId = seasonLeaderboardCanisterIds.get(seasonId);
      switch(canisterId){
        case (null) {
          return null;
        };
        case (?foundCanisterId){
          let season_leaderboard_canister = actor (foundCanisterId) : actor {
            getEntries : (limit : Nat, offset : Nat) -> async DTOs.SeasonLeaderboardDTO;
            getEntry : (principalId: Text) -> async DTOs.LeaderboardEntryDTO;
          };

          let leaderboardEntry = await season_leaderboard_canister.getEntry(principalId);
          return ?leaderboardEntry;
        };
      };
    };


    public func calculateLeaderboards(seasonId : T.SeasonId, gameweek : T.GameweekNumber, managers: HashMap.HashMap<T.PrincipalId, T.Manager>) : () {
      calculateWeeklyLeaderboards(seasonId, gameweek, managers);
      calculateSeasonLeaderboard(seasonId);

    };

    private func calculateWeeklyLeaderboards(seasonId : T.SeasonId, gameweek : T.GameweekNumber, managers: HashMap.HashMap<T.PrincipalId, T.Manager>){
      let seasonEntries = Array.map<(Text, T.Manager), T.LeaderboardEntry>(
        Iter.toArray(managers.entries()),
        func(pair) {
          return createLeaderboardEntry(pair.0, pair.1.username, totalPointsForSeason(pair.1, seasonId));
        }
      );
    //TODO: Create the leaderboard canisters for the leaderboards you are about to calculate
    //TODO: Add the leadeboard canister ids to the cycle watcher
    //TODO: Implement the calculation logic
    //TODO: Add the leaderboard data to the canister
    };

    private func calculateSeasonLeaderboard(seasonId : T.SeasonId){

    };
    
    private func totalPointsForSeason(manager : T.Manager, seasonId : T.SeasonId) : Int16 {

      var totalPoints : Int16 = 0;

      let season = List.find(
        manager.history,
        func(season : T.FantasyTeamSeason) : Bool {
          return season.seasonId == seasonId;
        },
      );

      switch (season) {
        case (null) { return 0 };
        case (?foundSeason) {
          for (gameweek in Iter.fromList(foundSeason.gameweeks)) {
            totalPoints += gameweek.points;
          };
          return totalPoints;
        };
      };
    };
    

    
    private func createLeaderboardEntry(principalId : Text, username : Text, points : Int16) : T.LeaderboardEntry {
      return {
        position = 0;
        positionText = "";
        username = username;
        principalId = principalId;
        points = points;
      };
    };



    

    
    private func compare(entry1 : T.LeaderboardEntry, entry2 : T.LeaderboardEntry) : Bool {
      return entry1.points <= entry2.points;
    };

    func mergeSort(entries : List.List<T.LeaderboardEntry>) : List.List<T.LeaderboardEntry> {
      let len = List.size(entries);
      if (len <= 1) {
        return entries;
      } else {
        let (firstHalf, secondHalf) = List.split(len / 2, entries);
        return List.merge(mergeSort(firstHalf), mergeSort(secondHalf), compare);
      };
    };
    
    public func getStableSeasonLeaderboardCanisterIds(): [(T.SeasonId, Text)] {
      return Iter.toArray(seasonLeaderboardCanisterIds.entries());
    };

    public func setStableSeasonLeaderboardCanisterIds(stable_season_leaderboard_canister_ids: [(T.SeasonId, Text)])  {
      seasonLeaderboardCanisterIds := HashMap.fromIter<T.SeasonId, Text>(
        stable_season_leaderboard_canister_ids.vals(),
        stable_season_leaderboard_canister_ids.size(),
        Utilities.eqNat16,
        Utilities.hashNat16
      );
    };
    
    public func getStableMonthlyLeaderboardCanisterIds(): [(T.MonthlyLeaderboardKey, Text)] {
      return Iter.toArray(monthlyLeaderboardCanisterIds.entries());
    };

    public func setStableMonthlyLeaderboardCanisterIds(stable_monthly_leaderboard_canister_ids: [(T.MonthlyLeaderboardKey, Text)])  {
      monthlyLeaderboardCanisterIds := HashMap.fromIter<T.MonthlyLeaderboardKey, Text>(
        stable_monthly_leaderboard_canister_ids.vals(),
        stable_monthly_leaderboard_canister_ids.size(),
        Utilities.eqMonthlyKey,
        Utilities.hashMonthlyKey
      );
    };
    
    public func getStableWeeklyLeaderboardCanisterIds(): [(T.WeeklyLeaderboardKey, Text)] {
      return Iter.toArray(weeklyLeaderboardCanisterIds.entries());
    };

    public func setStableWeeklyLeaderboardCanisterIds(stable_weekly_leaderboard_canister_ids: [(T.WeeklyLeaderboardKey, Text)])  {
      weeklyLeaderboardCanisterIds := HashMap.fromIter<T.WeeklyLeaderboardKey, Text>(
        stable_weekly_leaderboard_canister_ids.vals(),
        stable_weekly_leaderboard_canister_ids.size(),
        Utilities.eqWeeklyKey,
        Utilities.hashWeeklyKey
      );
    };    

    public func getCanisterId(seasonId: T.SeasonId, month: T.GameweekNumber) : ?Text{
      let weeklyLeaderboardKey = (seasonId, month);
      return weeklyLeaderboardCanisterIds.get(weeklyLeaderboardKey);
    };



 /*
    
    

    

    private func groupByTeam(fantasyTeams : HashMap.HashMap<Text, T.UserFantasyTeam>, allProfiles : HashMap.HashMap<Text, T.Profile>) : HashMap.HashMap<T.TeamId, [(Text, T.UserFantasyTeam)]> {
      let groupedTeams : HashMap.HashMap<T.TeamId, [(Text, T.UserFantasyTeam)]> = HashMap.HashMap<T.TeamId, [(Text, T.UserFantasyTeam)]>(10, Utilities.eqNat16, Utilities.hashNat16);

      for ((principalId, fantasyTeam) in fantasyTeams.entries()) {
        let profile = allProfiles.get(principalId);
        switch (profile) {
          case (null) {};
          case (?foundProfile) {
            let teamId = foundProfile.favouriteTeamId;
            switch (groupedTeams.get(teamId)) {
              case null {
                groupedTeams.put(teamId, [(principalId, fantasyTeam)]);
              };
              case (?existingEntries) {
                let updatedEntries = Buffer.fromArray<(Text, T.UserFantasyTeam)>(existingEntries);
                updatedEntries.add((principalId, fantasyTeam));
                groupedTeams.put(teamId, Buffer.toArray(updatedEntries));
              };
            };
          };
        };
      };

      return groupedTeams;
    };

    private func totalPointsForGameweek(team : T.UserFantasyTeam, seasonId : T.SeasonId, gameweek : T.GameweekNumber) : Int16 {

      let season = List.find(
        team.history,
        func(season : T.FantasyTeamSeason) : Bool {
          return season.seasonId == seasonId;
        },
      );
      switch (season) {
        case (null) { return 0 };
        case (?foundSeason) {
          let seasonGameweek = List.find(
            foundSeason.gameweeks,
            func(gw : T.FantasyTeamSnapshot) : Bool {
              return gw.gameweek == gameweek;
            },
          );
          switch (seasonGameweek) {
            case null { return 0 };
            case (?foundSeasonGameweek) {
              return foundSeasonGameweek.points;
            };
          };
        };
      };
    };

    private func totalPointsForSeason(team : T.UserFantasyTeam, seasonId : T.SeasonId) : Int16 {

      var totalPoints : Int16 = 0;

      let season = List.find(
        team.history,
        func(season : T.FantasyTeamSeason) : Bool {
          return season.seasonId == seasonId;
        },
      );

      switch (season) {
        case (null) { return 0 };
        case (?foundSeason) {
          for (gameweek in Iter.fromList(foundSeason.gameweeks)) {
            totalPoints += gameweek.points;
          };
          return totalPoints;
        };
      };
    };

    private func totalPointsForMonth(team : T.UserFantasyTeam, seasonId : T.SeasonId, monthGameweeks : List.List<Nat8>) : Int16 {

      var totalPoints : Int16 = 0;

      let season = List.find(
        team.history,
        func(season : T.FantasyTeamSeason) : Bool {
          return season.seasonId == seasonId;
        },
      );

      switch (season) {
        case (null) { return 0 };
        case (?foundSeason) {
          for (gameweek in Iter.fromList(foundSeason.gameweeks)) {
            if (List.some(monthGameweeks, func(mw : Nat8) : Bool { return mw == gameweek.gameweek })) {
              totalPoints += gameweek.points;
            };
          };
          return totalPoints;
        };
      };
    };

    public func snapshotGameweek(seasonId : Nat16, gameweek : T.GameweekNumber) : async () {
      for ((principalId, userFantasyTeam) in fantasyTeams.entries()) {
        let newSnapshot : T.FantasyTeamSnapshot = {
          principalId = userFantasyTeam.fantasyTeam.principalId;
          gameweek = gameweek;
          transfersAvailable = userFantasyTeam.fantasyTeam.transfersAvailable;
          bankBalance = userFantasyTeam.fantasyTeam.bankBalance;
          playerIds = userFantasyTeam.fantasyTeam.playerIds;
          captainId = userFantasyTeam.fantasyTeam.captainId;
          goalGetterGameweek = userFantasyTeam.fantasyTeam.goalGetterGameweek;
          goalGetterPlayerId = userFantasyTeam.fantasyTeam.goalGetterPlayerId;
          passMasterGameweek = userFantasyTeam.fantasyTeam.passMasterGameweek;
          passMasterPlayerId = userFantasyTeam.fantasyTeam.passMasterPlayerId;
          noEntryGameweek = userFantasyTeam.fantasyTeam.noEntryGameweek;
          noEntryPlayerId = userFantasyTeam.fantasyTeam.noEntryPlayerId;
          teamBoostGameweek = userFantasyTeam.fantasyTeam.teamBoostGameweek;
          teamBoostTeamId = userFantasyTeam.fantasyTeam.teamBoostTeamId;
          safeHandsGameweek = userFantasyTeam.fantasyTeam.safeHandsGameweek;
          safeHandsPlayerId = userFantasyTeam.fantasyTeam.safeHandsPlayerId;
          captainFantasticGameweek = userFantasyTeam.fantasyTeam.captainFantasticGameweek;
          captainFantasticPlayerId = userFantasyTeam.fantasyTeam.captainFantasticPlayerId;
          countrymenGameweek = userFantasyTeam.fantasyTeam.countrymenGameweek;
          countrymenCountryId = userFantasyTeam.fantasyTeam.countrymenCountryId;
          prospectsGameweek = userFantasyTeam.fantasyTeam.prospectsGameweek;
          braceBonusGameweek = userFantasyTeam.fantasyTeam.braceBonusGameweek;
          hatTrickHeroGameweek = userFantasyTeam.fantasyTeam.hatTrickHeroGameweek;
          teamName = userFantasyTeam.fantasyTeam.teamName;
          favouriteTeamId = userFantasyTeam.fantasyTeam.favouriteTeamId;
          points = 0;
          transferWindowGameweek = userFantasyTeam.fantasyTeam.transferWindowGameweek;
        };

        var seasonFound = false;

        var updatedSeasons = List.map<T.FantasyTeamSeason, T.FantasyTeamSeason>(
          userFantasyTeam.history,
          func(season : T.FantasyTeamSeason) : T.FantasyTeamSeason {
            if (season.seasonId == seasonId) {
              seasonFound := true;

              let otherSeasonGameweeks = List.filter<T.FantasyTeamSnapshot>(
                season.gameweeks,
                func(snapshot : T.FantasyTeamSnapshot) : Bool {
                  return snapshot.gameweek != gameweek;
                },
              );

              let updatedGameweeks = List.push(newSnapshot, otherSeasonGameweeks);

              return {
                seasonId = season.seasonId;
                totalPoints = season.totalPoints;
                gameweeks = updatedGameweeks;
              };
            };
            return season;
          },
        );

        if (not seasonFound) {
          let newSeason : T.FantasyTeamSeason = {
            seasonId = seasonId;
            totalPoints = 0;
            gameweeks = List.push(newSnapshot, List.nil());
          };

          updatedSeasons := List.push(newSeason, updatedSeasons);
        };

        let updatedUserTeam : T.UserFantasyTeam = {
          fantasyTeam = userFantasyTeam.fantasyTeam;
          history = updatedSeasons;
        };

        fantasyTeams.put(principalId, updatedUserTeam);
      };
    };
    
    */
/*
    
*/
  };
};
