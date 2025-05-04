<script lang="ts">
    import LoadingDots from "../global/loading-dots.svelte";


  interface Props {
      header: string;
      content: string;
      footer: string;
      loading: boolean;
  }
  let { header, content, footer, loading }: Props = $props();

</script>

<div class="flex-grow">
  <p class="content-panel-header">{header}</p>
  <p class="content-panel-stat">

      {#if loading}
          <LoadingDots />
      {:else}
          {content}
      {/if}
  </p>
  <p class="content-panel-header">
    {footer}
  </p>
</div>