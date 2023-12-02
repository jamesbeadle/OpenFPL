import { c as create_ssr_component, v as validate_component } from "../../chunks/index2.js";
import { L as Layout, a as LoadingIcon } from "../../chunks/Layout.js";
import "../../chunks/manager-store.js";
const _page_svelte_svelte_type_style_lang = "";
const css = {
  code: ".w-v.svelte-18fkfyi{width:20px}",
  map: null
};
const Page = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  $$result.css.add(css);
  return `${validate_component(Layout, "Layout").$$render($$result, {}, {}, {
    default: () => {
      return `${`${validate_component(LoadingIcon, "LoadingIcon").$$render($$result, {}, {}, {})}`}`;
    }
  })}`;
});
export {
  Page as default
};
