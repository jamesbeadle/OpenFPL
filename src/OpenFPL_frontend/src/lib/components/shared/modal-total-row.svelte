<script lang="ts">
    export let header: string;
    export let content: string;
</script>
<div class="mt-2">
    <div class="flex justify-between items-center bg-light-gray p-2 border-t border-b border-gray-600">
      <span class="w-5/6">{header}:</span>
      <span class="w-1/6">{content}</span>
    </div>
  </div>
