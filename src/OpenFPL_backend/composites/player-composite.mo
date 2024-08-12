import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";
import List "mo:base/List";
import Text "mo:base/Text";
import Time "mo:base/Time";
import Int "mo:base/Int";
import Timer "mo:base/Timer";
import Nat16 "mo:base/Nat16";
import TrieMap "mo:base/TrieMap";

import Countries "../Countries";
import DTOs "../DTOs";
import T "../types";
import Utilities "../utils/utilities";

module {
  public class PlayerComposite() {

    private var nextPlayerId : T.PlayerId = 560;
    private var players = List.fromArray<T.Player>([]);
    private var setAndBackupTimer : ?((duration : Timer.Duration, callbackName : Text) -> async ()) = null;
    private var removeExpiredTimers : ?(() -> ()) = null;

    public func setTimerBackupFunction(
      _setAndBackupTimer : (duration : Timer.Duration, callbackName : Text) -> async (),
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

    public func injuryExpired() : async () {

      let playersNoLongerInjured = List.filter<T.Player>(
        players,
        func(currentPlayer : T.Player) : Bool {
          return currentPlayer.latestInjuryEndDate > 0 and currentPlayer.latestInjuryEndDate <= Time.now();
        },
      );

      for (player in Iter.fromList(playersNoLongerInjured)) {
        await executeResetPlayerInjury(player.id);
      };

    };

    public func getActivePlayers(currentSeasonId : T.SeasonId) : [DTOs.PlayerDTO] {

      let activePlayers = List.filter<T.Player>(
        players,
        func(player : T.Player) : Bool {
          return player.status == #Active;
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

    public func getLoanedPlayers(dto: DTOs.ClubFilterDTO) : [DTOs.PlayerDTO] {

      let loanedPlayers = List.filter<T.Player>(
        players,
        func(player : T.Player) : Bool {
          return player.status == #OnLoan and player.clubId == dto.clubId;
        },
      );

      let playerDTOs = List.map<T.Player, DTOs.PlayerDTO>(
        loanedPlayers,
        func(player : T.Player) : DTOs.PlayerDTO {

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
            totalPoints = 0;
            status = player.status;
          };
        },
      );
      return List.toArray(playerDTOs);
    };

    public func getRetiredPlayers(dto: DTOs.ClubFilterDTO) : [DTOs.PlayerDTO] {

      let retiredPlayers = List.filter<T.Player>(
        players,
        func(player : T.Player) : Bool {
          return player.status == #Retired and player.clubId == dto.clubId;
        },
      );

      let playerDTOs = List.map<T.Player, DTOs.PlayerDTO>(
        retiredPlayers,
        func(player : T.Player) : DTOs.PlayerDTO {

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
            totalPoints = 0;
            status = player.status;
          };
        },
      );
      return List.toArray(playerDTOs);
    };

    public func getPlayerDetailsForGameweek(dto: DTOs.GameweekFiltersDTO) : [DTOs.PlayerPointsDTO] {
      var playerDetailsBuffer = Buffer.fromArray<DTOs.PlayerPointsDTO>([]);

      label playerDetailsLoop for (player in Iter.fromList(players)) {
        var points : Int16 = 0;
        var events : List.List<T.PlayerEventData> = List.nil();

        for (season in Iter.fromList(player.seasons)) {
          if (season.id == dto.seasonId) {
            for (gw in Iter.fromList(season.gameweeks)) {
              if (gw.number == dto.gameweek) {
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
          gameweek = dto.gameweek;
        };
        playerDetailsBuffer.add(playerGameweek);
      };

      return Buffer.toArray(playerDetailsBuffer);
    };

    public func getPlayersMap(dto: DTOs.GameweekFiltersDTO) : [(Nat16, DTOs.PlayerScoreDTO)] {
      var playersMap : TrieMap.TrieMap<Nat16, DTOs.PlayerScoreDTO> = TrieMap.TrieMap<Nat16, DTOs.PlayerScoreDTO>(Utilities.eqNat16, Utilities.hashNat16);
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
          if (season.id == dto.seasonId) {
            for (gw in Iter.fromList(season.gameweeks)) {

              if (gw.number == dto.gameweek) {
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
          events = List.toArray(events);
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

    public func getPlayerDetails(dto: DTOs.GetPlayerDetailsDTO) : DTOs.PlayerDetailDTO {

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
      var latestInjuryEndDate : Int = 0;
      var injuryHistory : [T.InjuryHistory] = [];
      var retirementDate : Int = 0;

      let gameweeksBuffer = Buffer.fromArray<DTOs.PlayerGameweekDTO>([]);

      let foundPlayer = List.find<T.Player>(
        players,
        func(player : T.Player) : Bool {
          return player.id == dto.playerId and player.status != #OnLoan;
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
          latestInjuryEndDate := player.latestInjuryEndDate;
          injuryHistory := List.toArray<T.InjuryHistory>(player.injuryHistory);
          retirementDate := player.retirementDate;

          let currentSeason = List.find<T.PlayerSeason>(player.seasons, func(ps : T.PlayerSeason) { ps.id == dto.seasonId });
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
        id = dto.playerId;
        clubId = clubId;
        position = position;
        firstName = firstName;
        lastName = lastName;
        shirtNumber = shirtNumber;
        valueQuarterMillions = valueQuarterMillions;
        dateOfBirth = dateOfBirth;
        nationality = nationality;
        seasonId = dto.seasonId;
        valueHistory = valueHistory;
        status = status;
        parentClubId = parentClubId;
        latestInjuryEndDate = latestInjuryEndDate;
        injuryHistory = injuryHistory;
        retirementDate = retirementDate;
        gameweeks = Buffer.toArray<DTOs.PlayerGameweekDTO>(gameweeksBuffer);
      };
    };

    public func getPlayerPosition(playerId : T.PlayerId) : ?T.PlayerPosition {

      let foundPlayer = List.find<T.Player>(
        players,
        func(player : T.Player) : Bool {
          return player.id == playerId and player.status != #OnLoan;
        },
      );

      switch (foundPlayer) {
        case (null) { return null };
        case (?player) {
          return ?player.position;

        };
      };
    };

    public func validateRevaluePlayerUp(revaluePlayerUpDTO : DTOs.RevaluePlayerUpDTO) : T.RustResult {
      let player = List.find<T.Player>(
        players,
        func(p : T.Player) : Bool {
          return p.id == revaluePlayerUpDTO.playerId;
        },
      );

      switch (player) {
        case (null) {
          return #Err("Invalid: Cannot find player.");
        };
        case (?foundPlayer) {};
      };

      return #Ok("Proposal Valid");
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
              valueQuarterMillions = newValue;
              dateOfBirth = p.dateOfBirth;
              nationality = p.nationality;
              seasons = p.seasons;
              valueHistory = List.append<T.ValueHistory>(p.valueHistory, List.make(historyEntry));
              status = p.status;
              parentClubId = p.parentClubId;
              currentLoanEndDate = p.currentLoanEndDate;
              latestInjuryEndDate = p.latestInjuryEndDate;
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

    public func validateRevaluePlayerDown(revaluePlayerDownDTO : DTOs.RevaluePlayerDownDTO) : T.RustResult {
      let player = List.find<T.Player>(
        players,
        func(p : T.Player) : Bool {
          return p.id == revaluePlayerDownDTO.playerId;
        },
      );

      switch (player) {
        case (null) {
          return #Err("Invalid: Cannot find player.");
        };
        case (?foundPlayer) {};
      };
      return #Ok("Proposal Valid");
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
              latestInjuryEndDate = p.latestInjuryEndDate;
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

    public func validateLoanPlayer(loanPlayerDTO : DTOs.LoanPlayerDTO, clubs : List.List<T.Club>) : T.RustResult {
      if (loanPlayerDTO.loanEndDate <= Time.now()) {
        return #Err("Invalid: Loan end date must be in the future.");
      };

      let player = List.find<T.Player>(
        players,
        func(p : T.Player) : Bool {
          return p.id == loanPlayerDTO.playerId;
        },
      );

      switch (player) {
        case (null) {
          return #Err("Invalid: Cannot find player to loan.");
        };
        case (?foundPlayer) {
          if (foundPlayer.status == #OnLoan) {
            return #Err("Invalid: Player already on loan.");
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
            return #Err("Invalid: Loan club does not exist.");
          };
          case (?foundTeam) {};
        };
      };

      return #Ok("Proposal Valid");
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
            latestInjuryEndDate = p.latestInjuryEndDate;
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
              await actualFunction(loanTimerDuration, "loanExpired");
            };
          };
        };
      };
    };

    public func validateTransferPlayer(transferPlayerDTO : DTOs.TransferPlayerDTO, clubs : List.List<T.Club>) : T.RustResult {
      let player = List.find<T.Player>(
        players,
        func(p : T.Player) : Bool {
          return p.id == transferPlayerDTO.playerId;
        },
      );

      switch (player) {
        case (null) {
          return #Err("Invalid: Cannot find player to transfer.");
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
            return #Err("Invalid: New club does not exist.");
          };
          case (?foundTeam) {};
        };
      };

      return #Ok("Proposal Valid");
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
            latestInjuryEndDate = p.latestInjuryEndDate;
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

    public func validateRecallPlayer(recallPlayerDTO : DTOs.RecallPlayerDTO) : T.RustResult {
      let player = List.find<T.Player>(
        players,
        func(p : T.Player) : Bool {
          return p.id == recallPlayerDTO.playerId;
        },
      );

      switch (player) {
        case (null) {
          return #Err("Invalid: Cannot find player to recall.");
        };
        case (?foundPlayer) {
          if (foundPlayer.status != #OnLoan) {
            return #Err("Invalid: Player is not on loan to recall.");
          };
        };
      };

      return #Ok("Proposal Valid");
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
              latestInjuryEndDate = p.latestInjuryEndDate;
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

    public func executeResetPlayerInjury(playerId : T.PlayerId) : async () {
      let playersToReset = List.find<T.Player>(players, func(p : T.Player) { p.id == playerId });
      switch (playersToReset) {
        case (null) {};
        case (?p) {
          if (p.latestInjuryEndDate > 0) {
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
              parentClubId = p.parentClubId;
              currentLoanEndDate = p.currentLoanEndDate;
              latestInjuryEndDate = 0;
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

    public func validateCreatePlayer(createPlayerDTO : DTOs.CreatePlayerDTO, clubs : List.List<T.Club>) : T.RustResult {

      let newClub = List.find<T.Club>(
        clubs,
        func(club : T.Club) : Bool {
          return club.id == createPlayerDTO.clubId;
        },
      );

      switch (newClub) {
        case (null) {
          return #Err("Invalid: Player club does not exist.");
        };
        case (?foundTeam) {};
      };

      if (Text.size(createPlayerDTO.firstName) > 50) {
        return #Err("Invalid: Player first name greater than 50 characters.");
      };

      if (Text.size(createPlayerDTO.lastName) > 50) {
        return #Err("Invalid: Player last name greater than 50 characters.");
      };

      let playerCountry = Array.find<T.Country>(Countries.countries, func(country : T.Country) : Bool { return country.id == createPlayerDTO.nationality });
      switch (playerCountry) {
        case (null) {
          return #Err("Invalid: Country not found.");
        };
        case (?foundCountry) {};
      };

      if (Utilities.calculateAgeFromUnix(createPlayerDTO.dateOfBirth) < 16) {
        return #Err("Invalid: Player under 16 years of age.");
      };

      return #Ok("Proposal Valid");
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
        latestInjuryEndDate = 0;
        injuryHistory = List.nil<T.InjuryHistory>();
        retirementDate = 0;
        transferHistory = List.nil<T.TransferHistory>();
      };
      players := List.push(newPlayer, players);
      nextPlayerId += 1;
    };

    public func validateUpdatePlayer(updatePlayerDTO : DTOs.UpdatePlayerDTO) : T.RustResult {

      let player = List.find<T.Player>(
        players,
        func(p : T.Player) : Bool {
          return p.id == updatePlayerDTO.playerId;
        },
      );

      switch (player) {
        case (null) {
          return #Err("Invalid: Cannot find player to update.");
        };
        case (?foundPlayer) {};
      };

      if (Text.size(updatePlayerDTO.firstName) > 50) {
        return #Err("Invalid: Player first name greater than 50 characters.");
      };

      if (Text.size(updatePlayerDTO.lastName) > 50) {
        return #Err("Invalid: Player last name greater than 50 characters.");
      };

      let playerCountry = Array.find<T.Country>(Countries.countries, func(country : T.Country) : Bool { return country.id == updatePlayerDTO.nationality });
      switch (playerCountry) {
        case (null) {
          return #Err("Invalid: Country not found.");
        };
        case (?foundCountry) {};
      };

      if (Utilities.calculateAgeFromUnix(updatePlayerDTO.dateOfBirth) < 16) {
        return #Err("Invalid: Player under 16 years of age.");
      };

      return #Ok("Proposal Valid");
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
              latestInjuryEndDate = currentPlayer.latestInjuryEndDate;
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

    public func validateSetPlayerInjury(setPlayerInjuryDTO : DTOs.SetPlayerInjuryDTO) : T.RustResult {
      let player = List.find<T.Player>(
        players,
        func(p : T.Player) : Bool {
          return p.id == setPlayerInjuryDTO.playerId;
        },
      );

      switch (player) {
        case (null) {
          return #Err("Invalid: Cannot find player.");
        };
        case (?foundPlayer) {};
      };

      return #Ok("Proposal Valid");
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
                latestInjuryEndDate = 0;
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
                latestInjuryEndDate = setPlayerInjuryDTO.expectedEndDate;
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

      let playerInjuryDuration = #nanoseconds(Int.abs((setPlayerInjuryDTO.expectedEndDate - Time.now())));
      switch (setAndBackupTimer) {
        case (null) {};
        case (?actualFunction) {
          await actualFunction(playerInjuryDuration, "injuryExpired");
        };
      };
    };

    public func validateRetirePlayer(retirePlayerDTO : DTOs.RetirePlayerDTO) : T.RustResult {
      let player = List.find<T.Player>(
        players,
        func(p : T.Player) : Bool {
          return p.id == retirePlayerDTO.playerId;
        },
      );

      switch (player) {
        case (null) {
          return #Err("Invalid: Cannot find player to retire.");
        };
        case (?foundPlayer) {};
      };

      return #Ok("Proposal Valid");
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
                  latestInjuryEndDate = p.latestInjuryEndDate;
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

    public func validateUnretirePlayer(unretirePlayerDTO : DTOs.UnretirePlayerDTO) : T.RustResult {

      let playerToUnretire = List.find<T.Player>(players, func(p : T.Player) { p.id == unretirePlayerDTO.playerId and p.status == #Retired });
      switch (playerToUnretire) {
        case (null) {
          return #Err("Invalid: Cannot find player");
        };
        case (?foundPlayer) {};
      };

      return #Ok("Proposal Valid");
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
                  latestInjuryEndDate = p.latestInjuryEndDate;
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
      let playerEventsMap : TrieMap.TrieMap<Nat16, [T.PlayerEventData]> = TrieMap.TrieMap<Nat16, [T.PlayerEventData]>(Utilities.eqNat16, Utilities.hashNat16);

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
              latestInjuryEndDate = foundPlayer.latestInjuryEndDate;
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

    public func setInitialPlayers(){
      players := List.fromArray<T.Player>([
        {id = 1; clubId = 1; firstName = "Aaron"; lastName = "Ramsdale"; shirtNumber = 1; valueQuarterMillions = 56; dateOfBirth = 895104000000000000; nationality = 186; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 2; clubId = 1; firstName = "David"; lastName = "Raya"; shirtNumber = 22; valueQuarterMillions = 56; dateOfBirth = 811123200000000000; nationality = 164; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 4; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 3; clubId = 1; firstName = "Karl"; lastName = "Hein"; shirtNumber = 31; valueQuarterMillions = 22; dateOfBirth = 1018656000000000000; nationality = 56; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 4; clubId = 1; firstName = "William"; lastName = "Saliba"; shirtNumber = 2; valueQuarterMillions = 60; dateOfBirth = 985392000000000000; nationality = 61; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 5; clubId = 1; firstName = "Ben"; lastName = "White"; shirtNumber = 4; valueQuarterMillions = 64; dateOfBirth = 876268800000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 6; clubId = 1; firstName = "Gabriel"; lastName = "Magalhães"; shirtNumber = 6; valueQuarterMillions = 72; dateOfBirth = 882489600000000000; nationality = 24; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 7; clubId = 1; firstName = "Jurrien"; lastName = "Timber"; shirtNumber = 12; valueQuarterMillions = 60; dateOfBirth = 992736000000000000; nationality = 125; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 8; clubId = 1; firstName = "Jakub"; lastName = "Kiwior"; shirtNumber = 15; valueQuarterMillions = 22; dateOfBirth = 950572800000000000; nationality = 140; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 9; clubId = 1; firstName = "Cédric"; lastName = "Soares"; shirtNumber = 17; valueQuarterMillions = 22; dateOfBirth = 683596800000000000; nationality = 141; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 10; clubId = 1; firstName = "Takehiro"; lastName = "Tomiyasu"; shirtNumber = 18; valueQuarterMillions = 30; dateOfBirth = 910224000000000000; nationality = 85; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 11; clubId = 1; firstName = "Oleksandr"; lastName = "Zinchenko"; shirtNumber = 35; valueQuarterMillions = 64; dateOfBirth = 850608000000000000; nationality = 184; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 12; clubId = 1; firstName = "Reuell"; lastName = "Walters"; shirtNumber = 76; valueQuarterMillions = 22; dateOfBirth = 1103155200000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 13; clubId = 1; firstName = "Thomas"; lastName = "Partey"; shirtNumber = 5; valueQuarterMillions = 50; dateOfBirth = 739929600000000000; nationality = 66; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 14; clubId = 1; firstName = "Martin"; lastName = "Ødegaard"; shirtNumber = 8; valueQuarterMillions = 144; dateOfBirth = 913852800000000000; nationality = 131; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 15; clubId = 1; firstName = "Emile"; lastName = "Smith Rowe"; shirtNumber = 10; valueQuarterMillions = 88; dateOfBirth = 964742400000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 16; clubId = 1; firstName = ""; lastName = "Jorginho"; shirtNumber = 20; valueQuarterMillions = 92; dateOfBirth = 693187200000000000; nationality = 83; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 17; clubId = 1; firstName = "Fábio"; lastName = "Vieira"; shirtNumber = 21; valueQuarterMillions = 88; dateOfBirth = 959644800000000000; nationality = 141; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 18; clubId = 1; firstName = "Mohamed"; lastName = "Elneny"; shirtNumber = 25; valueQuarterMillions = 26; dateOfBirth = 710812800000000000; nationality = 52; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 19; clubId = 1; firstName = "Kai"; lastName = "Havertz"; shirtNumber = 29; valueQuarterMillions = 164; dateOfBirth = 929059200000000000; nationality = 65; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 20; clubId = 1; firstName = "Declan"; lastName = "Rice"; shirtNumber = 41; valueQuarterMillions = 84; dateOfBirth = 916272000000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 21; clubId = 1; firstName = "Myles"; lastName = "Lewis-Skelly"; shirtNumber = 59; valueQuarterMillions = 42; dateOfBirth = 1159228800000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 22; clubId = 1; firstName = "Ethan"; lastName = "Nwaneri"; shirtNumber = 63; valueQuarterMillions = 42; dateOfBirth = 1174435200000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 23; clubId = 1; firstName = "Bukayo"; lastName = "Saka"; shirtNumber = 7; valueQuarterMillions = 190; dateOfBirth = 999648000000000000; nationality = 186; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 24; clubId = 1; firstName = "Gabriel"; lastName = "Jesus"; shirtNumber = 9; valueQuarterMillions = 194; dateOfBirth = 860025600000000000; nationality = 24; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 25; clubId = 1; firstName = "Gabriel"; lastName = "Martinelli"; shirtNumber = 11; valueQuarterMillions = 126; dateOfBirth = 992822400000000000; nationality = 24; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 26; clubId = 1; firstName = "Eddie"; lastName = "Nketiah"; shirtNumber = 14; valueQuarterMillions = 118; dateOfBirth = 928022400000000000; nationality = 186; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 27; clubId = 1; firstName = "Leandro"; lastName = "Trossard"; shirtNumber = 19; valueQuarterMillions = 130; dateOfBirth = 786499200000000000; nationality = 17; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 28; clubId = 1; firstName = "Reiss"; lastName = "Nelson"; shirtNumber = 24; valueQuarterMillions = 50; dateOfBirth = 944784000000000000; nationality = 186; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 29; clubId = 1; firstName = ""; lastName = "Marquinhos"; shirtNumber = 27; valueQuarterMillions = 42; dateOfBirth = 1049673600000000000; nationality = 24; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 30; clubId = 1; firstName = "Charles"; lastName = "Sagoe"; shirtNumber = 71; valueQuarterMillions = 42; dateOfBirth = 1090627200000000000; nationality = 186; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 31; clubId = 2; firstName = "Emiliano"; lastName = "Martínez"; shirtNumber = 1; valueQuarterMillions = 64; dateOfBirth = 715392000000000000; nationality = 7; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 32; clubId = 2; firstName = "Robin"; lastName = "Olsen"; shirtNumber = 25; valueQuarterMillions = 18; dateOfBirth = 631756800000000000; nationality = 168; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 33; clubId = 2; firstName = "Joe"; lastName = "Gauci"; shirtNumber = 0; valueQuarterMillions = 22; dateOfBirth = 1088899200000000000; nationality = 9; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 34; clubId = 2; firstName = "Sam"; lastName = "Proctor"; shirtNumber = 0; valueQuarterMillions = 22; dateOfBirth = 1166659200000000000; nationality = 186; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 35; clubId = 2; firstName = "James"; lastName = "Wright"; shirtNumber = 0; valueQuarterMillions = 22; dateOfBirth = 1101945600000000000; nationality = 186; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 36; clubId = 2; firstName = "Matty"; lastName = "Cash"; shirtNumber = 2; valueQuarterMillions = 46; dateOfBirth = 870912000000000000; nationality = 140; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 37; clubId = 2; firstName = "Diego"; lastName = "Carlos"; shirtNumber = 3; valueQuarterMillions = 50; dateOfBirth = 732153600000000000; nationality = 24; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 38; clubId = 2; firstName = "Ezri"; lastName = "Konsa"; shirtNumber = 4; valueQuarterMillions = 38; dateOfBirth = 877564800000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 39; clubId = 2; firstName = "Tyrone"; lastName = "Mings"; shirtNumber = 5; valueQuarterMillions = 50; dateOfBirth = 731980800000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 40; clubId = 2; firstName = "Lucas"; lastName = "Digne"; shirtNumber = 27; valueQuarterMillions = 42; dateOfBirth = 869356800000000000; nationality = 61; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 41; clubId = 2; firstName = "Pau"; lastName = "Torres"; shirtNumber = 0; valueQuarterMillions = 22; dateOfBirth = 853372800000000000; nationality = 164; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 42; clubId = 2; firstName = "Álex"; lastName = "Moreno"; shirtNumber = 15; valueQuarterMillions = 42; dateOfBirth = 739497600000000000; nationality = 164; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 43; clubId = 2; firstName = "Calum"; lastName = "Chambers"; shirtNumber = 16; valueQuarterMillions = 30; dateOfBirth = 790560000000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 44; clubId = 2; firstName = "Clément"; lastName = "Lenglet"; shirtNumber = 17; valueQuarterMillions = 42; dateOfBirth = 803347200000000000; nationality = 61; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 45; clubId = 2; firstName = "Kaine"; lastName = "Kesler-Hayden"; shirtNumber = 29; valueQuarterMillions = 22; dateOfBirth = 1035331200000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 46; clubId = 2; firstName = "Kortney"; lastName = "Hause"; shirtNumber = 30; valueQuarterMillions = 22; dateOfBirth = 805852800000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 47; clubId = 2; firstName = "Douglas"; lastName = "Luiz"; shirtNumber = 6; valueQuarterMillions = 56; dateOfBirth = 894672000000000000; nationality = 24; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 48; clubId = 2; firstName = "John"; lastName = "McGinn"; shirtNumber = 7; valueQuarterMillions = 68; dateOfBirth = 782438400000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 49; clubId = 2; firstName = "Youri"; lastName = "Tielemans"; shirtNumber = 8; valueQuarterMillions = 106; dateOfBirth = 862963200000000000; nationality = 17; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 50; clubId = 2; firstName = "Emiliano"; lastName = "Buendía"; shirtNumber = 10; valueQuarterMillions = 92; dateOfBirth = 851472000000000000; nationality = 7; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 51; clubId = 2; firstName = "Moussa"; lastName = "Diaby"; shirtNumber = 19; valueQuarterMillions = 126; dateOfBirth = 931305600000000000; nationality = 61; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 52; clubId = 2; firstName = "Nicolò"; lastName = "Zaniolo"; shirtNumber = 22; valueQuarterMillions = 84; dateOfBirth = 930873600000000000; nationality = 83; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 53; clubId = 2; firstName = "Morgan"; lastName = "Rogers"; shirtNumber = 27; valueQuarterMillions = 42; dateOfBirth = 1027641600000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 54; clubId = 2; firstName = "Leon"; lastName = "Bailey"; shirtNumber = 31; valueQuarterMillions = 34; dateOfBirth = 871084800000000000; nationality = 84; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 55; clubId = 2; firstName = "Jacob"; lastName = "Ramsey"; shirtNumber = 41; valueQuarterMillions = 68; dateOfBirth = 991008000000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 56; clubId = 2; firstName = "Boubacar"; lastName = "Kamara"; shirtNumber = 44; valueQuarterMillions = 50; dateOfBirth = 943315200000000000; nationality = 61; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 57; clubId = 2; firstName = "Tim"; lastName = "Iroegbunam"; shirtNumber = 47; valueQuarterMillions = 38; dateOfBirth = 1056931200000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 58; clubId = 2; firstName = "Omari"; lastName = "Kellyman"; shirtNumber = 71; valueQuarterMillions = 42; dateOfBirth = 1126742400000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 59; clubId = 2; firstName = "Ollie"; lastName = "Watkins"; shirtNumber = 11; valueQuarterMillions = 160; dateOfBirth = 820281600000000000; nationality = 186; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 60; clubId = 2; firstName = "Jhon"; lastName = "Durán"; shirtNumber = 22; valueQuarterMillions = 84; dateOfBirth = 1071273600000000000; nationality = 37; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 61; clubId = 3; firstName = ""; lastName = "Neto"; shirtNumber = 1; valueQuarterMillions = 42; dateOfBirth = 616809600000000000; nationality = 24; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 62; clubId = 3; firstName = "Darren"; lastName = "Randolph"; shirtNumber = 12; valueQuarterMillions = 22; dateOfBirth = 547776000000000000; nationality = 81; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 63; clubId = 3; firstName = "Andrei"; lastName = "Radu"; shirtNumber = 20; valueQuarterMillions = 42; dateOfBirth = 864777600000000000; nationality = 186; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 64; clubId = 3; firstName = "Mark"; lastName = "Travers"; shirtNumber = 42; valueQuarterMillions = 22; dateOfBirth = 926985600000000000; nationality = 81; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 65; clubId = 3; firstName = "Ryan"; lastName = "Fredericks"; shirtNumber = 2; valueQuarterMillions = 38; dateOfBirth = 718675200000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 66; clubId = 3; firstName = "Milos"; lastName = "Kerkez"; shirtNumber = 3; valueQuarterMillions = 42; dateOfBirth = 1068163200000000000; nationality = 75; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 67; clubId = 3; firstName = "Lloyd"; lastName = "Kelly"; shirtNumber = 5; valueQuarterMillions = 34; dateOfBirth = 907632000000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 68; clubId = 3; firstName = "Chris"; lastName = "Mepham"; shirtNumber = 6; valueQuarterMillions = 34; dateOfBirth = 878688000000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 69; clubId = 3; firstName = "Adam"; lastName = "Smith"; shirtNumber = 15; valueQuarterMillions = 34; dateOfBirth = 672883200000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 70; clubId = 3; firstName = "James"; lastName = "Hill"; shirtNumber = 23; valueQuarterMillions = 22; dateOfBirth = 1010620800000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 71; clubId = 3; firstName = "Marcos"; lastName = "Senesi"; shirtNumber = 25; valueQuarterMillions = 38; dateOfBirth = 863222400000000000; nationality = 7; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 72; clubId = 3; firstName = "Ilya"; lastName = "Zabarnyi"; shirtNumber = 27; valueQuarterMillions = 42; dateOfBirth = 907632000000000000; nationality = 184; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 73; clubId = 3; firstName = "Max"; lastName = "Aarons"; shirtNumber = 37; valueQuarterMillions = 42; dateOfBirth = 946944000000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 74; clubId = 3; firstName = "Lewis"; lastName = "Cook"; shirtNumber = 4; valueQuarterMillions = 60; dateOfBirth = 854928000000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 75; clubId = 3; firstName = "Romain"; lastName = "Faivre"; shirtNumber = 8; valueQuarterMillions = 64; dateOfBirth = 900374400000000000; nationality = 61; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 76; clubId = 3; firstName = "Ryan"; lastName = "Christie"; shirtNumber = 10; valueQuarterMillions = 76; dateOfBirth = 761875200000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 77; clubId = 3; firstName = "Alex"; lastName = "Scott"; shirtNumber = 14; valueQuarterMillions = 60; dateOfBirth = 1061424000000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 78; clubId = 3; firstName = "Marcus"; lastName = "Tavernier"; shirtNumber = 16; valueQuarterMillions = 50; dateOfBirth = 922060800000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 79; clubId = 3; firstName = "Tyler"; lastName = "Adams"; shirtNumber = 18; valueQuarterMillions = 60; dateOfBirth = 918950400000000000; nationality = 187; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 80; clubId = 3; firstName = "Gavin"; lastName = "Kilkenny"; shirtNumber = 26; valueQuarterMillions = 42; dateOfBirth = 949363200000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 81; clubId = 3; firstName = "Philip"; lastName = "Billing"; shirtNumber = 29; valueQuarterMillions = 64; dateOfBirth = 834451200000000000; nationality = 47; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 82; clubId = 3; firstName = "Dominic"; lastName = "Solanke"; shirtNumber = 9; valueQuarterMillions = 88; dateOfBirth = 874195200000000000; nationality = 186; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 83; clubId = 3; firstName = "Dango"; lastName = "Ouattara"; shirtNumber = 11; valueQuarterMillions = 64; dateOfBirth = 1013385600000000000; nationality = 27; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 84; clubId = 3; firstName = "Luis"; lastName = "Sinisterra"; shirtNumber = 17; valueQuarterMillions = 84; dateOfBirth = 929577600000000000; nationality = 37; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 85; clubId = 3; firstName = "Justin"; lastName = "Kluivert"; shirtNumber = 0; valueQuarterMillions = 64; dateOfBirth = 925862400000000000; nationality = 125; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 86; clubId = 3; firstName = "Kieffer"; lastName = "Moore"; shirtNumber = 21; valueQuarterMillions = 60; dateOfBirth = 713232000000000000; nationality = 186; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 87; clubId = 3; firstName = "Antoine"; lastName = "Semenyo"; shirtNumber = 24; valueQuarterMillions = 22; dateOfBirth = 947203200000000000; nationality = 66; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 88; clubId = 4; firstName = "Mark"; lastName = "Flekken"; shirtNumber = 1; valueQuarterMillions = 22; dateOfBirth = 739929600000000000; nationality = 125; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 89; clubId = 4; firstName = "Thomas"; lastName = "Strakosha"; shirtNumber = 21; valueQuarterMillions = 34; dateOfBirth = 795571200000000000; nationality = 2; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 90; clubId = 4; firstName = "Matthew"; lastName = "Cox"; shirtNumber = 34; valueQuarterMillions = 34; dateOfBirth = 1051833600000000000; nationality = 186; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 91; clubId = 4; firstName = "Ellery"; lastName = "Balcombe"; shirtNumber = 0; valueQuarterMillions = 22; dateOfBirth = 939945600000000000; nationality = 186; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 92; clubId = 4; firstName = "Aaron"; lastName = "Hickey"; shirtNumber = 2; valueQuarterMillions = 60; dateOfBirth = 1023667200000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 93; clubId = 4; firstName = "Rico"; lastName = "Henry"; shirtNumber = 3; valueQuarterMillions = 38; dateOfBirth = 870912000000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 94; clubId = 4; firstName = "Charlie"; lastName = "Goode"; shirtNumber = 4; valueQuarterMillions = 22; dateOfBirth = 807408000000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 95; clubId = 4; firstName = "Ethan"; lastName = "Pinnock"; shirtNumber = 5; valueQuarterMillions = 38; dateOfBirth = 738633600000000000; nationality = 84; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 96; clubId = 4; firstName = "Sergio"; lastName = "Reguilón"; shirtNumber = 12; valueQuarterMillions = 42; dateOfBirth = 850694400000000000; nationality = 164; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 18; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 97; clubId = 4; firstName = "Mathias"; lastName = "Jorgensen"; shirtNumber = 13; valueQuarterMillions = 22; dateOfBirth = 640828800000000000; nationality = 125; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 98; clubId = 4; firstName = "Ben"; lastName = "Mee"; shirtNumber = 16; valueQuarterMillions = 56; dateOfBirth = 622339200000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 99; clubId = 4; firstName = "Kristoffer"; lastName = "Ajer"; shirtNumber = 20; valueQuarterMillions = 42; dateOfBirth = 892771200000000000; nationality = 131; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 100; clubId = 4; firstName = "Nathan"; lastName = "Collins"; shirtNumber = 22; valueQuarterMillions = 42; dateOfBirth = 988588800000000000; nationality = 81; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 101; clubId = 4; firstName = "Mads"; lastName = "Roerslev"; shirtNumber = 30; valueQuarterMillions = 34; dateOfBirth = 930182400000000000; nationality = 47; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 102; clubId = 4; firstName = "Fin"; lastName = "Stevens"; shirtNumber = 33; valueQuarterMillions = 34; dateOfBirth = 1049932800000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 103; clubId = 4; firstName = "Christian"; lastName = "Nörgaard"; shirtNumber = 6; valueQuarterMillions = 76; dateOfBirth = 763257600000000000; nationality = 47; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 104; clubId = 4; firstName = "Mathias"; lastName = "Jensen"; shirtNumber = 8; valueQuarterMillions = 56; dateOfBirth = 820454400000000000; nationality = 47; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 105; clubId = 4; firstName = "Josh"; lastName = "Dasilva"; shirtNumber = 10; valueQuarterMillions = 26; dateOfBirth = 909100800000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 106; clubId = 4; firstName = "Yoane"; lastName = "Wissa"; shirtNumber = 11; valueQuarterMillions = 76; dateOfBirth = 841708800000000000; nationality = 39; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 107; clubId = 4; firstName = "Frank"; lastName = "Onyeka"; shirtNumber = 15; valueQuarterMillions = 56; dateOfBirth = 883612800000000000; nationality = 129; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 108; clubId = 4; firstName = "Mikkel"; lastName = "Damsgaard"; shirtNumber = 24; valueQuarterMillions = 64; dateOfBirth = 962582400000000000; nationality = 47; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 109; clubId = 4; firstName = "Myles"; lastName = "Peart-Harris"; shirtNumber = 25; valueQuarterMillions = 38; dateOfBirth = 1032307200000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 110; clubId = 4; firstName = "Shandon"; lastName = "Baptiste"; shirtNumber = 26; valueQuarterMillions = 42; dateOfBirth = 891993600000000000; nationality = 68; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 111; clubId = 4; firstName = "Vitaly"; lastName = "Janelt"; shirtNumber = 27; valueQuarterMillions = 84; dateOfBirth = 894758400000000000; nationality = 65; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 112; clubId = 4; firstName = "Yehor"; lastName = "Yarmolyuk"; shirtNumber = 36; valueQuarterMillions = 42; dateOfBirth = 1078099200000000000; nationality = 184; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 113; clubId = 4; firstName = "Paris"; lastName = "Maghoma"; shirtNumber = 0; valueQuarterMillions = 42; dateOfBirth = 989280000000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 114; clubId = 4; firstName = "Ryan"; lastName = "Trevitt"; shirtNumber = 0; valueQuarterMillions = 42; dateOfBirth = 1047427200000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 115; clubId = 4; firstName = "Neal"; lastName = "Maupay"; shirtNumber = 7; valueQuarterMillions = 88; dateOfBirth = 839980800000000000; nationality = 61; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 9; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 116; clubId = 4; firstName = "Kevin"; lastName = "Schade"; shirtNumber = 9; valueQuarterMillions = 60; dateOfBirth = 1006819200000000000; nationality = 65; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 117; clubId = 4; firstName = "Saman"; lastName = "Ghoddos"; shirtNumber = 14; valueQuarterMillions = 42; dateOfBirth = 747273600000000000; nationality = 168; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 118; clubId = 4; firstName = "Ivan"; lastName = "Toney"; shirtNumber = 17; valueQuarterMillions = 152; dateOfBirth = 826934400000000000; nationality = 186; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 119; clubId = 4; firstName = "Bryan"; lastName = "Mbeumo"; shirtNumber = 19; valueQuarterMillions = 92; dateOfBirth = 933984000000000000; nationality = 31; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 120; clubId = 4; firstName = "Keane"; lastName = "Lewis-Potter"; shirtNumber = 23; valueQuarterMillions = 72; dateOfBirth = 982800000000000000; nationality = 186; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 121; clubId = 5; firstName = "Bart"; lastName = "Verbruggen"; shirtNumber = 1; valueQuarterMillions = 42; dateOfBirth = 1029628800000000000; nationality = 125; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 122; clubId = 5; firstName = "Jason"; lastName = "Steele"; shirtNumber = 23; valueQuarterMillions = 22; dateOfBirth = 650937600000000000; nationality = 186; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 123; clubId = 5; firstName = "Tom"; lastName = "McGill"; shirtNumber = 38; valueQuarterMillions = 22; dateOfBirth = 953942400000000000; nationality = 32; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 124; clubId = 5; firstName = "Tariq"; lastName = "Lamptey"; shirtNumber = 2; valueQuarterMillions = 30; dateOfBirth = 970272000000000000; nationality = 66; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 125; clubId = 5; firstName = "Igor"; lastName = "Julio"; shirtNumber = 3; valueQuarterMillions = 42; dateOfBirth = 886809600000000000; nationality = 24; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 126; clubId = 5; firstName = "Adam"; lastName = "Webster"; shirtNumber = 4; valueQuarterMillions = 42; dateOfBirth = 789177600000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 127; clubId = 5; firstName = "Lewis"; lastName = "Dunk"; shirtNumber = 5; valueQuarterMillions = 56; dateOfBirth = 690681600000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 128; clubId = 5; firstName = "Jan"; lastName = "Paul van Hecke"; shirtNumber = 29; valueQuarterMillions = 22; dateOfBirth = 960422400000000000; nationality = 125; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 129; clubId = 5; firstName = "Pervis"; lastName = "Estupiñán"; shirtNumber = 30; valueQuarterMillions = 64; dateOfBirth = 885340800000000000; nationality = 51; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 130; clubId = 5; firstName = "Joël"; lastName = "Veltman"; shirtNumber = 34; valueQuarterMillions = 46; dateOfBirth = 695433600000000000; nationality = 125; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 131; clubId = 5; firstName = "Valentín"; lastName = "Barco"; shirtNumber = 0; valueQuarterMillions = 22; dateOfBirth = 1090540800000000000; nationality = 7; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 132; clubId = 5; firstName = "James"; lastName = "Milner"; shirtNumber = 6; valueQuarterMillions = 38; dateOfBirth = 505180800000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 133; clubId = 5; firstName = "Solly"; lastName = "March"; shirtNumber = 7; valueQuarterMillions = 72; dateOfBirth = 774662400000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 134; clubId = 5; firstName = "Billy"; lastName = "Gilmour"; shirtNumber = 11; valueQuarterMillions = 30; dateOfBirth = 992217600000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 135; clubId = 5; firstName = "Pascal"; lastName = "Groß"; shirtNumber = 13; valueQuarterMillions = 80; dateOfBirth = 676944000000000000; nationality = 65; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 136; clubId = 5; firstName = "Adam"; lastName = "Lallana"; shirtNumber = 14; valueQuarterMillions = 56; dateOfBirth = 579225600000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 137; clubId = 5; firstName = "Jakub"; lastName = "Moder"; shirtNumber = 15; valueQuarterMillions = 38; dateOfBirth = 923443200000000000; nationality = 140; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 138; clubId = 5; firstName = "Carlos"; lastName = "Baleba"; shirtNumber = 20; valueQuarterMillions = 42; dateOfBirth = 1073174400000000000; nationality = 31; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 139; clubId = 5; firstName = "Kaoru"; lastName = "Mitoma"; shirtNumber = 22; valueQuarterMillions = 92; dateOfBirth = 864086400000000000; nationality = 85; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 140; clubId = 5; firstName = "Facundo"; lastName = "Buonanotte"; shirtNumber = 40; valueQuarterMillions = 42; dateOfBirth = 1103760000000000000; nationality = 7; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 141; clubId = 5; firstName = "Jack"; lastName = "Hinshelwood"; shirtNumber = 41; valueQuarterMillions = 42; dateOfBirth = 1105401600000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 142; clubId = 5; firstName = "João"; lastName = "Pedro"; shirtNumber = 9; valueQuarterMillions = 84; dateOfBirth = 1001462400000000000; nationality = 24; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 143; clubId = 5; firstName = "Julio"; lastName = "Enciso"; shirtNumber = 10; valueQuarterMillions = 46; dateOfBirth = 1074816000000000000; nationality = 137; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 144; clubId = 5; firstName = "Danny"; lastName = "Welbeck"; shirtNumber = 18; valueQuarterMillions = 126; dateOfBirth = 659577600000000000; nationality = 186; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 145; clubId = 5; firstName = "Simon"; lastName = "Adingra"; shirtNumber = 24; valueQuarterMillions = 64; dateOfBirth = 1009843200000000000; nationality = 42; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 146; clubId = 5; firstName = "Evan"; lastName = "Ferguson"; shirtNumber = 28; valueQuarterMillions = 46; dateOfBirth = 1098144000000000000; nationality = 81; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 147; clubId = 5; firstName = "Ansu"; lastName = "Fati"; shirtNumber = 31; valueQuarterMillions = 126; dateOfBirth = 1036022400000000000; nationality = 71; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 148; clubId = 6; firstName = "James"; lastName = "Trafford"; shirtNumber = 1; valueQuarterMillions = 42; dateOfBirth = 1034208000000000000; nationality = 186; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 149; clubId = 6; firstName = "Lawrence"; lastName = "Vigouroux"; shirtNumber = 29; valueQuarterMillions = 22; dateOfBirth = 753667200000000000; nationality = 186; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 150; clubId = 6; firstName = "Arijanet"; lastName = "Muric"; shirtNumber = 49; valueQuarterMillions = 22; dateOfBirth = 910396800000000000; nationality = 169; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 151; clubId = 6; firstName = "Dara"; lastName = "O'Shea"; shirtNumber = 2; valueQuarterMillions = 42; dateOfBirth = 920505600000000000; nationality = 81; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 152; clubId = 6; firstName = "Charlie"; lastName = "Taylor"; shirtNumber = 3; valueQuarterMillions = 42; dateOfBirth = 753580800000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 153; clubId = 6; firstName = "Jordan"; lastName = "Beyer"; shirtNumber = 5; valueQuarterMillions = 42; dateOfBirth = 958694400000000000; nationality = 65; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 154; clubId = 6; firstName = "Hjalmar"; lastName = "Ekdal"; shirtNumber = 18; valueQuarterMillions = 42; dateOfBirth = 908928000000000000; nationality = 168; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 155; clubId = 6; firstName = "Vitinho"; lastName = "Vitinho"; shirtNumber = 22; valueQuarterMillions = 42; dateOfBirth = 750124800000000000; nationality = 24; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 156; clubId = 6; firstName = "Ameen"; lastName = "Al Dakhil"; shirtNumber = 28; valueQuarterMillions = 42; dateOfBirth = 1015372800000000000; nationality = 17; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 157; clubId = 6; firstName = "Hannes"; lastName = "Delcroix"; shirtNumber = 44; valueQuarterMillions = 22; dateOfBirth = 920160000000000000; nationality = 17; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 158; clubId = 6; firstName = "Jack"; lastName = "Cork"; shirtNumber = 4; valueQuarterMillions = 42; dateOfBirth = 614736000000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 159; clubId = 6; firstName = "Jóhann"; lastName = "Gudmundsson"; shirtNumber = 7; valueQuarterMillions = 42; dateOfBirth = 656985600000000000; nationality = 76; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 160; clubId = 6; firstName = "Josh"; lastName = "Brownhill"; shirtNumber = 8; valueQuarterMillions = 42; dateOfBirth = 819331200000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 161; clubId = 6; firstName = "Sander"; lastName = "Berge"; shirtNumber = 16; valueQuarterMillions = 42; dateOfBirth = 887414400000000000; nationality = 131; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 162; clubId = 6; firstName = "Aaron"; lastName = "Ramsey"; shirtNumber = 21; valueQuarterMillions = 64; dateOfBirth = 1043107200000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 163; clubId = 6; firstName = "Josh"; lastName = "Cullen"; shirtNumber = 24; valueQuarterMillions = 42; dateOfBirth = 828835200000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 164; clubId = 6; firstName = "Mike"; lastName = "Trésor"; shirtNumber = 31; valueQuarterMillions = 84; dateOfBirth = 927849600000000000; nationality = 17; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 165; clubId = 6; firstName = "Han-Noah"; lastName = "Massengo"; shirtNumber = 42; valueQuarterMillions = 42; dateOfBirth = 994464000000000000; nationality = 61; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 166; clubId = 6; firstName = "Jay"; lastName = "Rodriguez"; shirtNumber = 9; valueQuarterMillions = 80; dateOfBirth = 617673600000000000; nationality = 186; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 167; clubId = 6; firstName = "Benson"; lastName = "Manuel"; shirtNumber = 10; valueQuarterMillions = 84; dateOfBirth = 859507200000000000; nationality = 17; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 168; clubId = 6; firstName = "Nathan"; lastName = "Redmond"; shirtNumber = 15; valueQuarterMillions = 64; dateOfBirth = 762912000000000000; nationality = 186; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 169; clubId = 6; firstName = "Lyle"; lastName = "Foster"; shirtNumber = 12; valueQuarterMillions = 64; dateOfBirth = 967939200000000000; nationality = 162; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 170; clubId = 6; firstName = "David"; lastName = "Fofana"; shirtNumber = 23; valueQuarterMillions = 42; dateOfBirth = 1040515200000000000; nationality = 42; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 7; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 171; clubId = 6; firstName = "Zeki"; lastName = "Amdouni"; shirtNumber = 25; valueQuarterMillions = 84; dateOfBirth = 975888000000000000; nationality = 169; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 7; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 172; clubId = 6; firstName = "Luca"; lastName = "Koleosho"; shirtNumber = 12; valueQuarterMillions = 64; dateOfBirth = 1095206400000000000; nationality = 187; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 7; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 173; clubId = 6; firstName = "Jacob"; lastName = "Bruun Larsen"; shirtNumber = 0; valueQuarterMillions = 64; dateOfBirth = 906163200000000000; nationality = 47; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 7; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 174; clubId = 6; firstName = "Wilson"; lastName = "Odobert"; shirtNumber = 47; valueQuarterMillions = 64; dateOfBirth = 1101600000000000000; nationality = 61; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 7; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 175; clubId = 7; firstName = "Robert"; lastName = "Sanchez"; shirtNumber = 1; valueQuarterMillions = 42; dateOfBirth = 879811200000000000; nationality = 164; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 176; clubId = 7; firstName = "Marcus"; lastName = "Bettinelli"; shirtNumber = 13; valueQuarterMillions = 22; dateOfBirth = 706665600000000000; nationality = 186; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 177; clubId = 7; firstName = "Djordje"; lastName = "Petrovic"; shirtNumber = 28; valueQuarterMillions = 42; dateOfBirth = 939340800000000000; nationality = 154; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 178; clubId = 7; firstName = "Lucas"; lastName = "Bergstrom"; shirtNumber = 47; valueQuarterMillions = 22; dateOfBirth = 1031097600000000000; nationality = 60; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 179; clubId = 7; firstName = "Alex"; lastName = "Disasi"; shirtNumber = 2; valueQuarterMillions = 64; dateOfBirth = 889574400000000000; nationality = 61; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 180; clubId = 7; firstName = "Marc"; lastName = "Cucurella"; shirtNumber = 3; valueQuarterMillions = 60; dateOfBirth = 901065600000000000; nationality = 164; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 181; clubId = 7; firstName = "Benoît"; lastName = "Badiashile"; shirtNumber = 4; valueQuarterMillions = 64; dateOfBirth = 985564800000000000; nationality = 61; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 182; clubId = 7; firstName = "Thiago"; lastName = "Silva"; shirtNumber = 6; valueQuarterMillions = 80; dateOfBirth = 464659200000000000; nationality = 24; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 183; clubId = 7; firstName = "Trevoh"; lastName = "Chalobah"; shirtNumber = 14; valueQuarterMillions = 38; dateOfBirth = 931132800000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 184; clubId = 7; firstName = "Ben"; lastName = "Chilwell"; shirtNumber = 21; valueQuarterMillions = 88; dateOfBirth = 851126400000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 185; clubId = 7; firstName = "Reece"; lastName = "James"; shirtNumber = 24; valueQuarterMillions = 98; dateOfBirth = 944611200000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 186; clubId = 7; firstName = "Levi"; lastName = "Colwill"; shirtNumber = 26; valueQuarterMillions = 38; dateOfBirth = 1046217600000000000; nationality = 153; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 187; clubId = 7; firstName = "Malo"; lastName = "Gusto"; shirtNumber = 27; valueQuarterMillions = 64; dateOfBirth = 1053302400000000000; nationality = 61; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 188; clubId = 7; firstName = "Wesley"; lastName = "Fofana"; shirtNumber = 33; valueQuarterMillions = 34; dateOfBirth = 977011200000000000; nationality = 61; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 189; clubId = 7; firstName = "Alfie"; lastName = "Gilchrist"; shirtNumber = 42; valueQuarterMillions = 22; dateOfBirth = 1069977600000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 190; clubId = 7; firstName = "Malang"; lastName = "Sarr"; shirtNumber = 0; valueQuarterMillions = 30; dateOfBirth = 917049600000000000; nationality = 61; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 191; clubId = 7; firstName = "Enzo"; lastName = "Fernández"; shirtNumber = 8; valueQuarterMillions = 64; dateOfBirth = 979689600000000000; nationality = 7; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 192; clubId = 7; firstName = "Lesley"; lastName = "Ugochukwu"; shirtNumber = 16; valueQuarterMillions = 42; dateOfBirth = 1080259200000000000; nationality = 61; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 193; clubId = 7; firstName = "Carney"; lastName = "Chukwuemeka"; shirtNumber = 17; valueQuarterMillions = 30; dateOfBirth = 1066608000000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 194; clubId = 7; firstName = "Conor"; lastName = "Gallagher"; shirtNumber = 23; valueQuarterMillions = 88; dateOfBirth = 949795200000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 195; clubId = 7; firstName = "Moisés"; lastName = "Caicedo"; shirtNumber = 25; valueQuarterMillions = 64; dateOfBirth = 1004659200000000000; nationality = 51; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 196; clubId = 7; firstName = "Cesare"; lastName = "Casadei"; shirtNumber = 31; valueQuarterMillions = 42; dateOfBirth = 1042156800000000000; nationality = 83; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 197; clubId = 7; firstName = "Romeo"; lastName = "Lavia"; shirtNumber = 45; valueQuarterMillions = 60; dateOfBirth = 1073347200000000000; nationality = 17; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 198; clubId = 7; firstName = "Leo"; lastName = "Castledine"; shirtNumber = 54; valueQuarterMillions = 42; dateOfBirth = 1124496000000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 199; clubId = 7; firstName = "Raheem"; lastName = "Sterling"; shirtNumber = 7; valueQuarterMillions = 262; dateOfBirth = 786844800000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 200; clubId = 7; firstName = "Mykhaylo"; lastName = "Mudryk"; shirtNumber = 10; valueQuarterMillions = 126; dateOfBirth = 978652800000000000; nationality = 184; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 201; clubId = 7; firstName = "Noni"; lastName = "Madueke"; shirtNumber = 11; valueQuarterMillions = 80; dateOfBirth = 1015718400000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 202; clubId = 7; firstName = "Cole"; lastName = "Palmer"; shirtNumber = 20; valueQuarterMillions = 60; dateOfBirth = 1020643200000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 203; clubId = 7; firstName = "Diego"; lastName = "Moreira"; shirtNumber = 43; valueQuarterMillions = 42; dateOfBirth = 1091750400000000000; nationality = 17; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 204; clubId = 7; firstName = "Christopher"; lastName = "Nkunku"; shirtNumber = 0; valueQuarterMillions = 168; dateOfBirth = 879465600000000000; nationality = 61; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 205; clubId = 7; firstName = "Nicolas"; lastName = "Jackson"; shirtNumber = 15; valueQuarterMillions = 148; dateOfBirth = 992908800000000000; nationality = 63; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 206; clubId = 7; firstName = "Deivid"; lastName = "Washington"; shirtNumber = 36; valueQuarterMillions = 42; dateOfBirth = 1117929600000000000; nationality = 24; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 207; clubId = 7; firstName = "Dujuan"; lastName = "Richards"; shirtNumber = 0; valueQuarterMillions = 22; dateOfBirth = 1131580800000000000; nationality = 84; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 208; clubId = 8; firstName = "Sam"; lastName = "Johnstone"; shirtNumber = 1; valueQuarterMillions = 38; dateOfBirth = 733017600000000000; nationality = 186; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 209; clubId = 8; firstName = "Dean"; lastName = "Henderson"; shirtNumber = 30; valueQuarterMillions = 42; dateOfBirth = 858124800000000000; nationality = 186; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 210; clubId = 8; firstName = "Remi"; lastName = "Matthews"; shirtNumber = 31; valueQuarterMillions = 22; dateOfBirth = 760838400000000000; nationality = 186; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 211; clubId = 8; firstName = "Joe"; lastName = "Whitworth"; shirtNumber = 41; valueQuarterMillions = 22; dateOfBirth = 1078012800000000000; nationality = 186; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 212; clubId = 8; firstName = "Joel"; lastName = "Ward"; shirtNumber = 2; valueQuarterMillions = 38; dateOfBirth = 625622400000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 213; clubId = 8; firstName = "Tyrick"; lastName = "Mitchell"; shirtNumber = 3; valueQuarterMillions = 38; dateOfBirth = 936144000000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 214; clubId = 8; firstName = "Rob"; lastName = "Holding"; shirtNumber = 4; valueQuarterMillions = 30; dateOfBirth = 811555200000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 215; clubId = 8; firstName = "James"; lastName = "Tomkins"; shirtNumber = 5; valueQuarterMillions = 18; dateOfBirth = 607132800000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 216; clubId = 8; firstName = "Marc"; lastName = "Guéhi"; shirtNumber = 6; valueQuarterMillions = 42; dateOfBirth = 963446400000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 217; clubId = 8; firstName = "Daniel"; lastName = "Muñoz"; shirtNumber = 12; valueQuarterMillions = 42; dateOfBirth = 832896000000000000; nationality = 37; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 218; clubId = 8; firstName = "Joachim"; lastName = "Andersen"; shirtNumber = 16; valueQuarterMillions = 42; dateOfBirth = 833500800000000000; nationality = 47; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 219; clubId = 8; firstName = "Nathaniel"; lastName = "Clyne"; shirtNumber = 17; valueQuarterMillions = 42; dateOfBirth = 670809600000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 220; clubId = 8; firstName = "Chris"; lastName = "Richards"; shirtNumber = 26; valueQuarterMillions = 38; dateOfBirth = 954201600000000000; nationality = 187; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 221; clubId = 8; firstName = "Nathan"; lastName = "Ferguson"; shirtNumber = 36; valueQuarterMillions = 22; dateOfBirth = 970790400000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 222; clubId = 8; firstName = "Michael"; lastName = "Olise"; shirtNumber = 7; valueQuarterMillions = 76; dateOfBirth = 1008115200000000000; nationality = 61; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 223; clubId = 8; firstName = "Jefferson"; lastName = "Lerma"; shirtNumber = 8; valueQuarterMillions = 64; dateOfBirth = 783043200000000000; nationality = 37; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 224; clubId = 8; firstName = "Eberechi"; lastName = "Eze"; shirtNumber = 10; valueQuarterMillions = 92; dateOfBirth = 899078400000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 225; clubId = 8; firstName = "Jeffrey"; lastName = "Schlupp"; shirtNumber = 15; valueQuarterMillions = 50; dateOfBirth = 725068800000000000; nationality = 66; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 226; clubId = 8; firstName = "Will"; lastName = "Hughes"; shirtNumber = 19; valueQuarterMillions = 56; dateOfBirth = 798076800000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 227; clubId = 8; firstName = "Adam"; lastName = "Wharton"; shirtNumber = 20; valueQuarterMillions = 64; dateOfBirth = 1076025600000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 228; clubId = 8; firstName = "Cheick"; lastName = "Doucouré"; shirtNumber = 28; valueQuarterMillions = 64; dateOfBirth = 947289600000000000; nationality = 108; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 229; clubId = 8; firstName = "Naouirou"; lastName = "Ahamada"; shirtNumber = 29; valueQuarterMillions = 42; dateOfBirth = 1017360000000000000; nationality = 61; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 230; clubId = 8; firstName = "Jack"; lastName = "Wells-Morrison"; shirtNumber = 40; valueQuarterMillions = 42; dateOfBirth = 1641513600000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 231; clubId = 8; firstName = "Jairo"; lastName = "Riedewald"; shirtNumber = 44; valueQuarterMillions = 30; dateOfBirth = 842227200000000000; nationality = 125; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 232; clubId = 8; firstName = "Jesurun"; lastName = "Rak-Sakyi"; shirtNumber = 49; valueQuarterMillions = 42; dateOfBirth = 1033776000000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 233; clubId = 8; firstName = "David"; lastName = "Ozoh"; shirtNumber = 52; valueQuarterMillions = 42; dateOfBirth = 1115337600000000000; nationality = 164; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 234; clubId = 8; firstName = "Jadan"; lastName = "Raymond"; shirtNumber = 60; valueQuarterMillions = 22; dateOfBirth = 1066176000000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 235; clubId = 8; firstName = "Jordan"; lastName = "Ayew"; shirtNumber = 9; valueQuarterMillions = 72; dateOfBirth = 684547200000000000; nationality = 66; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 236; clubId = 8; firstName = "Matheus"; lastName = "França"; shirtNumber = 11; valueQuarterMillions = 60; dateOfBirth = 1080777600000000000; nationality = 24; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 237; clubId = 8; firstName = "Jean-Philippe"; lastName = "Mateta"; shirtNumber = 14; valueQuarterMillions = 68; dateOfBirth = 867456000000000000; nationality = 61; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 238; clubId = 8; firstName = "Odsonne"; lastName = "Edouard"; shirtNumber = 22; valueQuarterMillions = 64; dateOfBirth = 884908800000000000; nationality = 61; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 239; clubId = 8; firstName = "John-Kymani"; lastName = "Gordon"; shirtNumber = 37; valueQuarterMillions = 22; dateOfBirth = 1045094400000000000; nationality = 186; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 240; clubId = 8; firstName = "Luke"; lastName = "Plange"; shirtNumber = 48; valueQuarterMillions = 22; dateOfBirth = 1036368000000000000; nationality = 186; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 241; clubId = 9; firstName = "Jordan"; lastName = "Pickford"; shirtNumber = 1; valueQuarterMillions = 38; dateOfBirth = 762998400000000000; nationality = 186; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 242; clubId = 9; firstName = "João"; lastName = "Virgínia"; shirtNumber = 0; valueQuarterMillions = 22; dateOfBirth = 939513600000000000; nationality = 141; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 243; clubId = 9; firstName = "Andy"; lastName = "Lonergan"; shirtNumber = 31; valueQuarterMillions = 22; dateOfBirth = 435369600000000000; nationality = 186; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 244; clubId = 9; firstName = "Billy"; lastName = "Crellin"; shirtNumber = 43; valueQuarterMillions = 22; dateOfBirth = 962323200000000000; nationality = 186; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 245; clubId = 9; firstName = "Nathan"; lastName = "Patterson"; shirtNumber = 2; valueQuarterMillions = 18; dateOfBirth = 1003190400000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 246; clubId = 9; firstName = "Michael"; lastName = "Keane"; shirtNumber = 5; valueQuarterMillions = 30; dateOfBirth = 726710400000000000; nationality = 81; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 247; clubId = 9; firstName = "James"; lastName = "Tarkowski"; shirtNumber = 6; valueQuarterMillions = 26; dateOfBirth = 722131200000000000; nationality = 140; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 248; clubId = 9; firstName = "Ashley"; lastName = "Young"; shirtNumber = 18; valueQuarterMillions = 22; dateOfBirth = 489715200000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 249; clubId = 9; firstName = "Vitaliy"; lastName = "Mykolenko"; shirtNumber = 19; valueQuarterMillions = 26; dateOfBirth = 927936000000000000; nationality = 184; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 250; clubId = 9; firstName = "Ben"; lastName = "Godfrey"; shirtNumber = 22; valueQuarterMillions = 34; dateOfBirth = 884822400000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 251; clubId = 9; firstName = "Seamus"; lastName = "Coleman"; shirtNumber = 23; valueQuarterMillions = 26; dateOfBirth = 592531200000000000; nationality = 81; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 252; clubId = 9; firstName = "jarrad"; lastName = "Branthwaite"; shirtNumber = 32; valueQuarterMillions = 22; dateOfBirth = 1025136000000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 253; clubId = 9; firstName = "Amadou"; lastName = "Onana"; shirtNumber = 8; valueQuarterMillions = 50; dateOfBirth = 997920000000000000; nationality = 17; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 254; clubId = 9; firstName = "Abdoulaye"; lastName = "Doucouré"; shirtNumber = 16; valueQuarterMillions = 76; dateOfBirth = 725846400000000000; nationality = 108; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 255; clubId = 9; firstName = "Dele"; lastName = "Alli"; shirtNumber = 20; valueQuarterMillions = 64; dateOfBirth = 829180800000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 256; clubId = 9; firstName = "André"; lastName = "Gomes"; shirtNumber = 21; valueQuarterMillions = 38; dateOfBirth = 743990400000000000; nationality = 141; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 257; clubId = 9; firstName = "Idrissa"; lastName = "Gueye"; shirtNumber = 27; valueQuarterMillions = 50; dateOfBirth = 622771200000000000; nationality = 153; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 258; clubId = 9; firstName = "James"; lastName = "Garner"; shirtNumber = 37; valueQuarterMillions = 42; dateOfBirth = 984441600000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 259; clubId = 9; firstName = "Tyler"; lastName = "Onyango"; shirtNumber = 62; valueQuarterMillions = 42; dateOfBirth = 1046736000000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 260; clubId = 9; firstName = "Dwight"; lastName = "McNeil"; shirtNumber = 7; valueQuarterMillions = 72; dateOfBirth = 943228800000000000; nationality = 186; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 261; clubId = 9; firstName = "Dominic"; lastName = "Calvert-Lewin"; shirtNumber = 9; valueQuarterMillions = 186; dateOfBirth = 858470400000000000; nationality = 186; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 262; clubId = 9; firstName = "Arnaut"; lastName = "Danjuma"; shirtNumber = 10; valueQuarterMillions = 84; dateOfBirth = 854668800000000000; nationality = 125; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 263; clubId = 9; firstName = "Jack"; lastName = "Harrison"; shirtNumber = 11; valueQuarterMillions = 84; dateOfBirth = 848448000000000000; nationality = 186; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 264; clubId = 9; firstName = ""; lastName = "Beto"; shirtNumber = 14; valueQuarterMillions = 106; dateOfBirth = 886204800000000000; nationality = 141; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 265; clubId = 9; firstName = "Youssef"; lastName = "Chermiti"; shirtNumber = 28; valueQuarterMillions = 64; dateOfBirth = 1085356800000000000; nationality = 141; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 266; clubId = 9; firstName = "Lewis"; lastName = "Dobbin"; shirtNumber = 61; valueQuarterMillions = 42; dateOfBirth = 1041552000000000000; nationality = 186; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 267; clubId = 10; firstName = "Marek"; lastName = "Rodak"; shirtNumber = 1; valueQuarterMillions = 34; dateOfBirth = 850435200000000000; nationality = 158; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 268; clubId = 10; firstName = "Bernd"; lastName = "Leno"; shirtNumber = 17; valueQuarterMillions = 46; dateOfBirth = 699667200000000000; nationality = 65; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 269; clubId = 10; firstName = "Steven"; lastName = "Benda"; shirtNumber = 23; valueQuarterMillions = 22; dateOfBirth = 907200000000000000; nationality = 65; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 270; clubId = 10; firstName = "Kenny"; lastName = "Tete"; shirtNumber = 2; valueQuarterMillions = 38; dateOfBirth = 813196800000000000; nationality = 125; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 271; clubId = 10; firstName = "Calvin"; lastName = "Bassey"; shirtNumber = 3; valueQuarterMillions = 22; dateOfBirth = 946598400000000000; nationality = 129; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 272; clubId = 10; firstName = "Tosin"; lastName = "Adarabioyo"; shirtNumber = 4; valueQuarterMillions = 38; dateOfBirth = 875059200000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 273; clubId = 10; firstName = "Fodé"; lastName = "Ballo-Touré"; shirtNumber = 12; valueQuarterMillions = 42; dateOfBirth = 852249600000000000; nationality = 61; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 274; clubId = 10; firstName = "Tim"; lastName = "Ream"; shirtNumber = 13; valueQuarterMillions = 42; dateOfBirth = 560390400000000000; nationality = 187; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 275; clubId = 10; firstName = "Timothy"; lastName = "Castagne"; shirtNumber = 21; valueQuarterMillions = 42; dateOfBirth = 818121600000000000; nationality = 17; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 276; clubId = 10; firstName = "Issa"; lastName = "Diop"; shirtNumber = 31; valueQuarterMillions = 34; dateOfBirth = 852768000000000000; nationality = 61; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 277; clubId = 10; firstName = "Antonee"; lastName = "Robinson"; shirtNumber = 33; valueQuarterMillions = 38; dateOfBirth = 876268800000000000; nationality = 187; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 278; clubId = 10; firstName = "Harrison"; lastName = "Reed"; shirtNumber = 6; valueQuarterMillions = 34; dateOfBirth = 791164800000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 279; clubId = 10; firstName = "Tom"; lastName = "Cairney"; shirtNumber = 10; valueQuarterMillions = 50; dateOfBirth = 664329600000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 280; clubId = 10; firstName = "Andreas"; lastName = "Pereira"; shirtNumber = 18; valueQuarterMillions = 42; dateOfBirth = 820454400000000000; nationality = 24; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 281; clubId = 10; firstName = "João"; lastName = "Palhinha"; shirtNumber = 26; valueQuarterMillions = 60; dateOfBirth = 805248000000000000; nationality = 141; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 282; clubId = 10; firstName = "Sasa"; lastName = "Lukic"; shirtNumber = 28; valueQuarterMillions = 42; dateOfBirth = 839894400000000000; nationality = 154; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 283; clubId = 10; firstName = "Raúl"; lastName = "Jiménez"; shirtNumber = 9; valueQuarterMillions = 84; dateOfBirth = 673401600000000000; nationality = 113; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 284; clubId = 10; firstName = "Harry"; lastName = "Wilson"; shirtNumber = 8; valueQuarterMillions = 92; dateOfBirth = 858988800000000000; nationality = 186; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 285; clubId = 10; firstName = "Adama"; lastName = "Traoré"; shirtNumber = 11; valueQuarterMillions = 64; dateOfBirth = 822528000000000000; nationality = 164; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 286; clubId = 10; firstName = "Bobby"; lastName = "De Cordova-Reid"; shirtNumber = 14; valueQuarterMillions = 80; dateOfBirth = 728611200000000000; nationality = 84; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 287; clubId = 10; firstName = "Rodrigo"; lastName = "Muniz"; shirtNumber = 19; valueQuarterMillions = 42; dateOfBirth = 988934400000000000; nationality = 24; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 288; clubId = 10; firstName = ""; lastName = "Willian"; shirtNumber = 20; valueQuarterMillions = 84; dateOfBirth = 587088000000000000; nationality = 24; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 289; clubId = 10; firstName = "Alex"; lastName = "Iwobi"; shirtNumber = 17; valueQuarterMillions = 60; dateOfBirth = 831081600000000000; nationality = 129; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 9; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 290; clubId = 10; firstName = "Carlos"; lastName = "Vinícius"; shirtNumber = 30; valueQuarterMillions = 80; dateOfBirth = 796089600000000000; nationality = 24; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 291; clubId = 10; firstName = "Armando"; lastName = "Broja"; shirtNumber = 18; valueQuarterMillions = 72; dateOfBirth = 1000080000000000000; nationality = 2; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 7; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 292; clubId = 11; firstName = ""; lastName = "Alisson"; shirtNumber = 1; valueQuarterMillions = 84; dateOfBirth = 717984000000000000; nationality = 24; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 293; clubId = 11; firstName = ""; lastName = "Adrián"; shirtNumber = 13; valueQuarterMillions = 14; dateOfBirth = 536630400000000000; nationality = 164; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 294; clubId = 11; firstName = "Caoimhín"; lastName = "Kelleher"; shirtNumber = 62; valueQuarterMillions = 18; dateOfBirth = 911779200000000000; nationality = 81; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 295; clubId = 11; firstName = "Joe"; lastName = "Gomez"; shirtNumber = 2; valueQuarterMillions = 34; dateOfBirth = 864345600000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 296; clubId = 11; firstName = "Virgil"; lastName = "Van Dijk"; shirtNumber = 4; valueQuarterMillions = 130; dateOfBirth = 678931200000000000; nationality = 125; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 297; clubId = 11; firstName = "Ibrahima"; lastName = "Konaté"; shirtNumber = 5; valueQuarterMillions = 60; dateOfBirth = 927590400000000000; nationality = 61; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 298; clubId = 11; firstName = "Konstantinos"; lastName = "Tsimikas"; shirtNumber = 21; valueQuarterMillions = 34; dateOfBirth = 831859200000000000; nationality = 67; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 299; clubId = 11; firstName = "Andrew"; lastName = "Robertson"; shirtNumber = 26; valueQuarterMillions = 140; dateOfBirth = 763344000000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 300; clubId = 11; firstName = "Joel"; lastName = "Matip"; shirtNumber = 32; valueQuarterMillions = 102; dateOfBirth = 681609600000000000; nationality = 31; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 301; clubId = 11; firstName = "Rhys"; lastName = "Williams"; shirtNumber = 46; valueQuarterMillions = 102; dateOfBirth = 681609600000000000; nationality = 31; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 302; clubId = 11; firstName = "Trent"; lastName = "Alexander-Arnold"; shirtNumber = 66; valueQuarterMillions = 182; dateOfBirth = 907718400000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 303; clubId = 11; firstName = "Jarell"; lastName = "Quansah"; shirtNumber = 78; valueQuarterMillions = 22; dateOfBirth = 1043798400000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 304; clubId = 11; firstName = "Conor"; lastName = "Bradley"; shirtNumber = 84; valueQuarterMillions = 22; dateOfBirth = 1057708800000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 305; clubId = 11; firstName = "Wataru"; lastName = "Endō"; shirtNumber = 3; valueQuarterMillions = 84; dateOfBirth = 729216000000000000; nationality = 85; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 306; clubId = 11; firstName = ""; lastName = "Thiago"; shirtNumber = 6; valueQuarterMillions = 68; dateOfBirth = 671328000000000000; nationality = 164; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 307; clubId = 11; firstName = "Dominik"; lastName = "Szoboszlai"; shirtNumber = 8; valueQuarterMillions = 148; dateOfBirth = 972432000000000000; nationality = 75; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 308; clubId = 11; firstName = "Alexis"; lastName = "Mac Allister"; shirtNumber = 10; valueQuarterMillions = 106; dateOfBirth = 914457600000000000; nationality = 7; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 309; clubId = 11; firstName = "Curtis"; lastName = "Jones"; shirtNumber = 17; valueQuarterMillions = 60; dateOfBirth = 980812800000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 310; clubId = 11; firstName = "Harvey"; lastName = "Elliott"; shirtNumber = 19; valueQuarterMillions = 56; dateOfBirth = 1049414400000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 311; clubId = 11; firstName = "Ryan"; lastName = "Gravenberch"; shirtNumber = 38; valueQuarterMillions = 64; dateOfBirth = 1021507200000000000; nationality = 125; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 312; clubId = 11; firstName = "Stefan"; lastName = "Bajcetic"; shirtNumber = 43; valueQuarterMillions = 34; dateOfBirth = 1098403200000000000; nationality = 164; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 313; clubId = 11; firstName = "James"; lastName = "McConnell"; shirtNumber = 53; valueQuarterMillions = 38; dateOfBirth = 1095033600000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 314; clubId = 11; firstName = "Luis"; lastName = "Díaz"; shirtNumber = 7; valueQuarterMillions = 182; dateOfBirth = 853113600000000000; nationality = 37; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 315; clubId = 11; firstName = "Darwin"; lastName = "Núñez"; shirtNumber = 9; valueQuarterMillions = 214; dateOfBirth = 930182400000000000; nationality = 188; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 316; clubId = 11; firstName = "Mohamed"; lastName = "Salah"; shirtNumber = 11; valueQuarterMillions = 404; dateOfBirth = 708566400000000000; nationality = 52; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 317; clubId = 11; firstName = "Cody"; lastName = "Gakpo"; shirtNumber = 18; valueQuarterMillions = 172; dateOfBirth = 926035200000000000; nationality = 125; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 318; clubId = 11; firstName = "Diogo"; lastName = "Jota"; shirtNumber = 20; valueQuarterMillions = 214; dateOfBirth = 849657600000000000; nationality = 141; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 319; clubId = 11; firstName = "Ben"; lastName = "Doak"; shirtNumber = 50; valueQuarterMillions = 42; dateOfBirth = 1131667200000000000; nationality = 186; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 320; clubId = 12; firstName = "James"; lastName = "Shea"; shirtNumber = 1; valueQuarterMillions = 22; dateOfBirth = 677030400000000000; nationality = 186; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 321; clubId = 12; firstName = "Tim"; lastName = "Krul"; shirtNumber = 23; valueQuarterMillions = 38; dateOfBirth = 923097600000000000; nationality = 125; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 322; clubId = 12; firstName = "Thomas"; lastName = "Kaminski"; shirtNumber = 24; valueQuarterMillions = 42; dateOfBirth = 719798400000000000; nationality = 17; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 323; clubId = 12; firstName = "Dan"; lastName = "Potts"; shirtNumber = 3; valueQuarterMillions = 42; dateOfBirth = 766195200000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 324; clubId = 12; firstName = "Tom"; lastName = "Lockyer"; shirtNumber = 4; valueQuarterMillions = 42; dateOfBirth = 786412800000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 325; clubId = 12; firstName = "Mads"; lastName = "Andersen"; shirtNumber = 0; valueQuarterMillions = 22; dateOfBirth = 883180800000000000; nationality = 47; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 326; clubId = 12; firstName = "Issa"; lastName = "Kaboré"; shirtNumber = 0; valueQuarterMillions = 22; dateOfBirth = 989625600000000000; nationality = 27; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 327; clubId = 12; firstName = "Teden"; lastName = "Mengi"; shirtNumber = 43; valueQuarterMillions = 22; dateOfBirth = 1020124800000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 328; clubId = 12; firstName = "Reece"; lastName = "Burke"; shirtNumber = 16; valueQuarterMillions = 42; dateOfBirth = 841622400000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 329; clubId = 12; firstName = "Amari'i"; lastName = "Bell"; shirtNumber = 29; valueQuarterMillions = 42; dateOfBirth = 768096000000000000; nationality = 84; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 330; clubId = 12; firstName = "Gabriel"; lastName = "Osho"; shirtNumber = 32; valueQuarterMillions = 42; dateOfBirth = 903052800000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 331; clubId = 12; firstName = "Alfie"; lastName = "Doughty"; shirtNumber = 45; valueQuarterMillions = 42; dateOfBirth = 945734400000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 332; clubId = 12; firstName = "Ross"; lastName = "Barkley"; shirtNumber = 6; valueQuarterMillions = 64; dateOfBirth = 755049600000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 333; clubId = 12; firstName = "Luke"; lastName = "Berry"; shirtNumber = 8; valueQuarterMillions = 42; dateOfBirth = 710899200000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 334; clubId = 12; firstName = "Marvelous"; lastName = "Nakamba"; shirtNumber = 0; valueQuarterMillions = 42; dateOfBirth = 758937600000000000; nationality = 196; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 335; clubId = 12; firstName = "Tahith"; lastName = "Chong"; shirtNumber = 0; valueQuarterMillions = 64; dateOfBirth = 944265600000000000; nationality = 125; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 336; clubId = 12; firstName = "Pelly"; lastName = "Mpanzu"; shirtNumber = 17; valueQuarterMillions = 64; dateOfBirth = 764294400000000000; nationality = 39; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 337; clubId = 12; firstName = "Jordan"; lastName = "Clark"; shirtNumber = 18; valueQuarterMillions = 42; dateOfBirth = 748656000000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 338; clubId = 12; firstName = "Dion"; lastName = "Pereira"; shirtNumber = 19; valueQuarterMillions = 42; dateOfBirth = 922320000000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 339; clubId = 12; firstName = "Louie"; lastName = "Watson"; shirtNumber = 0; valueQuarterMillions = 42; dateOfBirth = 991872000000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 340; clubId = 12; firstName = "Allan"; lastName = "Campbell"; shirtNumber = 22; valueQuarterMillions = 42; dateOfBirth = 899510400000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 341; clubId = 12; firstName = "Ryan"; lastName = "Giles"; shirtNumber = 0; valueQuarterMillions = 42; dateOfBirth = 948844800000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 342; clubId = 12; firstName = "Albert"; lastName = "Lokonga"; shirtNumber = 23; valueQuarterMillions = 64; dateOfBirth = 940550400000000000; nationality = 17; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 1; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 343; clubId = 12; firstName = "Andros"; lastName = "Townsend"; shirtNumber = 30; valueQuarterMillions = 64; dateOfBirth = 679622400000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 344; clubId = 12; firstName = "Carlton"; lastName = "Morris"; shirtNumber = 9; valueQuarterMillions = 64; dateOfBirth = 819072000000000000; nationality = 186; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 345; clubId = 12; firstName = "Chiedozie"; lastName = "Ogbene"; shirtNumber = 7; valueQuarterMillions = 64; dateOfBirth = 862444800000000000; nationality = 129; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 346; clubId = 12; firstName = "Cauley"; lastName = "Woodrow"; shirtNumber = 10; valueQuarterMillions = 64; dateOfBirth = 786326400000000000; nationality = 186; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 347; clubId = 12; firstName = "Elijah"; lastName = "Adebayo"; shirtNumber = 11; valueQuarterMillions = 64; dateOfBirth = 884131200000000000; nationality = 186; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 348; clubId = 12; firstName = "Jacob"; lastName = "Brown"; shirtNumber = 19; valueQuarterMillions = 64; dateOfBirth = 892166400000000000; nationality = 186; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 349; clubId = 12; firstName = "John"; lastName = "McAtee"; shirtNumber = 21; valueQuarterMillions = 64; dateOfBirth = 932688000000000000; nationality = 186; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 350; clubId = 13; firstName = "Scott"; lastName = "Carson"; shirtNumber = 33; valueQuarterMillions = 14; dateOfBirth = 494553600000000000; nationality = 186; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 351; clubId = 13; firstName = ""; lastName = "Ederson"; shirtNumber = 31; valueQuarterMillions = 80; dateOfBirth = 745545600000000000; nationality = 24; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 352; clubId = 13; firstName = "Stefan"; lastName = "Ortega"; shirtNumber = 18; valueQuarterMillions = 8; dateOfBirth = 721008000000000000; nationality = 65; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 353; clubId = 13; firstName = "Manuel"; lastName = "Akanji"; shirtNumber = 25; valueQuarterMillions = 68; dateOfBirth = 806112000000000000; nationality = 169; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 354; clubId = 13; firstName = "Nathan"; lastName = "Aké"; shirtNumber = 6; valueQuarterMillions = 64; dateOfBirth = 793065600000000000; nationality = 125; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 355; clubId = 13; firstName = "João"; lastName = "Cancelo"; shirtNumber = 7; valueQuarterMillions = 106; dateOfBirth = 769996800000000000; nationality = 141; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 356; clubId = 13; firstName = "Rúben"; lastName = "Dias"; shirtNumber = 3; valueQuarterMillions = 106; dateOfBirth = 863568000000000000; nationality = 141; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 357; clubId = 13; firstName = "Sergio"; lastName = "Gómez"; shirtNumber = 21; valueQuarterMillions = 34; dateOfBirth = 968025600000000000; nationality = 164; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 358; clubId = 13; firstName = "Joško"; lastName = "Gvardiol"; shirtNumber = 24; valueQuarterMillions = 64; dateOfBirth = 1011744000000000000; nationality = 43; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 359; clubId = 13; firstName = "Rico"; lastName = "Lewis"; shirtNumber = 82; valueQuarterMillions = 14; dateOfBirth = 1100995200000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 360; clubId = 13; firstName = "John"; lastName = "Stones"; shirtNumber = 5; valueQuarterMillions = 88; dateOfBirth = 770083200000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 361; clubId = 13; firstName = "Kyle"; lastName = "Walker"; shirtNumber = 2; valueQuarterMillions = 50; dateOfBirth = 643852800000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 362; clubId = 13; firstName = "Oscar"; lastName = "Bobb"; shirtNumber = 52; valueQuarterMillions = 42; dateOfBirth = 1057968000000000000; nationality = 131; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 363; clubId = 13; firstName = "Kevin"; lastName = "De Bruyne"; shirtNumber = 17; valueQuarterMillions = 362; dateOfBirth = 678067200000000000; nationality = 17; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 364; clubId = 13; firstName = "Jérémy"; lastName = "Doku"; shirtNumber = 11; valueQuarterMillions = 126; dateOfBirth = 1022457600000000000; nationality = 17; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 365; clubId = 13; firstName = "Phil"; lastName = "Foden"; shirtNumber = 47; valueQuarterMillions = 190; dateOfBirth = 959472000000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 366; clubId = 13; firstName = "Jack"; lastName = "Grealish"; shirtNumber = 10; valueQuarterMillions = 152; dateOfBirth = 810691200000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 367; clubId = 13; firstName = "Mateo"; lastName = "Kovacic"; shirtNumber = 8; valueQuarterMillions = 60; dateOfBirth = 768182400000000000; nationality = 43; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 368; clubId = 13; firstName = "Matheus"; lastName = "Nunes"; shirtNumber = 27; valueQuarterMillions = 56; dateOfBirth = 904176000000000000; nationality = 141; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 369; clubId = 13; firstName = "Máximo"; lastName = "Perrone"; shirtNumber = 32; valueQuarterMillions = 38; dateOfBirth = 1041897600000000000; nationality = 7; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 370; clubId = 13; firstName = ""; lastName = "Rodri"; shirtNumber = 16; valueQuarterMillions = 88; dateOfBirth = 835401600000000000; nationality = 164; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 371; clubId = 13; firstName = "Bernardo"; lastName = "Silva"; shirtNumber = 20; valueQuarterMillions = 274; dateOfBirth = 776476800000000000; nationality = 141; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 372; clubId = 13; firstName = "Julián"; lastName = "Álvarez"; shirtNumber = 19; valueQuarterMillions = 110; dateOfBirth = 949276800000000000; nationality = 7; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 373; clubId = 13; firstName = "Erling"; lastName = "Haaland"; shirtNumber = 9; valueQuarterMillions = 374; dateOfBirth = 964137600000000000; nationality = 131; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 374; clubId = 14; firstName = "Altay"; lastName = "Bayındır"; shirtNumber = 1; valueQuarterMillions = 22; dateOfBirth = 892512000000000000; nationality = 180; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 375; clubId = 14; firstName = "Tom"; lastName = "Heaton"; shirtNumber = 22; valueQuarterMillions = 14; dateOfBirth = 513907200000000000; nationality = 186; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 376; clubId = 14; firstName = "André"; lastName = "Onana"; shirtNumber = 24; valueQuarterMillions = 64; dateOfBirth = 828403200000000000; nationality = 31; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 377; clubId = 14; firstName = "Victor"; lastName = "Lindelöf"; shirtNumber = 2; valueQuarterMillions = 50; dateOfBirth = 774403200000000000; nationality = 168; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 378; clubId = 14; firstName = "Harry"; lastName = "Maguire"; shirtNumber = 5; valueQuarterMillions = 56; dateOfBirth = 731289600000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 379; clubId = 14; firstName = "Lisandro"; lastName = "Martínez"; shirtNumber = 6; valueQuarterMillions = 64; dateOfBirth = 885081600000000000; nationality = 7; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 380; clubId = 14; firstName = "Tyrell"; lastName = "Malacia"; shirtNumber = 12; valueQuarterMillions = 30; dateOfBirth = 934848000000000000; nationality = 125; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 381; clubId = 14; firstName = "Raphaël"; lastName = "Varane"; shirtNumber = 19; valueQuarterMillions = 56; dateOfBirth = 735696000000000000; nationality = 61; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 382; clubId = 14; firstName = "Diogo"; lastName = "Dalot"; shirtNumber = 20; valueQuarterMillions = 56; dateOfBirth = 921715200000000000; nationality = 141; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 383; clubId = 14; firstName = "Luke"; lastName = "Shaw"; shirtNumber = 23; valueQuarterMillions = 76; dateOfBirth = 805507200000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 384; clubId = 14; firstName = "Aaron"; lastName = "Wan-Bissaka"; shirtNumber = 29; valueQuarterMillions = 34; dateOfBirth = 880502400000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 385; clubId = 14; firstName = "Brandon"; lastName = "Williams"; shirtNumber = 33; valueQuarterMillions = 8; dateOfBirth = 967939200000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 386; clubId = 14; firstName = "Jonny"; lastName = "Evans"; shirtNumber = 35; valueQuarterMillions = 22; dateOfBirth = 568166400000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 387; clubId = 14; firstName = "Willy"; lastName = "Kambwala"; shirtNumber = 53; valueQuarterMillions = 22; dateOfBirth = 1093392000000000000; nationality = 50; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 388; clubId = 14; firstName = "Sofyan"; lastName = "Amrabat"; shirtNumber = 4; valueQuarterMillions = 64; dateOfBirth = 840585600000000000; nationality = 125; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 389; clubId = 14; firstName = "Mason"; lastName = "Mount"; shirtNumber = 7; valueQuarterMillions = 156; dateOfBirth = 915926400000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 390; clubId = 14; firstName = "Bruno"; lastName = "Fernandes"; shirtNumber = 8; valueQuarterMillions = 252; dateOfBirth = 778982400000000000; nationality = 141; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 391; clubId = 14; firstName = "Christian"; lastName = "Eriksen"; shirtNumber = 14; valueQuarterMillions = 114; dateOfBirth = 698025600000000000; nationality = 47; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 392; clubId = 14; firstName = "Amad"; lastName = "Diallo"; shirtNumber = 0; valueQuarterMillions = 42; dateOfBirth = 1026345600000000000; nationality = 42; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 393; clubId = 14; firstName = "Casemiro"; lastName = "Casemiro"; shirtNumber = 18; valueQuarterMillions = 60; dateOfBirth = 698803200000000000; nationality = 24; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 394; clubId = 14; firstName = "Kobbie"; lastName = "Mainoo"; shirtNumber = 37; valueQuarterMillions = 38; dateOfBirth = 1113868800000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 395; clubId = 14; firstName = "Scott"; lastName = "McTominay"; shirtNumber = 39; valueQuarterMillions = 60; dateOfBirth = 850003200000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 396; clubId = 14; firstName = "Anthony"; lastName = "Martial"; shirtNumber = 9; valueQuarterMillions = 118; dateOfBirth = 818121600000000000; nationality = 61; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 397; clubId = 14; firstName = "Marcus"; lastName = "Rashford"; shirtNumber = 10; valueQuarterMillions = 156; dateOfBirth = 878256000000000000; nationality = 186; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 398; clubId = 14; firstName = "Rasmus"; lastName = "Højlund"; shirtNumber = 11; valueQuarterMillions = 148; dateOfBirth = 1044316800000000000; nationality = 47; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 399; clubId = 14; firstName = "Alejandro"; lastName = "Garnacho"; shirtNumber = 17; valueQuarterMillions = 26; dateOfBirth = 1088640000000000000; nationality = 7; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 400; clubId = 14; firstName = ""; lastName = "Antony"; shirtNumber = 21; valueQuarterMillions = 160; dateOfBirth = 951350400000000000; nationality = 24; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 401; clubId = 15; firstName = "Martin"; lastName = "Dúbravka"; shirtNumber = 1; valueQuarterMillions = 26; dateOfBirth = 600825600000000000; nationality = 158; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 402; clubId = 15; firstName = "Mark"; lastName = "Gillespie"; shirtNumber = 29; valueQuarterMillions = 22; dateOfBirth = 701654400000000000; nationality = 186; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 403; clubId = 15; firstName = "Loris"; lastName = "Karius"; shirtNumber = 18; valueQuarterMillions = 18; dateOfBirth = 740707200000000000; nationality = 65; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 404; clubId = 15; firstName = "Nick"; lastName = "Pope"; shirtNumber = 22; valueQuarterMillions = 80; dateOfBirth = 703641600000000000; nationality = 186; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 405; clubId = 15; firstName = "Sven"; lastName = "Botman"; shirtNumber = 4; valueQuarterMillions = 42; dateOfBirth = 947635200000000000; nationality = 125; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 406; clubId = 15; firstName = "Dan"; lastName = "Burn"; shirtNumber = 33; valueQuarterMillions = 42; dateOfBirth = 705369600000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 407; clubId = 15; firstName = "Paul"; lastName = "Dummett"; shirtNumber = 3; valueQuarterMillions = 22; dateOfBirth = 685843200000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 408; clubId = 15; firstName = "Lewis"; lastName = "Hall"; shirtNumber = 67; valueQuarterMillions = 34; dateOfBirth = 1094601600000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 409; clubId = 15; firstName = "Emil"; lastName = "Krafth"; shirtNumber = 17; valueQuarterMillions = 34; dateOfBirth = 775785600000000000; nationality = 168; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 410; clubId = 15; firstName = "Jamaal"; lastName = "Lascelles"; shirtNumber = 6; valueQuarterMillions = 34; dateOfBirth = 752976000000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 411; clubId = 15; firstName = "Tino"; lastName = "Livramento"; shirtNumber = 21; valueQuarterMillions = 42; dateOfBirth = 1037059200000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 412; clubId = 15; firstName = "Javier"; lastName = "Manquillo"; shirtNumber = 19; valueQuarterMillions = 30; dateOfBirth = 768096000000000000; nationality = 164; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 413; clubId = 15; firstName = "Fabian"; lastName = "Schär"; shirtNumber = 5; valueQuarterMillions = 68; dateOfBirth = 693187200000000000; nationality = 169; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 414; clubId = 15; firstName = "Matt"; lastName = "Targett"; shirtNumber = 13; valueQuarterMillions = 50; dateOfBirth = 811382400000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 415; clubId = 15; firstName = "Kieran"; lastName = "Trippier"; shirtNumber = 2; valueQuarterMillions = 106; dateOfBirth = 653702400000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 416; clubId = 15; firstName = ""; lastName = "Joelinton"; shirtNumber = 7; valueQuarterMillions = 106; dateOfBirth = 839980800000000000; nationality = 24; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 417; clubId = 15; firstName = "Miguel"; lastName = "Almirón"; shirtNumber = 24; valueQuarterMillions = 80; dateOfBirth = 760838400000000000; nationality = 137; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 418; clubId = 15; firstName = "Elliot"; lastName = "Anderson"; shirtNumber = 32; valueQuarterMillions = 34; dateOfBirth = 1036540800000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 419; clubId = 15; firstName = "Bruno"; lastName = "Guimarães"; shirtNumber = 39; valueQuarterMillions = 84; dateOfBirth = 879638400000000000; nationality = 24; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 420; clubId = 15; firstName = "Sean"; lastName = "Longstaff"; shirtNumber = 36; valueQuarterMillions = 34; dateOfBirth = 878169600000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 421; clubId = 15; firstName = "Lewis"; lastName = "Miley"; shirtNumber = 67; valueQuarterMillions = 42; dateOfBirth = 1146441600000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 422; clubId = 15; firstName = "Jacob"; lastName = "Murphy"; shirtNumber = 23; valueQuarterMillions = 30; dateOfBirth = 793584000000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 423; clubId = 15; firstName = "Matt"; lastName = "Ritchie"; shirtNumber = 11; valueQuarterMillions = 30; dateOfBirth = 621388800000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 424; clubId = 15; firstName = "Sandro"; lastName = "Tonali"; shirtNumber = 8; valueQuarterMillions = 84; dateOfBirth = 957744000000000000; nationality = 83; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 425; clubId = 15; firstName = "Harvey"; lastName = "Barnes"; shirtNumber = 15; valueQuarterMillions = 126; dateOfBirth = 881625600000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 426; clubId = 15; firstName = "Anthony"; lastName = "Gordon"; shirtNumber = 8; valueQuarterMillions = 68; dateOfBirth = 982972800000000000; nationality = 186; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 427; clubId = 15; firstName = "Alexander"; lastName = "Isak"; shirtNumber = 14; valueQuarterMillions = 148; dateOfBirth = 937872000000000000; nationality = 168; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 428; clubId = 15; firstName = "Callum"; lastName = "Wilson"; shirtNumber = 9; valueQuarterMillions = 160; dateOfBirth = 699148800000000000; nationality = 186; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 429; clubId = 16; firstName = "Matt"; lastName = "Turner"; shirtNumber = 1; valueQuarterMillions = 18; dateOfBirth = 772416000000000000; nationality = 187; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 430; clubId = 16; firstName = "Wayne"; lastName = "Hennessey"; shirtNumber = 13; valueQuarterMillions = 18; dateOfBirth = 538444800000000000; nationality = 186; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 431; clubId = 16; firstName = "Odysseas"; lastName = "Vlachodimos"; shirtNumber = 23; valueQuarterMillions = 42; dateOfBirth = 767318400000000000; nationality = 65; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 432; clubId = 16; firstName = "Matz"; lastName = "Sels"; shirtNumber = 26; valueQuarterMillions = 42; dateOfBirth = 699062400000000000; nationality = 17; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 433; clubId = 16; firstName = "Nuno"; lastName = "Tavares"; shirtNumber = 0; valueQuarterMillions = 22; dateOfBirth = 948844800000000000; nationality = 141; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 434; clubId = 16; firstName = "Joe"; lastName = "Worrall"; shirtNumber = 4; valueQuarterMillions = 30; dateOfBirth = 852854400000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 435; clubId = 16; firstName = "Neco"; lastName = "Williams"; shirtNumber = 7; valueQuarterMillions = 14; dateOfBirth = 987120000000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 436; clubId = 16; firstName = "Harry"; lastName = "Toffolo"; shirtNumber = 15; valueQuarterMillions = 34; dateOfBirth = 808790400000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 437; clubId = 16; firstName = ""; lastName = "Felipe"; shirtNumber = 38; valueQuarterMillions = 42; dateOfBirth = 611280000000000000; nationality = 24; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 438; clubId = 16; firstName = "Moussa"; lastName = "Niakhaté"; shirtNumber = 19; valueQuarterMillions = 34; dateOfBirth = 826243200000000000; nationality = 153; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 439; clubId = 16; firstName = "Gonzalo"; lastName = "Montiel"; shirtNumber = 29; valueQuarterMillions = 42; dateOfBirth = 852076800000000000; nationality = 7; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 440; clubId = 16; firstName = "Willy"; lastName = "Boly"; shirtNumber = 30; valueQuarterMillions = 26; dateOfBirth = 665539200000000000; nationality = 42; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 441; clubId = 16; firstName = "Andrew"; lastName = "Omobamidele"; shirtNumber = 32; valueQuarterMillions = 42; dateOfBirth = 1024790400000000000; nationality = 81; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 442; clubId = 16; firstName = ""; lastName = "Murillo"; shirtNumber = 40; valueQuarterMillions = 42; dateOfBirth = 1025740800000000000; nationality = 24; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 443; clubId = 16; firstName = "Ola"; lastName = "Aina"; shirtNumber = 43; valueQuarterMillions = 42; dateOfBirth = 844732800000000000; nationality = 125; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 444; clubId = 16; firstName = "Ibrahim"; lastName = "Sangaré"; shirtNumber = 6; valueQuarterMillions = 64; dateOfBirth = 881020800000000000; nationality = 42; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 445; clubId = 16; firstName = "Cheikhou"; lastName = "Kouyaté"; shirtNumber = 21; valueQuarterMillions = 38; dateOfBirth = 630201600000000000; nationality = 153; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 446; clubId = 16; firstName = "Morgan"; lastName = "Gibbs-White"; shirtNumber = 10; valueQuarterMillions = 84; dateOfBirth = 948931200000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 447; clubId = 16; firstName = "Nicolás"; lastName = "Domínguez"; shirtNumber = 16; valueQuarterMillions = 64; dateOfBirth = 898992000000000000; nationality = 7; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 448; clubId = 16; firstName = "Giovanni"; lastName = "Reyna"; shirtNumber = 20; valueQuarterMillions = 64; dateOfBirth = 1037145600000000000; nationality = 187; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 449; clubId = 16; firstName = "Ryan"; lastName = "Yates"; shirtNumber = 22; valueQuarterMillions = 64; dateOfBirth = 880070400000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 450; clubId = 16; firstName = ""; lastName = "Danilo"; shirtNumber = 28; valueQuarterMillions = 42; dateOfBirth = 679536000000000000; nationality = 24; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 451; clubId = 16; firstName = "Taiwo"; lastName = "Awoniyi"; shirtNumber = 9; valueQuarterMillions = 88; dateOfBirth = 871344000000000000; nationality = 129; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 452; clubId = 16; firstName = "Chris"; lastName = "Wood"; shirtNumber = 11; valueQuarterMillions = 64; dateOfBirth = 692064000000000000; nationality = 126; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 453; clubId = 16; firstName = "Callum"; lastName = "Hudson-Odoi"; shirtNumber = 0; valueQuarterMillions = 42; dateOfBirth = 973555200000000000; nationality = 186; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 454; clubId = 16; firstName = "Anthony"; lastName = "Elanga"; shirtNumber = 21; valueQuarterMillions = 64; dateOfBirth = 1019865600000000000; nationality = 168; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 455; clubId = 16; firstName = "Divock"; lastName = "Origi"; shirtNumber = 27; valueQuarterMillions = 64; dateOfBirth = 798163200000000000; nationality = 17; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 456; clubId = 16; firstName = "Rodrigo"; lastName = "Ribeiro"; shirtNumber = 37; valueQuarterMillions = 42; dateOfBirth = 1114646400000000000; nationality = 141; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 457; clubId = 17; firstName = "Adam"; lastName = "Davies"; shirtNumber = 1; valueQuarterMillions = 22; dateOfBirth = 711331200000000000; nationality = 186; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 458; clubId = 17; firstName = "Wes"; lastName = "Foderingham"; shirtNumber = 18; valueQuarterMillions = 22; dateOfBirth = 663811200000000000; nationality = 186; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 459; clubId = 17; firstName = "Jordan"; lastName = "Amissah"; shirtNumber = 37; valueQuarterMillions = 22; dateOfBirth = 996710400000000000; nationality = 65; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 460; clubId = 17; firstName = "George"; lastName = "Baldock"; shirtNumber = 2; valueQuarterMillions = 42; dateOfBirth = 731635200000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 461; clubId = 17; firstName = "Max"; lastName = "Lowe"; shirtNumber = 3; valueQuarterMillions = 42; dateOfBirth = 863308800000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 462; clubId = 17; firstName = "Auston"; lastName = "Trusty"; shirtNumber = 5; valueQuarterMillions = 22; dateOfBirth = 902880000000000000; nationality = 187; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 463; clubId = 17; firstName = "Chris"; lastName = "Basham"; shirtNumber = 6; valueQuarterMillions = 42; dateOfBirth = 585360000000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 464; clubId = 17; firstName = "John"; lastName = "Egan"; shirtNumber = 12; valueQuarterMillions = 42; dateOfBirth = 719539200000000000; nationality = 81; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 465; clubId = 17; firstName = "Anel"; lastName = "Ahmedhodzic"; shirtNumber = 15; valueQuarterMillions = 42; dateOfBirth = 922406400000000000; nationality = 22; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 466; clubId = 17; firstName = "Jack"; lastName = "Robinson"; shirtNumber = 19; valueQuarterMillions = 42; dateOfBirth = 746841600000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 467; clubId = 17; firstName = "Jayden"; lastName = "Bogle"; shirtNumber = 20; valueQuarterMillions = 42; dateOfBirth = 964656000000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 468; clubId = 17; firstName = "Yasser"; lastName = "Larouci"; shirtNumber = 27; valueQuarterMillions = 42; dateOfBirth = 978307200000000000; nationality = 3; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 469; clubId = 17; firstName = "Rhys"; lastName = "Norrington-Davies"; shirtNumber = 33; valueQuarterMillions = 42; dateOfBirth = 924739200000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 470; clubId = 17; firstName = "Mason"; lastName = "Holgate"; shirtNumber = 4; valueQuarterMillions = 30; dateOfBirth = 845942400000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 9; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 471; clubId = 17; firstName = "Gustavo"; lastName = "Hamer"; shirtNumber = 8; valueQuarterMillions = 64; dateOfBirth = 867110400000000000; nationality = 24; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 472; clubId = 17; firstName = "Oliver"; lastName = "Norwood"; shirtNumber = 16; valueQuarterMillions = 42; dateOfBirth = 671414400000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 473; clubId = 17; firstName = "Ismaila"; lastName = "Coulibaly"; shirtNumber = 17; valueQuarterMillions = 42; dateOfBirth = 977702400000000000; nationality = 108; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 474; clubId = 17; firstName = "Vinícius"; lastName = "Souza"; shirtNumber = 21; valueQuarterMillions = 64; dateOfBirth = 929577600000000000; nationality = 24; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 475; clubId = 17; firstName = "Tom"; lastName = "Davies"; shirtNumber = 22; valueQuarterMillions = 64; dateOfBirth = 899164800000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 476; clubId = 17; firstName = "Ben"; lastName = "Osborne"; shirtNumber = 23; valueQuarterMillions = 42; dateOfBirth = 776044800000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 477; clubId = 17; firstName = "Anis"; lastName = "Slimane"; shirtNumber = 25; valueQuarterMillions = 64; dateOfBirth = 984700800000000000; nationality = 47; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 478; clubId = 17; firstName = "James"; lastName = "Mcatee"; shirtNumber = 87; valueQuarterMillions = 42; dateOfBirth = 1034899200000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 13; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 479; clubId = 17; firstName = "Andre"; lastName = "Brooks"; shirtNumber = 35; valueQuarterMillions = 42; dateOfBirth = 1061337600000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 480; clubId = 17; firstName = "Rhian"; lastName = "Brewster"; shirtNumber = 7; valueQuarterMillions = 64; dateOfBirth = 954547200000000000; nationality = 186; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 481; clubId = 17; firstName = "Oliver"; lastName = "Mcburnie"; shirtNumber = 9; valueQuarterMillions = 64; dateOfBirth = 833846400000000000; nationality = 186; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 482; clubId = 17; firstName = "Cameron"; lastName = "Archer"; shirtNumber = 35; valueQuarterMillions = 42; dateOfBirth = 1007856000000000000; nationality = 186; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 483; clubId = 17; firstName = "William"; lastName = "Osula"; shirtNumber = 32; valueQuarterMillions = 64; dateOfBirth = 1059955200000000000; nationality = 47; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 484; clubId = 17; firstName = "Daniel"; lastName = "Jebbison"; shirtNumber = 36; valueQuarterMillions = 64; dateOfBirth = 1060732800000000000; nationality = 186; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 485; clubId = 18; firstName = "Guglielmo"; lastName = "Vicario"; shirtNumber = 13; valueQuarterMillions = 64; dateOfBirth = 844646400000000000; nationality = 83; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 486; clubId = 18; firstName = "Fraser"; lastName = "Forster"; shirtNumber = 20; valueQuarterMillions = 18; dateOfBirth = 574560000000000000; nationality = 186; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 487; clubId = 18; firstName = "Brandon"; lastName = "Austin"; shirtNumber = 40; valueQuarterMillions = 18; dateOfBirth = 915753600000000000; nationality = 186; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 488; clubId = 18; firstName = "Alfie"; lastName = "Whiteman"; shirtNumber = 41; valueQuarterMillions = 22; dateOfBirth = 907286400000000000; nationality = 186; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 489; clubId = 18; firstName = "Emerson"; lastName = "Royal"; shirtNumber = 12; valueQuarterMillions = 56; dateOfBirth = 916272000000000000; nationality = 24; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 490; clubId = 18; firstName = "Pedro"; lastName = "Porro"; shirtNumber = 23; valueQuarterMillions = 56; dateOfBirth = 937180800000000000; nationality = 164; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 491; clubId = 18; firstName = "Cristian "; lastName = "Romero"; shirtNumber = 17; valueQuarterMillions = 42; dateOfBirth = 893635200000000000; nationality = 7; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 492; clubId = 18; firstName = "Ben"; lastName = "Davies"; shirtNumber = 33; valueQuarterMillions = 50; dateOfBirth = 735609600000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 493; clubId = 18; firstName = "Micky"; lastName = "van de Ven"; shirtNumber = 37; valueQuarterMillions = 42; dateOfBirth = 987638400000000000; nationality = 125; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 494; clubId = 18; firstName = "Destiny"; lastName = "Udogie"; shirtNumber = 38; valueQuarterMillions = 42; dateOfBirth = 1038441600000000000; nationality = 83; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 495; clubId = 18; firstName = "Oliver"; lastName = "Skipp"; shirtNumber = 4; valueQuarterMillions = 34; dateOfBirth = 969062400000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 496; clubId = 18; firstName = "Radu"; lastName = "Drăgușin"; shirtNumber = 6; valueQuarterMillions = 38; dateOfBirth = 1012694400000000000; nationality = 143; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 497; clubId = 18; firstName = "Pierre-Emile"; lastName = "Höjbjerg"; shirtNumber = 5; valueQuarterMillions = 76; dateOfBirth = 807580800000000000; nationality = 47; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 498; clubId = 18; firstName = "Heung-min"; lastName = "Son"; shirtNumber = 7; valueQuarterMillions = 336; dateOfBirth = 710553600000000000; nationality = 91; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 499; clubId = 18; firstName = "Yves"; lastName = "Bissouma"; shirtNumber = 38; valueQuarterMillions = 50; dateOfBirth = 841363200000000000; nationality = 108; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 500; clubId = 18; firstName = "Bryan"; lastName = "Gil"; shirtNumber = 11; valueQuarterMillions = 64; dateOfBirth = 981849600000000000; nationality = 164; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 501; clubId = 18; firstName = "James"; lastName = "Maddison"; shirtNumber = 10; valueQuarterMillions = 168; dateOfBirth = 848707200000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 502; clubId = 18; firstName = "Giovani"; lastName = "Lo Celso"; shirtNumber = 18; valueQuarterMillions = 64; dateOfBirth = 829008000000000000; nationality = 7; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 503; clubId = 18; firstName = "Ryan"; lastName = "Sessegnon"; shirtNumber = 19; valueQuarterMillions = 38; dateOfBirth = 958608000000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 504; clubId = 18; firstName = "Dejan"; lastName = "Kulusevski"; shirtNumber = 21; valueQuarterMillions = 182; dateOfBirth = 956620800000000000; nationality = 168; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 505; clubId = 18; firstName = "Brennan"; lastName = "Johnson"; shirtNumber = 20; valueQuarterMillions = 84; dateOfBirth = 990576000000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 506; clubId = 18; firstName = "Manor"; lastName = "Solomon"; shirtNumber = 0; valueQuarterMillions = 60; dateOfBirth = 932774400000000000; nationality = 82; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 507; clubId = 18; firstName = "Pape"; lastName = "Matar Sarr"; shirtNumber = 29; valueQuarterMillions = 30; dateOfBirth = 1031961600000000000; nationality = 153; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 508; clubId = 18; firstName = "Rodrigo"; lastName = "Bentancur"; shirtNumber = 30; valueQuarterMillions = 76; dateOfBirth = 867196800000000000; nationality = 188; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 509; clubId = 18; firstName = ""; lastName = "Richarlison"; shirtNumber = 9; valueQuarterMillions = 206; dateOfBirth = 868492800000000000; nationality = 24; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 510; clubId = 18; firstName = "Timo"; lastName = "Werner"; shirtNumber = 16; valueQuarterMillions = 126; dateOfBirth = 826070400000000000; nationality = 65; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 511; clubId = 18; firstName = "Jamie"; lastName = "Donley"; shirtNumber = 63; valueQuarterMillions = 42; dateOfBirth = 1104710400000000000; nationality = 186; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 512; clubId = 19; firstName = "Lukasz"; lastName = "Fabianski"; shirtNumber = 1; valueQuarterMillions = 60; dateOfBirth = 482630400000000000; nationality = 140; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 513; clubId = 19; firstName = "Alphonse"; lastName = "Areola"; shirtNumber = 23; valueQuarterMillions = 34; dateOfBirth = 730771200000000000; nationality = 61; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 514; clubId = 19; firstName = "Joseph"; lastName = "Anang"; shirtNumber = 49; valueQuarterMillions = 22; dateOfBirth = 960422400000000000; nationality = 66; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 515; clubId = 19; firstName = "Ben"; lastName = "Johnson"; shirtNumber = 2; valueQuarterMillions = 38; dateOfBirth = 948672000000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 516; clubId = 19; firstName = "Aaron"; lastName = "Cresswell"; shirtNumber = 3; valueQuarterMillions = 50; dateOfBirth = 629683200000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 517; clubId = 19; firstName = "Kurt"; lastName = "Zouma"; shirtNumber = 4; valueQuarterMillions = 38; dateOfBirth = 783216000000000000; nationality = 61; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 518; clubId = 19; firstName = "Vladimir"; lastName = "Coufal"; shirtNumber = 5; valueQuarterMillions = 22; dateOfBirth = 714441600000000000; nationality = 46; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 519; clubId = 19; firstName = "Konstantinos"; lastName = "Mavropanos"; shirtNumber = 15; valueQuarterMillions = 42; dateOfBirth = 881798400000000000; nationality = 67; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 520; clubId = 19; firstName = "Angelo"; lastName = "Ogbonna"; shirtNumber = 21; valueQuarterMillions = 38; dateOfBirth = 580348800000000000; nationality = 83; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 521; clubId = 19; firstName = "Thilo"; lastName = "Kehrer"; shirtNumber = 24; valueQuarterMillions = 34; dateOfBirth = 843264000000000000; nationality = 65; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 522; clubId = 19; firstName = "Nayef"; lastName = "Aguerd"; shirtNumber = 27; valueQuarterMillions = 56; dateOfBirth = 828144000000000000; nationality = 119; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 523; clubId = 19; firstName = ""; lastName = "Emerson"; shirtNumber = 33; valueQuarterMillions = 22; dateOfBirth = 775872000000000000; nationality = 83; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 524; clubId = 19; firstName = "James"; lastName = "Ward-Prowse"; shirtNumber = 7; valueQuarterMillions = 106; dateOfBirth = 783648000000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 525; clubId = 19; firstName = "Lucas"; lastName = "Paquetá"; shirtNumber = 11; valueQuarterMillions = 102; dateOfBirth = 872640000000000000; nationality = 24; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 526; clubId = 19; firstName = "Kalvin"; lastName = "Phillips"; shirtNumber = 4; valueQuarterMillions = 14; dateOfBirth = 817862400000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 13; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 527; clubId = 19; firstName = "Mohammed"; lastName = "Kudus"; shirtNumber = 14; valueQuarterMillions = 126; dateOfBirth = 965174400000000000; nationality = 66; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 528; clubId = 19; firstName = "Maxwel"; lastName = "Cornet"; shirtNumber = 14; valueQuarterMillions = 102; dateOfBirth = 835833600000000000; nationality = 42; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 529; clubId = 19; firstName = "Edson"; lastName = "Álvarez"; shirtNumber = 19; valueQuarterMillions = 64; dateOfBirth = 877651200000000000; nationality = 113; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 530; clubId = 19; firstName = "Tomas"; lastName = "Soucek"; shirtNumber = 28; valueQuarterMillions = 64; dateOfBirth = 793843200000000000; nationality = 46; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 531; clubId = 19; firstName = "Michail"; lastName = "Antonio"; shirtNumber = 9; valueQuarterMillions = 144; dateOfBirth = 638582400000000000; nationality = 84; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 532; clubId = 19; firstName = "Danny"; lastName = "Ings"; shirtNumber = 18; valueQuarterMillions = 118; dateOfBirth = 711849600000000000; nationality = 186; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 533; clubId = 19; firstName = "Jarrod"; lastName = "Bowen"; shirtNumber = 20; valueQuarterMillions = 190; dateOfBirth = 851040000000000000; nationality = 186; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 534; clubId = 19; firstName = "Saïd"; lastName = "Benrahma"; shirtNumber = 22; valueQuarterMillions = 84; dateOfBirth = 808012800000000000; nationality = 3; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 535; clubId = 19; firstName = "Divin"; lastName = "Mubama"; shirtNumber = 45; valueQuarterMillions = 42; dateOfBirth = 1098662400000000000; nationality = 186; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 536; clubId = 20; firstName = "José"; lastName = "Sá"; shirtNumber = 1; valueQuarterMillions = 64; dateOfBirth = 727228800000000000; nationality = 141; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 537; clubId = 20; firstName = "Daniel"; lastName = "Bentley"; shirtNumber = 25; valueQuarterMillions = 22; dateOfBirth = 742521600000000000; nationality = 186; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 538; clubId = 20; firstName = "Tom"; lastName = "King"; shirtNumber = 40; valueQuarterMillions = 22; dateOfBirth = 794620800000000000; nationality = 186; position = #Goalkeeper; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 539; clubId = 20; firstName = "Matt"; lastName = "Doherty"; shirtNumber = 2; valueQuarterMillions = 42; dateOfBirth = 695520000000000000; nationality = 81; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 540; clubId = 20; firstName = "Rayan"; lastName = "Aït-Nouri"; shirtNumber = 3; valueQuarterMillions = 26; dateOfBirth = 991785600000000000; nationality = 3; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 541; clubId = 20; firstName = "Santiago"; lastName = "Bueno"; shirtNumber = 4; valueQuarterMillions = 38; dateOfBirth = 910569600000000000; nationality = 188; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 542; clubId = 20; firstName = "Craig"; lastName = "Dawson"; shirtNumber = 15; valueQuarterMillions = 56; dateOfBirth = 641952000000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 543; clubId = 20; firstName = "Hugo"; lastName = "Bueno"; shirtNumber = 17; valueQuarterMillions = 42; dateOfBirth = 1032307200000000000; nationality = 164; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 544; clubId = 20; firstName = "Nélson"; lastName = "Semedo"; shirtNumber = 22; valueQuarterMillions = 64; dateOfBirth = 753408000000000000; nationality = 141; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 545; clubId = 20; firstName = "Max"; lastName = "Kilman"; shirtNumber = 23; valueQuarterMillions = 34; dateOfBirth = 864345600000000000; nationality = 186; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 546; clubId = 20; firstName = ""; lastName = "Toti"; shirtNumber = 24; valueQuarterMillions = 18; dateOfBirth = 916444800000000000; nationality = 141; position = #Defender; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 547; clubId = 20; firstName = "Mario"; lastName = "Lemina"; shirtNumber = 5; valueQuarterMillions = 42; dateOfBirth = 746841600000000000; nationality = 62; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 548; clubId = 20; firstName = "Boubacar"; lastName = "Traoré"; shirtNumber = 6; valueQuarterMillions = 34; dateOfBirth = 998265600000000000; nationality = 108; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 549; clubId = 20; firstName = "João"; lastName = "Gomes"; shirtNumber = 35; valueQuarterMillions = 42; dateOfBirth = 981936000000000000; nationality = 24; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 550; clubId = 20; firstName = "Tommy"; lastName = "Doyle"; shirtNumber = 20; valueQuarterMillions = 38; dateOfBirth = 1003276800000000000; nationality = 186; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 551; clubId = 20; firstName = "Jean-Ricner"; lastName = "Bellegarde"; shirtNumber = 27; valueQuarterMillions = 64; dateOfBirth = 898905600000000000; nationality = 61; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 552; clubId = 20; firstName = "Joe"; lastName = "Hodge"; shirtNumber = 59; valueQuarterMillions = 34; dateOfBirth = 1031961600000000000; nationality = 81; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 553; clubId = 20; firstName = "Pedro"; lastName = "Neto"; shirtNumber = 7; valueQuarterMillions = 60; dateOfBirth = 952560000000000000; nationality = 141; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 554; clubId = 20; firstName = "Hee-chan"; lastName = "Hwang"; shirtNumber = 11; valueQuarterMillions = 92; dateOfBirth = 822614400000000000; nationality = 91; position = #Midfielder; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 555; clubId = 20; firstName = "Matheus"; lastName = "Cunha"; shirtNumber = 12; valueQuarterMillions = 76; dateOfBirth = 927763200000000000; nationality = 24; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 556; clubId = 20; firstName = "Noha"; lastName = "Lemina"; shirtNumber = 14; valueQuarterMillions = 64; dateOfBirth = 1118966400000000000; nationality = 62; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 557; clubId = 20; firstName = "Pablo"; lastName = "Sarabia"; shirtNumber = 21; valueQuarterMillions = 60; dateOfBirth = 705542400000000000; nationality = 164; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 558; clubId = 20; firstName = "Enso"; lastName = "González"; shirtNumber = 30; valueQuarterMillions = 64; dateOfBirth = 1106179200000000000; nationality = 137; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  },
        {id = 559; clubId = 20; firstName = "Nathan"; lastName = "Fraser"; shirtNumber = 63; valueQuarterMillions = 42; dateOfBirth = 1109030400000000000; nationality = 186; position = #Forward; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); latestInjuryEndDate = 0; parentClubId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>(); status = #Active; currentLoanEndDate = 0;  }
      ]);
    };

    public func removeDuplicatePlayer(playerId: T.PlayerId) : async () {
      let player = List.find<T.Player>(players, func(p : T.Player) { p.id == playerId });
      switch (player) {
        case (null) {};
        case (?p) {
          players := List.filter<T.Player>(
            players,
            func(currentPlayer : T.Player) : Bool {
              currentPlayer.id != playerId
            },
          );
        };
      };
    };
  };
};
