import { c as create_ssr_component, a as subscribe, o as onDestroy, v as validate_component } from "../../../chunks/index2.js";
import { p as page } from "../../../chunks/stores.js";
import "../../../chunks/team-store.js";
import "../../../chunks/manager-store.js";
import { L as Layout, a as LoadingIcon } from "../../../chunks/Layout.js";
import "../../../chunks/player-store.js";
import "../../../chunks/player-events-store.js";
const Page = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let $page, $$unsubscribe_page;
  $$unsubscribe_page = subscribe(page, (value) => $page = value);
  onDestroy(() => {
  });
  $page.url.searchParams.get("id");
  Number($page.url.searchParams.get("gw")) ?? 0;
  $$unsubscribe_page();
  return `${validate_component(Layout, "Layout").$$render($$result, {}, {}, {
    default: () => {
      return `<div class="m-4">${`${validate_component(LoadingIcon, "LoadingIcon").$$render($$result, {}, {}, {})}`}</div>`;
    }
  })}`;
});
export {
  Page as default
};
