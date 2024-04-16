<script lang="ts">
    import { onMount } from 'svelte';
    import { writable } from 'svelte/store';
  
    let leagueName: string = '';
    let fileInputProfile: HTMLInputElement;
    let fileInputBanner: HTMLInputElement;
    let maxEntrants: number = 10000;
    let leaguePicture: File;
    let leagueBanner: File;
  
    function handgleLeaguePictureChange(event: Event) {
      const input = event.target as HTMLInputElement;
      if (input.files && input.files[0]) {
        const file = input.files[0];
        if (file.size > 500 * 1024) {
          alert("File size exceeds 500KB");
          return;
        }
        leaguePicture = file;
      }
    }
  
    function handgleLeagueBannerChange(event: Event) {
      const input = event.target as HTMLInputElement;
      if (input.files && input.files[0]) {
        const file = input.files[0];
        if (file.size > 500 * 1024) {
          alert("File size exceeds 500KB");
          return;
        }
        leagueBanner = file;
      }
    }
  
    onMount(() => {
      // Additional initialization if needed
    });
  </script>
  
  <div class="container mx-auto p-4">
    <p class="text-xl mb-2">League Details</p>
  
    <div class="mb-4">
      <label class="block text-gray-700 text-sm font-bold mb-2" for="league-name">
        League Name:
      </label>
      <input type="text" bind:value={leagueName} class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline" id="league-name" />
    </div>
  
    <div class="file-upload-wrapper mt-4">
      <label class="block text-gray-700 text-sm font-bold mb-2">
        League Photo:
        <button class="btn-file-upload fpl-button" on:click={() => fileInputProfile.click()}>Upload Photo</button>
        <input type="file" id="profile-image" accept="image/*" bind:this={fileInputProfile} on:change={handgleLeaguePictureChange} style="opacity: 0; position: absolute; left: 0; top: 0;" />
      </label>
    </div>
  
    <div class="file-upload-wrapper mt-4">
      <label class="block text-gray-700 text-sm font-bold mb-2">
        Banner Image:
        <button class="btn-file-upload fpl-button" on:click={() => fileInputBanner.click()}>Upload Banner</button>
        <input type="file" id="banner-image" accept="image/*" bind:this={fileInputBanner} on:change={handgleLeagueBannerChange} style="opacity: 0; position: absolute; left: 0; top: 0;" />
      </label>
    </div>
  
  </div>
  