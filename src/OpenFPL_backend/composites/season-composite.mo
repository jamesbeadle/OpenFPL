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
import Nat64 "mo:base/Nat64";
import Int64 "mo:base/Int64";
import Nat32 "mo:base/Nat32";

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

    public func setInitialSeason(){
        seasons := List.fromArray<T.Season>([{
          id=1;
          name="2024/25";
          year=2024; 
          postponedFixtures = List.nil();
          fixtures = List.fromArray<T.Fixture>([
            { id = 1; homeClubId = 1; awayClubId = 11; gameweek = 1; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 2; homeClubId = 2; awayClubId = 12; gameweek = 1; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 3; homeClubId = 3; awayClubId = 13; gameweek = 1; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 4; homeClubId = 4; awayClubId = 14; gameweek = 1; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 5; homeClubId = 5; awayClubId = 15; gameweek = 1; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 6; homeClubId = 6; awayClubId = 16; gameweek = 1; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 7; homeClubId = 7; awayClubId = 17; gameweek = 1; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 8; homeClubId = 8; awayClubId = 18; gameweek = 1; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 9; homeClubId = 9; awayClubId = 19; gameweek = 1; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 10; homeClubId = 10; awayClubId = 20; gameweek = 1; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 11; homeClubId = 1; awayClubId = 12; gameweek = 2; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 12; homeClubId = 2; awayClubId = 13; gameweek = 2; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 13; homeClubId = 3; awayClubId = 14; gameweek = 2; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 14; homeClubId = 4; awayClubId = 15; gameweek = 2; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 15; homeClubId = 5; awayClubId = 16; gameweek = 2; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 16; homeClubId = 6; awayClubId = 17; gameweek = 2; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 17; homeClubId = 7; awayClubId = 18; gameweek = 2; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 18; homeClubId = 8; awayClubId = 19; gameweek = 2; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 19; homeClubId = 9; awayClubId = 20; gameweek = 2; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 20; homeClubId = 10; awayClubId = 11; gameweek = 2; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 21; homeClubId = 1; awayClubId = 13; gameweek = 3; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 22; homeClubId = 2; awayClubId = 14; gameweek = 3; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 23; homeClubId = 3; awayClubId = 15; gameweek = 3; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 24; homeClubId = 4; awayClubId = 16; gameweek = 3; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 25; homeClubId = 5; awayClubId = 17; gameweek = 3; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 26; homeClubId = 6; awayClubId = 18; gameweek = 3; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 27; homeClubId = 7; awayClubId = 19; gameweek = 3; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 28; homeClubId = 8; awayClubId = 20; gameweek = 3; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 29; homeClubId = 9; awayClubId = 11; gameweek = 3; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 30; homeClubId = 10; awayClubId = 12; gameweek = 3; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 31; homeClubId = 1; awayClubId = 14; gameweek = 4; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 32; homeClubId = 2; awayClubId = 15; gameweek = 4; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 33; homeClubId = 3; awayClubId = 16; gameweek = 4; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 34; homeClubId = 4; awayClubId = 17; gameweek = 4; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 35; homeClubId = 5; awayClubId = 18; gameweek = 4; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 36; homeClubId = 6; awayClubId = 19; gameweek = 4; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 37; homeClubId = 7; awayClubId = 20; gameweek = 4; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 38; homeClubId = 8; awayClubId = 11; gameweek = 4; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 39; homeClubId = 9; awayClubId = 12; gameweek = 4; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 40; homeClubId = 10; awayClubId = 13; gameweek = 4; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 41; homeClubId = 1; awayClubId = 15; gameweek = 5; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 42; homeClubId = 2; awayClubId = 16; gameweek = 5; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 43; homeClubId = 3; awayClubId = 17; gameweek = 5; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 44; homeClubId = 4; awayClubId = 18; gameweek = 5; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 45; homeClubId = 5; awayClubId = 19; gameweek = 5; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 46; homeClubId = 6; awayClubId = 20; gameweek = 5; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 47; homeClubId = 7; awayClubId = 11; gameweek = 5; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 48; homeClubId = 8; awayClubId = 12; gameweek = 5; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 49; homeClubId = 9; awayClubId = 13; gameweek = 5; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 50; homeClubId = 10; awayClubId = 14; gameweek = 5; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 51; homeClubId = 1; awayClubId = 16; gameweek = 6; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 52; homeClubId = 2; awayClubId = 17; gameweek = 6; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 53; homeClubId = 3; awayClubId = 18; gameweek = 6; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 54; homeClubId = 4; awayClubId = 19; gameweek = 6; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 55; homeClubId = 5; awayClubId = 20; gameweek = 6; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 56; homeClubId = 6; awayClubId = 11; gameweek = 6; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 57; homeClubId = 7; awayClubId = 12; gameweek = 6; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 58; homeClubId = 8; awayClubId = 13; gameweek = 6; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 59; homeClubId = 9; awayClubId = 14; gameweek = 6; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 60; homeClubId = 10; awayClubId = 15; gameweek = 6; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 61; homeClubId = 1; awayClubId = 17; gameweek = 7; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 62; homeClubId = 2; awayClubId = 18; gameweek = 7; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 63; homeClubId = 3; awayClubId = 19; gameweek = 7; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 64; homeClubId = 4; awayClubId = 20; gameweek = 7; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 65; homeClubId = 5; awayClubId = 11; gameweek = 7; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 66; homeClubId = 6; awayClubId = 12; gameweek = 7; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 67; homeClubId = 7; awayClubId = 13; gameweek = 7; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 68; homeClubId = 8; awayClubId = 14; gameweek = 7; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 69; homeClubId = 9; awayClubId = 15; gameweek = 7; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 70; homeClubId = 10; awayClubId = 16; gameweek = 7; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 71; homeClubId = 1; awayClubId = 18; gameweek = 8; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 72; homeClubId = 2; awayClubId = 19; gameweek = 8; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 73; homeClubId = 3; awayClubId = 20; gameweek = 8; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 74; homeClubId = 4; awayClubId = 11; gameweek = 8; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 75; homeClubId = 5; awayClubId = 12; gameweek = 8; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 76; homeClubId = 6; awayClubId = 13; gameweek = 8; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 77; homeClubId = 7; awayClubId = 14; gameweek = 8; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 78; homeClubId = 8; awayClubId = 15; gameweek = 8; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 79; homeClubId = 9; awayClubId = 16; gameweek = 8; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 80; homeClubId = 10; awayClubId = 17; gameweek = 8; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 81; homeClubId = 1; awayClubId = 19; gameweek = 9; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 82; homeClubId = 2; awayClubId = 20; gameweek = 9; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 83; homeClubId = 3; awayClubId = 11; gameweek = 9; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 84; homeClubId = 4; awayClubId = 12; gameweek = 9; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 85; homeClubId = 5; awayClubId = 13; gameweek = 9; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 86; homeClubId = 6; awayClubId = 14; gameweek = 9; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 87; homeClubId = 7; awayClubId = 15; gameweek = 9; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 88; homeClubId = 8; awayClubId = 16; gameweek = 9; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 89; homeClubId = 9; awayClubId = 17; gameweek = 9; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 90; homeClubId = 10; awayClubId = 18; gameweek = 9; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 91; homeClubId = 1; awayClubId = 20; gameweek = 10; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 92; homeClubId = 2; awayClubId = 11; gameweek = 10; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 93; homeClubId = 3; awayClubId = 12; gameweek = 10; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 94; homeClubId = 4; awayClubId = 13; gameweek = 10; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 95; homeClubId = 5; awayClubId = 14; gameweek = 10; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 96; homeClubId = 6; awayClubId = 15; gameweek = 10; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 97; homeClubId = 7; awayClubId = 16; gameweek = 10; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 98; homeClubId = 8; awayClubId = 17; gameweek = 10; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 99; homeClubId = 9; awayClubId = 18; gameweek = 10; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 100; homeClubId = 10; awayClubId = 19; gameweek = 10; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 101; homeClubId = 1; awayClubId = 2; gameweek = 11; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 102; homeClubId = 2; awayClubId = 3; gameweek = 11; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 103; homeClubId = 3; awayClubId = 4; gameweek = 11; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 104; homeClubId = 4; awayClubId = 5; gameweek = 11; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 105; homeClubId = 5; awayClubId = 6; gameweek = 11; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 106; homeClubId = 6; awayClubId = 7; gameweek = 11; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 107; homeClubId = 7; awayClubId = 8; gameweek = 11; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 108; homeClubId = 8; awayClubId = 9; gameweek = 11; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 109; homeClubId = 9; awayClubId = 10; gameweek = 11; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 110; homeClubId = 10; awayClubId = 1; gameweek = 11; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 111; homeClubId = 1; awayClubId = 3; gameweek = 12; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 112; homeClubId = 2; awayClubId = 4; gameweek = 12; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 113; homeClubId = 3; awayClubId = 5; gameweek = 12; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 114; homeClubId = 4; awayClubId = 6; gameweek = 12; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 115; homeClubId = 5; awayClubId = 7; gameweek = 12; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 116; homeClubId = 6; awayClubId = 8; gameweek = 12; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 117; homeClubId = 7; awayClubId = 9; gameweek = 12; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 118; homeClubId = 8; awayClubId = 10; gameweek = 12; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 119; homeClubId = 9; awayClubId = 1; gameweek = 12; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 120; homeClubId = 10; awayClubId = 2; gameweek = 12; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 121; homeClubId = 1; awayClubId = 4; gameweek = 13; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 122; homeClubId = 2; awayClubId = 5; gameweek = 13; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 123; homeClubId = 3; awayClubId = 6; gameweek = 13; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 124; homeClubId = 4; awayClubId = 7; gameweek = 13; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 125; homeClubId = 5; awayClubId = 8; gameweek = 13; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 126; homeClubId = 6; awayClubId = 9; gameweek = 13; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 127; homeClubId = 7; awayClubId = 10; gameweek = 13; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 128; homeClubId = 8; awayClubId = 1; gameweek = 13; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 129; homeClubId = 9; awayClubId = 2; gameweek = 13; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 130; homeClubId = 10; awayClubId = 3; gameweek = 13; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 131; homeClubId = 1; awayClubId = 5; gameweek = 14; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 132; homeClubId = 2; awayClubId = 6; gameweek = 14; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 133; homeClubId = 3; awayClubId = 7; gameweek = 14; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 134; homeClubId = 4; awayClubId = 8; gameweek = 14; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 135; homeClubId = 5; awayClubId = 9; gameweek = 14; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 136; homeClubId = 6; awayClubId = 10; gameweek = 14; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 137; homeClubId = 7; awayClubId = 1; gameweek = 14; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 138; homeClubId = 8; awayClubId = 2; gameweek = 14; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 139; homeClubId = 9; awayClubId = 3; gameweek = 14; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 140; homeClubId = 10; awayClubId = 4; gameweek = 14; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 141; homeClubId = 1; awayClubId = 6; gameweek = 15; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 142; homeClubId = 2; awayClubId = 7; gameweek = 15; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 143; homeClubId = 3; awayClubId = 8; gameweek = 15; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 144; homeClubId = 4; awayClubId = 9; gameweek = 15; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 145; homeClubId = 5; awayClubId = 10; gameweek = 15; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 146; homeClubId = 6; awayClubId = 1; gameweek = 15; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 147; homeClubId = 7; awayClubId = 2; gameweek = 15; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 148; homeClubId = 8; awayClubId = 3; gameweek = 15; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 149; homeClubId = 9; awayClubId = 4; gameweek = 15; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 150; homeClubId = 10; awayClubId = 5; gameweek = 15; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 151; homeClubId = 1; awayClubId = 7; gameweek = 16; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 152; homeClubId = 2; awayClubId = 8; gameweek = 16; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 153; homeClubId = 3; awayClubId = 9; gameweek = 16; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 154; homeClubId = 4; awayClubId = 10; gameweek = 16; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 155; homeClubId = 5; awayClubId = 1; gameweek = 16; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 156; homeClubId = 6; awayClubId = 2; gameweek = 16; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 157; homeClubId = 7; awayClubId = 3; gameweek = 16; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 158; homeClubId = 8; awayClubId = 4; gameweek = 16; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 159; homeClubId = 9; awayClubId = 5; gameweek = 16; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 160; homeClubId = 10; awayClubId = 6; gameweek = 16; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 161; homeClubId = 1; awayClubId = 8; gameweek = 17; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 162; homeClubId = 2; awayClubId = 9; gameweek = 17; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 163; homeClubId = 3; awayClubId = 10; gameweek = 17; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 164; homeClubId = 4; awayClubId = 1; gameweek = 17; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 165; homeClubId = 5; awayClubId = 2; gameweek = 17; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 166; homeClubId = 6; awayClubId = 3; gameweek = 17; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 167; homeClubId = 7; awayClubId = 4; gameweek = 17; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 168; homeClubId = 8; awayClubId = 5; gameweek = 17; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 169; homeClubId = 9; awayClubId = 6; gameweek = 17; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 170; homeClubId = 10; awayClubId = 7; gameweek = 17; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 171; homeClubId = 1; awayClubId = 9; gameweek = 18; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 172; homeClubId = 2; awayClubId = 10; gameweek = 18; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 173; homeClubId = 3; awayClubId = 1; gameweek = 18; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 174; homeClubId = 4; awayClubId = 2; gameweek = 18; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 175; homeClubId = 5; awayClubId = 3; gameweek = 18; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 176; homeClubId = 6; awayClubId = 4; gameweek = 18; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 177; homeClubId = 7; awayClubId = 5; gameweek = 18; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 178; homeClubId = 8; awayClubId = 6; gameweek = 18; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 179; homeClubId = 9; awayClubId = 7; gameweek = 18; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 180; homeClubId = 10; awayClubId = 8; gameweek = 18; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 181; homeClubId = 1; awayClubId = 10; gameweek = 19; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 182; homeClubId = 2; awayClubId = 1; gameweek = 19; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 183; homeClubId = 3; awayClubId = 2; gameweek = 19; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 184; homeClubId = 4; awayClubId = 3; gameweek = 19; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 185; homeClubId = 5; awayClubId = 4; gameweek = 19; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 186; homeClubId = 6; awayClubId = 5; gameweek = 19; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 187; homeClubId = 7; awayClubId = 6; gameweek = 19; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 188; homeClubId = 8; awayClubId = 7; gameweek = 19; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 189; homeClubId = 9; awayClubId = 8; gameweek = 19; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 190; homeClubId = 10; awayClubId = 9; gameweek = 19; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 191; homeClubId = 11; awayClubId = 1; gameweek = 20; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 192; homeClubId = 12; awayClubId = 2; gameweek = 20; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 193; homeClubId = 13; awayClubId = 3; gameweek = 20; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 194; homeClubId = 14; awayClubId = 4; gameweek = 20; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 195; homeClubId = 15; awayClubId = 5; gameweek = 20; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 196; homeClubId = 16; awayClubId = 6; gameweek = 20; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 197; homeClubId = 17; awayClubId = 7; gameweek = 20; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 198; homeClubId = 18; awayClubId = 8; gameweek = 20; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 199; homeClubId = 19; awayClubId = 9; gameweek = 20; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 200; homeClubId = 20; awayClubId = 10; gameweek = 20; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 201; homeClubId = 11; awayClubId = 2; gameweek = 21; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 202; homeClubId = 12; awayClubId = 3; gameweek = 21; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 203; homeClubId = 13; awayClubId = 4; gameweek = 21; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 204; homeClubId = 14; awayClubId = 5; gameweek = 21; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 205; homeClubId = 15; awayClubId = 6; gameweek = 21; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 206; homeClubId = 16; awayClubId = 7; gameweek = 21; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 207; homeClubId = 17; awayClubId = 8; gameweek = 21; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 208; homeClubId = 18; awayClubId = 9; gameweek = 21; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 209; homeClubId = 19; awayClubId = 10; gameweek = 21; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 210; homeClubId = 20; awayClubId = 1; gameweek = 21; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 211; homeClubId = 11; awayClubId = 3; gameweek = 22; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 212; homeClubId = 12; awayClubId = 4; gameweek = 22; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 213; homeClubId = 13; awayClubId = 5; gameweek = 22; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 214; homeClubId = 14; awayClubId = 6; gameweek = 22; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 215; homeClubId = 15; awayClubId = 7; gameweek = 22; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 216; homeClubId = 16; awayClubId = 8; gameweek = 22; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 217; homeClubId = 17; awayClubId = 9; gameweek = 22; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 218; homeClubId = 18; awayClubId = 10; gameweek = 22; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 219; homeClubId = 19; awayClubId = 1; gameweek = 22; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 220; homeClubId = 20; awayClubId = 2; gameweek = 22; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 221; homeClubId = 11; awayClubId = 4; gameweek = 23; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 222; homeClubId = 12; awayClubId = 5; gameweek = 23; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 223; homeClubId = 13; awayClubId = 6; gameweek = 23; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 224; homeClubId = 14; awayClubId = 7; gameweek = 23; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 225; homeClubId = 15; awayClubId = 8; gameweek = 23; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 226; homeClubId = 16; awayClubId = 9; gameweek = 23; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 227; homeClubId = 17; awayClubId = 10; gameweek = 23; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 228; homeClubId = 18; awayClubId = 1; gameweek = 23; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 229; homeClubId = 19; awayClubId = 2; gameweek = 23; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 230; homeClubId = 20; awayClubId = 3; gameweek = 23; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 231; homeClubId = 11; awayClubId = 5; gameweek = 24; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 232; homeClubId = 12; awayClubId = 6; gameweek = 24; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 233; homeClubId = 13; awayClubId = 7; gameweek = 24; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 234; homeClubId = 14; awayClubId = 8; gameweek = 24; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 235; homeClubId = 15; awayClubId = 9; gameweek = 24; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 236; homeClubId = 16; awayClubId = 10; gameweek = 24; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 237; homeClubId = 17; awayClubId = 1; gameweek = 24; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 238; homeClubId = 18; awayClubId = 2; gameweek = 24; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 239; homeClubId = 19; awayClubId = 3; gameweek = 24; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 240; homeClubId = 20; awayClubId = 4; gameweek = 24; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 241; homeClubId = 11; awayClubId = 6; gameweek = 25; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 242; homeClubId = 12; awayClubId = 7; gameweek = 25; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 243; homeClubId = 13; awayClubId = 8; gameweek = 25; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 244; homeClubId = 14; awayClubId = 9; gameweek = 25; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 245; homeClubId = 15; awayClubId = 10; gameweek = 25; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 246; homeClubId = 16; awayClubId = 1; gameweek = 25; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 247; homeClubId = 17; awayClubId = 2; gameweek = 25; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 248; homeClubId = 18; awayClubId = 3; gameweek = 25; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 249; homeClubId = 19; awayClubId = 4; gameweek = 25; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 250; homeClubId = 20; awayClubId = 5; gameweek = 25; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 251; homeClubId = 11; awayClubId = 7; gameweek = 26; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 252; homeClubId = 12; awayClubId = 8; gameweek = 26; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 253; homeClubId = 13; awayClubId = 9; gameweek = 26; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 254; homeClubId = 14; awayClubId = 10; gameweek = 26; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 255; homeClubId = 15; awayClubId = 1; gameweek = 26; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 256; homeClubId = 16; awayClubId = 2; gameweek = 26; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 257; homeClubId = 17; awayClubId = 3; gameweek = 26; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 258; homeClubId = 18; awayClubId = 4; gameweek = 26; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 259; homeClubId = 19; awayClubId = 5; gameweek = 26; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 260; homeClubId = 20; awayClubId = 6; gameweek = 26; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 261; homeClubId = 11; awayClubId = 8; gameweek = 27; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 262; homeClubId = 12; awayClubId = 9; gameweek = 27; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 263; homeClubId = 13; awayClubId = 10; gameweek = 27; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 264; homeClubId = 14; awayClubId = 1; gameweek = 27; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 265; homeClubId = 15; awayClubId = 2; gameweek = 27; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 266; homeClubId = 16; awayClubId = 3; gameweek = 27; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 267; homeClubId = 17; awayClubId = 4; gameweek = 27; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 268; homeClubId = 18; awayClubId = 5; gameweek = 27; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 269; homeClubId = 19; awayClubId = 6; gameweek = 27; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 270; homeClubId = 20; awayClubId = 7; gameweek = 27; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 271; homeClubId = 11; awayClubId = 9; gameweek = 28; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 272; homeClubId = 12; awayClubId = 10; gameweek = 28; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 273; homeClubId = 13; awayClubId = 1; gameweek = 28; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 274; homeClubId = 14; awayClubId = 2; gameweek = 28; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 275; homeClubId = 15; awayClubId = 3; gameweek = 28; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 276; homeClubId = 16; awayClubId = 4; gameweek = 28; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 277; homeClubId = 17; awayClubId = 5; gameweek = 28; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 278; homeClubId = 18; awayClubId = 6; gameweek = 28; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 279; homeClubId = 19; awayClubId = 7; gameweek = 28; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 280; homeClubId = 20; awayClubId = 8; gameweek = 28; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 281; homeClubId = 11; awayClubId = 10; gameweek = 29; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 282; homeClubId = 12; awayClubId = 1; gameweek = 29; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 283; homeClubId = 13; awayClubId = 2; gameweek = 29; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 284; homeClubId = 14; awayClubId = 3; gameweek = 29; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 285; homeClubId = 15; awayClubId = 4; gameweek = 29; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 286; homeClubId = 16; awayClubId = 5; gameweek = 29; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 287; homeClubId = 17; awayClubId = 6; gameweek = 29; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 288; homeClubId = 18; awayClubId = 7; gameweek = 29; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 289; homeClubId = 19; awayClubId = 8; gameweek = 29; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 290; homeClubId = 20; awayClubId = 9; gameweek = 29; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 291; homeClubId = 11; awayClubId = 12; gameweek = 30; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 292; homeClubId = 12; awayClubId = 13; gameweek = 30; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 293; homeClubId = 13; awayClubId = 14; gameweek = 30; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 294; homeClubId = 14; awayClubId = 15; gameweek = 30; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 295; homeClubId = 15; awayClubId = 16; gameweek = 30; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 296; homeClubId = 16; awayClubId = 17; gameweek = 30; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 297; homeClubId = 17; awayClubId = 18; gameweek = 30; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 298; homeClubId = 18; awayClubId = 19; gameweek = 30; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 299; homeClubId = 19; awayClubId = 20; gameweek = 30; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 300; homeClubId = 20; awayClubId = 11; gameweek = 30; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 301; homeClubId = 11; awayClubId = 13; gameweek = 31; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 302; homeClubId = 12; awayClubId = 14; gameweek = 31; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 303; homeClubId = 13; awayClubId = 15; gameweek = 31; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 304; homeClubId = 14; awayClubId = 16; gameweek = 31; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 305; homeClubId = 15; awayClubId = 17; gameweek = 31; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 306; homeClubId = 16; awayClubId = 18; gameweek = 31; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 307; homeClubId = 17; awayClubId = 19; gameweek = 31; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 308; homeClubId = 18; awayClubId = 20; gameweek = 31; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 309; homeClubId = 19; awayClubId = 11; gameweek = 31; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 310; homeClubId = 20; awayClubId = 12; gameweek = 31; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 311; homeClubId = 11; awayClubId = 14; gameweek = 32; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 312; homeClubId = 12; awayClubId = 15; gameweek = 32; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 313; homeClubId = 13; awayClubId = 16; gameweek = 32; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 314; homeClubId = 14; awayClubId = 17; gameweek = 32; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 315; homeClubId = 15; awayClubId = 18; gameweek = 32; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 316; homeClubId = 16; awayClubId = 19; gameweek = 32; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 317; homeClubId = 17; awayClubId = 20; gameweek = 32; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 318; homeClubId = 18; awayClubId = 11; gameweek = 32; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 319; homeClubId = 19; awayClubId = 12; gameweek = 32; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 320; homeClubId = 20; awayClubId = 13; gameweek = 32; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 321; homeClubId = 11; awayClubId = 15; gameweek = 33; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 322; homeClubId = 12; awayClubId = 16; gameweek = 33; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 323; homeClubId = 13; awayClubId = 17; gameweek = 33; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 324; homeClubId = 14; awayClubId = 18; gameweek = 33; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 325; homeClubId = 15; awayClubId = 19; gameweek = 33; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 326; homeClubId = 16; awayClubId = 20; gameweek = 33; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 327; homeClubId = 17; awayClubId = 11; gameweek = 33; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 328; homeClubId = 18; awayClubId = 12; gameweek = 33; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 329; homeClubId = 19; awayClubId = 13; gameweek = 33; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 330; homeClubId = 20; awayClubId = 14; gameweek = 33; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 331; homeClubId = 11; awayClubId = 16; gameweek = 34; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 332; homeClubId = 12; awayClubId = 17; gameweek = 34; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 333; homeClubId = 13; awayClubId = 18; gameweek = 34; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 334; homeClubId = 14; awayClubId = 19; gameweek = 34; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 335; homeClubId = 15; awayClubId = 20; gameweek = 34; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 336; homeClubId = 16; awayClubId = 11; gameweek = 34; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 337; homeClubId = 17; awayClubId = 12; gameweek = 34; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 338; homeClubId = 18; awayClubId = 13; gameweek = 34; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 339; homeClubId = 19; awayClubId = 14; gameweek = 34; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 340; homeClubId = 20; awayClubId = 15; gameweek = 34; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 341; homeClubId = 11; awayClubId = 17; gameweek = 35; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 342; homeClubId = 12; awayClubId = 18; gameweek = 35; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 343; homeClubId = 13; awayClubId = 19; gameweek = 35; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 344; homeClubId = 14; awayClubId = 20; gameweek = 35; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 345; homeClubId = 15; awayClubId = 11; gameweek = 35; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 346; homeClubId = 16; awayClubId = 12; gameweek = 35; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 347; homeClubId = 17; awayClubId = 13; gameweek = 35; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 348; homeClubId = 18; awayClubId = 14; gameweek = 35; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 349; homeClubId = 19; awayClubId = 15; gameweek = 35; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 350; homeClubId = 20; awayClubId = 16; gameweek = 35; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 351; homeClubId = 11; awayClubId = 18; gameweek = 36; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 352; homeClubId = 12; awayClubId = 19; gameweek = 36; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 353; homeClubId = 13; awayClubId = 20; gameweek = 36; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 354; homeClubId = 14; awayClubId = 11; gameweek = 36; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 355; homeClubId = 15; awayClubId = 12; gameweek = 36; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 356; homeClubId = 16; awayClubId = 13; gameweek = 36; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 357; homeClubId = 17; awayClubId = 14; gameweek = 36; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 358; homeClubId = 18; awayClubId = 15; gameweek = 36; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 359; homeClubId = 19; awayClubId = 16; gameweek = 36; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 360; homeClubId = 20; awayClubId = 17; gameweek = 36; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 361; homeClubId = 11; awayClubId = 19; gameweek = 37; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 362; homeClubId = 12; awayClubId = 20; gameweek = 37; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 363; homeClubId = 13; awayClubId = 11; gameweek = 37; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 364; homeClubId = 14; awayClubId = 12; gameweek = 37; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 365; homeClubId = 15; awayClubId = 13; gameweek = 37; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 366; homeClubId = 16; awayClubId = 14; gameweek = 37; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 367; homeClubId = 17; awayClubId = 15; gameweek = 37; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 368; homeClubId = 18; awayClubId = 16; gameweek = 37; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 369; homeClubId = 19; awayClubId = 17; gameweek = 37; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 370; homeClubId = 20; awayClubId = 18; gameweek = 37; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 371; homeClubId = 11; awayClubId = 20; gameweek = 38; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 372; homeClubId = 12; awayClubId = 11; gameweek = 38; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 373; homeClubId = 13; awayClubId = 12; gameweek = 38; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 374; homeClubId = 14; awayClubId = 13; gameweek = 38; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 375; homeClubId = 15; awayClubId = 14; gameweek = 38; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 376; homeClubId = 16; awayClubId = 15; gameweek = 38; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 377; homeClubId = 17; awayClubId = 16; gameweek = 38; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 378; homeClubId = 18; awayClubId = 17; gameweek = 38; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 379; homeClubId = 19; awayClubId = 18; gameweek = 38; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); },
{ id = 380; homeClubId = 20; awayClubId = 19; gameweek = 38; seasonId = 1; kickOff = 0; homeGoals = 0; awayGoals = 0; status = #Unplayed; highestScoringPlayerId = 0; events = List.nil(); }
          ]);
        }]);
    };
  };
};
