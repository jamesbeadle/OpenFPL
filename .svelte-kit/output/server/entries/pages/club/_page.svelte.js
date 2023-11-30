import "../../../chunks/fixture-store.js";
import {
  a as subscribe,
  c as create_ssr_component,
  o as onDestroy,
  v as validate_component,
} from "../../../chunks/index2.js";
import { L as Layout } from "../../../chunks/Layout.js";
import "../../../chunks/player-store.js";
import { p as page } from "../../../chunks/stores.js";
import "../../../chunks/system-store.js";
import { u as updateTableData } from "../../../chunks/team-store.js";
const Page = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let $page, $$unsubscribe_page;
  $$unsubscribe_page = subscribe(page, (value) => ($page = value));
  let teams = [];
  let fixturesWithTeams = [];
  let selectedGameweek = 1;
  onDestroy(() => {});
  Number($page.url.searchParams.get("id"));
  {
    if (fixturesWithTeams.length > 0 && teams.length > 0) {
      updateTableData(fixturesWithTeams, teams, selectedGameweek);
    }
  }
  $$unsubscribe_page();
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
