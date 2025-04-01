<script lang="ts">
    import type { Snippet } from "svelte";

  interface Props { children: Snippet }
  let { children }: Props = $props();
</script>
<div class="page-header-wrapper">
    {@render children()}
</div>