import { c as create_ssr_component, o as onDestroy, v as validate_component } from "../../../chunks/ssr.js";
import { L as Layout } from "../../../chunks/Layout.js";
import "@dfinity/utils";
import "dompurify";
import { L as LoadingIcon } from "../../../chunks/LoadingIcon.js";
const Page = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  Array.from({ length: 38 }, (_, i) => i + 1);
  onDestroy(() => {
  });
  return `${validate_component(Layout, "Layout").$$render($$result, {}, {}, {
    default: () => {
      return `${`${validate_component(LoadingIcon, "LoadingIcon").$$render($$result, {}, {}, {})}`}`;
    }
  })}`;
});
export {
  Page as default
};
