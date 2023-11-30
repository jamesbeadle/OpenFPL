<script lang="ts">
  let value = process.env.DFX_NETWORK;
  console.log(value);
  import { isLoading } from "../lib/stores/global-stores";
  import Header from "$lib/shared/Header.svelte";
  import Footer from "$lib/shared/Footer.svelte";
  import Toast from "$lib/components/toast.svelte";
  import LoadingIcon from "$lib/icons/LoadingIcon.svelte";
  import "../app.css";
</script>

<div class="flex flex-col h-screen justify-between">
  <Header />
  {#if $isLoading}
    <div class="loading-overlay">
      <LoadingIcon />
    </div>
  {:else}
    <main>
      <slot />
    </main>
    <Toast />
  {/if}
  <Footer />
</div>

<style>
  .loading-overlay {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    display: flex;
    justify-content: center;
    align-items: center;
    background-color: rgba(0, 0, 0, 0.5);
    z-index: 10;
  }

  main {
    flex: 1;
    display: flex;
    flex-direction: column;
  }
</style>
