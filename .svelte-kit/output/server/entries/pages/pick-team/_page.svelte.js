import { c as create_ssr_component, v as validate_component } from "../../../chunks/index2.js";
import { S as SystemService, F as FixtureService, L as LoadingIcon } from "../../../chunks/LoadingIcon.js";
import { T as TeamService } from "../../../chunks/TeamService.js";
import { M as ManagerService } from "../../../chunks/ManagerService.js";
import { L as Layout } from "../../../chunks/Layout.js";
const useBonusModal_svelte_svelte_type_style_lang = "";
var BonusType = /* @__PURE__ */ ((BonusType2) => {
  BonusType2[BonusType2["AUTOMATIC"] = 0] = "AUTOMATIC";
  BonusType2[BonusType2["PLAYER"] = 1] = "PLAYER";
  BonusType2[BonusType2["TEAM"] = 2] = "TEAM";
  BonusType2[BonusType2["COUNTRY"] = 3] = "COUNTRY";
  return BonusType2;
})(BonusType || {});
const _page_svelte_svelte_type_style_lang = "";
const css = {
  code: ".inactive-btn.svelte-1jt5xlc{background-color:black;color:white}.bonus-panel-inner.svelte-1jt5xlc{background-color:rgba(46, 50, 58, 0.9)}.bonus-panel.svelte-1jt5xlc{background-color:rgba(46, 50, 58, 0.8)}",
  map: null
};
function getGridSetup(formation) {
  const formationSplits = formation.split("-").map(Number);
  const setups = [[1], ...formationSplits.map((s) => Array(s).fill(0).map((_, i) => i + 1))];
  return setups;
}
const Page = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  new SystemService();
  new TeamService();
  new FixtureService();
  new ManagerService();
  let selectedFormation = "4-4-2";
  let progress = 0;
  [
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
  $$result.css.add(css);
  getGridSetup(selectedFormation);
  return `${validate_component(Layout, "Layout").$$render($$result, {}, {}, {
    default: () => {
      return `${`${validate_component(LoadingIcon, "LoadingIcon").$$render($$result, { progress }, {}, {})}`}`;
    }
  })}`;
});
export {
  Page as default
};
