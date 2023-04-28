import Types "types";
import List "mo:base/List";
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

        

    public func createProfile(principalName: Text, displayName: Text, wallet: Text, depositAddress: Account.AccountIdentifier) : () {
        
        let updatedProfile: Types.Profile = {
            principalName = principalName;
            displayName = displayName;
            wallet = wallet;
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


    }
}
