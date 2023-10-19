import { Actor, HttpAgent } from '@dfinity/agent';
import { assertNonNullish } from '@dfinity/utils';
import { OpenFPL_backend as open_fpl_backend } from '../../../declarations/OpenFPL_backend';

export const getBackendActor = (identity) => {
	assertNonNullish(identity, 'No internet identity.');

	const canisterId = process.env.CANISTER_ID_OPENFPL_BACKEND;
	return createActor({
		canisterId,
		open_fpl_backend,
		identity
	});
};

export const createActor = async ({ canisterId, idlFactory, identity }) => {
	const agent = await getAgent({ identity });
	// Creates an actor with using the candid interface and the HttpAgent
	return Actor.createActor(idlFactory, {
		agent,
		canisterId
	});
};

export const getAgent = (params) => {
    
    if (process.env.DFX_NETWORK == "local") {
		return getLocalAgent(params);
	}

	return getMainnetAgent(params);
};


const getMainnetAgent = async ({ identity }) => {
	const host = 'https://icp-api.io';
	return new HttpAgent({ identity, ...(host && { host }) });
};

const getLocalAgent = async ({ identity }) => {
	const host = 'http://localhost:8081/';

	const agent = new HttpAgent({ identity, ...(host && { host }) });

	// Fetch root key for certificate validation during development
	await agent.fetchRootKey();

	return agent;
};
