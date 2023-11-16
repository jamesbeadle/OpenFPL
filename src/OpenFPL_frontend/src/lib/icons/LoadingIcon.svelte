<script>
    import OpenFplIcon from "./OpenFPLIcon.svelte";

  export let progress = 0;
  export let className = '';
 
</script>

<div class="flex justify-center items-center h-screen">
  <div class={`${className} flex justify-center items-center h-screen`}>
    <div class="relative">
      <OpenFplIcon className="h-12 w-12" />

      <svg class="absolute top-0 left-0 h-full w-full svg-scale" viewBox="0 0 100 100">
        <circle
          cx="50"
          cy="50"
          r="45"
          stroke="#2CE3A6"
          stroke-dasharray="283"
          stroke-dashoffset="{283 - (progress / 100) * 283}"
          fill="transparent"
          stroke-width="5"
          transform="rotate(-90 50 50)"
        />
      </svg>
    </div>
  </div>
</div>


<style>
  circle {
    transition: stroke-dashoffset 0.2s;
  }
  .svg-scale {
    transform: scale(2);
  }
</style>
