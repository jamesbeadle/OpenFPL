<script lang="ts">
  interface Props {
    header: string;
    content: string;
  }
  let { header, content }: Props = $props();
</script>
    <div class="flex items-center justify-between px-2 py-3 bg-BrandGray/60">
      <span class="w-4/6">{header}:</span>
      <span class="w-2/6 text-center">{content}</span>
    </div>
