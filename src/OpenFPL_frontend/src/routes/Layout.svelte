<script lang="ts">
  import { writable } from 'svelte/store';
  import Header from "$lib/shared/Header.svelte";
  import Footer from "$lib/shared/Footer.svelte";
  import Toast from "$lib/components/toast.svelte";
  import LoadingIcon from '$lib/icons/LoadingIcon.svelte';
  import "../app.css";

  export const isLoading = writable(false);
</script>

<div class="flex flex-col h-screen justify-between">
  <Header />
  <main class="mb-auto">
    <slot />
  </main>
  <Toast />
  {#if $isLoading}
    <LoadingIcon />
  {/if}
  <Footer />
</div>
