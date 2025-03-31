import MopsEnums "../cleanup/mops_enums";
import MopsIds "../cleanup/mops_ids";

module CanisterQueries {


    public type GetCanisters = {
        canisterType : MopsEnums.CanisterType;
    };

    public type Canisters = {

    };

    public type Canister = {
        canisterId : MopsIds.CanisterId;
        cycles : Nat;
        computeAllocation : Nat;
        topups : [CanisterTopup];
    };

    public type CanisterTopup = {

    };
}