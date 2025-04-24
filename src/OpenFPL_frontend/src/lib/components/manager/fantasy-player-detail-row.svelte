<script lang="ts">
    interface Props {
        col1: string;
        col2: string;
        col3: string;
    }
    let { col1, col2, col3 }: Props = $props();
</script>
<div class="w-2/6 text-left">{col1}</div>
<div class="w-2/6 text-center">{col2}</div>
<div class="w-2/6 text-center">{col3}</div>