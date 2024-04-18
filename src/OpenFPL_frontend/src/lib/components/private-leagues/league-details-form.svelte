<script lang="ts">
    import { onMount } from 'svelte';
    import { writable } from 'svelte/store';
    import type { CreatePrivateLeagueDTO } from '../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did';
  
    let leagueName: string = '';
    let fileInputProfile: HTMLInputElement;
    let maxEntrants: number = 10000;
    let leaguePicture: File;
    let leaguePictureName: string = 'No file chosen';
    export let privateLeague = writable<CreatePrivateLeagueDTO | null>(null);

    const leagueNameUnique = writable(true); 
    
    async function checkLeagueNameUnique(name: string) {
      // TODO: Make a call to your backend to check if the league name is unique
      const isUnique = true; // Replace with actual backend call response
      leagueNameUnique.set(isUnique);
      if (!isUnique) {
        alert('League name already in use, please choose another.');
      }
    }
    
    function handleLeaguePictureChange(event: Event) {
      const input = event.target as HTMLInputElement;
      if (input.files && input.files[0]) {
        const file = input.files[0];
        if (file.size > 500 * 1024) {
          alert("File size exceeds 500KB");
          return;
        }
        leaguePicture = file;
        leaguePictureName = file.name;
      }
    }
      
    onMount(() => {
      // Additional initialization if needed
    });

    $: if (leagueName) {
      checkLeagueNameUnique(leagueName);
    }
  </script>
  
  <div class="container mx-auto p-4">
  
    <div class="mb-4">
      <label class="block text-sm mb-2" for="league-name">
        League Name:
      </label>
      <input type="text" bind:value={leagueName} class="shadow appearance-none border rounded w-full py-2 px-3 leading-tight focus:outline-none focus:shadow-outline" id="league-name" />
    </div>
  
    <div class="file-upload-wrapper mb-4">
      <label class="block text-sm mb-2">
        League Photo:
        <div class="text-xs">
          <span>{leaguePictureName}</span>
        </div>
        <input type="file" id="profile-image" accept="image/*" bind:this={fileInputProfile} on:change={handleLeaguePictureChange} class="file-input" />
      </label>
    </div>
  
    <div class="mb-4">
      <label class="block text-sm mb-2" for="league-name">
        Max Entrants:
      </label>
      <input type="number" min="2" max="10000" bind:value={maxEntrants} class="shadow appearance-none border rounded w-full py-2 px-3 leading-tight focus:outline-none focus:shadow-outline" id="max-entrants" />
    </div>
    
  </div>
  