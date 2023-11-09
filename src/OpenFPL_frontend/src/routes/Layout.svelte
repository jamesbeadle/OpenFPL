<script>
  import Header from "$lib/shared/Header.svelte";
  import Footer from "$lib/shared/Footer.svelte";
    import "../app.css";
</script>

<div class="flex flex-col h-screen justify-between">
  <Header />
  <main class="mb-auto">
    <slot />
  </main>
  <Footer />
</div>

<style>
  /* Add any additional global styles here */
</style>
