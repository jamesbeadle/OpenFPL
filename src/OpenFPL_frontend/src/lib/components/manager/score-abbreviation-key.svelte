<script lang="ts">

    import ActiveCaptainIcon from "$lib/icons/ActiveCaptainIcon.svelte";

</script>
<div class="flex flex-row px-4 py-2">
    <div class="xxs:hidden w-full">
      <div class="flex flex-row space-x-2">
        <div class="w-1/2 flex flex-col">
          <p class="mb-1">A: Appearance</p>
          <p>HSP: Highest Scoring Player</p>
        </div>
        <div class="w-1/2 flex flex-col">
          <p class="mb-1">B: Bonus Points</p>
          <p>PTS: Total Points</p>
        </div>
      </div>
    </div>
  
    <div
      class="hidden xxs:grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 gap-2 w-full text-xs my-4"
    >
      <p>A: Appearance</p>
      <p>HSP: Highest Scoring Player</p>
      <p>GS: Goals Scored</p>
      <p>GA: Goals Assisted</p>
      <p>PS: Penalties Saved</p>
      <p>CS: Clean Sheets</p>
      <p>KS: Keeper Saves</p>
      <p>YC: Yellow Cards</p>
      <p>OG: Own Goals</p>
      <p>GC: Goals Conceded</p>
      <p>RC: Red Cards</p>
      <p>B: Bonus Points</p>
      <div class="flex items-center">
        <p>C: Captain Points</p>
        <ActiveCaptainIcon className="w-4 md:w-6 ml-2" />
      </div>
      <p>PTS: Total Points</p>
    </div>
  </div>