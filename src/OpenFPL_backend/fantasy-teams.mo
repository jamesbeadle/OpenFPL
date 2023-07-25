import T "types";
import DTOs "DTOs";
import List "mo:base/List";
import Nat32 "mo:base/Nat32";
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
import Debug "mo:base/Debug";
import Buffer "mo:base/Buffer";
import Hash "mo:base/Hash";

module {
    public class FantasyTeams(){

        private var fantasyTeams = List.nil<T.FantasyTeam>();
        
        public func setData(stable_fantasy_teams: [T.FantasyTeam]){
            fantasyTeams := List.fromArray(stable_fantasy_teams);
        };
        
        public func getFantasyTeams() : [T.FantasyTeam] {
            return List.toArray(fantasyTeams);
        };

        public func getFantasyTeam(principalId: Text) : ?T.FantasyTeam {
            let foundTeam = List.find<T.FantasyTeam>(fantasyTeams, func (team: T.FantasyTeam): Bool {
                return team.principalId == principalId;
            });

            switch (foundTeam) {
                case (null) { return null; };
                case (?team) { return ?team; };
            };
        };

        public func createFantasyTeam(principalId: Text, gameweek: Nat8, newPlayers: [DTOs.PlayerDTO], captainId: Nat16, bonusId: Nat8, bonusPlayerId: Nat16, bonusTeamId: Nat16) : Result.Result<(), T.Error> {

            let existingTeam = List.find<T.FantasyTeam>(fantasyTeams, func (team: T.FantasyTeam): Bool {
                return team.principalId == principalId;
            });
            
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

                    var newTeamsList = List.nil<T.FantasyTeam>();
                    newTeamsList := List.push(newTeam, newTeamsList);
                    fantasyTeams := List.append(fantasyTeams, newTeamsList);
                    return #ok(());
                };
                case (?existingTeam) { return #ok(()); };
            };
        };

        public func updateFantasyTeam(principalId: Text, newPlayers: [DTOs.PlayerDTO], captainId: Nat16, bonusId: Nat8, bonusPlayerId: Nat16, bonusTeamId: Nat16, gameweek: Nat8, existingPlayers: [DTOs.PlayerDTO]) : Result.Result<(), T.Error> {
            
             let existingTeam = List.find<T.FantasyTeam>(fantasyTeams, func (team: T.FantasyTeam): Bool {
                return team.principalId == principalId;
            });
            
            switch (existingTeam) {
                case (null) { return #ok(()); };
                case (?existingTeam) { 
                    
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

                    fantasyTeams := List.map<T.FantasyTeam, T.FantasyTeam>(fantasyTeams, func (fantasyTeam: T.FantasyTeam): T.FantasyTeam {
                        if (fantasyTeam.principalId == principalId) { updatedTeam } else { fantasyTeam }
                    });
                   
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
                    goalkeeperCount := goalkeeperCount + 1;
                };

                if(players[i].position == 1){
                    defenderCount := defenderCount + 1;
                };
                
                if(players[i].position == 2){
                    midfielderCount := midfielderCount + 1;
                };
                
                if(players[i].position == 3){
                    forwardCount := forwardCount + 1;
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
            let mappedTeams = List.map<T.FantasyTeam, T.FantasyTeam>(fantasyTeams, func (fantasyTeam: T.FantasyTeam) : T.FantasyTeam {
              return {
                principalId = fantasyTeam.principalId;
                transfersAvailable = 2;
                bankBalance = fantasyTeam.bankBalance;
                playerIds = fantasyTeam.playerIds;
                captainId = fantasyTeam.captainId;
                goalGetterGameweek = fantasyTeam.goalGetterGameweek;
                goalGetterPlayerId = fantasyTeam.goalGetterPlayerId;
                passMasterGameweek = fantasyTeam.passMasterGameweek;
                passMasterPlayerId = fantasyTeam.passMasterPlayerId;
                noEntryGameweek = fantasyTeam.noEntryGameweek;
                noEntryPlayerId = fantasyTeam.noEntryPlayerId;
                teamBoostGameweek = fantasyTeam.teamBoostGameweek;
                teamBoostTeamId = fantasyTeam.teamBoostTeamId;
                safeHandsGameweek = fantasyTeam.safeHandsGameweek;
                safeHandsPlayerId = fantasyTeam.safeHandsPlayerId;
                captainFantasticGameweek = fantasyTeam.captainFantasticGameweek;
                captainFantasticPlayerId = fantasyTeam.captainFantasticPlayerId;
                braceBonusGameweek = fantasyTeam.braceBonusGameweek;
                hatTrickHeroGameweek = fantasyTeam.hatTrickHeroGameweek;
              };
          });
          fantasyTeams := mappedTeams;
        };

        public func calculatePredictionScores(gameweek: Nat8, gameweekFixtures: [T.Fixture]): async () {

            

            //loop through each fixture
                //get a unique list of the player ids in the fixture
                //if the player has the id in the team lookup the total points for the player

                        



            /*
            var allPlayerIdsBuffer = Buffer.fromArray<Nat16>([]);
            for (i in Iter.range(0, Array.size(gameEventData)-1)) {
                for (j in Iter.range(0, Array.size(gameEventData[i].appearances)-1)) {
                    let playerId: Nat16 = gameEventData[i].appearances[j].playerId;
                    allPlayerIdsBuffer.add(playerId);
                };
            };

            let allPlayerIds = Buffer.toArray(allPlayerIdsBuffer);
            let eq = func (a: Nat16, b: Nat16) : Bool {
                a == b
            };

            let hashNat16 = func (key: Nat16) : Hash.Hash {
                Nat32.fromNat(Nat16.toNat(key)%(2 ** 32 -1));
            };

            let playerPointsMap: HashMap.HashMap<Nat16, Nat16> = HashMap.HashMap<Nat16, Nat16>(22, eq, hashNat16);
            
            for (i in Iter.range(0, Array.size(allPlayerIds)-1)) {

                //HERE I NEED TO BE LOOPING AROUND AN OBJECT OF PLAYER ID AND THEIR RESPECTIVE EVNTS SO I ONLY PASS THOSE TO CALCULATE PLAYER POINTS

                let playerPoints = calculatePlayerPoints(gameEventData);
                playerPointsMap.put(allPlayerIds[i], playerPoints);
            };
            
            let fantasyTeamsArray = getFantasyTeams();

            for (i in Iter.range(0, Array.size(fantasyTeamsArray)-1)) {
                let fantasyTeam = fantasyTeamsArray[i];
                var points: Nat16 = 0;
                    
                for (j in Iter.range(0, Array.size(fantasyTeam.playerIds)-1)) {
                    let playerId = fantasyTeam.playerIds[j];
                    let playerPoints = playerPointsMap.get(playerId);
                    switch(playerPoints){
                        case (null) {};
                        case (?p){
                            
                            //adjust for bonuses
                            var bonusPlayed: Bool = false;
                            let player = await getPlayer(fantasyTeam.goalGetterPlayerId);
                            
                            //where fixture has player id in goal scored event count them and same for conceded
                            let goalsScored = 0; //GET FROM GAME EVENT DATA
                            
                            let goalsConceded = 0; //GET FROM GAME EVENT DATA
                               
                            if(fantasyTeam.goalGetterGameweek == gameweek and fantasyTeam.goalGetterPlayerId == playerId){
                                //let goalsScored = //get active season active gameweek goal count
                                
                                //Goal Getter - triple points for each goal scored for any selected player
                                points := points + p;
                                bonusPlayed := true;
                            };

                            if(fantasyTeam.passMasterGameweek == gameweek and fantasyTeam.passMasterPlayerId == playerId){
                                //Pass Master - receive triple points for each assist for any selected player.
                                
                            };

                            if(fantasyTeam.noEntryGameweek == gameweek and player.position == 1 and goalsConceded == 0){
                                //No Entry - receieve triple points on any defenders score if they keep a clean sheet.
                                points := points + (p * 3);
                            };

                            if(fantasyTeam.teamBoostGameweek == gameweek and player.teamId == fantasyTeam.teamBoostTeamId){
                                //Team Boost - receive double points for each player of the chosen team.
                                points := points + (p * 2);
                            };

                            if(fantasyTeam.safeHandsGameweek == gameweek and player.position == 0 and goalsConceded == 0){
                                //Safe Hands - bonus to triple your goalkeeper's points for this gameweek.
                                points := points + (p * 3);
                            };

                            if(fantasyTeam.captainFantasticGameweek == gameweek and fantasyTeam.captainId == playerId and goalsScored > 0){
                                //Captain Fantastic - bonus to triple your captain's points for this gameweek if they score a goal.
                                points := points + (p * 3);
                            };

                            if(fantasyTeam.braceBonusGameweek == gameweek and goalsScored >= 2){
                                //Brace Bonus - double the points for any player in your team that scores 2 or more goals in a match.
                                points := points + (p * 2);
                            };

                            if(fantasyTeam.hatTrickHeroGameweek == gameweek and goalsScored >= 3){
                                //Hat Trick Hero - bonus to triple the points for any player in your team that scores 3 or more goals in a match.
                                points := points + (p * 3);
                            };

                            if(not bonusPlayed){
                                points := points + p;
                            };
                        }
                    };
                };

                //save team score for gameweek

            };
            */
        };
        
        public shared func snapshotGameweek(): async (){

            //need to copy every current team into gameweek predictions

            //copy current teams into gameweek predictions - this is to copy the predictions into the users profile history
        };
    }
}
