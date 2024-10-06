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
  import Countries "../shared/Countries";

  actor Self {
      
    private stable var dataInitialised = false;

    private stable var leagues : [T.FootballLeague] = [
      {
        id = 1;
        name = "Premier League";
        abbreviation = "EPL";
        numOfTeams = 20;
        relatedGender = #Male;
        governingBody = "FA";
        countryId = 186;
        formed = 698544000000000000;
      },
      {
        id = 2;
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

    
    private stable var retiredLeaguePlayers: [(T.FootballLeagueId, [T.Player])] = [];
    private stable var retiredFreeAgents: [T.Player] = [];
    private stable var unknownPlayers: [T.Player] = [];

    private stable var untrackedClubs: [T.Club] = [];
    private stable var clubsInAdministration: [T.Club] = [];

    private stable var nextPlayerId: T.PlayerId = 1;

    private stable var timers : [T.TimerInfo] = [];

    private func callerAllowed(caller: Principal) : Bool {
      let foundCaller = Array.find<T.PrincipalId>(Environment.APPROVED_FRONTEND_CANISTERS, func(canisterId: T.CanisterId) : Bool {
        Principal.toText(caller) == canisterId
      });
      return Option.isSome(foundCaller);
    };

    //Getters

    public shared ( {caller} ) func getLeagues() : async Result.Result<[T.FootballLeague], T.Error>{
      //assert callerAllowed(caller);
      return #ok(leagues);
    };  


    public shared ( {caller} ) func getClubs(leagueId: T.FootballLeagueId) : async Result.Result<[T.Club], T.Error>{
      //assert callerAllowed(caller);

      let filteredLeagueClubs = Array.find<(T.FootballLeagueId, [T.Club])>(leagueClubs, 
        func(leagueClubs: (T.FootballLeagueId, [T.Club])) : Bool {
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
      //assert callerAllowed(caller);

      let filteredLeagueSeasons = Array.find<(T.FootballLeagueId, [T.Season])>(leagueSeasons, 
        func(leagueSeason: (T.FootballLeagueId, [T.Season])) : Bool{
            leagueSeason.0 == leagueId;
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

    public shared ( {caller} ) func getFixtures(leagueId: T.FootballLeagueId, dto: RequestDTOs.RequestFixturesDTO) : async Result.Result<[DTOs.FixtureDTO], T.Error>{
      //assert callerAllowed(caller);
      Debug.print("get fixtures");
      Debug.print(debug_show leagueId);
      Debug.print(debug_show dto);
      let filteredLeagueSeasons = Array.find<(T.FootballLeagueId, [T.Season])>(leagueSeasons, 
        func(leagueSeason: (T.FootballLeagueId, [T.Season])) : Bool{
            leagueSeason.0 == leagueId;
      });

      Debug.print("filtered league seasons");
      Debug.print(debug_show filteredLeagueSeasons);
      switch(filteredLeagueSeasons){
        case (?foundLeagueSeasons){          
          
          Debug.print("found league seasons");
          Debug.print(debug_show foundLeagueSeasons);
          let filteredSeason = Array.find<T.Season>(foundLeagueSeasons.1, 
            func(leagueSeason: T.Season) : Bool{
              leagueSeason.id == dto.seasonId;
          });
          Debug.print("filtered season");
          Debug.print(debug_show filteredSeason);

          switch(filteredSeason){
            case (?foundSeason){
              Debug.print("found season");
              Debug.print(debug_show foundSeason);
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

    public shared ( {caller} ) func getPostponedFixtures(leagueId: T.FootballLeagueId, dto: RequestDTOs.RequestFixturesDTO) : async Result.Result<[DTOs.FixtureDTO], T.Error>{
      //assert callerAllowed(caller);

      let filteredLeagueSeasons = Array.find<(T.FootballLeagueId, [T.Season])>(leagueSeasons, 
        func(currentLeagueSeason: (T.FootballLeagueId, [T.Season])) : Bool{
            currentLeagueSeason.0 == leagueId;
      });

      switch(filteredLeagueSeasons){
        case (?foundLeagueSeasons){          
          
          let filteredSeason = Array.find<T.Season>(foundLeagueSeasons.1, 
            func(leagueSeason: T.Season) : Bool{
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

    public shared ( {caller} ) func getPlayers(leagueId: T.FootballLeagueId, dto: RequestDTOs.RequestPlayersDTO) : async Result.Result<[DTOs.PlayerDTO], T.Error>{
      //assert callerAllowed(caller);

      let filteredLeaguePlayers = Array.find<(T.FootballLeagueId, [T.Player])>(leaguePlayers, 
        func(currentLeaguePlayers: (T.FootballLeagueId, [T.Player])) : Bool{
            currentLeaguePlayers.0 == leagueId;
      });

      switch(filteredLeaguePlayers){
        case (?foundLeaguePlayers){             
          return #ok(Array.map<T.Player, DTOs.PlayerDTO>(foundLeaguePlayers.1, func(player: T.Player){
            
            var totalPoints: Int16 = 0;
            let season = List.find<T.PlayerSeason>(player.seasons, func(season: T.PlayerSeason) : Bool{
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

    public shared ( {caller} ) func getLoanedPlayers(leagueId: T.FootballLeagueId, dto: DTOs.ClubFilterDTO) : async Result.Result<[DTOs.PlayerDTO], T.Error>{
      //assert callerAllowed(caller);

      let filteredLeaguePlayers = Array.find<(T.FootballLeagueId, [T.Player])>(leaguePlayers, 
        func(currentLeaguePlayers: (T.FootballLeagueId, [T.Player])) : Bool{
            currentLeaguePlayers.0 == leagueId;
      });

      switch(filteredLeaguePlayers){
        case (?foundLeaguePlayers){             

          let loanedClubPlayers = Array.filter<T.Player>(foundLeaguePlayers.1, func(player: T.Player) : Bool {
            player.status == #OnLoan and player.clubId == dto.clubId
          });

          return #ok(Array.map<T.Player, DTOs.PlayerDTO>(loanedClubPlayers, func(player: T.Player){
            
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
              totalPoints = 0;
              valueQuarterMillions = player.valueQuarterMillions;
            };

          }));
        };
        case (null){
          return #err(#NotFound);
        }
      };
    };

    public shared ( {caller} ) func getRetiredPlayers(leagueId: T.FootballLeagueId, dto: DTOs.ClubFilterDTO) : async Result.Result<[DTOs.PlayerDTO], T.Error>{
      //assert callerAllowed(caller);
      
      let filteredLeaguePlayers = Array.find<(T.FootballLeagueId, [T.Player])>(retiredLeaguePlayers, 
        func(currentLeaguePlayers: (T.FootballLeagueId, [T.Player])) : Bool{
            currentLeaguePlayers.0 == leagueId;
      });

      switch(filteredLeaguePlayers){
        case (?foundLeaguePlayers){             

          let clubPlayers = Array.filter<T.Player>(foundLeaguePlayers.1, func(player: T.Player) : Bool {
            player.clubId == dto.clubId
          });

          return #ok(Array.map<T.Player, DTOs.PlayerDTO>(clubPlayers, func(player: T.Player){
            
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
              totalPoints = 0;
              valueQuarterMillions = player.valueQuarterMillions;
            };

          }));
        };
        case (null){
          return #err(#NotFound);
        }
      };
    };

    public shared ( {caller} ) func getPlayerDetails(leagueId: T.FootballLeagueId, dto: DTOs.GetPlayerDetailsDTO) : async Result.Result<DTOs.PlayerDetailDTO, T.Error> {
      //assert callerAllowed(caller);

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

      let filteredLeaguePlayers = Array.find<(T.FootballLeagueId, [T.Player])>(leaguePlayers, 
        func(leagueWithPlayers: (T.FootballLeagueId, [T.Player])) : Bool{
        leagueWithPlayers.0 == leagueId
      });

      switch(filteredLeaguePlayers){
        case (?foundLeaguePlayers){

          let foundPlayer = Array.find<T.Player>(foundLeaguePlayers.1, func(player: T.Player) : Bool{
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

              let currentSeason = List.find<T.PlayerSeason>(player.seasons, func(ps : T.PlayerSeason) : Bool { ps.id == dto.seasonId });
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
    
    public shared ( {caller} ) func getPlayerDetailsForGameweek(leagueId: T.FootballLeagueId, dto: DTOs.GameweekFiltersDTO) : async Result.Result<[DTOs.PlayerPointsDTO], T.Error>{
      //assert callerAllowed(caller);

      var playerDetailsBuffer = Buffer.fromArray<DTOs.PlayerPointsDTO>([]);

      let filteredLeaguePlayers = Array.find<(T.FootballLeagueId, [T.Player])>(leaguePlayers, func(leagueWithPlayers: (T.FootballLeagueId, [T.Player])) : Bool{
        leagueWithPlayers.0 == leagueId
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

    public shared ( {caller} ) func getPlayersMap(leagueId: T.FootballLeagueId, dto: DTOs.GameweekFiltersDTO) : async Result.Result<[(Nat16, DTOs.PlayerScoreDTO)], T.Error>{
      //assert callerAllowed(caller);
      
      var playersMap : TrieMap.TrieMap<Nat16, DTOs.PlayerScoreDTO> = TrieMap.TrieMap<Nat16, DTOs.PlayerScoreDTO>(Utilities.eqNat16, Utilities.hashNat16);
      
      let filteredLeaguePlayers = Array.find<(T.FootballLeagueId, [T.Player])>(leaguePlayers, func(leagueWithPlayers: (T.FootballLeagueId, [T.Player])) : Bool {
        leagueWithPlayers.0 == leagueId
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

    public shared ( {caller} ) func validateRevaluePlayerUp(leagueId: T.FootballLeagueId, dto : DTOs.RevaluePlayerUpDTO) : async Result.Result<(), T.Error>{
      //assert callerAllowed(caller);
      assert leagueExists(leagueId);
      assert checkPlayerExists(leagueId, dto.playerId);
      return #ok();
    };

    public shared ( {caller} ) func validateRevaluePlayerDown(leagueId: T.FootballLeagueId, dto : DTOs.RevaluePlayerDownDTO) : async Result.Result<(), T.Error>{
      //assert callerAllowed(caller);
      assert leagueExists(leagueId);
      assert checkPlayerExists(leagueId, dto.playerId);
      return #ok();
    };

    public shared ( {caller} ) func validateSubmitFixtureData(leagueId: T.FootballLeagueId, dto : DTOs.SubmitFixtureDataDTO) : async Result.Result<(), T.Error>{
      //assert callerAllowed(caller);
      assert leagueExists(leagueId);
      assert validatePlayerEvents(dto.playerEventData);
      return #err(#NotFound);
    };

    public shared ( {caller} ) func validateAddInitialFixtures(leagueId: T.FootballLeagueId, dto : DTOs.AddInitialFixturesDTO) : async Result.Result<(), T.Error>{
      //assert callerAllowed(caller);
      assert leagueExists(leagueId);
      //TODO: Add fixtures check
        //should equal the number of teams in the related environment file
      return #err(#NotFound);
    };

    public shared ( {caller} ) func validateMoveFixture(leagueId: T.FootballLeagueId, dto : DTOs.MoveFixtureDTO) : async Result.Result<(), T.Error>{
      //assert callerAllowed(caller);
      assert leagueExists(leagueId);
      //TODO: Add fixture movement check
        //valid gameweek but that can go in a data check module in the backend
      return #err(#NotFound);
    };

    public shared ( {caller} ) func validatePostponeFixture(leagueId: T.FootballLeagueId, dto : DTOs.PostponeFixtureDTO) : async Result.Result<(), T.Error>{
      //assert callerAllowed(caller);
      assert leagueExists(leagueId);
      //TODO
      return #err(#NotFound);
    };

    public shared ( {caller} ) func validateRescehduleFixture(leagueId: T.FootballLeagueId, dto : DTOs.RescheduleFixtureDTO) : async Result.Result<(), T.Error>{
      //assert callerAllowed(caller);
      assert leagueExists(leagueId);
      //TODO
      return #err(#NotFound);
    };

    public shared ( {caller} ) func validateUpdateClub(leagueId: T.FootballLeagueId, dto : DTOs.UpdateClubDTO) : async Result.Result<(), T.Error>{
      //assert callerAllowed(caller);
      assert leagueExists(leagueId);
      //TODO
      return #err(#NotFound);
    };

    public shared ( {caller} ) func validateLoanPlayer(leagueId: T.FootballLeagueId, dto : DTOs.LoanPlayerDTO) : async Result.Result<(), T.Error>{
      //assert callerAllowed(caller);
      assert leagueExists(leagueId);
      assert checkPlayerExists(leagueId, dto.playerId);

      let filteredLeaguePlayers = Array.find<(T.FootballLeagueId, [T.Player])>(leaguePlayers, 
        func(leagueWithPlayers: (T.FootballLeagueId, [T.Player])) : Bool{
        leagueWithPlayers.0 == leagueId
      });

      switch(filteredLeaguePlayers){
        case (?players){
          if (dto.loanEndDate <= Time.now()) {
            return #err(#InvalidData);
          };

          let player = Array.find<T.Player>(players.1, func(currentPlayer: T.Player) : Bool{
            currentPlayer.id == dto.playerId;
          });


          switch (player) {
            case (null) {
            return #err(#InvalidData);
            };
            case (?foundPlayer) {
              if (foundPlayer.status == #OnLoan) {
                return #err(#InvalidData);
              };
            };
          };

          if (dto.loanClubId > 0) {

            let filteredLeagueClubs = Array.find<(T.FootballLeagueId, [T.Club])>(leagueClubs, 
              func(leagueClubs: (T.FootballLeagueId, [T.Club])) : Bool{
                  leagueClubs.0 == leagueId;
            });

            switch(filteredLeagueClubs){
              case (?foundLeagueClubs){

                let loanClub = List.find<T.Club>(
                  List.fromArray(foundLeagueClubs.1),
                  func(club : T.Club) : Bool {
                    return club.id == dto.loanClubId;
                  },
                );

                switch (loanClub) {
                  case (null) {
                    return #err(#InvalidData);
                  };
                  case (?foundTeam) {};
                };
                
                return #ok();

              };
              case (null){
                return #err(#NotFound);
              }
            };     
          };

          return #ok();
          
        };
        case (null){
          return #err(#NotFound);
        }
      };      
    };

    public shared ( {caller} ) func validateTransferPlayer(leagueId: T.FootballLeagueId, dto : DTOs.TransferPlayerDTO) : async Result.Result<(), T.Error>{
      //assert callerAllowed(caller);
      assert leagueExists(leagueId);
      assert checkPlayerExists(leagueId, dto.playerId);

      let filteredLeaguePlayers = Array.find<(T.FootballLeagueId, [T.Player])>(leaguePlayers, func(leagueWithPlayers: (T.FootballLeagueId, [T.Player])) : Bool{
        leagueWithPlayers.0 == leagueId
      });

      switch(filteredLeaguePlayers){
        case (?foundLeaguePlayers){
          let player = Array.find<T.Player>(
            foundLeaguePlayers.1,
            func(p : T.Player) : Bool {
              return p.id == dto.playerId;
            },
          );

          switch (player) {
            case (null) {
              return #err(#NotFound);
            };
            case (?foundPlayer) {};
          };

          if (dto.newClubId > 0) {

            let filteredLeagueClubs = Array.find<(T.FootballLeagueId, [T.Club])>(leagueClubs, 
              func(leagueClubs: (T.FootballLeagueId, [T.Club])) : Bool{
                  leagueClubs.0 == leagueId;
            });

            switch(filteredLeagueClubs){
              case (?foundLeagueClubs){
                let newClub = Array.find<T.Club>(
                  foundLeagueClubs.1,
                  func(club : T.Club) : Bool {
                    return club.id == dto.newClubId;
                  },
                );

                switch (newClub) {
                  case (null) {
                    return #err(#NotFound);
                  };
                  case (?foundTeam) {};
                };
                return #ok();

              };
              case (null){
                return #err(#NotFound);
              }
            }; 
          };

          return #ok();
          
        };
        case (null){
          return #err(#NotFound);
        }
      };  
    };

    public shared ( {caller} ) func validateRecallPlayer(leagueId: T.FootballLeagueId, dto : DTOs.RecallPlayerDTO) : async Result.Result<(), T.Error> {
      
      //assert callerAllowed(caller);
      assert leagueExists(leagueId);
      assert checkPlayerExists(leagueId, dto.playerId);

      let filteredLeaguePlayers = Array.find<(T.FootballLeagueId, [T.Player])>(leaguePlayers, func(leagueWithPlayers: (T.FootballLeagueId, [T.Player])) : Bool{
        leagueWithPlayers.0 == leagueId
      });

      switch(filteredLeaguePlayers){
        case (?foundLeaguePlayers){
          let player = Array.find<T.Player>(
            foundLeaguePlayers.1,
            func(p : T.Player) : Bool {
              return p.id == dto.playerId;
            },
          );

          switch (player) {
            case (null) {
              return #err(#NotFound);
            };
            case (?foundPlayer) {
              if (foundPlayer.status != #OnLoan) {
                return #err(#NotFound);
              };
            };
          };
          return #ok();
          
        };
        case (null){
          return #err(#NotFound);
        }
      };  
    };

    public shared ( {caller} ) func validateCreatePlayer(leagueId: T.FootballLeagueId, dto : DTOs.CreatePlayerDTO) : async Result.Result<(), T.Error>{
      //assert callerAllowed(caller);
      assert leagueExists(leagueId);

      if (Text.size(dto.firstName) > 50) {
        return #err(#InvalidData);
      };

      if (Text.size(dto.lastName) > 50) {
        return #err(#InvalidData);
      };

      let playerCountry = Array.find<T.Country>(Countries.countries, func(country : T.Country) : Bool { return country.id == dto.nationality });
      switch (playerCountry) {
        case (null) {
        return #err(#InvalidData);
        };
        case (?foundCountry) {};
      };

      if (Utilities.calculateAgeFromUnix(dto.dateOfBirth) < 16) {
        return #err(#InvalidData);
      };

      let filteredLeagueClubs = Array.find<(T.FootballLeagueId, [T.Club])>(leagueClubs, 
        func(leagueClubs: (T.FootballLeagueId, [T.Club])) : Bool{
            leagueClubs.0 == leagueId;
      });

      switch(filteredLeagueClubs){
        case (?foundLeagueClubs){
          let newClub = Array.find<T.Club>(
            foundLeagueClubs.1,
            func(club : T.Club) : Bool {
              return club.id == dto.clubId;
            },
          );

          switch (newClub) {
            case (null) {
              return #err(#NotFound);
            };
            case (?foundTeam) {};
          };
          return #ok();

        };
        case (null){
          return #err(#NotFound);
        }
      };    
    };

    public shared ( {caller} ) func validateUpdatePlayer(leagueId: T.FootballLeagueId, dto : DTOs.UpdatePlayerDTO) : async Result.Result<(), T.Error>{
      //assert callerAllowed(caller);
      assert leagueExists(leagueId);
      assert checkPlayerExists(leagueId, dto.playerId);

      let filteredLeaguePlayers = Array.find<(T.FootballLeagueId, [T.Player])>(leaguePlayers, func(leagueWithPlayers: (T.FootballLeagueId, [T.Player])) : Bool{
        leagueWithPlayers.0 == leagueId
      });

      switch(filteredLeaguePlayers){
        case (?foundLeaguePlayers){
          let player = Array.find<T.Player>(
            foundLeaguePlayers.1,
            func(p : T.Player) : Bool {
              return p.id == dto.playerId;
            },
          );

          switch (player) {
            case (null) {
              return #err(#NotFound);
            };
            case (?foundPlayer) {};
          };

          if (Text.size(dto.firstName) > 50) {
            return #err(#InvalidData);
          };

          if (Text.size(dto.lastName) > 50) {
            return #err(#InvalidData);
          };

          let playerCountry = Array.find<T.Country>(Countries.countries, func(country : T.Country) : Bool { return country.id == dto.nationality });
          switch (playerCountry) {
            case (null) {
            return #err(#InvalidData);
            };
            case (?foundCountry) {};
          };

          if (Utilities.calculateAgeFromUnix(dto.dateOfBirth) < 16) {
            return #err(#InvalidData);
          };
          return #ok();
          
        };
        case (null){
          return #err(#NotFound);
        }
      };  
    };

    public shared ( {caller} ) func validateSetPlayerInjury(leagueId: T.FootballLeagueId, dto : DTOs.SetPlayerInjuryDTO) : async Result.Result<(), T.Error>{
      //assert callerAllowed(caller);
      assert leagueExists(leagueId);
      assert checkPlayerExists(leagueId, dto.playerId);

      let filteredLeaguePlayers = Array.find<(T.FootballLeagueId, [T.Player])>(leaguePlayers, func(leagueWithPlayers: (T.FootballLeagueId, [T.Player])) : Bool{
        leagueWithPlayers.0 == leagueId
      });

      switch(filteredLeaguePlayers){
        case (?foundLeaguePlayers){
         let player = Array.find<T.Player>(
            foundLeaguePlayers.1,
            func(p : T.Player) : Bool {
              return p.id == dto.playerId;
            },
          );

          switch (player) {
            case (null) {
              return #err(#NotFound);
            };
            case (?foundPlayer) {};
          };

          return #ok();
        };
        case (null){
          return #err(#NotFound);
        }
      }; 
    };

    public shared ( {caller} ) func validateRetirePlayer(leagueId: T.FootballLeagueId, dto : DTOs.RetirePlayerDTO) : async Result.Result<(), T.Error>{
      //assert callerAllowed(caller);
      assert leagueExists(leagueId);
      assert checkPlayerExists(leagueId, dto.playerId);

      let filteredLeaguePlayers = Array.find<(T.FootballLeagueId, [T.Player])>(leaguePlayers, func(leagueWithPlayers: (T.FootballLeagueId, [T.Player])) : Bool {
        leagueWithPlayers.0 == leagueId
      });

      switch(filteredLeaguePlayers){
        case (?foundLeaguePlayers){
          let player = Array.find<T.Player>(
            foundLeaguePlayers.1,
            func(p : T.Player) : Bool {
              return p.id == dto.playerId;
            },
          );

          switch (player) {
            case (null) {
              return #err(#NotFound);
            };
            case (?foundPlayer) {};
          };

          return #ok();
        };
        case (null){
          return #err(#NotFound);
        }
      }; 
    };

    public shared ( {caller} ) func validateUnretirePlayer(leagueId: T.FootballLeagueId, dto : DTOs.UnretirePlayerDTO) : async Result.Result<(), T.Error>{
      //assert callerAllowed(caller);
      assert leagueExists(leagueId);
      assert checkPlayerExists(leagueId, dto.playerId);

      let filteredLeaguePlayers = Array.find<(T.FootballLeagueId, [T.Player])>(leaguePlayers, func(leagueWithPlayers: (T.FootballLeagueId, [T.Player])){
        leagueWithPlayers.0 == leagueId
      });

      switch(filteredLeaguePlayers){
        case (?foundLeaguePlayers){
          let playerToUnretire = Array.find<T.Player>(foundLeaguePlayers.1, 
            func(p : T.Player) : Bool { p.id == dto.playerId and p.status == #Retired });
            switch (playerToUnretire) {
              case (null) {
                return #err(#NotFound);
              };
              case (?foundPlayer) {};
            };
            return #ok();
        };
        case (null){
          return #err(#NotFound);
        }
      }; 
    };

    //Governance execution functions
    
    public shared ( {caller} ) func revaluePlayerUp(leagueId: T.FootballLeagueId, dto : DTOs.RevaluePlayerUpDTO) : async Result.Result<(), T.Error>{
      //assert callerAllowed(caller);

      let updatedLeaguePlayersBuffer = Buffer.fromArray<(T.FootballLeagueId, [T.Player])>([]);

      for(league in Iter.fromArray(leaguePlayers)){
        if(league.0 == leagueId){

          let filteredLeaguePlayers = Array.find<(T.FootballLeagueId, [T.Player])>(leaguePlayers, func(leagueWithPlayers: (T.FootballLeagueId, [T.Player])) : Bool{
            leagueWithPlayers.0 == leagueId
          });

          switch(filteredLeaguePlayers){
            case (?foundLeaguePlayers){
              
              var updatedPlayers = Array.map<T.Player, T.Player>(
                foundLeaguePlayers.1,
                  func(p : T.Player) : T.Player {
                    if (p.id == dto.playerId) {
                      var newValue = p.valueQuarterMillions;
                      newValue += 1;

                      let historyEntry : T.ValueHistory = {
                        seasonId = dto.seasonId;
                        gameweek = dto.gameweek;
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
                        gender = p.gender;
                      };

                      return updatedPlayer;
                    };
                    return p;
                },
              );

              updatedLeaguePlayersBuffer.add((leagueId, updatedPlayers));
            };
            case (null){

            }
          };
        } else {
          updatedLeaguePlayersBuffer.add(league);
        } 
      };

      leaguePlayers := Buffer.toArray(updatedLeaguePlayersBuffer);

      return #ok();
    };

    public shared ( {caller} ) func revaluePlayerDown(leagueId: T.FootballLeagueId, dto : DTOs.RevaluePlayerDownDTO) : async Result.Result<(), T.Error>{
      //assert callerAllowed(caller);

      let updatedLeaguePlayersBuffer = Buffer.fromArray<(T.FootballLeagueId, [T.Player])>([]);

      for(league in Iter.fromArray(leaguePlayers)){
        if(league.0 == leagueId){

          let filteredLeaguePlayers = Array.find<(T.FootballLeagueId, [T.Player])>(leaguePlayers, func(leagueWithPlayers: (T.FootballLeagueId, [T.Player])) : Bool{
            leagueWithPlayers.0 == leagueId
          });

          switch(filteredLeaguePlayers){
            case (?foundLeaguePlayers){
              
              var updatedPlayers = Array.map<T.Player, T.Player>(
                foundLeaguePlayers.1,
                  func(p : T.Player) : T.Player {
                    if (p.id == dto.playerId) {
                      var newValue = p.valueQuarterMillions;
                      if (newValue >= 1) {
                        newValue -= 1;
                      };

                      let historyEntry : T.ValueHistory = {
                        seasonId = dto.seasonId;
                        gameweek = dto.gameweek;
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
                        gender = p.gender;
                      };

                      return updatedPlayer;
                    };
                    return p;
                },
              );

              updatedLeaguePlayersBuffer.add((leagueId, updatedPlayers));
            };
            case (null){

            }
          };
        } else {
          updatedLeaguePlayersBuffer.add(league);
        } 
      };

      leaguePlayers := Buffer.toArray(updatedLeaguePlayersBuffer);

      return #ok();
    };

    public shared ( {caller} ) func loanPlayer(leagueId: T.FootballLeagueId, dto : DTOs.LoanPlayerDTO) : async Result.Result<(), T.Error>{
      //assert callerAllowed(caller);
      assert leagueExists(leagueId);
      assert leagueExists(dto.loanLeagueId);
      assert clubExists(dto.loanLeagueId, dto.loanClubId);

      let updatedLeaguePlayersBuffer = Buffer.fromArray<(T.FootballLeagueId, [T.Player])>([]);

      //move player from 1 league to another league



      //TODO LATER: Extend to allow loans to other leagues



      for(league in Iter.fromArray(leaguePlayers)){
        if(league.0 == leagueId){

          let filteredLeaguePlayers = Array.find<(T.FootballLeagueId, [T.Player])>(leaguePlayers, func(leagueWithPlayers: (T.FootballLeagueId, [T.Player])) : Bool{
            leagueWithPlayers.0 == leagueId
          });

          switch(filteredLeaguePlayers){
            case (?foundLeaguePlayers){
              
              var updatedPlayers = Array.map<T.Player, T.Player>(
                foundLeaguePlayers.1,
                  func(p : T.Player) : T.Player {
                    if (p.id == dto.playerId) {
                      
                      let newTransferHistoryEntry : T.TransferHistory = {
                        transferDate = Time.now();
                        transferGameweek = dto.gameweek;
                        transferSeason = dto.seasonId;
                        fromClub = p.clubId;
                        toClub = dto.loanClubId;
                        loanEndDate = dto.loanEndDate;
                        fromLeagueId = league.0;
                        toLeagueId = dto.loanLeagueId;
                      };

                      let loanedPlayer : T.Player = {
                        id = p.id;
                        clubId = dto.loanClubId;
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
                        currentLoanEndDate = dto.loanEndDate;
                        latestInjuryEndDate = p.latestInjuryEndDate;
                        injuryHistory = p.injuryHistory;
                        retirementDate = p.retirementDate;
                        transferHistory = List.append<T.TransferHistory>(p.transferHistory, List.fromArray([newTransferHistoryEntry]));
                        gender = p.gender;
                      };

                      return loanedPlayer;
                    };
                    return p;
                },
              );

              updatedLeaguePlayersBuffer.add((leagueId, updatedPlayers));
            };
            case (null){

            }
          };
        } else {
          updatedLeaguePlayersBuffer.add(league);
        } 
      };

      leaguePlayers := Buffer.toArray(updatedLeaguePlayersBuffer);

      return #ok();
    };

    public shared ( {caller} ) func transferPlayer(leagueId: T.FootballLeagueId, dto : DTOs.TransferPlayerDTO) : async Result.Result<(), T.Error>{
      //assert callerAllowed(caller);

      if(dto.newClubId == 0 and dto.newLeagueId == 0){
        movePlayerToFreeAgents(leagueId, dto.clubId, dto.playerId, dto.seasonId, dto.gameweek);
        return #ok();
      };

      if(dto.newLeagueId == leagueId){
        movePlayerWithinLeague(leagueId, dto.newClubId, dto.playerId, dto.seasonId, dto.gameweek, dto.newShirtNumber);
        return #ok();
      };

      movePlayerToLeague(leagueId, dto.clubId, dto.newLeagueId, dto.newClubId, dto.playerId, dto.seasonId, dto.gameweek, dto.newShirtNumber);
      
      return #ok();
    };

    public shared ( {caller} ) func createPlayer(leagueId: T.FootballLeagueId, dto : DTOs.CreatePlayerDTO) : async Result.Result<(), T.Error>{
      //assert callerAllowed(caller);
      
      let newPlayer : T.Player = {
        id = nextPlayerId + 1;
        clubId = dto.clubId;
        position = dto.position;
        firstName = dto.firstName;
        lastName = dto.lastName;
        shirtNumber = dto.shirtNumber;
        valueQuarterMillions = dto.valueQuarterMillions;
        dateOfBirth = dto.dateOfBirth;
        nationality = dto.nationality;
        seasons = List.nil<T.PlayerSeason>();
        valueHistory = List.nil<T.ValueHistory>();
        status = #Active;
        parentClubId = 0;
        currentLoanEndDate = 0;
        latestInjuryEndDate = 0;
        injuryHistory = List.nil<T.InjuryHistory>();
        retirementDate = 0;
        transferHistory = List.nil<T.TransferHistory>();
        gender = dto.gender;
      };

      leaguePlayers := Array.map<(T.FootballLeagueId, [T.Player]), (T.FootballLeagueId, [T.Player])>(leaguePlayers, 
        func(leaguePlayersEntry: (T.FootballLeagueId, [T.Player])){
          if(leaguePlayersEntry.0 == leagueId){
            let updatedPlayersBuffer = Buffer.fromArray<T.Player>(leaguePlayersEntry.1);
            updatedPlayersBuffer.add(newPlayer);
            return (leaguePlayersEntry.0, Buffer.toArray(updatedPlayersBuffer));
          } else {
            return leaguePlayersEntry;
          }
      });

      nextPlayerId += 1;
      return #ok();
    };

    public shared ( {caller} ) func updatePlayer(leagueId: T.FootballLeagueId, dto : DTOs.UpdatePlayerDTO) : async Result.Result<(), T.Error>{
      //assert callerAllowed(caller);

      leaguePlayers := Array.map<(T.FootballLeagueId, [T.Player]), (T.FootballLeagueId, [T.Player])>(leaguePlayers, 
        func(leaguePlayersEntry: (T.FootballLeagueId, [T.Player])){
          if(leaguePlayersEntry.0 == leagueId){

            let existingPlayer = Array.find<T.Player>(leaguePlayersEntry.1, func(player: T.Player) : Bool{
              player.id == dto.playerId
            });

            let updatedPlayersBuffer = Buffer.fromArray<T.Player>(Array.filter<T.Player>(leaguePlayersEntry.1, func(player: T.Player) : Bool{
              player.id != dto.playerId
            }));

            switch(existingPlayer){
              case (?currentPlayer){

                let updatedPlayer: T.Player = {
                  id = currentPlayer.id;
                  clubId = currentPlayer.clubId;
                  position = dto.position;
                  firstName = dto.firstName;
                  lastName = dto.lastName;
                  shirtNumber = dto.shirtNumber;
                  valueQuarterMillions = currentPlayer.valueQuarterMillions;
                  dateOfBirth = dto.dateOfBirth;
                  nationality = dto.nationality;
                  seasons = currentPlayer.seasons;
                  valueHistory = currentPlayer.valueHistory;
                  status = currentPlayer.status;
                  parentClubId = currentPlayer.parentClubId;
                  currentLoanEndDate = currentPlayer.currentLoanEndDate;
                  latestInjuryEndDate = currentPlayer.latestInjuryEndDate;
                  injuryHistory = currentPlayer.injuryHistory;
                  retirementDate = currentPlayer.retirementDate;
                  transferHistory = currentPlayer.transferHistory;
                  gender = currentPlayer.gender;
                };
                updatedPlayersBuffer.add(updatedPlayer);

              };
              case (null){

              }
            };

            return (leaguePlayersEntry.0, Buffer.toArray(updatedPlayersBuffer));
          } else {
            return leaguePlayersEntry;
          }
      });
      return #ok();
    };

    public shared ( {caller} ) func setPlayerInjury(leagueId: T.FootballLeagueId, dto : DTOs.SetPlayerInjuryDTO) : async Result.Result<(), T.Error>{
      //assert callerAllowed(caller);


      leaguePlayers := Array.map<(T.FootballLeagueId, [T.Player]), (T.FootballLeagueId, [T.Player])>(leaguePlayers, 
        func(leaguePlayersEntry: (T.FootballLeagueId, [T.Player]))
        {
          if(leaguePlayersEntry.0 == leagueId){
            
             let existingPlayer = Array.find<T.Player>(leaguePlayersEntry.1, func(player: T.Player) : Bool{
              player.id == dto.playerId
            });

            let updatedPlayersBuffer = Buffer.fromArray<T.Player>(Array.filter<T.Player>(leaguePlayersEntry.1, func(player: T.Player) : Bool{
              player.id != dto.playerId
            }));

            switch(existingPlayer){
              case (?currentPlayer){
                
                let injuryHistoryEntry : T.InjuryHistory = {
                  description = dto.description;
                  injuryStartDate = Time.now();
                  expectedEndDate = dto.expectedEndDate;
                };

                let updatedPlayer: T.Player = {
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
                  latestInjuryEndDate = currentPlayer.latestInjuryEndDate;
                  injuryHistory = List.append<T.InjuryHistory>(currentPlayer.injuryHistory, List.fromArray([injuryHistoryEntry]));
                  retirementDate = currentPlayer.retirementDate;
                  transferHistory = currentPlayer.transferHistory;
                  gender = currentPlayer.gender;
                };
                updatedPlayersBuffer.add(updatedPlayer);

              };
              case (null){

              }
            };

            return (leaguePlayersEntry.0, Buffer.toArray(updatedPlayersBuffer));


          } else {
            return leaguePlayersEntry;
          }
        }
      );

      let playerInjuryDuration = #nanoseconds(Int.abs((dto.expectedEndDate - Time.now())));
      await setAndBackupTimer(playerInjuryDuration, "injuryExpired");
      return #ok();
    };

    public shared ( {caller} ) func retirePlayer(leagueId: T.FootballLeagueId, dto : DTOs.RetirePlayerDTO) : async Result.Result<(), T.Error>{
      //TODO
      /*
      //assert callerAllowed(caller);
      let playerToRetire = List.find<T.Player>(players, func(p : T.Player) : Bool { p.id == retirePlayerDTO.playerId });
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
      */
      return #err(#NotFound);
    };

    public shared ( {caller} ) func unretirePlayer(dto : DTOs.UnretirePlayerDTO) : async Result.Result<(), T.Error>{
      //TODO
      /* 
      //assert callerAllowed(caller);
      let playerToUnretire = List.find<T.Player>(players, func(p : T.Player) : Bool { p.id == unretirePlayerDTO.playerId });
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
      */
      return #err(#NotFound);
    };

    public shared ({ caller }) func promoteNewClub(leagueId: T.FootballLeagueId, promoteNewClubDTO : DTOs.PromoteNewClubDTO) : async Result.Result<(), T.Error> {
      //TODO
      /*
      //assert callerAllowed(caller);


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
        */

      return #err(#NotFound);
    };

    public shared ({ caller }) func updateClub(updateClubDTO : DTOs.UpdateClubDTO) : async Result.Result<(), T.Error> {
      //TODO
      /*
      //assert callerAllowed(caller);
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
        */
      return #err(#NotFound);
    };

    //Game Update Functions

    public shared ( {caller} ) func createNewSeason(systemState : T.SystemState) {
      //TODO
      /*
      //assert callerAllowed(caller);
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
      */
    };

    public shared ( {caller} ) func addEventsToFixture(playerEventData : [T.PlayerEventData], seasonId : T.SeasonId, fixtureId : T.FixtureId) : async () {
      //TODO LATER
      /*
      //assert callerAllowed(caller);
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
      */
    };

    public shared ( {caller} ) func setGameScore(seasonId: T.SeasonId, fixtureId: T.FixtureId){
      //TODO LATER
      /*
      //assert callerAllowed(caller);
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
      */
    };

    public shared ( {caller} ) func setFixtureToComplete(seasonId: T.SeasonId, fixtureId: T.FixtureId){
      //TODO LATER
      /*
      //assert callerAllowed(caller);
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
      */
    };

    public shared ( {caller} ) func setFixtureToFinalised(seasonId: T.SeasonId, fixtureId: T.FixtureId) {
      //TODO LATER
      /*
      //assert callerAllowed(caller);
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
      */
    };

    public shared ( {caller} ) func addEventsToPlayers(playerEventData : [T.PlayerEventData], seasonId : T.SeasonId, gameweek : T.GameweekNumber) : async () {
      //TODO LATER
      /*
      //assert callerAllowed(caller);
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
      */
    };

    //Game State Check Functions

    public shared ( {caller} ) func checkGameweekComplete(seasonId: T.SeasonId, gameweek: T.GameweekNumber) : async Bool {
      //TODO LATER
      /*
      //assert callerAllowed(caller);
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
      */
      return false;
    };

    public shared ( {caller} ) func checkMonthComplete(seasonId: T.SeasonId, month: T.CalendarMonth, gameweek: T.GameweekNumber) : async Bool {
      //TODO LATER
      /*

      //assert callerAllowed(caller);
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
      */

      return false;
    };

    public shared ( {caller} ) func checkSeasonComplete(seasonId: T.SeasonId) : async Bool {
      //TODO LATER
      /*

      //assert callerAllowed(caller);
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
      */
      return false;
    };

    private func getPlayer(leagueId: T.FootballLeagueId, playerId: T.PlayerId) : ?T.Player{
      let playersLeague = Array.find<(T.FootballLeagueId, [T.Player])>(leaguePlayers, func(playerLeagueEntry: (T.FootballLeagueId, [T.Player])) : Bool{
        playerLeagueEntry.0 == leagueId;
      });
      switch(playersLeague){
        case (null){
          return null;
        };
        case (?foundPlayersLeague){
          return Array.find<T.Player>(foundPlayersLeague.1, func(player: T.Player) : Bool{
            player.id == playerId
          });
        }
      }
    };

    private func movePlayerToFreeAgents(leagueId: T.FootballLeagueId, clubId: T.ClubId, playerId: T.PlayerId, seasonId: T.SeasonId, gameweek: T.GameweekNumber){

      let playerToMove = getPlayer(leagueId, playerId);

      switch(playerToMove){
        case (?foundPlayer){
          leaguePlayers := Array.map<(T.FootballLeagueId, [T.Player]), (T.FootballLeagueId, [T.Player])>(leaguePlayers, 
            func(leagueWithPlayers: (T.FootballLeagueId, [T.Player]))
            {
              if(leagueWithPlayers.0 == leagueId){
                return (leagueWithPlayers.0, 
                  Array.filter<T.Player>(leagueWithPlayers.1, func(player: T.Player) : Bool{
                    player.id != playerId
                  })
                );
              } else {
                return leagueWithPlayers;
              }
            }
          );

          let newTransferHistoryEntry : T.TransferHistory = {
            transferDate = Time.now();
            transferGameweek = gameweek;
            transferSeason = seasonId;
            fromClub = foundPlayer.clubId;
            toClub = 0;
            loanEndDate = 0;
            fromLeagueId = leagueId;
            toLeagueId = 0;
          };

          let freeAgentsBuffer = Buffer.fromArray<T.Player>(freeAgents);
          freeAgentsBuffer.add({
            clubId = 0;
            currentLoanEndDate = 0;
            dateOfBirth = foundPlayer.dateOfBirth;
            firstName = foundPlayer.firstName;
            gender = foundPlayer.gender;
            id = foundPlayer.id;
            injuryHistory = foundPlayer.injuryHistory;
            lastName = foundPlayer.lastName;
            latestInjuryEndDate = foundPlayer.latestInjuryEndDate;
            nationality = foundPlayer.nationality;
            parentClubId = foundPlayer.parentClubId;
            position = foundPlayer.position;
            retirementDate = foundPlayer.retirementDate;
            seasons = foundPlayer.seasons;
            shirtNumber = 0;
            status = foundPlayer.status;
            transferHistory = List.append<T.TransferHistory>(foundPlayer.transferHistory, List.fromArray([newTransferHistoryEntry]));
            valueHistory = foundPlayer.valueHistory;
            valueQuarterMillions = foundPlayer.valueQuarterMillions

          });
          freeAgents := Buffer.toArray(freeAgentsBuffer);
        };
        case (null){ }
      };
    };

    private func movePlayerWithinLeague(currentLeagueId: T.FootballLeagueId, newClubId: T.ClubId, playerId: T.PlayerId, seasonId: T.SeasonId, gameweek: T.GameweekNumber, shirtNumber: Nat8){
      
      leaguePlayers := Array.map<(T.FootballLeagueId, [T.Player]),(T.FootballLeagueId, [T.Player])>(leaguePlayers, func(leaguePlayersEntry: (T.FootballLeagueId, [T.Player])){
        if(leaguePlayersEntry.0 == currentLeagueId){
          return (leaguePlayersEntry.0, Array.map<T.Player, T.Player>(leaguePlayersEntry.1, func(player: T.Player){
            if(player.id == playerId){

              let newTransferHistoryEntry : T.TransferHistory = {
                transferDate = Time.now();
                transferGameweek = gameweek;
                transferSeason = seasonId;
                fromClub = player.clubId;
                toClub = newClubId;
                loanEndDate = 0;
                fromLeagueId = currentLeagueId;
                toLeagueId = currentLeagueId;
              };

              return {
                clubId = newClubId;
                currentLoanEndDate = 0;
                dateOfBirth = player.dateOfBirth;
                firstName = player.firstName;
                gender = player.gender;
                id = player.id;
                injuryHistory = player.injuryHistory;
                lastName = player.lastName;
                latestInjuryEndDate = player.latestInjuryEndDate;
                nationality = player.nationality;
                parentClubId = 0;
                position = player.position;
                retirementDate = player.retirementDate;
                seasons = player.seasons;
                shirtNumber = shirtNumber;
                status = player.status;
                transferHistory = List.append<T.TransferHistory>(player.transferHistory, List.fromArray([newTransferHistoryEntry]));
                valueHistory = player.valueHistory;
                valueQuarterMillions = player.valueQuarterMillions;
              }
            } else {
              return player;
            }
          }));
        } else {
          return leaguePlayersEntry;
        };
      });
    };

    private func movePlayerToLeague(currentLeagueId: T.FootballLeagueId, currentClubId: T.ClubId, newLeagueId: T.FootballLeagueId, newClubId: T.ClubId, playerId: T.PlayerId, seasonId: T.SeasonId, gameweek: T.GameweekNumber, shirtNumber: Nat8){
      
      let playerToMove = getPlayer(currentLeagueId, playerId);

      switch(playerToMove){
        case (?foundPlayer){
          leaguePlayers := Array.map<(T.FootballLeagueId, [T.Player]), (T.FootballLeagueId, [T.Player])>(leaguePlayers, 
            func(leagueWithPlayers: (T.FootballLeagueId, [T.Player]))
            {
              if(leagueWithPlayers.0 == currentLeagueId){
                return (leagueWithPlayers.0, 
                  Array.filter<T.Player>(leagueWithPlayers.1, func(player: T.Player) : Bool{
                    player.id != playerId
                  })
                );
              } else {
                return leagueWithPlayers;
              }
            }
          );

          let newTransferHistoryEntry : T.TransferHistory = {
            transferDate = Time.now();
            transferGameweek = gameweek;
            transferSeason = seasonId;
            fromLeagueId = currentLeagueId;
            fromClub = foundPlayer.clubId;
            toLeagueId = newLeagueId;
            toClub = newClubId;
            loanEndDate = 0;
          };

          leaguePlayers := Array.map<(T.FootballLeagueId, [T.Player]), (T.FootballLeagueId, [T.Player])>(leaguePlayers, 
            func(leagueWithPlayers: (T.FootballLeagueId, [T.Player]))
            {
              if(leagueWithPlayers.0 == newLeagueId){

                let updatedPlayersBuffer = Buffer.fromArray<T.Player>(leagueWithPlayers.1);
                updatedPlayersBuffer.add({
                  clubId = newClubId;
                  currentLoanEndDate = 0;
                  dateOfBirth = foundPlayer.dateOfBirth;
                  firstName = foundPlayer.firstName;
                  gender = foundPlayer.gender;
                  id = foundPlayer.id;
                  injuryHistory = foundPlayer.injuryHistory;
                  lastName = foundPlayer.lastName;
                  latestInjuryEndDate = foundPlayer.latestInjuryEndDate;
                  nationality = foundPlayer.nationality;
                  parentClubId = 0;
                  position = foundPlayer.position;
                  retirementDate = foundPlayer.retirementDate;
                  seasons = foundPlayer.seasons;
                  shirtNumber = foundPlayer.shirtNumber;
                  status = foundPlayer.status;
                  transferHistory = foundPlayer.transferHistory;
                  valueHistory = foundPlayer.valueHistory;
                  valueQuarterMillions = foundPlayer.valueQuarterMillions;
                });

                return (leagueWithPlayers.0, Buffer.toArray(updatedPlayersBuffer));
              } else {
                return leagueWithPlayers;
              }
            }
          );
        };
        case (null){ }
      };
    };

    private func calculatePlayerScore(playerPosition : T.PlayerPosition, events : [T.PlayerEventData]) : Int16 {
      //TODO LATER
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

    private func leagueExists(leagueId: T.FootballLeagueId) : Bool {
      let foundLeague = Array.find<T.FootballLeague>(leagues, func(league: T.FootballLeague) : Bool {
        league.id == leagueId
      });
      return Option.isSome(foundLeague);
    }; 

    private func clubExists(leagueId: T.FootballLeagueId, clubId: T.ClubId) : Bool {
      
      let league = Array.find<(T.FootballLeagueId, [T.Club])>(leagueClubs, func(league: (T.FootballLeagueId, [T.Club])) : Bool {
        league.0 == leagueId
      });

      switch(league){
        case (?foundLeague){
          let foundClub = Array.find<T.Club>(foundLeague.1, func(club: T.Club) : Bool {
            return club.id == clubId;
          });

          return Option.isSome(foundClub);
        };
        case (null){
          return false;
        }
      };
    }; 

    private func checkPlayerExists(leagueId: T.FootballLeagueId, playerId: T.PlayerId) : Bool {
      let playersInLeague = Array.find<(T.FootballLeagueId, [T.Player])>(leaguePlayers, 
        func(foundLeaguePlayers: (T.FootballLeagueId, [T.Player])) : Bool{
          foundLeaguePlayers.0 == leagueId;
        }
      );

      switch(playersInLeague){
        case (?foundPlayersInLeague){
          let foundPlayer = Array.find<T.Player>(foundPlayersInLeague.1, func(player: T.Player) : Bool{
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

    private func setAndBackupTimer(duration : Timer.Duration, callbackName : Text) : async () {
      let jobId : Timer.TimerId = switch (callbackName) {
        case "loanExpired" {
          Timer.setTimer<system>(duration, loanExpiredCallback);
        };
        case "injuryExpired" {
          Timer.setTimer<system>(duration, injuryExpiredCallback);
        };
        case _ {
          Timer.setTimer<system>(duration, defaultCallback);
        }
      };
    };

    private func loanExpiredCallback() : async (){
      //TODO LATER
      /*
      //assert callerAllowed(caller);
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
      */
    };

    private func injuryExpiredCallback() : async (){
      //TODO LATER
      /*
      //assert callerAllowed(caller);

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
      */
    };

    private func defaultCallback() : async () {};


    system func preupgrade() {

    };

    system func postupgrade() {
      
      //set data


      ignore Timer.setTimer<system>(#nanoseconds(Int.abs(1)), postUpgradeCallback); 
    };



    private func postUpgradeCallback() : async (){

      

      //await setSystemTimers();
    };

    public shared ({ caller }) func setupData() : async Result.Result<(), T.Error> {
      if(dataInitialised){
        return #err(#NotAllowed);
      };

      leagueSeasons := [
        (1, 
          [
            {
              id = 1;
              name = "2024/25";
              postponedFixtures = List.fromArray([]);
              rewardPool = {
                allTimeMonthlyHighScorePool = 0;
                allTimeSeasonHighScorePool = 0;
                allTimeWeeklyHighScorePool = 0;
                highestScoringMatchPlayerPool = 0;
                monthlyLeaderboardPool = 0;
                mostValuableTeamPool = 0;
                seasonId = 1;
                seasonLeaderboardPool = 0;
                weeklyLeaderboardPool = 0;
              };
              year = 2024;
              fixtures = List.fromArray<T.Fixture>([
                {id=1; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=10; events=List.fromArray([]); homeClubId=14; kickOff=1723834800000000000; homeGoals=1; gameweek=1; awayGoals=0 },
                {id=2; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=11; events=List.fromArray([]); homeClubId=22; kickOff=1723894200000000000; homeGoals=0; gameweek=1; awayGoals=2},
                {id=3; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=20; events=List.fromArray([]); homeClubId=1; kickOff=1723903200000000000; homeGoals=2; gameweek=1; awayGoals=0},
                {id=4; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=5; events=List.fromArray([]); homeClubId=9; kickOff=1723903200000000000; homeGoals=0; gameweek=1; awayGoals=3},
                {id=5; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=23; events=List.fromArray([]); homeClubId=15; kickOff=1723903200000000000; homeGoals=1; gameweek=1; awayGoals=0}, 
                {id=6; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=3; events=List.fromArray([]); homeClubId=16; kickOff=1723903200000000000; homeGoals=1; gameweek=1; awayGoals=1}, 
                {id=7; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=2; events=List.fromArray([]); homeClubId=19; kickOff=1723912200000000000; homeGoals=1; gameweek=1; awayGoals=2}, 
                {id=8; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=8; events=List.fromArray([]); homeClubId=4; kickOff=1723986000000000000; homeGoals=2; gameweek=1; awayGoals=1}, 
                {id=9; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=13; events=List.fromArray([]); homeClubId=7; kickOff=1723995000000000000; homeGoals=0; gameweek=1; awayGoals=2}, 
                {id=10; status=#Complete; highestScoringPlayerId=0; seasonId=1; awayClubId=18; events=List.fromArray([]); homeClubId=21; kickOff=1724094000000000000; homeGoals=0; gameweek=1; awayGoals=0}, 
                {id=11; status=#Complete; highestScoringPlayerId=0; seasonId=1; awayClubId=14; events=List.fromArray([]); homeClubId=5; kickOff=1724499000000000000; homeGoals=0; gameweek=2; awayGoals=0},
                {id=12; status=#Complete; highestScoringPlayerId=0; seasonId=1; awayClubId=19; events=List.fromArray([]); homeClubId=8; kickOff=1724508000000000000; homeGoals=0; gameweek=2; awayGoals=0}, 
                {id=13; status=#Complete; highestScoringPlayerId=0; seasonId=1; awayClubId=21; events=List.fromArray([]); homeClubId=10; kickOff=1724508000000000000; homeGoals=0; gameweek=2; awayGoals=0}, 
                {id=14; status=#Complete; highestScoringPlayerId=0; seasonId=1; awayClubId=22; events=List.fromArray([]); homeClubId=13; kickOff=1724508000000000000; homeGoals=0; gameweek=2; awayGoals=0}, 
                {id=15; status=#Complete; highestScoringPlayerId=0; seasonId=1; awayClubId=16; events=List.fromArray([]); homeClubId=23; kickOff=1724508000000000000; homeGoals=0; gameweek=2; awayGoals=0}, 
                {id=16; status=#Complete; highestScoringPlayerId=0; seasonId=1; awayClubId=9; events=List.fromArray([]); homeClubId=18; kickOff=1724508000000000000; homeGoals=0; gameweek=2; awayGoals=0}, 
                {id=17; status=#Complete; highestScoringPlayerId=0; seasonId=1; awayClubId=1; events=List.fromArray([]); homeClubId=2; kickOff=1724603400000000000; homeGoals=0; gameweek=2; awayGoals=0}, 
                {id=18; status=#Complete; highestScoringPlayerId=0; seasonId=1; awayClubId=15; events=List.fromArray([]); homeClubId=3; kickOff=1724590800000000000; homeGoals=0; gameweek=2; awayGoals=0}, 
                {id=19; status=#Complete; highestScoringPlayerId=0; seasonId=1; awayClubId=7; events=List.fromArray([]); homeClubId=20; kickOff=1724590800000000000; homeGoals=0; gameweek=2; awayGoals=0}, 
                {id=20; status=#Complete; highestScoringPlayerId=0; seasonId=1; awayClubId=4; events=List.fromArray([]); homeClubId=11; kickOff=1724599800000000000; homeGoals=0; gameweek=2; awayGoals=0}, 
                {id=21; status=#Complete; highestScoringPlayerId=0; seasonId=1; awayClubId=5; events=List.fromArray([]); homeClubId=1; kickOff=1725103800000000000; homeGoals=0; gameweek=3; awayGoals=0}, 
                {id=22; status=#Complete; highestScoringPlayerId=0; seasonId=1; awayClubId=23; events=List.fromArray([]); homeClubId=4; kickOff=1725112800000000000; homeGoals=0; gameweek=3; awayGoals=0}, 
                {id=23; status=#Complete; highestScoringPlayerId=0; seasonId=1; awayClubId=3; events=List.fromArray([]); homeClubId=9; kickOff=1725112800000000000; homeGoals=0; gameweek=3; awayGoals=0}, 
                {id=24; status=#Complete; highestScoringPlayerId=0; seasonId=1; awayClubId=10; events=List.fromArray([]); homeClubId=22; kickOff=1725112800000000000; homeGoals=0; gameweek=3; awayGoals=0}, 
                {id=25; status=#Complete; highestScoringPlayerId=0; seasonId=1; awayClubId=2; events=List.fromArray([]); homeClubId=21; kickOff=1725112800000000000; homeGoals=0; gameweek=3; awayGoals=0}, 
                {id=26; status=#Complete; highestScoringPlayerId=0; seasonId=1; awayClubId=20; events=List.fromArray([]); homeClubId=16; kickOff=1725112800000000000; homeGoals=0; gameweek=3; awayGoals=0}, 
                {id=27; status=#Complete; highestScoringPlayerId=0; seasonId=1; awayClubId=13; events=List.fromArray([]); homeClubId=19; kickOff=1725121800000000000; homeGoals=0; gameweek=3; awayGoals=0}, 
                {id=28; status=#Complete; highestScoringPlayerId=0; seasonId=1; awayClubId=8; events=List.fromArray([]); homeClubId=7; kickOff=1725193800000000000; homeGoals=0; gameweek=3; awayGoals=0}, 
                {id=29; status=#Complete; highestScoringPlayerId=0; seasonId=1; awayClubId=18; events=List.fromArray([]); homeClubId=15; kickOff=1725193800000000000; homeGoals=0; gameweek=3; awayGoals=0}, 
                {id=30; status=#Complete; highestScoringPlayerId=0; seasonId=1; awayClubId=11; events=List.fromArray([]); homeClubId=14; kickOff=1725202800000000000; homeGoals=0; gameweek=3; awayGoals=0}, 
                {id=31; status=#Complete; highestScoringPlayerId=0; seasonId=1; awayClubId=14; events=List.fromArray([]); homeClubId=23; kickOff=1726313400000000000; homeGoals=0; gameweek=4; awayGoals=0}, 
                {id=32; status=#Complete; highestScoringPlayerId=0; seasonId=1; awayClubId=22; events=List.fromArray([]); homeClubId=5; kickOff=1726322400000000000; homeGoals=0; gameweek=4; awayGoals=0},
                {id=33; status=#Complete; highestScoringPlayerId=0; seasonId=1; awayClubId=21; events=List.fromArray([]); homeClubId=8; kickOff=1726322400000000000; homeGoals=0; gameweek=4; awayGoals=0}, 
                {id=34; status=#Complete; highestScoringPlayerId=0; seasonId=1; awayClubId=19; events=List.fromArray([]); homeClubId=10; kickOff=1726322400000000000; homeGoals=0; gameweek=4; awayGoals=0}, 
                {id=35; status=#Complete; highestScoringPlayerId=0; seasonId=1; awayClubId=16; events=List.fromArray([]); homeClubId=11; kickOff=1726322400000000000; homeGoals=0; gameweek=4; awayGoals=0},
                {id=36; status=#Complete; highestScoringPlayerId=0; seasonId=1; awayClubId=4; events=List.fromArray([]); homeClubId=13; kickOff=1726322400000000000; homeGoals=0; gameweek=4; awayGoals=0},
                {id=37; status=#Complete; highestScoringPlayerId=0; seasonId=1; awayClubId=9; events=List.fromArray([]); homeClubId=2; kickOff=1726331400000000000; homeGoals=0; gameweek=4; awayGoals=0},
                {id=38; status=#Complete; highestScoringPlayerId=0; seasonId=1; awayClubId=7; events=List.fromArray([]); homeClubId=3; kickOff=1726340400000000000; homeGoals=0; gameweek=4; awayGoals=0}, 
                {id=39; status=#Complete; highestScoringPlayerId=0; seasonId=1; awayClubId=1; events=List.fromArray([]); homeClubId=18; kickOff=1726405200000000000; homeGoals=0; gameweek=4; awayGoals=0}, 
                {id=40; status=#Complete; highestScoringPlayerId=0; seasonId=1; awayClubId=15; events=List.fromArray([]); homeClubId=20; kickOff=1726414200000000000; homeGoals=0; gameweek=4; awayGoals=0}, 
                {id=41; status=#Complete; highestScoringPlayerId=0; seasonId=1; awayClubId=7; events=List.fromArray([]); homeClubId=19; kickOff=1726918200000000000; homeGoals=0; gameweek=5; awayGoals=0}, 
                {id=42; status=#Complete; highestScoringPlayerId=0; seasonId=1; awayClubId=20; events=List.fromArray([]); homeClubId=2; kickOff=1726927200000000000; homeGoals=0; gameweek=5; awayGoals=0}, 
                {id=43; status=#Complete; highestScoringPlayerId=0; seasonId=1; awayClubId=15; events=List.fromArray([]); homeClubId=10; kickOff=1726927200000000000; homeGoals=0; gameweek=5; awayGoals=0}, 
                {id=44; status=#Complete; highestScoringPlayerId=0; seasonId=1; awayClubId=9; events=List.fromArray([]); homeClubId=21; kickOff=1726927200000000000; homeGoals=0; gameweek=5; awayGoals=0}, 
                {id=45; status=#Complete; highestScoringPlayerId=0; seasonId=1; awayClubId=3; events=List.fromArray([]); homeClubId=11; kickOff=1726927200000000000; homeGoals=0; gameweek=5; awayGoals=0}, 
                {id=46; status=#Complete; highestScoringPlayerId=0; seasonId=1; awayClubId=22; events=List.fromArray([]); homeClubId=23; kickOff=1726927200000000000; homeGoals=0; gameweek=5; awayGoals=0}, 
                {id=47; status=#Complete; highestScoringPlayerId=0; seasonId=1; awayClubId=4; events=List.fromArray([]); homeClubId=18; kickOff=1726927200000000000; homeGoals=0; gameweek=5; awayGoals=0}, 
                {id=48; status=#Complete; highestScoringPlayerId=0; seasonId=1; awayClubId=14; events=List.fromArray([]); homeClubId=8; kickOff=1726936200000000000; homeGoals=0; gameweek=5; awayGoals=0}, 
                {id=49; status=#Complete; highestScoringPlayerId=0; seasonId=1; awayClubId=16; events=List.fromArray([]); homeClubId=5; kickOff=1727010000000000000; homeGoals=0; gameweek=5; awayGoals=0}, 
                {id=50; status=#Complete; highestScoringPlayerId=0; seasonId=1; awayClubId=1; events=List.fromArray([]); homeClubId=13; kickOff=1727019000000000000; homeGoals=0; gameweek=5; awayGoals=0}, 
                {id=51; status=#Complete; highestScoringPlayerId=0; seasonId=1; awayClubId=13; events=List.fromArray([]); homeClubId=15; kickOff=1727523000000000000; homeGoals=0; gameweek=6; awayGoals=0}, 
                {id=52; status=#Complete; highestScoringPlayerId=0; seasonId=1; awayClubId=21; events=List.fromArray([]); homeClubId=1; kickOff=1727532000000000000; homeGoals=0; gameweek=6; awayGoals=0}, 
                {id=53; status=#Complete; highestScoringPlayerId=0; seasonId=1; awayClubId=19; events=List.fromArray([]); homeClubId=4; kickOff=1727532000000000000; homeGoals=0; gameweek=6; awayGoals=0}, 
                {id=54; status=#Complete; highestScoringPlayerId=0; seasonId=1; awayClubId=5; events=List.fromArray([]); homeClubId=7; kickOff=1727532000000000000; homeGoals=0; gameweek=6; awayGoals=0}, 
                {id=55; status=#Complete; highestScoringPlayerId=0; seasonId=1; awayClubId=8; events=List.fromArray([]); homeClubId=9; kickOff=1727532000000000000; homeGoals=0; gameweek=6; awayGoals=0}, 
                {id=56; status=#Complete; highestScoringPlayerId=0; seasonId=1; awayClubId=10; events=List.fromArray([]); homeClubId=16; kickOff=1727532000000000000; homeGoals=0; gameweek=6; awayGoals=0}, 
                {id=57; status=#Complete; highestScoringPlayerId=0; seasonId=1; awayClubId=11; events=List.fromArray([]); homeClubId=20; kickOff=1727541000000000000; homeGoals=0; gameweek=6; awayGoals=0}, 
                {id=58; status=#Complete; highestScoringPlayerId=0; seasonId=1; awayClubId=2; events=List.fromArray([]); homeClubId=22; kickOff=1727614800000000000; homeGoals=0; gameweek=6; awayGoals=0}, 
                {id=59; status=#Complete; highestScoringPlayerId=0; seasonId=1; awayClubId=18; events=List.fromArray([]); homeClubId=14; kickOff=1727623800000000000; homeGoals=0; gameweek=6; awayGoals=0}, 
                {id=60; status=#Complete; highestScoringPlayerId=0; seasonId=1; awayClubId=23; events=List.fromArray([]); homeClubId=3; kickOff=1727722800000000000; homeGoals=0; gameweek=6; awayGoals=0}, 
                {id=61; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=23; events=List.fromArray([]); homeClubId=1; kickOff=1728136800000000000; homeGoals=0; gameweek=7; awayGoals=0}, 
                {id=62; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=14; events=List.fromArray([]); homeClubId=2; kickOff=1728136800000000000; homeGoals=0; gameweek=7; awayGoals=0}, 
                {id=63; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=20; events=List.fromArray([]); homeClubId=4; kickOff=1728136800000000000; homeGoals=0; gameweek=7; awayGoals=0}, 
                {id=64; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=18; events=List.fromArray([]); homeClubId=5; kickOff=1728136800000000000; homeGoals=0; gameweek=7; awayGoals=0}, 
                {id=65; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=16; events=List.fromArray([]); homeClubId=7; kickOff=1728136800000000000; homeGoals=0; gameweek=7; awayGoals=0}, 
                {id=66; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=11; events=List.fromArray([]); homeClubId=8; kickOff=1728136800000000000; homeGoals=0; gameweek=7; awayGoals=0}, 
                {id=67; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=15; events=List.fromArray([]); homeClubId=9; kickOff=1728136800000000000; homeGoals=0; gameweek=7; awayGoals=0}, 
                {id=68; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=3; events=List.fromArray([]); homeClubId=21; kickOff=1728136800000000000; homeGoals=0; gameweek=7; awayGoals=0}, 
                {id=69; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=10; events=List.fromArray([]); homeClubId=13; kickOff=1728136800000000000; homeGoals=0; gameweek=7; awayGoals=0}, 
                {id=70; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=22; events=List.fromArray([]); homeClubId=19; kickOff=1728136800000000000; homeGoals=0; gameweek=7; awayGoals=0}, 
                {id=71; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=1; events=List.fromArray([]); homeClubId=3; kickOff=1729346400000000000; homeGoals=0; gameweek=8; awayGoals=0}, 
                {id=72; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=2; events=List.fromArray([]); homeClubId=10; kickOff=1729346400000000000; homeGoals=0; gameweek=8; awayGoals=0}, 
                {id=73; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=9; events=List.fromArray([]); homeClubId=22; kickOff=1729346400000000000; homeGoals=0; gameweek=8; awayGoals=0}, 
                {id=74; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=7; events=List.fromArray([]); homeClubId=11; kickOff=1729346400000000000; homeGoals=0; gameweek=8; awayGoals=0}, 
                {id=75; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=4; events=List.fromArray([]); homeClubId=14; kickOff=1729346400000000000; homeGoals=0; gameweek=8; awayGoals=0}, 
                {id=76; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=5; events=List.fromArray([]); homeClubId=15; kickOff=1729346400000000000; homeGoals=0; gameweek=8; awayGoals=0}, 
                {id=77; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=8; events=List.fromArray([]); homeClubId=16; kickOff=1729346400000000000; homeGoals=0; gameweek=8; awayGoals=0}, 
                {id=78; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=21; events=List.fromArray([]); homeClubId=23; kickOff=1729346400000000000; homeGoals=0; gameweek=8; awayGoals=0}, 
                {id=79; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=19; events=List.fromArray([]); homeClubId=18; kickOff=1729346400000000000; homeGoals=0; gameweek=8; awayGoals=0}, 
                {id=80; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=13; events=List.fromArray([]); homeClubId=20; kickOff=1729346400000000000; homeGoals=0; gameweek=8; awayGoals=0}, 
                {id=81; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=11; events=List.fromArray([]); homeClubId=1; kickOff=1729951200000000000; homeGoals=0; gameweek=9; awayGoals=0}, 
                {id=82; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=3; events=List.fromArray([]); homeClubId=2; kickOff=1729951200000000000; homeGoals=0; gameweek=9; awayGoals=0}, 
                {id=83; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=22; events=List.fromArray([]); homeClubId=4; kickOff=1729951200000000000; homeGoals=0; gameweek=9; awayGoals=0}, 
                {id=84; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=20; events=List.fromArray([]); homeClubId=5; kickOff=1729951200000000000; homeGoals=0; gameweek=9; awayGoals=0}, 
                {id=85; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=15; events=List.fromArray([]); homeClubId=7; kickOff=1729951200000000000; homeGoals=0; gameweek=9; awayGoals=0}, 
                {id=86; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=18; events=List.fromArray([]); homeClubId=8; kickOff=1729951200000000000; homeGoals=0; gameweek=9; awayGoals=0}, 
                {id=87; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=10; events=List.fromArray([]); homeClubId=9; kickOff=1729951200000000000; homeGoals=0; gameweek=9; awayGoals=0}, 
                {id=88; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=16; events=List.fromArray([]); homeClubId=21; kickOff=1729951200000000000; homeGoals=0; gameweek=9; awayGoals=0}, 
                {id=89; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=23; events=List.fromArray([]); homeClubId=13; kickOff=1729951200000000000; homeGoals=0; gameweek=9; awayGoals=0}, 
                {id=90; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=14; events=List.fromArray([]); homeClubId=19; kickOff=1729951200000000000; homeGoals=0; gameweek=9; awayGoals=0}, 
                {id=91; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=13; events=List.fromArray([]); homeClubId=3; kickOff=1730556000000000000; homeGoals=0; gameweek=10; awayGoals=0},
                {id=92; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=4; events=List.fromArray([]); homeClubId=10; kickOff=1730556000000000000; homeGoals=0; gameweek=10; awayGoals=0}, 
                {id=93; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=21; events=List.fromArray([]); homeClubId=22; kickOff=1730556000000000000; homeGoals=0; gameweek=10; awayGoals=0}, 
                {id=94; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=5; events=List.fromArray([]); homeClubId=11; kickOff=1730556000000000000; homeGoals=0; gameweek=10; awayGoals=0}, 
                {id=95; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=7; events=List.fromArray([]); homeClubId=14; kickOff=1730556000000000000; homeGoals=0; gameweek=10; awayGoals=0}, 
                {id=96; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=1; events=List.fromArray([]); homeClubId=15; kickOff=1730556000000000000; homeGoals=0; gameweek=10; awayGoals=0}, 
                {id=97; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=19; events=List.fromArray([]); homeClubId=16; kickOff=1730556000000000000; homeGoals=0; gameweek=10; awayGoals=0}, 
                {id=98; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=9; events=List.fromArray([]); homeClubId=23; kickOff=1730556000000000000; homeGoals=0; gameweek=10; awayGoals=0}, 
                {id=99; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=2; events=List.fromArray([]); homeClubId=18; kickOff=1730556000000000000; homeGoals=0; gameweek=10; awayGoals=0}, 
                {id=100; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=8; events=List.fromArray([]); homeClubId=20; kickOff=1730556000000000000; homeGoals=0; gameweek=10; awayGoals=0}, 
                {id=101; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=3; events=List.fromArray([]); homeClubId=4; kickOff=1731160800000000000; homeGoals=0; gameweek=11; awayGoals=0}, 
                {id=102; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=13; events=List.fromArray([]); homeClubId=5; kickOff=1731160800000000000; homeGoals=0; gameweek=11; awayGoals=0}, 
                {id=103; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=1; events=List.fromArray([]); homeClubId=7; kickOff=1731160800000000000; homeGoals=0; gameweek=11; awayGoals=0}, 
                {id=104; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=10; events=List.fromArray([]); homeClubId=8; kickOff=1731160800000000000; homeGoals=0; gameweek=11; awayGoals=0}, 
                {id=105; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=2; events=List.fromArray([]); homeClubId=11; kickOff=1731160800000000000; homeGoals=0; gameweek=11; awayGoals=0}, 
                {id=106; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=21; events=List.fromArray([]); homeClubId=14; kickOff=1731160800000000000; homeGoals=0; gameweek=11; awayGoals=0}, 
                {id=107; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=15; events=List.fromArray([]); homeClubId=16; kickOff=1731160800000000000; homeGoals=0; gameweek=11; awayGoals=0}, 
                {id=108; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=22; events=List.fromArray([]); homeClubId=18; kickOff=1731160800000000000; homeGoals=0; gameweek=11; awayGoals=0}, 
                {id=109; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=9; events=List.fromArray([]); homeClubId=19; kickOff=1731160800000000000; homeGoals=0; gameweek=11; awayGoals=0}, 
                {id=110; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=23; events=List.fromArray([]); homeClubId=20; kickOff=1731160800000000000; homeGoals=0; gameweek=11; awayGoals=0}, 
                {id=111; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=16; events=List.fromArray([]); homeClubId=1; kickOff=1732370400000000000; homeGoals=0; gameweek=12; awayGoals=0}, 
                {id=112; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=8; events=List.fromArray([]); homeClubId=2; kickOff=1732370400000000000; homeGoals=0; gameweek=12; awayGoals=0}, 
                {id=113; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=5; events=List.fromArray([]); homeClubId=3; kickOff=1732370400000000000; homeGoals=0; gameweek=12; awayGoals=0}, 
                {id=114; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=4; events=List.fromArray([]); homeClubId=9; kickOff=1732370400000000000; homeGoals=0; gameweek=12; awayGoals=0}, 
                {id=115; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=20; events=List.fromArray([]); homeClubId=10; kickOff=1732370400000000000; homeGoals=0; gameweek=12; awayGoals=0}, 
                {id=116; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=14; events=List.fromArray([]); homeClubId=22; kickOff=1732370400000000000; homeGoals=0; gameweek=12; awayGoals=0}, 
                {id=117; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=7; events=List.fromArray([]); homeClubId=21; kickOff=1732370400000000000; homeGoals=0; gameweek=12; awayGoals=0}, 
                {id=118; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=18; events=List.fromArray([]); homeClubId=13; kickOff=1732370400000000000; homeGoals=0; gameweek=12; awayGoals=0}, 
                {id=119; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=19; events=List.fromArray([]); homeClubId=15; kickOff=1732370400000000000; homeGoals=0; gameweek=12; awayGoals=0}, 
                {id=120; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=11; events=List.fromArray([]); homeClubId=23; kickOff=1732370400000000000; homeGoals=0; gameweek=12; awayGoals=0},
                {id=121; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=21; events=List.fromArray([]); homeClubId=4; kickOff=1732975200000000000; homeGoals=0; gameweek=13; awayGoals=0},
                {id=122; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=23; events=List.fromArray([]); homeClubId=5; kickOff=1732975200000000000; homeGoals=0; gameweek=13; awayGoals=0}, 
                {id=123; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=2; events=List.fromArray([]); homeClubId=7; kickOff=1732975200000000000; homeGoals=0; gameweek=13; awayGoals=0}, 
                {id=124; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=15; events=List.fromArray([]); homeClubId=8; kickOff=1732975200000000000; homeGoals=0; gameweek=13; awayGoals=0}, 
                {id=125; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=13; events=List.fromArray([]); homeClubId=11; kickOff=1732975200000000000; homeGoals=0; gameweek=13; awayGoals=0}, 
                {id=126; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=9; events=List.fromArray([]); homeClubId=14; kickOff=1732975200000000000; homeGoals=0; gameweek=13; awayGoals=0}, 
                {id=127; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=22; events=List.fromArray([]); homeClubId=16; kickOff=1732975200000000000; homeGoals=0; gameweek=13; awayGoals=0}, 
                {id=128; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=10; events=List.fromArray([]); homeClubId=18; kickOff=1732975200000000000; homeGoals=0; gameweek=13; awayGoals=0}, 
                {id=129; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=1; events=List.fromArray([]); homeClubId=19; kickOff=1732975200000000000; homeGoals=0; gameweek=13; awayGoals=0}, 
                {id=130; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=3; events=List.fromArray([]); homeClubId=20; kickOff=1732975200000000000; homeGoals=0; gameweek=13; awayGoals=0}, 
                {id=131; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=14; events=List.fromArray([]); homeClubId=1; kickOff=1733251500000000000; homeGoals=0; gameweek=14; awayGoals=0}, 
                {id=132; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=4; events=List.fromArray([]); homeClubId=2; kickOff=1733251500000000000; homeGoals=0; gameweek=14; awayGoals=0}, 
                {id=133; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=18; events=List.fromArray([]); homeClubId=3; kickOff=1733251500000000000; homeGoals=0; gameweek=14; awayGoals=0}, 
                {id=134; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=20; events=List.fromArray([]); homeClubId=9; kickOff=1733251500000000000; homeGoals=0; gameweek=14; awayGoals=0}, 
                {id=135; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=5; events=List.fromArray([]); homeClubId=10; kickOff=1733251500000000000; homeGoals=0; gameweek=14; awayGoals=0}, 
                {id=136; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=8; events=List.fromArray([]); homeClubId=22; kickOff=1733251500000000000; homeGoals=0; gameweek=14; awayGoals=0}, 
                {id=137; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=19; events=List.fromArray([]); homeClubId=21; kickOff=1733251500000000000; homeGoals=0; gameweek=14; awayGoals=0}, 
                {id=138; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=16; events=List.fromArray([]); homeClubId=13; kickOff=1733337900000000000; homeGoals=0; gameweek=14; awayGoals=0}, 
                {id=139; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=11; events=List.fromArray([]); homeClubId=15; kickOff=1733337900000000000; homeGoals=0; gameweek=14; awayGoals=0}, 
                {id=140; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=7; events=List.fromArray([]); homeClubId=23; kickOff=1733337900000000000; homeGoals=0; gameweek=14; awayGoals=0}, 
                {id=141; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=23; events=List.fromArray([]); homeClubId=2; kickOff=1733580000000000000; homeGoals=0; gameweek=15; awayGoals=0}, 
                {id=142; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=15; events=List.fromArray([]); homeClubId=4; kickOff=1733580000000000000; homeGoals=0; gameweek=15; awayGoals=0}, 
                {id=143; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=13; events=List.fromArray([]); homeClubId=8; kickOff=1733580000000000000; homeGoals=0; gameweek=15; awayGoals=0}, 
                {id=144; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=11; events=List.fromArray([]); homeClubId=9; kickOff=1733580000000000000; homeGoals=0; gameweek=15; awayGoals=0}, 
                {id=145; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=1; events=List.fromArray([]); homeClubId=10; kickOff=1733580000000000000; homeGoals=0; gameweek=15; awayGoals=0}, 
                {id=146; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=3; events=List.fromArray([]); homeClubId=22; kickOff=1733580000000000000; homeGoals=0; gameweek=15; awayGoals=0}, 
                {id=147; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=5; events=List.fromArray([]); homeClubId=21; kickOff=1733580000000000000; homeGoals=0; gameweek=15; awayGoals=0}, 
                {id=148; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=16; events=List.fromArray([]); homeClubId=14; kickOff=1733580000000000000; homeGoals=0; gameweek=15; awayGoals=0}, 
                {id=149; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=7; events=List.fromArray([]); homeClubId=18; kickOff=1733580000000000000; homeGoals=0; gameweek=15; awayGoals=0},
                {id=150; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=20; events=List.fromArray([]); homeClubId=19; kickOff=1733580000000000000; homeGoals=0; gameweek=15; awayGoals=0}, 
                {id=151; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=9; events=List.fromArray([]); homeClubId=1; kickOff=1734184800000000000; homeGoals=0; gameweek=16; awayGoals=0}, 
                {id=152; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=19; events=List.fromArray([]); homeClubId=3; kickOff=1734184800000000000; homeGoals=0; gameweek=16; awayGoals=0}, 
                {id=153; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=8; events=List.fromArray([]); homeClubId=5; kickOff=1734184800000000000; homeGoals=0; gameweek=16; awayGoals=0}, 
                {id=154; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=4; events=List.fromArray([]); homeClubId=7; kickOff=1734184800000000000; homeGoals=0; gameweek=16; awayGoals=0}, 
                {id=155; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=10; events=List.fromArray([]); homeClubId=11; kickOff=1734184800000000000; homeGoals=0; gameweek=16; awayGoals=0}, 
                {id=156; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=14; events=List.fromArray([]); homeClubId=13; kickOff=1734184800000000000; homeGoals=0; gameweek=16; awayGoals=0}, 
                {id=157; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=21; events=List.fromArray([]); homeClubId=15; kickOff=1734184800000000000; homeGoals=0; gameweek=16; awayGoals=0}, 
                {id=158; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=2; events=List.fromArray([]); homeClubId=16; kickOff=1734184800000000000; homeGoals=0; gameweek=16; awayGoals=0}, 
                {id=159; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=18; events=List.fromArray([]); homeClubId=23; kickOff=1734184800000000000; homeGoals=0; gameweek=16; awayGoals=0}, 
                {id=160; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=22; events=List.fromArray([]); homeClubId=20; kickOff=1734184800000000000; homeGoals=0; gameweek=16; awayGoals=0}, 
                {id=161; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=13; events=List.fromArray([]); homeClubId=2; kickOff=1734789600000000000; homeGoals=0; gameweek=17; awayGoals=0}, 
                {id=162; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=16; events=List.fromArray([]); homeClubId=4; kickOff=1734789600000000000; homeGoals=0; gameweek=17; awayGoals=0}, 
                {id=163; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=1; events=List.fromArray([]); homeClubId=8; kickOff=1734789600000000000; homeGoals=0; gameweek=17; awayGoals=0}, 
                {id=164; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=7; events=List.fromArray([]); homeClubId=9; kickOff=1734789600000000000; homeGoals=0; gameweek=17; awayGoals=0}, 
                {id=165; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=23; events=List.fromArray([]); homeClubId=10; kickOff=1734789600000000000; homeGoals=0; gameweek=17; awayGoals=0}, 
                {id=166; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=15; events=List.fromArray([]); homeClubId=22; kickOff=1734789600000000000; homeGoals=0; gameweek=17; awayGoals=0}, 
                {id=167; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=20; events=List.fromArray([]); homeClubId=21; kickOff=1734789600000000000; homeGoals=0; gameweek=17; awayGoals=0}, 
                {id=168; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=3; events=List.fromArray([]); homeClubId=14; kickOff=1734789600000000000; homeGoals=0; gameweek=17; awayGoals=0},
                {id=169; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=11; events=List.fromArray([]); homeClubId=18; kickOff=1734789600000000000; homeGoals=0; gameweek=17; awayGoals=0}, 
                {id=170; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=5; events=List.fromArray([]); homeClubId=19; kickOff=1734789600000000000; homeGoals=0; gameweek=17; awayGoals=0}, 
                {id=171; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=22; events=List.fromArray([]); homeClubId=1; kickOff=1735221600000000000; homeGoals=0; gameweek=18; awayGoals=0}, 
                {id=172; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=8; events=List.fromArray([]); homeClubId=3; kickOff=1735221600000000000; homeGoals=0; gameweek=18; awayGoals=0}, 
                {id=173; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=4; events=List.fromArray([]); homeClubId=5; kickOff=1735221600000000000; homeGoals=0; gameweek=18; awayGoals=0}, 
                {id=174; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=10; events=List.fromArray([]); homeClubId=7; kickOff=1735221600000000000; homeGoals=0; gameweek=18; awayGoals=0}, 
                {id=175; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=21; events=List.fromArray([]); homeClubId=11; kickOff=1735221600000000000; homeGoals=0; gameweek=18; awayGoals=0}, 
                {id=176; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=9; events=List.fromArray([]); homeClubId=13; kickOff=1735221600000000000; homeGoals=0; gameweek=18; awayGoals=0}, 
                {id=177; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=2; events=List.fromArray([]); homeClubId=15; kickOff=1735221600000000000; homeGoals=0; gameweek=18; awayGoals=0}, 
                {id=178; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=18; events=List.fromArray([]); homeClubId=16; kickOff=1735221600000000000; homeGoals=0; gameweek=18; awayGoals=0}, 
                {id=179; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=19; events=List.fromArray([]); homeClubId=23; kickOff=1735221600000000000; homeGoals=0; gameweek=18; awayGoals=0}, 
                {id=180; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=14; events=List.fromArray([]); homeClubId=20; kickOff=1735221600000000000; homeGoals=0; gameweek=18; awayGoals=0}, 
                {id=181; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=5; events=List.fromArray([]); homeClubId=2; kickOff=1735480800000000000; homeGoals=0; gameweek=19; awayGoals=0},
                {id=182; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=1; events=List.fromArray([]); homeClubId=4; kickOff=1735480800000000000; homeGoals=0; gameweek=19; awayGoals=0}, 
                {id=183; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=23; events=List.fromArray([]); homeClubId=8; kickOff=1735480800000000000; homeGoals=0; gameweek=19; awayGoals=0}, 
                {id=184; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=16; events=List.fromArray([]); homeClubId=9; kickOff=1735480800000000000; homeGoals=0; gameweek=19; awayGoals=0},
                {id=185; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=3; events=List.fromArray([]); homeClubId=10; kickOff=1735480800000000000; homeGoals=0; gameweek=19; awayGoals=0}, 
                {id=186; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=7; events=List.fromArray([]); homeClubId=22; kickOff=1735480800000000000; homeGoals=0; gameweek=19; awayGoals=0}, 
                {id=187; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=13; events=List.fromArray([]); homeClubId=21; kickOff=1735480800000000000; homeGoals=0; gameweek=19; awayGoals=0}, 
                {id=188; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=15; events=List.fromArray([]); homeClubId=14; kickOff=1735480800000000000; homeGoals=0; gameweek=19; awayGoals=0}, 
                {id=189; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=20; events=List.fromArray([]); homeClubId=18; kickOff=1735480800000000000; homeGoals=0; gameweek=19; awayGoals=0}, 
                {id=190; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=11; events=List.fromArray([]); homeClubId=19; kickOff=1735480800000000000; homeGoals=0; gameweek=19; awayGoals=0}, 
                {id=191; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=21; events=List.fromArray([]); homeClubId=2; kickOff=1735999200000000000; homeGoals=0; gameweek=20; awayGoals=0},
                {id=192; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=9; events=List.fromArray([]); homeClubId=3; kickOff=1735999200000000000; homeGoals=0; gameweek=20; awayGoals=0},
                {id=193; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=1; events=List.fromArray([]); homeClubId=5; kickOff=1735999200000000000; homeGoals=0; gameweek=20; awayGoals=0},
                {id=194; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=7; events=List.fromArray([]); homeClubId=8; kickOff=1735999200000000000; homeGoals=0; gameweek=20; awayGoals=0}, 
                {id=195; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=22; events=List.fromArray([]); homeClubId=10; kickOff=1735999200000000000; homeGoals=0; gameweek=20; awayGoals=0}, 
                {id=196; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=14; events=List.fromArray([]); homeClubId=11; kickOff=1735999200000000000; homeGoals=0; gameweek=20; awayGoals=0}, 
                {id=197; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=19; events=List.fromArray([]); homeClubId=13; kickOff=1735999200000000000; homeGoals=0; gameweek=20; awayGoals=0}, 
                {id=198; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=4; events=List.fromArray([]); homeClubId=23; kickOff=1735999200000000000; homeGoals=0; gameweek=20; awayGoals=0}, 
                {id=199; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=15; events=List.fromArray([]); homeClubId=18; kickOff=1735999200000000000; homeGoals=0; gameweek=20; awayGoals=0}, 
                {id=200; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=16; events=List.fromArray([]); homeClubId=20; kickOff=1735999200000000000; homeGoals=0; gameweek=20; awayGoals=0}, 
                {id=201; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=18; events=List.fromArray([]); homeClubId=1; kickOff=1736880300000000000; homeGoals=0; gameweek=21; awayGoals=0}, 
                {id=202; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=13; events=List.fromArray([]); homeClubId=4; kickOff=1736880300000000000; homeGoals=0; gameweek=21; awayGoals=0}, 
                {id=203; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=2; events=List.fromArray([]); homeClubId=9; kickOff=1736880300000000000; homeGoals=0; gameweek=21; awayGoals=0}, 
                {id=204; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=5; events=List.fromArray([]); homeClubId=22; kickOff=1736880300000000000; homeGoals=0; gameweek=21; awayGoals=0}, 
                {id=205; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=8; events=List.fromArray([]); homeClubId=21; kickOff=1736880300000000000; homeGoals=0; gameweek=21; awayGoals=0}, 
                {id=206; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=11; events=List.fromArray([]); homeClubId=16; kickOff=1736880300000000000; homeGoals=0; gameweek=21; awayGoals=0}, 
                {id=207; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=10; events=List.fromArray([]); homeClubId=19; kickOff=1736880300000000000; homeGoals=0; gameweek=21; awayGoals=0}, 
                {id=208; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=3; events=List.fromArray([]); homeClubId=7; kickOff=1736966700000000000; homeGoals=0; gameweek=21; awayGoals=0}, 
                {id=209; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=20; events=List.fromArray([]); homeClubId=15; kickOff=1736966700000000000; homeGoals=0; gameweek=21; awayGoals=0}, 
                {id=210; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=23; events=List.fromArray([]); homeClubId=14; kickOff=1736967600000000000; homeGoals=0; gameweek=21; awayGoals=0}, 
                {id=211; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=2; events=List.fromArray([]); homeClubId=1; kickOff=1737208800000000000; homeGoals=0; gameweek=22; awayGoals=0},
                {id=212; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=11; events=List.fromArray([]); homeClubId=4; kickOff=1737208800000000000; homeGoals=0; gameweek=22; awayGoals=0}, 
                {id=213; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=20; events=List.fromArray([]); homeClubId=7; kickOff=1737208800000000000; homeGoals=0; gameweek=22; awayGoals=0}, 
                {id=214; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=18; events=List.fromArray([]); homeClubId=9; kickOff=1737208800000000000; homeGoals=0; gameweek=22; awayGoals=0}, 
                {id=215; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=13; events=List.fromArray([]); homeClubId=22; kickOff=1737208800000000000; homeGoals=0; gameweek=22; awayGoals=0}, 
                {id=216; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=10; events=List.fromArray([]); homeClubId=21; kickOff=1737208800000000000; homeGoals=0; gameweek=22; awayGoals=0}, 
                {id=217; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=5; events=List.fromArray([]); homeClubId=14; kickOff=1737208800000000000; homeGoals=0; gameweek=22; awayGoals=0}, 
                {id=218; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=3; events=List.fromArray([]); homeClubId=15; kickOff=1737208800000000000; homeGoals=0; gameweek=22; awayGoals=0}, 
                {id=219; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=23; events=List.fromArray([]); homeClubId=16; kickOff=1737208800000000000; homeGoals=0; gameweek=22; awayGoals=0}, 
                {id=220; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=8; events=List.fromArray([]); homeClubId=19; kickOff=1737208800000000000; homeGoals=0; gameweek=22; awayGoals=0}, 
                {id=221; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=19; events=List.fromArray([]); homeClubId=2; kickOff=1737813600000000000; homeGoals=0; gameweek=23; awayGoals=0}, 
                {id=222; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=16; events=List.fromArray([]); homeClubId=3; kickOff=1737813600000000000; homeGoals=0; gameweek=23; awayGoals=0}, 
                {id=223; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=9; events=List.fromArray([]); homeClubId=5; kickOff=1737813600000000000; homeGoals=0; gameweek=23; awayGoals=0}, 
                {id=224; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=4; events=List.fromArray([]); homeClubId=8; kickOff=1737813600000000000; homeGoals=0; gameweek=23; awayGoals=0}, 
                {id=225; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=14; events=List.fromArray([]); homeClubId=10; kickOff=1737813600000000000; homeGoals=0; gameweek=23; awayGoals=0}, 
                {id=226; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=22; events=List.fromArray([]); homeClubId=11; kickOff=1737813600000000000; homeGoals=0; gameweek=23; awayGoals=0}, 
                {id=227; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=7; events=List.fromArray([]); homeClubId=13; kickOff=1737813600000000000; homeGoals=0; gameweek=23; awayGoals=0}, 
                {id=228; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=15; events=List.fromArray([]); homeClubId=23; kickOff=1737813600000000000; homeGoals=0; gameweek=23; awayGoals=0}, 
                {id=229; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=21; events=List.fromArray([]); homeClubId=18; kickOff=1737813600000000000; homeGoals=0; gameweek=23; awayGoals=0}, 
                {id=230; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=1; events=List.fromArray([]); homeClubId=20; kickOff=1737813600000000000; homeGoals=0; gameweek=23; awayGoals=0}, 
                {id=231; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=13; events=List.fromArray([]); homeClubId=1; kickOff=1738418400000000000; homeGoals=0; gameweek=24; awayGoals=0}, 
                {id=232; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=11; events=List.fromArray([]); homeClubId=3; kickOff=1738418400000000000; homeGoals=0; gameweek=24; awayGoals=0}, 
                {id=233; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=18; events=List.fromArray([]); homeClubId=4; kickOff=1738418400000000000; homeGoals=0; gameweek=24; awayGoals=0}, 
                {id=234; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=19; events=List.fromArray([]); homeClubId=7; kickOff=1738418400000000000; homeGoals=0; gameweek=24; awayGoals=0}, 
                {id=235; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=21; events=List.fromArray([]); homeClubId=9; kickOff=1738418400000000000; homeGoals=0; gameweek=24; awayGoals=0}, 
                {id=236; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=23; events=List.fromArray([]); homeClubId=22; kickOff=1738418400000000000; homeGoals=0; gameweek=24; awayGoals=0}, 
                {id=237; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=8; events=List.fromArray([]); homeClubId=14; kickOff=1738418400000000000; homeGoals=0; gameweek=24; awayGoals=0}, 
                {id=238; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=10; events=List.fromArray([]); homeClubId=15; kickOff=1738418400000000000; homeGoals=0; gameweek=24; awayGoals=0}, 
                {id=239; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=5; events=List.fromArray([]); homeClubId=16; kickOff=1738418400000000000; homeGoals=0; gameweek=24; awayGoals=0}, 
                {id=240; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=2; events=List.fromArray([]); homeClubId=20; kickOff=1738418400000000000; homeGoals=0; gameweek=24; awayGoals=0}, 
                {id=241; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=22; events=List.fromArray([]); homeClubId=2; kickOff=1739628000000000000; homeGoals=0; gameweek=25; awayGoals=0}, 
                {id=242; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=7; events=List.fromArray([]); homeClubId=5; kickOff=1739628000000000000; homeGoals=0; gameweek=25; awayGoals=0}, 
                {id=243; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=9; events=List.fromArray([]); homeClubId=8; kickOff=1739628000000000000; homeGoals=0; gameweek=25; awayGoals=0}, 
                {id=244; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=16; events=List.fromArray([]); homeClubId=10; kickOff=1739628000000000000; homeGoals=0; gameweek=25; awayGoals=0}, 
                {id=245; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=1; events=List.fromArray([]); homeClubId=21; kickOff=1739628000000000000; homeGoals=0; gameweek=25; awayGoals=0}, 
                {id=246; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=20; events=List.fromArray([]); homeClubId=11; kickOff=1739628000000000000; homeGoals=0; gameweek=25; awayGoals=0}, 
                {id=247; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=15; events=List.fromArray([]); homeClubId=13; kickOff=1739628000000000000; homeGoals=0; gameweek=25; awayGoals=0}, 
                {id=248; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=3; events=List.fromArray([]); homeClubId=23; kickOff=1739628000000000000; homeGoals=0; gameweek=25; awayGoals=0}, 
                {id=249; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=14; events=List.fromArray([]); homeClubId=18; kickOff=1739628000000000000; homeGoals=0; gameweek=25; awayGoals=0}, 
                {id=250; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=4; events=List.fromArray([]); homeClubId=19; kickOff=1739628000000000000; homeGoals=0; gameweek=25; awayGoals=0}, 
                {id=251; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=19; events=List.fromArray([]); homeClubId=1; kickOff=1740232800000000000; homeGoals=0; gameweek=26; awayGoals=0}, 
                {id=252; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=7; events=List.fromArray([]); homeClubId=2; kickOff=1740232800000000000; homeGoals=0; gameweek=26; awayGoals=0}, 
                {id=253; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=20; events=List.fromArray([]); homeClubId=3; kickOff=1740232800000000000; homeGoals=0; gameweek=26; awayGoals=0}, 
                {id=254; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=14; events=List.fromArray([]); homeClubId=9; kickOff=1740232800000000000; homeGoals=0; gameweek=26; awayGoals=0}, 
                {id=255; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=8; events=List.fromArray([]); homeClubId=10; kickOff=1740232800000000000; homeGoals=0; gameweek=26; awayGoals=0}, 
                {id=256; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=18; events=List.fromArray([]); homeClubId=22; kickOff=1740232800000000000; homeGoals=0; gameweek=26; awayGoals=0}, 
                {id=257; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=4; events=List.fromArray([]); homeClubId=21; kickOff=1740232800000000000; homeGoals=0; gameweek=26; awayGoals=0}, 
                {id=258; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=11; events=List.fromArray([]); homeClubId=13; kickOff=1740232800000000000; homeGoals=0; gameweek=26; awayGoals=0}, 
                {id=259; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=16; events=List.fromArray([]); homeClubId=15; kickOff=1740232800000000000; homeGoals=0; gameweek=26; awayGoals=0}, 
                {id=260; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=5; events=List.fromArray([]); homeClubId=23; kickOff=1740232800000000000; homeGoals=0; gameweek=26; awayGoals=0}, 
                {id=261; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=9; events=List.fromArray([]); homeClubId=4; kickOff=1740509100000000000; homeGoals=0; gameweek=27; awayGoals=0}, 
                {id=262; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=3; events=List.fromArray([]); homeClubId=5; kickOff=1740509100000000000; homeGoals=0; gameweek=27; awayGoals=0}, 
                {id=263; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=1; events=List.fromArray([]); homeClubId=16; kickOff=1740509100000000000; homeGoals=0; gameweek=27; awayGoals=0}, 
                {id=264; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=13; events=List.fromArray([]); homeClubId=18; kickOff=1740509100000000000; homeGoals=0; gameweek=27; awayGoals=0}, 
                {id=265; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=21; events=List.fromArray([]); homeClubId=19; kickOff=1740509100000000000; homeGoals=0; gameweek=27; awayGoals=0}, 
                {id=266; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=10; events=List.fromArray([]); homeClubId=20; kickOff=1740509100000000000; homeGoals=0; gameweek=27; awayGoals=0}, 
                {id=267; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=2; events=List.fromArray([]); homeClubId=8; kickOff=1740510000000000000; homeGoals=0; gameweek=27; awayGoals=0}, 
                {id=268; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=23; events=List.fromArray([]); homeClubId=7; kickOff=1740595500000000000; homeGoals=0; gameweek=27; awayGoals=0}, 
                {id=269; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=15; events=List.fromArray([]); homeClubId=11; kickOff=1740596400000000000; homeGoals=0; gameweek=27; awayGoals=0}, 
                {id=270; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=22; events=List.fromArray([]); homeClubId=14; kickOff=1740596400000000000; homeGoals=0; gameweek=27; awayGoals=0}, 
                {id=271; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=2; events=List.fromArray([]); homeClubId=4; kickOff=1741442400000000000; homeGoals=0; gameweek=28; awayGoals=0}, 
                {id=272; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=10; events=List.fromArray([]); homeClubId=5; kickOff=1741442400000000000; homeGoals=0; gameweek=28; awayGoals=0}, 
                {id=273; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=21; events=List.fromArray([]); homeClubId=7; kickOff=1741442400000000000; homeGoals=0; gameweek=28; awayGoals=0}, 
                {id=274; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=22; events=List.fromArray([]); homeClubId=8; kickOff=1741442400000000000; homeGoals=0; gameweek=28; awayGoals=0}, 
                {id=275; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=23; events=List.fromArray([]); homeClubId=11; kickOff=1741442400000000000; homeGoals=0; gameweek=28; awayGoals=0}, 
                {id=276; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=1; events=List.fromArray([]); homeClubId=14; kickOff=1741442400000000000; homeGoals=0; gameweek=28; awayGoals=0}, 
                {id=277; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=13; events=List.fromArray([]); homeClubId=16; kickOff=1741442400000000000; homeGoals=0; gameweek=28; awayGoals=0}, 
                {id=278; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=3; events=List.fromArray([]); homeClubId=18; kickOff=1741442400000000000; homeGoals=0; gameweek=28; awayGoals=0}, 
                {id=279; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=15; events=List.fromArray([]); homeClubId=19; kickOff=1741442400000000000; homeGoals=0; gameweek=28; awayGoals=0}, 
                {id=280; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=9; events=List.fromArray([]); homeClubId=20; kickOff=1741442400000000000; homeGoals=0; gameweek=28; awayGoals=0}, 
                {id=281; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=7; events=List.fromArray([]); homeClubId=1; kickOff=1742047200000000000; homeGoals=0; gameweek=29; awayGoals=0}, 
                {id=282; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=11; events=List.fromArray([]); homeClubId=2; kickOff=1742047200000000000; homeGoals=0; gameweek=29; awayGoals=0}, 
                {id=283; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=4; events=List.fromArray([]); homeClubId=3; kickOff=1742047200000000000; homeGoals=0; gameweek=29; awayGoals=0}, 
                {id=284; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=19; events=List.fromArray([]); homeClubId=9; kickOff=1742047200000000000; homeGoals=0; gameweek=29; awayGoals=0}, 
                {id=285; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=18; events=List.fromArray([]); homeClubId=10; kickOff=1742047200000000000; homeGoals=0; gameweek=29; awayGoals=0}, 
                {id=286; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=16; events=List.fromArray([]); homeClubId=22; kickOff=1742047200000000000; homeGoals=0; gameweek=29; awayGoals=0}, 
                {id=287; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=14; events=List.fromArray([]); homeClubId=21; kickOff=1742047200000000000; homeGoals=0; gameweek=29; awayGoals=0}, 
                {id=288; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=5; events=List.fromArray([]); homeClubId=13; kickOff=1742047200000000000; homeGoals=0; gameweek=29; awayGoals=0}, 
                {id=289; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=8; events=List.fromArray([]); homeClubId=15; kickOff=1742047200000000000; homeGoals=0; gameweek=29; awayGoals=0}, 
                {id=290; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=20; events=List.fromArray([]); homeClubId=23; kickOff=1742047200000000000; homeGoals=0; gameweek=29; awayGoals=0}, 
                {id=291; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=10; events=List.fromArray([]); homeClubId=1; kickOff=1743533100000000000; homeGoals=0; gameweek=30; awayGoals=0}, 
                {id=292; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=22; events=List.fromArray([]); homeClubId=3; kickOff=1743533100000000000; homeGoals=0; gameweek=30; awayGoals=0}, 
                {id=293; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=2; events=List.fromArray([]); homeClubId=5; kickOff=1743533100000000000; homeGoals=0; gameweek=30; awayGoals=0}, 
                {id=294; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=14; events=List.fromArray([]); homeClubId=16; kickOff=1743533100000000000; homeGoals=0; gameweek=30; awayGoals=0}, 
                {id=295; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=19; events=List.fromArray([]); homeClubId=20; kickOff=1743533100000000000; homeGoals=0; gameweek=30; awayGoals=0}, 
                {id=296; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=18; events=List.fromArray([]); homeClubId=7; kickOff=1743619500000000000; homeGoals=0; gameweek=30; awayGoals=0}, 
                {id=297; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=21; events=List.fromArray([]); homeClubId=13; kickOff=1743619500000000000; homeGoals=0; gameweek=30; awayGoals=0}, 
                {id=298; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=4; events=List.fromArray([]); homeClubId=15; kickOff=1743619500000000000; homeGoals=0; gameweek=30; awayGoals=0}, 
                {id=299; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=8; events=List.fromArray([]); homeClubId=23; kickOff=1743619500000000000; homeGoals=0; gameweek=30; awayGoals=0}, 
                {id=300; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=9; events=List.fromArray([]); homeClubId=11; kickOff=1743620400000000000; homeGoals=0; gameweek=30; awayGoals=0}, 
                {id=301; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=16; events=List.fromArray([]); homeClubId=2; kickOff=1743861600000000000; homeGoals=0; gameweek=31; awayGoals=0}, 
                {id=302; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=7; events=List.fromArray([]); homeClubId=4; kickOff=1743861600000000000; homeGoals=0; gameweek=31; awayGoals=0},
                {id=303; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=5; events=List.fromArray([]); homeClubId=8; kickOff=1743861600000000000; homeGoals=0; gameweek=31; awayGoals=0}, 
                {id=304; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=1; events=List.fromArray([]); homeClubId=9; kickOff=1743861600000000000; homeGoals=0; gameweek=31; awayGoals=0}, 
                {id=305; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=11; events=List.fromArray([]); homeClubId=10; kickOff=1743861600000000000; homeGoals=0; gameweek=31; awayGoals=0}, 
                {id=306; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=20; events=List.fromArray([]); homeClubId=22; kickOff=1743861600000000000; homeGoals=0; gameweek=31; awayGoals=0}, 
                {id=307; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=15; events=List.fromArray([]); homeClubId=21; kickOff=1743861600000000000; homeGoals=0; gameweek=31; awayGoals=0}, 
                {id=308; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=13; events=List.fromArray([]); homeClubId=14; kickOff=1743861600000000000; homeGoals=0; gameweek=31; awayGoals=0}, 
                {id=309; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=23; events=List.fromArray([]); homeClubId=18; kickOff=1743861600000000000; homeGoals=0; gameweek=31; awayGoals=0}, 
                {id=310; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=3; events=List.fromArray([]); homeClubId=19; kickOff=1743861600000000000; homeGoals=0; gameweek=31; awayGoals=0}, 
                {id=311; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=4; events=List.fromArray([]); homeClubId=1; kickOff=1744466400000000000; homeGoals=0; gameweek=32; awayGoals=0}, 
                {id=312; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=10; events=List.fromArray([]); homeClubId=3; kickOff=1744466400000000000; homeGoals=0; gameweek=32; awayGoals=0}, 
                {id=313; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=21; events=List.fromArray([]); homeClubId=5; kickOff=1744466400000000000; homeGoals=0; gameweek=32; awayGoals=0}, 
                {id=314; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=22; events=List.fromArray([]); homeClubId=7; kickOff=1744466400000000000; homeGoals=0; gameweek=32; awayGoals=0}, 
                {id=315; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=19; events=List.fromArray([]); homeClubId=11; kickOff=1744466400000000000; homeGoals=0; gameweek=32; awayGoals=0}, 
                {id=316; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=8; events=List.fromArray([]); homeClubId=13; kickOff=1744466400000000000; homeGoals=0; gameweek=32; awayGoals=0}, 
                {id=317; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=14; events=List.fromArray([]); homeClubId=15; kickOff=1744466400000000000; homeGoals=0; gameweek=32; awayGoals=0}, 
                {id=318; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=9; events=List.fromArray([]); homeClubId=16; kickOff=1744466400000000000; homeGoals=0; gameweek=32; awayGoals=0}, 
                {id=319; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=2; events=List.fromArray([]); homeClubId=23; kickOff=1744466400000000000; homeGoals=0; gameweek=32; awayGoals=0}, 
                {id=320; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=18; events=List.fromArray([]); homeClubId=20; kickOff=1744466400000000000; homeGoals=0; gameweek=32; awayGoals=0}, 
                {id=321; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=15; events=List.fromArray([]); homeClubId=2; kickOff=1745071200000000000; homeGoals=0; gameweek=33; awayGoals=0}, 
                {id=322; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=5; events=List.fromArray([]); homeClubId=4; kickOff=1745071200000000000; homeGoals=0; gameweek=33; awayGoals=0}, 
                {id=323; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=3; events=List.fromArray([]); homeClubId=8; kickOff=1745071200000000000; homeGoals=0; gameweek=33; awayGoals=0}, 
                {id=324; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=13; events=List.fromArray([]); homeClubId=9; kickOff=1745071200000000000; homeGoals=0; gameweek=33; awayGoals=0}, 
                {id=325; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=7; events=List.fromArray([]); homeClubId=10; kickOff=1745071200000000000; homeGoals=0; gameweek=33; awayGoals=0}, 
                {id=326; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=1; events=List.fromArray([]); homeClubId=22; kickOff=1745071200000000000; homeGoals=0; gameweek=33; awayGoals=0}, 
                {id=327; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=11; events=List.fromArray([]); homeClubId=21; kickOff=1745071200000000000; homeGoals=0; gameweek=33; awayGoals=0}, 
                {id=328; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=20; events=List.fromArray([]); homeClubId=14; kickOff=1745071200000000000; homeGoals=0; gameweek=33; awayGoals=0}, 
                {id=329; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=16; events=List.fromArray([]); homeClubId=18; kickOff=1745071200000000000; homeGoals=0; gameweek=33; awayGoals=0}, 
                {id=330; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=23; events=List.fromArray([]); homeClubId=19; kickOff=1745071200000000000; homeGoals=0; gameweek=33; awayGoals=0}, 
                {id=331; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=8; events=List.fromArray([]); homeClubId=1; kickOff=1745676000000000000; homeGoals=0; gameweek=34; awayGoals=0}, 
                {id=332; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=14; events=List.fromArray([]); homeClubId=3; kickOff=1745676000000000000; homeGoals=0; gameweek=34; awayGoals=0}, 
                {id=333; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=19; events=List.fromArray([]); homeClubId=5; kickOff=1745676000000000000; homeGoals=0; gameweek=34; awayGoals=0}, 
                {id=334; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=9; events=List.fromArray([]); homeClubId=7; kickOff=1745676000000000000; homeGoals=0; gameweek=34; awayGoals=0}, 
                {id=335; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=18; events=List.fromArray([]); homeClubId=11; kickOff=1745676000000000000; homeGoals=0; gameweek=34; awayGoals=0}, 
                {id=336; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=2; events=List.fromArray([]); homeClubId=13; kickOff=1745676000000000000; homeGoals=0; gameweek=34; awayGoals=0}, 
                {id=337; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=22; events=List.fromArray([]); homeClubId=15; kickOff=1745676000000000000; homeGoals=0; gameweek=34; awayGoals=0}, 
                {id=338; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=4; events=List.fromArray([]); homeClubId=16; kickOff=1745676000000000000; homeGoals=0; gameweek=34; awayGoals=0}, 
                {id=339; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=10; events=List.fromArray([]); homeClubId=23; kickOff=1745676000000000000; homeGoals=0; gameweek=34; awayGoals=0}, 
                {id=340; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=21; events=List.fromArray([]); homeClubId=20; kickOff=1745676000000000000; homeGoals=0; gameweek=34; awayGoals=0}, 
                {id=341; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=3; events=List.fromArray([]); homeClubId=1; kickOff=1746280800000000000; homeGoals=0; gameweek=35; awayGoals=0}, 
                {id=342; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=10; events=List.fromArray([]); homeClubId=2; kickOff=1746280800000000000; homeGoals=0; gameweek=35; awayGoals=0}, 
                {id=343; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=14; events=List.fromArray([]); homeClubId=4; kickOff=1746280800000000000; homeGoals=0; gameweek=35; awayGoals=0}, 
                {id=344; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=15; events=List.fromArray([]); homeClubId=5; kickOff=1746280800000000000; homeGoals=0; gameweek=35; awayGoals=0}, 
                {id=345; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=11; events=List.fromArray([]); homeClubId=7; kickOff=1746280800000000000; homeGoals=0; gameweek=35; awayGoals=0}, 
                {id=346; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=16; events=List.fromArray([]); homeClubId=8; kickOff=1746280800000000000; homeGoals=0; gameweek=35; awayGoals=0}, 
                {id=347; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=22; events=List.fromArray([]); homeClubId=9; kickOff=1746280800000000000; homeGoals=0; gameweek=35; awayGoals=0}, 
                {id=348; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=23; events=List.fromArray([]); homeClubId=21; kickOff=1746280800000000000; homeGoals=0; gameweek=35; awayGoals=0}, 
                {id=349; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=20; events=List.fromArray([]); homeClubId=13; kickOff=1746280800000000000; homeGoals=0; gameweek=35; awayGoals=0}, 
                {id=350; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=18; events=List.fromArray([]); homeClubId=19; kickOff=1746280800000000000; homeGoals=0; gameweek=35; awayGoals=0}, 
                {id=351; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=2; events=List.fromArray([]); homeClubId=3; kickOff=1746885600000000000; homeGoals=0; gameweek=36; awayGoals=0}, 
                {id=352; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=9; events=List.fromArray([]); homeClubId=10; kickOff=1746885600000000000; homeGoals=0; gameweek=36; awayGoals=0}, 
                {id=353; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=4; events=List.fromArray([]); homeClubId=22; kickOff=1746885600000000000; homeGoals=0; gameweek=36; awayGoals=0}, 
                {id=354; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=1; events=List.fromArray([]); homeClubId=11; kickOff=1746885600000000000; homeGoals=0; gameweek=36; awayGoals=0}, 
                {id=355; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=19; events=List.fromArray([]); homeClubId=14; kickOff=1746885600000000000; homeGoals=0; gameweek=36; awayGoals=0}, 
                {id=356; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=7; events=List.fromArray([]); homeClubId=15; kickOff=1746885600000000000; homeGoals=0; gameweek=36; awayGoals=0},
                {id=357; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=21; events=List.fromArray([]); homeClubId=16; kickOff=1746885600000000000; homeGoals=0; gameweek=36; awayGoals=0}, 
                {id=358; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=13; events=List.fromArray([]); homeClubId=23; kickOff=1746885600000000000; homeGoals=0; gameweek=36; awayGoals=0}, 
                {id=359; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=8; events=List.fromArray([]); homeClubId=18; kickOff=1746885600000000000; homeGoals=0; gameweek=36; awayGoals=0}, 
                {id=360; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=5; events=List.fromArray([]); homeClubId=20; kickOff=1746885600000000000; homeGoals=0; gameweek=36; awayGoals=0}, 
                {id=361; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=15; events=List.fromArray([]); homeClubId=1; kickOff=1747576800000000000; homeGoals=0; gameweek=37; awayGoals=0}, 
                {id=362; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=18; events=List.fromArray([]); homeClubId=2; kickOff=1747576800000000000; homeGoals=0; gameweek=37; awayGoals=0}, 
                {id=363; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=10; events=List.fromArray([]); homeClubId=4; kickOff=1747576800000000000; homeGoals=0; gameweek=37; awayGoals=0}, 
                {id=364; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=11; events=List.fromArray([]); homeClubId=5; kickOff=1747576800000000000; homeGoals=0; gameweek=37; awayGoals=0}, 
                {id=365; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=14; events=List.fromArray([]); homeClubId=7; kickOff=1747576800000000000; homeGoals=0; gameweek=37; awayGoals=0}, 
                {id=366; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=20; events=List.fromArray([]); homeClubId=8; kickOff=1747576800000000000; homeGoals=0; gameweek=37; awayGoals=0}, 
                {id=367; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=23; events=List.fromArray([]); homeClubId=9; kickOff=1747576800000000000; homeGoals=0; gameweek=37; awayGoals=0}, 
                {id=368; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=22; events=List.fromArray([]); homeClubId=21; kickOff=1747576800000000000; homeGoals=0; gameweek=37; awayGoals=0}, 
                {id=369; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=3; events=List.fromArray([]); homeClubId=13; kickOff=1747576800000000000; homeGoals=0; gameweek=37; awayGoals=0}, 
                {id=370; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=16; events=List.fromArray([]); homeClubId=19; kickOff=1747576800000000000; homeGoals=0; gameweek=37; awayGoals=0}, 
                {id=371; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=21; events=List.fromArray([]); homeClubId=3; kickOff=1748185200000000000; homeGoals=0; gameweek=38; awayGoals=0}, 
                {id=372; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=13; events=List.fromArray([]); homeClubId=10; kickOff=1748185200000000000; homeGoals=0; gameweek=38; awayGoals=0}, 
                {id=373; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=19; events=List.fromArray([]); homeClubId=22; kickOff=1748185200000000000; homeGoals=0; gameweek=38; awayGoals=0}, 
                {id=374; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=8; events=List.fromArray([]); homeClubId=11; kickOff=1748185200000000000; homeGoals=0; gameweek=38; awayGoals=0}, 
                {id=375; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=2; events=List.fromArray([]); homeClubId=14; kickOff=1748185200000000000; homeGoals=0; gameweek=38; awayGoals=0}, 
                {id=376; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=9; events=List.fromArray([]); homeClubId=15; kickOff=1748185200000000000; homeGoals=0; gameweek=38; awayGoals=0}, 
                {id=377; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=7; events=List.fromArray([]); homeClubId=16; kickOff=1748185200000000000; homeGoals=0; gameweek=38; awayGoals=0}, 
                {id=378; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=1; events=List.fromArray([]); homeClubId=23; kickOff=1748185200000000000; homeGoals=0; gameweek=38; awayGoals=0}, 
                {id=379; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=5; events=List.fromArray([]); homeClubId=18; kickOff=1748185200000000000; homeGoals=0; gameweek=38; awayGoals=0}, 
                {id=380; status=#Unplayed; highestScoringPlayerId=0; seasonId=1; awayClubId=4; events=List.fromArray([]); homeClubId=20; kickOff=1748185200000000000; homeGoals=0; gameweek=38; awayGoals=0}
              ]);
            }
          ]
        ),
        (2, 
          [
            {
              id = 1;
              name = "2024/25";
              postponedFixtures = List.fromArray([]);
              rewardPool = {
                allTimeMonthlyHighScorePool = 0;
                allTimeSeasonHighScorePool = 0;
                allTimeWeeklyHighScorePool = 0;
                highestScoringMatchPlayerPool = 0;
                monthlyLeaderboardPool = 0;
                mostValuableTeamPool = 0;
                seasonId = 2;
                seasonLeaderboardPool = 0;
                weeklyLeaderboardPool = 0;
              };
              year = 2024;
              fixtures = List.fromArray<T.Fixture>([
                {id=1; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=2; events=List.fromArray([]); homeClubId=4; kickOff=1726862400000000000; homeGoals=0; gameweek=1; awayGoals=0 },
                {id=2; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=12; events=List.fromArray([]); homeClubId=10; kickOff=1726930800000000000; homeGoals=0; gameweek=1; awayGoals=0 },
                {id=3; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=6; events=List.fromArray([]); homeClubId=3; kickOff=1726930800000000000; homeGoals=0; gameweek=1; awayGoals=0 },
                {id=4; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=9; events=List.fromArray([]); homeClubId=1; kickOff=1727017200000000000; homeGoals=0; gameweek=1; awayGoals=0 },
                {id=5; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=5; events=List.fromArray([]); homeClubId=11; kickOff=1727017200000000000; homeGoals=0; gameweek=1; awayGoals=0 },
                {id=6; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=7; events=List.fromArray([]); homeClubId=8; kickOff=1727017200000000000; homeGoals=0; gameweek=1; awayGoals=0 },
                {id=7; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=4; events=List.fromArray([]); homeClubId=5; kickOff=1727467200000000000; homeGoals=0; gameweek=2; awayGoals=0 },
                {id=8; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=3; events=List.fromArray([]); homeClubId=9; kickOff=1727622000000000000; homeGoals=0; gameweek=2; awayGoals=0 },
                {id=9; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=10; events=List.fromArray([]); homeClubId=6; kickOff=1727622000000000000; homeGoals=0; gameweek=2; awayGoals=0 },
                {id=10; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=8; events=List.fromArray([]); homeClubId=12; kickOff=1727622000000000000; homeGoals=0; gameweek=2; awayGoals=0 },
                {id=11; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=1; events=List.fromArray([]); homeClubId=7; kickOff=1727622000000000000; homeGoals=0; gameweek=2; awayGoals=0 },
                {id=12; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=11; events=List.fromArray([]); homeClubId=2; kickOff=1727622000000000000; homeGoals=0; gameweek=2; awayGoals=0 },
                {id=13; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=2; events=List.fromArray([]); homeClubId=3; kickOff=1728131400000000000; homeGoals=0; gameweek=3; awayGoals=0 },
                {id=14; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=12; events=List.fromArray([]); homeClubId=9; kickOff=1728219600000000000; homeGoals=0; gameweek=3; awayGoals=0 },
                {id=15; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=6; events=List.fromArray([]); homeClubId=1; kickOff=1728223200000000000; homeGoals=0; gameweek=3; awayGoals=0 },
                {id=16; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=8; events=List.fromArray([]); homeClubId=11; kickOff=1728224100000000000; homeGoals=0; gameweek=3; awayGoals=0 },
                {id=17; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=5; events=List.fromArray([]); homeClubId=7; kickOff=1728226800000000000; homeGoals=0; gameweek=3; awayGoals=0 },
                {id=18; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=4; events=List.fromArray([]); homeClubId=1; kickOff=1728740700000000000; homeGoals=0; gameweek=4; awayGoals=0 },
                {id=19; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=11; events=List.fromArray([]); homeClubId=10; kickOff=1728822600000000000; homeGoals=0; gameweek=4; awayGoals=0 },
                {id=20; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=12; events=List.fromArray([]); homeClubId=6; kickOff=1728828000000000000; homeGoals=0; gameweek=4; awayGoals=0 },
                {id=21; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=3; events=List.fromArray([]); homeClubId=5; kickOff=1728828000000000000; homeGoals=0; gameweek=4; awayGoals=0 },
                {id=22; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=7; events=List.fromArray([]); homeClubId=2; kickOff=1728828000000000000; homeGoals=0; gameweek=4; awayGoals=0 },
                {id=23; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=9; events=List.fromArray([]); homeClubId=8; kickOff=1728831600000000000; homeGoals=0; gameweek=4; awayGoals=0 },
                {id=24; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=10; events=List.fromArray([]); homeClubId=3; kickOff=1729341000000000000; homeGoals=0; gameweek=5; awayGoals=0 },
                {id=25; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=2; events=List.fromArray([]); homeClubId=9; kickOff=1729426500000000000; homeGoals=0; gameweek=5; awayGoals=0 },
                {id=26; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=5; events=List.fromArray([]); homeClubId=8; kickOff=1729432800000000000; homeGoals=0; gameweek=5; awayGoals=0 },
                {id=27; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=1; events=List.fromArray([]); homeClubId=12; kickOff=1729436400000000000; homeGoals=0; gameweek=5; awayGoals=0 },
                {id=28; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=6; events=List.fromArray([]); homeClubId=7; kickOff=1729436400000000000; homeGoals=0; gameweek=5; awayGoals=0 },
                {id=29; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=11; events=List.fromArray([]); homeClubId=4; kickOff=1729449900000000000; homeGoals=0; gameweek=5; awayGoals=0 },
                {id=30; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=1; events=List.fromArray([]); homeClubId=10; kickOff=1730640600000000000; homeGoals=0; gameweek=6; awayGoals=0 },
                {id=31; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=12; events=List.fromArray([]); homeClubId=11; kickOff=1730646000000000000; homeGoals=0; gameweek=6; awayGoals=0 },
                {id=32; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=9; events=List.fromArray([]); homeClubId=5; kickOff=1730646000000000000; homeGoals=0; gameweek=6; awayGoals=0 },
                {id=33; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=7; events=List.fromArray([]); homeClubId=3; kickOff=1730646000000000000; homeGoals=0; gameweek=6; awayGoals=0 },
                {id=34; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=8; events=List.fromArray([]); homeClubId=2; kickOff=1730655000000000000; homeGoals=0; gameweek=6; awayGoals=0 },
                {id=35; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=4; events=List.fromArray([]); homeClubId=6; kickOff=1730663100000000000; homeGoals=0; gameweek=6; awayGoals=0 },
                {id=36; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=3; events=List.fromArray([]); homeClubId=1; kickOff=1731096000000000000; homeGoals=0; gameweek=7; awayGoals=0 },
                {id=37; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=11; events=List.fromArray([]); homeClubId=9; kickOff=1731097800000000000; homeGoals=0; gameweek=7; awayGoals=0 },
                {id=38; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=4; events=List.fromArray([]); homeClubId=8; kickOff=1731245400000000000; homeGoals=0; gameweek=7; awayGoals=0 },
                {id=39; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=6; events=List.fromArray([]); homeClubId=5; kickOff=1731250800000000000; homeGoals=0; gameweek=7; awayGoals=0 },
                {id=40; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=4; events=List.fromArray([]); homeClubId=8; kickOff=1731245400000000000; homeGoals=0; gameweek=7; awayGoals=0 },
                {id=41; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=7; events=List.fromArray([]); homeClubId=12; kickOff=1731254400000000000; homeGoals=0; gameweek=7; awayGoals=0 },
                {id=42; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=12; events=List.fromArray([]); homeClubId=3; kickOff=1731763800000000000; homeGoals=0; gameweek=8; awayGoals=0 },
                {id=43; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=8; events=List.fromArray([]); homeClubId=6; kickOff=1731769200000000000; homeGoals=0; gameweek=8; awayGoals=0 },
                {id=44; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=1; events=List.fromArray([]); homeClubId=11; kickOff=1731855600000000000; homeGoals=0; gameweek=8; awayGoals=0 },
                {id=45; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=9; events=List.fromArray([]); homeClubId=4; kickOff=1731855600000000000; homeGoals=0; gameweek=8; awayGoals=0 },
                {id=46; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=5; events=List.fromArray([]); homeClubId=2; kickOff=1731855600000000000; homeGoals=0; gameweek=8; awayGoals=0 },
                {id=47; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=10; events=List.fromArray([]); homeClubId=7; kickOff=1731859200000000000; homeGoals=0; gameweek=8; awayGoals=0 },
                {id=48; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=8; events=List.fromArray([]); homeClubId=10; kickOff=1733662800000000000; homeGoals=0; gameweek=9; awayGoals=0 },
                {id=49; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=7; events=List.fromArray([]); homeClubId=9; kickOff=1733666400000000000; homeGoals=0; gameweek=9; awayGoals=0 },
                {id=50; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=6; events=List.fromArray([]); homeClubId=11; kickOff=1733670000000000000; homeGoals=0; gameweek=9; awayGoals=0 },
                {id=51; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=3; events=List.fromArray([]); homeClubId=4; kickOff=1733670000000000000; homeGoals=0; gameweek=9; awayGoals=0 },
                {id=52; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=2; events=List.fromArray([]); homeClubId=1; kickOff=1733670000000000000; homeGoals=0; gameweek=9; awayGoals=0 },
                {id=53; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=5; events=List.fromArray([]); homeClubId=12; kickOff=1733673600000000000; homeGoals=0; gameweek=9; awayGoals=0 },
                {id=54; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=1; events=List.fromArray([]); homeClubId=8; kickOff=1734274800000000000; homeGoals=0; gameweek=10; awayGoals=0 },
                {id=55; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=9; events=List.fromArray([]); homeClubId=6; kickOff=1734274800000000000; homeGoals=0; gameweek=10; awayGoals=0 },
                {id=56; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=10; events=List.fromArray([]); homeClubId=5; kickOff=1734274800000000000; homeGoals=0; gameweek=10; awayGoals=0 },
                {id=57; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=12; events=List.fromArray([]); homeClubId=2; kickOff=1734274800000000000; homeGoals=0; gameweek=10; awayGoals=0 },
                {id=58; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=4; events=List.fromArray([]); homeClubId=7; kickOff=1734278400000000000; homeGoals=0; gameweek=10; awayGoals=0 },
                {id=59; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=11; events=List.fromArray([]); homeClubId=3; kickOff=1734278400000000000; homeGoals=0; gameweek=10; awayGoals=0 },
                {id=60; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=10; events=List.fromArray([]); homeClubId=9; kickOff=1737291600000000000; homeGoals=0; gameweek=11; awayGoals=0 },
                {id=61; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=7; events=List.fromArray([]); homeClubId=11; kickOff=1737295200000000000; homeGoals=0; gameweek=11; awayGoals=0 },
                {id=62; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=5; events=List.fromArray([]); homeClubId=1; kickOff=1737295200000000000; homeGoals=0; gameweek=11; awayGoals=0 },
                {id=63; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=2; events=List.fromArray([]); homeClubId=6; kickOff=1737295200000000000; homeGoals=0; gameweek=11; awayGoals=0 },
                {id=64; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=3; events=List.fromArray([]); homeClubId=8; kickOff=1737295200000000000; homeGoals=0; gameweek=11; awayGoals=0 },
                {id=65; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=4; events=List.fromArray([]); homeClubId=12; kickOff=1737298800000000000; homeGoals=0; gameweek=11; awayGoals=0 },
                {id=66; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=3; events=List.fromArray([]); homeClubId=10; kickOff=1737892800000000000; homeGoals=0; gameweek=12; awayGoals=0 },
                {id=67; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=1; events=List.fromArray([]); homeClubId=4; kickOff=1737900000000000000; homeGoals=0; gameweek=12; awayGoals=0 },
                {id=68; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=11; events=List.fromArray([]); homeClubId=5; kickOff=1737900000000000000; homeGoals=0; gameweek=12; awayGoals=0 },
                {id=69; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=9; events=List.fromArray([]); homeClubId=2; kickOff=1737900000000000000; homeGoals=0; gameweek=12; awayGoals=0 },
                {id=70; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=8; events=List.fromArray([]); homeClubId=7; kickOff=1737903600000000000; homeGoals=0; gameweek=12; awayGoals=0 },
                {id=71; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=6; events=List.fromArray([]); homeClubId=12; kickOff=1737903600000000000; homeGoals=0; gameweek=12; awayGoals=0 },
                {id=72; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=1; events=List.fromArray([]); homeClubId=9; kickOff=1738501200000000000; homeGoals=0; gameweek=13; awayGoals=0 },
                {id=73; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=7; events=List.fromArray([]); homeClubId=6; kickOff=1738504800000000000; homeGoals=0; gameweek=13; awayGoals=0 },
                {id=74; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=12; events=List.fromArray([]); homeClubId=8; kickOff=1738504800000000000; homeGoals=0; gameweek=13; awayGoals=0 },
                {id=75; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=4; events=List.fromArray([]); homeClubId=2; kickOff=1738504800000000000; homeGoals=0; gameweek=13; awayGoals=0 },
                {id=76; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=5; events=List.fromArray([]); homeClubId=3; kickOff=1738504800000000000; homeGoals=0; gameweek=13; awayGoals=0 },
                {id=77; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=10; events=List.fromArray([]); homeClubId=11; kickOff=1738504800000000000; homeGoals=0; gameweek=13; awayGoals=0 },
                {id=78; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=5; events=List.fromArray([]); homeClubId=10; kickOff=1739707200000000000; homeGoals=0; gameweek=14; awayGoals=0 },
                {id=79; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=8; events=List.fromArray([]); homeClubId=9; kickOff=1739710800000000000; homeGoals=0; gameweek=14; awayGoals=0 },
                {id=80; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=6; events=List.fromArray([]); homeClubId=4; kickOff=1739714400000000000; homeGoals=0; gameweek=14; awayGoals=0 },
                {id=81; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=11; events=List.fromArray([]); homeClubId=1; kickOff=1739714400000000000; homeGoals=0; gameweek=14; awayGoals=0 },
                {id=82; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=2; events=List.fromArray([]); homeClubId=7; kickOff=1739718000000000000; homeGoals=0; gameweek=14; awayGoals=0 },
                {id=83; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=3; events=List.fromArray([]); homeClubId=12; kickOff=1739718000000000000; homeGoals=0; gameweek=14; awayGoals=0 },
                {id=84; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=7; events=List.fromArray([]); homeClubId=10; kickOff=1740916800000000000; homeGoals=0; gameweek=15; awayGoals=0 },
                {id=85; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=12; events=List.fromArray([]); homeClubId=1; kickOff=1740924000000000000; homeGoals=0; gameweek=15; awayGoals=0 },
                {id=86; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=4; events=List.fromArray([]); homeClubId=3; kickOff=1740924000000000000; homeGoals=0; gameweek=15; awayGoals=0 },
                {id=87; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=6; events=List.fromArray([]); homeClubId=2; kickOff=1740924000000000000; homeGoals=0; gameweek=15; awayGoals=0 },
                {id=88; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=9; events=List.fromArray([]); homeClubId=11; kickOff=1740924000000000000; homeGoals=0; gameweek=15; awayGoals=0 },
                {id=89; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=8; events=List.fromArray([]); homeClubId=5; kickOff=1740924000000000000; homeGoals=0; gameweek=15; awayGoals=0 },
                {id=90; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=1; events=List.fromArray([]); homeClubId=6; kickOff=1742133600000000000; homeGoals=0; gameweek=16; awayGoals=0 },
                {id=91; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=2; events=List.fromArray([]); homeClubId=5; kickOff=1742133600000000000; homeGoals=0; gameweek=16; awayGoals=0 },
                {id=92; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=7; events=List.fromArray([]); homeClubId=4; kickOff=1742133600000000000; homeGoals=0; gameweek=16; awayGoals=0 },
                {id=93; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=10; events=List.fromArray([]); homeClubId=8; kickOff=1742133600000000000; homeGoals=0; gameweek=16; awayGoals=0 },
                {id=94; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=9; events=List.fromArray([]); homeClubId=12; kickOff=1742137200000000000; homeGoals=0; gameweek=16; awayGoals=0 },
                {id=95; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=3; events=List.fromArray([]); homeClubId=11; kickOff=1742137200000000000; homeGoals=0; gameweek=16; awayGoals=0 },
                {id=96; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=5; events=List.fromArray([]); homeClubId=6; kickOff=1742652000000000000; homeGoals=0; gameweek=17; awayGoals=0 },
                {id=97; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=4; events=List.fromArray([]); homeClubId=9; kickOff=1742648400000000000; homeGoals=0; gameweek=17; awayGoals=0 },
                {id=98; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=8; events=List.fromArray([]); homeClubId=1; kickOff=1742652000000000000; homeGoals=0; gameweek=17; awayGoals=0 },
                {id=99; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=10; events=List.fromArray([]); homeClubId=2; kickOff=1742652000000000000; homeGoals=0; gameweek=17; awayGoals=0 },
                {id=100; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=11; events=List.fromArray([]); homeClubId=12; kickOff=1742655600000000000; homeGoals=0; gameweek=17; awayGoals=0 },
                {id=101; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=3; events=List.fromArray([]); homeClubId=7; kickOff=1742655600000000000; homeGoals=0; gameweek=17; awayGoals=0 },
                {id=102; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=6; events=List.fromArray([]); homeClubId=10; kickOff=1743336000000000000; homeGoals=0; gameweek=18; awayGoals=0 },
                {id=103; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=1; events=List.fromArray([]); homeClubId=5; kickOff=1743343200000000000; homeGoals=0; gameweek=18; awayGoals=0 },
                {id=104; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=12; events=List.fromArray([]); homeClubId=4; kickOff=1743343200000000000; homeGoals=0; gameweek=18; awayGoals=0 },
                {id=105; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=2; events=List.fromArray([]); homeClubId=8; kickOff=1743343200000000000; homeGoals=0; gameweek=18; awayGoals=0 },
                {id=106; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=9; events=List.fromArray([]); homeClubId=3; kickOff=1743343200000000000; homeGoals=0; gameweek=18; awayGoals=0 },
                {id=107; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=11; events=List.fromArray([]); homeClubId=7; kickOff=1743346800000000000; homeGoals=0; gameweek=18; awayGoals=0 },
                {id=108; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=6; events=List.fromArray([]); homeClubId=9; kickOff=1713618000000000000; homeGoals=0; gameweek=19; awayGoals=0 },
                {id=109; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=5; events=List.fromArray([]); homeClubId=4; kickOff=1713621600000000000; homeGoals=0; gameweek=19; awayGoals=0 },
                {id=110; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=7; events=List.fromArray([]); homeClubId=1; kickOff=1713621600000000000; homeGoals=0; gameweek=19; awayGoals=0 },
                {id=111; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=8; events=List.fromArray([]); homeClubId=3; kickOff=1713621600000000000; homeGoals=0; gameweek=19; awayGoals=0 },
                {id=112; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=2; events=List.fromArray([]); homeClubId=11; kickOff=1713621600000000000; homeGoals=0; gameweek=19; awayGoals=0 },
                {id=113; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=10; events=List.fromArray([]); homeClubId=12; kickOff=1713625200000000000; homeGoals=0; gameweek=19; awayGoals=0 },
                {id=114; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=4; events=List.fromArray([]); homeClubId=10; kickOff=1714219200000000000; homeGoals=0; gameweek=20; awayGoals=0 },
                {id=115; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=12; events=List.fromArray([]); homeClubId=5; kickOff=1714226400000000000; homeGoals=0; gameweek=20; awayGoals=0 },
                {id=116; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=3; events=List.fromArray([]); homeClubId=6; kickOff=1714226400000000000; homeGoals=0; gameweek=20; awayGoals=0 },
                {id=117; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=11; events=List.fromArray([]); homeClubId=8; kickOff=1714226400000000000; homeGoals=0; gameweek=20; awayGoals=0 },
                {id=118; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=1; events=List.fromArray([]); homeClubId=2; kickOff=1714226400000000000; homeGoals=0; gameweek=20; awayGoals=0 },
                {id=119; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=9; events=List.fromArray([]); homeClubId=7; kickOff=1714230000000000000; homeGoals=0; gameweek=20; awayGoals=0 },
                {id=120; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=9; events=List.fromArray([]); homeClubId=10; kickOff=1714824000000000000; homeGoals=0; gameweek=21; awayGoals=0 },
                {id=121; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=7; events=List.fromArray([]); homeClubId=5; kickOff=1714831200000000000; homeGoals=0; gameweek=21; awayGoals=0 },
                {id=122; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=1; events=List.fromArray([]); homeClubId=3; kickOff=1714831200000000000; homeGoals=0; gameweek=21; awayGoals=0 },
                {id=123; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=6; events=List.fromArray([]); homeClubId=8; kickOff=1714831200000000000; homeGoals=0; gameweek=21; awayGoals=0 },
                {id=124; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=4; events=List.fromArray([]); homeClubId=11; kickOff=1714831200000000000; homeGoals=0; gameweek=21; awayGoals=0 },
                {id=125; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=2; events=List.fromArray([]); homeClubId=12; kickOff=1714834800000000000; homeGoals=0; gameweek=21; awayGoals=0 },
                {id=126; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=11; events=List.fromArray([]); homeClubId=6; kickOff=1715428800000000000; homeGoals=0; gameweek=22; awayGoals=0 },
                {id=127; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=12; events=List.fromArray([]); homeClubId=7; kickOff=1715436000000000000; homeGoals=0; gameweek=22; awayGoals=0 },
                {id=128; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=5; events=List.fromArray([]); homeClubId=9; kickOff=1715436000000000000; homeGoals=0; gameweek=22; awayGoals=0 },
                {id=129; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=10; events=List.fromArray([]); homeClubId=1; kickOff=1715436000000000000; homeGoals=0; gameweek=22; awayGoals=0 },
                {id=130; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=3; events=List.fromArray([]); homeClubId=2; kickOff=1715436000000000000; homeGoals=0; gameweek=22; awayGoals=0 },
                {id=131; status=#Unplayed; highestScoringPlayerId=0; seasonId=2; awayClubId=8; events=List.fromArray([]); homeClubId=4; kickOff=1715439600000000000; homeGoals=0; gameweek=22; awayGoals=0 }
              ]);
            }
          ]
        )
      ];

      leagueClubs := [
        (1, 
          [
            {id=3; secondaryColourHex="#262729"; name="AFC Bournemouth"; friendlyName="Bournemouth"; thirdColourHex="#262729"; abbreviatedName="BOU"; shirtType=#Striped; primaryColourHex="#CA2D26"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=1; secondaryColourHex="#FFFFFF"; name="Arsenal"; friendlyName="Arsenal"; thirdColourHex="#F0DCBA"; abbreviatedName="ARS"; shirtType=#Filled; primaryColourHex="#D3121A"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=2; secondaryColourHex="#B7D7FE"; name="Aston Villa"; friendlyName="Aston Villa"; thirdColourHex="#FFFFFF"; abbreviatedName="AVL"; shirtType=#Filled; primaryColourHex="#CA3E69"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=4; secondaryColourHex="#FFFFFF"; name="Brentford"; friendlyName="Brentford"; thirdColourHex="#090F14"; abbreviatedName="BRE"; shirtType=#Striped; primaryColourHex="#CF2E26"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=5; secondaryColourHex="#124098"; name="Brighton & Hove Albion"; friendlyName="Brighton"; thirdColourHex="#124098"; abbreviatedName="BRI"; shirtType=#Striped; primaryColourHex="#FFFFFF"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=7; secondaryColourHex="#FFFFFF"; name="Chelsea"; friendlyName="Chelsea"; thirdColourHex="#020514"; abbreviatedName="CHE"; shirtType=#Filled; primaryColourHex="#2D57C7"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=8; secondaryColourHex="#E12F44"; name="Crystal Palace"; friendlyName="Crystal Palace"; thirdColourHex="#FFFFFF"; abbreviatedName="CRY"; shirtType=#Striped; primaryColourHex="#1A47A0"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=9; secondaryColourHex="#FFFFFF"; name="Everton"; friendlyName="Everton"; thirdColourHex="#13356D"; abbreviatedName="EVE"; shirtType=#Filled; primaryColourHex="#0F3DD1"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=10; secondaryColourHex="#B14C5C"; name="Fulham"; friendlyName="Fulham"; thirdColourHex="#000000"; abbreviatedName="FUL"; shirtType=#Filled; primaryColourHex="#FFFFFF"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=22; secondaryColourHex="#F4656B"; name="Ipswich Town"; friendlyName="Ipswich"; thirdColourHex="#FFFFFF"; abbreviatedName="IPS"; shirtType=#Filled; primaryColourHex="#6493E1"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=21; secondaryColourHex="#FFFFFF"; name="Leicester City"; friendlyName="Leicester"; thirdColourHex="#C8A851"; abbreviatedName="LEI"; shirtType=#Filled; primaryColourHex="#2A4282"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=11; secondaryColourHex="#FFFFFF"; name="Liverpool"; friendlyName="Liverpool"; thirdColourHex="#2CC4B9"; abbreviatedName="LIV"; shirtType=#Filled; primaryColourHex="#E50113"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=13; secondaryColourHex="#FFFFFF"; name="Manchester City"; friendlyName="Man City"; thirdColourHex="#A3E1FE"; abbreviatedName="MCI"; shirtType=#Filled; primaryColourHex="#569ECD"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=14; secondaryColourHex="#FFFFFF"; name="Manchester United"; friendlyName="Man United"; thirdColourHex="#FEF104"; abbreviatedName="MUN"; shirtType=#Filled; primaryColourHex="#C00814"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=15; secondaryColourHex="#1A1A1A"; name="Newcastle United"; friendlyName="Newcastle"; thirdColourHex="#1A1A1A"; abbreviatedName="NEW"; shirtType=#Striped; primaryColourHex="#FFFFFF"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=16; secondaryColourHex="#FFFFFF"; name="Nottingham Forest"; friendlyName="Nottingham Forest"; thirdColourHex="#FFFFFF"; abbreviatedName="NFO"; shirtType=#Filled; primaryColourHex="#BB212A"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=23; secondaryColourHex="#FFFFFF"; name="Southampton"; friendlyName="Southampton"; thirdColourHex="#000000"; abbreviatedName="SOT"; shirtType=#Striped; primaryColourHex="#c00e1a"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=18; secondaryColourHex="#001952"; name="Tottenham Hotspur"; friendlyName="Tottenham"; thirdColourHex="#001952"; abbreviatedName="TOT"; shirtType=#Filled; primaryColourHex="#FFFFFF"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=19; secondaryColourHex="#A7DAF9"; name="West Ham United"; friendlyName="West Ham"; thirdColourHex="#F1D655"; abbreviatedName="WHU"; shirtType=#Filled; primaryColourHex="#6D202A"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=20; secondaryColourHex="#2D2D23"; name="Wolverhampton Wanderers"; friendlyName="Wolves"; thirdColourHex="#2D2D23"; abbreviatedName="WOL"; shirtType=#Filled; primaryColourHex="#F7CA3B"}
          ]
        ),
        (2, 
          [
            {id=1; secondaryColourHex="#FFFFFF"; name="Arsenal"; friendlyName="Arsenal"; thirdColourHex="#F0DCBA"; abbreviatedName="ARS"; shirtType=#Filled; primaryColourHex="#D3121A"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=2; secondaryColourHex="#B7D7FE"; name="Aston Villa"; friendlyName="Aston Villa"; thirdColourHex="#FFFFFF"; abbreviatedName="AVL"; shirtType=#Filled; primaryColourHex="#CA3E69"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=3; secondaryColourHex="#124098"; name="Brighton & Hove Albion"; friendlyName="Brighton"; thirdColourHex="#124098"; abbreviatedName="BRI"; shirtType=#Striped; primaryColourHex="#FFFFFF"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=4; secondaryColourHex="#FFFFFF"; name="Chelsea"; friendlyName="Chelsea"; thirdColourHex="#020514"; abbreviatedName="CHE"; shirtType=#Filled; primaryColourHex="#2D57C7"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=5; secondaryColourHex="#E12F44"; name="Crystal Palace"; friendlyName="Crystal Palace"; thirdColourHex="#FFFFFF"; abbreviatedName="CRY"; shirtType=#Striped; primaryColourHex="#1A47A0"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=6; secondaryColourHex="#FFFFFF"; name="Everton"; friendlyName="Everton"; thirdColourHex="#13356D"; abbreviatedName="EVE"; shirtType=#Filled; primaryColourHex="#0F3DD1"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=7; secondaryColourHex="#FFFFFF"; name="Leicester City"; friendlyName="Leicester"; thirdColourHex="#C8A851"; abbreviatedName="LEI"; shirtType=#Filled; primaryColourHex="#2A4282"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=8; secondaryColourHex="#FFFFFF"; name="Liverpool"; friendlyName="Liverpool"; thirdColourHex="#2CC4B9"; abbreviatedName="LIV"; shirtType=#Filled; primaryColourHex="#E50113"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=9; secondaryColourHex="#FFFFFF"; name="Manchester City"; friendlyName="Man City"; thirdColourHex="#A3E1FE"; abbreviatedName="MCI"; shirtType=#Filled; primaryColourHex="#569ECD"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=10; secondaryColourHex="#FFFFFF"; name="Manchester United"; friendlyName="Man United"; thirdColourHex="#FEF104"; abbreviatedName="MUN"; shirtType=#Filled; primaryColourHex="#C00814"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=11; secondaryColourHex="#001952"; name="Tottenham Hotspur"; friendlyName="Tottenham"; thirdColourHex="#001952"; abbreviatedName="TOT"; shirtType=#Filled; primaryColourHex="#FFFFFF"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=12; secondaryColourHex="#A7DAF9"; name="West Ham United"; friendlyName="West Ham"; thirdColourHex="#F1D655"; abbreviatedName="WHU"; shirtType=#Filled; primaryColourHex="#6D202A"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
        
        ])
      ];

      leaguePlayers := [
        (1, 
          [
            {id=724; status=#Active; clubId=21; valueQuarterMillions=32; dateOfBirth=920073600000000000; nationality=61; shirtNumber=24; totalPoints=0; position=#Midfielder; lastName="Soumaré"; firstName="Boubakary"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=723; status=#Active; clubId=21; valueQuarterMillions=40; dateOfBirth=1006387200000000000; nationality=81; shirtNumber=35; totalPoints=0; position=#Midfielder; lastName="McAteer"; firstName="Kasey"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=722; status=#Active; clubId=19; valueQuarterMillions=80; dateOfBirth=729216000000000000; nationality=65; shirtNumber=11; totalPoints=5; position=#Forward; lastName="Füllkrug"; firstName="Niclas"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=721; status=#Active; clubId=19; valueQuarterMillions=64; dateOfBirth=1004400000000000000; nationality=125; shirtNumber=7; totalPoints=5; position=#Forward; lastName="Summerville"; firstName="Crysencio"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=720; status=#Active; clubId=19; valueQuarterMillions=60; dateOfBirth=766108800000000000; nationality=7; shirtNumber=24; totalPoints=5; position=#Midfielder; lastName="Rodríguez"; firstName="Guido"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=719; status=#Active; clubId=19; valueQuarterMillions=40; dateOfBirth=946512000000000000; nationality=61; shirtNumber=25; totalPoints=-10; position=#Defender; lastName="Todibo"; firstName="Jean-Clair"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=718; status=#Active; clubId=3; valueQuarterMillions=32; dateOfBirth=997660800000000000; nationality=113; shirtNumber=28; totalPoints=5; position=#Defender; lastName="Araujo"; firstName="Julián"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=717; status=#Active; clubId=23; valueQuarterMillions=56; dateOfBirth=924393600000000000; nationality=35; shirtNumber=17; totalPoints=0; position=#Forward; lastName="Brereton"; firstName="Ben"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=716; status=#Active; clubId=23; valueQuarterMillions=36; dateOfBirth=1140134400000000000; nationality=186; shirtNumber=33; totalPoints=5; position=#Midfielder; lastName="Dibling"; firstName="Tyler"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=715; status=#Active; clubId=23; valueQuarterMillions=56; dateOfBirth=1038614400000000000; nationality=7; shirtNumber=22; totalPoints=5; position=#Midfielder; lastName="Alcaraz"; firstName="Carlos"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=714; status=#Active; clubId=23; valueQuarterMillions=36; dateOfBirth=860889600000000000; nationality=186; shirtNumber=2; totalPoints=5; position=#Defender; lastName="Walker-Peters"; firstName="Kyle"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=713; status=#Active; clubId=20; valueQuarterMillions=60; dateOfBirth=949708800000000000; nationality=141; shirtNumber=23; totalPoints=5; position=#Forward; lastName="Chiquinho"; firstName=""; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=712; status=#Active; clubId=20; valueQuarterMillions=60; dateOfBirth=814233600000000000; nationality=141; shirtNumber=10; totalPoints=5; position=#Forward; lastName="Podence"; firstName="Daniel"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=711; status=#Active; clubId=20; valueQuarterMillions=56; dateOfBirth=988761600000000000; nationality=37; shirtNumber=14; totalPoints=-10; position=#Defender; lastName="Mosquera"; firstName="Yerson"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=710; status=#Active; clubId=22; valueQuarterMillions=64; dateOfBirth=811900800000000000; nationality=81; shirtNumber=23; totalPoints=5; position=#Forward; lastName="Szmodics"; firstName="Sammie"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=709; status=#Active; clubId=7; valueQuarterMillions=160; dateOfBirth=942192000000000000; nationality=141; shirtNumber=14; totalPoints=0; position=#Forward; lastName="Félix"; firstName="João"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=708; status=#Active; clubId=16; valueQuarterMillions=28; dateOfBirth=938736000000000000; nationality=141; shirtNumber=20; totalPoints=0; position=#Forward; lastName="Silva"; firstName="Jota"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=707; status=#Active; clubId=16; valueQuarterMillions=24; dateOfBirth=1146614400000000000; nationality=65; shirtNumber=17; totalPoints=0; position=#Forward; lastName="Da Silva Moreira"; firstName="Eric"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=706; status=#Active; clubId=16; valueQuarterMillions=24; dateOfBirth=1147478400000000000; nationality=186; shirtNumber=44; totalPoints=0; position=#Defender; lastName="Abbott"; firstName="Zach"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=705; status=#Active; clubId=16; valueQuarterMillions=30; dateOfBirth=876614400000000000; nationality=154; shirtNumber=31; totalPoints=0; position=#Defender; lastName="Milenković"; firstName="Nikola"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=704; status=#Active; clubId=16; valueQuarterMillions=24; dateOfBirth=887500800000000000; nationality=186; shirtNumber=27; totalPoints=0; position=#Defender; lastName="Richards"; firstName="Omar"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=703; status=#Active; clubId=16; valueQuarterMillions=20; dateOfBirth=907891200000000000; nationality=24; shirtNumber=33; totalPoints=0; position=#Goalkeeper; lastName="Miguel"; firstName="Carlos"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=702; status=#Active; clubId=15; valueQuarterMillions=32; dateOfBirth=1033430400000000000; nationality=186; shirtNumber=40; totalPoints=0; position=#Midfielder; lastName="White"; firstName="Joe"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=701; status=#Active; clubId=14; valueQuarterMillions=28; dateOfBirth=1137715200000000000; nationality=186; shirtNumber=36; totalPoints=0; position=#Forward; lastName="Wheatley"; firstName="Ethan"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=700; status=#Active; clubId=14; valueQuarterMillions=28; dateOfBirth=1073088000000000000; nationality=186; shirtNumber=43; totalPoints=0; position=#Midfielder; lastName="Collyer"; firstName="Toby"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=699; status=#Active; clubId=14; valueQuarterMillions=26; dateOfBirth=1174003200000000000; nationality=186; shirtNumber=41; totalPoints=0; position=#Defender; lastName="Amass"; firstName="Harry"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=698; status=#Active; clubId=14; valueQuarterMillions=72; dateOfBirth=934416000000000000; nationality=125; shirtNumber=4; totalPoints=15; position=#Defender; lastName="De Ligt"; firstName="Matthijs"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=697; status=#Active; clubId=14; valueQuarterMillions=64; dateOfBirth=879465600000000000; nationality=119; shirtNumber=3; totalPoints=15; position=#Defender; lastName="Mazraoui"; firstName="Noussair"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=696; status=#Active; clubId=21; valueQuarterMillions=32; dateOfBirth=850694400000000000; nationality=129; shirtNumber=25; totalPoints=0; position=#Midfielder; lastName="Ndidi"; firstName="Wilfred"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=695; status=#Active; clubId=10; valueQuarterMillions=32; dateOfBirth=942796800000000000; nationality=164; shirtNumber=0; totalPoints=0; position=#Defender; lastName="Cuenca"; firstName="Jorge"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=694; status=#Active; clubId=9; valueQuarterMillions=76; dateOfBirth=951782400000000000; nationality=47; shirtNumber=0; totalPoints=0; position=#Forward; lastName="Lindstrøm"; firstName="Jesper"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=693; status=#Active; clubId=9; valueQuarterMillions=80; dateOfBirth=848448000000000000; nationality=186; shirtNumber=11; totalPoints=5; position=#Forward; lastName="Harrison"; firstName="Jack"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=692; status=#Active; clubId=9; valueQuarterMillions=26; dateOfBirth=989884800000000000; nationality=81; shirtNumber=0; totalPoints=0; position=#Defender; lastName="O'Brien"; firstName="Jake"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=691; status=#Active; clubId=8; valueQuarterMillions=64; dateOfBirth=919900800000000000; nationality=153; shirtNumber=7; totalPoints=5; position=#Midfielder; lastName="Sarr"; firstName="Ismaïla"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=690; status=#Active; clubId=7; valueQuarterMillions=32; dateOfBirth=1139011200000000000; nationality=186; shirtNumber=32; totalPoints=0; position=#Forward; lastName="George"; firstName="Tyrique"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=689; status=#Active; clubId=7; valueQuarterMillions=48; dateOfBirth=1059436800000000000; nationality=141; shirtNumber=40; totalPoints=5; position=#Midfielder; lastName="Veiga"; firstName="Renato"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=688; status=#Active; clubId=7; valueQuarterMillions=72; dateOfBirth=905040000000000000; nationality=186; shirtNumber=22; totalPoints=5; position=#Midfielder; lastName="Dewsbury-Hall"; firstName="Kiernan"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=687; status=#Active; clubId=7; valueQuarterMillions=32; dateOfBirth=1018915200000000000; nationality=47; shirtNumber=12; totalPoints=0; position=#Goalkeeper; lastName="Jörgensen"; firstName="Filip"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=686; status=#Active; clubId=5; valueQuarterMillions=30; dateOfBirth=1066176000000000000; nationality=81; shirtNumber=0; totalPoints=0; position=#Midfielder; lastName="Moran"; firstName="Andrew"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=685; status=#Active; clubId=5; valueQuarterMillions=24; dateOfBirth=1044403200000000000; nationality=186; shirtNumber=0; totalPoints=0; position=#Defender; lastName="Samuels"; firstName="Imari"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=684; status=#Active; clubId=3; valueQuarterMillions=70; dateOfBirth=868320000000000000; nationality=186; shirtNumber=7; totalPoints=0; position=#Midfielder; lastName="Brooks"; firstName="David"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=683; status=#Active; clubId=3; valueQuarterMillions=28; dateOfBirth=1113436800000000000; nationality=164; shirtNumber=2; totalPoints=5; position=#Defender; lastName="Huijsen"; firstName="Dean"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=682; status=#Active; clubId=3; valueQuarterMillions=22; dateOfBirth=1025740800000000000; nationality=126; shirtNumber=0; totalPoints=0; position=#Goalkeeper; lastName="Paulsen"; firstName="Alex"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=681; status=#Active; clubId=5; valueQuarterMillions=80; dateOfBirth=992736000000000000; nationality=153; shirtNumber=0; totalPoints=0; position=#Forward; lastName="Sima"; firstName="Abdallah"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=680; status=#Active; clubId=5; valueQuarterMillions=30; dateOfBirth=1065398400000000000; nationality=168; shirtNumber=0; totalPoints=5; position=#Midfielder; lastName="Ayari"; firstName="Yasin"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=679; status=#Active; clubId=5; valueQuarterMillions=26; dateOfBirth=1132272000000000000; nationality=108; shirtNumber=0; totalPoints=0; position=#Midfielder; lastName="Yalcouyé"; firstName="Malick"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=678; status=#Active; clubId=5; valueQuarterMillions=32; dateOfBirth=1012435200000000000; nationality=186; shirtNumber=0; totalPoints=0; position=#Midfielder; lastName="Weir"; firstName="Jensen"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=677; status=#Active; clubId=14; valueQuarterMillions=34; dateOfBirth=1131840000000000000; nationality=61; shirtNumber=15; totalPoints=0; position=#Defender; lastName="Yoro"; firstName="Leny"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=676; status=#Active; clubId=5; valueQuarterMillions=36; dateOfBirth=994032000000000000; nationality=186; shirtNumber=0; totalPoints=0; position=#Goalkeeper; lastName="Rushworth"; firstName="Carl"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=675; status=#Active; clubId=1; valueQuarterMillions=56; dateOfBirth=1021766400000000000; nationality=83; shirtNumber=33; totalPoints=0; position=#Defender; lastName="Calafiori"; firstName="Riccardo"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=674; status=#Active; clubId=23; valueQuarterMillions=64; dateOfBirth=837043200000000000; nationality=186; shirtNumber=11; totalPoints=0; position=#Forward; lastName="Stewart"; firstName="Ross"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=673; status=#Active; clubId=23; valueQuarterMillions=60; dateOfBirth=1027987200000000000; nationality=61; shirtNumber=18; totalPoints=0; position=#Forward; lastName="Mara"; firstName="Sékou"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=672; status=#Active; clubId=23; valueQuarterMillions=80; dateOfBirth=855532800000000000; nationality=186; shirtNumber=9; totalPoints=5; position=#Forward; lastName="Armstrong"; firstName="Adam"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=671; status=#Active; clubId=23; valueQuarterMillions=56; dateOfBirth=951091200000000000; nationality=81; shirtNumber=16; totalPoints=5; position=#Midfielder; lastName="Smallbone"; firstName="Will"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=670; status=#Active; clubId=23; valueQuarterMillions=56; dateOfBirth=1043712000000000000; nationality=186; shirtNumber=23; totalPoints=5; position=#Midfielder; lastName="Edozie"; firstName="Samuel"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=669; status=#Active; clubId=23; valueQuarterMillions=52; dateOfBirth=916790400000000000; nationality=186; shirtNumber=4; totalPoints=5; position=#Midfielder; lastName="Downes"; firstName="Flynn"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=668; status=#Active; clubId=23; valueQuarterMillions=48; dateOfBirth=1067990400000000000; nationality=186; shirtNumber=24; totalPoints=0; position=#Midfielder; lastName="Charles"; firstName="Shea"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=667; status=#Active; clubId=23; valueQuarterMillions=60; dateOfBirth=837907200000000000; nationality=129; shirtNumber=7; totalPoints=5; position=#Midfielder; lastName="Aribo"; firstName="Joe"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=666; status=#Active; clubId=23; valueQuarterMillions=40; dateOfBirth=1153180800000000000; nationality=66; shirtNumber=27; totalPoints=5; position=#Midfielder; lastName="Amo-Ameyaw"; firstName="Sam"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=665; status=#Active; clubId=23; valueQuarterMillions=32; dateOfBirth=1022803200000000000; nationality=186; shirtNumber=0; totalPoints=0; position=#Defender; lastName="Wood"; firstName="Nathan"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=664; status=#Active; clubId=23; valueQuarterMillions=36; dateOfBirth=748310400000000000; nationality=186; shirtNumber=0; totalPoints=0; position=#Defender; lastName="Taylor"; firstName="Charlie"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=663; status=#Active; clubId=23; valueQuarterMillions=36; dateOfBirth=962150400000000000; nationality=85; shirtNumber=0; totalPoints=5; position=#Defender; lastName="Sugawara"; firstName="Yukinari"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=662; status=#Active; clubId=23; valueQuarterMillions=34; dateOfBirth=759628800000000000; nationality=186; shirtNumber=5; totalPoints=0; position=#Defender; lastName="Stephens"; firstName="Jack"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=661; status=#Active; clubId=23; valueQuarterMillions=34; dateOfBirth=834710400000000000; nationality=81; shirtNumber=3; totalPoints=0; position=#Defender; lastName="Manning"; firstName="Ryan"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=660; status=#Active; clubId=23; valueQuarterMillions=32; dateOfBirth=1073865600000000000; nationality=164; shirtNumber=28; totalPoints=0; position=#Defender; lastName="Larios"; firstName="Juan"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=659; status=#Active; clubId=23; valueQuarterMillions=34; dateOfBirth=1012348800000000000; nationality=186; shirtNumber=6; totalPoints=0; position=#Defender; lastName="Harwood-Bellis"; firstName="Taylor"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=658; status=#Active; clubId=23; valueQuarterMillions=32; dateOfBirth=1048809600000000000; nationality=186; shirtNumber=0; totalPoints=0; position=#Defender; lastName="Edwards"; firstName="Ronnie"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=657; status=#Active; clubId=23; valueQuarterMillions=36; dateOfBirth=881798400000000000; nationality=186; shirtNumber=14; totalPoints=0; position=#Defender; lastName="Bree"; firstName="James"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=656; status=#Active; clubId=23; valueQuarterMillions=36; dateOfBirth=829267200000000000; nationality=140; shirtNumber=35; totalPoints=5; position=#Defender; lastName="Bednarek"; firstName="Jan"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=655; status=#Active; clubId=23; valueQuarterMillions=32; dateOfBirth=628646400000000000; nationality=186; shirtNumber=1; totalPoints=5; position=#Goalkeeper; lastName="McCarthy"; firstName="Alex"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=654; status=#Active; clubId=23; valueQuarterMillions=28; dateOfBirth=792806400000000000; nationality=186; shirtNumber=13; totalPoints=0; position=#Goalkeeper; lastName="Lumley"; firstName="Joe"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=653; status=#Active; clubId=21; valueQuarterMillions=44; dateOfBirth=1034985600000000000; nationality=141; shirtNumber=40; totalPoints=0; position=#Forward; lastName="Marçal"; firstName="Wanya"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=652; status=#Active; clubId=21; valueQuarterMillions=72; dateOfBirth=896572800000000000; nationality=186; shirtNumber=10; totalPoints=0; position=#Forward; lastName="Mavididi"; firstName="Stephy"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=651; status=#Active; clubId=21; valueQuarterMillions=81; dateOfBirth=537321600000000000; nationality=186; shirtNumber=9; totalPoints=0; position=#Forward; lastName="Vardy"; firstName="Jamie"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=650; status=#Active; clubId=21; valueQuarterMillions=48; dateOfBirth=1078704000000000000; nationality=66; shirtNumber=7; totalPoints=0; position=#Forward; lastName="Fatawu"; firstName="Abdul"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=649; status=#Active; clubId=21; valueQuarterMillions=32; dateOfBirth=1148342400000000000; nationality=186; shirtNumber=0; totalPoints=0; position=#Midfielder; lastName="Golding"; firstName="Michael"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=648; status=#Active; clubId=21; valueQuarterMillions=38; dateOfBirth=875664000000000000; nationality=186; shirtNumber=17; totalPoints=0; position=#Midfielder; lastName="Choudhury"; firstName="Hamza"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=647; status=#Active; clubId=21; valueQuarterMillions=40; dateOfBirth=823219200000000000; nationality=186; shirtNumber=8; totalPoints=0; position=#Midfielder; lastName="Winks"; firstName="Harry"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=646; status=#Active; clubId=21; valueQuarterMillions=34; dateOfBirth=994982400000000000; nationality=83; shirtNumber=0; totalPoints=0; position=#Defender; lastName="Okoli"; firstName="Caleb"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=645; status=#Active; clubId=21; valueQuarterMillions=32; dateOfBirth=1079568000000000000; nationality=186; shirtNumber=45; totalPoints=0; position=#Defender; lastName="Nelson"; firstName="Ben"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=644; status=#Active; clubId=21; valueQuarterMillions=32; dateOfBirth=992131200000000000; nationality=186; shirtNumber=33; totalPoints=0; position=#Defender; lastName="Thomas"; firstName="Luke"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=643; status=#Active; clubId=21; valueQuarterMillions=36; dateOfBirth=712800000000000000; nationality=47; shirtNumber=23; totalPoints=0; position=#Defender; lastName="Vestergaard"; firstName="Jannik"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=642; status=#Active; clubId=21; valueQuarterMillions=36; dateOfBirth=749865600000000000; nationality=141; shirtNumber=21; totalPoints=0; position=#Defender; lastName="Pereira"; firstName="Ricardo"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=641; status=#Active; clubId=21; valueQuarterMillions=34; dateOfBirth=1039996800000000000; nationality=47; shirtNumber=16; totalPoints=0; position=#Defender; lastName="Kristiansen"; firstName="Victor"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=640; status=#Active; clubId=21; valueQuarterMillions=36; dateOfBirth=730598400000000000; nationality=186; shirtNumber=4; totalPoints=0; position=#Defender; lastName="Coady"; firstName="Conor"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=639; status=#Active; clubId=21; valueQuarterMillions=34; dateOfBirth=891561600000000000; nationality=17; shirtNumber=3; totalPoints=0; position=#Defender; lastName="Faes"; firstName="Wout"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=638; status=#Active; clubId=21; valueQuarterMillions=36; dateOfBirth=888192000000000000; nationality=186; shirtNumber=2; totalPoints=0; position=#Defender; lastName="Justin"; firstName="James"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=637; status=#Active; clubId=21; valueQuarterMillions=30; dateOfBirth=963273600000000000; nationality=47; shirtNumber=30; totalPoints=0; position=#Goalkeeper; lastName="Hermansen"; firstName="Mads"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=636; status=#Active; clubId=21; valueQuarterMillions=32; dateOfBirth=740707200000000000; nationality=186; shirtNumber=1; totalPoints=0; position=#Goalkeeper; lastName="Ward"; firstName="Danny"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=635; status=#Active; clubId=22; valueQuarterMillions=64; dateOfBirth=1044662400000000000; nationality=186; shirtNumber=0; totalPoints=5; position=#Forward; lastName="Delap"; firstName="Liam"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=634; status=#Active; clubId=22; valueQuarterMillions=60; dateOfBirth=919036800000000000; nationality=186; shirtNumber=27; totalPoints=0; position=#Forward; lastName="Hirst"; firstName="George"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=633; status=#Active; clubId=22; valueQuarterMillions=64; dateOfBirth=1067472000000000000; nationality=84; shirtNumber=20; totalPoints=0; position=#Forward; lastName="Hutchinson"; firstName="Omari"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=632; status=#Active; clubId=22; valueQuarterMillions=64; dateOfBirth=1014940800000000000; nationality=80; shirtNumber=16; totalPoints=5; position=#Forward; lastName="Al-Hamadi"; firstName="Ali"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=631; status=#Active; clubId=22; valueQuarterMillions=64; dateOfBirth=825120000000000000; nationality=186; shirtNumber=11; totalPoints=5; position=#Forward; lastName="Harness"; firstName="Marcus"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=630; status=#Active; clubId=22; valueQuarterMillions=80; dateOfBirth=856051200000000000; nationality=186; shirtNumber=10; totalPoints=5; position=#Forward; lastName="Chaplin"; firstName="Conor"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=629; status=#Active; clubId=22; valueQuarterMillions=38; dateOfBirth=1067472000000000000; nationality=186; shirtNumber=30; totalPoints=0; position=#Midfielder; lastName="Humphreys"; firstName="Cameron"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=628; status=#Active; clubId=22; valueQuarterMillions=40; dateOfBirth=717379200000000000; nationality=9; shirtNumber=25; totalPoints=5; position=#Midfielder; lastName="Luongo"; firstName="Massimo"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=627; status=#Active; clubId=22; valueQuarterMillions=48; dateOfBirth=898560000000000000; nationality=81; shirtNumber=14; totalPoints=5; position=#Midfielder; lastName="Taylor"; firstName="Jack"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=626; status=#Active; clubId=22; valueQuarterMillions=64; dateOfBirth=785548800000000000; nationality=186; shirtNumber=7; totalPoints=0; position=#Midfielder; lastName="Burns"; firstName="Wes"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=625; status=#Active; clubId=22; valueQuarterMillions=40; dateOfBirth=684460800000000000; nationality=52; shirtNumber=5; totalPoints=5; position=#Midfielder; lastName="Morsy"; firstName="Sam"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=624; status=#Active; clubId=22; valueQuarterMillions=32; dateOfBirth=968716800000000000; nationality=186; shirtNumber=0; totalPoints=-10; position=#Defender; lastName="Greaves"; firstName="Jacob"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=623; status=#Active; clubId=22; valueQuarterMillions=34; dateOfBirth=879465600000000000; nationality=39; shirtNumber=40; totalPoints=-10; position=#Defender; lastName="Tuanzebe"; firstName="Axel"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=622; status=#Active; clubId=22; valueQuarterMillions=32; dateOfBirth=814233600000000000; nationality=186; shirtNumber=15; totalPoints=0; position=#Defender; lastName="Burgess"; firstName="Cameron"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=621; status=#Active; clubId=22; valueQuarterMillions=34; dateOfBirth=908928000000000000; nationality=186; shirtNumber=6; totalPoints=-15; position=#Defender; lastName="Woolfenden"; firstName="Luke"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=620; status=#Active; clubId=22; valueQuarterMillions=34; dateOfBirth=871603200000000000; nationality=186; shirtNumber=4; totalPoints=0; position=#Defender; lastName="Edmundson"; firstName="George"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=619; status=#Active; clubId=22; valueQuarterMillions=36; dateOfBirth=946598400000000000; nationality=186; shirtNumber=3; totalPoints=-10; position=#Defender; lastName="Davis"; firstName="Leif"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=618; status=#Active; clubId=22; valueQuarterMillions=34; dateOfBirth=983491200000000000; nationality=186; shirtNumber=2; totalPoints=0; position=#Defender; lastName="Clarke"; firstName="Harry"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=617; status=#Active; clubId=22; valueQuarterMillions=28; dateOfBirth=910396800000000000; nationality=169; shirtNumber=0; totalPoints=0; position=#Goalkeeper; lastName="Muric"; firstName="Arijanet"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=616; status=#Active; clubId=22; valueQuarterMillions=24; dateOfBirth=1032048000000000000; nationality=186; shirtNumber=13; totalPoints=0; position=#Goalkeeper; lastName="Slicker"; firstName="Cieran"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=615; status=#Active; clubId=22; valueQuarterMillions=32; dateOfBirth=815875200000000000; nationality=186; shirtNumber=1; totalPoints=-5; position=#Goalkeeper; lastName="Walton"; firstName="Christian"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=614; status=#Active; clubId=20; valueQuarterMillions=48; dateOfBirth=1057536000000000000; nationality=141; shirtNumber=19; totalPoints=5; position=#Forward; lastName="Gomes"; firstName="Rodrigo"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=613; status=#Active; clubId=20; valueQuarterMillions=60; dateOfBirth=949795200000000000; nationality=131; shirtNumber=9; totalPoints=5; position=#Forward; lastName="Strand Larsen"; firstName="Jørgen"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=612; status=#Active; clubId=20; valueQuarterMillions=30; dateOfBirth=1151712000000000000; nationality=24; shirtNumber=37; totalPoints=0; position=#Defender; lastName="Lima"; firstName="Pedro"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=611; status=#Active; clubId=19; valueQuarterMillions=44; dateOfBirth=864345600000000000; nationality=186; shirtNumber=26; totalPoints=-10; position=#Defender; lastName="Kilman"; firstName="Max"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=610; status=#Active; clubId=18; valueQuarterMillions=52; dateOfBirth=1138838400000000000; nationality=168; shirtNumber=15; totalPoints=0; position=#Midfielder; lastName="Bergvall"; firstName="Lucas"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=609; status=#Active; clubId=18; valueQuarterMillions=48; dateOfBirth=1142121600000000000; nationality=186; shirtNumber=14; totalPoints=0; position=#Midfielder; lastName="Gray"; firstName="Archie"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=608; status=#Active; clubId=18; valueQuarterMillions=48; dateOfBirth=1080086400000000000; nationality=186; shirtNumber=44; totalPoints=0; position=#Forward; lastName="Scarlett"; firstName="Dane"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=607; status=#Active; clubId=18; valueQuarterMillions=32; dateOfBirth=1119744000000000000; nationality=186; shirtNumber=24; totalPoints=0; position=#Defender; lastName="Phillips"; firstName="Ashley"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=606; status=#Active; clubId=18; valueQuarterMillions=32; dateOfBirth=965779200000000000; nationality=186; shirtNumber=24; totalPoints=0; position=#Defender; lastName="Spence"; firstName="Djed"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=605; status=#Active; clubId=15; valueQuarterMillions=40; dateOfBirth=935107200000000000; nationality=186; shirtNumber=28; totalPoints=0; position=#Midfielder; lastName="Willock"; firstName="Joe"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=604; status=#Active; clubId=15; valueQuarterMillions=32; dateOfBirth=530496000000000000; nationality=186; shirtNumber=0; totalPoints=0; position=#Goalkeeper; lastName="Ruddy"; firstName="John"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=603; status=#Active; clubId=14; valueQuarterMillions=80; dateOfBirth=990489600000000000; nationality=125; shirtNumber=0; totalPoints=15; position=#Forward; lastName="Zirkzee"; firstName="Joshua"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=601; status=#Active; clubId=13; valueQuarterMillions=48; dateOfBirth=1081555200000000000; nationality=24; shirtNumber=26; totalPoints=5; position=#Midfielder; lastName="Savinho"; firstName=""; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=600; status=#Active; clubId=13; valueQuarterMillions=32; dateOfBirth=1040860800000000000; nationality=186; shirtNumber=97; totalPoints=0; position=#Defender; lastName="Wilson-Esbrand"; firstName="Josh"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=599; status=#Active; clubId=4; valueQuarterMillions=72; dateOfBirth=1030665600000000000; nationality=141; shirtNumber=28; totalPoints=5; position=#Forward; lastName="Carvalho"; firstName="Fábio"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=598; status=#Active; clubId=11; valueQuarterMillions=32; dateOfBirth=1040342400000000000; nationality=24; shirtNumber=45; totalPoints=0; position=#Goalkeeper; lastName="Pitaluga"; firstName="Marcelo"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=596; status=#Active; clubId=9; valueQuarterMillions=72; dateOfBirth=952300800000000000; nationality=153; shirtNumber=0; totalPoints=5; position=#Forward; lastName="Ndiaye"; firstName="Iliman"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=595; status=#Active; clubId=9; valueQuarterMillions=72; dateOfBirth=829180800000000000; nationality=186; shirtNumber=20; totalPoints=0; position=#Midfielder; lastName="Alli"; firstName="Dele"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=594; status=#Active; clubId=8; valueQuarterMillions=32; dateOfBirth=1065830400000000000; nationality=186; shirtNumber=63; totalPoints=0; position=#Midfielder; lastName="Devenny"; firstName="Justin"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=593; status=#Active; clubId=8; valueQuarterMillions=32; dateOfBirth=1097107200000000000; nationality=186; shirtNumber=51; totalPoints=0; position=#Midfielder; lastName="Rodney"; firstName="Kaden"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=592; status=#Active; clubId=8; valueQuarterMillions=44; dateOfBirth=1017446400000000000; nationality=81; shirtNumber=34; totalPoints=0; position=#Midfielder; lastName="Phillips"; firstName="Killian"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=590; status=#Active; clubId=8; valueQuarterMillions=68; dateOfBirth=839203200000000000; nationality=85; shirtNumber=0; totalPoints=10; position=#Midfielder; lastName="Kamada"; firstName="Daichi"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=588; status=#Active; clubId=8; valueQuarterMillions=36; dateOfBirth=1073520000000000000; nationality=81; shirtNumber=42; totalPoints=0; position=#Defender; lastName="Grehan"; firstName="Seán"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=587; status=#Active; clubId=8; valueQuarterMillions=36; dateOfBirth=1055808000000000000; nationality=119; shirtNumber=0; totalPoints=0; position=#Defender; lastName="Riad"; firstName="Chadi"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=586; status=#Active; clubId=7; valueQuarterMillions=52; dateOfBirth=1040515200000000000; nationality=42; shirtNumber=0; totalPoints=0; position=#Forward; lastName="Fofana"; firstName="David"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=585; status=#Active; clubId=7; valueQuarterMillions=48; dateOfBirth=1136332800000000000; nationality=164; shirtNumber=38; totalPoints=5; position=#Forward; lastName="Guiu"; firstName="Marc"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=583; status=#Active; clubId=7; valueQuarterMillions=60; dateOfBirth=1000080000000000000; nationality=2; shirtNumber=19; totalPoints=0; position=#Forward; lastName="Broja"; firstName="Armando"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=582; status=#Active; clubId=5; valueQuarterMillions=48; dateOfBirth=1101686400000000000; nationality=66; shirtNumber=0; totalPoints=0; position=#Forward; lastName="Osman"; firstName="Ibrahim"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=581; status=#Active; clubId=5; valueQuarterMillions=60; dateOfBirth=1090454400000000000; nationality=63; shirtNumber=0; totalPoints=15; position=#Forward; lastName="Minteh"; firstName="Yankuba"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=580; status=#Active; clubId=5; valueQuarterMillions=40; dateOfBirth=1117324800000000000; nationality=186; shirtNumber=0; totalPoints=0; position=#Midfielder; lastName="Cozier-Duberry"; firstName="Amario"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=579; status=#Active; clubId=5; valueQuarterMillions=80; dateOfBirth=837734400000000000; nationality=65; shirtNumber=21; totalPoints=0; position=#Forward; lastName="Undav"; firstName="Deniz"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=578; status=#Active; clubId=5; valueQuarterMillions=48; dateOfBirth=942710400000000000; nationality=125; shirtNumber=0; totalPoints=15; position=#Midfielder; lastName="Wieffer"; firstName="Mats"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=577; status=#Active; clubId=5; valueQuarterMillions=40; dateOfBirth=1032739200000000000; nationality=9; shirtNumber=44; totalPoints=0; position=#Midfielder; lastName="Peupion"; firstName="Cameron"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=576; status=#Active; clubId=5; valueQuarterMillions=48; dateOfBirth=1024185600000000000; nationality=51; shirtNumber=19; totalPoints=5; position=#Midfielder; lastName="Sarmiento"; firstName="Jeremy"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=575; status=#Active; clubId=5; valueQuarterMillions=40; dateOfBirth=1035590400000000000; nationality=65; shirtNumber=8; totalPoints=0; position=#Midfielder; lastName="Dahoud"; firstName="Mahmoud"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=574; status=#Active; clubId=5; valueQuarterMillions=24; dateOfBirth=1035590400000000000; nationality=186; shirtNumber=42; totalPoints=0; position=#Defender; lastName="Offiah"; firstName="Odeluga"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=573; status=#Active; clubId=4; valueQuarterMillions=64; dateOfBirth=980467200000000000; nationality=24; shirtNumber=9; totalPoints=0; position=#Forward; lastName="Thiago"; firstName="Igor"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=572; status=#Active; clubId=4; valueQuarterMillions=32; dateOfBirth=1136851200000000000; nationality=180; shirtNumber=0; totalPoints=0; position=#Midfielder; lastName="Konak"; firstName="Yunus"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=571; status=#Active; clubId=4; valueQuarterMillions=40; dateOfBirth=1103846400000000000; nationality=91; shirtNumber=36; totalPoints=0; position=#Defender; lastName="Kim"; firstName="Ji-soo"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=570; status=#Active; clubId=3; valueQuarterMillions=60; dateOfBirth=1057881600000000000; nationality=186; shirtNumber=0; totalPoints=5; position=#Forward; lastName="Jebbison"; firstName="Daniel"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=569; status=#Active; clubId=3; valueQuarterMillions=72; dateOfBirth=863222400000000000; nationality=180; shirtNumber=26; totalPoints=0; position=#Forward; lastName="Ünal"; firstName="Enes"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=568; status=#Active; clubId=2; valueQuarterMillions=60; dateOfBirth=1013126400000000000; nationality=186; shirtNumber=0; totalPoints=5; position=#Midfielder; lastName="Philogene"; firstName="Jaden"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=567; status=#Active; clubId=2; valueQuarterMillions=60; dateOfBirth=1065225600000000000; nationality=186; shirtNumber=0; totalPoints=0; position=#Midfielder; lastName="Iling-Junior"; firstName="Samuel"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=566; status=#Active; clubId=2; valueQuarterMillions=60; dateOfBirth=990489600000000000; nationality=7; shirtNumber=0; totalPoints=0; position=#Midfielder; lastName="Barrenechea"; firstName="Enzo"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=565; status=#Active; clubId=2; valueQuarterMillions=68; dateOfBirth=797904000000000000; nationality=17; shirtNumber=32; totalPoints=0; position=#Midfielder; lastName="Dendoncker"; firstName="Leander"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=564; status=#Active; clubId=2; valueQuarterMillions=20; dateOfBirth=1106092800000000000; nationality=141; shirtNumber=0; totalPoints=0; position=#Defender; lastName="Sousa"; firstName="Lino"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=563; status=#Active; clubId=2; valueQuarterMillions=20; dateOfBirth=1134691200000000000; nationality=154; shirtNumber=0; totalPoints=5; position=#Defender; lastName="Nedeljković"; firstName="Kosta"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=562; status=#Active; clubId=1; valueQuarterMillions=60; dateOfBirth=865468800000000000; nationality=186; shirtNumber=3; totalPoints=0; position=#Defender; lastName="Tierney"; firstName="Kieran"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=561; status=#Active; clubId=2; valueQuarterMillions=40; dateOfBirth=895104000000000000; nationality=125; shirtNumber=0; totalPoints=5; position=#Defender; lastName="Maatsen"; firstName="Ian"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=1; status=#Active; clubId=23; valueQuarterMillions=56; dateOfBirth=895104000000000000; nationality=186; shirtNumber=1; totalPoints=0; position=#Goalkeeper; lastName="Ramsdale"; firstName="Aaron"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=2; status=#Active; clubId=1; valueQuarterMillions=56; dateOfBirth=811123200000000000; nationality=164; shirtNumber=22; totalPoints=20; position=#Goalkeeper; lastName="Raya"; firstName="David"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=4; status=#Active; clubId=1; valueQuarterMillions=60; dateOfBirth=985392000000000000; nationality=61; shirtNumber=2; totalPoints=15; position=#Defender; lastName="Saliba"; firstName="William"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=5; status=#Active; clubId=1; valueQuarterMillions=64; dateOfBirth=876268800000000000; nationality=186; shirtNumber=4; totalPoints=15; position=#Defender; lastName="White"; firstName="Ben"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=6; status=#Active; clubId=1; valueQuarterMillions=72; dateOfBirth=882489600000000000; nationality=24; shirtNumber=6; totalPoints=15; position=#Defender; lastName="Magalhães"; firstName="Gabriel"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=7; status=#Active; clubId=1; valueQuarterMillions=60; dateOfBirth=992736000000000000; nationality=125; shirtNumber=12; totalPoints=15; position=#Defender; lastName="Timber"; firstName="Jurrien"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=8; status=#Active; clubId=1; valueQuarterMillions=22; dateOfBirth=950572800000000000; nationality=140; shirtNumber=15; totalPoints=0; position=#Defender; lastName="Kiwior"; firstName="Jakub"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=10; status=#Active; clubId=1; valueQuarterMillions=30; dateOfBirth=910224000000000000; nationality=85; shirtNumber=18; totalPoints=0; position=#Defender; lastName="Tomiyasu"; firstName="Takehiro"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=11; status=#Active; clubId=1; valueQuarterMillions=64; dateOfBirth=850608000000000000; nationality=184; shirtNumber=35; totalPoints=15; position=#Defender; lastName="Zinchenko"; firstName="Oleksandr"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=13; status=#Active; clubId=1; valueQuarterMillions=50; dateOfBirth=739929600000000000; nationality=66; shirtNumber=5; totalPoints=5; position=#Midfielder; lastName="Partey"; firstName="Thomas"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=14; status=#Active; clubId=1; valueQuarterMillions=144; dateOfBirth=913852800000000000; nationality=131; shirtNumber=8; totalPoints=5; position=#Midfielder; lastName="Ødegaard"; firstName="Martin"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=15; status=#Active; clubId=10; valueQuarterMillions=88; dateOfBirth=964742400000000000; nationality=186; shirtNumber=10; totalPoints=5; position=#Midfielder; lastName="Smith Rowe"; firstName="Emile"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=16; status=#Active; clubId=1; valueQuarterMillions=92; dateOfBirth=693187200000000000; nationality=83; shirtNumber=20; totalPoints=0; position=#Midfielder; lastName="Jorginho"; firstName=""; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=17; status=#Active; clubId=1; valueQuarterMillions=88; dateOfBirth=959644800000000000; nationality=141; shirtNumber=21; totalPoints=0; position=#Midfielder; lastName="Vieira"; firstName="Fábio"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=19; status=#Active; clubId=1; valueQuarterMillions=164; dateOfBirth=929059200000000000; nationality=65; shirtNumber=29; totalPoints=55; position=#Midfielder; lastName="Havertz"; firstName="Kai"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=20; status=#Active; clubId=1; valueQuarterMillions=84; dateOfBirth=916272000000000000; nationality=186; shirtNumber=41; totalPoints=5; position=#Midfielder; lastName="Rice"; firstName="Declan"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=21; status=#Active; clubId=1; valueQuarterMillions=42; dateOfBirth=1159228800000000000; nationality=186; shirtNumber=59; totalPoints=0; position=#Midfielder; lastName="Lewis-Skelly"; firstName="Myles"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=22; status=#Active; clubId=1; valueQuarterMillions=42; dateOfBirth=1174435200000000000; nationality=186; shirtNumber=63; totalPoints=0; position=#Midfielder; lastName="Nwaneri"; firstName="Ethan"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=23; status=#Active; clubId=1; valueQuarterMillions=190; dateOfBirth=999648000000000000; nationality=186; shirtNumber=7; totalPoints=20; position=#Forward; lastName="Saka"; firstName="Bukayo"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=24; status=#Active; clubId=1; valueQuarterMillions=194; dateOfBirth=860025600000000000; nationality=24; shirtNumber=9; totalPoints=5; position=#Forward; lastName="Jesus"; firstName="Gabriel"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=25; status=#Active; clubId=1; valueQuarterMillions=126; dateOfBirth=992822400000000000; nationality=24; shirtNumber=11; totalPoints=5; position=#Forward; lastName="Martinelli"; firstName="Gabriel"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=26; status=#Active; clubId=1; valueQuarterMillions=118; dateOfBirth=928022400000000000; nationality=186; shirtNumber=14; totalPoints=0; position=#Forward; lastName="Nketiah"; firstName="Eddie"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=27; status=#Active; clubId=1; valueQuarterMillions=130; dateOfBirth=786499200000000000; nationality=17; shirtNumber=19; totalPoints=5; position=#Forward; lastName="Trossard"; firstName="Leandro"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=28; status=#Active; clubId=1; valueQuarterMillions=50; dateOfBirth=944784000000000000; nationality=186; shirtNumber=24; totalPoints=0; position=#Forward; lastName="Nelson"; firstName="Reiss"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=30; status=#Active; clubId=1; valueQuarterMillions=42; dateOfBirth=1090627200000000000; nationality=186; shirtNumber=71; totalPoints=0; position=#Forward; lastName="Sagoe"; firstName="Charles"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=31; status=#Active; clubId=2; valueQuarterMillions=64; dateOfBirth=715392000000000000; nationality=7; shirtNumber=1; totalPoints=10; position=#Goalkeeper; lastName="Martínez"; firstName="Emiliano"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=32; status=#Active; clubId=2; valueQuarterMillions=18; dateOfBirth=631756800000000000; nationality=168; shirtNumber=25; totalPoints=0; position=#Goalkeeper; lastName="Olsen"; firstName="Robin"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=33; status=#Active; clubId=2; valueQuarterMillions=22; dateOfBirth=1088899200000000000; nationality=9; shirtNumber=0; totalPoints=0; position=#Goalkeeper; lastName="Gauci"; firstName="Joe"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=34; status=#Active; clubId=2; valueQuarterMillions=22; dateOfBirth=1166659200000000000; nationality=186; shirtNumber=0; totalPoints=0; position=#Goalkeeper; lastName="Proctor"; firstName="Sam"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=35; status=#Active; clubId=2; valueQuarterMillions=22; dateOfBirth=1101945600000000000; nationality=186; shirtNumber=0; totalPoints=0; position=#Goalkeeper; lastName="Wright"; firstName="James"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=36; status=#Active; clubId=2; valueQuarterMillions=46; dateOfBirth=870912000000000000; nationality=140; shirtNumber=2; totalPoints=5; position=#Defender; lastName="Cash"; firstName="Matty"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=37; status=#Active; clubId=2; valueQuarterMillions=50; dateOfBirth=732153600000000000; nationality=24; shirtNumber=3; totalPoints=0; position=#Defender; lastName="Carlos"; firstName="Diego"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=38; status=#Active; clubId=2; valueQuarterMillions=38; dateOfBirth=877564800000000000; nationality=186; shirtNumber=4; totalPoints=5; position=#Defender; lastName="Konsa"; firstName="Ezri"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=39; status=#Active; clubId=2; valueQuarterMillions=50; dateOfBirth=731980800000000000; nationality=186; shirtNumber=5; totalPoints=0; position=#Defender; lastName="Mings"; firstName="Tyrone"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=40; status=#Active; clubId=2; valueQuarterMillions=42; dateOfBirth=869356800000000000; nationality=61; shirtNumber=27; totalPoints=5; position=#Defender; lastName="Digne"; firstName="Lucas"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=41; status=#Active; clubId=2; valueQuarterMillions=22; dateOfBirth=853372800000000000; nationality=164; shirtNumber=0; totalPoints=5; position=#Defender; lastName="Torres"; firstName="Pau"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=42; status=#Active; clubId=2; valueQuarterMillions=42; dateOfBirth=739497600000000000; nationality=164; shirtNumber=15; totalPoints=0; position=#Defender; lastName="Moreno"; firstName="Álex"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=45; status=#Active; clubId=2; valueQuarterMillions=22; dateOfBirth=1035331200000000000; nationality=186; shirtNumber=29; totalPoints=0; position=#Defender; lastName="Kesler-Hayden"; firstName="Kaine"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=46; status=#Active; clubId=2; valueQuarterMillions=22; dateOfBirth=805852800000000000; nationality=186; shirtNumber=30; totalPoints=0; position=#Defender; lastName="Hause"; firstName="Kortney"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=48; status=#Active; clubId=2; valueQuarterMillions=68; dateOfBirth=782438400000000000; nationality=186; shirtNumber=7; totalPoints=5; position=#Midfielder; lastName="McGinn"; firstName="John"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=49; status=#Active; clubId=2; valueQuarterMillions=106; dateOfBirth=862963200000000000; nationality=17; shirtNumber=8; totalPoints=15; position=#Midfielder; lastName="Tielemans"; firstName="Youri"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=50; status=#Active; clubId=2; valueQuarterMillions=92; dateOfBirth=851472000000000000; nationality=7; shirtNumber=10; totalPoints=0; position=#Midfielder; lastName="Buendía"; firstName="Emiliano"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=53; status=#Active; clubId=2; valueQuarterMillions=42; dateOfBirth=1027641600000000000; nationality=186; shirtNumber=27; totalPoints=5; position=#Midfielder; lastName="Rogers"; firstName="Morgan"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=54; status=#Active; clubId=2; valueQuarterMillions=34; dateOfBirth=871084800000000000; nationality=84; shirtNumber=31; totalPoints=0; position=#Midfielder; lastName="Bailey"; firstName="Leon"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=55; status=#Active; clubId=2; valueQuarterMillions=68; dateOfBirth=991008000000000000; nationality=186; shirtNumber=41; totalPoints=15; position=#Midfielder; lastName="Ramsey"; firstName="Jacob"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=56; status=#Active; clubId=2; valueQuarterMillions=50; dateOfBirth=943315200000000000; nationality=61; shirtNumber=44; totalPoints=0; position=#Midfielder; lastName="Kamara"; firstName="Boubacar"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=57; status=#Active; clubId=9; valueQuarterMillions=38; dateOfBirth=1056931200000000000; nationality=186; shirtNumber=47; totalPoints=5; position=#Midfielder; lastName="Iroegbunam"; firstName="Tim"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=58; status=#Active; clubId=7; valueQuarterMillions=42; dateOfBirth=1126742400000000000; nationality=186; shirtNumber=71; totalPoints=0; position=#Midfielder; lastName="Kellyman"; firstName="Omari"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=59; status=#Active; clubId=2; valueQuarterMillions=160; dateOfBirth=820281600000000000; nationality=186; shirtNumber=11; totalPoints=5; position=#Forward; lastName="Watkins"; firstName="Ollie"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=60; status=#Active; clubId=2; valueQuarterMillions=84; dateOfBirth=1071273600000000000; nationality=37; shirtNumber=22; totalPoints=15; position=#Forward; lastName="Durán"; firstName="Jhon"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=61; status=#Active; clubId=3; valueQuarterMillions=42; dateOfBirth=616809600000000000; nationality=24; shirtNumber=1; totalPoints=15; position=#Goalkeeper; lastName="Neto"; firstName=""; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=64; status=#Active; clubId=3; valueQuarterMillions=22; dateOfBirth=926985600000000000; nationality=81; shirtNumber=42; totalPoints=0; position=#Goalkeeper; lastName="Travers"; firstName="Mark"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=66; status=#Active; clubId=3; valueQuarterMillions=42; dateOfBirth=1068163200000000000; nationality=75; shirtNumber=3; totalPoints=0; position=#Defender; lastName="Kerkez"; firstName="Milos"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=67; status=#Active; clubId=15; valueQuarterMillions=34; dateOfBirth=907632000000000000; nationality=186; shirtNumber=5; totalPoints=15; position=#Defender; lastName="Kelly"; firstName="Lloyd"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=68; status=#Active; clubId=3; valueQuarterMillions=34; dateOfBirth=878688000000000000; nationality=186; shirtNumber=6; totalPoints=0; position=#Defender; lastName="Mepham"; firstName="Chris"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=69; status=#Active; clubId=3; valueQuarterMillions=34; dateOfBirth=672883200000000000; nationality=186; shirtNumber=15; totalPoints=5; position=#Defender; lastName="Smith"; firstName="Adam"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=70; status=#Active; clubId=3; valueQuarterMillions=22; dateOfBirth=1010620800000000000; nationality=186; shirtNumber=23; totalPoints=0; position=#Defender; lastName="Hill"; firstName="James"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=71; status=#Active; clubId=3; valueQuarterMillions=38; dateOfBirth=863222400000000000; nationality=7; shirtNumber=25; totalPoints=0; position=#Defender; lastName="Senesi"; firstName="Marcos"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=72; status=#Active; clubId=3; valueQuarterMillions=42; dateOfBirth=907632000000000000; nationality=184; shirtNumber=27; totalPoints=5; position=#Defender; lastName="Zabarnyi"; firstName="Ilya"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=73; status=#Active; clubId=3; valueQuarterMillions=42; dateOfBirth=946944000000000000; nationality=186; shirtNumber=37; totalPoints=0; position=#Defender; lastName="Aarons"; firstName="Max"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=74; status=#Active; clubId=3; valueQuarterMillions=60; dateOfBirth=854928000000000000; nationality=186; shirtNumber=4; totalPoints=0; position=#Midfielder; lastName="Cook"; firstName="Lewis"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=75; status=#Active; clubId=3; valueQuarterMillions=64; dateOfBirth=900374400000000000; nationality=61; shirtNumber=8; totalPoints=0; position=#Midfielder; lastName="Faivre"; firstName="Romain"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=76; status=#Active; clubId=3; valueQuarterMillions=76; dateOfBirth=761875200000000000; nationality=186; shirtNumber=10; totalPoints=5; position=#Midfielder; lastName="Christie"; firstName="Ryan"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=77; status=#Active; clubId=3; valueQuarterMillions=60; dateOfBirth=1061424000000000000; nationality=186; shirtNumber=14; totalPoints=5; position=#Midfielder; lastName="Scott"; firstName="Alex"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=78; status=#Active; clubId=3; valueQuarterMillions=50; dateOfBirth=922060800000000000; nationality=186; shirtNumber=16; totalPoints=5; position=#Midfielder; lastName="Tavernier"; firstName="Marcus"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=79; status=#Active; clubId=3; valueQuarterMillions=60; dateOfBirth=918950400000000000; nationality=187; shirtNumber=18; totalPoints=0; position=#Midfielder; lastName="Adams"; firstName="Tyler"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=80; status=#Active; clubId=3; valueQuarterMillions=42; dateOfBirth=949363200000000000; nationality=186; shirtNumber=26; totalPoints=0; position=#Midfielder; lastName="Kilkenny"; firstName="Gavin"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=81; status=#Active; clubId=3; valueQuarterMillions=64; dateOfBirth=834451200000000000; nationality=47; shirtNumber=29; totalPoints=5; position=#Midfielder; lastName="Billing"; firstName="Philip"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=82; status=#Active; clubId=18; valueQuarterMillions=88; dateOfBirth=874195200000000000; nationality=186; shirtNumber=9; totalPoints=0; position=#Forward; lastName="Solanke"; firstName="Dominic"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=83; status=#Active; clubId=3; valueQuarterMillions=64; dateOfBirth=1013385600000000000; nationality=27; shirtNumber=11; totalPoints=5; position=#Forward; lastName="Ouattara"; firstName="Dango"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=84; status=#Active; clubId=3; valueQuarterMillions=84; dateOfBirth=929577600000000000; nationality=37; shirtNumber=17; totalPoints=5; position=#Forward; lastName="Sinisterra"; firstName="Luis"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=85; status=#Active; clubId=3; valueQuarterMillions=64; dateOfBirth=925862400000000000; nationality=125; shirtNumber=0; totalPoints=5; position=#Forward; lastName="Kluivert"; firstName="Justin"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=87; status=#Active; clubId=3; valueQuarterMillions=22; dateOfBirth=947203200000000000; nationality=66; shirtNumber=24; totalPoints=15; position=#Forward; lastName="Semenyo"; firstName="Antoine"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=88; status=#Active; clubId=4; valueQuarterMillions=22; dateOfBirth=739929600000000000; nationality=125; shirtNumber=1; totalPoints=15; position=#Goalkeeper; lastName="Flekken"; firstName="Mark"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=90; status=#Active; clubId=4; valueQuarterMillions=34; dateOfBirth=1051833600000000000; nationality=186; shirtNumber=34; totalPoints=0; position=#Goalkeeper; lastName="Cox"; firstName="Matthew"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=92; status=#Active; clubId=4; valueQuarterMillions=60; dateOfBirth=1023667200000000000; nationality=186; shirtNumber=2; totalPoints=0; position=#Defender; lastName="Hickey"; firstName="Aaron"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=93; status=#Active; clubId=4; valueQuarterMillions=38; dateOfBirth=870912000000000000; nationality=186; shirtNumber=3; totalPoints=0; position=#Defender; lastName="Henry"; firstName="Rico"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=95; status=#Active; clubId=4; valueQuarterMillions=38; dateOfBirth=738633600000000000; nationality=84; shirtNumber=5; totalPoints=-5; position=#Defender; lastName="Pinnock"; firstName="Ethan"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=96; status=#Active; clubId=18; valueQuarterMillions=42; dateOfBirth=850694400000000000; nationality=164; shirtNumber=12; totalPoints=0; position=#Defender; lastName="Reguilón"; firstName="Sergio"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=97; status=#Active; clubId=4; valueQuarterMillions=22; dateOfBirth=640828800000000000; nationality=125; shirtNumber=13; totalPoints=0; position=#Defender; lastName="Jorgensen"; firstName="Mathias"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=98; status=#Active; clubId=4; valueQuarterMillions=56; dateOfBirth=622339200000000000; nationality=186; shirtNumber=16; totalPoints=5; position=#Defender; lastName="Mee"; firstName="Ben"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=99; status=#Active; clubId=4; valueQuarterMillions=42; dateOfBirth=892771200000000000; nationality=131; shirtNumber=20; totalPoints=5; position=#Defender; lastName="Ajer"; firstName="Kristoffer"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=100; status=#Active; clubId=4; valueQuarterMillions=42; dateOfBirth=988588800000000000; nationality=81; shirtNumber=22; totalPoints=20; position=#Defender; lastName="Collins"; firstName="Nathan"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=101; status=#Active; clubId=4; valueQuarterMillions=34; dateOfBirth=930182400000000000; nationality=47; shirtNumber=30; totalPoints=5; position=#Defender; lastName="Roerslev"; firstName="Mads"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=102; status=#Active; clubId=4; valueQuarterMillions=34; dateOfBirth=1049932800000000000; nationality=186; shirtNumber=33; totalPoints=0; position=#Defender; lastName="Stevens"; firstName="Fin"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=103; status=#Active; clubId=4; valueQuarterMillions=76; dateOfBirth=763257600000000000; nationality=47; shirtNumber=6; totalPoints=5; position=#Midfielder; lastName="Nörgaard"; firstName="Christian"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=104; status=#Active; clubId=4; valueQuarterMillions=56; dateOfBirth=820454400000000000; nationality=47; shirtNumber=8; totalPoints=5; position=#Midfielder; lastName="Jensen"; firstName="Mathias"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=105; status=#Active; clubId=4; valueQuarterMillions=26; dateOfBirth=909100800000000000; nationality=186; shirtNumber=10; totalPoints=0; position=#Midfielder; lastName="Dasilva"; firstName="Josh"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=106; status=#Active; clubId=4; valueQuarterMillions=76; dateOfBirth=841708800000000000; nationality=76; shirtNumber=11; totalPoints=20; position=#Forward; lastName="Wissa"; firstName="Yoane"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=107; status=#Active; clubId=4; valueQuarterMillions=56; dateOfBirth=883612800000000000; nationality=129; shirtNumber=15; totalPoints=5; position=#Midfielder; lastName="Onyeka"; firstName="Frank"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=108; status=#Active; clubId=4; valueQuarterMillions=64; dateOfBirth=962582400000000000; nationality=47; shirtNumber=24; totalPoints=5; position=#Midfielder; lastName="Damsgaard"; firstName="Mikkel"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=109; status=#Active; clubId=4; valueQuarterMillions=38; dateOfBirth=1032307200000000000; nationality=186; shirtNumber=25; totalPoints=0; position=#Midfielder; lastName="Peart-Harris"; firstName="Myles"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=111; status=#Active; clubId=4; valueQuarterMillions=84; dateOfBirth=894758400000000000; nationality=65; shirtNumber=27; totalPoints=5; position=#Midfielder; lastName="Janelt"; firstName="Vitaly"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=112; status=#Active; clubId=4; valueQuarterMillions=42; dateOfBirth=1078099200000000000; nationality=184; shirtNumber=36; totalPoints=0; position=#Midfielder; lastName="Yarmolyuk"; firstName="Yehor"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=113; status=#Active; clubId=4; valueQuarterMillions=42; dateOfBirth=989280000000000000; nationality=186; shirtNumber=0; totalPoints=0; position=#Midfielder; lastName="Maghoma"; firstName="Paris"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=114; status=#Active; clubId=4; valueQuarterMillions=42; dateOfBirth=1047427200000000000; nationality=186; shirtNumber=0; totalPoints=0; position=#Midfielder; lastName="Trevitt"; firstName="Ryan"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=115; status=#Active; clubId=9; valueQuarterMillions=88; dateOfBirth=839980800000000000; nationality=61; shirtNumber=7; totalPoints=0; position=#Forward; lastName="Maupay"; firstName="Neal"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=116; status=#Active; clubId=4; valueQuarterMillions=60; dateOfBirth=1006819200000000000; nationality=65; shirtNumber=9; totalPoints=5; position=#Forward; lastName="Schade"; firstName="Kevin"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=118; status=#Active; clubId=4; valueQuarterMillions=152; dateOfBirth=826934400000000000; nationality=186; shirtNumber=17; totalPoints=0; position=#Forward; lastName="Toney"; firstName="Ivan"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=119; status=#Active; clubId=4; valueQuarterMillions=92; dateOfBirth=933984000000000000; nationality=31; shirtNumber=19; totalPoints=15; position=#Forward; lastName="Mbeumo"; firstName="Bryan"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=120; status=#Active; clubId=4; valueQuarterMillions=72; dateOfBirth=982800000000000000; nationality=186; shirtNumber=23; totalPoints=5; position=#Forward; lastName="Lewis-Potter"; firstName="Keane"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=121; status=#Active; clubId=5; valueQuarterMillions=42; dateOfBirth=1029628800000000000; nationality=125; shirtNumber=1; totalPoints=0; position=#Goalkeeper; lastName="Verbruggen"; firstName="Bart"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=122; status=#Active; clubId=5; valueQuarterMillions=22; dateOfBirth=650937600000000000; nationality=186; shirtNumber=23; totalPoints=15; position=#Goalkeeper; lastName="Steele"; firstName="Jason"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=124; status=#Active; clubId=5; valueQuarterMillions=30; dateOfBirth=970272000000000000; nationality=66; shirtNumber=2; totalPoints=0; position=#Defender; lastName="Lamptey"; firstName="Tariq"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=125; status=#Active; clubId=5; valueQuarterMillions=42; dateOfBirth=886809600000000000; nationality=24; shirtNumber=3; totalPoints=0; position=#Defender; lastName="Julio"; firstName="Igor"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=126; status=#Active; clubId=5; valueQuarterMillions=42; dateOfBirth=789177600000000000; nationality=186; shirtNumber=4; totalPoints=15; position=#Defender; lastName="Webster"; firstName="Adam"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=127; status=#Active; clubId=5; valueQuarterMillions=56; dateOfBirth=690681600000000000; nationality=186; shirtNumber=5; totalPoints=15; position=#Defender; lastName="Dunk"; firstName="Lewis"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=128; status=#Active; clubId=5; valueQuarterMillions=22; dateOfBirth=960422400000000000; nationality=125; shirtNumber=29; totalPoints=15; position=#Defender; lastName="Paul van Hecke"; firstName="Jan"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=129; status=#Active; clubId=5; valueQuarterMillions=64; dateOfBirth=885340800000000000; nationality=51; shirtNumber=30; totalPoints=0; position=#Defender; lastName="Estupiñán"; firstName="Pervis"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=130; status=#Active; clubId=5; valueQuarterMillions=46; dateOfBirth=695433600000000000; nationality=125; shirtNumber=34; totalPoints=15; position=#Defender; lastName="Veltman"; firstName="Joël"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=131; status=#Active; clubId=5; valueQuarterMillions=22; dateOfBirth=1090540800000000000; nationality=7; shirtNumber=0; totalPoints=0; position=#Defender; lastName="Barco"; firstName="Valentín"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=132; status=#Active; clubId=5; valueQuarterMillions=38; dateOfBirth=505180800000000000; nationality=186; shirtNumber=6; totalPoints=0; position=#Midfielder; lastName="Milner"; firstName="James"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=133; status=#Active; clubId=5; valueQuarterMillions=72; dateOfBirth=774662400000000000; nationality=186; shirtNumber=7; totalPoints=0; position=#Midfielder; lastName="March"; firstName="Solly"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=134; status=#Active; clubId=5; valueQuarterMillions=30; dateOfBirth=992217600000000000; nationality=186; shirtNumber=11; totalPoints=5; position=#Midfielder; lastName="Gilmour"; firstName="Billy"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=136; status=#Active; clubId=23; valueQuarterMillions=56; dateOfBirth=579225600000000000; nationality=186; shirtNumber=14; totalPoints=0; position=#Midfielder; lastName="Lallana"; firstName="Adam"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=137; status=#Active; clubId=5; valueQuarterMillions=38; dateOfBirth=923443200000000000; nationality=140; shirtNumber=15; totalPoints=0; position=#Midfielder; lastName="Moder"; firstName="Jakub"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=138; status=#Active; clubId=5; valueQuarterMillions=42; dateOfBirth=1073174400000000000; nationality=31; shirtNumber=20; totalPoints=0; position=#Midfielder; lastName="Baleba"; firstName="Carlos"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=139; status=#Active; clubId=5; valueQuarterMillions=92; dateOfBirth=864086400000000000; nationality=85; shirtNumber=22; totalPoints=20; position=#Midfielder; lastName="Mitoma"; firstName="Kaoru"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=140; status=#OnLoan; clubId=21; valueQuarterMillions=42; dateOfBirth=1103760000000000000; nationality=7; shirtNumber=40; totalPoints=0; position=#Midfielder; lastName="Buonanotte"; firstName="Facundo"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=141; status=#Active; clubId=5; valueQuarterMillions=42; dateOfBirth=1105401600000000000; nationality=186; shirtNumber=41; totalPoints=5; position=#Midfielder; lastName="Hinshelwood"; firstName="Jack"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=142; status=#Active; clubId=5; valueQuarterMillions=84; dateOfBirth=1001462400000000000; nationality=24; shirtNumber=9; totalPoints=5; position=#Forward; lastName="Pedro"; firstName="João"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=143; status=#Active; clubId=5; valueQuarterMillions=46; dateOfBirth=1074816000000000000; nationality=137; shirtNumber=10; totalPoints=0; position=#Forward; lastName="Enciso"; firstName="Julio"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=144; status=#Active; clubId=5; valueQuarterMillions=126; dateOfBirth=659577600000000000; nationality=186; shirtNumber=18; totalPoints=50; position=#Forward; lastName="Welbeck"; firstName="Danny"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=145; status=#Active; clubId=5; valueQuarterMillions=64; dateOfBirth=1009843200000000000; nationality=42; shirtNumber=24; totalPoints=15; position=#Forward; lastName="Adingra"; firstName="Simon"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=146; status=#Active; clubId=5; valueQuarterMillions=46; dateOfBirth=1098144000000000000; nationality=81; shirtNumber=28; totalPoints=0; position=#Forward; lastName="Ferguson"; firstName="Evan"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=175; status=#Active; clubId=7; valueQuarterMillions=42; dateOfBirth=879811200000000000; nationality=164; shirtNumber=1; totalPoints=-5; position=#Goalkeeper; lastName="Sanchez"; firstName="Robert"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=176; status=#Active; clubId=7; valueQuarterMillions=22; dateOfBirth=706665600000000000; nationality=186; shirtNumber=13; totalPoints=0; position=#Goalkeeper; lastName="Bettinelli"; firstName="Marcus"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=177; status=#Active; clubId=7; valueQuarterMillions=42; dateOfBirth=939340800000000000; nationality=154; shirtNumber=28; totalPoints=0; position=#Goalkeeper; lastName="Petrovic"; firstName="Djordje"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=178; status=#Active; clubId=7; valueQuarterMillions=22; dateOfBirth=1031097600000000000; nationality=60; shirtNumber=47; totalPoints=0; position=#Goalkeeper; lastName="Bergstrom"; firstName="Lucas"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=179; status=#Active; clubId=7; valueQuarterMillions=64; dateOfBirth=889574400000000000; nationality=61; shirtNumber=2; totalPoints=0; position=#Defender; lastName="Disasi"; firstName="Alex"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=180; status=#Active; clubId=7; valueQuarterMillions=60; dateOfBirth=901065600000000000; nationality=164; shirtNumber=3; totalPoints=-10; position=#Defender; lastName="Cucurella"; firstName="Marc"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=181; status=#Active; clubId=7; valueQuarterMillions=64; dateOfBirth=985564800000000000; nationality=61; shirtNumber=4; totalPoints=0; position=#Defender; lastName="Badiashile"; firstName="Benoît"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=183; status=#Active; clubId=7; valueQuarterMillions=38; dateOfBirth=931132800000000000; nationality=186; shirtNumber=14; totalPoints=0; position=#Defender; lastName="Chalobah"; firstName="Trevoh"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=184; status=#Active; clubId=7; valueQuarterMillions=88; dateOfBirth=851126400000000000; nationality=186; shirtNumber=21; totalPoints=0; position=#Defender; lastName="Chilwell"; firstName="Ben"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=185; status=#Active; clubId=7; valueQuarterMillions=98; dateOfBirth=944611200000000000; nationality=186; shirtNumber=24; totalPoints=0; position=#Defender; lastName="James"; firstName="Reece"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=186; status=#Active; clubId=7; valueQuarterMillions=38; dateOfBirth=1046217600000000000; nationality=153; shirtNumber=26; totalPoints=-10; position=#Defender; lastName="Colwill"; firstName="Levi"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=187; status=#Active; clubId=7; valueQuarterMillions=64; dateOfBirth=1053302400000000000; nationality=61; shirtNumber=27; totalPoints=-10; position=#Defender; lastName="Gusto"; firstName="Malo"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=188; status=#Active; clubId=7; valueQuarterMillions=34; dateOfBirth=977011200000000000; nationality=61; shirtNumber=33; totalPoints=-10; position=#Defender; lastName="Fofana"; firstName="Wesley"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=191; status=#Active; clubId=7; valueQuarterMillions=64; dateOfBirth=979689600000000000; nationality=7; shirtNumber=8; totalPoints=5; position=#Midfielder; lastName="Fernández"; firstName="Enzo"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=192; status=#Active; clubId=7; valueQuarterMillions=42; dateOfBirth=1080259200000000000; nationality=61; shirtNumber=16; totalPoints=0; position=#Midfielder; lastName="Ugochukwu"; firstName="Lesley"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=193; status=#Active; clubId=7; valueQuarterMillions=30; dateOfBirth=1066608000000000000; nationality=186; shirtNumber=17; totalPoints=0; position=#Midfielder; lastName="Chukwuemeka"; firstName="Carney"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=195; status=#Active; clubId=7; valueQuarterMillions=64; dateOfBirth=1004659200000000000; nationality=51; shirtNumber=25; totalPoints=0; position=#Midfielder; lastName="Caicedo"; firstName="Moisés"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=196; status=#Active; clubId=7; valueQuarterMillions=42; dateOfBirth=1042156800000000000; nationality=83; shirtNumber=31; totalPoints=0; position=#Midfielder; lastName="Casadei"; firstName="Cesare"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=197; status=#Active; clubId=7; valueQuarterMillions=60; dateOfBirth=1073347200000000000; nationality=17; shirtNumber=45; totalPoints=5; position=#Midfielder; lastName="Lavia"; firstName="Romeo"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=198; status=#Active; clubId=7; valueQuarterMillions=42; dateOfBirth=1124496000000000000; nationality=186; shirtNumber=54; totalPoints=0; position=#Midfielder; lastName="Castledine"; firstName="Leo"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=199; status=#OnLoan; clubId=1; valueQuarterMillions=262; dateOfBirth=786844800000000000; nationality=186; shirtNumber=7; totalPoints=0; position=#Midfielder; lastName="Sterling"; firstName="Raheem"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=200; status=#Active; clubId=7; valueQuarterMillions=126; dateOfBirth=978652800000000000; nationality=184; shirtNumber=10; totalPoints=0; position=#Midfielder; lastName="Mudryk"; firstName="Mykhaylo"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=201; status=#Active; clubId=7; valueQuarterMillions=80; dateOfBirth=1015718400000000000; nationality=186; shirtNumber=11; totalPoints=0; position=#Midfielder; lastName="Madueke"; firstName="Noni"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=202; status=#Active; clubId=7; valueQuarterMillions=60; dateOfBirth=1020643200000000000; nationality=186; shirtNumber=20; totalPoints=5; position=#Midfielder; lastName="Palmer"; firstName="Cole"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=203; status=#Active; clubId=7; valueQuarterMillions=42; dateOfBirth=1091750400000000000; nationality=17; shirtNumber=43; totalPoints=0; position=#Midfielder; lastName="Moreira"; firstName="Diego"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=204; status=#Active; clubId=7; valueQuarterMillions=168; dateOfBirth=879465600000000000; nationality=61; shirtNumber=18; totalPoints=5; position=#Forward; lastName="Nkunku"; firstName="Christopher"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=205; status=#Active; clubId=7; valueQuarterMillions=148; dateOfBirth=992908800000000000; nationality=63; shirtNumber=15; totalPoints=5; position=#Forward; lastName="Jackson"; firstName="Nicolas"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=206; status=#Active; clubId=7; valueQuarterMillions=42; dateOfBirth=1117929600000000000; nationality=24; shirtNumber=36; totalPoints=0; position=#Forward; lastName="Washington"; firstName="Deivid"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=207; status=#Active; clubId=7; valueQuarterMillions=22; dateOfBirth=1131580800000000000; nationality=84; shirtNumber=0; totalPoints=0; position=#Forward; lastName="Richards"; firstName="Dujuan"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=208; status=#Active; clubId=8; valueQuarterMillions=38; dateOfBirth=733017600000000000; nationality=186; shirtNumber=1; totalPoints=0; position=#Goalkeeper; lastName="Johnstone"; firstName="Sam"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=209; status=#Active; clubId=8; valueQuarterMillions=42; dateOfBirth=858124800000000000; nationality=186; shirtNumber=30; totalPoints=-5; position=#Goalkeeper; lastName="Henderson"; firstName="Dean"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=210; status=#Active; clubId=8; valueQuarterMillions=22; dateOfBirth=760838400000000000; nationality=186; shirtNumber=31; totalPoints=0; position=#Goalkeeper; lastName="Matthews"; firstName="Remi"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=212; status=#Active; clubId=8; valueQuarterMillions=38; dateOfBirth=625622400000000000; nationality=186; shirtNumber=2; totalPoints=0; position=#Defender; lastName="Ward"; firstName="Joel"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=213; status=#Active; clubId=8; valueQuarterMillions=38; dateOfBirth=936144000000000000; nationality=186; shirtNumber=3; totalPoints=-10; position=#Defender; lastName="Mitchell"; firstName="Tyrick"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=214; status=#Active; clubId=8; valueQuarterMillions=30; dateOfBirth=811555200000000000; nationality=186; shirtNumber=4; totalPoints=0; position=#Defender; lastName="Holding"; firstName="Rob"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=216; status=#Active; clubId=8; valueQuarterMillions=42; dateOfBirth=963446400000000000; nationality=186; shirtNumber=6; totalPoints=-15; position=#Defender; lastName="Guéhi"; firstName="Marc"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=217; status=#Active; clubId=8; valueQuarterMillions=42; dateOfBirth=832896000000000000; nationality=37; shirtNumber=12; totalPoints=-10; position=#Defender; lastName="Muñoz"; firstName="Daniel"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=218; status=#Active; clubId=8; valueQuarterMillions=42; dateOfBirth=833500800000000000; nationality=47; shirtNumber=16; totalPoints=-15; position=#Defender; lastName="Andersen"; firstName="Joachim"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=219; status=#Active; clubId=8; valueQuarterMillions=42; dateOfBirth=670809600000000000; nationality=186; shirtNumber=17; totalPoints=0; position=#Defender; lastName="Clyne"; firstName="Nathaniel"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=220; status=#Active; clubId=8; valueQuarterMillions=38; dateOfBirth=954201600000000000; nationality=187; shirtNumber=26; totalPoints=-15; position=#Defender; lastName="Richards"; firstName="Chris"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=223; status=#Active; clubId=8; valueQuarterMillions=64; dateOfBirth=783043200000000000; nationality=37; shirtNumber=8; totalPoints=5; position=#Midfielder; lastName="Lerma"; firstName="Jefferson"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=224; status=#Active; clubId=8; valueQuarterMillions=92; dateOfBirth=899078400000000000; nationality=186; shirtNumber=10; totalPoints=5; position=#Midfielder; lastName="Eze"; firstName="Eberechi"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=225; status=#Active; clubId=8; valueQuarterMillions=50; dateOfBirth=725068800000000000; nationality=66; shirtNumber=15; totalPoints=0; position=#Midfielder; lastName="Schlupp"; firstName="Jeffrey"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=226; status=#Active; clubId=8; valueQuarterMillions=56; dateOfBirth=798076800000000000; nationality=186; shirtNumber=19; totalPoints=5; position=#Midfielder; lastName="Hughes"; firstName="Will"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=227; status=#Active; clubId=8; valueQuarterMillions=64; dateOfBirth=1076025600000000000; nationality=186; shirtNumber=20; totalPoints=5; position=#Midfielder; lastName="Wharton"; firstName="Adam"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=228; status=#Active; clubId=8; valueQuarterMillions=64; dateOfBirth=947289600000000000; nationality=108; shirtNumber=28; totalPoints=5; position=#Midfielder; lastName="Doucouré"; firstName="Cheick"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=229; status=#Active; clubId=8; valueQuarterMillions=42; dateOfBirth=1017360000000000000; nationality=61; shirtNumber=29; totalPoints=0; position=#Midfielder; lastName="Ahamada"; firstName="Naouirou"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=230; status=#Active; clubId=8; valueQuarterMillions=42; dateOfBirth=1641513600000000000; nationality=186; shirtNumber=40; totalPoints=0; position=#Midfielder; lastName="Wells-Morrison"; firstName="Jack"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=232; status=#Active; clubId=8; valueQuarterMillions=42; dateOfBirth=1033776000000000000; nationality=186; shirtNumber=49; totalPoints=0; position=#Midfielder; lastName="Rak-Sakyi"; firstName="Jesurun"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=234; status=#Active; clubId=8; valueQuarterMillions=22; dateOfBirth=1066176000000000000; nationality=186; shirtNumber=60; totalPoints=0; position=#Midfielder; lastName="Raymond"; firstName="Jadan"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=235; status=#Active; clubId=8; valueQuarterMillions=72; dateOfBirth=684547200000000000; nationality=66; shirtNumber=9; totalPoints=5; position=#Forward; lastName="Ayew"; firstName="Jordan"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=236; status=#Active; clubId=8; valueQuarterMillions=60; dateOfBirth=1080777600000000000; nationality=24; shirtNumber=11; totalPoints=0; position=#Forward; lastName="França"; firstName="Matheus"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=237; status=#Active; clubId=8; valueQuarterMillions=68; dateOfBirth=867456000000000000; nationality=61; shirtNumber=14; totalPoints=5; position=#Forward; lastName="Mateta"; firstName="Jean-Philippe"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=238; status=#Active; clubId=8; valueQuarterMillions=64; dateOfBirth=884908800000000000; nationality=61; shirtNumber=22; totalPoints=5; position=#Forward; lastName="Edouard"; firstName="Odsonne"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=241; status=#Active; clubId=9; valueQuarterMillions=38; dateOfBirth=762998400000000000; nationality=186; shirtNumber=1; totalPoints=-10; position=#Goalkeeper; lastName="Pickford"; firstName="Jordan"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=242; status=#Active; clubId=9; valueQuarterMillions=22; dateOfBirth=939513600000000000; nationality=141; shirtNumber=0; totalPoints=0; position=#Goalkeeper; lastName="Virgínia"; firstName="João"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=244; status=#Active; clubId=9; valueQuarterMillions=22; dateOfBirth=962323200000000000; nationality=186; shirtNumber=43; totalPoints=0; position=#Goalkeeper; lastName="Crellin"; firstName="Billy"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=245; status=#Active; clubId=9; valueQuarterMillions=18; dateOfBirth=1003190400000000000; nationality=186; shirtNumber=2; totalPoints=0; position=#Defender; lastName="Patterson"; firstName="Nathan"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=246; status=#Active; clubId=9; valueQuarterMillions=30; dateOfBirth=726710400000000000; nationality=81; shirtNumber=5; totalPoints=-10; position=#Defender; lastName="Keane"; firstName="Michael"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=247; status=#Active; clubId=9; valueQuarterMillions=26; dateOfBirth=722131200000000000; nationality=140; shirtNumber=6; totalPoints=-15; position=#Defender; lastName="Tarkowski"; firstName="James"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=248; status=#Active; clubId=9; valueQuarterMillions=22; dateOfBirth=489715200000000000; nationality=186; shirtNumber=18; totalPoints=-30; position=#Defender; lastName="Young"; firstName="Ashley"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=249; status=#Active; clubId=9; valueQuarterMillions=26; dateOfBirth=927936000000000000; nationality=184; shirtNumber=19; totalPoints=-10; position=#Defender; lastName="Mykolenko"; firstName="Vitaliy"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=251; status=#Active; clubId=9; valueQuarterMillions=26; dateOfBirth=592531200000000000; nationality=81; shirtNumber=23; totalPoints=0; position=#Defender; lastName="Coleman"; firstName="Seamus"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=252; status=#Active; clubId=9; valueQuarterMillions=22; dateOfBirth=1025136000000000000; nationality=186; shirtNumber=32; totalPoints=0; position=#Defender; lastName="Branthwaite"; firstName="jarrad"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=253; status=#Active; clubId=2; valueQuarterMillions=50; dateOfBirth=997920000000000000; nationality=17; shirtNumber=8; totalPoints=45; position=#Midfielder; lastName="Onana"; firstName="Amadou"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=254; status=#Active; clubId=9; valueQuarterMillions=76; dateOfBirth=725846400000000000; nationality=108; shirtNumber=16; totalPoints=5; position=#Midfielder; lastName="Doucouré"; firstName="Abdoulaye"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=257; status=#Active; clubId=9; valueQuarterMillions=50; dateOfBirth=622771200000000000; nationality=153; shirtNumber=27; totalPoints=5; position=#Midfielder; lastName="Gueye"; firstName="Idrissa"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=258; status=#Active; clubId=9; valueQuarterMillions=42; dateOfBirth=984441600000000000; nationality=186; shirtNumber=37; totalPoints=0; position=#Midfielder; lastName="Garner"; firstName="James"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=260; status=#Active; clubId=9; valueQuarterMillions=72; dateOfBirth=943228800000000000; nationality=186; shirtNumber=7; totalPoints=5; position=#Forward; lastName="McNeil"; firstName="Dwight"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=261; status=#Active; clubId=9; valueQuarterMillions=186; dateOfBirth=858470400000000000; nationality=186; shirtNumber=9; totalPoints=5; position=#Forward; lastName="Calvert-Lewin"; firstName="Dominic"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=264; status=#Active; clubId=9; valueQuarterMillions=106; dateOfBirth=886204800000000000; nationality=141; shirtNumber=14; totalPoints=5; position=#Forward; lastName="Beto"; firstName=""; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=265; status=#Active; clubId=9; valueQuarterMillions=64; dateOfBirth=1085356800000000000; nationality=141; shirtNumber=28; totalPoints=0; position=#Forward; lastName="Chermiti"; firstName="Youssef"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=266; status=#Active; clubId=2; valueQuarterMillions=42; dateOfBirth=1041552000000000000; nationality=186; shirtNumber=61; totalPoints=0; position=#Forward; lastName="Dobbin"; firstName="Lewis"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=268; status=#Active; clubId=10; valueQuarterMillions=46; dateOfBirth=699667200000000000; nationality=65; shirtNumber=17; totalPoints=10; position=#Goalkeeper; lastName="Leno"; firstName="Bernd"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=269; status=#Active; clubId=10; valueQuarterMillions=22; dateOfBirth=907200000000000000; nationality=65; shirtNumber=23; totalPoints=0; position=#Goalkeeper; lastName="Benda"; firstName="Steven"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=270; status=#Active; clubId=10; valueQuarterMillions=38; dateOfBirth=813196800000000000; nationality=125; shirtNumber=2; totalPoints=5; position=#Defender; lastName="Tete"; firstName="Kenny"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=271; status=#Active; clubId=10; valueQuarterMillions=22; dateOfBirth=946598400000000000; nationality=129; shirtNumber=3; totalPoints=0; position=#Defender; lastName="Bassey"; firstName="Calvin"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=272; status=#Active; clubId=7; valueQuarterMillions=38; dateOfBirth=875059200000000000; nationality=186; shirtNumber=4; totalPoints=0; position=#Defender; lastName="Adarabioyo"; firstName="Tosin"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=275; status=#Active; clubId=10; valueQuarterMillions=42; dateOfBirth=818121600000000000; nationality=17; shirtNumber=21; totalPoints=0; position=#Defender; lastName="Castagne"; firstName="Timothy"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=276; status=#Active; clubId=10; valueQuarterMillions=34; dateOfBirth=852768000000000000; nationality=61; shirtNumber=31; totalPoints=5; position=#Defender; lastName="Diop"; firstName="Issa"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=277; status=#Active; clubId=10; valueQuarterMillions=38; dateOfBirth=876268800000000000; nationality=187; shirtNumber=33; totalPoints=5; position=#Defender; lastName="Robinson"; firstName="Antonee"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=278; status=#Active; clubId=10; valueQuarterMillions=34; dateOfBirth=791164800000000000; nationality=186; shirtNumber=6; totalPoints=5; position=#Midfielder; lastName="Reed"; firstName="Harrison"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=279; status=#Active; clubId=10; valueQuarterMillions=50; dateOfBirth=664329600000000000; nationality=186; shirtNumber=10; totalPoints=5; position=#Midfielder; lastName="Cairney"; firstName="Tom"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=280; status=#Active; clubId=10; valueQuarterMillions=42; dateOfBirth=820454400000000000; nationality=24; shirtNumber=18; totalPoints=0; position=#Midfielder; lastName="Pereira"; firstName="Andreas"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=282; status=#Active; clubId=10; valueQuarterMillions=42; dateOfBirth=839894400000000000; nationality=154; shirtNumber=28; totalPoints=5; position=#Midfielder; lastName="Lukic"; firstName="Sasa"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=283; status=#Active; clubId=10; valueQuarterMillions=84; dateOfBirth=673401600000000000; nationality=113; shirtNumber=9; totalPoints=5; position=#Forward; lastName="Jiménez"; firstName="Raúl"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=284; status=#Active; clubId=10; valueQuarterMillions=92; dateOfBirth=858988800000000000; nationality=186; shirtNumber=8; totalPoints=5; position=#Forward; lastName="Wilson"; firstName="Harry"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=285; status=#Active; clubId=10; valueQuarterMillions=64; dateOfBirth=822528000000000000; nationality=164; shirtNumber=11; totalPoints=5; position=#Forward; lastName="Traoré"; firstName="Adama"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=286; status=#Active; clubId=21; valueQuarterMillions=80; dateOfBirth=728611200000000000; nationality=84; shirtNumber=14; totalPoints=0; position=#Forward; lastName="De Cordova-Reid"; firstName="Bobby"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=287; status=#Active; clubId=10; valueQuarterMillions=42; dateOfBirth=988934400000000000; nationality=24; shirtNumber=19; totalPoints=5; position=#Forward; lastName="Muniz"; firstName="Rodrigo"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=288; status=#Active; clubId=10; valueQuarterMillions=84; dateOfBirth=587088000000000000; nationality=24; shirtNumber=20; totalPoints=0; position=#Forward; lastName="Willian"; firstName=""; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=289; status=#Active; clubId=10; valueQuarterMillions=60; dateOfBirth=831081600000000000; nationality=129; shirtNumber=17; totalPoints=5; position=#Forward; lastName="Iwobi"; firstName="Alex"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=290; status=#Active; clubId=10; valueQuarterMillions=80; dateOfBirth=796089600000000000; nationality=24; shirtNumber=30; totalPoints=0; position=#Forward; lastName="Vinícius"; firstName="Carlos"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=292; status=#Active; clubId=11; valueQuarterMillions=84; dateOfBirth=717984000000000000; nationality=24; shirtNumber=1; totalPoints=15; position=#Goalkeeper; lastName="Alisson"; firstName=""; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=294; status=#Active; clubId=11; valueQuarterMillions=18; dateOfBirth=911779200000000000; nationality=81; shirtNumber=62; totalPoints=0; position=#Goalkeeper; lastName="Kelleher"; firstName="Caoimhín"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=295; status=#Active; clubId=11; valueQuarterMillions=34; dateOfBirth=864345600000000000; nationality=186; shirtNumber=2; totalPoints=0; position=#Defender; lastName="Gomez"; firstName="Joe"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=296; status=#Active; clubId=11; valueQuarterMillions=130; dateOfBirth=678931200000000000; nationality=125; shirtNumber=4; totalPoints=15; position=#Defender; lastName="Van Dijk"; firstName="Virgil"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=297; status=#Active; clubId=11; valueQuarterMillions=60; dateOfBirth=927590400000000000; nationality=61; shirtNumber=5; totalPoints=15; position=#Defender; lastName="Konaté"; firstName="Ibrahima"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=298; status=#Active; clubId=11; valueQuarterMillions=34; dateOfBirth=831859200000000000; nationality=67; shirtNumber=21; totalPoints=15; position=#Defender; lastName="Tsimikas"; firstName="Konstantinos"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=299; status=#Active; clubId=11; valueQuarterMillions=140; dateOfBirth=763344000000000000; nationality=186; shirtNumber=26; totalPoints=15; position=#Defender; lastName="Robertson"; firstName="Andrew"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=301; status=#Active; clubId=11; valueQuarterMillions=102; dateOfBirth=681609600000000000; nationality=31; shirtNumber=46; totalPoints=0; position=#Defender; lastName="Williams"; firstName="Rhys"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=302; status=#Active; clubId=11; valueQuarterMillions=182; dateOfBirth=907718400000000000; nationality=186; shirtNumber=66; totalPoints=15; position=#Defender; lastName="Alexander-Arnold"; firstName="Trent"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=303; status=#Active; clubId=11; valueQuarterMillions=22; dateOfBirth=1043798400000000000; nationality=186; shirtNumber=78; totalPoints=15; position=#Defender; lastName="Quansah"; firstName="Jarell"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=304; status=#Active; clubId=11; valueQuarterMillions=22; dateOfBirth=1057708800000000000; nationality=186; shirtNumber=84; totalPoints=15; position=#Defender; lastName="Bradley"; firstName="Conor"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=305; status=#Active; clubId=11; valueQuarterMillions=84; dateOfBirth=729216000000000000; nationality=85; shirtNumber=3; totalPoints=0; position=#Midfielder; lastName="Endō"; firstName="Wataru"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=307; status=#Active; clubId=11; valueQuarterMillions=148; dateOfBirth=972432000000000000; nationality=75; shirtNumber=8; totalPoints=5; position=#Midfielder; lastName="Szoboszlai"; firstName="Dominik"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=308; status=#Active; clubId=11; valueQuarterMillions=106; dateOfBirth=914457600000000000; nationality=7; shirtNumber=10; totalPoints=5; position=#Midfielder; lastName="Mac Allister"; firstName="Alexis"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=309; status=#Active; clubId=11; valueQuarterMillions=60; dateOfBirth=980812800000000000; nationality=186; shirtNumber=17; totalPoints=0; position=#Midfielder; lastName="Jones"; firstName="Curtis"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=310; status=#Active; clubId=11; valueQuarterMillions=56; dateOfBirth=1049414400000000000; nationality=186; shirtNumber=19; totalPoints=0; position=#Midfielder; lastName="Elliott"; firstName="Harvey"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=311; status=#Active; clubId=11; valueQuarterMillions=64; dateOfBirth=1021507200000000000; nationality=125; shirtNumber=38; totalPoints=5; position=#Midfielder; lastName="Gravenberch"; firstName="Ryan"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=312; status=#Active; clubId=11; valueQuarterMillions=34; dateOfBirth=1098403200000000000; nationality=164; shirtNumber=43; totalPoints=0; position=#Midfielder; lastName="Bajcetic"; firstName="Stefan"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=313; status=#Active; clubId=11; valueQuarterMillions=38; dateOfBirth=1095033600000000000; nationality=186; shirtNumber=53; totalPoints=0; position=#Midfielder; lastName="McConnell"; firstName="James"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=314; status=#Active; clubId=11; valueQuarterMillions=182; dateOfBirth=853113600000000000; nationality=37; shirtNumber=7; totalPoints=5; position=#Forward; lastName="Díaz"; firstName="Luis"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=315; status=#Active; clubId=11; valueQuarterMillions=214; dateOfBirth=930182400000000000; nationality=188; shirtNumber=9; totalPoints=0; position=#Forward; lastName="Núñez"; firstName="Darwin"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=316; status=#Active; clubId=11; valueQuarterMillions=404; dateOfBirth=708566400000000000; nationality=52; shirtNumber=11; totalPoints=50; position=#Forward; lastName="Salah"; firstName="Mohamed"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=317; status=#Active; clubId=11; valueQuarterMillions=172; dateOfBirth=926035200000000000; nationality=125; shirtNumber=18; totalPoints=5; position=#Forward; lastName="Gakpo"; firstName="Cody"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=318; status=#Active; clubId=11; valueQuarterMillions=214; dateOfBirth=849657600000000000; nationality=141; shirtNumber=20; totalPoints=15; position=#Forward; lastName="Jota"; firstName="Diogo"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=319; status=#Active; clubId=11; valueQuarterMillions=42; dateOfBirth=1131667200000000000; nationality=186; shirtNumber=50; totalPoints=0; position=#Forward; lastName="Doak"; firstName="Ben"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=332; status=#Active; clubId=2; valueQuarterMillions=64; dateOfBirth=755049600000000000; nationality=186; shirtNumber=6; totalPoints=0; position=#Midfielder; lastName="Barkley"; firstName="Ross"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=350; status=#Active; clubId=13; valueQuarterMillions=14; dateOfBirth=494553600000000000; nationality=186; shirtNumber=33; totalPoints=0; position=#Goalkeeper; lastName="Carson"; firstName="Scott"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=351; status=#Active; clubId=13; valueQuarterMillions=80; dateOfBirth=745545600000000000; nationality=24; shirtNumber=31; totalPoints=20; position=#Goalkeeper; lastName="Ederson"; firstName=""; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=352; status=#Active; clubId=13; valueQuarterMillions=8; dateOfBirth=721008000000000000; nationality=65; shirtNumber=18; totalPoints=0; position=#Goalkeeper; lastName="Ortega"; firstName="Stefan"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=353; status=#Active; clubId=13; valueQuarterMillions=68; dateOfBirth=806112000000000000; nationality=169; shirtNumber=25; totalPoints=15; position=#Defender; lastName="Akanji"; firstName="Manuel"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=354; status=#Active; clubId=13; valueQuarterMillions=64; dateOfBirth=793065600000000000; nationality=125; shirtNumber=6; totalPoints=0; position=#Defender; lastName="Aké"; firstName="Nathan"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=355; status=#Active; clubId=13; valueQuarterMillions=106; dateOfBirth=769996800000000000; nationality=141; shirtNumber=7; totalPoints=0; position=#Defender; lastName="Cancelo"; firstName="João"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=356; status=#Active; clubId=13; valueQuarterMillions=106; dateOfBirth=863568000000000000; nationality=141; shirtNumber=3; totalPoints=15; position=#Defender; lastName="Dias"; firstName="Rúben"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=358; status=#Active; clubId=13; valueQuarterMillions=64; dateOfBirth=1011744000000000000; nationality=43; shirtNumber=24; totalPoints=15; position=#Defender; lastName="Gvardiol"; firstName="Joško"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=359; status=#Active; clubId=13; valueQuarterMillions=14; dateOfBirth=1100995200000000000; nationality=186; shirtNumber=82; totalPoints=15; position=#Defender; lastName="Lewis"; firstName="Rico"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=360; status=#Active; clubId=13; valueQuarterMillions=88; dateOfBirth=770083200000000000; nationality=186; shirtNumber=5; totalPoints=0; position=#Defender; lastName="Stones"; firstName="John"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=361; status=#Active; clubId=13; valueQuarterMillions=50; dateOfBirth=643852800000000000; nationality=186; shirtNumber=2; totalPoints=0; position=#Defender; lastName="Walker"; firstName="Kyle"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=362; status=#Active; clubId=13; valueQuarterMillions=42; dateOfBirth=1057968000000000000; nationality=131; shirtNumber=52; totalPoints=0; position=#Midfielder; lastName="Bobb"; firstName="Oscar"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=363; status=#Active; clubId=13; valueQuarterMillions=362; dateOfBirth=678067200000000000; nationality=17; shirtNumber=17; totalPoints=5; position=#Midfielder; lastName="De Bruyne"; firstName="Kevin"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=364; status=#Active; clubId=13; valueQuarterMillions=126; dateOfBirth=1022457600000000000; nationality=17; shirtNumber=11; totalPoints=5; position=#Midfielder; lastName="Doku"; firstName="Jérémy"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=365; status=#Active; clubId=13; valueQuarterMillions=190; dateOfBirth=959472000000000000; nationality=186; shirtNumber=47; totalPoints=5; position=#Midfielder; lastName="Foden"; firstName="Phil"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=366; status=#Active; clubId=13; valueQuarterMillions=152; dateOfBirth=810691200000000000; nationality=186; shirtNumber=10; totalPoints=0; position=#Midfielder; lastName="Grealish"; firstName="Jack"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=367; status=#Active; clubId=13; valueQuarterMillions=60; dateOfBirth=768182400000000000; nationality=43; shirtNumber=8; totalPoints=20; position=#Midfielder; lastName="Kovacic"; firstName="Mateo"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=368; status=#Active; clubId=13; valueQuarterMillions=56; dateOfBirth=904176000000000000; nationality=141; shirtNumber=27; totalPoints=0; position=#Midfielder; lastName="Nunes"; firstName="Matheus"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=369; status=#Active; clubId=13; valueQuarterMillions=38; dateOfBirth=1041897600000000000; nationality=7; shirtNumber=32; totalPoints=0; position=#Midfielder; lastName="Perrone"; firstName="Máximo"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=370; status=#Active; clubId=13; valueQuarterMillions=88; dateOfBirth=835401600000000000; nationality=164; shirtNumber=16; totalPoints=0; position=#Midfielder; lastName="Rodri"; firstName=""; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=371; status=#Active; clubId=13; valueQuarterMillions=274; dateOfBirth=776476800000000000; nationality=141; shirtNumber=20; totalPoints=15; position=#Midfielder; lastName="Silva"; firstName="Bernardo"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=373; status=#Active; clubId=13; valueQuarterMillions=374; dateOfBirth=964137600000000000; nationality=131; shirtNumber=9; totalPoints=10; position=#Forward; lastName="Haaland"; firstName="Erling"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=374; status=#Active; clubId=14; valueQuarterMillions=22; dateOfBirth=892512000000000000; nationality=180; shirtNumber=1; totalPoints=0; position=#Goalkeeper; lastName="Bayındır"; firstName="Altay"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=375; status=#Active; clubId=14; valueQuarterMillions=14; dateOfBirth=513907200000000000; nationality=186; shirtNumber=22; totalPoints=0; position=#Goalkeeper; lastName="Heaton"; firstName="Tom"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=376; status=#Active; clubId=14; valueQuarterMillions=64; dateOfBirth=828403200000000000; nationality=31; shirtNumber=24; totalPoints=15; position=#Goalkeeper; lastName="Onana"; firstName="André"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=377; status=#Active; clubId=14; valueQuarterMillions=50; dateOfBirth=774403200000000000; nationality=168; shirtNumber=2; totalPoints=0; position=#Defender; lastName="Lindelöf"; firstName="Victor"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=378; status=#Active; clubId=14; valueQuarterMillions=56; dateOfBirth=731289600000000000; nationality=186; shirtNumber=5; totalPoints=10; position=#Defender; lastName="Maguire"; firstName="Harry"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=379; status=#Active; clubId=14; valueQuarterMillions=64; dateOfBirth=885081600000000000; nationality=7; shirtNumber=6; totalPoints=15; position=#Defender; lastName="Martínez"; firstName="Lisandro"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=380; status=#Active; clubId=14; valueQuarterMillions=30; dateOfBirth=934848000000000000; nationality=125; shirtNumber=12; totalPoints=0; position=#Defender; lastName="Malacia"; firstName="Tyrell"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=382; status=#Active; clubId=14; valueQuarterMillions=56; dateOfBirth=921715200000000000; nationality=141; shirtNumber=20; totalPoints=15; position=#Defender; lastName="Dalot"; firstName="Diogo"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=383; status=#Active; clubId=14; valueQuarterMillions=76; dateOfBirth=805507200000000000; nationality=186; shirtNumber=23; totalPoints=0; position=#Defender; lastName="Shaw"; firstName="Luke"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=384; status=#Active; clubId=19; valueQuarterMillions=34; dateOfBirth=880502400000000000; nationality=186; shirtNumber=29; totalPoints=0; position=#Defender; lastName="Wan-Bissaka"; firstName="Aaron"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=386; status=#Active; clubId=14; valueQuarterMillions=22; dateOfBirth=568166400000000000; nationality=186; shirtNumber=35; totalPoints=15; position=#Defender; lastName="Evans"; firstName="Jonny"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=388; status=#Active; clubId=14; valueQuarterMillions=64; dateOfBirth=840585600000000000; nationality=125; shirtNumber=4; totalPoints=0; position=#Midfielder; lastName="Amrabat"; firstName="Sofyan"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=389; status=#Active; clubId=14; valueQuarterMillions=156; dateOfBirth=915926400000000000; nationality=186; shirtNumber=7; totalPoints=0; position=#Midfielder; lastName="Mount"; firstName="Mason"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=390; status=#Active; clubId=14; valueQuarterMillions=252; dateOfBirth=778982400000000000; nationality=141; shirtNumber=8; totalPoints=5; position=#Midfielder; lastName="Fernandes"; firstName="Bruno"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=391; status=#Active; clubId=14; valueQuarterMillions=114; dateOfBirth=698025600000000000; nationality=47; shirtNumber=14; totalPoints=0; position=#Midfielder; lastName="Eriksen"; firstName="Christian"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=392; status=#Active; clubId=14; valueQuarterMillions=42; dateOfBirth=1026345600000000000; nationality=42; shirtNumber=16; totalPoints=5; position=#Forward; lastName="Diallo"; firstName="Amad"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=393; status=#Active; clubId=14; valueQuarterMillions=60; dateOfBirth=698803200000000000; nationality=24; shirtNumber=18; totalPoints=5; position=#Midfielder; lastName="Casemiro"; firstName="Casemiro"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=394; status=#Active; clubId=14; valueQuarterMillions=38; dateOfBirth=1113868800000000000; nationality=186; shirtNumber=37; totalPoints=5; position=#Midfielder; lastName="Mainoo"; firstName="Kobbie"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=395; status=#Active; clubId=14; valueQuarterMillions=60; dateOfBirth=850003200000000000; nationality=186; shirtNumber=39; totalPoints=5; position=#Midfielder; lastName="McTominay"; firstName="Scott"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=397; status=#Active; clubId=14; valueQuarterMillions=156; dateOfBirth=878256000000000000; nationality=186; shirtNumber=10; totalPoints=5; position=#Forward; lastName="Rashford"; firstName="Marcus"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=398; status=#Active; clubId=14; valueQuarterMillions=148; dateOfBirth=1044316800000000000; nationality=47; shirtNumber=11; totalPoints=0; position=#Forward; lastName="Højlund"; firstName="Rasmus"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=399; status=#Active; clubId=14; valueQuarterMillions=26; dateOfBirth=1088640000000000000; nationality=7; shirtNumber=17; totalPoints=15; position=#Forward; lastName="Garnacho"; firstName="Alejandro"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=400; status=#Active; clubId=14; valueQuarterMillions=160; dateOfBirth=951350400000000000; nationality=24; shirtNumber=21; totalPoints=0; position=#Forward; lastName="Antony"; firstName=""; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=401; status=#Active; clubId=15; valueQuarterMillions=26; dateOfBirth=600825600000000000; nationality=158; shirtNumber=1; totalPoints=0; position=#Goalkeeper; lastName="Dúbravka"; firstName="Martin"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=402; status=#Active; clubId=15; valueQuarterMillions=22; dateOfBirth=701654400000000000; nationality=186; shirtNumber=29; totalPoints=0; position=#Goalkeeper; lastName="Gillespie"; firstName="Mark"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=404; status=#Active; clubId=15; valueQuarterMillions=80; dateOfBirth=703641600000000000; nationality=186; shirtNumber=22; totalPoints=20; position=#Goalkeeper; lastName="Pope"; firstName="Nick"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=405; status=#Active; clubId=15; valueQuarterMillions=42; dateOfBirth=947635200000000000; nationality=125; shirtNumber=4; totalPoints=0; position=#Defender; lastName="Botman"; firstName="Sven"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=406; status=#Active; clubId=15; valueQuarterMillions=42; dateOfBirth=705369600000000000; nationality=186; shirtNumber=33; totalPoints=10; position=#Defender; lastName="Burn"; firstName="Dan"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=408; status=#Active; clubId=15; valueQuarterMillions=34; dateOfBirth=1094601600000000000; nationality=186; shirtNumber=67; totalPoints=10; position=#Defender; lastName="Hall"; firstName="Lewis"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=409; status=#Active; clubId=15; valueQuarterMillions=34; dateOfBirth=775785600000000000; nationality=168; shirtNumber=17; totalPoints=15; position=#Defender; lastName="Krafth"; firstName="Emil"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=410; status=#Active; clubId=15; valueQuarterMillions=34; dateOfBirth=752976000000000000; nationality=186; shirtNumber=6; totalPoints=0; position=#Defender; lastName="Lascelles"; firstName="Jamaal"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=411; status=#Active; clubId=15; valueQuarterMillions=42; dateOfBirth=1037059200000000000; nationality=186; shirtNumber=21; totalPoints=15; position=#Defender; lastName="Livramento"; firstName="Tino"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=413; status=#Active; clubId=15; valueQuarterMillions=68; dateOfBirth=693187200000000000; nationality=169; shirtNumber=5; totalPoints=-5; position=#Defender; lastName="Schär"; firstName="Fabian"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=414; status=#Active; clubId=15; valueQuarterMillions=50; dateOfBirth=811382400000000000; nationality=186; shirtNumber=13; totalPoints=0; position=#Defender; lastName="Targett"; firstName="Matt"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=415; status=#Active; clubId=15; valueQuarterMillions=106; dateOfBirth=653702400000000000; nationality=186; shirtNumber=2; totalPoints=0; position=#Defender; lastName="Trippier"; firstName="Kieran"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=416; status=#Active; clubId=15; valueQuarterMillions=106; dateOfBirth=839980800000000000; nationality=24; shirtNumber=7; totalPoints=20; position=#Midfielder; lastName="Joelinton"; firstName=""; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=417; status=#Active; clubId=15; valueQuarterMillions=80; dateOfBirth=760838400000000000; nationality=137; shirtNumber=24; totalPoints=0; position=#Midfielder; lastName="Almirón"; firstName="Miguel"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=418; status=#Active; clubId=16; valueQuarterMillions=34; dateOfBirth=1036540800000000000; nationality=186; shirtNumber=32; totalPoints=5; position=#Midfielder; lastName="Anderson"; firstName="Elliot"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=419; status=#Active; clubId=15; valueQuarterMillions=84; dateOfBirth=879638400000000000; nationality=24; shirtNumber=39; totalPoints=5; position=#Midfielder; lastName="Guimarães"; firstName="Bruno"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=420; status=#Active; clubId=15; valueQuarterMillions=34; dateOfBirth=878169600000000000; nationality=186; shirtNumber=36; totalPoints=5; position=#Midfielder; lastName="Longstaff"; firstName="Sean"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=421; status=#Active; clubId=15; valueQuarterMillions=42; dateOfBirth=1146441600000000000; nationality=186; shirtNumber=67; totalPoints=0; position=#Midfielder; lastName="Miley"; firstName="Lewis"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=422; status=#Active; clubId=15; valueQuarterMillions=30; dateOfBirth=793584000000000000; nationality=186; shirtNumber=23; totalPoints=5; position=#Midfielder; lastName="Murphy"; firstName="Jacob"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=424; status=#Active; clubId=15; valueQuarterMillions=84; dateOfBirth=957744000000000000; nationality=83; shirtNumber=8; totalPoints=0; position=#Midfielder; lastName="Tonali"; firstName="Sandro"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=425; status=#Active; clubId=15; valueQuarterMillions=126; dateOfBirth=881625600000000000; nationality=186; shirtNumber=15; totalPoints=5; position=#Forward; lastName="Barnes"; firstName="Harvey"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=426; status=#Active; clubId=15; valueQuarterMillions=68; dateOfBirth=982972800000000000; nationality=186; shirtNumber=8; totalPoints=5; position=#Forward; lastName="Gordon"; firstName="Anthony"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=427; status=#Active; clubId=15; valueQuarterMillions=148; dateOfBirth=937872000000000000; nationality=168; shirtNumber=14; totalPoints=15; position=#Forward; lastName="Isak"; firstName="Alexander"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=428; status=#Active; clubId=15; valueQuarterMillions=160; dateOfBirth=699148800000000000; nationality=186; shirtNumber=9; totalPoints=0; position=#Forward; lastName="Wilson"; firstName="Callum"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=429; status=#Active; clubId=16; valueQuarterMillions=18; dateOfBirth=772416000000000000; nationality=187; shirtNumber=1; totalPoints=0; position=#Goalkeeper; lastName="Turner"; firstName="Matt"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=431; status=#Active; clubId=15; valueQuarterMillions=42; dateOfBirth=767318400000000000; nationality=65; shirtNumber=23; totalPoints=0; position=#Goalkeeper; lastName="Vlachodimos"; firstName="Odysseas"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=432; status=#Active; clubId=16; valueQuarterMillions=42; dateOfBirth=699062400000000000; nationality=17; shirtNumber=26; totalPoints=10; position=#Goalkeeper; lastName="Sels"; firstName="Matz"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=434; status=#Active; clubId=16; valueQuarterMillions=30; dateOfBirth=852854400000000000; nationality=186; shirtNumber=4; totalPoints=0; position=#Defender; lastName="Worrall"; firstName="Joe"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=435; status=#Active; clubId=16; valueQuarterMillions=14; dateOfBirth=987120000000000000; nationality=186; shirtNumber=7; totalPoints=0; position=#Defender; lastName="Williams"; firstName="Neco"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=436; status=#Active; clubId=16; valueQuarterMillions=34; dateOfBirth=808790400000000000; nationality=186; shirtNumber=15; totalPoints=5; position=#Defender; lastName="Toffolo"; firstName="Harry"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=440; status=#Active; clubId=16; valueQuarterMillions=26; dateOfBirth=665539200000000000; nationality=42; shirtNumber=30; totalPoints=5; position=#Defender; lastName="Boly"; firstName="Willy"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=441; status=#Active; clubId=16; valueQuarterMillions=42; dateOfBirth=1024790400000000000; nationality=81; shirtNumber=32; totalPoints=0; position=#Defender; lastName="Omobamidele"; firstName="Andrew"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=442; status=#Active; clubId=16; valueQuarterMillions=42; dateOfBirth=1025740800000000000; nationality=24; shirtNumber=40; totalPoints=5; position=#Defender; lastName="Murillo"; firstName=""; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=443; status=#Active; clubId=16; valueQuarterMillions=42; dateOfBirth=844732800000000000; nationality=125; shirtNumber=43; totalPoints=5; position=#Defender; lastName="Aina"; firstName="Ola"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=444; status=#Active; clubId=16; valueQuarterMillions=64; dateOfBirth=881020800000000000; nationality=42; shirtNumber=6; totalPoints=5; position=#Midfielder; lastName="Sangaré"; firstName="Ibrahim"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=446; status=#Active; clubId=16; valueQuarterMillions=84; dateOfBirth=948931200000000000; nationality=186; shirtNumber=10; totalPoints=5; position=#Midfielder; lastName="Gibbs-White"; firstName="Morgan"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=447; status=#Active; clubId=16; valueQuarterMillions=64; dateOfBirth=898992000000000000; nationality=7; shirtNumber=16; totalPoints=5; position=#Midfielder; lastName="Domínguez"; firstName="Nicolás"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=449; status=#Active; clubId=16; valueQuarterMillions=64; dateOfBirth=880070400000000000; nationality=186; shirtNumber=22; totalPoints=15; position=#Midfielder; lastName="Yates"; firstName="Ryan"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=450; status=#Active; clubId=16; valueQuarterMillions=42; dateOfBirth=679536000000000000; nationality=24; shirtNumber=28; totalPoints=5; position=#Midfielder; lastName="Danilo"; firstName=""; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=451; status=#Active; clubId=16; valueQuarterMillions=88; dateOfBirth=871344000000000000; nationality=129; shirtNumber=9; totalPoints=5; position=#Forward; lastName="Awoniyi"; firstName="Taiwo"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=452; status=#Active; clubId=16; valueQuarterMillions=64; dateOfBirth=692064000000000000; nationality=126; shirtNumber=11; totalPoints=15; position=#Forward; lastName="Wood"; firstName="Chris"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=453; status=#Active; clubId=16; valueQuarterMillions=42; dateOfBirth=973555200000000000; nationality=186; shirtNumber=0; totalPoints=5; position=#Forward; lastName="Hudson-Odoi"; firstName="Callum"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=454; status=#Active; clubId=16; valueQuarterMillions=64; dateOfBirth=1019865600000000000; nationality=168; shirtNumber=21; totalPoints=5; position=#Forward; lastName="Elanga"; firstName="Anthony"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=470; status=#Active; clubId=9; valueQuarterMillions=30; dateOfBirth=845942400000000000; nationality=186; shirtNumber=4; totalPoints=-10; position=#Defender; lastName="Holgate"; firstName="Mason"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=478; status=#Active; clubId=13; valueQuarterMillions=42; dateOfBirth=1034899200000000000; nationality=186; shirtNumber=87; totalPoints=0; position=#Midfielder; lastName="Mcatee"; firstName="James"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=482; status=#Active; clubId=23; valueQuarterMillions=42; dateOfBirth=1007856000000000000; nationality=186; shirtNumber=35; totalPoints=5; position=#Forward; lastName="Archer"; firstName="Cameron"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=483; status=#Active; clubId=15; valueQuarterMillions=64; dateOfBirth=1059955200000000000; nationality=47; shirtNumber=32; totalPoints=0; position=#Forward; lastName="Osula"; firstName="William"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=485; status=#Active; clubId=18; valueQuarterMillions=64; dateOfBirth=844646400000000000; nationality=83; shirtNumber=13; totalPoints=0; position=#Goalkeeper; lastName="Vicario"; firstName="Guglielmo"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=486; status=#Active; clubId=18; valueQuarterMillions=18; dateOfBirth=574560000000000000; nationality=186; shirtNumber=20; totalPoints=0; position=#Goalkeeper; lastName="Forster"; firstName="Fraser"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=487; status=#Active; clubId=18; valueQuarterMillions=18; dateOfBirth=915753600000000000; nationality=186; shirtNumber=40; totalPoints=0; position=#Goalkeeper; lastName="Austin"; firstName="Brandon"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=488; status=#Active; clubId=18; valueQuarterMillions=22; dateOfBirth=907286400000000000; nationality=186; shirtNumber=41; totalPoints=0; position=#Goalkeeper; lastName="Whiteman"; firstName="Alfie"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=489; status=#Active; clubId=18; valueQuarterMillions=56; dateOfBirth=916272000000000000; nationality=24; shirtNumber=12; totalPoints=0; position=#Defender; lastName="Royal"; firstName="Emerson"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=490; status=#Active; clubId=18; valueQuarterMillions=56; dateOfBirth=937180800000000000; nationality=164; shirtNumber=23; totalPoints=0; position=#Defender; lastName="Porro"; firstName="Pedro"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=491; status=#Active; clubId=18; valueQuarterMillions=42; dateOfBirth=893635200000000000; nationality=7; shirtNumber=17; totalPoints=0; position=#Defender; lastName="Romero"; firstName="Cristian "; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=492; status=#Active; clubId=18; valueQuarterMillions=50; dateOfBirth=735609600000000000; nationality=186; shirtNumber=33; totalPoints=0; position=#Defender; lastName="Davies"; firstName="Ben"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=493; status=#Active; clubId=18; valueQuarterMillions=42; dateOfBirth=987638400000000000; nationality=125; shirtNumber=37; totalPoints=0; position=#Defender; lastName="van de Ven"; firstName="Micky"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, {id=494; status=#Active; clubId=18; valueQuarterMillions=42; dateOfBirth=1038441600000000000; nationality=83; shirtNumber=38; totalPoints=0; position=#Defender; lastName="Udogie"; firstName="Destiny"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=495; status=#Active; clubId=18; valueQuarterMillions=34; dateOfBirth=969062400000000000; nationality=186; shirtNumber=4; totalPoints=0; position=#Midfielder; lastName="Skipp"; firstName="Oliver"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=496; status=#Active; clubId=18; valueQuarterMillions=38; dateOfBirth=1012694400000000000; nationality=143; shirtNumber=6; totalPoints=0; position=#Defender; lastName="Drăgușin"; firstName="Radu"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=498; status=#Active; clubId=18; valueQuarterMillions=336; dateOfBirth=710553600000000000; nationality=91; shirtNumber=7; totalPoints=0; position=#Forward; lastName="Son"; firstName="Heung-min"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=499; status=#Active; clubId=18; valueQuarterMillions=50; dateOfBirth=841363200000000000; nationality=108; shirtNumber=38; totalPoints=0; position=#Midfielder; lastName="Bissouma"; firstName="Yves"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=500; status=#Active; clubId=18; valueQuarterMillions=64; dateOfBirth=981849600000000000; nationality=164; shirtNumber=11; totalPoints=0; position=#Midfielder; lastName="Gil"; firstName="Bryan"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=501; status=#Active; clubId=18; valueQuarterMillions=168; dateOfBirth=848707200000000000; nationality=186; shirtNumber=10; totalPoints=0; position=#Midfielder; lastName="Maddison"; firstName="James"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=502; status=#Active; clubId=18; valueQuarterMillions=64; dateOfBirth=829008000000000000; nationality=7; shirtNumber=18; totalPoints=0; position=#Midfielder; lastName="Lo Celso"; firstName="Giovani"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=503; status=#Active; clubId=10; valueQuarterMillions=38; dateOfBirth=958608000000000000; nationality=186; shirtNumber=0; totalPoints=0; position=#Defender; lastName="Sessegnon"; firstName="Ryan"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=504; status=#Active; clubId=18; valueQuarterMillions=182; dateOfBirth=956620800000000000; nationality=168; shirtNumber=21; totalPoints=0; position=#Midfielder; lastName="Kulusevski"; firstName="Dejan"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=505; status=#Active; clubId=18; valueQuarterMillions=84; dateOfBirth=990576000000000000; nationality=186; shirtNumber=20; totalPoints=0; position=#Forward; lastName="Johnson"; firstName="Brennan"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=506; status=#Active; clubId=18; valueQuarterMillions=60; dateOfBirth=932774400000000000; nationality=82; shirtNumber=0; totalPoints=0; position=#Midfielder; lastName="Solomon"; firstName="Manor"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=507; status=#Active; clubId=18; valueQuarterMillions=30; dateOfBirth=1031961600000000000; nationality=153; shirtNumber=29; totalPoints=0; position=#Midfielder; lastName="Matar Sarr"; firstName="Pape"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=508; status=#Active; clubId=18; valueQuarterMillions=76; dateOfBirth=867196800000000000; nationality=188; shirtNumber=30; totalPoints=0; position=#Midfielder; lastName="Bentancur"; firstName="Rodrigo"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=509; status=#Active; clubId=18; valueQuarterMillions=206; dateOfBirth=868492800000000000; nationality=24; shirtNumber=9; totalPoints=0; position=#Forward; lastName="Richarlison"; firstName=""; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=510; status=#Active; clubId=18; valueQuarterMillions=126; dateOfBirth=826070400000000000; nationality=65; shirtNumber=16; totalPoints=0; position=#Forward; lastName="Werner"; firstName="Timo"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=511; status=#Active; clubId=18; valueQuarterMillions=42; dateOfBirth=1104710400000000000; nationality=186; shirtNumber=63; totalPoints=0; position=#Forward; lastName="Donley"; firstName="Jamie"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=512; status=#Active; clubId=19; valueQuarterMillions=60; dateOfBirth=482630400000000000; nationality=140; shirtNumber=1; totalPoints=0; position=#Goalkeeper; lastName="Fabianski"; firstName="Lukasz"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=513; status=#Active; clubId=19; valueQuarterMillions=34; dateOfBirth=730771200000000000; nationality=61; shirtNumber=23; totalPoints=-10; position=#Goalkeeper; lastName="Areola"; firstName="Alphonse"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=515; status=#Active; clubId=22; valueQuarterMillions=38; dateOfBirth=948672000000000000; nationality=186; shirtNumber=2; totalPoints=-10; position=#Defender; lastName="Johnson"; firstName="Ben"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=516; status=#Active; clubId=19; valueQuarterMillions=50; dateOfBirth=629683200000000000; nationality=186; shirtNumber=3; totalPoints=0; position=#Defender; lastName="Cresswell"; firstName="Aaron"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=517; status=#Active; clubId=19; valueQuarterMillions=38; dateOfBirth=783216000000000000; nationality=61; shirtNumber=4; totalPoints=0; position=#Defender; lastName="Zouma"; firstName="Kurt"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=518; status=#Active; clubId=19; valueQuarterMillions=22; dateOfBirth=714441600000000000; nationality=46; shirtNumber=5; totalPoints=-10; position=#Defender; lastName="Coufal"; firstName="Vladimir"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=519; status=#Active; clubId=19; valueQuarterMillions=42; dateOfBirth=881798400000000000; nationality=67; shirtNumber=15; totalPoints=-10; position=#Defender; lastName="Mavropanos"; firstName="Konstantinos"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=522; status=#Active; clubId=19; valueQuarterMillions=56; dateOfBirth=828144000000000000; nationality=119; shirtNumber=27; totalPoints=0; position=#Defender; lastName="Aguerd"; firstName="Nayef"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=523; status=#Active; clubId=19; valueQuarterMillions=22; dateOfBirth=775872000000000000; nationality=83; shirtNumber=33; totalPoints=-10; position=#Defender; lastName="Emerson"; firstName=""; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=524; status=#Active; clubId=19; valueQuarterMillions=106; dateOfBirth=783648000000000000; nationality=186; shirtNumber=7; totalPoints=5; position=#Midfielder; lastName="Ward-Prowse"; firstName="James"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=525; status=#Active; clubId=19; valueQuarterMillions=102; dateOfBirth=872640000000000000; nationality=24; shirtNumber=11; totalPoints=15; position=#Midfielder; lastName="Paquetá"; firstName="Lucas"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=526; status=#Active; clubId=19; valueQuarterMillions=14; dateOfBirth=817862400000000000; nationality=186; shirtNumber=4; totalPoints=0; position=#Midfielder; lastName="Phillips"; firstName="Kalvin"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=527; status=#Active; clubId=19; valueQuarterMillions=126; dateOfBirth=965174400000000000; nationality=66; shirtNumber=14; totalPoints=5; position=#Midfielder; lastName="Kudus"; firstName="Mohammed"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=528; status=#Active; clubId=19; valueQuarterMillions=102; dateOfBirth=835833600000000000; nationality=42; shirtNumber=14; totalPoints=0; position=#Midfielder; lastName="Cornet"; firstName="Maxwel"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=529; status=#Active; clubId=19; valueQuarterMillions=64; dateOfBirth=877651200000000000; nationality=113; shirtNumber=19; totalPoints=0; position=#Midfielder; lastName="Álvarez"; firstName="Edson"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=530; status=#Active; clubId=19; valueQuarterMillions=64; dateOfBirth=793843200000000000; nationality=46; shirtNumber=28; totalPoints=15; position=#Midfielder; lastName="Soucek"; firstName="Tomas"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=531; status=#Active; clubId=19; valueQuarterMillions=144; dateOfBirth=638582400000000000; nationality=84; shirtNumber=9; totalPoints=5; position=#Forward; lastName="Antonio"; firstName="Michail"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=532; status=#Active; clubId=19; valueQuarterMillions=118; dateOfBirth=711849600000000000; nationality=186; shirtNumber=18; totalPoints=5; position=#Forward; lastName="Ings"; firstName="Danny"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=533; status=#Active; clubId=19; valueQuarterMillions=190; dateOfBirth=851040000000000000; nationality=186; shirtNumber=20; totalPoints=5; position=#Forward; lastName="Bowen"; firstName="Jarrod"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=535; status=#Active; clubId=19; valueQuarterMillions=42; dateOfBirth=1098662400000000000; nationality=186; shirtNumber=45; totalPoints=0; position=#Forward; lastName="Mubama"; firstName="Divin"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=536; status=#Active; clubId=20; valueQuarterMillions=64; dateOfBirth=727228800000000000; nationality=141; shirtNumber=1; totalPoints=-5; position=#Goalkeeper; lastName="Sá"; firstName="José"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=537; status=#Active; clubId=20; valueQuarterMillions=22; dateOfBirth=742521600000000000; nationality=186; shirtNumber=25; totalPoints=0; position=#Goalkeeper; lastName="Bentley"; firstName="Daniel"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=538; status=#Active; clubId=20; valueQuarterMillions=22; dateOfBirth=794620800000000000; nationality=186; shirtNumber=40; totalPoints=0; position=#Goalkeeper; lastName="King"; firstName="Tom"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=539; status=#Active; clubId=20; valueQuarterMillions=42; dateOfBirth=695520000000000000; nationality=81; shirtNumber=2; totalPoints=-10; position=#Defender; lastName="Doherty"; firstName="Matt"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=540; status=#Active; clubId=20; valueQuarterMillions=26; dateOfBirth=991785600000000000; nationality=3; shirtNumber=3; totalPoints=-10; position=#Defender; lastName="Aït-Nouri"; firstName="Rayan"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=541; status=#Active; clubId=20; valueQuarterMillions=38; dateOfBirth=910569600000000000; nationality=188; shirtNumber=4; totalPoints=0; position=#Defender; lastName="Bueno"; firstName="Santiago"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=542; status=#Active; clubId=20; valueQuarterMillions=56; dateOfBirth=641952000000000000; nationality=186; shirtNumber=15; totalPoints=-10; position=#Defender; lastName="Dawson"; firstName="Craig"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=543; status=#Active; clubId=20; valueQuarterMillions=42; dateOfBirth=1032307200000000000; nationality=164; shirtNumber=17; totalPoints=0; position=#Defender; lastName="Bueno"; firstName="Hugo"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=544; status=#Active; clubId=20; valueQuarterMillions=64; dateOfBirth=753408000000000000; nationality=141; shirtNumber=22; totalPoints=0; position=#Defender; lastName="Semedo"; firstName="Nélson"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=545; status=#Active; clubId=20; valueQuarterMillions=34; dateOfBirth=864345600000000000; nationality=186; shirtNumber=23; totalPoints=0; position=#Defender; lastName="Kilman"; firstName="Max"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=546; status=#Active; clubId=20; valueQuarterMillions=18; dateOfBirth=916444800000000000; nationality=141; shirtNumber=24; totalPoints=-15; position=#Defender; lastName="Toti"; firstName=""; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=547; status=#Active; clubId=20; valueQuarterMillions=42; dateOfBirth=746841600000000000; nationality=62; shirtNumber=5; totalPoints=5; position=#Midfielder; lastName="Lemina"; firstName="Mario"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=548; status=#Active; clubId=20; valueQuarterMillions=34; dateOfBirth=998265600000000000; nationality=108; shirtNumber=6; totalPoints=0; position=#Midfielder; lastName="Traoré"; firstName="Boubacar"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=549; status=#Active; clubId=20; valueQuarterMillions=42; dateOfBirth=981936000000000000; nationality=24; shirtNumber=35; totalPoints=0; position=#Midfielder; lastName="Gomes"; firstName="João"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=550; status=#Active; clubId=20; valueQuarterMillions=38; dateOfBirth=1003276800000000000; nationality=186; shirtNumber=20; totalPoints=0; position=#Midfielder; lastName="Doyle"; firstName="Tommy"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=551; status=#Active; clubId=20; valueQuarterMillions=64; dateOfBirth=898905600000000000; nationality=61; shirtNumber=27; totalPoints=5; position=#Midfielder; lastName="Bellegarde"; firstName="Jean-Ricner"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=552; status=#Active; clubId=20; valueQuarterMillions=34; dateOfBirth=1031961600000000000; nationality=81; shirtNumber=59; totalPoints=0; position=#Midfielder; lastName="Hodge"; firstName="Joe"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=553; status=#Active; clubId=7; valueQuarterMillions=60; dateOfBirth=952560000000000000; nationality=141; shirtNumber=7; totalPoints=5; position=#Midfielder; lastName="Neto"; firstName="Pedro"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=554; status=#Active; clubId=20; valueQuarterMillions=92; dateOfBirth=822614400000000000; nationality=91; shirtNumber=11; totalPoints=5; position=#Forward; lastName="Hwang"; firstName="Hee-chan"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=555; status=#Active; clubId=20; valueQuarterMillions=76; dateOfBirth=927763200000000000; nationality=24; shirtNumber=12; totalPoints=5; position=#Forward; lastName="Cunha"; firstName="Matheus"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}, 
            {id=557; status=#Active; clubId=20; valueQuarterMillions=60; dateOfBirth=705542400000000000; nationality=164; shirtNumber=21; totalPoints=5; position=#Forward; lastName="Sarabia"; firstName="Pablo"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=558; status=#Active; clubId=20; valueQuarterMillions=64; dateOfBirth=1106179200000000000; nationality=137; shirtNumber=30; totalPoints=0; position=#Forward; lastName="González"; firstName="Enso"; currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=559; status=#Active; clubId=20; valueQuarterMillions=42; dateOfBirth=1109030400000000000; nationality=186; shirtNumber=63; totalPoints=0; position=#Forward; lastName="Fraser"; firstName="Nathan";  currentLoanEndDate=0; gender=#Male; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()}
          ]
        ),
        (2,
          [
            {id=1; status=#Active; clubId=1; valueQuarterMillions=41; dateOfBirth=814060800000000000; nationality=10; shirtNumber=1; totalPoints=0; position=#Goalkeeper; lastName="Manuela"; firstName="Zinsberger"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=2; status=#Active; clubId=1; valueQuarterMillions=30; dateOfBirth=952300800000000000; nationality=125; shirtNumber=14; totalPoints=0; position=#Goalkeeper; lastName="Daphne"; firstName="Van Domselaar"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=3; status=#Active; clubId=1; valueQuarterMillions=34; dateOfBirth=1098576000000000000; nationality=186; shirtNumber=40; totalPoints=0; position=#Goalkeeper; lastName="Naomi "; firstName="Williams"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=4; status=#Active; clubId=1; valueQuarterMillions=65; dateOfBirth=897004800000000000; nationality=187; shirtNumber=2; totalPoints=0; position=#Defender; lastName="Emily"; firstName="Fox"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=5; status=#Active; clubId=1; valueQuarterMillions=65; dateOfBirth=916012800000000000; nationality=186; shirtNumber=3; totalPoints=0; position=#Defender; lastName="Lotte"; firstName="Wubben-Moy"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=6; status=#Active; clubId=1; valueQuarterMillions=61; dateOfBirth=948499200000000000; nationality=164; shirtNumber=5; totalPoints=0; position=#Defender; lastName="Laia "; firstName="Codina"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=7; status=#Active; clubId=1; valueQuarterMillions=79; dateOfBirth=859593600000000000; nationality=186; shirtNumber=6; totalPoints=0; position=#Defender; lastName="Leah"; firstName="Williamson"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=8; status=#Active; clubId=1; valueQuarterMillions=87; dateOfBirth=759542400000000000; nationality=9; shirtNumber=7; totalPoints=0; position=#Defender; lastName="Steph"; firstName="Catley"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=9; status=#Active; clubId=1; valueQuarterMillions=84; dateOfBirth=811641600000000000; nationality=81; shirtNumber=11; totalPoints=0; position=#Defender; lastName="Katie"; firstName="Mccabe"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=10; status=#Active; clubId=1; valueQuarterMillions=58; dateOfBirth=916185600000000000; nationality=10; shirtNumber=26; totalPoints=0; position=#Defender; lastName="Laura"; firstName="Wienroither"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=11; status=#Active; clubId=1; valueQuarterMillions=85; dateOfBirth=790300800000000000; nationality=168; shirtNumber=28; totalPoints=0; position=#Defender; lastName="Amanda"; firstName="Ilestedt"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=12; status=#Active; clubId=1; valueQuarterMillions=40; dateOfBirth=1140652800000000000; nationality=186; shirtNumber=62; totalPoints=0; position=#Defender; lastName="Katie"; firstName="Reid"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=13; status=#Active; clubId=1; valueQuarterMillions=162; dateOfBirth=827193600000000000; nationality=164; shirtNumber=8; totalPoints=0; position=#Midfielder; lastName="Mariona"; firstName="Caldentey"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=14; status=#Active; clubId=1; valueQuarterMillions=213; dateOfBirth=646617600000000000; nationality=197; shirtNumber=10; totalPoints=0; position=#Midfielder; lastName="Kim"; firstName="Little"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=15; status=#Active; clubId=1; valueQuarterMillions=131; dateOfBirth=932083200000000000; nationality=131; shirtNumber=12; totalPoints=0; position=#Midfielder; lastName="Frida"; firstName="Maanum"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=16; status=#Active; clubId=1; valueQuarterMillions=181; dateOfBirth=735177600000000000; nationality=169; shirtNumber=13; totalPoints=0; position=#Midfielder; lastName="Lia"; firstName="Wälti"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=17; status=#Active; clubId=1; valueQuarterMillions=125; dateOfBirth=928368000000000000; nationality=125; shirtNumber=21; totalPoints=0; position=#Midfielder; lastName="Victoria"; firstName="Pelova"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=18; status=#Active; clubId=1; valueQuarterMillions=115; dateOfBirth=1057363200000000000; nationality=47; shirtNumber=22; totalPoints=0; position=#Midfielder; lastName="Kathrine"; firstName="Kühl"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=19; status=#Active; clubId=1; valueQuarterMillions=120; dateOfBirth=1013731200000000000; nationality=9; shirtNumber=32; totalPoints=0; position=#Midfielder; lastName="Kyra"; firstName="Cooney-Cross"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=20; status=#Active; clubId=1; valueQuarterMillions=80; dateOfBirth=1167782400000000000; nationality=186; shirtNumber=60; totalPoints=0; position=#Midfielder; lastName="Laila"; firstName="Harbert"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=21; status=#Active; clubId=1; valueQuarterMillions=352; dateOfBirth=799977600000000000; nationality=186; shirtNumber=9; totalPoints=0; position=#Forward; lastName="Beth"; firstName="Mead"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=22; status=#Active; clubId=1; valueQuarterMillions=256; dateOfBirth=1057363200000000000; nationality=168; shirtNumber=16; totalPoints=0; position=#Forward; lastName="Rosa"; firstName="Kafaji"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=23; status=#Active; clubId=1; valueQuarterMillions=308; dateOfBirth=810259200000000000; nationality=168; shirtNumber=17; totalPoints=0; position=#Forward; lastName="Lina"; firstName="Hurtig"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=24; status=#Active; clubId=1; valueQuarterMillions=347; dateOfBirth=784512000000000000; nationality=9; shirtNumber=19; totalPoints=0; position=#Forward; lastName="Caitlin"; firstName="Foord"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=25; status=#Active; clubId=1; valueQuarterMillions=272; dateOfBirth=918432000000000000; nationality=186; shirtNumber=23; totalPoints=0; position=#Forward; lastName="Alessia"; firstName="Russo"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=26; status=#Active; clubId=1; valueQuarterMillions=319; dateOfBirth=823478400000000000; nationality=168; shirtNumber=25; totalPoints=0; position=#Forward; lastName="Stina"; firstName="Blackstenius"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=27; status=#Active; clubId=1; valueQuarterMillions=296; dateOfBirth=810259200000000000; nationality=186; shirtNumber=53; totalPoints=0; position=#Forward; lastName="Vivienne"; firstName="Lia"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=28; status=#Active; clubId=1; valueQuarterMillions=189; dateOfBirth=1115424000000000000; nationality=186; shirtNumber=56; totalPoints=0; position=#Forward; lastName="Freya"; firstName="Godfrey"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=29; status=#Active; clubId=2; valueQuarterMillions=39; dateOfBirth=737078400000000000; nationality=32; shirtNumber=1; totalPoints=0; position=#Goalkeeper; lastName="Sabrina"; firstName="D'Angelo"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=30; status=#Active; clubId=2; valueQuarterMillions=29; dateOfBirth=993513600000000000; nationality=126; shirtNumber=21; totalPoints=0; position=#Goalkeeper; lastName="Anna"; firstName="Leat"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=31; status=#Active; clubId=2; valueQuarterMillions=20; dateOfBirth=1151193600000000000; nationality=186; shirtNumber=35; totalPoints=0; position=#Goalkeeper; lastName="Sophia"; firstName="Poor"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=32; status=#Active; clubId=2; valueQuarterMillions=74; dateOfBirth=858816000000000000; nationality=186; shirtNumber=2; totalPoints=0; position=#Defender; lastName="Sarah"; firstName="Mayling"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=33; status=#Active; clubId=2; valueQuarterMillions=63; dateOfBirth=1000166400000000000; nationality=164; shirtNumber=3; totalPoints=0; position=#Defender; lastName="Paula"; firstName="Tomás"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=34; status=#Active; clubId=2; valueQuarterMillions=59; dateOfBirth=924566400000000000; nationality=81; shirtNumber=4; totalPoints=0; position=#Defender; lastName="Anna "; firstName="Patten"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=35; status=#Active; clubId=2; valueQuarterMillions=99; dateOfBirth=619315200000000000; nationality=197; shirtNumber=6; totalPoints=0; position=#Defender; lastName="Rachel"; firstName="Corsie"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=36; status=#Active; clubId=2; valueQuarterMillions=89; dateOfBirth=684460800000000000; nationality=186; shirtNumber=14; totalPoints=0; position=#Defender; lastName="Danielle"; firstName="Turner"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=37; status=#Active; clubId=2; valueQuarterMillions=58; dateOfBirth=911347200000000000; nationality=186; shirtNumber=15; totalPoints=0; position=#Defender; lastName="Lucy"; firstName="Parker"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=38; status=#Active; clubId=2; valueQuarterMillions=77; dateOfBirth=819676800000000000; nationality=169; shirtNumber=16; totalPoints=0; position=#Defender; lastName="Noelle"; firstName="Maritz"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=39; status=#Active; clubId=2; valueQuarterMillions=65; dateOfBirth=904003200000000000; nationality=186; shirtNumber=33; totalPoints=0; position=#Defender; lastName="Mayumi"; firstName="Pacheco"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=40; status=#Active; clubId=2; valueQuarterMillions=163; dateOfBirth=717984000000000000; nationality=186; shirtNumber=5; totalPoints=0; position=#Midfielder; lastName="Lucy"; firstName="Staniforth"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=41; status=#Active; clubId=2; valueQuarterMillions=118; dateOfBirth=987206400000000000; nationality=186; shirtNumber=7; totalPoints=0; position=#Midfielder; lastName="Missy Bo"; firstName="Kearns"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=42; status=#Active; clubId=2; valueQuarterMillions=179; dateOfBirth=723772800000000000; nationality=186; shirtNumber=8; totalPoints=0; position=#Midfielder; lastName="Jordan"; firstName="Nobbs"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=43; status=#Active; clubId=2; valueQuarterMillions=193; dateOfBirth=678499200000000000; nationality=61; shirtNumber=10; totalPoints=0; position=#Midfielder; lastName="Kenza"; firstName="Dali"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=44; status=#Active; clubId=2; valueQuarterMillions=120; dateOfBirth=982886400000000000; nationality=125; shirtNumber=22; totalPoints=0; position=#Midfielder; lastName="Jill"; firstName="Baijings"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=45; status=#Active; clubId=2; valueQuarterMillions=104; dateOfBirth=949449600000000000; nationality=186; shirtNumber=25; totalPoints=0; position=#Midfielder; lastName="Miri"; firstName="Taylor"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=46; status=#Active; clubId=2; valueQuarterMillions=393; dateOfBirth=691977600000000000; nationality=186; shirtNumber=9; totalPoints=0; position=#Forward; lastName="Rachel"; firstName="Daly"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=47; status=#Active; clubId=2; valueQuarterMillions=237; dateOfBirth=1028764800000000000; nationality=186; shirtNumber=11; totalPoints=0; position=#Forward; lastName="Katie"; firstName="Robinson"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=48; status=#Active; clubId=2; valueQuarterMillions=250; dateOfBirth=980553600000000000; nationality=186; shirtNumber=17; totalPoints=0; position=#Forward; lastName="Ebony"; firstName="Salmon"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=49; status=#Active; clubId=2; valueQuarterMillions=198; dateOfBirth=1126828800000000000; nationality=186; shirtNumber=18; totalPoints=0; position=#Forward; lastName="Georgia"; firstName="Mullett"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=50; status=#Active; clubId=2; valueQuarterMillions=343; dateOfBirth=717984000000000000; nationality=32; shirtNumber=19; totalPoints=0; position=#Forward; lastName="Adriana"; firstName="Leon"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=51; status=#Active; clubId=2; valueQuarterMillions=250; dateOfBirth=892771200000000000; nationality=197; shirtNumber=20; totalPoints=0; position=#Forward; lastName="Kirsty"; firstName="Hanson"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=52; status=#Active; clubId=2; valueQuarterMillions=234; dateOfBirth=987638400000000000; nationality=125; shirtNumber=23; totalPoints=0; position=#Forward; lastName="Chasity"; firstName="Grant"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=53; status=#Active; clubId=2; valueQuarterMillions=269; dateOfBirth=857952000000000000; nationality=24; shirtNumber=28; totalPoints=0; position=#Forward; lastName="Gabi"; firstName="Nunes"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=54; status=#Active; clubId=3; valueQuarterMillions=28; dateOfBirth=1114473600000000000; nationality=186; shirtNumber=25; totalPoints=0; position=#Goalkeeper; lastName="Hannah"; firstName="Poulter"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=55; status=#Active; clubId=3; valueQuarterMillions=25; dateOfBirth=962409600000000000; nationality=168; shirtNumber=38; totalPoints=0; position=#Goalkeeper; lastName="Melina"; firstName="Loeck"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=56; status=#Active; clubId=3; valueQuarterMillions=31; dateOfBirth=849225600000000000; nationality=186; shirtNumber=32; totalPoints=0; position=#Goalkeeper; lastName="Sophie"; firstName="Baggaley"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=57; status=#Active; clubId=3; valueQuarterMillions=81; dateOfBirth=739238400000000000; nationality=131; shirtNumber=2; totalPoints=0; position=#Defender; lastName="Maria"; firstName="Thorisdóttir"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=58; status=#Active; clubId=3; valueQuarterMillions=58; dateOfBirth=957052800000000000; nationality=186; shirtNumber=3; totalPoints=0; position=#Defender; lastName="Poppy"; firstName="Pattinson"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=59; status=#Active; clubId=3; valueQuarterMillions=74; dateOfBirth=762652800000000000; nationality=131; shirtNumber=5; totalPoints=0; position=#Defender; lastName="Guro"; firstName="Bergsvand"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=60; status=#Active; clubId=3; valueQuarterMillions=66; dateOfBirth=863913600000000000; nationality=37; shirtNumber=16; totalPoints=0; position=#Defender; lastName="Jorelyn"; firstName="Carabalí"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=61; status=#Active; clubId=3; valueQuarterMillions=55; dateOfBirth=968457600000000000; nationality=125; shirtNumber=19; totalPoints=0; position=#Defender; lastName="Marisa"; firstName="Olislagers"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=62; status=#Active; clubId=3; valueQuarterMillions=60; dateOfBirth=1010707200000000000; nationality=125; shirtNumber=23; totalPoints=0; position=#Defender; lastName="Marit"; firstName="Auee"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=63; status=#Active; clubId=3; valueQuarterMillions=69; dateOfBirth=868233600000000000; nationality=197; shirtNumber=27; totalPoints=0; position=#Defender; lastName="Rachel"; firstName="Mclauchlan"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=64; status=#Active; clubId=3; valueQuarterMillions=184; dateOfBirth=668131200000000000; nationality=164; shirtNumber=6; totalPoints=0; position=#Midfielder; lastName="Vicky"; firstName="Losada"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=65; status=#Active; clubId=3; valueQuarterMillions=156; dateOfBirth=808272000000000000; nationality=154; shirtNumber=10; totalPoints=0; position=#Midfielder; lastName="Jelena"; firstName="Čanković"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=66; status=#Active; clubId=3; valueQuarterMillions=162; dateOfBirth=741312000000000000; nationality=186; shirtNumber=14; totalPoints=0; position=#Midfielder; lastName="Fran"; firstName="Kirby"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=67; status=#Active; clubId=3; valueQuarterMillions=120; dateOfBirth=941932800000000000; nationality=186; shirtNumber=17; totalPoints=0; position=#Midfielder; lastName="Bex"; firstName="Rayner"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=68; status=#Active; clubId=3; valueQuarterMillions=109; dateOfBirth=1044144000000000000; nationality=186; shirtNumber=18; totalPoints=0; position=#Midfielder; lastName="Maisie"; firstName="Symonds"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=69; status=#Active; clubId=3; valueQuarterMillions=118; dateOfBirth=1023148800000000000; nationality=164; shirtNumber=20; totalPoints=0; position=#Midfielder; lastName="Bruna"; firstName="Vilamala"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=70; status=#Active; clubId=3; valueQuarterMillions=129; dateOfBirth=868060800000000000; nationality=154; shirtNumber=22; totalPoints=0; position=#Midfielder; lastName="Dejana"; firstName="Stefanović"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=71; status=#Active; clubId=3; valueQuarterMillions=109; dateOfBirth=1045353600000000000; nationality=9; shirtNumber=33; totalPoints=0; position=#Midfielder; lastName="Charlie"; firstName="Rule"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=72; status=#Active; clubId=3; valueQuarterMillions=250; dateOfBirth=1068422400000000000; nationality=173; shirtNumber=7; totalPoints=0; position=#Forward; lastName="Aisha"; firstName="Masaka"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=73; status=#Active; clubId=3; valueQuarterMillions=301; dateOfBirth=829094400000000000; nationality=65; shirtNumber=8; totalPoints=0; position=#Forward; lastName="Pauline"; firstName="Bremer"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=74; status=#Active; clubId=3; valueQuarterMillions=344; dateOfBirth=763257600000000000; nationality=186; shirtNumber=9; totalPoints=0; position=#Forward; lastName="Nikita"; firstName="Parris"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=75; status=#Active; clubId=3; valueQuarterMillions=305; dateOfBirth=839462400000000000; nationality=85; shirtNumber=11; totalPoints=0; position=#Forward; lastName="Kiko"; firstName="Seike"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=76; status=#Active; clubId=3; valueQuarterMillions=237; dateOfBirth=909273600000000000; nationality=187; shirtNumber=21; totalPoints=0; position=#Forward; lastName="Madison"; firstName="Haley"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=77; status=#Active; clubId=3; valueQuarterMillions=160; dateOfBirth=1138924800000000000; nationality=186; shirtNumber=59; totalPoints=0; position=#Forward; lastName="Michelle"; firstName="Agyemang"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=78; status=#Active; clubId=4; valueQuarterMillions=38; dateOfBirth=833068800000000000; nationality=168; shirtNumber=1; totalPoints=0; position=#Goalkeeper; lastName="Zećira"; firstName="Mušović"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=79; status=#Active; clubId=4; valueQuarterMillions=31; dateOfBirth=974332800000000000; nationality=186; shirtNumber=24; totalPoints=0; position=#Goalkeeper; lastName="Hannah"; firstName="Hampton"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=80; status=#Active; clubId=4; valueQuarterMillions=20; dateOfBirth=1146182400000000000; nationality=186; shirtNumber=40; totalPoints=0; position=#Goalkeeper; lastName="Katie"; firstName="Cox"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=81; status=#Active; clubId=4; valueQuarterMillions=67; dateOfBirth=920937600000000000; nationality=125; shirtNumber=3; totalPoints=0; position=#Defender; lastName="Aniek"; firstName="Nouwen"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=82; status=#Active; clubId=4; valueQuarterMillions=91; dateOfBirth=745891200000000000; nationality=186; shirtNumber=4; totalPoints=0; position=#Defender; lastName="Millie"; firstName="Bright"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=83; status=#Active; clubId=4; valueQuarterMillions=85; dateOfBirth=802828800000000000; nationality=32; shirtNumber=12; totalPoints=0; position=#Defender; lastName="Ashley"; firstName="Lawrence"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=84; status=#Active; clubId=4; valueQuarterMillions=80; dateOfBirth=862704000000000000; nationality=168; shirtNumber=14; totalPoints=0; position=#Defender; lastName="Nathalie"; firstName="Björn"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=85; status=#Active; clubId=4; valueQuarterMillions=83; dateOfBirth=788227200000000000; nationality=61; shirtNumber=15; totalPoints=0; position=#Defender; lastName="Ève"; firstName="Périsset"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=86; status=#Active; clubId=4; valueQuarterMillions=65; dateOfBirth=929923200000000000; nationality=186; shirtNumber=21; totalPoints=0; position=#Defender; lastName="Niahm"; firstName="Charles"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=87; status=#Active; clubId=4; valueQuarterMillions=99; dateOfBirth=688608000000000000; nationality=186; shirtNumber=22; totalPoints=0; position=#Defender; lastName="Lucy"; firstName="Bronze"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=88; status=#Active; clubId=4; valueQuarterMillions=61; dateOfBirth=1045958400000000000; nationality=61; shirtNumber=25; totalPoints=0; position=#Defender; lastName="Maelys"; firstName="Mpomé"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=89; status=#Active; clubId=4; valueQuarterMillions=82; dateOfBirth=815529600000000000; nationality=32; shirtNumber=26; totalPoints=0; position=#Defender; lastName="Kadeisha"; firstName="Buchanan"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=90; status=#Active; clubId=4; valueQuarterMillions=62; dateOfBirth=1005523200000000000; nationality=164; shirtNumber=29; totalPoints=0; position=#Defender; lastName="Alejandra"; firstName="Bernabé"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=91; status=#Active; clubId=4; valueQuarterMillions=187; dateOfBirth=683769600000000000; nationality=198; shirtNumber=5; totalPoints=0; position=#Midfielder; lastName="Sophie"; firstName="Ingle"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=92; status=#Active; clubId=4; valueQuarterMillions=130; dateOfBirth=980121600000000000; nationality=65; shirtNumber=6; totalPoints=0; position=#Midfielder; lastName="Sjoeke"; firstName="Nüsken"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=93; status=#Active; clubId=4; valueQuarterMillions=125; dateOfBirth=900806400000000000; nationality=197; shirtNumber=8; totalPoints=0; position=#Midfielder; lastName="Erin"; firstName="Cuthbert"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=94; status=#Active; clubId=4; valueQuarterMillions=96; dateOfBirth=1084838400000000000; nationality=164; shirtNumber=16; totalPoints=0; position=#Midfielder; lastName="Júlia"; firstName="Bartel"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=95; status=#Active; clubId=4; valueQuarterMillions=107; dateOfBirth=1125273600000000000; nationality=125; shirtNumber=18; totalPoints=0; position=#Midfielder; lastName="Wieke"; firstName="Kaptein"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=96; status=#Active; clubId=4; valueQuarterMillions=126; dateOfBirth=997747200000000000; nationality=61; shirtNumber=27; totalPoints=0; position=#Midfielder; lastName="Oriane"; firstName="Jean-François"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=97; status=#Active; clubId=4; valueQuarterMillions=234; dateOfBirth=988588800000000000; nationality=187; shirtNumber=2; totalPoints=0; position=#Forward; lastName="Mia"; firstName="Fisher"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=98; status=#Active; clubId=4; valueQuarterMillions=266; dateOfBirth=922320000000000000; nationality=37; shirtNumber=7; totalPoints=0; position=#Forward; lastName="Mayra"; firstName="Ramírez"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=99; status=#Active; clubId=4; valueQuarterMillions=269; dateOfBirth=938995200000000000; nationality=187; shirtNumber=9; totalPoints=0; position=#Forward; lastName="Catarina"; firstName="Macario"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=100; status=#Active; clubId=4; valueQuarterMillions=275; dateOfBirth=1001721600000000000; nationality=186; shirtNumber=10; totalPoints=0; position=#Forward; lastName="Lauren"; firstName="James"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=101; status=#Active; clubId=4; valueQuarterMillions=363; dateOfBirth=775180800000000000; nationality=131; shirtNumber=11; totalPoints=0; position=#Forward; lastName="Guro"; firstName="Reiten"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=102; status=#Active; clubId=4; valueQuarterMillions=269; dateOfBirth=950918400000000000; nationality=61; shirtNumber=17; totalPoints=0; position=#Forward; lastName="Sandy"; firstName="Baltimore"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=103; status=#Active; clubId=4; valueQuarterMillions=284; dateOfBirth=855705600000000000; nationality=168; shirtNumber=19; totalPoints=0; position=#Forward; lastName="Johanna"; firstName="Rytting Kaneryd"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=104; status=#Active; clubId=4; valueQuarterMillions=385; dateOfBirth=747619200000000000; nationality=9; shirtNumber=20; totalPoints=0; position=#Forward; lastName="Sam"; firstName="Kerr"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=105; status=#Active; clubId=4; valueQuarterMillions=234; dateOfBirth=1084060800000000000; nationality=85; shirtNumber=23; totalPoints=0; position=#Forward; lastName="Maika"; firstName="Hamano"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=106; status=#Active; clubId=4; valueQuarterMillions=224; dateOfBirth=1059264000000000000; nationality=186; shirtNumber=33; totalPoints=0; position=#Forward; lastName="Aggie"; firstName="Beever-Jones"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=107; status=#Active; clubId=5; valueQuarterMillions=32; dateOfBirth=864259200000000000; nationality=187; shirtNumber=30; totalPoints=0; position=#Goalkeeper; lastName="Shae"; firstName="Yanez"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=108; status=#Active; clubId=5; valueQuarterMillions=87; dateOfBirth=677289600000000000; nationality=47; shirtNumber=2; totalPoints=0; position=#Defender; lastName="Katrine"; firstName="Veje"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=109; status=#Active; clubId=5; valueQuarterMillions=74; dateOfBirth=773712000000000000; nationality=186; shirtNumber=3; totalPoints=0; position=#Defender; lastName="Felicity"; firstName="Gibbons"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=110; status=#Active; clubId=5; valueQuarterMillions=46; dateOfBirth=996710400000000000; nationality=186; shirtNumber=6; totalPoints=0; position=#Defender; lastName="Aimee"; firstName="Everett"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=111; status=#Active; clubId=5; valueQuarterMillions=67; dateOfBirth=857692800000000000; nationality=81; shirtNumber=15; totalPoints=0; position=#Defender; lastName="Hayley"; firstName="Nolan"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=112; status=#Active; clubId=5; valueQuarterMillions=54; dateOfBirth=1062028800000000000; nationality=186; shirtNumber=29; totalPoints=0; position=#Defender; lastName="Jorja"; firstName="Fox"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=113; status=#Active; clubId=5; valueQuarterMillions=56; dateOfBirth=967939200000000000; nationality=198; shirtNumber=0; totalPoints=0; position=#Defender; lastName="Lily"; firstName="Woodham"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=114; status=#Active; clubId=5; valueQuarterMillions=144; dateOfBirth=790646400000000000; nationality=197; shirtNumber=4; totalPoints=0; position=#Midfielder; lastName="Chloe"; firstName="Arthur"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=115; status=#Active; clubId=5; valueQuarterMillions=106; dateOfBirth=875923200000000000; nationality=186; shirtNumber=24; totalPoints=0; position=#Midfielder; lastName="Shanade"; firstName="Hopcroft"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=116; status=#Active; clubId=5; valueQuarterMillions=224; dateOfBirth=889660800000000000; nationality=186; shirtNumber=8; totalPoints=0; position=#Forward; lastName="Molly-Mae"; firstName="Sharpe"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=117; status=#Active; clubId=5; valueQuarterMillions=224; dateOfBirth=987292800000000000; nationality=198; shirtNumber=9; totalPoints=0; position=#Forward; lastName="Elise"; firstName="Hughes"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=118; status=#Active; clubId=5; valueQuarterMillions=192; dateOfBirth=989193600000000000; nationality=186; shirtNumber=10; totalPoints=0; position=#Forward; lastName="Annabel"; firstName="Blanchard"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=119; status=#Active; clubId=5; valueQuarterMillions=243; dateOfBirth=928713600000000000; nationality=125; shirtNumber=11; totalPoints=0; position=#Forward; lastName="Ashleigh"; firstName="Weerden"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=120; status=#Active; clubId=5; valueQuarterMillions=230; dateOfBirth=1008806400000000000; nationality=126; shirtNumber=20; totalPoints=0; position=#Forward; lastName="Indiah-Paige"; firstName="Riley"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=121; status=#Active; clubId=5; valueQuarterMillions=230; dateOfBirth=938044800000000000; nationality=47; shirtNumber=22; totalPoints=0; position=#Forward; lastName="Mille"; firstName="Gejl"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=122; status=#Active; clubId=5; valueQuarterMillions=211; dateOfBirth=1114560000000000000; nationality=81; shirtNumber=27; totalPoints=0; position=#Forward; lastName="Abbie"; firstName="Larkin"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=123; status=#Active; clubId=5; valueQuarterMillions=221; dateOfBirth=995328000000000000; nationality=81; shirtNumber=77; totalPoints=0; position=#Forward; lastName="Izzy"; firstName="Atkinson"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=124; status=#Active; clubId=5; valueQuarterMillions=329; dateOfBirth=699321600000000000; nationality=187; shirtNumber=0; totalPoints=0; position=#Forward; lastName="Katie"; firstName="Stengel"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=125; status=#Active; clubId=6; valueQuarterMillions=36; dateOfBirth=815961600000000000; nationality=81; shirtNumber=1; totalPoints=0; position=#Goalkeeper; lastName="Courtney"; firstName="Brosnan"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=126; status=#Active; clubId=6; valueQuarterMillions=28; dateOfBirth=974332800000000000; nationality=186; shirtNumber=12; totalPoints=0; position=#Goalkeeper; lastName="Emily"; firstName="Ramsey"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=127; status=#Active; clubId=6; valueQuarterMillions=83; dateOfBirth=677289600000000000; nationality=47; shirtNumber=2; totalPoints=0; position=#Defender; lastName="Katrine"; firstName="Veje"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=128; status=#Active; clubId=6; valueQuarterMillions=40; dateOfBirth=1193788800000000000; nationality=186; shirtNumber=4; totalPoints=0; position=#Defender; lastName="Issy"; firstName="Hobson"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=129; status=#Active; clubId=6; valueQuarterMillions=57; dateOfBirth=948844800000000000; nationality=81; shirtNumber=19; totalPoints=0; position=#Defender; lastName="Heather "; firstName="Payne"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=130; status=#Active; clubId=6; valueQuarterMillions=59; dateOfBirth=891475200000000000; nationality=186; shirtNumber=20; totalPoints=0; position=#Defender; lastName="Megan"; firstName="Finnigan"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=131; status=#Active; clubId=6; valueQuarterMillions=54; dateOfBirth=917481600000000000; nationality=47; shirtNumber=23; totalPoints=0; position=#Defender; lastName="Sara "; firstName="Holmgaard"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=132; status=#Active; clubId=6; valueQuarterMillions=48; dateOfBirth=1074038400000000000; nationality=197; shirtNumber=24; totalPoints=0; position=#Defender; lastName="Kenzie"; firstName="Weir"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=133; status=#Active; clubId=6; valueQuarterMillions=56; dateOfBirth=936835200000000000; nationality=131; shirtNumber=27; totalPoints=0; position=#Defender; lastName="Elise"; firstName="Stenevik"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=134; status=#Active; clubId=6; valueQuarterMillions=114; dateOfBirth=884736000000000000; nationality=9; shirtNumber=7; totalPoints=0; position=#Midfielder; lastName="Clare"; firstName="Wheeler"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=135; status=#Active; clubId=6; valueQuarterMillions=170; dateOfBirth=704505600000000000; nationality=17; shirtNumber=8; totalPoints=0; position=#Midfielder; lastName="Justine"; firstName="Vanhaevermaet"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=136; status=#Active; clubId=6; valueQuarterMillions=134; dateOfBirth=844905600000000000; nationality=197; shirtNumber=17; totalPoints=0; position=#Midfielder; lastName="Lucy"; firstName="Hope"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=137; status=#Active; clubId=6; valueQuarterMillions=123; dateOfBirth=913507200000000000; nationality=83; shirtNumber=22; totalPoints=0; position=#Midfielder; lastName="Aurora"; firstName="Galli"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=138; status=#Active; clubId=6; valueQuarterMillions=118; dateOfBirth=917481600000000000; nationality=47; shirtNumber=28; totalPoints=0; position=#Midfielder; lastName="Karen"; firstName="Holmgaard"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=139; status=#Active; clubId=6; valueQuarterMillions=106; dateOfBirth=1107388800000000000; nationality=47; shirtNumber=47; totalPoints=0; position=#Midfielder; lastName="Karoline"; firstName="Olesen"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=140; status=#Active; clubId=6; valueQuarterMillions=112; dateOfBirth=895536000000000000; nationality=85; shirtNumber=6; totalPoints=0; position=#Midfielder; lastName="Honoka"; firstName="Hayashi"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=141; status=#Active; clubId=6; valueQuarterMillions=346; dateOfBirth=720921600000000000; nationality=164; shirtNumber=10; totalPoints=0; position=#Forward; lastName="Inma"; firstName="Gabarro"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=142; status=#Active; clubId=6; valueQuarterMillions=205; dateOfBirth=1008892800000000000; nationality=186; shirtNumber=11; totalPoints=0; position=#Forward; lastName="Emma"; firstName="Bissell"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=143; status=#Active; clubId=6; valueQuarterMillions=296; dateOfBirth=767491200000000000; nationality=186; shirtNumber=14; totalPoints=0; position=#Forward; lastName="Melissa"; firstName="Lawley"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=144; status=#Active; clubId=6; valueQuarterMillions=224; dateOfBirth=883612800000000000; nationality=67; shirtNumber=21; totalPoints=0; position=#Forward; lastName="Veatriki"; firstName="Sarri"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=145; status=#Active; clubId=6; valueQuarterMillions=264; dateOfBirth=871084800000000000; nationality=47; shirtNumber=26; totalPoints=0; position=#Forward; lastName="Rikke"; firstName="Madsen"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=146; status=#Active; clubId=6; valueQuarterMillions=317; dateOfBirth=798508800000000000; nationality=129; shirtNumber=0; totalPoints=0; position=#Forward; lastName="Toni"; firstName="Payne"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=147; status=#Active; clubId=7; valueQuarterMillions=30; dateOfBirth=924220800000000000; nationality=65; shirtNumber=1; totalPoints=0; position=#Goalkeeper; lastName="Janina"; firstName="Leitzig"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=148; status=#Active; clubId=7; valueQuarterMillions=30; dateOfBirth=890092800000000000; nationality=125; shirtNumber=23; totalPoints=0; position=#Goalkeeper; lastName="Lize"; firstName="Kop"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=149; status=#Active; clubId=7; valueQuarterMillions=53; dateOfBirth=1013472000000000000; nationality=9; shirtNumber=2; totalPoints=0; position=#Defender; lastName="Courtney"; firstName="Nevin"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=150; status=#Active; clubId=7; valueQuarterMillions=70; dateOfBirth=798508800000000000; nationality=126; shirtNumber=4; totalPoints=0; position=#Defender; lastName="CJ"; firstName="Bott"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=151; status=#Active; clubId=7; valueQuarterMillions=80; dateOfBirth=745545600000000000; nationality=197; shirtNumber=5; totalPoints=0; position=#Defender; lastName="Sophie"; firstName="Howard"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=152; status=#Active; clubId=7; valueQuarterMillions=56; dateOfBirth=893030400000000000; nationality=61; shirtNumber=17; totalPoints=0; position=#Defender; lastName="Julie"; firstName="Thibaud"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=153; status=#Active; clubId=7; valueQuarterMillions=58; dateOfBirth=1004745600000000000; nationality=186; shirtNumber=12; totalPoints=0; position=#Defender; lastName="Asmita"; firstName="Ale"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=154; status=#Active; clubId=7; valueQuarterMillions=58; dateOfBirth=982368000000000000; nationality=17; shirtNumber=22; totalPoints=0; position=#Defender; lastName="Sari"; firstName="Kees"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=155; status=#Active; clubId=7; valueQuarterMillions=56; dateOfBirth=902361600000000000; nationality=84; shirtNumber=31; totalPoints=0; position=#Defender; lastName="Chantelle"; firstName="Swaby"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=156; status=#Active; clubId=7; valueQuarterMillions=117; dateOfBirth=907804800000000000; nationality=186; shirtNumber=3; totalPoints=0; position=#Midfielder; lastName="Sam"; firstName="Tierney"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=157; status=#Active; clubId=7; valueQuarterMillions=110; dateOfBirth=977875200000000000; nationality=85; shirtNumber=6; totalPoints=0; position=#Midfielder; lastName="Saori"; firstName="Takarada"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=158; status=#Active; clubId=7; valueQuarterMillions=120; dateOfBirth=908150400000000000; nationality=17; shirtNumber=11; totalPoints=0; position=#Midfielder; lastName="Janice"; firstName="Cayman"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=159; status=#Active; clubId=7; valueQuarterMillions=96; dateOfBirth=1078272000000000000; nationality=168; shirtNumber=18; totalPoints=0; position=#Midfielder; lastName="Emilia"; firstName="Pelgander"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=160; status=#Active; clubId=7; valueQuarterMillions=102; dateOfBirth=1062720000000000000; nationality=186; shirtNumber=30; totalPoints=0; position=#Midfielder; lastName="Ruby"; firstName="Mace"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=161; status=#Active; clubId=7; valueQuarterMillions=250; dateOfBirth=920419200000000000; nationality=32; shirtNumber=7; totalPoints=0; position=#Forward; lastName="Deanne"; firstName="Rose"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=162; status=#Active; clubId=7; valueQuarterMillions=224; dateOfBirth=942192000000000000; nationality=60; shirtNumber=8; totalPoints=0; position=#Forward; lastName="Jutta"; firstName="Rantala"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=163; status=#Active; clubId=7; valueQuarterMillions=332; dateOfBirth=760406400000000000; nationality=65; shirtNumber=9; totalPoints=0; position=#Forward; lastName="Lena"; firstName="Petermann"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=164; status=#Active; clubId=7; valueQuarterMillions=224; dateOfBirth=1054857600000000000; nationality=61; shirtNumber=10; totalPoints=0; position=#Forward; lastName="Noémie"; firstName="Mouchon"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=165; status=#Active; clubId=7; valueQuarterMillions=160; dateOfBirth=1174089600000000000; nationality=186; shirtNumber=19; totalPoints=0; position=#Forward; lastName="Denny"; firstName="Draper"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=166; status=#Active; clubId=7; valueQuarterMillions=202; dateOfBirth=1043625600000000000; nationality=186; shirtNumber=20; totalPoints=0; position=#Forward; lastName="Missy"; firstName="Goodwin"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=167; status=#Active; clubId=7; valueQuarterMillions=208; dateOfBirth=918691200000000000; nationality=198; shirtNumber=21; totalPoints=0; position=#Forward; lastName="Hannah"; firstName="Cain"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=168; status=#Active; clubId=7; valueQuarterMillions=218; dateOfBirth=1002240000000000000; nationality=186; shirtNumber=27; totalPoints=0; position=#Forward; lastName="Shannon"; firstName="O’Brien"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=169; status=#Active; clubId=7; valueQuarterMillions=160; dateOfBirth=1108339200000000000; nationality=61; shirtNumber=28; totalPoints=0; position=#Forward; lastName="Shana"; firstName="Chossenotte"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=170; status=#Active; clubId=7; valueQuarterMillions=293; dateOfBirth=829008000000000000; nationality=85; shirtNumber=29; totalPoints=0; position=#Forward; lastName="Yuka"; firstName="Momiki"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=171; status=#Active; clubId=8; valueQuarterMillions=44; dateOfBirth=657763200000000000; nationality=186; shirtNumber=1; totalPoints=0; position=#Goalkeeper; lastName="Rachel"; firstName="Laws"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=172; status=#Active; clubId=8; valueQuarterMillions=33; dateOfBirth=877305600000000000; nationality=9; shirtNumber=16; totalPoints=0; position=#Goalkeeper; lastName="Teagan"; firstName="Micah"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=173; status=#Active; clubId=8; valueQuarterMillions=34; dateOfBirth=1081123200000000000; nationality=186; shirtNumber=22; totalPoints=0; position=#Goalkeeper; lastName="Faye"; firstName="Kirby"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=174; status=#Active; clubId=8; valueQuarterMillions=48; dateOfBirth=1081296000000000000; nationality=186; shirtNumber=2; totalPoints=0; position=#Defender; lastName="Lucy"; firstName="Parry"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=175; status=#Active; clubId=8; valueQuarterMillions=72; dateOfBirth=838857600000000000; nationality=198; shirtNumber=3; totalPoints=0; position=#Defender; lastName="Gemma"; firstName="Evans"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=176; status=#Active; clubId=8; valueQuarterMillions=61; dateOfBirth=883958400000000000; nationality=198; shirtNumber=4; totalPoints=0; position=#Defender; lastName="Grace"; firstName="Fisk"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=177; status=#Active; clubId=8; valueQuarterMillions=104; dateOfBirth=561081600000000000; nationality=81; shirtNumber=5; totalPoints=0; position=#Defender; lastName="Niamh"; firstName="Fahey"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=178; status=#Active; clubId=8; valueQuarterMillions=80; dateOfBirth=732931200000000000; nationality=186; shirtNumber=6; totalPoints=0; position=#Defender; lastName="Jasmine"; firstName="Matthews"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=179; status=#Active; clubId=8; valueQuarterMillions=58; dateOfBirth=924998400000000000; nationality=186; shirtNumber=12; totalPoints=0; position=#Defender; lastName="Taylor"; firstName="Hinds"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=180; status=#Active; clubId=8; valueQuarterMillions=54; dateOfBirth=1001721600000000000; nationality=197; shirtNumber=17; totalPoints=0; position=#Defender; lastName="Jenna"; firstName="Clark"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=181; status=#Active; clubId=8; valueQuarterMillions=87; dateOfBirth=679363200000000000; nationality=186; shirtNumber=23; totalPoints=0; position=#Defender; lastName="Gemma"; firstName="Bonner"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=182; status=#Active; clubId=8; valueQuarterMillions=46; dateOfBirth=1095465600000000000; nationality=186; shirtNumber=34; totalPoints=0; position=#Defender; lastName="Hannah"; firstName="Silcock"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=183; status=#Active; clubId=8; valueQuarterMillions=118; dateOfBirth=920937600000000000; nationality=85; shirtNumber=8; totalPoints=0; position=#Midfielder; lastName="Fuka"; firstName="Nagano"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=184; status=#Active; clubId=8; valueQuarterMillions=117; dateOfBirth=925171200000000000; nationality=81; shirtNumber=9; totalPoints=0; position=#Midfielder; lastName="Leanne"; firstName="Kiernan"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=185; status=#Active; clubId=8; valueQuarterMillions=114; dateOfBirth=993945600000000000; nationality=10; shirtNumber=14; totalPoints=0; position=#Midfielder; lastName="Marie"; firstName="Höbinger"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=186; status=#Active; clubId=8; valueQuarterMillions=109; dateOfBirth=1022630400000000000; nationality=47; shirtNumber=15; totalPoints=0; position=#Midfielder; lastName="Sofie"; firstName="Lundgaard"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=187; status=#Active; clubId=8; valueQuarterMillions=136; dateOfBirth=881884800000000000; nationality=198; shirtNumber=18; totalPoints=0; position=#Midfielder; lastName="Ceri"; firstName="Holland"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=188; status=#Active; clubId=8; valueQuarterMillions=138; dateOfBirth=1181088000000000000; nationality=186; shirtNumber=36; totalPoints=0; position=#Midfielder; lastName="Zara"; firstName="Shaw"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=189; status=#Active; clubId=8; valueQuarterMillions=224; dateOfBirth=963446400000000000; nationality=168; shirtNumber=7; totalPoints=0; position=#Forward; lastName="Cornelia"; firstName="Kapocs"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=190; status=#Active; clubId=8; valueQuarterMillions=237; dateOfBirth=928454400000000000; nationality=131; shirtNumber=10; totalPoints=0; position=#Forward; lastName="Sophie"; firstName="Román Haug"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=191; status=#Active; clubId=8; valueQuarterMillions=224; dateOfBirth=1091664000000000000; nationality=32; shirtNumber=11; totalPoints=0; position=#Forward; lastName="Olivia"; firstName="Smith"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=192; status=#Active; clubId=8; valueQuarterMillions=208; dateOfBirth=991267200000000000; nationality=186; shirtNumber=13; totalPoints=0; position=#Forward; lastName="Mia"; firstName="Enderby"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=193; status=#Active; clubId=8; valueQuarterMillions=322; dateOfBirth=705283200000000000; nationality=17; shirtNumber=20; totalPoints=0; position=#Forward; lastName="Yana"; firstName="Daniëls"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=194; status=#Active; clubId=9; valueQuarterMillions=32; dateOfBirth=1088294400000000000; nationality=186; shirtNumber=35; totalPoints=0; position=#Goalkeeper; lastName="Khiara"; firstName="Keating"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=195; status=#Active; clubId=9; valueQuarterMillions=29; dateOfBirth=898128000000000000; nationality=197; shirtNumber=22; totalPoints=0; position=#Goalkeeper; lastName="Sandy"; firstName="Maciver"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=196; status=#Active; clubId=9; valueQuarterMillions=25; dateOfBirth=917481600000000000; nationality=186; shirtNumber=40; totalPoints=0; position=#Goalkeeper; lastName="Katie"; firstName="Startup"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=197; status=#Active; clubId=9; valueQuarterMillions=34; dateOfBirth=812332800000000000; nationality=85; shirtNumber=31; totalPoints=0; position=#Goalkeeper; lastName="Ayaka"; firstName="Yamashita"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=198; status=#Active; clubId=9; valueQuarterMillions=62; dateOfBirth=967161600000000000; nationality=164; shirtNumber=4; totalPoints=0; position=#Defender; lastName="Laia"; firstName="Aleixandri"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=199; status=#Active; clubId=9; valueQuarterMillions=61; dateOfBirth=966643200000000000; nationality=125; shirtNumber=18; totalPoints=0; position=#Defender; lastName="Kerstin"; firstName="Casparij"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=200; status=#Active; clubId=9; valueQuarterMillions=90; dateOfBirth=747360000000000000; nationality=186; shirtNumber=5; totalPoints=0; position=#Defender; lastName="Alex"; firstName="Greenwood"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=201; status=#Active; clubId=9; valueQuarterMillions=80; dateOfBirth=790646400000000000; nationality=9; shirtNumber=14; totalPoints=0; position=#Defender; lastName="Alanna"; firstName="Kennedy"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=202; status=#Active; clubId=9; valueQuarterMillions=60; dateOfBirth=1078012800000000000; nationality=186; shirtNumber=3; totalPoints=0; position=#Defender; lastName="Naomi"; firstName="Layzell"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=203; status=#Active; clubId=9; valueQuarterMillions=46; dateOfBirth=1110758400000000000; nationality=81; shirtNumber=26; totalPoints=0; position=#Defender; lastName="Tara"; firstName="O'Hanlon"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=204; status=#Active; clubId=9; valueQuarterMillions=90; dateOfBirth=732758400000000000; nationality=164; shirtNumber=15; totalPoints=0; position=#Defender; lastName="Leila"; firstName="Ouahabi"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=205; status=#Active; clubId=9; valueQuarterMillions=52; dateOfBirth=1101945600000000000; nationality=186; shirtNumber=28; totalPoints=0; position=#Defender; lastName="Gracie"; firstName="Prior"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=206; status=#Active; clubId=9; valueQuarterMillions=76; dateOfBirth=834796800000000000; nationality=85; shirtNumber=2; totalPoints=0; position=#Defender; lastName="Risa"; firstName="Shimizu"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=207; status=#Active; clubId=9; valueQuarterMillions=117; dateOfBirth=1070928000000000000; nationality=186; shirtNumber=19; totalPoints=0; position=#Midfielder; lastName="Laura"; firstName="Blindkilde Brown"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=208; status=#Active; clubId=9; valueQuarterMillions=188; dateOfBirth=665107200000000000; nationality=186; shirtNumber=7; totalPoints=0; position=#Midfielder; lastName="Laura"; firstName="Coombs"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=209; status=#Active; clubId=9; valueQuarterMillions=157; dateOfBirth=854496000000000000; nationality=85; shirtNumber=25; totalPoints=0; position=#Midfielder; lastName="Yui"; firstName="Hasegawa"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=210; status=#Active; clubId=9; valueQuarterMillions=160; dateOfBirth=861667200000000000; nationality=125; shirtNumber=10; totalPoints=0; position=#Midfielder; lastName="Jill"; firstName="Roord"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=211; status=#Active; clubId=9; valueQuarterMillions=246; dateOfBirth=1045180800000000000; nationality=9; shirtNumber=8; totalPoints=0; position=#Forward; lastName="Mary"; firstName="Fowler"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=212; status=#Active; clubId=9; valueQuarterMillions=224; dateOfBirth=1075161600000000000; nationality=85; shirtNumber=20; totalPoints=0; position=#Forward; lastName="Aoba"; firstName="Fujino"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=213; status=#Active; clubId=9; valueQuarterMillions=275; dateOfBirth=965606400000000000; nationality=186; shirtNumber=11; totalPoints=0; position=#Forward; lastName="Lauren"; firstName="Hemp"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=214; status=#Active; clubId=9; valueQuarterMillions=275; dateOfBirth=884822400000000000; nationality=186; shirtNumber=9; totalPoints=0; position=#Forward; lastName="Chloe"; firstName="Kelly"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=215; status=#Active; clubId=9; valueQuarterMillions=325; dateOfBirth=837388800000000000; nationality=125; shirtNumber=6; totalPoints=0; position=#Forward; lastName="Vivianne"; firstName="Miedema"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=216; status=#Active; clubId=9; valueQuarterMillions=253; dateOfBirth=1003622400000000000; nationality=186; shirtNumber=16; totalPoints=0; position=#Forward; lastName="Jess"; firstName="Park"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=217; status=#Active; clubId=9; valueQuarterMillions=160; dateOfBirth=1133568000000000000; nationality=186; shirtNumber=17; totalPoints=0; position=#Forward; lastName="Poppy"; firstName="Pritchard"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=218; status=#Active; clubId=9; valueQuarterMillions=270; dateOfBirth=854668800000000000; nationality=84; shirtNumber=21; totalPoints=0; position=#Forward; lastName="Khadija"; firstName="Shaw"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=219; status=#Active; clubId=10; valueQuarterMillions=24; dateOfBirth=1095724800000000000; nationality=198; shirtNumber=39; totalPoints=0; position=#Goalkeeper; lastName="Safia"; firstName="Middleton-Patel"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=220; status=#Active; clubId=10; valueQuarterMillions=37; dateOfBirth=845683200000000000; nationality=187; shirtNumber=91; totalPoints=0; position=#Goalkeeper; lastName="Phallon"; firstName="Tullis-Joyce"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=221; status=#Active; clubId=10; valueQuarterMillions=58; dateOfBirth=1053648000000000000; nationality=168; shirtNumber=2; totalPoints=0; position=#Defender; lastName="Anna"; firstName="Sandberg"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=222; status=#Active; clubId=10; valueQuarterMillions=71; dateOfBirth=854841600000000000; nationality=186; shirtNumber=3; totalPoints=0; position=#Defender; lastName="Gabby"; firstName="George"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=223; status=#Active; clubId=10; valueQuarterMillions=65; dateOfBirth=1019088000000000000; nationality=186; shirtNumber=4; totalPoints=0; position=#Defender; lastName="Maya"; firstName="Le Tissier"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=224; status=#Active; clubId=10; valueQuarterMillions=68; dateOfBirth=811900800000000000; nationality=186; shirtNumber=5; totalPoints=0; position=#Defender; lastName="Aoife"; firstName="Mannion"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=225; status=#Active; clubId=10; valueQuarterMillions=87; dateOfBirth=769824000000000000; nationality=186; shirtNumber=6; totalPoints=0; position=#Defender; lastName="Hannah"; firstName="Blundell"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=226; status=#Active; clubId=10; valueQuarterMillions=58; dateOfBirth=980121600000000000; nationality=32; shirtNumber=14; totalPoints=0; position=#Defender; lastName="Jayde"; firstName="Riviere"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=227; status=#Active; clubId=10; valueQuarterMillions=85; dateOfBirth=790300800000000000; nationality=125; shirtNumber=17; totalPoints=0; position=#Defender; lastName="Dominique"; firstName="Janssen"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=228; status=#Active; clubId=10; valueQuarterMillions=75; dateOfBirth=836697600000000000; nationality=186; shirtNumber=21; totalPoints=0; position=#Defender; lastName="Millie"; firstName="Turner"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=229; status=#Active; clubId=10; valueQuarterMillions=49; dateOfBirth=1114646400000000000; nationality=186; shirtNumber=25; totalPoints=0; position=#Defender; lastName="Evie"; firstName="Rabjohn"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=230; status=#Active; clubId=10; valueQuarterMillions=47; dateOfBirth=1105574400000000000; nationality=186; shirtNumber=38; totalPoints=0; position=#Defender; lastName="Jess"; firstName="Simpson"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=231; status=#Active; clubId=10; valueQuarterMillions=134; dateOfBirth=936230400000000000; nationality=186; shirtNumber=7; totalPoints=0; position=#Midfielder; lastName="Ella"; firstName="Toone"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=232; status=#Active; clubId=10; valueQuarterMillions=114; dateOfBirth=1043971200000000000; nationality=186; shirtNumber=8; totalPoints=0; position=#Midfielder; lastName="Grace"; firstName="Clinton"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=233; status=#Active; clubId=10; valueQuarterMillions=173; dateOfBirth=769737600000000000; nationality=186; shirtNumber=11; totalPoints=0; position=#Midfielder; lastName="Leah"; firstName="Galton"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=234; status=#Active; clubId=10; valueQuarterMillions=171; dateOfBirth=749865600000000000; nationality=198; shirtNumber=12; totalPoints=0; position=#Midfielder; lastName="Hayley"; firstName="Ladd"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=235; status=#Active; clubId=10; valueQuarterMillions=115; dateOfBirth=1066867200000000000; nationality=32; shirtNumber=13; totalPoints=0; position=#Midfielder; lastName="Simi"; firstName="Awujo"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=236; status=#Active; clubId=10; valueQuarterMillions=141; dateOfBirth=802828800000000000; nationality=131; shirtNumber=16; totalPoints=0; position=#Midfielder; lastName="Lisa"; firstName="Naalsund"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=237; status=#Active; clubId=10; valueQuarterMillions=120; dateOfBirth=943747200000000000; nationality=85; shirtNumber=20; totalPoints=0; position=#Midfielder; lastName="Hinata"; firstName="Miyazawa"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=238; status=#Active; clubId=10; valueQuarterMillions=80; dateOfBirth=1138406400000000000; nationality=197; shirtNumber=34; totalPoints=0; position=#Midfielder; lastName="Emma"; firstName="Watson"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=239; status=#Active; clubId=10; valueQuarterMillions=262; dateOfBirth=962150400000000000; nationality=61; shirtNumber=9; totalPoints=0; position=#Forward; lastName="Melvine"; firstName="Malard"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=240; status=#Active; clubId=10; valueQuarterMillions=243; dateOfBirth=1003881600000000000; nationality=131; shirtNumber=15; totalPoints=0; position=#Forward; lastName="Celin"; firstName="Bizet"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=241; status=#Active; clubId=10; valueQuarterMillions=243; dateOfBirth=993686400000000000; nationality=131; shirtNumber=19; totalPoints=0; position=#Forward; lastName="Elisabeth"; firstName="Terland"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=242; status=#Active; clubId=10; valueQuarterMillions=259; dateOfBirth=890956800000000000; nationality=24; shirtNumber=23; totalPoints=0; position=#Forward; lastName="Geyse"; firstName="Da Silva Ferreria"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=243; status=#Active; clubId=10; valueQuarterMillions=243; dateOfBirth=568771200000000000; nationality=186; shirtNumber=28; totalPoints=0; position=#Forward; lastName="Rachel"; firstName="Williams"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=244; status=#Active; clubId=11; valueQuarterMillions=57; dateOfBirth=1000944000000000000; nationality=9; shirtNumber=2; totalPoints=0; position=#Defender; lastName="Charlotte"; firstName="Grant"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=245; status=#Active; clubId=11; valueQuarterMillions=57; dateOfBirth=1032739200000000000; nationality=186; shirtNumber=3; totalPoints=0; position=#Defender; lastName="Ella"; firstName="Morris"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=246; status=#Active; clubId=11; valueQuarterMillions=80; dateOfBirth=678585600000000000; nationality=186; shirtNumber=4; totalPoints=0; position=#Defender; lastName="Amy"; firstName="James-Turner"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=247; status=#Active; clubId=11; valueQuarterMillions=76; dateOfBirth=833587200000000000; nationality=186; shirtNumber=5; totalPoints=0; position=#Defender; lastName="Molly"; firstName="Bartrip"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=248; status=#Active; clubId=11; valueQuarterMillions=62; dateOfBirth=902448000000000000; nationality=168; shirtNumber=6; totalPoints=0; position=#Defender; lastName="Amanda"; firstName="Nildén"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=249; status=#Active; clubId=11; valueQuarterMillions=243; dateOfBirth=969753600000000000; nationality=186; shirtNumber=7; totalPoints=0; position=#Forward; lastName="Jessica"; firstName="Naz"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=250; status=#Active; clubId=11; valueQuarterMillions=329; dateOfBirth=778723200000000000; nationality=9; shirtNumber=8; totalPoints=0; position=#Forward; lastName="Hayley"; firstName="Raso"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=251; status=#Active; clubId=11; valueQuarterMillions=341; dateOfBirth=770601600000000000; nationality=186; shirtNumber=9; totalPoints=0; position=#Forward; lastName="Bethany"; firstName="England"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=252; status=#Active; clubId=11; valueQuarterMillions=118; dateOfBirth=890784000000000000; nationality=164; shirtNumber=10; totalPoints=0; position=#Midfielder; lastName="Maite"; firstName="Oroz"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=253; status=#Active; clubId=11; valueQuarterMillions=104; dateOfBirth=1047772800000000000; nationality=168; shirtNumber=13; totalPoints=0; position=#Midfielder; lastName="Matilda"; firstName="Vinberg"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=254; status=#Active; clubId=11; valueQuarterMillions=115; dateOfBirth=942537600000000000; nationality=75; shirtNumber=14; totalPoints=0; position=#Midfielder; lastName="Anna"; firstName="Csiki"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=255; status=#Active; clubId=11; valueQuarterMillions=77; dateOfBirth=796089600000000000; nationality=9; shirtNumber=15; totalPoints=0; position=#Defender; lastName="Clare"; firstName="Hunt"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=256; status=#Active; clubId=11; valueQuarterMillions=274; dateOfBirth=816048000000000000; nationality=186; shirtNumber=16; totalPoints=0; position=#Forward; lastName="Kit"; firstName="Graham"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=257; status=#Active; clubId=11; valueQuarterMillions=296; dateOfBirth=833500800000000000; nationality=186; shirtNumber=17; totalPoints=0; position=#Forward; lastName="Martha"; firstName="Thomas"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=258; status=#Active; clubId=11; valueQuarterMillions=132; dateOfBirth=871603200000000000; nationality=60; shirtNumber=20; totalPoints=0; position=#Midfielder; lastName="Olga"; firstName="Ahtinen"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=259; status=#Active; clubId=11; valueQuarterMillions=74; dateOfBirth=830649600000000000; nationality=169; shirtNumber=21; totalPoints=0; position=#Defender; lastName="Luana"; firstName="Bühler"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=260; status=#Active; clubId=11; valueQuarterMillions=46; dateOfBirth=667180800000000000; nationality=84; shirtNumber=22; totalPoints=0; position=#Goalkeeper; lastName="Becky"; firstName="Spencer"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=261; status=#Active; clubId=11; valueQuarterMillions=164; dateOfBirth=719798400000000000; nationality=84; shirtNumber=24; totalPoints=0; position=#Midfielder; lastName="Drew"; firstName="Spence "; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=262; status=#Active; clubId=11; valueQuarterMillions=122; dateOfBirth=896400000000000000; nationality=60; shirtNumber=25; totalPoints=0; position=#Midfielder; lastName="Eveliina"; firstName="Summanen"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=263; status=#Active; clubId=11; valueQuarterMillions=28; dateOfBirth=907891200000000000; nationality=187; shirtNumber=26; totalPoints=0; position=#Goalkeeper; lastName="Katelyn"; firstName="Talbert"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=264; status=#Active; clubId=11; valueQuarterMillions=23; dateOfBirth=1059955200000000000; nationality=186; shirtNumber=27; totalPoints=0; position=#Goalkeeper; lastName="Eleanor"; firstName="Heeps"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=265; status=#Active; clubId=11; valueQuarterMillions=90; dateOfBirth=736041600000000000; nationality=186; shirtNumber=29; totalPoints=0; position=#Defender; lastName="Ashleigh"; firstName="Neville"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=266; status=#Active; clubId=11; valueQuarterMillions=170; dateOfBirth=1136937600000000000; nationality=186; shirtNumber=30; totalPoints=0; position=#Forward; lastName="Araya"; firstName="Dennis"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=267; status=#Active; clubId=11; valueQuarterMillions=182; dateOfBirth=1107561600000000000; nationality=186; shirtNumber=31; totalPoints=0; position=#Forward; lastName="Lenna"; firstName="Gunning-Williams"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=268; status=#Active; clubId=11; valueQuarterMillions=160; dateOfBirth=790819200000000000; nationality=36; shirtNumber=77; totalPoints=0; position=#Midfielder; lastName="Shuang"; firstName="Wang"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=269; status=#Active; clubId=12; valueQuarterMillions=36; dateOfBirth=867196800000000000; nationality=140; shirtNumber=1; totalPoints=0; position=#Goalkeeper; lastName="Kinga"; firstName="Szemik"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=270; status=#Active; clubId=12; valueQuarterMillions=40; dateOfBirth=784598400000000000; nationality=81; shirtNumber=25; totalPoints=0; position=#Goalkeeper; lastName="Megan"; firstName="Walsh"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=271; status=#Active; clubId=12; valueQuarterMillions=31; dateOfBirth=907891200000000000; nationality=187; shirtNumber=30; totalPoints=0; position=#Goalkeeper; lastName="Katelin"; firstName="Talbert"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=272; status=#Active; clubId=12; valueQuarterMillions=79; dateOfBirth=757814400000000000; nationality=197; shirtNumber=2; totalPoints=0; position=#Defender; lastName="Kirsty"; firstName="Smith"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=273; status=#Active; clubId=12; valueQuarterMillions=56; dateOfBirth=996019200000000000; nationality=61; shirtNumber=3; totalPoints=0; position=#Defender; lastName="Inès"; firstName="Belloumou"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=274; status=#Active; clubId=12; valueQuarterMillions=56; dateOfBirth=948844800000000000; nationality=17; shirtNumber=5; totalPoints=0; position=#Defender; lastName="Amber"; firstName="Tysiak"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=275; status=#Active; clubId=12; valueQuarterMillions=87; dateOfBirth=719884800000000000; nationality=32; shirtNumber=14; totalPoints=0; position=#Defender; lastName="Shelina"; firstName="Zadorsky"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=276; status=#Active; clubId=12; valueQuarterMillions=80; dateOfBirth=782352000000000000; nationality=35; shirtNumber=17; totalPoints=0; position=#Defender; lastName="Camila"; firstName="Sáez"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=277; status=#Active; clubId=12; valueQuarterMillions=53; dateOfBirth=1052438400000000000; nationality=186; shirtNumber=18; totalPoints=0; position=#Defender; lastName="Anouk"; firstName="Denton"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=278; status=#Active; clubId=12; valueQuarterMillions=53; dateOfBirth=949449600000000000; nationality=186; shirtNumber=21; totalPoints=0; position=#Defender; lastName="Shannon"; firstName="Cooke"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=279; status=#Active; clubId=12; valueQuarterMillions=48; dateOfBirth=1107734400000000000; nationality=81; shirtNumber=24; totalPoints=0; position=#Defender; lastName="Jessie"; firstName="Stapleton"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=280; status=#Active; clubId=12; valueQuarterMillions=62; dateOfBirth=796348800000000000; nationality=36; shirtNumber=26; totalPoints=0; position=#Defender; lastName="Li"; firstName="Mengwen"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=281; status=#Active; clubId=12; valueQuarterMillions=40; dateOfBirth=1129852800000000000; nationality=186; shirtNumber=42; totalPoints=0; position=#Defender; lastName="Marnie"; firstName="Morrison"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=282; status=#Active; clubId=12; valueQuarterMillions=40; dateOfBirth=1136851200000000000; nationality=186; shirtNumber=43; totalPoints=0; position=#Defender; lastName="Daniella"; firstName="Way"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=283; status=#Active; clubId=12; valueQuarterMillions=112; dateOfBirth=982886400000000000; nationality=60; shirtNumber=4; totalPoints=0; position=#Midfielder; lastName="Oona"; firstName="Siren"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=284; status=#Active; clubId=12; valueQuarterMillions=109; dateOfBirth=931737600000000000; nationality=168; shirtNumber=7; totalPoints=0; position=#Midfielder; lastName="Marika"; firstName="Bergman Lundin"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=285; status=#Active; clubId=12; valueQuarterMillions=183; dateOfBirth=681782400000000000; nationality=76; shirtNumber=10; totalPoints=0; position=#Midfielder; lastName="Dagný"; firstName="Brynjarsdóttir"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=286; status=#Active; clubId=12; valueQuarterMillions=189; dateOfBirth=667440000000000000; nationality=187; shirtNumber=15; totalPoints=0; position=#Midfielder; lastName="Kristie"; firstName="Mewis"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=287; status=#Active; clubId=12; valueQuarterMillions=110; dateOfBirth=1023321600000000000; nationality=81; shirtNumber=16; totalPoints=0; position=#Midfielder; lastName="Jess"; firstName="Ziu"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=288; status=#Active; clubId=12; valueQuarterMillions=175; dateOfBirth=713664000000000000; nationality=9; shirtNumber=22; totalPoints=0; position=#Midfielder; lastName="Katrina"; firstName="Gorry"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=289; status=#Active; clubId=12; valueQuarterMillions=102; dateOfBirth=1102723200000000000; nationality=180; shirtNumber=33; totalPoints=0; position=#Midfielder; lastName="Halle"; firstName="Houssein"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=290; status=#Active; clubId=12; valueQuarterMillions=80; dateOfBirth=1159920000000000000; nationality=186; shirtNumber=34; totalPoints=0; position=#Midfielder; lastName="Macey"; firstName="Nicholls"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=291; status=#Active; clubId=12; valueQuarterMillions=80; dateOfBirth=1141948800000000000; nationality=186; shirtNumber=36; totalPoints=0; position=#Midfielder; lastName="Soraya"; firstName="Walsh"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=292; status=#Active; clubId=12; valueQuarterMillions=80; dateOfBirth=1127260800000000000; nationality=186; shirtNumber=38; totalPoints=0; position=#Midfielder; lastName="Ellie"; firstName="Moore"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=293; status=#Active; clubId=12; valueQuarterMillions=80; dateOfBirth=1127520000000000000; nationality=186; shirtNumber=41; totalPoints=0; position=#Midfielder; lastName="Keira"; firstName="Flannery"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=294; status=#Active; clubId=12; valueQuarterMillions=122; dateOfBirth=959904000000000000; nationality=169; shirtNumber=77; totalPoints=0; position=#Midfielder; lastName="Seraina"; firstName="Piubel"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=295; status=#Active; clubId=12; valueQuarterMillions=224; dateOfBirth=933292800000000000; nationality=85; shirtNumber=9; totalPoints=0; position=#Forward; lastName="Riko"; firstName="Ueki"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=296; status=#Active; clubId=12; valueQuarterMillions=224; dateOfBirth=977529600000000000; nationality=37; shirtNumber=11; totalPoints=0; position=#Forward; lastName="Manuela"; firstName="Paví"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=297; status=#Active; clubId=12; valueQuarterMillions=230; dateOfBirth=1017360000000000000; nationality=186; shirtNumber=12; totalPoints=0; position=#Forward; lastName="Emma"; firstName="Harries"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=298; status=#Active; clubId=12; valueQuarterMillions=230; dateOfBirth=994204800000000000; nationality=65; shirtNumber=19; totalPoints=0; position=#Forward; lastName="Shekiera"; firstName="Martinez"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=299; status=#Active; clubId=12; valueQuarterMillions=344; dateOfBirth=753753600000000000; nationality=61; shirtNumber=20; totalPoints=0; position=#Forward; lastName="Viviane"; firstName="Asseyi"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            {id=300; status=#Active; clubId=12; valueQuarterMillions=160; dateOfBirth=1127433600000000000; nationality=186; shirtNumber=44; totalPoints=0; position=#Forward; lastName="Ruby"; firstName="Doe"; currentLoanEndDate=0; gender=#Female; injuryHistory=List.nil(); latestInjuryEndDate=0; parentClubId=0; retirementDate=0; seasons=List.nil(); transferHistory=List.nil(); valueHistory=List.nil()},
            ]
        )
      ];

      dataInitialised := true;

      return #ok();
    };



    private func setSystemTimers() : async (){
      
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
    };

  };
