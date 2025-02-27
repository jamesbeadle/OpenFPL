<script lang="ts">
    import { authStore, type AuthSignInParams } from "$lib/stores/auth.store"
    import { goto } from "$app/navigation";
    import OpenFPLIconWithText from "$lib/icons/OpenFPLIconWithText.svelte";
    import IcpLogo from "$lib/icons/IcpLogo.svelte";
    import JunoIcon from "$lib/icons/JunoIcon.svelte";

    async function handleLoginClick() {
        let params: AuthSignInParams = {
            domain: import.meta.env.VITE_AUTH_PROVIDER_URL,
        };
        await authStore.signIn(params);
        goto("/", {invalidateAll: true});
    }
</script>

<div class="flex flex-col w-full min-h-screen p-3 bg-BrandGrayBg md:flex-row">
    <div class="w-full bg-center bg-cover rounded-lg md:w-1/2" style="background-image: url('landing-background.jpeg')">
        <div class="flex items-end h-full p-4 rounded-lg bg-gradient-to-t from-black/70 to-transparent">
            <h1 class="w-full py-32 text-2xl font-bold text-center md:py-1">
                The world's game on the world's computer
            </h1>
        </div>
    </div>
    <div class="relative flex flex-col items-center justify-center w-full md:w-1/2">
        <div class="items-center w-full max-w-sm">
            <div class="flex items-center justify-center mb-5">
                <OpenFPLIconWithText className="w-40 h-40" />
            </div>
            <p class="mb-12 text-center text-BrandGrayShade3">
                Decentralised Fantasy Premier League
            </p>
            <div class="flex flex-row items-center justify-center mb-4 space-x-4">
                <div class="w-full ml-2 border border-l border-BrandGrayShade1"></div>
                <p class="text-xxs whitespace-nowrap">Connect Instantly</p>
                <div class="w-full mr-2 border border-r border-BrandGrayShade1"></div>
            </div>
            <div class="space-y-5">
                <button 
                    class="flex items-center justify-center w-full py-2 rounded bg-BrandGrayShade1 hover:bg-BrandGrayShade2"
                    on:click={handleLoginClick}
                >
                  <span class="mr-2"><IcpLogo /></span> Internet Identity
                </button>
                <div class="mt-6 text-xs text-center">
                    <a href="/terms" target="_blank" class="underline hover:text-BrandGreen">Terms and Conditions</a>
                </div>
            </div>
        </div>

        <div class="absolute bottom-0 flex flex-row space-x left-4">
            <a
              href="https://oc.app/community/uf3iv-naaaa-aaaar-ar3ta-cai/?ref=zv6hh-xaaaa-aaaar-ac35q-cai"
              target="_blank"
              rel="noopener noreferrer"
            >
              <img
                src="/openchat.png"
                class="w-auto h-4 mb-2 mr-2"
                alt="OpenChat"
              />
            </a>
            <a
              href="https://x.com/OpenFPL_DAO"
              target="_blank"
              rel="noopener noreferrer"
            >
              <img src="/twitter.png" class="w-auto h-4 mb-2 mr-2" alt="X" />
            </a>
            <a
              href="https://github.com/jamesbeadle/OpenFPL"
              target="_blank"
              rel="noopener noreferrer"
            >
              <img src="/github.png" class="w-auto h-4 mb-2" alt="GitHub" />
            </a>
        </div>
        <div class="absolute bottom-0 right-0 flex flex-row space-x">
            <div class="px-4 mt-1 text-xs text-right md:px-0 md:mt-0 md:mr-4">
                <a
                  href="https://juno.build"
                  target="_blank"
                  class="flex items-center hover:text-gray-300"
                >
                  Sponsored By juno.build
                  <JunoIcon className="h-8 w-auto ml-2" />
                </a>
              </div>
        </div>
    </div>
</div>