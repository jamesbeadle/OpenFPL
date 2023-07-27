import T "types";
import DTOs "DTOs";
import List "mo:base/List";
import Array "mo:base/Array";
import Iter "mo:base/Iter";
import Float "mo:base/Float";
import Nat8 "mo:base/Nat8";
import Nat16 "mo:base/Nat16";
import Order "mo:base/Order";
import Result "mo:base/Result";
import HashMap "mo:base/HashMap";
import Text "mo:base/Text";
import Option "mo:base/Option";
import Utilities "utilities";

module {
    public class FantasyTeams(getAllPlayersMap: (seasonId: Nat16, gameweek: Nat8) -> async [(Nat16, DTOs.PlayerScoreDTO)]){
        
        private var fantasyTeams: HashMap.HashMap<Text, T.UserFantasyTeam> = HashMap.HashMap<Text, T.UserFantasyTeam>(100, Text.equal, Text.hash);

        public func setData(stable_fantasy_teams: [(Text, T.UserFantasyTeam)]){
            fantasyTeams := HashMap.fromIter<Text, T.UserFantasyTeam>(
                stable_fantasy_teams.vals(), stable_fantasy_teams.size(), Text.equal, Text.hash);
        };

        public func getFantasyTeams() : [(Text, T.UserFantasyTeam)] {
            return Iter.toArray(fantasyTeams.entries());
        };

        public func getFantasyTeam(principalId: Text) : ?T.UserFantasyTeam {
            return fantasyTeams.get(principalId);
        };

        public func createFantasyTeam(principalId: Text, gameweek: Nat8, newPlayers: [DTOs.PlayerDTO], captainId: Nat16, bonusId: Nat8, bonusPlayerId: Nat16, bonusTeamId: Nat16) : Result.Result<(), T.Error> {

             let existingTeam = fantasyTeams.get(principalId);
            
            switch (existingTeam) {
                case (null) { 

                    let allPlayerValues = Array.map<DTOs.PlayerDTO, Float>(newPlayers, func (player: DTOs.PlayerDTO) : Float { return player.value; });

                    if(not isTeamValid(newPlayers, bonusId, bonusPlayerId)){
                        return #err(#InvalidTeamError);
                    };

                    let totalTeamValue = Array.foldLeft<Float, Float>(allPlayerValues, 0, func(sumSoFar, x) = sumSoFar + x);
                    if(totalTeamValue > Float.fromInt(300_000_000)){
                        return #err(#InvalidTeamError);
                    };

                    var bankBalance = 300_000_000 - (totalTeamValue * 1_000_000);
                    var goalGetterGameweek = Nat8.fromNat(0);
                    var goalGetterPlayerId = Nat16.fromNat(0);
                    var passMasterGameweek = Nat8.fromNat(0);
                    var passMasterPlayerId = Nat16.fromNat(0);
                    var noEntryGameweek = Nat8.fromNat(0);
                    var noEntryPlayerId = Nat16.fromNat(0);
                    var teamBoostGameweek = Nat8.fromNat(0);
                    var teamBoostTeamId = Nat16.fromNat(0);
                    var safeHandsGameweek = Nat8.fromNat(0);
                    var safeHandsPlayerId = Nat16.fromNat(0);
                    var captainFantasticGameweek = Nat8.fromNat(0);
                    var captainFantasticPlayerId = Nat16.fromNat(0);
                    var braceBonusGameweek = Nat8.fromNat(0);
                    var hatTrickHeroGameweek = Nat8.fromNat(0);
                    var newCaptainId = captainId;

                    let sortedPlayers = sortPlayers(newPlayers);       
                    let allPlayerIds = Array.map<DTOs.PlayerDTO, Nat16>(sortedPlayers, func (player: DTOs.PlayerDTO) : Nat16 { return player.id; });
                    
                    if(newCaptainId == 0){
                        var highestValue = Float.fromInt(0);
                        for (i in Iter.range(0, Array.size(newPlayers)-1)) {
                            if(newPlayers[i].value > highestValue){
                                highestValue := newPlayers[i].value; 
                                newCaptainId := newPlayers[i].id;
                            };
                        };
                    };
                    
                    if(bonusId == 1 and bonusPlayerId > 0){
                        goalGetterGameweek := gameweek;
                        goalGetterPlayerId := bonusPlayerId;
                    };

                    if(bonusId == 2 and bonusPlayerId > 0){
                        passMasterGameweek := gameweek;
                        passMasterPlayerId := bonusPlayerId;
                    };

                    if(bonusId == 3 and bonusPlayerId > 0){
                        noEntryGameweek := gameweek;
                        noEntryPlayerId := bonusPlayerId;
                    };

                    if(bonusId == 4 and bonusTeamId > 0){
                        teamBoostGameweek := gameweek;
                        teamBoostTeamId := bonusTeamId;
                    };

                    if(bonusId == 5 and bonusPlayerId > 0){
                        safeHandsGameweek := gameweek;
                        safeHandsPlayerId := bonusPlayerId;
                    };


                    if(bonusId == 6 and bonusPlayerId > 0){
                        captainFantasticGameweek := gameweek;
                        captainFantasticPlayerId := bonusPlayerId;
                    };


                    if(bonusId == 7){
                        braceBonusGameweek := gameweek;
                    };


                    if(bonusId == 8){
                        hatTrickHeroGameweek := gameweek;
                    };

                    var newTeam: T.FantasyTeam = {
                        principalId = principalId;
                        bankBalance = bankBalance;
                        playerIds = allPlayerIds;
                        transfersAvailable = 2;
                        captainId = newCaptainId;
                        goalGetterGameweek = goalGetterGameweek;
                        goalGetterPlayerId = goalGetterPlayerId;
                        passMasterGameweek = passMasterGameweek;
                        passMasterPlayerId = passMasterPlayerId;
                        noEntryGameweek = noEntryGameweek;
                        noEntryPlayerId = noEntryPlayerId;
                        teamBoostGameweek = teamBoostGameweek;
                        teamBoostTeamId = teamBoostTeamId;
                        safeHandsGameweek = safeHandsGameweek;
                        safeHandsPlayerId = safeHandsPlayerId;
                        captainFantasticGameweek = captainFantasticGameweek;
                        captainFantasticPlayerId = captainFantasticPlayerId;
                        braceBonusGameweek = braceBonusGameweek;
                        hatTrickHeroGameweek = hatTrickHeroGameweek;
                    };

                    let newUserTeam: T.UserFantasyTeam = {
                        fantasyTeam = newTeam;
                        history = List.nil<T.FantasyTeamSeason>();
                    };

                    fantasyTeams.put(principalId, newUserTeam);
                    return #ok(());
                };
                case (?existingTeam) { return #ok(()); };
            };
        };

        public func updateFantasyTeam(principalId: Text, newPlayers: [DTOs.PlayerDTO], captainId: Nat16, bonusId: Nat8, bonusPlayerId: Nat16, bonusTeamId: Nat16, gameweek: Nat8, existingPlayers: [DTOs.PlayerDTO]) : Result.Result<(), T.Error> {
            
            let existingUserTeam = fantasyTeams.get(principalId);
   
            switch (existingUserTeam) {
                case (null) { return #ok(()); };
                case (?e) { 
                    let existingTeam = e.fantasyTeam;
                    let allPlayerValues = Array.map<DTOs.PlayerDTO, Float>(newPlayers, func (player: DTOs.PlayerDTO) : Float { return player.value; });
                    
                    if(not isTeamValid(newPlayers, bonusId, bonusPlayerId)){
                        return #err(#InvalidTeamError);
                    };

                    let playersAdded = Array.filter<DTOs.PlayerDTO>(newPlayers, func (player: DTOs.PlayerDTO): Bool {
                        let playerId = player.id;
                        let isPlayerIdInExistingTeam = Array.find(existingTeam.playerIds, func (id: Nat16): Bool {
                            return id == playerId;
                        });
                        return Option.isNull(isPlayerIdInExistingTeam);
                    });

                    if(Nat8.fromNat(Array.size(playersAdded)) > existingTeam.transfersAvailable and gameweek != 1){
                        return #err(#InvalidTeamError);
                    };

                    let playersRemoved = Array.filter<Nat16>(existingTeam.playerIds, func (playerId: Nat16): Bool {
                        let isPlayerIdInPlayers = Array.find(newPlayers, func (player: DTOs.PlayerDTO): Bool {
                            return player.id == playerId;
                        });
                        return Option.isNull(isPlayerIdInPlayers);
                    });

                    let spent = Array.foldLeft<DTOs.PlayerDTO, Float>(playersAdded, 0, func(sumSoFar, x) = sumSoFar + x.value);
                    var sold = 0.0;
                    for (i in Iter.range(0, Array.size(playersRemoved)-1)) {
                        let player = Array.find(newPlayers, func (player: DTOs.PlayerDTO): Bool {
                            return player.id == playersRemoved[i];
                        });
                        switch(player){
                            case (null) {};
                            case (?p) {
                                sold := sold + p.value;
                            };
                        };
                    };

                    if(spent - sold > existingTeam.bankBalance){
                        return #err(#InvalidTeamError);
                    };

                    if(bonusId == 1 and existingTeam.goalGetterGameweek != 0){
                        return #err(#InvalidTeamError);
                    };

                    if(bonusId == 2 and existingTeam.passMasterGameweek != 0){
                        return #err(#InvalidTeamError);
                    };

                    if(bonusId == 3 and existingTeam.noEntryGameweek != 0){
                        return #err(#InvalidTeamError);
                    };

                    if(bonusId == 4 and existingTeam.teamBoostGameweek != 0){
                        return #err(#InvalidTeamError);
                    };

                    if(bonusId == 5 and existingTeam.safeHandsGameweek != 0){
                        return #err(#InvalidTeamError);
                    };

                    if(bonusId == 6 and existingTeam.captainFantasticGameweek != 0){
                        return #err(#InvalidTeamError);
                    };

                    if(bonusId == 7 and existingTeam.braceBonusGameweek != 0){
                        return #err(#InvalidTeamError);
                    };

                    if(bonusId == 8 and existingTeam.hatTrickHeroGameweek != 0){
                        return #err(#InvalidTeamError);
                    };

                    if(bonusId > 0 and (
                        existingTeam.goalGetterGameweek == gameweek 
                        or existingTeam.passMasterGameweek == gameweek
                        or existingTeam.noEntryGameweek == gameweek
                        or existingTeam.teamBoostGameweek == gameweek
                        or existingTeam.safeHandsGameweek == gameweek
                        or existingTeam.captainFantasticGameweek == gameweek
                        or existingTeam.braceBonusGameweek == gameweek
                        or existingTeam.hatTrickHeroGameweek == gameweek)){
                            return #err(#InvalidTeamError);
                    };


                    var goalGetterGameweek = existingTeam.goalGetterGameweek;
                    var goalGetterPlayerId = existingTeam.goalGetterPlayerId;
                    var passMasterGameweek = existingTeam.passMasterGameweek;
                    var passMasterPlayerId = existingTeam.passMasterPlayerId;
                    var noEntryGameweek = existingTeam.noEntryGameweek;
                    var noEntryPlayerId = existingTeam.noEntryPlayerId;
                    var teamBoostGameweek = existingTeam.teamBoostGameweek;
                    var teamBoostTeamId = existingTeam.teamBoostTeamId;
                    var safeHandsGameweek = existingTeam.safeHandsGameweek;
                    var safeHandsPlayerId = existingTeam.safeHandsPlayerId;
                    var captainFantasticGameweek = existingTeam.captainFantasticGameweek;
                    var captainFantasticPlayerId = existingTeam.captainFantasticPlayerId;
                    var braceBonusGameweek = existingTeam.braceBonusGameweek;
                    var hatTrickHeroGameweek = existingTeam.hatTrickHeroGameweek;
                    var newCaptainId = captainId;

                    let sortedPlayers = sortPlayers(newPlayers);       
                    let allPlayerIds = Array.map<DTOs.PlayerDTO, Nat16>(sortedPlayers, func (player: DTOs.PlayerDTO) : Nat16 { return player.id; });    
                    
                    if(newCaptainId == 0){
                        var highestValue = Float.fromInt(0);
                        for (i in Iter.range(0, Array.size(newPlayers)-1)) {
                            if(newPlayers[i].value > highestValue){
                                highestValue := newPlayers[i].value; 
                                newCaptainId := newPlayers[i].id;
                            };
                        };
                    };
                    
                    if(bonusId == 1 and bonusPlayerId > 0){
                        goalGetterGameweek := gameweek;
                        goalGetterPlayerId := bonusPlayerId;
                    };

                    if(bonusId == 2 and bonusPlayerId > 0){
                        passMasterGameweek := gameweek;
                        passMasterPlayerId := bonusPlayerId;
                    };

                    if(bonusId == 3 and bonusPlayerId > 0){
                        noEntryGameweek := gameweek;
                        noEntryPlayerId := bonusPlayerId;
                    };

                    if(bonusId == 4 and bonusTeamId > 0){
                        teamBoostGameweek := gameweek;
                        teamBoostTeamId := bonusTeamId;
                    };

                    if(bonusId == 5 and bonusPlayerId > 0){
                        safeHandsGameweek := gameweek;
                        safeHandsPlayerId := bonusPlayerId;
                    };


                    if(bonusId == 6 and bonusPlayerId > 0){
                        captainFantasticGameweek := gameweek;
                        captainFantasticPlayerId := bonusPlayerId;
                    };


                    if(bonusId == 7){
                        braceBonusGameweek := gameweek;
                    };


                    if(bonusId == 8){
                        hatTrickHeroGameweek := gameweek;
                    };
                   
                    let updatedTeam: T.FantasyTeam = {
                        principalId = principalId;
                        bankBalance = existingTeam.bankBalance - spent + sold;
                        playerIds = allPlayerIds;
                        transfersAvailable = existingTeam.transfersAvailable - Nat8.fromNat(Array.size(playersAdded));
                        captainId = newCaptainId;
                        goalGetterGameweek = goalGetterGameweek;
                        goalGetterPlayerId = goalGetterPlayerId;
                        passMasterGameweek = passMasterGameweek;
                        passMasterPlayerId = passMasterPlayerId;
                        noEntryGameweek = noEntryGameweek;
                        noEntryPlayerId = noEntryPlayerId;
                        teamBoostGameweek = teamBoostGameweek;
                        teamBoostTeamId = teamBoostTeamId;
                        safeHandsGameweek = safeHandsGameweek;
                        safeHandsPlayerId = safeHandsPlayerId;
                        captainFantasticGameweek = captainFantasticGameweek;
                        captainFantasticPlayerId = captainFantasticPlayerId;
                        braceBonusGameweek = braceBonusGameweek;
                        hatTrickHeroGameweek = hatTrickHeroGameweek;
                    };

                    let updatedUserTeam: T.UserFantasyTeam = {
                        fantasyTeam = updatedTeam;
                        history = e.history;
                    };

                    fantasyTeams.put(principalId, updatedUserTeam);
                    return #ok(());
                };
            };
        };

        private func sortPlayers(players: [DTOs.PlayerDTO]) : [DTOs.PlayerDTO] {
            
            let sortedPlayers = Array.sort(players, func(a: DTOs.PlayerDTO, b: DTOs.PlayerDTO): Order.Order {
                if (a.position < b.position) { return #less; };
                if (a.position > b.position) { return #greater; };
                if (a.value > b.value) { return #less; };
                if (a.value < b.value) { return #greater; };
                return #equal;
            });
            return sortedPlayers;
        };

        public func isTeamValid(players: [DTOs.PlayerDTO], bonusId: Nat8, bonusPlayerId: Nat16) : Bool {
            let playerPositions = Array.map<DTOs.PlayerDTO, Nat8>(players, func (player: DTOs.PlayerDTO) : Nat8 { return player.position; });
                    
            let playerCount = playerPositions.size();
            if(playerCount != 11 ){
                return false;
            };
            
            var teamPlayerCounts = HashMap.HashMap<Text, Nat8>(0, Text.equal, Text.hash);
            var playerIdCounts = HashMap.HashMap<Text, Nat8>(0, Text.equal, Text.hash);  // HashMap to store player ids as Text
            var goalkeeperCount = 0;
            var defenderCount = 0;
            var midfielderCount = 0;
            var forwardCount = 0;

            for (i in Iter.range(0, playerCount-1)) {
                let count = teamPlayerCounts.get(Nat16.toText(players[i].teamId));
                switch(count){
                    case (null) { teamPlayerCounts.put(Nat16.toText(players[i].teamId), 1); };
                    case (?count){
                        teamPlayerCounts.put(Nat16.toText(players[i].teamId), count + 1);
                    };
                };
        
                let playerIdCount = playerIdCounts.get(Nat16.toText(players[i].id));
                switch(playerIdCount){
                    case (null) { playerIdCounts.put(Nat16.toText(players[i].id), 1); };
                    case (?count){
                        return false;
                    };
                };

                if(players[i].position == 0){
                    goalkeeperCount += 1;
                };

                if(players[i].position == 1){
                    defenderCount += 1;
                };
                
                if(players[i].position == 2){
                    midfielderCount += 1;
                };
                
                if(players[i].position == 3){
                    forwardCount += 1;
                };

            };
            
            for ((key, value) in teamPlayerCounts.entries()) {
                if(value > 3){
                    return false;
                };
            };
            
            if (goalkeeperCount != 1 or defenderCount < 3 or defenderCount > 5 or
                midfielderCount < 3 or midfielderCount > 5 or forwardCount < 1 or forwardCount > 3 ){
                return false;
            };

            if (bonusId == 3) {
                let bonusPlayer = List.find<DTOs.PlayerDTO>(List.fromArray(players), func (player: DTOs.PlayerDTO): Bool {
                    return player.id == bonusPlayerId;
                });
                switch(bonusPlayer){
                    case(null) { return false; };
                    case(?player) {
                        if (player.position != 1) { return false; };
                    };
                };
            };

            if (bonusId == 5) {
                let bonusPlayer = List.find<DTOs.PlayerDTO>(List.fromArray(players), func (player: DTOs.PlayerDTO): Bool {
                    return player.id == bonusPlayerId;
                });
                switch(bonusPlayer){
                    case(null) { return false; };
                    case(?player) {
                        if (player.position != 0) { return false; };
                    };
                };
            };

            return true;
        };

        public func resetTransfers(): async () {
            
            for ((key, value) in fantasyTeams.entries()) {
                let userFantasyTeam = value.fantasyTeam;
                let updatedTeam = { 
                    principalId = userFantasyTeam.principalId;
                    transfersAvailable = Nat8.fromNat(2);
                    bankBalance = userFantasyTeam.bankBalance;
                    playerIds = userFantasyTeam.playerIds;
                    captainId = userFantasyTeam.captainId;
                    goalGetterGameweek = userFantasyTeam.goalGetterGameweek;
                    goalGetterPlayerId = userFantasyTeam.goalGetterPlayerId;
                    passMasterGameweek = userFantasyTeam.passMasterGameweek;
                    passMasterPlayerId = userFantasyTeam.passMasterPlayerId;
                    noEntryGameweek = userFantasyTeam.noEntryGameweek;
                    noEntryPlayerId = userFantasyTeam.noEntryPlayerId;
                    teamBoostGameweek = userFantasyTeam.teamBoostGameweek;
                    teamBoostTeamId = userFantasyTeam.teamBoostTeamId;
                    safeHandsGameweek = userFantasyTeam.safeHandsGameweek;
                    safeHandsPlayerId = userFantasyTeam.safeHandsPlayerId;
                    captainFantasticGameweek = userFantasyTeam.captainFantasticGameweek;
                    captainFantasticPlayerId = userFantasyTeam.captainFantasticPlayerId;
                    braceBonusGameweek = userFantasyTeam.braceBonusGameweek;
                    hatTrickHeroGameweek = userFantasyTeam.hatTrickHeroGameweek;
                };
                
                let updatedUserTeam: T.UserFantasyTeam = {
                    fantasyTeam = updatedTeam;
                    history = value.history;
                };

                fantasyTeams.put(key, updatedUserTeam);
            }
        };

        public func calculateFantasyTeamScores(seasonId: Nat16, gameweek: Nat8, gameweekFixtures: [T.Fixture]): async () {
            
            let allPlayersList = await getAllPlayersMap(seasonId, gameweek);
            var allPlayers = HashMap.HashMap<Nat16, DTOs.PlayerScoreDTO>(500, Utilities.eqNat16, Utilities.hashNat16);
            for ((key, value) in Iter.fromArray(allPlayersList)) {
                allPlayers.put(key, value);
            };

            for ((key, value) in fantasyTeams.entries()) {
                let userFantasyTeam = value.fantasyTeam;
                var totalTeamPoints: Int16 = 0;
                
                for (i in Iter.range(0, Array.size(userFantasyTeam.playerIds)-1)) {
                    let playerId = userFantasyTeam.playerIds[i];
                    let playerData = allPlayers.get(playerId);
                    switch (playerData) {
                        case (null) {};
                        case (?player) {
                            var bonusPoints: Int16 = 0;

                            // Goal Getter
                            if(userFantasyTeam.goalGetterGameweek == gameweek and userFantasyTeam.goalGetterPlayerId == playerId) {
                                bonusPoints += calculateGoalPoints(player.position, player.goalsScored);
                            };

                            // Pass Master
                            if(userFantasyTeam.passMasterGameweek == gameweek and userFantasyTeam.passMasterPlayerId == playerId) {
                                bonusPoints += calculateAssistPoints(player.position, player.assists);
                            };

                            // No Entry
                            if(userFantasyTeam.noEntryGameweek == gameweek and (player.position < 2) and player.goalsConceded == 0) {
                                bonusPoints += (player.points * 2);
                            };

                            // Team Boost
                            if(userFantasyTeam.teamBoostGameweek == gameweek and player.teamId == userFantasyTeam.teamBoostTeamId) {
                                bonusPoints += player.points;
                            };

                            // Safe Hands
                            if(userFantasyTeam.safeHandsGameweek == gameweek and player.position == 0 and player.saves > 4) {
                                bonusPoints += (player.points * 2);
                            };

                            // Captain Fantastic
                            if(userFantasyTeam.captainFantasticGameweek == gameweek and userFantasyTeam.captainId == playerId and player.goalsScored > 0) {
                                bonusPoints += (player.points * 2);
                            };

                            // Brace Bonus
                            if(userFantasyTeam.braceBonusGameweek == gameweek and player.goalsScored >= 2) {
                                bonusPoints += (player.points * 2);
                            };

                            // Hat Trick Hero
                            if(userFantasyTeam.hatTrickHeroGameweek == gameweek and player.goalsScored >= 3) {
                                bonusPoints += (player.points * 3);
                            };

                            totalTeamPoints += player.points + bonusPoints;

                            // Handle captain bonus: Doubles the total (base + bonus) points of the captain
                            if (playerId == userFantasyTeam.captainId) {
                                totalTeamPoints += player.points + bonusPoints;
                            };
                        };
                    }
                };
                
                updateSnapshotPoints(key, seasonId, gameweek, totalTeamPoints);
            };
        };

        private func updateSnapshotPoints(principalId: Text, seasonId: Nat16, gameweek: Nat8, teamPoints: Int16): () {
            let userFantasyTeam = fantasyTeams.get(principalId);

            switch(userFantasyTeam) {
                case (null) { }; 
                case (?ufTeam) {
                    let updatedSeasons = List.map<T.FantasyTeamSeason, T.FantasyTeamSeason>(ufTeam.history, func(season: T.FantasyTeamSeason): T.FantasyTeamSeason {
                        if (season.seasonId == seasonId) {
                            let updatedGameweeks = List.map<T.FantasyTeamSnapshot, T.FantasyTeamSnapshot>(season.gameweeks, func(snapshot: T.FantasyTeamSnapshot): T.FantasyTeamSnapshot {
                                if (snapshot.goalGetterGameweek == gameweek) {
                                    return {
                                        principalId = snapshot.principalId;
                                        transfersAvailable = snapshot.transfersAvailable;
                                        bankBalance = snapshot.bankBalance;
                                        playerIds = snapshot.playerIds;
                                        captainId = snapshot.captainId;
                                        goalGetterGameweek = snapshot.goalGetterGameweek;
                                        goalGetterPlayerId = snapshot.goalGetterPlayerId;
                                        passMasterGameweek = snapshot.passMasterGameweek;
                                        passMasterPlayerId = snapshot.passMasterPlayerId;
                                        noEntryGameweek = snapshot.noEntryGameweek;
                                        noEntryPlayerId = snapshot.noEntryPlayerId;
                                        teamBoostGameweek = snapshot.teamBoostGameweek;
                                        teamBoostTeamId = snapshot.teamBoostTeamId;
                                        safeHandsGameweek = snapshot.safeHandsGameweek;
                                        safeHandsPlayerId = snapshot.safeHandsPlayerId;
                                        captainFantasticGameweek = snapshot.captainFantasticGameweek;
                                        captainFantasticPlayerId = snapshot.captainFantasticPlayerId;
                                        braceBonusGameweek = snapshot.braceBonusGameweek;
                                        hatTrickHeroGameweek = snapshot.hatTrickHeroGameweek;
                                        points = teamPoints;
                                    };
                                };
                                return snapshot;
                            });
                            return {
                                seasonId = season.seasonId;
                                totalPoints = season.totalPoints + teamPoints;
                                gameweeks = updatedGameweeks;
                            };
                        };
                        return season;
                    });

                    let updatedUserFantasyTeam: T.UserFantasyTeam = {
                        fantasyTeam = ufTeam.fantasyTeam;
                        history = updatedSeasons;
                    };
                    fantasyTeams.put(principalId, updatedUserFantasyTeam);
                };
            };
        };

        public func snapshotGameweek(seasonId: Nat16): async () {
            for ((principalId, userFantasyTeam) in fantasyTeams.entries()) {
                let newSnapshot: T.FantasyTeamSnapshot = {
                    principalId = userFantasyTeam.fantasyTeam.principalId;
                    transfersAvailable = userFantasyTeam.fantasyTeam.transfersAvailable;
                    bankBalance = userFantasyTeam.fantasyTeam.bankBalance;
                    playerIds = userFantasyTeam.fantasyTeam.playerIds;
                    captainId = userFantasyTeam.fantasyTeam.captainId;
                    goalGetterGameweek = userFantasyTeam.fantasyTeam.goalGetterGameweek;
                    goalGetterPlayerId = userFantasyTeam.fantasyTeam.goalGetterPlayerId;
                    passMasterGameweek = userFantasyTeam.fantasyTeam.passMasterGameweek;
                    passMasterPlayerId = userFantasyTeam.fantasyTeam.passMasterPlayerId;
                    noEntryGameweek = userFantasyTeam.fantasyTeam.noEntryGameweek;
                    noEntryPlayerId = userFantasyTeam.fantasyTeam.noEntryPlayerId;
                    teamBoostGameweek = userFantasyTeam.fantasyTeam.teamBoostGameweek;
                    teamBoostTeamId = userFantasyTeam.fantasyTeam.teamBoostTeamId;
                    safeHandsGameweek = userFantasyTeam.fantasyTeam.safeHandsGameweek;
                    safeHandsPlayerId = userFantasyTeam.fantasyTeam.safeHandsPlayerId;
                    captainFantasticGameweek = userFantasyTeam.fantasyTeam.captainFantasticGameweek;
                    captainFantasticPlayerId = userFantasyTeam.fantasyTeam.captainFantasticPlayerId;
                    braceBonusGameweek = userFantasyTeam.fantasyTeam.braceBonusGameweek;
                    hatTrickHeroGameweek = userFantasyTeam.fantasyTeam.hatTrickHeroGameweek;
                    points = 0;
                };

                var seasonFound = false;
        
                var updatedSeasons = List.map<T.FantasyTeamSeason, T.FantasyTeamSeason>(userFantasyTeam.history, func(season: T.FantasyTeamSeason): T.FantasyTeamSeason {
                    if (season.seasonId == seasonId) {
                        seasonFound := true; 
                        let updatedGameweeks = List.push(newSnapshot, season.gameweeks);
                        return {
                            seasonId = season.seasonId;
                            totalPoints = season.totalPoints;
                            gameweeks = updatedGameweeks;
                        };
                    };
                    return season;
                });
        
                if (not seasonFound) {
                    let newSeason: T.FantasyTeamSeason = {
                        seasonId = seasonId;
                        totalPoints = 0; 
                        gameweeks =  List.push(newSnapshot, List.nil());  
                    };
                    
                    updatedSeasons := List.push(newSeason, updatedSeasons); 
                };

                let updatedUserTeam: T.UserFantasyTeam = {
                    fantasyTeam = userFantasyTeam.fantasyTeam;
                    history = updatedSeasons;
                };

                fantasyTeams.put(principalId, updatedUserTeam);
            }
        };


        func calculateGoalPoints(position: Nat8, goalsScored: Int16) : Int16 {
            switch (position) {
                case 0 { return 20 * goalsScored; };
                case 1 { return 20 * goalsScored; };
                case 2 { return 15 * goalsScored; };
                case 3 { return 10 * goalsScored; };
                case _ { return 0; };
            };
        };

        func calculateAssistPoints(position: Nat8, assists: Int16) : Int16 {
            switch (position) {
                case 0 { return 15 * assists; };
                case 1 { return 15 * assists; };
                case 2 { return 10 * assists; };
                case 3 { return 10 * assists; };
                case _ { return 0; };
            };
        };

        public func resetFantasyTeams() : async () {
            for ((principalId, userFantasyTeam) in fantasyTeams.entries()) {

                let clearTeam = clearFantasyTeam(principalId);

                let updatedUserTeam: T.UserFantasyTeam = {
                    fantasyTeam = clearTeam;
                    history = userFantasyTeam.history;
                };

                fantasyTeams.put(principalId, updatedUserTeam);
            }
        };

        private func clearFantasyTeam(principalId: Text) : T.FantasyTeam {
            return {
                principalId = principalId;
                transfersAvailable = 2;
                bankBalance = 300_000_000;
                playerIds = [];
                captainId = 0;
                goalGetterGameweek = 0;
                goalGetterPlayerId = 0;
                passMasterGameweek = 0;
                passMasterPlayerId = 0;
                noEntryGameweek = 0;
                noEntryPlayerId = 0;
                teamBoostGameweek = 0;
                teamBoostTeamId = 0;
                safeHandsGameweek = 0;
                safeHandsPlayerId = 0;
                captainFantasticGameweek = 0;
                captainFantasticPlayerId = 0;
                braceBonusGameweek = 0;
                hatTrickHeroGameweek = 0;
            };
        }


    }
}
