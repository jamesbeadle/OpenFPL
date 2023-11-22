import { c as create_ssr_component, v as validate_component } from "../../../chunks/index2.js";
import { S as SystemService, T as TeamService, F as FixtureService } from "../../../chunks/TeamService.js";
import { M as ManagerService } from "../../../chunks/ManagerService.js";
import { L as Layout } from "../../../chunks/Layout.js";
import { L as LoadingIcon } from "../../../chunks/LoadingIcon.js";
import "@dfinity/agent";
const useBonusModal_svelte_svelte_type_style_lang = "";
const bonusPanel_svelte_svelte_type_style_lang = "";
const addPlayerModal_svelte_svelte_type_style_lang = "";
const _page_svelte_svelte_type_style_lang = "";
const css = {
  code: ".inactive-btn.svelte-hd1108{background-color:black;color:white}",
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
