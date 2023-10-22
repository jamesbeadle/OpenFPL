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

    private var players = List.fromArray<T.Player>([]);
    private var nextPlayerId : Nat = 560;
    private var retiredPlayers = List.fromArray<T.Player>([]);
    private var formerPlayers = List.fromArray<T.Player>([]);

    private var dataCacheHashes: List.List<T.DataCache> = List.fromArray([
        { category = "players"; hash = "DEFAULT_VALUE" },
        { category = "playerEventData"; hash = "DEFAULT_VALUE" }
    ]);
  
    public shared query ({caller}) func getAllPlayers() : async [DTOs.PlayerDTO] {
        
        func compare(player1: T.Player, player2: T.Player) : Bool {
            return player1.value >= player2.value;
        };

        func mergeSort(entries: List.List<T.Player>) : List.List<T.Player> {
            let len = List.size(entries);
            
            if (len <= 1) {
                return entries;
            } else {
                let (firstHalf, secondHalf) = List.split(len / 2, entries);
                return List.merge(mergeSort(firstHalf), mergeSort(secondHalf), compare);
            };
        };

        let sortedPlayers = mergeSort(players);

        return Array.map<T.Player, DTOs.PlayerDTO>(List.toArray(sortedPlayers), func (player: T.Player) : DTOs.PlayerDTO { 
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
            }});
    };

    public shared query ({caller}) func getActivePlayers() : async [DTOs.PlayerDTO] {
        
        func compare(player1: T.Player, player2: T.Player) : Bool {
            return player1.value >= player2.value;
        };

        func mergeSort(entries: List.List<T.Player>) : List.List<T.Player> {
            let len = List.size(entries);
            
            if (len <= 1) {
                return entries;
            } else {
                let (firstHalf, secondHalf) = List.split(len / 2, entries);
                return List.merge(mergeSort(firstHalf), mergeSort(secondHalf), compare);
            };
        };

        let nonLoanPlayers = List.filter<T.Player>(players, func (player: T.Player) : Bool {
            return player.onLoan == false;
        });

        let sortedPlayers = mergeSort(nonLoanPlayers);

        let filteredPlayers = List.filter<T.Player>(sortedPlayers, func(player: T.Player) : Bool {
            return player.teamId > 0;
        });

        return Array.map<T.Player, DTOs.PlayerDTO>(List.toArray(filteredPlayers), func (player: T.Player) : DTOs.PlayerDTO { 
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
            }});
    };

    public shared query ({caller}) func getPlayerDetailsForGameweek(seasonId: Nat16, gameweek: Nat8) : async [DTOs.PlayerPointsDTO] {
        
        var playerDetailsBuffer = Buffer.fromArray<DTOs.PlayerPointsDTO>([]);

        label playerDetailsLoop for (player in Iter.fromList(players)) {
            var points: Int16 = 0;
            var events: List.List<T.PlayerEventData> = List.nil();

            for (season in Iter.fromList(player.seasons)) {
                if (season.id == seasonId) {
                    for (gw in Iter.fromList(season.gameweeks)) {

                        if (gw.number == gameweek) {
                            points := gw.points;
                            events := List.filter<T.PlayerEventData>(gw.events, func(event: T.PlayerEventData) : Bool {
                                return event.playerId == player.id;
                            });
                        };
                    }
                }
            };

            let playerGameweek: DTOs.PlayerPointsDTO = {
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

    public shared query ({caller}) func getPlayersDetailsForGameweek(playerIds: [T.PlayerId], seasonId: Nat16, gameweek: Nat8) : async [DTOs.PlayerPointsDTO] {
        var playerDetailsBuffer = Buffer.fromArray<DTOs.PlayerPointsDTO>([]);

        label playerDetailsLoop for (player in Iter.fromList(players)) {
            if (Array.find<T.PlayerId>(playerIds, func(id) { id == player.id }) == null or player.onLoan) {
                continue playerDetailsLoop;
            };

            var points: Int16 = 0;
            var events: List.List<T.PlayerEventData> = List.nil();

            for (season in Iter.fromList(player.seasons)) {
                if (season.id == seasonId) {
                    for (gw in Iter.fromList(season.gameweeks)) {

                        if (gw.number == gameweek) {
                            points := gw.points;
                            events := List.filter<T.PlayerEventData>(gw.events, func(event: T.PlayerEventData) : Bool {
                                return event.playerId == player.id;
                            });
                        };
                    }
                }
            };

            let playerGameweek: DTOs.PlayerPointsDTO = {
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

    public query ({caller}) func getAllPlayersMap(seasonId: Nat16, gameweek: Nat8) : async [(Nat16, DTOs.PlayerScoreDTO)] {
        var playersMap: HashMap.HashMap<Nat16, DTOs.PlayerScoreDTO> = HashMap.HashMap<Nat16, DTOs.PlayerScoreDTO>(500, Utilities.eqNat16, Utilities.hashNat16);
        label playerMapLoop for (player in Iter.fromList(players)) { 
            if (player.onLoan) {
                continue playerMapLoop; 
            };

            var points: Int16 = 0;
            var events: List.List<T.PlayerEventData> = List.nil();
            var goalsScored: Int16 = 0;
            var goalsConceded: Int16 = 0;
            var saves: Int16 = 0;
            var assists: Int16 = 0;

            for (season in Iter.fromList(player.seasons)) {
                if (season.id == seasonId) {
                    for (gw in Iter.fromList(season.gameweeks)) {

                        if (gw.number == gameweek) {
                            points := gw.points;
                            events := gw.events;

                            for (event in Iter.fromList(gw.events)) {
                                switch (event.eventType) {
                                    case (1) { goalsScored += 1; }; 
                                    case (2) { assists += 1; };
                                    case (3) { goalsConceded += 1; };
                                    case (4) { saves += 1; };
                                    case _ {};
                                };
                            };
                        };
                    }
                }
            };

            let scoreDTO: DTOs.PlayerScoreDTO = {
                id = player.id;
                points = points;
                events = events;
                teamId = player.teamId;
                position = player.position;
                goalsScored = goalsScored;
                goalsConceded = goalsConceded;
                saves = saves;
                assists = assists;
            };
            playersMap.put(player.id, scoreDTO);
        };
        return Iter.toArray(playersMap.entries());
    };

    public shared query ({caller}) func getPlayer(playerId: Nat16) : async T.Player {
        let foundPlayer = List.find<T.Player>(players, func (player: T.Player): Bool {
            return player.id == playerId and not player.onLoan;
        });

        switch (foundPlayer) {
            case (null) { return { 
                id = 0; teamId = 0; position = 0; 
                firstName = ""; lastName = ""; 
                shirtNumber = 0; value = 0; 
                dateOfBirth = 0; nationality = ""; 
                seasons = List.nil<T.PlayerSeason>(); 
                valueHistory = List.nil<T.ValueHistory>();
                onLoan = false; parentTeamId = 0;
                isInjured = false; injuryHistory = List.nil<T.InjuryHistory>();
                retirementDate = 0; 
                transferHistory = List.nil<T.TransferHistory>(); 
                } };
            case (?player) { return player; };
        };
    };

    public shared query ({caller}) func getPlayerDetails(playerId: Nat16, seasonId: T.SeasonId) : async DTOs.PlayerDetailDTO {
        
        var teamId: T.TeamId = 0;
        var position: Nat8 = 0; 
        var firstName = ""; 
        var lastName = "";
        var shirtNumber: Nat8 = 0; 
        var value: Nat = 0;
        var dateOfBirth: Int = 0; 
        var nationality = "";
        var valueHistory: [T.ValueHistory] = [];
        var onLoan = false; 
        var parentTeamId: T.TeamId = 0;
        var isInjured = false; 
        var injuryHistory: [T.InjuryHistory] = [];
        var retirementDate: Int = 0;
        
        let gameweeksBuffer = Buffer.fromArray<DTOs.PlayerGameweekDTO>([]);
        
        let foundPlayer = List.find<T.Player>(players, func (player: T.Player): Bool {
            return player.id == playerId and not player.onLoan;
        });

        switch (foundPlayer) {
            case (null) {  };
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
                
                let currentSeason = List.find<T.PlayerSeason>(player.seasons, func(ps: T.PlayerSeason) { ps.id == seasonId });
                switch(currentSeason){
                    case (null){};
                    case (?season){
                        for(gw in Iter.fromList(season.gameweeks)){

                            var fixtureId: T.FixtureId = 0;
                            let events = List.toArray<T.PlayerEventData>(gw.events);
                            if(Array.size(events) > 0){
                                fixtureId := events[0].fixtureId;
                            };

                            let gameweekDTO: DTOs.PlayerGameweekDTO = {
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

    public shared func revaluePlayerUp(playerId: T.PlayerId, activeSeasonId: T.SeasonId, activeGameweek: T.GameweekNumber) : async (){
        var updatedPlayers = List.map<T.Player, T.Player>(players, func (p: T.Player): T.Player {
            if (p.id == playerId) {
                var newValue = p.value;
                newValue += 1;
                
                let historyEntry: T.ValueHistory = {
                    seasonId = activeSeasonId;
                    gameweek = activeGameweek;
                    oldValue = p.value;
                    newValue = newValue;
                };

                let updatedPlayer: T.Player = {
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
                    parentTeamId = p.parentTeamId;
                    isInjured = p.isInjured;
                    injuryHistory = p.injuryHistory;
                    retirementDate = p.retirementDate;
                    transferHistory = p.transferHistory;
                };

                return updatedPlayer;
            };
            return p;
        });

        players := updatedPlayers;
    };

    public shared func revaluePlayerDown(playerId: T.PlayerId, activeSeasonId: T.SeasonId, activeGameweek: T.GameweekNumber){
        var updatedPlayers = List.map<T.Player, T.Player>(players, func (p: T.Player): T.Player {
            if (p.id == playerId) {
                var newValue = p.value;
                if(newValue >= 1){
                    newValue -= 1;
                };
    
                let historyEntry: T.ValueHistory = {
                    seasonId = activeSeasonId;
                    gameweek = activeGameweek;
                    oldValue = p.value;
                    newValue = newValue;
                };

                let updatedPlayer: T.Player = {
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
                    parentTeamId = p.parentTeamId;
                    isInjured = p.isInjured;
                    injuryHistory = p.injuryHistory;
                    retirementDate = p.retirementDate;
                    transferHistory = p.transferHistory;
                };

                return updatedPlayer;
            };
            return p;
        });

        players := updatedPlayers;
    };

    public shared ({caller}) func calculatePlayerScores(seasonId: Nat16, gameweek: Nat8, fixture: T.Fixture) : async T.Fixture {
        var homeGoalsCount: Nat8 = 0;
        var awayGoalsCount: Nat8 = 0;
        
        let playerEventsMap: HashMap.HashMap<Nat16, [T.PlayerEventData]> = HashMap.HashMap<Nat16, [T.PlayerEventData]>(200, Utilities.eqNat16, Utilities.hashNat16);
        
        for (event in Iter.fromList(fixture.events)) {
            
            switch(event.eventType) {
                case 1 {
                    if (event.teamId == fixture.homeTeamId) {
                        homeGoalsCount += 1;
                    } else if (event.teamId == fixture.awayTeamId) {
                        awayGoalsCount += 1;
                    }
                };
                case 10 {
                    if (event.teamId == fixture.homeTeamId) {
                        awayGoalsCount += 1;
                    } else if (event.teamId == fixture.awayTeamId) {
                        homeGoalsCount += 1;
                    }
                };
                case _ {};  
            };

            let playerId: Nat16 = event.playerId;
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
        
        let playerScoresMap: HashMap.HashMap<Nat16, Int16> = HashMap.HashMap<Nat16, Int16>(200, Utilities.eqNat16, Utilities.hashNat16);
        for ((playerId, events) in playerEventsMap.entries()) {
            var currentPlayer = await getPlayer(playerId);

            let totalScore = Array.foldLeft<T.PlayerEventData, Int16>(
                events, 
                0,
                func (acc: Int16, event: T.PlayerEventData) : Int16 {
                    return acc + calculateIndividualScoreForEvent(event, currentPlayer.position);
                }
            );

            let aggregateScore = calculateAggregatePlayerEvents(events, currentPlayer.position);       
            playerScoresMap.put(playerId, totalScore + aggregateScore);
        };


        for ((playerId, score) in playerScoresMap.entries()) {
            
            let player = await getPlayer(playerId);
            var updatedSeasons: List.List<T.PlayerSeason> = List.nil<T.PlayerSeason>();
            let playerSpecificEvents = playerEventsMap.get(playerId);
            switch(playerSpecificEvents){
                case (null) {};
                case (?foundEvents){
                    if(player.seasons == null){ 
                        let newGameweek: T.PlayerGameweek = {
                            number = gameweek;
                            events = List.fromArray<T.PlayerEventData>(foundEvents);
                            points = score;
                        };
                        let newSeason: T.PlayerSeason = {
                            id = seasonId;
                            gameweeks = List.fromArray<T.PlayerGameweek>([newGameweek]);
                        };
                        updatedSeasons := List.fromArray<T.PlayerSeason>([newSeason]);
                    } else { 
                        let currentSeason = List.find<T.PlayerSeason>(player.seasons, func (s: T.PlayerSeason) : Bool {
                            s.id == seasonId
                        });

                        if (currentSeason == null) {
                            let newGameweek: T.PlayerGameweek = {
                                number = gameweek;
                                events = List.fromArray<T.PlayerEventData>(foundEvents);
                                points = score;
                            };
                            let newSeason: T.PlayerSeason = {
                                id = seasonId;
                                gameweeks = List.fromArray<T.PlayerGameweek>([newGameweek]);
                            };
                            updatedSeasons := List.append<T.PlayerSeason>(player.seasons, List.fromArray<T.PlayerSeason>([newSeason]));

                        } else {
                            updatedSeasons := List.map<T.PlayerSeason, T.PlayerSeason>(player.seasons, func (season: T.PlayerSeason) : T.PlayerSeason {
                                
                                if (season.id != seasonId) {
                                    return season;
                                };

                                let currentGameweek = List.find<T.PlayerGameweek>(season.gameweeks, func (gw: T.PlayerGameweek) : Bool {
                                    gw.number == gameweek
                                });

                                if (currentGameweek == null) {
                                    let newGameweek: T.PlayerGameweek = {
                                        number = gameweek;
                                        events = List.fromArray<T.PlayerEventData>(foundEvents);
                                        points = score;
                                    };
                                    let updatedGameweeks = List.append<T.PlayerGameweek>(season.gameweeks, List.fromArray<T.PlayerGameweek>([newGameweek]));
                                    let updatedSeason: T.PlayerSeason = {
                                        id = season.id;
                                        gameweeks = List.append<T.PlayerGameweek>(season.gameweeks, List.fromArray<T.PlayerGameweek>([newGameweek]));
                                    };
                                    return updatedSeason;
                                } else {
                                    let updatedGameweeks = List.map<T.PlayerGameweek, T.PlayerGameweek>(
                                        season.gameweeks,
                                        func (gw: T.PlayerGameweek) : T.PlayerGameweek {
                                            if (gw.number != gameweek) {
                                                return gw;
                                            };
                                            return {
                                                number = gw.number;
                                                events = List.append<T.PlayerEventData>(gw.events, List.fromArray(foundEvents));
                                                points = score;
                                            };
                                        }
                                    );
                                    return {
                                        id = season.id;
                                        gameweeks = updatedGameweeks;
                                    };
                                }
                            });
                        }
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
                parentTeamId = player.parentTeamId;
                isInjured = player.isInjured;
                injuryHistory = player.injuryHistory;
                retirementDate = player.retirementDate;
                transferHistory = player.transferHistory;
            };
         
            players := List.map<T.Player, T.Player>(players, func (p: T.Player): T.Player {
                if (p.id == updatedPlayer.id) { updatedPlayer } else { p }
            });
        };
        
        var highestScore: Int16 = 0;
        var highestScoringPlayerId: Nat16 = 0;
        var isUniqueHighScore: Bool = true; 
        let uniquePlayerIdsBuffer = Buffer.fromArray<Nat16>([]);

        for (event in List.toIter(fixture.events)) {
            if (not Buffer.contains<Nat16>(uniquePlayerIdsBuffer, event.playerId, func (a: Nat16, b: Nat16): Bool { a == b })) {
                uniquePlayerIdsBuffer.add(event.playerId);
            };
        };

        let uniquePlayerIds = Buffer.toArray<Nat16>(uniquePlayerIdsBuffer);

        for (j in Iter.range(0, Array.size(uniquePlayerIds)-1)) {  
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

        var newHighScoringPlayerId: Nat16 = 0;
        if(isUniqueHighScore){
            newHighScoringPlayerId := highestScoringPlayerId;
        };
        let updatedFixture = {
            id = fixture.id;
            seasonId = fixture.seasonId;
            gameweek = fixture.gameweek;
            homeTeamId = fixture.homeTeamId;
            awayTeamId = fixture.awayTeamId;
            kickOff = fixture.kickOff;
            homeGoals = homeGoalsCount;
            awayGoals = awayGoalsCount;
            status = fixture.status;
            events = fixture.events;
            highestScoringPlayerId = newHighScoringPlayerId;
        };

        //add the highest scoring player id to the player canister players events
        
        let highestScoringPlayer = await getPlayer(newHighScoringPlayerId);
        players := List.map<T.Player, T.Player>(players, func (p: T.Player): T.Player {
            if(p.id == newHighScoringPlayerId){

                let updatedSeasons = List.map<T.PlayerSeason, T.PlayerSeason>(p.seasons, func(s: T.PlayerSeason) : T.PlayerSeason {

                    if(s.id == seasonId){
                        return {
                            id = s.id;
                            gameweeks = List.map<T.PlayerGameweek, T.PlayerGameweek>(s.gameweeks, func(playerGameweek: T.PlayerGameweek) : T.PlayerGameweek {
                                

                                let newEvent: T.PlayerEventData = {
                                    fixtureId = fixture.id; 
                                    playerId = newHighScoringPlayerId;
                                    eventType = 11;
                                    eventStartMinute = 90;
                                    eventEndMinute = 90;
                                    teamId = highestScoringPlayer.teamId;
                                };

                                let updatedEvents: List.List<T.PlayerEventData> = List.append(playerGameweek.events, List.fromArray([newEvent]));
                                
                                if(playerGameweek.number == gameweek){
                                    return {
                                        number = playerGameweek.number;
                                        events = updatedEvents;
                                        points = playerGameweek.points + 25;
                                    }
                                } else { return playerGameweek; };    
                            });
                    };
                    } else { return s; }
                });

                let adjustedPlayer: T.Player = {
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
                    parentTeamId = p.parentTeamId;
                    isInjured = p.isInjured;
                    injuryHistory = p.injuryHistory;
                    retirementDate = p.retirementDate;
                    transferHistory = p.transferHistory;
                };

            } else {return p};
        });
        
        await updateHashForCategory("players");
        await updateHashForCategory("playerEventData");
        return updatedFixture;
    };

    func calculateAggregatePlayerEvents(events: [T.PlayerEventData], playerPosition: Nat8): Int16 {
        var totalScore: Int16 = 0;

        if (playerPosition == 0 or playerPosition == 1) {
            let goalsConcededCount = Array.filter<T.PlayerEventData>(
                events,
                func (event: T.PlayerEventData): Bool { event.eventType == 3 }
            ).size();

            if (goalsConcededCount >= 2) {
                
                totalScore += (Int16.fromNat16(Nat16.fromNat(goalsConcededCount)) / 2) * -15;
            }
        };


        if (playerPosition == 0) {
            let savesCount = Array.filter<T.PlayerEventData>(
                events,
                func (event: T.PlayerEventData): Bool { event.eventType == 4 }
            ).size();

            totalScore += (Int16.fromNat16(Nat16.fromNat(savesCount)) / 3) * 5;
        };

        return totalScore;
    };

    func calculateIndividualScoreForEvent(event: T.PlayerEventData, playerPosition: Nat8) : Int16 {
        switch (event.eventType) {
            case 0 { return 5; };  // Appearing in the game
            case 1 { 
                switch (playerPosition) {
                    case 3 { return 10; };
                    case 2 { return 15; };
                    case _ { return 20; };  // Goalkeeper or defender
                }
            };  
            case 2 { 
                switch (playerPosition) {
                    case 3 { return 10; };
                    case 2 { return 10; };
                    case _ { return 15; };  // Goalkeeper or defender
                }
            };  
            case 4 { return 0; };
            case 5 { 
                switch (playerPosition) {
                    case 0 { return 10; };
                    case 1 { return 10; };
                    case _ { return 0; };
                }
            };
            case 6 { return 20; };  // Goalkeeper saves a penalty
            case 7 { return -15; };  // Player misses a penalty
            case 8 { return -5; };   // Yellow Card
            case 9 { return -20; };  // Red Card
            case 10 { return -10; };  // Own Goal
            case 11 { return 0; };  // Handled after all players calculated
            case _ { return 0; };
        };
    };
    
    public shared func transferPlayer(playerId: T.PlayerId, newTeamId: T.TeamId, currentSeasonId: T.SeasonId, currentGameweek: T.GameweekNumber) : async () {
        let player = List.find<T.Player>(players, func(p: T.Player) { p.id == playerId });
        switch(player){
            case (null) { };
            case (?p) {

                let newTransferHistoryEntry: T.TransferHistory = {
                    transferDate = Time.now();
                    transferGameweek = currentGameweek;
                    transferSeason = currentSeasonId;
                    fromTeam = p.teamId;
                    toTeam = newTeamId;
                    loanEndDate = 0;
                };

                let updatedPlayer: T.Player = {
                    id = p.id;
                    teamId = newTeamId;
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
                    retirementDate = p.retirementDate;
                    transferHistory = List.append<T.TransferHistory>(p.transferHistory, List.fromArray([newTransferHistoryEntry]));
                };
                players := List.map<T.Player, T.Player>(players, func(currentPlayer: T.Player) : T.Player {
                    if (currentPlayer.id == updatedPlayer.id) {
                        return updatedPlayer;
                    } else {
                        return currentPlayer;
                    }
                });
            };
        };
    };

    public shared func loanPlayer(playerId: T.PlayerId, loanTeamId: T.TeamId, loanEndDate: Int, currentSeasonId: T.SeasonId, currentGameweek: T.GameweekNumber) : async () {
        let playerToLoan = List.find<T.Player>(players, func(p: T.Player) { p.id == playerId });
        switch(playerToLoan) {
            case (null) { };
            case (?p) {
                
                let newTransferHistoryEntry: T.TransferHistory = {
                    transferDate = Time.now();
                    transferGameweek = currentGameweek;
                    transferSeason = currentSeasonId;
                    fromTeam = p.teamId;
                    toTeam = loanTeamId;
                    loanEndDate = loanEndDate;
                };
        
        
                let loanedPlayer: T.Player = {
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

                players := List.map<T.Player, T.Player>(players, func(currentPlayer: T.Player) : T.Player {
                    if (currentPlayer.id == loanedPlayer.id) {
                        return loanedPlayer;
                    } else {
                        return currentPlayer;
                    }
                });
                
                let loanTimerDuration = #nanoseconds (Int.abs((loanEndDate - Time.now())));
                await setAndBackupTimer(loanTimerDuration, "loanExpired", playerId);
            };
        };
    };
  
    private func setAndBackupTimer(duration: Timer.Duration, callbackName: Text, playerId: T.PlayerId) : async () {
        let jobId: Timer.TimerId = switch(callbackName) {
            case "loanExpired" {
                Timer.setTimer(duration, loanExpiredCallback);
            };
            case _ {
                Timer.setTimer(duration, defaultCallback);
            }
        };

        let triggerTime = switch (duration) {
            case (#seconds s) {
                Time.now() + s * 1_000_000_000;
            };
            case (#nanoseconds ns) {
                Time.now() + ns;
            };
        };

        let timerInfo: T.TimerInfo = {
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

    private func loanExpiredCallback() : async (){
        let currentTime = Time.now();

        for (timer in Iter.fromArray(stable_timers)) {
            if (timer.triggerTime <= currentTime and timer.callbackName == "loanExpired") {
                let playerToReturn = List.find<T.Player>(players, func(p: T.Player) { p.id == timer.playerId });
                
                switch(playerToReturn) {
                    case (null) { }; 
                    case (?p) {
                        if(p.parentTeamId == 0){
                            //move player to former players
                            formerPlayers := List.append(formerPlayers, List.fromArray([p]));

                            players := List.filter<T.Player>(players, func(player: T.Player) : Bool {
                                return player.id != p.id;
                            });
                        }
                        else{
                            //update existing player
                            players := List.map<T.Player, T.Player>(players, func(currentPlayer: T.Player) : T.Player {
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
                                }
                            });

                        };

                    };
                };
            }
        };

        stable_timers := Array.filter<T.TimerInfo>(stable_timers, func(timer: T.TimerInfo) : Bool {
            return timer.triggerTime > currentTime;
        });
    };

    private func defaultCallback() : async () { };

    public shared func recallPlayer(playerId: T.PlayerId) : async () {
        let playerToRecall = List.find<T.Player>(players, func(p: T.Player) { p.id == playerId });
        switch(playerToRecall) {
            case (null) { };
            case (?p) {
                if (p.onLoan) {
                    let returnedPlayer: T.Player = {
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

                    players := List.map<T.Player, T.Player>(players, func(currentPlayer: T.Player) : T.Player {
                        if (currentPlayer.id == returnedPlayer.id) {
                            return returnedPlayer;
                        } else {
                            return currentPlayer;
                        }
                    });

                    stable_timers := Array.filter<T.TimerInfo>(stable_timers, func(timer: T.TimerInfo) : Bool {
                        return timer.playerId != returnedPlayer.id;
                    });
                }
            };
        };
    };


    public shared func createPlayer(teamId: T.TeamId, position: Nat8, firstName: Text, lastName: Text, shirtNumber: Nat8, value: Nat, dateOfBirth: Int, nationality: Text) : async () {
        let newPlayer: T.Player = {
            id = Nat16.fromNat(nextPlayerId + 1);
            teamId = teamId;
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
            parentTeamId = 0;
            isInjured = false;
            injuryHistory = List.nil<T.InjuryHistory>();
            retirementDate = 0;
            transferHistory = List.nil<T.TransferHistory>();
        };
        players := List.push(newPlayer, players);
        nextPlayerId += 1;
    };

    public shared func updatePlayer(playerId: T.PlayerId, position: Nat8, firstName: Text, lastName: Text, shirtNumber: Nat8, dateOfBirth: Int, nationality: Text) : async () {
        players := List.map<T.Player, T.Player>(players, func(currentPlayer: T.Player) : T.Player {
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
                    parentTeamId = currentPlayer.parentTeamId;
                    isInjured = currentPlayer.isInjured;
                    injuryHistory = currentPlayer.injuryHistory;
                    retirementDate = currentPlayer.retirementDate;
                    transferHistory = currentPlayer.transferHistory;
                };
            } else {
                return currentPlayer;
            }
        });
    };
    
    public shared func setPlayerInjury(playerId: T.PlayerId, description: Text, expectedEndDate: Int) : async () {
        players := List.map<T.Player, T.Player>(players, func(currentPlayer: T.Player) : T.Player {
            if (currentPlayer.id == playerId) {

                if(expectedEndDate <= Time.now()){
                    let updatedInjuryHistory = List.map<T.InjuryHistory, T.InjuryHistory>(currentPlayer.injuryHistory, func(injury: T.InjuryHistory) : T.InjuryHistory {
                        if (injury.expectedEndDate > Time.now()) {
                            return {
                                description = injury.description;
                                injuryStartDate = injury.injuryStartDate;
                                expectedEndDate = Time.now();
                            };
                        } else {
                            return injury;
                        }
                    });

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
                        parentTeamId = currentPlayer.parentTeamId;
                        isInjured = false;
                        injuryHistory = updatedInjuryHistory;
                        retirementDate = currentPlayer.retirementDate;
                        transferHistory = currentPlayer.transferHistory;
                    };
                } else {
                    let newInjury: T.InjuryHistory = {
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
                        parentTeamId = currentPlayer.parentTeamId;
                        isInjured = true;
                        injuryHistory = List.push(newInjury, currentPlayer.injuryHistory);
                        retirementDate = currentPlayer.retirementDate;
                        transferHistory = currentPlayer.transferHistory;
                    };
                }
            } else {
                return currentPlayer;
            }
        });
    };
    
    public shared func retirePlayer(playerId: T.PlayerId, retirementDate: Int) : async () {
        let playerToRetire = List.find<T.Player>(players, func(p: T.Player) { p.id == playerId });
        switch(playerToRetire) {
            case (null) { };
            case (?p) {
                let retiredPlayer: T.Player = {
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
                    retirementDate = retirementDate;
                    transferHistory = p.transferHistory;
                };
                
                retiredPlayers := List.push(retiredPlayer, retiredPlayers);
                players := List.filter<T.Player>(players, func(currentPlayer: T.Player) : Bool {
                    return currentPlayer.id != playerId;
                });
                await updateHashForCategory("players");
            };
        };
    };

    public shared func unretirePlayer(playerId: T.PlayerId) : async () {
        let playerToUnretire = List.find<T.Player>(retiredPlayers, func(p: T.Player) { p.id == playerId });
        switch(playerToUnretire) {
            case (null) { };
            case (?p) {
                let activePlayer: T.Player = {
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
                retiredPlayers := List.filter<T.Player>(retiredPlayers, func(currentPlayer: T.Player) : Bool {
                    return currentPlayer.id != playerId;
                });
            };
        };
    };
    
    public shared query ({caller}) func getRetiredPlayer(surname: Text) : async [T.Player] {
        let retiredPlayers = List.filter<T.Player>(players, func(player: T.Player) : Bool {
           return Text.equal(player.lastName, surname) and player.retirementDate > 0;
        });
        return List.toArray(retiredPlayers);
    };

    public shared query func getDataHashes() : async [T.DataCache] {
        return List.toArray(dataCacheHashes);
    };

    private stable var stable_players: [T.Player] = [];
    private stable var stable_next_player_id : Nat = 0;
    private stable var stable_timers: [T.TimerInfo] = [];
    private stable var stable_data_cache_hashes: [T.DataCache] = [];

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

    private func recreateTimers(){
        let currentTime = Time.now();
        for (timerInfo in Iter.fromArray(stable_timers)) {
            let remainingDuration = timerInfo.triggerTime - currentTime;

            if (remainingDuration > 0) { 
                let duration: Timer.Duration =  #nanoseconds(Int.abs(remainingDuration));

                switch(timerInfo.callbackName) {
                    case "loanExpired" {
                        ignore Timer.setTimer(duration, loanExpiredCallback);
                    };
                    case _ {
                        ignore Timer.setTimer(duration, defaultCallback);
                    };
                };
            }
        }
    };

    public shared func updatePlayerEventDataCache() : async (){
        await updateHashForCategory("playerEventData");
    };

    public func updateHashForCategory(category: Text): async () {
        
        let hashBuffer = Buffer.fromArray<T.DataCache>([]);

        for(hashObj in Iter.fromList(dataCacheHashes)){
            if(hashObj.category == category){
            let randomHash = await SHA224.getRandomHash();
            hashBuffer.add({ category = hashObj.category; hash = randomHash; });
            } else { hashBuffer.add(hashObj); };
        };

        dataCacheHashes := List.fromArray(Buffer.toArray<T.DataCache>(hashBuffer));
    };

    public shared func setDefaultHashes(): async () {
        dataCacheHashes := List.fromArray([
            { category = "players"; hash = "DEFAULT_VALUE" },
            { category = "playerEventData"; hash = "DEFAULT_VALUE" }
        ]);
    };

    public func reuploadPlayers(): async (){
        players := List.fromArray<T.Player>([
            {id = 1; teamId = 1; firstName = "Aaron"; lastName = "Ramsdale"; shirtNumber = 1; value = 56; dateOfBirth = 895104000000000000; nationality = "England"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 2; teamId = 1; firstName = "Matt"; lastName = "Turner"; shirtNumber = 30; value = 14; dateOfBirth = 772416000000000000; nationality = "United States"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 3; teamId = 1; firstName = "Rúnar "; lastName = "Rúnarsson"; shirtNumber = 13; value = 22; dateOfBirth = 793065600000000000; nationality = "Iceland"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 4; teamId = 1; firstName = "William"; lastName = "Saliba"; shirtNumber = 12; value = 60; dateOfBirth = 985392000000000000; nationality = "France"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 5; teamId = 1; firstName = "Gabriel"; lastName = "Magalhães"; shirtNumber = 6; value = 72; dateOfBirth = 882489600000000000; nationality = "Brazil"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 6; teamId = 1; firstName = "Jakub"; lastName = "Kiwior"; shirtNumber = 15; value = 22; dateOfBirth = 950572800000000000; nationality = "Poland"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 7; teamId = 1; firstName = "Rob"; lastName = "Holding"; shirtNumber = 16; value = 30; dateOfBirth = 811555200000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 8; teamId = 1; firstName = "Auston"; lastName = "Trusty"; shirtNumber = 16; value = 22; dateOfBirth = 902880000000000000; nationality = "United States"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 9; teamId = 1; firstName = "Oleksandr"; lastName = "Zinchenko"; shirtNumber = 35; value = 64; dateOfBirth = 850608000000000000; nationality = "Ukraine"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 10; teamId = 1; firstName = "Kieran"; lastName = "Tierney"; shirtNumber = 3; value = 46; dateOfBirth = 865468800000000000; nationality = "Scotland"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 11; teamId = 1; firstName = "Nuno"; lastName = "Tavares"; shirtNumber = 0; value = 22; dateOfBirth = 948844800000000000; nationality = "Portugal"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 12; teamId = 1; firstName = "Cédric"; lastName = "Soares"; shirtNumber = 17; value = 22; dateOfBirth = 683596800000000000; nationality = "Portugal"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 13; teamId = 1; firstName = "Ben"; lastName = "White"; shirtNumber = 4; value = 64; dateOfBirth = 876268800000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 14; teamId = 1; firstName = "Takehiro"; lastName = "Tomiyasu"; shirtNumber = 18; value = 30; dateOfBirth = 910224000000000000; nationality = "Japan"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 15; teamId = 1; firstName = "Thomas"; lastName = "Partey"; shirtNumber = 5; value = 50; dateOfBirth = 739929600000000000; nationality = "Ghana"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 16; teamId = 1; firstName = ""; lastName = "Jorginho"; shirtNumber = 20; value = 92; dateOfBirth = 693187200000000000; nationality = "Italy"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 17; teamId = 1; firstName = "Mohamed"; lastName = "Elneny"; shirtNumber = 25; value = 26; dateOfBirth = 710812800000000000; nationality = "Egypt"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 18; teamId = 1; firstName = "Declan"; lastName = "Rice"; shirtNumber = 41; value = 84; dateOfBirth = 916272000000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 19; teamId = 1; firstName = "Martin"; lastName = "Ødegaard"; shirtNumber = 8; value = 144; dateOfBirth = 913852800000000000; nationality = "Norway"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 20; teamId = 1; firstName = "Emile"; lastName = "Smith Rowe"; shirtNumber = 10; value = 88; dateOfBirth = 964742400000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 21; teamId = 1; firstName = "Fábio"; lastName = "Vieira"; shirtNumber = 21; value = 88; dateOfBirth = 959644800000000000; nationality = "Portugal"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 22; teamId = 1; firstName = "Bukayo"; lastName = "Saka"; shirtNumber = 7; value = 190; dateOfBirth = 999648000000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 23; teamId = 1; firstName = ""; lastName = "Marquinhos"; shirtNumber = 27; value = 42; dateOfBirth = 1049673600000000000; nationality = "Brazil"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 24; teamId = 1; firstName = "Reiss"; lastName = "Nelson"; shirtNumber = 24; value = 50; dateOfBirth = 944784000000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 25; teamId = 1; firstName = "Albert"; lastName = "Lokonga"; shirtNumber = 23; value = 64; dateOfBirth = 940550400000000000; nationality = "Belgium"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 26; teamId = 1; firstName = "Kai"; lastName = "Havertz"; shirtNumber = 29; value = 164; dateOfBirth = 929059200000000000; nationality = "Germany"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 27; teamId = 1; firstName = "Gabriel"; lastName = "Jesus"; shirtNumber = 9; value = 194; dateOfBirth = 860025600000000000; nationality = "Brazil"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 28; teamId = 1; firstName = "Gabriel"; lastName = "Martinelli"; shirtNumber = 11; value = 126; dateOfBirth = 992822400000000000; nationality = "Brazil"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 29; teamId = 1; firstName = "Leandro"; lastName = "Trossard"; shirtNumber = 19; value = 130; dateOfBirth = 786499200000000000; nationality = "Belgium"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 30; teamId = 1; firstName = "Eddie"; lastName = "Nketiah"; shirtNumber = 14; value = 118; dateOfBirth = 928022400000000000; nationality = "England"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 31; teamId = 2; firstName = "Emiliano"; lastName = "Martínez"; shirtNumber = 1; value = 64; dateOfBirth = 715392000000000000; nationality = "Argentina"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 32; teamId = 2; firstName = "Robin"; lastName = "Olsen"; shirtNumber = 25; value = 18; dateOfBirth = 631756800000000000; nationality = "Sweden"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 33; teamId = 2; firstName = "Ezri"; lastName = "Konsa"; shirtNumber = 4; value = 38; dateOfBirth = 877564800000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 34; teamId = 2; firstName = "Tyrone"; lastName = "Mings"; shirtNumber = 5; value = 50; dateOfBirth = 731980800000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 35; teamId = 2; firstName = "Diego"; lastName = "Carlos"; shirtNumber = 3; value = 50; dateOfBirth = 732153600000000000; nationality = "Brazil"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 36; teamId = 2; firstName = "Pau"; lastName = "Torres"; shirtNumber = 0; value = 22; dateOfBirth = 853372800000000000; nationality = "Spain"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 37; teamId = 2; firstName = "Calum"; lastName = "Chambers"; shirtNumber = 16; value = 30; dateOfBirth = 790560000000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 38; teamId = 2; firstName = "Kortney"; lastName = "Hause"; shirtNumber = 30; value = 22; dateOfBirth = 805852800000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 39; teamId = 2; firstName = "Álex"; lastName = "Moreno"; shirtNumber = 15; value = 42; dateOfBirth = 739497600000000000; nationality = "Spain"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 40; teamId = 2; firstName = "Lucas"; lastName = "Digne"; shirtNumber = 27; value = 42; dateOfBirth = 869356800000000000; nationality = "France"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 41; teamId = 2; firstName = "Matty"; lastName = "Cash"; shirtNumber = 2; value = 46; dateOfBirth = 870912000000000000; nationality = "Poland"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 42; teamId = 2; firstName = "Boubacar"; lastName = "Kamara"; shirtNumber = 44; value = 50; dateOfBirth = 943315200000000000; nationality = "France"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 43; teamId = 2; firstName = "Leander"; lastName = "Dendoncker"; shirtNumber = 32; value = 50; dateOfBirth = 797904000000000000; nationality = "Belgium"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 44; teamId = 2; firstName = "Youri"; lastName = "Tielemans"; shirtNumber = 8; value = 106; dateOfBirth = 862963200000000000; nationality = "Belgium"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 45; teamId = 2; firstName = "Jacob"; lastName = "Ramsey"; shirtNumber = 41; value = 68; dateOfBirth = 991008000000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 46; teamId = 2; firstName = "Douglas"; lastName = "Luiz"; shirtNumber = 6; value = 56; dateOfBirth = 894672000000000000; nationality = "Brazil"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 47; teamId = 2; firstName = "John"; lastName = "McGinn"; shirtNumber = 7; value = 68; dateOfBirth = 782438400000000000; nationality = "Scotland"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 48; teamId = 2; firstName = "Tim"; lastName = "Iroegbunam"; shirtNumber = 47; value = 42; dateOfBirth = 1056931200000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 49; teamId = 2; firstName = "Leon"; lastName = "Bailey"; shirtNumber = 31; value = 34; dateOfBirth = 871084800000000000; nationality = "Jamaica"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 50; teamId = 2; firstName = "Philippe"; lastName = "Coutinho"; shirtNumber = 23; value = 130; dateOfBirth = 708307200000000000; nationality = "Brazil"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 51; teamId = 2; firstName = "Emiliano"; lastName = "Buendía"; shirtNumber = 10; value = 92; dateOfBirth = 851472000000000000; nationality = "Argentina"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 52; teamId = 2; firstName = "Jaden"; lastName = "Philogene"; shirtNumber = 33; value = 42; dateOfBirth = 1013126400000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 53; teamId = 2; firstName = "Bertrand"; lastName = "Traoré"; shirtNumber = 9; value = 60; dateOfBirth = 810345600000000000; nationality = "Burkina Faso"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 54; teamId = 2; firstName = "Moussa"; lastName = "Diaby"; shirtNumber = 19; value = 126; dateOfBirth = 931305600000000000; nationality = "France"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 55; teamId = 2; firstName = "Ollie"; lastName = "Watkins"; shirtNumber = 11; value = 160; dateOfBirth = 820281600000000000; nationality = "England"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 56; teamId = 2; firstName = "Jhon"; lastName = "Durán"; shirtNumber = 22; value = 84; dateOfBirth = 1071273600000000000; nationality = "Colombia"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 57; teamId = 2; firstName = "Cameron"; lastName = "Archer"; shirtNumber = 35; value = 42; dateOfBirth = 1007856000000000000; nationality = "England"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 58; teamId = 2; firstName = "Keinan"; lastName = "Davis"; shirtNumber = 39; value = 64; dateOfBirth = 887328000000000000; nationality = "England"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 59; teamId = 3; firstName = ""; lastName = "Neto"; shirtNumber = 13; value = 42; dateOfBirth = 616809600000000000; nationality = "Brazil"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 60; teamId = 3; firstName = "Darren"; lastName = "Randolph"; shirtNumber = 12; value = 22; dateOfBirth = 547776000000000000; nationality = "Ireland"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 61; teamId = 3; firstName = "Ionuț"; lastName = "Radu"; shirtNumber = 0; value = 42; dateOfBirth = 864777600000000000; nationality = "Bournemouth"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 62; teamId = 3; firstName = "Marcos"; lastName = "Senesi"; shirtNumber = 25; value = 38; dateOfBirth = 863222400000000000; nationality = "Argentina"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 63; teamId = 3; firstName = "Ilya"; lastName = "Zabarnyi"; shirtNumber = 27; value = 42; dateOfBirth = 907632000000000000; nationality = "Ukraine"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 64; teamId = 3; firstName = "Lloyd"; lastName = "Kelly"; shirtNumber = 5; value = 34; dateOfBirth = 907632000000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 65; teamId = 3; firstName = "Chris"; lastName = "Mepham"; shirtNumber = 6; value = 34; dateOfBirth = 878688000000000000; nationality = "Wales"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 66; teamId = 3; firstName = "James"; lastName = "Hill"; shirtNumber = 0; value = 22; dateOfBirth = 1010620800000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 67; teamId = 3; firstName = "Ryan"; lastName = "Fredericks"; shirtNumber = 2; value = 38; dateOfBirth = 718675200000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 68; teamId = 3; firstName = "Adam"; lastName = "Smith"; shirtNumber = 15; value = 34; dateOfBirth = 672883200000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 69; teamId = 3; firstName = "Milos"; lastName = "Kerkez"; shirtNumber = 0; value = 42; dateOfBirth = 1068163200000000000; nationality = "Hungary"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 70; teamId = 3; firstName = "Philip"; lastName = "Billing"; shirtNumber = 29; value = 64; dateOfBirth = 834451200000000000; nationality = "Denmark"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 71; teamId = 3; firstName = "Lewis"; lastName = "Cook"; shirtNumber = 4; value = 60; dateOfBirth = 854928000000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 72; teamId = 3; firstName = "David"; lastName = "Brooks"; shirtNumber = 7; value = 76; dateOfBirth = 868320000000000000; nationality = "Wales"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 73; teamId = 3; firstName = "Ryan"; lastName = "Christie"; shirtNumber = 10; value = 76; dateOfBirth = 761875200000000000; nationality = "Scotland"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 74; teamId = 3; firstName = "Joe"; lastName = "Rothwell"; shirtNumber = 14; value = 60; dateOfBirth = 789782400000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 75; teamId = 3; firstName = "Marcus"; lastName = "Tavernier"; shirtNumber = 16; value = 50; dateOfBirth = 922060800000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 76; teamId = 3; firstName = "Hamed"; lastName = "Traorè"; shirtNumber = 22; value = 42; dateOfBirth = 950659200000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 77; teamId = 3; firstName = "Gavin"; lastName = "Kilkenny"; shirtNumber = 26; value = 42; dateOfBirth = 949363200000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 78; teamId = 3; firstName = "Dominic"; lastName = "Solanke"; shirtNumber = 9; value = 88; dateOfBirth = 874195200000000000; nationality = "England"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 79; teamId = 3; firstName = "Dango"; lastName = "Ouattara"; shirtNumber = 11; value = 64; dateOfBirth = 1013385600000000000; nationality = "Burkina Faso"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 80; teamId = 3; firstName = "Kieffer"; lastName = "Moore"; shirtNumber = 21; value = 60; dateOfBirth = 713232000000000000; nationality = "Wales"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 81; teamId = 3; firstName = "Antoine"; lastName = "Semenyo"; shirtNumber = 24; value = 22; dateOfBirth = 947203200000000000; nationality = "Ghana"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 82; teamId = 3; firstName = "Jaidon"; lastName = "Anthony"; shirtNumber = 32; value = 72; dateOfBirth = 944006400000000000; nationality = "England"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 83; teamId = 3; firstName = "Emiliano"; lastName = "Marcondes"; shirtNumber = 0; value = 64; dateOfBirth = 794707200000000000; nationality = "Denmark"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 84; teamId = 3; firstName = "Jamal"; lastName = "Lowe"; shirtNumber = 0; value = 64; dateOfBirth = 774748800000000000; nationality = "Jamaica"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 85; teamId = 3; firstName = "Justin"; lastName = "Kluivert"; shirtNumber = 0; value = 64; dateOfBirth = 925862400000000000; nationality = "Netherlands"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 86; teamId = 4; firstName = "David"; lastName = "Raya"; shirtNumber = 1; value = 56; dateOfBirth = 811123200000000000; nationality = "Spain"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 87; teamId = 4; firstName = "Ellery"; lastName = "Balcombe"; shirtNumber = 0; value = 22; dateOfBirth = 939945600000000000; nationality = "England"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 88; teamId = 4; firstName = "Mark"; lastName = "Flekken"; shirtNumber = 0; value = 22; dateOfBirth = 739929600000000000; nationality = "Netherlands"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 89; teamId = 4; firstName = "Thomas"; lastName = "Strakosha"; shirtNumber = 22; value = 34; dateOfBirth = 795571200000000000; nationality = "Albania"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 90; teamId = 4; firstName = "Kristoffer"; lastName = "Ajer"; shirtNumber = 20; value = 42; dateOfBirth = 892771200000000000; nationality = "Norway"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 91; teamId = 4; firstName = "Ethan"; lastName = "Pinnock"; shirtNumber = 5; value = 38; dateOfBirth = 738633600000000000; nationality = "Jamaica"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 92; teamId = 4; firstName = "Ben"; lastName = "Mee"; shirtNumber = 16; value = 56; dateOfBirth = 622339200000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 93; teamId = 4; firstName = "Mathias"; lastName = "Jorgensen"; shirtNumber = 13; value = 22; dateOfBirth = 640828800000000000; nationality = "Netherlands"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 94; teamId = 4; firstName = "Mads"; lastName = "Sørensen"; shirtNumber = 29; value = 22; dateOfBirth = 915667200000000000; nationality = "Denmark"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 95; teamId = 4; firstName = "Charlie"; lastName = "Goode"; shirtNumber = 0; value = 22; dateOfBirth = 807408000000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 96; teamId = 4; firstName = "Nathan"; lastName = "Collins"; shirtNumber = 0; value = 42; dateOfBirth = 988588800000000000; nationality = "Ireland"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 97; teamId = 4; firstName = "Rico"; lastName = "Henry"; shirtNumber = 3; value = 38; dateOfBirth = 870912000000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 98; teamId = 4; firstName = "Aaron"; lastName = "Hickey"; shirtNumber = 2; value = 60; dateOfBirth = 1023667200000000000; nationality = "Scotland"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 99; teamId = 4; firstName = "Mads"; lastName = "Roerslev"; shirtNumber = 30; value = 34; dateOfBirth = 930182400000000000; nationality = "Denmark"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 100; teamId = 4; firstName = "Vitaly"; lastName = "Janelt"; shirtNumber = 27; value = 84; dateOfBirth = 894758400000000000; nationality = "Germany"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 101; teamId = 4; firstName = "Christian"; lastName = "Nörgaard"; shirtNumber = 6; value = 76; dateOfBirth = 763257600000000000; nationality = "Denmark"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 102; teamId = 4; firstName = "Mathias"; lastName = "Jensen"; shirtNumber = 8; value = 56; dateOfBirth = 820454400000000000; nationality = "Denmark"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 103; teamId = 4; firstName = "Josh"; lastName = "Dasilva"; shirtNumber = 10; value = 26; dateOfBirth = 909100800000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 104; teamId = 4; firstName = "Frank"; lastName = "Onyeka"; shirtNumber = 15; value = 56; dateOfBirth = 883612800000000000; nationality = "Nigeria"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 105; teamId = 4; firstName = "Shandon"; lastName = "Baptiste"; shirtNumber = 26; value = 42; dateOfBirth = 891993600000000000; nationality = "Grenada"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 106; teamId = 4; firstName = "Ryan"; lastName = "Trevitt"; shirtNumber = 8; value = 42; dateOfBirth = 1047427200000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 107; teamId = 4; firstName = "Yehor"; lastName = "Yarmolyuk"; shirtNumber = 36; value = 42; dateOfBirth = 1078099200000000000; nationality = "Ukraine"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 108; teamId = 4; firstName = "Mikkel"; lastName = "Damsgaard"; shirtNumber = 24; value = 64; dateOfBirth = 962582400000000000; nationality = "Denmark"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 109; teamId = 4; firstName = "Keane"; lastName = "Lewis-Potter"; shirtNumber = 23; value = 72; dateOfBirth = 982800000000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 110; teamId = 4; firstName = "Bryan"; lastName = "Mbeumo"; shirtNumber = 19; value = 92; dateOfBirth = 933984000000000000; nationality = "Cameroon"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 111; teamId = 4; firstName = "Kevin"; lastName = "Schade"; shirtNumber = 9; value = 60; dateOfBirth = 1006819200000000000; nationality = "Germany"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 112; teamId = 4; firstName = "Sergi"; lastName = "Canós"; shirtNumber = 7; value = 64; dateOfBirth = 854841600000000000; nationality = "Spain"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 113; teamId = 4; firstName = "Yoane"; lastName = "Wissa"; shirtNumber = 11; value = 76; dateOfBirth = 841708800000000000; nationality = "DR Congo"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 114; teamId = 4; firstName = "Ivan"; lastName = "Toney"; shirtNumber = 17; value = 152; dateOfBirth = 826934400000000000; nationality = "England"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 115; teamId = 5; firstName = "Robert"; lastName = "Sánchez"; shirtNumber = 1; value = 38; dateOfBirth = 879811200000000000; nationality = "Spain"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 116; teamId = 5; firstName = "Jason"; lastName = "Steele"; shirtNumber = 23; value = 22; dateOfBirth = 650937600000000000; nationality = "England"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 117; teamId = 5; firstName = "Tom"; lastName = "McGill"; shirtNumber = 38; value = 22; dateOfBirth = 953942400000000000; nationality = "Canada"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 118; teamId = 5; firstName = "Bart"; lastName = "Verbruggen"; shirtNumber = 0; value = 42; dateOfBirth = 1029628800000000000; nationality = "Netherlands"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 119; teamId = 5; firstName = "Adam"; lastName = "Webster"; shirtNumber = 4; value = 42; dateOfBirth = 789177600000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 120; teamId = 5; firstName = "Lewis"; lastName = "Dunk"; shirtNumber = 5; value = 56; dateOfBirth = 690681600000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 121; teamId = 5; firstName = "Igor"; lastName = "Julio"; shirtNumber = 6; value = 42; dateOfBirth = 886809600000000000; nationality = "Brazil"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 122; teamId = 5; firstName = "Pervis"; lastName = "Estupiñán"; shirtNumber = 30; value = 64; dateOfBirth = 885340800000000000; nationality = "Ecuador"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 123; teamId = 5; firstName = "Tariq"; lastName = "Lamptey"; shirtNumber = 2; value = 30; dateOfBirth = 970272000000000000; nationality = "Ghana"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 124; teamId = 5; firstName = "Joël"; lastName = "Veltman"; shirtNumber = 34; value = 46; dateOfBirth = 695433600000000000; nationality = "Netherlands"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 125; teamId = 5; firstName = "Michał"; lastName = "Karbownik"; shirtNumber = 0; value = 22; dateOfBirth = 984441600000000000; nationality = "Poland"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 126; teamId = 5; firstName = "Moisés"; lastName = "Caicedo"; shirtNumber = 25; value = 64; dateOfBirth = 1004659200000000000; nationality = "Ecuador"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 127; teamId = 5; firstName = "Billy"; lastName = "Gilmour"; shirtNumber = 27; value = 30; dateOfBirth = 992217600000000000; nationality = "Scotland"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 128; teamId = 5; firstName = "Jakub"; lastName = "Moder"; shirtNumber = 15; value = 38; dateOfBirth = 923443200000000000; nationality = "Poland"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 129; teamId = 5; firstName = "Pascal"; lastName = "Groß"; shirtNumber = 13; value = 80; dateOfBirth = 676944000000000000; nationality = "Germany"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 130; teamId = 5; firstName = "Yasin"; lastName = "Ayari"; shirtNumber = 26; value = 42; dateOfBirth = 1065398400000000000; nationality = "Sweden"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 131; teamId = 5; firstName = "James"; lastName = "Milner"; shirtNumber = 0; value = 38; dateOfBirth = 505180800000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 132; teamId = 5; firstName = "Mahmoud "; lastName = "Dahoud"; shirtNumber = 0; value = 64; dateOfBirth = 820454400000000000; nationality = "German"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 133; teamId = 5; firstName = "Steven"; lastName = "Alzate"; shirtNumber = 17; value = 42; dateOfBirth = 905212800000000000; nationality = "Colombia"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 134; teamId = 5; firstName = "Facundo"; lastName = "Buonanotte"; shirtNumber = 40; value = 42; dateOfBirth = 1103760000000000000; nationality = "Argentina"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 135; teamId = 5; firstName = "Adam"; lastName = "Lallana"; shirtNumber = 14; value = 56; dateOfBirth = 579225600000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 136; teamId = 5; firstName = "Kaoru"; lastName = "Mitoma"; shirtNumber = 22; value = 92; dateOfBirth = 864086400000000000; nationality = "Japan"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 137; teamId = 5; firstName = "Solly"; lastName = "March"; shirtNumber = 7; value = 72; dateOfBirth = 774662400000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 138; teamId = 5; firstName = "Simon"; lastName = "Adingra"; shirtNumber = 24; value = 64; dateOfBirth = 1009843200000000000; nationality = "Ivory Coast"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 139; teamId = 5; firstName = "Evan"; lastName = "Ferguson"; shirtNumber = 28; value = 46; dateOfBirth = 1098144000000000000; nationality = "Ireland"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 140; teamId = 5; firstName = "Julio"; lastName = "Enciso"; shirtNumber = 20; value = 46; dateOfBirth = 1074816000000000000; nationality = "Paraguay"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 141; teamId = 5; firstName = "Deniz"; lastName = "Undav"; shirtNumber = 21; value = 64; dateOfBirth = 837734400000000000; nationality = "Germany"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 142; teamId = 5; firstName = "Danny"; lastName = "Welbeck"; shirtNumber = 18; value = 126; dateOfBirth = 659577600000000000; nationality = "England"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 143; teamId = 5; firstName = "Aaron"; lastName = "Connolly"; shirtNumber = 0; value = 42; dateOfBirth = 949017600000000000; nationality = "Ireland"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 144; teamId = 7; firstName = "Kepa"; lastName = "Arrizabalaga"; shirtNumber = 1; value = 42; dateOfBirth = 781142400000000000; nationality = "Spain"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 145; teamId = 7; firstName = "Gabriel"; lastName = "Slonina"; shirtNumber = 36; value = 88; dateOfBirth = 1084579200000000000; nationality = "United States"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 146; teamId = 7; firstName = "Marcus"; lastName = "Bettinelli"; shirtNumber = 13; value = 22; dateOfBirth = 706665600000000000; nationality = "England"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 147; teamId = 7; firstName = "Wesley"; lastName = "Fofana"; shirtNumber = 33; value = 34; dateOfBirth = 977011200000000000; nationality = "France"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 148; teamId = 7; firstName = "Benoît"; lastName = "Badiashile"; shirtNumber = 4; value = 64; dateOfBirth = 985564800000000000; nationality = "France"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 149; teamId = 7; firstName = "Trevoh"; lastName = "Chalobah"; shirtNumber = 14; value = 38; dateOfBirth = 931132800000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 150; teamId = 7; firstName = "Levi"; lastName = "Colwill"; shirtNumber = 0; value = 38; dateOfBirth = 1046217600000000000; nationality = "Senegal"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 151; teamId = 7; firstName = "Thiago"; lastName = "Silva"; shirtNumber = 6; value = 80; dateOfBirth = 464659200000000000; nationality = "Brazil"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 152; teamId = 7; firstName = "Ben"; lastName = "Chilwell"; shirtNumber = 21; value = 88; dateOfBirth = 851126400000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 153; teamId = 7; firstName = "Marc"; lastName = "Cucurella"; shirtNumber = 32; value = 60; dateOfBirth = 901065600000000000; nationality = "Spain"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 154; teamId = 7; firstName = "Lewis"; lastName = "Hall"; shirtNumber = 67; value = 34; dateOfBirth = 1094601600000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 155; teamId = 7; firstName = "Malang"; lastName = "Sarr"; shirtNumber = 0; value = 30; dateOfBirth = 917049600000000000; nationality = "France"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 156; teamId = 7; firstName = "Reece"; lastName = "James"; shirtNumber = 24; value = 98; dateOfBirth = 944611200000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 157; teamId = 7; firstName = "Malo"; lastName = "Gusto"; shirtNumber = 0; value = 64; dateOfBirth = 1053302400000000000; nationality = "France"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 158; teamId = 7; firstName = "Enzo"; lastName = "Fernández"; shirtNumber = 5; value = 64; dateOfBirth = 979689600000000000; nationality = "Argentina"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 159; teamId = 7; firstName = "Conor"; lastName = "Gallagher"; shirtNumber = 23; value = 88; dateOfBirth = 949795200000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 160; teamId = 7; firstName = "Carney"; lastName = "Chukwuemeka"; shirtNumber = 30; value = 30; dateOfBirth = 1066608000000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 161; teamId = 7; firstName = "Raheem"; lastName = "Sterling"; shirtNumber = 17; value = 262; dateOfBirth = 786844800000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 162; teamId = 7; firstName = "Ian"; lastName = "Maatsen"; shirtNumber = 38; value = 262; dateOfBirth = 1015718400000000000; nationality = "Netherlands"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 163; teamId = 7; firstName = "Noni"; lastName = "Madueke"; shirtNumber = 31; value = 80; dateOfBirth = 1015718400000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 164; teamId = 7; firstName = "Hakim"; lastName = "Ziyech"; shirtNumber = 22; value = 84; dateOfBirth = 732499200000000000; nationality = "Morocco"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 165; teamId = 7; firstName = "Ângelo"; lastName = "Gabriel"; shirtNumber = 41; value = 64; dateOfBirth = 1103587200000000000; nationality = "Brazil"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 166; teamId = 7; firstName = "Armando"; lastName = "Broja"; shirtNumber = 18; value = 72; dateOfBirth = 1000080000000000000; nationality = "Albania"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 167; teamId = 7; firstName = "Callum"; lastName = "Hudson-Odoi"; shirtNumber = 0; value = 42; dateOfBirth = 973555200000000000; nationality = "England"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 168; teamId = 7; firstName = "Romelu"; lastName = "Lukaku"; shirtNumber = 0; value = 210; dateOfBirth = 737251200000000000; nationality = "Belgium"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 169; teamId = 7; firstName = "Christopher"; lastName = "Nkunku"; shirtNumber = 0; value = 168; dateOfBirth = 879465600000000000; nationality = "France"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 170; teamId = 7; firstName = "Nicolas"; lastName = "Jackson"; shirtNumber = 0; value = 148; dateOfBirth = 992908800000000000; nationality = "Gambia"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 171; teamId = 7; firstName = "Andrey"; lastName = "Santos"; shirtNumber = 39; value = 42; dateOfBirth = 1083542400000000000; nationality = "Brazil"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 172; teamId = 8; firstName = "Sam"; lastName = "Johnstone"; shirtNumber = 21; value = 38; dateOfBirth = 733017600000000000; nationality = "England"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 173; teamId = 8; firstName = "Vicente"; lastName = "Guaita"; shirtNumber = 13; value = 38; dateOfBirth = 537235200000000000; nationality = "Spain"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 174; teamId = 8; firstName = "Joe"; lastName = "Whitworth"; shirtNumber = 41; value = 22; dateOfBirth = 1078012800000000000; nationality = "England"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 175; teamId = 8; firstName = "Remi"; lastName = "Matthews"; shirtNumber = 31; value = 22; dateOfBirth = 760838400000000000; nationality = "England"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 176; teamId = 8; firstName = "Marc"; lastName = "Guéhi"; shirtNumber = 6; value = 42; dateOfBirth = 963446400000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 177; teamId = 8; firstName = "Joachim"; lastName = "Andersen"; shirtNumber = 16; value = 42; dateOfBirth = 833500800000000000; nationality = "Denmark"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 178; teamId = 8; firstName = "Chris"; lastName = "Richards"; shirtNumber = 26; value = 38; dateOfBirth = 954201600000000000; nationality = "United States"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 179; teamId = 8; firstName = "James"; lastName = "Tomkins"; shirtNumber = 5; value = 18; dateOfBirth = 607132800000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 180; teamId = 8; firstName = "Tyrick"; lastName = "Mitchell"; shirtNumber = 3; value = 38; dateOfBirth = 936144000000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 181; teamId = 8; firstName = "Nathaniel"; lastName = "Clyne"; shirtNumber = 17; value = 42; dateOfBirth = 670809600000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 182; teamId = 8; firstName = "Joel"; lastName = "Ward"; shirtNumber = 2; value = 38; dateOfBirth = 625622400000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 183; teamId = 8; firstName = "Cheick"; lastName = "Doucouré"; shirtNumber = 28; value = 64; dateOfBirth = 947289600000000000; nationality = "Mali"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 184; teamId = 8; firstName = "Jairo"; lastName = "Riedewald"; shirtNumber = 44; value = 30; dateOfBirth = 842227200000000000; nationality = "Netherlands"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 185; teamId = 8; firstName = "Will"; lastName = "Hughes"; shirtNumber = 19; value = 56; dateOfBirth = 798076800000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 186; teamId = 8; firstName = "Jeffrey"; lastName = "Schlupp"; shirtNumber = 15; value = 50; dateOfBirth = 725068800000000000; nationality = "Ghana"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 187; teamId = 8; firstName = "Eberechi"; lastName = "Eze"; shirtNumber = 10; value = 92; dateOfBirth = 899078400000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 188; teamId = 8; firstName = "Malcolm"; lastName = "Ebiowei"; shirtNumber = 23; value = 42; dateOfBirth = 1062633600000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 189; teamId = 8; firstName = "Michael"; lastName = "Olise"; shirtNumber = 7; value = 76; dateOfBirth = 1008115200000000000; nationality = "France"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 190; teamId = 8; firstName = "Odsonne"; lastName = "Edouard"; shirtNumber = 22; value = 64; dateOfBirth = 884908800000000000; nationality = "France"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 191; teamId = 8; firstName = "Jean-Philippe"; lastName = "Mateta"; shirtNumber = 14; value = 68; dateOfBirth = 867456000000000000; nationality = "France"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 192; teamId = 8; firstName = "Jordan"; lastName = "Ayew"; shirtNumber = 9; value = 72; dateOfBirth = 684547200000000000; nationality = "Ghana"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 193; teamId = 8; firstName = "Jefferson"; lastName = "Lerma"; shirtNumber = 8; value = 64; dateOfBirth = 783043200000000000; nationality = "Colombia"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 194; teamId = 9; firstName = "Jordan"; lastName = "Pickford"; shirtNumber = 1; value = 38; dateOfBirth = 762998400000000000; nationality = "England"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 195; teamId = 9; firstName = "João"; lastName = "Virgínia"; shirtNumber = 0; value = 22; dateOfBirth = 939513600000000000; nationality = "Portugal"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 196; teamId = 9; firstName = "Andy"; lastName = "Lonergan"; shirtNumber = 31; value = 22; dateOfBirth = 435369600000000000; nationality = "England"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 197; teamId = 9; firstName = "James"; lastName = "Tarkowski"; shirtNumber = 2; value = 26; dateOfBirth = 722131200000000000; nationality = "Poland"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 198; teamId = 9; firstName = "Ben"; lastName = "Godfrey"; shirtNumber = 22; value = 34; dateOfBirth = 884822400000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 199; teamId = 9; firstName = "Michael"; lastName = "Keane"; shirtNumber = 5; value = 30; dateOfBirth = 726710400000000000; nationality = "Ireland"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 200; teamId = 9; firstName = "Mason"; lastName = "Holgate"; shirtNumber = 4; value = 30; dateOfBirth = 845942400000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 201; teamId = 9; firstName = "jarrad"; lastName = "Branthwaite"; shirtNumber = 0; value = 22; dateOfBirth = 1025136000000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 202; teamId = 9; firstName = "Vitaliy"; lastName = "Mykolenko"; shirtNumber = 19; value = 26; dateOfBirth = 927936000000000000; nationality = "Ukraine"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 203; teamId = 9; firstName = "Nathan"; lastName = "Patterson"; shirtNumber = 3; value = 18; dateOfBirth = 1003190400000000000; nationality = "Scotland"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 204; teamId = 9; firstName = "Seamus"; lastName = "Coleman"; shirtNumber = 23; value = 26; dateOfBirth = 592531200000000000; nationality = "Ireland"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 205; teamId = 9; firstName = "Amadou"; lastName = "Onana"; shirtNumber = 8; value = 50; dateOfBirth = 997920000000000000; nationality = "Belgium"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 206; teamId = 9; firstName = "James"; lastName = "Garner"; shirtNumber = 37; value = 42; dateOfBirth = 984441600000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 207; teamId = 9; firstName = "Abdoulaye"; lastName = "Doucouré"; shirtNumber = 16; value = 76; dateOfBirth = 725846400000000000; nationality = "Mali"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 208; teamId = 9; firstName = "Idrissa"; lastName = "Gueye"; shirtNumber = 27; value = 50; dateOfBirth = 622771200000000000; nationality = "Senegal"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 209; teamId = 9; firstName = "Alex"; lastName = "Iwobi"; shirtNumber = 17; value = 60; dateOfBirth = 831081600000000000; nationality = "Nigeria"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 210; teamId = 9; firstName = "Dele"; lastName = "Alli"; shirtNumber = 0; value = 64; dateOfBirth = 829180800000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 211; teamId = 9; firstName = "Dwight"; lastName = "McNeil"; shirtNumber = 7; value = 72; dateOfBirth = 943228800000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 212; teamId = 9; firstName = "Demarai"; lastName = "Gray"; shirtNumber = 11; value = 68; dateOfBirth = 835920000000000000; nationality = "Jamaica"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 213; teamId = 9; firstName = "Arnaut"; lastName = "Danjuma"; shirtNumber = 10; value = 84; dateOfBirth = 854668800000000000; nationality = "Netherlands"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 214; teamId = 9; firstName = "Dominic"; lastName = "Calvert-Lewin"; shirtNumber = 9; value = 186; dateOfBirth = 858470400000000000; nationality = "England"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 215; teamId = 9; firstName = "Neal"; lastName = "Maupay"; shirtNumber = 20; value = 88; dateOfBirth = 839980800000000000; nationality = "France"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 216; teamId = 9; firstName = "Ashley"; lastName = "Young"; shirtNumber = 18; value = 22; dateOfBirth = 489715200000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 217; teamId = 10; firstName = "Bernd"; lastName = "Leno"; shirtNumber = 17; value = 46; dateOfBirth = 699667200000000000; nationality = "Germany"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 218; teamId = 10; firstName = "Marek"; lastName = "Rodak"; shirtNumber = 1; value = 34; dateOfBirth = 850435200000000000; nationality = "Slovakia"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 219; teamId = 10; firstName = "Issa"; lastName = "Diop"; shirtNumber = 31; value = 34; dateOfBirth = 852768000000000000; nationality = "France"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 220; teamId = 10; firstName = "Tosin"; lastName = "Adarabioyo"; shirtNumber = 4; value = 38; dateOfBirth = 875059200000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 221; teamId = 10; firstName = "Tim"; lastName = "Ream"; shirtNumber = 13; value = 42; dateOfBirth = 560390400000000000; nationality = "United States"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 222; teamId = 10; firstName = "Kevin"; lastName = "Mbabu"; shirtNumber = 27; value = 22; dateOfBirth = 798249600000000000; nationality = "United States"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 223; teamId = 10; firstName = "Terence"; lastName = "Kongolo"; shirtNumber = 5; value = 22; dateOfBirth = 761184000000000000; nationality = "Switzerland"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 224; teamId = 10; firstName = "Calvin"; lastName = "Bassey"; shirtNumber = 3; value = 22; dateOfBirth = 946598400000000000; nationality = "Nigeria"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 225; teamId = 10; firstName = "Antonee"; lastName = "Robinson"; shirtNumber = 33; value = 38; dateOfBirth = 876268800000000000; nationality = "United States"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 226; teamId = 10; firstName = "Kenny"; lastName = "Tete"; shirtNumber = 2; value = 38; dateOfBirth = 813196800000000000; nationality = "Netherlands"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 227; teamId = 10; firstName = "João"; lastName = "Palhinha"; shirtNumber = 26; value = 60; dateOfBirth = 805248000000000000; nationality = "Portugal"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 228; teamId = 10; firstName = "Harrison"; lastName = "Reed"; shirtNumber = 6; value = 34; dateOfBirth = 791164800000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 229; teamId = 10; firstName = "Sasa"; lastName = "Lukic"; shirtNumber = 28; value = 42; dateOfBirth = 839894400000000000; nationality = "Serbia"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 230; teamId = 10; firstName = "Tom"; lastName = "Cairney"; shirtNumber = 10; value = 50; dateOfBirth = 664329600000000000; nationality = "Scotland"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 231; teamId = 10; firstName = "Tyrese"; lastName = "Francois"; shirtNumber = 35; value = 42; dateOfBirth = 963705600000000000; nationality = "Australia"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 232; teamId = 10; firstName = "Andreas"; lastName = "Pereira"; shirtNumber = 18; value = 42; dateOfBirth = 820454400000000000; nationality = "Brazil"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 233; teamId = 10; firstName = "Bobby"; lastName = "De Cordova-Reid"; shirtNumber = 14; value = 80; dateOfBirth = 728611200000000000; nationality = "Jamaica"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 234; teamId = 10; firstName = ""; lastName = "Willian"; shirtNumber = 20; value = 84; dateOfBirth = 587088000000000000; nationality = "Brazil"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 235; teamId = 10; firstName = "Harry"; lastName = "Wilson"; shirtNumber = 8; value = 92; dateOfBirth = 858988800000000000; nationality = "Wales"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 236; teamId = 10; firstName = "Ivan"; lastName = "Cavaleiro"; shirtNumber = 0; value = 64; dateOfBirth = 750902400000000000; nationality = "Portugal"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 237; teamId = 10; firstName = "Anthony"; lastName = "Knockaert"; shirtNumber = 0; value = 42; dateOfBirth = 690595200000000000; nationality = "France"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 238; teamId = 10; firstName = "Aleksandar"; lastName = "Mitrović"; shirtNumber = 9; value = 130; dateOfBirth = 779673600000000000; nationality = "Serbia"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 239; teamId = 10; firstName = "Carlos"; lastName = "Vinícius"; shirtNumber = 30; value = 80; dateOfBirth = 796089600000000000; nationality = "Brazil"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 240; teamId = 10; firstName = "Raúl"; lastName = "Jiménez"; shirtNumber = 9; value = 84; dateOfBirth = 673401600000000000; nationality = "Mexico"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 241; teamId = 10; firstName = "Rodrigo"; lastName = "Muniz"; shirtNumber = 19; value = 42; dateOfBirth = 988934400000000000; nationality = "Brazil"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 242; teamId = 11; firstName = ""; lastName = "Alisson"; shirtNumber = 1; value = 84; dateOfBirth = 717984000000000000; nationality = "Brazil"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 243; teamId = 11; firstName = "Caoimhín"; lastName = "Kelleher"; shirtNumber = 62; value = 18; dateOfBirth = 911779200000000000; nationality = "Ireland"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 244; teamId = 11; firstName = ""; lastName = "Adrián"; shirtNumber = 13; value = 14; dateOfBirth = 536630400000000000; nationality = "Spain"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 245; teamId = 11; firstName = "Ibrahima"; lastName = "Konaté"; shirtNumber = 5; value = 60; dateOfBirth = 927590400000000000; nationality = "France"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 246; teamId = 11; firstName = "Virgil"; lastName = "Van Dijk"; shirtNumber = 4; value = 130; dateOfBirth = 678931200000000000; nationality = "Netherlands"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 247; teamId = 11; firstName = "Joe"; lastName = "Gomez"; shirtNumber = 2; value = 34; dateOfBirth = 864345600000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 248; teamId = 11; firstName = "Joel"; lastName = "Matip"; shirtNumber = 32; value = 102; dateOfBirth = 681609600000000000; nationality = "Cameroon"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 249; teamId = 11; firstName = "Nathaniel"; lastName = "Phillips"; shirtNumber = 47; value = 14; dateOfBirth = 858902400000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 250; teamId = 11; firstName = "Andrew"; lastName = "Robertson"; shirtNumber = 26; value = 140; dateOfBirth = 763344000000000000; nationality = "Scotland"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 251; teamId = 11; firstName = "Konstantinos"; lastName = "Tsimikas"; shirtNumber = 21; value = 34; dateOfBirth = 831859200000000000; nationality = "Greece"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 252; teamId = 11; firstName = "Trent"; lastName = "Alexander-Arnold"; shirtNumber = 66; value = 182; dateOfBirth = 907718400000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 253; teamId = 11; firstName = "Stefan"; lastName = "Bajcetic"; shirtNumber = 43; value = 34; dateOfBirth = 1098403200000000000; nationality = "Spain"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 254; teamId = 11; firstName = "Curtis"; lastName = "Jones"; shirtNumber = 17; value = 60; dateOfBirth = 980812800000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 255; teamId = 11; firstName = "Thiago"; lastName = "Thiago"; shirtNumber = 6; value = 68; dateOfBirth = 671328000000000000; nationality = "Spain"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 256; teamId = 11; firstName = "Harvey"; lastName = "Elliott"; shirtNumber = 19; value = 56; dateOfBirth = 1049414400000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 257; teamId = 11; firstName = "Luis"; lastName = "Díaz"; shirtNumber = 23; value = 182; dateOfBirth = 853113600000000000; nationality = "Colombia"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 258; teamId = 11; firstName = "Cody"; lastName = "Gakpo"; shirtNumber = 18; value = 172; dateOfBirth = 926035200000000000; nationality = "Netherlands"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 259; teamId = 11; firstName = "Diogo"; lastName = "Jota"; shirtNumber = 20; value = 214; dateOfBirth = 849657600000000000; nationality = "Portugal"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 260; teamId = 11; firstName = "Mohamed"; lastName = "Salah"; shirtNumber = 11; value = 404; dateOfBirth = 708566400000000000; nationality = "Egypt"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 261; teamId = 11; firstName = "Darwin"; lastName = "Núñez"; shirtNumber = 27; value = 214; dateOfBirth = 930182400000000000; nationality = "Uruguay"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 262; teamId = 11; firstName = "Alexis"; lastName = "Mac Allister"; shirtNumber = 10; value = 106; dateOfBirth = 914457600000000000; nationality = "Argentina"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 263; teamId = 11; firstName = "Dominik"; lastName = "Szoboszlai"; shirtNumber = 8; value = 148; dateOfBirth = 972432000000000000; nationality = "Hungary"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 264; teamId = 13; firstName = ""; lastName = "Ederson"; shirtNumber = 31; value = 80; dateOfBirth = 745545600000000000; nationality = "Brazil"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 265; teamId = 13; firstName = "Stefan"; lastName = "Ortega"; shirtNumber = 18; value = 8; dateOfBirth = 721008000000000000; nationality = "Germany"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 266; teamId = 13; firstName = "Zack"; lastName = "Steffen"; shirtNumber = 0; value = 22; dateOfBirth = 796780800000000000; nationality = "United States"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 267; teamId = 13; firstName = "Scott"; lastName = "Carson"; shirtNumber = 33; value = 14; dateOfBirth = 494553600000000000; nationality = "England"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 268; teamId = 13; firstName = "Rúben"; lastName = "Dias"; shirtNumber = 3; value = 106; dateOfBirth = 863568000000000000; nationality = "Portugal"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 269; teamId = 13; firstName = "Nathan"; lastName = "Aké"; shirtNumber = 6; value = 64; dateOfBirth = 793065600000000000; nationality = "Netherlands"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 270; teamId = 13; firstName = "John"; lastName = "Stones"; shirtNumber = 5; value = 88; dateOfBirth = 770083200000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 271; teamId = 13; firstName = "Manuel"; lastName = "Akanji"; shirtNumber = 25; value = 68; dateOfBirth = 806112000000000000; nationality = "Switzerland"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 272; teamId = 13; firstName = "João"; lastName = "Cancelo"; shirtNumber = 7; value = 106; dateOfBirth = 769996800000000000; nationality = "Portugal"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 273; teamId = 13; firstName = "Aymeric"; lastName = "Laporte"; shirtNumber = 14; value = 88; dateOfBirth = 769996800000000000; nationality = "Spain"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 274; teamId = 13; firstName = "Sergio"; lastName = "Gómez"; shirtNumber = 21; value = 34; dateOfBirth = 968025600000000000; nationality = "Spain"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 275; teamId = 13; firstName = "Rico"; lastName = "Lewis"; shirtNumber = 82; value = 14; dateOfBirth = 1100995200000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 276; teamId = 13; firstName = "Kyle"; lastName = "Walker"; shirtNumber = 2; value = 50; dateOfBirth = 643852800000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 277; teamId = 13; firstName = "Rodri"; lastName = "Rodri"; shirtNumber = 16; value = 88; dateOfBirth = 835401600000000000; nationality = "Spain"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 278; teamId = 13; firstName = "Kalvin"; lastName = "Phillips"; shirtNumber = 4; value = 14; dateOfBirth = 817862400000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 279; teamId = 13; firstName = "Máximo"; lastName = "Perrone"; shirtNumber = 32; value = 38; dateOfBirth = 1041897600000000000; nationality = "Argentina"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 280; teamId = 13; firstName = "Mateo"; lastName = "Kovacic"; shirtNumber = 8; value = 60; dateOfBirth = 768182400000000000; nationality = "Croatia"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 281; teamId = 13; firstName = "Bernardo"; lastName = "Silva"; shirtNumber = 20; value = 274; dateOfBirth = 776476800000000000; nationality = "Portugal"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 282; teamId = 13; firstName = "Kevin"; lastName = "De Bruyne"; shirtNumber = 17; value = 362; dateOfBirth = 678067200000000000; nationality = "Belgium"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 283; teamId = 13; firstName = "Cole"; lastName = "Palmer"; shirtNumber = 80; value = 30; dateOfBirth = 1020643200000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 284; teamId = 13; firstName = "Phil"; lastName = "Foden"; shirtNumber = 47; value = 190; dateOfBirth = 959472000000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 285; teamId = 13; firstName = "Jack"; lastName = "Grealish"; shirtNumber = 10; value = 152; dateOfBirth = 810691200000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 286; teamId = 13; firstName = "Oscar"; lastName = "Bobb"; shirtNumber = 52; value = 42; dateOfBirth = 1057968000000000000; nationality = "Norway"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 287; teamId = 13; firstName = "Erling"; lastName = "Haaland"; shirtNumber = 9; value = 374; dateOfBirth = 964137600000000000; nationality = "Norway"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 288; teamId = 13; firstName = "Julián"; lastName = "Álvarez"; shirtNumber = 19; value = 110; dateOfBirth = 949276800000000000; nationality = "Argentina"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 289; teamId = 14; firstName = "Dean"; lastName = "Henderson"; shirtNumber = 26; value = 42; dateOfBirth = 858124800000000000; nationality = "England"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 290; teamId = 14; firstName = "Tom"; lastName = "Heaton"; shirtNumber = 22; value = 14; dateOfBirth = 513907200000000000; nationality = "England"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 291; teamId = 14; firstName = "André"; lastName = "Onana"; shirtNumber = 24; value = 64; dateOfBirth = 828403200000000000; nationality = "England"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 292; teamId = 14; firstName = "Lisandro"; lastName = "Martínez"; shirtNumber = 6; value = 64; dateOfBirth = 885081600000000000; nationality = "Argentina"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 293; teamId = 14; firstName = "Raphaël"; lastName = "Varane"; shirtNumber = 19; value = 56; dateOfBirth = 735696000000000000; nationality = "France"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 294; teamId = 14; firstName = "Harry"; lastName = "Maguire"; shirtNumber = 5; value = 56; dateOfBirth = 731289600000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 295; teamId = 14; firstName = "Victor"; lastName = "Lindelöf"; shirtNumber = 2; value = 50; dateOfBirth = 774403200000000000; nationality = "Sweden"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 296; teamId = 14; firstName = "Eric"; lastName = "Bailly"; shirtNumber = 3; value = 34; dateOfBirth = 766108800000000000; nationality = "Ivory Coast"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 297; teamId = 14; firstName = "Teden"; lastName = "Mengi"; shirtNumber = 43; value = 22; dateOfBirth = 1020124800000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 298; teamId = 14; firstName = "Luke"; lastName = "Shaw"; shirtNumber = 23; value = 76; dateOfBirth = 805507200000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 299; teamId = 14; firstName = "Tyrell"; lastName = "Malacia"; shirtNumber = 12; value = 30; dateOfBirth = 934848000000000000; nationality = "Netherlands"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 300; teamId = 14; firstName = "Brandon"; lastName = "Williams"; shirtNumber = 33; value = 8; dateOfBirth = 967939200000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 301; teamId = 14; firstName = "Álvaro"; lastName = "Fernandez"; shirtNumber = 74; value = 42; dateOfBirth = 1048377600000000000; nationality = "Spain"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 302; teamId = 14; firstName = "Diogo"; lastName = "Dalot"; shirtNumber = 20; value = 56; dateOfBirth = 921715200000000000; nationality = "Portugal"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 303; teamId = 14; firstName = "Aaron"; lastName = "Wan-Bissaka"; shirtNumber = 29; value = 34; dateOfBirth = 880502400000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 304; teamId = 14; firstName = "Casemiro"; lastName = "Casemiro"; shirtNumber = 18; value = 60; dateOfBirth = 698803200000000000; nationality = "Brazil"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 305; teamId = 14; firstName = "Scott"; lastName = "McTominay"; shirtNumber = 39; value = 60; dateOfBirth = 850003200000000000; nationality = "Scotland"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 306; teamId = 14; firstName = "Christian"; lastName = "Eriksen"; shirtNumber = 14; value = 114; dateOfBirth = 698025600000000000; nationality = "Denmark"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 307; teamId = 14; firstName = ""; lastName = "Fred"; shirtNumber = 17; value = 68; dateOfBirth = 731289600000000000; nationality = "Brazil"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 308; teamId = 14; firstName = "Donny"; lastName = "Van de Beek"; shirtNumber = 34; value = 68; dateOfBirth = 861321600000000000; nationality = "Netherlands"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 309; teamId = 14; firstName = "Kobbie"; lastName = "Mainoo"; shirtNumber = 73; value = 42; dateOfBirth = 1113868800000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 310; teamId = 14; firstName = "Mason"; lastName = "Mount"; shirtNumber = 7; value = 156; dateOfBirth = 915926400000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 311; teamId = 14; firstName = "Bruno"; lastName = "Fernandes"; shirtNumber = 8; value = 252; dateOfBirth = 778982400000000000; nationality = "Portugal"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 312; teamId = 14; firstName = "Marcus"; lastName = "Rashford"; shirtNumber = 10; value = 156; dateOfBirth = 878256000000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 313; teamId = 14; firstName = "Jadon"; lastName = "Sancho"; shirtNumber = 25; value = 152; dateOfBirth = 953942400000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 314; teamId = 14; firstName = "Alejandro"; lastName = "Garnacho"; shirtNumber = 49; value = 26; dateOfBirth = 1088640000000000000; nationality = "Argentina"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 315; teamId = 14; firstName = ""; lastName = "Antony"; shirtNumber = 21; value = 160; dateOfBirth = 951350400000000000; nationality = "Brazil"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 316; teamId = 14; firstName = "Amad"; lastName = "Diallo"; shirtNumber = 0; value = 42; dateOfBirth = 1026345600000000000; nationality = "Cote d'Ivoire"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 317; teamId = 14; firstName = "Facundo"; lastName = "Pellistri"; shirtNumber = 28; value = 34; dateOfBirth = 1008806400000000000; nationality = "Uruguay"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 318; teamId = 14; firstName = "Anthony"; lastName = "Martial"; shirtNumber = 9; value = 118; dateOfBirth = 818121600000000000; nationality = "France"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 319; teamId = 15; firstName = "Nick"; lastName = "Pope"; shirtNumber = 22; value = 80; dateOfBirth = 703641600000000000; nationality = "England"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 320; teamId = 15; firstName = "Martin"; lastName = "Dúbravka"; shirtNumber = 1; value = 26; dateOfBirth = 600825600000000000; nationality = "Slovakia"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 321; teamId = 15; firstName = "Mark"; lastName = "Gillespie"; shirtNumber = 29; value = 22; dateOfBirth = 701654400000000000; nationality = "England"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 322; teamId = 15; firstName = "Loris"; lastName = "Karius"; shirtNumber = 18; value = 18; dateOfBirth = 740707200000000000; nationality = "Germany"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 323; teamId = 15; firstName = "Sven"; lastName = "Botman"; shirtNumber = 4; value = 42; dateOfBirth = 947635200000000000; nationality = "Netherlands"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 324; teamId = 15; firstName = "Fabian"; lastName = "Schär"; shirtNumber = 5; value = 68; dateOfBirth = 693187200000000000; nationality = "Switzerland"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 325; teamId = 15; firstName = "Jamaal"; lastName = "Lascelles"; shirtNumber = 6; value = 34; dateOfBirth = 752976000000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 326; teamId = 15; firstName = "Matt"; lastName = "Targett"; shirtNumber = 13; value = 50; dateOfBirth = 811382400000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 327; teamId = 15; firstName = "Dan"; lastName = "Burn"; shirtNumber = 33; value = 42; dateOfBirth = 705369600000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 328; teamId = 15; firstName = "Paul"; lastName = "Dummett"; shirtNumber = 3; value = 22; dateOfBirth = 685843200000000000; nationality = "Wales"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 329; teamId = 15; firstName = "Kieran"; lastName = "Trippier"; shirtNumber = 2; value = 106; dateOfBirth = 653702400000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 330; teamId = 15; firstName = "Emil"; lastName = "Krafth"; shirtNumber = 17; value = 34; dateOfBirth = 775785600000000000; nationality = "Sweden"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 331; teamId = 15; firstName = "Javier"; lastName = "Manquillo"; shirtNumber = 19; value = 30; dateOfBirth = 768096000000000000; nationality = "Spain"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 332; teamId = 15; firstName = "Harrison"; lastName = "Ashby"; shirtNumber = 30; value = 14; dateOfBirth = 1005696000000000000; nationality = "Scotland"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 333; teamId = 15; firstName = "Bruno"; lastName = "Guimarães"; shirtNumber = 39; value = 84; dateOfBirth = 879638400000000000; nationality = "Brazil"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 334; teamId = 15; firstName = "Isaac"; lastName = "Hayden"; shirtNumber = 0; value = 42; dateOfBirth = 795830400000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 335; teamId = 15; firstName = "Joe"; lastName = "Willock"; shirtNumber = 28; value = 50; dateOfBirth = 935107200000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 336; teamId = 15; firstName = "Sean"; lastName = "Longstaff"; shirtNumber = 36; value = 34; dateOfBirth = 878169600000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 337; teamId = 15; firstName = "Jeff"; lastName = "Hendrick"; shirtNumber = 0; value = 42; dateOfBirth = 696816000000000000; nationality = "Ireland"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 338; teamId = 15; firstName = "Matt"; lastName = "Ritchie"; shirtNumber = 11; value = 30; dateOfBirth = 621388800000000000; nationality = "Scotland"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 339; teamId = 15; firstName = ""; lastName = "Joelinton"; shirtNumber = 7; value = 106; dateOfBirth = 839980800000000000; nationality = "Brazil"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 340; teamId = 15; firstName = "Harvey"; lastName = "Barnes"; shirtNumber = 15; value = 128; dateOfBirth = 881625600000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 341; teamId = 15; firstName = "Elliot"; lastName = "Anderson"; shirtNumber = 32; value = 34; dateOfBirth = 1036540800000000000; nationality = "Scotland"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 342; teamId = 15; firstName = "Anthony"; lastName = "Gordon"; shirtNumber = 8; value = 68; dateOfBirth = 982972800000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 343; teamId = 15; firstName = "Ryan"; lastName = "Fraser"; shirtNumber = 21; value = 72; dateOfBirth = 762048000000000000; nationality = "Scotland"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 344; teamId = 15; firstName = "Miguel"; lastName = "Almirón"; shirtNumber = 24; value = 80; dateOfBirth = 760838400000000000; nationality = "Paraguay"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 345; teamId = 15; firstName = "Jacob"; lastName = "Murphy"; shirtNumber = 23; value = 30; dateOfBirth = 793584000000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 346; teamId = 15; firstName = "Garang"; lastName = "Kuol"; shirtNumber = 0; value = 42; dateOfBirth = 1095206400000000000; nationality = "Sudan"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 347; teamId = 15; firstName = "Alexander"; lastName = "Isak"; shirtNumber = 14; value = 148; dateOfBirth = 937872000000000000; nationality = "Sweden"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 348; teamId = 15; firstName = "Callum"; lastName = "Wilson"; shirtNumber = 9; value = 160; dateOfBirth = 699148800000000000; nationality = "England"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 349; teamId = 16; firstName = "Wayne"; lastName = "Hennessey"; shirtNumber = 13; value = 18; dateOfBirth = 538444800000000000; nationality = "Wales"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 350; teamId = 16; firstName = "Ethan"; lastName = "Horvath"; shirtNumber = 0; value = 42; dateOfBirth = 802656000000000000; nationality = "United States"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 351; teamId = 16; firstName = "Moussa"; lastName = "Niakhaté"; shirtNumber = 19; value = 34; dateOfBirth = 826243200000000000; nationality = "Senegal"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 352; teamId = 16; firstName = "Joe"; lastName = "Worrall"; shirtNumber = 4; value = 30; dateOfBirth = 852854400000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 353; teamId = 16; firstName = "Scott"; lastName = "McKenna"; shirtNumber = 26; value = 38; dateOfBirth = 847756800000000000; nationality = "Scotland"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 354; teamId = 16; firstName = "Willy"; lastName = "Boly"; shirtNumber = 30; value = 26; dateOfBirth = 665539200000000000; nationality = "Cote d'Ivoire"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 355; teamId = 16; firstName = ""; lastName = "Felipe"; shirtNumber = 38; value = 42; dateOfBirth = 611280000000000000; nationality = "Brazil"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 356; teamId = 16; firstName = "Steve"; lastName = "Cook"; shirtNumber = 3; value = 34; dateOfBirth = 672019200000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 357; teamId = 16; firstName = "Harry"; lastName = "Toffolo"; shirtNumber = 15; value = 34; dateOfBirth = 808790400000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 358; teamId = 16; firstName = "Neco"; lastName = "Williams"; shirtNumber = 7; value = 14; dateOfBirth = 987120000000000000; nationality = "Wales"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 359; teamId = 16; firstName = "Serge"; lastName = "Aurier"; shirtNumber = 24; value = 34; dateOfBirth = 725155200000000000; nationality = "Cote d'Ivoire"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 360; teamId = 16; firstName = "Giulian"; lastName = "Biancone"; shirtNumber = 2; value = 30; dateOfBirth = 954460800000000000; nationality = "France"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 361; teamId = 16; firstName = "Mohamed"; lastName = "Dräger"; shirtNumber = 42; value = 22; dateOfBirth = 835660800000000000; nationality = "Germany"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 362; teamId = 16; firstName = "Richie"; lastName = "Laryea"; shirtNumber = 0; value = 42; dateOfBirth = 789436800000000000; nationality = "Canada"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 363; teamId = 16; firstName = "Loïc"; lastName = "Mbe Soh"; shirtNumber = 0; value = 22; dateOfBirth = 992390400000000000; nationality = "Cameroon"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 364; teamId = 16; firstName = ""; lastName = "Danilo"; shirtNumber = 28; value = 42; dateOfBirth = 679536000000000000; nationality = "Brazil"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 365; teamId = 16; firstName = "Cheikhou"; lastName = "Kouyaté"; shirtNumber = 21; value = 38; dateOfBirth = 630201600000000000; nationality = "Senegal"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 366; teamId = 16; firstName = "Orel"; lastName = "Mangala"; shirtNumber = 5; value = 60; dateOfBirth = 890179200000000000; nationality = "Belgium"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 367; teamId = 16; firstName = "Lewis"; lastName = "O'Brien"; shirtNumber = 14; value = 22; dateOfBirth = 908323200000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 368; teamId = 16; firstName = "Ryan"; lastName = "Yates"; shirtNumber = 22; value = 64; dateOfBirth = 880070400000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 369; teamId = 16; firstName = "Remo"; lastName = "Freuler"; shirtNumber = 23; value = 60; dateOfBirth = 703296000000000000; nationality = "Switzerland"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 370; teamId = 16; firstName = "Jonjo"; lastName = "Shelvey"; shirtNumber = 6; value = 56; dateOfBirth = 699148800000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 371; teamId = 16; firstName = "Morgan"; lastName = "Gibbs-White"; shirtNumber = 10; value = 84; dateOfBirth = 948931200000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 372; teamId = 16; firstName = "Brennan"; lastName = "Johnson"; shirtNumber = 20; value = 84; dateOfBirth = 990576000000000000; nationality = "Wales"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 373; teamId = 16; firstName = "Anthony"; lastName = "Elanga"; shirtNumber = 21; value = 64; dateOfBirth = 1019865600000000000; nationality = "Sweden"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 374; teamId = 16; firstName = "Gustavo"; lastName = "Scarpa"; shirtNumber = 31; value = 46; dateOfBirth = 757728000000000000; nationality = "Brazil"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 375; teamId = 16; firstName = "Alex"; lastName = "Mighten"; shirtNumber = 17; value = 22; dateOfBirth = 1018483200000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 376; teamId = 16; firstName = "Taiwo"; lastName = "Awoniyi"; shirtNumber = 9; value = 88; dateOfBirth = 871344000000000000; nationality = "Nigeria"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 377; teamId = 16; firstName = "Emmanuel"; lastName = "Dennis"; shirtNumber = 25; value = 88; dateOfBirth = 879552000000000000; nationality = "Nigeria"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 378; teamId = 16; firstName = "Chris"; lastName = "Wood"; shirtNumber = 11; value = 64; dateOfBirth = 692064000000000000; nationality = "New Zealand"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 379; teamId = 18; firstName = "Hugo"; lastName = "Lloris"; shirtNumber = 1; value = 80; dateOfBirth = 535939200000000000; nationality = "France"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 380; teamId = 18; firstName = "Fraser"; lastName = "Forster"; shirtNumber = 20; value = 18; dateOfBirth = 574560000000000000; nationality = "England"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 381; teamId = 18; firstName = "Alfie"; lastName = "Whiteman"; shirtNumber = 41; value = 22; dateOfBirth = 907286400000000000; nationality = "England"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 382; teamId = 18; firstName = "Brandon"; lastName = "Austin"; shirtNumber = 40; value = 18; dateOfBirth = 915753600000000000; nationality = "England"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 383; teamId = 18; firstName = "Guglielmo"; lastName = "Vicario"; shirtNumber = 13; value = 64; dateOfBirth = 844646400000000000; nationality = "Italy"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 384; teamId = 18; firstName = "Eric"; lastName = "Dier"; shirtNumber = 15; value = 64; dateOfBirth = 758592000000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 385; teamId = 18; firstName = "Davinson"; lastName = "Sánchez"; shirtNumber = 6; value = 38; dateOfBirth = 834537600000000000; nationality = "Colombia"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 386; teamId = 18; firstName = "Japhet"; lastName = "Tanganga"; shirtNumber = 25; value = 14; dateOfBirth = 922838400000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 387; teamId = 18; firstName = "Joe"; lastName = "Rodon"; shirtNumber = 0; value = 22; dateOfBirth = 877478400000000000; nationality = "Wales"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 388; teamId = 18; firstName = "Ben"; lastName = "Davies"; shirtNumber = 33; value = 50; dateOfBirth = 735609600000000000; nationality = "Wales"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 389; teamId = 18; firstName = "Sergio"; lastName = "Reguilón"; shirtNumber = 3; value = 42; dateOfBirth = 850694400000000000; nationality = "Spain"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 390; teamId = 18; firstName = "Destiny"; lastName = "Udogie"; shirtNumber = 0; value = 42; dateOfBirth = 1038441600000000000; nationality = "Italy"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 391; teamId = 18; firstName = "Pedro"; lastName = "Porro"; shirtNumber = 23; value = 56; dateOfBirth = 937180800000000000; nationality = "Spain"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 392; teamId = 18; firstName = "Emerson"; lastName = "Royal"; shirtNumber = 12; value = 56; dateOfBirth = 916272000000000000; nationality = "Brazil"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 393; teamId = 18; firstName = "Djed"; lastName = "Spence"; shirtNumber = 0; value = 22; dateOfBirth = 965779200000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 394; teamId = 18; firstName = "Oliver"; lastName = "Skipp"; shirtNumber = 4; value = 34; dateOfBirth = 969062400000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 395; teamId = 18; firstName = "Pierre-Emile"; lastName = "Höjbjerg"; shirtNumber = 5; value = 76; dateOfBirth = 807580800000000000; nationality = "Denmark"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 396; teamId = 18; firstName = "Rodrigo"; lastName = "Bentancur"; shirtNumber = 30; value = 76; dateOfBirth = 867196800000000000; nationality = "Uruguay"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 397; teamId = 18; firstName = "Yves"; lastName = "Bissouma"; shirtNumber = 38; value = 50; dateOfBirth = 841363200000000000; nationality = "Mali"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 398; teamId = 18; firstName = "Pape"; lastName = "Matar Sarr"; shirtNumber = 29; value = 30; dateOfBirth = 1031961600000000000; nationality = "Senegal"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 399; teamId = 18; firstName = "Ryan"; lastName = "Sessegnon"; shirtNumber = 19; value = 38; dateOfBirth = 958608000000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 400; teamId = 18; firstName = "Ivan"; lastName = "Perisic"; shirtNumber = 14; value = 76; dateOfBirth = 602380800000000000; nationality = "Croatia"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 401; teamId = 18; firstName = "Manor"; lastName = "Solomon"; shirtNumber = 0; value = 60; dateOfBirth = 932774400000000000; nationality = "Israel"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 402; teamId = 18; firstName = "Heung-min"; lastName = "Son"; shirtNumber = 7; value = 336; dateOfBirth = 710553600000000000; nationality = "South Korea"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 403; teamId = 18; firstName = "Bryan"; lastName = "Gil"; shirtNumber = 11; value = 64; dateOfBirth = 981849600000000000; nationality = "Spain"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 404; teamId = 18; firstName = "Dejan"; lastName = "Kulusevski"; shirtNumber = 21; value = 182; dateOfBirth = 956620800000000000; nationality = "Sweden"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 405; teamId = 18; firstName = "Harry"; lastName = "Kane"; shirtNumber = 10; value = 336; dateOfBirth = 743817600000000000; nationality = "England"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 406; teamId = 18; firstName = ""; lastName = "Richarlison"; shirtNumber = 9; value = 206; dateOfBirth = 868492800000000000; nationality = "Brazil"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 407; teamId = 18; firstName = "James"; lastName = "Maddison"; shirtNumber = 0; value = 168; dateOfBirth = 848707200000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 408; teamId = 19; firstName = "Alphonse"; lastName = "Areola"; shirtNumber = 13; value = 34; dateOfBirth = 730771200000000000; nationality = "France"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 409; teamId = 19; firstName = "Lukasz"; lastName = "Fabianski"; shirtNumber = 1; value = 60; dateOfBirth = 482630400000000000; nationality = "Poland"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 410; teamId = 19; firstName = "Nayef"; lastName = "Aguerd"; shirtNumber = 27; value = 56; dateOfBirth = 828144000000000000; nationality = "Morocco"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 411; teamId = 19; firstName = "Kurt"; lastName = "Zouma"; shirtNumber = 4; value = 38; dateOfBirth = 783216000000000000; nationality = "France"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 412; teamId = 19; firstName = "Thilo"; lastName = "Kehrer"; shirtNumber = 24; value = 34; dateOfBirth = 843264000000000000; nationality = "Germany"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 413; teamId = 19; firstName = "Angelo"; lastName = "Ogbonna"; shirtNumber = 21; value = 38; dateOfBirth = 580348800000000000; nationality = "Italy"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 414; teamId = 19; firstName = ""; lastName = "Emerson"; shirtNumber = 33; value = 22; dateOfBirth = 775872000000000000; nationality = "Italy"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 415; teamId = 19; firstName = "Aaron"; lastName = "Cresswell"; shirtNumber = 3; value = 50; dateOfBirth = 629683200000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 416; teamId = 19; firstName = "Ben"; lastName = "Johnson"; shirtNumber = 2; value = 38; dateOfBirth = 948672000000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 417; teamId = 19; firstName = "Vladimir"; lastName = "Coufal"; shirtNumber = 5; value = 22; dateOfBirth = 714441600000000000; nationality = "Czech Republic"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 418; teamId = 19; firstName = "Nikola"; lastName = "Vlašić"; shirtNumber = 0; value = 42; dateOfBirth = 875923200000000000; nationality = "Croatia"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 419; teamId = 19; firstName = "Tomas"; lastName = "Soucek"; shirtNumber = 28; value = 64; dateOfBirth = 793843200000000000; nationality = "Czech Republic"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 420; teamId = 19; firstName = "Conor"; lastName = "Coventry"; shirtNumber = 0; value = 22; dateOfBirth = 953942400000000000; nationality = "Ireland"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 421; teamId = 19; firstName = "Flynn"; lastName = "Downes"; shirtNumber = 12; value = 30; dateOfBirth = 916790400000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 422; teamId = 19; firstName = "Lucas"; lastName = "Paquetá"; shirtNumber = 11; value = 102; dateOfBirth = 872640000000000000; nationality = "Brazil"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 423; teamId = 19; firstName = "Saïd"; lastName = "Benrahma"; shirtNumber = 22; value = 84; dateOfBirth = 808012800000000000; nationality = "Algeria"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 424; teamId = 19; firstName = "Maxwel"; lastName = "Cornet"; shirtNumber = 14; value = 102; dateOfBirth = 835833600000000000; nationality = "Cote d'Ivoire"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 425; teamId = 19; firstName = "Jarrod"; lastName = "Bowen"; shirtNumber = 20; value = 190; dateOfBirth = 851040000000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 426; teamId = 19; firstName = "Gianluca"; lastName = "Scamacca"; shirtNumber = 7; value = 130; dateOfBirth = 915148800000000000; nationality = "Italy"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 427; teamId = 19; firstName = "Danny"; lastName = "Ings"; shirtNumber = 18; value = 118; dateOfBirth = 711849600000000000; nationality = "England"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 428; teamId = 19; firstName = "Michail"; lastName = "Antonio"; shirtNumber = 9; value = 144; dateOfBirth = 638582400000000000; nationality = "Jamaica"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 429; teamId = 19; firstName = "Divin"; lastName = "Mubama"; shirtNumber = 45; value = 42; dateOfBirth = 1098662400000000000; nationality = "England"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 430; teamId = 20; firstName = "José"; lastName = "Sá"; shirtNumber = 1; value = 64; dateOfBirth = 727228800000000000; nationality = "Portugal"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 431; teamId = 20; firstName = "Daniel"; lastName = "Bentley"; shirtNumber = 25; value = 22; dateOfBirth = 742521600000000000; nationality = "England"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 432; teamId = 20; firstName = "Max"; lastName = "Kilman"; shirtNumber = 23; value = 34; dateOfBirth = 864345600000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 433; teamId = 20; firstName = ""; lastName = "Toti"; shirtNumber = 24; value = 18; dateOfBirth = 916444800000000000; nationality = "Portugal"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 434; teamId = 20; firstName = "Craig"; lastName = "Dawson"; shirtNumber = 15; value = 56; dateOfBirth = 641952000000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 435; teamId = 20; firstName = "Rayan"; lastName = "Aït-Nouri"; shirtNumber = 3; value = 26; dateOfBirth = 991785600000000000; nationality = "Algeria"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 436; teamId = 20; firstName = "Jonny"; lastName = "Otto"; shirtNumber = 19; value = 34; dateOfBirth = 762652800000000000; nationality = "Spain"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 437; teamId = 20; firstName = "Hugo"; lastName = "Bueno"; shirtNumber = 64; value = 14; dateOfBirth = 1032307200000000000; nationality = "Spain"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 438; teamId = 20; firstName = "Nélson"; lastName = "Semedo"; shirtNumber = 22; value = 64; dateOfBirth = 753408000000000000; nationality = "Portugal"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 439; teamId = 20; firstName = "Matt"; lastName = "Doherty"; shirtNumber = 2; value = 42; dateOfBirth = 695520000000000000; nationality = "Ireland"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 440; teamId = 20; firstName = "Bendegúz"; lastName = "Bolla"; shirtNumber = 0; value = 22; dateOfBirth = 943228800000000000; nationality = "Hungary"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 441; teamId = 20; firstName = "Mario"; lastName = "Lemina"; shirtNumber = 5; value = 42; dateOfBirth = 746841600000000000; nationality = "Gabon"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 442; teamId = 20; firstName = "Boubacar"; lastName = "Traoré"; shirtNumber = 6; value = 34; dateOfBirth = 998265600000000000; nationality = "Mali"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 443; teamId = 20; firstName = "Joe"; lastName = "Hodge"; shirtNumber = 59; value = 34; dateOfBirth = 1031961600000000000; nationality = "Ireland"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 444; teamId = 20; firstName = "Matheus"; lastName = "Nunes"; shirtNumber = 27; value = 56; dateOfBirth = 904176000000000000; nationality = "Portugal"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 445; teamId = 20; firstName = "João"; lastName = "Gomes"; shirtNumber = 35; value = 42; dateOfBirth = 981936000000000000; nationality = "Brazil"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 446; teamId = 20; firstName = "Luke"; lastName = "Cundle"; shirtNumber = 59; value = 42; dateOfBirth = 1019779200000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 447; teamId = 20; firstName = "Bruno"; lastName = "Jordão"; shirtNumber = 0; value = 42; dateOfBirth = 908150400000000000; nationality = "Portugal"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 448; teamId = 20; firstName = "Daniel"; lastName = "Podence"; shirtNumber = 10; value = 68; dateOfBirth = 814233600000000000; nationality = "Portugal"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 449; teamId = 20; firstName = "Pedro"; lastName = "Neto"; shirtNumber = 7; value = 60; dateOfBirth = 952560000000000000; nationality = "Portugal"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 450; teamId = 20; firstName = "Pablo"; lastName = "Sarabia"; shirtNumber = 21; value = 60; dateOfBirth = 705542400000000000; nationality = "Spain"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 451; teamId = 20; firstName = "Matheus"; lastName = "Cunha"; shirtNumber = 12; value = 76; dateOfBirth = 927763200000000000; nationality = "Brazil"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 452; teamId = 20; firstName = "Sasa"; lastName = "Kalajdzic"; shirtNumber = 18; value = 76; dateOfBirth = 868233600000000000; nationality = "Austria"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 453; teamId = 20; firstName = "Fábio"; lastName = "Silva"; shirtNumber = 29; value = 84; dateOfBirth = 1027036800000000000; nationality = "Portugal"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 454; teamId = 20; firstName = "Hee-chan"; lastName = "Hwang"; shirtNumber = 11; value = 92; dateOfBirth = 822614400000000000; nationality = "South Korea"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 455; teamId = 20; firstName = "Gonçalo"; lastName = "Guedes"; shirtNumber = 0; value = 84; dateOfBirth = 849225600000000000; nationality = "Portugal"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 456; teamId = 20; firstName = "Matija"; lastName = "Šarkić"; shirtNumber = 0; value = 22; dateOfBirth = 869616000000000000; nationality = "Montenegro"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 457; teamId = 20; firstName = "Tom"; lastName = "King"; shirtNumber = 40; value = 22; dateOfBirth = 794620800000000000; nationality = "Wales"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 458; teamId = 6; firstName = "Denis"; lastName = "Franchi"; shirtNumber = 20; value = 22; dateOfBirth = 1035244800000000000; nationality = "Italy"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 459; teamId = 6; firstName = "Arijanet"; lastName = "Muric"; shirtNumber = 49; value = 22; dateOfBirth = 910396800000000000; nationality = "Switzerland"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 460; teamId = 6; firstName = "Lawrence"; lastName = "Vigouroux"; shirtNumber = 29; value = 22; dateOfBirth = 753667200000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 461; teamId = 6; firstName = "James"; lastName = "Trafford"; shirtNumber = 1; value = 42; dateOfBirth = 1034208000000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 462; teamId = 6; firstName = "Charlie"; lastName = "Taylor"; shirtNumber = 3; value = 42; dateOfBirth = 753580800000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 463; teamId = 6; firstName = "CJ"; lastName = "Egan-Riley"; shirtNumber = 6; value = 42; dateOfBirth = 1041465600000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 464; teamId = 6; firstName = "Connor"; lastName = "Roberts"; shirtNumber = 14; value = 42; dateOfBirth = 811814400000000000; nationality = "Wales"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 465; teamId = 6; firstName = "Hjalmar"; lastName = "Ekdal"; shirtNumber = 18; value = 42; dateOfBirth = 908928000000000000; nationality = "Sweden"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 466; teamId = 6; firstName = "Luke"; lastName = "Mcnally"; shirtNumber = 21; value = 42; dateOfBirth = 937785600000000000; nationality = "Ireland"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 467; teamId = 6; firstName = "Vitinho"; lastName = "Vitinho"; shirtNumber = 22; value = 42; dateOfBirth = 750124800000000000; nationality = "Brazil"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 468; teamId = 6; firstName = "Ameen"; lastName = "Al Dakhil"; shirtNumber = 28; value = 42; dateOfBirth = 1015372800000000000; nationality = "Belgium"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 469; teamId = 6; firstName = "Jordan"; lastName = "Beyer"; shirtNumber = 36; value = 42; dateOfBirth = 958694400000000000; nationality = "Germany"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 470; teamId = 6; firstName = "Dara"; lastName = "O'Shea"; shirtNumber = 2; value = 42; dateOfBirth = 920505600000000000; nationality = "Ireland"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 471; teamId = 6; firstName = "Nathan"; lastName = "Redmond"; shirtNumber = 0; value = 64; dateOfBirth = 762912000000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 472; teamId = 6; firstName = "Enock"; lastName = "Agyei"; shirtNumber = 0; value = 42; dateOfBirth = 1105574400000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 473; teamId = 6; firstName = "Jack"; lastName = "Cork"; shirtNumber = 4; value = 42; dateOfBirth = 614736000000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 474; teamId = 6; firstName = "Jóhann"; lastName = "Gudmundsson"; shirtNumber = 7; value = 42; dateOfBirth = 656985600000000000; nationality = "Iceland"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 475; teamId = 6; firstName = "Josh"; lastName = "Brownhill"; shirtNumber = 8; value = 42; dateOfBirth = 819331200000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 476; teamId = 6; firstName = "Josh"; lastName = "Cullen"; shirtNumber = 24; value = 42; dateOfBirth = 828835200000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 477; teamId = 6; firstName = "Samuel"; lastName = "Bastien"; shirtNumber = 26; value = 42; dateOfBirth = 843696000000000000; nationality = "Belgium"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 478; teamId = 6; firstName = "Benson"; lastName = "Manuel"; shirtNumber = 17; value = 84; dateOfBirth = 859507200000000000; nationality = "Belgium"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 479; teamId = 6; firstName = "Darko"; lastName = "Churlinov"; shirtNumber = 27; value = 42; dateOfBirth = 963273600000000000; nationality = "Macedonia"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 480; teamId = 6; firstName = "Dara"; lastName = "Costelloe"; shirtNumber = 44; value = 42; dateOfBirth = 1039564800000000000; nationality = "Ireland"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 481; teamId = 6; firstName = "Scott"; lastName = "Twine"; shirtNumber = 11; value = 64; dateOfBirth = 931910400000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 482; teamId = 6; firstName = "Luca"; lastName = "Koleosho"; shirtNumber = 12; value = 64; dateOfBirth = 1095206400000000000; nationality = "United States"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 483; teamId = 6; firstName = "Jacob"; lastName = "Bruun Larsen"; shirtNumber = 0; value = 64; dateOfBirth = 906163200000000000; nationality = "Denmark"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 484; teamId = 6; firstName = "Wout"; lastName = "Weghorst"; shirtNumber = 27; value = 84; dateOfBirth = 713145600000000000; nationality = "Netherlands"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 485; teamId = 6; firstName = "Lyle"; lastName = "Foster"; shirtNumber = 12; value = 64; dateOfBirth = 967939200000000000; nationality = "South Africa"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 486; teamId = 6; firstName = "Michael"; lastName = "Obafemi"; shirtNumber = 45; value = 64; dateOfBirth = 962841600000000000; nationality = "Ireland"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 487; teamId = 12; firstName = "James"; lastName = "Shea"; shirtNumber = 1; value = 22; dateOfBirth = 677030400000000000; nationality = "England"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 488; teamId = 12; firstName = "Matt"; lastName = "Macey"; shirtNumber = 33; value = 22; dateOfBirth = 779068800000000000; nationality = "England"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 489; teamId = 12; firstName = "Dan"; lastName = "Potts"; shirtNumber = 3; value = 42; dateOfBirth = 766195200000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 490; teamId = 12; firstName = "Tom"; lastName = "Lockyer"; shirtNumber = 4; value = 42; dateOfBirth = 786412800000000000; nationality = "Wales"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 491; teamId = 12; firstName = "Reece"; lastName = "Burke"; shirtNumber = 16; value = 42; dateOfBirth = 841622400000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 492; teamId = 12; firstName = "Amari'i"; lastName = "Bell"; shirtNumber = 29; value = 42; dateOfBirth = 768096000000000000; nationality = "Jamaica"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 493; teamId = 12; firstName = "Gabriel"; lastName = "Osho"; shirtNumber = 32; value = 42; dateOfBirth = 903052800000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 494; teamId = 12; firstName = "Issa"; lastName = "Kaboré"; shirtNumber = 0; value = 22; dateOfBirth = 989625600000000000; nationality = "Burkina Faso"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 495; teamId = 12; firstName = "Marvelous"; lastName = "Nakamba"; shirtNumber = 0; value = 42; dateOfBirth = 758937600000000000; nationality = "Zimbabwe"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 496; teamId = 12; firstName = "Glen"; lastName = "Rea"; shirtNumber = 6; value = 42; dateOfBirth = 778550400000000000; nationality = "Ireland"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 497; teamId = 12; firstName = "Luke"; lastName = "Berry"; shirtNumber = 8; value = 42; dateOfBirth = 710899200000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 498; teamId = 12; firstName = "Jordan"; lastName = "Clark"; shirtNumber = 18; value = 42; dateOfBirth = 748656000000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 499; teamId = 12; firstName = "Dion"; lastName = "Pereira"; shirtNumber = 19; value = 42; dateOfBirth = 922320000000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 500; teamId = 12; firstName = "Allan"; lastName = "Campbell"; shirtNumber = 22; value = 42; dateOfBirth = 899510400000000000; nationality = "Scotland"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 501; teamId = 12; firstName = "Luke"; lastName = "Freeman"; shirtNumber = 30; value = 42; dateOfBirth = 701222400000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 502; teamId = 12; firstName = "Alfie"; lastName = "Doughty"; shirtNumber = 45; value = 42; dateOfBirth = 945734400000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 503; teamId = 12; firstName = "Ryan"; lastName = "Giles"; shirtNumber = 0; value = 42; dateOfBirth = 948844800000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 504; teamId = 12; firstName = "Louie"; lastName = "Watson"; shirtNumber = 0; value = 42; dateOfBirth = 991872000000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 505; teamId = 12; firstName = "Pelly"; lastName = "Mpanzu"; shirtNumber = 17; value = 64; dateOfBirth = 764294400000000000; nationality = "DR Congo"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 506; teamId = 12; firstName = "Tahith"; lastName = "Chong"; shirtNumber = 0; value = 64; dateOfBirth = 944265600000000000; nationality = "Netherlands"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 507; teamId = 12; firstName = "Carlton"; lastName = "Morris"; shirtNumber = 9; value = 64; dateOfBirth = 819072000000000000; nationality = "England"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 508; teamId = 12; firstName = "Cauley"; lastName = "Woodrow"; shirtNumber = 10; value = 64; dateOfBirth = 786326400000000000; nationality = "England"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 509; teamId = 12; firstName = "Elijah"; lastName = "Adebayo"; shirtNumber = 11; value = 64; dateOfBirth = 884131200000000000; nationality = "England"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 510; teamId = 12; firstName = "Admiral"; lastName = "Muskwe"; shirtNumber = 15; value = 64; dateOfBirth = 903657600000000000; nationality = "Zimbabwe"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 511; teamId = 12; firstName = "Aribim"; lastName = "Pepple"; shirtNumber = 27; value = 64; dateOfBirth = 1040774400000000000; nationality = "Canada"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 512; teamId = 12; firstName = "Joe"; lastName = "Taylor"; shirtNumber = 25; value = 64; dateOfBirth = 1037577600000000000; nationality = "England"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 513; teamId = 12; firstName = "John"; lastName = "McAtee"; shirtNumber = 0; value = 64; dateOfBirth = 932688000000000000; nationality = "England"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 514; teamId = 12; firstName = "Chiedozie"; lastName = "Ogbene"; shirtNumber = 0; value = 64; dateOfBirth = 862444800000000000; nationality = "Nigeria"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 515; teamId = 12; firstName = "Mads"; lastName = "Andersen"; shirtNumber = 0; value = 22; dateOfBirth = 883180800000000000; nationality = "Denmark"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 516; teamId = 17; firstName = "Adam"; lastName = "Davies"; shirtNumber = 1; value = 22; dateOfBirth = 711331200000000000; nationality = "Wales"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 517; teamId = 17; firstName = "Wes"; lastName = "Foderingham"; shirtNumber = 18; value = 22; dateOfBirth = 663811200000000000; nationality = "England"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 518; teamId = 17; firstName = "Jordan"; lastName = "Amissah"; shirtNumber = 37; value = 22; dateOfBirth = 996710400000000000; nationality = "Germany"; position = 0; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 519; teamId = 17; firstName = "George"; lastName = "Baldock"; shirtNumber = 2; value = 42; dateOfBirth = 731635200000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 520; teamId = 17; firstName = "Chris"; lastName = "Basham"; shirtNumber = 6; value = 42; dateOfBirth = 585360000000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 521; teamId = 17; firstName = "John"; lastName = "Egan"; shirtNumber = 12; value = 42; dateOfBirth = 719539200000000000; nationality = "Ireland"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 522; teamId = 17; firstName = "Max"; lastName = "Lowe"; shirtNumber = 13; value = 42; dateOfBirth = 863308800000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 523; teamId = 17; firstName = "Anel"; lastName = "Ahmedhodzic"; shirtNumber = 15; value = 42; dateOfBirth = 922406400000000000; nationality = "Bosnia and Herzegovina"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 524; teamId = 17; firstName = "Jack"; lastName = "Robinson"; shirtNumber = 19; value = 42; dateOfBirth = 746841600000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 525; teamId = 17; firstName = "Jayden"; lastName = "Bogle"; shirtNumber = 20; value = 42; dateOfBirth = 964656000000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 526; teamId = 17; firstName = "Rhys"; lastName = "Norrington-Davies"; shirtNumber = 33; value = 42; dateOfBirth = 924739200000000000; nationality = "Wales"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 527; teamId = 17; firstName = "Yasser"; lastName = "Larouci"; shirtNumber = 27; value = 42; dateOfBirth = 978307200000000000; nationality = "Algeria"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 528; teamId = 17; firstName = "John"; lastName = "Fleck"; shirtNumber = 4; value = 42; dateOfBirth = 682992000000000000; nationality = "Scotland"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 529; teamId = 17; firstName = "Sander"; lastName = "Berge"; shirtNumber = 8; value = 42; dateOfBirth = 887414400000000000; nationality = "Norway"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 530; teamId = 17; firstName = "Oliver"; lastName = "Norwood"; shirtNumber = 16; value = 42; dateOfBirth = 671414400000000000; nationality = "Northern Ireland"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 531; teamId = 17; firstName = "Ismaila"; lastName = "Coulibaly"; shirtNumber = 17; value = 42; dateOfBirth = 977702400000000000; nationality = "Mali"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 532; teamId = 17; firstName = "Ben"; lastName = "Osborne"; shirtNumber = 23; value = 42; dateOfBirth = 776044800000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 533; teamId = 17; firstName = "Anis"; lastName = "Slimane"; shirtNumber = 25; value = 64; dateOfBirth = 984700800000000000; nationality = "Denmark"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 534; teamId = 17; firstName = "Rhian"; lastName = "Brewster"; shirtNumber = 7; value = 64; dateOfBirth = 954547200000000000; nationality = "England"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 535; teamId = 17; firstName = "Oliver"; lastName = "Mcburnie"; shirtNumber = 9; value = 64; dateOfBirth = 833846400000000000; nationality = "England"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 536; teamId = 17; firstName = "William"; lastName = "Osula"; shirtNumber = 32; value = 64; dateOfBirth = 1059955200000000000; nationality = "Denmark"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 537; teamId = 17; firstName = "Daniel"; lastName = "Jebbison"; shirtNumber = 36; value = 64; dateOfBirth = 1060732800000000000; nationality = "England"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 538; teamId = 17; firstName = "Bénie"; lastName = "Traoré"; shirtNumber = 11; value = 84; dateOfBirth = 1037923200000000000; nationality = "Ivory Coast"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 539; teamId = 18; firstName = "Cristian "; lastName = "Romero"; shirtNumber = 17; value = 42; dateOfBirth = 893635200000000000; nationality = "Argentina"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();},
            {id = 540; teamId = 7; firstName = "Alex"; lastName = "Disasi"; shirtNumber = 2; value = 64; dateOfBirth = 889574400000000000; nationality = "France"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>(); transferHistory = List.nil<T.TransferHistory>();}
        ]);
    };

/*  
    

    
    public func addMissingPlayers() : async (){
        players := List.append(players, List.fromArray<T.Player>([
            {id = 605; teamId = 4; firstName = "Saman"; lastName = "Ghoddos"; shirtNumber = 14; value = 42; dateOfBirth = 747273600000000000; nationality = "Sweden"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>();}
        ]));
        await updateHashForCategory("players");
    };

    public func squadAdjustments() : async (){
        var updatedPlayers = List.map<T.Player, T.Player>(players, func (p: T.Player): T.Player {

            if(p.id == 215){
                let updatedPlayer: T.Player = {
                    id = p.id;
                    teamId = 4;
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
                    retirementDate = p.retirementDate;
                };
                return updatedPlayer;
            } else { return p; }
        });

        players := updatedPlayers;
        await updateHashForCategory("players");
    };



        */

    /*

    public shared func setDefaultHashes(): async () {
        dataCacheHashes := List.fromArray([
            { category = "players"; hash = "DEFAULT_VALUE" },
            { category = "playerEventData"; hash = "DEFAULT_VALUE" }
        ]);
    };


    public func squadAdjustments() : async (){
        var updatedPlayers = List.map<T.Player, T.Player>(players, func (p: T.Player): T.Player {

            if(p.id == 57){
                let updatedPlayer: T.Player = {
                    id = p.id;
                    teamId = 17;
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
                    retirementDate = p.retirementDate;
                };
                return updatedPlayer;
            } else { return p; }
        });

        players := updatedPlayers;
    };


    public func addMissingPlayers() : async (){
        
        var updatedPlayers = players;

        players := List.append(players, List.fromArray<T.Player>([
            {id = 584; teamId = 17; firstName = "Luke"; lastName = "Thomas"; shirtNumber = 14; value = 22; dateOfBirth = 992131200000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>();},
        ]));
    };
    public func addMissingPlayers() : async (){
        
        var updatedPlayers = players;

        players := List.append(players, List.fromArray<T.Player>([
            {id = 563; teamId = 7; firstName = "Mykhaylo"; lastName = "Mudryk"; shirtNumber = 15; value = 126; dateOfBirth = 978652800000000000; nationality = "Ukraine"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>();},
            {id = 564; teamId = 11; firstName = "Wataru"; lastName = "Endō"; shirtNumber = 3; value = 84; dateOfBirth = 729216000000000000; nationality = "Japan"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>();},
            {id = 565; teamId = 15; firstName = "Tino"; lastName = "Livramento"; shirtNumber = 21; value = 42; dateOfBirth = 1037059200000000000; nationality = "England"; position = 1; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>();},
            {id = 566; teamId = 9; firstName = "Tyler"; lastName = "Onyango"; shirtNumber = 62; value = 42; dateOfBirth = 1046736000000000000; nationality = "England"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>();},
            {id = 567; teamId = 19; firstName = "Edson"; lastName = "Álvarez"; shirtNumber = 19; value = 64; dateOfBirth = 877651200000000000; nationality = "Mexico"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>();},
            {id = 568; teamId = 7; firstName = "Mason"; lastName = "Burstow"; shirtNumber = 37; value = 42; dateOfBirth = 1059955200000000000; nationality = "England"; position = 3; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>();},
            {id = 569; teamId = 7; firstName = "Lesley"; lastName = "Ugochukwu"; shirtNumber = 16; value = 42; dateOfBirth = 1080259200000000000; nationality = "France"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>();},
            {id = 570; teamId = 11; firstName = "Ben"; lastName = "Doak"; shirtNumber = 50; value = 42; dateOfBirth = 1131667200000000000; nationality = "Scotland"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>();},
            {id = 571; teamId = 6; firstName = "Anass"; lastName = "Zaroury"; shirtNumber = 19; value = 64; dateOfBirth = 973555200000000000; nationality = "Belgium"; position = 2; seasons = List.nil<T.PlayerSeason>(); injuryHistory = List.nil<T.InjuryHistory>(); isInjured = false; onLoan = false; parentTeamId = 0; retirementDate = 0; valueHistory = List.nil<T.ValueHistory>();}
        ]));

    };

    public func squadAdjustments() : async (){
        var updatedPlayers = List.map<T.Player, T.Player>(players, func (p: T.Player): T.Player {

            //Adjust Lawrence Vigourous (460) position to 0 (GK)
            //Adjust James Trafford (461) position to 0 (GK)
            if(p.id == 460 or p.id == 461){
                let updatedPlayer: T.Player = {
                    id = p.id;
                    teamId = p.teamId;
                    position = 0;
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
                    retirementDate = p.retirementDate;
                };
                return updatedPlayer;
            };

            return p;
        });

        players := updatedPlayers;
    };

    public func dataAdj() : async (){
        
        var updatedPlayers = List.map<T.Player, T.Player>(players, func (p: T.Player): T.Player {
                
            let updatedPlayer: T.Player = {
                id = p.id;
                teamId = p.teamId;
                position = p.position;
                firstName = p.firstName;
                lastName = p.lastName;
                shirtNumber = p.shirtNumber;
                value = p.value;
                dateOfBirth = p.dateOfBirth;
                nationality = p.nationality;
                seasons = List.nil<T.PlayerSeason>();
                valueHistory = p.valueHistory;
                onLoan = p.onLoan;
                parentTeamId = p.parentTeamId;
                isInjured = p.isInjured;
                injuryHistory = p.injuryHistory;
                retirementDate = p.retirementDate;
            };
            return updatedPlayer;
        });

        players := updatedPlayers;

            
        //Adjust James Trafford Position to 0
        //Adjust Lawrence Vigourous position to 0
        //Add AnAss Zaroury to Burnley - CHECK IF IN THERE
        //move thomas party to defender from midfield 
        //Move robert sanchez to chelsea from brighton
        



    };
    public shared func recalculatePlayerScores(fixture: T.Fixture, seasonId: Nat16, gameweek: Nat8) : async () {
        ignore await calculatePlayerScores(seasonId,gameweek,fixture);
    };

    public shared func adjustDuplicatedEvents(){
        
        players := List.map<T.Player, T.Player>(players, func (p: T.Player): T.Player {
            let updatedSeasons = List.map<T.PlayerSeason, T.PlayerSeason>(p.seasons, func(season: T.PlayerSeason) : T.PlayerSeason {
                return {
                    id = season.id;
                    gameweeks = List.map<T.PlayerGameweek, T.PlayerGameweek>(season.gameweeks, func(playerGameweek: T.PlayerGameweek) : T.PlayerGameweek{
                        return {
                            number = playerGameweek.number;
                            events = List.filter<T.PlayerEventData>(removeDuplicates(playerGameweek.events, p.id), func(event: T.PlayerEventData) : Bool {
                                return event.playerId == p.id;
                            });
                            points = playerGameweek.points;
                        }    
                    });
                };
            });

            let adjustedPlayer: T.Player = {
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
                parentTeamId = p.parentTeamId;
                isInjured = p.isInjured;
                injuryHistory = p.injuryHistory;
                retirementDate = p.retirementDate;
            };

            return adjustedPlayer;

        }); 
    };

    private func removeDuplicates(events: List.List<T.PlayerEventData>, playerId: Nat16): List.List<T.PlayerEventData> {
    var seenEvents: List.List<(T.PlayerEventData)> = List.nil<(T.PlayerEventData)>();
        return List.filter<T.PlayerEventData>(events, func(event: T.PlayerEventData): Bool {
            let uniqueTuple: T.PlayerEventData = {
                fixtureId = event.fixtureId;
                playerId = event.playerId;
                eventType = event.eventType;
                eventStartMinute = event.eventStartMinute;
                eventEndMinute = event.eventEndMinute;
                teamId = event.teamId;
            };
            if (isTupleSeen(seenEvents, uniqueTuple)) {
                return false;
            } else {
                seenEvents := List.append<T.PlayerEventData>(seenEvents, List.fromArray<T.PlayerEventData>([uniqueTuple]));
                return true;
            }
        });
    };

    private func isTupleSeen(seenEvents: List.List<(T.PlayerEventData)>, uniqueTuple: (T.PlayerEventData)): Bool {
        switch (seenEvents) {
            case (null) { return false; };
            case (?(head, tail)) {
                if (head == uniqueTuple) {
                    return true;
                } else {
                    return isTupleSeen(tail, uniqueTuple);
                }
            }
        }
    };
    */

};
