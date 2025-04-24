<script lang="ts">

    interface Props {
        selectedMonth: number;
    }
    let { selectedMonth }: Props = $props();

    function changeMonth(delta: number) {
        selectedMonth += delta;
        if (selectedMonth > 12) {
            selectedMonth = 1;
        } else if (selectedMonth < 1) {
            selectedMonth = 12;
        }
    }

</script>

<div class="flex w-full flex-col">
    <p class="input-header">Select Month:</p>
    <div class="flex items-center">
        <button class="mr-1 default-button fpl-button" onclick={() => changeMonth(-1)}>
            &lt;
        </button>

        <select class="fpl-dropdown" value={selectedMonth}>
            <option value={1}>January</option>
            <option value={2}>February</option>
            <option value={3}>March</option>
            <option value={4}>April</option>
            <option value={5}>May</option>
            <option value={6}>June</option>
            <option value={7}>July</option>
            <option value={8}>August</option>
            <option value={9}>September</option>
            <option value={10}>October</option>
            <option value={11}>November</option>
            <option value={12}>December</option>
        </select>

        <button class="ml-3 default-button fpl-button" onclick={() => changeMonth(1)}>
            &gt;
        </button>
    </div>
</div>
