<script lang="ts">
    import { onMount, onDestroy } from 'svelte';
  
    let dotCount: number = 1;
    let direction: number = 1;
    let intervalId: ReturnType<typeof setInterval>;
  
    onMount(() => {
      intervalId = setInterval(() => {
        dotCount += direction;
        if (dotCount === 3) {
          direction = -1;
        } else if (dotCount === 1) {
          direction = 1;
        }
      }, 500);
    });
  
    onDestroy(() => {
      clearInterval(intervalId);
    });
  </script>
  
  <div class="flex items-center space-x-1">
    {#each Array(dotCount) as _, i}
      .
    {/each}
  </div>
  