<script lang="ts">
    import { writable } from "svelte/store";
    import type { CreatePrivateLeagueDTO } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    
    export let privateLeague = writable<CreatePrivateLeagueDTO | null>(null);
</script>

<div class="container mx-auto px-4 py-8">
    <h1 class="text-3xl font-bold text-center mb-6">OpenFPL Private League Terms & Conditions</h1>
    
    <div class="space-y-4 text-sm">
        <p>
            These Terms and Conditions govern your use of the private league features provided by OpenFPL. 
            By participating in any private league, you agree to these terms.
        </p>
        <p>
            Private leagues on OpenFPL are funded using ICRC-1 tokens. 
            Participants may be required to contribute a predetermined number of tokens to join a private league. 
            The distribution of tokens and any potential winnings are subject to the specific rules set forth by the league's creator.
        </p>
        <ul class="list-disc list-inside">
            <li>Entry requirements and fees.</li>
            <li>Distribution of winnings.</li>
            <li>Setting the league admin fee.</li>
        </ul>
        <p>
            It is your responsibility to clearly communicate these rules to all participants before the start of the league. 
            OpenFPL is not responsible for the enforcement of individual league rules and operates only as a platform provider.
        </p>
        <p>
            You are responsible for ensuring that your participation in private leagues complies with all applicable laws and regulations 
            in your jurisdiction. OpenFPL disclaims all liability for any illegal use of the platform by its users.
        </p>
        <p>
            OpenFPL provides the platform for private leagues "as is" and "as available," without any warranties of any kind. 
            We do not guarantee the continuous, uninterrupted or error-free operation of the platform, 
            nor do we guarantee the outcomes of any games or leagues conducted on our platform.
        </p>
        <p>
            To the fullest extent permitted by law, OpenFPL shall not be liable for any indirect, incidental, special, consequential, or punitive damages, 
            or any loss of profits or revenues, whether incurred directly or indirectly, or any loss of data, use, goodwill, 
            or other intangible losses resulting from:
        </p>
        <ul class="list-disc list-inside ml-4">
            <li>Your access to, use of, or inability to access or use the services;</li>
            <li>Any conduct or content of any third party on the services;</li>
            <li>Unauthorized access, use, or alteration of your transmissions or content.</li>
        </ul>
        <p>
            If you have any questions about these Terms and Conditions, please contact us at 
            <a href="https://oc.app/community/uf3iv-naaaa-aaaar-ar3ta-cai/?ref=zv6hh-xaaaa-aaaar-ac35q-cai" class="text-blue-600 hover:text-blue-800">
                OpenFPL Community Support
            </a>.
        </p>
        <div class="mt-6 flex items-center">
            <input type="checkbox" id="agreeTerms" name="agreeTerms" class="w-4 h-4 border-gray-300 rounded focus:ring-blue-500">
            <label for="agreeTerms" class="ml-2 block text-sm">
                I agree to the OpenFPL Private League Terms & Conditions
            </label>
        </div>
    </div>
</div>
