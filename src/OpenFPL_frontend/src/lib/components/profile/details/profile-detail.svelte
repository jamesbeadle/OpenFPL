<script lang="ts">
  import ProfileImage from "./profile-image.svelte";
  import ProfileBalances from "../token-balances/profile-balances.svelte";
  import ProfileProperties from "./profile-properties.svelte";
</script>
<div class="container mx-auto p-4">
  <div class="flex flex-wrap">
    <ProfileImage />
    <ProfileProperties />
  </div>
  <ProfileBalances />
</div>