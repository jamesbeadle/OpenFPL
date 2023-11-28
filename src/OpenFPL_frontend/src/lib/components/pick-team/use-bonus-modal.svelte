<script lang="ts">
  import { writable, get } from "svelte/store";
  import type { Bonus } from "$lib/types/Bonus";
  import type { FantasyTeam, Team } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import type { PlayerDTO } from "../../../../../declarations/player_canister/player_canister.did";
  import { BonusType } from "$lib/enums/BonusType";

  export let fantasyTeam = writable<FantasyTeam | null>(null);
  export let players: PlayerDTO[];
  export let teams: Team[];
  export let activeGameweek: number;
  export let showModal: boolean;
  export let closeBonusModal: () => void;
  export let bonus: Bonus = {
    id: 0,
    name: "",
    description: "",
    image: "",
    selectionType: 0,
  };

  let countries: string[];
  let selectedTeamId = 0;
  let selectedPlayerId = 0;
  let selectedCountry = "";

  const getUniqueCountries = () => {
    const team = get(fantasyTeam);
    if (!team || !team.playerIds) {
      return [];
    }

    const fantasyTeamPlayerIds = new Set(team.playerIds);
    const countriesOfFantasyTeamPlayers = players
      .filter((player) => fantasyTeamPlayerIds.has(player.id))
      .map((player) => player.nationality);

    return [...new Set(countriesOfFantasyTeamPlayers)].sort();
  };

  const getPlayerNames = () => {
    return players
      .filter((p) => isPlayerInFantasyTeam(p.id))
      .map((p) => ({ id: p.id, name: `${p.firstName} ${p.lastName}` }));
  };

  const isPlayerInFantasyTeam = (playerId: number): boolean => {
    const team = get(fantasyTeam);
    return !team ? false : team.playerIds && team.playerIds.includes(playerId);
  };

  const getRelatedTeamNames = () => {
    const teamIds = new Set(
      players.filter((p) => isPlayerInFantasyTeam(p.id)).map((p) => p.teamId)
    );
    return teams
      .filter((t) => teamIds.has(t.id))
      .map((t) => ({ id: t.id, name: t.friendlyName }));
  };

  const getGoalkeeperId = () => {
    const team = get(fantasyTeam);
    if (!team || !team.playerIds) return 0;

    for (const playerId of team.playerIds) {
      const player = players.find((p) => p.id === playerId);
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
        fantasyTeam.update((team) => {
          if (!team) return team;
          return {
            ...team,
            goalGetterPlayerId: selectedPlayerId,
            goalGetterGameweek: activeGameweek,
            playerIds: team.playerIds || new Uint16Array(11),
          };
        });
        break;
      case 2:
        fantasyTeam.update((team) => {
          if (!team) return team;
          return {
            ...team,
            passMasterPlayerId: selectedPlayerId,
            passMasterGameweek: activeGameweek,
            playerIds: team.playerIds || new Uint16Array(11),
          };
        });
        break;
      case 3:
        fantasyTeam.update((team) => {
          if (!team) return team;
          return {
            ...team,
            noEntryPlayerId: selectedTeamId,
            noEntryGameweek: activeGameweek,
            playerIds: team.playerIds || new Uint16Array(11),
          };
        });
        break;
      case 4:
        fantasyTeam.update((team) => {
          if (!team) return team;
          return {
            ...team,
            teamBoostTeamId: selectedTeamId,
            teamBoostGameweek: activeGameweek,
            playerIds: team.playerIds || new Uint16Array(11),
          };
        });
        break;
      case 5:
        fantasyTeam.update((team) => {
          if (!team) return team;
          return {
            ...team,
            safeHandsGameweek: activeGameweek,
            safeHandsPlayerId: getGoalkeeperId(),
            playerIds: team.playerIds || new Uint16Array(11),
          };
        });
        break;
      case 6:
        fantasyTeam.update((team) => {
          if (!team) return team;
          return {
            ...team,
            captainFantasticPlayerId: $fantasyTeam?.captainId ?? 0,
            captainFantasticGameweek: activeGameweek,
            playerIds: team.playerIds || new Uint16Array(11),
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
        fantasyTeam.update((team) => {
          if (!team) return team;
          return {
            ...team,
            braceBonusGameweek: activeGameweek,
            playerIds: team.playerIds || new Uint16Array(11),
          };
        });
        break;
      case 10:
        fantasyTeam.update((team) => {
          if (!team) return team;
          return {
            ...team,
            hatTrickHeroGameweek: activeGameweek,
            playerIds: team.playerIds || new Uint16Array(11),
          };
        });
        break;
    }

    closeBonusModal();
  }

  function handleKeydown(event: KeyboardEvent): void {
    if (!(event.target instanceof HTMLInputElement) && event.key === "Escape") {
      closeBonusModal();
    }
  }

  $: countries = getUniqueCountries();
  $: playerOptions = getPlayerNames();
  $: teamOptions = getRelatedTeamNames();
  $: isUseButtonEnabled = (() => {
    switch (bonus.selectionType) {
      case BonusType.PLAYER:
        return selectedPlayerId !== 0;
      case BonusType.TEAM:
        return selectedTeamId !== 0;
      case BonusType.COUNTRY:
        return selectedCountry !== "";
      default:
        return true;
    }
  })();
</script>

{#if showModal}
  <div
    class="fixed inset-0 bg-gray-900 bg-opacity-80 overflow-y-auto h-full w-full modal-backdrop" on:click={closeBonusModal} on:keydown={handleKeydown}>
    <div class="relative top-20 mx-auto p-5 border border-gray-700 w-96 shadow-lg rounded-md bg-panel text-white" on:click|stopPropagation on:keydown={handleKeydown}>
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
          <div class="w-full border border-gray-500 my-4">
            <select bind:value={selectedPlayerId} class="w-full p-2 rounded-md fpl-dropdown">
              <option value={0}>Select Player</option>
              {#each playerOptions as player}
                <option value={player.id}>{player.name}</option>
              {/each}
            </select>
          </div>
        {/if}

        {#if bonus.selectionType === BonusType.COUNTRY}
          <div class="w-full border border-gray-500 my-4">
            <select bind:value={selectedCountry} class="w-full p-2 rounded-md fpl-dropdown">
              <option value={0}>Select Country</option>
              {#each countries as country}
                <option value={country}>{country}</option>
              {/each}
            </select>
          </div>
        {/if}

        {#if bonus.selectionType === BonusType.TEAM}
          <div class="w-full border border-gray-500 my-4">
            <select bind:value={selectedTeamId} class="w-full p-2 rounded-md fpl-dropdown">
              <option value={0}>Select Team</option>
              {#each teamOptions as team}
                <option value={team.id}>{team.name}</option>
              {/each}
            </select>
          </div>
        {/if}

        <div class="bg-orange-100 border-l-4 border-orange-500 text-orange-700 p-4 mb-2" role="alert">
          <p class="font-bold text-sm">Warning</p>
          <p class="font-bold text-xs">
            Your bonus will be activated when you save your team and it cannot
            be reversed. A bonus can only be played once per season.
          </p>
        </div>

        <div class="items-center py-3 flex space-x-4">
          <button class="px-4 py-2 fpl-cancel-btn text-white text-base font-medium rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300"
          on:click={closeBonusModal}>
            Cancel
          </button>
          <button class={`px-4 py-2 ${ isUseButtonEnabled ? "fpl-purple-btn" : "bg-gray-500" } text-white text-base font-medium rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300`}
            on:click={handleUseBonus} disabled={!isUseButtonEnabled}>
            Use
          </button>
        </div>
      </div>
    </div>
  </div>
{/if}

<style>
  .modal-backdrop {
    z-index: 1000;
  }
</style>
