<script lang="ts">
    export let header: string;
    export let content: string;
</script>
    <div class="flex items-center justify-between px-2 py-3 bg-BrandGray/60">
      <span class="w-4/6">{header}:</span>
      <span class="w-2/6 text-center">{content}</span>
    </div>
