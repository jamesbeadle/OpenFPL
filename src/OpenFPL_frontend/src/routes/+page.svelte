<script lang="ts">
  import { onMount } from "svelte";
  import { writable } from "svelte/store";
  import Layout from "./Layout.svelte";
  import FixturesComponent from "$lib/components/fixtures.svelte";
  import GamweekPointsComponents from "$lib/components/gameweek-points.svelte";
  import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
  import { idlFactory } from "../../../declarations/OpenFPL_backend";
  import { Actor, HttpAgent } from "@dfinity/agent";

  let activeTab: string = "fixtures";
  let managerCount = -1;
  let nextFixtureHomeTeam = null;
  let nextFixtureAwayTeam = null;
  let days = 0;
  let hours = 0;
  let minutes = 0;
  let isLoading = true;

  function createActor(options: any = null) {
    const hostOptions = {
      host:
        process.env.DFX_NETWORK === "ic"
          ? `https://${process.env.BACKEND_CANISTER_ID}.ic0.app`
          : "http://127.0.0.1:8080/?canisterId=bw4dl-smaaa-aaaaa-qaacq-cai&id=bkyz2-fmaaa-aaaaa-qaaaq-cai",
    };
    if (!options) {
      options = {
        agentOptions: hostOptions,
      };
    } else if (!options.agentOptions) {
      options.agentOptions = hostOptions;
    } else {
      options.agentOptions.host = hostOptions.host;
    }

    const agent = new HttpAgent({ ...options.agentOptions });

    // Fetch root key for certificate validation during development
    if (process.env.NODE_ENV !== "production") {
      agent.fetchRootKey().catch((err) => {
        console.warn(
          "Unable to fetch root key. Check to ensure that your local replica is running"
        );
        console.error(err);
      });
    }

    // Creates an actor with using the candid interface and the HttpAgent
    return Actor.createActor(idlFactory, {
      agent,
      canisterId: process.env.OPENFPL_BACKEND_CANISTER_ID,
      ...options?.actorOptions,
    });
  }

  const store = writable({
    loggedIn: false,
    actor: createActor(),
  });

  onMount(async () => {
    // Perform initial data fetching here
    await fetchData();
    isLoading = false;
    const timer = setInterval(() => {
      updateCountdowns();
    }, 60 * 1000);

    return () => {
      clearInterval(timer);
    };
  });

  const fetchData = async () => {
    // Your data fetching logic here
    try {
      const managerCountData = await $store.actor.getTotalManagers();
      managerCount = Number(managerCountData);
    } catch (error) {
      console.log(error);
    }
    // ... other data fetching logic
  };

  const updateCountdowns = () => {
    // Your countdown updating logic here
  };

  function setActiveTab(tab: string): void {
    activeTab = tab;
  }
</script>

<Layout>
  <div class="p-1">
    <div class="flex flex-col md:flex-row">
      <div
        class="flex justify-start items-center text-white space-x-4 flex-grow m-1 bg-panel p-4 rounded-md border border-gray-500"
      >
        <div class="flex-grow">
          <p class="text-gray-300 text-xs">Gameweek</p>
          <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">12</p>
          <p class="text-gray-300 text-xs">2023/24</p>
        </div>
        <div
          class="flex-shrink-0 w-px bg-gray-400 self-stretch"
          style="min-width: 2px; min-height: 50px;"
        />
        <div class="flex-grow">
          <p class="text-gray-300 text-xs">Managers</p>
          <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">
            {managerCount}
          </p>
          <p class="text-gray-300 text-xs">Total</p>
        </div>
        <div
          class="flex-shrink-0 w-px bg-gray-400 self-stretch"
          style="min-width: 2px; min-height: 50px;"
        />
        <div class="flex-grow">
          <p class="text-gray-300 text-xs">Weekly Prize Pool</p>
          <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">0</p>
          <p class="text-gray-300 text-xs">$FPL</p>
        </div>
      </div>
      <div
        class="flex flex-col md:flex-row justify-start md:items-center text-white space-x-0 md:space-x-4 flex-grow m-1 bg-panel p-4 rounded-md border border-gray-500"
      >
        <div class="flex-grow mb-4 md:mb-0">
          <p class="text-gray-300 text-xs">Next Game:</p>
          <div class="flex justify-center mb-2 mt-2">
            <div class="flex justify-center items-center">
              <div class="w-10 ml-4 mr-4">
                <BadgeIcon
                  primaryColour="#000000"
                  secondaryColour="#f3f3f3"
                  thirdColour="#211223"
                />
              </div>
              <div class="w-v ml-1 mr-1 flex justify-center">
                <p class="text-xs mt-2 mb-2 font-bold">v</p>
              </div>
              <div class="w-10 ml-4">
                <BadgeIcon
                  primaryColour="#000000"
                  secondaryColour="#f3f3f3"
                  thirdColour="#211223"
                />
              </div>
            </div>
          </div>
          <div class="flex justify-center">
            <div class="w-10 ml-4 mr-4">
              <p class="text-gray-300 text-xs text-center">NEW</p>
            </div>
            <div class="w-v ml-1 mr-1" />
            <div class="w-10 ml-4">
              <p class="text-gray-300 text-xs text-center">ARS</p>
            </div>
          </div>
        </div>
        <div
          class="h-px bg-gray-400 w-full md:w-px md:h-full md:self-stretch"
          style="min-height: 2px; min-width: 2px;"
        />

        <div class="flex-grow mb-4 md:mb-0">
          <p class="text-gray-300 text-xs mt-4 md:mt-0">Kick Off:</p>
          <div class="flex">
            <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">
              00<span class="text-gray-300 text-xs ml-1">d</span> : 18<span
                class="text-gray-300 text-xs ml-1">h</span
              >
              : 55<span class="text-gray-300 text-xs ml-1">m</span>
            </p>
          </div>
          <p class="text-gray-300 text-xs">Saturday November 11th, 2024</p>
        </div>
        <div
          class="h-px bg-gray-400 w-full md:w-px md:h-full md:self-stretch"
          style="min-height: 2px; min-width: 2px;"
        />
        <div class="flex-grow">
          <p class="text-gray-300 text-xs mt-4 md:mt-0">GW 11 High Score</p>
          <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">
            Santi
          </p>
          <p class="text-gray-300 text-xs">250 points</p>
        </div>
      </div>
    </div>
  </div>

  <div class="bg-panel p-4 m-1 bg-panel p-4 rounded-md border border-gray-500">
    <ul class="flex">
      <li class="mr-4">
        <button
          class={`p-2 ${
            activeTab === "fixtures" ? "text-white" : "text-gray-400"
          }`}
          on:click={() => setActiveTab("fixtures")}
        >
          Fixtures
        </button>
      </li>
      <li class="mr-4">
        <button
          class={`p-2 ${
            activeTab === "points" ? "text-white" : "text-gray-400"
          }`}
          on:click={() => setActiveTab("points")}
        >
          Gameweek Points
        </button>
      </li>
    </ul>

    {#if activeTab === "fixtures"}
      <FixturesComponent />
    {:else if activeTab === "points"}
      <GamweekPointsComponents />
    {/if}
  </div>
</Layout>

<style>
  .bg-panel {
    background-color: rgba(46, 50, 58, 0.9);
  }

  .circle-badge-container {
    display: flex;
    flex-direction: column;
    align-items: center;
  }

  .circle-badge-icon {
    align-self: center;
  }

  .w-v {
    width: 20px;
  }
</style>
