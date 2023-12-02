import { c as create_ssr_component, o as onDestroy, b as each, d as add_attribute, e as escape, v as validate_component, n as null_to_empty } from "../../chunks/index2.js";
import { L as Layout } from "../../chunks/Layout.js";
import "@dfinity/auth-client";
import "@dfinity/utils";
import "../../chunks/manager-store.js";
import { s as systemStore, A as ActorFactory, i as idlFactory, r as replacer, f as formatUnixTimeToTime } from "../../chunks/team-store.js";
import { w as writable } from "../../chunks/index.js";
import "@dfinity/agent";
import "../../chunks/fixture-store.js";
import { B as BadgeIcon } from "../../chunks/BadgeIcon.js";
import "../../chunks/player-store.js";
function createLeaderboardStore() {
  const { subscribe, set } = writable(null);
  const itemsPerPage = 25;
  let systemState;
  systemStore.subscribe((value) => {
    systemState = value;
  });
  let actor = ActorFactory.createActor(
    idlFactory,
    { "OPENFPL_BACKEND_CANISTER_ID": "bboqb-jiaaa-aaaal-qb6ea-cai", "OPENFPL_FRONTEND_CANISTER_ID": "bgpwv-eqaaa-aaaal-qb6eq-cai", "PLAYER_CANISTER_CANISTER_ID": "pec6o-uqaaa-aaaal-qb7eq-cai", "TOKEN_CANISTER_CANISTER_ID": "hwd4h-eyaaa-aaaal-qb6ra-cai", "DFX_NETWORK": "ic" }.OPENFPL_BACKEND_CANISTER_ID
  );
  async function syncWeeklyLeaderboard() {
    let category = "weekly_leaderboard";
    const newHashValues = await actor.getDataHashes();
    let liveHash = newHashValues.find((x) => x.category === category) ?? null;
    const localHash = localStorage.getItem(category);
    if (liveHash?.hash != localHash) {
      let updatedLeaderboardData = await actor.getWeeklyLeaderboardCache(
        systemState?.activeSeason.id,
        systemState?.focusGameweek
      );
      localStorage.setItem(
        "weekly_leaderboard_data",
        JSON.stringify(updatedLeaderboardData, replacer)
      );
      localStorage.setItem(category, liveHash?.hash ?? "");
    }
  }
  async function syncMonthlyLeaderboards() {
    let category = "monthly_leaderboards";
    const newHashValues = await actor.getDataHashes();
    let liveHash = newHashValues.find((x) => x.category === category) ?? null;
    const localHash = localStorage.getItem(category);
    if (liveHash?.hash != localHash) {
      let updatedLeaderboardData = await actor.getClubLeaderboardsCache(
        systemState?.activeSeason.id,
        systemState?.activeMonth
      );
      localStorage.setItem(
        "monthly_leaderboard_data",
        JSON.stringify(updatedLeaderboardData, replacer)
      );
      localStorage.setItem(category, liveHash?.hash ?? "");
    }
  }
  async function syncSeasonLeaderboard() {
    let category = "season_leaderboard";
    const newHashValues = await actor.getDataHashes();
    let liveHash = newHashValues.find((x) => x.category === category) ?? null;
    const localHash = localStorage.getItem(category);
    if (liveHash?.hash != localHash) {
      let updatedLeaderboardData = await actor.getSeasonLeaderboardCache(
        systemState?.activeSeason.id
      );
      localStorage.setItem(
        "season_leaderboard_data",
        JSON.stringify(updatedLeaderboardData, replacer)
      );
      localStorage.setItem(category, liveHash?.hash ?? "");
    }
  }
  async function getWeeklyLeaderboard() {
    const cachedWeeklyLeaderboardData = localStorage.getItem(
      "weekly_leaderboard_data"
    );
    let cachedWeeklyLeaderboard;
    try {
      cachedWeeklyLeaderboard = JSON.parse(
        cachedWeeklyLeaderboardData || "{entries: [], gameweek: 0, seasonId: 0, totalEntries: 0n }"
      );
    } catch (e) {
      cachedWeeklyLeaderboard = {
        entries: [],
        gameweek: 0,
        seasonId: 0,
        totalEntries: 0n
      };
    }
    return cachedWeeklyLeaderboard;
  }
  async function getWeeklyLeaderboardPage(gameweek, currentPage) {
    const limit = itemsPerPage;
    const offset = (currentPage - 1) * limit;
    if (currentPage <= 4) {
      const cachedData = localStorage.getItem("weekly_leaderboard_data");
      if (cachedData) {
        let cachedLeaderboard = JSON.parse(cachedData);
        return {
          entries: cachedLeaderboard.entries.slice(offset, offset + limit),
          gameweek: cachedLeaderboard.gameweek,
          seasonId: cachedLeaderboard.seasonId,
          totalEntries: cachedLeaderboard.totalEntries
        };
      }
    }
    let leaderboardData = await actor.getWeeklyLeaderboard(
      systemState?.activeSeason.id,
      gameweek,
      limit,
      offset
    );
    return leaderboardData;
  }
  async function getMonthlyLeaderboard(clubId, month, currentPage) {
    const limit = itemsPerPage;
    const offset = (currentPage - 1) * limit;
    if (currentPage <= 4) {
      const cachedData = localStorage.getItem("monthly_leaderboard_data");
      if (cachedData) {
        let cachedLeaderboards = JSON.parse(cachedData);
        let clubLeaderboard = cachedLeaderboards.find(
          (x) => x.clubId === clubId
        );
        if (clubLeaderboard) {
          return {
            ...clubLeaderboard,
            entries: clubLeaderboard.entries.slice(offset, offset + limit)
          };
        }
      }
    }
    let leaderboardData = await actor.getClubLeaderboard(
      systemState?.activeSeason.id,
      month,
      clubId,
      limit,
      offset
    );
    return leaderboardData;
  }
  async function getSeasonLeaderboardPage(currentPage) {
    const limit = itemsPerPage;
    const offset = (currentPage - 1) * limit;
    if (currentPage <= 4) {
      const cachedData = localStorage.getItem("season_leaderboard_data");
      if (cachedData) {
        let cachedLeaderboard = JSON.parse(cachedData);
        return {
          ...cachedLeaderboard,
          entries: cachedLeaderboard.entries.slice(offset, offset + limit)
        };
      }
    }
    let leaderboardData = await actor.getSeasonLeaderboard(
      systemState?.activeSeason.id,
      limit,
      offset
    );
    return leaderboardData;
  }
  async function getLeadingWeeklyTeam() {
    let weeklyLeaderboard = await getWeeklyLeaderboard();
    return weeklyLeaderboard.entries[0];
  }
  return {
    subscribe,
    syncWeeklyLeaderboard,
    syncMonthlyLeaderboards,
    syncSeasonLeaderboard,
    getWeeklyLeaderboard,
    getWeeklyLeaderboardPage,
    getMonthlyLeaderboard,
    getSeasonLeaderboardPage,
    getLeadingWeeklyTeam
  };
}
createLeaderboardStore();
const Fixtures = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let filteredFixtures;
  let groupedFixtures;
  let fixturesWithTeams = [];
  let selectedGameweek = 1;
  let gameweeks = Array.from({ length: 38 }, (_, i) => i + 1);
  onDestroy(() => {
  });
  filteredFixtures = fixturesWithTeams.filter(({ fixture }) => fixture.gameweek === selectedGameweek);
  groupedFixtures = filteredFixtures.reduce(
    (acc, fixtureWithTeams) => {
      const date = new Date(Number(fixtureWithTeams.fixture.kickOff) / 1e6);
      const dateFormatter = new Intl.DateTimeFormat(
        "en-GB",
        {
          weekday: "long",
          day: "numeric",
          month: "long",
          year: "numeric"
        }
      );
      const dateKey = dateFormatter.format(date);
      if (!acc[dateKey]) {
        acc[dateKey] = [];
      }
      acc[dateKey].push(fixtureWithTeams);
      return acc;
    },
    {}
  );
  return `<div class="container-fluid mt-4 mb-4"><div class="flex flex-col space-y-4"><div class="flex flex-col sm:flex-row gap-4 sm:gap-8"><div class="flex items-center space-x-2 ml-4"><button class="text-base sm:text-xs md:text-base rounded fpl-button px-3 sm:px-2 px-3 py-1" ${"disabled"}>&lt;
        </button>

        <select class="p-2 fpl-dropdown text-xs md:text-base text-center mx-0 md:mx-2 min-w-[150px] sm:min-w-[100px]">${each(gameweeks, (gameweek) => {
    return `<option${add_attribute("value", gameweek, 0)}>Gameweek ${escape(gameweek)}</option>`;
  })}</select>

        <button class="text-base sm:text-xs md:text-base rounded fpl-button px-3 sm:px-2 px-3 py-1 ml-1" ${""}>&gt;
        </button></div></div>
    <div>${each(Object.entries(groupedFixtures), ([date, fixtures]) => {
    return `<div><div class="flex items-center justify-between border border-gray-700 py-4 bg-light-gray"><h2 class="date-header ml-4 text-xs md:text-base">${escape(date)}</h2></div>
          ${each(fixtures, ({ fixture, homeTeam, awayTeam }) => {
      return `<div${add_attribute("class", `flex items-center justify-between py-2 border-b border-gray-700  ${fixture.status === 0 ? "text-gray-400" : "text-white"}`, 0)}><div class="flex items-center w-1/2 ml-4"><div class="flex w-1/2 space-x-4 justify-center"><div class="w-10 items-center justify-center"><a${add_attribute("href", `/club?id=${fixture.homeTeamId}`, 0)}>${validate_component(BadgeIcon, "BadgeIcon").$$render(
        $$result,
        {
          primaryColour: homeTeam ? homeTeam.primaryColourHex : "",
          secondaryColour: homeTeam ? homeTeam.secondaryColourHex : "",
          thirdColour: homeTeam ? homeTeam.thirdColourHex : ""
        },
        {},
        {}
      )}
                    </a></div>
                  <span class="font-bold text-lg">v</span>
                  <div class="w-10 items-center justify-center"><a${add_attribute("href", `/club?id=${fixture.awayTeamId}`, 0)}>${validate_component(BadgeIcon, "BadgeIcon").$$render(
        $$result,
        {
          primaryColour: awayTeam ? awayTeam.primaryColourHex : "",
          secondaryColour: awayTeam ? awayTeam.secondaryColourHex : "",
          thirdColour: awayTeam ? awayTeam.thirdColourHex : ""
        },
        {},
        {}
      )}</a>
                  </div></div>
                <div class="flex w-1/2 lg:justify-center"><span class="text-sm md:text-lg ml-4 md:ml-0 text-left">${escape(formatUnixTimeToTime(Number(fixture.kickOff)))}</span>
                </div></div>
              <div class="flex items-center space-x-10 w-1/2 lg:justify-center"><div class="flex flex-col min-w-[200px] lg:min-w-[120px] lg:min-w-[200px] text-xs md:text-base"><a${add_attribute("href", `/club?id=${fixture.homeTeamId}`, 0)}>${escape(homeTeam ? homeTeam.friendlyName : "")}</a>
                  <a${add_attribute("href", `/club?id=${fixture.awayTeamId}`, 0)}>${escape(awayTeam ? awayTeam.friendlyName : "")}</a></div>
                <div class="flex flex-col min-w-[200px] lg:min-w-[120px] lg:min-w-[200px] text-xs md:text-base"><span>${escape(fixture.status === 0 ? "-" : fixture.homeGoals)}</span>
                  <span>${escape(fixture.status === 0 ? "-" : fixture.awayGoals)}</span>
                </div></div>
            </div>`;
    })}
        </div>`;
  })}</div></div></div>`;
});
const _page_svelte_svelte_type_style_lang = "";
const css = {
  code: ".w-v.svelte-18fkfyi{width:20px}",
  map: null
};
const Page = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let activeGameweek = -1;
  let activeSeason = "-";
  let managerCount = -1;
  let countdownDays = "00";
  let countdownHours = "00";
  let countdownMinutes = "00";
  let nextFixtureDate = "-";
  let nextFixtureTime = "-";
  let focusGameweek = -1;
  $$result.css.add(css);
  return `${validate_component(Layout, "Layout").$$render($$result, {}, {}, {
    default: () => {
      return `<div class="m-4"><div class="flex flex-col lg:flex-row"><div class="flex justify-start items-center text-white space-x-4 flex-grow m-4 bg-panel p-4 rounded-md"><div class="flex-grow"><p class="text-gray-300 text-xs">Gameweek</p>
          <p class="text-2xl sm:text-3xl lg:text-4xl mt-2 mb-2 font-bold">${escape(activeGameweek)}</p>
          <p class="text-gray-300 text-xs">${escape(activeSeason)}</p></div>
        <div class="flex-shrink-0 w-px bg-gray-400 self-stretch" style="min-width: 2px; min-height: 50px;"></div>
        <div class="flex-grow"><p class="text-gray-300 text-xs">Managers</p>
          <p class="text-2xl sm:text-3xl lg:text-4xl mt-2 mb-2 font-bold">${escape(managerCount)}</p>
          <p class="text-gray-300 text-xs">Total</p></div>
        <div class="flex-shrink-0 w-px bg-gray-400 self-stretch" style="min-width: 2px; min-height: 50px;"></div>
        <div class="flex-grow"><p class="text-gray-300 text-xs">Weekly Prize Pool</p>
          <p class="text-2xl sm:text-3xl lg:text-4xl mt-2 mb-2 font-bold">0</p>
          <p class="text-gray-300 text-xs">$FPL</p></div></div>
      <div class="flex flex-col lg:flex-row justify-start lg:items-center text-white space-x-0 lg:space-x-4 flex-grow m-4 bg-panel p-4 rounded-md"><div class="flex-grow mb-4 lg:mb-0"><p class="text-gray-300 text-xs">Next Game:</p>
          <div class="flex justify-center mb-2 mt-2"><div class="flex justify-center items-center"><div class="w-10 ml-4 mr-4"><a${add_attribute("href", `/club?id=${-1}`, 0)}>${validate_component(BadgeIcon, "BadgeIcon").$$render(
        $$result,
        {
          primaryColour: "",
          secondaryColour: "",
          thirdColour: ""
        },
        {},
        {}
      )}</a></div>
              <div class="w-v ml-1 mr-1 flex justify-center svelte-18fkfyi"><p class="text-xs mt-2 mb-2 font-bold">v</p></div>
              <div class="w-10 ml-4"><a${add_attribute("href", `/club?id=${-1}`, 0)}>${validate_component(BadgeIcon, "BadgeIcon").$$render(
        $$result,
        {
          primaryColour: "",
          secondaryColour: "",
          thirdColour: ""
        },
        {},
        {}
      )}</a></div></div></div>
          <div class="flex justify-center"><div class="w-10 ml-4 mr-4"><p class="text-gray-300 text-xs text-center"><a class="text-gray-300 text-xs text-center"${add_attribute("href", `/club?id=${-1}`, 0)}>${escape("")}</a></p></div>
            <div class="w-v ml-1 mr-1 svelte-18fkfyi"></div>
            <div class="w-10 ml-4"><p class="text-gray-300 text-xs text-center"><a class="text-gray-300 text-xs text-center"${add_attribute("href", `/club?id=${-1}`, 0)}>${escape("")}</a></p></div></div></div>
        <div class="h-px bg-gray-400 w-full lg:w-px lg:h-full lg:self-stretch" style="min-height: 2px; min-width: 2px;"></div>

        <div class="flex-grow mb-4 lg:mb-0"><p class="text-gray-300 text-xs mt-4 lg:mt-0">Kick Off:</p>
          <div class="flex"><p class="text-2xl sm:text-3xl lg:text-4xl mt-2 mb-2 font-bold">${escape(countdownDays)}<span class="text-gray-300 text-xs ml-1">d</span>
              : ${escape(countdownHours)}<span class="text-gray-300 text-xs ml-1">h</span>
              : ${escape(countdownMinutes)}<span class="text-gray-300 text-xs ml-1">m</span></p></div>
          <p class="text-gray-300 text-xs">${escape(nextFixtureDate)} | ${escape(nextFixtureTime)}</p></div>
        <div class="h-px bg-gray-400 w-full lg:w-px lg:h-full lg:self-stretch" style="min-height: 2px; min-width: 2px;"></div>
        <div class="flex-grow"><p class="text-gray-300 text-xs mt-4 lg:mt-0">GW ${escape(focusGameweek)} High Score
          </p>
          <p class="text-2xl sm:text-3xl lg:text-4xl mt-2 mb-2 font-bold max-w-[200px] truncate">${`-`}</p>
          <p class="text-gray-300 text-xs">${`-`}</p></div></div></div></div>

  <div class="mx-4"><div class="bg-panel rounded-md mx-4"><ul class="flex bg-light-gray px-4 pt-2 text-sm sm:text-base md:text-lg"><li class="${escape(null_to_empty(`mr-4 ${"active-tab"}`), true) + " svelte-18fkfyi"}"><button class="${escape(
        null_to_empty(`p-2 ${"text-white"}`),
        true
      ) + " svelte-18fkfyi"}">Fixtures
          </button></li>
        ${``}
        <li class="${escape(null_to_empty(`mr-4 ${""}`), true) + " svelte-18fkfyi"}"><button class="${escape(
        null_to_empty(`p-2 ${"text-gray-400"}`),
        true
      ) + " svelte-18fkfyi"}">Leaderboards
          </button></li>
        <li class="${escape(null_to_empty(`mr-4 ${""}`), true) + " svelte-18fkfyi"}"><button class="${escape(
        null_to_empty(`p-2 ${"text-gray-400"}`),
        true
      ) + " svelte-18fkfyi"}">Table
          </button></li></ul>

      ${`${validate_component(Fixtures, "FixturesComponent").$$render($$result, {}, {}, {})}`}</div></div>`;
    }
  })}`;
});
export {
  Page as default
};
