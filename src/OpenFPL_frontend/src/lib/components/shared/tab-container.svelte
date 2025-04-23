<script lang="ts">
    import { authSignedInStore } from "$lib/derived/auth.derived";

    interface Props {
        activeTab: string;
        setActiveTab: (tabName: string) => void;
        tabs:  { id: string; label: string; authOnly: boolean }
    }
    let { activeTab, setActiveTab, tabs }: Props = $props();

    let isLoggedIn: boolean = $authSignedInStore;

</script>

<div class="w-full">
    <ul class="flex flex-wrap w-full px-2 pt-2 border-b border-gray-700 rounded-t-lg sm:px-4 bg-light-gray">
        {#each tabs as tab}
            {#if !tab.authOnly || isLoggedIn}
                <li class="mb-2 {activeTab === tab.id ? 'active-tab' : ''} flex-shrink-0">
                    <button 
                        class="p-2 text-sm sm:text-base whitespace-nowrap
                               {activeTab === tab.id ? 'text-white' : 'text-gray-400'}"
                        on:click={() => setActiveTab(tab.id)}
                    >
                        {tab.label}
                    </button>
                </li>
            {/if}
        {/each}
    </ul>
</div>