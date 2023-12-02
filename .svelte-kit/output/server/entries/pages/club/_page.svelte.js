import { c as create_ssr_component, a as subscribe, o as onDestroy, v as validate_component } from "../../../chunks/index2.js";
import { u as updateTableData } from "../../../chunks/team-store.js";
import "../../../chunks/fixture-store.js";
import "../../../chunks/player-store.js";
import { L as Layout } from "../../../chunks/Layout.js";
import { p as page } from "../../../chunks/stores.js";
const Page = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let $page, $$unsubscribe_page;
  $$unsubscribe_page = subscribe(page, (value) => $page = value);
  let teams = [];
  let fixturesWithTeams = [];
  let selectedGameweek = 1;
  onDestroy(() => {
  });
  Number($page.url.searchParams.get("id"));
  {
    if (fixturesWithTeams.length > 0 && teams.length > 0) {
      updateTableData(fixturesWithTeams, teams, selectedGameweek);
    }
  }
  $$unsubscribe_page();
  return `${validate_component(Layout, "Layout").$$render($$result, {}, {}, {
    default: () => {
      return `${``}`;
    }
  })}`;
});
export {
  Page as default
};
