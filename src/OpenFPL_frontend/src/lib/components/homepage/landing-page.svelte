<script lang="ts">
    import { authStore, type AuthSignInParams } from "$lib/stores/auth.store"
    import { goto } from "$app/navigation";
    import LandingPageDisplay from "./landing-page-display.svelte";
    import LandingPageFooter from "./landing-page-footer.svelte";
    
    async function handleLoginClick() {
        let params: AuthSignInParams = {
            domain: import.meta.env.VITE_AUTH_PROVIDER_URL,
        };
        await authStore.signIn(params);
        goto("/", {invalidateAll: true});
    }
</script>

<div class="flex flex-col w-full min-h-screen space-y-4 md:bg-BrandGrayBg md:p-3 md:flex-row">
    <div class="relative flex flex-col w-full h-full bg-center bg-cover md:rounded-lg md:w-1/2" style="background-image: url('landing-background.jpeg')">
        <div class="items-end h-full p-4 md:flex bg-gradient-to-t from-black/70 to-transparent md:rounded-lg">
            <h1 class="hidden w-full text-2xl font-bold text-center md:block md:mb-8 md:py-1">
                The world's game on the world's computer
            </h1>
            <div class="flex items-center justify-center min-h-[55%] mx-4 my-24 rounded-lg bg-BrandGray md:hidden">
                <LandingPageDisplay {handleLoginClick} />
            </div>
    
            <div class="pt-4 pb-6 md:hidden">
                <h2 class="mx-4 text-2xl text-center xxs:pb-8 text-bold md:hidden">
                    The world's game on the world's computer
                </h2>
                <div class="md:hidden">
                    <LandingPageFooter />
                </div>
            </div>
        </div>
    </div>
    <div class="items-center justify-center hidden w-1/2 h-full md:block md:px-auto">
        <LandingPageDisplay {handleLoginClick} />
        <LandingPageFooter />
    </div>
</div>
