import T "../types";
import DTOs "../DTOs";
import HashMap "mo:base/HashMap";
import Result "mo:base/Result";
import Iter "mo:base/Iter";
import List "mo:base/List";
import Utilities "../utilities";

module {

  public class LeaderboardComposite() {
    private var seasonLeaderboardCanisterIds : HashMap.HashMap<T.SeasonId, Text> = HashMap.HashMap<T.SeasonId, Text>(100, Utilities.eqNat16, Utilities.hashNat16);
    private var monthlyLeaderboardCanisterIds : HashMap.HashMap<T.MonthlyLeaderboardKey, Text> = HashMap.HashMap<T.MonthlyLeaderboardKey, Text>(100, Utilities.eqMonthlyKey, Utilities.hashMonthlyKey);
    private var weeklyLeaderboardCanisterIds : HashMap.HashMap<T.WeeklyLeaderboardKey, Text> = HashMap.HashMap<T.WeeklyLeaderboardKey, Text>(100, Utilities.eqWeeklyKey, Utilities.hashWeeklyKey);
   
    private var setAndWatchCanister : ?((canisterId : Text) -> async ()) = null;

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
    
    public func setCanisterWatcherFunction(
      _setAndWatchCanister : (canisterId : Text) -> async ()) {
      setAndWatchCanister := ?_setAndWatchCanister;
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

    public func calculateLeaderboards() : async (){
      //TODO: Create the leaderboard canisters for the leaderboards you are about to calculate
      //TODO: Add the leadeboard canister ids to the cycle watcher
      //TODO: Implement the calculation logic
      //TODO: Add the leaderboard data to the canister
      
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
    
    private func updateSnapshotPoints(principalId : Text, seasonId : Nat16, gameweek : Nat8, teamPoints : Int16) : () {
      let userFantasyTeam = fantasyTeams.get(principalId);

      switch (userFantasyTeam) {
        case (null) {};
        case (?ufTeam) {

          let teamHistoryBuffer = Buffer.fromArray<T.FantasyTeamSeason>([]);

          switch (ufTeam.history) {
            case (null) {};
            case (existingHistory) {
              for (season in List.toIter<T.FantasyTeamSeason>(existingHistory)) {
                if (season.seasonId == seasonId) {
                  let snapshotBuffer = Buffer.fromArray<T.FantasyTeamSnapshot>([]);

                  for (snapshot in List.toIter<T.FantasyTeamSnapshot>(season.gameweeks)) {
                    if (snapshot.gameweek == gameweek) {

                      let updatedSnapshot : T.FantasyTeamSnapshot = {
                        principalId = snapshot.principalId;
                        gameweek = snapshot.gameweek;
                        transfersAvailable = snapshot.transfersAvailable;
                        bankBalance = snapshot.bankBalance;
                        playerIds = snapshot.playerIds;
                        captainId = snapshot.captainId;
                        goalGetterGameweek = snapshot.goalGetterGameweek;
                        goalGetterPlayerId = snapshot.goalGetterPlayerId;
                        passMasterGameweek = snapshot.passMasterGameweek;
                        passMasterPlayerId = snapshot.passMasterPlayerId;
                        noEntryGameweek = snapshot.noEntryGameweek;
                        noEntryPlayerId = snapshot.noEntryPlayerId;
                        teamBoostGameweek = snapshot.teamBoostGameweek;
                        teamBoostTeamId = snapshot.teamBoostTeamId;
                        safeHandsGameweek = snapshot.safeHandsGameweek;
                        safeHandsPlayerId = snapshot.safeHandsPlayerId;
                        captainFantasticGameweek = snapshot.captainFantasticGameweek;
                        captainFantasticPlayerId = snapshot.captainFantasticPlayerId;
                        countrymenGameweek = snapshot.countrymenGameweek;
                        countrymenCountryId = snapshot.countrymenCountryId;
                        prospectsGameweek = snapshot.prospectsGameweek;
                        braceBonusGameweek = snapshot.braceBonusGameweek;
                        hatTrickHeroGameweek = snapshot.hatTrickHeroGameweek;
                        favouriteTeamId = snapshot.favouriteTeamId;
                        teamName = snapshot.teamName;
                        points = teamPoints;
                        transferWindowGameweek = snapshot.transferWindowGameweek;
                      };

                      snapshotBuffer.add(updatedSnapshot);

                    } else { snapshotBuffer.add(snapshot) };
                  };

                  let gameweekSnapshots = Buffer.toArray<T.FantasyTeamSnapshot>(snapshotBuffer);

                  let totalSeasonPoints = Array.foldLeft<T.FantasyTeamSnapshot, Int16>(gameweekSnapshots, 0, func(sumSoFar, x) = sumSoFar + x.points);

                  let updatedSeason : T.FantasyTeamSeason = {
                    gameweeks = List.fromArray(gameweekSnapshots);
                    seasonId = season.seasonId;
                    totalPoints = totalSeasonPoints;
                  };

                  teamHistoryBuffer.add(updatedSeason);

                } else { teamHistoryBuffer.add(season) };
              };
            };
          };

          let updatedUserFantasyTeam : T.UserFantasyTeam = {
            fantasyTeam = ufTeam.fantasyTeam;
            history = List.fromArray(Buffer.toArray<T.FantasyTeamSeason>(teamHistoryBuffer));
          };
          fantasyTeams.put(principalId, updatedUserFantasyTeam);
        };
      };
    };

    

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
    private func calculateLeaderboards(seasonId : Nat16, gameweek : Nat8) : () {

      let seasonEntries = Array.map<(Text, T.UserFantasyTeam), T.LeaderboardEntry>(
        Iter.toArray(fantasyTeams.entries()),
        func(pair) {
          return createLeaderboardEntry(pair.0, pair.1.fantasyTeam.teamName, pair.1, totalPointsForSeason(pair.1, seasonId));
        }

      );

      let gameweekEntries = Array.map<(Text, T.UserFantasyTeam), T.LeaderboardEntry>(
        Iter.toArray(fantasyTeams.entries()),
        func(pair) {
          return createLeaderboardEntry(pair.0, pair.1.fantasyTeam.teamName, pair.1, totalPointsForGameweek(pair.1, seasonId, gameweek));
        },
      );

      let sortedGameweekEntries = List.reverse(mergeSort(List.fromArray(gameweekEntries)));
      let sortedSeasonEntries = List.reverse(mergeSort(List.fromArray(seasonEntries)));

      let positionedGameweekEntries = assignPositionText(sortedGameweekEntries);
      let positionedSeasonEntries = assignPositionText(sortedSeasonEntries);

      let existingSeasonLeaderboard = seasonLeaderboards.get(seasonId);

      let currentGameweekLeaderboard : T.Leaderboard = {
        seasonId = seasonId;
        gameweek = gameweek;
        entries = positionedGameweekEntries;
      };

      var updatedGameweekLeaderboards = List.fromArray<T.Leaderboard>([]);

      switch (existingSeasonLeaderboard) {
        case (null) {
          updatedGameweekLeaderboards := List.fromArray([currentGameweekLeaderboard]);
        };
        case (?foundLeaderboard) {
          var gameweekLeaderboardExists = false;
          updatedGameweekLeaderboards := List.map<T.Leaderboard, T.Leaderboard>(
            foundLeaderboard.gameweekLeaderboards,
            func(leaderboard : T.Leaderboard) : T.Leaderboard {
              if (leaderboard.gameweek == gameweek) {
                gameweekLeaderboardExists := true;
                return currentGameweekLeaderboard;
              } else { return leaderboard };
            },
          );

          if (not gameweekLeaderboardExists) {
            updatedGameweekLeaderboards := List.append(updatedGameweekLeaderboards, List.fromArray([currentGameweekLeaderboard]));
          };

        };
      };

      let updatedSeasonLeaderboard : T.SeasonLeaderboards = {
        seasonLeaderboard = {
          seasonId = seasonId;
          gameweek = gameweek;
          entries = positionedSeasonEntries;
        };
        gameweekLeaderboards = updatedGameweekLeaderboards;
      };

      seasonLeaderboards.put(seasonId, updatedSeasonLeaderboard);

    };

    private func calculateMonthlyLeaderboards(seasonId : Nat16, gameweek : Nat8) : () {

      var monthGameweeks : List.List<Nat8> = List.nil();
      var gameweekMonth : Nat8 = 0;

      func getLatestFixtureTime(fixtures : [T.Fixture]) : Int {
        return Array.foldLeft(
          fixtures,
          fixtures[0].kickOff,
          func(acc : Int, fixture : T.Fixture) : Int {
            if (fixture.kickOff > acc) {
              return fixture.kickOff;
            } else {
              return acc;
            };
          },
        );
      };

      switch (getGameweekFixtures) {
        case (null) {};
        case (?actualFunction) {
          let activeGameweekFixtures = actualFunction(seasonId, gameweek);
          if (activeGameweekFixtures.size() > 0) {
            gameweekMonth := Utilities.unixTimeToMonth(getLatestFixtureTime(activeGameweekFixtures));
            monthGameweeks := List.append(monthGameweeks, List.fromArray([gameweek]));

            var currentGameweek = gameweek;
            label gwLoop while (currentGameweek > 1) {
              currentGameweek -= 1;
              let currentFixtures = actualFunction(seasonId, currentGameweek);
              let currentMonth = Utilities.unixTimeToMonth(getLatestFixtureTime(currentFixtures));
              if (currentMonth == gameweekMonth) {
                monthGameweeks := List.append(monthGameweeks, List.fromArray([currentGameweek]));
              } else {
                break gwLoop;
              };
            };
          };

        };
      };

      let allUserProfiles = getProfiles();
      let profilesMap = HashMap.fromIter<Text, T.Profile>(allUserProfiles.vals(), allUserProfiles.size(), Text.equal, Text.hash);
      let clubGroup = groupByTeam(fantasyTeams, profilesMap);
      var updatedLeaderboards = List.nil<T.ClubLeaderboard>();

      for ((clubId, userTeams) : (T.TeamId, [(Text, T.UserFantasyTeam)]) in clubGroup.entries()) {

        let filteredTeams = List.filter<(Text, T.UserFantasyTeam)>(
          List.fromArray(userTeams),
          func(team : (Text, T.UserFantasyTeam)) : Bool {
            return team.1.fantasyTeam.favouriteTeamId != 0;
          },
        );

        let monthEntries = List.map<(Text, T.UserFantasyTeam), T.LeaderboardEntry>(
          filteredTeams,
          func(pair : (Text, T.UserFantasyTeam)) : T.LeaderboardEntry {
            return createLeaderboardEntry(pair.0, pair.1.fantasyTeam.teamName, pair.1, totalPointsForMonth(pair.1, seasonId, monthGameweeks));
          },
        );

        let sortedMonthEntries = List.reverse(mergeSort(monthEntries));
        let positionedGameweekEntries = assignPositionText(sortedMonthEntries);

        let clubMonthlyLeaderboard : T.ClubLeaderboard = {
          seasonId = seasonId;
          month = gameweekMonth;
          clubId = clubId;
          entries = positionedGameweekEntries;
        };

        updatedLeaderboards := List.append<T.ClubLeaderboard>(updatedLeaderboards, List.fromArray([clubMonthlyLeaderboard]));
      };

      var seasonMonthlyLeaderboards = List.nil<T.ClubLeaderboard>();

      switch (monthlyLeaderboards.get(seasonId)) {
        case (null) {};
        case (?value) { seasonMonthlyLeaderboards := value };
      };

      for (leaderboard in Iter.fromList(seasonMonthlyLeaderboards)) {
        if (not (leaderboard.month == gameweekMonth)) {
          updatedLeaderboards := List.append<T.ClubLeaderboard>(updatedLeaderboards, List.fromArray([leaderboard]));
        };
      };

      monthlyLeaderboards.put(seasonId, updatedLeaderboards);
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
*/
  };
};
