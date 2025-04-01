<script lang="ts">
    import { userGetProfilePicture } from "$lib/derived/user.derived";
</script>
<div class="w-full px-2 md:w-1/2 lg:w-1/3 xl:w-1/4">
    <div class="flex flex-col group md:block">
        <img src={$userGetProfilePicture} alt="Profile" class="w-full mb-1 rounded-lg" />
    </div>
</div>