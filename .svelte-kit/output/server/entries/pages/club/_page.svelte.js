import { c as create_ssr_component, a as subscribe, v as validate_component } from "../../../chunks/index2.js";
import { L as Layout } from "../../../chunks/Layout.js";
import { F as FixtureService, S as SystemService, L as LoadingIcon } from "../../../chunks/LoadingIcon.js";
import { T as TeamService, u as updateTableData } from "../../../chunks/TeamService.js";
import { p as page } from "../../../chunks/stores.js";
import { P as PlayerService } from "../../../chunks/PlayerService.js";
let progress = 0;
const Page = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let $page, $$unsubscribe_page;
  $$unsubscribe_page = subscribe(page, (value) => $page = value);
  new FixtureService();
  new TeamService();
  new SystemService();
  new PlayerService();
  let selectedGameweek = 1;
  let fixtures = [];
  let teams = [];
  Number($page.url.searchParams.get("id"));
  {
    if (fixtures.length > 0 && teams.length > 0) {
      updateTableData(fixtures, teams, selectedGameweek);
    }
  }
  $$unsubscribe_page();
  return `${validate_component(Layout, "Layout").$$render($$result, {}, {}, {
    default: () => {
      return `${`${validate_component(LoadingIcon, "LoadingIcon").$$render($$result, { progress }, {}, {})}`}`;
    }
  })}`;
});
export {
  Page as default
};
