<script lang="ts">
    import type { Writable } from "svelte/store";

    export let selectedFixtureType: Writable<number>;
</script>
<div class="flex p-4">
    <div class="flex items-center">
      <p>Type:</p>
      <select
        class="px-2 fpl-dropdown text-center mx-0 md:mx-2 min-w-[100px]"
        bind:value={$selectedFixtureType}
      >
        <option value={-1}>All</option>
        <option value={0}>Home</option>
        <option value={1}>Away</option>
      </select>
    </div>
  </div>