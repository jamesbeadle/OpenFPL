import { c as create_ssr_component, v as validate_component } from "../../../chunks/ssr.js";
import { L as Layout } from "../../../chunks/Layout.js";
import "../../../chunks/manager-store.js";
import "@dfinity/utils";
import "dompurify";
import { L as LoadingIcon } from "../../../chunks/LoadingIcon.js";
import "@dfinity/auth-client";
import "@dfinity/agent";
const CopyIcon_svelte_svelte_type_style_lang = "";
const profileDetail_svelte_svelte_type_style_lang = "";
const Page = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  return `${validate_component(Layout, "Layout").$$render($$result, {}, {}, {
    default: () => {
      return `${`${validate_component(LoadingIcon, "LoadingIcon").$$render($$result, {}, {}, {})}`}`;
    }
  })}`;
});
export {
  Page as default
};
