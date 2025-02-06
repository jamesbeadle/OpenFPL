import { requestVerifiablePresentation, type VerifiablePresentationResponse } from "@dfinity/verifiable-credentials/request-verifiable-presentation";
import { Principal } from "@dfinity/principal";
class VerificationManager {
    requestVerification = async (verifyPrincipal: Principal): Promise<void> => {
        try {
          const jwt: string = await new Promise((resolve, reject) => {
            requestVerifiablePresentation({
              onSuccess: async (verifiablePresentation: VerifiablePresentationResponse) => {
                if ('Ok' in verifiablePresentation) {
                  resolve(verifiablePresentation.Ok);
                } else {
                  reject(new Error(verifiablePresentation.Err));
                }
              },
              onError(err) {
                reject(new Error(err));
              },
              issuerData: {
                origin: 'https://id.decideai.xyz',
                canisterId: Principal.fromText('qgxyr-pyaaa-aaaah-qdcwq-cai'),
              },
              credentialData: {
                credentialSpec: {
                  credentialType: 'ProofOfUniqueness',
                  arguments: {
                    minimumVerificationDate: "2024-12-10T00:00:00Z",
                  },
                },
                credentialSubject: verifyPrincipal,
              },
              identityProvider: new URL('https://identity.ic0.app/'),
              derivationOrigin: window.location.origin,
            });
          });
      
          // Send JWT to your backend canister for verification
          await backendCanister.verifyCredential(jwt);
      
        } catch (error) {
          console.error('Verification failed:', error);
          throw error;
        }
      };
}