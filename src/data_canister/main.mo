  import Array "mo:base/Array";
  import Bool "mo:base/Bool";
  import Buffer "mo:base/Buffer";
  import Int "mo:base/Int";
  import Principal "mo:base/Principal";
  import Result "mo:base/Result";
  import Timer "mo:base/Timer";
  import Order "mo:base/Order";
  import Debug "mo:base/Debug";
  import Text "mo:base/Text";
  import Time "mo:base/Time";
  import Iter "mo:base/Iter";

  import T "../OpenFPL_backend/types";
  import DTOs "../OpenFPL_backend/DTOs";
  import Environment "../OpenFPL_backend/utils/Environment";
  import Utilities "../OpenFPL_backend/utils/utilities";

  actor Self {

    private stable var seasons : [T.Season] = [];
    private stable var nextSeasonId: T.SeasonId = 2; //TODO needs to be dictionary of league id and next season id and lookup
    private stable var nextFixtureId: T.FixtureId = 1;

    private stable var nextClubId : T.ClubId = 23;
    private stable var clubs: [T.Club] = [];
    private stable var relegatedClubs: [T.Club] = [];
    private stable var retiredClubs: [T.Club] = [];

    private stable var nextPlayerId: T.PlayerId = 560;
    private stable var players: [T.Player] = [];
    private stable var retiredPlayers: [T.PlayerId] = [];

    private var setAndBackupTimer : ?((duration : Timer.Duration, callbackName : Text) -> async ()) = null;
    private var removeExpiredTimers : ?(() -> ()) = null;
    
    public shared ({ caller }) func getClubs() : async [T.Club] {
        assert Principal.toText(caller) == Environment.BACKEND_CANISTER_ID;
        let sortedArray = Array.sort(
            clubs,
            func(a : T.Club, b : T.Club) : Order.Order {
            if (a.name < b.name) { return #less };
            if (a.name == b.name) { return #equal };
            return #greater;
            },
        );
        return sortedArray;
    };

    public shared ({ caller }) func getFormerClubs() : async [T.Club] {
        assert Principal.toText(caller) == Environment.BACKEND_CANISTER_ID;
      let sortedArray = Array.sort(
        clubs,
        func(a : T.Club, b : T.Club) : Order.Order {
          if (a.name < b.name) { return #less };
          if (a.name == b.name) { return #equal };
          return #greater;
        },
      );
      return sortedArray;
    };

    public shared ({ caller }) func promoteFormerClub(promoteFormerClubDTO : DTOs.PromoteFormerClubDTO) : async Result.Result<(), T.Error> {
        assert Principal.toText(caller) == Environment.BACKEND_CANISTER_ID;
        let clubToPromote = Array.find<T.Club>(relegatedClubs, func(c : T.Club) { c.id == promoteFormerClubDTO.clubId });


        if (Array.size(clubs) >= 20) {
            return #err(#InvalidData);
        };

        switch (clubToPromote) {
            case (null) {
                return #err(#InvalidData);
            };
            case (?foundClub) {};
        };

        switch (clubToPromote) {
            case (null) {
                return #err(#NotFound);
            };
            case (?club) {
                let clubBuffer = Buffer.fromArray<T.Club>(clubs);
                let relegatedClubsBuffer = Buffer.fromArray<T.Club>(relegatedClubs);
                relegatedClubs := Array.filter<T.Club>(
                    relegatedClubs,
                    func(currentClub : T.Club) : Bool {
                        return currentClub.id != promoteFormerClubDTO.clubId;
                    },
                );
                clubBuffer.add(club);
                clubs := Buffer.toArray(clubBuffer);
                return #ok();
            };
        };
    };

    public shared ({ caller }) func promoteNewClub(promoteNewClubDTO : DTOs.PromoteNewClubDTO) : async Result.Result<(), T.Error> {

        assert Principal.toText(caller) == Environment.BACKEND_CANISTER_ID;

        if (Array.size(clubs) >= 20) {
            return #err(#InvalidData);
        };

        if (Text.size(promoteNewClubDTO.name) > 100) {
            return #err(#InvalidData);
        };

        if (Text.size(promoteNewClubDTO.friendlyName) > 50) {
                return #err(#InvalidData);
        };

        if (Text.size(promoteNewClubDTO.abbreviatedName) != 3) {
                return #err(#InvalidData);
        };

        if (not Utilities.validateHexColor(promoteNewClubDTO.primaryColourHex)) {
            return #err(#InvalidData);
        };

        if (not Utilities.validateHexColor(promoteNewClubDTO.secondaryColourHex)) {
            return #err(#InvalidData);
        };

        if (not Utilities.validateHexColor(promoteNewClubDTO.thirdColourHex)) {
            return #err(#InvalidData);
        };
      
        let newClub : T.Club = {
            id = nextClubId;
            name = promoteNewClubDTO.name;
            friendlyName = promoteNewClubDTO.friendlyName;
            abbreviatedName = promoteNewClubDTO.abbreviatedName;
            primaryColourHex = promoteNewClubDTO.primaryColourHex;
            secondaryColourHex = promoteNewClubDTO.secondaryColourHex;
            thirdColourHex = promoteNewClubDTO.thirdColourHex;
            shirtType = promoteNewClubDTO.shirtType;
        };

        let clubsBuffer = Buffer.fromArray<T.Club>(clubs);
        clubsBuffer.add(newClub);
        clubs := Buffer.toArray(clubsBuffer);
        return #ok();
    };

    public shared ({ caller }) func updateClub(updateClubDTO : DTOs.UpdateClubDTO) : async Result.Result<(), T.Error> {
        assert Principal.toText(caller) == Environment.BACKEND_CANISTER_ID;
        let club = Array.find(
            clubs,
            func(c : T.Club) : Bool {
            return c.id == updateClubDTO.clubId;
            },
        );

        switch (club) {
            case (null) {
                return #err(#InvalidData);
            };
            case (?foundTeam) {

            if (Text.size(foundTeam.name) > 100) {
                return #err(#InvalidData);
            };

            if (Text.size(foundTeam.friendlyName) > 50) {
                return #err(#InvalidData);
            };

            if (Text.size(foundTeam.abbreviatedName) != 3) {
                return #err(#InvalidData);
            };

            if (not Utilities.validateHexColor(foundTeam.primaryColourHex)) {
                return #err(#InvalidData);
            };

            if (not Utilities.validateHexColor(foundTeam.secondaryColourHex)) {
                return #err(#InvalidData);
            };

            if (not Utilities.validateHexColor(foundTeam.thirdColourHex)) {
                return #err(#InvalidData);
            };
            };
        };

        clubs := Array.map<T.Club, T.Club>(
            clubs,
            func(currentClub : T.Club) : T.Club {
            if (currentClub.id == updateClubDTO.clubId) {
                return {
                id = currentClub.id;
                name = updateClubDTO.name;
                friendlyName = updateClubDTO.friendlyName;
                primaryColourHex = updateClubDTO.primaryColourHex;
                secondaryColourHex = updateClubDTO.secondaryColourHex;
                thirdColourHex = updateClubDTO.thirdColourHex;
                abbreviatedName = updateClubDTO.abbreviatedName;
                shirtType = updateClubDTO.shirtType;
                };
            } else {
                return currentClub;
            };
            },
        );
        return #ok();
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

    public func injuryExpired() : async Result.Result<(), T.Error> {

      let playersNoLongerInjured = Array.filter<T.Player>(
        players,
        func(currentPlayer : T.Player) : Bool {
          return currentPlayer.latestInjuryEndDate > 0 and currentPlayer.latestInjuryEndDate <= Time.now();
        },
      );

      for (player in Iter.fromArray(playersNoLongerInjured)) {
        let _ = await executeResetPlayerInjury(player.id);
      };
      return #ok();
    };

    public shared ( { caller } ) func getActivePlayers(currentSeasonId : T.SeasonId, activeClubs: [T.ClubId]) : async Result.Result<[DTOs.PlayerDTO], T.Error> {

      let activeClubPlayers = Array.filter<T.Player>(
        players,
        func(player : T.Player) : Bool {
          let playerInActiveClub = Array.find<T.ClubId>(activeClubs, func(club: T.ClubId){
            club == player.clubId
          });
          return Option.isSome(playerInActiveClub);
        },
      );

      Debug.print("debug_show activeClubPlayers");
      Debug.print(debug_show activeClubPlayers);

      let playerDTOs = Array.map<T.Player, DTOs.PlayerDTO>(
        activeClubPlayers,
        func(player : T.Player) : DTOs.PlayerDTO {

          let season = Array.find<T.PlayerSeason>(
            List.toArray(player.seasons),
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
      return playerDTOs;
    };

    public func getLoanedPlayers(dto: DTOs.ClubFilterDTO) : async Result.Result<[DTOs.PlayerDTO], T.Error> {

      let loanedPlayers = Array.filter<T.Player>(
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

    public func getRetiredPlayers(dto: DTOs.ClubFilterDTO) : async Result.Result<[DTOs.PlayerDTO], T.Error> {

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

    public func getPlayerDetailsForGameweek(dto: DTOs.GameweekFiltersDTO) : async Result.Result<[DTOs.PlayerPointsDTO], T.Error> {
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

    public func getPlayersMap(dto: DTOs.GameweekFiltersDTO) : async Result.Result<[(Nat16, DTOs.PlayerScoreDTO)], T.Error> {
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

    public func getPlayerDetails(dto: DTOs.GetPlayerDetailsDTO) : async Result.Result<DTOs.PlayerDetailDTO, T.Error> {

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

    public func getPlayerPosition(playerId : T.PlayerId) : async Result.Result<?T.PlayerPosition, T.Error> {

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





    public func validateRevaluePlayerUp(revaluePlayerUpDTO : DTOs.RevaluePlayerUpDTO) : async Result.Result<(), T.Error> {
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

    public func validateRevaluePlayerDown(revaluePlayerDownDTO : DTOs.RevaluePlayerDownDTO) : async Result.Result<(), T.Error> {
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

    public func executeRevaluePlayerDown(revaluePlayerDownDTO : DTOs.RevaluePlayerDownDTO, systemState : T.SystemState) : async Result.Result<(), T.Error> {
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

    public func validateLoanPlayer(loanPlayerDTO : DTOs.LoanPlayerDTO, clubs : [T.Club]) : async Result.Result<(), T.Error> {
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

    public func executeLoanPlayer(loanPlayerDTO : DTOs.LoanPlayerDTO, systemState : T.SystemState) : async Result.Result<(), T.Error> {
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

    public func validateTransferPlayer(transferPlayerDTO : DTOs.TransferPlayerDTO, clubs : [T.Club]) : async Result.Result<(), T.Error> {
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

    public func executeTransferPlayer(transferPlayerDTO : DTOs.TransferPlayerDTO, systemState : T.SystemState) : async Result.Result<(), T.Error> {
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

    public func validateRecallPlayer(recallPlayerDTO : DTOs.RecallPlayerDTO) : async Result.Result<(), T.Error> {
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

    public func executeRecallPlayer(recallPlayerDTO : DTOs.RecallPlayerDTO) : async Result.Result<(), T.Error> {
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

    public func executeResetPlayerInjury(playerId : T.PlayerId) : async Result.Result<(), T.Error> {
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

    public func validateCreatePlayer(createPlayerDTO : DTOs.CreatePlayerDTO, clubs : [T.Club]) : async Result.Result<(), T.Error> {

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

    public func validateUpdatePlayer(updatePlayerDTO : DTOs.UpdatePlayerDTO) : async Result.Result<(), T.Error> {

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

    public func executeUpdatePlayer(updatePlayerDTO : DTOs.UpdatePlayerDTO) : async Result.Result<(), T.Error> {
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

    public func validateSetPlayerInjury(setPlayerInjuryDTO : DTOs.SetPlayerInjuryDTO) : async Result.Result<(), T.Error> {
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

    public func validateRetirePlayer(retirePlayerDTO : DTOs.RetirePlayerDTO) : async Result.Result<(), T.Error> {
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

    public func validateUnretirePlayer(unretirePlayerDTO : DTOs.UnretirePlayerDTO) : async Result.Result<(), T.Error> {

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









        //check for admin
    //revalue player up
    //revalue player down
    //submit fixture data
    //add initial season fixtures
    //move fixture
    //postpone fixture
    //reschedule fixture
    //loan fixture
    //transfer player
    //recall player
    //create player
    //update player
    //set player injury
    //validate retire player
    //validate unretire player
    //vlidatre promote former club
    //promote new club
    //validate update club



    public func loanExpiredCallback() : async () {
      await playerComposite.loanExpired();
      await updateCacheHash("players");
    };

    public func injuryExpiredCallback() : async () {
      await playerComposite.injuryExpired();
      await updateCacheHash("players");
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

    public func getAllPlayers(currentSeasonId : T.SeasonId) : async Result.Result<[DTOs.PlayerDTO], T.Error> {

      let playerDTOs = List.map<T.Player, DTOs.PlayerDTO>(
        players,
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


    system func preupgrade() {
    };

    system func postupgrade() {
      
      
      ignore Timer.setTimer<system>(#nanoseconds(Int.abs(1)), postUpgradeCallback);
    };
    
    public shared ({ caller }) func initialiseData () : async (){
      Debug.print("Initialising data");
    };


    private func postUpgradeCallback() : async (){
        await initialiseData();
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
      
      //TODO: Get from canister
    };

    public func setInitialClubs() {
      //TODO
      //clubs := //set from openfpl canister
      relegatedClubs := [];
    };



    private func loanExpiredCallback() : async () {
      await seasonManager.loanExpiredCallback();
      removeExpiredTimers();
    };

    private func injuryExpiredCallback() : async () {
      await seasonManager.injuryExpiredCallback();
      removeExpiredTimers();
    };


      //Player Composite
      stable_next_player_id := seasonManager.getStableNextPlayerId();
      stable_players := seasonManager.getStablePlayers();

      //Club Composite
      stable_clubs := seasonManager.getStableClubs();
      stable_relegated_clubs := seasonManager.getStableRelegatedClubs();
      stable_next_club_id := seasonManager.getStableNextClubId();

      //Season Composite
      stable_seasons := seasonManager.getStableSeasons();
      stable_next_season_id := seasonManager.getStableNextSeasonId();
      stable_next_fixture_id := seasonManager.getStableNextFixtureId();


      //Player Composite
      seasonManager.setStablePlayers(stable_players);
      seasonManager.setStableNextPlayerId(stable_next_player_id);

      //Club Composite
      seasonManager.setStableClubs(stable_clubs);
      seasonManager.setStableRelegatedClubs(stable_relegated_clubs);
      seasonManager.setStableNextClubId(stable_next_club_id);

      //Season Composite
      seasonManager.setStableSeasons(stable_seasons);
      seasonManager.setStableNextSeasonId(stable_next_season_id);
      seasonManager.setStableNextFixtureId(stable_next_fixture_id);


    public func getStableClubs() :  [T.Club] {
      return clubComposite.getStableClubs();
    };

    public func setStableClubs(stable_clubs : [T.Club]) {
      clubComposite.setStableClubs(stable_clubs);
    };

    public func getStableRelegatedClubs() : [T.Club] {
      return clubComposite.getStableRelegatedClubs();
    };

    public func setStableRelegatedClubs(stable_relegated_clubs : [T.Club]) {
      clubComposite.setStableRelegatedClubs(stable_relegated_clubs);
    };

    public func getStableNextClubId() : T.ClubId {
      return clubComposite.getStableNextClubId();
    };

    public func setStableNextClubId(stable_next_club_id : T.ClubId) {
      clubComposite.setStableNextClubId(stable_next_club_id);
    };

    public func getStablePlayers() : [T.Player] {
      return playerComposite.getStablePlayers();
    };

    public func setStablePlayers(stable_players : [T.Player]) {
      playerComposite.setStablePlayers(stable_players);
    };

    public func getStableNextPlayerId() : T.PlayerId {
      return playerComposite.getStableNextPlayerId();
    };

    public func setStableNextPlayerId(stable_next_player_id : T.PlayerId) {
      playerComposite.setStableNextPlayerId(stable_next_player_id);
    };

    public func getStableSeasons() : [T.Season] {
      return seasonComposite.getStableSeasons();
    };

    public func setStableSeasons(stable_seasons : [T.Season]) {
      seasonComposite.setStableSeasons(stable_seasons);
    };

    public func getStableNextSeasonId() : T.SeasonId {
      return seasonComposite.getStableNextSeasonId();
    };

    public func setStableNextSeasonId(stable_next_season_id : T.SeasonId) {
      seasonComposite.setStableNextSeasonId(stable_next_season_id);
    };

    public func getStableNextFixtureId() : T.FixtureId {
      return seasonComposite.getStableNextFixtureId();
    };

    public func setStableNextFixtureId(stable_next_fixture_id : T.FixtureId) {
      seasonComposite.setStableNextFixtureId(stable_next_fixture_id);
    };



    system func postupgrade() {
      
      seasonManager.setBackendCanisterController(Principal.fromActor(Self));
      seasonManager.setTimerBackupFunction(setAndBackupTimer, removeExpiredTimers);
      seasonManager.setRecordSystemEventFunction(recordSystemEvent);

      
      let currentTime = Time.now();
      for (timerInfo in Iter.fromArray(timers)) {
        let remainingDuration = timerInfo.triggerTime - currentTime;

        if (remainingDuration > 0) {
          let duration : Timer.Duration = #nanoseconds(Int.abs(remainingDuration));

          switch (timerInfo.callbackName) {
               case "loanExpired" {
              ignore Timer.setTimer<system>(duration, loanExpiredCallback);
            };
            case "injuryExpired" {
              ignore Timer.setTimer<system>(duration, injuryExpiredCallback);
            };
            case _ {};
          };
        };
      };
      ignore Timer.setTimer<system>(#nanoseconds(Int.abs(1)), postUpgradeCallback);
    };


    private func setAndBackupTimer(duration : Timer.Duration, callbackName : Text) : async () {
      let jobId : Timer.TimerId = switch (callbackName) {
        case "gameweekBeginExpired" {
          Timer.setTimer<system>(duration, gameweekBeginExpiredCallback);
        };
        case "gameKickOffExpired" {
          Timer.setTimer<system>(duration, gameKickOffExpiredCallback);
        };
        case "gameCompletedExpired" {
          Timer.setTimer<system>(duration, gameCompletedExpiredCallback);
        };
        case "loanExpired" {
          Timer.setTimer<system>(duration, loanExpiredCallback);
        };
        case "injuryExpired" {
          Timer.setTimer<system>(duration, injuryExpiredCallback);
        };
        case "transferWindowStart" {
          Timer.setTimer<system>(duration, transferWindowStartCallback);
        };
        case "transferWindowEnd" {
          Timer.setTimer<system>(duration, transferWindowEndCallback);
        };
        case _ {
          Timer.setTimer<system>(duration, defaultCallback);
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

      let newTimerInfo : T.TimerInfo = {
        id = jobId;
        triggerTime = triggerTime;
        callbackName = callbackName;
      };

      var timerBuffer = Buffer.fromArray<T.TimerInfo>(timers);
      timerBuffer.add(newTimerInfo);
      timers := Buffer.toArray(timerBuffer);
    };

    public func initialiseData(){
      let old_openfpl_backend_canister = actor ("bboqb-jiaaa-aaaal-qb6ea-cai") : actor {
        getClubs : () -> async  Result.Result<[DTOs.ClubDTO], T.Error>;
        getFixtures : (dto: DTOs.GetFixturesDTO) -> async  Result.Result<[DTOs.FixtureDTO], T.Error>;
        getPlayers : () -> async  Result.Result<[DTOs.PlayerDTO], T.Error>;
        getCountries : () -> async Result.Result<[DTOs.CountryDTO], T.Error>;
      };

      let clubs = old_openfpl_backend_canister.getClubs();
      let fixtures = old_openfpl_backend_canister.getFixtures();
      let players = old_openfpl_backend_canister.getPlayers();
      let countries = old_openfpl_backend_canister.getCountries();
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


      let data_canister = actor (Environment.DATA_CANISTER_ID) : actor {
        getSeason : (seasonId : T.SeasonId) -> async Result.Result<T.Season, T.Error>;
      };
      let seasonResult = await data_canister.getSeason(submitFixtureDataDTO.seasonId);
      switch(seasonResult){
        case (#ok season){
          let fixture = List.find<T.Fixture>(
            season.fixtures,
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
        case (_){
          return null;
        }
      };

      //TODO get from new data canister

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

  };
