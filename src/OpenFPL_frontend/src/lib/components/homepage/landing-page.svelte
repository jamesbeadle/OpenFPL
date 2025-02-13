<script lang="ts">
    import { authStore, type AuthSignInParams } from "$lib/stores/auth.store"
    import OpenFPLIcon from "$lib/icons/OpenFPLIcon.svelte";
    import WalletIcon from "$lib/icons/WalletIcon.svelte";

    function handleLogin() {
        let params: AuthSignInParams = {
            domain: import.meta.env.VITE_AUTH_PROVIDER_URL,
        };
        authStore.signIn(params);
    }
</script>

<div class="flex flex-col items-center justify-center h-full bg-gradient-to-b from-black to-gray-900">
    <div class="flex flex-col items-center p-8 space-y-8 rounded-lg">
        <OpenFPLIcon className="w-32 h-32" currentColor="#2CE3A6" />
        <div class="space-y-4 text-center">
            <h1 class="text-4xl font-bold text-transparent bg-gradient-to-r from-BrandGreen to-blue-500 bg-clip-text">
                Welcome to OpenFPL
            </h1>
            <h2 class="text-xl text-gray-300">
                Decentralised Fantasy Premier League
            </h2>
        </div>
        <button 
            class="flex items-center px-6 py-3 mt-6 text-lg font-semibold text-white transition-all duration-200 rounded-lg shadow-lg bg-gradient-to-r from-BrandGreen to-blue-600 hover:opacity-90 hover:shadow-emerald-500/20"
            on:click={handleLogin}
        >
            Connect Internet Identity
            <WalletIcon className="ml-2 mt-2 h-6 w-6" />
        </button>
    </div>
</div>