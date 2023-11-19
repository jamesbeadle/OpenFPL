<script lang="ts">
  import { page } from '$app/stores';
  $: id = $page.url.searchParams.get('id');
  
</script>
  
<h1>Club {id}</h1>
