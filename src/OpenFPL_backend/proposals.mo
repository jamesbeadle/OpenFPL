import List "mo:base/List";
import Result "mo:base/Result";
import T "types";
import Debug "mo:base/Debug";
import Array "mo:base/Array";
import Order "mo:base/Order";

module {
    
  public class Proposals(){

    private var proposals = List.nil<T.Proposal>();
    public var nextProposalId : Nat = 1;

    public func setData(stable_proposals: [T.Proposal], stable_proposal_id : Nat){
        proposals := List.fromArray(stable_proposals);
        nextProposalId := stable_proposal_id;
    };

    public func getData() : [T.Proposal] {
        return List.toArray(proposals);
    };

    public func execute_accepted_proposals(): async () {
        //execute any accepted proposals
    };

    public func submitProposal(){
        //submit proposals of any type
    };

  }
}
