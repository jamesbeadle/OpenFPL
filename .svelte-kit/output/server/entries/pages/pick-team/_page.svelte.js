import { c as create_ssr_component, a as subscribe, o as onDestroy, v as validate_component } from "../../../chunks/index2.js";
import { L as Layout } from "../../../chunks/Layout.js";
import { w as writable } from "../../../chunks/index.js";
import "../../../chunks/system-store.js";
import "../../../chunks/fixture-store.js";
import { g as getAvailableFormations } from "../../../chunks/team-store.js";
import "../../../chunks/player-store.js";
import "../../../chunks/manager-store.js";
const useBonusModal_svelte_svelte_type_style_lang = "";
const bonusPanel_svelte_svelte_type_style_lang = "";
const addPlayerModal_svelte_svelte_type_style_lang = "";
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
const Page = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let $fantasyTeam, $$unsubscribe_fantasyTeam;
  let $players, $$unsubscribe_players;
  let $bankBalance, $$unsubscribe_bankBalance;
  let $transfersAvailable, $$unsubscribe_transfersAvailable;
  let $systemState, $$unsubscribe_systemState;
  let $$unsubscribe_availableFormations;
  let $$unsubscribe_teams;
  const availableFormations = writable(["3-4-3", "3-5-2", "4-3-3", "4-4-2", "4-5-1", "5-4-1", "5-3-2"]);
  $$unsubscribe_availableFormations = subscribe(availableFormations, (value) => value);
  let activeSeason = "-";
  let activeGameweek = -1;
  let selectedFormation = "4-4-2";
  let teams = writable([]);
  $$unsubscribe_teams = subscribe(teams, (value) => value);
  let players = writable([]);
  $$unsubscribe_players = subscribe(players, (value) => $players = value);
  let systemState = writable(null);
  $$unsubscribe_systemState = subscribe(systemState, (value) => $systemState = value);
  const fantasyTeam = writable(null);
  $$unsubscribe_fantasyTeam = subscribe(fantasyTeam, (value) => $fantasyTeam = value);
  const transfersAvailable = writable(Infinity);
  $$unsubscribe_transfersAvailable = subscribe(transfersAvailable, (value) => $transfersAvailable = value);
  const bankBalance = writable(1200);
  $$unsubscribe_bankBalance = subscribe(bankBalance, (value) => $bankBalance = value);
  onDestroy(() => {
  });
  function disableInvalidFormations() {
    if (!$fantasyTeam || !$fantasyTeam.playerIds) {
      return;
    }
    const formations2 = getAvailableFormations($players, $fantasyTeam);
    availableFormations.set(formations2);
  }
  function updateTeamValue() {
    const team = $fantasyTeam;
    if (team) {
      let totalValue = 0;
      team.playerIds.forEach((id) => {
        const player = $players.find((p) => p.id === id);
        if (player) {
          totalValue += Number(player.value);
        }
      });
    }
  }
  function checkSaveButtonConditions() {
    const teamCount = /* @__PURE__ */ new Map();
    for (const playerId of $fantasyTeam?.playerIds || []) {
      if (playerId > 0) {
        const player = $players.find((p) => p.id === playerId);
        if (player) {
          teamCount.set(player.teamId, (teamCount.get(player.teamId) || 0) + 1);
          if (teamCount.get(player.teamId) > 2) {
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
    if (!isValidFormation($fantasyTeam, selectedFormation)) {
      return false;
    }
    return true;
  }
  function isValidFormation(team, selectedFormation2) {
    const positionCounts = { 0: 0, 1: 0, 2: 0, 3: 0 };
    team.playerIds.forEach((id) => {
      const teamPlayer = $players.find((p) => p.id === id);
      if (teamPlayer) {
        positionCounts[teamPlayer.position]++;
      }
    });
    const [def, mid, fwd] = selectedFormation2.split("-").map(Number);
    const minDef = Math.max(0, def - (positionCounts[1] || 0));
    const minMid = Math.max(0, mid - (positionCounts[2] || 0));
    const minFwd = Math.max(0, fwd - (positionCounts[3] || 0));
    const minGK = Math.max(0, 1 - (positionCounts[0] || 0));
    const additionalPlayersNeeded = minDef + minMid + minFwd + minGK;
    const totalPlayers = Object.values(positionCounts).reduce((a, b) => a + b, 0);
    return totalPlayers + additionalPlayersNeeded <= 11;
  }
  getGridSetup(selectedFormation);
  {
    if (players && $fantasyTeam) {
      disableInvalidFormations();
      updateTeamValue();
    }
  }
  $fantasyTeam ? checkSaveButtonConditions() : false;
  {
    {
      if ($systemState) {
        activeSeason = $systemState?.activeSeason.name ?? activeSeason;
        activeGameweek = $systemState?.activeGameweek ?? activeGameweek;
      }
    }
  }
  $$unsubscribe_fantasyTeam();
  $$unsubscribe_players();
  $$unsubscribe_bankBalance();
  $$unsubscribe_transfersAvailable();
  $$unsubscribe_systemState();
  $$unsubscribe_availableFormations();
  $$unsubscribe_teams();
  return `${validate_component(Layout, "Layout").$$render($$result, {}, {}, {
    default: () => {
      return `${``}`;
    }
  })}`;
});
export {
  Page as default
};
