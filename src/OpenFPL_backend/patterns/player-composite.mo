import T "../types";
import DTOs "../DTOs";
import List "mo:base/List";
import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";
import Result "mo:base/Result";
import Time "mo:base/Time";
import Text "mo:base/Text";
import Array "mo:base/Array";
import Int "mo:base/Int";
import Timer "mo:base/Timer";
import Nat16 "mo:base/Nat16";
import HashMap "mo:base/HashMap";
import CanisterIds "../CanisterIds";
import Countries "../Countries";
import Utilities "../utilities";

module {
  public class PlayerComposite() {

    private var nextPlayerId : T.PlayerId = 1;
    private var players = List.fromArray<T.Player>([]);
    private var setAndBackupTimer : ?((duration : Timer.Duration, callbackName : Text) -> ()) = null;
    private var removeExpiredTimers : ?(() -> ()) = null;

    public func setStableData(stable_next_player_id : T.PlayerId, stable_players : [T.Player]) {
      nextPlayerId := stable_next_player_id;
      players := List.fromArray(stable_players);
    };

    public func setTimerBackupFunction(
      _setAndBackupTimer : (duration : Timer.Duration, callbackName : Text) -> (),
      _removeExpiredTimers : () -> (),
    ) {
      setAndBackupTimer := ?_setAndBackupTimer;
      removeExpiredTimers := ?_removeExpiredTimers;
    };

    public func loanExpired() : async () {

      let playersToRecall = List.filter<T.Player>(
        players,
        func(currentPlayer : T.Player) : Bool {
          return currentPlayer.status == #OnLoan and currentPlayer.currentLoanEndDate <= Time.now();
        },
      );

      for (player in Iter.fromList(playersToRecall)) {
        let recallPlayerDTO : DTOs.RecallPlayerDTO = {
          playerId = player.id;
        };

        await executeRecallPlayer(recallPlayerDTO);
      };

    };

    public func getActivePlayers(currentSeasonId : T.SeasonId) : [DTOs.PlayerDTO] {

      let activePlayers = List.filter<T.Player>(
        players,
        func(event : T.Player) : Bool {
          return event.status == #Active;
        },
      );

      let playerDTOs = List.map<T.Player, DTOs.PlayerDTO>(
        activePlayers,
        func(player : T.Player) : DTOs.PlayerDTO {

          let season = List.find<T.PlayerSeason>(
            player.seasons,
            func(playerSeason : T.PlayerSeason) {
              return playerSeason.id == currentSeasonId;
            },
          );

          var totalSeasonPoints : Int16 = 0;

          switch (season) {
            case (null) {};
            case (?foundSeason) {
              totalSeasonPoints := List.foldLeft<T.PlayerGameweek, Int16>(foundSeason.gameweeks, 0, func(acc, n) { acc + n.points });
            };
          };

          return {
            id = player.id;
            clubId = player.clubId;
            position = player.position;
            firstName = player.firstName;
            lastName = player.lastName;
            shirtNumber = player.shirtNumber;
            valueQuarterMillions = player.valueQuarterMillions;
            dateOfBirth = player.dateOfBirth;
            nationality = player.nationality;
            totalPoints = totalSeasonPoints;
            status = player.status;
          };
        },
      );
      return List.toArray(playerDTOs);
    };

    public func getPlayerDetailsForGameweek(seasonId : T.SeasonId, gameweek : T.GameweekNumber) : [DTOs.PlayerPointsDTO] {
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
          clubId = player.clubId;
          position = player.position;
          events = List.toArray(events);
          gameweek = gameweek;
        };
        playerDetailsBuffer.add(playerGameweek);
      };

      return Buffer.toArray(playerDetailsBuffer);
    };

    public func getPlayersMap(seasonId : T.SeasonId, gameweek : T.GameweekNumber) : async [(Nat16, DTOs.PlayerScoreDTO)] {
      var playersMap : HashMap.HashMap<Nat16, DTOs.PlayerScoreDTO> = HashMap.HashMap<Nat16, DTOs.PlayerScoreDTO>(500, Utilities.eqNat16, Utilities.hashNat16);
      label playerMapLoop for (player in Iter.fromList(players)) {
        if (player.status == #OnLoan) {
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
                    case (#Goal) { goalsScored += 1 };
                    case (#GoalAssisted) { assists += 1 };
                    case (#GoalConceded) { goalsConceded += 1 };
                    case (#KeeperSave) { saves += 1 };
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
          clubId = player.clubId;
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

    public func getPlayerDetails(playerId : T.PlayerId, seasonId : T.SeasonId) : async Result.Result<DTOs.PlayerDetailDTO, T.Error> {

      var clubId : T.ClubId = 0;
      var position : T.PlayerPosition = #Goalkeeper;
      var firstName = "";
      var lastName = "";
      var shirtNumber : Nat8 = 0;
      var valueQuarterMillions : Nat16 = 0;
      var dateOfBirth : Int = 0;
      var nationality : T.CountryId = 0;
      var valueHistory : [T.ValueHistory] = [];
      var status : T.PlayerStatus = #Active;
      var parentClubId : T.ClubId = 0;
      var isInjured = false;
      var injuryHistory : [T.InjuryHistory] = [];
      var retirementDate : Int = 0;

      let gameweeksBuffer = Buffer.fromArray<DTOs.PlayerGameweekDTO>([]);

      let foundPlayer = List.find<T.Player>(
        players,
        func(player : T.Player) : Bool {
          return player.id == playerId and player.status != #OnLoan;
        },
      );

      switch (foundPlayer) {
        case (null) {};
        case (?player) {
          clubId := player.clubId;
          position := player.position;
          firstName := player.firstName;
          lastName := player.lastName;
          shirtNumber := player.shirtNumber;
          valueQuarterMillions := player.valueQuarterMillions;
          dateOfBirth := player.dateOfBirth;
          nationality := player.nationality;
          valueHistory := List.toArray<T.ValueHistory>(player.valueHistory);
          status := player.status;
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

      return #ok({
        id = playerId;
        clubId = clubId;
        position = position;
        firstName = firstName;
        lastName = lastName;
        shirtNumber = shirtNumber;
        valueQuarterMillions = valueQuarterMillions;
        dateOfBirth = dateOfBirth;
        nationality = nationality;
        seasonId = seasonId;
        valueHistory = valueHistory;
        status = status;
        parentClubId = parentClubId;
        isInjured = isInjured;
        injuryHistory = injuryHistory;
        retirementDate = retirementDate;
        gameweeks = Buffer.toArray<DTOs.PlayerGameweekDTO>(gameweeksBuffer);
      });
    };

    public func getPlayerPosition(playerId : T.PlayerId) : ?T.PlayerPosition {

      let foundPlayer = List.find<T.Player>(
        players,
        func(player : T.Player) : Bool {
          return player.id == playerId and player.status != #OnLoan;
        },
      );

      switch (foundPlayer) {
        case (null) { return null; };
        case (?player) {
          return ?player.position;

        };
      };
    };

    public func validateRevaluePlayerUp(revaluePlayerUpDTO : DTOs.RevaluePlayerUpDTO) : async Result.Result<Text, Text> {
      let player = List.find<T.Player>(
        players,
        func(p : T.Player) : Bool {
          return p.id == revaluePlayerUpDTO.playerId;
        },
      );

      switch (player) {
        case (null) {
          return #err("Invalid: Cannot find player.");
        };
        case (?foundPlayer) {};
      };
      return #ok("Valid");
    };

    public func executeRevaluePlayerUp(revaluePlayerUpDTO : DTOs.RevaluePlayerUpDTO, systemState : T.SystemState) : async () {
      var updatedPlayers = List.map<T.Player, T.Player>(
        players,
        func(p : T.Player) : T.Player {
          if (p.id == revaluePlayerUpDTO.playerId) {
            var newValue = p.valueQuarterMillions;
            newValue += 1;

            let historyEntry : T.ValueHistory = {
              seasonId = systemState.calculationSeasonId;
              gameweek = systemState.pickTeamGameweek;
              oldValue = p.valueQuarterMillions;
              newValue = newValue;
            };

            let updatedPlayer : T.Player = {
              id = p.id;
              clubId = p.clubId;
              position = p.position;
              firstName = p.firstName;
              lastName = p.lastName;
              shirtNumber = p.shirtNumber;
              valueQuarterMillions = p.valueQuarterMillions;
              dateOfBirth = p.dateOfBirth;
              nationality = p.nationality;
              seasons = p.seasons;
              valueHistory = List.append<T.ValueHistory>(p.valueHistory, List.make(historyEntry));
              status = p.status;
              parentClubId = p.parentClubId;
              currentLoanEndDate = p.currentLoanEndDate;
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

    public func validateRevaluePlayerDown(revaluePlayerDownDTO : DTOs.RevaluePlayerDownDTO) : async Result.Result<Text, Text> {
      let player = List.find<T.Player>(
        players,
        func(p : T.Player) : Bool {
          return p.id == revaluePlayerDownDTO.playerId;
        },
      );

      switch (player) {
        case (null) {
          return #err("Invalid: Cannot find player.");
        };
        case (?foundPlayer) {};
      };
      return #ok("Valid");
    };

    public func executeRevaluePlayerDown(revaluePlayerDownDTO : DTOs.RevaluePlayerDownDTO, systemState : T.SystemState) : async () {
      var updatedPlayers = List.map<T.Player, T.Player>(
        players,
        func(p : T.Player) : T.Player {
          if (p.id == revaluePlayerDownDTO.playerId) {
            var newValue = p.valueQuarterMillions;
            if (newValue >= 1) {
              newValue -= 1;
            };

            let historyEntry : T.ValueHistory = {
              seasonId = systemState.calculationSeasonId;
              gameweek = systemState.pickTeamGameweek;
              oldValue = p.valueQuarterMillions;
              newValue = newValue;
            };

            let updatedPlayer : T.Player = {
              id = p.id;
              clubId = p.clubId;
              position = p.position;
              firstName = p.firstName;
              lastName = p.lastName;
              shirtNumber = p.shirtNumber;
              valueQuarterMillions = newValue;
              dateOfBirth = p.dateOfBirth;
              nationality = p.nationality;
              seasons = p.seasons;
              valueHistory = List.append<T.ValueHistory>(p.valueHistory, List.make(historyEntry));
              status = p.status;
              parentClubId = p.parentClubId;
              currentLoanEndDate = p.currentLoanEndDate;
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

    public func validateLoanPlayer(loanPlayerDTO : DTOs.LoanPlayerDTO, clubs : List.List<T.Club>) : async Result.Result<Text, Text> {
      if (loanPlayerDTO.loanEndDate <= Time.now()) {
        return #err("Invalid: Loan end date must be in the future.");
      };

      let player = List.find<T.Player>(
        players,
        func(p : T.Player) : Bool {
          return p.id == loanPlayerDTO.playerId;
        },
      );

      switch (player) {
        case (null) {
          return #err("Invalid: Cannot find player to loan.");
        };
        case (?foundPlayer) {
          if (foundPlayer.status == #OnLoan) {
            return #err("Invalid: Player already on loan.");
          };
        };
      };

      if (loanPlayerDTO.loanClubId > 0) {

        let loanClub = List.find<T.Club>(
          clubs,
          func(club : T.Club) : Bool {
            return club.id == loanPlayerDTO.loanClubId;
          },
        );

        switch (loanClub) {
          case (null) {
            return #err("Invalid: Loan club does not exist.");
          };
          case (?foundTeam) {};
        };
      };

      return #ok("Valid");
    };

    public func executeLoanPlayer(loanPlayerDTO : DTOs.LoanPlayerDTO, systemState : T.SystemState) : async () {
      let playerToLoan = List.find<T.Player>(players, func(p : T.Player) { p.id == loanPlayerDTO.playerId });
      switch (playerToLoan) {
        case (null) {};
        case (?p) {

          let newTransferHistoryEntry : T.TransferHistory = {
            transferDate = Time.now();
            transferGameweek = systemState.pickTeamGameweek;
            transferSeason = systemState.calculationSeasonId;
            fromClub = p.clubId;
            toClub = loanPlayerDTO.loanClubId;
            loanEndDate = loanPlayerDTO.loanEndDate;
          };

          let loanedPlayer : T.Player = {
            id = p.id;
            clubId = loanPlayerDTO.loanClubId;
            position = p.position;
            firstName = p.firstName;
            lastName = p.lastName;
            shirtNumber = p.shirtNumber;
            valueQuarterMillions = p.valueQuarterMillions;
            dateOfBirth = p.dateOfBirth;
            nationality = p.nationality;
            seasons = p.seasons;
            valueHistory = p.valueHistory;
            status = #OnLoan;
            parentClubId = p.clubId;
            currentLoanEndDate = loanPlayerDTO.loanEndDate;
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

          let loanTimerDuration = #nanoseconds(Int.abs((loanPlayerDTO.loanEndDate - Time.now())));
          switch (setAndBackupTimer) {
            case (null) {};
            case (?actualFunction) {
              actualFunction(loanTimerDuration, "loanExpired");
            };
          };
        };
      };
    };

    public func validateTransferPlayer(transferPlayerDTO : DTOs.TransferPlayerDTO, clubs : List.List<T.Club>) : async Result.Result<Text, Text> {
      let player = List.find<T.Player>(
        players,
        func(p : T.Player) : Bool {
          return p.id == transferPlayerDTO.playerId;
        },
      );

      switch (player) {
        case (null) {
          return #err("Invalid: Cannot find player to transfer.");
        };
        case (?foundPlayer) {};
      };

      if (transferPlayerDTO.newClubId > 0) {

        let newClub = List.find<T.Club>(
          clubs,
          func(club : T.Club) : Bool {
            return club.id == transferPlayerDTO.newClubId;
          },
        );

        switch (newClub) {
          case (null) {
            return #err("Invalid: New club does not exist.");
          };
          case (?foundTeam) {};
        };
      };

      return #ok("Valid");
    };

    public func executeTransferPlayer(transferPlayerDTO : DTOs.TransferPlayerDTO, systemState : T.SystemState) : async () {
      let player = List.find<T.Player>(players, func(p : T.Player) { p.id == transferPlayerDTO.playerId });
      switch (player) {
        case (null) {};
        case (?p) {

          let newTransferHistoryEntry : T.TransferHistory = {
            transferDate = Time.now();
            transferGameweek = systemState.pickTeamGameweek;
            transferSeason = systemState.calculationSeasonId;
            fromClub = p.clubId;
            toClub = transferPlayerDTO.newClubId;
            loanEndDate = 0;
          };

          var status : T.PlayerStatus = #Active;
          if (transferPlayerDTO.newClubId == 0) {
            status := #Former;
          };

          let updatedPlayer : T.Player = {
            id = p.id;
            clubId = transferPlayerDTO.newClubId;
            position = p.position;
            firstName = p.firstName;
            lastName = p.lastName;
            shirtNumber = p.shirtNumber;
            valueQuarterMillions = p.valueQuarterMillions;
            dateOfBirth = p.dateOfBirth;
            nationality = p.nationality;
            seasons = p.seasons;
            valueHistory = p.valueHistory;
            status = status;
            currentLoanEndDate = 0;
            parentClubId = 0;
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

    public func validateRecallPlayer(recallPlayerDTO : DTOs.RecallPlayerDTO) : async Result.Result<Text, Text> {
      let player = List.find<T.Player>(
        players,
        func(p : T.Player) : Bool {
          return p.id == recallPlayerDTO.playerId;
        },
      );

      switch (player) {
        case (null) {
          return #err("Invalid: Cannot find player to recall.");
        };
        case (?foundPlayer) {
          if (foundPlayer.status != #OnLoan) {
            return #err("Invalid: Player is not on loan to recall.");
          };
        };
      };

      return #ok("Valid");
    };

    public func executeRecallPlayer(recallPlayerDTO : DTOs.RecallPlayerDTO) : async () {
      let playerToRecall = List.find<T.Player>(players, func(p : T.Player) { p.id == recallPlayerDTO.playerId });
      switch (playerToRecall) {
        case (null) {};
        case (?p) {
          if (p.status == #OnLoan) {
            let returnedPlayer : T.Player = {
              id = p.id;
              clubId = p.parentClubId;
              position = p.position;
              firstName = p.firstName;
              lastName = p.lastName;
              shirtNumber = p.shirtNumber;
              valueQuarterMillions = p.valueQuarterMillions;
              dateOfBirth = p.dateOfBirth;
              nationality = p.nationality;
              seasons = p.seasons;
              valueHistory = p.valueHistory;
              status = #Active;
              parentClubId = 0;
              currentLoanEndDate = 0;
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

            switch (removeExpiredTimers) {
              case (null) {};
              case (?actualFunction) {
                actualFunction();
              };
            };
          };
        };
      };
    };

    public func validateCreatePlayer(createPlayerDTO : DTOs.CreatePlayerDTO, clubs : List.List<T.Club>) : async Result.Result<Text, Text> {

      let newClub = List.find<T.Club>(
        clubs,
        func(club : T.Club) : Bool {
          return club.id == createPlayerDTO.clubId;
        },
      );

      switch (newClub) {
        case (null) {
          return #err("Invalid: Player club does not exist.");
        };
        case (?foundTeam) {};
      };

      if (Text.size(createPlayerDTO.firstName) > 50) {
        return #err("Invalid: Player first name greater than 50 characters.");
      };

      if (Text.size(createPlayerDTO.lastName) > 50) {
        return #err("Invalid: Player last name greater than 50 characters.");
      };

      let playerCountry = Array.find<T.Country>(Countries.countries, func(country : T.Country) : Bool { return country.id == createPlayerDTO.nationality });
      switch (playerCountry) {
        case (null) {
          return #err("Invalid: Country not found.");
        };
        case (?foundCountry) {};
      };

      if (Utilities.calculateAgeFromUnix(createPlayerDTO.dateOfBirth) < 16) {
        return #err("Invalid: Player under 16 years of age.");
      };

      return #ok("Valid");
    };

    public func executeCreatePlayer(createPlayerDTO : DTOs.CreatePlayerDTO) : async () {
      let newPlayer : T.Player = {
        id = nextPlayerId + 1;
        clubId = createPlayerDTO.clubId;
        position = createPlayerDTO.position;
        firstName = createPlayerDTO.firstName;
        lastName = createPlayerDTO.lastName;
        shirtNumber = createPlayerDTO.shirtNumber;
        valueQuarterMillions = createPlayerDTO.valueQuarterMillions;
        dateOfBirth = createPlayerDTO.dateOfBirth;
        nationality = createPlayerDTO.nationality;
        seasons = List.nil<T.PlayerSeason>();
        valueHistory = List.nil<T.ValueHistory>();
        status = #Active;
        parentClubId = 0;
        currentLoanEndDate = 0;
        isInjured = false;
        injuryHistory = List.nil<T.InjuryHistory>();
        retirementDate = 0;
        transferHistory = List.nil<T.TransferHistory>();
      };
      players := List.push(newPlayer, players);
      nextPlayerId += 1;
    };

    public func validateUpdatePlayer(updatePlayerDTO : DTOs.UpdatePlayerDTO) : async Result.Result<Text, Text> {

      let player = List.find<T.Player>(
        players,
        func(p : T.Player) : Bool {
          return p.id == updatePlayerDTO.playerId;
        },
      );

      switch (player) {
        case (null) {
          return #err("Invalid: Cannot find player to update.");
        };
        case (?foundPlayer) {};
      };

      if (Text.size(updatePlayerDTO.firstName) > 50) {
        return #err("Invalid: Player first name greater than 50 characters.");
      };

      if (Text.size(updatePlayerDTO.lastName) > 50) {
        return #err("Invalid: Player last name greater than 50 characters.");
      };

      let playerCountry = Array.find<T.Country>(Countries.countries, func(country : T.Country) : Bool { return country.id == updatePlayerDTO.nationality });
      switch (playerCountry) {
        case (null) {
          return #err("Invalid: Country not found.");
        };
        case (?foundCountry) {};
      };

      if (Utilities.calculateAgeFromUnix(updatePlayerDTO.dateOfBirth) < 16) {
        return #err("Invalid: Player under 16 years of age.");
      };

      return #ok("Valid");
    };

    public func executeUpdatePlayer(updatePlayerDTO : DTOs.UpdatePlayerDTO) : async () {
      players := List.map<T.Player, T.Player>(
        players,
        func(currentPlayer : T.Player) : T.Player {
          if (currentPlayer.id == updatePlayerDTO.playerId) {
            return {
              id = currentPlayer.id;
              clubId = currentPlayer.clubId;
              position = updatePlayerDTO.position;
              firstName = updatePlayerDTO.firstName;
              lastName = updatePlayerDTO.lastName;
              shirtNumber = updatePlayerDTO.shirtNumber;
              valueQuarterMillions = currentPlayer.valueQuarterMillions;
              dateOfBirth = updatePlayerDTO.dateOfBirth;
              nationality = updatePlayerDTO.nationality;
              seasons = currentPlayer.seasons;
              valueHistory = currentPlayer.valueHistory;
              status = currentPlayer.status;
              parentClubId = currentPlayer.parentClubId;
              currentLoanEndDate = currentPlayer.currentLoanEndDate;
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

    public func validateSetPlayerInjury(setPlayerInjuryDTO : DTOs.SetPlayerInjuryDTO) : async Result.Result<Text, Text> {
      let player = List.find<T.Player>(
        players,
        func(p : T.Player) : Bool {
          return p.id == setPlayerInjuryDTO.playerId;
        },
      );

      switch (player) {
        case (null) {
          return #err("Invalid: Cannot find player.");
        };
        case (?foundPlayer) {};
      };

      return #ok("Valid");
    };

    public func executeSetPlayerInjury(setPlayerInjuryDTO : DTOs.SetPlayerInjuryDTO) : async () {
      players := List.map<T.Player, T.Player>(
        players,
        func(currentPlayer : T.Player) : T.Player {
          if (currentPlayer.id == setPlayerInjuryDTO.playerId) {

            if (setPlayerInjuryDTO.expectedEndDate <= Time.now()) {
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
                clubId = currentPlayer.clubId;
                position = currentPlayer.position;
                firstName = currentPlayer.firstName;
                lastName = currentPlayer.lastName;
                shirtNumber = currentPlayer.shirtNumber;
                valueQuarterMillions = currentPlayer.valueQuarterMillions;
                dateOfBirth = currentPlayer.dateOfBirth;
                nationality = currentPlayer.nationality;
                seasons = currentPlayer.seasons;
                valueHistory = currentPlayer.valueHistory;
                status = currentPlayer.status;
                parentClubId = currentPlayer.parentClubId;
                currentLoanEndDate = currentPlayer.currentLoanEndDate;
                isInjured = false;
                injuryHistory = updatedInjuryHistory;
                retirementDate = currentPlayer.retirementDate;
                transferHistory = currentPlayer.transferHistory;
              };
            } else {
              let newInjury : T.InjuryHistory = {
                description = setPlayerInjuryDTO.description;
                expectedEndDate = setPlayerInjuryDTO.expectedEndDate;
                injuryStartDate = Time.now();
              };

              return {
                id = currentPlayer.id;
                clubId = currentPlayer.clubId;
                position = currentPlayer.position;
                firstName = currentPlayer.firstName;
                lastName = currentPlayer.lastName;
                shirtNumber = currentPlayer.shirtNumber;
                valueQuarterMillions = currentPlayer.valueQuarterMillions;
                dateOfBirth = currentPlayer.dateOfBirth;
                nationality = currentPlayer.nationality;
                seasons = currentPlayer.seasons;
                valueHistory = currentPlayer.valueHistory;
                status = currentPlayer.status;
                parentClubId = currentPlayer.parentClubId;
                currentLoanEndDate = currentPlayer.currentLoanEndDate;
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

    public func validateRetirePlayer(retirePlayerDTO : DTOs.RetirePlayerDTO) : async Result.Result<Text, Text> {
      let player = List.find<T.Player>(
        players,
        func(p : T.Player) : Bool {
          return p.id == retirePlayerDTO.playerId;
        },
      );

      switch (player) {
        case (null) {
          return #err("Invalid: Cannot find player to retire.");
        };
        case (?foundPlayer) {};
      };

      return #ok("Valid");
    };

    public func executeRetirePlayer(retirePlayerDTO : DTOs.RetirePlayerDTO) : async () {
      let playerToRetire = List.find<T.Player>(players, func(p : T.Player) { p.id == retirePlayerDTO.playerId });
      switch (playerToRetire) {
        case (null) {};
        case (?p) {
          players := List.map<T.Player, T.Player>(
            players,
            func(currentPlayer : T.Player) : T.Player {
              if (currentPlayer.id == retirePlayerDTO.playerId) {
                return {
                  id = p.id;
                  clubId = p.clubId;
                  position = p.position;
                  firstName = p.firstName;
                  lastName = p.lastName;
                  shirtNumber = p.shirtNumber;
                  valueQuarterMillions = p.valueQuarterMillions;
                  dateOfBirth = p.dateOfBirth;
                  nationality = p.nationality;
                  seasons = p.seasons;
                  valueHistory = p.valueHistory;
                  status = #Retired;
                  parentClubId = p.parentClubId;
                  currentLoanEndDate = p.currentLoanEndDate;
                  isInjured = p.isInjured;
                  injuryHistory = p.injuryHistory;
                  retirementDate = retirePlayerDTO.retirementDate;
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

    public func validateUnretirePlayer(unretirePlayerDTO : DTOs.UnretirePlayerDTO) : async Result.Result<Text, Text> {

      let playerToUnretire = List.find<T.Player>(players, func(p : T.Player) { p.id == unretirePlayerDTO.playerId and p.status == #Retired });
      switch (playerToUnretire) {
        case (null) {
          return #err("Invalid: Cannot find player");
        };
        case (?foundPlayer) {};
      };

      return #ok("Valid");
    };

    public func executeUnretirePlayer(unretirePlayerDTO : DTOs.UnretirePlayerDTO) : async () {
      let playerToUnretire = List.find<T.Player>(players, func(p : T.Player) { p.id == unretirePlayerDTO.playerId });
      switch (playerToUnretire) {
        case (null) {};
        case (?p) {
          players := List.map<T.Player, T.Player>(
            players,
            func(currentPlayer : T.Player) : T.Player {
              if (currentPlayer.id == unretirePlayerDTO.playerId) {
                return {
                  id = p.id;
                  clubId = p.clubId;
                  position = p.position;
                  firstName = p.firstName;
                  lastName = p.lastName;
                  shirtNumber = p.shirtNumber;
                  valueQuarterMillions = p.valueQuarterMillions;
                  dateOfBirth = p.dateOfBirth;
                  nationality = p.nationality;
                  seasons = p.seasons;
                  valueHistory = p.valueHistory;
                  status = #Active;
                  parentClubId = p.parentClubId;
                  currentLoanEndDate = p.currentLoanEndDate;
                  isInjured = p.isInjured;
                  injuryHistory = p.injuryHistory;
                  retirementDate = 0;
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

    public func addEventsToPlayers(playerEventData : [T.PlayerEventData], seasonId : T.SeasonId, gameweek : T.GameweekNumber) : async () {

      var updatedSeasons : List.List<T.PlayerSeason> = List.nil<T.PlayerSeason>();
      let playerEventsMap : HashMap.HashMap<Nat16, [T.PlayerEventData]> = HashMap.HashMap<Nat16, [T.PlayerEventData]>(200, Utilities.eqNat16, Utilities.hashNat16);

      for (event in Iter.fromArray(playerEventData)) {
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

      for (playerEventMap in playerEventsMap.entries()) {
        let player = List.find<T.Player>(
          players,
          func(p : T.Player) : Bool {
            return p.id == playerEventMap.0;
          },
        );
        switch (player) {
          case (null) {};
          case (?foundPlayer) {

            let score : Int16 = calculatePlayerScore(foundPlayer.position, playerEventMap.1);

            if (foundPlayer.seasons == null) {
              let newGameweek : T.PlayerGameweek = {
                number = gameweek;
                events = List.fromArray<T.PlayerEventData>(playerEventMap.1);
                points = score;
              };
              let newSeason : T.PlayerSeason = {
                id = seasonId;
                gameweeks = List.fromArray<T.PlayerGameweek>([newGameweek]);
              };
              updatedSeasons := List.fromArray<T.PlayerSeason>([newSeason]);
            } else {
              let currentSeason = List.find<T.PlayerSeason>(
                foundPlayer.seasons,
                func(s : T.PlayerSeason) : Bool {
                  s.id == seasonId;
                },
              );

              if (currentSeason == null) {
                let newGameweek : T.PlayerGameweek = {
                  number = gameweek;
                  events = List.fromArray<T.PlayerEventData>(playerEventMap.1);
                  points = score;
                };
                let newSeason : T.PlayerSeason = {
                  id = seasonId;
                  gameweeks = List.fromArray<T.PlayerGameweek>([newGameweek]);
                };
                updatedSeasons := List.append<T.PlayerSeason>(foundPlayer.seasons, List.fromArray<T.PlayerSeason>([newSeason]));

              } else {
                updatedSeasons := List.map<T.PlayerSeason, T.PlayerSeason>(
                  foundPlayer.seasons,
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
                        events = List.fromArray<T.PlayerEventData>(playerEventMap.1);
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
                            events = List.append<T.PlayerEventData>(gw.events, List.fromArray(playerEventMap.1));
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

            let updatedPlayer = {
              id = foundPlayer.id;
              clubId = foundPlayer.clubId;
              position = foundPlayer.position;
              firstName = foundPlayer.firstName;
              lastName = foundPlayer.lastName;
              shirtNumber = foundPlayer.shirtNumber;
              valueQuarterMillions = foundPlayer.valueQuarterMillions;
              dateOfBirth = foundPlayer.dateOfBirth;
              nationality = foundPlayer.nationality;
              seasons = updatedSeasons;
              valueHistory = foundPlayer.valueHistory;
              status = foundPlayer.status;
              parentClubId = foundPlayer.parentClubId;
              currentLoanEndDate = foundPlayer.currentLoanEndDate;
              isInjured = foundPlayer.isInjured;
              injuryHistory = foundPlayer.injuryHistory;
              retirementDate = foundPlayer.retirementDate;
              transferHistory = foundPlayer.transferHistory;
            };

            players := List.map<T.Player, T.Player>(
              players,
              func(p : T.Player) : T.Player {
                if (p.id == updatedPlayer.id) { updatedPlayer } else { p };
              },
            );
          };
        }

      };
    };

    private func calculatePlayerScore(playerPosition : T.PlayerPosition, events : [T.PlayerEventData]) : Int16 {
      let totalScore = Array.foldLeft<T.PlayerEventData, Int16>(
        events,
        0,
        func(acc : Int16, event : T.PlayerEventData) : Int16 {
          return acc + Utilities.calculateIndividualScoreForEvent(event, playerPosition);
        },
      );

      let aggregateScore = Utilities.calculateAggregatePlayerEvents(events, playerPosition);
      return totalScore + aggregateScore;
    };

    public func getStablePlayers() : [T.Player] {
      return List.toArray(players);
    };

    public func setStablePlayers(stable_players : [T.Player]) {
      players := List.fromArray(stable_players);
    };

    public func getStableNextPlayerId() : T.PlayerId {
      return nextPlayerId;
    };

    public func setStableNextPlayerId(stable_next_player_id : T.PlayerId) {
      nextPlayerId := stable_next_player_id;
    };
  };
};
