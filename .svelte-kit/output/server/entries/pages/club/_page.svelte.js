import { c as create_ssr_component, d as add_attribute, b as each, e as escape, v as validate_component, m as missing_component, a as subscribe } from "../../../chunks/index3.js";
import { P as Position, g as getPositionText, c as calculateAgeFromNanoseconds, b as getFlagComponent, t as teamStore, s as systemStore, u as updateTableData } from "../../../chunks/team-store.js";
import { f as fixtureStore, p as playerStore } from "../../../chunks/player-store.js";
import { L as Layout, a as LoadingIcon } from "../../../chunks/Layout.js";
import { B as BadgeIcon } from "../../../chunks/BadgeIcon.js";
import { p as page } from "../../../chunks/stores.js";
import { S as ShirtIcon } from "../../../chunks/ShirtIcon.js";
import { w as writable } from "../../../chunks/index2.js";
const isLoading = writable(false);
const Team_players = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let filteredPlayers;
  let { players = [] } = $$props;
  let positionValues = Object.values(Position).filter((value) => typeof value === "number");
  if ($$props.players === void 0 && $$bindings.players && players !== void 0)
    $$bindings.players(players);
  filteredPlayers = players;
  return `<div class="container-fluid"><div class="flex flex-col space-y-4"><div><div class="flex p-4"><div class="flex items-center ml-4"><p class="text-sm md:text-xl mr-4">Position:</p>
          <select class="p-2 fpl-dropdown text-sm md:text-xl"><option${add_attribute("value", -1, 0)}>All</option>${each(positionValues, (position) => {
    return `<option${add_attribute("value", position, 0)}>${escape(getPositionText(position))}</option>`;
  })}</select></div></div>
      <div class="flex justify-between p-2 border border-gray-700 py-4 bg-light-gray"><div class="flex-grow px-4 w-1/2">Number</div>
        <div class="flex-grow px-4 w-1/2">First Name</div>
        <div class="flex-grow px-4 w-1/2">Last Name</div>
        <div class="flex-grow px-4 w-1/2">Position</div>
        <div class="flex-grow px-4 w-1/2">Age</div>
        <div class="flex-grow px-4 w-1/2">Nationality</div>
        <div class="flex-grow px-4 w-1/2">Season Points</div>
        <div class="flex-grow px-4 w-1/2">Value</div></div>
      ${each(filteredPlayers, (player) => {
    return `<div class="flex items-center justify-between py-2 border-b border-gray-700 text-white cursor-pointer"><a class="flex-grow flex items-center justify-start space-x-2 px-4"${add_attribute("href", `/player?id=${player.id}`, 0)}><div class="flex items-center w-1/2 px-3">${escape(player.shirtNumber === 0 ? "-" : player.shirtNumber)}</div>
            <div class="flex items-center w-1/2 px-3">${escape(player.firstName === "" ? "-" : player.firstName)}</div>
            <div class="flex items-center w-1/2 px-3">${escape(player.lastName)}</div>
            <div class="flex items-center w-1/2 px-3">${escape(getPositionText(player.position))}</div>
            <div class="flex items-center w-1/2 px-3">${escape(calculateAgeFromNanoseconds(Number(player.dateOfBirth)))}</div>
            <div class="flex items-center w-1/2 px-3">${validate_component(getFlagComponent(player.nationality) || missing_component, "svelte:component").$$render($$result, { class: "w-10 h-10", size: "100" }, {}, {})}</div>
            <div class="flex items-center w-1/2 px-3">${escape(player.totalPoints)}</div>
            <div class="flex items-center w-1/2 px-3">£${escape((Number(player.value) / 4).toFixed(2))}m
            </div></a>
        </div>`;
  })}</div></div></div>`;
});
let team = null;
const Page = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let id;
  let $page, $$unsubscribe_page;
  $$unsubscribe_page = subscribe(page, (value) => $page = value);
  let teams = [];
  let fixtures = [];
  let fixturesWithTeams = [];
  teamStore.subscribe((value) => {
    teams = value;
  });
  fixtureStore.subscribe((value) => {
    fixtures = value;
    fixturesWithTeams = fixtures.map((fixture) => ({
      fixture,
      homeTeam: getTeamFromId(fixture.homeTeamId),
      awayTeam: getTeamFromId(fixture.awayTeamId)
    }));
  });
  systemStore.subscribe((value) => {
  });
  playerStore.subscribe((value) => {
    players = value.filter((player) => player.teamId === id);
  });
  let selectedGameweek = 1;
  let selectedSeason;
  let players = [];
  let nextFixtureHomeTeam = null;
  let nextFixtureAwayTeam = null;
  let highestScoringPlayer = null;
  let tableData = [];
  function getTeamFromId(teamId) {
    return teams.find((team2) => team2.id === teamId);
  }
  const getTeamPosition = (teamId) => {
    const position = tableData.findIndex((team2) => team2.id === teamId);
    return position !== -1 ? position + 1 : "Not found";
  };
  const getTeamPoints = (teamId) => {
    const points = tableData.find((team2) => team2.id === teamId).points;
    return points;
  };
  id = Number($page.url.searchParams.get("id"));
  {
    if (fixturesWithTeams.length > 0 && teams.length > 0) {
      tableData = updateTableData(fixturesWithTeams, teams, selectedGameweek);
    }
  }
  $$unsubscribe_page();
  return `${validate_component(Layout, "Layout").$$render($$result, {}, {}, {
    default: () => {
      return `${isLoading ? `${validate_component(LoadingIcon, "LoadingIcon").$$render($$result, {}, {}, {})}` : `<div class="m-4"><div class="flex flex-col md:flex-row"><div class="flex justify-start items-center text-white space-x-4 flex-grow m-4 bg-panel p-4 rounded-md"><div class="flex-grow flex flex-col items-center"><p class="text-gray-300 text-xs">${escape(team?.friendlyName)}</p>
            <div class="py-2 flex space-x-4">${validate_component(BadgeIcon, "BadgeIcon").$$render(
        $$result,
        {
          className: "h-10",
          primaryColour: team?.primaryColourHex,
          secondaryColour: team?.secondaryColourHex,
          thirdColour: team?.thirdColourHex
        },
        {},
        {}
      )}
              ${validate_component(ShirtIcon, "ShirtIcon").$$render(
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
            <p class="text-gray-300 text-xs">${escape(team?.abbreviatedName)}</p></div>
          <div class="flex-shrink-0 w-px bg-gray-400 self-stretch" style="min-width: 2px; min-height: 50px;"></div>
          <div class="flex-grow"><p class="text-gray-300 text-xs">Players</p>
            <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">${escape(players.length)}</p>
            <p class="text-gray-300 text-xs">Total</p></div>
          <div class="flex-shrink-0 w-px bg-gray-400 self-stretch" style="min-width: 2px; min-height: 50px;"></div>
          <div class="flex-grow"><p class="text-gray-300 text-xs">League Position</p>
            <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">${escape(getTeamPosition(id))}</p>
            <p class="text-gray-300 text-xs">${escape(selectedSeason.name)}</p></div></div>
        <div class="flex flex-col md:flex-row justify-start md:items-center text-white space-x-0 md:space-x-4 flex-grow m-4 bg-panel p-4 rounded-md"><div class="flex-grow mb-4 md:mb-0"><p class="text-gray-300 text-xs">League Points</p>
            <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">${escape(getTeamPoints(id))}</p>
            <p class="text-gray-300 text-xs">Total</p></div>
          <div class="h-px bg-gray-400 w-full md:w-px md:h-full md:self-stretch" style="min-height: 2px; min-width: 2px;"></div>

          <div class="flex-grow mb-4 md:mb-0"><p class="text-gray-300 text-xs">Next Game:</p>
            <div class="flex justify-center mb-2 mt-2"><div class="flex justify-center items-center"><div class="w-10 ml-4 mr-4"><a${add_attribute("href", `/club?id=${nextFixtureHomeTeam?.id}`, 0)}>${validate_component(BadgeIcon, "BadgeIcon").$$render(
        $$result,
        {
          primaryColour: nextFixtureHomeTeam?.primaryColourHex,
          secondaryColour: nextFixtureHomeTeam?.secondaryColourHex,
          thirdColour: nextFixtureHomeTeam?.thirdColourHex
        },
        {},
        {}
      )}</a></div>
                <div class="w-v ml-1 mr-1 flex justify-center"><p class="text-xs mt-2 mb-2 font-bold">v</p></div>
                <div class="w-10 ml-4"><a${add_attribute("href", `/club?id=${nextFixtureAwayTeam?.id}`, 0)}>${validate_component(BadgeIcon, "BadgeIcon").$$render(
        $$result,
        {
          primaryColour: nextFixtureAwayTeam?.primaryColourHex,
          secondaryColour: nextFixtureAwayTeam?.secondaryColourHex,
          thirdColour: nextFixtureAwayTeam?.thirdColourHex
        },
        {},
        {}
      )}</a></div></div></div>
            <div class="flex justify-center"><div class="w-10 ml-4 mr-4"><p class="text-gray-300 text-xs text-center"><a class="text-gray-300 text-xs text-center"${add_attribute("href", `/club?id=${nextFixtureHomeTeam?.id}`, 0)}>${escape(nextFixtureHomeTeam?.abbreviatedName)}</a></p></div>
              <div class="w-v ml-2 mr-2"></div>
              <div class="w-10 ml-4"><p class="text-gray-300 text-xs text-center"><a class="text-gray-300 text-xs text-center"${add_attribute("href", `/club?id=${nextFixtureAwayTeam?.id}`, 0)}>${escape(nextFixtureAwayTeam?.abbreviatedName)}</a></p></div></div></div>
          <div class="h-px bg-gray-400 w-full md:w-px md:h-full md:self-stretch" style="min-height: 2px; min-width: 2px;"></div>
          <div class="flex-grow"><p class="text-gray-300 text-xs mt-4 md:mt-0">Highest Scoring Player
            </p>
            <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold"><a${add_attribute("href", `/player?id=${highestScoringPlayer?.id}`, 0)}>${escape(highestScoringPlayer?.lastName)}</a></p>
            <p class="text-gray-300 text-xs">${escape(getPositionText(0))}
              (${escape(highestScoringPlayer?.totalPoints)})
            </p></div></div></div></div>

    <div class="m-4"><div class="bg-panel rounded-md m-4"><ul class="flex bg-light-gray px-4 pt-2"><li${add_attribute("class", `mr-4 text-xs md:text-lg ${"active-tab"}`, 0)}><button${add_attribute("class", `p-2 ${"text-white"}`, 0)}>Players
            </button></li>
          <li${add_attribute("class", `mr-4 text-xs md:text-lg ${""}`, 0)}><button${add_attribute(
        "class",
        `p-2 ${"text-gray-400"}`,
        0
      )}>Fixtures
            </button></li></ul>

        ${`${validate_component(Team_players, "TeamPlayers").$$render($$result, { players }, {}, {})}`}</div></div>`}`;
    }
  })}`;
});
export {
  Page as default
};
