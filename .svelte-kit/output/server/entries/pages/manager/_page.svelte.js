import { c as create_ssr_component, a as subscribe, o as onDestroy, v as validate_component } from "../../../chunks/ssr.js";
import { p as page } from "../../../chunks/stores.js";
import { L as Layout } from "../../../chunks/Layout.js";
import "../../../chunks/manager-store.js";
import "@dfinity/utils";
import "dompurify";
import { L as LoadingIcon } from "../../../chunks/LoadingIcon.js";
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
      return `${`${validate_component(LoadingIcon, "LoadingIcon").$$render($$result, {}, {}, {})}`}`;
    }
  })}`;
});
export {
  Page as default
};
