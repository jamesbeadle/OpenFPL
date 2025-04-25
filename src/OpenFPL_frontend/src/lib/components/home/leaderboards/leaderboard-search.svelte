<script lang="ts">
  
    interface Props {
      searchTerm: string;
    }
    let { searchTerm }: Props = $props();
  
    let searchInput: string = $state("");
  
    function executeSearch() {
      searchTerm = searchInput;
    }
  
    function resetSearch() {
      searchInput = "";
      searchTerm = "";
    }
  
    function handleKeydown(event: KeyboardEvent) {
      if (event.key === 'Enter') {
        executeSearch();
      }
    }
  </script>
  
  <div class="px-4 mb-6">
    <div class="relative flex gap-2">
      <div class="relative flex-1">
        <input
          type="text"
          placeholder="Search by username..."
          onkeydown={handleKeydown}
          value={searchInput}
          class="w-full px-4 py-3 text-white transition-colors border border-gray-700 rounded-lg bg-BrandGray focus:outline-none focus:border-BrandGreen"
        />
        <svg class="absolute right-4 top-3.5 md:h-5 md:w-5 h-3 w-3 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
        </svg>
      </div>
      <button
        onclick={executeSearch}
        class="px-4 py-2 text-white transition-colors border border-gray-700 rounded-lg bg-BrandGray hover:bg-BrandGrayShade1 focus:outline-none focus:border-BrandGreen"
      >
        Search
      </button>
      <button
        onclick={resetSearch}
        class="px-4 py-2 text-white transition-colors border border-gray-700 rounded-lg bg-BrandGray hover:bg-BrandGrayShade1 focus:outline-none focus:border-BrandGreen"
      >
        Reset
      </button>
    </div>
  </div>
  