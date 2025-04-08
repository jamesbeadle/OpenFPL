<script lang="ts">
    import { authSignedInStore } from '$lib/derived/auth.derived';
    import { userIdCreatedStore } from '$lib/stores/user-control-store';
    import { userStore } from '$lib/stores/user-store';
    import { get } from 'svelte/store';
    import { onMount, type Snippet } from 'svelte';
    import type { CombinedProfile, MembershipType__1 } from '../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did';
    import { page } from '$app/state';
    
    import Header from '$lib/shared/Header.svelte';
    import Footer from '$lib/shared/Footer.svelte';
    import InvalidMembershipPage from '$lib/components/profile/invalid-membership-page.svelte';
    import MembershipProfile from '$lib/components/profile/membership-profile.svelte';
    import LandingPage from '$lib/components/landing/landing-page.svelte';
    import FullScreenSpinner from '../shared/full-screen-spinner.svelte';
    
    interface Props {
        children: Snippet;
    }
    let { children }: Props = $props();

    let isLoading = $state(false);
    let hasValidMembership = $state(false);
    let profile: CombinedProfile | undefined = $state(undefined);
    let loadingMessage = $state("");
    let profileChecked = $state(false);

    function checkValidMembership(membershipType: MembershipType__1): boolean {
        console.log("checkValidMembership", membershipType);
        return 'Founding' in membershipType || 
               'Seasonal' in membershipType || 
               'Lifetime' in membershipType || 
               'Monthly' in membershipType;
    }

    async function checkProfile() {
        isLoading = true;
        try {
            if (!get(authSignedInStore)) return;
            
            loadingMessage = "Searching for Profile";
            profile = await userStore.getUser();
            console.log('profile', profile);
            if (profile) {
                loadingMessage = "Found Profile, checking membership";
                hasValidMembership = checkValidMembership(profile.membershipType);
            } else {
                loadingMessage = "Profile not found";
                hasValidMembership = false;
            }
        } catch (error) {
            loadingMessage = "Profile not found";
            console.error('Error fetching user profile:', error);
            hasValidMembership = false;
        } finally {
            isLoading = false;
            console.log("checkProfile finished");
            profileChecked = true;
        }
    }

    onMount(() => {
        console.log("onMount checkProfile");
        checkProfile();
    });

    $effect(() => {
        console.log('userIdCreatedStore', $userIdCreatedStore);
        if($userIdCreatedStore?.data) {
            isLoading = true;
            checkProfile();
        }
    });
</script>

{#if isLoading}
    <FullScreenSpinner message={loadingMessage} />
{:else if $authSignedInStore}
    <!-- {#if $userIdCreatedStore?.data}
       {#if !hasValidMembership && profileChecked}
          <Header />  
          <InvalidMembershipPage />
        {:else if profileChecked} -->
            <div class="flex flex-col min-h-screen">
                <Header />
                <main class="flex-grow page-wrapper">
                    {@render children()}
                </main>
                <Footer />
            </div>
        <!-- {/if}
    {:else if profileChecked}
        <MembershipProfile />
    {/if} -->
{:else}
    {#if page.route.id === '/'}
        <LandingPage />
    {:else}
        <div class="flex flex-col min-h-screen">
            <Header />
            <main class="flex-grow page-wrapper">
                {@render children()}
            </main>
            <Footer />
        </div>
    {/if}
{/if}