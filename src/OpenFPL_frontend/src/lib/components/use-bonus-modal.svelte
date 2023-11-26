<script lang="ts">
  import { writable, get } from 'svelte/store';
  import type { Bonus } from "$lib/types/Bonus";
  import type { FantasyTeam, Team } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import type { PlayerDTO } from '../../../../declarations/player_canister/player_canister.did';
  import { BonusType } from "$lib/enums/BonusType";

  export let fantasyTeam = writable<FantasyTeam | null>(null);
  export let players: PlayerDTO[];
  export let teams: Team[];
  export let activeGameweek: number;
  let countries: string[];
  let selectedTeamId = 0;
  let selectedPlayerId = 0;
  let selectedCountry = '';

  export let showModal: boolean;
  export let closeBonusModal: () => void;
  export let bonus: Bonus = {
    id: 0,
    name: "",
    description: "",
    image: "",
    selectionType: 0,
  };

  const getUniqueCountries = () => {
    const allCountries = players.map(p => p.nationality);
    return [...new Set(allCountries)].sort();
  };
  
  const getPlayerNames = () => {
    return players.map(p => ({ id: p.id, name: `${p.firstName} ${p.lastName}` }));
  };
  
  const getTeamNames = () => {
    return teams.map(t => ({ id: t.id, name: t.friendlyName }));
  };

  const getGoalkeeperId = () => {
    const team = get(fantasyTeam);
    if (!team || !team.playerIds) return 0;

    for (const playerId of team.playerIds) {
      const player = players.find(p => p.id === playerId);
      if (player && player.position === 0) {
        return player.id;
      }
    }

    return 0;
  };

  function handleUseBonus() {
    const currentFantasyTeam = get(fantasyTeam);
    if (!currentFantasyTeam) return;

    switch (bonus.id) {
      case 1:
        fantasyTeam.update(team => {
          if (!team) return team;
          return {
            ...team,
            goalGetterPlayerId: selectedPlayerId,
            goalGetterGameweek: activeGameweek,
            playerIds: team.playerIds || new Uint16Array(11)
          };
        });
        break;
      case 2:
        fantasyTeam.update(team => {
            if (!team) return team;
            return {
              ...team,
              passMasterPlayerId: selectedPlayerId,
              passMasterGameweek: activeGameweek,
              playerIds: team.playerIds || new Uint16Array(11)
            };
          });
        break;
      case 3:
        fantasyTeam.update(team => {
            if (!team) return team;
            return {
              ...team,
              noEntryPlayerId: selectedTeamId,
              noEntryGameweek: activeGameweek,
              playerIds: team.playerIds || new Uint16Array(11)
            };
        });
        break;
      case 4:
        fantasyTeam.update(team => {
          if (!team) return team;
          return {
            ...team,
            teamBoostTeamId: selectedTeamId,
            teamBoostGameweek: activeGameweek,
            playerIds: team.playerIds || new Uint16Array(11)
          };
        });
        break;
      case 5:
        fantasyTeam.update(team => {
          if (!team) return team;
          return {
            ...team,
            safeHandsGameweek: activeGameweek,
            safeHandsPlayerId: getGoalkeeperId(),
            playerIds: team.playerIds || new Uint16Array(11)
          };
        });
        break;
      case 6:
        fantasyTeam.update(team => {
          if (!team) return team;
          return {
            ...team,
            captainFantasticPlayerId: $fantasyTeam?.captainId ?? 0,
            captainFantasticGameweek: activeGameweek,
            playerIds: team.playerIds || new Uint16Array(11)
          };
        });
        break;
      case 7:
        /* Coming Soon
        fantasyTeam.update(team => {
          if (!team) return team;
          return {
            ...team,
            prospectsGameweek: activeGameweek,
            playerIds: team.playerIds || new Uint16Array(11)
          };
        });
        */
        break;
      case 8:
        /* Coming Soon
        fantasyTeam.update(team => {
          if (!team) return team;
          return {
            ...team,
            countrymenCountry: selectedCountry,
            countrymenGameweek: activeGameweek,
            playerIds: team.playerIds || new Uint16Array(11)
          };
        });
        */
        break;
      case 9:
        fantasyTeam.update(team => {
          if (!team) return team;
          return {
            ...team,
            braceBonusGameweek: activeGameweek,
            playerIds: team.playerIds || new Uint16Array(11)
          };
        });
        break;
      case 10:
        fantasyTeam.update(team => {
          if (!team) return team;
          return {
            ...team,
            hatTrickHeroGameweek: activeGameweek,
            playerIds: team.playerIds || new Uint16Array(11)
          };
        });
        break;
    }

    closeBonusModal();
  }

  $: countries = getUniqueCountries();
  $: playerOptions = getPlayerNames();
  $: teamOptions = getTeamNames();
</script>

<style>
  .modal-backdrop {
    z-index: 1000;
  }
</style>

{#if showModal}
  <div
    class="fixed inset-0 bg-gray-900 bg-opacity-80 overflow-y-auto h-full w-full modal-backdrop"
    on:click={closeBonusModal}
    on:keydown={closeBonusModal}
  >
    <div
      class="relative top-20 mx-auto p-5 border border-gray-700 w-96 shadow-lg rounded-md bg-panel text-white"
    >
      <img src={bonus.image} class="w-16 mx-auto block" alt={bonus.name} />
      <div class="mt-3 text-center">
        <h3 class="text-lg leading-6 font-medium">
          {bonus.name}
        </h3>
        <div class="mt-2 px-7 py-3">
          <p class="text-sm">
            {bonus.description}
          </p>
        </div>


        {#if bonus.selectionType === BonusType.PLAYER}
          <select bind:value={selectedPlayerId} class="w-full p-2 rounded-md">
            {#each playerOptions as player}
              <option value={player.id}>{player.name}</option>
            {/each}
          </select>
        {/if}

        {#if bonus.selectionType === BonusType.COUNTRY}
          <select bind:value={selectedCountry} class="w-full p-2 rounded-md">
            {#each countries as country}
              <option value={country}>{country}</option>
            {/each}
          </select>
        {/if}

        {#if bonus.selectionType === BonusType.TEAM}
          <select bind:value={selectedTeamId} class="w-full p-2 rounded-md">
            {#each teamOptions as team}
              <option value={team.id}>{team.name}</option>
            {/each}
          </select>
        {/if}
        
        <div class="flex items-center bg-blue-500 text-white text-sm font-bold px-4 py-3" role="alert">
          <svg class="fill-current w-4 h-4 mr-2" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20">
            <path d="M12.432 0c1.34 0 2.01.912 2.01 1.957 0 1.305-1.164 2.512-2.679 2.512-1.269 0-2.009-.75-1.974-1.99C9.789 1.436 10.67 0 12.432 0zM8.309 20c-1.058 0-1.833-.652-1.093-3.524l1.214-5.092c.211-.814.246-1.141 0-1.141-.317 0-1.689.562-2.502 1.117l-.528-.88c2.572-2.186 5.531-3.467 6.801-3.467 1.057 0 1.233 1.273.705 3.23l-1.391 5.352c-.246.945-.141 1.271.106 1.271.317 0 1.357-.392 2.379-1.207l.6.814C12.098 19.02 9.365 20 8.309 20z"/></svg>
          <p>Your bonus will be activated when you save your team and it cannot be reversed. A bonus can only be played once per season.</p>
        </div>

        <div class="items-center px-4 py-3 flex space-x-4">
          <button class="px-4 py-2 fpl-cancel-btn text-white text-base font-medium rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300"
            on:click={closeBonusModal}>
            Cancel
          </button>
          <button class="px-4 py-2 fpl-purple-btn text-white text-base font-medium rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300"
            on:click={handleUseBonus}>
            Use
          </button>
        </div>
      </div>
    </div>
  </div>
{/if}
