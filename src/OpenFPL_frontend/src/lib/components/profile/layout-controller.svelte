<script lang="ts">
    import { authSignedInStore } from '$lib/derived/auth.derived';
    import { userIdCreatedStore } from '$lib/stores/user-control-store';
    import type { Snippet } from 'svelte';
    import type { CombinedProfile, MembershipType__1 } from '../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did';

    import Header from '$lib/shared/Header.svelte';
    import Footer from '$lib/shared/Footer.svelte';
    import InvalidMembershipPage from '$lib/components/profile/invalid-membership-page.svelte';
    import MembershipProfile from '$lib/components/profile/membership-profile.svelte';
    import LandingPage from '$lib/components/landing/landing-page.svelte';
    import { UserService } from '$lib/services/user-service';
    import { authStore } from '$lib/stores/auth-store';
    import { get } from 'svelte/store';
    import LocalSpinner from '$lib/components/shared/local-spinner.svelte';
    import { onMount } from 'svelte';

    interface Props {
        children: Snippet;
    }
    let { children }: Props = $props();

    let isLoading = $state(true);
    let hasValidMembership = $state(false);
    let profile: CombinedProfile | undefined = $state(undefined);

    function checkValidMembership(membershipType: MembershipType__1): boolean {
        console.log("checkValidMembership", membershipType);
        return 'Founding' in membershipType || 
               'Seasonal' in membershipType || 
               'Lifetime' in membershipType || 
               'Monthly' in membershipType;
    }

    async function checkProfile() {
        try {
            const principalId = get(authStore).identity?.getPrincipal().toString();
            if (!principalId) return;
            
            profile = await new UserService().getUser();
            console.log('profile', profile);
            if (profile) {
                hasValidMembership = checkValidMembership(profile.membershipType);
            } else {
                hasValidMembership = false;
            }
        } catch (error) {
            console.error('Error fetching user profile:', error);
            hasValidMembership = false;
        } finally {
            isLoading = false;
        }
    }

    onMount(() => {
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
    <LocalSpinner />
{:else if $authSignedInStore}
    {#if $userIdCreatedStore?.data}
       {#if !hasValidMembership}
          <Header />  
          <InvalidMembershipPage />
        {:else}
            <Header />
                <main class="page-wrapper">
                    {@render children()}
                </main>
            <Footer />
        {/if}
    {:else}
        <MembershipProfile />
    {/if}
{:else}
    <LandingPage />
{/if}