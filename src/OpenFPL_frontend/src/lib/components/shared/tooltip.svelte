<script lang="ts">
    import type { Snippet } from "svelte";

  interface Props {
    text: string;
    children: Snippet;
  }

  let { text, children }: Props = $props();

  let tooltipVisible = false;

  function toggleTooltip() {
    tooltipVisible = !tooltipVisible;
  }
</script>

<button
  class="relative z-10 flex items-center"
  on:mouseenter={() => (tooltipVisible = true)}
  on:mouseleave={() => (tooltipVisible = false)}
  on:click={toggleTooltip}
>
  {@render children()}
  {#if tooltipVisible}
    <button
      class="absolute z-10 w-auto bg-black text-white text-sm rounded-md shadow-lg p-4 min-w-[200px] text-center whitespace-normal hidden md:flex"
      style="transform: translate(-50%, -50%); top: 100%; left: 80%;"
      on:click={toggleTooltip}
    >
      {text}
    </button>
    <button
      class="absolute z-10 w-auto bg-black text-white text-sm rounded-md shadow-lg p-4 min-w-[200px] text-center whitespace-normal flex md:hidden"
      on:click={toggleTooltip}
    >
      {text}
    </button>
  {/if}
</button>