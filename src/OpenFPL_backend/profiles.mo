import Types "types";
import List "mo:base/List";
import Text "mo:base/Text";
import Blob "mo:base/Blob";
import Account "Account";

module {
    public class Profiles(){

        private var userProfiles = List.nil<Types.Profile>();
        
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

        

        public func createProfile(principalName: Text, displayName: Text, depositAddress: Account.AccountIdentifier) : () {
            
            let updatedProfile: Types.Profile = {
                principalName = principalName;
                displayName = displayName;
                depositAddress = depositAddress;
                balance = 0;
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


    }
}
