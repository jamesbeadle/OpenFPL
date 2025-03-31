import Enums "mo:waterway-mops/Enums";
import Ids "mo:waterway-mops/Ids";

module CanisterQueries {


    public type GetCanisters = {
        canisterType : Enums.CanisterType;
    };

    public type Canisters = {

    };

    public type Canister = {
        canisterId : Ids.CanisterId;
        cycles : Nat;
        computeAllocation : Nat;
        topups : [CanisterTopup];
    };

    public type CanisterTopup = {

    };
}