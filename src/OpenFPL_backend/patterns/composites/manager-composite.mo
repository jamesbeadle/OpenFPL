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
    
    public func createProfile(principalId : Text, createProfileDTO : DTOs.ProfileDTO) : async Result.Result<(), T.Error> {
      
      var profilePictureCanisterId = "";
      if(createProfileDTO.profilePicture.size() > 0){




//same profile code




        //profilePictureCanisterId := updateProfilePicture(principalId, createProfileDTO.profilePicture);
      };

      let newManager = buildNewManager(principalId, createProfileDTO, profilePictureCanisterId);
      managers.put(principalId, newManager);
      return #ok();
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

    public func getTotalManagers() : Nat {
      let managersWithTeams = Iter.filter<T.Manager>(managers.vals(), func (manager : T.Manager) : Bool { Array.size(manager.playerIds) == 11 });
      return Iter.size(managersWithTeams);
    };

    public func buildNewManager(principalId: Text, createProfileDTO: DTOs.ProfileDTO, profilePictureCanisterId: Text) : T.Manager {
        let newManager: T.Manager = {
        principalId = principalId;
        username = createProfileDTO.username;
        favouriteClubId = createProfileDTO.favouriteClubId;
        createDate = createProfileDTO.createDate;
        termsAccepted = false;
        profilePictureCanisterId = profilePictureCanisterId;
        transfersAvailable = 3;
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
    
    public func updateManager(principalId: Text, updatedFantasyTeam: DTOs.UpdateFantasyTeamDTO) : async Result.Result<(), T.Error> {
      let manager = managers.get(principalId);
      switch(manager){
        case (null){
          let createProfileDTO: DTOs.ProfileDTO = {
              principalId = principalId;
              username = "";
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
      if(not isUsernameValid(updatedUsername)){
        return #err(#InvalidData);
      };

      if(not isUsernameAvailable(updatedUsername)){
        return #err(#NotAllowed);
      };

      let manager = managers.get(principalId);

      switch(manager){
        case (null){
          return #err(#NotFound);
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
          return #err(#NotFound);
        };
        case (?foundManager) {
          
          var profilePictureCanisterId = foundManager.profilePictureCanisterId;
          if(Text.size(profilePictureCanisterId) > 0){
            //replace the existing profile picture and the canister id will remain the same so return

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

    public func isUsernameAvailable(username: Text) : Bool{
        return false;
    };
        
    public func isUsernameValid(username: Text) : Bool{
        return false;
    };

    public func isValidProfilePicture(profilePicture: Blob) : Bool{
        return false;
    };


    public func snapshotFantasyTeams() : (){

    };

    public func resetTransfers() : (){

    };





   //include all profile info for caller
    //include all manager info
    //GetProfile
      //GetGameweekPoints?? - Replace with GetProfile which includes their season history
      //Will include their current team and the pick team should copy from this for the in game session changes
   

    /*
    
    manager-profile-manager.mo
Purpose: Handles operations related to the user profiles of the football managers.
Contents:
Methods for updating manager details like updateUsername and updateProfilePicture.
Functions for managing account settings and preferences.
Integration points for authentication and authorization if needed.
    




    public func getFantasyTeamForGameweek(managerId : Text, seasonId : Nat16, gameweek : Nat8) : T.FantasyTeamSnapshot {
      let emptySnapshot : T.FantasyTeamSnapshot = {
        principalId = "";
        transfersAvailable = 0;
        bankBalance = 0;
        playerIds = [];
        captainId = 0;
        gameweek = 0;
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
        points = 0;
        favouriteTeamId = 0;
        teamName = "";
        transferWindowGameweek = 0;
      };
      let fantasyTeam = fantasyTeams.get(managerId);
      switch (fantasyTeam) {
        case (null) { return emptySnapshot };
        case (?foundTeam) {

          let teamHistory = foundTeam.history;
          switch (teamHistory) {
            case (null) { return emptySnapshot };
            case (foundHistory) {
              let foundSeason = List.find<T.FantasyTeamSeason>(
                foundHistory,
                func(season : T.FantasyTeamSeason) : Bool {
                  return season.seasonId == seasonId;
                },
              );
              switch (foundSeason) {
                case (null) { return emptySnapshot };
                case (?fs) {
                  let foundGameweek = List.find<T.FantasyTeamSnapshot>(
                    fs.gameweeks,
                    func(gw : T.FantasyTeamSnapshot) : Bool {
                      return gw.gameweek == gameweek;
                    },
                  );
                  switch (foundGameweek) {
                    case (null) { return emptySnapshot };
                    case (?fgw) { return fgw };
                  };
                };
              };

            };

          };
        };
      };
    };

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

    





    public func getTeamValueInfo() : async [Text] {
      let allPlayers = await getPlayers();
      let teamDetailsBuffer = Buffer.fromArray<Text>([]);
      for (fantasyTeam in fantasyTeams.entries()) {

        let currentTeam : T.UserFantasyTeam = fantasyTeam.1;
        var allTeamPlayers : [DTOs.PlayerDTO] = [];
        let allTeamPlayersBuffer = Buffer.fromArray<DTOs.PlayerDTO>([]);
        for (playerId in Iter.fromArray(currentTeam.fantasyTeam.playerIds)) {
          let player = Array.find<DTOs.PlayerDTO>(
            allPlayers,
            func(player : DTOs.PlayerDTO) : Bool {
              return player.id == playerId;
            },
          );
          switch (player) {
            case (null) {};
            case (?foundPlayer) {
              allTeamPlayersBuffer.add(foundPlayer);
            };
          };
        };

        allTeamPlayers := Buffer.toArray(allTeamPlayersBuffer);
        let allPlayerValues = Array.map<DTOs.PlayerDTO, Nat>(allTeamPlayers, func(player : DTOs.PlayerDTO) : Nat { return player.value });
        let totalTeamValue = Array.foldLeft<Nat, Nat>(allPlayerValues, 0, func(sumSoFar, x) = sumSoFar + x);

        teamDetailsBuffer.add(currentTeam.fantasyTeam.principalId # " - " # Nat.toText(totalTeamValue));
      };
      return Buffer.toArray(teamDetailsBuffer);
    };

    public func updateTeamValueInfo() : async () {
      let updatedFantasyTeams : HashMap.HashMap<Text, T.UserFantasyTeam> = HashMap.HashMap<Text, T.UserFantasyTeam>(100, Text.equal, Text.hash);
      let allPlayers = await getPlayers();
      for (fantasyTeam in fantasyTeams.entries()) {

        let currentTeam : T.UserFantasyTeam = fantasyTeam.1;
        var allTeamPlayers : [DTOs.PlayerDTO] = [];
        let allTeamPlayersBuffer = Buffer.fromArray<DTOs.PlayerDTO>([]);
        for (playerId in Iter.fromArray(currentTeam.fantasyTeam.playerIds)) {
          let player = Array.find<DTOs.PlayerDTO>(
            allPlayers,
            func(player : DTOs.PlayerDTO) : Bool {
              return player.id == playerId;
            },
          );
          switch (player) {
            case (null) {};
            case (?foundPlayer) {
              allTeamPlayersBuffer.add(foundPlayer);
            };
          };
        };

        allTeamPlayers := Buffer.toArray(allTeamPlayersBuffer);
        let allPlayerValues = Array.map<DTOs.PlayerDTO, Nat>(allTeamPlayers, func(player : DTOs.PlayerDTO) : Nat { return player.value });
        let totalTeamValue = Array.foldLeft<Nat, Nat>(allPlayerValues, 0, func(sumSoFar, x) = sumSoFar + x);

        let ut : T.FantasyTeam = {
          principalId = currentTeam.fantasyTeam.principalId;
          favouriteTeamId = currentTeam.fantasyTeam.favouriteTeamId;
          teamName = currentTeam.fantasyTeam.teamName;
          transfersAvailable = currentTeam.fantasyTeam.transfersAvailable;
          bankBalance = Nat.sub(1200, totalTeamValue);
          playerIds = currentTeam.fantasyTeam.playerIds;
          captainId = currentTeam.fantasyTeam.captainId;
          goalGetterGameweek = currentTeam.fantasyTeam.goalGetterGameweek;
          goalGetterPlayerId = currentTeam.fantasyTeam.goalGetterPlayerId;
          passMasterGameweek = currentTeam.fantasyTeam.passMasterGameweek;
          passMasterPlayerId = currentTeam.fantasyTeam.passMasterPlayerId;
          noEntryGameweek = currentTeam.fantasyTeam.noEntryGameweek;
          noEntryPlayerId = currentTeam.fantasyTeam.noEntryPlayerId;
          teamBoostGameweek = currentTeam.fantasyTeam.teamBoostGameweek;
          teamBoostTeamId = currentTeam.fantasyTeam.teamBoostTeamId;
          safeHandsGameweek = currentTeam.fantasyTeam.safeHandsGameweek;
          safeHandsPlayerId = currentTeam.fantasyTeam.safeHandsPlayerId;
          captainFantasticGameweek = currentTeam.fantasyTeam.captainFantasticGameweek;
          captainFantasticPlayerId = currentTeam.fantasyTeam.captainFantasticPlayerId;
          countrymenGameweek = currentTeam.fantasyTeam.countrymenGameweek;
          countrymenCountryId = currentTeam.fantasyTeam.countrymenCountryId;
          prospectsGameweek = currentTeam.fantasyTeam.prospectsGameweek;
          braceBonusGameweek = currentTeam.fantasyTeam.braceBonusGameweek;
          hatTrickHeroGameweek = currentTeam.fantasyTeam.hatTrickHeroGameweek;
          transferWindowGameweek = currentTeam.fantasyTeam.transferWindowGameweek;
        };

        let updatedFantasyteam : T.UserFantasyTeam = {
          fantasyTeam = ut;
          history = currentTeam.history;
        };
        updatedFantasyTeams.put(fantasyTeam.0, updatedFantasyteam);

      };
      fantasyTeams := updatedFantasyTeams;
    };
  };




    
    public func setData(stable_profiles : [(Text, T.Profile)]) {
      userProfiles := HashMap.fromIter<Text, T.Profile>(
        stable_profiles.vals(),
        stable_profiles.size(),
        Text.equal,
        Text.hash,
      );
    };

    public func getProfiles() : [(Text, T.Profile)] {
      return Iter.toArray(userProfiles.entries());
    };

    public func getProfile(principalName : Text) : ?T.Profile {
      return userProfiles.get(principalName);
    };

    public func getProfilePicture(principalName : Text) : ?Blob {
      return userProfilePictures.get(principalName);
    };

    public func isWalletValid(walletAddress : Text) : Bool {
      let account_id = Account.decode(walletAddress);
      switch account_id {
        case (#ok array) {
          if (Account.validateAccountIdentifier(Blob.fromArray(array))) {
            return true;
          };
        };
        case (#err err) {
          return false;
        };
      };

      return false;
    };

    public func isDisplayNameValid(displayName : Text) : Bool {

      if (Text.size(displayName) < 3 or Text.size(displayName) > 20) {
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

      if (not isAlphanumeric(displayName)) {
        return false;
      };

      for (profile in userProfiles.vals()) {
        if (profile.displayName == displayName) {
          return false;
        };
      };

      return true;
    };

    public func updateDisplayName(principalName : Text, displayName : Text) : Result.Result<(), T.Error> {
      let existingProfile = userProfiles.get(principalName);
      switch (existingProfile) {
        case (null) {
          return #err(#NotFound);
        };
        case (?existingProfile) {
          if (existingProfile.displayName == displayName) {
            return #ok(());
          };
          let nameValid = isDisplayNameValid(displayName);
          if (not nameValid) {
            return #err(#NotAllowed);
          };

          let updatedProfile : T.Profile = {
            principalName = existingProfile.principalName;
            displayName = displayName;
            profilePictureCanisterId = existingProfile.profilePictureCanisterId;
            termsAccepted = existingProfile.termsAccepted;
            favouriteTeamId = existingProfile.favouriteTeamId;
            createDate = existingProfile.createDate;
          };

          userProfiles.put(principalName, updatedProfile);

          return #ok(());
        };
      };
    };

    public func updateFavouriteTeam(principalName : Text, favouriteTeamId : Nat16) : Result.Result<(), T.Error> {
      let existingProfile = userProfiles.get(principalName);
      switch (existingProfile) {
        case (null) {
          return #err(#NotFound);
        };
        case (?existingProfile) {
          let updatedProfile : T.Profile = {
            principalName = existingProfile.principalName;
            displayName = existingProfile.displayName;
            profilePictureCanisterId = existingProfile.profilePictureCanisterId;
            termsAccepted = existingProfile.termsAccepted;
            favouriteTeamId = favouriteTeamId;
            createDate = existingProfile.createDate;
          };

          userProfiles.put(principalName, updatedProfile);
          return #ok(());
        };
      };
    };

    
    public func createProfile(principalId: Text){
      var existingProfile = profilesInstance.getProfile(Principal.toText(caller));
      switch (existingProfile) {
        case (null) {
          profilesInstance.createProfile(Principal.toText(caller), Principal.toText(caller));
        };
        case (_) {};
      };
    };
    
    public func updateUsername(principalId: Text, username: Text){

      assert not Principal.isAnonymous(caller);
      let invalidName = not profilesInstance.isDisplayNameValid(displayName);
      assert not invalidName;

      var profile = profilesInstance.getProfile(Principal.toText(caller));
      switch (profile) {
        case (null) {
          profilesInstance.createProfile(Principal.toText(caller), Principal.toText(caller));
          profile := profilesInstance.getProfile(Principal.toText(caller));
        };
        case (?foundProfile) {};
      };

      fantasyTeamsInstance.updateDisplayName(Principal.toText(caller), displayName);
      return profilesInstance.updateDisplayName(Principal.toText(caller), displayName);

    };
    
    public func updateFavouriteClub(principalId: Text, favouriteClubId: T.ClubId){


      var profile = profilesInstance.getProfile(Principal.toText(caller));
      switch (profile) {
        case (null) {
          profilesInstance.createProfile(Principal.toText(caller), Principal.toText(caller));
          profile := profilesInstance.getProfile(Principal.toText(caller));
        };
        case (?foundProfile) {
          if (foundProfile.favouriteTeamId > 0) {
            assert not seasonManager.seasonActive();
          };
        };
      };

      fantasyTeamsInstance.updateFavouriteTeam(Principal.toText(caller), favouriteTeamId);
      return profilesInstance.updateFavouriteTeam(Principal.toText(caller), favouriteTeamId);
    };
    
    public func updateProfilePicture(principalId: Text, profilePicture: Blob){

      let sizeInKB = Array.size(Blob.toArray(profilePicture)) / 1024;
      if (sizeInKB > 4000) {
        return #err(#NotAllowed);
      };

      return profilesInstance.updateProfilePicture(Principal.toText(caller), profilePicture);
    };


    
  public shared query ({ caller }) func getProfile() : async ?DTOs.ProfileDTO {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);

    var icpDepositAddress = Blob.fromArray([]);
    var fplDepositAddress = Blob.fromArray([]);
    var displayName = "";
    var membershipType = Nat8.fromNat(0);
    var profilePicture = Blob.fromArray([]);
    var favouriteTeamId = Nat16.fromNat(0);
    var createDate : Int = 0;
    var reputation = Nat32.fromNat(0);
    var canUpdateFavouriteTeam = true;

    var profile = profilesInstance.getProfile(Principal.toText(caller));

    switch (profile) {
      case (null) { return null };
      case (?p) {
        displayName := p.displayName;
        favouriteTeamId := p.favouriteTeamId;
        createDate := p.createDate;
        canUpdateFavouriteTeam := p.favouriteTeamId == 0 or not seasonManager.seasonActive();
      };
    };

    let profileDTO : DTOs.ProfileDTO = {
      principalId = principalId;
      icpDepositAddress = icpDepositAddress;
      fplDepositAddress = fplDepositAddress;
      displayName = displayName;
      membershipType = membershipType;
      profilePicture = profilePicture;
      favouriteTeamId = favouriteTeamId;
      createDate = createDate;
      reputation = reputation;
      canUpdateFavouriteTeam = canUpdateFavouriteTeam;
    };

    return ?profileDTO;
  };

  public shared query ({ caller }) func getPublicProfileDTO(principalId : Text) : async DTOs.ProfileDTO {
    var icpDepositAddress = Blob.fromArray([]);
    var fplDepositAddress = Blob.fromArray([]);
    var displayName = "";
    var membershipType = Nat8.fromNat(0);
    var profilePicture = Blob.fromArray([]);
    var favouriteTeamId = Nat16.fromNat(0);
    var createDate : Int = 0;
    var reputation = Nat32.fromNat(0);

    var profile = profilesInstance.getProfile(principalId);

    switch (profile) {
      case (null) {};
      case (?p) {

        let existingProfilePicture = profilesInstance.getProfilePicture(principalId);
        switch (existingProfilePicture) {
          case (null) {};
          case (?foundPicture) {
            profilePicture := foundPicture;
          };
        };

        displayName := p.displayName;
        favouriteTeamId := p.favouriteTeamId;
      };
    };

    let profileDTO : DTOs.ProfileDTO = {
      principalId = principalId;
      icpDepositAddress = icpDepositAddress;
      fplDepositAddress = fplDepositAddress;
      displayName = displayName;
      membershipType = membershipType;
      profilePicture = profilePicture;
      favouriteTeamId = favouriteTeamId;
      createDate = createDate;
      reputation = reputation;
      canUpdateFavouriteTeam = false;
    };

    return profileDTO;
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









  //Fantasy team functions
  public shared query ({ caller }) func getTotalManagers() : async Nat {
    return fantasyTeamsInstance.getTotalManagers();
  };

  public shared query ({ caller }) func getFantasyTeam() : async T.FantasyTeam {
    assert not Principal.isAnonymous(caller);

    let principalId = Principal.toText(caller);
    let fantasyTeam = fantasyTeamsInstance.getFantasyTeam(principalId);

    switch (fantasyTeam) {
      case (null) {
        return {
          principalId = "";
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
          favouriteTeamId = 0;
          teamName = "";
          transferWindowGameweek = 0;
        };
      };
      case (?team) {
        return team.fantasyTeam;
      };
    };
  };


  public shared query ({ caller }) func getFantasyTeamForGameweek(managerId : Text, seasonId : Nat16, gameweek : Nat8) : async T.FantasyTeamSnapshot {
    return fantasyTeamsInstance.getFantasyTeamForGameweek(managerId, seasonId, gameweek);
  };




          */


    

  };
};
