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
