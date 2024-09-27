<script lang="ts">
  export let text: string;
  let tooltipVisible = false;

  function toggleTooltip() {
    tooltipVisible = !tooltipVisible;
  }
</script>

<button
  class="relative flex items-center"
  on:mouseenter={() => (tooltipVisible = true)}
  on:mouseleave={() => (tooltipVisible = false)}
  on:click={toggleTooltip}
>
  <slot />
  {#if tooltipVisible}
    <button
      class="absolute z-10 w-auto p-2 bg-black text-white text-sm rounded-md shadow-lg p-4 min-w-[200px] hidden md:flex"
      style="transform: translate(-50%, -50%); top: 50%; left: 50%;"
      on:click={toggleTooltip}
    >
      {text}
    </button>
    <button
      class="absolute z-10 w-auto p-2 bg-black text-white text-sm rounded-md shadow-lg p-4 min-w-[200px] flex md:hidden"
      on:click={toggleTooltip}
    >
      {text}
    </button>
  {/if}
</button>
