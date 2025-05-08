<script lang="ts">
    import IcpLogo from "$lib/icons/IcpLogo.svelte";
    import OpenFplIconWithText from "$lib/icons/OpenFPLIconWithText.svelte";
    import { signIn } from "$lib/services/auth-services";

</script>

<div class="relative flex flex-col items-center justify-center w-full md:min-h-screen">
    <div class="items-center w-full max-w-sm mx-4">
        <div class="flex items-center justify-center mb-5">
            <OpenFplIconWithText currentColor="#ffffff" className="w-32 h-32 md:w-40 md:h-40" />
        </div>
        <p class="mb-8 text-lg text-center text-BrandGrayShade3">
            Decentralised Fantasy Premier League
        </p>
        <div class="flex flex-row items-center justify-center mx-2 mb-4 space-x-2 md:space-x-4">
            <div class="w-full border border-l border-BrandGrayShade1"></div>
            <p class="text-center text-xxs whitespace-nowrap">Connect Instantly</p>
            <div class="w-full border border-r border-BrandGrayShade1"></div>
        </div>
        <div class="mx-2 space-y-4">
            <button 
                class="flex items-center justify-center w-full py-2 mr-8 rounded lg:mx-0 bg-BrandGrayShade1 hover:bg-BrandGrayShade2"
                onclick={async () => await signIn({})}
            >
              <span class="mr-2"><IcpLogo /></span> Internet Identity
            </button>
            <div class="mt-6 text-xs text-center">
                <a href="/terms" target="_blank" class="underline hover:text-BrandGreen">Terms and Conditions</a>
            </div>
        </div>
    </div>
</div>
