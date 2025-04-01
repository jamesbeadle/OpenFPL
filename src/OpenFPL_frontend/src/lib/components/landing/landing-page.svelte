<script lang="ts">
    import LandingPageDisplay from "./landing-page-display.svelte";
    import LandingPageFooter from "./landing-page-footer.svelte";
</script>

<svelte:head>
    <link rel="preload" href="/landing-background.jpeg" as="image" />
</svelte:head>

<div class="flex flex-col w-full h-screen space-y-4 md:bg-BrandGrayBg md:p-3 md:flex-row">
    <div class="relative flex flex-col w-full h-full bg-center bg-cover md:rounded-lg md:w-1/2" style="background-image: url('landing-background.jpeg')">
        <div class="items-end h-full p-4 md:flex bg-gradient-to-t from-black/70 to-transparent md:rounded-lg">
            <h1 class="hidden w-full text-2xl font-bold text-center md:block md:mb-8 md:py-1">
                The world's game on the world's computer
            </h1>
            <div class="flex items-center justify-center min-h-[55%] mx-4 my-24 rounded-lg bg-BrandGray md:hidden">
                <LandingPageDisplay />
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
        <LandingPageDisplay />
        <LandingPageFooter />
    </div>
</div>
