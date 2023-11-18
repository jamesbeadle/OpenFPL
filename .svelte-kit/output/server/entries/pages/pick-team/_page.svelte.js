import { c as create_ssr_component, v as validate_component } from "../../../chunks/index2.js";
import { S as SystemService, F as FixtureService, M as ManagerService, L as LoadingIcon } from "../../../chunks/LoadingIcon.js";
import { T as TeamService } from "../../../chunks/TeamService.js";
import { L as Layout } from "../../../chunks/Layout.js";
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
