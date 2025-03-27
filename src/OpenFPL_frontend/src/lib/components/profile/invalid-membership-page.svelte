<script lang="ts">
    import CopyPrincipal from "./copy-principal.svelte";
</script>


<div class="flex flex-col space-y-4">
    <p>Only ICFC ecosystem owners can play OpenFPL.</p>
    <p>Please visit <a href="https://icfc.app">https://icfc.app</a> to setup your membership and link your OpenFPL principal ID:</p>
    <CopyPrincipal />
    <button class="brand-button">Refresh</button>
</div>