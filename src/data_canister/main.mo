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
  import TrieMap "mo:base/TrieMap";
  import List "mo:base/List";
  import Option "mo:base/Option";

  import T "../shared/types";
  import DTOs "../shared/DTOs";
  import Utilities "../shared/utils/utilities";
  import RequestDTOs "../shared/RequestDTOs";
  import Environment "environment";

  actor Self {
      
    private stable var leagues : [T.FootballLeague] = [
      {
        name = "Premier League";
        abbreviation = "EPL";
        numOfTeams = 20;
        relatedGender = #Male;
        governingBody = "FA";
        countryId = 186;
        formed = 698544000000000000;
      },
      {
        name = "Women's Super League";
        abbreviation = "WSL";
        numOfTeams = 12;
        relatedGender = #Female;
        governingBody = "FA";
        countryId = 186;
        formed = 1269388800000000000;
      }
    ];

    private stable var leagueSeasons: [(T.FootballLeagueId, [T.Season])] = [];
    private stable var leagueClubs: [(T.FootballLeagueId, [T.Club])] = [];
    private stable var leaguePlayers: [(T.FootballLeagueId, [T.Player])] = [];

    private stable var freeAgents: [T.Player] = [];
    private stable var retiredFreeAgents: [T.Player] = [];
    private stable var unknownPlayers: [T.Player] = [];

    private stable var untrackedClubs: [T.Club] = [];
    private stable var clubsInAdministration: [T.Club] = [];

    private func callerAllowed(caller: Principal) : Bool {
      let foundCaller = Array.find<T.PrincipalId>(Environment.APPROVED_FRONTEND_CANISTERS, func(canisterId: T.CanisterId){
        Principal.toText(caller) == canisterId
      });
      return Option.isSome(foundCaller);
    };

    //Getters

    public shared ( {caller} ) func getClubs(leagueId: T.FootballLeagueId) : async Result.Result<[T.Club], T.Error>{
      assert callerAllowed(caller);

      let filteredLeagueClubs = Array.find<(T.FootballLeagueId, [T.Club])>(leagueClubs, 
        func(leagueClubs: (T.FootballLeagueId, [T.Club])){
            leagueClubs.0 == leagueId;
      });

      switch(filteredLeagueClubs){
        case (?foundLeagueClubs){
          let sortedArray = Array.sort<T.Club>(
          foundLeagueClubs.1,
          func(a : T.Club, b : T.Club) : Order.Order {
          if (a.name < b.name) { return #less };
          if (a.name == b.name) { return #equal };
          return #greater;
          },
        );
        return #ok(sortedArray);

        };
        case (null){
          return #err(#NotFound);
        }
      };
    };  

    public shared ( {caller} ) func getSeasons(leagueId: T.FootballLeagueId) : async Result.Result<[DTOs.SeasonDTO], T.Error>{
      assert callerAllowed(caller);

      let filteredLeagueSeasons = Array.find<(T.FootballLeagueId, [T.Season])>(leagueSeasons, 
        func(leagueSeasons: (T.FootballLeagueId, [T.Season])){
            leagueSeasons.0 == leagueId;
      });

      switch(filteredLeagueSeasons){
        case (?foundLeagueSeasons){
          let sortedArray = Array.sort<T.Season>(
          foundLeagueSeasons.1,
          func(a : T.Season, b : T.Season) : Order.Order {
          if (a.id > b.id) { return #greater };
          if (a.id == b.id) { return #equal };
          return #less;
          },
        );
        return #ok(sortedArray);

        };
        case (null){
          return #err(#NotFound);
        }
      };
    };

    public shared ( {caller} ) func getFixtures(dto: RequestDTOs.RequestFixturesDTO) : async Result.Result<[DTOs.FixtureDTO], T.Error>{
      assert callerAllowed(caller);

      let filteredLeagueSeasons = Array.find<(T.FootballLeagueId, [T.Season])>(leagueSeasons, 
        func(leagueSeasons: (T.FootballLeagueId, [T.Season])){
            leagueSeasons.0 == dto.leagueId;
      });

      switch(filteredLeagueSeasons){
        case (?foundLeagueSeasons){          
          
          let filteredSeason = Array.find<T.Season>(foundLeagueSeasons.1, 
            func(leagueSeason: T.Season){
              leagueSeason.id == dto.seasonId;
          });

          switch(filteredSeason){
            case (?foundSeason){
              return #ok(List.toArray(List.map<T.Fixture, DTOs.FixtureDTO>(foundSeason.fixtures, func(fixture: T.Fixture){
                return {
                  awayClubId = fixture.awayClubId;
                  awayGoals  = fixture.awayGoals;
                  events  = List.toArray(fixture.events);
                  gameweek = fixture.gameweek;
                  highestScoringPlayerId = fixture.highestScoringPlayerId;
                  homeClubId = fixture.homeClubId;
                  homeGoals = fixture.homeGoals;
                  id = fixture.id;
                  kickOff = fixture.kickOff;
                  seasonId = fixture.seasonId;
                  status = fixture.status
                }
              })));
            };
            case (null){
              return #err(#NotFound);
            }
          };
        };
        case (null){
          return #err(#NotFound);
        }
      };
    };

    public shared ( {caller} ) func getPostponedFixtures(dto: RequestDTOs.RequestFixturesDTO) : async Result.Result<[DTOs.FixtureDTO], T.Error>{
      assert callerAllowed(caller);

      let filteredLeagueSeasons = Array.find<(T.FootballLeagueId, [T.Season])>(leagueSeasons, 
        func(currentLeagueSeason: (T.FootballLeagueId, [T.Season])){
            currentLeagueSeason.0 == dto.leagueId;
      });

      switch(filteredLeagueSeasons){
        case (?foundLeagueSeasons){          
          
          let filteredSeason = Array.find<T.Season>(foundLeagueSeasons.1, 
            func(leagueSeason: T.Season){
              leagueSeason.id == dto.seasonId;
          });

          switch(filteredSeason){
            case (?foundSeason){
              return #ok(List.toArray(List.map<T.Fixture, DTOs.FixtureDTO>(foundSeason.fixtures, func(fixture: T.Fixture){
                return {
                  awayClubId = fixture.awayClubId;
                  awayGoals  = fixture.awayGoals;
                  events  = List.toArray(fixture.events);
                  gameweek = fixture.gameweek;
                  highestScoringPlayerId = fixture.highestScoringPlayerId;
                  homeClubId = fixture.homeClubId;
                  homeGoals = fixture.homeGoals;
                  id = fixture.id;
                  kickOff = fixture.kickOff;
                  seasonId = fixture.seasonId;
                  status = fixture.status
                }
              })));
            };
            case (null){
              return #err(#NotFound);
            }
          };
        };
        case (null){
          return #err(#NotFound);
        }
      };
    };

    public shared ( {caller} ) func getPlayers(dto: RequestDTOs.RequestPlayersDTO) : async Result.Result<[DTOs.PlayerDTO], T.Error>{
      assert callerAllowed(caller);

      let filteredLeaguePlayers = Array.find<(T.FootballLeagueId, [T.Player])>(leaguePlayers, 
        func(currentLeaguePlayers: (T.FootballLeagueId, [T.Player])){
            currentLeaguePlayers.0 == dto.leagueId;
      });

      switch(filteredLeaguePlayers){
        case (?foundLeaguePlayers){             
          return #ok(Array.map<T.Player, DTOs.PlayerDTO>(foundLeaguePlayers.1, func(player: T.Player){
            
            var totalPoints: Int16 = 0;
            let season = List.find<T.PlayerSeason>(player.seasons, func(season: T.PlayerSeason){
              season.id == dto.seasonId
            });

            switch(season){
              case (?foundSeason){
                totalPoints := foundSeason.totalPoints;
              };
              case null {}
            };
            return {
              clubId = player.clubId;
              dateOfBirth = player.dateOfBirth;
              firstName = player.firstName;
              id = player.id;
              lastName = player.lastName;
              nationality = player.nationality;
              position = player.position;
              shirtNumber = player.shirtNumber;
              status = player.status;
              totalPoints = totalPoints;
              valueQuarterMillions = player.valueQuarterMillions;
            };

          }));
        };
        case (null){
          return #err(#NotFound);
        }
      };
    };

    public shared ( {caller} ) func getAllSeasonPlayers(dto: RequestDTOs.RequestPlayersDTO) : async Result.Result<[DTOs.PlayerDTO], T.Error> {
      assert callerAllowed(caller);

//TODO
  //could get from ids of people who appeared in any fixture 
      let filteredLeaguePlayers = Array.find<(T.FootballLeagueId, [T.Player])>(leaguePlayers, 
        func(currentLeaguePlayers: (T.FootballLeagueId, [T.Player])){
            currentLeaguePlayers.0 == dto.leagueId;
      });

      switch(filteredLeaguePlayers){
        case (?foundLeaguePlayers){             
          return #ok(Array.map<T.Player, DTOs.PlayerDTO>(foundLeaguePlayers.1, func(player: T.Player){
            
            var totalPoints: Int16 = 0;
            let season = List.find<T.PlayerSeason>(player.seasons, func(season: T.PlayerSeason){
              season.id == dto.seasonId
            });

            switch(season){
              case (?foundSeason){
                totalPoints := foundSeason.totalPoints;
              };
              case null {}
            };
            return {
              clubId = player.clubId;
              dateOfBirth = player.dateOfBirth;
              firstName = player.firstName;
              id = player.id;
              lastName = player.lastName;
              nationality = player.nationality;
              position = player.position;
              shirtNumber = player.shirtNumber;
              status = player.status;
              totalPoints = totalPoints;
              valueQuarterMillions = player.valueQuarterMillions;
            };

          }));
        };
        case (null){
          return #err(#NotFound);
        }
      };
    };

    public shared ( {caller} ) func getPlayerDetails(dto: DTOs.GetPlayerDetailsDTO) : async Result.Result<DTOs.PlayerDetailDTO, T.Error> {

      assert callerAllowed(caller);
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

      let filteredLeaguePlayers = Array.find<(T.FootballLeagueId, [T.Player])>(leaguePlayers, func(leagueWithPlayers: (T.FootballLeagueId, [T.Player])){
        leagueWithPlayers.0 == dto.leagueId
      });

      switch(filteredLeaguePlayers){
        case (?foundLeaguePlayers){

          let foundPlayer = Array.find<T.Player>(foundLeaguePlayers.1, func(player: T.Player){
            player.id == dto.playerId;
          });

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

          return #ok({
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
          });

        };
        case (null){
          return #err(#NotFound);
        }
      };
    };
    
    public shared ( {caller} ) func getPlayerDetailsForGameweek(dto: DTOs.GameweekFiltersDTO) : async Result.Result<[DTOs.PlayerPointsDTO], T.Error>{
      assert callerAllowed(caller);
      var playerDetailsBuffer = Buffer.fromArray<DTOs.PlayerPointsDTO>([]);

      let filteredLeaguePlayers = Array.find<(T.FootballLeagueId, [T.Player])>(leaguePlayers, func(leagueWithPlayers: (T.FootballLeagueId, [T.Player])){
        leagueWithPlayers.0 == dto.leagueId
      });

      switch(filteredLeaguePlayers){
        case (?players){
          label playerDetailsLoop for (player in Iter.fromArray(players.1)) {
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

        return #ok(Buffer.toArray(playerDetailsBuffer));
        };
        case (null){
          return #err(#NotFound);
        }
      };
    };

    public shared ( {caller} ) func getPlayersMap(dto: DTOs.GameweekFiltersDTO) : async Result.Result<[(Nat16, DTOs.PlayerScoreDTO)], T.Error>{
      assert callerAllowed(caller);
      
      var playersMap : TrieMap.TrieMap<Nat16, DTOs.PlayerScoreDTO> = TrieMap.TrieMap<Nat16, DTOs.PlayerScoreDTO>(Utilities.eqNat16, Utilities.hashNat16);
      
      let filteredLeaguePlayers = Array.find<(T.FootballLeagueId, [T.Player])>(leaguePlayers, func(leagueWithPlayers: (T.FootballLeagueId, [T.Player])){
        leagueWithPlayers.0 == dto.leagueId
      });

      switch(filteredLeaguePlayers){
        case (?players){
          label playerMapLoop for (player in Iter.fromArray(players.1)) {
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
          return #ok(Iter.toArray(playersMap.entries()));
        };
        case (null){
          return #err(#NotFound);
        }
      };
    };

    //Validation Functions for Update

    public shared ( {caller} ) func validateRevaluePlayerUp(dto : DTOs.RevaluePlayerUpDTO) : async Result.Result<(), T.Error>{
      assert callerAllowed(caller);
      assert checkPlayerExists(dto.leagueId, dto.playerId);
      return #ok();
    };

    private func checkPlayerExists(leagueId: T.FootballLeagueId, playerId: T.PlayerId) : Bool {
      let playersInLeague = Array.find<(T.FootballLeagueId, [T.Player])>(leaguePlayers, 
        func(foundLeaguePlayers: (T.FootballLeagueId, [T.Player])){
          foundLeaguePlayers.0 == leagueId;
        }
      );

      switch(playersInLeague){
        case (?foundPlayersInLeague){
          let foundPlayer = Array.find<T.Player>(foundPlayersInLeague.1, func(player: T.Player){
            player.id == playerId;
          });
          if(Option.isNull(foundPlayer)){
            return false;
          }
        };
        case (null){
          return false;
        }
      };
      return true;
    };

    public shared ( {caller} ) func validateRevaluePlayerDown(dto : DTOs.RevaluePlayerDownDTO) : async Result.Result<(), T.Error>{
      assert callerAllowed(caller);
      assert checkPlayerExists(dto.leagueId, dto.playerId);
      return #ok();
    };

    public shared ( {caller} ) func validateSubmitFixtureData(dto : DTOs.SubmitFixtureDataDTO) : async Result.Result<(), T.Error>{
      assert callerAllowed(caller);
      assert validatePlayerEvents(dto.playerEventData);
      return #err(#NotFound);
    };

    public shared ( {caller} ) func validateAddInitialFixtures(dto : DTOs.AddInitialFixturesDTO) : async Result.Result<(), T.Error>{
      assert callerAllowed(caller);
      return #err(#NotFound);
    };

    public shared ( {caller} ) func validateMoveFixture(dto : DTOs.MoveFixtureDTO) : async Result.Result<(), T.Error>{
      assert callerAllowed(caller);
      return #err(#NotFound);
    };

    public shared ( {caller} ) func validatePostponeFixture(dto : DTOs.PostponeFixtureDTO) : async Result.Result<(), T.Error>{
      assert callerAllowed(caller);
      return #err(#NotFound);
    };

    public shared ( {caller} ) func validateRescehduleFixture(dto : DTOs.RescheduleFixtureDTO) : async Result.Result<(), T.Error>{
      assert callerAllowed(caller);
      return #err(#NotFound);
    };

    public shared ( {caller} ) func validateUpdateClub(dto : DTOs.UpdateClubDTO) : async Result.Result<(), T.Error>{
      assert callerAllowed(caller);
      return #err(#NotFound);
    };

    public shared ( {caller} ) func validateLoanPlayer(loanPlayerDTO : DTOs.LoanPlayerDTO) : async Result.Result<(), T.Error>{
      assert callerAllowed(caller);
      assert checkPlayerExists(dto.leagueId, dto.playerId);


      if (loanPlayerDTO.loanEndDate <= Time.now()) {
        return #err(#InvalidData);
      };

      let player = List.find<T.Player>(
        players,
        func(p : T.Player) : Bool {
          return p.id == loanPlayerDTO.playerId;
        },
      );

      switch (player) {
        case (null) {
        return #err(#InvalidData);
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

    public shared ( {caller} ) func validateTransferPlayer(transferPlayerDTO : DTOs.TransferPlayerDTO) : async Result.Result<(), T.Error>{
      assert callerAllowed(caller);
      assert checkPlayerExists(dto.leagueId, dto.playerId);

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

    public shared ( {caller} ) func validateRecallPlayer(recallPlayerDTO : DTOs.RecallPlayerDTO) : async Result.Result<(), T.Error> {
      
      assert callerAllowed(caller);
      assert checkPlayerExists(dto.leagueId, dto.playerId);
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

    public shared ( {caller} ) func validateCreatePlayer(createPlayerDTO : DTOs.CreatePlayerDTO) : async Result.Result<(), T.Error>{
      assert callerAllowed(caller);
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

    public shared ( {caller} ) func validateUpdatePlayer(updatePlayerDTO : DTOs.UpdatePlayerDTO) : async Result.Result<(), T.Error>{
      assert callerAllowed(caller);
      assert checkPlayerExists(dto.leagueId, dto.playerId);
      

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

    public shared ( {caller} ) func validateSetPlayerInjury(setPlayerInjuryDTO : DTOs.SetPlayerInjuryDTO) : async Result.Result<(), T.Error>{
      assert callerAllowed(caller);
      assert checkPlayerExists(dto.leagueId, dto.playerId);
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

    public shared ( {caller} ) func validateRetirePlayer(retirePlayerDTO : DTOs.RetirePlayerDTO) : async Result.Result<(), T.Error>{
      assert callerAllowed(caller);
      assert checkPlayerExists(dto.leagueId, dto.playerId);
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

    public shared ( {caller} ) func validateUnretirePlayer(unretirePlayerDTO : DTOs.UnretirePlayerDTO) : async Result.Result<(), T.Error>{
      assert callerAllowed(caller);
      assert checkPlayerExists(dto.leagueId, dto.playerId);

      let playerToUnretire = List.find<T.Player>(players, func(p : T.Player) { p.id == unretirePlayerDTO.playerId and p.status == #Retired });
      switch (playerToUnretire) {
        case (null) {
          return #Err("Invalid: Cannot find player");
        };
        case (?foundPlayer) {};
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

    //Governance execution functions
    
    public shared ( {caller} ) func revaluePlayerUp(dto : DTOs.RevaluePlayerUpDTO) : async Result.Result<(), T.Error>{
      assert callerAllowed(caller);

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

      return #err(#NotFound);
    };

    public shared ( {caller} ) func revaluePlayerDown(dto : DTOs.RevaluePlayerDownDTO) : async Result.Result<(), T.Error>{
      assert callerAllowed(caller);
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
      return #err(#NotFound);
    };

    public shared ( {caller} ) func loanPlayer(dto : DTOs.LoanPlayerDTO) : async Result.Result<(), T.Error>{
      assert callerAllowed(caller);
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
      return #err(#NotFound);
    };

    public shared ( {caller} ) func transferPlayer(dto : DTOs.TransferPlayerDTO) : async Result.Result<(), T.Error>{
      assert callerAllowed(caller);
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
            status := #FreeAgent;
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
      return #err(#NotFound);
    };

    public shared ( {caller} ) func recallPlayer(dto : DTOs.RecallPlayerDTO) : async Result.Result<(), T.Error>{
      assert callerAllowed(caller);
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
      return #err(#NotFound);
    };

    public shared ( {caller} ) func createPlayer(dto : DTOs.CreatePlayerDTO) : async Result.Result<(), T.Error>{
      assert callerAllowed(caller);
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
      return #err(#NotFound);
    };

    public shared ( {caller} ) func updatePlayer(dto : DTOs.UpdatePlayerDTO) : async Result.Result<(), T.Error>{
      assert callerAllowed(caller);
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
      return #err(#NotFound);
    };

    public shared ( {caller} ) func setPlayerInjury(dto : DTOs.SetPlayerInjuryDTO) : async Result.Result<(), T.Error>{
      assert callerAllowed(caller);
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
      return #err(#NotFound);
    };

    public shared ( {caller} ) func retirePlayer(dto : DTOs.RetirePlayerDTO) : async Result.Result<(), T.Error>{
      assert callerAllowed(caller);
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
      return #err(#NotFound);
    };

    public shared ( {caller} ) func unretirePlayer(dto : DTOs.UnretirePlayerDTO) : async Result.Result<(), T.Error>{
      assert callerAllowed(caller);
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
      return #err(#NotFound);
    };

    public shared ({ caller }) func promoteNewClub(promoteNewClubDTO : DTOs.PromoteNewClubDTO) : async Result.Result<(), T.Error> {
      assert callerAllowed(caller);


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
      assert callerAllowed(caller);
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

    //Either timer callback

    public shared ( {caller} ) func loanExpired() : async (){
      assert callerAllowed(caller);
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

    public shared ( {caller} ) func injuryExpired() : async (){
      assert callerAllowed(caller);

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

    //Game Update Functions

    public shared ( {caller} ) func createNewSeason(systemState : T.SystemState) {
      assert callerAllowed(caller);
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

    public shared ( {caller} ) func addEventsToFixture(playerEventData : [T.PlayerEventData], seasonId : T.SeasonId, fixtureId : T.FixtureId) : async () {
      
      assert callerAllowed(caller);
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

    public shared ( {caller} ) func setGameScore(seasonId: T.SeasonId, fixtureId: T.FixtureId){
      assert callerAllowed(caller);
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

    public shared ( {caller} ) func setFixtureToComplete(seasonId: T.SeasonId, fixtureId: T.FixtureId){
      assert callerAllowed(caller);
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

    public shared ( {caller} ) func setFixtureToFinalised(seasonId: T.SeasonId, fixtureId: T.FixtureId) {
      assert callerAllowed(caller);
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

    public shared ( {caller} ) func addEventsToPlayers(playerEventData : [T.PlayerEventData], seasonId : T.SeasonId, gameweek : T.GameweekNumber) : async () {

      assert callerAllowed(caller);
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

    //Game State Check Functions

    public shared ( {caller} ) func checkGameweekComplete(seasonId: T.SeasonId, gameweek: T.GameweekNumber) : async Bool {
      assert callerAllowed(caller);
      let season = List.find(
        seasons,
        func(season : T.Season) : Bool {
          return season.id == seasonId;
        },
      );
      switch (season) {
        case (null) { return false };
        case (?foundSeason) {
          let fixtures = List.filter<T.Fixture>(
            foundSeason.fixtures,
            func(fixture : T.Fixture) : Bool {
              return fixture.gameweek == gameweek;
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

    public shared ( {caller} ) func checkMonthComplete(seasonId: T.SeasonId, month: T.CalendarMonth, gameweek: T.GameweekNumber) : async Bool {

      assert callerAllowed(caller);
      let currentSeason = List.find(
        seasons,
        func(season : T.Season) : Bool {
          return season.id == seasonId;
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
                return fixture.gameweek == gameweek;
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
                return fixture.gameweek == gameweek + 1;
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

          return fixtureMonth > month;
        };
      };

      return false;
    };

    public shared ( {caller} ) func checkSeasonComplete(seasonId: T.SeasonId) : async Bool {

      assert callerAllowed(caller);
      if (systemState.calculationGameweek != 38) {
        return false;
      };

      let currentSeason = List.find(
        seasons,
        func(season : T.Season) : Bool {
          return season.id == seasonId;
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

    system func preupgrade() {

    };

    system func postupgrade() {
      //timer backup stuff

    };

  };
