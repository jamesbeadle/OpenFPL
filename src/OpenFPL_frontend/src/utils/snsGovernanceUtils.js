// snsGovernanceUtils.js

/**
 * Convert a neuron's data into a human-readable format.
 * This is a simple example; you might have much more complex transformations.
 */
export const formatNeuronData = (neuron) => {
    return {
        id: neuron.id,
        age: Date.now() - neuron.creationTimestamp,  // convert timestamp into age
        status: neuron.status ? "Active" : "Inactive",
        // ... any other transformations ...
    };
};

/**
 * Filter out proposals based on some criteria.
 * This is a simple example; your real criteria might differ.
 */
export const filterActiveProposals = (proposals) => {
    return proposals.filter(proposal => proposal.status === "Active");
};

/**
 * Validate neuron's data before sending to the server.
 * Again, this is a simple example.
 */
export const validateNeuronData = (neuron) => {
    if (!neuron.id) {
        throw new Error("Neuron ID is missing.");
    }
    // ... any other validations ...
    return true;
};

// ... any other utility functions ...

