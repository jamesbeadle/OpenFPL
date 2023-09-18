import { SnsGovernanceCanister } from '@dfinity/sns';
import { HttpAgent } from '@dfinity/agent';

const snsGovernance = {
  createInstance: function(canisterId) {
    return SnsGovernanceCanister.create({
      agent: new HttpAgent(),
      canisterId: canisterId
    });
  },

  listNeurons: function(instance, params) {
    return instance.listNeurons(params);
  },

  listProposals: function(instance, params) {
    return instance.listProposals(params);
  },

  getProposal: function(instance, params) {
    return instance.getProposal(params);
  },

  listNervousSystemFunctions: function(instance, params) {
    return instance.listNervousSystemFunctions(params);
  },

  metadata: function(instance, params) {
    return instance.metadata(params);
  },

  nervousSystemParameters: function(instance, params) {
    return instance.nervousSystemParameters(params);
  }
  
};

export default snsGovernance;
