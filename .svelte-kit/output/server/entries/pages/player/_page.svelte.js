import { c as create_ssr_component, a as subscribe, v as validate_component, e as escape, d as add_attribute, m as missing_component } from "../../../chunks/index3.js";
import { p as page } from "../../../chunks/stores.js";
import { t as teamStore, s as systemStore, u as updateTableData, g as getPositionText, c as calculateAgeFromNanoseconds, e as convertDateToReadable, b as getFlagComponent } from "../../../chunks/team-store.js";
import { a as LoadingIcon, L as Layout } from "../../../chunks/Layout.js";
import { f as fixtureStore } from "../../../chunks/player-store.js";
import { B as BadgeIcon } from "../../../chunks/BadgeIcon.js";
import { S as ShirtIcon } from "../../../chunks/ShirtIcon.js";
import "../../../chunks/app.constants.js";
import "@dfinity/auth-client";
import "@dfinity/utils";
import "@dfinity/agent";
const playerGameweekModal_svelte_svelte_type_style_lang = "";
const Player_gameweek_history = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let $page, $$unsubscribe_page;
  $$unsubscribe_page = subscribe(page, (value) => $page = value);
  let teams = [];
  let fixtures = [];
  teamStore.subscribe((value) => {
    teams = value;
  });
  fixtureStore.subscribe((value) => {
    fixtures = value;
    fixtures.map((fixture) => ({
      fixture,
      homeTeam: getTeamFromId(fixture.homeTeamId),
      awayTeam: getTeamFromId(fixture.awayTeamId)
    }));
  });
  systemStore.subscribe((value) => {
  });
  function getTeamFromId(teamId) {
    return teams.find((team) => team.id === teamId);
  }
  Number($page.url.searchParams.get("id"));
  $$unsubscribe_page();
  return `${`${validate_component(LoadingIcon, "LoadingIcon").$$render($$result, {}, {}, {})}`}`;
});
const Page = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let $page, $$unsubscribe_page;
  $$unsubscribe_page = subscribe(page, (value) => $page = value);
  let selectedGameweek = 1;
  let selectedPlayer = null;
  let fixtures = [];
  let teams = [];
  let team = null;
  let countdownDays = "00";
  let countdownHours = "00";
  let countdownMinutes = "00";
  let nextFixtureDate = "-";
  let nextFixtureTime = "-";
  Number($page.url.searchParams.get("id"));
  {
    if (fixtures.length > 0 && teams.length > 0) {
      updateTableData(fixtures, teams, selectedGameweek);
    }
  }
  $$unsubscribe_page();
  return `${validate_component(Layout, "Layout").$$render($$result, {}, {}, {
    default: () => {
      return `<div class="m-4"><div class="flex flex-col md:flex-row"><div class="flex justify-start items-center text-white space-x-4 flex-grow m-4 bg-panel p-4 rounded-md"><div class="flex-grow flex flex-col items-center"><p class="text-gray-300 text-xs">${escape(getPositionText(-1))}</p>
          <div class="py-2 flex">${validate_component(ShirtIcon, "ShirtIcon").$$render(
        $$result,
        {
          className: "h-10",
          primaryColour: team?.primaryColourHex,
          secondaryColour: team?.secondaryColourHex,
          thirdColour: team?.thirdColourHex
        },
        {},
        {}
      )}</div>
          <p class="text-gray-300 text-xs">Shirt: ${escape(selectedPlayer?.shirtNumber)}</p></div>
        <div class="flex-shrink-0 w-px bg-gray-400 self-stretch" style="min-width: 2px; min-height: 50px;"></div>
        <div class="flex-grow"><p class="text-gray-300 text-xs">${escape(team?.name)}</p>
          <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">${escape(selectedPlayer?.lastName)}</p>
          <p class="text-gray-300 text-xs flex items-center">${validate_component(getFlagComponent("") || missing_component, "svelte:component").$$render($$result, { class: "w-4 h-4 mr-1", size: "100" }, {}, {})}${escape(selectedPlayer?.firstName)}</p></div>
        <div class="flex-shrink-0 w-px bg-gray-400 self-stretch" style="min-width: 2px; min-height: 50px;"></div>
        <div class="flex-grow"><p class="text-gray-300 text-xs">Value</p>
          <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">£${escape((Number(0) / 4).toFixed(2))}m
          </p>
          <p class="text-gray-300 text-xs">Weekly Change: 0%</p></div>
        <div class="h-px bg-gray-400 w-full md:w-px md:h-full md:self-stretch" style="min-height: 2px; min-width: 2px;"></div>
        <div class="flex-grow mb-4 md:mb-0"><p class="text-gray-300 text-xs">Age</p>
          <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">${escape(calculateAgeFromNanoseconds(Number(0)))}</p>
          <p class="text-gray-300 text-xs">${escape(convertDateToReadable(Number(0)))}</p></div></div>
      <div class="flex flex-col md:flex-row justify-start md:items-center text-white space-x-0 md:space-x-4 flex-grow m-4 bg-panel p-4 rounded-md"><div class="flex-grow mb-4 md:mb-0"><p class="text-gray-300 text-xs">Next Game:</p>
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
              <div class="w-v ml-1 mr-1 flex justify-center"><p class="text-xs mt-2 mb-2 font-bold">v</p></div>
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
            <div class="w-v ml-2 mr-2"></div>
            <div class="w-10 ml-4"><p class="text-gray-300 text-xs text-center"><a class="text-gray-300 text-xs text-center"${add_attribute("href", `/club?id=${-1}`, 0)}>${escape("")}</a></p></div></div></div>
        <div class="h-px bg-gray-400 w-full md:w-px md:h-full md:self-stretch" style="min-height: 2px; min-width: 2px;"></div>
        <div class="flex-grow mb-4 md:mb-0"><p class="text-gray-300 text-xs mt-4 md:mt-0">Kick Off:</p>
          <div class="flex"><p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">${escape(countdownDays)}<span class="text-gray-300 text-xs ml-1">d</span>
              : ${escape(countdownHours)}<span class="text-gray-300 text-xs ml-1">h</span>
              : ${escape(countdownMinutes)}<span class="text-gray-300 text-xs ml-1">m</span></p></div>
          <p class="text-gray-300 text-xs">${escape(nextFixtureDate)} | ${escape(nextFixtureTime)}</p></div></div></div></div>

  <div class="m-4"><div class="bg-panel rounded-md m-4"><ul class="flex bg-light-gray px-4 pt-2"><li${add_attribute("class", `mr-4 text-xs md:text-lg ${"active-tab"}`, 0)}><button${add_attribute("class", `p-2 ${"text-white"}`, 0)}>Gameweek History
          </button></li></ul>
      ${`${validate_component(Player_gameweek_history, "PlayerGameweekHistory").$$render($$result, {}, {}, {})}`}</div></div>`;
    }
  })}`;
});
export {
  Page as default
};
