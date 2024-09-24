import Array "mo:base/Array";
import Bool "mo:base/Bool";
import Buffer "mo:base/Buffer";
import Char "mo:base/Char";
import Int16 "mo:base/Int16";
import Iter "mo:base/Iter";
import List "mo:base/List";
import Nat8 "mo:base/Nat8";
import Nat16 "mo:base/Nat16";
import Time "mo:base/Time";
import Text "mo:base/Text";
import TrieMap "mo:base/TrieMap";
import Order "mo:base/Order";
import Option "mo:base/Option";
import Nat "mo:base/Nat";
import Int "mo:base/Int";

import DTOs "../DTOs";
import Utilities "../utils/utilities";
import T "../types";

module {

  public class SeasonComposite() {
    private var seasons = List.fromArray<T.Season>([]);
    private var nextSeasonId : T.SeasonId = 2;
    private var nextFixtureId : T.FixtureId = 1;

    public func getSeason(seasonId : T.SeasonId) : ?DTOs.SeasonDTO {
      let season = List.find(
        seasons,
        func(season : T.Season) : Bool {
          return season.id == seasonId;
        },
      );
      switch (season) {
        case (null) { return null };
        case (?foundSeason) {
          return ?{
            id = foundSeason.id;
            name = foundSeason.name;
            year = foundSeason.year;
          };
        };
      };
    };

    public func getFixtures(dto: DTOs.GetFixturesDTO) : [DTOs.FixtureDTO] {
      let season = List.find(
        seasons,
        func(season : T.Season) : Bool {
          return season.id == dto.seasonId;
        },
      );
      switch (season) {
        case (null) { return [] };
        case (?foundSeason) {

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
      };
    };

    public func getSeasons() : [DTOs.SeasonDTO] {
      return List.toArray(
        List.map<T.Season, DTOs.SeasonDTO>(
          seasons,
          func(season : T.Season) : DTOs.SeasonDTO {
            return {
              id = season.id;
              name = season.name;
              year = season.year;
            };
          },
        ),
      );
    };

    public func getPostponedFixtures(seasonId : T.SeasonId) : [DTOs.FixtureDTO] {
      let season = List.find(
        seasons,
        func(season : T.Season) : Bool {
          return season.id == seasonId;
        },
      );
      switch (season) {
        case (null) { return [] };
        case (?foundSeason) {

          let fixtureDTOs = List.map<T.Fixture, DTOs.FixtureDTO>(
            foundSeason.postponedFixtures,
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
      };
    };

    public func getFixturesForGameweek(seasonId : T.SeasonId, gameweek : T.GameweekNumber) : [DTOs.FixtureDTO] {
      let season = List.find(
        seasons,
        func(season : T.Season) : Bool {
          return season.id == seasonId;
        },
      );
      switch (season) {
        case (null) { return [] };
        case (?foundSeason) {
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
      };
    };

    public func getGameweekKickOffTimes(seasonId : T.SeasonId, gamweek : T.GameweekNumber) : [Int] {

      let fixtures = getFixturesForGameweek(seasonId, gamweek);

      let kickOffTimes = Buffer.fromArray<Int>([]);

      for (fixture in Iter.fromArray<DTOs.FixtureDTO>(fixtures)) {
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

    public func setFixturesToActive(seasonId : T.SeasonId) {

      let currentSeason = List.find<T.Season>(
        seasons,
        func(season : T.Season) : Bool {
          return season.id == seasonId;
        },
      );

      switch (currentSeason) {
        case (null) {};
        case (?foundSeason) {

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
                    } else { return fixture };
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

    public func setFixturesToCompleted(seasonId : T.SeasonId) {
      let currentSeason = List.find<T.Season>(
        seasons,
        func(season : T.Season) : Bool {
          return season.id == seasonId;
        },
      );

      switch (currentSeason) {
        case (null) {};
        case (?foundSeason) {

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
                    } else { return fixture };
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

    public func validateSubmitFixtureData(submitFixtureDataDTO : DTOs.SubmitFixtureDataDTO) : T.RustResult {

      let validPlayerEvents = validatePlayerEvents(submitFixtureDataDTO.playerEventData);
      if (not validPlayerEvents) {
        return #Err("Invalid: Player events are not valid.");
      };

      let currentSeason = List.find<T.Season>(
        seasons,
        func(season : T.Season) : Bool {
          return season.id == submitFixtureDataDTO.seasonId;
        },
      );

      switch (currentSeason) {
        case (null) {
          return #Err("Invalid: Cannot find season.");
        };
        case (?foundSeason) {
          let fixture = List.find<T.Fixture>(
            foundSeason.fixtures,
            func(f : T.Fixture) : Bool {
              return f.id == submitFixtureDataDTO.fixtureId;
            },
          );
          switch (fixture) {
            case (null) {
              return #Err("Invalid: Cannot find fixture.");
            };
            case (?foundFixture) {
              if (foundFixture.status != #Complete) {
                return #Err("Invalid: Fixture status is not set to complete.");
              };
            };
          };
        };
      };

      return #Ok("Proposal Valid");
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
              return (event.eventType == #Goal or event.eventType == #OwnGoal) and event.eventStartMinute == assist.eventStartMinute;
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

    public func populatePlayerEventData(submitFixtureDataDTO : DTOs.SubmitFixtureDataDTO, allPlayers : [DTOs.PlayerDTO]) : async ?[T.PlayerEventData] {

      let allPlayerEventsBuffer = Buffer.fromArray<T.PlayerEventData>(submitFixtureDataDTO.playerEventData);

      let homeTeamPlayerIdsBuffer = Buffer.fromArray<Nat16>([]);
      let awayTeamPlayerIdsBuffer = Buffer.fromArray<Nat16>([]);

      let currentSeason = List.find<T.Season>(
        seasons,
        func(season : T.Season) : Bool {
          return season.id == submitFixtureDataDTO.seasonId;
        },
      );

      switch (currentSeason) {
        case (null) { return null };
        case (?foundSeason) {
          let fixture = List.find<T.Fixture>(
            foundSeason.fixtures,
            func(f : T.Fixture) : Bool {
              return f.id == submitFixtureDataDTO.fixtureId;
            },
          );
          switch (fixture) {
            case (null) { return null };
            case (?foundFixture) {

              for (event in Iter.fromArray(submitFixtureDataDTO.playerEventData)) {
                if (event.clubId == foundFixture.homeClubId) {
                  let alreadyAdded = Option.isSome(Array.find<T.PlayerId>(Buffer.toArray(homeTeamPlayerIdsBuffer), func(playerId: T.PlayerId){
                    playerId == event.playerId
                  }));
                  if(not alreadyAdded){
                    homeTeamPlayerIdsBuffer.add(event.playerId);
                  }
                } else if (event.clubId == foundFixture.awayClubId) {
                  let alreadyAdded = Option.isSome(Array.find<T.PlayerId>(Buffer.toArray(awayTeamPlayerIdsBuffer), func(playerId: T.PlayerId){
                    playerId == event.playerId
                  }));
                  if(not alreadyAdded){
                    awayTeamPlayerIdsBuffer.add(event.playerId);
                  };
                };
              };

              let homeTeamDefensivePlayerIdsBuffer = Buffer.fromArray<Nat16>([]);
              let awayTeamDefensivePlayerIdsBuffer = Buffer.fromArray<Nat16>([]);

              for (playerId in Iter.fromArray<Nat16>(Buffer.toArray(homeTeamPlayerIdsBuffer))) {
                let player = Array.find<DTOs.PlayerDTO>(allPlayers, func(p : DTOs.PlayerDTO) : Bool { return p.id == playerId });
                switch (player) {
                  case (null) {};
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
                  case (null) {};
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
            };
          };
        };
      };
    };

    private func populateHighestScoringPlayer(playerEvents : [T.PlayerEventData], fixture : T.Fixture, players : [DTOs.PlayerDTO]) : [T.PlayerEventData] {

      let playerEventsMap : TrieMap.TrieMap<T.PlayerId, [T.PlayerEventData]> = TrieMap.TrieMap<T.PlayerId, [T.PlayerEventData]>(Utilities.eqNat16, Utilities.hashNat16);

      for (event in Iter.fromArray(playerEvents)) {
        
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

      let playerScoresMap : TrieMap.TrieMap<Nat16, Int16> = TrieMap.TrieMap<Nat16, Int16>(Utilities.eqNat16, Utilities.hashNat16);
      for ((playerId, events) in playerEventsMap.entries()) {
        let currentPlayer = Array.find<DTOs.PlayerDTO>(
          players,
          func(player : DTOs.PlayerDTO) : Bool {
            return player.id == playerId;
          },
        );

        switch (currentPlayer) {
          case (null) {};
          case (?foundPlayer) {
            let totalScore = Array.foldLeft<T.PlayerEventData, Int16>(
              events,
              0,
              func(acc : Int16, event : T.PlayerEventData) : Int16 {
                return acc + Utilities.calculateIndividualScoreForEvent(event, foundPlayer.position);
              },
            );

            let aggregateScore = Utilities.calculateAggregatePlayerEvents(events, foundPlayer.position);
            playerScoresMap.put(playerId, totalScore + aggregateScore);
          };
        };
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
        switch (highestScoringPlayer) {
          case (null) {};
          case (?foundPlayer) {
            let newEvent : T.PlayerEventData = {
              fixtureId = fixture.id;
              playerId = highestScoringPlayerId;
              eventType = #HighestScoringPlayer;
              eventStartMinute = 90;
              eventEndMinute = 90;
              clubId = foundPlayer.clubId;
            };
            let existingEvents = playerEventsMap.get(highestScoringPlayerId);
            switch (existingEvents) {
              case (null) {};
              case (?foundEvents) {
                let existingEventsBuffer = Buffer.fromArray<T.PlayerEventData>(foundEvents);
                existingEventsBuffer.add(newEvent);
                playerEventsMap.put(highestScoringPlayerId, Buffer.toArray(existingEventsBuffer));
              };
            };
          };
        };
      };

      let allEventsBuffer = Buffer.fromArray<T.PlayerEventData>([]);
      for ((playerId, playerEventArray) in playerEventsMap.entries()) {
        allEventsBuffer.append(Buffer.fromArray(playerEventArray));
      };

      return Buffer.toArray(allEventsBuffer);
    };

    public func addEventsToFixture(playerEventData : [T.PlayerEventData], seasonId : T.SeasonId, fixtureId : T.FixtureId) : async () {
      seasons := List.map<T.Season, T.Season>(
        seasons,
        func(season : T.Season) : T.Season {
          if (season.id == seasonId) {
            return {
              id = season.id;
              name = season.name;
              year = season.year;
              fixtures = List.map<T.Fixture, T.Fixture>(
                season.fixtures,
                func(fixture : T.Fixture) : T.Fixture {
                  if (fixture.id == fixtureId) {
                    return {
                      id = fixture.id;
                      seasonId = fixture.seasonId;
                      gameweek = fixture.gameweek;
                      kickOff = fixture.kickOff;
                      homeClubId = fixture.homeClubId;
                      awayClubId = fixture.awayClubId;
                      homeGoals = fixture.homeGoals;
                      awayGoals = fixture.awayGoals;
                      status = fixture.status;
                      events = List.fromArray(playerEventData);
                      highestScoringPlayerId = fixture.highestScoringPlayerId;
                    };
                  } else { return fixture };
                },
              );
              postponedFixtures = season.postponedFixtures;
            };
          } else {
            return season;
          };
        },
      );
    };

    public func setFixtureToFinalised(seasonId: T.SeasonId, fixtureId: T.FixtureId) {
      seasons := List.map<T.Season, T.Season>(
        seasons,
        func(season : T.Season) : T.Season {
          if (season.id == seasonId) {
            let updatedFixtures = List.map<T.Fixture, T.Fixture>(
              season.fixtures,
              func(fixture : T.Fixture) : T.Fixture {
                if (fixture.id == fixtureId) {
                  return {
                    id = fixture.id;
                    seasonId = fixture.seasonId;
                    gameweek = fixture.gameweek;
                    kickOff = fixture.kickOff;
                    homeClubId = fixture.homeClubId;
                    awayClubId = fixture.awayClubId;
                    homeGoals = fixture.homeGoals;
                    awayGoals = fixture.awayGoals;
                    status = #Finalised;
                    events = fixture.events;
                    highestScoringPlayerId = fixture.highestScoringPlayerId;
                  };
                } else { return fixture };
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

    public func checkGameweekComplete(systemState : T.SystemState) : Bool {
      let season = List.find(
        seasons,
        func(season : T.Season) : Bool {
          return season.id == systemState.calculationSeasonId;
        },
      );
      switch (season) {
        case (null) { return false };
        case (?foundSeason) {
          let fixtures = List.filter<T.Fixture>(
            foundSeason.fixtures,
            func(fixture : T.Fixture) : Bool {
              return fixture.gameweek == systemState.calculationGameweek;
            },
          );

          let completedFixtures = List.filter<T.Fixture>(
            fixtures,
            func(fixture : T.Fixture) : Bool {
              return fixture.status == #Finalised;
            },
          );

          return List.size(completedFixtures) == List.size(fixtures);

        };
      };
      return false;
    };

    public func checkMonthComplete(systemState : T.SystemState) : Bool {

      let currentSeason = List.find(
        seasons,
        func(season : T.Season) : Bool {
          return season.id == systemState.calculationSeasonId;
        },
      );

      switch (currentSeason) {
        case (null) {
          return false;
        };
        case (?foundSeason) {

          let gameweekFixtures = List.toArray(
            List.filter<T.Fixture>(
              foundSeason.fixtures,
              func(fixture : T.Fixture) : Bool {
                return fixture.gameweek == systemState.calculationGameweek;
              },
            ),
          );

          let completedGameweekFixtures = Array.filter<T.Fixture>(
            gameweekFixtures,
            func(fixture : T.Fixture) : Bool {
              return fixture.status == #Finalised;
            },
          );

          if (Array.size(gameweekFixtures) != Array.size(completedGameweekFixtures)) {
            return false;
          };

          if (systemState.calculationGameweek >= 38) {
            return true;
          };

          let nextGameweekFixtures = List.toArray(
            List.filter<T.Fixture>(
              foundSeason.fixtures,
              func(fixture : T.Fixture) : Bool {
                return fixture.gameweek == systemState.calculationGameweek + 1;
              },
            ),
          );

          let sortedNextFixtures = Array.sort(
            nextGameweekFixtures,
            func(a : T.Fixture, b : T.Fixture) : Order.Order {
              if (a.kickOff < b.kickOff) { return #greater };
              if (a.kickOff == b.kickOff) { return #equal };
              return #less;
            },
          );

          let latestNextFixture = sortedNextFixtures[0];
          let fixtureMonth = Utilities.unixTimeToMonth(latestNextFixture.kickOff);

          return fixtureMonth > systemState.calculationMonth;
        };
      };

      return false;
    };

    public func checkSeasonComplete(systemState : T.SystemState) : Bool {

      if (systemState.calculationGameweek != 38) {
        return false;
      };

      let currentSeason = List.find(
        seasons,
        func(season : T.Season) : Bool {
          return season.id == systemState.calculationSeasonId;
        },
      );

      switch (currentSeason) {
        case (null) {
          return false;
        };
        case (?foundSeason) {

          if (List.size(foundSeason.fixtures) == 0) {
            return false;
          };

          let completedFixtures = List.filter<T.Fixture>(
            foundSeason.fixtures,
            func(fixture : T.Fixture) : Bool {
              return fixture.status == #Finalised;
            },
          );

          return List.size(completedFixtures) == List.size(foundSeason.fixtures);
        };
      };

      return false;
    };

    public func validateAddInitialFixtures(addInitialFixturesDTO : DTOs.AddInitialFixturesDTO, clubs : [T.Club]) : T.RustResult {

      let currentSeason = List.find(
        seasons,
        func(season : T.Season) : Bool {
          return season.id == addInitialFixturesDTO.seasonId;
        },
      );
      switch (currentSeason) {
        case (null) {
          return #Err("Invalid: Season does not exist.");
        };
        case (?foundSeason) {
          //ensure all fixtures have the current seasons id
          let filteredFixtures = List.filter<DTOs.FixtureDTO>(
            List.fromArray(addInitialFixturesDTO.seasonFixtures),
            func(fixture : DTOs.FixtureDTO) : Bool {
              return fixture.seasonId != foundSeason.id;
            },
          );

          if (List.size(filteredFixtures) > 0) {
            return #Err("Invalid: Fixtures not for current season.");
          };

          if (Array.size(addInitialFixturesDTO.seasonFixtures) != 380) {
            return #Err("Invalid: There must be 380 fixtures for a season.");
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
            return #Err("Invalid: There must be exactly 20 teams for a season.");
          };

          let homeFixtureMap : TrieMap.TrieMap<T.ClubId, Int> = TrieMap.TrieMap<T.ClubId, Int>(Utilities.eqNat16, Utilities.hashNat16);

          for (f in Iter.fromArray(addInitialFixturesDTO.seasonFixtures)) {

            let existing = homeFixtureMap.get(f.homeClubId);
            switch (existing) {
              case (null) {
                homeFixtureMap.put(f.homeClubId, 1);
              };
              case (?found) {
                homeFixtureMap.put(f.homeClubId, found + 1);
              };
            };
          };

          let awayFixtureMap : TrieMap.TrieMap<T.ClubId, Int> = TrieMap.TrieMap<T.ClubId, Int>(Utilities.eqNat16, Utilities.hashNat16);

          for (f in Iter.fromArray(addInitialFixturesDTO.seasonFixtures)) {

            let existing = awayFixtureMap.get(f.awayClubId);
            switch (existing) {
              case (null) {
                awayFixtureMap.put(f.awayClubId, 1);
              };
              case (?found) {
                awayFixtureMap.put(f.awayClubId, found + 1);
              };
            };
          };

          for (map in homeFixtureMap.entries()) {
            if (map.1 != 19) {
              return #Err("Invlid: Each team must have 19 home games.");
            };
          };

          for (map in awayFixtureMap.entries()) {
            if (map.1 != 19) {
              return #Err("Invlid: Each team must have 19 away games.");
            };
          };

        };
      };

      return #Ok("Proposal Valid");
    };

    public func executeAddInitialFixtures(addInitialFixturesDTO : DTOs.AddInitialFixturesDTO) : async () {
      seasons := List.map<T.Season, T.Season>(
        seasons,
        func(season : T.Season) : T.Season {
          if (season.id == addInitialFixturesDTO.seasonId) {
            return {
              id = season.id;
              name = season.name;
              year = season.year;
              fixtures = List.map<DTOs.FixtureDTO, T.Fixture>(
                List.fromArray(addInitialFixturesDTO.seasonFixtures),
                func(fixture : DTOs.FixtureDTO) : T.Fixture {
                  return {
                    id = fixture.id;
                    seasonId = fixture.seasonId;
                    gameweek = fixture.gameweek;
                    kickOff = fixture.kickOff;
                    homeClubId = fixture.homeClubId;
                    awayClubId = fixture.awayClubId;
                    homeGoals = fixture.homeGoals;
                    awayGoals = fixture.awayGoals;
                    status = fixture.status;
                    events = List.fromArray(fixture.events);
                    highestScoringPlayerId = fixture.highestScoringPlayerId;
                  };
                },
              );
              postponedFixtures = season.postponedFixtures;
            };
          } else {
            return season;
          };
        },
      );
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

    public func validateMoveFixture(moveFixtureDTO : DTOs.MoveFixtureDTO, systemState : T.SystemState) : T.RustResult {
      let currentSeason = List.find(
        seasons,
        func(season : T.Season) : Bool {
          return season.id == systemState.calculationSeasonId;
        },
      );
      switch (currentSeason) {
        case (null) {
          return #Err("Invalid: Season does not exist.");
        };
        case (?foundSeason) {
          if (moveFixtureDTO.updatedFixtureDate < Time.now()) {
            return #Err("Invalid: Fixture date in the past.");
          };

          if (moveFixtureDTO.updatedFixtureGameweek < systemState.pickTeamGameweek) {
            return #Err("Invalid: Fixture gameweek in the past.");
          };

          let fixture = List.find(
            foundSeason.fixtures,
            func(f : T.Fixture) : Bool {
              return f.id == moveFixtureDTO.fixtureId;
            },
          );

          switch (fixture) {
            case (null) {
              return #Err("Invalid: Cannot find fixture.");
            };
            case (?foundFixture) {
              if (foundFixture.status == #Finalised) {
                return #Err("Invalid: Cannot reschedule finalised fixture.");
              };
            };
          };
        };
      };

      return #Ok("Proposal Valid");
    };

    public func executeMoveFixture(moveFixtureDTO : DTOs.MoveFixtureDTO, systemState : T.SystemState) : async () {
      seasons := List.map<T.Season, T.Season>(
        seasons,
        func(currentSeason : T.Season) : T.Season {
          if (currentSeason.id == systemState.calculationSeasonId) {
            let updatedSeason : T.Season = {
              id = currentSeason.id;
              name = currentSeason.name;
              year = currentSeason.year;
              fixtures = List.map<T.Fixture, T.Fixture>(
                currentSeason.fixtures,
                func(currentFixture : T.Fixture) : T.Fixture {
                  if (currentFixture.id == moveFixtureDTO.fixtureId) {
                    return {
                      awayClubId = currentFixture.awayClubId;
                      awayGoals = currentFixture.awayGoals;
                      events = currentFixture.events;
                      gameweek = moveFixtureDTO.updatedFixtureGameweek;
                      highestScoringPlayerId = currentFixture.highestScoringPlayerId;
                      homeClubId = currentFixture.homeClubId;
                      homeGoals = currentFixture.homeGoals;
                      id = currentFixture.id;
                      kickOff = moveFixtureDTO.updatedFixtureDate;
                      seasonId = currentFixture.seasonId;
                      status = currentFixture.status;
                    };
                  } else {
                    return currentFixture;
                  };
                },
              );
              postponedFixtures = currentSeason.postponedFixtures;
            };
            return updatedSeason;
          } else {
            return currentSeason;
          };
        },
      );
    };

    public func validatePostponeFixture(postponeFixtureDTO : DTOs.PostponeFixtureDTO, systemState : T.SystemState) : T.RustResult {
      let currentSeason = List.find(
        seasons,
        func(season : T.Season) : Bool {
          return season.id == systemState.calculationSeasonId;
        },
      );
      switch (currentSeason) {
        case (null) {
          return #Err("Invalid: Season does not exist.");
        };
        case (?foundSeason) {

          let fixture = List.find(
            foundSeason.fixtures,
            func(f : T.Fixture) : Bool {
              return f.id == postponeFixtureDTO.fixtureId;
            },
          );

          switch (fixture) {
            case (null) {
              return #Err("Invalid: Cannot find fixture.");
            };
            case (?foundFixture) {
              if (foundFixture.status == #Finalised) {
                return #Err("Invalid: Cannot postpone finalised fixture.");
              };
            };
          };
        };
      };

      return #Ok("Proposal Valid");
    };

    public func executePostponeFixture(postponeFixtureDTO : DTOs.PostponeFixtureDTO, systemState : T.SystemState) : async () {

      seasons := List.map<T.Season, T.Season>(
        seasons,
        func(currentSeason : T.Season) : T.Season {
          if (currentSeason.id == systemState.calculationSeasonId) {
            var postponedFixtures = currentSeason.postponedFixtures;
            let postponedFixture = List.find<T.Fixture>(
              currentSeason.fixtures,
              func(fixture : T.Fixture) : Bool {
                return fixture.id == postponeFixtureDTO.fixtureId;
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
                return fixture.id != postponeFixtureDTO.fixtureId;
              },
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

    public func validateRescheduleFixture(rescheduleFixtureDTO : DTOs.RescheduleFixtureDTO, systemState : T.SystemState) : T.RustResult {
      let currentSeason = List.find(
        seasons,
        func(season : T.Season) : Bool {
          return season.id == systemState.calculationSeasonId;
        },
      );
      switch (currentSeason) {
        case (null) {
          return #Err("Invalid: Season does not exist.");
        };
        case (?foundSeason) {

          let fixture = List.find(
            foundSeason.postponedFixtures,
            func(f : T.Fixture) : Bool {
              return f.id == rescheduleFixtureDTO.postponedFixtureId;
            },
          );

          switch (fixture) {
            case (null) {
              return #Err("Invalid: Cannot find postponed fixture.");
            };
            case (?foundFixture) {
              if (foundFixture.status == #Finalised) {
                return #Err("Invalid: Cannot reschedule finalised fixture.");
              };
            };
          };
        };
      };

      return #Ok("Proposal Valid");
    };

    public func executeRescheduleFixture(rescheduleFixtureDTO : DTOs.RescheduleFixtureDTO, systemState : T.SystemState) : async () {

      let currentSeason = List.find(
        seasons,
        func(season : T.Season) : Bool {
          return season.id == systemState.calculationSeasonId;
        },
      );
      switch (currentSeason) {
        case (null) {};
        case (?foundSeason) {

          let postponedFixture = List.find(
            foundSeason.postponedFixtures,
            func(f : T.Fixture) : Bool {
              return f.id == rescheduleFixtureDTO.postponedFixtureId;
            },
          );

          switch (postponedFixture) {
            case (null) {};
            case (?foundPostponedFixture) {

              let rescheduledFixture : T.Fixture = {
                awayClubId = foundPostponedFixture.awayClubId;
                awayGoals = foundPostponedFixture.awayGoals;
                events = foundPostponedFixture.events;
                gameweek = rescheduleFixtureDTO.updatedFixtureGameweek;
                highestScoringPlayerId = foundPostponedFixture.highestScoringPlayerId;
                homeClubId = foundPostponedFixture.homeClubId;
                homeGoals = foundPostponedFixture.homeGoals;
                id = foundPostponedFixture.id;
                kickOff = rescheduleFixtureDTO.updatedFixtureDate;
                seasonId = foundPostponedFixture.seasonId;
                status = foundPostponedFixture.status;
              };

              let updatedSeasonFixtures = List.append<T.Fixture>(foundSeason.fixtures, List.make(rescheduledFixture));

              seasons := List.map<T.Season, T.Season>(
                seasons,
                func(currentSeason : T.Season) : T.Season {
                  if (currentSeason.id == systemState.calculationSeasonId) {

                    let updatedPostponedFixtures = List.filter<T.Fixture>(
                      currentSeason.postponedFixtures,
                      func(fixture : T.Fixture) : Bool {
                        return fixture.id != rescheduleFixtureDTO.postponedFixtureId;
                      },
                    );

                    let updatedSeason : T.Season = {
                      id = currentSeason.id;
                      name = currentSeason.name;
                      year = currentSeason.year;
                      fixtures = updatedSeasonFixtures;
                      postponedFixtures = updatedPostponedFixtures;
                    };
                    return updatedSeason;
                  } else {
                    return currentSeason;
                  };
                },
              );
            };
          };
        };
      };
    };

    public func createNewSeason(systemState : T.SystemState) {
      let existingSeason = List.find(
        seasons,
        func(season : T.Season) : Bool {
          return season.year == systemState.calculationSeasonId + 1;
        },
      );

      let currentSeason = List.find(
        seasons,
        func(season : T.Season) : Bool {
          return season.year == systemState.calculationSeasonId;
        },
      );
      switch (existingSeason) {
        case (null) {};
        case (?foundSeason) {
          let seasonName = Nat16.toText(foundSeason.year) # subText(Nat16.toText(foundSeason.year + 1), 2, 3);
          let newSeason : T.Season = {
            id = nextSeasonId;
            name = seasonName;
            year = foundSeason.year + 1;
            fixtures = List.fromArray([]);
            postponedFixtures = List.nil<T.Fixture>();
          };
          seasons := List.append<T.Season>(seasons, List.make(newSeason));
          nextSeasonId := nextSeasonId;
        };
      };
    };

    public func getStableSeasons() : [T.Season] {
      return List.toArray(seasons);
    };

    public func setStableSeasons(stable_seasons : [T.Season]) {
      seasons := List.fromArray(stable_seasons);
    };

    public func getStableNextSeasonId() : T.SeasonId {
      return nextSeasonId;
    };

    public func setStableNextSeasonId(stable_next_season_id : T.SeasonId) {
      nextSeasonId := stable_next_season_id;
    };

    public func getStableNextFixtureId() : T.FixtureId {
      return nextFixtureId;
    };

    public func setStableNextFixtureId(stable_next_fixture_id : T.FixtureId) {
      nextFixtureId := stable_next_fixture_id;
    };

    public func removeEventDataFromFixtures() : async (){
      
      let seasonBuffer = Buffer.fromArray<T.Season>([]);

      for(season in Iter.fromList(seasons)){
        let fixturesBuffer = Buffer.fromArray<T.Fixture>([]);
        for(fixture in Iter.fromList(season.fixtures)){
          fixturesBuffer.add({
            awayClubId = fixture.awayClubId;
            awayGoals = fixture.awayGoals;
            events = List.nil();
            gameweek = fixture.gameweek;
            highestScoringPlayerId = fixture.highestScoringPlayerId;
            homeClubId = fixture.homeClubId;
            homeGoals = fixture.homeGoals;
            id = fixture.id;
            kickOff = fixture.kickOff;
            seasonId = fixture.seasonId;
            status = fixture.status;
          });
        };
        let updatedSeason: T.Season = {
          fixtures = List.fromArray(Buffer.toArray(fixturesBuffer));
          id = season.id;
          name = season.name;
          postponedFixtures = season.postponedFixtures;
          year = season.year;
        };
        seasonBuffer.add(updatedSeason);
      };

      seasons := List.fromArray(Buffer.toArray(seasonBuffer));
    };


    public func setFixtureToComplete(seasonId: T.SeasonId, fixtureId: T.FixtureId){
      let seasonBuffer = Buffer.fromArray<T.Season>([]);

      for(season in Iter.fromList(seasons)){
        if(season.id == seasonId){
          let fixturesBuffer = Buffer.fromArray<T.Fixture>([]);
          for(fixture in Iter.fromList(season.fixtures)){
            if(fixture.id == fixtureId){
              fixturesBuffer.add({
                awayClubId = fixture.awayClubId;
                awayGoals = fixture.awayGoals;
                events = fixture.events;
                gameweek = fixture.gameweek;
                highestScoringPlayerId = fixture.highestScoringPlayerId;
                homeClubId = fixture.homeClubId;
                homeGoals = fixture.homeGoals;
                id = fixture.id;
                kickOff = fixture.kickOff;
                seasonId = fixture.seasonId;
                status = #Complete;
              });
            } else {
              fixturesBuffer.add(fixture);
            }
          };
          let updatedSeason: T.Season = {
            fixtures = List.fromArray(Buffer.toArray(fixturesBuffer));
            id = season.id;
            name = season.name;
            postponedFixtures = season.postponedFixtures;
            year = season.year;
          };
          seasonBuffer.add(updatedSeason);
        } else {
          seasonBuffer.add(season);
        };
      };

      seasons := List.fromArray(Buffer.toArray(seasonBuffer));
    };

    public func setGameScore(seasonId: T.SeasonId, fixtureId: T.FixtureId){
      let seasonBuffer = Buffer.fromArray<T.Season>([]);

      for(season in Iter.fromList(seasons)){
        if(season.id == seasonId){
          let fixturesBuffer = Buffer.fromArray<T.Fixture>([]);
          for(fixture in Iter.fromList(season.fixtures)){
            if(fixture.id == fixtureId){

              var homeGoals: Nat8 = 0;
              var awayGoals: Nat8 = 0;

              for(event in Iter.fromList(fixture.events)){
                switch(event.eventType){
                  case (#Goal) {
                    if(event.clubId == fixture.homeClubId){
                      homeGoals += 1;
                    } else {
                      awayGoals += 1;
                    }
                  };
                  case (#OwnGoal){
                    if(event.clubId == fixture.homeClubId){
                      awayGoals += 1;
                    } else {
                      homeGoals += 1;
                    }
                  };
                  case _ { };
                };
              };

              fixturesBuffer.add({
                awayClubId = fixture.awayClubId;
                awayGoals = awayGoals;
                events = fixture.events;
                gameweek = fixture.gameweek;
                highestScoringPlayerId = fixture.highestScoringPlayerId;
                homeClubId = fixture.homeClubId;
                homeGoals = homeGoals;
                id = fixture.id;
                kickOff = fixture.kickOff;
                seasonId = fixture.seasonId;
                status = fixture.status;
              });
            } else {
              fixturesBuffer.add(fixture);
            }
          };
          let updatedSeason: T.Season = {
            fixtures = List.fromArray(Buffer.toArray(fixturesBuffer));
            id = season.id;
            name = season.name;
            postponedFixtures = season.postponedFixtures;
            year = season.year;
          };
          seasonBuffer.add(updatedSeason);
        } else {
          seasonBuffer.add(season);
        };
      };

      seasons := List.fromArray(Buffer.toArray(seasonBuffer));
    };

    public func setInitialSeason() {
      seasons := List.fromArray<T.Season>([{
        fixtures = List.fromArray<T.Fixture>([
          { id = 1; seasonId = 1; gameweek  = 2; kickOff = 1701446400000000000; homeClubId = 1; awayClubId = 16; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 3; seasonId = 1; gameweek = 1; kickOff = 1701446400000000000; homeClubId = 3; awayClubId = 19; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 4; seasonId = 1; gameweek = 1; kickOff = 1701446400000000000; homeClubId = 5; awayClubId = 12; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 5; seasonId = 1; gameweek = 1; kickOff = 1701446400000000000; homeClubId = 9; awayClubId = 10; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 6; seasonId = 1; gameweek = 1; kickOff = 1701446400000000000; homeClubId = 17; awayClubId = 8; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 7; seasonId = 1; gameweek = 1; kickOff = 1701446400000000000; homeClubId = 15; awayClubId = 2; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 8; seasonId = 1; gameweek = 1; kickOff = 1701446400000000000; homeClubId = 4; awayClubId = 18; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 9; seasonId = 1; gameweek = 1; kickOff = 1701446400000000000; homeClubId = 7; awayClubId = 11; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 10; seasonId = 1; gameweek = 1; kickOff = 1701446400000000000; homeClubId = 14; awayClubId = 20; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 11; seasonId = 1; gameweek = 2; kickOff = 1701532800000000000; homeClubId = 2; awayClubId = 9; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 12; seasonId = 1; gameweek = 2; kickOff = 1701532800000000000; homeClubId = 8; awayClubId = 1; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 13; seasonId = 1; gameweek = 2; kickOff = 1701532800000000000; homeClubId = 10; awayClubId = 4; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 14; seasonId = 1; gameweek = 2; kickOff = 1701532800000000000; homeClubId = 11; awayClubId = 3; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 16; seasonId = 1; gameweek = 2; kickOff = 1701532800000000000; homeClubId = 13; awayClubId = 15; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 17; seasonId = 1; gameweek = 2; kickOff = 1701532800000000000; homeClubId = 16; awayClubId = 17; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 18; seasonId = 1; gameweek = 2; kickOff = 1701532800000000000; homeClubId = 18; awayClubId = 14; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 19; seasonId = 1; gameweek = 2; kickOff = 1701532800000000000; homeClubId = 19; awayClubId = 7; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 20; seasonId = 1; gameweek = 2; kickOff = 1701532800000000000; homeClubId = 20; awayClubId = 5; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 21; seasonId = 1; gameweek = 3; kickOff = 1701619200000000000; homeClubId = 3; awayClubId = 18; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 22; seasonId = 1; gameweek = 3; kickOff = 1701619200000000000; homeClubId = 1; awayClubId = 10; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 23; seasonId = 1; gameweek = 3; kickOff = 1701619200000000000; homeClubId = 4; awayClubId = 8; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 24; seasonId = 1; gameweek = 3; kickOff = 1701619200000000000; homeClubId = 5; awayClubId = 19; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 25; seasonId = 1; gameweek = 3; kickOff = 1701619200000000000; homeClubId = 6; awayClubId = 2; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 26; seasonId = 1; gameweek = 3; kickOff = 1701619200000000000; homeClubId = 7; awayClubId = 12; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 27; seasonId = 1; gameweek = 3; kickOff = 1701619200000000000; homeClubId = 9; awayClubId = 20; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 28; seasonId = 1; gameweek = 3; kickOff = 1701619200000000000; homeClubId = 14; awayClubId = 16; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 29; seasonId = 1; gameweek = 3; kickOff = 1701619200000000000; homeClubId = 15; awayClubId = 11; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 30; seasonId = 1; gameweek = 3; kickOff = 1701619200000000000; homeClubId = 17; awayClubId = 13; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 31; seasonId = 1; gameweek = 4; kickOff = 1720366200000000000; homeClubId = 1; awayClubId = 14; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 32; seasonId = 1; gameweek = 4; kickOff = 1720366200000000000; homeClubId = 4; awayClubId = 3; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 33; seasonId = 1; gameweek = 4; kickOff = 1720366200000000000; homeClubId = 5; awayClubId = 15; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 34; seasonId = 1; gameweek = 4; kickOff = 1720366200000000000; homeClubId = 6; awayClubId = 18; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 35; seasonId = 1; gameweek = 4; kickOff = 1720366200000000000; homeClubId = 7; awayClubId = 16; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 36; seasonId = 1; gameweek = 4; kickOff = 1720366200000000000; homeClubId = 8; awayClubId = 20; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 37; seasonId = 1; gameweek = 4; kickOff = 1720366200000000000; homeClubId = 11; awayClubId = 2; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 38; seasonId = 1; gameweek = 4; kickOff = 1720366200000000000; homeClubId = 12; awayClubId = 19; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 39; seasonId = 1; gameweek = 4; kickOff = 1720366200000000000; homeClubId = 13; awayClubId = 10; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 40; seasonId = 1; gameweek = 4; kickOff = 1720366200000000000; homeClubId = 17; awayClubId = 9; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 41; seasonId = 1; gameweek = 5; kickOff = 1720366200000000000; homeClubId = 3; awayClubId = 7; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 42; seasonId = 1; gameweek = 5; kickOff = 1720366200000000000; homeClubId = 2; awayClubId = 8; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 43; seasonId = 1; gameweek = 5; kickOff = 1720366200000000000; homeClubId = 9; awayClubId = 1; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 44; seasonId = 1; gameweek = 5; kickOff = 1720366200000000000; homeClubId = 10; awayClubId = 12; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 45; seasonId = 1; gameweek = 5; kickOff = 1720366200000000000; homeClubId = 14; awayClubId = 5; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 46; seasonId = 1; gameweek = 5; kickOff = 1720366200000000000; homeClubId = 15; awayClubId = 4; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 47; seasonId = 1; gameweek = 5; kickOff = 1720366200000000000; homeClubId = 16; awayClubId = 6; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 48; seasonId = 1; gameweek = 5; kickOff = 1720366200000000000; homeClubId = 18; awayClubId = 17; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 49; seasonId = 1; gameweek = 5; kickOff = 1720366200000000000; homeClubId = 19; awayClubId = 13; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 50; seasonId = 1; gameweek = 5; kickOff = 1720366200000000000; homeClubId = 20; awayClubId = 11; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 51; seasonId = 1; gameweek = 6; kickOff = 1720366200000000000; homeClubId = 1; awayClubId = 18; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 52; seasonId = 1; gameweek = 6; kickOff = 1720366200000000000; homeClubId = 4; awayClubId = 9; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 53; seasonId = 1; gameweek = 6; kickOff = 1720366200000000000; homeClubId = 5; awayClubId = 3; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 54; seasonId = 1; gameweek = 6; kickOff = 1720366200000000000; homeClubId = 6; awayClubId = 14; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 55; seasonId = 1; gameweek = 6; kickOff = 1720366200000000000; homeClubId = 7; awayClubId = 2; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 56; seasonId = 1; gameweek = 6; kickOff = 1720366200000000000; homeClubId = 8; awayClubId = 10; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 57; seasonId = 1; gameweek = 6; kickOff = 1720366200000000000; homeClubId = 11; awayClubId = 19; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 58; seasonId = 1; gameweek = 6; kickOff = 1720366200000000000; homeClubId = 12; awayClubId = 20; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 59; seasonId = 1; gameweek = 6; kickOff = 1720366200000000000; homeClubId = 13; awayClubId = 16; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 60; seasonId = 1; gameweek = 6; kickOff = 1720366200000000000; homeClubId = 17; awayClubId = 15; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 61; seasonId = 1; gameweek = 7; kickOff = 1720366200000000000; homeClubId = 3; awayClubId = 1; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 62; seasonId = 1; gameweek = 7; kickOff = 1720366200000000000; homeClubId = 2; awayClubId = 5; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 63; seasonId = 1; gameweek = 7; kickOff = 1720366200000000000; homeClubId = 9; awayClubId = 12; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 64; seasonId = 1; gameweek = 7; kickOff = 1720366200000000000; homeClubId = 10; awayClubId = 7; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 65; seasonId = 1; gameweek = 7; kickOff = 1720366200000000000; homeClubId = 14; awayClubId = 8; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 66; seasonId = 1; gameweek = 7; kickOff = 1720366200000000000; homeClubId = 15; awayClubId = 6; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 67; seasonId = 1; gameweek = 7; kickOff = 1720366200000000000; homeClubId = 16; awayClubId = 4; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 68; seasonId = 1; gameweek = 7; kickOff = 1720366200000000000; homeClubId = 18; awayClubId = 11; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 69; seasonId = 1; gameweek = 7; kickOff = 1720366200000000000; homeClubId = 19; awayClubId = 17; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 70; seasonId = 1; gameweek = 7; kickOff = 1720366200000000000; homeClubId = 20; awayClubId = 13; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 71; seasonId = 1; gameweek = 8; kickOff = 1720366200000000000; homeClubId = 1; awayClubId = 13; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 72; seasonId = 1; gameweek = 8; kickOff = 1720366200000000000; homeClubId = 5; awayClubId = 11; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 73; seasonId = 1; gameweek = 8; kickOff = 1720366200000000000; homeClubId = 6; awayClubId = 7; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 74; seasonId = 1; gameweek = 8; kickOff = 1720366200000000000; homeClubId = 8; awayClubId = 16; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 75; seasonId = 1; gameweek = 8; kickOff = 1720366200000000000; homeClubId = 9; awayClubId = 3; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 76; seasonId = 1; gameweek = 8; kickOff = 1720366200000000000; homeClubId = 10; awayClubId = 17; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 77; seasonId = 1; gameweek = 8; kickOff = 1720366200000000000; homeClubId = 12; awayClubId = 18; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 78; seasonId = 1; gameweek = 8; kickOff = 1720366200000000000; homeClubId = 14; awayClubId = 4; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 79; seasonId = 1; gameweek = 8; kickOff = 1720366200000000000; homeClubId = 19; awayClubId = 15; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 80; seasonId = 1; gameweek = 8; kickOff = 1720366200000000000; homeClubId = 20; awayClubId = 2; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 81; seasonId = 1; gameweek = 9; kickOff = 1720366200000000000; homeClubId = 3; awayClubId = 20; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 82; seasonId = 1; gameweek = 9; kickOff = 1720366200000000000; homeClubId = 2; awayClubId = 19; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 83; seasonId = 1; gameweek = 9; kickOff = 1720366200000000000; homeClubId = 4; awayClubId = 6; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 84; seasonId = 1; gameweek = 9; kickOff = 1720366200000000000; homeClubId = 7; awayClubId = 1; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 85; seasonId = 1; gameweek = 9; kickOff = 1720366200000000000; homeClubId = 11; awayClubId = 9; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 86; seasonId = 1; gameweek = 9; kickOff = 1720366200000000000; homeClubId = 13; awayClubId = 5; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 87; seasonId = 1; gameweek = 9; kickOff = 1720366200000000000; homeClubId = 15; awayClubId = 8; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 88; seasonId = 1; gameweek = 9; kickOff = 1720366200000000000; homeClubId = 16; awayClubId = 12; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 89; seasonId = 1; gameweek = 9; kickOff = 1720366200000000000; homeClubId = 17; awayClubId = 14; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 90; seasonId = 1; gameweek = 9; kickOff = 1720366200000000000; homeClubId = 18; awayClubId = 10; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 91; seasonId = 1; gameweek = 10; kickOff = 1720366200000000000; homeClubId = 3; awayClubId = 6; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 92; seasonId = 1; gameweek = 10; kickOff = 1720366200000000000; homeClubId = 1; awayClubId = 17; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 93; seasonId = 1; gameweek = 10; kickOff = 1720366200000000000; homeClubId = 2; awayClubId = 12; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 94; seasonId = 1; gameweek = 10; kickOff = 1720366200000000000; homeClubId = 5; awayClubId = 10; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 95; seasonId = 1; gameweek = 10; kickOff = 1720366200000000000; homeClubId = 7; awayClubId = 4; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 96; seasonId = 1; gameweek = 10; kickOff = 1720366200000000000; homeClubId = 8; awayClubId = 18; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 97; seasonId = 1; gameweek = 10; kickOff = 1720366200000000000; homeClubId = 11; awayClubId = 16; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 98; seasonId = 1; gameweek = 10; kickOff = 1720366200000000000; homeClubId = 14; awayClubId = 13; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 99; seasonId = 1; gameweek = 10; kickOff = 1720366200000000000; homeClubId = 19; awayClubId = 9; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 100; seasonId = 1; gameweek = 10; kickOff = 1720366200000000000; homeClubId = 20; awayClubId = 15; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 101; seasonId = 1; gameweek = 11; kickOff = 1720366200000000000; homeClubId = 4; awayClubId = 19; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 102; seasonId = 1; gameweek = 11; kickOff = 1720366200000000000; homeClubId = 6; awayClubId = 8; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 103; seasonId = 1; gameweek = 11; kickOff = 1720366200000000000; homeClubId = 9; awayClubId = 5; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 104; seasonId = 1; gameweek = 11; kickOff = 1720366200000000000; homeClubId = 10; awayClubId = 14; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 105; seasonId = 1; gameweek = 11; kickOff = 1720366200000000000; homeClubId = 12; awayClubId = 11; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 106; seasonId = 1; gameweek = 11; kickOff = 1720366200000000000; homeClubId = 13; awayClubId = 3; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 107; seasonId = 1; gameweek = 11; kickOff = 1720366200000000000; homeClubId = 15; awayClubId = 1; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 108; seasonId = 1; gameweek = 11; kickOff = 1720366200000000000; homeClubId = 16; awayClubId = 2; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 109; seasonId = 1; gameweek = 11; kickOff = 1720366200000000000; homeClubId = 17; awayClubId = 20; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 110; seasonId = 1; gameweek = 11; kickOff = 1720366200000000000; homeClubId = 18; awayClubId = 7; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 111; seasonId = 1; gameweek = 12; kickOff = 1720366200000000000; homeClubId = 3; awayClubId = 15; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 112; seasonId = 1; gameweek = 12; kickOff = 1720366200000000000; homeClubId = 1; awayClubId = 6; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 113; seasonId = 1; gameweek = 12; kickOff = 1720366200000000000; homeClubId = 2; awayClubId = 10; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 114; seasonId = 1; gameweek = 12; kickOff = 1720366200000000000; homeClubId = 5; awayClubId = 17; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 115; seasonId = 1; gameweek = 12; kickOff = 1720366200000000000; homeClubId = 7; awayClubId = 13; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 116; seasonId = 1; gameweek = 12; kickOff = 1720366200000000000; homeClubId = 8; awayClubId = 9; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 117; seasonId = 1; gameweek = 12; kickOff = 1720366200000000000; homeClubId = 11; awayClubId = 4; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 118; seasonId = 1; gameweek = 12; kickOff = 1720366200000000000; homeClubId = 14; awayClubId = 12; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 119; seasonId = 1; gameweek = 12; kickOff = 1720366200000000000; homeClubId = 19; awayClubId = 16; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 120; seasonId = 1; gameweek = 12; kickOff = 1720366200000000000; homeClubId = 20; awayClubId = 18; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 121; seasonId = 1; gameweek = 13; kickOff = 1720366200000000000; homeClubId = 4; awayClubId = 1; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 122; seasonId = 1; gameweek = 13; kickOff = 1720366200000000000; homeClubId = 6; awayClubId = 19; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 123; seasonId = 1; gameweek = 13; kickOff = 1720366200000000000; homeClubId = 9; awayClubId = 14; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 124; seasonId = 1; gameweek = 13; kickOff = 1720366200000000000; homeClubId = 10; awayClubId = 20; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 125; seasonId = 1; gameweek = 13; kickOff = 1720366200000000000; homeClubId = 12; awayClubId = 8; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 126; seasonId = 1; gameweek = 13; kickOff = 1720366200000000000; homeClubId = 13; awayClubId = 11; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 127; seasonId = 1; gameweek = 13; kickOff = 1720366200000000000; homeClubId = 15; awayClubId = 7; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 128; seasonId = 1; gameweek = 13; kickOff = 1720366200000000000; homeClubId = 16; awayClubId = 5; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 129; seasonId = 1; gameweek = 13; kickOff = 1720366200000000000; homeClubId = 17; awayClubId = 3; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 130; seasonId = 1; gameweek = 13; kickOff = 1720366200000000000; homeClubId = 18; awayClubId = 2; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 131; seasonId = 1; gameweek = 14; kickOff = 1720366200000000000; homeClubId = 3; awayClubId = 2; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 132; seasonId = 1; gameweek = 14; kickOff = 1720366200000000000; homeClubId = 1; awayClubId = 20; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 133; seasonId = 1; gameweek = 14; kickOff = 1720366200000000000; homeClubId = 4; awayClubId = 12; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 134; seasonId = 1; gameweek = 14; kickOff = 1720366200000000000; homeClubId = 6; awayClubId = 17; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 135; seasonId = 1; gameweek = 14; kickOff = 1720366200000000000; homeClubId = 7; awayClubId = 5; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 136; seasonId = 1; gameweek = 14; kickOff = 1720366200000000000; homeClubId = 11; awayClubId = 10; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 137; seasonId = 1; gameweek = 14; kickOff = 1720366200000000000; homeClubId = 13; awayClubId = 18; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 138; seasonId = 1; gameweek = 14; kickOff = 1720366200000000000; homeClubId = 15; awayClubId = 14; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 139; seasonId = 1; gameweek = 14; kickOff = 1720366200000000000; homeClubId = 16; awayClubId = 9; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 140; seasonId = 1; gameweek = 14; kickOff = 1720366200000000000; homeClubId = 19; awayClubId = 8; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 141; seasonId = 1; gameweek = 15; kickOff = 1720366200000000000; homeClubId = 2; awayClubId = 13; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 142; seasonId = 1; gameweek = 15; kickOff = 1720366200000000000; homeClubId = 5; awayClubId = 4; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 143; seasonId = 1; gameweek = 15; kickOff = 1720366200000000000; homeClubId = 9; awayClubId = 15; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 144; seasonId = 1; gameweek = 15; kickOff = 1720366200000000000; homeClubId = 10; awayClubId = 16; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 145; seasonId = 1; gameweek = 15; kickOff = 1720366200000000000; homeClubId = 12; awayClubId = 1; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 146; seasonId = 1; gameweek = 15; kickOff = 1720366200000000000; homeClubId = 17; awayClubId = 11; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 147; seasonId = 1; gameweek = 15; kickOff = 1720366200000000000; homeClubId = 18; awayClubId = 19; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 148; seasonId = 1; gameweek = 15; kickOff = 1720366200000000000; homeClubId = 20; awayClubId = 6; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 149; seasonId = 1; gameweek = 15; kickOff = 1720366200000000000; homeClubId = 8; awayClubId = 3; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 150; seasonId = 1; gameweek = 15; kickOff = 1720366200000000000; homeClubId = 14; awayClubId = 7; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 151; seasonId = 1; gameweek = 16; kickOff = 1720366200000000000; homeClubId = 2; awayClubId = 1; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 152; seasonId = 1; gameweek = 16; kickOff = 1720366200000000000; homeClubId = 5; awayClubId = 6; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 153; seasonId = 1; gameweek = 16; kickOff = 1720366200000000000; homeClubId = 8; awayClubId = 11; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 154; seasonId = 1; gameweek = 16; kickOff = 1720366200000000000; homeClubId = 9; awayClubId = 7; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 155; seasonId = 1; gameweek = 16; kickOff = 1720366200000000000; homeClubId = 10; awayClubId = 19; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 156; seasonId = 1; gameweek = 16; kickOff = 1720366200000000000; homeClubId = 12; awayClubId = 13; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 157; seasonId = 1; gameweek = 16; kickOff = 1720366200000000000; homeClubId = 14; awayClubId = 3; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 158; seasonId = 1; gameweek = 16; kickOff = 1720366200000000000; homeClubId = 17; awayClubId = 4; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 159; seasonId = 1; gameweek = 16; kickOff = 1720366200000000000; homeClubId = 18; awayClubId = 15; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 160; seasonId = 1; gameweek = 16; kickOff = 1720366200000000000; homeClubId = 20; awayClubId = 16; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 161; seasonId = 1; gameweek = 17; kickOff = 1720366200000000000; homeClubId = 3; awayClubId = 12; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 162; seasonId = 1; gameweek = 17; kickOff = 1720366200000000000; homeClubId = 1; awayClubId = 5; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 163; seasonId = 1; gameweek = 17; kickOff = 1720366200000000000; homeClubId = 4; awayClubId = 2; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 164; seasonId = 1; gameweek = 17; kickOff = 1720366200000000000; homeClubId = 6; awayClubId = 9; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 165; seasonId = 1; gameweek = 17; kickOff = 1720366200000000000; homeClubId = 7; awayClubId = 17; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 166; seasonId = 1; gameweek = 17; kickOff = 1720366200000000000; homeClubId = 11; awayClubId = 14; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 167; seasonId = 1; gameweek = 17; kickOff = 1720366200000000000; homeClubId = 13; awayClubId = 8; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 168; seasonId = 1; gameweek = 17; kickOff = 1720366200000000000; homeClubId = 15; awayClubId = 10; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 169; seasonId = 1; gameweek = 17; kickOff = 1720366200000000000; homeClubId = 16; awayClubId = 18; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 170; seasonId = 1; gameweek = 17; kickOff = 1720366200000000000; homeClubId = 19; awayClubId = 20; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 171; seasonId = 1; gameweek = 18; kickOff = 1720366200000000000; homeClubId = 2; awayClubId = 17; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 172; seasonId = 1; gameweek = 18; kickOff = 1720366200000000000; homeClubId = 8; awayClubId = 5; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 173; seasonId = 1; gameweek = 18; kickOff = 1720366200000000000; homeClubId = 10; awayClubId = 6; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 174; seasonId = 1; gameweek = 18; kickOff = 1720366200000000000; homeClubId = 11; awayClubId = 1; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 175; seasonId = 1; gameweek = 18; kickOff = 1720366200000000000; homeClubId = 12; awayClubId = 15; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 176; seasonId = 1; gameweek = 18; kickOff = 1720366200000000000; homeClubId = 13; awayClubId = 4; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 177; seasonId = 1; gameweek = 18; kickOff = 1720366200000000000; homeClubId = 16; awayClubId = 3; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 178; seasonId = 1; gameweek = 18; kickOff = 1720366200000000000; homeClubId = 18; awayClubId = 9; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 179; seasonId = 1; gameweek = 18; kickOff = 1720366200000000000; homeClubId = 19; awayClubId = 14; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 180; seasonId = 1; gameweek = 18; kickOff = 1720366200000000000; homeClubId = 20; awayClubId = 7; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 181; seasonId = 1; gameweek = 19; kickOff = 1720366200000000000; homeClubId = 3; awayClubId = 10; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 182; seasonId = 1; gameweek = 19; kickOff = 1720366200000000000; homeClubId = 1; awayClubId = 19; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 183; seasonId = 1; gameweek = 19; kickOff = 1720366200000000000; homeClubId = 4; awayClubId = 20; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 184; seasonId = 1; gameweek = 19; kickOff = 1720366200000000000; homeClubId = 5; awayClubId = 18; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 185; seasonId = 1; gameweek = 19; kickOff = 1720366200000000000; homeClubId = 6; awayClubId = 11; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 186; seasonId = 1; gameweek = 19; kickOff = 1720366200000000000; homeClubId = 7; awayClubId = 8; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 187; seasonId = 1; gameweek = 19; kickOff = 1720366200000000000; homeClubId = 9; awayClubId = 13; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 188; seasonId = 1; gameweek = 19; kickOff = 1720366200000000000; homeClubId = 14; awayClubId = 2; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 189; seasonId = 1; gameweek = 19; kickOff = 1720366200000000000; homeClubId = 15; awayClubId = 16; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 190; seasonId = 1; gameweek = 19; kickOff = 1720366200000000000; homeClubId = 17; awayClubId = 12; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 191; seasonId = 1; gameweek = 20; kickOff = 1720366200000000000; homeClubId = 2; awayClubId = 6; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 192; seasonId = 1; gameweek = 20; kickOff = 1720366200000000000; homeClubId = 8; awayClubId = 4; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 193; seasonId = 1; gameweek = 20; kickOff = 1720366200000000000; homeClubId = 10; awayClubId = 1; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 194; seasonId = 1; gameweek = 20; kickOff = 1720366200000000000; homeClubId = 11; awayClubId = 15; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 195; seasonId = 1; gameweek = 20; kickOff = 1720366200000000000; homeClubId = 12; awayClubId = 7; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 196; seasonId = 1; gameweek = 20; kickOff = 1720366200000000000; homeClubId = 13; awayClubId = 17; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 197; seasonId = 1; gameweek = 20; kickOff = 1720366200000000000; homeClubId = 16; awayClubId = 14; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 198; seasonId = 1; gameweek = 20; kickOff = 1720366200000000000; homeClubId = 18; awayClubId = 3; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 199; seasonId = 1; gameweek = 20; kickOff = 1720366200000000000; homeClubId = 19; awayClubId = 5; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 200; seasonId = 1; gameweek = 20; kickOff = 1720366200000000000; homeClubId = 20; awayClubId = 9; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 201; seasonId = 1; gameweek = 21; kickOff = 1720366200000000000; homeClubId = 3; awayClubId = 11; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 202; seasonId = 1; gameweek = 21; kickOff = 1720366200000000000; homeClubId = 1; awayClubId = 8; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 203; seasonId = 1; gameweek = 21; kickOff = 1720366200000000000; homeClubId = 4; awayClubId = 16; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 204; seasonId = 1; gameweek = 21; kickOff = 1720366200000000000; homeClubId = 5; awayClubId = 20; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 205; seasonId = 1; gameweek = 21; kickOff = 1720366200000000000; homeClubId = 6; awayClubId = 12; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 206; seasonId = 1; gameweek = 21; kickOff = 1720366200000000000; homeClubId = 7; awayClubId = 10; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 207; seasonId = 1; gameweek = 21; kickOff = 1720366200000000000; homeClubId = 9; awayClubId = 2; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 208; seasonId = 1; gameweek = 21; kickOff = 1720366200000000000; homeClubId = 14; awayClubId = 18; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 209; seasonId = 1; gameweek = 21; kickOff = 1720366200000000000; homeClubId = 15; awayClubId = 13; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 210; seasonId = 1; gameweek = 21; kickOff = 1720366200000000000; homeClubId = 17; awayClubId = 19; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 211; seasonId = 1; gameweek = 22; kickOff = 1720366200000000000; homeClubId = 2; awayClubId = 15; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 212; seasonId = 1; gameweek = 22; kickOff = 1720366200000000000; homeClubId = 10; awayClubId = 9; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 213; seasonId = 1; gameweek = 22; kickOff = 1720366200000000000; homeClubId = 12; awayClubId = 5; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 214; seasonId = 1; gameweek = 22; kickOff = 1720366200000000000; homeClubId = 16; awayClubId = 1; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 215; seasonId = 1; gameweek = 22; kickOff = 1720366200000000000; homeClubId = 18; awayClubId = 4; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 216; seasonId = 1; gameweek = 22; kickOff = 1720366200000000000; homeClubId = 19; awayClubId = 3; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 217; seasonId = 1; gameweek = 22; kickOff = 1720366200000000000; homeClubId = 20; awayClubId = 14; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 218; seasonId = 1; gameweek = 22; kickOff = 1720366200000000000; homeClubId = 8; awayClubId = 17; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 219; seasonId = 1; gameweek = 22; kickOff = 1720366200000000000; homeClubId = 11; awayClubId = 7; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 220; seasonId = 1; gameweek = 22; kickOff = 1720366200000000000; homeClubId = 13; awayClubId = 6; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 221; seasonId = 1; gameweek = 23; kickOff = 1720366200000000000; homeClubId = 3; awayClubId = 16; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 222; seasonId = 1; gameweek = 23; kickOff = 1720366200000000000; homeClubId = 1; awayClubId = 11; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 223; seasonId = 1; gameweek = 23; kickOff = 1720366200000000000; homeClubId = 4; awayClubId = 13; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 224; seasonId = 1; gameweek = 23; kickOff = 1720366200000000000; homeClubId = 5; awayClubId = 8; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 225; seasonId = 1; gameweek = 23; kickOff = 1720366200000000000; homeClubId = 6; awayClubId = 10; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 226; seasonId = 1; gameweek = 23; kickOff = 1720366200000000000; homeClubId = 7; awayClubId = 20; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 227; seasonId = 1; gameweek = 23; kickOff = 1720366200000000000; homeClubId = 9; awayClubId = 18; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 228; seasonId = 1; gameweek = 23; kickOff = 1720366200000000000; homeClubId = 14; awayClubId = 19; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 229; seasonId = 1; gameweek = 23; kickOff = 1720366200000000000; homeClubId = 15; awayClubId = 12; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 230; seasonId = 1; gameweek = 23; kickOff = 1720366200000000000; homeClubId = 17; awayClubId = 2; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 231; seasonId = 1; gameweek = 24; kickOff = 1720366200000000000; homeClubId = 2; awayClubId = 14; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 232; seasonId = 1; gameweek = 24; kickOff = 1720366200000000000; homeClubId = 8; awayClubId = 7; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 233; seasonId = 1; gameweek = 24; kickOff = 1720366200000000000; homeClubId = 10; awayClubId = 3; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 234; seasonId = 1; gameweek = 24; kickOff = 1720366200000000000; homeClubId = 11; awayClubId = 6; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 235; seasonId = 1; gameweek = 24; kickOff = 1720366200000000000; homeClubId = 12; awayClubId = 17; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 236; seasonId = 1; gameweek = 24; kickOff = 1720366200000000000; homeClubId = 13; awayClubId = 9; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 237; seasonId = 1; gameweek = 24; kickOff = 1720366200000000000; homeClubId = 16; awayClubId = 15; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 238; seasonId = 1; gameweek = 24; kickOff = 1720366200000000000; homeClubId = 18; awayClubId = 5; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 239; seasonId = 1; gameweek = 24; kickOff = 1720366200000000000; homeClubId = 19; awayClubId = 1; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 240; seasonId = 1; gameweek = 24; kickOff = 1720366200000000000; homeClubId = 20; awayClubId = 4; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 241; seasonId = 1; gameweek = 25; kickOff = 1720366200000000000; homeClubId = 4; awayClubId = 11; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 242; seasonId = 1; gameweek = 25; kickOff = 1720366200000000000; homeClubId = 6; awayClubId = 1; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 243; seasonId = 1; gameweek = 25; kickOff = 1720366200000000000; homeClubId = 9; awayClubId = 8; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 244; seasonId = 1; gameweek = 25; kickOff = 1720366200000000000; homeClubId = 10; awayClubId = 2; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 245; seasonId = 1; gameweek = 25; kickOff = 1720366200000000000; homeClubId = 12; awayClubId = 14; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 246; seasonId = 1; gameweek = 25; kickOff = 1720366200000000000; homeClubId = 13; awayClubId = 7; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 247; seasonId = 1; gameweek = 25; kickOff = 1720366200000000000; homeClubId = 15; awayClubId = 3; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 248; seasonId = 1; gameweek = 25; kickOff = 1720366200000000000; homeClubId = 16; awayClubId = 19; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 249; seasonId = 1; gameweek = 25; kickOff = 1720366200000000000; homeClubId = 17; awayClubId = 5; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 250; seasonId = 1; gameweek = 25; kickOff = 1720366200000000000; homeClubId = 18; awayClubId = 20; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 251; seasonId = 1; gameweek = 26; kickOff = 1720366200000000000; homeClubId = 3; awayClubId = 13; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 252; seasonId = 1; gameweek = 26; kickOff = 1720366200000000000; homeClubId = 1; awayClubId = 15; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 253; seasonId = 1; gameweek = 26; kickOff = 1720366200000000000; homeClubId = 2; awayClubId = 16; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 254; seasonId = 1; gameweek = 26; kickOff = 1720366200000000000; homeClubId = 5; awayClubId = 9; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 255; seasonId = 1; gameweek = 26; kickOff = 1720366200000000000; homeClubId = 7; awayClubId = 18; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 256; seasonId = 1; gameweek = 26; kickOff = 1720366200000000000; homeClubId = 8; awayClubId = 6; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 257; seasonId = 1; gameweek = 26; kickOff = 1720366200000000000; homeClubId = 11; awayClubId = 12; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 258; seasonId = 1; gameweek = 26; kickOff = 1720366200000000000; homeClubId = 14; awayClubId = 10; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 259; seasonId = 1; gameweek = 26; kickOff = 1720366200000000000; homeClubId = 19; awayClubId = 4; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 260; seasonId = 1; gameweek = 26; kickOff = 1720366200000000000; homeClubId = 20; awayClubId = 17; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 261; seasonId = 1; gameweek = 27; kickOff = 1720366200000000000; homeClubId = 4; awayClubId = 7; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 262; seasonId = 1; gameweek = 27; kickOff = 1720366200000000000; homeClubId = 6; awayClubId = 3; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 263; seasonId = 1; gameweek = 27; kickOff = 1720366200000000000; homeClubId = 9; awayClubId = 19; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 264; seasonId = 1; gameweek = 27; kickOff = 1720366200000000000; homeClubId = 10; awayClubId = 5; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 265; seasonId = 1; gameweek = 27; kickOff = 1720366200000000000; homeClubId = 12; awayClubId = 2; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 266; seasonId = 1; gameweek = 27; kickOff = 1720366200000000000; homeClubId = 13; awayClubId = 14; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 267; seasonId = 1; gameweek = 27; kickOff = 1720366200000000000; homeClubId = 15; awayClubId = 20; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 268; seasonId = 1; gameweek = 27; kickOff = 1720366200000000000; homeClubId = 16; awayClubId = 11; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 269; seasonId = 1; gameweek = 27; kickOff = 1720366200000000000; homeClubId = 17; awayClubId = 1; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 270; seasonId = 1; gameweek = 27; kickOff = 1720366200000000000; homeClubId = 18; awayClubId = 8; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 271; seasonId = 1; gameweek = 28; kickOff = 1720366200000000000; homeClubId = 3; awayClubId = 17; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 272; seasonId = 1; gameweek = 28; kickOff = 1720366200000000000; homeClubId = 1; awayClubId = 4; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 273; seasonId = 1; gameweek = 28; kickOff = 1720366200000000000; homeClubId = 2; awayClubId = 18; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 274; seasonId = 1; gameweek = 28; kickOff = 1720366200000000000; homeClubId = 5; awayClubId = 16; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 275; seasonId = 1; gameweek = 28; kickOff = 1720366200000000000; homeClubId = 7; awayClubId = 15; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 276; seasonId = 1; gameweek = 28; kickOff = 1720366200000000000; homeClubId = 8; awayClubId = 12; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 277; seasonId = 1; gameweek = 28; kickOff = 1720366200000000000; homeClubId = 11; awayClubId = 13; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 278; seasonId = 1; gameweek = 28; kickOff = 1720366200000000000; homeClubId = 14; awayClubId = 9; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 279; seasonId = 1; gameweek = 28; kickOff = 1720366200000000000; homeClubId = 19; awayClubId = 6; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 280; seasonId = 1; gameweek = 28; kickOff = 1720366200000000000; homeClubId = 20; awayClubId = 10; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 281; seasonId = 1; gameweek = 29; kickOff = 1720366200000000000; homeClubId = 1; awayClubId = 7; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 282; seasonId = 1; gameweek = 29; kickOff = 1720366200000000000; homeClubId = 5; awayClubId = 13; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 283; seasonId = 1; gameweek = 29; kickOff = 1720366200000000000; homeClubId = 6; awayClubId = 4; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 284; seasonId = 1; gameweek = 29; kickOff = 1720366200000000000; homeClubId = 8; awayClubId = 15; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 285; seasonId = 1; gameweek = 29; kickOff = 1720366200000000000; homeClubId = 9; awayClubId = 11; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 286; seasonId = 1; gameweek = 29; kickOff = 1720366200000000000; homeClubId = 10; awayClubId = 18; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 287; seasonId = 1; gameweek = 29; kickOff = 1720366200000000000; homeClubId = 12; awayClubId = 16; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 288; seasonId = 1; gameweek = 29; kickOff = 1720366200000000000; homeClubId = 14; awayClubId = 17; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 289; seasonId = 1; gameweek = 29; kickOff = 1720366200000000000; homeClubId = 19; awayClubId = 2; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 290; seasonId = 1; gameweek = 29; kickOff = 1720366200000000000; homeClubId = 20; awayClubId = 3; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 291; seasonId = 1; gameweek = 30; kickOff = 1720366200000000000; homeClubId = 3; awayClubId = 9; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 292; seasonId = 1; gameweek = 30; kickOff = 1720366200000000000; homeClubId = 2; awayClubId = 20; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 293; seasonId = 1; gameweek = 30; kickOff = 1720366200000000000; homeClubId = 4; awayClubId = 14; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 294; seasonId = 1; gameweek = 30; kickOff = 1720366200000000000; homeClubId = 7; awayClubId = 6; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 295; seasonId = 1; gameweek = 30; kickOff = 1720366200000000000; homeClubId = 11; awayClubId = 5; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 296; seasonId = 1; gameweek = 30; kickOff = 1720366200000000000; homeClubId = 13; awayClubId = 1; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 297; seasonId = 1; gameweek = 30; kickOff = 1720366200000000000; homeClubId = 15; awayClubId = 19; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 298; seasonId = 1; gameweek = 30; kickOff = 1720366200000000000; homeClubId = 16; awayClubId = 8; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 299; seasonId = 1; gameweek = 30; kickOff = 1720366200000000000; homeClubId = 17; awayClubId = 10; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 300; seasonId = 1; gameweek = 30; kickOff = 1720366200000000000; homeClubId = 18; awayClubId = 12; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 301; seasonId = 1; gameweek = 31; kickOff = 1720366200000000000; homeClubId = 3; awayClubId = 8; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 302; seasonId = 1; gameweek = 31; kickOff = 1720366200000000000; homeClubId = 1; awayClubId = 12; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 303; seasonId = 1; gameweek = 31; kickOff = 1720366200000000000; homeClubId = 4; awayClubId = 5; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 304; seasonId = 1; gameweek = 31; kickOff = 1720366200000000000; homeClubId = 6; awayClubId = 20; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 305; seasonId = 1; gameweek = 31; kickOff = 1720366200000000000; homeClubId = 16; awayClubId = 10; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 306; seasonId = 1; gameweek = 31; kickOff = 1720366200000000000; homeClubId = 19; awayClubId = 18; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 307; seasonId = 1; gameweek = 31; kickOff = 1720366200000000000; homeClubId = 7; awayClubId = 14; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 308; seasonId = 1; gameweek = 31; kickOff = 1720366200000000000; homeClubId = 15; awayClubId = 9; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 309; seasonId = 1; gameweek = 31; kickOff = 1720366200000000000; homeClubId = 11; awayClubId = 17; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 310; seasonId = 1; gameweek = 31; kickOff = 1720366200000000000; homeClubId = 13; awayClubId = 2; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 311; seasonId = 1; gameweek = 32; kickOff = 1720366200000000000; homeClubId = 2; awayClubId = 4; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 312; seasonId = 1; gameweek = 32; kickOff = 1720366200000000000; homeClubId = 5; awayClubId = 1; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 313; seasonId = 1; gameweek = 32; kickOff = 1720366200000000000; homeClubId = 8; awayClubId = 13; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 314; seasonId = 1; gameweek = 32; kickOff = 1720366200000000000; homeClubId = 9; awayClubId = 6; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 315; seasonId = 1; gameweek = 32; kickOff = 1720366200000000000; homeClubId = 10; awayClubId = 15; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 316; seasonId = 1; gameweek = 32; kickOff = 1720366200000000000; homeClubId = 12; awayClubId = 3; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 317; seasonId = 1; gameweek = 32; kickOff = 1720366200000000000; homeClubId = 14; awayClubId = 11; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 318; seasonId = 1; gameweek = 32; kickOff = 1720366200000000000; homeClubId = 17; awayClubId = 7; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 319; seasonId = 1; gameweek = 32; kickOff = 1720366200000000000; homeClubId = 18; awayClubId = 16; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 320; seasonId = 1; gameweek = 32; kickOff = 1720366200000000000; homeClubId = 20; awayClubId = 19; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 321; seasonId = 1; gameweek = 33; kickOff = 1720366200000000000; homeClubId = 3; awayClubId = 14; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 322; seasonId = 1; gameweek = 33; kickOff = 1720366200000000000; homeClubId = 1; awayClubId = 2; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 323; seasonId = 1; gameweek = 33; kickOff = 1720366200000000000; homeClubId = 4; awayClubId = 17; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 324; seasonId = 1; gameweek = 33; kickOff = 1720366200000000000; homeClubId = 6; awayClubId = 5; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 325; seasonId = 1; gameweek = 33; kickOff = 1720366200000000000; homeClubId = 7; awayClubId = 9; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 326; seasonId = 1; gameweek = 33; kickOff = 1720366200000000000; homeClubId = 11; awayClubId = 8; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 327; seasonId = 1; gameweek = 33; kickOff = 1720366200000000000; homeClubId = 13; awayClubId = 12; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 328; seasonId = 1; gameweek = 33; kickOff = 1720366200000000000; homeClubId = 15; awayClubId = 18; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 329; seasonId = 1; gameweek = 33; kickOff = 1720366200000000000; homeClubId = 16; awayClubId = 20; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 330; seasonId = 1; gameweek = 33; kickOff = 1720366200000000000; homeClubId = 19; awayClubId = 10; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 331; seasonId = 1; gameweek = 34; kickOff = 1720366200000000000; homeClubId = 2; awayClubId = 3; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 332; seasonId = 1; gameweek = 34; kickOff = 1720366200000000000; homeClubId = 5; awayClubId = 7; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 333; seasonId = 1; gameweek = 34; kickOff = 1720366200000000000; homeClubId = 8; awayClubId = 19; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 334; seasonId = 1; gameweek = 34; kickOff = 1720366200000000000; homeClubId = 9; awayClubId = 16; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 335; seasonId = 1; gameweek = 34; kickOff = 1720366200000000000; homeClubId = 10; awayClubId = 11; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 336; seasonId = 1; gameweek = 34; kickOff = 1720366200000000000; homeClubId = 12; awayClubId = 4; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 337; seasonId = 1; gameweek = 34; kickOff = 1720366200000000000; homeClubId = 14; awayClubId = 15; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 338; seasonId = 1; gameweek = 34; kickOff = 1720366200000000000; homeClubId = 17; awayClubId = 6; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 339; seasonId = 1; gameweek = 34; kickOff = 1720366200000000000; homeClubId = 18; awayClubId = 13; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 340; seasonId = 1; gameweek = 34; kickOff = 1720366200000000000; homeClubId = 20; awayClubId = 1; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 341; seasonId = 1; gameweek = 35; kickOff = 1720366200000000000; homeClubId = 3; awayClubId = 5; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 342; seasonId = 1; gameweek = 35; kickOff = 1720366200000000000; homeClubId = 2; awayClubId = 7; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 343; seasonId = 1; gameweek = 35; kickOff = 1720366200000000000; homeClubId = 4; awayClubId = 9; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 344; seasonId = 1; gameweek = 35; kickOff = 1720366200000000000; homeClubId = 10; awayClubId = 8; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 345; seasonId = 1; gameweek = 35; kickOff = 1720366200000000000; homeClubId = 14; awayClubId = 6; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 346; seasonId = 1; gameweek = 35; kickOff = 1720366200000000000; homeClubId = 15; awayClubId = 17; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 347; seasonId = 1; gameweek = 35; kickOff = 1720366200000000000; homeClubId = 16; awayClubId = 13; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 348; seasonId = 1; gameweek = 35; kickOff = 1720366200000000000; homeClubId = 18; awayClubId = 1; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 349; seasonId = 1; gameweek = 35; kickOff = 1720366200000000000; homeClubId = 19; awayClubId = 11; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 350; seasonId = 1; gameweek = 35; kickOff = 1720366200000000000; homeClubId = 20; awayClubId = 12; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 351; seasonId = 1; gameweek = 36; kickOff = 1720366200000000000; homeClubId = 1; awayClubId = 3; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 352; seasonId = 1; gameweek = 36; kickOff = 1720366200000000000; homeClubId = 4; awayClubId = 10; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 353; seasonId = 1; gameweek = 36; kickOff = 1720366200000000000; homeClubId = 5; awayClubId = 2; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 354; seasonId = 1; gameweek = 36; kickOff = 1720366200000000000; homeClubId = 6; awayClubId = 15; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 355; seasonId = 1; gameweek = 36; kickOff = 1720366200000000000; homeClubId = 7; awayClubId = 19; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 356; seasonId = 1; gameweek = 36; kickOff = 1720366200000000000; homeClubId = 8; awayClubId = 14; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 357; seasonId = 1; gameweek = 36; kickOff = 1720366200000000000; homeClubId = 11; awayClubId = 18; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 358; seasonId = 1; gameweek = 36; kickOff = 1720366200000000000; homeClubId = 12; awayClubId = 9; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 359; seasonId = 1; gameweek = 36; kickOff = 1720366200000000000; homeClubId = 13; awayClubId = 20; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 360; seasonId = 1; gameweek = 36; kickOff = 1720366200000000000; homeClubId = 17; awayClubId = 16; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 361; seasonId = 1; gameweek = 37; kickOff = 1720366200000000000; homeClubId = 3; awayClubId = 4; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 362; seasonId = 1; gameweek = 37; kickOff = 1720366200000000000; homeClubId = 2; awayClubId = 11; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 363; seasonId = 1; gameweek = 37; kickOff = 1720366200000000000; homeClubId = 9; awayClubId = 17; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 364; seasonId = 1; gameweek = 37; kickOff = 1720366200000000000; homeClubId = 10; awayClubId = 13; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 365; seasonId = 1; gameweek = 37; kickOff = 1720366200000000000; homeClubId = 14; awayClubId = 1; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 366; seasonId = 1; gameweek = 37; kickOff = 1720366200000000000; homeClubId = 15; awayClubId = 5; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 367; seasonId = 1; gameweek = 37; kickOff = 1720366200000000000; homeClubId = 16; awayClubId = 7; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 368; seasonId = 1; gameweek = 37; kickOff = 1720366200000000000; homeClubId = 18; awayClubId = 6; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 369; seasonId = 1; gameweek = 37; kickOff = 1720366200000000000; homeClubId = 19; awayClubId = 12; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 370; seasonId = 1; gameweek = 37; kickOff = 1720366200000000000; homeClubId = 20; awayClubId = 8; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 371; seasonId = 1; gameweek = 38; kickOff = 1720366200000000000; homeClubId = 1; awayClubId = 9; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 372; seasonId = 1; gameweek = 38; kickOff = 1720366200000000000; homeClubId = 4; awayClubId = 15; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 373; seasonId = 1; gameweek = 38; kickOff = 1720366200000000000; homeClubId = 5; awayClubId = 14; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 374; seasonId = 1; gameweek = 38; kickOff = 1720366200000000000; homeClubId = 6; awayClubId = 16; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 375; seasonId = 1; gameweek = 38; kickOff = 1720366200000000000; homeClubId = 7; awayClubId = 3; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 376; seasonId = 1; gameweek = 38; kickOff = 1720366200000000000; homeClubId = 8; awayClubId = 2; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 377; seasonId = 1; gameweek = 38; kickOff = 1720366200000000000; homeClubId = 11; awayClubId = 20; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 378; seasonId = 1; gameweek = 38; kickOff = 1720366200000000000; homeClubId = 12; awayClubId = 10; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 379; seasonId = 1; gameweek = 38; kickOff = 1720366200000000000; homeClubId = 13; awayClubId = 19; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; },
          { id = 380; seasonId = 1; gameweek = 38; kickOff = 1720366200000000000; homeClubId = 17; awayClubId = 18; homeGoals = 0; awayGoals = 0; status = #Unplayed; events = List.nil<T.PlayerEventData>(); highestScoringPlayerId = 0; }
        ]);
        id = 1;
        name = "2024/25";
        postponedFixtures = List.nil();
        year = 2024

      }]);
    };

  };
};
