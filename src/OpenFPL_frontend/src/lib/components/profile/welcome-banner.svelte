<script lang="ts">
    import { slide } from 'svelte/transition';
    
    interface Props {
      visible: boolean; 
    }
    let { visible }: Props = $props();
    
    let showSecondMessage = $state(false);

    function dismiss() {
        if (!showSecondMessage) {
            showSecondMessage = true;
        } else {
            visible = false;
        }
    }
</script>

{#if visible}
    <div 
        transition:slide 
        class="p-4 mb-4 text-white rounded-lg shadow-lg bg-gradient-to-r from-BrandPurple to-BrandPurple/80"
    >
        <div class="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
            <div class="flex-1">
                {#if !showSecondMessage}
                    <h3 class="mb-1 font-bold">Welcome, new manager!</h3>
                    <p class="text-white/90">
                        You can now update your profile picture, edit your username and favorite team, 
                        withdraw FPL, and view your gameweek history.
                    </p>
                {:else}
                    <h3 class="mb-1 font-bold">Ready to get started?</h3>
                    <p class="text-white/90">
                        Once you're done exploring your profile, check out the Home page or go to Squad Selection to pick your 
                        team and join the competition. Good luck on your FPL journey!
                    </p>
                {/if}
            </div>
            <button 
                onclick={dismiss}
                class="self-center px-6 py-2 font-medium transition-colors rounded-lg bg-white/10 hover:bg-white/20"
            >
                {!showSecondMessage ? 'Got it!' : 'Let\'s go!'}
            </button>
        </div>
    </div>
{/if} 