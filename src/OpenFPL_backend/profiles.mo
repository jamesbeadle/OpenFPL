import Types "types";
import List "mo:base/List";
import Text "mo:base/Text";
import Blob "mo:base/Blob";
import Account "Account";
import Result "mo:base/Result";
import Time "mo:base/Time";
import Debug "mo:base/Debug";

module {
    public class Profiles(){

        private var userProfiles = List.nil<Types.Profile>();
        
        public func setData(stable_profiles: [Types.Profile]){
            userProfiles := List.fromArray(stable_profiles);
        };
        
        public func getProfiles() : [Types.Profile] {
            return List.toArray(List.map<Types.Profile, Types.Profile>(userProfiles, func (profile: Types.Profile): Types.Profile {
                return {
                    principalName = profile.principalName; 
                    displayName = profile.displayName;
                    icpDepositAddress = profile.icpDepositAddress;
                    fplDepositAddress = profile.fplDepositAddress;
                    profilePicture = profile.profilePicture;
                    termsAccepted = profile.termsAccepted;
                    favouriteTeamId = profile.favouriteTeamId;
                    membershipType = profile.membershipType;
                    subscriptionDate = profile.subscriptionDate;
                    createDate = profile.createDate;
                    reputation = profile.reputation;
                };
            }));
        };

        public func getProfile(principalName: Text) : ?Types.Profile {
            let foundProfile = List.find<Types.Profile>(userProfiles, func (profile: Types.Profile): Bool {
                return profile.principalName == principalName;
            });

            switch (foundProfile) {
                case (null) { return null; };
                case (?profile) { return ?profile; };
            };
        };
        
        public func isWalletValid(walletAddress: Text) : Bool {
            
            let account_id = Account.decode(walletAddress);
            switch account_id {
                case (#ok array) {
                    if(Account.validateAccountIdentifier(Blob.fromArray(array))){
                        return true;
                    };
                };
                case (#err err) {
                    return false;
                };
            };

            return false;
        };

        public func createProfile(principalName: Text, displayName: Text, icpDepositAddress: Account.AccountIdentifier, fplDepositAddress: Account.AccountIdentifier) : () {
            
            let updatedProfile: Types.Profile = {
                principalName = principalName;
                displayName = displayName;
                icpDepositAddress = icpDepositAddress;
                fplDepositAddress = fplDepositAddress;
                profilePicture = Blob.fromArray([]);
                termsAccepted = false;
                favouriteTeamId = 0;
                membershipType = 0;
                subscriptionDate = 0;
                createDate = Time.now();
                reputation = 0;
            };
            
            let existingProfile = List.find<Types.Profile>(userProfiles, func (profile: Types.Profile): Bool {
                return profile.principalName == principalName;
            });

            
            switch (existingProfile) {
                case (null) { 
                    var newProfilesList = List.nil<Types.Profile>();
                    newProfilesList := List.push(updatedProfile, newProfilesList);
                    userProfiles := List.append(userProfiles, newProfilesList);
                    };
                case (?existingProfile) { };
            };
        };
        
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

        public func updateFavouriteTeam(principalName: Text, favouriteTeamId: Nat16) : Result.Result<(), Types.Error> {
            
            let existingProfile = List.find<Types.Profile>(userProfiles, func (profile: Types.Profile): Bool {
                return profile.principalName == principalName;
            });

            switch (existingProfile) {
                case (null) { 
                    return #err(#NotFound);
                };
                case (?existingProfile) {

                    if(existingProfile.favouriteTeamId == favouriteTeamId){
                        return #ok(());
                    };
            
                    let updatedProfile: Types.Profile = {
                        principalName = existingProfile.principalName;
                        displayName = existingProfile.displayName;
                        favouriteTeamId = favouriteTeamId;
                        icpDepositAddress = existingProfile.icpDepositAddress;
                        fplDepositAddress = existingProfile.fplDepositAddress;
                        profilePicture = existingProfile.profilePicture;
                        termsAccepted = existingProfile.termsAccepted;
                        membershipType = existingProfile.membershipType;
                        createDate = existingProfile.createDate;
                        subscriptionDate = existingProfile.subscriptionDate;
                        reputation = existingProfile.reputation;
                    };

                    userProfiles := List.map<Types.Profile, Types.Profile>(userProfiles, func (profile: Types.Profile): Types.Profile {
                        if (profile.principalName == principalName) { updatedProfile } else { profile }
                    });

                    return #ok(());
                };
            };
        };

        public func updateProfilePicture(principalName: Text, profilePicture: Blob) : Result.Result<(), Types.Error> {
            
            let existingProfile = List.find<Types.Profile>(userProfiles, func (profile: Types.Profile): Bool {
                return profile.principalName == principalName;
            });

            switch (existingProfile) {
                case (null) { 
                    return #err(#NotFound);
                };
                case (?existingProfile) {

                    let updatedProfile: Types.Profile = {
                        principalName = existingProfile.principalName;
                        displayName = existingProfile.displayName;
                        icpDepositAddress = existingProfile.icpDepositAddress;
                        fplDepositAddress = existingProfile.fplDepositAddress;
                        termsAccepted = existingProfile.termsAccepted;
                        profilePicture = profilePicture;
                        favouriteTeamId = existingProfile.favouriteTeamId;
                        createDate = existingProfile.createDate;
                        subscriptionDate = existingProfile.subscriptionDate;
                        membershipType = existingProfile.membershipType;
                        reputation = existingProfile.reputation;
                    };

                    userProfiles := List.map<Types.Profile, Types.Profile>(userProfiles, func (profile: Types.Profile): Types.Profile {
                        if (profile.principalName == principalName) { updatedProfile } else { profile }
                    });

                    return #ok(());
                };
            };
        };


    }
}
