import { c as create_ssr_component, o as onDestroy, b as each, d as add_attribute, e as escape, v as validate_component } from "../../../chunks/index2.js";
import { L as Layout } from "../../../chunks/Layout.js";
import { f as formatUnixTimeToTime } from "../../../chunks/team-store.js";
import "../../../chunks/fixture-store.js";
import "../../../chunks/system-store.js";
import { B as BadgeIcon } from "../../../chunks/BadgeIcon.js";
const Admin_fixtures = create_ssr_component(($$result, $$props, $$bindings, slots) => {
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
const Page = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  return `${validate_component(Layout, "Layout").$$render($$result, {}, {}, {
    default: () => {
      return `<div class="m-4"><div class="bg-panel rounded-lg m-4"><div class="flex flex-col p-4"><h1 class="text-xl">OpenFPL Admin</h1>
        <p class="mt-2">This view is for testing purposes only.</p></div>

      <div class="flex flex-row p-4 space-x-4"><button class="text-base sm:text-xs md:text-base rounded fpl-button px-3 sm:px-2 px-3 py-1">System Status</button></div>

      <ul class="flex rounded-t-lg bg-light-gray px-4 pt-2"><li${add_attribute("class", `mr-4 text-xs md:text-base ${"active-tab"}`, 0)}><button${add_attribute(
        "class",
        `p-2 ${"text-white"}`,
        0
      )}>Fixtures</button></li></ul>

      ${`${validate_component(Admin_fixtures, "AdminFixtures").$$render($$result, {}, {}, {})}`}</div></div>`;
    }
  })}`;
});
export {
  Page as default
};
