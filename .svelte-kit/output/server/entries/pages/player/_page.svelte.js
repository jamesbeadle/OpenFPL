import { c as create_ssr_component, a as subscribe, v as validate_component } from "../../../chunks/index2.js";
import { p as page } from "../../../chunks/stores.js";
import { u as updateTableData, L as Layout, a as LoadingIcon } from "../../../chunks/Layout.js";
const playerGameweekModal_svelte_svelte_type_style_lang = "";
const Page = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let $page, $$unsubscribe_page;
  $$unsubscribe_page = subscribe(page, (value) => $page = value);
  let selectedGameweek = 1;
  let teams = [];
  let fixtures = [];
  let fixturesWithTeams = [];
  Number($page.url.searchParams.get("id"));
  {
    if (fixtures.length > 0 && teams.length > 0) {
      updateTableData(fixturesWithTeams, teams, selectedGameweek);
    }
  }
  $$unsubscribe_page();
  return `${validate_component(Layout, "Layout").$$render($$result, {}, {}, {
    default: () => {
      return `${`${validate_component(LoadingIcon, "LoadingIcon").$$render($$result, {}, {}, {})}`}`;
    }
  })}`;
});
export {
  Page as default
};
