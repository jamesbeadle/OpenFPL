import T "types";
import Cycles "mo:base/ExperimentalCycles";
import Timer "mo:base/Timer";
import Iter "mo:base/Iter";
import Utilities "utilities";
import Environment "Environment";

actor class _PrivateLeague() {
    private let cyclesCheckInterval : Nat = Utilities.getHour() * 24;
    private var cyclesCheckTimerId : ?Timer.TimerId = null;
    private var main_canister_id = Environment.BACKEND_CANISTER_ID;

    private var leagueMembers: [T.LeagueMember] = [];

    public shared ({ caller }) func isLeagueMember(canisterId: T.CanisterId, callerId: T.PrincipalId) : Bool {
        assert not Principal.isAnonymous(caller);
        let principalId = Principal.toText(caller);
        assert principalId == main_canister_id;

        for(member in Iter.fromArray(leagueMembers)){
            if(member.principalId == callerId){
                return true;
            }
        };
        
        return false;
    };

    

    public shared ({ caller }) func getManager(managerPrincipal : Text) : async ?T.Manager {
        assert not Principal.isAnonymous(caller);
        let principalId = Principal.toText(caller);
        assert principalId == main_canister_id;

        let managerGroupIndex = managerGroupIndexes.get(managerPrincipal);
        switch (managerGroupIndex) {
        case (null) {
            return null;
        };
        case (?foundIndex) {
            switch (foundIndex) {
            case (0) {
                for (manager in Iter.fromArray<T.Manager>(managerGroup1)) {
                if (manager.principalId == managerPrincipal) {
                    return ?manager;
                };
                };
            };
            case (1) {
                for (manager in Iter.fromArray<T.Manager>(managerGroup2)) {
                if (manager.principalId == managerPrincipal) {
                    return ?manager;
                };
                };
            };
            case (2) {
                for (manager in Iter.fromArray<T.Manager>(managerGroup3)) {
                if (manager.principalId == managerPrincipal) {
                    return ?manager;
                };
                };
            };
            case (3) {
                for (manager in Iter.fromArray<T.Manager>(managerGroup4)) {
                if (manager.principalId == managerPrincipal) {
                    return ?manager;
                };
                };
            };
            case (4) {
                for (manager in Iter.fromArray<T.Manager>(managerGroup5)) {
                if (manager.principalId == managerPrincipal) {
                    return ?manager;
                };
                };
            };
            case (5) {
                for (manager in Iter.fromArray<T.Manager>(managerGroup6)) {
                if (manager.principalId == managerPrincipal) {
                    return ?manager;
                };
                };
            };
            case (6) {
                for (manager in Iter.fromArray<T.Manager>(managerGroup7)) {
                if (manager.principalId == managerPrincipal) {
                    return ?manager;
                };
                };
            };
            case (7) {
                for (manager in Iter.fromArray<T.Manager>(managerGroup8)) {
                if (manager.principalId == managerPrincipal) {
                    return ?manager;
                };
                };
            };
            case (8) {
                for (manager in Iter.fromArray<T.Manager>(managerGroup9)) {
                if (manager.principalId == managerPrincipal) {
                    return ?manager;
                };
                };
            };
            case (9) {
                for (manager in Iter.fromArray<T.Manager>(managerGroup10)) {
                if (manager.principalId == managerPrincipal) {
                    return ?manager;
                };
                };
            };
            case (10) {
                for (manager in Iter.fromArray<T.Manager>(managerGroup11)) {
                if (manager.principalId == managerPrincipal) {
                    return ?manager;
                };
                };
            };
            case (11) {
                for (manager in Iter.fromArray<T.Manager>(managerGroup12)) {
                if (manager.principalId == managerPrincipal) {
                    return ?manager;
                };
                };
            };
            case _ {

            };
            };
            return null;
        };
        };
    };

    system func preupgrade() {};

    system func postupgrade() {
        switch (cyclesCheckTimerId) {
        case (null) {};
        case (?id) {
            Timer.cancelTimer(id);
            cyclesCheckTimerId := null;
        };
        };
        cyclesCheckTimerId := ?Timer.setTimer<system>(#nanoseconds(cyclesCheckInterval), checkCanisterCycles);
    };

    private func checkCanisterCycles() : async () {

        let balance = Cycles.balance();

        if (balance < 500000000000) {
        let openfpl_backend_canister = actor (main_canister_id) : actor {
            requestCanisterTopup : () -> async ();
        };
        await openfpl_backend_canister.requestCanisterTopup();
        };
        await setCheckCyclesTimer();
    };

    private func setCheckCyclesTimer() : async () {
        switch (cyclesCheckTimerId) {
        case (null) {};
        case (?id) {
            Timer.cancelTimer(id);
            cyclesCheckTimerId := null;
        };
        };
        cyclesCheckTimerId := ?Timer.setTimer<system>(#nanoseconds(cyclesCheckInterval), checkCanisterCycles);
    };

    public func topupCanister() : async () {
        let amount = Cycles.available();
        let _ = Cycles.accept<system>(amount);
    };

    public func getCyclesBalance() : async Nat {
        return Cycles.balance();
    };
};
