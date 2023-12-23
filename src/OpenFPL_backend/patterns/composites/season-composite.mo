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
import Int16 "mo:base/Int16";
import Text "mo:base/Text";
import Char "mo:base/Char";
import TrieMap "mo:base/TrieMap";
import HashMap "mo:base/HashMap";
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
      let validPlayerEvents = validatePlayerEvents(submitFixtureDataDTO.playerEventData);
      if (not validPlayerEvents) {
        return #err("Invalid: Player events are not valid.");
      };

      let currentSeason = List.find<T.Season>(
        seasons,
        func(season : T.Season) : Bool {
          return season.id == submitFixtureDataDTO.seasonId;
        },
      );

      switch(currentSeason){
        case (null){
          return #err("Invalid: Cannot find season.")
        };
        case (?foundSeason){
          let fixture = List.find<T.Fixture>(
          foundSeason.fixtures,
            func(f : T.Fixture) : Bool {
              return f.id == submitFixtureDataDTO.fixtureId;
            }
          );
          switch(fixture){
            case (null){
              return #err("Invalid: Cannot find fixture.")
            };
            case (?foundFixture){
              if (foundFixture.status != #Complete) {
                return #err("Invalid: Fixture status is not set to complete.");
              };
            }
          }
        }
      };

      return #ok("Valid");
    };
    
    private func validatePlayerEvents(playerEvents : [T.PlayerEventData]) : Bool {

      let eventsBelow0 = Array.filter<T.PlayerEventData>(
        playerEvents,
        func(event : T.PlayerEventData) : Bool {
          return event.eventStartMinute < 0;
        },
      );

      if (Array.size(eventsBelow0) > 0) {
        return false;
      };

      let eventsAbove90 = Array.filter<T.PlayerEventData>(
        playerEvents,
        func(event : T.PlayerEventData) : Bool {
          return event.eventStartMinute > 90;
        },
      );

      if (Array.size(eventsAbove90) > 0) {
        return false;
      };

      let playerEventsMap : TrieMap.TrieMap<T.PlayerId, List.List<T.PlayerEventData>> = TrieMap.TrieMap<T.PlayerId, List.List<T.PlayerEventData>>(Utilities.eqNat16, Utilities.hashNat16);

      for (playerEvent in Iter.fromArray(playerEvents)) {
        switch (playerEventsMap.get(playerEvent.playerId)) {
          case (null) {};
          case (?existingEvents) {
            playerEventsMap.put(playerEvent.playerId, List.push<T.PlayerEventData>(playerEvent, existingEvents));
          };
        };
      };

      for ((playerId, events) in playerEventsMap.entries()) {
        let redCards = List.filter<T.PlayerEventData>(
          events,
          func(event : T.PlayerEventData) : Bool {
            return event.eventType == #RedCard;
          },
        );

        if (List.size<T.PlayerEventData>(redCards) > 1) {
          return false;
        };

        let yellowCards = List.filter<T.PlayerEventData>(
          events,
          func(event : T.PlayerEventData) : Bool {
            return event.eventType == #YellowCard;
          },
        );

        if (List.size<T.PlayerEventData>(yellowCards) > 2) {
          return false;
        };

        if (List.size<T.PlayerEventData>(yellowCards) == 2 and List.size<T.PlayerEventData>(redCards) != 1) {
          return false;
        };

        let assists = List.filter<T.PlayerEventData>(
          events,
          func(event : T.PlayerEventData) : Bool {
            return event.eventType == #GoalAssisted;
          },
        );

        for (assist in Iter.fromList(assists)) {
          let goalsAtSameMinute = List.filter<T.PlayerEventData>(
            events,
            func(event : T.PlayerEventData) : Bool {
              return event.eventType == #Goal and event.eventStartMinute == assist.eventStartMinute;
            },
          );

          if (List.size<T.PlayerEventData>(goalsAtSameMinute) == 0) {
            return false;
          };
        };

        let penaltySaves = List.filter<T.PlayerEventData>(
          events,
          func(event : T.PlayerEventData) : Bool {
            return event.eventType == #PenaltySaved;
          },
        );

        for (penaltySave in Iter.fromList(penaltySaves)) {
          let penaltyMissesAtSameMinute = List.filter<T.PlayerEventData>(
            events,
            func(event : T.PlayerEventData) : Bool {
              return event.eventType == #PenaltyMissed and event.eventStartMinute == penaltySave.eventStartMinute;
            },
          );

          if (List.size<T.PlayerEventData>(penaltyMissesAtSameMinute) == 0) {
            return false;
          };
        };
      };

      return true;
    };

    public func populatePlayerEventData(submitFixtureDataDTO: DTOs.SubmitFixtureDataDTO, allPlayers: [DTOs.PlayerDTO]) : async ?[T.PlayerEventData] {

      let allPlayerEventsBuffer = Buffer.fromArray<T.PlayerEventData>(submitFixtureDataDTO.playerEventData);

      let homeTeamPlayerIdsBuffer = Buffer.fromArray<Nat16>([]);
      let awayTeamPlayerIdsBuffer = Buffer.fromArray<Nat16>([]);

      let currentSeason = List.find<T.Season>(
        seasons,
        func(season : T.Season) : Bool {
          return season.id == submitFixtureDataDTO.seasonId;
        },
      );

      switch(currentSeason){
        case (null){ return null; };
        case (?foundSeason){
          let fixture = List.find<T.Fixture>(
          foundSeason.fixtures,
            func(f : T.Fixture) : Bool {
              return f.id == submitFixtureDataDTO.fixtureId;
            }
          );
          switch(fixture){
            case (null){ return null; };
            case (?foundFixture){

              for (event in Iter.fromArray(submitFixtureDataDTO.playerEventData)) {
                if (event.clubId == foundFixture.homeClubId) {
                  homeTeamPlayerIdsBuffer.add(event.playerId);
                } else if (event.clubId == foundFixture.awayClubId) {
                  awayTeamPlayerIdsBuffer.add(event.playerId);
                };
              };

              let homeTeamDefensivePlayerIdsBuffer = Buffer.fromArray<Nat16>([]);
              let awayTeamDefensivePlayerIdsBuffer = Buffer.fromArray<Nat16>([]);

              for (playerId in Iter.fromArray<Nat16>(Buffer.toArray(homeTeamPlayerIdsBuffer))) {
                let player = Array.find<DTOs.PlayerDTO>(allPlayers, func(p : DTOs.PlayerDTO) : Bool { return p.id == playerId });
                switch (player) {
                  case (null) {  };
                  case (?actualPlayer) {
                    if (actualPlayer.position == #Goalkeeper or actualPlayer.position == #Defender) {
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
                  case (null) {  };
                  case (?actualPlayer) {
                    if (actualPlayer.position == #Goalkeeper or actualPlayer.position == #Defender) {
                      if (Array.find<Nat16>(Buffer.toArray(awayTeamDefensivePlayerIdsBuffer), func(x : Nat16) : Bool { return x == playerId }) == null) {
                        awayTeamDefensivePlayerIdsBuffer.add(playerId);
                      };
                    };
                  };
                };
              };

              let homeTeamGoals = Array.filter<T.PlayerEventData>(
                submitFixtureDataDTO.playerEventData,
                func(event : T.PlayerEventData) : Bool {
                  return event.clubId == foundFixture.homeClubId and event.eventType == #Goal;
                },
              );

              let awayTeamGoals = Array.filter<T.PlayerEventData>(
                submitFixtureDataDTO.playerEventData,
                func(event : T.PlayerEventData) : Bool {
                  return event.clubId == foundFixture.awayClubId and event.eventType == #Goal;
                },
              );

              let homeTeamOwnGoals = Array.filter<T.PlayerEventData>(
                submitFixtureDataDTO.playerEventData,
                func(event : T.PlayerEventData) : Bool {
                  return event.clubId == foundFixture.homeClubId and event.eventType == #OwnGoal;
                },
              );

              let awayTeamOwnGoals = Array.filter<T.PlayerEventData>(
                submitFixtureDataDTO.playerEventData,
                func(event : T.PlayerEventData) : Bool {
                  return event.clubId == foundFixture.awayClubId and event.eventType == #OwnGoal;
                },
              );

              let totalHomeScored = Array.size(homeTeamGoals) + Array.size(awayTeamOwnGoals);
              let totalAwayScored = Array.size(awayTeamGoals) + Array.size(homeTeamOwnGoals);

              if (totalHomeScored == 0) {
                for (playerId in Iter.fromArray(Buffer.toArray(awayTeamDefensivePlayerIdsBuffer))) {
                  let player = Array.find<DTOs.PlayerDTO>(allPlayers, func(p : DTOs.PlayerDTO) : Bool { return p.id == playerId });
                  switch (player) {
                    case (null) {};
                    case (?actualPlayer) {
                      let cleanSheetEvent : T.PlayerEventData = {
                        fixtureId = submitFixtureDataDTO.fixtureId;
                        playerId = playerId;
                        eventType = #CleanSheet;
                        eventStartMinute = 90;
                        eventEndMinute = 90;
                        clubId = actualPlayer.clubId;
                        position = actualPlayer.position;
                      };
                      allPlayerEventsBuffer.add(cleanSheetEvent);
                    };
                  };
                };
              } else {
                for (goal in Iter.fromArray(homeTeamGoals)) {
                  for (playerId in Iter.fromArray(Buffer.toArray(awayTeamDefensivePlayerIdsBuffer))) {
                    let player = Array.find<DTOs.PlayerDTO>(allPlayers, func(p : DTOs.PlayerDTO) : Bool { return p.id == playerId });
                    switch (player) {
                      case (null) {};
                      case (?actualPlayer) {
                        let concededEvent : T.PlayerEventData = {
                          fixtureId = submitFixtureDataDTO.fixtureId;
                          playerId = actualPlayer.id;
                          eventType = #GoalConceded;
                          eventStartMinute = goal.eventStartMinute;
                          eventEndMinute = goal.eventStartMinute;
                          clubId = actualPlayer.clubId;
                          position = actualPlayer.position;
                        };
                        allPlayerEventsBuffer.add(concededEvent);
                      };
                    };
                  };
                };
              };

              if (totalAwayScored == 0) {
                for (playerId in Iter.fromArray(Buffer.toArray(homeTeamDefensivePlayerIdsBuffer))) {
                  let player = Array.find<DTOs.PlayerDTO>(allPlayers, func(p : DTOs.PlayerDTO) : Bool { return p.id == playerId });
                  switch (player) {
                    case (null) {};
                    case (?actualPlayer) {
                      let cleanSheetEvent : T.PlayerEventData = {
                        fixtureId = submitFixtureDataDTO.fixtureId;
                        playerId = playerId;
                        eventType = #CleanSheet;
                        eventStartMinute = 90;
                        eventEndMinute = 90;
                        clubId = actualPlayer.clubId;
                        position = actualPlayer.position;
                      };
                      allPlayerEventsBuffer.add(cleanSheetEvent);
                    };
                  };
                };
              } else {
                for (goal in Iter.fromArray(awayTeamGoals)) {
                  for (playerId in Iter.fromArray(Buffer.toArray(homeTeamDefensivePlayerIdsBuffer))) {
                    let player = Array.find<DTOs.PlayerDTO>(allPlayers, func(p : DTOs.PlayerDTO) : Bool { return p.id == playerId });
                    switch (player) {
                      case (null) {};
                      case (?actualPlayer) {
                        let concededEvent : T.PlayerEventData = {
                          fixtureId = goal.fixtureId;
                          playerId = actualPlayer.id;
                          eventType = #GoalConceded;
                          eventStartMinute = goal.eventStartMinute;
                          eventEndMinute = goal.eventStartMinute;
                          clubId = actualPlayer.clubId;
                          position = actualPlayer.position;
                        };
                        allPlayerEventsBuffer.add(concededEvent);
                      };
                    };
                  };
                };
              };

              let playerEvents = Buffer.toArray<T.PlayerEventData>(allPlayerEventsBuffer);
              let eventsWithHighestScoringPlayer = populateHighestScoringPlayer(playerEvents, foundFixture, allPlayers);
              return ?eventsWithHighestScoringPlayer;
            }
          }
        }
      };
    };

    private func populateHighestScoringPlayer(playerEvents: [T.PlayerEventData], fixture: T.Fixture, players: [DTOs.PlayerDTO]) : [T.PlayerEventData]{
     
      var homeGoalsCount : Nat8 = 0;
      var awayGoalsCount : Nat8 = 0;

      let playerEventsMap : HashMap.HashMap<T.PlayerId, [T.PlayerEventData]> = HashMap.HashMap<T.PlayerId, [T.PlayerEventData]>(200, Utilities.eqNat16, Utilities.hashNat16);

      for (event in Iter.fromArray(playerEvents)) {
        switch (event.eventType) {
          case (#Goal) {
            if (event.clubId == fixture.homeClubId) {
              homeGoalsCount += 1;
            } else if (event.clubId == fixture.awayClubId) {
              awayGoalsCount += 1;
            };
          };
          case (#OwnGoal) {
            if (event.clubId == fixture.homeClubId) {
              awayGoalsCount += 1;
            } else if (event.clubId == fixture.awayClubId) {
              homeGoalsCount += 1;
            };
          };
          case _ {};
        };

        let playerId : T.PlayerId = event.playerId;
        switch (playerEventsMap.get(playerId)) {
          case (null) {
            playerEventsMap.put(playerId, [event]);
          };
          case (?existingEvents) {
            let existingEventsBuffer = Buffer.fromArray<T.PlayerEventData>(existingEvents);
            existingEventsBuffer.add(event);
            playerEventsMap.put(playerId, Buffer.toArray(existingEventsBuffer));
          };
        };
      };

      let playerScoresMap : HashMap.HashMap<Nat16, Int16> = HashMap.HashMap<Nat16, Int16>(200, Utilities.eqNat16, Utilities.hashNat16);
      for ((playerId, events) in playerEventsMap.entries()) {
        let currentPlayer = Array.find<DTOs.PlayerDTO>(
          players,
          func(player : DTOs.PlayerDTO) : Bool {
            return player.id == playerId;
          },
        );

        switch(currentPlayer){
          case (null){};
          case (?foundPlayer){
            let totalScore = Array.foldLeft<T.PlayerEventData, Int16>(
              events,
              0,
              func(acc : Int16, event : T.PlayerEventData) : Int16 {
                return acc + calculateIndividualScoreForEvent(event, foundPlayer.position);
              },
            );

            let aggregateScore = calculateAggregatePlayerEvents(events, foundPlayer.position);
            playerScoresMap.put(playerId, totalScore + aggregateScore);
          };
        }
      };
    
      var highestScore : Int16 = 0;
      var highestScoringPlayerId : T.PlayerId = 0;
      var isUniqueHighScore : Bool = true;
      let uniquePlayerIdsBuffer = Buffer.fromArray<T.PlayerId>([]);

      for (event in Iter.fromArray(playerEvents)) {
        if (not Buffer.contains<T.PlayerId>(uniquePlayerIdsBuffer, event.playerId, func(a : T.PlayerId, b : T.PlayerId) : Bool { a == b })) {
          uniquePlayerIdsBuffer.add(event.playerId);
        };
      };

      let uniquePlayerIds = Buffer.toArray<Nat16>(uniquePlayerIdsBuffer);

      for (j in Iter.range(0, Array.size(uniquePlayerIds) -1)) {
        let playerId = uniquePlayerIds[j];
        switch (playerScoresMap.get(playerId)) {
          case (?playerScore) {
            if (playerScore > highestScore) {
              highestScore := playerScore;
              highestScoringPlayerId := playerId;
              isUniqueHighScore := true;
            } else if (playerScore == highestScore) {
              isUniqueHighScore := false;
            };
          };
          case null {};
        };
      };

      if (isUniqueHighScore) {
        let highestScoringPlayer = Array.find<DTOs.PlayerDTO>(players, func(p : DTOs.PlayerDTO) : Bool { return p.id == highestScoringPlayerId });
        switch(highestScoringPlayer){
          case (null){};
          case (?foundPlayer){
            let newEvent : T.PlayerEventData = {
              fixtureId = fixture.id;
              playerId = highestScoringPlayerId;
              eventType = #HighestScoringPlayer;
              eventStartMinute = 90;
              eventEndMinute = 90;
              clubId = foundPlayer.clubId;
            };
            let existingEvents = playerEventsMap.get(highestScoringPlayerId);
            switch(existingEvents){
              case (null){};
              case (?foundEvents){
                let existingEventsBuffer = Buffer.fromArray<T.PlayerEventData>(foundEvents);
                existingEventsBuffer.add(newEvent);
                playerEventsMap.put(highestScoringPlayerId, Buffer.toArray(existingEventsBuffer));
              };
            };
          };
        };
      };

      let allEventsBuffer = Buffer.fromArray<T.PlayerEventData>([]);
      for((playerId, playerEventArray) in playerEventsMap.entries()){
        allEventsBuffer.append(Buffer.fromArray(playerEventArray));
      };

      return Buffer.toArray(allEventsBuffer);
    };


    private func calculateAggregatePlayerEvents(events : [T.PlayerEventData], playerPosition : T.PlayerPosition) : Int16 {
      var totalScore : Int16 = 0;

      if (playerPosition == #Goalkeeper or playerPosition == #Defender) {
        let goalsConcededCount = Array.filter<T.PlayerEventData>(
          events,
          func(event : T.PlayerEventData) : Bool { event.eventType == #GoalConceded },
        ).size();

        if (goalsConcededCount >= 2) {

          totalScore += (Int16.fromNat16(Nat16.fromNat(goalsConcededCount)) / 2) * -15;
        };
      };

      if (playerPosition == #Goalkeeper) {
        let savesCount = Array.filter<T.PlayerEventData>(
          events,
          func(event : T.PlayerEventData) : Bool { event.eventType == #KeeperSave },
        ).size();

        totalScore += (Int16.fromNat16(Nat16.fromNat(savesCount)) / 3) * 5;
      };

      return totalScore;
    };

    private func calculateIndividualScoreForEvent(event : T.PlayerEventData, playerPosition : T.PlayerPosition) : Int16 {
      switch (event.eventType) {
        case (#Appearance) { return 5 };
        case (#Goal) {
          switch (playerPosition) {
            case (#Forward) { return 10 };
            case (#Midfielder) { return 15 };
            case _ { return 20 };
          };
        };
        case (#GoalAssisted) {
          switch (playerPosition) {
            case (#Forward) { return 10 };
            case (#Midfielder) { return 10 };
            case _ { return 15 };
          };
        };
        case (#KeeperSave) { return 0 };
        case (#CleanSheet) {
          switch (playerPosition) {
            case (#Goalkeeper) { return 10 };
            case (#Defender) { return 10 };
            case _ { return 0 };
          };
        };
        case (#PenaltySaved) { return 20 };
        case (#PenaltyMissed) { return -15 };
        case (#YellowCard) { return -5 };
        case (#RedCard) { return -20 };
        case (#OwnGoal) { return -10 };
        case (#HighestScoringPlayer) { return 0 };
        case _ { return 0 };
      };
    };



    public func addEventsToFixture(playerEventData: [T.PlayerEventData], fixtureId: T.FixtureId) : async (){
      //TODO: Imeplement adding the events for a game to the fixture
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

    public func validateRescheduleFixture(rescheduleFixtureDTO: DTOs.RescheduleFixtureDTO, systemState: T.SystemState) : async Result.Result<Text,Text> {

      let currentSeason = List.find(
        seasons,
        func(season : T.Season) : Bool {
          return season.id == rescheduleFixtureDTO.seasonId;
        },
      );
      switch(currentSeason){
        case (null) {
          return #err("Invalid: Season does not exist.");
        };
        case (?foundSeason){
          if (rescheduleFixtureDTO.updatedFixtureDate <= Time.now()) {
            return #err("Invalid: Fixture date in the past.");
          };

          if (rescheduleFixtureDTO.updatedFixtureGameweek < systemState.pickTeamGameweek) {
            return #err("Invalid: Fixture gameweek in the past.");
          };

          let fixture = List.find(
            foundSeason.fixtures,
            func(f : T.Fixture) : Bool {
              return f.id == rescheduleFixtureDTO.fixtureId;
            },
          );

          switch(fixture){
            case (null){
              return #err("Invalid: Cannot find fixture.");
            };
            case (?foundFixture){
              if (foundFixture.status == #Finalised) {
                return #err("Invalid: Cannot reschedule finalised fixture.");
              };  
            };
          };
        };
      };

      return #ok("Valid");
    };

    public func executeRescheduleFixture(rescheduleFixtureDTO: DTOs.RescheduleFixtureDTO) : async () {
      seasons := List.map<T.Season, T.Season>(
        seasons,
        func(currentSeason : T.Season) : T.Season {
          if (currentSeason.id == rescheduleFixtureDTO.seasonId) {
            
            var postponedFixtures = currentSeason.postponedFixtures;
            let postponedFixture = List.find<T.Fixture>(
              currentSeason.fixtures,
              func(fixture : T.Fixture) : Bool {
                return fixture.id == rescheduleFixtureDTO.fixtureId;
              },
            );
            
            switch (postponedFixture) {
              case (null) {};
              case (?foundPostponedFixture) {
                postponedFixtures := List.push(foundPostponedFixture, currentSeason.postponedFixtures);
              };
            };
          
            let updatedFixtures = List.filter<T.Fixture>(
              currentSeason.fixtures,
              func(fixture : T.Fixture) : Bool {
                return fixture.id != rescheduleFixtureDTO.fixtureId;
              }    
            );
          
            let updatedSeason : T.Season = {
              id = currentSeason.id;
              name = currentSeason.name;
              year = currentSeason.year;
              fixtures = updatedFixtures;
              postponedFixtures = postponedFixtures;
            };
            return updatedSeason;
          } else {
            return currentSeason;
          };
        },
      );
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
