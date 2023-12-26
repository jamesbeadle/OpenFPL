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
import SHA224 "../SHA224";

actor Self {

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

    let sortedPlayers = mergeSort(formerPlayers);

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

  public shared query ({ caller }) func getPlayerDetailsForGameweek(seasonId : Nat16, gameweek : Nat8) : async [DTOs.PlayerPointsDTO] {

    var playerDetailsBuffer = Buffer.fromArray<DTOs.PlayerPointsDTO>([]);

    label playerDetailsLoop for (player in Iter.fromList(formerPlayers)) {
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
          parentTeamId = 0;
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

    var teamId : T.TeamId = 0;
    var position : Nat8 = 0;
    var firstName = "";
    var lastName = "";
    var shirtNumber : Nat8 = 0;
    var value : Nat = 0;
    var dateOfBirth : Int = 0;
    var nationality : T.CountryId = 0;
    var valueHistory : [T.ValueHistory] = [];
    var onLoan = false;
    var parentTeamId : T.TeamId = 0;
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
        parentTeamId := player.parentTeamId;
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
      parentTeamId = parentTeamId;
      isInjured = isInjured;
      injuryHistory = injuryHistory;
      retirementDate = retirementDate;
      gameweeks = Buffer.toArray<DTOs.PlayerGameweekDTO>(gameweeksBuffer);
    };
  };

  public shared func loanPlayer(playerId : T.PlayerId, loanTeamId : T.TeamId, loanEndDate : Int, currentSeasonId : T.SeasonId, currentGameweek : T.GameweekNumber) : async () {
    let playerToLoan = List.find<T.Player>(players, func(p : T.Player) { p.id == playerId });
    switch (playerToLoan) {
      case (null) {};
      case (?p) {

        let newTransferHistoryEntry : T.TransferHistory = {
          transferDate = Time.now();
          transferGameweek = currentGameweek;
          transferSeason = currentSeasonId;
          fromTeam = p.teamId;
          toTeam = loanTeamId;
          loanEndDate = loanEndDate;
        };

        let loanedPlayer : T.Player = {
          id = p.id;
          teamId = loanTeamId;
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
          parentTeamId = p.teamId;
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
  private func loanExpiredCallback() : async () {
    let currentTime = Time.now();

    for (timer in Iter.fromArray(stable_timers)) {
      if (timer.triggerTime <= currentTime and timer.callbackName == "loanExpired") {
        let playerToReturn = List.find<T.Player>(players, func(p : T.Player) { p.id == timer.playerId });

        switch (playerToReturn) {
          case (null) {};
          case (?p) {
            if (p.parentTeamId == 0) {
              //move player to former players
              formerPlayers := List.append(formerPlayers, List.fromArray([p]));

              players := List.filter<T.Player>(
                players,
                func(player : T.Player) : Bool {
                  return player.id != p.id;
                },
              );
            } else {
              //update existing player
              players := List.map<T.Player, T.Player>(
                players,
                func(currentPlayer : T.Player) : T.Player {
                  if (currentPlayer.id == p.id) {
                    return {
                      id = p.id;
                      teamId = p.parentTeamId;
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
                      parentTeamId = 0;
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
          parentTeamId = p.parentTeamId;
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

  private stable var stable_players : [T.Player] = [];

  system func preupgrade() {
    stable_players := List.toArray(formerPlayers);
  };

  system func postupgrade() {
    formerPlayers := List.fromArray(stable_players);
  };

};
