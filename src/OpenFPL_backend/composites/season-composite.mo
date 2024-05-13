import T "../types";
import DTOs "../DTOs";
import List "mo:base/List";
import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";
import Time "mo:base/Time";
import Array "mo:base/Array";
import Nat8 "mo:base/Nat8";
import Nat16 "mo:base/Nat16";
import Int16 "mo:base/Int16";
import Text "mo:base/Text";
import Char "mo:base/Char";
import TrieMap "mo:base/TrieMap";
import Bool "mo:base/Bool";
import Order "mo:base/Order";
import Utilities "../utils/utilities";

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

      var homeGoalsCount : Nat8 = 0;
      var awayGoalsCount : Nat8 = 0;

      let playerEventsMap : TrieMap.TrieMap<T.PlayerId, [T.PlayerEventData]> = TrieMap.TrieMap<T.PlayerId, [T.PlayerEventData]>(Utilities.eqNat16, Utilities.hashNat16);

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
              return fixture.status == #Complete;
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

    public func init() {
      seasons := List.fromArray<T.Season>([{
        id = 1;
        name = "2024/25";
        year = 2024;
        fixtures = List.nil();
        postponedFixtures = List.nil();
      }]);
    };
  };
};
