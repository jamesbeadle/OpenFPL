import { c as create_ssr_component, b as each, d as add_attribute, e as escape, v as validate_component, m as missing_component, a as subscribe } from "../../../chunks/index3.js";
import { L as Layout } from "../../../chunks/Layout.js";
import { p as page } from "../../../chunks/stores.js";
import { s as systemStore, t as teamStore, d as getPositionAbbreviation, b as getFlagComponent } from "../../../chunks/team-store.js";
import { p as playerStore } from "../../../chunks/player-store.js";
import { B as BadgeIcon } from "../../../chunks/BadgeIcon.js";
import "../../../chunks/manager-store.js";
import "../../../chunks/app.constants.js";
import "@dfinity/auth-client";
import "@dfinity/utils";
import "@dfinity/agent";
const Manager_gameweek_details = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let teams = [];
  let players = [];
  systemStore.subscribe((value) => {
  });
  teamStore.subscribe((value) => {
    teams = value;
  });
  playerStore.subscribe((value) => {
    players = value;
  });
  let gameweeks = Array.from({ length: 38 }, (_, i) => i + 1);
  let { selectedGameweek } = $$props;
  let { fantasyTeam } = $$props;
  let gameweekPlayers = [];
  function getPlayerDTO(playerId) {
    return players.find((x) => x.id === playerId) ?? null;
  }
  function getPlayerTeam(teamId) {
    return teams.find((x) => x.id === teamId) ?? null;
  }
  if ($$props.selectedGameweek === void 0 && $$bindings.selectedGameweek && selectedGameweek !== void 0)
    $$bindings.selectedGameweek(selectedGameweek);
  if ($$props.fantasyTeam === void 0 && $$bindings.fantasyTeam && fantasyTeam !== void 0)
    $$bindings.fantasyTeam(fantasyTeam);
  return `<div class="mx-5 my-4"><div class="flex flex-col sm:flex-row gap-4 sm:gap-8"><div class="flex items-center space-x-2"><button class="text-2xl rounded fpl-button px-2" ${selectedGameweek === 1 ? "disabled" : ""}>&lt;
      </button>

      <select class="p-4 fpl-dropdown text-sm md:text-lg text-center">${each(gameweeks, (gameweek) => {
    return `<option${add_attribute("value", gameweek, 0)}>Gameweek ${escape(gameweek)}</option>`;
  })}</select>

      <button class="text-2xl rounded fpl-button px-2 ml-1" ${selectedGameweek === 38 ? "disabled" : ""}>&gt;
      </button></div></div>

  <div class="flex flex-col space-y-4 mt-4 text-lg"><div class="overflow-x-auto flex-1"><div class="flex justify-between p-2 border border-gray-700 py-4 bg-light-gray"><div class="w-1/12 text-center mx-4">Position</div>
        <div class="w-2/12">Player</div>
        <div class="w-2/12 text-center">Team</div>
        <div class="w-1/2"><div class="w-1/12 text-center">A</div>
          <div class="w-1/12 text-center">HSP</div>
          <div class="w-1/12 text-center">GS</div>
          <div class="w-1/12 text-center">GA</div>
          <div class="w-1/12 text-center">PS</div>
          <div class="w-1/12 text-center">CS</div>
          <div class="w-1/12 text-center">KS</div>
          <div class="w-1/12 text-center">YC</div>
          <div class="w-1/12 text-center">OG</div>
          <div class="w-1/12 text-center">GC</div>
          <div class="w-1/12 text-center">RC</div>
          <div class="w-1/12 text-center">B</div></div>
        <div class="w-1/12 text-center">PTS</div></div>

      ${each(gameweekPlayers, (data) => {
    let playerDTO = getPlayerDTO(data.player.id), playerTeam = getPlayerTeam(data.player.teamId);
    return `
        
        <div class="flex items-center justify-between py-4 border-b border-gray-700 cursor-pointer"><div class="w-1/12 text-center mx-4">${escape(getPositionAbbreviation(data.player.position))}</div>
          <div class="w-2/12">${validate_component(getFlagComponent(playerDTO?.nationality ?? "") || missing_component, "svelte:component").$$render($$result, { class: "w-4 h-4 mr-1", size: "100" }, {}, {})}
            ${escape(playerDTO ? playerDTO.firstName.length > 2 ? playerDTO.firstName.substring(0, 1) + "." + playerDTO.lastName : "" : "")}</div>
          <div class="w-2/12 text-center flex items-center">${validate_component(BadgeIcon, "BadgeIcon").$$render(
      $$result,
      {
        primaryColour: playerTeam?.primaryColourHex,
        secondaryColour: playerTeam?.secondaryColourHex,
        thirdColour: playerTeam?.thirdColourHex,
        className: "w-6 h-6 mr-2"
      },
      {},
      {}
    )}
            ${escape(playerTeam?.friendlyName)}</div>
          <div class="w-1/2"><div${add_attribute("class", `w-1/12 text-center ${data.appearance > 0 ? "" : "text-gray-500"}`, 0)}>${escape(data.appearance)}</div>
            <div${add_attribute(
      "class",
      `w-1/12 text-center ${data.highestScoringPlayerId === playerDTO?.id ? "" : "text-gray-500"}`,
      0
    )}>${escape(data.highestScoringPlayerId === playerDTO?.id ? 1 : 0)}</div>
            <div${add_attribute("class", `w-1/12 text-center ${data.goals > 0 ? "" : "text-gray-500"}`, 0)}>${escape(data.goals)}</div>
            <div${add_attribute("class", `w-1/12 text-center ${data.assists > 0 ? "" : "text-gray-500"}`, 0)}>${escape(data.assists)}</div>
            <div${add_attribute("class", `w-1/12 text-center ${data.penaltySaves > 0 ? "" : "text-gray-500"}`, 0)}>${escape(data.penaltySaves)}</div>
            <div${add_attribute("class", `w-1/12 text-center ${data.cleanSheets > 0 ? "" : "text-gray-500"}`, 0)}>${escape(data.cleanSheets)}</div>
            <div${add_attribute("class", `w-1/12 text-center ${data.saves > 0 ? "" : "text-gray-500"}`, 0)}>${escape(data.saves)}</div>
            <div${add_attribute("class", `w-1/12 text-center ${data.yellowCards > 0 ? "" : "text-gray-500"}`, 0)}>${escape(data.yellowCards)}</div>
            <div${add_attribute("class", `w-1/12 text-center ${data.ownGoals > 0 ? "" : "text-gray-500"}`, 0)}>${escape(data.ownGoals)}</div>
            <div${add_attribute("class", `w-1/12 text-center ${data.goalsConceded > 0 ? "" : "text-gray-500"}`, 0)}>${escape(data.goalsConceded)}</div>
            <div${add_attribute("class", `w-1/12 text-center ${data.redCards > 0 ? "" : "text-gray-500"}`, 0)}>${escape(data.redCards)}</div>
            <div${add_attribute("class", `w-1/12 text-center ${data.bonusPoints > 0 ? "" : "text-gray-500"}`, 0)}>${escape(data.bonusPoints)}
            </div></div>
          <div class="w-1/12 text-center">${escape(data.points)}</div>
        </div>`;
  })}</div></div></div>`;
});
const Page = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let selectedGameweek;
  let $page, $$unsubscribe_page;
  $$unsubscribe_page = subscribe(page, (value) => $page = value);
  let manager;
  let selectedSeason = "";
  let joinedDate = "";
  let profilePicture;
  let favouriteTeam = null;
  let fantasyTeam;
  selectedGameweek = 1;
  $page.url.searchParams.get("id");
  Number($page.url.searchParams.get("gw"));
  $$unsubscribe_page();
  return `${validate_component(Layout, "Layout").$$render($$result, {}, {}, {
    default: () => {
      return `<div class="m-4"><div class="flex flex-col md:flex-row"><div class="flex justify-start items-center text-white space-x-4 flex-grow m-4 bg-panel p-4 rounded-md"><div class="flex"><img class="w-20"${add_attribute("src", profilePicture, 0)}${add_attribute("alt", manager.displayName, 0)}></div>
        <div class="flex-shrink-0 w-px bg-gray-400 self-stretch" style="min-width: 2px; min-height: 50px;"></div>
        <div class="flex-grow"><p class="text-gray-300 text-xs">Manager</p>
          <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">${escape(manager.displayName)}</p>
          <p class="text-gray-300 text-xs">Joined: ${escape(joinedDate)}</p></div>
        <div class="flex-shrink-0 w-px bg-gray-400 self-stretch" style="min-width: 2px; min-height: 50px;"></div>
        <div class="flex-grow"><p class="text-gray-300 text-xs">Favourite Team</p>
          <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold flex items-center">${validate_component(BadgeIcon, "BadgeIcon").$$render(
        $$result,
        {
          className: "w-7 mr-2",
          primaryColour: favouriteTeam?.primaryColourHex,
          secondaryColour: favouriteTeam?.secondaryColourHex,
          thirdColour: favouriteTeam?.thirdColourHex
        },
        {},
        {}
      )}
            ${escape(favouriteTeam?.abbreviatedName)}</p>
          <p class="text-gray-300 text-xs">${escape(favouriteTeam?.name)}</p></div></div>
      <div class="flex justify-start items-center text-white space-x-4 flex-grow m-4 bg-panel p-4 rounded-md"><div class="flex-grow"><p class="text-gray-300 text-xs">Leaderboards</p>
          <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">${escape(manager.weeklyPositionText)}
            <span class="text-xs">(${escape(manager.weeklyPoints.toLocaleString())})</span></p>
          <p class="text-gray-300 text-xs">Weekly</p></div>
        <div class="flex-shrink-0 w-px bg-gray-400 self-stretch" style="min-width: 2px; min-height: 50px;"></div>
        <div class="flex-grow"><p class="text-gray-300 text-xs">${escape(favouriteTeam?.friendlyName)}</p>
          <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">${escape(manager.monthlyPositionText)}
            <span class="text-xs">(${escape(manager.monthlyPoints.toLocaleString())})</span></p>
          <p class="text-gray-300 text-xs">Club</p></div>
        <div class="flex-shrink-0 w-px bg-gray-400 self-stretch" style="min-width: 2px; min-height: 50px;"></div>
        <div class="flex-grow"><p class="text-gray-300 text-xs">${escape(selectedSeason)}</p>
          <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">${escape(manager.seasonPositionText)}
            <span class="text-xs">(${escape(manager.seasonPoints.toLocaleString())})</span></p>
          <p class="text-gray-300 text-xs">Season</p></div></div></div>

    <div class="flex flex-col bg-panel m-4 rounded-md"><div class="flex justify-between items-center text-white px-4 pt-4 rounded-md w-full"><div class="flex"><button${add_attribute("class", `btn ${`fpl-button`} px-4 py-2 rounded-l-md font-bold text-md min-w-[125px]`, 0)}>Details
          </button>
          <button${add_attribute(
        "class",
        `btn ${`inactive-btn`} px-4 py-2 rounded-r-md font-bold text-md min-w-[125px]`,
        0
      )}>Gameweeks
          </button></div>

        <div class="px-4">${`<span class="text-2xl">Total Points: ${escape(0)}</span>`}</div></div>

      <div class="w-full">${`${validate_component(Manager_gameweek_details, "ManagerGameweekDetails").$$render($$result, { selectedGameweek, fantasyTeam }, {}, {})}`}
        ${``}</div></div></div>`;
    }
  })}`;
});
export {
  Page as default
};
