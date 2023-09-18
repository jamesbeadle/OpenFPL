import { SnsGovernanceCanister } from '@dfinity/sns'; // Assuming the import path

const snsGovernance = {};

// Create instance of the SnsGovernanceCanister
snsGovernance.createInstance = (agent, canisterId) => {
  return SnsGovernanceCanister.create({
    agent,
    canisterId
  });
};

// List the neurons of the Sns
snsGovernance.listNeurons = async (instance, params) => {
  return await instance.listNeurons(params);
};

// List the proposals of the Sns
snsGovernance.listProposals = async (instance, params) => {
  return await instance.listProposals(params);
};

// Get the proposal of the Sns
snsGovernance.getProposal = async (instance, params) => {
  return await instance.getProposal(params);
};

// List Nervous System Functions
snsGovernance.listNervousSystemFunctions = async (instance, params) => {
  return await instance.listNervousSystemFunctions(params);
};

// Get the Sns metadata (title, description, etc.)
snsGovernance.metadata = async (instance, params) => {
  return await instance.metadata(params);
};

// Get the Sns nervous system parameters 
snsGovernance.nervousSystemParameters = async (instance, params) => {
  return await instance.nervousSystemParameters(params);
};

// ... Continue in a similar fashion for the rest of the methods ...

export default snsGovernance;
