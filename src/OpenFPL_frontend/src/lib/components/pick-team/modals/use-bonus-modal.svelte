<script lang="ts">
  import { onMount } from "svelte";
  import { type Writable } from "svelte/store";
  import { clubStore } from "$lib/stores/club-store";
  import { playerStore } from "$lib/stores/player-store";
  import { managerStore } from "$lib/stores/manager-store";
  import { BonusType } from "$lib/enums/BonusType";
  import { countryStore } from "$lib/stores/country-store";
  import { convertPositionToIndex } from "$lib/utils/helpers";
  import { leagueStore } from "$lib/stores/league-store";
  import type { Bonus } from "$lib/types/bonus";
  import type { TeamSelectionDTO } from "../../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

  import Modal from "$lib/components/shared/modal.svelte";
    import LocalSpinner from "$lib/components/shared/local-spinner.svelte";
    
  export let visible: boolean;
  export let fantasyTeam: Writable<TeamSelectionDTO | undefined>;
  export let bonusUsedInSession: Writable<boolean>;
  export let closeBonusModal: () => void;
  export let bonus: Bonus;
  export let updateBonuses: () => void;
  export let bonuses: Writable<Bonus[]>;

  let countries: { id: number; name: string }[];
  let selectedTeamId = 0;
  let selectedPlayerId = 0;
  let selectedCountry = "";
  let selectedCountryId = 0;
  let isSubmitting = false;

  onMount(async () => {
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
      .map((country) => ({ id: country.id, name: country.name }));

    return [...new Set(countriesOfFantasyTeamPlayers)].sort((a, b) => a.name.localeCompare(b.name));
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
      if (player && convertPositionToIndex(player.position) === 0) {
        return player.id;
      }
    }

    return 0;
  };

  async function handleUseBonus() {
    if (!$fantasyTeam) return;
    let activeGameweek = $leagueStore!.unplayedGameweek;
    const originalTeam = { ...$fantasyTeam };

    $bonuses[bonus.id - 1].usedGameweek = activeGameweek
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
            noEntryPlayerId: selectedPlayerId,
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
            teamBoostClubId: selectedTeamId,
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
            oneNationCountryId: selectedCountryId,
            oneNationCountryName: selectedCountry,
            oneNationGameweek: activeGameweek,
            playerIds: team.playerIds || new Uint16Array(11),
          };
        });
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
    
    try{
      isSubmitting = true;
      const isSaved = await managerStore.saveBonus($fantasyTeam, activeGameweek);

      if (isSaved) {
        updateBonuses();
        bonusUsedInSession.set(true);
      } else {
        fantasyTeam.set(originalTeam);
        $bonuses[bonus.id - 1].usedGameweek = 0;
      }
    } catch (error) {
      fantasyTeam.set(originalTeam);
      $bonuses[bonus.id - 1].usedGameweek = 0;
      console.error("Error saving bonus:", error);
    } finally {
      isSubmitting = false;
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
        return selectedCountryId !== 0;
      case BonusType.AUTOMATIC:
        return true;
      default:
        return false;
    }
  })();
</script>

<Modal showModal={visible} onClose={closeBonusModal} title="Use Bonus">
  <div class="p-4 mx-4">
    <img src={bonus.image} class="block w-16 mx-auto" alt={bonus.name} />
    {#if !isSubmitting}
      <div class="mt-3 text-center">
        <h3 class="default-header">{bonus.name}</h3>
        <div class="py-3 mt-2 px-7">
          <p>{bonus.description}</p>
        </div>

        {#if bonus.selectionType === BonusType.PLAYER}
          <div class="w-full my-4 border border-gray-500">
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
          <div class="w-full my-4 border border-gray-500">
            <select
              bind:value={selectedCountryId}
              on:change={(e) => {
                const selected = countries.find(c => c.id === Number((e.target as HTMLSelectElement).value));
                if (selected) {
                  selectedCountry = selected.name;
                } else {
                  selectedCountry = "";
                }
              }}
              class="w-full p-2 rounded-md fpl-dropdown"
            >
              <option value={0}>Select Country</option>
              {#each countries as country}
                <option value={country.id}>{country.name}</option>
              {/each}
            </select>
          </div>
        {/if}

        {#if bonus.selectionType === BonusType.TEAM}
          <div class="w-full my-4 border border-gray-500">
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
          class="p-4 mb-2 text-orange-700 bg-orange-100 border-l-4 border-orange-500"
          role="alert"
        >
          <p>Warning</p>
          <p>
            Your bonus will be activated and it cannot be reversed, each bonus can only be played once a season.
            Please confirm to proceed.
          </p>
        </div>

        <div class="flex items-center justify-center py-3 space-x-4">
          <button
            class="px-4 py-2 fpl-cancel-btn default-button"
            type="button"
            on:click={closeBonusModal}
          >
            Cancel
          </button>
          <button
            class={`px-4 py-2 ${
              isUseButtonEnabled ? "bg-BrandPurple" : "bg-gray-500"
            } 
            default-button bg-BrandPurple`}
            on:click={handleUseBonus}
            disabled={!isUseButtonEnabled}
          >
            Confirm
          </button>
        </div>
      </div>
    {:else}
      <div class="flex flex-col items-center justify-center">
        <LocalSpinner />
        <p class="text-xl">Saving Bonus...</p>
      </div>
    {/if}
  </div>
</Modal>
