<script lang="ts">
  import { onMount } from "svelte";
  import { type Writable } from "svelte/store";
  import { systemStore } from "$lib/stores/system-store";
  import { clubStore } from "$lib/stores/club-store";
  import { playerStore } from "$lib/stores/player-store";

  import type { Bonus } from "$lib/types/bonus";
  import type { PickTeamDTO } from "../../../../../../declarations/OpenWSL_backend/OpenWSL_backend.did";
  import { BonusType } from "$lib/enums/BonusType";
  import { Modal } from "@dfinity/gix-components";
  import { countryStore } from "$lib/stores/country-store";
    import { convertPlayerPosition } from "$lib/utils/helpers";
    import { storeManager } from "$lib/managers/store-manager";
    
  export let visible: boolean;
  export let fantasyTeam: Writable<PickTeamDTO | null>;
  export let bonusUsedInSession: Writable<boolean | null>;
  export let closeBonusModal: () => void;
  export let bonus: Bonus;
  export let updateBonuses: () => void;
  export let bonuses: Writable<Bonus[]>;

  let countries: string[];
  let selectedTeamId = 0;
  let selectedPlayerId = 0;
  let selectedCountry = "";

  onMount(async () => {
    await storeManager.syncStores();
    getUniqueCountries();
  });

  const getUniqueCountries = () => {

    if (!$countryStore || !$fantasyTeam || !$fantasyTeam.playerIds) {
      return [];
    }

    const fantasyTeamPlayerIds = new Set($fantasyTeam.playerIds);
    const countriesOfFantasyTeamPlayers = $countryStore
      .filter((country) =>
        $playerStore.some(
          (player) =>
            fantasyTeamPlayerIds.has(player.id) && player.nationality === country.id
        )
      )
      .map((country) => country.name);

    return [...new Set(countriesOfFantasyTeamPlayers)].sort();
  };


  const getPlayerNames = () => {
    return $playerStore
      .filter((p) => isPlayerInFantasyTeam(p.id))
      .map((p) => ({ id: p.id, name: `${p.firstName} ${p.lastName}` }));
  };

  const isPlayerInFantasyTeam = (playerId: number): boolean => {
    return !$fantasyTeam
      ? false
      : $fantasyTeam.playerIds && $fantasyTeam.playerIds.includes(playerId);
  };

  const getRelatedTeamNames = () => {
    const teamIds = new Set(
      $playerStore
        .filter((p) => isPlayerInFantasyTeam(p.id))
        .map((p) => p.clubId)
    );
    return $clubStore
      .filter((t) => teamIds.has(t.id))
      .map((t) => ({ id: t.id, name: t.friendlyName }));
  };

  const getGoalkeeperId = () => {
    if (!$fantasyTeam || !$fantasyTeam.playerIds) return 0;

    for (const playerId of $fantasyTeam.playerIds) {
      const player = $playerStore.find((p) => p.id === playerId);
      if (player && convertPlayerPosition(player.position) === 0) {
        return player.id;
      }
    }

    return 0;
  };

  function handleUseBonus() {
    if (!$fantasyTeam) return;
    let activeGameweek = 1;
    if($systemStore?.pickTeamGameweek){
      activeGameweek = $systemStore?.pickTeamGameweek
    }
    
    $bonuses[bonus.id - 1].usedGameweek = activeGameweek
    switch (bonus.id) {
      case 1:
        fantasyTeam.update((team) => {
          if (!team) return team;
          bonusUsedInSession.set(true);
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
          bonusUsedInSession.set(true);
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
          bonusUsedInSession.set(true);
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
          bonusUsedInSession.set(true);
          return {
            ...team,
            teamBoostClubId: selectedTeamId,
            teamBoostGameweek: activeGameweek,
            playerIds: team.playerIds || new Uint16Array(11),
          };
        });
        break;
      case 5:
        fantasyTeam.update((team) => {
          if (!team) return team;
          bonusUsedInSession.set(true);
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
          bonusUsedInSession.set(true);
          return {
            ...team,
            captainFantasticPlayerId: $fantasyTeam?.captainId ?? 0,
            captainFantasticGameweek: activeGameweek,
            playerIds: team.playerIds || new Uint16Array(11),
          };
        });
        break;
      case 7:
        fantasyTeam.update((team) => {
          if (!team) return team;
          return {
            ...team,
            prospectsGameweek: activeGameweek,
            playerIds: team.playerIds || new Uint16Array(11),
          };
        });
        break;
      case 8:
        fantasyTeam.update((team) => {
          if (!team) return team;
          return {
            ...team,
            oneNationCountry: selectedCountry,
            oneNationGameweek: activeGameweek,
            playerIds: team.playerIds || new Uint16Array(11),
          };
        });
        break;
      case 9:
        fantasyTeam.update((team) => {
          if (!team) return team;
          bonusUsedInSession.set(true);
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
          bonusUsedInSession.set(true);
          return {
            ...team,
            hatTrickHeroGameweek: activeGameweek,
            playerIds: team.playerIds || new Uint16Array(11),
          };
        });
        break;
    }
    updateBonuses();
    closeBonusModal();
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

<Modal {visible} on:nnsClose={closeBonusModal}>
  <div class="mx-4 p-4">
    <div class="flex justify-between items-center my-2">
      <h3 class="default-header">Use Bonus</h3>
      <button class="times-button" on:click={closeBonusModal}>&times;</button>
    </div>
    <img src={bonus.image} class="w-16 mx-auto block" alt={bonus.name} />
    <div class="mt-3 text-center">
      <h3 class="default-header">{bonus.name}</h3>
      <div class="mt-2 px-7 py-3">
        <p>{bonus.description}</p>
      </div>

      {#if bonus.selectionType === BonusType.PLAYER}
        <div class="w-full border border-gray-500 my-4">
          <select
            bind:value={selectedPlayerId}
            class="w-full p-2 rounded-md fpl-dropdown"
          >
            <option value={0}>Select Player</option>
            {#each playerOptions as player}
              <option value={player.id}>{player.name}</option>
            {/each}
          </select>
        </div>
      {/if}

      {#if bonus.selectionType === BonusType.COUNTRY}
        <div class="w-full border border-gray-500 my-4">
          <select
            bind:value={selectedCountry}
            class="w-full p-2 rounded-md fpl-dropdown"
          >
            <option value={0}>Select Country</option>
            {#each countries as country}
              <option value={country}>{country}</option>
            {/each}
          </select>
        </div>
      {/if}

      {#if bonus.selectionType === BonusType.TEAM}
        <div class="w-full border border-gray-500 my-4">
          <select
            bind:value={selectedTeamId}
            class="w-full p-2 rounded-md fpl-dropdown"
          >
            <option value={0}>Select Team</option>
            {#each teamOptions as team}
              <option value={team.id}>{team.name}</option>
            {/each}
          </select>
        </div>
      {/if}

      <div
        class="bg-orange-100 border-l-4 border-orange-500 text-orange-700 p-4 mb-2"
        role="alert"
      >
        <p>Warning</p>
        <p>
          Your bonus will be activated when you save your team and it cannot be
          reversed. A bonus can only be played once per season.
        </p>
      </div>

      <div class="items-center py-3 flex space-x-4">
        <button
          class="px-4 py-2 fpl-cancel-btn default-button"
          type="button"
          on:click={closeBonusModal}
        >
          Cancel
        </button>
        <button
          class={`px-4 py-2 ${
            isUseButtonEnabled ? "fpl-purple-btn" : "bg-gray-500"
          } 
          default-button fpl-purple-btn`}
          on:click={handleUseBonus}
          disabled={!isUseButtonEnabled}
        >
          Use
        </button>
      </div>
    </div>
  </div>
</Modal>
