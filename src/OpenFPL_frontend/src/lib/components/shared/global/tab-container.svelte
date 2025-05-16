<script lang="ts">
    interface Props {
        activeTab: string;
        setActiveTab: (tabName: string) => void;
        tabs:  { id: string; label: string }[]
    }
    let { activeTab, setActiveTab, tabs }: Props = $props();

</script>

<div class="m-4">
    <div class="bg-panel">

        <div class="w-full">
            <ul class="flex flex-wrap w-full px-2 pt-2 border-b border-gray-700 rounded-t-lg sm:px-4 bg-light-gray">
                {#each tabs as tab}
                    <li class="mb-2 {activeTab === tab.id ? 'active-tab' : ''} flex-shrink-0">
                        <button 
                            class="p-2 text-sm sm:text-base whitespace-nowrap
                                {activeTab === tab.id ? 'text-white' : 'text-gray-400'}"
                            onclick={() => setActiveTab(tab.id)}
                        >
                            {tab.label}
                        </button>
                    </li>
                {/each}
            </ul>
        </div>


    </div>
  </div>