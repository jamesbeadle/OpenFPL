<script lang="ts">

    interface Props {
      selectedFixtureType: number;
    }
    let { selectedFixtureType }: Props = $props();

</script>

<div class="flex w-full flex-col">
    <p class="input-header">Select Fixture Type:</p>
    <select class="fpl-dropdown" value={selectedFixtureType}>
      <option value={-1}>All</option>
      <option value={0}>Home</option>
      <option value={1}>Away</option>
    </select>
</div>
