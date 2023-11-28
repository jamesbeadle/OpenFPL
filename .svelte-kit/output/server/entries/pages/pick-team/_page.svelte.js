import { c as create_ssr_component, b as each, e as escape, n as null_to_empty, d as add_attribute, g as get_store_value, a as subscribe, v as validate_component, o as onDestroy, m as missing_component } from "../../../chunks/index3.js";
import { L as Layout } from "../../../chunks/Layout.js";
import { w as writable } from "../../../chunks/index2.js";
import { t as teamStore, s as systemStore, f as formatUnixTimeToTime, d as getPositionAbbreviation, b as getFlagComponent } from "../../../chunks/team-store.js";
import "../../../chunks/app.constants.js";
import "@dfinity/auth-client";
import "@dfinity/utils";
import "@dfinity/agent";
import "../../../chunks/manager-store.js";
import { B as BadgeIcon } from "../../../chunks/BadgeIcon.js";
import { p as playerStore, f as fixtureStore } from "../../../chunks/player-store.js";
import { S as ShirtIcon } from "../../../chunks/ShirtIcon.js";
var BonusType = /* @__PURE__ */ ((BonusType2) => {
  BonusType2[BonusType2["AUTOMATIC"] = 0] = "AUTOMATIC";
  BonusType2[BonusType2["PLAYER"] = 1] = "PLAYER";
  BonusType2[BonusType2["TEAM"] = 2] = "TEAM";
  BonusType2[BonusType2["COUNTRY"] = 3] = "COUNTRY";
  return BonusType2;
})(BonusType || {});
const useBonusModal_svelte_svelte_type_style_lang = "";
const bonusPanel_svelte_svelte_type_style_lang = "";
const css$1 = {
  code: ".bonus-panel-inner.svelte-1nv76pl{background-color:rgba(46, 50, 58, 0.9)}.bonus-panel.svelte-1nv76pl{background-color:rgba(46, 50, 58, 0.8)}",
  map: null
};
const Bonus_panel = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { fantasyTeam = writable(null) } = $$props;
  let { players } = $$props;
  let { teams } = $$props;
  let { activeGameweek } = $$props;
  let bonuses = [
    {
      id: 1,
      name: "Goal Getter",
      image: "goal-getter.png",
      description: "Select a player you think will score in a game to receive a X3 mulitplier for each goal scored.",
      selectionType: BonusType.PLAYER
    },
    {
      id: 2,
      name: "Pass Master",
      image: "pass-master.png",
      description: "Select a player you think will assist in a game to receive a X3 mulitplier for each assist.",
      selectionType: BonusType.PLAYER
    },
    {
      id: 3,
      name: "No Entry",
      image: "no-entry.png",
      description: "Select a goalkeeper or defender you think will keep a clean sheet to receive a X3 multipler on their total score.",
      selectionType: BonusType.PLAYER
    },
    {
      id: 4,
      name: "Team Boost",
      image: "team-boost.png",
      description: "Receive a X2 multiplier from all players from a single club that are in your team.",
      selectionType: BonusType.TEAM
    },
    {
      id: 5,
      name: "Safe Hands",
      image: "safe-hands.png",
      description: "Receive a X3 multiplier on your goalkeeper if they make 5 saves in a match.",
      selectionType: BonusType.AUTOMATIC
    },
    {
      id: 6,
      name: "Captain Fantastic",
      image: "captain-fantastic.png",
      description: "Receive a X2 multiplier on your team captain's score if they score a goal in a match.",
      selectionType: BonusType.AUTOMATIC
    },
    {
      id: 7,
      name: "Prospects",
      image: "prospects.png",
      description: "Receive a X2 multiplier for players under the age of 21.",
      selectionType: BonusType.AUTOMATIC
    },
    {
      id: 8,
      name: "Countrymen",
      image: "countrymen.png",
      description: "Receive a X2 multiplier for players of a selected nationality.",
      selectionType: BonusType.COUNTRY
    },
    {
      id: 9,
      name: "Brace Bonus",
      image: "brace-bonus.png",
      description: "Receive a X2 multiplier on a player's score if they score 2 or more goals in a game. Applies to every player who scores a brace.",
      selectionType: BonusType.AUTOMATIC
    },
    {
      id: 10,
      name: "Hat-Trick Hero",
      image: "hat-trick-hero.png",
      description: "Receive a X3 multiplier on a player's score if they score 3 or more goals in a game. Applies to every player who scores a hat-trick.",
      selectionType: BonusType.AUTOMATIC
    }
  ];
  let leftPanelBonuses = bonuses.slice(0, 5);
  let rightPanelBonuses = bonuses.slice(5, 10);
  function isBonusUsed(bonusId) {
    const team = get_store_value(fantasyTeam);
    if (!team)
      return false;
    switch (bonusId) {
      case 1:
        return team.goalGetterGameweek && team.goalGetterGameweek > 0 ? team.goalGetterGameweek : false;
      case 2:
        return team.passMasterGameweek && team.passMasterGameweek > 0 ? team.passMasterGameweek : false;
      case 3:
        return team.noEntryGameweek && team.noEntryGameweek > 0 ? team.noEntryGameweek : false;
      case 4:
        return team.teamBoostGameweek && team.teamBoostGameweek > 0 ? team.teamBoostGameweek : false;
      case 5:
        return team.safeHandsGameweek && team.safeHandsGameweek > 0 ? team.safeHandsGameweek : false;
      case 6:
        return team.captainFantasticGameweek && team.captainFantasticGameweek > 0 ? team.captainFantasticGameweek : false;
      case 7:
        return false;
      case 8:
        return false;
      case 9:
        return team.braceBonusGameweek && team.braceBonusGameweek > 0 ? team.braceBonusGameweek : false;
      case 10:
        return team.hatTrickHeroGameweek && team.hatTrickHeroGameweek > 0 ? team.hatTrickHeroGameweek : false;
      default:
        return false;
    }
  }
  if ($$props.fantasyTeam === void 0 && $$bindings.fantasyTeam && fantasyTeam !== void 0)
    $$bindings.fantasyTeam(fantasyTeam);
  if ($$props.players === void 0 && $$bindings.players && players !== void 0)
    $$bindings.players(players);
  if ($$props.teams === void 0 && $$bindings.teams && teams !== void 0)
    $$bindings.teams(teams);
  if ($$props.activeGameweek === void 0 && $$bindings.activeGameweek && activeGameweek !== void 0)
    $$bindings.activeGameweek(activeGameweek);
  $$result.css.add(css$1);
  return `<div class="bonus-panel rounded-md m-4 flex-1 svelte-1nv76pl">${``}
  <div class="flex flex-col md:flex-row bonus-panel-inner svelte-1nv76pl"><h1 class="m-4 font-bold">Bonuses</h1></div>
  <div class="flex flex-col md:flex-row"><div class="flex items-center w-100 md:w-1/2">${each(leftPanelBonuses, (bonus) => {
    return `<div class="flex items-center w-1/5 bonus-panel-inner m-1 md:m-4 rounded-lg border border-gray-700 svelte-1nv76pl"><div class="${escape(null_to_empty(`flex flex-col justify-center items-center flex-1`), true) + " svelte-1nv76pl"}"><img${add_attribute("alt", bonus.name, 0)}${add_attribute("src", bonus.image, 0)} class="h-10 md:h-24 mt-2">
            <p class="text-center text-xs mt-4 m-2 font-bold">${escape(bonus.name)}</p>
            <button class="fpl-purple-btn mt-4 mb-8 p-2 px-4 rounded-md min-w-[100px]">Use</button></div>
        </div>`;
  })}</div>
    <div class="flex items-center w-100 md:w-1/2">${each(rightPanelBonuses, (bonus) => {
    return `<div class="flex items-center w-1/5 bonus-panel-inner m-1 md:m-4 rounded-lg border border-gray-700 svelte-1nv76pl"><div class="${escape(null_to_empty(`flex flex-col justify-center items-center flex-1`), true) + " svelte-1nv76pl"}"><img${add_attribute("alt", bonus.name, 0)}${add_attribute("src", bonus.image, 0)} class="h-10 md:h-24 mt-2">
            <p class="text-center text-xs mt-4 m-2 font-bold">${escape(bonus.name)}</p>
            ${isBonusUsed(bonus.id) ? `<p class="text-center text-xs mt-4 m-2">Used in GW ${escape(isBonusUsed(bonus.id))}
              </p>` : `<button class="fpl-purple-btn mt-4 mb-8 p-2 px-4 rounded-md min-w-[100px]">Use</button>`}</div>
        </div>`;
  })}</div></div>
</div>`;
});
const AddIcon = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { className = "" } = $$props;
  if ($$props.className === void 0 && $$bindings.className && className !== void 0)
    $$bindings.className(className);
  return `<svg xmlns="http://www.w3.org/2000/svg"${add_attribute("class", className, 0)} fill="currentColor" viewBox="0 0 16 16"><path d="M16 6.66667H9.33333V0H6.66667V6.66667H0V9.33333H6.66667V16H9.33333V9.33333H16V6.66667Z" fill="#FFFFFF"></path></svg>`;
});
const addPlayerModal_svelte_svelte_type_style_lang = "";
const css = {
  code: ".modal-backdrop.svelte-1jzawa3{z-index:1000}.active.svelte-1jzawa3{background-color:#2ce3a6;color:white}",
  map: null
};
const pageSize = 10;
const Add_player_modal = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let filteredPlayers;
  let paginatedPlayers;
  let teamPlayerCounts;
  let disableReasons;
  let $bankBalance, $$unsubscribe_bankBalance;
  let { showAddPlayer } = $$props;
  let { closeAddPlayerModal } = $$props;
  let { handlePlayerSelection } = $$props;
  let { fantasyTeam = writable(null) } = $$props;
  let { filterPosition = -1 } = $$props;
  let { filterColumn = -1 } = $$props;
  let { bankBalance = writable(0) } = $$props;
  $$unsubscribe_bankBalance = subscribe(bankBalance, (value) => $bankBalance = value);
  let players = [];
  let teams = [];
  teamStore.subscribe((value) => {
    teams = value;
  });
  playerStore.subscribe((value) => {
    players = value;
  });
  let filterSurname = "";
  let minValue = 0;
  let maxValue = 0;
  let currentPage = 1;
  function countPlayersByTeam(playerIds) {
    const counts = {};
    playerIds.forEach((playerId) => {
      const player = players.find((p) => p.id === playerId);
      if (player) {
        if (!counts[player.teamId]) {
          counts[player.teamId] = 0;
        }
        counts[player.teamId]++;
      }
    });
    return counts;
  }
  function reasonToDisablePlayer(player) {
    const teamCount = teamPlayerCounts[player.teamId] || 0;
    if (teamCount >= 2)
      return "Max 2 Per Team";
    let team = get_store_value(fantasyTeam);
    const canAfford = get_store_value(bankBalance) >= Number(player.value);
    if (!canAfford)
      return "Over Budget";
    if (team && team.playerIds.includes(player.id))
      return "Selected";
    const positionCounts = { 0: 0, 1: 0, 2: 0, 3: 0 };
    team && team.playerIds.forEach((id) => {
      const teamPlayer = players.find((p) => p.id === id);
      if (teamPlayer) {
        positionCounts[teamPlayer.position]++;
      }
    });
    positionCounts[player.position]++;
    const formations = ["3-4-3", "3-5-2", "4-3-3", "4-4-2", "4-5-1", "5-4-1", "5-3-2"];
    const isFormationValid = formations.some((formation) => {
      const [def, mid, fwd] = formation.split("-").map(Number);
      const minDef = Math.max(0, def - (positionCounts[1] || 0));
      const minMid = Math.max(0, mid - (positionCounts[2] || 0));
      const minFwd = Math.max(0, fwd - (positionCounts[3] || 0));
      const minGK = Math.max(0, 1 - (positionCounts[0] || 0));
      const additionalPlayersNeeded = minDef + minMid + minFwd + minGK;
      const totalPlayers = Object.values(positionCounts).reduce((a, b) => a + b, 0);
      return totalPlayers + additionalPlayersNeeded <= 11;
    });
    if (!isFormationValid)
      return "Invalid Formation";
    return null;
  }
  if ($$props.showAddPlayer === void 0 && $$bindings.showAddPlayer && showAddPlayer !== void 0)
    $$bindings.showAddPlayer(showAddPlayer);
  if ($$props.closeAddPlayerModal === void 0 && $$bindings.closeAddPlayerModal && closeAddPlayerModal !== void 0)
    $$bindings.closeAddPlayerModal(closeAddPlayerModal);
  if ($$props.handlePlayerSelection === void 0 && $$bindings.handlePlayerSelection && handlePlayerSelection !== void 0)
    $$bindings.handlePlayerSelection(handlePlayerSelection);
  if ($$props.fantasyTeam === void 0 && $$bindings.fantasyTeam && fantasyTeam !== void 0)
    $$bindings.fantasyTeam(fantasyTeam);
  if ($$props.filterPosition === void 0 && $$bindings.filterPosition && filterPosition !== void 0)
    $$bindings.filterPosition(filterPosition);
  if ($$props.filterColumn === void 0 && $$bindings.filterColumn && filterColumn !== void 0)
    $$bindings.filterColumn(filterColumn);
  if ($$props.bankBalance === void 0 && $$bindings.bankBalance && bankBalance !== void 0)
    $$bindings.bankBalance(bankBalance);
  $$result.css.add(css);
  filteredPlayers = players.filter((player) => {
    return (filterPosition === -1 || player.position === filterPosition) && filterColumn > -2 && minValue === 0 && maxValue === 0 && filterSurname === "";
  });
  {
    {
      {
        teamPlayerCounts = countPlayersByTeam(get_store_value(fantasyTeam)?.playerIds ?? []);
        currentPage = 1;
      }
    }
  }
  paginatedPlayers = filteredPlayers.slice((currentPage - 1) * pageSize, currentPage * pageSize);
  teamPlayerCounts = countPlayersByTeam(get_store_value(fantasyTeam)?.playerIds ?? []);
  disableReasons = paginatedPlayers.map((player) => reasonToDisablePlayer(player));
  $$unsubscribe_bankBalance();
  return `${showAddPlayer ? `<div class="fixed inset-0 bg-gray-900 bg-opacity-80 overflow-y-auto h-full w-full modal-backdrop svelte-1jzawa3"><div class="relative top-20 mx-auto p-5 border w-full max-w-4xl shadow-lg rounded-md bg-panel text-white"><div class="flex justify-between items-center mb-4"><h3 class="text-xl font-semibold">Select Player</h3>
        <button class="text-3xl leading-none">×</button></div>
      <div class="mb-4"><div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4"><div><label for="filterTeam" class="text-sm">Filter by Team:</label>
            <select id="filterTeam" class="mt-1 block w-full p-2 bg-gray-700 text-white rounded-md"><option${add_attribute("value", -1, 0)}>All</option>${each(teams, (team) => {
    return `<option${add_attribute("value", team.id, 0)}>${escape(team.friendlyName)}</option>`;
  })}</select></div>
          <div><label for="filterPosition" class="text-sm">Filter by Position:</label>
            <select id="filterPosition" class="mt-1 block w-full p-2 bg-gray-700 text-white rounded-md"><option${add_attribute("value", -1, 0)}>All</option><option${add_attribute("value", 0, 0)}>Goalkeepers</option><option${add_attribute("value", 1, 0)}>Defenders</option><option${add_attribute("value", 2, 0)}>Midfielders</option><option${add_attribute("value", 3, 0)}>Forwards</option></select></div></div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4"><div><label for="minValue" class="text-sm">Min Value:</label>
            <input id="minValue" type="number" class="mt-1 block w-full p-2 bg-gray-700 text-white rounded-md"${add_attribute("value", minValue, 0)}></div>
          <div><label for="maxValue" class="text-sm">Max Value:</label>
            <input id="maxValue" type="number" class="mt-1 block w-full p-2 bg-gray-700 text-white rounded-md"${add_attribute("value", maxValue, 0)}></div></div>

        <div class="mb-4"><label for="filterSurname" class="text-sm">Search by Name:</label>
          <input id="filterSurname" type="text" class="mt-1 block w-full p-2 bg-gray-700 text-white rounded-md" placeholder="Enter"${add_attribute("value", filterSurname, 0)}></div>

        <div class="mb-4"><label for="bankBalance" class="font-bold">Available Balance: £${escape(($bankBalance / 4).toFixed(2))}m</label></div></div>

      <div class="overflow-x-auto"><table class="w-full"><thead><tr><th class="text-left p-2">Pos</th>
              <th class="text-left p-2">Name</th>
              <th class="text-left p-2">Club</th>
              <th class="text-left p-2">Value</th>
              <th class="text-left p-2">Pts</th>
              <th class="text-left p-2"> </th></tr></thead>
          <tbody>${each(paginatedPlayers, (player, index) => {
    return `<tr>${player.position === 0 ? `<td class="p-2">GK</td>` : ``}
                ${player.position === 1 ? `<td class="p-2">DF</td>` : ``}
                ${player.position === 2 ? `<td class="p-2">MF</td>` : ``}
                ${player.position === 3 ? `<td class="p-2">FW</td>` : ``}
                <td class="p-2">${escape(player.firstName)} ${escape(player.lastName)}</td>
                <td class="p-2"><p class="flex items-center">${validate_component(BadgeIcon, "BadgeIcon").$$render(
      $$result,
      {
        className: "w-6 h-6 mr-2",
        primaryColour: player.team?.primaryColourHex,
        secondaryColour: player.team?.secondaryColourHex,
        thirdColour: player.team?.thirdColourHex
      },
      {},
      {}
    )}
                    ${escape(player.team?.abbreviatedName)}
                  </p></td>
                <td class="p-2">£${escape((Number(player.value) / 4).toFixed(2))}m</td>
                <td class="p-2">${escape(player.totalPoints)}</td>
                <td class="p-2"><div class="w-1/6 flex items-center">${disableReasons[index] ? `<span class="text-xs">${escape(disableReasons[index])}</span>` : `<button class="text-xl rounded fpl-button flex items-center">${validate_component(AddIcon, "AddIcon").$$render($$result, { className: "w-6 h-6 p-2" }, {}, {})}
                      </button>`}
                  </div></td>
              </tr>`;
  })}</tbody></table></div>

      <div class="justify-center mt-4 pb-4 overflow-x-auto"><div class="flex space-x-1 min-w-max">${each(Array(Math.ceil(filteredPlayers.length / pageSize)), (_, index) => {
    return `<button class="${[
      "px-4 py-2 bg-gray-700 rounded-md text-white hover:bg-gray-600 svelte-1jzawa3",
      index + 1 === currentPage ? "active" : ""
    ].join(" ").trim()}">${escape(index + 1)}
            </button>`;
  })}</div></div>

      <div class="flex justify-end mt-4"><button class="px-4 py-2 fpl-purple-btn rounded-md text-white">Close</button></div></div></div>` : ``}`;
});
const OpenChatIcon = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { className = "" } = $$props;
  if ($$props.className === void 0 && $$bindings.className && className !== void 0)
    $$bindings.className(className);
  return `<svg viewBox="0 0 361 361"${add_attribute("class", className, 0)} xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"><defs><linearGradient id="gradient-2"></linearGradient><linearGradient id="gradient-5"><stop style="stop-color: rgb(251, 176, 59);" offset="0"></stop><stop style="stop-color: rgb(240, 90, 36);" offset="1"></stop></linearGradient><linearGradient id="gradient-6"><stop style="stop-color: rgb(95, 37, 131);" offset="0"></stop><stop style="stop-color: rgb(237, 30, 121);" offset="1"></stop></linearGradient><linearGradient id="gradient-6-1" gradientUnits="userSpaceOnUse" x1="973.216" y1="100.665" x2="973.216" y2="388.077" gradientTransform="matrix(0.974127, -0.22842, 0.310454, 1.352474, -95.300314, 85.515158)" xlink:href="#gradient-6"></linearGradient><linearGradient id="gradient-5-0" gradientUnits="userSpaceOnUse" x1="188.919" y1="1.638" x2="188.919" y2="361.638" gradientTransform="matrix(-0.999999, 0.0016, -0.002016, -1.25907, 376.779907, 357.264557)" xlink:href="#gradient-5"></linearGradient></defs><g transform="matrix(1, 0, 0, 1, -69.98674, -69.986298)"><path d="M 188.919 181.638 m -180 0 a 180 180 0 1 0 360 0 a 180 180 0 1 0 -360 0 Z M 188.919 181.638 m -100 0 a 100 100 0 0 1 200 0 a 100 100 0 0 1 -200 0 Z" style="fill: url(#gradient-5-0);" transform="matrix(1, 0.000074, -0.000074, 1, 61.094498, 68.347626)"></path><path style="stroke-width: 0px; paint-order: stroke; fill: url(#gradient-6-1);" transform="matrix(1.031731, 0.000001, 0, 1.020801, -634.597351, 0.544882)" d="M 958.327234958 100.664699414 A 175.433 175.433 0 0 1 958.327234958 388.077300586 L 913.296322517 323.766492741 A 96.924 96.924 0 0 0 913.296322517 164.975507259 Z"></path><circle style="fill: rgb(25, 25, 25);" cx="250" cy="250" r="100"></circle></g></svg>`;
});
const Simple_fixtures = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let filteredFixtures;
  let groupedFixtures;
  let teams = [];
  let fixtures = [];
  let fixturesWithTeams = [];
  let selectedGameweek = 1;
  let gameweeks = Array.from({ length: 38 }, (_, i) => i + 1);
  let unsubscribeTeams;
  unsubscribeTeams = teamStore.subscribe((value) => {
    teams = value;
  });
  let unsubscribeFixtures;
  unsubscribeFixtures = fixtureStore.subscribe((value) => {
    fixtures = value;
    fixturesWithTeams = fixtures.map((fixture) => ({
      fixture,
      homeTeam: getTeamFromId(fixture.homeTeamId),
      awayTeam: getTeamFromId(fixture.awayTeamId)
    }));
  });
  let unsubscribeSystemState;
  unsubscribeSystemState = systemStore.subscribe((value) => {
  });
  onDestroy(() => {
    if (unsubscribeTeams) {
      unsubscribeTeams();
    }
    if (unsubscribeFixtures) {
      unsubscribeFixtures();
    }
    if (unsubscribeSystemState) {
      unsubscribeSystemState();
    }
  });
  function getTeamFromId(teamId) {
    return teams.find((team) => team.id === teamId);
  }
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
  return `<div class="bg-panel rounded-md m-4 flex-1"><div class="container-fluid"><div class="flex items-center justify-between py-2 bg-light-gray"><h1 class="mx-4 m-2 font-bold">Fixtures</h1></div>
    <div class="flex items-center space-x-2 m-3 mx-4"><button class="text-2xl rounded fpl-button px-3 py-1" ${"disabled"}>&lt;
      </button>

      <select class="p-2 fpl-dropdown text-sm md:text-xl text-center">${each(gameweeks, (gameweek) => {
    return `<option${add_attribute("value", gameweek, 0)}>Gameweek ${escape(gameweek)}</option>`;
  })}</select>

      <button class="text-2xl rounded fpl-button px-3 py-1" ${""}>&gt;
      </button></div>
    <div>${each(Object.entries(groupedFixtures), ([date, fixtures2]) => {
    return `<div><div class="flex items-center justify-between border border-gray-700 py-2 bg-light-gray"><h2 class="date-header ml-4 text-xs">${escape(date)}</h2></div>
          ${each(fixtures2, ({ fixture, homeTeam, awayTeam }) => {
      return `<div${add_attribute("class", `flex items-center justify-between py-2 border-b border-gray-700  ${fixture.status === 0 ? "text-gray-400" : "text-white"}`, 0)}><div class="flex items-center w-1/2 ml-4"><div class="flex w-1/2 space-x-4 justify-center"><div class="w-8 items-center justify-center"><a${add_attribute("href", `/club?id=${fixture.homeTeamId}`, 0)}>${validate_component(BadgeIcon, "BadgeIcon").$$render(
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
                  <div class="w-8 items-center justify-center"><a${add_attribute("href", `/club?id=${fixture.awayTeamId}`, 0)}>${validate_component(BadgeIcon, "BadgeIcon").$$render(
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
                <div class="flex w-1/2 md:justify-center"><span class="text-sm ml-4 md:ml-0 text-left">${escape(formatUnixTimeToTime(Number(fixture.kickOff)))}</span>
                </div></div>
              <div class="flex items-center space-x-10 w-1/2 md:justify-center"><div class="flex flex-col min-w-[120px] md:min-w-[200px] text-xs 3xl:text-base"><a class="my-1"${add_attribute("href", `/club?id=${fixture.homeTeamId}`, 0)}>${escape(homeTeam ? homeTeam.friendlyName : "")}</a>
                  <a class="my-1"${add_attribute("href", `/club?id=${fixture.awayTeamId}`, 0)}>${escape(awayTeam ? awayTeam.friendlyName : "")}</a></div>
                <div class="flex flex-col items-center text-xs"><span>${escape(fixture.status === 0 ? "-" : fixture.homeGoals)}</span>
                  <span>${escape(fixture.status === 0 ? "-" : fixture.awayGoals)}</span>
                </div></div>
            </div>`;
    })}
        </div>`;
  })}</div></div></div>`;
});
const AddPlayerIcon = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { className = "" } = $$props;
  let { primaryColour = "#2CE3A6" } = $$props;
  let { secondaryColour = "#777777" } = $$props;
  let { thirdColour = "#FFFFFF" } = $$props;
  if ($$props.className === void 0 && $$bindings.className && className !== void 0)
    $$bindings.className(className);
  if ($$props.primaryColour === void 0 && $$bindings.primaryColour && primaryColour !== void 0)
    $$bindings.primaryColour(primaryColour);
  if ($$props.secondaryColour === void 0 && $$bindings.secondaryColour && secondaryColour !== void 0)
    $$bindings.secondaryColour(secondaryColour);
  if ($$props.thirdColour === void 0 && $$bindings.thirdColour && thirdColour !== void 0)
    $$bindings.thirdColour(thirdColour);
  return `<svg xmlns="http://www.w3.org/2000/svg"${add_attribute("class", className, 0)} fill="currentColor" viewBox="0 0 86 88"><g filter="url(#filter0_d_354_581)"><path d="M65.9308 38.3253L63.5966 33.0215L63.642 33.2129C63.5966 34.2107 63.5603 35.2633 63.533 36.366C63.4831 38.3299 63.4604 40.4442 63.4604 42.6587C63.4604 54.9386 64.1597 70.308 64.8727 79.9999H21.1266C21.835 70.2989 22.5389 54.9159 22.5389 42.6313C22.5389 40.4214 22.5162 38.3162 22.4663 36.3569C22.439 35.2542 22.4027 34.2062 22.3573 33.2129L22.3982 33.0215L20.0685 38.3253L9.30566 33.3131L20.5453 10.6213L20.5862 10.5438L20.6271 10.4573C20.6271 10.4573 31.6578 6.72087 32.0166 6.3609C32.0983 6.27889 32.2346 6.09662 32.3935 5.86424C34.2554 8.43871 36.6668 10.6122 39.4688 12.2252C40.2726 12.69 41.1037 13.1046 41.971 13.4737C42.3026 13.615 42.6432 13.7517 42.9883 13.8747V13.8838C42.9883 13.8838 42.9928 13.8838 42.9974 13.8793C43.0019 13.8838 43.0065 13.8838 43.011 13.8838V13.8747C43.3516 13.7517 43.6922 13.615 44.0237 13.4737C44.8865 13.1092 45.7267 12.69 46.5305 12.2252C49.3324 10.6122 51.7439 8.43871 53.6058 5.85968C53.7647 6.09662 53.901 6.27889 53.9827 6.3609C54.3415 6.72087 65.3722 10.4573 65.3722 10.4573L65.4131 10.5438L65.454 10.6213L76.6891 33.3131L65.9308 38.3253Z"${add_attribute("fill", primaryColour, 0)}></path><path d="M51.2756 3.04364C51.1348 3.26691 50.985 3.48563 50.8351 3.69979C49.0504 6.26059 46.7298 8.43864 44.0232 10.0881C43.6917 10.2932 43.3556 10.4845 43.0105 10.6714C43.0105 10.6714 43.0059 10.6759 43.0014 10.6759C42.9969 10.6759 42.9923 10.6714 42.9878 10.6714C42.6426 10.4845 42.302 10.2886 41.9705 10.0836C39.2685 8.43864 36.9479 6.26059 35.1632 3.69979C35.0133 3.48563 34.8634 3.26691 34.7227 3.04364H51.2756Z"${add_attribute("fill", secondaryColour, 0)}></path><path d="M68.5512 8.58005L68.265 8.00136C68.265 8.00136 68.2514 7.99681 68.2287 7.98769C67.5294 7.75075 57.3478 4.29686 55.1726 3.35365C54.9546 3.25796 54.8138 3.18505 54.7775 3.1486C54.7502 3.12126 54.7184 3.08936 54.6866 3.0438C54.2416 2.49701 53.1699 0.715384 52.8429 0.164037C52.7793 0.0592356 52.743 0 52.743 0H33.2564C33.2564 0 33.22 0.0592356 33.1565 0.164037C32.8295 0.715384 31.7578 2.49701 31.3173 3.0438C31.2809 3.08936 31.2491 3.12126 31.2219 3.1486C31.1856 3.18505 31.0448 3.25796 30.8223 3.35365C28.6424 4.29686 18.4654 7.75075 17.7706 7.98769C17.7479 7.99681 17.7343 8.00136 17.7343 8.00136L17.4482 8.5846L4.33301 35.0629L18.5835 41.7019L20.0685 38.3254L9.3057 33.3132L20.5454 10.6214L20.5862 10.5439L20.6271 10.4574C20.6271 10.4574 31.6578 6.72096 32.0166 6.36099C32.0984 6.27897 32.2346 6.09671 32.3935 5.86432C34.2555 8.43879 36.6669 10.6123 39.4688 12.2253C40.2726 12.6901 41.1037 13.1047 41.9711 13.4738C42.3026 13.6151 42.6432 13.7518 42.9883 13.8748C42.9883 13.8748 42.9914 13.8763 42.9974 13.8794C42.9974 13.8794 43.0065 13.8794 43.011 13.8748C43.3516 13.7518 43.6922 13.6151 44.0237 13.4738C44.8866 13.1093 45.7267 12.6901 46.5305 12.2253C49.3325 10.6123 51.7439 8.43879 53.6058 5.85977C53.7648 6.09671 53.901 6.27897 53.9827 6.36099C54.3415 6.72096 65.3723 10.4574 65.3723 10.4574L65.4131 10.5439L65.454 10.6214L76.6891 33.3132L65.9308 38.3254L67.4158 41.7019L81.6663 35.0629L68.5512 8.58005ZM50.8356 3.69995C49.0509 6.26075 46.7303 8.43879 44.0237 10.0883C43.6922 10.2933 43.3562 10.4847 43.011 10.6715V10.6806H43.0019C42.9974 10.6806 42.9929 10.6806 42.9883 10.6806V10.6715C42.6432 10.4847 42.3026 10.2888 41.9711 10.0837C39.269 8.43879 36.9484 6.26075 35.1637 3.69995C35.0138 3.48579 34.864 3.26707 34.7232 3.0438H51.2761C51.1354 3.26707 50.9855 3.48579 50.8356 3.69995Z"${add_attribute("fill", thirdColour, 0)}></path></g><g transform="translate(36 30)"><path d="M16 6.66667H9.33333V0H6.66667V6.66667H0V9.33333H6.66667V16H9.33333V9.33333H16V6.66667Z" fill="#FFFFF"></path></g><defs><filter id="filter0_d_354_581" x="0.333008" y="0" width="85.333" height="87.9999" filterUnits="userSpaceOnUse"><feFlood flood-opacity="0" result="BackgroundImageFix"></feFlood><feColorMatrix in="SourceAlpha" type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0" result="hardAlpha"></feColorMatrix><feOffset dy="4"></feOffset><feGaussianBlur stdDeviation="2"></feGaussianBlur><feComposite in2="hardAlpha" operator="out"></feComposite><feColorMatrix type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.25 0"></feColorMatrix><feBlend mode="normal" in2="BackgroundImageFix" result="effect1_dropShadow_354_581"></feBlend><feBlend mode="normal" in="SourceGraphic" in2="effect1_dropShadow_354_581" result="shape"></feBlend></filter></defs></svg>`;
});
const RemovePlayerIcon = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { className = "" } = $$props;
  if ($$props.className === void 0 && $$bindings.className && className !== void 0)
    $$bindings.className(className);
  return `<svg xmlns="http://www.w3.org/2000/svg"${add_attribute("class", className, 0)} fill="currentColor" viewBox="0 0 16 16"><path d="M14.5979 8.93594L14.6033 8.89794V8.89927C14.6193 8.7806 14.6326 8.66127 14.6419 8.54127C14.6579 8.33994 14.5159 8.0006 14.1426 8.0006C13.8819 8.0006 13.6659 8.2006 13.6446 8.4606C13.6326 8.60794 13.6153 8.75394 13.5926 8.89794C13.1626 11.5986 10.8206 13.6666 7.99859 13.6666C5.97392 13.6666 4.19592 12.6019 3.19459 11.0033L4.52192 10.9999C4.79792 10.9999 5.02192 10.7759 5.02192 10.4999C5.02192 10.2239 4.79792 9.99994 4.52192 9.99994H1.83325C1.55725 9.99994 1.33325 10.2239 1.33325 10.4999V13.1993C1.33325 13.4753 1.55725 13.6993 1.83325 13.6993C2.10925 13.6993 2.33325 13.4759 2.33325 13.1993L2.33525 11.5159C3.51192 13.4066 5.60925 14.6666 7.99859 14.6666C11.3599 14.6666 14.1433 12.1726 14.5979 8.93594ZM1.41525 6.95327L1.40925 6.9906V6.98927C1.38592 7.1446 1.36725 7.30194 1.35459 7.46127C1.33859 7.6626 1.48059 8.00194 1.85392 8.00194C2.11459 8.00194 2.33059 7.80194 2.35192 7.54194C2.36659 7.35527 2.39059 7.17127 2.42325 6.9906C2.90059 4.34527 5.21592 2.33594 7.99792 2.33594C10.0226 2.33594 11.8006 3.4006 12.8019 4.99927L11.4746 5.0026C11.1986 5.0026 10.9746 5.2266 10.9746 5.5026C10.9746 5.7786 11.1986 6.0026 11.4746 6.0026H14.1633C14.4393 6.0026 14.6633 5.7786 14.6633 5.5026V2.80327C14.6633 2.52727 14.4393 2.30327 14.1633 2.30327C13.8873 2.30327 13.6633 2.5266 13.6633 2.80327L13.6613 4.4866C12.4846 2.59594 10.3873 1.33594 7.99792 1.33594C4.67525 1.33594 1.91792 3.77194 1.41525 6.95327Z" fill="white"></path></svg>`;
});
const PlayerCaptainIcon = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { className = "" } = $$props;
  if ($$props.className === void 0 && $$bindings.className && className !== void 0)
    $$bindings.className(className);
  return `<svg xmlns="http://www.w3.org/2000/svg"${add_attribute("class", className, 0)} fill="currentColor" viewBox="0 0 23 22"><circle cx="11.5" cy="11" r="11" fill="#242529" fill-opacity="0.9"></circle><path transform="translate(4.7,4) scale(0.8,0.8)" d="M8.39289 1.61501C8.47689 1.44234 8.65289 1.33301 8.84489 1.33301C9.03756 1.33301 9.21289 1.44234 9.29689 1.61501C9.94622 2.94701 11.0636 5.24167 11.0636 5.24167C11.0636 5.24167 13.6042 5.59101 15.0782 5.79434C15.3469 5.83101 15.5116 6.05834 15.5116 6.29234C15.5116 6.41901 15.4636 6.54767 15.3576 6.64967C14.2842 7.67501 12.4362 9.44368 12.4362 9.44368C12.4362 9.44368 12.8876 11.955 13.1489 13.4117C13.2042 13.7197 12.9656 13.9997 12.6542 13.9997C12.5729 13.9997 12.4916 13.9803 12.4176 13.9403C11.1056 13.2417 8.84489 12.0397 8.84489 12.0397C8.84489 12.0397 6.58422 13.2417 5.27222 13.9403C5.19822 13.9803 5.11622 13.9997 5.03489 13.9997C4.72489 13.9997 4.48489 13.719 4.54089 13.4117C4.80289 11.955 5.25422 9.44368 5.25422 9.44368C5.25422 9.44368 3.40556 7.67501 2.33289 6.64967C2.22622 6.54767 2.17822 6.41901 2.17822 6.29301C2.17822 6.05834 2.34422 5.83034 2.61222 5.79434C4.08622 5.59101 6.62622 5.24167 6.62622 5.24167C6.62622 5.24167 7.74422 2.94701 8.39289 1.61501ZM8.84489 2.97034L7.27089 6.16501L3.77356 6.64434L6.33889 9.07301L5.70689 12.5763L8.84489 10.9063L11.9829 12.5763L11.3489 9.08567L13.9162 6.64434L10.3736 6.14034L8.84489 2.97034Z" fill="#2CE3A6"></path></svg>`;
});
const ActiveCaptainIcon = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { className = "" } = $$props;
  if ($$props.className === void 0 && $$bindings.className && className !== void 0)
    $$bindings.className(className);
  return `<svg xmlns="http://www.w3.org/2000/svg"${add_attribute("class", className, 0)} fill="currentColor" viewBox="0 0 23 22"><circle cx="11.5" cy="11" r="11" fill="#242529" fillopacity="0.9"></circle><path transform="translate(4.7,4) scale(0.8,0.8)" d="M8.39289 1.61501C8.47689 1.44234 8.65289 1.33301 8.84489 1.33301C9.03756 1.33301 9.21289 1.44234 9.29689 1.61501C9.94622 2.94701 11.0636 5.24167 11.0636 5.24167C11.0636 5.24167 13.6042 5.59101 15.0782 5.79434C15.3469 5.83101 15.5116 6.05834 15.5116 6.29234C15.5116 6.41901 15.4636 6.54767 15.3576 6.64967C14.2842 7.67501 12.4362 9.44368 12.4362 9.44368C12.4362 9.44368 12.8876 11.955 13.1489 13.4117C13.2042 13.7197 12.9656 13.9997 12.6542 13.9997C12.5729 13.9997 12.4916 13.9803 12.4176 13.9403C11.1056 13.2417 8.84489 12.0397 8.84489 12.0397C8.84489 12.0397 6.58422 13.2417 5.27222 13.9403C5.19822 13.9803 5.11622 13.9997 5.03489 13.9997C4.72489 13.9997 4.48489 13.719 4.54089 13.4117C4.80289 11.955 5.25422 9.44368 5.25422 9.44368C5.25422 9.44368 3.40556 7.67501 2.33289 6.64967C2.22622 6.54767 2.17822 6.41901 2.17822 6.29301C2.17822 6.05834 2.34422 5.83034 2.61222 5.79434C4.08622 5.59101 6.62622 5.24167 6.62622 5.24167C6.62622 5.24167 7.74422 2.94701 8.39289 1.61501Z" fill="#2CE3A6"></path></svg>`;
});
function getGridSetup(formation) {
  const formationSplits = formation.split("-").map(Number);
  const setups = [[1], ...formationSplits.map((s) => Array(s).fill(0).map((_, i) => i + 1))];
  return setups;
}
function isBonusConditionMet(team) {
  if (!team) {
    return false;
  }
  const gameweekCounts = {};
  const bonusGameweeks = [
    team.hatTrickHeroGameweek,
    team.teamBoostGameweek,
    team.captainFantasticGameweek,
    team.braceBonusGameweek,
    team.passMasterGameweek,
    team.goalGetterGameweek,
    team.noEntryGameweek,
    team.safeHandsGameweek
  ];
  for (const gw of bonusGameweeks) {
    if (gw !== 0) {
      gameweekCounts[gw] = (gameweekCounts[gw] || 0) + 1;
      if (gameweekCounts[gw] > 1) {
        return false;
      }
    }
  }
  return true;
}
function isValidFormation(players, team, selectedFormation) {
  const positionCounts = { 0: 0, 1: 0, 2: 0, 3: 0 };
  team.playerIds.forEach((id) => {
    const teamPlayer = players.find((p) => p.id === id);
    if (teamPlayer) {
      positionCounts[teamPlayer.position]++;
    }
  });
  const [def, mid, fwd] = selectedFormation.split("-").map(Number);
  const minDef = Math.max(0, def - (positionCounts[1] || 0));
  const minMid = Math.max(0, mid - (positionCounts[2] || 0));
  const minFwd = Math.max(0, fwd - (positionCounts[3] || 0));
  const minGK = Math.max(0, 1 - (positionCounts[0] || 0));
  const additionalPlayersNeeded = minDef + minMid + minFwd + minGK;
  const totalPlayers = Object.values(positionCounts).reduce((a, b) => a + b, 0);
  return totalPlayers + additionalPlayersNeeded <= 11;
}
const Page = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let gridSetup;
  let isSaveButtonActive;
  let $fantasyTeam, $$unsubscribe_fantasyTeam;
  let $transfersAvailable, $$unsubscribe_transfersAvailable;
  let $bankBalance, $$unsubscribe_bankBalance;
  let $availableFormations, $$unsubscribe_availableFormations;
  const formations = {
    "3-4-3": {
      positions: [0, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3]
    },
    "3-5-2": {
      positions: [0, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3]
    },
    "4-3-3": {
      positions: [0, 1, 1, 1, 1, 2, 2, 2, 3, 3, 3]
    },
    "4-4-2": {
      positions: [0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3]
    },
    "4-5-1": {
      positions: [0, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3]
    },
    "5-4-1": {
      positions: [0, 1, 1, 1, 1, 1, 2, 2, 2, 2, 3]
    },
    "5-3-2": {
      positions: [0, 1, 1, 1, 1, 1, 2, 2, 2, 3, 3]
    }
  };
  const availableFormations = writable(["3-4-3", "3-5-2", "4-3-3", "4-4-2", "4-5-1", "5-4-1", "5-3-2"]);
  $$unsubscribe_availableFormations = subscribe(availableFormations, (value) => $availableFormations = value);
  let activeSeason = "-";
  let activeGameweek = -1;
  let nextFixtureDate = "-";
  let nextFixtureTime = "-";
  let countdownDays = "00";
  let countdownHours = "00";
  let countdownMinutes = "00";
  let selectedFormation = "4-4-2";
  let selectedPosition = -1;
  let selectedColumn = -1;
  let showAddPlayer = false;
  let teamValue = 0;
  let teams;
  let players;
  let sessionAddedPlayers = [];
  const fantasyTeam = writable(null);
  $$unsubscribe_fantasyTeam = subscribe(fantasyTeam, (value) => $fantasyTeam = value);
  const transfersAvailable = writable(Infinity);
  $$unsubscribe_transfersAvailable = subscribe(transfersAvailable, (value) => $transfersAvailable = value);
  const bankBalance = writable(1200);
  $$unsubscribe_bankBalance = subscribe(bankBalance, (value) => $bankBalance = value);
  function closeAddPlayerModal() {
    showAddPlayer = false;
  }
  function handlePlayerSelection(player) {
    const currentFantasyTeam = get_store_value(fantasyTeam);
    if (currentFantasyTeam) {
      if (canAddPlayerToCurrentFormation(player, currentFantasyTeam, selectedFormation)) {
        addPlayerToTeam(player, currentFantasyTeam, selectedFormation);
      } else {
        const newFormation = findValidFormationWithPlayer(currentFantasyTeam, player);
        repositionPlayersForNewFormation(currentFantasyTeam, newFormation);
        selectedFormation = newFormation;
        addPlayerToTeam(player, currentFantasyTeam, newFormation);
      }
      bankBalance.update((n) => n - Number(player.value) > 0 ? n - Number(player.value) : n);
      if (!currentFantasyTeam.playerIds.includes(player.id)) {
        sessionAddedPlayers.push(player.id);
      }
    }
  }
  function canAddPlayerToCurrentFormation(player, team, formation) {
    const positionCounts = { 0: 0, 1: 0, 2: 0, 3: 0 };
    team.playerIds.forEach((id) => {
      const teamPlayer = players.find((p) => p.id === id);
      if (teamPlayer) {
        positionCounts[teamPlayer.position]++;
      }
    });
    positionCounts[player.position]++;
    const [def, mid, fwd] = formation.split("-").map(Number);
    const minDef = Math.max(0, def - (positionCounts[1] || 0));
    const minMid = Math.max(0, mid - (positionCounts[2] || 0));
    const minFwd = Math.max(0, fwd - (positionCounts[3] || 0));
    const minGK = Math.max(0, 1 - (positionCounts[0] || 0));
    const additionalPlayersNeeded = minDef + minMid + minFwd + minGK;
    const totalPlayers = Object.values(positionCounts).reduce((a, b) => a + b, 0);
    return totalPlayers + additionalPlayersNeeded <= 11;
  }
  function addPlayerToTeam(player, team, formation) {
    const indexToAdd = getAvailablePositionIndex(player.position, team, formation);
    if (indexToAdd === -1) {
      console.error("No available position to add the player.");
      return;
    }
    fantasyTeam.update((currentTeam) => {
      if (!currentTeam)
        return null;
      const newPlayerIds = Uint16Array.from(currentTeam.playerIds);
      if (indexToAdd < newPlayerIds.length) {
        newPlayerIds[indexToAdd] = player.id;
        return { ...currentTeam, playerIds: newPlayerIds };
      } else {
        console.error("Index out of bounds when attempting to add player to team.");
        return currentTeam;
      }
    });
    updateCaptainIfNeeded(get_store_value(fantasyTeam));
  }
  function getAvailablePositionIndex(position, team, formation) {
    const formationArray = formations[formation].positions;
    for (let i = 0; i < formationArray.length; i++) {
      if (formationArray[i] === position && team.playerIds[i] === 0) {
        return i;
      }
    }
    return -1;
  }
  function findValidFormationWithPlayer(team, player) {
    const positionCounts = { 0: 1, 1: 0, 2: 0, 3: 0 };
    team.playerIds.forEach((id) => {
      const teamPlayer = players.find((p) => p.id === id);
      if (teamPlayer) {
        positionCounts[teamPlayer.position]++;
      }
    });
    positionCounts[player.position]++;
    let bestFitFormation = null;
    let minimumAdditionalPlayersNeeded = Number.MAX_SAFE_INTEGER;
    for (const formation of Object.keys(formations)) {
      if (formation === selectedFormation) {
        continue;
      }
      const formationPositions = formations[formation].positions;
      let formationDetails = { 0: 0, 1: 0, 2: 0, 3: 0 };
      formationPositions.forEach((pos) => {
        formationDetails[pos]++;
      });
      const additionalPlayersNeeded = Object.keys(formationDetails).reduce(
        (total, key) => {
          const position = parseInt(key);
          return total + Math.max(0, formationDetails[position] - positionCounts[position]);
        },
        0
      );
      if (additionalPlayersNeeded < minimumAdditionalPlayersNeeded && formationDetails[player.position] > positionCounts[player.position] - 1) {
        bestFitFormation = formation;
        minimumAdditionalPlayersNeeded = additionalPlayersNeeded;
      }
    }
    if (bestFitFormation) {
      return bestFitFormation;
    }
    console.error("No valid formation found for the player");
    return selectedFormation;
  }
  function repositionPlayersForNewFormation(team, newFormation) {
    const newFormationArray = formations[newFormation].positions;
    let newPlayerIds = new Array(11).fill(0);
    team.playerIds.forEach((playerId) => {
      const player = players.find((p) => p.id === playerId);
      if (player) {
        for (let i = 0; i < newFormationArray.length; i++) {
          if (newFormationArray[i] === player.position && newPlayerIds[i] === 0) {
            newPlayerIds[i] = playerId;
            break;
          }
        }
      }
    });
    team.playerIds = newPlayerIds;
  }
  function getActualIndex(rowIndex, colIndex) {
    let startIndex = gridSetup.slice(0, rowIndex).reduce((sum, currentRow) => sum + currentRow.length, 0);
    return startIndex + colIndex;
  }
  function setCaptain(playerId) {
    selectedPosition = -1;
    selectedColumn = -1;
    fantasyTeam.update((currentTeam) => {
      if (!currentTeam)
        return null;
      return { ...currentTeam, captainId: playerId };
    });
  }
  function updateCaptainIfNeeded(currentTeam) {
    if (!currentTeam.captainId || currentTeam.captainId === 0 || !currentTeam.playerIds.includes(currentTeam.captainId)) {
      const newCaptainId = getHighestValuedPlayerId(currentTeam);
      setCaptain(newCaptainId);
    }
  }
  function getHighestValuedPlayerId(team) {
    let highestValue = 0;
    let highestValuedPlayerId = 0;
    team.playerIds.forEach((playerId) => {
      const player = players.find((p) => p.id === playerId);
      if (player && Number(player.value) > highestValue) {
        highestValue = Number(player.value);
        highestValuedPlayerId = playerId;
      }
    });
    return highestValuedPlayerId;
  }
  function checkSaveButtonConditions() {
    const teamCount = /* @__PURE__ */ new Map();
    for (const playerId of $fantasyTeam?.playerIds || []) {
      if (playerId > 0) {
        const player = players.find((p) => p.id === playerId);
        if (player) {
          teamCount.set(player.teamId, (teamCount.get(player.teamId) || 0) + 1);
          if (teamCount.get(player.teamId) > 1) {
            return false;
          }
        }
      }
    }
    if (!isBonusConditionMet($fantasyTeam)) {
      return false;
    }
    if ($fantasyTeam?.playerIds.filter((id) => id > 0).length !== 11) {
      return false;
    }
    if ($bankBalance < 0) {
      return false;
    }
    if ($transfersAvailable < 0) {
      return false;
    }
    if (!isValidFormation(players, $fantasyTeam, selectedFormation)) {
      return false;
    }
    return true;
  }
  gridSetup = getGridSetup(selectedFormation);
  isSaveButtonActive = checkSaveButtonConditions();
  $$unsubscribe_fantasyTeam();
  $$unsubscribe_transfersAvailable();
  $$unsubscribe_bankBalance();
  $$unsubscribe_availableFormations();
  return `${validate_component(Layout, "Layout").$$render($$result, {}, {}, {
    default: () => {
      return `${validate_component(Add_player_modal, "AddPlayerModal").$$render(
        $$result,
        {
          handlePlayerSelection,
          filterPosition: selectedPosition,
          filterColumn: selectedColumn,
          showAddPlayer,
          closeAddPlayerModal,
          fantasyTeam,
          bankBalance
        },
        {},
        {}
      )}
  <div class="m-4"><div class="flex flex-col md:flex-row"><div class="flex flex-col md:flex-row justify-start md:items-center text-white space-x-0 md:space-x-4 flex-grow m-4 bg-panel p-4 rounded-md"><div class="flex-grow mb-4 md:mb-0"><p class="text-gray-300 text-xs">Gameweek</p>
          <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">${escape(activeGameweek)}</p>
          <p class="text-gray-300 text-xs">${escape(activeSeason)}</p></div>

        <div class="h-px bg-gray-400 w-full md:w-px md:h-full md:self-stretch" style="min-height: 2px; min-width: 2px;"></div>

        <div class="flex-grow mb-4 md:mb-0"><p class="text-gray-300 text-xs mt-4 md:mt-0">Kick Off:</p>
          <div class="flex"><p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">${escape(countdownDays)}<span class="text-gray-300 text-xs ml-1">d</span>
              : ${escape(countdownHours)}<span class="text-gray-300 text-xs ml-1">h</span>
              : ${escape(countdownMinutes)}<span class="text-gray-300 text-xs ml-1">m</span></p></div>
          <p class="text-gray-300 text-xs">${escape(nextFixtureDate)} | ${escape(nextFixtureTime)}</p></div>

        <div class="h-px bg-gray-400 w-full md:w-px md:h-full md:self-stretch" style="min-height: 2px; min-width: 2px;"></div>

        <div class="flex-grow mb-4 md:mb-0 mt-4 md:mt-0"><p class="text-gray-300 text-xs">Players</p>
          <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">${escape($fantasyTeam?.playerIds.filter((x) => x > 0).length)}/11
          </p>
          <p class="text-gray-300 text-xs">Selected</p></div></div>

      <div class="flex justify-start items-center text-white space-x-4 flex-grow m-4 bg-panel p-4 rounded-md"><div class="flex-grow"><p class="text-gray-300 text-xs">Team Value</p>
          <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">£${escape(teamValue.toFixed(2))}m
          </p>
          <p class="text-gray-300 text-xs">GBP</p></div>
        <div class="flex-shrink-0 w-px bg-gray-400 self-stretch" style="min-width: 2px; min-height: 50px;"></div>
        <div class="flex-grow"><p class="text-gray-300 text-xs">Bank Balance</p>
          <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">£${escape(($bankBalance / 4).toFixed(2))}m
          </p>
          <p class="text-gray-300 text-xs">GBP</p></div>
        <div class="flex-shrink-0 w-px bg-gray-400 self-stretch" style="min-width: 2px; min-height: 50px;"></div>
        <div class="flex-grow"><p class="text-gray-300 text-xs">Transfers</p>
          <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">${escape($transfersAvailable === Infinity ? "Unlimited" : $transfersAvailable)}</p>
          <p class="text-gray-300 text-xs">Available</p></div></div></div>

    <div class="flex flex-col md:flex-row"><div class="flex flex-col md:flex-row justify-between items-center text-white m-4 bg-panel p-4 rounded-md md:w-full"><div class="flex flex-row justify-between md:justify-start flex-grow mb-2 md:mb-0 ml-4 order-3 md:order-1"><button${add_attribute("class", `btn ${`fpl-button`} px-4 py-2 rounded-l-md font-bold text-md min-w-[125px] my-4`, 0)}>Pitch View
          </button>
          <button${add_attribute("class", `btn ${`inactive-btn`} px-4 py-2 rounded-r-md font-bold text-md min-w-[125px] my-4`, 0)}>List View
          </button></div>

        <div class="text-center md:text-left w-full mt-4 md:mt-0 md:ml-8 order-2"><span class="text-lg">Formation:
            <select class="p-2 fpl-dropdown text-lg text-center">${each($availableFormations, (formation) => {
        return `<option${add_attribute("value", formation, 0)}>${escape(formation)}</option>`;
      })}</select></span></div>

        <div class="flex flex-col md:flex-row w-full md:justify-end gap-4 mr-0 md:mr-4 order-1 md:order-3"><button ${($fantasyTeam?.playerIds ? $fantasyTeam?.playerIds.filter((x) => x === 0).length === 0 : true) ? "disabled" : ""}${add_attribute(
        "class",
        `btn w-full md:w-auto px-4 py-2 rounded ${$fantasyTeam?.playerIds && $fantasyTeam?.playerIds.filter((x) => x === 0).length > 0 ? "fpl-purple-btn" : "bg-gray-500"} text-white min-w-[125px]`,
        0
      )}>Auto Fill
          </button>
          <button ${isSaveButtonActive ? "disabled" : ""}${add_attribute("class", `btn w-full md:w-auto px-4 py-2 rounded  ${isSaveButtonActive ? "fpl-purple-btn" : "bg-gray-500"} text-white min-w-[125px]`, 0)}>Save Team
          </button></div></div></div>

    <div class="flex flex-col md:flex-row">${`<div class="relative w-full md:w-1/2 mt-4"><img src="pitch.png" alt="pitch" class="w-full">
          <div class="absolute top-0 left-0 right-0 bottom-0"><div${add_attribute("class", `flex justify-around w-full h-auto`, 0)}><div class="relative inline-block"><img class="h-6 md:h-12 m-0 md:m-1" src="board.png" alt="OpenChat">
                <div class="absolute top-0 left-0 w-full h-full"><a class="flex items-center justify-center w-full h-full px-2 md:px-4 ml-1 md:ml-0" target="_blank" href="https://oc.app/community/uf3iv-naaaa-aaaar-ar3ta-cai/channel/231651284198326210763327878874377361028/?ref=zv6hh-xaaaa-aaaar-ac35q-cai">${validate_component(OpenChatIcon, "OpenChatIcon").$$render($$result, { className: "h-4 md:h-6 mr-1 md:mr-2" }, {}, {})}
                    <span class="text-white text-xs md:text-xl mr-4 oc-logo">OpenChat</span></a></div></div>
              <div class="relative inline-block"><img class="h-6 md:h-12 m-0 md:m-1" src="board.png" alt="OpenChat">
                <div class="absolute top-0 left-0 w-full h-full"><a class="flex items-center justify-center w-full h-full px-2 md:px-4 ml-1 md:ml-0" target="_blank" href="https://oc.app/community/uf3iv-naaaa-aaaar-ar3ta-cai/channel/231651284198326210763327878874377361028/?ref=zv6hh-xaaaa-aaaar-ac35q-cai">${validate_component(OpenChatIcon, "OpenChatIcon").$$render($$result, { className: "h-4 md:h-6 mr-1 md:mr-2" }, {}, {})}
                    <span class="text-white text-xs md:text-xl mr-4 oc-logo">OpenChat</span></a></div></div></div>
            ${each(gridSetup, (row, rowIndex) => {
        return `<div class="flex justify-around items-center w-full">${each(row, (_, colIndex) => {
          let actualIndex = getActualIndex(rowIndex, colIndex), playerIds = $fantasyTeam?.playerIds ?? [], playerId = playerIds[actualIndex], player = players.find((p) => p.id === playerId);
          return `
                  
                  
                  
                  <div class="flex flex-col justify-center items-center flex-1">${playerId > 0 && player ? (() => {
            let team = teams.find((x) => x.id === player.teamId);
            return `
                      <div class="mt-2 mb-2 md:mb-12 flex flex-col items-center text-center"><div class="flex justify-center items-center"><div class="flex justify-between items-end w-full"><button class="bg-red-600 mb-1 rounded-sm">${validate_component(RemovePlayerIcon, "RemovePlayerIcon").$$render($$result, { className: "w-5 h-5 p-1" }, {}, {})}</button>
                            <div class="flex justify-center items-center flex-grow">${validate_component(ShirtIcon, "ShirtIcon").$$render(
              $$result,
              {
                className: "h-16",
                primaryColour: team?.primaryColourHex,
                secondaryColour: team?.secondaryColourHex,
                thirdColour: team?.thirdColourHex
              },
              {},
              {}
            )}</div>
                            ${$fantasyTeam?.captainId === playerId ? `<span class="mb-1">${validate_component(ActiveCaptainIcon, "ActiveCaptainIcon").$$render($$result, { className: "w-6 h-6" }, {}, {})}
                              </span>` : `<button class="mb-1">${validate_component(PlayerCaptainIcon, "PlayerCaptainIcon").$$render($$result, { className: "w-6 h-6" }, {}, {})}
                              </button>`}
                          </div></div>
                        <div class="flex flex-col justify-center items-center text-xs"><div class="flex justify-center items-center bg-gray-700 px-2 py-1 rounded-t-md min-w-[100px]"><p class="min-w-[20px]">${escape(getPositionAbbreviation(player.position))}</p>
                            ${validate_component(getFlagComponent(player.nationality) || missing_component, "svelte:component").$$render($$result, { class: "h-4 w-4 ml-2 mr-2 min-w-[15px]" }, {}, {})}
                            <p class="truncate min-w-[60px] max-w-[60px]">${escape(player.firstName.length > 2 ? player.firstName.substring(0, 1) + "." : "")}
                              ${escape(player.lastName)}
                            </p></div>
                          <div class="flex justify-center items-center bg-white text-black px-2 py-1 rounded-b-md min-w-[100px]"><p class="min-w-[20px]">${escape(team?.abbreviatedName)}</p>
                            ${validate_component(BadgeIcon, "BadgeIcon").$$render(
              $$result,
              {
                className: "h-4 w-4 mr-2 ml-2 min-w-[15px]",
                primaryColour: team?.primaryColourHex,
                secondaryColour: team?.secondaryColourHex,
                thirdColour: team?.thirdColourHex
              },
              {},
              {}
            )}
                            <p class="truncate min-w-[60px] max-w-[60px]">£${escape((Number(player.value) / 4).toFixed(2))}m
                            </p>
                          </div></div>
                      </div>`;
          })() : `<button>${validate_component(AddPlayerIcon, "AddPlayerIcon").$$render(
            $$result,
            {
              className: "h-12 md:h-16 mt-2 mb-2 md:mb-24"
            },
            {},
            {}
          )}
                      </button>`}
                  </div>`;
        })}
              </div>`;
      })}</div></div>`}
      <div class="flex w-100 md:w-1/2">${validate_component(Simple_fixtures, "SimpleFixtures").$$render($$result, {}, {}, {})}</div></div>
    ${validate_component(Bonus_panel, "BonusPanel").$$render(
        $$result,
        {
          fantasyTeam,
          teams,
          players,
          activeGameweek
        },
        {},
        {}
      )}</div>`;
    }
  })}`;
});
export {
  Page as default
};
