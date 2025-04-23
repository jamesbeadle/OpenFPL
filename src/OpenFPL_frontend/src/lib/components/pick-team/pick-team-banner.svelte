<script lang="ts">
    import { slide } from 'svelte/transition';

    interface Props {
        visible: boolean;
        onDismiss: () => void;
    }
    let { visible, onDismiss }: Props = $props();
    
    
    let currentStep = $state(1);
    const totalSteps = 2;

    function nextStep() {
        if (currentStep < totalSteps) {
            currentStep++;
        } else {
            visible = false;
            onDismiss();
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
                {#if currentStep === 1}
                    <h3 class="mb-1 font-bold">Welcome to the OpenFPL Relaunch! 🎉</h3>
                    <p class="text-white/90">
                        We've reset all teams for a fresh start. You're now selecting your team for the 
                        next 10 gameweeks of the season. Build your squad carefully - you'll have limited 
                        transfers between gameweeks.
                    </p>
                {:else}
                    <h3 class="mb-1 font-bold">Need help getting started?</h3>
                    <p class="text-white/90">
                        Check out the rules in the footer for budget limits, scoring system, and transfer rules. 
                        Remember to pick a balanced team and choose your captain wisely!
                    </p>
                {/if}
            </div>
            <button 
                onclick={nextStep}
                class="self-center px-6 py-2 font-medium transition-colors rounded-lg bg-white/10 hover:bg-white/20"
            >
                {currentStep < totalSteps ? 'Next' : 'Got it!'}
            </button>
        </div>
    </div>
{/if} 