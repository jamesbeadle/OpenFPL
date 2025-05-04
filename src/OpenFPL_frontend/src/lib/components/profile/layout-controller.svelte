<script lang="ts">
    import { authSignedInStore } from '$lib/derived/auth.derived';
    import { userIdCreatedStore } from '$lib/stores/user-control-store';
    import { userStore } from '$lib/stores/user-store';
    import { get } from 'svelte/store';
    import { onMount, type Snippet } from 'svelte';
    import type { CombinedProfile, MembershipType } from '../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did';
    
    import Header from '$lib/shared/Header.svelte';
    import Footer from '$lib/shared/Footer.svelte';
    import InvalidMembershipPage from '$lib/components/profile/membership/invalid-membership-page.svelte';
    import MembershipProfile from '$lib/components/profile/membership/membership-profile.svelte';
    import LandingPage from '$lib/components/landing/landing-page.svelte';
    import FullScreenSpinner from '../shared/global/full-screen-spinner.svelte';
    import Sidebar from '$lib/shared/sidebar.svelte';
    
    interface Props {
        children: Snippet;
    }
    let { children }: Props = $props();

    let isLoading = $state(false);
    let hasValidMembership = $state(false);
    let profile: CombinedProfile | undefined = $state(undefined);
    let loadingMessage = $state("");
    let profileChecked = $state(false);
    let isMenuOpen = $state(false);

    function toggleMenu() {
        isMenuOpen = !isMenuOpen;
    }
    
    function checkValidMembership(membershipType: MembershipType): boolean {
        console.log("checkValidMembership", membershipType);
        return 'Founding' in membershipType || 
               'Seasonal' in membershipType || 
               'Lifetime' in membershipType || 
               'Monthly' in membershipType;
    }

    async function checkProfile() {
        let i = 1;
        console.log("checkProfile", i);
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
            profileChecked = true;
        }
        i++;
    }

    onMount(() => {
        console.log("onMount checkProfile");
        checkProfile();
    });
</script>

{#if isLoading}
    <FullScreenSpinner message={loadingMessage} />
{:else if $authSignedInStore}
    <Header {toggleMenu} />  
    <Sidebar {isMenuOpen} {toggleMenu} />
    {#if $userIdCreatedStore?.data}
       {#if !hasValidMembership && profileChecked}
          <InvalidMembershipPage />
        {:else if profileChecked}
            <div class="flex flex-col min-h-screen">
                <main class="flex-grow page-wrapper">
                    {@render children()}
                </main>
                <Footer />
            </div>
        {/if}
    {:else if profileChecked}
        <MembershipProfile />
    {/if}
{:else}
    <LandingPage />
{/if}