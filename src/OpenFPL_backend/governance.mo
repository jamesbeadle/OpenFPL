import T "types";
import List "mo:base/List";
import Text "mo:base/Text";
import Blob "mo:base/Blob";
import Account "Account";
import Result "mo:base/Result";
import Time "mo:base/Time";
import Debug "mo:base/Debug";
import HashMap "mo:base/HashMap";
import Hash "mo:base/Hash";
import Nat32 "mo:base/Nat32";
import Nat16 "mo:base/Nat16";

module {
    public class Governance(){

        let eq = func (a: Nat16, b: Nat16) : Bool { a == b };
        let hashNat16 = func (key: Nat16) : Hash.Hash {
            Nat32.fromNat(Nat16.toNat(key)%(2 ** 32 -1));
        };
        private var fixtureDataSubmissions: HashMap.HashMap<Nat16, List.List<T.PlayerEventData>> = HashMap.HashMap<Nat16, List.List<T.PlayerEventData>>(22, eq, hashNat16);

        public shared func getGameweekPlayerEventData(gameweek: Nat8, fixtureId: Nat32) : async List.List<T.PlayerEventData> {

            //IMPLEMENT

            return List.nil();
        };

        public shared func getRevaluedPlayers() : async [T.Player] {

            //IMPLEMENT

            //RESET PLAYERS VOTES

            //NOTE THE SUCCESSFUL PLAYER VALUATION VOTES

            return [];
        };

    }
}
