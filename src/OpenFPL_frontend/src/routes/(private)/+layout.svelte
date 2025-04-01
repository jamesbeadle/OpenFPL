<script lang="ts">
    import type { Snippet } from 'svelte';
    import { browser } from '$app/environment';
    import { goto } from '$app/navigation';
    import { authSignedInStore } from '$lib/derived/auth.derived';
  
    interface Props {
      children: Snippet;
    }
    let { children }: Props = $props();

    $effect(() => {
      if (browser && !$authSignedInStore) {
        goto('/', { replaceState: true });
      }
    });
</script>
  
{@render children()}