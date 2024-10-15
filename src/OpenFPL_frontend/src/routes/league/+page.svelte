<script lang="ts">
    import { onMount } from "svelte";
    import { toastsError } from "$lib/stores/toasts-store";
    import Layout from "../Layout.svelte";
    import { Spinner } from "@dfinity/gix-components";
    import { storeManager } from "$lib/managers/store-manager";
    import { page } from "$app/stores";
    import type { CountryDTO, FootballLeagueDTO } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    import { countryStore } from "$lib/stores/country-store"; 
    import { leagueStore } from "$lib/stores/league-store";
    import UpdateNameModal from "$lib/components/admin/league/update-name-modal.svelte";
    import UpdateAbbreviatedNameModal from "$lib/components/admin/league/update-abbreviated-name-modal.svelte";
    import UpdateGoverningBodyModal from "$lib/components/admin/league/update-governing-body-modal.svelte";
    import UpdateGenderModal from "$lib/components/admin/league/update-gender-modal.svelte";
    import UpdateDateFormedModal from "$lib/components/admin/league/update-date-formed-modal.svelte";
    import UpdateCountryModal from "$lib/components/admin/league/update-country-modal.svelte";
    import UpdateLogoModal from "$lib/components/admin/league/update-logo-modal.svelte";
    import { userStore } from "$lib/stores/user-store";
    import EditIcon from "$lib/icons/EditIcon.svelte";
    import { getImageURL } from "$lib/utils/helpers";
    
    let isLoading = true;
    let league: FootballLeagueDTO | null = null;
    let countries: CountryDTO[] = [];
    let isAdmin = false; 

    let activeTab: string = "details";
    
    let name: string = "";
    let abbreviatedName: string = "";
    let governingBody: string = "";
    let gender = 1;
    let dateFormed: string = "";
    let countryId: number = 0;
    let logo: string = "";
  
    $: id = Number($page.url.searchParams.get("id"));
  
    onMount(async () => {
      try {
        await loadData();
      } catch (error) {
        toastsError({ msg: { text: "Error fetching club details." }, err: error });
        console.error("Error fetching club details:", error);
      } finally {
        isLoading = false;
      }
    });

    async function loadData(){
      await storeManager.syncStores();
      countries = $countryStore;

      isAdmin = await userStore.isAdmin();
      
      league = $leagueStore.find((x) => x.id == id) ?? null;
      if (league) {
        name = league.name;
        abbreviatedName = league.abbreviation;
        governingBody = league.governingBody;
        if (league.relatedGender && "Male" in league.relatedGender) {
          gender = 1;
        } else if (league.relatedGender && "Female" in league.relatedGender) {
          gender = 2;
        }
        const milliseconds = Number(league.formed) / 1_000_000; 
        const date = new Date(milliseconds);
        dateFormed = date.toISOString().split('T')[0];

        countryId = league.countryId;
        logo = getImageURL(league.logo);
      }
    };

    let showEditNameModal = false;
    let showEditAbbreviatedNameModal = false;
    let showEditGoverningBodyModal = false;
    let showEditGenderModal = false;
    let showEditDateFormedModal = false;
    let showEditCountryModal = false;
    let showEditLogoModal = false;

    function openEditModal(category: string) {
      switch(category){
        case "name":
            showEditNameModal = true;
        break;
        case "abbreviated-name":
            showEditAbbreviatedNameModal = true;
        break;
        case "governing-body":
            showEditGoverningBodyModal = true;
        break;
        case "gender":
            showEditGenderModal = true;
        break;
        case "date-formed":
            showEditDateFormedModal = true;
        break;
        case "country":
            showEditCountryModal = true;
        break;
        case "logo":
            showEditLogoModal = true;
        break;
      }
    }

    async function closeModal() {
        showEditNameModal = false;
        showEditAbbreviatedNameModal = false;
        showEditGoverningBodyModal = false;
        showEditGenderModal = false;
        showEditDateFormedModal = false;
        showEditCountryModal = false;
        showEditLogoModal = false;
        await loadData();
    }
  
    function setActiveTab(tab: string): void {
      activeTab = tab;
    }
</script>

<Layout>
  {#if isLoading}
    <Spinner />
  {:else}
    <div class="bg-panel rounded-md">
      <ul class="flex bg-light-gray border-b border-gray-700 px-2 pt-2">
        <li class={`mr-4 ${activeTab === "details" ? "active-tab" : ""}`}>
          <button class={`p-2 ${activeTab === "details" ? "text-white" : "text-gray-400"}`} on:click={() => setActiveTab("details")}>
            Details
          </button>
        </li>
        <li class={`mr-4 ${activeTab === "players" ? "active-tab" : ""}`}>
          <button class={`p-2 ${activeTab === "players" ? "text-white" : "text-gray-400"}`} on:click={() => setActiveTab("players")}>
            Players
          </button>
        </li>
        <li class={`mr-4 ${activeTab === "fixtures" ? "active-tab" : ""}`}>
          <button class={`p-2 ${activeTab === "fixtures" ? "text-white" : "text-gray-400"}`} on:click={() => setActiveTab("fixtures")}>
            Fixtures
          </button>
        </li>
      </ul>

      {#if activeTab === "details"}
        <div class="p-4 flex flex-col space-y-2">
            <div class="flex items-center justify-between">
                <div>
                  <label for="name" class="block text-gray-300">Name</label>
                  <div class="flex flex-row items-center">
                    {#if isAdmin}
                      <button on:click={() => openEditModal("logo")}>
                        <img src={getImageURL(logo)} alt="logo" class="w-8 mr-1" />
                      </button>
                    {:else}
                      <img src={getImageURL(logo)} alt="logo" class="w-4 mr-1" />
                    {/if}
                    <p class="text-gray-200">{name}</p>
                  </div>
                </div>
                {#if isAdmin}
                  <button class="ml-2 p-2 bg-blue-600 hover:bg-blue-500 rounded-full" on:click={() => openEditModal("name")}>
                    <EditIcon className="w-4 h-4 text-white" />
                  </button>
                {/if}
            </div>
    
            <div class="flex items-center justify-between">
                <div>
                    <label for="abbreviated-name" class="block text-gray-300">Abbreviated Name</label>
                    <p class="text-gray-200">{abbreviatedName}</p>
                </div>
                {#if isAdmin}
                    <button class="ml-2 p-2 bg-blue-600 hover:bg-blue-500 rounded-full" on:click={() => openEditModal("abbreviated-name")}>
                        <EditIcon className="w-4 h-4 text-white" />
                    </button>
                {/if}
            </div>

            <div class="flex items-center justify-between">
                <div>
                    <label for="governing-body" class="block text-gray-300">Governing Body</label>
                    <p class="text-gray-200">{governingBody}</p>
                </div>
                {#if isAdmin}
                    <button class="ml-2 p-2 bg-blue-600 hover:bg-blue-500 rounded-full" on:click={() => openEditModal("governing-body")}>
                        <EditIcon className="w-4 h-4 text-white" />
                    </button>
                {/if}
            </div>

            <div class="flex items-center justify-between">
                <div>
                    <label for="gender" class="block text-gray-300">Gender</label>
                    <p class="text-gray-200">{gender === 1 ? "Male" : "Female"}</p>
                </div>
                {#if isAdmin}
                    <button class="ml-2 p-2 bg-blue-600 hover:bg-blue-500 rounded-full" on:click={() => openEditModal("gender")}>
                        <EditIcon className="w-4 h-4 text-white" />
                    </button>
                {/if}
            </div>

            <div class="flex items-center justify-between">
                <div>
                    <label for="date-formed" class="block text-gray-300">Date Formed</label>
                    <p class="text-gray-200">{dateFormed}</p>
                </div>
                {#if isAdmin}
                    <button class="ml-2 p-2 bg-blue-600 hover:bg-blue-500 rounded-full" on:click={() => openEditModal("date-formed")}>
                        <EditIcon className="w-4 h-4 text-white" />
                    </button>
                {/if}
            </div>

            <div class="flex items-center justify-between">
                <div>
                    <label for="country" class="block text-gray-300">Country</label>
                    <p class="text-gray-200">{$countryStore.find((country) => country.id === countryId)?.name}</p>
                </div>
                {#if isAdmin}
                    <button class="ml-2 p-2 bg-blue-600 hover:bg-blue-500 rounded-full" on:click={() => openEditModal("country")}>
                        <EditIcon className="w-4 h-4 text-white" />
                    </button>
                {/if}
            </div>
        </div>
      {/if}
    </div>
  {/if}

  {#if showEditNameModal}
    <UpdateNameModal leagueId={id} newName={name} visible={showEditNameModal} closeModal={closeModal} cancelModal={closeModal}/>
  {/if}

  {#if showEditAbbreviatedNameModal}
    <UpdateAbbreviatedNameModal leagueId={id} newAbbreviatedName={abbreviatedName} visible={showEditAbbreviatedNameModal} closeModal={closeModal} cancelModal={closeModal} />
  {/if}

  {#if showEditGoverningBodyModal}
    <UpdateGoverningBodyModal leagueId={id} newGoverningBody={governingBody} visible={showEditGoverningBodyModal} closeModal={closeModal} cancelModal={closeModal} />
  {/if}
    
  {#if showEditGenderModal}
    <UpdateGenderModal leagueId={id} newGender={gender} visible={showEditGenderModal} closeModal={closeModal} cancelModal={closeModal} />
  {/if}
  
  {#if showEditDateFormedModal}
    <UpdateDateFormedModal leagueId={id} newDateFormed={dateFormed} visible={showEditDateFormedModal} closeModal={closeModal} cancelModal={closeModal} />
  {/if}

  {#if showEditCountryModal}
    <UpdateCountryModal leagueId={id} newCountryId={countryId} visible={showEditCountryModal} closeModal={closeModal} cancelModal={closeModal} />
  {/if}
  
  {#if showEditLogoModal}
    <UpdateLogoModal leagueId={id} newLogo={logo} visible={showEditLogoModal} closeModal={closeModal} cancelModal={closeModal} />
  {/if}

</Layout>
  