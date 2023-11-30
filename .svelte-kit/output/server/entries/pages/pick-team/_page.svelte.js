import "../../../chunks/fixture-store.js";
import { w as writable } from "../../../chunks/index.js";
import {
  a as subscribe,
  c as create_ssr_component,
  o as onDestroy,
  v as validate_component,
} from "../../../chunks/index2.js";
import { L as Layout } from "../../../chunks/Layout.js";
import "../../../chunks/manager-store.js";
import "../../../chunks/player-store.js";
import "../../../chunks/system-store.js";
import "../../../chunks/team-store.js";
const useBonusModal_svelte_svelte_type_style_lang = "";
const bonusPanel_svelte_svelte_type_style_lang = "";
const addPlayerModal_svelte_svelte_type_style_lang = "";
function getGridSetup(formation) {
  const formationSplits = formation.split("-").map(Number);
  const setups = [
    [1],
    ...formationSplits.map((s) =>
      Array(s)
        .fill(0)
        .map((_, i) => i + 1)
    ),
  ];
  return setups;
}
function isBonusConditionMet(team) {
  if (!team) {
    console.log("a");
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
    team.safeHandsGameweek,
  ];
  for (const gw of bonusGameweeks) {
    if (gw !== 0) {
      gameweekCounts[gw] = (gameweekCounts[gw] || 0) + 1;
      if (gameweekCounts[gw] > 1) {
        console.log("b");
        return false;
      }
    }
  }
  return true;
}
function isValidFormation(players2, team, selectedFormation2) {
  const positionCounts = { 0: 0, 1: 0, 2: 0, 3: 0 };
  team.playerIds.forEach((id) => {
    const teamPlayer = players2.find((p) => p.id === id);
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
const Page = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let $fantasyTeam, $$unsubscribe_fantasyTeam;
  let $transfersAvailable, $$unsubscribe_transfersAvailable;
  let $bankBalance, $$unsubscribe_bankBalance;
  let $$unsubscribe_availableFormations;
  const availableFormations = writable([
    "3-4-3",
    "3-5-2",
    "4-3-3",
    "4-4-2",
    "4-5-1",
    "5-4-1",
    "5-3-2",
  ]);
  $$unsubscribe_availableFormations = subscribe(
    availableFormations,
    (value) => value
  );
  let selectedFormation = "4-4-2";
  let players;
  const fantasyTeam = writable(null);
  $$unsubscribe_fantasyTeam = subscribe(
    fantasyTeam,
    (value) => ($fantasyTeam = value)
  );
  const transfersAvailable = writable(Infinity);
  $$unsubscribe_transfersAvailable = subscribe(
    transfersAvailable,
    (value) => ($transfersAvailable = value)
  );
  const bankBalance = writable(1200);
  $$unsubscribe_bankBalance = subscribe(
    bankBalance,
    (value) => ($bankBalance = value)
  );
  onDestroy(() => {});
  function checkSaveButtonConditions() {
    const teamCount = /* @__PURE__ */ new Map();
    for (const playerId of $fantasyTeam?.playerIds || []) {
      if (playerId > 0) {
        const player = players.find((p) => p.id === playerId);
        if (player) {
          teamCount.set(player.teamId, (teamCount.get(player.teamId) || 0) + 1);
          if (teamCount.get(player.teamId) > 2) {
            return false;
          }
        }
      }
    }
    if (!isBonusConditionMet($fantasyTeam)) {
      console.log("2");
      return false;
    }
    if ($fantasyTeam?.playerIds.filter((id) => id > 0).length !== 11) {
      console.log("3");
      return false;
    }
    if ($bankBalance < 0) {
      console.log("4");
      return false;
    }
    if ($transfersAvailable < 0) {
      console.log("5");
      return false;
    }
    if (!isValidFormation(players, $fantasyTeam, selectedFormation)) {
      return false;
    }
    return true;
  }
  getGridSetup(selectedFormation);
  $fantasyTeam ? checkSaveButtonConditions() : false;
  $$unsubscribe_fantasyTeam();
  $$unsubscribe_transfersAvailable();
  $$unsubscribe_bankBalance();
  $$unsubscribe_availableFormations();
  return `${validate_component(Layout, "Layout").$$render(
    $$result,
    {},
    {},
    {
      default: () => {
        return `${``}`;
      },
    }
  )}`;
});
export { Page as default };
