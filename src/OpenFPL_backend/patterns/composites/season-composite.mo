import T "../../types";
import DTOs "../../DTOs";
import List "mo:base/List";
import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";
import Time "mo:base/Time";
import Result "mo:base/Result";
import Array "mo:base/Array";
import Nat8 "mo:base/Nat8";
import Nat16 "mo:base/Nat16";
import Text "mo:base/Text";
import Char "mo:base/Char";
import Utilities "../../utilities";

module {

  public class SeasonComposite() {
    private var seasons = List.fromArray<T.Season>([]);
    private var nextSeasonId : T.SeasonId = 1;
    private var nextFixtureId : T.FixtureId = 1;

    public func setStableData(
      stable_next_season_id: T.SeasonId,
      stable_next_fixture_id: T.FixtureId,
      stable_seasons: [T.Season]) {

      nextSeasonId := stable_next_season_id;
      nextFixtureId := stable_next_fixture_id; 
      seasons := List.fromArray(stable_seasons);
    };

    public func getFixtures(seasonId: T.SeasonId) : [DTOs.FixtureDTO]{
      let season = List.find(
        seasons,
        func(season : T.Season) : Bool {
          return season.id == seasonId;
        },
      );
      switch(season){
        case (null) {return []};
        case (?foundSeason){
          
          let fixtureDTOs = List.map<T.Fixture, DTOs.FixtureDTO>(
            foundSeason.fixtures, 
            func(fixture : T.Fixture) : DTOs.FixtureDTO {
              return {
                awayClubId = fixture.awayClubId;
                awayGoals = fixture.awayGoals;
                gameweek = fixture.gameweek;
                highestScoringPlayerId = fixture.highestScoringPlayerId;
                homeClubId = fixture.homeClubId;
                homeGoals = fixture.homeGoals;
                id = fixture.id;
                kickOff = fixture.kickOff;
                seasonId = fixture.seasonId;
                status = fixture.status;
                events = List.toArray(fixture.events);
              };
            },
          );
          return List.toArray(fixtureDTOs);
        };
      }
    };

    public func getFixturesForGameweek(seasonId: T.SeasonId, gameweek: T.GameweekNumber) : [DTOs.FixtureDTO]{
      let season = List.find(
        seasons,
        func(season : T.Season) : Bool {
          return season.id == seasonId;
        },
      );
      switch(season){
        case (null) {return []};
        case (?foundSeason){
          let fixtures = List.filter<T.Fixture>(
            foundSeason.fixtures,
            func(fixture : T.Fixture) : Bool {
              return fixture.gameweek == gameweek;
            },
          );

          let fixtureDTOs = List.map<T.Fixture, DTOs.FixtureDTO>(
            fixtures, 
            func(fixture : T.Fixture) : DTOs.FixtureDTO {
              return {
                awayClubId = fixture.awayClubId;
                awayGoals = fixture.awayGoals;
                gameweek = fixture.gameweek;
                highestScoringPlayerId = fixture.highestScoringPlayerId;
                homeClubId = fixture.homeClubId;
                homeGoals = fixture.homeGoals;
                id = fixture.id;
                kickOff = fixture.kickOff;
                seasonId = fixture.seasonId;
                status = fixture.status;
                events = List.toArray(fixture.events);
              };
            },
          );
          return List.toArray(fixtureDTOs);
        };
      }
    };

    public func getGameweekKickOffTimes(seasonId: T.SeasonId, gamweek: T.GameweekNumber) : [Int] {

      let fixtures = getFixturesForGameweek(seasonId, gamweek);

      let kickOffTimes = Buffer.fromArray<Int>([]);

      for(fixture in Iter.fromArray<DTOs.FixtureDTO>(fixtures)){
        kickOffTimes.add(fixture.kickOff);
      };

      let uniqueKickOffTimes = Buffer.fromArray<Int>([]);
      
      for (kickOffTime in Iter.fromArray(Buffer.toArray(kickOffTimes))) {
        if (not Buffer.contains<Int>(uniqueKickOffTimes, kickOffTime, func(a : Int, b : Int) : Bool { a == b })) {
          uniqueKickOffTimes.add(kickOffTime);
        };
      };

      return Buffer.toArray(uniqueKickOffTimes);
    };

    public func setFixturesToActive(seasonId: T.SeasonId, gamweek: T.GameweekNumber) : [T.Fixture]{
      
      let currentSeason = List.find<T.Season>(
        seasons,
        func(season : T.Season) : Bool {
          return season.id == seasonId;
        },
      );

      switch(currentSeason){
        case (null) { return [] };
        case (?foundSeason){

          let fixturesToActivate = List.filter<T.Fixture>(
            foundSeason.fixtures,
            func(fixture : T.Fixture) : Bool {
              return fixture.status == #Unplayed and fixture.kickOff < Time.now();
            },
          );
          
          seasons := List.map<T.Season, T.Season>(
            seasons,
            func(season : T.Season) : T.Season {
              if (season.id == seasonId) {
                let updatedFixtures = List.map<T.Fixture, T.Fixture>(
                  season.fixtures,
                  func(fixture : T.Fixture) : T.Fixture {
                    if (List.some(fixturesToActivate, func(activatedFixture : T.Fixture) : Bool { return activatedFixture.id == fixture.id })) {
                      return {
                        id = fixture.id;
                        seasonId = fixture.seasonId;
                        gameweek = fixture.gameweek;
                        kickOff = fixture.kickOff;
                        homeClubId = fixture.homeClubId;
                        awayClubId = fixture.awayClubId;
                        homeGoals = fixture.homeGoals;
                        awayGoals = fixture.awayGoals;
                        status = #Active;
                        events = fixture.events;
                        highestScoringPlayerId = fixture.highestScoringPlayerId;
                      };
                    }
                    else
                    { return fixture; };
                  },
                );

                return {
                  id = season.id;
                  name = season.name;
                  year = season.year;
                  fixtures = updatedFixtures;
                  postponedFixtures = season.postponedFixtures;
                };
              } else {
                return season;
              };
            },
          );

          return List.toArray(fixturesToActivate);

        };
      };

    };
    
    public func setFixturesToCompleted(seasonId: T.SeasonId, gamweek: T.GameweekNumber){
      let currentSeason = List.find<T.Season>(
          seasons,
          func(season : T.Season) : Bool {
            return season.id == seasonId;
          },
        );

      switch(currentSeason){
        case (null) { };
        case (?foundSeason){

          let fixturesToComplete = List.filter<T.Fixture>(
            foundSeason.fixtures,
            func(fixture : T.Fixture) : Bool {
              return fixture.status == #Active and (fixture.kickOff + (Utilities.getHour() * 2)) < Time.now();
            },
          );
          
          seasons := List.map<T.Season, T.Season>(
            seasons,
            func(season : T.Season) : T.Season {
              if (season.id == seasonId) {
                let updatedFixtures = List.map<T.Fixture, T.Fixture>(
                  season.fixtures,
                  func(fixture : T.Fixture) : T.Fixture {
                    if (List.some(fixturesToComplete, func(completedFixture : T.Fixture) : Bool { return completedFixture.id == fixture.id })) {
                      return {
                        id = fixture.id;
                        seasonId = fixture.seasonId;
                        gameweek = fixture.gameweek;
                        kickOff = fixture.kickOff;
                        homeClubId = fixture.homeClubId;
                        awayClubId = fixture.awayClubId;
                        homeGoals = fixture.homeGoals;
                        awayGoals = fixture.awayGoals;
                        status = #Complete;
                        events = fixture.events;
                        highestScoringPlayerId = fixture.highestScoringPlayerId;
                      };
                    }
                    else
                    { return fixture; };
                  },
                );

                return {
                  id = season.id;
                  name = season.name;
                  year = season.year;
                  fixtures = updatedFixtures;
                  postponedFixtures = season.postponedFixtures;
                };
              } else {
                return season;
              };
            },
          );
        };
      };

    };

    public func validateSubmitFixtureData(submitFixtureDataDTO: DTOs.SubmitFixtureDataDTO) : async Result.Result<Text,Text> {
      
      let findIndex = func(arr : [T.ClubId], value : T.ClubId) : ?Nat {
        for (i in Array.keys(arr)) {
          if (arr[i] == value) {
            return ?(i);
          };
        };
        return null;
      };

/*
      //there should be no fixtures for the season currently
      let currentSeason = getSeason(seasonId);
      if (currentSeason.id == 0) {
        return #err(#InvalidData);
      };

      for (gameweek in Iter.fromList(currentSeason.gameweeks)) {
        if (List.size(gameweek.fixtures) > 0) {
          return #err(#InvalidData);
        };
      };

      //there are 380 fixtures
      if (Array.size(seasonFixtures) != 380) {
        return #err(#InvalidData);
      };

      let teams = await getTeams();
      let teamIds = Array.map<T.Team, T.TeamId>(teams, func(t : T.Team) : T.TeamId { return t.id });

      let uniqueTeamIdsBuffer = Buffer.fromArray<T.TeamId>([]);

      for (teamId in Iter.fromArray(teamIds)) {
        if (not Buffer.contains<T.TeamId>(uniqueTeamIdsBuffer, teamId, func(a : T.TeamId, b : T.TeamId) : Bool { a == b })) {
          uniqueTeamIdsBuffer.add(teamId);
        };
      };

      //there are 20 teams
      let uniqueTeamIds = Buffer.toArray<T.TeamId>(uniqueTeamIdsBuffer);
      if (Array.size(uniqueTeamIds) != 20) {
        return #err(#InvalidData);
      };

      //19 home games and 19 away games for each team
      let homeGamesCount = Array.tabulate<Nat>(Array.size(uniqueTeamIds), func(_ : Nat) { return 0 });
      let awayGamesCount = Array.tabulate<Nat>(Array.size(uniqueTeamIds), func(_ : Nat) { return 0 });

      let homeGamesBuffer = Buffer.fromArray<Nat>(homeGamesCount);
      let awayGamesBuffer = Buffer.fromArray<Nat>(awayGamesCount);

      for (f in Iter.fromArray(seasonFixtures)) {

        //all default values are set correctly for starting fixture, scores and statuses etc
        if (
          f.homeGoals != 0 or f.awayGoals != 0 or f.status != 0 or not List.isNil(f.events) or f.highestScoringPlayerId != 0,
        ) {
          return #err(#InvalidData);
        };

        //all team ids exist
        let homeTeam = Array.find<T.TeamId>(teamIds, func(teamId : T.TeamId) : Bool { return teamId == f.homeTeamId });
        let awayTeam = Array.find<T.TeamId>(teamIds, func(teamId : T.TeamId) : Bool { return teamId == f.awayTeamId });
        if (homeTeam == null or awayTeam == null) {
          return #err(#InvalidData);
        };

        let homeTeamIndexOpt = findIndex(uniqueTeamIds, f.homeTeamId);
        let awayTeamIndexOpt = findIndex(uniqueTeamIds, f.awayTeamId);

        label check switch (homeTeamIndexOpt, awayTeamIndexOpt) {
          case (?(homeTeamIndex), ?(awayTeamIndex)) {
            let currentHomeGames = homeGamesBuffer.get(homeTeamIndex);
            let currentAwayGames = awayGamesBuffer.get(awayTeamIndex);
            homeGamesBuffer.put(homeTeamIndex, currentHomeGames + 1);
            awayGamesBuffer.put(awayTeamIndex, currentAwayGames + 1);
            break check;
          };
          case _ {
            return #err(#InvalidData);
          };
        };

      };

      let gameweekFixturesBuffer = Buffer.fromArray<Nat>(Array.tabulate<Nat>(38, func(_ : Nat) { return 0 }));

      for (f in Iter.fromArray(seasonFixtures)) {
        let gameweekIndex = f.gameweek - 1;
        let currentCount = gameweekFixturesBuffer.get(Nat8.toNat(gameweekIndex));
        gameweekFixturesBuffer.put(Nat8.toNat(gameweekIndex), currentCount + 1);
      };

      for (i in Iter.fromArray(Buffer.toArray(gameweekFixturesBuffer))) {
        if (gameweekFixturesBuffer.get(i) != 10) {
          return #err(#InvalidData);
        };
      };

      for (i in Iter.fromArray(Buffer.toArray(homeGamesBuffer))) {
        if (homeGamesBuffer.get(i) != 19 or awayGamesBuffer.get(i) != 19) {
          return #err(#InvalidData);
        };
      };
      */
      
      return #ok("Valid");
    };

    public func executeSubmitFixtureData(submitFixtureDataDTO: DTOs.SubmitFixtureDataDTO) : async () {
      /*
      let activeSeasonId = seasonManager.getActiveSeasonId();
      let activeGameweek = seasonManager.getActiveGameweek();
      let fixture = await seasonManager.getFixture(activeSeasonId, activeGameweek, fixtureId);
      let allPlayers = await playerCanister.getPlayers();

      let homeTeamPlayerIdsBuffer = Buffer.fromArray<Nat16>([]);
      let awayTeamPlayerIdsBuffer = Buffer.fromArray<Nat16>([]);

      for (event in Iter.fromArray(playerEventData)) {
        if (event.teamId == fixture.homeTeamId) {
          homeTeamPlayerIdsBuffer.add(event.playerId);
        } else if (event.teamId == fixture.awayTeamId) {
          awayTeamPlayerIdsBuffer.add(event.playerId);
        };
      };

      let homeTeamDefensivePlayerIdsBuffer = Buffer.fromArray<Nat16>([]);
      let awayTeamDefensivePlayerIdsBuffer = Buffer.fromArray<Nat16>([]);

      for (playerId in Iter.fromArray<Nat16>(Buffer.toArray(homeTeamPlayerIdsBuffer))) {
        let player = Array.find<DTOs.PlayerDTO>(allPlayers, func(p : DTOs.PlayerDTO) : Bool { return p.id == playerId });
        switch (player) {
          case (null) {};
          case (?actualPlayer) {
            if (actualPlayer.position == 0 or actualPlayer.position == 1) {
              if (Array.find<Nat16>(Buffer.toArray(homeTeamDefensivePlayerIdsBuffer), func(x : Nat16) : Bool { return x == playerId }) == null) {
                homeTeamDefensivePlayerIdsBuffer.add(playerId);
              };
            };
          };
        };
      };

      for (playerId in Iter.fromArray<Nat16>(Buffer.toArray(awayTeamPlayerIdsBuffer))) {
        let player = Array.find<DTOs.PlayerDTO>(allPlayers, func(p : DTOs.PlayerDTO) : Bool { return p.id == playerId });
        switch (player) {
          case (null) {};
          case (?actualPlayer) {
            if (actualPlayer.position == 0 or actualPlayer.position == 1) {
              if (Array.find<Nat16>(Buffer.toArray(awayTeamDefensivePlayerIdsBuffer), func(x : Nat16) : Bool { return x == playerId }) == null) {
                awayTeamDefensivePlayerIdsBuffer.add(playerId);
              };
            };
          };
        };
      };

      // Get goals for each team
      let homeTeamGoals = Array.filter<T.PlayerEventData>(
        playerEventData,
        func(event : T.PlayerEventData) : Bool {
          return event.teamId == fixture.homeTeamId and event.eventType == 1;
        },
      );

      let awayTeamGoals = Array.filter<T.PlayerEventData>(
        playerEventData,
        func(event : T.PlayerEventData) : Bool {
          return event.teamId == fixture.awayTeamId and event.eventType == 1;
        },
      );

      let homeTeamOwnGoals = Array.filter<T.PlayerEventData>(
        playerEventData,
        func(event : T.PlayerEventData) : Bool {
          return event.teamId == fixture.homeTeamId and event.eventType == 10;
        },
      );

      let awayTeamOwnGoals = Array.filter<T.PlayerEventData>(
        playerEventData,
        func(event : T.PlayerEventData) : Bool {
          return event.teamId == fixture.awayTeamId and event.eventType == 10;
        },
      );

      let totalHomeScored = Array.size(homeTeamGoals) + Array.size(awayTeamOwnGoals);
      let totalAwayScored = Array.size(awayTeamGoals) + Array.size(homeTeamOwnGoals);

      let allPlayerEventsBuffer = Buffer.fromArray<T.PlayerEventData>(playerEventData);

      if (totalHomeScored == 0) {
        //add away team clean sheets
        for (playerId in Iter.fromArray(Buffer.toArray(awayTeamDefensivePlayerIdsBuffer))) {
          let player = Array.find<DTOs.PlayerDTO>(allPlayers, func(p : DTOs.PlayerDTO) : Bool { return p.id == playerId });
          switch (player) {
            case (null) {};
            case (?actualPlayer) {
              let cleanSheetEvent : T.PlayerEventData = {
                fixtureId = fixtureId;
                playerId = playerId;
                eventType = 5;
                eventStartMinute = 90;
                eventEndMinute = 90;
                teamId = actualPlayer.teamId;
                position = actualPlayer.position;
              };
              allPlayerEventsBuffer.add(cleanSheetEvent);
            };
          };
        };
      } else {
        //add away team conceded events
        for (goal in Iter.fromArray(homeTeamGoals)) {
          for (playerId in Iter.fromArray(Buffer.toArray(awayTeamDefensivePlayerIdsBuffer))) {
            let player = Array.find<DTOs.PlayerDTO>(allPlayers, func(p : DTOs.PlayerDTO) : Bool { return p.id == playerId });
            switch (player) {
              case (null) {};
              case (?actualPlayer) {
                let concededEvent : T.PlayerEventData = {
                  fixtureId = fixtureId;
                  playerId = actualPlayer.id;
                  eventType = 3;
                  eventStartMinute = goal.eventStartMinute;
                  eventEndMinute = goal.eventStartMinute;
                  teamId = actualPlayer.teamId;
                  position = actualPlayer.position;
                };
                allPlayerEventsBuffer.add(concededEvent);
              };
            };
          };
        };
      };

      if (totalAwayScored == 0) {
        //add home team clean sheets
        for (playerId in Iter.fromArray(Buffer.toArray(homeTeamDefensivePlayerIdsBuffer))) {
          let player = Array.find<DTOs.PlayerDTO>(allPlayers, func(p : DTOs.PlayerDTO) : Bool { return p.id == playerId });
          switch (player) {
            case (null) {};
            case (?actualPlayer) {
              let cleanSheetEvent : T.PlayerEventData = {
                fixtureId = fixtureId;
                playerId = playerId;
                eventType = 5;
                eventStartMinute = 90;
                eventEndMinute = 90;
                teamId = actualPlayer.teamId;
                position = actualPlayer.position;
              };
              allPlayerEventsBuffer.add(cleanSheetEvent);
            };
          };
        };
      } else {
        //add home team conceded events
        for (goal in Iter.fromArray(awayTeamGoals)) {
          for (playerId in Iter.fromArray(Buffer.toArray(homeTeamDefensivePlayerIdsBuffer))) {
            let player = Array.find<DTOs.PlayerDTO>(allPlayers, func(p : DTOs.PlayerDTO) : Bool { return p.id == playerId });
            switch (player) {
              case (null) {};
              case (?actualPlayer) {
                let concededEvent : T.PlayerEventData = {
                  fixtureId = goal.fixtureId;
                  playerId = actualPlayer.id;
                  eventType = 3;
                  eventStartMinute = goal.eventStartMinute;
                  eventEndMinute = goal.eventStartMinute;
                  teamId = actualPlayer.teamId;
                  position = actualPlayer.position;
                };
                allPlayerEventsBuffer.add(concededEvent);
              };
            };
          };
        };

        let fixtureEvents = Buffer.toArray(allPlayerEventsBuffer);
        await seasonManager.fixtureConsensusReached(fixture.seasonId, fixture.gameweek, fixtureId, fixtureEvents);
        return #ok();
      };

*/



    };

    public func validateAddInitialFixtures(addInitialFixturesDTO: DTOs.AddInitialFixturesDTO, seasonId: T.SeasonId, clubs: [T.Club]) : async Result.Result<Text,Text> {
        
      let currentSeason = List.find(
        seasons,
        func(season : T.Season) : Bool {
          return season.id == seasonId;
        },
      );
      switch(currentSeason){
        case (null) {
          return #err("Invalid: Season does not exist.");
        };
        case (?foundSeason){
          if(addInitialFixturesDTO.seasonStartYear - 1 != foundSeason.year){
            return #err("Invalid: Incorrect season start year.");
          };
        };
      };

      let newSeason = List.find(
        seasons,
        func(season : T.Season) : Bool {
          return season.year == addInitialFixturesDTO.seasonStartYear;
        },
      );
      switch(newSeason){
        case (null) { };
        case (?foundSeason){
          return #err("Invalid: Season already exists.");
        };
      };

      let findIndex = func(arr : [T.ClubId], value : T.ClubId) : ?Nat {
        for (i in Array.keys(arr)) {
          if (arr[i] == value) {
            return ?(i);
          };
        };
        return null;
      };

      if (Array.size(addInitialFixturesDTO.seasonFixtures) != 380) {
        return #err("Invalid: There must be 380 fixtures for a season.");
      };

      let clubIds = Array.map<T.Club, T.ClubId>(clubs, func(c : T.Club) : T.ClubId { return c.id });

      let uniqueClubIdsBuffer = Buffer.fromArray<T.ClubId>([]);

      for (clubId in Iter.fromArray(clubIds)) {
        if (not Buffer.contains<T.ClubId>(uniqueClubIdsBuffer, clubId, func(a : T.ClubId, b : T.ClubId) : Bool { a == b })) {
          uniqueClubIdsBuffer.add(clubId);
        };
      };

      let uniqueClubIds = Buffer.toArray<T.ClubId>(uniqueClubIdsBuffer);
      if (Array.size(uniqueClubIds) != 20) {
        return #err("Invalid: There must be exactly 20 teams for a season.");
      };

      //19 home games and 19 away games for each team
      let homeGamesCount = Array.tabulate<Nat>(Array.size(uniqueClubIds), func(_ : Nat) { return 0 });
      let awayGamesCount = Array.tabulate<Nat>(Array.size(uniqueClubIds), func(_ : Nat) { return 0 });

      let homeGamesBuffer = Buffer.fromArray<Nat>(homeGamesCount);
      let awayGamesBuffer = Buffer.fromArray<Nat>(awayGamesCount);

      for (f in Iter.fromArray(addInitialFixturesDTO.seasonFixtures)) {
        if (
          f.homeGoals != 0 or f.awayGoals != 0 or f.status != #Unplayed or not List.isNil(f.events) or f.highestScoringPlayerId != 0,
        ) {
          return #err("Invalid: Incorrect default values.");
        };

        //all team ids exist
        let homeTeam = Array.find<T.ClubId>(clubIds, func(clubId : T.ClubId) : Bool { return clubId == f.homeClubId });
        let awayTeam = Array.find<T.ClubId>(clubIds, func(clubId : T.ClubId) : Bool { return clubId == f.awayClubId });
        if (homeTeam == null or awayTeam == null) {
          return #err("Invalid: Incorrect default values.");
        };

        let homeTeamIndexOpt = findIndex(uniqueClubIds, f.homeClubId);
        let awayTeamIndexOpt = findIndex(uniqueClubIds, f.awayClubId);

        label check switch (homeTeamIndexOpt, awayTeamIndexOpt) {
          case (?(homeTeamIndex), ?(awayTeamIndex)) {
            let currentHomeGames = homeGamesBuffer.get(homeTeamIndex);
            let currentAwayGames = awayGamesBuffer.get(awayTeamIndex);
            homeGamesBuffer.put(homeTeamIndex, currentHomeGames + 1);
            awayGamesBuffer.put(awayTeamIndex, currentAwayGames + 1);
            break check;
          };
          case _ {
            return #err("Invalid: Incorrect fixture data.");
          };
        };

      };

      let gameweekFixturesBuffer = Buffer.fromArray<Nat>(Array.tabulate<Nat>(38, func(_ : Nat) { return 0 }));

      for (f in Iter.fromArray(addInitialFixturesDTO.seasonFixtures)) {
        let gameweekIndex = f.gameweek - 1;
        let currentCount = gameweekFixturesBuffer.get(Nat8.toNat(gameweekIndex));
        gameweekFixturesBuffer.put(Nat8.toNat(gameweekIndex), currentCount + 1);
      };

      for (i in Iter.fromArray(Buffer.toArray(homeGamesBuffer))) {
        if (homeGamesBuffer.get(i) != 19 or awayGamesBuffer.get(i) != 19) {
          return #err("Invlid: Each team must have 19 home and 19 away games.");
        };
      };
      return #ok("Valid");
    };

    public func executeAddInitialFixtures(addInitialFixturesDTO: DTOs.AddInitialFixturesDTO) : async () { 
      let seasonName = Nat16.toText(addInitialFixturesDTO.seasonStartYear) # subText(Nat16.toText(addInitialFixturesDTO.seasonStartYear + 1), 2, 3);
      let newSeason: T.Season = {
        id = nextSeasonId;
        name = seasonName;
        year = addInitialFixturesDTO.seasonStartYear;
        fixtures = List.fromArray(addInitialFixturesDTO.seasonFixtures);
        postponedFixtures = List.nil<T.Fixture>();
      };      
       seasons := List.append<T.Season>(seasons, List.make(newSeason));       
    };

    
    private func subText(value : Text, indexStart : Nat, indexEnd : Nat) : Text {
      if (indexStart == 0 and indexEnd >= value.size()) {
        return value;
      } else if (indexStart >= value.size()) {
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

    public func validateRescheduleFixture(rescheduleFixtureDTO: DTOs.RescheduleFixtureDTO) : async Result.Result<Text,Text> {

/* //TODO
      if (updatedFixtureDate <= Time.now()) {
        return #err(#InvalidData);
      };

      if (updatedFixtureGameweek <= seasonManager.getActiveGameweek()) {
        return #err(#InvalidData);
      };

      let fixture = await seasonManager.getFixture(seasonManager.getActiveSeason().id, currentFixtureGameweek, fixtureId);
      if (fixture.id == 0 or fixture.status == 3) {
        return #err(#InvalidData);
      };
*/

      return #ok("Valid");
    };

    public func executeRescheduleFixture(rescheduleFixtureDTO: DTOs.RescheduleFixtureDTO) : async () {
      /* TODO
      var allSeasons = List.fromArray(seasonsInstance.getSeasons());
      allSeasons := List.map<T.Season, T.Season>(
        allSeasons,
        func(currentSeason : T.Season) : T.Season {
          if (currentSeason.id == activeSeasonId) {
            var updatedGameweeks : List.List<T.Gameweek> = List.nil();
            var postponedFixtures : List.List<T.Fixture> = List.nil();

            for (gameweek in Iter.fromList(currentSeason.gameweeks)) {
              let postponedFixture = List.find<T.Fixture>(
                gameweek.fixtures,
                func(fixture : T.Fixture) : Bool {
                  return fixture.id == fixtureId;
                },
              );

              switch (postponedFixture) {
                case (null) {};
                case (?foundPostponedFixture) {
                  postponedFixtures := List.push(foundPostponedFixture, currentSeason.postponedFixtures);
                };
              };
            };

            updatedGameweeks := List.map<T.Gameweek, T.Gameweek>(
              currentSeason.gameweeks,
              func(gw : T.Gameweek) : T.Gameweek {
                if (gw.number == currentFixtureGameweek) {
                  return {
                    canisterId = gw.canisterId;
                    number = gw.number;
                    fixtures = List.filter<T.Fixture>(
                      gw.fixtures,
                      func(fixture : T.Fixture) : Bool {
                        return fixture.id != fixtureId;
                      },
                    );
                  };
                } else { return gw };
              },
            );

            let updatedSeason : T.Season = {
              id = currentSeason.id;
              name = currentSeason.name;
              year = currentSeason.year;
              gameweeks = updatedGameweeks;
              postponedFixtures = postponedFixtures;
            };

            return updatedSeason;
          } else {
            return currentSeason;
          };
        },
      );
      seasonsInstance.setSeasons(List.toArray(allSeasons));
      */
    };

    public func getStableSeasons() : [T.Season] {
      return List.toArray(seasons);
    };

    public func setStableSeasons(stable_seasons: [T.Season]) {
      seasons := List.fromArray(stable_seasons);
    };

    public func getStableNextSeasonId() : T.SeasonId {
      return nextSeasonId;
    };

    public func setStableNextSeasonId(stable_next_season_id: T.SeasonId) {
      nextSeasonId := stable_next_season_id;
    };

    public func getStableNextFixtureId() : T.FixtureId {
      return nextFixtureId;
    };

    public func setStableNextFixtureId(stable_next_fixture_id: T.FixtureId) {
      nextFixtureId := stable_next_fixture_id;
    };      
  };
};
