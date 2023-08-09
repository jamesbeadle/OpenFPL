import T "../OpenFPL_backend/types";
import DTOs "../OpenFPL_backend/DTOs";
import List "mo:base/List";
import Principal "mo:base/Principal";
import GenesisData "../OpenFPL_backend/genesis-data";
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

actor Self {

    private var players = List.fromArray<T.Player>(GenesisData.get_genesis_players());
    private var nextPlayerId : Nat = 560;
    private var retiredPlayers = List.fromArray<T.Player>([]);

    public shared query ({caller}) func getAllPlayers() : async [DTOs.PlayerDTO] {
        assert not Principal.isAnonymous(caller);

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

    public query ({caller}) func getAllPlayersMap(seasonId: Nat16, gameweek: Nat8) : async [(Nat16, DTOs.PlayerScoreDTO)] {
        assert not Principal.isAnonymous(caller);

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
                        };

                        for (event in Iter.fromList(gw.events)) {
                            switch (event.eventType) {
                                case (1) { goalsScored += 1; }; 
                                case (2) { assists += 1; };
                                case (3) { goalsConceded += 1; };
                                case (4) { saves += 1; };
                                case _ {};
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

    public query ({caller}) func getPlayer(playerId: Nat16) : async T.Player {
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
                retirementDate = 0; } };
            case (?player) { return player; };
        };
    };

    public shared func revaluePlayers(seasonId: Nat16, gameweek: Nat8, revaluedPlayers: List.List<T.RevaluedPlayer>) : async () {
        /*
        let changeAmount: Float = 250000000;

        for (revaluedPlayer in Iter.fromList(revaluedPlayers)) {
            var updatedPlayers = List.map<T.Player, T.Player>(players, func (p: T.Player): T.Player {
                if (p.id == revaluedPlayer.playerId) {
                    var newValue = p.value;

                    switch (revaluedPlayer.direction) {
                        case (#Increase) {
                            newValue += changeAmount;
                        };
                        case (#Decrease) {
                            if (p.value > changeAmount) {
                                newValue -= changeAmount;
                            }
                        };
                    };
        
                    let historyEntry: T.ValueHistory = {
                        seasonId = seasonId;
                        gameweek = gameweek;
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
                    };

                    return updatedPlayer;
                };
                return p;
            });

            players := updatedPlayers;
        }
        */
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
            
            Debug.print(debug_show playerId # " " # Int16.toText(totalScore));
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
                    } else { //alerady got seasons
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
                                                events = fixture.events;
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
    
    public shared func transferPlayer(proposalPayload: T.TransferPlayerPayload) : async () {
        let player = List.find<T.Player>(players, func(p: T.Player) { p.id == proposalPayload.playerId });
        switch(player){
            case (null) { };
            case (?p) {
                let updatedPlayer: T.Player = {
                    id = p.id;
                    teamId = proposalPayload.newTeamId;
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

    public shared func loanPlayer(proposalPayload: T.LoanPlayerPayload) : async () {
        let playerToLoan = List.find<T.Player>(players, func(p: T.Player) { p.id == proposalPayload.playerId });
        switch(playerToLoan) {
            case (null) { };
            case (?p) {
                let loanedPlayer: T.Player = {
                    id = p.id;
                    teamId = proposalPayload.loanTeamId;
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
                };
                players := List.map<T.Player, T.Player>(players, func(currentPlayer: T.Player) : T.Player {
                    if (currentPlayer.id == loanedPlayer.id) {
                        return loanedPlayer;
                    } else {
                        return currentPlayer;
                    }
                });
                
                let loanTimerDuration = #nanoseconds (Int.abs((proposalPayload.loanEndDate - Time.now())));
                await setAndBackupTimer(loanTimerDuration, "loanExpired", proposalPayload.playerId);
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

    private func loanComplete() : async (){
        let currentTime = Time.now();

        for (timer in Iter.fromArray(stable_timers)) {
            if (timer.triggerTime <= currentTime and timer.callbackName == "loanExpired") {
                let playerToReturn = List.find<T.Player>(players, func(p: T.Player) { p.id == timer.playerId });
                
                switch(playerToReturn) {
                    case (null) { }; 
                    case (?p) {
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
                        };

                        players := List.map<T.Player, T.Player>(players, func(currentPlayer: T.Player) : T.Player {
                            if (currentPlayer.id == returnedPlayer.id) {
                                return returnedPlayer;
                            } else {
                                return currentPlayer;
                            }
                        });
                    };
                };
            }
        };

        stable_timers := Array.filter<T.TimerInfo>(stable_timers, func(timer: T.TimerInfo) : Bool {
            return timer.triggerTime > currentTime;
        });
    };

    private func loanExpiredCallback() : async () {
        let currentTime = Time.now();
        
        for (timer in Iter.fromArray(stable_timers)) {
            if (timer.callbackName == "loanExpired") {
                let playerToReturn = List.find<T.Player>(players, func(p: T.Player) { p.id == timer.playerId });
                
                switch(playerToReturn) {
                    case (null) { }; 
                    case (?p) {
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
                    };
                };
            }
        }
    };


    private func defaultCallback() : async () { };

    public shared func recallPlayer(proposalPayload: T.RecallPlayerPayload) : async () {
        let playerToRecall = List.find<T.Player>(players, func(p: T.Player) { p.id == proposalPayload.playerId });
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


    public shared func createPlayer(proposalPayload: T.CreatePlayerPayload) : async () {
        let newPlayer: T.Player = {
            id = Nat16.fromNat(nextPlayerId + 1);
            teamId = proposalPayload.teamId;
            position = proposalPayload.position;
            firstName = proposalPayload.firstName;
            lastName = proposalPayload.lastName;
            shirtNumber = proposalPayload.shirtNumber;
            value = proposalPayload.value;
            dateOfBirth = proposalPayload.dateOfBirth;
            nationality = proposalPayload.nationality;
            seasons = List.nil<T.PlayerSeason>();
            valueHistory = List.nil<T.ValueHistory>();
            onLoan = false;
            parentTeamId = 0;
            isInjured = false;
            injuryHistory = List.nil<T.InjuryHistory>();
            retirementDate = 0;
        };
        players := List.push(newPlayer, players);
        nextPlayerId += 1;
    };

    public shared func updatePlayer(proposalPayload: T.UpdatePlayerPayload) : async () {
        players := List.map<T.Player, T.Player>(players, func(currentPlayer: T.Player) : T.Player {
            if (currentPlayer.id == proposalPayload.playerId) {
                return {
                    id = currentPlayer.id;
                    teamId = proposalPayload.teamId;
                    position = proposalPayload.position;
                    firstName = proposalPayload.firstName;
                    lastName = proposalPayload.lastName;
                    shirtNumber = proposalPayload.shirtNumber;
                    value = currentPlayer.value;
                    dateOfBirth = proposalPayload.dateOfBirth;
                    nationality = proposalPayload.nationality;
                    seasons = currentPlayer.seasons;
                    valueHistory = currentPlayer.valueHistory;
                    onLoan = currentPlayer.onLoan;
                    parentTeamId = currentPlayer.parentTeamId;
                    isInjured = currentPlayer.isInjured;
                    injuryHistory = currentPlayer.injuryHistory;
                    retirementDate = currentPlayer.retirementDate;
                };
            } else {
                return currentPlayer;
            }
        });
    };
    
    public shared func setPlayerInjury(proposalPayload: T.SetPlayerInjuryPayload) : async () {
        players := List.map<T.Player, T.Player>(players, func(currentPlayer: T.Player) : T.Player {
            if (currentPlayer.id == proposalPayload.playerId) {
                if (proposalPayload.recovered) {
                    let updatedInjuryHistory = List.map<T.InjuryHistory, T.InjuryHistory>(currentPlayer.injuryHistory, func(injury: T.InjuryHistory) : T.InjuryHistory {
                        if (injury.expectedEndDate > Time.now()) {
                            return {
                                description = injury.description;
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
                    };
                } else {
                    let newInjury: T.InjuryHistory = {
                        description = proposalPayload.injuryDescription;
                        expectedEndDate = proposalPayload.expectedEndDate;
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
                    };
                }
            } else {
                return currentPlayer;
            }
        });
    };
    
    public shared func retirePlayer(proposalPayload: T.RetirePlayerPayload) : async () {
        let playerToRetire = List.find<T.Player>(players, func(p: T.Player) { p.id == proposalPayload.playerId });
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
                    retirementDate = proposalPayload.retirementDate;
                };
                
                retiredPlayers := List.push(retiredPlayer, retiredPlayers);
                players := List.filter<T.Player>(players, func(currentPlayer: T.Player) : Bool {
                    return currentPlayer.id != proposalPayload.playerId;
                });
            };
        };
    };

    public shared func unretirePlayer(proposalPayload: T.UnretirePlayerPayload) : async () {
        let playerToUnretire = List.find<T.Player>(retiredPlayers, func(p: T.Player) { p.id == proposalPayload.playerId });
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
                };
                
                players := List.push(activePlayer, players);
                retiredPlayers := List.filter<T.Player>(retiredPlayers, func(currentPlayer: T.Player) : Bool {
                    return currentPlayer.id != proposalPayload.playerId;
                });
            };
        };
    };

    private stable var stable_players: [T.Player] = [];
    private stable var stable_next_player_id : Nat = 0;
    private stable var stable_timers: [T.TimerInfo] = [];

    system func preupgrade() {
        stable_players := List.toArray(players);
        stable_next_player_id := nextPlayerId;
    };

    system func postupgrade() {
        if(stable_players != []){
            players := List.fromArray(stable_players);
        };
        nextPlayerId := stable_next_player_id;
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


};
