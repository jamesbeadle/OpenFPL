import { c as create_ssr_component, a as subscribe, v as validate_component } from "../../../chunks/index2.js";
import { L as Layout } from "../../../chunks/Layout.js";
import { L as LoadingIcon } from "../../../chunks/LoadingIcon.js";
import { p as page } from "../../../chunks/stores.js";
import "@dfinity/auth-client";
import "@dfinity/utils";
import "@dfinity/agent";
let progress = 0;
const Page = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let $page, $$unsubscribe_page;
  $$unsubscribe_page = subscribe(page, (value) => $page = value);
  $page.url.searchParams.get("id");
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
