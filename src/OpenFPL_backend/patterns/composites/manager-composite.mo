import DTOs "../../DTOs";
import T "../../types";
import Result "mo:base/Result";
import Blob "mo:base/Blob";
import Text "mo:base/Text";
import List "mo:base/List";
import { now } = "mo:base/Time";
import HashMap "mo:base/HashMap";
import Iter "mo:base/Iter";
import Array "mo:base/Array";
import Nat16 "mo:base/Nat16";
import Nat8 "mo:base/Nat8";
import Int64 "mo:base/Int64";
import Nat64 "mo:base/Nat64";

module {

  public class ManagerComposite() {
    private var managers: HashMap.HashMap<T.PrincipalId, T.Manager> = HashMap.HashMap<T.PrincipalId, T.Manager>(100, Text.equal, Text.hash);
    private var profilePictureCanisterIds : HashMap.HashMap<T.PrincipalId, Text> = HashMap.HashMap<T.PrincipalId, Text>(100, Text.equal, Text.hash);    
   
    public func setStableData(stable_managers: [(T.PrincipalId, T.Manager)], stable_profile_picture_canister_ids: [(T.PrincipalId, Text)]) { 
      managers := HashMap.fromIter<T.PrincipalId, T.Manager>(
        stable_managers.vals(),
        stable_managers.size(),
        Text.equal,
        Text.hash
      );
      profilePictureCanisterIds := HashMap.fromIter<T.PrincipalId, Text>(
        stable_profile_picture_canister_ids.vals(),
        stable_profile_picture_canister_ids.size(),
        Text.equal,
        Text.hash
      );
    };
    
    public func getProfile(principalId: Text) : async Result.Result<DTOs.ProfileDTO, T.Error>{
        
        let manager = managers.get(principalId);

        switch(manager){
            case (null) {
            return #err(#NotFound);
            };
            case (?foundManager){
            
            var profilePicture = Blob.fromArray([]);
            
            if(Text.size(foundManager.profilePictureCanisterId) > 0){
                let profile_picture_canister = actor (foundManager.profilePictureCanisterId) : actor {
                getProfilePicture : (principalId: Text) -> async Blob;
                };
                profilePicture := await profile_picture_canister.getProfilePicture(foundManager.principalId);
            };
            
            let profileDTO: DTOs.ProfileDTO = {
                principalId = foundManager.principalId;
                username = foundManager.username;
                profilePicture = profilePicture;
                favouriteClubId = foundManager.favouriteClubId;
                createDate = foundManager.createDate;
            };

            return #ok(profileDTO);
            };
        }
    };

    public func getManager(principalId: Text) : async Result.Result<DTOs.ManagerDTO, T.Error>{
      let manager = managers.get(principalId);

      switch(manager){
        case (null) {
          return #err(#NotFound);
        };
        case (?foundManager){
        
          var profilePicture = Blob.fromArray([]);
          if(Text.size(foundManager.profilePictureCanisterId) > 0){
              let profile_picture_canister = actor (foundManager.profilePictureCanisterId) : actor {
              getProfilePicture : (principalId: Text) -> async Blob;
              };
              profilePicture := await profile_picture_canister.getProfilePicture(foundManager.principalId);
          };
          
          let managerDTO: DTOs.ManagerDTO = {
            principalId = foundManager.principalId;
            username = foundManager.username;
            profilePicture = profilePicture;
            favouriteClubId = foundManager.favouriteClubId;
            createDate = foundManager.createDate;
            gameweeks = [];
            weeklyPosition = 0;
            monthlyPosition = 0;
            seasonPosition = 0;
            weeklyPositionText = "";
            monthlyPositionText = "";
            seasonPositionText = "";
            weeklyPoints = 0;
            monthlyPoints = 0;
            seasonPoints = 0;
          };
          return #ok(managerDTO);
        };
      }
    };
    
    public func getManagerGameweek(principalId: Text, seasonId: T.SeasonId, gameweek: T.GameweekNumber) : async Result.Result<DTOs.ManagerGameweekDTO, T.Error>{
      
      let manager = managers.get(principalId);
      switch (manager) {
        case (null) { return #err(#NotFound) };
        case (?foundTeam) {

          let teamHistory = foundTeam.history;
          switch (teamHistory) {
            case (null) { return #err(#NotFound) };
            case (foundHistory) {
              let foundSeason = List.find<T.FantasyTeamSeason>(
                foundHistory,
                func(season : T.FantasyTeamSeason) : Bool {
                  return season.seasonId == seasonId;
                },
              );
              switch (foundSeason) {
                case (null) { return #err(#NotFound) };
                case (?fs) {
                  let foundGameweek = List.find<T.FantasyTeamSnapshot>(
                    fs.gameweeks,
                    func(gw : T.FantasyTeamSnapshot) : Bool {
                      return gw.gameweek == gameweek;
                    },
                  );
                  switch (foundGameweek) {
                    case (null) { return #err(#NotFound) };
                    case (?fgw) { return #ok(fgw) };
                  };
                };
              };
            };
          };
        };
      };
    };

    public func getTotalManagers() : Nat {
      let managersWithTeams = Iter.filter<T.Manager>(managers.vals(), func (manager : T.Manager) : Bool { Array.size(manager.playerIds) == 11 });
      return Iter.size(managersWithTeams);
    };
    
    public func saveFantasyTeam(principalId: Text, updatedFantasyTeam: DTOs.UpdateFantasyTeamDTO, systemState: T.SystemState, players: [DTOs.PlayerDTO]) : async Result.Result<(), T.Error> {
      
      let manager = managers.get(principalId);
      
      if(not isUsernameValid(updatedFantasyTeam.username, principalId)){
        return #err(#InvalidData);
      };

      if(invalidBonuses(updatedFantasyTeam, manager, systemState, players)){
        return #err(#InvalidData);
      };
      
      if(invalidTransfers(updatedFantasyTeam, manager, systemState, players)){
        return #err(#InvalidTeamError);
      };  

      if(invalidTeamComposition(updatedFantasyTeam, players)){
        return #err(#InvalidTeamError);
      };
      
      switch(manager){
        case (null){
          let createProfileDTO: DTOs.ProfileDTO = {
              principalId = principalId;
              username = updatedFantasyTeam.username;
              profilePicture = Blob.fromArray([]);
              favouriteClubId = 0;
              createDate = now();
              canUpdateFavouriteClub = true;
          };
          let newManager = buildNewManager(principalId, createProfileDTO, "");
          let updatedManager: T.Manager = {
              principalId = newManager.principalId;
              username = newManager.username;
              favouriteClubId = newManager.favouriteClubId;
              createDate = newManager.createDate;
              termsAccepted = newManager.termsAccepted;
              profilePictureCanisterId = newManager.profilePictureCanisterId;
              transfersAvailable = newManager.transfersAvailable;
              monthlyBonusesAvailable = newManager.monthlyBonusesAvailable;
              bankQuarterMillions = newManager.bankQuarterMillions;
              playerIds = updatedFantasyTeam.playerIds;
              captainId = updatedFantasyTeam.captainId;
              goalGetterGameweek = updatedFantasyTeam.goalGetterGameweek;
              goalGetterPlayerId = updatedFantasyTeam.goalGetterPlayerId;
              passMasterGameweek = updatedFantasyTeam.passMasterGameweek;
              passMasterPlayerId = updatedFantasyTeam.passMasterPlayerId;
              noEntryGameweek = updatedFantasyTeam.noEntryGameweek;
              noEntryPlayerId = updatedFantasyTeam.noEntryPlayerId;
              teamBoostGameweek = updatedFantasyTeam.teamBoostGameweek;
              teamBoostClubId = updatedFantasyTeam.teamBoostClubId;
              safeHandsGameweek = updatedFantasyTeam.safeHandsGameweek;
              safeHandsPlayerId = updatedFantasyTeam.safeHandsPlayerId;
              captainFantasticGameweek = updatedFantasyTeam.captainFantasticGameweek;
              captainFantasticPlayerId = updatedFantasyTeam.captainFantasticPlayerId;
              countrymenGameweek = updatedFantasyTeam.countrymenGameweek;
              countrymenCountryId = updatedFantasyTeam.countrymenCountryId;
              prospectsGameweek = updatedFantasyTeam.prospectsGameweek;
              braceBonusGameweek = updatedFantasyTeam.braceBonusGameweek;
              hatTrickHeroGameweek = updatedFantasyTeam.hatTrickHeroGameweek;
              transferWindowGameweek = updatedFantasyTeam.transferWindowGameweek;
              history = List.nil<T.FantasyTeamSeason>();
          };
          managers.put(principalId, updatedManager);
          return #ok();
        };
        case (?foundManager){
          let updatedManager: T.Manager = {
              principalId = foundManager.principalId;
              username = foundManager.username;
              favouriteClubId = foundManager.favouriteClubId;
              createDate = foundManager.createDate;
              termsAccepted = foundManager.termsAccepted;
              profilePictureCanisterId = foundManager.profilePictureCanisterId;
              transfersAvailable = foundManager.transfersAvailable;
              monthlyBonusesAvailable = foundManager.monthlyBonusesAvailable;
              bankQuarterMillions = foundManager.bankQuarterMillions;
              playerIds = updatedFantasyTeam.playerIds;
              captainId = updatedFantasyTeam.captainId;
              goalGetterGameweek = updatedFantasyTeam.goalGetterGameweek;
              goalGetterPlayerId = updatedFantasyTeam.goalGetterPlayerId;
              passMasterGameweek = updatedFantasyTeam.passMasterGameweek;
              passMasterPlayerId = updatedFantasyTeam.passMasterPlayerId;
              noEntryGameweek = updatedFantasyTeam.noEntryGameweek;
              noEntryPlayerId = updatedFantasyTeam.noEntryPlayerId;
              teamBoostGameweek = updatedFantasyTeam.teamBoostGameweek;
              teamBoostClubId = updatedFantasyTeam.teamBoostClubId;
              safeHandsGameweek = updatedFantasyTeam.safeHandsGameweek;
              safeHandsPlayerId = updatedFantasyTeam.safeHandsPlayerId;
              captainFantasticGameweek = updatedFantasyTeam.captainFantasticGameweek;
              captainFantasticPlayerId = updatedFantasyTeam.captainFantasticPlayerId;
              countrymenGameweek = updatedFantasyTeam.countrymenGameweek;
              countrymenCountryId = updatedFantasyTeam.countrymenCountryId;
              prospectsGameweek = updatedFantasyTeam.prospectsGameweek;
              braceBonusGameweek = updatedFantasyTeam.braceBonusGameweek;
              hatTrickHeroGameweek = updatedFantasyTeam.hatTrickHeroGameweek;
              transferWindowGameweek = updatedFantasyTeam.transferWindowGameweek;
              history = foundManager.history;
          };
          managers.put(principalId, updatedManager);
          return #ok();
        };
      };
    };
      


    







    public func updateUsername(principalId: T.PrincipalId, updatedUsername: Text) : async Result.Result<(), T.Error> {
      if(not isUsernameValid(updatedUsername, principalId)){
        return #err(#InvalidData);
      };

      let manager = managers.get(principalId);

      switch(manager){
        case (null){
          
          //TODO: CREATE NEW USER WITH USERNAME




          return #ok();

        };
        case (?foundManager){
          let updatedManager: T.Manager = {
            principalId = foundManager.principalId;
            username = updatedUsername;
            favouriteClubId = foundManager.favouriteClubId;
            createDate = foundManager.createDate;
            termsAccepted = foundManager.termsAccepted;
            profilePictureCanisterId = foundManager.profilePictureCanisterId;
            transfersAvailable = foundManager.transfersAvailable;
            monthlyBonusesAvailable = foundManager.monthlyBonusesAvailable;
            bankQuarterMillions = foundManager.bankQuarterMillions;
            playerIds = foundManager.playerIds;
            captainId = foundManager.captainId;
            goalGetterGameweek = foundManager.goalGetterGameweek;
            goalGetterPlayerId = foundManager.goalGetterPlayerId;
            passMasterGameweek = foundManager.passMasterGameweek;
            passMasterPlayerId = foundManager.passMasterPlayerId;
            noEntryGameweek = foundManager.noEntryGameweek;
            noEntryPlayerId = foundManager.noEntryPlayerId;
            teamBoostGameweek = foundManager.teamBoostGameweek;
            teamBoostClubId = foundManager.teamBoostClubId;
            safeHandsGameweek = foundManager.safeHandsGameweek;
            safeHandsPlayerId = foundManager.safeHandsPlayerId;
            captainFantasticGameweek = foundManager.captainFantasticGameweek;
            captainFantasticPlayerId = foundManager.captainFantasticPlayerId;
            countrymenGameweek = foundManager.countrymenGameweek;
            countrymenCountryId = foundManager.countrymenCountryId;
            prospectsGameweek = foundManager.prospectsGameweek;
            braceBonusGameweek = foundManager.braceBonusGameweek;
            hatTrickHeroGameweek = foundManager.hatTrickHeroGameweek;
            transferWindowGameweek = foundManager.transferWindowGameweek;
            history = foundManager.history;
          };
          managers.put(principalId, updatedManager);
          return #ok();
        };
      };
    };

    public func updateFavouriteClub(principalId : T.PrincipalId, favouriteClubId : T.ClubId) : async Result.Result<(), T.Error> {
      
      let manager = managers.get(principalId);

      switch(manager){
        case (null){
          return #err(#NotFound);
        };
        case (?foundManager){
          let updatedManager: T.Manager = {
            principalId = foundManager.principalId;
            username = foundManager.username;
            favouriteClubId = favouriteClubId;
            createDate = foundManager.createDate;
            termsAccepted = foundManager.termsAccepted;
            profilePictureCanisterId = foundManager.profilePictureCanisterId;
            transfersAvailable = foundManager.transfersAvailable;
            monthlyBonusesAvailable = foundManager.monthlyBonusesAvailable;
            bankQuarterMillions = foundManager.bankQuarterMillions;
            playerIds = foundManager.playerIds;
            captainId = foundManager.captainId;
            goalGetterGameweek = foundManager.goalGetterGameweek;
            goalGetterPlayerId = foundManager.goalGetterPlayerId;
            passMasterGameweek = foundManager.passMasterGameweek;
            passMasterPlayerId = foundManager.passMasterPlayerId;
            noEntryGameweek = foundManager.noEntryGameweek;
            noEntryPlayerId = foundManager.noEntryPlayerId;
            teamBoostGameweek = foundManager.teamBoostGameweek;
            teamBoostClubId = foundManager.teamBoostClubId;
            safeHandsGameweek = foundManager.safeHandsGameweek;
            safeHandsPlayerId = foundManager.safeHandsPlayerId;
            captainFantasticGameweek = foundManager.captainFantasticGameweek;
            captainFantasticPlayerId = foundManager.captainFantasticPlayerId;
            countrymenGameweek = foundManager.countrymenGameweek;
            countrymenCountryId = foundManager.countrymenCountryId;
            prospectsGameweek = foundManager.prospectsGameweek;
            braceBonusGameweek = foundManager.braceBonusGameweek;
            hatTrickHeroGameweek = foundManager.hatTrickHeroGameweek;
            transferWindowGameweek = foundManager.transferWindowGameweek;
            history = foundManager.history;
          };
          managers.put(principalId, updatedManager);
          return #ok();
        };
      };
    };

    public func updateProfilePicture(principalId : T.PrincipalId, profilePicture : Blob) : async Result.Result<(), T.Error> {
      let existingManager = managers.get(principalId);
      switch (existingManager) {
        case (null) {
          let createProfileDTO: DTOs.ProfileDTO = {
            principalId = principalId;
            username = "";
            profilePicture = "";
            favouriteClubId = 0;
            createDate = 0;
          };

          var profilePictureCanisterId = "";
          if(createProfileDTO.profilePicture.size() > 0){
            //TODO: Need to implement multicanister profile architechture
              //Need to check if the current profile canister has room for this user
                //If it does then add the profile picture to the current profile picture canister and return the canister id
                //If it doesn't then add the profile picture to a new canister and set this as the current live one, returning the canister id
                
            //profilePictureCanisterId := updateProfilePicture(principalId, createProfileDTO.profilePicture);
          };



          let newManager = buildNewManager(principalId, createProfileDTO, profilePictureCanisterId);
          managers.put(principalId, newManager);
          return #ok();
        };
        case (?foundManager) {
          
          var profilePictureCanisterId = foundManager.profilePictureCanisterId;
          if(Text.size(profilePictureCanisterId) > 0){
            //TODO: replace the existing profile picture and the canister id will remain the same so return


            //create canister and call update function
              //Ensure only this canister can call the profile canister
                //I guess when it's created set the allowed principal to this canister?
              



            return #ok();
          };







          //no current profile picture

          //check if current canister has space

            //if not add new profile picture canister and add
              profilePictureCanisterId := ""; //this is where you set to the next canister
            //if existing canister has space set to that and pu in there







          
          let updatedManager: T.Manager = {
            principalId = foundManager.principalId;
            username = foundManager.username;
            favouriteClubId = foundManager.favouriteClubId;
            createDate = foundManager.createDate;
            termsAccepted = foundManager.termsAccepted;
            profilePictureCanisterId = profilePictureCanisterId;
            transfersAvailable = foundManager.transfersAvailable;
            monthlyBonusesAvailable = foundManager.monthlyBonusesAvailable;
            bankQuarterMillions = foundManager.bankQuarterMillions;
            playerIds = foundManager.playerIds;
            captainId = foundManager.captainId;
            goalGetterGameweek = foundManager.goalGetterGameweek;
            goalGetterPlayerId = foundManager.goalGetterPlayerId;
            passMasterGameweek = foundManager.passMasterGameweek;
            passMasterPlayerId = foundManager.passMasterPlayerId;
            noEntryGameweek = foundManager.noEntryGameweek;
            noEntryPlayerId = foundManager.noEntryPlayerId;
            teamBoostGameweek = foundManager.teamBoostGameweek;
            teamBoostClubId = foundManager.teamBoostClubId;
            safeHandsGameweek = foundManager.safeHandsGameweek;
            safeHandsPlayerId = foundManager.safeHandsPlayerId;
            captainFantasticGameweek = foundManager.captainFantasticGameweek;
            captainFantasticPlayerId = foundManager.captainFantasticPlayerId;
            countrymenGameweek = foundManager.countrymenGameweek;
            countrymenCountryId = foundManager.countrymenCountryId;
            prospectsGameweek = foundManager.prospectsGameweek;
            braceBonusGameweek = foundManager.braceBonusGameweek;
            hatTrickHeroGameweek = foundManager.hatTrickHeroGameweek;
            transferWindowGameweek = foundManager.transferWindowGameweek;
            history = foundManager.history;
          };
          
          managers.put(principalId, updatedManager);
          return #ok();
        };
      };
    };






    public func isValidProfilePicture(profilePicture: Blob) : Bool{
        //TODO: implement
        return false;
    };


    //TODO: move the private validator functions here
    public func isUsernameValid(username: Text, principalId: Text) : Bool{
        if (Text.size(username) < 3 or Text.size(username) > 20) {
        return false;
      };

      let isAlphanumeric = func(s : Text) : Bool {
        let chars = Text.toIter(s);
        for (c in chars) {
          if (not ((c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z') or (c >= '0' and c <= '9') or (c == ' '))) {
            return false;
          };
        };
        return true;
      };

      if (not isAlphanumeric(username)) {
        return false;
      };

      for (profile in managers.vals()) {
        if (profile.username == username and profile.principalId != principalId) {
          return false;
        };
      };

      return true;
    };

    private func invalidBonuses(updatedFantasyTeam: DTOs.UpdateFantasyTeamDTO, existingFantasyTeam: ?T.Manager, systemState: T.SystemState, players: [DTOs.PlayerDTO]) : Bool {
      
      var bonusesPlayed = 0;
      if(updatedFantasyTeam.goalGetterGameweek == systemState.pickTeamGameweek){
        bonusesPlayed += 1;
      };
      if(updatedFantasyTeam.passMasterGameweek == systemState.pickTeamGameweek){
        bonusesPlayed += 1;
      };
      if(updatedFantasyTeam.noEntryGameweek == systemState.pickTeamGameweek){
        let bonusPlayer = List.find<DTOs.PlayerDTO>(
          List.fromArray(players),
          func(player : DTOs.PlayerDTO) : Bool {
            return player.id == updatedFantasyTeam.noEntryPlayerId;
          },
        );
        switch (bonusPlayer) {
          case (null) { return false };
          case (?player) {
            if (player.position != #Goalkeeper and player.position != #Defender) { return false };
          };
        };
        bonusesPlayed += 1;
      };
      if(updatedFantasyTeam.teamBoostGameweek == systemState.pickTeamGameweek){
        bonusesPlayed += 1;
      };
      if(updatedFantasyTeam.safeHandsGameweek == systemState.pickTeamGameweek){
        let bonusPlayer = List.find<DTOs.PlayerDTO>(
          List.fromArray(players),
          func(player : DTOs.PlayerDTO) : Bool {
            return player.id == updatedFantasyTeam.safeHandsPlayerId;
          },
        );
        switch (bonusPlayer) {
          case (null) { return false };
          case (?player) {
            if (player.position != #Goalkeeper) { return false };
          };
        };
        bonusesPlayed += 1;
      };
      if(updatedFantasyTeam.captainFantasticGameweek == systemState.pickTeamGameweek){
        bonusesPlayed += 1;
      };
      if(updatedFantasyTeam.countrymenGameweek == systemState.pickTeamGameweek){
        bonusesPlayed += 1;
      };
      if(updatedFantasyTeam.prospectsGameweek == systemState.pickTeamGameweek){
        bonusesPlayed += 1;
      };
      if(updatedFantasyTeam.braceBonusGameweek == systemState.pickTeamGameweek){
        bonusesPlayed += 1;
      };
      if(updatedFantasyTeam.hatTrickHeroGameweek == systemState.pickTeamGameweek){
        bonusesPlayed += 1;
      };

      if(bonusesPlayed > 1){
        return true;
      };

      switch(existingFantasyTeam){
        case (null){ };
        case (?foundTeam){
          if(updatedFantasyTeam.goalGetterGameweek == systemState.pickTeamGameweek and foundTeam.goalGetterGameweek != 0){  
            return true;
          };
          if(updatedFantasyTeam.passMasterGameweek == systemState.pickTeamGameweek and foundTeam.passMasterGameweek != 0){
            return true;
          };
          if(updatedFantasyTeam.noEntryGameweek == systemState.pickTeamGameweek and foundTeam.noEntryGameweek != 0){
            return true;
          };
          if(updatedFantasyTeam.teamBoostGameweek == systemState.pickTeamGameweek and foundTeam.teamBoostGameweek != 0){
            return true;
          };
          if(updatedFantasyTeam.safeHandsGameweek == systemState.pickTeamGameweek and foundTeam.safeHandsGameweek != 0){
            return true;
          };
          if(updatedFantasyTeam.captainFantasticGameweek == systemState.pickTeamGameweek and foundTeam.captainFantasticGameweek != 0){
            return true;
          };
          if(updatedFantasyTeam.countrymenGameweek == systemState.pickTeamGameweek and foundTeam.countrymenGameweek != 0){
            return true;
          };
          if(updatedFantasyTeam.prospectsGameweek == systemState.pickTeamGameweek and foundTeam.prospectsGameweek != 0){
            return true;
          };
          if(updatedFantasyTeam.braceBonusGameweek == systemState.pickTeamGameweek and foundTeam.braceBonusGameweek != 0){
            return true;
          };
          if(updatedFantasyTeam.hatTrickHeroGameweek == systemState.pickTeamGameweek and foundTeam.hatTrickHeroGameweek != 0){
            return true;
          };

          if(Int64.fromNat64(Nat64.fromNat(Nat8.toNat(foundTeam.monthlyBonusesAvailable) - bonusesPlayed)) < 0){
            return true;
          };
        };
      };

      return false;
    };
    
    private func invalidTransfers(updatedFantasyTeam: DTOs.UpdateFantasyTeamDTO, existingFantasyTeam: ?T.Manager, systemState: T.SystemState, players: [DTOs.PlayerDTO]) : Bool {
      
      if(updatedFantasyTeam.transferWindowGameweek == systemState.pickTeamGameweek and not systemState.transferWindowActive){
        return true;
      };

      switch(existingFantasyTeam){
        case (null){
          let spend = Array.foldLeft(updatedFantasyTeam.playerIds, 0, func(sum : Nat, playerId : T.PlayerId) : Nat {
            let player: ?DTOs.PlayerDTO = Array.find<DTOs.PlayerDTO>(players, func(p) { p.id == playerId });
            switch(player){
              case (null){
                sum
              };
              case (?foundPlayer){
                sum + foundPlayer.valueQuarterMillions
              }
            }
          });
          
          if(spend > 1200){
            return true;
          };
        };
        case (?foundTeam){
          let existingPlayerIds: [T.PlayerId] = foundTeam.playerIds;

          let playersBought = Array.filter(updatedFantasyTeam.playerIds, func(playerId : T.PlayerId) : Bool {
            Array.find(existingPlayerIds, func(id : T.PlayerId) : Bool { id != playerId }) == null
          });

          var newTransfersAvailable = foundTeam.transfersAvailable;
          if(not systemState.transferWindowActive){
            newTransfersAvailable := newTransfersAvailable - Nat8.fromNat(Array.size(playersBought));
          };

          if(newTransfersAvailable < 0){
            return true;
          };

          let playersSold = Array.filter(existingPlayerIds, func(playerId : T.PlayerId) : Bool {
            Array.find(updatedFantasyTeam.playerIds, func(id : T.PlayerId) : Bool { id != playerId }) == null
          });

          let spend = Array.foldLeft(playersBought, 0, func(sum : Nat, playerId : T.PlayerId) : Nat {
            let player: ?DTOs.PlayerDTO = Array.find<DTOs.PlayerDTO>(players, func(p) { p.id == playerId });
            switch(player){
              case (null){
                sum
              };
              case (?foundPlayer){
                sum + foundPlayer.valueQuarterMillions
              }
            }
          });

          let sold = Array.foldLeft(playersSold, 0, func(sum : Nat, playerId : T.PlayerId) : Nat {
            let player: ?DTOs.PlayerDTO = Array.find<DTOs.PlayerDTO>(players, func(p) { p.id == playerId });
            switch(player){
              case (null){
                sum
              };
              case (?foundPlayer){
                sum + foundPlayer.valueQuarterMillions
              }
            }
          });

          let remainingBank: Nat = foundTeam.bankQuarterMillions - spend + sold;
          if(remainingBank < 0){
            return true;
          };

        };
      };
    
      return false;
    };
    
    private func invalidTeamComposition(updatedFantasyTeam: DTOs.UpdateFantasyTeamDTO, players: [DTOs.PlayerDTO]) : Bool {
      
      let newTeamPlayers = Array.filter(players, func(player : DTOs.PlayerDTO) : Bool {
        Array.find(updatedFantasyTeam.playerIds, func(id : T.PlayerId) : Bool { id != player.id }) == null
      });

      let playerPositions = Array.map<DTOs.PlayerDTO, T.PlayerPosition>(newTeamPlayers, func(player : DTOs.PlayerDTO) : T.PlayerPosition { return player.position });
      
      let playerCount = playerPositions.size();
      if (playerCount != 11) {
        return false;
      };

      var teamPlayerCounts = HashMap.HashMap<Text, Nat8>(0, Text.equal, Text.hash);
      var playerIdCounts = HashMap.HashMap<Text, Nat8>(0, Text.equal, Text.hash);
      var goalkeeperCount = 0;
      var defenderCount = 0;
      var midfielderCount = 0;
      var forwardCount = 0;
      var captainInTeam = false;

      for (i in Iter.range(0, playerCount -1)) {
        let count = teamPlayerCounts.get(Nat16.toText(players[i].clubId));
        switch (count) {
          case (null) {
            teamPlayerCounts.put(Nat16.toText(players[i].clubId), 1);
          };
          case (?count) {
            teamPlayerCounts.put(Nat16.toText(players[i].clubId), count + 1);
          };
        };

        let playerIdCount = playerIdCounts.get(Nat16.toText(players[i].id));
        switch (playerIdCount) {
          case (null) { playerIdCounts.put(Nat16.toText(players[i].id), 1) };
          case (?count) {
            return true;
          };
        };

        if (players[i].position == #Goalkeeper) {
          goalkeeperCount += 1;
        };

        if (players[i].position == #Defender) {
          defenderCount += 1;
        };

        if (players[i].position == #Midfielder) {
          midfielderCount += 1;
        };

        if (players[i].position == #Forward) {
          forwardCount += 1;
        };

        if(players[i].id == updatedFantasyTeam.captainId){
          captainInTeam := true;
        }

      };

      for ((key, value) in teamPlayerCounts.entries()) {
        if (value > 2) {
          return true;
        };
      };

      if (
        goalkeeperCount != 1 or defenderCount < 3 or defenderCount > 5 or midfielderCount < 3 or midfielderCount > 5 or forwardCount < 1 or forwardCount > 3,
      ) {
        return true;
      };

      if(not captainInTeam){
        return true;
      };

      return false;
    };

















    public func snapshotFantasyTeams() : (){

    };

    public func resetTransfers() : (){
      //reset transfers available for gameweek AND reset the bonuses that can be played within a calendar month

      //if last game of the upcoming gameweek falls in the following month, reset the number of transfers available to 2


    };

    public func getStableManagers(): [(T.PrincipalId, T.Manager)] {
      return Iter.toArray(managers.entries());
    };

    public func setStableManagers(stable_managers: [(T.PrincipalId, T.Manager)]) {
       managers := HashMap.fromIter<T.PrincipalId, T.Manager>(
        stable_managers.vals(),
        stable_managers.size(),
        Text.equal,
        Text.hash
      );
    };

    public func getStableProfilePictureCanisterIds(): [(T.PrincipalId, Text)] {
      return Iter.toArray(profilePictureCanisterIds.entries());
    };

    public func setStableProfilePictureCanisterIds(stable_profile_picture_canister_ids: [(T.PrincipalId, Text)])  {
      profilePictureCanisterIds := HashMap.fromIter<T.PrincipalId, Text>(
        stable_profile_picture_canister_ids.vals(),
        stable_profile_picture_canister_ids.size(),
        Text.equal,
        Text.hash
      );
    };

    private func buildNewManager(principalId: Text, createProfileDTO: DTOs.ProfileDTO, profilePictureCanisterId: Text) : T.Manager {
        let newManager: T.Manager = {
          principalId = principalId;
          username = createProfileDTO.username;
          favouriteClubId = createProfileDTO.favouriteClubId;
          createDate = createProfileDTO.createDate;
          termsAccepted = false;
          profilePictureCanisterId = profilePictureCanisterId;
          transfersAvailable = 3;
          monthlyBonusesAvailable = 2;
          bankQuarterMillions = 1200;
          playerIds = [];
          captainId = 0;
          goalGetterGameweek = 0;
          goalGetterPlayerId = 0;
          passMasterGameweek = 0;
          passMasterPlayerId = 0;
          noEntryGameweek = 0;
          noEntryPlayerId = 0;
          teamBoostGameweek = 0;
          teamBoostClubId = 0;
          safeHandsGameweek = 0;
          safeHandsPlayerId = 0;
          captainFantasticGameweek = 0;
          captainFantasticPlayerId = 0;
          countrymenGameweek = 0;
          countrymenCountryId = 0;
          prospectsGameweek = 0;
          braceBonusGameweek = 0;
          hatTrickHeroGameweek = 0;
          transferWindowGameweek = 0;
          history = List.nil<T.FantasyTeamSeason>();
        };

        return newManager;
    };
    

    /*
    

    public func resetFantasyTeams() : async () {
      for ((principalId, userFantasyTeam) in fantasyTeams.entries()) {

        let clearTeam = clearFantasyTeam(principalId);

        let updatedUserTeam : T.UserFantasyTeam = {
          fantasyTeam = clearTeam;
          history = userFantasyTeam.history;
        };

        fantasyTeams.put(principalId, updatedUserTeam);
      };
    };



    private func clearFantasyTeam(principalId : Text) : T.FantasyTeam {
      return {
        principalId = principalId;
        transfersAvailable = 3;
        bankBalance = 1200;
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
        countrymenGameweek = 0;
        countrymenCountryId = 0;
        prospectsGameweek = 0;
        braceBonusGameweek = 0;
        hatTrickHeroGameweek = 0;
        teamName = "";
        favouriteTeamId = 0;
        transferWindowGameweek = 0;
      };
    };

    



  
  public shared query func getManager(managerId : Text, seasonId : T.SeasonId, gameweek : T.GameweekNumber) : async DTOs.ManagerDTO {

    var displayName = "";
    var profilePicture = Blob.fromArray([]);
    var favouriteTeamId : T.TeamId = 0;
    var createDate = Time.now();
    var gameweeks : [T.FantasyTeamSnapshot] = [];

    var weeklyLeaderboardEntry = fantasyTeamsInstance.getWeeklyLeaderboardEntry(managerId, seasonId, gameweek);
    var seasonLeaderboardEntry = fantasyTeamsInstance.getSeasonLeaderboardEntry(managerId, seasonId);
    var monthlyLeaderboardEntry : ?T.LeaderboardEntry = null;

    let userProfile = profilesInstance.getProfile(managerId);
    switch (userProfile) {
      case (null) {};
      case (?foundProfile) {

        let existingProfilePicture = profilesInstance.getProfilePicture(managerId);
        switch (existingProfilePicture) {
          case (null) {};
          case (?foundPicture) {
            profilePicture := foundPicture;
          };
        };

        displayName := foundProfile.displayName;
        favouriteTeamId := foundProfile.favouriteTeamId;
        createDate := foundProfile.createDate;

        if (foundProfile.favouriteTeamId > 0) {
          monthlyLeaderboardEntry := fantasyTeamsInstance.getMonthlyLeaderboardEntry(managerId, seasonId, foundProfile.favouriteTeamId);
        }

      };
    };

    //get gameweek snapshots
    let fantasyTeam = fantasyTeamsInstance.getFantasyTeam(managerId);

    switch (fantasyTeam) {
      case (null) {};
      case (?foundTeam) {

        let season = List.find(
          foundTeam.history,
          func(season : T.FantasyTeamSeason) : Bool {
            return season.seasonId == seasonId;
          },
        );

        switch (season) {
          case (null) {};
          case (?foundSeason) {
            gameweeks := List.toArray(foundSeason.gameweeks);
          };
        };
      };
    };

    var weeklyPosition : Int = 0;
    var monthlyPosition : Int = 0;
    var seasonPosition : Int = 0;

    var weeklyPositionText = "N/A";
    var monthlyPositionText = "N/A";
    var seasonPositionText = "N/A";

    var weeklyPoints : Int16 = 0;
    var monthlyPoints : Int16 = 0;
    var seasonPoints : Int16 = 0;

    switch (weeklyLeaderboardEntry) {
      case (null) {};
      case (?foundEntry) {
        weeklyPosition := foundEntry.position;
        weeklyPositionText := foundEntry.positionText;
        weeklyPoints := foundEntry.points;
      };
    };

    switch (monthlyLeaderboardEntry) {
      case (null) {};
      case (?foundEntry) {
        monthlyPosition := foundEntry.position;
        monthlyPositionText := foundEntry.positionText;
        monthlyPoints := foundEntry.points;
      };
    };

    switch (seasonLeaderboardEntry) {
      case (null) {};
      case (?foundEntry) {
        seasonPosition := foundEntry.position;
        seasonPositionText := foundEntry.positionText;
        seasonPoints := foundEntry.points;
      };
    };

    let managerDTO : DTOs.ManagerDTO = {
      principalId = managerId;
      displayName = displayName;
      profilePicture = profilePicture;
      favouriteTeamId = favouriteTeamId;
      createDate = createDate;
      gameweeks = gameweeks;
      weeklyPosition = weeklyPosition;
      monthlyPosition = monthlyPosition;
      seasonPosition = seasonPosition;
      weeklyPositionText = weeklyPositionText;
      monthlyPositionText = monthlyPositionText;
      seasonPositionText = seasonPositionText;
      weeklyPoints = weeklyPoints;
      monthlyPoints = monthlyPoints;
      seasonPoints = seasonPoints;
    };

    return managerDTO;
  };









          */


    

  };
};
