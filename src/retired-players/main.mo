import T "../OpenFPL_backend/types";
import DTOs "../OpenFPL_backend/DTOs";
import List "mo:base/List";
import Principal "mo:base/Principal";
import Nat8 "mo:base/Nat8";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Nat16 "mo:base/Nat16";
import Array "mo:base/Array";
import HashMap "mo:base/HashMap";
import Hash "mo:base/Hash";
import Nat32 "mo:base/Nat32";
import Iter "mo:base/Iter";
import Buffer "mo:base/Buffer";
import Int16 "mo:base/Int16";
import Utilities "../OpenFPL_backend/utilities";
import Timer "mo:base/Timer";
import Time "mo:base/Time";
import Debug "mo:base/Debug";
import Nat64 "mo:base/Nat64";
import Text "mo:base/Text";
import Bool "mo:base/Bool";
import SHA224 "../OpenFPL_backend/SHA224";

actor Self {

  private var retiredPlayers = List.fromArray<T.Player>([]);
  private var formerPlayers = List.fromArray<T.Player>([]);
  public shared query ({ caller }) func getPlayers() : async [DTOs.PlayerDTO] {

    func compare(player1 : T.Player, player2 : T.Player) : Bool {
      return player1.value >= player2.value;
    };

    func mergeSort(entries : List.List<T.Player>) : List.List<T.Player> {
      let len = List.size(entries);

      if (len <= 1) {
        return entries;
      } else {
        let (firstHalf, secondHalf) = List.split(len / 2, entries);
        return List.merge(mergeSort(firstHalf), mergeSort(secondHalf), compare);
      };
    };

    let sortedPlayers = mergeSort(players);

    return Array.map<T.Player, DTOs.PlayerDTO>(
      List.toArray(sortedPlayers),
      func(player : T.Player) : DTOs.PlayerDTO {
        return {
          id = player.id;
          firstName = player.firstName;
          lastName = player.lastName;
          teamId = player.teamId;
          position = player.position;
          shirtNumber = player.shirtNumber;
          value = player.value;
          dateOfBirth = player.dateOfBirth;
          nationality = player.nationality;
          totalPoints = 0;
        };
      },
    );
  };

  public shared query ({ caller }) func getActivePlayers() : async [DTOs.PlayerDTO] {

    func compare(player1 : T.Player, player2 : T.Player) : Bool {
      return player1.value >= player2.value;
    };

    func mergeSort(entries : List.List<T.Player>) : List.List<T.Player> {
      let len = List.size(entries);

      if (len <= 1) {
        return entries;
      } else {
        let (firstHalf, secondHalf) = List.split(len / 2, entries);
        return List.merge(mergeSort(firstHalf), mergeSort(secondHalf), compare);
      };
    };

    let nonLoanPlayers = List.filter<T.Player>(
      players,
      func(player : T.Player) : Bool {
        return player.onLoan == false;
      },
    );

    let sortedPlayers = mergeSort(nonLoanPlayers);

    let filteredPlayers = List.filter<T.Player>(
      sortedPlayers,
      func(player : T.Player) : Bool {
        return player.teamId > 0;
      },
    );

    return Array.map<T.Player, DTOs.PlayerDTO>(
      List.toArray(filteredPlayers),
      func(player : T.Player) : DTOs.PlayerDTO {
        return {
          id = player.id;
          firstName = player.firstName;
          lastName = player.lastName;
          teamId = player.teamId;
          position = player.position;
          shirtNumber = player.shirtNumber;
          value = player.value;
          dateOfBirth = player.dateOfBirth;
          nationality = player.nationality;
          totalPoints = 0;
        };
      },
    );
  };

  public shared query ({ caller }) func getPlayerDetailsForGameweek(seasonId : Nat16, gameweek : Nat8) : async [DTOs.PlayerPointsDTO] {

    var playerDetailsBuffer = Buffer.fromArray<DTOs.PlayerPointsDTO>([]);

    label playerDetailsLoop for (player in Iter.fromList(players)) {
      var points : Int16 = 0;
      var events : List.List<T.PlayerEventData> = List.nil();

      for (season in Iter.fromList(player.seasons)) {
        if (season.id == seasonId) {
          for (gw in Iter.fromList(season.gameweeks)) {

            if (gw.number == gameweek) {
              points := gw.points;
              events := List.filter<T.PlayerEventData>(
                gw.events,
                func(event : T.PlayerEventData) : Bool {
                  return event.playerId == player.id;
                },
              );
            };
          };
        };
      };

      let playerGameweek : DTOs.PlayerPointsDTO = {
        id = player.id;
        points = points;
        teamId = player.teamId;
        position = player.position;
        events = List.toArray(events);
        gameweek = gameweek;
      };
      playerDetailsBuffer.add(playerGameweek);
    };

    return Buffer.toArray(playerDetailsBuffer);
  };

  public shared query ({ caller }) func getPlayersDetailsForGameweek(playerIds : [T.PlayerId], seasonId : Nat16, gameweek : Nat8) : async [DTOs.PlayerPointsDTO] {
    var playerDetailsBuffer = Buffer.fromArray<DTOs.PlayerPointsDTO>([]);

    label playerDetailsLoop for (player in Iter.fromList(players)) {
      if (Array.find<T.PlayerId>(playerIds, func(id) { id == player.id }) == null or player.onLoan) {
        continue playerDetailsLoop;
      };

      var points : Int16 = 0;
      var events : List.List<T.PlayerEventData> = List.nil();

      for (season in Iter.fromList(player.seasons)) {
        if (season.id == seasonId) {
          for (gw in Iter.fromList(season.gameweeks)) {

            if (gw.number == gameweek) {
              points := gw.points;
              events := List.filter<T.PlayerEventData>(
                gw.events,
                func(event : T.PlayerEventData) : Bool {
                  return event.playerId == player.id;
                },
              );
            };
          };
        };
      };

      let playerGameweek : DTOs.PlayerPointsDTO = {
        id = player.id;
        points = points;
        teamId = player.teamId;
        position = player.position;
        events = List.toArray(events);
        gameweek = gameweek;
      };
      playerDetailsBuffer.add(playerGameweek);
    };

    return Buffer.toArray(playerDetailsBuffer);
  };

  public query ({ caller }) func getPlayersMap(seasonId : Nat16, gameweek : Nat8) : async [(Nat16, DTOs.PlayerScoreDTO)] {
    var playersMap : HashMap.HashMap<Nat16, DTOs.PlayerScoreDTO> = HashMap.HashMap<Nat16, DTOs.PlayerScoreDTO>(500, Utilities.eqNat16, Utilities.hashNat16);
    label playerMapLoop for (player in Iter.fromList(players)) {
      if (player.onLoan) {
        continue playerMapLoop;
      };

      var points : Int16 = 0;
      var events : List.List<T.PlayerEventData> = List.nil();
      var goalsScored : Int16 = 0;
      var goalsConceded : Int16 = 0;
      var saves : Int16 = 0;
      var assists : Int16 = 0;
      var dateOfBirth : Int = player.dateOfBirth;

      for (season in Iter.fromList(player.seasons)) {
        if (season.id == seasonId) {
          for (gw in Iter.fromList(season.gameweeks)) {

            if (gw.number == gameweek) {
              points := gw.points;
              events := gw.events;

              for (event in Iter.fromList(gw.events)) {
                switch (event.eventType) {
                  case (1) { goalsScored += 1 };
                  case (2) { assists += 1 };
                  case (3) { goalsConceded += 1 };
                  case (4) { saves += 1 };
                  case _ {};
                };
              };
            };
          };
        };
      };

      let scoreDTO : DTOs.PlayerScoreDTO = {
        id = player.id;
        points = points;
        events = events;
        teamId = player.teamId;
        position = player.position;
        goalsScored = goalsScored;
        goalsConceded = goalsConceded;
        saves = saves;
        assists = assists;
        dateOfBirth = dateOfBirth;
        nationality = player.nationality;
      };
      playersMap.put(player.id, scoreDTO);
    };
    return Iter.toArray(playersMap.entries());
  };

  public shared query ({ caller }) func getPlayer(playerId : Nat16) : async T.Player {
    let foundPlayer = List.find<T.Player>(
      players,
      func(player : T.Player) : Bool {
        return player.id == playerId and not player.onLoan;
      },
    );

    switch (foundPlayer) {
      case (null) {
        return {
          id = 0;
          teamId = 0;
          position = 0;
          firstName = "";
          lastName = "";
          shirtNumber = 0;
          value = 0;
          dateOfBirth = 0;
          nationality = 0;
          seasons = List.nil<T.PlayerSeason>();
          valueHistory = List.nil<T.ValueHistory>();
          onLoan = false;
          parentclubId = 0;
          isInjured = false;
          injuryHistory = List.nil<T.InjuryHistory>();
          retirementDate = 0;
          transferHistory = List.nil<T.TransferHistory>();
        };
      };
      case (?player) { return player };
    };
  };

  public shared query ({ caller }) func getPlayerDetails(playerId : Nat16, seasonId : T.SeasonId) : async DTOs.PlayerDetailDTO {

    var teamId : T.ClubId = 0;
    var position : Nat8 = 0;
    var firstName = "";
    var lastName = "";
    var shirtNumber : Nat8 = 0;
    var value : Nat = 0;
    var dateOfBirth : Int = 0;
    var nationality : T.CountryId = 0;
    var valueHistory : [T.ValueHistory] = [];
    var onLoan = false;
    var parentClubId : T.ClubId = 0;
    var isInjured = false;
    var injuryHistory : [T.InjuryHistory] = [];
    var retirementDate : Int = 0;

    let gameweeksBuffer = Buffer.fromArray<DTOs.PlayerGameweekDTO>([]);

    let foundPlayer = List.find<T.Player>(
      players,
      func(player : T.Player) : Bool {
        return player.id == playerId and not player.onLoan;
      },
    );

    switch (foundPlayer) {
      case (null) {};
      case (?player) {
        teamId := player.teamId;
        position := player.position;
        firstName := player.firstName;
        lastName := player.lastName;
        shirtNumber := player.shirtNumber;
        value := player.value;
        dateOfBirth := player.dateOfBirth;
        nationality := player.nationality;
        valueHistory := List.toArray<T.ValueHistory>(player.valueHistory);
        onLoan := player.onLoan;
        parentClubId := player.parentClubId;
        isInjured := player.isInjured;
        injuryHistory := List.toArray<T.InjuryHistory>(player.injuryHistory);
        retirementDate := player.retirementDate;

        let currentSeason = List.find<T.PlayerSeason>(player.seasons, func(ps : T.PlayerSeason) { ps.id == seasonId });
        switch (currentSeason) {
          case (null) {};
          case (?season) {
            for (gw in Iter.fromList(season.gameweeks)) {

              var fixtureId : T.FixtureId = 0;
              let events = List.toArray<T.PlayerEventData>(gw.events);
              if (Array.size(events) > 0) {
                fixtureId := events[0].fixtureId;
              };

              let gameweekDTO : DTOs.PlayerGameweekDTO = {
                number = gw.number;
                events = List.toArray<T.PlayerEventData>(gw.events);
                points = gw.points;
                fixtureId = fixtureId;
              };

              gameweeksBuffer.add(gameweekDTO);
            };
          };
        };

      };
    };

    return {
      id = playerId;
      teamId = teamId;
      position = position;
      firstName = firstName;
      lastName = lastName;
      shirtNumber = shirtNumber;
      value = value;
      dateOfBirth = dateOfBirth;
      nationality = nationality;
      seasonId = seasonId;
      valueHistory = valueHistory;
      onLoan = onLoan;
      parentClubId = parentClubId;
      isInjured = isInjured;
      injuryHistory = injuryHistory;
      retirementDate = retirementDate;
      gameweeks = Buffer.toArray<DTOs.PlayerGameweekDTO>(gameweeksBuffer);
    };
  };

  public shared func revaluePlayerUp(playerId : T.PlayerId, activeSeasonId : T.SeasonId, activeGameweek : T.GameweekNumber) : async () {
    var updatedPlayers = List.map<T.Player, T.Player>(
      players,
      func(p : T.Player) : T.Player {
        if (p.id == playerId) {
          var newValue = p.value;
          newValue += 1;

          let historyEntry : T.ValueHistory = {
            seasonId = activeSeasonId;
            gameweek = activeGameweek;
            oldValue = p.value;
            newValue = newValue;
          };

          let updatedPlayer : T.Player = {
            id = p.id;
            teamId = p.teamId;
            position = p.position;
            firstName = p.firstName;
            lastName = p.lastName;
            shirtNumber = p.shirtNumber;
            value = newValue;
            dateOfBirth = p.dateOfBirth;
            nationality = p.nationality;
            seasons = p.seasons;
            valueHistory = List.append<T.ValueHistory>(p.valueHistory, List.make(historyEntry));
            onLoan = p.onLoan;
            parentClubId = p.parentClubId;
            isInjured = p.isInjured;
            injuryHistory = p.injuryHistory;
            retirementDate = p.retirementDate;
            transferHistory = p.transferHistory;
          };

          return updatedPlayer;
        };
        return p;
      },
    );

    players := updatedPlayers;
  };

  public shared func revaluePlayerDown(playerId : T.PlayerId, activeSeasonId : T.SeasonId, activeGameweek : T.GameweekNumber) {
    var updatedPlayers = List.map<T.Player, T.Player>(
      players,
      func(p : T.Player) : T.Player {
        if (p.id == playerId) {
          var newValue = p.value;
          if (newValue >= 1) {
            newValue -= 1;
          };

          let historyEntry : T.ValueHistory = {
            seasonId = activeSeasonId;
            gameweek = activeGameweek;
            oldValue = p.value;
            newValue = newValue;
          };

          let updatedPlayer : T.Player = {
            id = p.id;
            teamId = p.teamId;
            position = p.position;
            firstName = p.firstName;
            lastName = p.lastName;
            shirtNumber = p.shirtNumber;
            value = newValue;
            dateOfBirth = p.dateOfBirth;
            nationality = p.nationality;
            seasons = p.seasons;
            valueHistory = List.append<T.ValueHistory>(p.valueHistory, List.make(historyEntry));
            onLoan = p.onLoan;
            parentClubId = p.parentClubId;
            isInjured = p.isInjured;
            injuryHistory = p.injuryHistory;
            retirementDate = p.retirementDate;
            transferHistory = p.transferHistory;
          };

          return updatedPlayer;
        };
        return p;
      },
    );

    players := updatedPlayers;
  };

  public shared ({ caller }) func calculatePlayerScores(seasonId : Nat16, gameweek : Nat8, fixture : T.Fixture) : async T.Fixture {
    var homeGoalsCount : Nat8 = 0;
    var awayGoalsCount : Nat8 = 0;

    let playerEventsMap : HashMap.HashMap<Nat16, [T.PlayerEventData]> = HashMap.HashMap<Nat16, [T.PlayerEventData]>(200, Utilities.eqNat16, Utilities.hashNat16);

    for (event in Iter.fromList(fixture.events)) {

      switch (event.eventType) {
        case 1 {
          if (event.teamId == fixture.homeClubId) {
            homeGoalsCount += 1;
          } else if (event.teamId == fixture.awayClubId) {
            awayGoalsCount += 1;
          };
        };
        case 10 {
          if (event.teamId == fixture.homeClubId) {
            awayGoalsCount += 1;
          } else if (event.teamId == fixture.awayClubId) {
            homeGoalsCount += 1;
          };
        };
        case _ {};
      };

      let playerId : Nat16 = event.playerId;
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
      var currentPlayer = await getPlayer(playerId);

      let totalScore = Array.foldLeft<T.PlayerEventData, Int16>(
        events,
        0,
        func(acc : Int16, event : T.PlayerEventData) : Int16 {
          return acc + calculateIndividualScoreForEvent(event, currentPlayer.position);
        },
      );

      let aggregateScore = calculateAggregatePlayerEvents(events, currentPlayer.position);
      playerScoresMap.put(playerId, totalScore + aggregateScore);
    };

    for ((playerId, score) in playerScoresMap.entries()) {

      let player = await getPlayer(playerId);
      var updatedSeasons : List.List<T.PlayerSeason> = List.nil<T.PlayerSeason>();
      let playerSpecificEvents = playerEventsMap.get(playerId);
      switch (playerSpecificEvents) {
        case (null) {};
        case (?foundEvents) {
          if (player.seasons == null) {
            let newGameweek : T.PlayerGameweek = {
              number = gameweek;
              events = List.fromArray<T.PlayerEventData>(foundEvents);
              points = score;
            };
            let newSeason : T.PlayerSeason = {
              id = seasonId;
              gameweeks = List.fromArray<T.PlayerGameweek>([newGameweek]);
            };
            updatedSeasons := List.fromArray<T.PlayerSeason>([newSeason]);
          } else {
            let currentSeason = List.find<T.PlayerSeason>(
              player.seasons,
              func(s : T.PlayerSeason) : Bool {
                s.id == seasonId;
              },
            );

            if (currentSeason == null) {
              let newGameweek : T.PlayerGameweek = {
                number = gameweek;
                events = List.fromArray<T.PlayerEventData>(foundEvents);
                points = score;
              };
              let newSeason : T.PlayerSeason = {
                id = seasonId;
                gameweeks = List.fromArray<T.PlayerGameweek>([newGameweek]);
              };
              updatedSeasons := List.append<T.PlayerSeason>(player.seasons, List.fromArray<T.PlayerSeason>([newSeason]));

            } else {
              updatedSeasons := List.map<T.PlayerSeason, T.PlayerSeason>(
                player.seasons,
                func(season : T.PlayerSeason) : T.PlayerSeason {

                  if (season.id != seasonId) {
                    return season;
                  };

                  let currentGameweek = List.find<T.PlayerGameweek>(
                    season.gameweeks,
                    func(gw : T.PlayerGameweek) : Bool {
                      gw.number == gameweek;
                    },
                  );

                  if (currentGameweek == null) {
                    let newGameweek : T.PlayerGameweek = {
                      number = gameweek;
                      events = List.fromArray<T.PlayerEventData>(foundEvents);
                      points = score;
                    };
                    let updatedGameweeks = List.append<T.PlayerGameweek>(season.gameweeks, List.fromArray<T.PlayerGameweek>([newGameweek]));
                    let updatedSeason : T.PlayerSeason = {
                      id = season.id;
                      gameweeks = List.append<T.PlayerGameweek>(season.gameweeks, List.fromArray<T.PlayerGameweek>([newGameweek]));
                    };
                    return updatedSeason;
                  } else {
                    let updatedGameweeks = List.map<T.PlayerGameweek, T.PlayerGameweek>(
                      season.gameweeks,
                      func(gw : T.PlayerGameweek) : T.PlayerGameweek {
                        if (gw.number != gameweek) {
                          return gw;
                        };
                        return {
                          number = gw.number;
                          events = List.append<T.PlayerEventData>(gw.events, List.fromArray(foundEvents));
                          points = score;
                        };
                      },
                    );
                    return {
                      id = season.id;
                      gameweeks = updatedGameweeks;
                    };
                  };
                },
              );
            };
          };
        };
      };

      let updatedPlayer = {
        id = player.id;
        teamId = player.teamId;
        position = player.position;
        firstName = player.firstName;
        lastName = player.lastName;
        shirtNumber = player.shirtNumber;
        value = player.value;
        dateOfBirth = player.dateOfBirth;
        nationality = player.nationality;
        seasons = updatedSeasons;
        valueHistory = player.valueHistory;
        onLoan = player.onLoan;
        parentClubId = player.parentClubId;
        isInjured = player.isInjured;
        injuryHistory = player.injuryHistory;
        retirementDate = player.retirementDate;
        transferHistory = player.transferHistory;
      };

      players := List.map<T.Player, T.Player>(
        players,
        func(p : T.Player) : T.Player {
          if (p.id == updatedPlayer.id) { updatedPlayer } else { p };
        },
      );
    };

    var highestScore : Int16 = 0;
    var highestScoringPlayerId : Nat16 = 0;
    var isUniqueHighScore : Bool = true;
    let uniquePlayerIdsBuffer = Buffer.fromArray<Nat16>([]);

    for (event in List.toIter(fixture.events)) {
      if (not Buffer.contains<Nat16>(uniquePlayerIdsBuffer, event.playerId, func(a : Nat16, b : Nat16) : Bool { a == b })) {
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

    var newHighScoringPlayerId : Nat16 = 0;
    if (isUniqueHighScore) {
      newHighScoringPlayerId := highestScoringPlayerId;
    };
    let updatedFixture = {
      id = fixture.id;
      seasonId = fixture.seasonId;
      gameweek = fixture.gameweek;
      homeClubId = fixture.homeClubId;
      awayClubId = fixture.awayClubId;
      kickOff = fixture.kickOff;
      homeGoals = homeGoalsCount;
      awayGoals = awayGoalsCount;
      status = fixture.status;
      events = fixture.events;
      highestScoringPlayerId = newHighScoringPlayerId;
    };

    //add the highest scoring player id to the player canister players events

    let highestScoringPlayer = await getPlayer(newHighScoringPlayerId);
    players := List.map<T.Player, T.Player>(
      players,
      func(p : T.Player) : T.Player {
        if (p.id == newHighScoringPlayerId) {

          let updatedSeasons = List.map<T.PlayerSeason, T.PlayerSeason>(
            p.seasons,
            func(s : T.PlayerSeason) : T.PlayerSeason {

              if (s.id == seasonId) {
                return {
                  id = s.id;
                  gameweeks = List.map<T.PlayerGameweek, T.PlayerGameweek>(
                    s.gameweeks,
                    func(playerGameweek : T.PlayerGameweek) : T.PlayerGameweek {

                      let newEvent : T.PlayerEventData = {
                        fixtureId = fixture.id;
                        playerId = newHighScoringPlayerId;
                        eventType = 11;
                        eventStartMinute = 90;
                        eventEndMinute = 90;
                        teamId = highestScoringPlayer.teamId;
                      };

                      let updatedEvents : List.List<T.PlayerEventData> = List.append(playerGameweek.events, List.fromArray([newEvent]));

                      if (playerGameweek.number == gameweek) {
                        return {
                          number = playerGameweek.number;
                          events = updatedEvents;
                          points = playerGameweek.points + 25;
                        };
                      } else { return playerGameweek };
                    },
                  );
                };
              } else { return s };
            },
          );

          let adjustedPlayer : T.Player = {
            id = p.id;
            teamId = p.teamId;
            position = p.position;
            firstName = p.firstName;
            lastName = p.lastName;
            shirtNumber = p.shirtNumber;
            value = p.value;
            dateOfBirth = p.dateOfBirth;
            nationality = p.nationality;
            seasons = updatedSeasons;
            valueHistory = p.valueHistory;
            onLoan = p.onLoan;
            parentClubId = p.parentClubId;
            isInjured = p.isInjured;
            injuryHistory = p.injuryHistory;
            retirementDate = p.retirementDate;
            transferHistory = p.transferHistory;
          };

        } else { return p };
      },
    );

    await updateHashForCategory("players");
    await updateHashForCategory("playerEventData");
    return updatedFixture;
  };

  func calculateAggregatePlayerEvents(events : [T.PlayerEventData], playerPosition : Nat8) : Int16 {
    var totalScore : Int16 = 0;

    if (playerPosition == 0 or playerPosition == 1) {
      let goalsConcededCount = Array.filter<T.PlayerEventData>(
        events,
        func(event : T.PlayerEventData) : Bool { event.eventType == 3 },
      ).size();

      if (goalsConcededCount >= 2) {

        totalScore += (Int16.fromNat16(Nat16.fromNat(goalsConcededCount)) / 2) * -15;
      };
    };

    if (playerPosition == 0) {
      let savesCount = Array.filter<T.PlayerEventData>(
        events,
        func(event : T.PlayerEventData) : Bool { event.eventType == 4 },
      ).size();

      totalScore += (Int16.fromNat16(Nat16.fromNat(savesCount)) / 3) * 5;
    };

    return totalScore;
  };

  func calculateIndividualScoreForEvent(event : T.PlayerEventData, playerPosition : Nat8) : Int16 {
    switch (event.eventType) {
      case 0 { return 5 }; // Appearing in the game
      case 1 {
        switch (playerPosition) {
          case 3 { return 10 };
          case 2 { return 15 };
          case _ { return 20 }; // Goalkeeper or defender
        };
      };
      case 2 {
        switch (playerPosition) {
          case 3 { return 10 };
          case 2 { return 10 };
          case _ { return 15 }; // Goalkeeper or defender
        };
      };
      case 4 { return 0 };
      case 5 {
        switch (playerPosition) {
          case 0 { return 10 };
          case 1 { return 10 };
          case _ { return 0 };
        };
      };
      case 6 { return 20 }; // Goalkeeper saves a penalty
      case 7 { return -15 }; // Player misses a penalty
      case 8 { return -5 }; // Yellow Card
      case 9 { return -20 }; // Red Card
      case 10 { return -10 }; // Own Goal
      case 11 { return 0 }; // Handled after all players calculated
      case _ { return 0 };
    };
  };

  public shared func transferPlayer(playerId : T.PlayerId, newClubId : T.ClubId, currentSeasonId : T.SeasonId, currentGameweek : T.GameweekNumber) : async () {
    let player = List.find<T.Player>(players, func(p : T.Player) { p.id == playerId });
    switch (player) {
      case (null) {};
      case (?p) {

        let newTransferHistoryEntry : T.TransferHistory = {
          transferDate = Time.now();
          transferGameweek = currentGameweek;
          transferSeason = currentSeasonId;
          fromTeam = p.teamId;
          toTeam = newClubId;
          loanEndDate = 0;
        };

        let updatedPlayer : T.Player = {
          id = p.id;
          teamId = newClubId;
          position = p.position;
          firstName = p.firstName;
          lastName = p.lastName;
          shirtNumber = p.shirtNumber;
          value = p.value;
          dateOfBirth = p.dateOfBirth;
          nationality = p.nationality;
          seasons = p.seasons;
          valueHistory = p.valueHistory;
          onLoan = p.onLoan;
          parentClubId = p.parentClubId;
          isInjured = p.isInjured;
          injuryHistory = p.injuryHistory;
          retirementDate = p.retirementDate;
          transferHistory = List.append<T.TransferHistory>(p.transferHistory, List.fromArray([newTransferHistoryEntry]));
        };
        players := List.map<T.Player, T.Player>(
          players,
          func(currentPlayer : T.Player) : T.Player {
            if (currentPlayer.id == updatedPlayer.id) {
              return updatedPlayer;
            } else {
              return currentPlayer;
            };
          },
        );
      };
    };
  };

  public shared func loanPlayer(playerId : T.PlayerId, loanClubId : T.ClubId, loanEndDate : Int, currentSeasonId : T.SeasonId, currentGameweek : T.GameweekNumber) : async () {
    let playerToLoan = List.find<T.Player>(players, func(p : T.Player) { p.id == playerId });
    switch (playerToLoan) {
      case (null) {};
      case (?p) {

        let newTransferHistoryEntry : T.TransferHistory = {
          transferDate = Time.now();
          transferGameweek = currentGameweek;
          transferSeason = currentSeasonId;
          fromTeam = p.clubId;
          toTeam = loanClubId;
          loanEndDate = loanEndDate;
        };

        let loanedPlayer : T.Player = {
          id = p.id;
          teamId = loanClubId;
          position = p.position;
          firstName = p.firstName;
          lastName = p.lastName;
          shirtNumber = p.shirtNumber;
          value = p.value;
          dateOfBirth = p.dateOfBirth;
          nationality = p.nationality;
          seasons = p.seasons;
          valueHistory = p.valueHistory;
          onLoan = true;
          parentClubId = p.clubId;
          isInjured = p.isInjured;
          injuryHistory = p.injuryHistory;
          retirementDate = p.retirementDate;
          transferHistory = List.append<T.TransferHistory>(p.transferHistory, List.fromArray([newTransferHistoryEntry]));
        };

        players := List.map<T.Player, T.Player>(
          players,
          func(currentPlayer : T.Player) : T.Player {
            if (currentPlayer.id == loanedPlayer.id) {
              return loanedPlayer;
            } else {
              return currentPlayer;
            };
          },
        );

        let loanTimerDuration = #nanoseconds(Int.abs((loanEndDate - Time.now())));
        await setAndBackupTimer(loanTimerDuration, "loanExpired", playerId);
      };
    };
  };

  private func setAndBackupTimer(duration : Timer.Duration, callbackName : Text, playerId : T.PlayerId) : async () {
    let jobId : Timer.TimerId = switch (callbackName) {
      case "loanExpired" {
        Timer.setTimer(duration, loanExpiredCallback);
      };
      case _ {
        Timer.setTimer(duration, defaultCallback);
      };
    };

    let triggerTime = switch (duration) {
      case (#seconds s) {
        Time.now() + s * 1_000_000_000;
      };
      case (#nanoseconds ns) {
        Time.now() + ns;
      };
    };

    let timerInfo : T.TimerInfo = {
      id = jobId;
      triggerTime = triggerTime;
      callbackName = callbackName;
      playerId = playerId;
      fixtureId = 0;
    };

    var timerBuffer = Buffer.fromArray<T.TimerInfo>(stable_timers);
    timerBuffer.add(timerInfo);
    stable_timers := Buffer.toArray(timerBuffer);
  };

  private func loanExpiredCallback() : async () {
    let currentTime = Time.now();

    for (timer in Iter.fromArray(stable_timers)) {
      if (timer.triggerTime <= currentTime and timer.callbackName == "loanExpired") {
        let playerToReturn = List.find<T.Player>(players, func(p : T.Player) { p.id == timer.playerId });

        switch (playerToReturn) {
          case (null) {};
          case (?p) {
            if (p.parentClubId == 0) {
              formerPlayers := List.append(formerPlayers, List.fromArray([p]));

              players := List.filter<T.Player>(
                players,
                func(player : T.Player) : Bool {
                  return player.id != p.id;
                },
              );
            } else {
              players := List.map<T.Player, T.Player>(
                players,
                func(currentPlayer : T.Player) : T.Player {
                  if (currentPlayer.id == p.id) {
                    return {
                      id = p.id;
                      teamId = p.parentClubId;
                      position = p.position;
                      firstName = p.firstName;
                      lastName = p.lastName;
                      shirtNumber = p.shirtNumber;
                      value = p.value;
                      dateOfBirth = p.dateOfBirth;
                      nationality = p.nationality;
                      seasons = p.seasons;
                      valueHistory = p.valueHistory;
                      onLoan = false;
                      parentClubId = 0;
                      isInjured = p.isInjured;
                      injuryHistory = p.injuryHistory;
                      retirementDate = p.retirementDate;
                      transferHistory = p.transferHistory;
                    };
                  } else {
                    return currentPlayer;
                  };
                },
              );

            };

          };
        };
      };
    };

    stable_timers := Array.filter<T.TimerInfo>(
      stable_timers,
      func(timer : T.TimerInfo) : Bool {
        return timer.triggerTime > currentTime;
      },
    );
  };

  private func defaultCallback() : async () {};

  public shared func recallPlayer(playerId : T.PlayerId) : async () {
    let playerToRecall = List.find<T.Player>(players, func(p : T.Player) { p.id == playerId });
    switch (playerToRecall) {
      case (null) {};
      case (?p) {
        if (p.onLoan) {
          let returnedPlayer : T.Player = {
            id = p.id;
            clubId = p.parentClubId;
            position = p.position;
            firstName = p.firstName;
            lastName = p.lastName;
            shirtNumber = p.shirtNumber;
            value = p.value;
            dateOfBirth = p.dateOfBirth;
            nationality = p.nationality;
            seasons = p.seasons;
            valueHistory = p.valueHistory;
            onLoan = false;
            parentClubId = 0;
            isInjured = p.isInjured;
            injuryHistory = p.injuryHistory;
            retirementDate = p.retirementDate;
            transferHistory = p.transferHistory;
          };

          players := List.map<T.Player, T.Player>(
            players,
            func(currentPlayer : T.Player) : T.Player {
              if (currentPlayer.id == returnedPlayer.id) {
                return returnedPlayer;
              } else {
                return currentPlayer;
              };
            },
          );

          stable_timers := Array.filter<T.TimerInfo>(
            stable_timers,
            func(timer : T.TimerInfo) : Bool {
              return timer.playerId != returnedPlayer.id;
            },
          );
        };
      };
    };
  };

  public shared func createPlayer(clubId : T.ClubId, position : Nat8, firstName : Text, lastName : Text, shirtNumber : Nat8, value : Nat, dateOfBirth : Int, nationality : T.CountryId) : async () {
    let newPlayer : T.Player = {
      id = Nat16.fromNat(nextPlayerId + 1);
      clubId = clubId;
      position = position;
      firstName = firstName;
      lastName = lastName;
      shirtNumber = shirtNumber;
      value = value;
      dateOfBirth = dateOfBirth;
      nationality = nationality;
      seasons = List.nil<T.PlayerSeason>();
      valueHistory = List.nil<T.ValueHistory>();
      onLoan = false;
      parentClubId = 0;
      isInjured = false;
      injuryHistory = List.nil<T.InjuryHistory>();
      retirementDate = 0;
      transferHistory = List.nil<T.TransferHistory>();
    };
    players := List.push(newPlayer, players);
    nextPlayerId += 1;
  };

  public shared func updatePlayer(playerId : T.PlayerId, position : Nat8, firstName : Text, lastName : Text, shirtNumber : Nat8, dateOfBirth : Int, nationality : T.CountryId) : async () {
    players := List.map<T.Player, T.Player>(
      players,
      func(currentPlayer : T.Player) : T.Player {
        if (currentPlayer.id == playerId) {
          return {
            id = currentPlayer.id;
            teamId = currentPlayer.teamId;
            position = position;
            firstName = firstName;
            lastName = lastName;
            shirtNumber = shirtNumber;
            value = currentPlayer.value;
            dateOfBirth = dateOfBirth;
            nationality = nationality;
            seasons = currentPlayer.seasons;
            valueHistory = currentPlayer.valueHistory;
            onLoan = currentPlayer.onLoan;
            parentClubId = currentPlayer.parentClubId;
            isInjured = currentPlayer.isInjured;
            injuryHistory = currentPlayer.injuryHistory;
            retirementDate = currentPlayer.retirementDate;
            transferHistory = currentPlayer.transferHistory;
          };
        } else {
          return currentPlayer;
        };
      },
    );
  };

  public shared func setPlayerInjury(playerId : T.PlayerId, description : Text, expectedEndDate : Int) : async () {
    players := List.map<T.Player, T.Player>(
      players,
      func(currentPlayer : T.Player) : T.Player {
        if (currentPlayer.id == playerId) {

          if (expectedEndDate <= Time.now()) {
            let updatedInjuryHistory = List.map<T.InjuryHistory, T.InjuryHistory>(
              currentPlayer.injuryHistory,
              func(injury : T.InjuryHistory) : T.InjuryHistory {
                if (injury.expectedEndDate > Time.now()) {
                  return {
                    description = injury.description;
                    injuryStartDate = injury.injuryStartDate;
                    expectedEndDate = Time.now();
                  };
                } else {
                  return injury;
                };
              },
            );

            return {
              id = currentPlayer.id;
              teamId = currentPlayer.teamId;
              position = currentPlayer.position;
              firstName = currentPlayer.firstName;
              lastName = currentPlayer.lastName;
              shirtNumber = currentPlayer.shirtNumber;
              value = currentPlayer.value;
              dateOfBirth = currentPlayer.dateOfBirth;
              nationality = currentPlayer.nationality;
              seasons = currentPlayer.seasons;
              valueHistory = currentPlayer.valueHistory;
              onLoan = currentPlayer.onLoan;
              parentClubId = currentPlayer.parentClubId;
              isInjured = false;
              injuryHistory = updatedInjuryHistory;
              retirementDate = currentPlayer.retirementDate;
              transferHistory = currentPlayer.transferHistory;
            };
          } else {
            let newInjury : T.InjuryHistory = {
              description = description;
              expectedEndDate = expectedEndDate;
              injuryStartDate = Time.now();
            };

            return {
              id = currentPlayer.id;
              teamId = currentPlayer.teamId;
              position = currentPlayer.position;
              firstName = currentPlayer.firstName;
              lastName = currentPlayer.lastName;
              shirtNumber = currentPlayer.shirtNumber;
              value = currentPlayer.value;
              dateOfBirth = currentPlayer.dateOfBirth;
              nationality = currentPlayer.nationality;
              seasons = currentPlayer.seasons;
              valueHistory = currentPlayer.valueHistory;
              onLoan = currentPlayer.onLoan;
              parentClubId = currentPlayer.parentClubId;
              isInjured = true;
              injuryHistory = List.push(newInjury, currentPlayer.injuryHistory);
              retirementDate = currentPlayer.retirementDate;
              transferHistory = currentPlayer.transferHistory;
            };
          };
        } else {
          return currentPlayer;
        };
      },
    );
  };

  public shared func retirePlayer(playerId : T.PlayerId, retirementDate : Int) : async () {
    let playerToRetire = List.find<T.Player>(players, func(p : T.Player) { p.id == playerId });
    switch (playerToRetire) {
      case (null) {};
      case (?p) {
        let retiredPlayer : T.Player = {
          id = p.id;
          teamId = p.teamId;
          position = p.position;
          firstName = p.firstName;
          lastName = p.lastName;
          shirtNumber = p.shirtNumber;
          value = p.value;
          dateOfBirth = p.dateOfBirth;
          nationality = p.nationality;
          seasons = p.seasons;
          valueHistory = p.valueHistory;
          onLoan = p.onLoan;
          parentClubId = p.parentClubId;
          isInjured = p.isInjured;
          injuryHistory = p.injuryHistory;
          retirementDate = retirementDate;
          transferHistory = p.transferHistory;
        };

        retiredPlayers := List.push(retiredPlayer, retiredPlayers);
        players := List.filter<T.Player>(
          players,
          func(currentPlayer : T.Player) : Bool {
            return currentPlayer.id != playerId;
          },
        );
        await updateHashForCategory("players");
      };
    };
  };

  public shared func unretirePlayer(playerId : T.PlayerId) : async () {
    let playerToUnretire = List.find<T.Player>(retiredPlayers, func(p : T.Player) { p.id == playerId });
    switch (playerToUnretire) {
      case (null) {};
      case (?p) {
        let activePlayer : T.Player = {
          id = p.id;
          teamId = p.teamId;
          position = p.position;
          firstName = p.firstName;
          lastName = p.lastName;
          shirtNumber = p.shirtNumber;
          value = p.value;
          dateOfBirth = p.dateOfBirth;
          nationality = p.nationality;
          seasons = p.seasons;
          valueHistory = p.valueHistory;
          onLoan = p.onLoan;
          parentClubId = p.parentClubId;
          isInjured = p.isInjured;
          injuryHistory = p.injuryHistory;
          retirementDate = 0;
          transferHistory = p.transferHistory;
        };

        players := List.push(activePlayer, players);
        retiredPlayers := List.filter<T.Player>(
          retiredPlayers,
          func(currentPlayer : T.Player) : Bool {
            return currentPlayer.id != playerId;
          },
        );
      };
    };
  };

  public shared query ({ caller }) func getRetiredPlayer(surname : Text) : async [T.Player] {
    let retiredPlayers = List.filter<T.Player>(
      players,
      func(player : T.Player) : Bool {
        return Text.equal(player.lastName, surname) and player.retirementDate > 0;
      },
    );
    return List.toArray(retiredPlayers);
  };

  public shared query func getDataHashes() : async [T.DataCache] {
    return List.toArray(dataCacheHashes);
  };

  private stable var stable_players : [T.Player] = [];
  private stable var stable_next_player_id : Nat = 0;
  private stable var stable_timers : [T.TimerInfo] = [];
  private stable var stable_data_cache_hashes : [T.DataCache] = [];

  system func preupgrade() {
    stable_players := List.toArray(players);
    stable_next_player_id := nextPlayerId;
    stable_data_cache_hashes := List.toArray(dataCacheHashes);
  };

  system func postupgrade() {
    players := List.fromArray(stable_players);
    nextPlayerId := stable_next_player_id;
    dataCacheHashes := List.fromArray(stable_data_cache_hashes);
    recreateTimers();
  };

  private func recreateTimers() {
    let currentTime = Time.now();
    for (timerInfo in Iter.fromArray(stable_timers)) {
      let remainingDuration = timerInfo.triggerTime - currentTime;

      if (remainingDuration > 0) {
        let duration : Timer.Duration = #nanoseconds(Int.abs(remainingDuration));

        switch (timerInfo.callbackName) {
          case "loanExpired" {
            ignore Timer.setTimer(duration, loanExpiredCallback);
          };
          case _ {
            ignore Timer.setTimer(duration, defaultCallback);
          };
        };
      };
    };
  };

  public shared func updatePlayerEventDataCache() : async () {
    await updateHashForCategory("playerEventData");
  };

  public func updateHashForCategory(category : Text) : async () {

    let hashBuffer = Buffer.fromArray<T.DataCache>([]);

    for (hashObj in Iter.fromList(dataCacheHashes)) {
      if (hashObj.category == category) {
        let randomHash = await SHA224.getRandomHash();
        hashBuffer.add({ category = hashObj.category; hash = randomHash });
      } else { hashBuffer.add(hashObj) };
    };

    dataCacheHashes := List.fromArray(Buffer.toArray<T.DataCache>(hashBuffer));
  };

  public shared func setDefaultHashes() : async () {
    dataCacheHashes := List.fromArray([
      { category = "players"; hash = "DEFAULT_VALUE" },
      { category = "playerEventData"; hash = "DEFAULT_VALUE" },
    ]);
  };

};