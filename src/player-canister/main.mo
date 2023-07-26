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

actor Self {

    private var players = List.fromArray<T.Player>(GenesisData.get_genesis_players());
    private var nextPlayerId : Nat = 560;

    private stable var stable_players: [T.Player] = [];
    private stable var stable_next_player_id : Nat = 0;

    public shared query ({caller}) func getPlayers(teamId: Nat16, positionId: Int, start: Nat, count: Nat) : async DTOs.PlayerRatingsDTO {
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

    let returnPlayers = List.map<T.Player, T.Player>(
        List.filter<T.Player>(players, func (player: T.Player) : Bool {
        return (teamId == 0 or player.teamId == teamId) and (positionId == -1 or Nat8.toNat(player.position) == positionId);
        }), 
        func (player: T.Player) : T.Player {
        return {
            id = player.id;
            teamId = player.teamId;
            position = player.position; //0 = Goalkeeper //1 = Defender //2 = Midfielder //3 = Forward
            firstName = player.firstName;
            lastName = player.lastName;
            shirtNumber = player.shirtNumber;
            value = player.value;
            dateOfBirth = player.dateOfBirth;
            nationality = player.nationality;
            seasons = List.nil<T.PlayerSeason>();
        };
    });

    let sortedPlayers = mergeSort(returnPlayers);

    let paginatedPlayers = List.take(List.drop(sortedPlayers, start), count);

    let dto: DTOs.PlayerRatingsDTO = {
        players = List.toArray(paginatedPlayers);
        totalEntries = Nat16.fromNat(List.size<T.Player>(returnPlayers));
    };

    return dto;

    };

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

    public query ({caller}) func getAllPlayersMap(seasonId: Nat16, gameweek: Nat8) : async [(Nat16, DTOs.PlayerScoreDTO)] {
        assert not Principal.isAnonymous(caller);

        let eq = func (a: Nat16, b: Nat16) : Bool {
            a == b
        };

        let hashNat16 = func (key: Nat16) : Hash.Hash {
            Nat32.fromNat(Nat16.toNat(key)%(2 ** 32 -1));
        };
        var playersMap: HashMap.HashMap<Nat16, DTOs.PlayerScoreDTO> = HashMap.HashMap<Nat16, DTOs.PlayerScoreDTO>(500, eq, hashNat16);
        for (player in Iter.fromList(players)) {

            var points: Int16 = 0;
            var events: List.List<T.PlayerEventData> = List.nil();
            var goalsScored: Nat8 = 0;
            var goalsConceded: Nat8 = 0;
            var saves: Nat8 = 0;

            for (season in Iter.fromList(player.seasons)) {
                if (season.year == seasonId) {
                    for (gw in Iter.fromList(season.gameweeks)) {

                        if (gw.number == gameweek) {
                            points := gw.points;
                            events := gw.events;
                        };

                        for (event in Iter.fromList(gw.events)) {
                            switch (event.eventType) {
                                case (1) { goalsScored += 1; }; 
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
            };
        };
        return Iter.toArray(playersMap.entries());
    };


    public query ({caller}) func getPlayer(playerId: Nat16) : async T.Player {
        let foundPlayer = List.find<T.Player>(players, func (player: T.Player): Bool {
            return player.id == playerId;
        });

        switch (foundPlayer) {
            case (null) { return { id = 0; teamId = 0; position = 0; firstName = ""; lastName = ""; shirtNumber = 0; value = 0; dateOfBirth = 0; nationality = ""; seasons = List.nil<T.PlayerSeason>(); } };
            case (?player) { return player; };
        };
    };

    public func revaluePlayers(revaluedPlayers: [T.Player]){

        //update the players value in the player canister
        //ensure the prior value is recorded
    };

    public func calculatePlayerScores(seasonId: Nat16, gameweek: Nat8, gameweekFixtures: [T.Fixture]) : async [T.Fixture] {

        let eq = func (a: Nat16, b: Nat16) : Bool {
            a == b
        };

        let hashNat16 = func (key: Nat16) : Hash.Hash {
            Nat32.fromNat(Nat16.toNat(key)%(2 ** 32 -1));
        };

        let playerEventsMap: HashMap.HashMap<Nat16, [T.PlayerEventData]> = HashMap.HashMap<Nat16, [T.PlayerEventData]>(22, eq, hashNat16);
        for (i in Iter.range(0, Array.size(gameweekFixtures)-1)) {  
            
            let fixture = gameweekFixtures[i];
            let events = List.toArray<T.PlayerEventData>(fixture.events);

            for (j in Iter.range(0, Array.size(events)-1)) {
                let event = events[j];
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
        };

        let playerScoresMap: HashMap.HashMap<Nat16, Int16> = HashMap.HashMap<Nat16, Int16>(22, eq, hashNat16);
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
            switch (?player) {
                case null {};
                case (?p) {
                    let updatedSeasons = List.map<T.PlayerSeason, T.PlayerSeason>(
                        p.seasons,
                        func (season: T.PlayerSeason) : T.PlayerSeason {
                            if (season.year != seasonId) {
                                return season;
                            };
                            
                            let updatedGameweeks = List.map<T.PlayerGameweek, T.PlayerGameweek>(
                                season.gameweeks,
                                func (gw: T.PlayerGameweek) : T.PlayerGameweek {
                                    if (gw.number != gameweek) {
                                        return gw;
                                    };
                                    
                                    return {
                                        number = gw.number;
                                        events = gw.events;
                                        points = score;
                                    };
                                }
                            );
                            
                            return {
                                year = season.year;
                                gameweeks = updatedGameweeks;
                            };
                        }
                    );

                    let updatedPlayer = {
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
                    };

                    players := List.map<T.Player, T.Player>(players, func (player: T.Player): T.Player {
                        if (player.id == updatedPlayer.id) { updatedPlayer } else { player }
                    });

                };
            };
        };


        var updatedFixtures: [T.Fixture] = [];
        let updatedFixturesBuffer = Buffer.fromArray<T.Fixture>(updatedFixtures);

        for (i in Iter.range(0, Array.size(gameweekFixtures)-1)) {  
            let fixture = gameweekFixtures[i];
            let fixtureEvents = List.toArray<T.PlayerEventData>(fixture.events);
            var highestScore: Int16 = 0;
            var highestScoringPlayerId: Nat16 = 0;
            var isUniqueHighScore: Bool = true; 

            // Create a buffer to hold unique playerIds
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
            homeGoals = fixture.homeGoals;
            awayGoals = fixture.awayGoals;
            status = fixture.status;
            events = fixture.events;
            highestScoringPlayerId = newHighScoringPlayerId;
            };

            updatedFixturesBuffer.add(updatedFixture);
        };

        updatedFixtures := Buffer.toArray<T.Fixture>(updatedFixturesBuffer);
        return updatedFixtures;
    };

    func calculateAggregatePlayerEvents(events: [T.PlayerEventData], playerPosition: Nat8): Int16 {
        var totalScore: Int16 = 0;

        if (playerPosition == 0 or playerPosition == 1) {
            let goalsConcededCount = Array.filter<T.PlayerEventData>(
                events,
                func (event: T.PlayerEventData): Bool { event.eventType == 3 }
            ).size();

            if (goalsConcededCount >= 2) {
                
                totalScore := totalScore + (Int16.fromNat16(Nat16.fromNat(goalsConcededCount)) / 2) * -15;
            }
        };


        if (playerPosition == 0) {
            let savesCount = Array.filter<T.PlayerEventData>(
                events,
                func (event: T.PlayerEventData): Bool { event.eventType == 4 }
            ).size();

            totalScore := totalScore + (Int16.fromNat16(Nat16.fromNat(savesCount)) / 3) * 5;
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
            case 3 { return 0; };  // Handled in aggregate
            case 4 { 
                switch (playerPosition) {
                    case 0 { return 10; };
                    case 1 { return 10; };
                    case _ { return 0; };
                }
            };
            case 5 { return 20; };  // Goalkeeper saves a penalty
            case 6 { return -15; };  // Player misses a penalty
            case 7 { return -5; };   // Yellow Card
            case 8 { return -20; };  // Red Card
            case 9 { return -10; };  // Own Goal
            case 10 { return 0; };  // Handled after all players calculated
            case _ { return 0; };
        };
    };


    system func heartbeat() : async () {
        
    };

    system func preupgrade() {
        stable_players := List.toArray(players);
        stable_next_player_id := nextPlayerId;
    };

    system func postupgrade() {
        players := List.fromArray(stable_players);
        nextPlayerId := stable_next_player_id;
    };

};
