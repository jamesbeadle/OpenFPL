<script lang="ts">
  import { onMount } from "svelte";
  import { clubStore } from "$lib/stores/club-store";
  import { playerStore } from "$lib/stores/player-store";
  import { managerStore } from "$lib/stores/manager-store";
  import { BonusType } from "$lib/enums/BonusType";
  import type { BonusType as BonusName } from "../../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import { countryStore } from "$lib/stores/country-store";
  import { convertPositionToIndex } from "$lib/utils/Helpers";
  import { leagueStore } from "$lib/stores/league-store";
  import type { Bonus } from "$lib/types/bonus";
  import type { TeamSetup } from "../../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import { authStore } from "$lib/stores/auth-store";
  import Modal from "$lib/components/shared/global/modal.svelte";
  import LocalSpinner from "$lib/components/shared/global/local-spinner.svelte";
    import { teamSetupStore } from "$lib/stores/team-setup-store";

  interface Props {
    bonusUsedInSession: boolean;
    closeBonusModal: () => void;
    bonus: Bonus;
    updateBonuses: () => void;
    bonuses: Bonus[];
  }
  let { bonusUsedInSession, closeBonusModal, bonus, updateBonuses, bonuses }: Props = $props();

  let countries: { id: number; name: string }[] = $state([]);
  let playerOptions: { id: number; name: string }[] = $state([]);
  let teamOptions: { id: number; name: string }[] = $state([]);
  let selectedTeamId = 0;
  let selectedPlayerId = 0;
  let selectedCountry = "";
  let selectedCountryId = 0;
  let isSubmitting = $state(false);
  let isUseButtonEnabled = $state(false);

  onMount(async () => {
    countries = getUniqueCountries();
    playerOptions = getPlayerNames();
    teamOptions = getRelatedTeamNames();
    isUseButtonEnabled = (() => {
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
  });

  const getUniqueCountries = () => {

    if (!$countryStore || !$teamSetupStore || !$teamSetupStore.playerIds) {
      return [];
    }

    const fantasyTeamPlayerIds = new Set($teamSetupStore.playerIds);
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
    return !$teamSetupStore
      ? false
      : $teamSetupStore.playerIds && $teamSetupStore.playerIds.includes(playerId);
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
    if (!$teamSetupStore || !$teamSetupStore.playerIds) return 0;

    for (const playerId of $teamSetupStore.playerIds) {
      const player = $playerStore.find((p) => p.id === playerId);
      if (player && convertPositionToIndex(player.position) === 0) {
        return player.id;
      }
    }

    return 0;
  };

  async function handleUseBonus() {
    if (!$teamSetupStore) return;
    let activeGameweek = $leagueStore!.unplayedGameweek;
    const originalTeam = { ...$teamSetupStore };

    bonuses[bonus.id - 1].usedGameweek = activeGameweek
    switch (bonus.id) {
      case 1:
      $teamSetupStore = {
            ...$teamSetupStore,
            goalGetterPlayerId: selectedPlayerId,
            goalGetterGameweek: activeGameweek,
            playerIds: $teamSetupStore.playerIds || new Uint16Array(11),
          }
        break;
      case 2:
      $teamSetupStore = {
          ...$teamSetupStore,
            passMasterPlayerId: selectedPlayerId,
            passMasterGameweek: activeGameweek,
            playerIds: $teamSetupStore.playerIds || new Uint16Array(11),
          };
        break;
      case 3:
      $teamSetupStore = {
          ...$teamSetupStore,
            noEntryPlayerId: selectedPlayerId,
            noEntryGameweek: activeGameweek,
            playerIds: $teamSetupStore.playerIds || new Uint16Array(11),
          };
        break;
      case 4:
      $teamSetupStore = {
          ...$teamSetupStore,
            teamBoostClubId: selectedTeamId,
            teamBoostGameweek: activeGameweek,
            playerIds: $teamSetupStore.playerIds || new Uint16Array(11),
          };
        break;
      case 5:
      $teamSetupStore = {
          ...$teamSetupStore,
            safeHandsGameweek: activeGameweek,
            safeHandsPlayerId: getGoalkeeperId(),
            playerIds: $teamSetupStore.playerIds || new Uint16Array(11),
          };
        break;
      case 6:
      $teamSetupStore = {
          ...$teamSetupStore,
            captainFantasticPlayerId: $teamSetupStore?.captainId ?? 0,
            captainFantasticGameweek: activeGameweek,
            playerIds: $teamSetupStore.playerIds || new Uint16Array(11),
          };
        break;
      case 7:
      $teamSetupStore = {
          ...$teamSetupStore,
            prospectsGameweek: activeGameweek,
            playerIds: $teamSetupStore.playerIds || new Uint16Array(11),
          };
        break;
      case 8:
      $teamSetupStore = {
          ...$teamSetupStore,
            oneNationCountryId: selectedCountryId,
            oneNationGameweek: activeGameweek,
            playerIds: $teamSetupStore.playerIds || new Uint16Array(11),
          };
        break;
      case 9:
      $teamSetupStore = {
          ...$teamSetupStore,
            braceBonusGameweek: activeGameweek,
            playerIds: $teamSetupStore.playerIds || new Uint16Array(11),
          };
        break;
      case 10:
      $teamSetupStore = {
          ...$teamSetupStore,
            hatTrickHeroGameweek: activeGameweek,
            playerIds: $teamSetupStore.playerIds || new Uint16Array(11),
          };
        break;
    }
    
    try{
      isSubmitting = true;

      const principalId = $authStore.identity?.getPrincipal().toString() ?? "Not available";
      const bonusPlayed = getBonusPlayed($teamSetupStore, activeGameweek);
      const bonusPlayerId = getBonusPlayerId($teamSetupStore, activeGameweek);
      const bonusTeamId = getBonusTeamId($teamSetupStore, activeGameweek);
      const bonusCountryId = getBonusCountryId($teamSetupStore, activeGameweek);

      const isSaved = await managerStore.saveBonus(principalId, bonusPlayed, bonusPlayerId, bonusTeamId, bonusCountryId);

      if (isSaved) {
        updateBonuses();
        bonusUsedInSession = true;
      } else {
        $teamSetupStore = originalTeam;
        bonuses[bonus.id - 1].usedGameweek = 0;
      }
    } catch (error) {
      $teamSetupStore = originalTeam;
      bonuses[bonus.id - 1].usedGameweek = 0;
      console.error("Error saving bonus:", error);
    } finally {
      isSubmitting = false;
      closeBonusModal();
    }
  }

  function getBonusPlayed(userFantasyTeam: TeamSetup, activeGameweek: number): BonusName {
    let bonusPlayed: BonusName = { NoEntry: null };

    if (userFantasyTeam.goalGetterGameweek === activeGameweek) {
      bonusPlayed = { GoalGetter: null };
    }

    if (userFantasyTeam.passMasterGameweek === activeGameweek) {
      bonusPlayed = { PassMaster: null };
    }

    if (userFantasyTeam.noEntryGameweek === activeGameweek) {
      bonusPlayed = { NoEntry: null };
    }

    if (userFantasyTeam.teamBoostGameweek === activeGameweek) {
      bonusPlayed = { TeamBoost: null };
    }

    if (userFantasyTeam.safeHandsGameweek === activeGameweek) {
      bonusPlayed = { SafeHands: null };
    }

    if (userFantasyTeam.captainFantasticGameweek === activeGameweek) {
      bonusPlayed = { CaptainFantastic: null };
    }

    if (userFantasyTeam.prospectsGameweek === activeGameweek) {
      bonusPlayed = { Prospects: null };
    }

    if (userFantasyTeam.oneNationGameweek === activeGameweek) {
      bonusPlayed = { OneNation: null };
    }

    if (userFantasyTeam.braceBonusGameweek === activeGameweek) {
      bonusPlayed = { BraceBonus: null };
    }

    if (userFantasyTeam.hatTrickHeroGameweek === activeGameweek) {
      bonusPlayed = { HatTrickHero: null };
    }

    return bonusPlayed;
  }

  function getBonusPlayerId(
    userFantasyTeam: TeamSetup,
    activeGameweek: number,
  ): number {
    let bonusPlayerId = 0;

    if (userFantasyTeam.goalGetterGameweek === activeGameweek) {
      bonusPlayerId = userFantasyTeam.goalGetterPlayerId;
    }

    if (userFantasyTeam.passMasterGameweek === activeGameweek) {
      bonusPlayerId = userFantasyTeam.passMasterPlayerId;
    }

    if (userFantasyTeam.noEntryGameweek === activeGameweek) {
      bonusPlayerId = userFantasyTeam.noEntryPlayerId;
    }

    if (userFantasyTeam.safeHandsGameweek === activeGameweek) {
      bonusPlayerId = userFantasyTeam.safeHandsPlayerId;
    }

    if (userFantasyTeam.captainFantasticGameweek === activeGameweek) {
      bonusPlayerId = userFantasyTeam.captainId;
    }

    return bonusPlayerId;
  }

  function getBonusTeamId(
    userFantasyTeam: TeamSetup,
    activeGameweek: number,
  ): number {
    let bonusTeamId = 0;

    if (userFantasyTeam.teamBoostGameweek === activeGameweek) {
      bonusTeamId = userFantasyTeam.teamBoostClubId;
    }

    return bonusTeamId;
  }

  function getBonusCountryId(
    userFantasyTeam: TeamSetup,
    activeGameweek: number,
  ): number {
    let bonusCountryId = 0;

    if (userFantasyTeam.oneNationGameweek === activeGameweek) {
      bonusCountryId = userFantasyTeam.oneNationCountryId;
    }

    return bonusCountryId;
  }

</script>

<Modal onClose={closeBonusModal} title="Use Bonus">
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
              value={selectedPlayerId}
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
              value={selectedCountryId}
              onchange={(e) => {
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
              value={selectedTeamId}
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
            class="px-4 py-2 border rounded-sm border-BrandSlateGray bg-BrandRed default-button"
            type="button"
            onclick={closeBonusModal}
          >
            Cancel
          </button>
          <button
            class={`px-4 py-2 ${
              isUseButtonEnabled ? "bg-BrandPurple" : "bg-gray-500"
            } 
            default-button bg-BrandPurple`}
            onclick={handleUseBonus}
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
