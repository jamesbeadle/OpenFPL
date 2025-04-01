<script lang="ts">
    import { authSignedInStore } from "$lib/derived/auth.derived";
    export let activeTab: string;
    export let setActiveTab: (tabName: string) => void;

    export let tabs:  { id: string; label: string; authOnly: boolean }[];
    let isLoggedIn: boolean = $authSignedInStore;

</script>

<div class="flex w-full">
    <ul class="flex w-full px-4 pt-2 border-b border-gray-700 rounded-t-lg bg-light-gray">
        {#each tabs as tab}
            {#if !tab.authOnly || isLoggedIn}
                <li class={`mr-4 ${activeTab === tab.id ? "active-tab" : ""}`}>
                    <button 
                        class={`p-2 ${activeTab === tab.id ? "text-white" : "text-gray-400"}`}
                        on:click={() => setActiveTab(tab.id)}
                    >
                        {tab.label}
                    </button>
                </li>
            {/if}
        {/each}
    </ul>
</div>