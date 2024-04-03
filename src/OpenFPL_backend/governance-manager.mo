import Environment "./Environment";
import SNSGovernanceCanister "./sns-wrappers/governance";
import DTOs "DTOs";

module {

  public class GovernanceManager() {

  
    private let governance : SNSGovernanceCanister.Interface = actor (Environment.SNS_GOVERNANCE_CANISTER_ID);

    
    public func revaluePlayerUpProposalExists(dto: DTOs.RevaluePlayerUpDTO) : async Bool {    
      
      let proposals = await governance.list_proposals({
        include_reward_status = [0];
        before_proposal = ?{ id = 0};
        limit = 100;
        exclude_type = [0];
        include_status = [0];
      });


      //check the active proposals in the governance canister
      //might have to get them in batches
      //if one is the same then return true

      return false;
    };

    public func revaluePlayerDownProposalExists(dto : DTOs.RevaluePlayerDownDTO) : async Bool {
        return false;
    };

    public func submitFixtureDataProposalExists(dto : DTOs.SubmitFixtureDataDTO) : async Bool {
        return false;
    };

    public func addInitialFixturesProposalExists(dto : DTOs.AddInitialFixturesDTO) : async Bool {
        return false;
    };

    public func moveFixtureProposalExists(dto : DTOs.MoveFixtureDTO) : async Bool {
        return false;
    };

    public func postponeFixtureProposalExists(dto : DTOs.PostponeFixtureDTO) : async Bool {
        return false;
    };

    public func rescheduleFixtureProposalExists(dto : DTOs.RescheduleFixtureDTO) : async Bool {
        return false;
    };

    public func loanPlayerProposalExists(dto : DTOs.LoanPlayerDTO) : async Bool {
        return false;
    };

    public func transferPlayerProposalExists(dto : DTOs.TransferPlayerDTO) : async Bool {
        return false;
    };
    public func recallPlayerProposalExists(recallPlayerDTO : DTOs.RecallPlayerDTO) : async Bool {
        return false;
    };

    public func createPlayerProposalExists(dto : DTOs.CreatePlayerDTO) : async Bool {
        return false;
    };

    public func updatePlayerProposalExists(dto : DTOs.UpdatePlayerDTO) : async Bool {
        return false;
    };

    public func setPlayerInjuryProposalExists(dto : DTOs.SetPlayerInjuryDTO) : async Bool {
        return false;
    };

    public func retirePlayerProposalExists(dto : DTOs.RetirePlayerDTO) : async Bool {
        return false;
    };

    public func unretirePlayerProposalExists(dto : DTOs.UnretirePlayerDTO) : async Bool {
        return false;
    };

    public func promoteFormerClubProposalExists(dto : DTOs.PromoteFormerClubDTO) : async Bool {
        return false;
    };

    public func promoteNewClubProposalExists(dto : DTOs.PromoteNewClubDTO) : async Bool {
        return false;
    };

    public func updateClubProposalExists(dto : DTOs.UpdateClubDTO) : async Bool {
        return false;
    };

  };
};
