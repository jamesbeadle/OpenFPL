import T "types";
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

        public func createFantasyTeam(principalId: Text, gameweek: Nat8, players: [T.Player], captainId: Nat16, bonusId: Nat8, bonusPlayerId: Nat16, bonusTeamId: Nat16) : Result.Result<(), T.Error> {

            let existingTeam = List.find<T.FantasyTeam>(fantasyTeams, func (team: T.FantasyTeam): Bool {
                return team.principalId == principalId;
            });
            
            switch (existingTeam) {
                case (null) { 

                    let allPlayerValues = Array.map<T.Player, Float>(players, func (player: T.Player) : Float { return player.value; });

                    if(not isTeamValid(players)){
                        return #err(#InvalidTeamError);
                    };

                    let totalTeamValue = Array.foldLeft<Float, Float>(allPlayerValues, 0, func(sumSoFar, x) = sumSoFar + x);
                    if(totalTeamValue > Float.fromInt(300_000_000)){
                        return #err(#InvalidTeamError);
                    };

                    var bankBalance = Nat32.fromNat(0);
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

                    let sortedPlayers = sortPlayers(players);       
                    let allPlayerIds = Array.map<T.Player, Nat16>(sortedPlayers, func (player: T.Player) : Nat16 { return player.id; });
                    
                    if(newCaptainId == 0){
                        var highestValue = Float.fromInt(0);
                        for (i in Iter.range(0, Array.size(players)-1)) {
                            if(players[i].value > highestValue){
                                highestValue := players[i].value; 
                                newCaptainId := players[i].id;
                            };
                        };
                    };
                    
                    if(bonusId == 1 and bonusPlayerId > 0){
                        goalGetterGameweek := gameweek;
                        goalGetterPlayerId := bonusPlayerId;
                    };

                    if(bonusId == 2){
                        passMasterGameweek := gameweek;
                        passMasterPlayerId := bonusPlayerId;
                    };

                    if(bonusId == 3){
                        noEntryGameweek := gameweek;
                        noEntryPlayerId := bonusPlayerId;
                    };

                    if(bonusId == 4){
                        teamBoostGameweek := gameweek;
                        teamBoostTeamId := bonusTeamId;
                    };

                    if(bonusId == 5){
                        safeHandsGameweek := gameweek;
                        safeHandsPlayerId := bonusPlayerId;
                    };


                    if(bonusId == 6){
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

        public func updateFantasyTeam(principalId: Text, players: [T.Player], bankBalance: Nat32, bonusId: Nat8, gameweek: Nat8) : Result.Result<(), T.Error> {
            
             let existingTeam = List.find<T.FantasyTeam>(fantasyTeams, func (team: T.FantasyTeam): Bool {
                return team.principalId == principalId;
            });
            
            switch (existingTeam) {
                case (null) { return #ok(()); };
                case (?existingTeam) { 
                    
                    let allPlayerValues = Array.map<T.Player, Float>(players, func (player: T.Player) : Float { return player.value; });
                    
                    if(not isTeamValid(players)){
                        return #err(#InvalidTeamError);
                    };

                    //if valid team need to work out which players are in and which are out to calculate the number of transfers and whether it is over budget or not



                    let totalTeamValue = Array.foldLeft<Float, Float>(allPlayerValues, 0, func(sumSoFar, x) = sumSoFar + x);
                    if(totalTeamValue > Float.fromInt(300_000_000)){
                        return #err(#InvalidTeamError);
                    };
                   
                    return #ok(()); 
                };
            };






















            let allPlayerIds = Array.map<T.Player, Nat16>(players, func (player: T.Player) : Nat16 { return player.id; });
            let allPlayerPositions = Array.map<T.Player, Nat8>(players, func (player: T.Player) : Nat8 { return player.position; });

            let validTeam = isTeamValid(allPlayerPositions);
            if(not validTeam){
                //SHOW INVALID FORMATION ERROR
            };

            //CHECK THE BONUS HASN'T ALREADY BEEN PLAYED
            //Check they are allowed to make the transfers they have requested
            //2 per gameweek unless pre season
            //check players against original fanatasy team to check number of transfers and then check that against transfers available
            //reduce the number of transfers if all valid

            let newTeam: T.FantasyTeam = {
                principalId = principalId;
                bankBalance = bankBalance;
                playerIds = allPlayerIds;
                transfersAvailable = 0;
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

            let existingTeam = List.find<T.FantasyTeam>(fantasyTeams, func (team: T.FantasyTeam): Bool {
                return team.principalId == principalId;
            });
            
            switch (existingTeam) {
                case (null) { 
                    var newTeamsList = List.nil<T.FantasyTeam>();
                    newTeamsList := List.push(newTeam, newTeamsList);
                    fantasyTeams := List.append(fantasyTeams, newTeamsList);
                    };
                case (?existingTeam) { };
            };
        };

        private func sortPlayers(players: [T.Player]) : [T.Player] {
            
            let sortedPlayers = Array.sort(players, func(a: T.Player, b: T.Player): Order.Order {
                if (a.position < b.position) { return #less; };
                if (a.position > b.position) { return #greater; };
                if (a.value > b.value) { return #less; };
                if (a.value < b.value) { return #greater; };
                return #equal;
            });
            return sortedPlayers;
        };

        //sell player 

        /*
        public func isDisplayNameValid(displayName: Text) : Bool {
            
            if (Text.size(displayName) < 3 or Text.size(displayName) > 20) {
                return false;
            };

            let isAlphanumeric = func (s: Text): Bool {
                let chars = Text.toIter(s);
                for (c in chars) {
                    if (not((c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z') or (c >= '0' and c <= '9'))) {
                        return false;
                    };
                };
                return true;
            };

            if (not isAlphanumeric(displayName)) {
                return false;
            };

            let foundProfile = List.find<Types.Profile>(userProfiles, func (profile: Types.Profile): Bool {
                return profile.displayName == displayName;
            });

            if(foundProfile != null){
                return false;
            };

            return true;
        };

        public func updateDisplayName(principalName: Text, displayName: Text) : Result.Result<(), Types.Error> {
            
             let existingProfile = List.find<Types.Profile>(userProfiles, func (profile: Types.Profile): Bool {
                return profile.principalName == principalName;
            });
            switch (existingProfile) {
                case (null) { 
                    return #err(#NotFound);
                };
                case (?existingProfile) {

                    if(existingProfile.displayName == displayName){
                        return #ok(());
                    };
            
                    let updatedProfile: Types.Profile = {
                        principalName = existingProfile.principalName;
                        displayName = displayName;
                        icpDepositAddress = existingProfile.icpDepositAddress;
                        fplDepositAddress = existingProfile.fplDepositAddress;
                        profilePicture = existingProfile.profilePicture;
                        termsAccepted = existingProfile.termsAccepted;
                        favouriteTeamId = existingProfile.favouriteTeamId;
                        membershipType = existingProfile.membershipType;
                        subscriptionDate = existingProfile.subscriptionDate;
                        createDate = existingProfile.createDate;
                        reputation = existingProfile.reputation;
                    };

                    let nameValid = isDisplayNameValid(updatedProfile.displayName);
                    if(not nameValid){
                        return #err(#NotAllowed);
                    };

                    userProfiles := List.map<Types.Profile, Types.Profile>(userProfiles, func (profile: Types.Profile): Types.Profile {
                        if (profile.principalName == principalName) { updatedProfile } else { profile }
                    });

                    return #ok(());
                };
            };
        };
*/

        public func isTeamValid(players: [T.Player]) : Bool {
            let playerPositions = Array.map<T.Player, Nat8>(players, func (player: T.Player) : Nat8 { return player.position; });
                    
            // Check the number of players
            let playerCount = playerPositions.size();
            if(playerCount != 11 ){
                return false;
            };
            
            // Count the number of players in each position
            var teamPlayerCounts = HashMap.HashMap<Text, Nat8>(0, Text.equal, Text.hash);
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


            
            return true;
        };


    }
}
