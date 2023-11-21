<script>
  import Header from "$lib/shared/Header.svelte";
  import Footer from "$lib/shared/Footer.svelte";
  import "../app.css";
  import Toast from "$lib/components/toast.svelte";
</script>

<div class="flex flex-col h-screen justify-between">
  <Header />
  <main class="mb-auto">
    <slot />
  </main>
  <Toast />
  <Footer />
</div>

<style>
</style>
