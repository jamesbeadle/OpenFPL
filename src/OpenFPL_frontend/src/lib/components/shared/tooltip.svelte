<script lang="ts">
    import type { Snippet } from "svelte";

  interface Props {
    text: string;
    children: Snippet;
  }

  let { text, children }: Props = $props();

  let tooltipVisible = $state(false);

  function toggleTooltip() {
    tooltipVisible = !tooltipVisible;
  }
</script>

<button
  class="relative z-10 flex items-center"
  onmouseenter={() => (tooltipVisible = true)}
  onmouseleave={() => (tooltipVisible = false)}
  onclick={toggleTooltip}
>
  {@render children()}
  {#if tooltipVisible}
    <div
      class="absolute z-10 w-auto bg-black text-white text-sm rounded-md shadow-lg p-4 min-w-[200px] text-center whitespace-normal hidden md:flex"
      style="transform: translate(-50%, -50%); top: 100%; left: 80%;"
    >
      {text}
    </div>
    <div
      class="absolute z-10 w-auto bg-black text-white text-sm rounded-md shadow-lg p-4 min-w-[200px] text-center whitespace-normal flex md:hidden"
    >
      {text}
    </div>
  {/if}
</button>