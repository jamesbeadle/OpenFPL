<script lang="ts">
    import SortIcon from "$lib/icons/SortIcon.svelte";
    
    export let sortField: 'value' | 'points';
    export let sortDirection: 'asc' | 'desc';
    export let toggleSort: (field: 'value' | 'points') => void;
</script>

<div class="flex items-center justify-between py-2 border-b border-gray-700">
    <div class="w-1/12 text-center">Pos</div>
    <div class="w-2/12">Player</div>
    <div class="w-2/12">Team</div>
    <button class="flex items-center w-2/12" on:click={() => toggleSort('value')}>
        Value
        <SortIcon 
            className="w-2 lg:w-3 ml-1 xxs:ml-2"
            fill1={sortField === 'value' && sortDirection === 'desc' ? '#2CE3A6' : '#454B56'}
            fill2={sortField === 'value' && sortDirection === 'asc' ? '#2CE3A6' : '#454B56'}
        />
    </button>
    <button class="flex items-center w-2/12" on:click={() => toggleSort('points')}>
        Points
        <SortIcon 
            className="w-2 lg:w-3 ml-1 xxs:ml-2"
            fill1={sortField === 'points' && sortDirection === 'desc' ? '#2CE3A6' : '#454B56'}
            fill2={sortField === 'points' && sortDirection === 'asc' ? '#2CE3A6' : '#454B56'}
        />
    </button>
    <div class="w-2/12"></div>
</div>