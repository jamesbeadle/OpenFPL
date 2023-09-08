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
import Int "mo:base/Int";
import Debug "mo:base/Debug";
import Int16 "mo:base/Int16";
import Buffer "mo:base/Buffer";

module {
    public class FantasyTeams(
        getAllPlayersMap: (seasonId: Nat16, gameweek: Nat8) -> async [(Nat16, DTOs.PlayerScoreDTO)],
        getPlayer: (playerId: Nat16) -> async T.Player,
        getProfiles: () -> [(Text, T.Profile)],
        getAllPlayers: () -> async [DTOs.PlayerDTO]){
        
        private var fantasyTeams: HashMap.HashMap<Text, T.UserFantasyTeam> = HashMap.HashMap<Text, T.UserFantasyTeam>(100, Text.equal, Text.hash);
        private var seasonLeaderboards: HashMap.HashMap<Nat16, T.SeasonLeaderboards> = HashMap.HashMap<Nat16, T.SeasonLeaderboards>(100, Utilities.eqNat16, Utilities.hashNat16);
        private var monthlyLeaderboards: HashMap.HashMap<T.SeasonId, List.List<T.ClubLeaderboard>> = HashMap.HashMap<T.SeasonId, List.List<T.ClubLeaderboard>>(100, Utilities.eqNat16, Utilities.hashNat16);

        private var getGameweekFixtures : ?((seasonId: T.SeasonId, gameweek: T.GameweekNumber) -> [T.Fixture]) = null;
    
        public func setGetFixturesFunction(_getGameweekFixtures: ((seasonId: T.SeasonId, gameweek: T.GameweekNumber) -> [T.Fixture])) {
            getGameweekFixtures := ?_getGameweekFixtures;
        };

        public func getMonthlyLeaderboards() : [(T.SeasonId, List.List<T.ClubLeaderboard>)] {
            return Iter.toArray(monthlyLeaderboards.entries());
        };
        
        public func setDataForMonthlyLeaderboards(data: [(T.SeasonId, List.List<T.ClubLeaderboard>)]) {
            monthlyLeaderboards := HashMap.fromIter<T.SeasonId, List.List<T.ClubLeaderboard>>(
                data.vals(), data.size(), Utilities.eqNat16, Utilities.hashNat16
            );
        };
        
        public func setData(stable_fantasy_teams: [(Text, T.UserFantasyTeam)]){
            fantasyTeams := HashMap.fromIter<Text, T.UserFantasyTeam>(
                stable_fantasy_teams.vals(), stable_fantasy_teams.size(), Text.equal, Text.hash);
        };

        public func getFantasyTeams() : [(Text, T.UserFantasyTeam)] {
            return Iter.toArray(fantasyTeams.entries());
        };

        public func getSeasonLeaderboards() : [(Nat16, T.SeasonLeaderboards)] {
            return Iter.toArray(seasonLeaderboards.entries());
        };

        
        public func setDataForSeasonLeaderboards(data: [(Nat16, T.SeasonLeaderboards)]) {
            seasonLeaderboards := HashMap.fromIter<Nat16, T.SeasonLeaderboards>(
                data.vals(), data.size(), Utilities.eqNat16, Utilities.hashNat16
            );
        };

        public func getFantasyTeam(principalId: Text) : ?T.UserFantasyTeam {
            return fantasyTeams.get(principalId);
        };

        public func createFantasyTeam(principalId: Text, gameweek: Nat8, newPlayers: [DTOs.PlayerDTO], captainId: Nat16, bonusId: Nat8, bonusPlayerId: Nat16, bonusTeamId: Nat16) : Result.Result<(), T.Error> {

             let existingTeam = fantasyTeams.get(principalId);
            
            switch (existingTeam) {
                case (null) { 

                    let allPlayerValues = Array.map<DTOs.PlayerDTO, Nat>(newPlayers, func (player: DTOs.PlayerDTO) : Nat { return player.value; });

                    if(not isTeamValid(newPlayers, bonusId, bonusPlayerId)){
                        return #err(#InvalidTeamError);
                    };

                    let totalTeamValue = Array.foldLeft<Nat, Nat>(allPlayerValues, 0, func(sumSoFar, x) = sumSoFar + x);
                    
                    if(totalTeamValue > 1200){
                        return #err(#InvalidTeamError);
                    };

                    let teamValueMillions = totalTeamValue * 250_000;
                    let bank: Nat = 300_000_000 - teamValueMillions;

                    var bankBalance = bank;
                    var goalGetterGameweek = Nat8.fromNat(0);
                    var goalGetterPlayerId = Nat16.fromNat(0);
                    var passMasterGameweek = Nat8.fromNat(0);
                    var passMasterPlayerId = Nat16.fromNat(0);
                    var noEntryGameweek = Nat8.fromNat(0);
                    var noEntryPlayerId = Nat16.fromNat(0);
                    var teamBoostGameweek = Nat8.fromNat(0);
                    var teamBoostTeamId = Nat16.fromNat(0);
                    var safeHandsGameweek = Nat8.fromNat(0);
                    var captainFantasticGameweek = Nat8.fromNat(0);
                    var braceBonusGameweek = Nat8.fromNat(0);
                    var hatTrickHeroGameweek = Nat8.fromNat(0);
                    var newCaptainId = captainId;

                    let sortedPlayers = sortPlayers(newPlayers);       
                    let allPlayerIds = Array.map<DTOs.PlayerDTO, Nat16>(sortedPlayers, func (player: DTOs.PlayerDTO) : Nat16 { return player.id; });
                    
                    if(newCaptainId == 0){
                        var highestValue = 0;
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

                    if(bonusId == 5){
                        safeHandsGameweek := gameweek;
                    };


                    if(bonusId == 6){
                        captainFantasticGameweek := gameweek;
                    };


                    if(bonusId == 7){
                        braceBonusGameweek := gameweek;
                    };


                    if(bonusId == 8){
                        hatTrickHeroGameweek := gameweek;
                    };

                    var captainFantasticPlayerId: T.PlayerId = 0;
                    var safeHandsPlayerId: T.PlayerId = 0;

                    if(captainFantasticGameweek == gameweek){
                        captainFantasticPlayerId := newCaptainId;
                    };

                    if(safeHandsGameweek == gameweek){

                        let goalKeeper = List.find<DTOs.PlayerDTO>(List.fromArray(sortedPlayers), func (player: DTOs.PlayerDTO): Bool {
                            return player.position == 0;
                        });

                        switch(goalKeeper){
                            case (null){ };
                            case (?gk){
                                safeHandsPlayerId := gk.id;
                            };
                        };
                    };

                    var newTeam: T.FantasyTeam = {
                        principalId = principalId;
                        bankBalance = Float.fromInt(bankBalance);
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

        public func updateFantasyTeam(principalId: Text, newPlayers: [DTOs.PlayerDTO], captainId: Nat16, bonusId: Nat8, bonusPlayerId: Nat16, bonusTeamId: Nat16, gameweek: Nat8, existingPlayers: [DTOs.PlayerDTO]) : async Result.Result<(), T.Error> {
            
            let existingUserTeam = fantasyTeams.get(principalId);
            switch (existingUserTeam) {
                case (null) { return #ok(()); };
                case (?e) { 
                    let existingTeam = e.fantasyTeam;
                    let allPlayerValues = Array.map<DTOs.PlayerDTO, Nat>(newPlayers, func (player: DTOs.PlayerDTO) : Nat { return player.value; });
                    
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
                   
                    let spent = Array.foldLeft<DTOs.PlayerDTO, Nat>(playersAdded, 0, func(sumSoFar, x) = sumSoFar + x.value);
                    var sold: Nat = 0;
                    for (i in Iter.range(0, Array.size(playersRemoved)-1)) {
                        let newPlayer = await getPlayer(playersRemoved[i]);
                        sold := sold + newPlayer.value;
                    };

                    let netSpendQMs: Int = spent - sold;
                    let netSpendM: Float = Float.fromInt(netSpendQMs) / 4.0;
                    
                    let netSpend: Float = netSpendM * 1_000_000;

                    if(netSpend > existingTeam.bankBalance){
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
                    var captainFantasticGameweek = existingTeam.captainFantasticGameweek;
                    var braceBonusGameweek = existingTeam.braceBonusGameweek;
                    var hatTrickHeroGameweek = existingTeam.hatTrickHeroGameweek;
                    var newCaptainId = captainId;

                    let sortedPlayers = sortPlayers(newPlayers);       
                    let allPlayerIds = Array.map<DTOs.PlayerDTO, Nat16>(sortedPlayers, func (player: DTOs.PlayerDTO) : Nat16 { return player.id; });    
                    
                    if(newCaptainId == 0){
                        var highestValue = 0;
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

                    if(bonusId == 5){
                        safeHandsGameweek := gameweek;
                    };

                    if(bonusId == 6){
                        captainFantasticGameweek := gameweek;
                    };


                    if(bonusId == 7){
                        braceBonusGameweek := gameweek;
                    };


                    if(bonusId == 8){
                        hatTrickHeroGameweek := gameweek;
                    };
                   
                    let newBankBalance: Float = existingTeam.bankBalance - netSpend;

                    var newTransfersAvailable: Nat8 = 2;

                    if(gameweek != 1){
                        newTransfersAvailable := existingTeam.transfersAvailable - Nat8.fromNat(Array.size(playersAdded));
                    };

                    var captainFantasticPlayerId: T.PlayerId = 0;
                    var safeHandsPlayerId: T.PlayerId = 0;

                    if(captainFantasticGameweek == gameweek){
                        captainFantasticPlayerId := newCaptainId;
                    };

                    if(safeHandsGameweek == gameweek){

                        let goalKeeper = List.find<DTOs.PlayerDTO>(List.fromArray(sortedPlayers), func (player: DTOs.PlayerDTO): Bool {
                            return player.position == 0;
                        });

                        switch(goalKeeper){
                            case (null){ };
                            case (?gk){
                                safeHandsPlayerId := gk.id;
                            };
                        };
                    };

                    let updatedTeam: T.FantasyTeam = {
                        principalId = principalId;
                        bankBalance = newBankBalance;
                        playerIds = allPlayerIds;
                        transfersAvailable = newTransfersAvailable;
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
            var playerIdCounts = HashMap.HashMap<Text, Nat8>(0, Text.equal, Text.hash);
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

        public func calculateFantasyTeamScores(seasonId: Nat16, gameweek: Nat8): async () {
            let allPlayersList = await getAllPlayersMap(seasonId, gameweek);
            var allPlayers = HashMap.HashMap<Nat16, DTOs.PlayerScoreDTO>(500, Utilities.eqNat16, Utilities.hashNat16);
            for ((key, value) in Iter.fromArray(allPlayersList)) {
                allPlayers.put(key, value);
            };
            
            for ((key, value) in fantasyTeams.entries()) {

                let currentSeason = List.find<T.FantasyTeamSeason>(value.history, func(teamSeason: T.FantasyTeamSeason) : Bool {
                    return teamSeason.seasonId == seasonId;
                });

                switch(currentSeason){
                    case (null) { };
                    case (?foundSeason){
                        let currentSnapshot = List.find<T.FantasyTeamSnapshot>(foundSeason.gameweeks, func(snapshot: T.FantasyTeamSnapshot) : Bool {
                            return snapshot.gameweek == gameweek;
                        });
                        switch(currentSnapshot){
                            case (null) {  };
                            case (?foundSnapshot){

                                var totalTeamPoints: Int16 = 0;
                                for (i in Iter.range(0, Array.size(foundSnapshot.playerIds)-1)) {
                                    let playerId = foundSnapshot.playerIds[i];
                                    let playerData = allPlayers.get(playerId);
                                    switch (playerData) {
                                        case (null) {};
                                        case (?player) {

                                            var totalScore: Int16 = player.points;
                                            
                                            // Goal Getter
                                            if(foundSnapshot.goalGetterGameweek == gameweek and foundSnapshot.goalGetterPlayerId == playerId) {
                                                totalScore += calculateGoalPoints(player.position, player.goalsScored);
                                            };

                                            // Pass Master
                                            if(foundSnapshot.passMasterGameweek == gameweek and foundSnapshot.passMasterPlayerId == playerId) {
                                                totalScore += calculateAssistPoints(player.position, player.assists);
                                            };

                                            // No Entry
                                            if(foundSnapshot.noEntryGameweek == gameweek and (player.position < 2) and player.goalsConceded == 0) {
                                                totalScore := totalScore * 3;
                                            };

                                            // Team Boost
                                            if(foundSnapshot.teamBoostGameweek == gameweek and player.teamId == foundSnapshot.teamBoostTeamId) {
                                                totalScore := totalScore * 2;
                                            };

                                            // Safe Hands
                                            if(foundSnapshot.safeHandsGameweek == gameweek and player.position == 0 and player.saves > 4) {
                                                totalScore := totalScore * 3;
                                            };

                                            // Captain Fantastic
                                            if(foundSnapshot.captainFantasticGameweek == gameweek and foundSnapshot.captainId == playerId and player.goalsScored > 0) {
                                                totalScore := totalScore * 2;
                                            };

                                            // Brace Bonus
                                            if(foundSnapshot.braceBonusGameweek == gameweek and player.goalsScored >= 2) {
                                                totalScore := totalScore * 2;
                                            };

                                            // Hat Trick Hero
                                            if(foundSnapshot.hatTrickHeroGameweek == gameweek and player.goalsScored >= 3) {
                                                totalScore := totalScore * 3;
                                            };

                                            // Handle captain bonus
                                            if (playerId == foundSnapshot.captainId) {
                                                totalScore := totalScore * 2;
                                            };

                                            totalTeamPoints += totalScore;
                                        };
                                    }
                                };
                                updateSnapshotPoints(key, seasonId, gameweek, totalTeamPoints);
                            };
                        }


                    };
                };
            };
            calculateLeaderboards(seasonId, gameweek);
        };

        private func updateSnapshotPoints(principalId: Text, seasonId: Nat16, gameweek: Nat8, teamPoints: Int16): () {
            let userFantasyTeam = fantasyTeams.get(principalId);

            switch(userFantasyTeam) {
                case (null) { }; 
                case (?ufTeam) {

                    let teamHistoryBuffer = Buffer.fromArray<T.FantasyTeamSeason>([]); 

                    switch(ufTeam.history){
                        case (null) {};
                        case (existingHistory){
                            for(season in List.toIter<T.FantasyTeamSeason>(existingHistory)){
                                if(season.seasonId == seasonId){
                                    let snapshotBuffer = Buffer.fromArray<T.FantasyTeamSnapshot>([]); 
                                    
                                    for(snapshot in List.toIter<T.FantasyTeamSnapshot>(season.gameweeks)){
                                        if(snapshot.gameweek == gameweek){

                                            let updatedSnapshot: T.FantasyTeamSnapshot = {
                                                principalId = snapshot.principalId;
                                                gameweek = snapshot.gameweek;
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

                                            snapshotBuffer.add(updatedSnapshot);

                                        } else { snapshotBuffer.add(snapshot)};
                                    };

                                    let gameweekSnapshots = Buffer.toArray<T.FantasyTeamSnapshot>(snapshotBuffer);

                                    let totalSeasonPoints = Array.foldLeft<T.FantasyTeamSnapshot, Int16>(gameweekSnapshots, 0, 
                                        func(sumSoFar, x) = sumSoFar + x.points);

                                    let updatedSeason: T.FantasyTeamSeason = {
                                        gameweeks = List.fromArray(gameweekSnapshots);
                                        seasonId = season.seasonId;
                                        totalPoints = totalSeasonPoints;
                                    };

                                    teamHistoryBuffer.add(updatedSeason);
                                    
                                } else { teamHistoryBuffer.add(season); };
                            };
                        };
                    };
                    
                    let updatedUserFantasyTeam: T.UserFantasyTeam = {
                        fantasyTeam = ufTeam.fantasyTeam;
                        history = List.fromArray(Buffer.toArray<T.FantasyTeamSeason>(teamHistoryBuffer));
                    };
                    fantasyTeams.put(principalId, updatedUserFantasyTeam);
                };
            };
        };

        private func calculateLeaderboards(seasonId: Nat16, gameweek: Nat8): () {

            func createLeaderboardEntry(principalId: Text, username: Text, team: T.UserFantasyTeam, points: Int16): T.LeaderboardEntry {
                return {
                    position = 0;  
                    positionText = "";
                    username = username;
                    principalId = principalId;
                    points = points;
                };
            };

            func assignPositionText(sortedEntries: List.List<T.LeaderboardEntry>): List.List<T.LeaderboardEntry> {
                var position = 1;
                var previousScore: ?Int16 = null;
                var currentPosition = 1;

                func updatePosition(entry: T.LeaderboardEntry) : T.LeaderboardEntry {
                    if (previousScore == null) {
                        previousScore := ?entry.points;
                        let updatedEntry = {entry with positionText = Int.toText(position)};
                        currentPosition += 1;
                        return updatedEntry;
                    } else if (previousScore == ?entry.points) {
                        currentPosition += 1;
                        return {entry with positionText = "-"};
                    } else {
                        position := currentPosition;
                        previousScore := ?entry.points;
                        let updatedEntry = {entry with positionText = Int.toText(position)};
                        currentPosition += 1;
                        return updatedEntry;
                    }
                };

                return List.map(sortedEntries, updatePosition);
            };


            let allUserProfiles = getProfiles();
           
            let seasonEntries = Array.map<(Text, T.UserFantasyTeam), T.LeaderboardEntry>(
                Iter.toArray(fantasyTeams.entries()),
                func (pair) { 
                    let userProfile = Array.find<(Text, T.Profile)>(allUserProfiles, func(p: (Text, T.Profile)): Bool { return p.0 == pair.0; });
                    switch(userProfile){
                        case (null) {
                            return createLeaderboardEntry(pair.0, pair.0, pair.1, totalPointsForSeason(pair.1, seasonId));
                        };
                        case (?foundProfile){
                            return createLeaderboardEntry(pair.0, foundProfile.1.displayName, pair.1, totalPointsForSeason(pair.1, seasonId)); }
                        };
                    }
            );

            let gameweekEntries = Array.map<(Text, T.UserFantasyTeam), T.LeaderboardEntry>(
                Iter.toArray(fantasyTeams.entries()),
                func (pair) { 
                    let userProfile = Array.find<(Text, T.Profile)>(allUserProfiles, func(p: (Text, T.Profile)): Bool { return p.0 == pair.0; });
                    switch(userProfile){
                        case (null) {
                            return createLeaderboardEntry(pair.0, pair.0, pair.1, totalPointsForGameweek(pair.1, seasonId, gameweek)); 
                        };  
                        case (?foundProfile){
                            return createLeaderboardEntry(pair.0, foundProfile.1.displayName, pair.1, totalPointsForGameweek(pair.1, seasonId, gameweek)); 
                        };
                    }
                }
            );

            let sortedGameweekEntries = List.reverse(mergeSort(List.fromArray(gameweekEntries)));
            let sortedSeasonEntries = List.reverse(mergeSort(List.fromArray(seasonEntries)));

            let positionedGameweekEntries = assignPositionText(sortedGameweekEntries);
            let positionedSeasonEntries = assignPositionText(sortedSeasonEntries);

            let existingSeasonLeaderboard = seasonLeaderboards.get(seasonId);

            let currentGameweekLeaderboard : T.Leaderboard = {
                seasonId = seasonId;
                gameweek = gameweek;
                entries = positionedGameweekEntries;
            };

            var updatedGameweekLeaderboards = List.fromArray<T.Leaderboard>([]); //an list of all the leaderboards for a seasons gameweeks

            switch(existingSeasonLeaderboard){
                case (null){
                    updatedGameweekLeaderboards := List.fromArray([currentGameweekLeaderboard]);
                 };
                case (?foundLeaderboard){
                    var gameweekLeaderboardExists = false;
                    updatedGameweekLeaderboards := List.map<T.Leaderboard, T.Leaderboard>(foundLeaderboard.gameweekLeaderboards, func (leaderboard: T.Leaderboard): T.Leaderboard {
                        if(leaderboard.gameweek == gameweek){
                            gameweekLeaderboardExists := true;
                            return currentGameweekLeaderboard;
                        } else { return leaderboard };
                    });

                    if(not gameweekLeaderboardExists){
                        updatedGameweekLeaderboards := List.append(updatedGameweekLeaderboards, List.fromArray([currentGameweekLeaderboard]));
                    };

                };
            };

            let updatedSeasonLeaderboard: T.SeasonLeaderboards = {
                seasonLeaderboard = { seasonId = seasonId; gameweek = gameweek; entries = positionedSeasonEntries };
                gameweekLeaderboards = updatedGameweekLeaderboards;
            };

            seasonLeaderboards.put(seasonId, updatedSeasonLeaderboard);

        };

        private func totalPointsForGameweek(team: T.UserFantasyTeam, seasonId: T.SeasonId, gameweek: T.GameweekNumber): Int16 {

            let season = List.find(team.history, func(season: T.FantasyTeamSeason): Bool {
                return season.seasonId == seasonId;
            });
            switch(season){
                case (null) { return 0; };
                case (?foundSeason){ 
                    let seasonGameweek = List.find(foundSeason.gameweeks, func(gw: T.FantasyTeamSnapshot): Bool {
                        return gw.gameweek == gameweek;
                    });  
                    switch(seasonGameweek){
                        case null { return 0; };
                        case (?foundSeasonGameweek){
                            return foundSeasonGameweek.points;
                        };
                    };
                };
            };
        };

        private func totalPointsForSeason(team: T.UserFantasyTeam, seasonId: T.SeasonId): Int16 {
            
            var totalPoints: Int16 = 0;
            
            let season = List.find(team.history, func(season: T.FantasyTeamSeason): Bool {
                return season.seasonId == seasonId;
            });

            switch(season){
                case (null) { return 0; };
                case (?foundSeason){
                    for(gameweek in Iter.fromList(foundSeason.gameweeks)){
                        totalPoints += gameweek.points;
                    };
                    return totalPoints;
                };
            };
        };

        public func snapshotGameweek(seasonId: Nat16, gameweek: T.GameweekNumber): async () {
            for ((principalId, userFantasyTeam) in fantasyTeams.entries()) {
                let newSnapshot: T.FantasyTeamSnapshot = {
                    principalId = userFantasyTeam.fantasyTeam.principalId;
                    gameweek = gameweek;
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
                    captainFantasticPlayerId =  userFantasyTeam.fantasyTeam.captainFantasticPlayerId;
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

        public func getTotalManagers() : Nat{
            fantasyTeams.size();
        };

        public func getWeeklyTop10(activeSeasonId: Nat16, activeGameweek: Nat8) : T.Leaderboard {

            var getSeasonId = activeSeasonId;
            var getGameweekId = activeGameweek;

            //if current season first game is not active then show last week
            var gameweekFixtures: [T.Fixture] = [];
            switch(getGameweekFixtures) {
                case (null) { };
                case (?actualFunction) {
                    gameweekFixtures := actualFunction(activeSeasonId, activeGameweek);

                    let fixturesBegun = Array.filter<T.Fixture>(gameweekFixtures, func(fixture: T.Fixture) : Bool {
                        return fixture.status > 0;
                    });

                    if(Array.size(fixturesBegun) == 0){
                        if(getGameweekId == 1){
                            getGameweekId := 38;
                            getSeasonId -= 1; 
                        }
                        else{
                            getGameweekId -= 1;
                        };
                    }
                };
            };


            switch (seasonLeaderboards.get(getSeasonId)) {
                case (null) {
                    return {
                        seasonId = getSeasonId;
                        gameweek = getGameweekId;
                        entries = List.nil();
                    };
                };
                
                case (?seasonData) {
                    let allGameweekLeaderboards = seasonData.gameweekLeaderboards;
                    let matchingGameweekLeaderboard = List.find(allGameweekLeaderboards, func(leaderboard: T.Leaderboard): Bool {
                        return leaderboard.gameweek == getGameweekId;
                    });

                    switch (matchingGameweekLeaderboard) {
                        case (null) {
                            return {
                                seasonId = getSeasonId;
                                gameweek = getGameweekId;
                                entries = List.nil();
                            };
                        };
                        case (?foundLeaderboard) {
                            let top10Entries = List.take(foundLeaderboard.entries, 10);
                            return {
                                seasonId = getSeasonId;
                                gameweek = getGameweekId;
                                entries = top10Entries;
                            };
                        };
                    };
                };
            };
        };

        public func getWeeklyLeaderboard(activeSeasonId: Nat16, activeGameweek: Nat8, limit: Nat, offset: Nat) : T.PaginatedLeaderboard {
            switch (seasonLeaderboards.get(activeSeasonId)) {
                case (null) {
                    return {
                        seasonId = activeSeasonId;
                        gameweek = activeGameweek;
                        entries = [];
                        totalEntries = 0;
                    };
                };
                
                case (?seasonData) {
                    let allGameweekLeaderboards = seasonData.gameweekLeaderboards;
                    let matchingGameweekLeaderboard = List.find(allGameweekLeaderboards, func(leaderboard: T.Leaderboard): Bool {
                        return leaderboard.gameweek == activeGameweek;
                    });

                    switch (matchingGameweekLeaderboard) {
                        case (null) {
                            return {
                                seasonId = activeSeasonId;
                                gameweek = activeGameweek;
                                entries = [];
                                totalEntries = 0;
                            };
                        };
                        case (?foundLeaderboard) {
                            let droppedEntries = List.drop<T.LeaderboardEntry>(foundLeaderboard.entries, offset);
                            let paginatedEntries = List.take<T.LeaderboardEntry>(droppedEntries, limit);
 

                            return {
                                seasonId = activeSeasonId;
                                gameweek = activeGameweek;
                                entries = List.toArray(paginatedEntries);
                                totalEntries = List.size<T.LeaderboardEntry>(foundLeaderboard.entries);
                            };
                        };
                    };
                };
            };
        };

        public func getSeasonLeaderboard(activeSeasonId: Nat16, limit: Nat, offset: Nat) : T.PaginatedLeaderboard {
            switch (seasonLeaderboards.get(activeSeasonId)) {
                case (null) {
                    return {
                        seasonId = activeSeasonId;
                        gameweek = 0;
                        entries = [];
                        totalEntries = 0;
                    };
                };

                case (?seasonData) {
                    let allSeasonLeaderboardEntries = seasonData.seasonLeaderboard.entries;

                    let droppedEntries = List.drop<T.LeaderboardEntry>(allSeasonLeaderboardEntries, offset);
                    let paginatedEntries = List.take<T.LeaderboardEntry>(droppedEntries, limit);

                    return {
                        seasonId = activeSeasonId;
                        gameweek = 0; 
                        entries = List.toArray(paginatedEntries);
                        totalEntries = List.size<T.LeaderboardEntry>(allSeasonLeaderboardEntries);
                    };
                };
            };
        };

        public func getFantasyTeamForGameweek(managerId: Text, seasonId: Nat16, gameweek: Nat8) : async T.FantasyTeamSnapshot {
            let emptySnapshot: T.FantasyTeamSnapshot = { principalId = ""; transfersAvailable = 0; bankBalance = 0.0;  playerIds = [];
                captainId = 0; gameweek = 0; goalGetterGameweek = 0; goalGetterPlayerId = 0; passMasterGameweek = 0;
                passMasterPlayerId = 0; noEntryGameweek = 0; noEntryPlayerId = 0; teamBoostGameweek = 0; teamBoostTeamId = 0;
                safeHandsGameweek = 0; safeHandsPlayerId = 0; captainFantasticGameweek = 0; captainFantasticPlayerId = 0; braceBonusGameweek = 0;
                hatTrickHeroGameweek = 0; points = 0;
            };
            let fantasyTeam = fantasyTeams.get(managerId);
            switch(fantasyTeam){
                case (null){ return emptySnapshot; };
                case (?foundTeam){ 
                    
                    let teamHistory = foundTeam.history;
                    switch(teamHistory){
                        case (null){ return emptySnapshot; };
                        case (foundHistory){
                            let foundSeason = List.find<T.FantasyTeamSeason>(foundHistory, func (season: T.FantasyTeamSeason): Bool {
                                return season.seasonId == seasonId;
                            });
                            switch(foundSeason){
                                case (null) { return emptySnapshot; };
                                case (?fs) {
                                    let foundGameweek = List.find<T.FantasyTeamSnapshot>(fs.gameweeks, func (gw: T.FantasyTeamSnapshot): Bool {
                                        return gw.gameweek == gameweek;
                                    });
                                    switch(foundGameweek){
                                        case (null) { return emptySnapshot; };
                                        case (?fgw) { return fgw; };
                                    }
                                };
                            };

                        };

                    };
                }
            };
        };

        public func getSeasonTop10(activeSeasonId: Nat16) : T.Leaderboard {
            switch (seasonLeaderboards.get(activeSeasonId)) {
                case (null) {
                    return {
                        seasonId = activeSeasonId;
                        gameweek = 0; 
                        entries = List.nil();
                    };
                };
              
                case (?seasonData) {
                    let top10Entries = List.take(seasonData.seasonLeaderboard.entries, 10);
                    return {
                        seasonId = activeSeasonId;
                        gameweek = 0; 
                        entries = top10Entries;
                    };
                };
            };
        };

        func calculateGoalPoints(position: Nat8, goalsScored: Int16) : Int16 {
            switch (position) {
                case 0 { return 40 * goalsScored; };
                case 1 { return 40 * goalsScored; };
                case 2 { return 30 * goalsScored; };
                case 3 { return 20 * goalsScored; };
                case _ { return 0; };
            };
        };

        func calculateAssistPoints(position: Nat8, assists: Int16) : Int16 {
            switch (position) {
                case 0 { return 30 * assists; };
                case 1 { return 30 * assists; };
                case 2 { return 20 * assists; };
                case 3 { return 20 * assists; };
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
        };
        
        private func compare(entry1: T.LeaderboardEntry, entry2: T.LeaderboardEntry): Bool {
            return entry1.points <= entry2.points;
        };

    
        func mergeSort(entries: List.List<T.LeaderboardEntry>): List.List<T.LeaderboardEntry> {
            let len = List.size(entries);
            if (len <= 1) {
                return entries;
            } else {
                let (firstHalf, secondHalf) = List.split(len / 2, entries);
                return List.merge(mergeSort(firstHalf), mergeSort(secondHalf), compare);
            };
        };
        
        public func recalculateSnapshotTotals() : async (){
            await calculateFantasyTeamScores(1,1);
            await calculateFantasyTeamScores(1,2);
        };
        
    };
    
}
